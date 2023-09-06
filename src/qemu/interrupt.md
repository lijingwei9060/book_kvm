
# 概述

- 中断是处理器用于异步处理外围设备请求的一种机制；
- 外设通过硬件管脚连接在中断控制器上，并通过电信号向中断控制器发送请求；
- 中断控制器将外设的中断请求路由到CPU上；

CPU（以ARM为例）进行模式切换（切换到IRQ/FIQ），保存Context后，根据外设的中断号去查找系统中已经注册好的Handler进行处理，处理完成后再将Context进行恢复，接着之前打断的执行流继续move on；
中断的作用不局限于外设的处理，系统的调度，SMP核间交互等，都离不开中断；

中断虚拟化，将从中断信号产生到路由到vCPU的角度来展开，包含以下三种情况：

1. 物理设备产生中断信号，路由到vCPU；
2. 虚拟外设产生中断信号，路由到vCPU；
3. Guest OS中CPU之间产生中断信号（IPI中断）；

中断控制器：pic/ioapic/lapic/i8259

qemu全局变量kvm_kernel_irqchip置为true
kvm将kvm->arch.irqchip_mode 赋值为 KVM_IRQCHIP_KERNEL

kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP)
|--> kvm_pic_init                    /* i8259 初始化 */
|--> kvm_ioapic_init                 /* ioapic 初始化 */
|--> kvm_setup_default_irq_routing   /* 初始化缺省的IRE */




BIOS启动时发现中断控制器，把收集到的中断控制器的信息放在ACPI表中，操作系统起来后就知道有那些中断控制器，中断控制器和CPU/外设之间连接关系是怎么样的。

中断控制器有PIC/APIC(IOAPIC和LAPCI)
- CPU通过IO地址空间访问PIC，PIC芯片线的个数有限，导致中断大量共享
- 后来就有了高级的PIC，也就是APIC，APIC分别为全局一个IOAPIC，每个CPU一个LAPCI。
- IOAPIC映射到内存中，所有CPU可以访问它，给它读写信息。
- 每个CPU有一个LAPIC，只是LAPIC的编号不相同，CPU只能读写自己的LAPIC，LAPIC对应的物理地址在寄存器IA32_APIC_BASE MSR中，虽然所有CPU的IA32_APIC_BASE MSR地址相同，但CPU访问这个地址时并不会把这个地址传到地址总线上，CPU内部就能满足这个地址访问。
- 由于CPU的核心越来越多，APIC的编号位数不够用了，出了升级版的xAPIC和x2APIC，xAPIC用memory mapping方式访问，x2APIC用读写MSR寄存器的方式访问。


产生中断的设备： 简单把中断分了LAPIC内部中断/IPI中断/外设中断。

- LAPIC内部中断，如local timer，就在CPU内产生的，直接就打断CPU执行。
- IPI中断是不同CPU间中断，本CPU把中断目的CPU的LAPIC编号写到自己的LAPIC中，然后写自己LAPIC的ICR，通过APIC BUS或者系统总线就把中断送到目的CPU的LAPIC，目的CPU的LAPIC再打断自己CPU的执行。
- 外设中断先到了IOAPIC，它根据Redirection Table Entry把中断路由到不同CPU的LAPIC，可以静态配置或者动态调整，它根据所有CPU的TPR选择优先级最低的CPU。外设还有一种方式就是用MSI方式触发中断，直接写到CPU的LAPIC，跳过了IOAPIC。驱动给外设的PCI配置空间写MSI的信息，外设有Message Address Register和Message Data Register，写这两个寄存器就能把中断投递到LAPIC中。


