# 




IO apic上的寄存器： 

1. id/rw/
2. version/ro
3. arbitration version/ro
4. redirection table/rw/位于0x10-0x3F 地址偏移的地方，存放着24个64bit的寄存器，每个对应IOAPIC的24个管脚之一，这24个寄存器统称为Redirection Table，每个寄存器都是一个entry。该重定向表会在系统初始化时由内核设置，在系统启动后亦可动态修改该表。

## 数据结构
- kvm_lapic: 每个vcpu都有，该结构主要由3部分信息形成：即将作为IO设备注册到Guest的设备相关信息；一个定时器；Lapic的apic-page信息
- kvm_ioapic： 每个kvm都有，看做3部分信息：即将作为IO设备注册到Guest的设备信息；IOAPIC的基础，如用于标记IOAPIC身份的APIC ID，用于选择APIC-page中寄存器的寄存器IOREGSEL；重定向表
```c
struct kvm_lapic {
	unsigned long base_address; // LAPIC的基地址
	struct kvm_io_device dev; // 准备将LAPIC注册为IO设备
	struct { // 定义一个基于HRTIMER的定时器
		atomic_t pending;
		s64 period;	/* unit: ns */
		u32 divide_count;
		ktime_t last_update;
		struct hrtimer dev;
	} timer;
	struct kvm_vcpu *vcpu; // 所属vcpu
	struct page *regs_page; // lapic所有的寄存器都在apic-page上存放。
	void *regs;
};

struct kvm_ioapic {
	u64 base_address; // IOAPIC的基地址
	u32 ioregsel; // 用于选择APIC-page中的寄存器
	u32 id; // IOAPIC的ID
	u32 irr; // IRR
	u32 pad; // 是什么？
	union ioapic_redir_entry { // 重定向表
		u64 bits;
		struct {
			u8 vector;
			u8 delivery_mode:3;
			u8 dest_mode:1;
			u8 delivery_status:1;
			u8 polarity:1;
			u8 remote_irr:1;
			u8 trig_mode:1;
			u8 mask:1;
			u8 reserve:7;
			u8 reserved[4];
			u8 dest_id;
		} fields;
	} redirtbl[IOAPIC_NUM_PINS];
	struct kvm_io_device dev; // 准备注册为Guest的IO设备
	struct kvm *kvm;
};
```

## 创建过程

### ioapic
io apic kvm: ioapic_mmio_read和ioapic_mmio_write用于Guest对IOAPIC进行配置，具体到达方式为MMIO Exit.

```C
int kvm_ioapic_init(struct kvm *kvm)
{
	struct kvm_ioapic *ioapic;
	int i;

	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
	if (!ioapic)
		return -ENOMEM;
	kvm->vioapic = ioapic; // 
	for (i = 0; i < IOAPIC_NUM_PINS; i++) // 24次循环
		ioapic->redirtbl[i].fields.mask = 1; // 暂时屏蔽所有外部中断
	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS; // 0xFEC0_0000
	ioapic->dev.read = ioapic_mmio_read; // vmexit后的mmio读 
	ioapic->dev.write = ioapic_mmio_write; // vmexit后的mmio写
	ioapic->dev.in_range = ioapic_in_range; // vmexit后确定是否在该设备范围内
	ioapic->dev.private = ioapic;
	ioapic->kvm = kvm;
	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev); // 注册为MMIO设备，注册到KVM的MMIO总线上
	return 0;
}
```

### lapic

LAPIC每个vcpu都应该有一个，所以KVM将创建虚拟LAPIC的工作放在了创建vcpu时，即当QEMU发出IOCTL(KVM_CREATE_VCPU)，KVM在创建vcpu时，检测中断芯片(PIC/IOAPIC)是否在内核中，如果在内核中，就调用kvm_create_lapic()创建虚拟LAPIC。

