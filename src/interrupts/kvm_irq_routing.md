# 概念
KVM中有了APIC和PIC的实现之后，出现一个问题，一个来自外部的中断到底要走PIC还是APIC呢？

早期KVM的策略是，如果irq小于16，则APIC和PIC都走，即这两者的中断设置函数都调用。如果大于等于16，则只走APIC. Guest支持哪个中断芯片，就和哪个中断芯片进行交互。代码如下：
```c
KVM:
static long kvm_vm_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_IRQ_LINE: {
            if (irqchip_in_kernel(kvm)) { // 如果PIC在内核(kvm)中实现
									if (irq_event.irq < 16)
										kvm_pic_set_irq(pic_irqchip(kvm), // 如果IRQn的n小于16，则调用PIC和IOAPIC产生中断
																							irq_event.irq,
																					irq_event.level);
               kvm_ioapic_set_irq(kvm->vioapic, // 如果IRQn的n不小于16，则调用IOAPIC产生中断
					                           irq_event.irq,
					                        irq_event.level);
        }
    ...
}
```

出于代码风格和接口一致原则，KVM在之后的更新中设计了IRQ routing方案。

KVM第一次加入用户定义的中断映射，包括irq，对应的中断芯片、中断函数
```text
399ec807ddc38ecccf8c06dbde04531cbdc63e11

KVM: Userspace controlled irq routing

Currently KVM has a static routing from GSI numbers to interrupts (namely,
0-15 are mapped 1:1 to both PIC and IOAPIC, and 16:23 are mapped 1:1 to
the IOAPIC). This is insufficient for several reasons:

HPET requires non 1:1 mapping for the timer interrupt
MSIs need a new method to assign interrupt numbers and dispatch them
ACPI APIC mode needs to be able to reassign the PCI LINK interrupts to the
ioapics
This patch implements an interrupt routing table (as a linked list, but this
can be easily changed) and a userspace interface to replace the table. The
routing table is initialized according to the current hardwired mapping.

Signed-off-by: Avi Kivity avi@redhat.com
```

## 数据结构

kvm内核中： kvm_kernel_irq_routing_entry： 该patch引入了一个结构用于表示KVM中的中断路由，包含： 中断号及其对应的中断生成函数set；该中断号对应的中断芯片类型及对应管脚
qemu中： kvm_irq_routing_entry： 用于表示用户空间传入的中断路由信息的结构,用户空间的中断路由信息看起来更加简单，包含了一些中断类型、标志。最终中断怎样路由，由内核端决定。

```C
struct kvm_kernel_irq_routing_entry {
	u32 gsi;
	void (*set)(struct kvm_kernel_irq_routing_entry *e,
		    struct kvm *kvm, int level); // 生成中断的函数指针
	union {
		struct {
			unsigned irqchip; // 中断芯片的预编号
			unsigned pin; // 类似IRQn
		} irqchip;
	};
	struct list_head link; // 链接下一个kvm_kernel_irq_routing_entry结构
};

struct kvm_irq_routing_entry {
	__u32 gsi;
	__u32 type;
	__u32 flags;
	__u32 pad;
	union {
		struct kvm_irq_routing_irqchip irqchip; // 包含irqchip和pin两个field
		__u32 pad[8];
	} u;
};
```

## 默认中断路由

该patch中定义了一个默认中断路由，在QEMU创建中断芯片(IOCTL(KVM_CREATE_IRQCHIP))时创建。
```C
KVM:
static long kvm_vm_ioctl(struct file *filp,  unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_CREATE_IRQCHIP: {
            ...
                r = kvm_setup_default_irq_routing(kvm);
            ...
        }
    ...
}

int kvm_setup_default_irq_routing(struct kvm *kvm)
{
	return kvm_set_irq_routing(kvm, default_routing, ARRAY_SIZE(default_routing), 0);
}

int kvm_set_irq_routing(struct kvm *kvm,
			const struct kvm_irq_routing_entry *ue, // default_routing
			unsigned nr, // routing中entry的数量
			unsigned flags)
{
    ...
        for (i = 0; i < nr; ++i) {
            e = kzalloc(sizeof(*e), GFP_KERNEL); // 为内核中断路由结构
            ...
                r = setup_routing_entry(e, ue);
            ...
                list_add(&e->link, &irq_list); 
        }
    ...
        list_splice(&irq_list, &kvm->irq_routing); // 将所有kvm_irq_routing_entry链成链表，维护在kvm->irq_routing中
}
```
也就是说，在用户空间向KVM申请创建内核端的中断芯片时，就会建立一个默认的中断路由表。代码路径为：

```shell
kvm_setup_default_irq_routing()
=> kvm_set_irq_routing(default_routing)
   => setup_routing_entry(e,default_routing)
```

