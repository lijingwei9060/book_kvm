# 数据结构

- kvm_kpic_state： kvm保存PIC的状态,结构完整描述了一个8259A中断控制器应该具有的所有基本特征，包括寄存器IRR、IMR、ISR等
- kvm_pic: 包含了2片8259A，一片为master，一片为slave，具体来说，pic[0]为master，pic[1]为slave

```C
struct kvm_kpic_state {
	u8 last_irr;	/* edge detection */
	u8 irr;		/* interrupt request register IRR */
	u8 imr;		/* interrupt mask register IMR */
	u8 isr;		/* interrupt service register ISR */
	u8 priority_add;	/* highest irq priority 中断最高优先级 */
	u8 irq_base; // 用于将IRQn转化为VECTORx
	u8 read_reg_select; // 选择要读取的寄存器
	u8 poll;
	u8 special_mask;
	u8 init_state;
	u8 auto_eoi; // 标志auto_eoi模式
	u8 rotate_on_auto_eoi;
	u8 special_fully_nested_mode;
	u8 init4;		/* true if 4 byte init */
	u8 elcr;		/* PIIX edge/trigger selection */
	u8 elcr_mask;
	struct kvm_pic *pics_state; // 指向高级PIC抽象结构
};

struct kvm_pic {
	struct kvm_kpic_state pics[2]; /* 0 is master pic, 1 is slave pic */
	irq_request_func *irq_request; // 模拟PIC向外输出中断的callback
	void *irq_request_opaque;
	int output;		/* intr from master PIC */
	struct kvm_io_device dev; // 这里说明PIC是一个KVM内的IO设备
};
```


## PIC 的管理

1. 创建： qemu : static int kvm_irqchip_create(KVMState *s) =>  kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
2. guest读取： 假设Guest需要从一个外设读取数据，一般流程为vmexit到kvm/qemu，传递相关信息后直接返回Guest，当数据获取完成之后，qemu/kvm向Guest发送中断，通知Guest数据准备就绪。
3. 中断流程：kvm中模拟的中断流程只是设备在qemu中模拟的中断流程的一个子集 qemu：  kvm_set_irq(KVMState *s, int irq, int level) =>  kvm_vm_ioctl(s, s->irq_set_ioctl, &event);先通过pic_set_irq1设置PIC的IRR寄存器的对应bit，然后通过pic_get_irq获取PIC的IRR状态，并通过IRR状态设置模拟PIC的output.通过以上流程，成功将PIC的output设置为了1。还需要将中断注入Guest。在每次准备进入Guest时，KVM查询中断芯片，如果有待处理的中断，则执行中断注入。之前的流程最终设置的pic->output，会在每次切入Guest之前被检查
kvm 创建过程: 
```C
static long kvm_vm_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_CREATE_IRQCHIP:
        ...
            	kvm->vpic = kvm_create_pic(kvm);
        ...
    ...
}

struct kvm_pic *kvm_create_pic(struct kvm *kvm)
{
	struct kvm_pic *s;
	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
	if (!s)
		return NULL;
	s->pics[0].elcr_mask = 0xf8;
	s->pics[1].elcr_mask = 0xde;
	s->irq_request = pic_irq_request;
	s->irq_request_opaque = kvm; 
	s->pics[0].pics_state = s;
	s->pics[1].pics_state = s;

	/*
	 * Initialize PIO device
	 */
	s->dev.read = picdev_read; // 注册了该IO设备的read、write、in_range方法
	s->dev.write = picdev_write;
	s->dev.in_range = picdev_in_range;
	s->dev.private = s;
	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
	return s;
}

/*
 * callback when PIC0 irq status changed
 */
static void pic_irq_request(void *opaque, int level)
{
	struct kvm *kvm = opaque;

	pic_irqchip(kvm)->output = level;
}
```

kvm中pic中断处理流程：

```C
KVM:
static long kvm_vm_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_IRQ_LINE: {
            if (irqchip_in_kernel(kvm)) { // 如果PIC在内核(kvm)中实现
									if (irq_event.irq < 16)
										kvm_pic_set_irq(pic_irqchip(kvm),
																							irq_event.irq,
																					irq_event.level);
        }
    ...
}
    
void kvm_pic_set_irq(void *opaque, int irq, int level)
{
    ...
    	pic_set_irq1(&s->pics[irq >> 3], irq & 7, level); // 设置PIC的IRR寄存器
			 pic_update_irq(s); // 更新pic->output
    ...
}
    
/*
 * set irq level. If an edge is detected, then the IRR is set to 1
 */
static inline void pic_set_irq1(struct kvm_kpic_state *s, int irq, int level)
{
	int mask;
	mask = 1 << irq;
	if (s->elcr & mask)	/* level triggered */
		if (level) { // 将IRR对应bit置1
			s->irr |= mask;
			s->last_irr |= mask;
		} else { // 将IRR对应bit置0
			s->irr &= ~mask;
			s->last_irr &= ~mask;
		}
	else	/* edge triggered */
		if (level) {
			if ((s->last_irr & mask) == 0) // 如果出现了一个上升沿
				s->irr |= mask; // 将IRR对应bit置1
			s->last_irr |= mask;
		} else
			s->last_irr &= ~mask;
}
    
/*
 * raise irq to CPU if necessary. must be called every time the active
 * irq may change
 */
static void pic_update_irq(struct kvm_pic *s)
{
	int irq2, irq;

	irq2 = pic_get_irq(&s->pics[1]);
	if (irq2 >= 0) { // 先检查slave PIC的IRQ情况
		/*
		 * if irq request by slave pic, signal master PIC
		 */
		pic_set_irq1(&s->pics[0], 2, 1);
		pic_set_irq1(&s->pics[0], 2, 0);
	}
	irq = pic_get_irq(&s->pics[0]);
	if (irq >= 0)
		s->irq_request(s->irq_request_opaque, 1); // 调用pic_irq_request使PIC的output为1
	else
		s->irq_request(s->irq_request_opaque, 0);
}
    
/*
 * return the pic wanted interrupt. return -1 if none
 */
static int pic_get_irq(struct kvm_kpic_state *s)
{
	int mask, cur_priority, priority;

	mask = s->irr & ~s->imr; // 过滤掉由IMR屏蔽的中断
	priority = get_priority(s, mask); // 获取过滤后的中断的优先级
	if (priority == 8)
		return -1;
	/*
	 * compute current priority. If special fully nested mode on the
	 * master, the IRQ coming from the slave is not taken into account
	 * for the priority computation.
	 */
	mask = s->isr;
	if (s->special_fully_nested_mode && s == &s->pics_state->pics[0])
		mask &= ~(1 << 2);
	cur_priority = get_priority(s, mask); // 获取当前CPU正在服务的中断的优先级
	if (priority < cur_priority) // 如果新中断的优先级大于正在服务的中断的优先级(数值越小，优先级越高)
		/*
		 * higher priority found: an irq should be generated
		 */
		return (priority + s->priority_add) & 7; // 循环优先级的算法: 某IRQ的优先级 + 最高优先级(动态) = IRQ号码
	else
		return -1;
}
  
```