```C
int kvm_create_lapic(struct kvm_vcpu *vcpu)
{
	struct kvm_lapic *apic;
  ...
	apic = kzalloc(sizeof(*apic), GFP_KERNEL); // 分配kvm_lapic结构
  ...
	vcpu->apic = apic; 

	apic->regs_page = alloc_page(GFP_KERNEL); // 为apic-page分配空间
  ...
	apic->regs = page_address(apic->regs_page);
	memset(apic->regs, 0, PAGE_SIZE);
	apic->vcpu = vcpu;// 确定属于哪个vcpu

  // 初始化一个计时器
	hrtimer_init(&apic->timer.dev, CLOCK_MONOTONIC, HRTIMER_MODE_ABS); 
	apic->timer.dev.function = apic_timer_fn;
	apic->base_address = APIC_DEFAULT_PHYS_BASE; // 0xFEE0_0000
	vcpu->apic_base = APIC_DEFAULT_PHYS_BASE; // 0xFEE0_0000

	lapic_reset(vcpu); // 对apic-page中的寄存器，计时器的分频等数据进行初始化
	apic->dev.read = apic_mmio_read; // MMIO设备，但未注册到kvm->mmio_bus上
	apic->dev.write = apic_mmio_write;
	apic->dev.in_range = apic_mmio_range;
	apic->dev.private = apic;

	return 0;
nomem:
	kvm_free_apic(apic);
	return -ENOMEM;
}
```

## 中断

APIC既可以接收外部中断，也可以处理核间中断，而外部中断和核间中断的虚拟化流程是不同的，因此这里分为两个部分。

### 外部中断
假设Guest需要从一个外设读取数据，一般流程为vmexit到kvm/qemu，传递相关信息后直接返回Guest，当数据获取完成之后，qemu/kvm向Guest发送外部中断，通知Guest数据准备就绪。那么qemu/kvm如何通过APIC向Guest发送中断呢？

```C
QEMU:
int kvm_init(void)
{
    ...
         s = g_malloc0(sizeof(KVMState));
         s->irq_set_ioctl = KVM_IRQ_LINE;
    ...
}
int kvm_set_irq(KVMState *s, int irq, int level)
{
    ...
        ret = kvm_vm_ioctl(s, s->irq_set_ioctl, &event);
    ...
}
```

QEMU的动作与向PIC发送中断请求时一样，都是调用kvm_set_irq()向KVM发送中断请求。

```C
KVM:
static long kvm_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_IRQ_LINE: {
            if (irqchip_in_kernel(kvm)) { // 如果PIC在内核(kvm)中实现
                if (irq_event.irq < 16)
                    kvm_pic_set_irq(pic_irqchip(kvm), irq_event.irq, irq_event.level);// 如果IRQn的n小于16，则调用PIC和IOAPIC产生中断
                kvm_ioapic_set_irq(kvm->vioapic, irq_event.irq, irq_event.level);// 如果IRQn的n不小于16，则调用IOAPIC产生中断		                        
        }
    ...
}

/* 根据输入level设置ioapic->irr, 并根据重定向表的对应entry决定是否为irq生成中断(ioapic_service) */
void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
{
	u32 old_irr = ioapic->irr;
	u32 mask = 1 << irq;
	union ioapic_redir_entry entry;

	if (irq >= 0 && irq < IOAPIC_NUM_PINS) { // irq在0-23之间
		entry = ioapic->redirtbl[irq]; // irq对应的entry
		level ^= entry.fields.polarity; // polarity: 0-高电平有效 1-低电平有效
		if (!level) // 这里的level已经表示输入有效性而非电平高低 1-有效，0-无效
			ioapic->irr &= ~mask; // 如果输入无效，则clear掉irq对应的IRR
		else { // 如果输入有效
			ioapic->irr |= mask; // set irq对应的IRR
			if ((!entry.fields.trig_mode && old_irr != ioapic->irr) // trigger mode为边沿触发 且 IRR出现了沿
			    || !entry.fields.remote_irr) // 或 远方的LAPIC没有正在处理中断
				ioapic_service(ioapic, irq); // 就对irq进行service
		}
	}
}
    
static void ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
{
	union ioapic_redir_entry *pent;

	pent = &ioapic->redirtbl[idx];

	if (!pent->fields.mask) { // 如果irq没有被ioapic屏蔽
		ioapic_deliver(ioapic, idx); // 决定是否向特定LAPIC发送中断
		if (pent->fields.trig_mode == IOAPIC_LEVEL_TRIG) // 电平触发时，还需要将remote_irr置1，在收到LAPIC的EOI信息后将remote_irr置0
			pent->fields.remote_irr = 1;
	}
	if (!pent->fields.trig_mode) // 沿触发时，ioapic_service为IRR产生一个下降沿
		ioapic->irr &= ~(1 << idx);
}
    
static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
{
    ...
    /* 获取irq对应的目标vcpu mask */
    deliver_bitmask = ioapic_get_delivery_bitmask(ioapic, dest, dest_mode);
    ...
    switch (delivery_mode) { // 根据目标vcpu mask和delivery mode确定是否要向Guest注入中断
            ...
           ioapic_inj_irq(ioapic, target, vector, trig_mode, delivery_mode);
    }
    
}

static void ioapic_inj_irq(struct kvm_ioapic *ioapic,  struct kvm_lapic *target, u8 vector, u8 trig_mode, u8 delivery_mode)
{
    ...
    kvm_apic_set_irq(target, vector, trig_mode);
}
int kvm_apic_set_irq(struct kvm_lapic *apic, u8 vec, u8 trig)
{
	if (!apic_test_and_set_irr(vec, apic)) { // 只有irq对应的irr某bit本来为0时，才可以产生新的中断
		/* a new pending irq is set in IRR */
		if (trig) // 电平触发模式
			apic_set_vector(vec, apic->regs + APIC_TMR); // 设置apic-page中的Trigger Mode Register为1
		else // 沿触发模式
			apic_clear_vector(vec, apic->regs + APIC_TMR); // 设置apic-page中的Trigger Mode Register为0
		kvm_vcpu_kick(apic->vcpu); // 踢醒vcpu ×××这里就在vmentry时查中断即可×××
		return 1;
	}
	return 0;
}
```

