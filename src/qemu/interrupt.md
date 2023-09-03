
# 概述

中断控制器：pic/ioapic/lapic/i8259

qemu全局变量kvm_kernel_irqchip置为true
kvm将kvm->arch.irqchip_mode 赋值为 KVM_IRQCHIP_KERNEL

kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP)
|--> kvm_pic_init                    /* i8259 初始化 */
|--> kvm_ioapic_init                 /* ioapic 初始化 */
|--> kvm_setup_default_irq_routing   /* 初始化缺省的IRE */

中断路由： 

kvm_init_irq_routing

i8259设备创建流程(pic还是传统的isa设备，中断是边沿触发的，master的i/o port为0x20,0x21 slave的i/o port为0xa0,0xa1)：
machine_run_board_init
    |--> pc_init1
        |--> if (kvm_pic_in_kernel())
            |--> kvm_i8259_init
                |--> isadev = isa_create(bus, name)

ioapic的设备创建流程:
machine_run_board_init
    |--> pc_init1
        |--> if (pcmc->pci_enabled)
            |--> ioapic_init_gsi(gsi_state, "i440fx")
                |--> if kvm_ioapic_in_kernel()
                    |--> dev = qdev_create(NULL, "kvm-ioapic")

PIC由2个i8259进行“级联”，一个为master一个为slave，每个i8259有8个PIN（salve的INT输出线连接到master的IRQ2引脚上,所以实际可用的IRQ数目为15）。目前kvm只为虚拟机创建一个ioapic设备（现在多路服务器可能有多个ioapic设备），ioapic设备提供24个PIN给外部中断使用。在IRQ路由上 0-15号GSI为PIC和IOAPIC共用的，16-23号GSI则都分配给ioapic。


几个概念要理清楚：IRQ号，中断向量和GSI。

- IRQ号是PIC时代引入的概念,由于ISA设备通常是直接连接到到固定的引脚，所以对于IRQ号描述了设备连接到了PIC的哪个引脚上，同IRQ号直接和中断优先级相关,例如IRQ0比IRQ3的中断优先级更高。
- GSI号是ACPI引入的概念，全称是Global System Interrupt，用于为系统中每个中断源指定一个唯一的中断编号。注：ACPI Spec规定PIC的IRQ号必须对应到GSI0-GSI15上。kvm默认支持最大1024个GSI。
- 中断向量是针对逻辑CPU的概念，用来表示中断在IDT表的索引号，每个IRQ（或者GSI）最后都会被定向到某个Vecotor上。对于PIC上的中断，中断向量 = 32(start vector) + IRQ号。在IOAPIC上的中断被分配的中断向量则是由操作系统分配。

PIC主要针对与传统的单核处理器体系结构，在SMP系统上则是通过IOAPIC和每个CPU内部的LAPIC来构成整个中断系统的。

IOAPIC 负责接受中断并将中断格式化化成中断消息，并按照一定规则转发给LAPIC。LAPIC内部有IRR(Interrupt Reguest Register)和ISR(Interrupt Service Register)等2个重要寄存器。系统在处理一个vector的同时缓存着一个相同的vector，vector通过2个256-bit寄存器标志，对应位置位则表示上报了vector请求或者正在处理中。另外LAPIC提供了TPR(Task Priority Register)，PPR(Processor Priority Register)来设置LAPIC的task优先级和CPU的优先级，当IOAPIC转发的终端vector优先级小于LAPIC设置的TPR时，此中断不能打断当前cpu上运行的task；当中断vector的优先级小于LAPIC设置的PPR时此cpu不处理这个中断。操作系统通过动态设置TPR和PPR来实现系统的实时性需求和中断负载均衡。

值得一提的是qemu中为了记录pic和ioapic的中断处理回调函数，定义了一个GSIState类型的结构体：
```C
typedef struct GSIState {
    qemu_irq i8259_irq[ISA_NUM_IRQS];
    qemu_irq ioapic_irq[IOAPIC_NUM_PINS];
} GSIState;
```

在qemu主板初始化逻辑函数pc_init1中会分别分配ioapic和pic的qemu_irq并初始化注册handler。ioapic注册的handler为kvm_pc_gsi_handler函数opaque参数为qdev_get_gpio_in,pic注册的handler为kvm_pic_set_irq。这2个handler是qemu模拟中断的关键入口，后面我们会对其进行分析。