中断投递：
- IDTR寄存器挺： 前半8bytes部分存“IDT开头地址”，后半部分2bytes存“IDT有多长”，asm(LIDT)指令修改cpu寄存器IDTR的值，asm(SIDT)指令读取cpu寄存器IDTR的值。 每个CPU都有IDTR寄存器，但是这些CPU的IDTR都指向同一个地址
- IDT表(Interrupt Description Table): 4KB页面 = 256个vector号 * 16bytes，操作系统中维护一个IDT表，操作系统初始化时会填充这个表，中断来了，CPU读中断控制器就知道是哪个vector了，vector就是IDT表中一个index，IDT表一个entry中存储了一个segment selector， 这个segment selector就是GDT表一个entry，这个entry中存放了中断处理程序的地址，CPU跳到这个地址开始执行指令就可以处理中断，不过在开始处理中断例程之前，CPU先得保存自己当前执行的context，否则它处理完中断返不回原来正在执行的地方，这些context相关的东西就保存在内核处理中断的stack中，处理完中断iret指令就自动恢复原来的context。

```C
struct gate_struct {
	u16		offset_low;
	u16		segment;
	struct idt_bits	bits;
	u16		offset_middle;
	u32		offset_high;
	u32		reserved;
}

struct idt_bits {
	u16		ist	: 3,
			zero: 5,
			type: 5,
			dpl	: 2,
			p	: 1;
}

struct idt_data {
	unsigned int	vector;
	unsigned int	segment;
	struct idt_bits	bits;
	const void	*addr;
};

static gate_desc idt_table[IDT_ENTRIES]
static struct desc_ptr idt_descr
```

- 16-31共16位是中断处理程序所在的段选择符。
- 0-15位和48-64位组合起来形成32位偏移量，也就是中断处理程序所在段(由16-31位给出)的段内偏移。
- 40－43位共4位表示描述符的类型。(0111:中断描述符，1010：任务门描述符，1111：陷阱门描述符)
- 45－46两位标识描述符的访问特权级(DPL,Descriptor Privilege Level)。
- 47位标识段是否在内存中。如果为1则表示段当前不再内存中。

- 16~31：code segment selector
- 0~15 & 48-63：segment offset （根据以上两项可确定中断处理函数的地址）
- 32-39： 保留
- 40-43： Type：区分中断门、陷阱门、任务门等
- 44： 0
- 45-46： DPL：Descriptor Privilege Level， 访问特权级
- 47： P：该描述符是否在内存中


中断有优先级之分，中断处理程序不可重入，所以CPU要把自己正在处理的中断以及优先级更低的中断都要mask掉，CPU处理中不可以block，中断处理的过程要快，否则一些中断信号就发送不到CPU了，那代表着CPU错过很多关键的事件。CPU处理完这个中断就开中断，再告诉中断控制器这个中断处理完了，中断控制器就可以把这个中断从自己的队列中清除了，接着投递其它优先级更低的中断。

在虚拟化环境，一个物理CPU要当作很多个虚拟CPU来使用，虚拟CPU要么共享物理CPU的真正硬件，外加隔离措施，如TLB共享，要么用虚拟的硬件，如虚拟APIC。TLB就是通过VPID(virtual processor id)标签来区分不同的VCPU，APIC硬件逻辑太复杂，显然无法通过标签来区分，只能用虚拟的。guest的IOAPIC和LAPIC都是假的，不是真正存在的硬件单元，只有host拥有真正的硬件，没有虚拟化之前原来的流程都要玩得转，第一，guest里的操作系统和host上一模一样，host操作系统是怎么读写中断控制器的，那么guest就是怎么读写中断控制器的，由于guest并没有真正的硬件单元，guest对中断控制器的读写只能由hypervisor拦截住做特殊处理。第二，没有虚拟化之前，IOAPIC和LAPIC之间有硬连线，LAPIC和CPU就是强绑定，而且CPU是一直在线的，在虚拟化环境，中断控制器是虚拟的，但CPU使用的是真实的物理CPU，只是物理CPU运行于guest模式，虚拟的中断控制器和物理CPU之间没有连线，虚拟CPU在物理CPU上来回漂，而且虚拟CPU也有可能没有在任何物理CPU上运行，问题就来了，原来APIC的处理逻辑可以用软件来模拟，虚拟CPU在物理CPU上运行时怎么把中断投递给它？虚拟CPU没有运行时中断暂时存放在哪里？第三，外部中断来了由host处理还是guest处理？