可以看到，一旦QEMU发送了IOCTL(KVM_IRQ_LINE)，KVM就会通过以下一系列的调用,最终通过kvm_apic_set_irq()向Guest发起中断请求.

```shell
kvm_ioapic_set_irq()
=> ioapic_service()
   => ioapic_deliver()
      => ioapic_inj_irq()
         => kvm_apic_set_irq()
            |- 设置apic-page的IRR
            |- 设置apic-page的TMR
            |- 踢醒(出)vcpu

vmentry时触发中断检测
```

### 核间中断

物理机上，CPU-0的LAPIC-x向CPU-1的LAPIC-y发送核间中断时，会将中断向量和目标的LAPIC标识符存储在自己的LAPIC-x的ICR(中断命令寄存器)中，然后该中断会顺着总线到达目标CPU。

虚拟机上，当vcpu-0的lapic-x向vcpu-1的lapic-y发送核间中断时，会首先访问apic-page的ICR寄存器(因为要将中断向量信息和目标lapic信息都放在ICR中)，在没有硬件支持的中断虚拟化时，访问(write)apic-page会导致mmio vmexit，在KVM中将所有相关信息放在ICR中，在之后的vcpu-1的vmentry时会检查中断，进而注入IPI中断。

这里涉及到IO(MMIO) vmexit的流程，关于该流程暂时不做trace，只需要知道，在没有硬件辅助中断虚拟化的情况下，对apic-page的读写会vmexit最终调用apic_mmio_write()/apic_mmio_read().