## 用户态和内核态的中断关联

qemu中尽管对中断控制器进行了模拟，但只是搭建了一个空架子，如果高效快速工作起来还需要qemu用户态和kvm内核的数据关联才能实现整个高效的中断框架。

IOAPIC为了实现中断路由(Interrupt Routing)会维护一个中断路由表信息，下面看下kvm内核模块中几个重要的数据结构。

中断路由：用来记录中断路由信息的数据结构。

struct kvm_irq_routing {
    __u32 nr;
    __u32 flags;
    struct kvm_irq_routing_entry entries[0];  /* irq routing entry 数组 */
};
中断路由表：

kvm_irq_routing_table这个数据结构描述了“每个虚拟机的中断路由表”，对应于kvm数据结构的irq_routing成员。chip是个二维数组表示三个中断控制器芯片的每一个管脚（最多24个pin）的GSI，nr_rt_entries表示中断路由表中存放的“中断路由项”的数目，最为关键的struct hlist_head map[0]是一个哈希链表结构体数组，数组以GSI作为索引可以找到同一个irq关联的所有kvm_kernel_irq_routing_entry（中断路由项）。

struct kvm_irq_routing_table {
    int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
    u32 nr_rt_entries;
    /*
        * Array indexed by gsi. Each entry contains list of irq chips
        * the gsi is connected to.
        */
    struct hlist_head map[0];  /* 哈希表数组 */
};
中断路由项：

gsi表示这个中断路由项对应的GSI号，type表示该gsi的类型取值可以是 KVM_IRQ_ROUTING_IRQCHIP, KVM_IRQ_ROUTING_MSI等，set函数指针很重要表示该gsi关联的中断触发方法（不同type的GSI会调用不同的set触发函数），hlist_node则是中断路由表哈希链表的节点，通过link将同一个gsi对应的中断路由项链接到map对应的gsi上。

struct kvm_kernel_irq_routing_entry {
    u32 gsi;
    u32 type;
    int (*set)(struct kvm_
    kernel_irq_routing_entry *e,
        struct kvm *kvm, int irq_source_id, int level,
        bool line_status);
    union {
        struct {
            unsigned irqchip;
            unsigned pin;
        } irqchip;
        struct {
            u32 address_lo;
            u32 address_hi;
            u32 data;
            u32 flags;
            u32 devid;
        } msi;
        struct kvm_s390_adapter_int adapter;
        struct kvm_hv_sint hv_sint;
    };
    struct hlist_node link;
};
中断路由表的设置在qemu中初始化时，通过调用kvm_pc_setup_irq_routing函数来完成。

void kvm_pc_setup_irq_routing(bool pci_enabled)
{
    KVMState *s = kvm_state;
    int i;

    if (kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
        for (i = 0; i < 8; ++i) {
            if (i == 2) {    /* slave的INTR引脚接入到master的2号引脚上 */
                continue;
            }
            kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_MASTER, i);
        }
        for (i = 8; i < 16; ++i) {
            kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_PIC_SLAVE, i - 8);
        }
        if (pci_enabled) {
            for (i = 0; i < 24; ++i) {
                if (i == 0) {
                    kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, 2);
                } else if (i != 2) {
                    kvm_irqchip_add_irq_route(s, i, KVM_IRQCHIP_IOAPIC, i);
                }
            }
        }
        kvm_irqchip_commit_routes(s);
    }
}

## PIC中断处理流程

为了一窥中断处理的具体流程，这里我们选择最简单模拟串口为例进行分析。qemu作为设备模拟器会模拟很多传统的设备，isa-serial就是其中之一。我们看下串口触发中断时候的调用栈：