路由表由路由Entry构成，内核将irq0-irq15既给了PIC，也给了IOAPIC，如果是32bit架构，那么irq16-irq24专属于IOAPIC，如果是64bit架构，那么irq16-irq47专属于IOAPIC。

中断路由Entry的细节方面，对于IOAPIC entry，gsi == irq == pin，类型为KVM_IRQ_ROUTING_IRQCHIP，中断芯片为KVM_IRQCHIP_IOAPIC。对于PIC entry，gsi == irq，可以通过irq选择PIC的master或slave，pin == irq % 8。更加具体的默认中断路由代码实现如下。
```C
/* KVM中的默认中断路由 */
static const struct kvm_irq_routing_entry default_routing[] = {
	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
#ifdef CONFIG_IA64
	ROUTING_ENTRY1(24), ROUTING_ENTRY1(25),
	ROUTING_ENTRY1(26), ROUTING_ENTRY1(27),
	ROUTING_ENTRY1(28), ROUTING_ENTRY1(29),
	ROUTING_ENTRY1(30), ROUTING_ENTRY1(31),
	ROUTING_ENTRY1(32), ROUTING_ENTRY1(33),
	ROUTING_ENTRY1(34), ROUTING_ENTRY1(35),
	ROUTING_ENTRY1(36), ROUTING_ENTRY1(37),
	ROUTING_ENTRY1(38), ROUTING_ENTRY1(39),
	ROUTING_ENTRY1(40), ROUTING_ENTRY1(41),
	ROUTING_ENTRY1(42), ROUTING_ENTRY1(43),
	ROUTING_ENTRY1(44), ROUTING_ENTRY1(45),
	ROUTING_ENTRY1(46), ROUTING_ENTRY1(47),
#endif
};

// IOAPIC entry定义 gsi == irq == pin
#define IOAPIC_ROUTING_ENTRY(irq) \
	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
	  .u.irqchip.irqchip = KVM_IRQCHIP_IOAPIC, .u.irqchip.pin = (irq) }
#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)

// PIC entry定义 gsi == irq  irq % 8 == pin
#define SELECT_PIC(irq) \
	((irq) < 8 ? KVM_IRQCHIP_PIC_MASTER : KVM_IRQCHIP_PIC_SLAVE)
#  define PIC_ROUTING_ENTRY(irq) \
	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
	  .u.irqchip.irqchip = SELECT_PIC(irq), .u.irqchip.pin = (irq) % 8 }
#  define ROUTING_ENTRY2(irq) \
	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
```

接下来看看，在拥有了一个确认的中断路由时，setup_routing_entry()具体如何操作。

```C
int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
			const struct kvm_irq_routing_entry *ue)
{
    int r = -EINVAL;
    int delta;

    e->gsi = ue->gsi; // global system interrupt 号码直接交换
    switch (ue->type) {
        case KVM_IRQ_ROUTING_IRQCHIP: // 用户传入的entry类型是中断芯片
            delta = 0;
            switch (ue->u.irqchip.irqchip) {
                case KVM_IRQCHIP_PIC_MASTER: // PIC MASTER
                    e->set = kvm_set_pic_irq;--------------------|
                    break;                                       |
                case KVM_IRQCHIP_PIC_SLAVE: // PIC SLAVE         |
                    e->set = kvm_set_pic_irq;--------------------|--具体中断芯片上的中断生成函数
                    delta = 8;                                   |
                    break;                                       |
                case KVM_IRQCHIP_IOAPIC: // IOAPIC               |
                    e->set = kvm_set_ioapic_irq;-----------------|
                    break;
                default:
                    goto out;
            }
            e->irqchip.irqchip = ue->u.irqchip.irqchip; // 直接赋值
            e->irqchip.pin = ue->u.irqchip.pin + delta; // 在用户传入的基础上加上一个delta，实现从Master/Slave PIC的选择
            break;
        default:
            goto out;
    }
    r = 0;
    out:
    return r;
}
setup_routing_entry()：
```
将用户传入的gsi直接赋值给内核中断路由entry的gsi
根据用户传入的中断路由entry的中断芯片类型为entry设备不同的set函数
根据中断芯片类型为内核中断路由entry的pin设置正确的值

## 用户自定义中断路由

当然，该patch也为用户空间提供了传入其自定义中断路由表的接口，即IOCTL(KVM_SET_GSI_ROUTING).
```C
KVM:
static long kvm_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
{
    ...
        case KVM_SET_GSI_ROUTING: {
            ...
                r = kvm_set_irq_routing(kvm, entries, routing.nr, routing.flags);
            ...
        }
    ...
}
```
可以看到这里同样调用了kvm_set_irq_routing()，不过与建立默认中断路由表（default_routing）不同，这一次传入的中断路由表是由用户空间定义的，而其它流程，则与建立默认中断路由一模一样。