```C
static void apic_mmio_write(struct kvm_io_device *this,
			    gpa_t address, int len, const void *data)
{
    ...
       	switch (offset) {
                ...
                    case APIC_ICR:
                        		/* No delay here, so we always clear the pending bit , 因为ICR的bit12是Delivery Status，0-该LAPIC已经完成了之前的任何IPI的发送，1-有之前的IPI正在pending. 由于我们的LAPIC模拟发送IPI中，没有任何延迟，因此直接clear掉ICR的bit12. */
		                        apic_set_reg(apic, APIC_ICR, val & ~(1 << 12));
                           apic_send_ipi(apic);
		                        break;
        }
}

static void apic_send_ipi(struct kvm_lapic *apic)
{
    u32 icr_low = apic_get_reg(apic, APIC_ICR); // ICR低32bit
    u32 icr_high = apic_get_reg(apic, APIC_ICR2); // ICR高32bit

    unsigned int dest = GET_APIC_DEST_FIELD(icr_high); // Destination Field
    unsigned int short_hand = icr_low & APIC_SHORT_MASK; // Destination Shorthand
    unsigned int trig_mode = icr_low & APIC_INT_LEVELTRIG; // Trigger Mode
    unsigned int level = icr_low & APIC_INT_ASSERT; // Level
    unsigned int dest_mode = icr_low & APIC_DEST_MASK; // Destination Mode
    unsigned int delivery_mode = icr_low & APIC_MODE_MASK; // Delivery Mode
    unsigned int vector = icr_low & APIC_VECTOR_MASK; // Vector
    
    for (i = 0; i < KVM_MAX_VCPUS; i++) { // 针对所有vcpu
        vcpu = apic->vcpu->kvm->vcpus[i];
        if (!vcpu)
            continue;

        if (vcpu->apic &&
            apic_match_dest(vcpu, apic, short_hand, dest, dest_mode)) { // 如果vcpu有LAPIC且vcpu是该中断的目标
            if (delivery_mode == APIC_DM_LOWEST) // 如果Delivery Mode为Lowest Priority，则将vcpu对应的Lowest Priority Register map中的对应bit设置为1.(因为这种模式下，最终只有一个vcpu会收到本次中断，所以需要最终查看lpr_map的内容决定. )
                set_bit(vcpu->vcpu_id, &lpr_map);
            else // 如果Delivery Mode不为Lowest Priority
                __apic_accept_irq(vcpu->apic, delivery_mode,
                                  vector, level, trig_mode); // 使用LAPIC发送中断
        }
    }
}

/* 确认传入参数vcpu是否是LAPIC发送中断的目标 返回1表示是，返回0表示不是 */
static int apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
			   int short_hand, int dest, int dest_mode)
{
    int result = 0;
    struct kvm_lapic *target = vcpu->apic;
    ...

    ASSERT(!target);
    switch (short_hand) {
        case APIC_DEST_NOSHORT: // short_hand为00 目标CPU通过Destination指定
            if (dest_mode == 0) {
                /* Physical mode. 如果为全局广播或目标即自身 表示当前vcpu是目标vcpu */
                if ((dest == 0xFF) || (dest == kvm_apic_id(target)))
                    result = 1;
            } else
                /* Logical mode. Destination不再是物理的APIC ID而是逻辑上代表一组CPU，SDM将此时
                 * 的Destination称为Message Destination Address (MDA)。 这里为了确认当前vcpu是否
                 * 在MDA中.如果在则返回1.
                 */
                result = kvm_apic_match_logical_addr(target, dest);
            break;
        case APIC_DEST_SELF:
            if (target == source)
                result = 1;
            break;
        case APIC_DEST_ALLINC:
            result = 1;
            break;
        case APIC_DEST_ALLBUT:
            if (target != source)
                result = 1;
            break;
        default:
            printk(KERN_WARNING "Bad dest shorthand value %x\n",
                   short_hand);
            break;
    }

    return result;
}

/*
 * Add a pending IRQ into lapic.
 * Return 1 if successfully added and 0 if discarded.
 */
static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
			     int vector, int level, int trig_mode)
{
    int result = 0;

    switch (delivery_mode) {
        case APIC_DM_FIXED:
        case APIC_DM_LOWEST:

            /* 重复设置IRR检测 */
            if (apic_test_and_set_irr(vector, apic) && trig_mode) { // 如果IRR为0，则设置为1
                apic_debug("level trig mode repeatedly for vector %d",
                           vector);
                break;
            }

            if (trig_mode) { // 根据传入的trig_mode设置apic-page中的TMR.
                apic_debug("level trig mode for vector %d", vector);
                apic_set_vector(vector, apic->regs + APIC_TMR);
            } else
                apic_clear_vector(vector, apic->regs + APIC_TMR);

            kvm_vcpu_kick(apic->vcpu); // 踢醒vcpu ×××这里就在vmentry时查中断即可×××

            result = 1;
            break;

        case APIC_DM_REMRD:
            printk(KERN_DEBUG "Ignoring delivery mode 3\n");
            break;

        case APIC_DM_SMI:
            printk(KERN_DEBUG "Ignoring guest SMI\n");
            break;
        case APIC_DM_NMI:
            printk(KERN_DEBUG "Ignoring guest NMI\n");
            break;

        case APIC_DM_INIT:
            printk(KERN_DEBUG "Ignoring guest INIT\n");
            break;

        case APIC_DM_STARTUP:
            printk(KERN_DEBUG "Ignoring guest STARTUP\n");
            break;

        default:
            printk(KERN_ERR "TODO: unsupported delivery mode %x\n",
                   delivery_mode);
            break;
    }
    return result;
}
```

可以看到，核间中断由Guest通过写apic-page中的ICR(中断控制寄存器)发起，vmexit到KVM，最终调用apic_mmio_write().

```shell
apic_mmio_write()
=> apic_send_ipi()
   => __apic_accept_irq()
   |- 设置apic-page的IRR
   |- 设置apic-page的TMR
   |- 踢醒(出)vCPU
vmentry时触发中断检测
```




LAPIC收到中断：

kvm_apic_set_irq