#0  0x00005555557dd543 in kvm_set_irq (s=0x5555568f4440, irq=4, level=1) at /home/fang/code/qemu/accel/kvm/kvm-all.c:991
#1  0x0000555555881c0f in kvm_pic_set_irq (opaque=0x0, irq=4, level=1) at /home/fang/code/qemu/hw/i386/kvm/i8259.c:114
#2  0x00005555559cb0aa in qemu_set_irq (irq=0x5555577c9dc0, level=1) at hw/core/irq.c:45
#3  0x0000555555881fda in kvm_pc_gsi_handler (opaque=0x555556b61970, n=4, level=1) at /home/fang/code/qemu/hw/i386/kvm/ioapic.c:55
#4  0x00005555559cb0aa in qemu_set_irq (irq=0x555556b63660, level=1) at hw/core/irq.c:45
#5  0x00005555559c06e7 in qemu_irq_raise (irq=0x555556b63660) at /home/fang/code/qemu/include/hw/irq.h:16
#6  0x00005555559c09b3 in serial_update_irq (s=0x555557b77770) at hw/char/serial.c:145
#7  0x00005555559c138c in serial_ioport_write (opaque=0x555557b77770, addr=1, val=2, size=1) at hw/char/serial.c:404
可以看到qemu用户态有个函数kvm_set_irq，这个函数是用户态通知kvm内核态触发一个中断的入口。函数中通过调用 kvm_vm_ioctl注入一个中断，调用号是 KVM_IRQ_LINE（pic类型中断），入参是一个 kvm_irq_level 的数据结构（传入了irq编号和中断的电平信息）。模拟isa串口是个isa设备使用边沿触发，所以注入中断会调用2次这个函数前后2次电平相反。

int kvm_set_irq(KVMState *s, int irq, int level)
{
    struct kvm_irq_level event;
    int ret;

    assert(kvm_async_interrupts_enabled());

    event.level = level;
    event.irq = irq;
    ret = kvm_vm_ioctl(s, s->irq_set_ioctl, &event);
    if (ret < 0) {
        perror("kvm_set_irq");
        abort();
    }

    return (s->irq_set_ioctl == KVM_IRQ_LINE) ? 1 : event.status;
}
这个ioctl在内核的处理对应到下面这段代码，pic类型中断进而会调用到kvm_vm_ioctl_irq_line函数。

kvm_vm_ioctl
{
    ......
#ifdef __KVM_HAVE_IRQ_LINE
    case KVM_IRQ_LINE_STATUS:
    case KVM_IRQ_LINE: {            /* 处理pic上产生的中断 */
        struct kvm_irq_level irq_event;

        r = -EFAULT;
        if (copy_from_user(&irq_event, argp, sizeof(irq_event)))
            goto out;

        r = kvm_vm_ioctl_irq_line(kvm, &irq_event,
                    ioctl == KVM_IRQ_LINE_STATUS);
        if (r)
            goto out;

        r = -EFAULT;
        if (ioctl == KVM_IRQ_LINE_STATUS) {
            if (copy_to_user(argp, &irq_event, sizeof(irq_event)))
                goto out;
        }

        r = 0;
        break;
    }
#endif
#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING      /* 处理ioapic的中断 */
    case KVM_SET_GSI_ROUTING: {
        struct kvm_irq_routing routing;
        struct kvm_irq_routing __user *urouting;
        struct kvm_irq_routing_entry *entries = NULL;

        r = -EFAULT;
        if (copy_from_user(&routing, argp, sizeof(routing)))
            goto out;
        r = -EINVAL;
        if (!kvm_arch_can_set_irq_routing(kvm))
            goto out;
        if (routing.nr > KVM_MAX_IRQ_ROUTES)
            goto out;
        if (routing.flags)
            goto out;
        if (routing.nr) {
            r = -ENOMEM;
            entries = vmalloc(routing.nr * sizeof(*entries));
            if (!entries)
                goto out;
            r = -EFAULT;
            urouting = argp;
            if (copy_from_user(entries, urouting->entries,
                    routing.nr * sizeof(*entries)))
                goto out_free_irq_routing;
        }
        r = kvm_set_irq_routing(kvm, entries, routing.nr,
                    routing.flags);
out_free_irq_routing:
        vfree(entries);
        break;
    }
    ......
}
kvm_vm_ioctl_irq_line函数中会进一步调用内核态的kvm_set_irq函数（用户态用同名函数额），这个函数是整个中断处理的入口：

int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
            bool line_status)
{
    if (!irqchip_in_kernel(kvm))
        return -ENXIO;

    irq_event->status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
                    irq_event->irq, irq_event->level,
                    line_status);
    return 0;
}
kvm_set_irq函数的入参有5个，kvm代表某个特性的的虚拟机，irq_source_id可以是KVM_USERSPACE_IRQ_SOURCE_ID或者KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID(这个是irqfd这个我们这里不讨论)，irq是传入的设备irq号，对于串口来说第一个port的irq=4而且irq=gsi，level代表电平。kvm_irq_map函数会获取改gsi索引上注册的中断路由项(kvm_kernel_irq_routing_entry)，while循环中会挨个调用每个中断路由项上的set方法触发中,在guest中会忽略没有实现的芯片类型发送的中断消息。