答案在intel手册中，先说第三个问题，intel在VMCS中加了一个控制字段external interrupt exiting，如果设置为1，外部中断来了，物理CPU如果在guest模式就exit出来处理这个中断，如果设置为0，就由guest来处理这个中断，有可能host和guest的IDT表不相同，处理结果就不一样，这显然不是虚拟化想要的效果，要设置为1，但CPU exit出来是有性能开销，最好guest绑定在一些物理CPU上运行，外部中断绑定在另一些物理CPU上处理。第一个问题，guest读写中断控制器时hypervisor进行拦截，guest要exit出来，中断控制器逻辑复杂，寄存器众多，guest要经常exit出来，性能影响很大。第二个问题，intel在VMCS中提供一个存放中断的地方interrupt pending，如果虚拟CPU没有运行投递给它的中断就pending起来，intel还提供了event inject机制，如果VMCS中有中断标志，VMRESUME后guest不会立马执行其它指令而是立马处理中断，如果虚拟CPU正在物理CPU上运行，还是把中断写在VMCS中，给物理CPU发个IPI中断，把物理CPU从guest模式kick出来，物理CPU一看IPI中携带的号码是事先约定的，就知道是给虚拟CPU的中断，然后重新RESUME guest用event inject机制把中断投递给虚拟CPU。

中断虚拟化有点复杂，guest也是可能mask/unmask中断的，guest也有不可mask的中断，guest的两个虚拟CPU之间也要发IPI中断，一个虚拟CPU发送中断时exit出来，把真正的中断号写到目标虚拟CPU的VMCS中，如果目标CPU在一个物理CPU上运行，发送真正的IPI给目标物理CPU，目标物理CPU exit出来，然后重新RESUME进行interrupt inject。



原来APIC virtualization在hypervisor软件中实现，导致guest exit次数太多，性能太差，intel决定在硬件中实现部分原来hypervisor软件实现的APIC virtualization功能，目标就是减少guest exit的次数，从而提高guest的性能。intel手册中有三部分APIC-Register Virtualization，Virtual-Interrupt Delivery和Posted-Interrupt Processing。

intel在VMCS增加了很多很多中断控制相关的控制位，可以细粒度控制中断虚拟化。

APIC-Register Virtualization
上面说了所有CPU访问自己的LAPIC用了相同的物理地址，那么guest中两个虚拟CPU访问自己的虚拟LAPIC也用相同的物理地址，但一个guest只有一套EPT机制，这怎么区分？intel发明了apic-access page和virtual-apic page，这两个page的物理地址写在VMCS中，我理解一个guest只有一个apic-access page，每个虚拟CPU有一个virtual-apic page，guest虚拟CPU读写LAPIC时，EPT把地址翻译指向apic-access page，EPT翻译完了，CPU知道自己此时处于guest模式，正在运行哪个虚拟CPU，加载着哪个VMCS，然后就偷偷去virtual apic page去拿数据了，这样就能保证虚拟CPU访问相同的物理地址拿到不同的结果，而且不需要hypervisor软件介入，比如虚拟CPU读自己的LAPIC ID，那结果肯定不一样，EPT翻译到相同的地址，如果没重定向到virtual-apic page那么结果就一样了。

guest处理完中断写EOI原来要exit出来，有了EOI-exit bitmapp就可以不exit出来。

Virtual-Interrupt Delivery
virtual-APIC page每个位置就代表着硬件LAPIC的寄存器，把中断号写到virtual-APIC page中一个位置中断就自动投递给虚拟CPU了，不需要把物理CPU kick一下exit出来再event inject。

Posted-Interrupt Processing
投递中断时不用再exit出了，但发送中断时要不要exit出来？如虚拟CPU之间IPI，一个虚拟CPU发送中断，另一个CPU接受中断，post interrupt就是要解决虚拟CPU发送中断时也不exit，VMCS中增加一个地址就叫做post interrupt descriptor addr，它指向了post interrupt request vector和post interrupt notification vector，post interrupt request就是目前有哪些中断来了，notification vector代表通知CPU中断来了，按我理解发送虚拟CPU写LAPIC ICR时硬件把数据写到了descriptor vector和notification vector中，硬件根据写的信息得进行中断逻辑处理，得出要投递的中断号，写到virtual-APIC page中，目标虚拟CPU在guest模式每个指令前都要检查一下outstanding notification，如果outstanding notification标志着中断来了就去virtual-APIC page中读中断。