对于PIC而言，set函数对应于kvm_set_pic_irq函数，对于IOAPIC而言set函数对应于kvm_set_ioapic_irq（不同的chip不一样额）。对于串口而言，我们会进一步调用kvm_pic_set_irq来处理中断。

/*
* Return value:
*  < 0   Interrupt was ignored (masked or not delivered for other reasons)
*  = 0   Interrupt was coalesced (previous irq is still pending)
*  > 0   Number of CPUs interrupt was delivered to
*/
int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
        bool line_status)
{
    struct kvm_kernel_irq_routing_entry irq_set[KVM_NR_IRQCHIPS];
    int ret = -1, i, idx;

    trace_kvm_set_irq(irq, level, irq_source_id);

    /* Not possible to detect if the guest uses the PIC or the
    * IOAPIC.  So set the bit in both. The guest will ignore
    * writes to the unused one.
    */
    idx = srcu_read_lock(&kvm->irq_srcu);
    i = kvm_irq_map_gsi(kvm, irq_set, irq);
    srcu_read_unlock(&kvm->irq_srcu, idx);

    /* 依次调用同一个gsi上的所有芯片的set方法 */
    while (i--) {
        int r;
        r = irq_set[i].set(&irq_set[i], kvm, irq_source_id, level,
                line_status);
        if (r < 0)
            continue;

        ret = r + ((ret < 0) ? 0 : ret);
    }

    return ret;
}

/* 查询出此gsi号上对应的所有的“中断路由项” */
int kvm_irq_map_gsi(struct kvm *kvm,
            struct kvm_kernel_irq_routing_entry *entries, int gsi)
{
    struct kvm_irq_routing_table *irq_rt;
    struct kvm_kernel_irq_routing_entry *e;
    int n = 0;

    irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
                    lockdep_is_held(&kvm->irq_lock));
    if (irq_rt && gsi < irq_rt->nr_rt_entries) {
        hlist_for_each_entry(e, &irq_rt->map[gsi], link) {  /* 遍历此gsi对应的中断路由项 */
            entries[n] = *e;
            ++n;
        }
    }

    return n;
}
kvm_pic_set_irq 函数中，根据传入的irq编号check下原先的irq_state将本次的level与上次的irq_state进行逻辑“异或”判断是否发生电平跳变从而进行边沿检测（pic_set_irq1）。如果是的话设置IRR对应的bit，然后调用和pic_update_irq更新pic相关的寄存器并唤醒vcpu注入中断。

int kvm_pic_set_irq(struct kvm_pic *s, int irq, int irq_source_id, int level)
{
    int ret, irq_level;

    BUG_ON(irq < 0 || irq >= PIC_NUM_PINS);

    pic_lock(s);
    /* irq_level = 1表示该irq引脚有电平跳变，出发中断 */
    irq_level = __kvm_irq_line_state(&s->irq_states[irq],
                    irq_source_id, level);
    /* 一个pic最多8个irq */
    ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, irq_level);
    pic_update_irq(s);
    trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
                s->pics[irq >> 3].imr, ret == 0);
    pic_unlock(s);

    return ret;
}
最后的最后，pic_unlock函数中在如果wakeup为true（又中断产生时）的时候会遍历每个vcpu，在满足条件的情况下调用kvm_make_request为vcpu注入中断，然后kick每个vcpu。

static void pic_unlock(struct kvm_pic *s)
    __releases(&s->lock)
{
    bool wakeup = s->wakeup_needed;
    struct kvm_vcpu *vcpu;
    int i;

    s->wakeup_needed = false;

    spin_unlock(&s->lock);

    if (wakeup) {       /* wakeup在pic_update_irq中被更新 */
        kvm_for_each_vcpu(i, vcpu, s->kvm) {
            if (kvm_apic_accept_pic_intr(vcpu)) {
                /* 中断注入会在kvm_enter_guest时候执行 */
                kvm_make_request(KVM_REQ_EVENT, vcpu);
                kvm_vcpu_kick(vcpu);
                return;
            }
        }
    }
}