硬件实现了部分功能，kvm代码要配合修改，如果CPU具有这样的功能kvm会自动打开，目录/sys/module/kvm_intel/parameters/enable_apicv可以查看CPU是否具有这样的功能。

intel手册中说的也不够清楚，反正是非常非常复杂，极其难以理解。

vt-d中断虚拟化
vt-d包括DMA remapping和interrupt remapping，由IOMMU硬件实现具体的功能，主要用于用户态驱动和kvm外设直接passthrough给guest，DMA remapping的目标就是外设直接把数据DMA到guest内存中，interrupt remapping的目标就是把外设产生的中断直接给了guest虚拟CPU，hypervisor不介入，这样性能最高。

hypervisor拥有一个Interrupt Remap Table Address Register指向Interrupt Remapping Table Entry，每passthrough一个设备，hypervisor就在这个表中分配一个entry，打上相应的属性，由于外设已经pasthrough给guest了，guest里驱动写外设的PCI config space，此时hypervisor要拦截对PCI config space的写，配置外设MSI产生的中断是remappable格式。

guest里的driver给这个passthroug的device分配了一个vector X，然后在IDT中添加了vector X的处理函数。由于device的interrupt是external interrupt，不能直接给了guest，host也给device分配一个vector Y，host接收到了interrupt Y转换成interrupt X，再投递给guest，guest用自己的函数处理，投递时用post interrupt就不会导致guest exit出来。这里有两个问题，第一，能不能vector X不转换成vector Y？其实是不行的，因为guest1会分配一个vector X，guest2也有可能分配一个vector X，外设的X中断来了投递给哪个guest呢？所以必须转换，guest独自分配自己的vector，host再转换保证不冲突。第二，原来虚拟CPU运行在物理CPU1上，外设中断Y来了交给物理CPU1处理，那么假如虚拟CPU漂移到物理CPU2上执行，那么就得修改IOMMU中东西，以后把中断Y交给物理CPU2处理，如果虚拟CPU没有在运行，还得找地方暂存起来。


## 物理机的中断初始化
64位Linux启动大的方向上需要经过 实模式 -> 保护模式 -> 长模式 第三种模式的转换

中断的第一次初始化： 实模式下的初始化，在实模式下也有一个BIOS的中断向量表，这个中断向量表提供了一些类似于BIOS的系统调用一样的方法。比如Linux在初始化时需要获取物理内存的详情，就 是调用了BIOS的相应中断来获取的。

中断的第二次初始化: 在进入到保护模式后，会全新初始化一个空的中断描述符表 IDT, 供 kernel 使用;Linux Kernel提供256个大小的中断描述符表
中断的第三次初始化: 在进入到长模式后，在x86_64_start_kernel先初始化(idt_setup_early_handler)前(early_idt_handler_array)32个异常类型的中断(即上面定义的 idt_table 的前32项)；

- X86_TRAP_PF 缺页异常的中断处理程序
- 在trap_init中调用 idt_setup_traps更新部分异常的中断处理程序



实模式下的1MB地址空间： 
0x0000 0000 - 0x0000 03FF: Real Mode Interrupt Vector Table
0x0000 0400 - 0x0000 04FF: BIOS Data Area
0x0000 0500 - 0x0000 7BFF: Unused
0x0000 7C00 - 0x0000 7DFF: our Boot Loader
0x0000 7E00 - 0x0009 FFFF: Unused
0x000A 0000 - 0x000B FFFF: Video RAM (VRAM) Memory
0x000B 0000 - 0x000B 7777: Monochrome Video Memory
0x000B 8000 - 0x000B FFFF: Color Video Memory
0x000C 0000 - 0x000C 7FFF: Video ROM BIOS
0x000C 8000 - 0x000E FFFF: BIOS Shadow Area
0x000F 0000 - 0x000F FFFF: System BIOS



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