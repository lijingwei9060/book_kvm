#

## LAPIC 

lapic 为每个CPU分配一个4KB的内存映射，物理地址为0xFEE00000H，这个是物理地址，每个cpu访问这个地址都指向lapic，物理内存是不存在的。

### vapic

intel 的中断虚拟化和apic 虚拟化，

- APIC-access address (64 bits). This field contains the physical address of the 4-KByte APIC-access page
- Virtual-APIC address (64 bits). This field contains the physical address of the 4-KByte virtual-APIC page

- TPR threshold (32 bits). Bits 3:0 of this field determine the threshold below which bits 7:4 of VTPR (see Section 29.1.1) cannot fall.
- EOI-exit bitmap (4 fields; 64 bits each). These fields are supported only on processors that support the 1- setting of the “virtual-interrupt delivery” VM-execution control. They are used to determine which virtualized writes to the APIC’s EOI register cause VM exits
- Posted-interrupt notification vector (16 bits). Its low 8 bits contain the interrupt vector that is used to notify a logical processor that virtual interrupts have been posted. See Section 29.6 for more information on the use of this field.
- Posted-interrupt descriptor address (64 bits).

**Guest Non-Register State**

- Guest interrupt status (16 bits) This field is supported only on processors that support the 1-setting of the “virtual-interrupt delivery” VM-execution control.
- Requesting virtual interrupt (RVI)(low byte)
- Servicing virtual interrupt (SVI)(high byte)


- Virtual-interrupt delivery. This controls enables the evaluation and delivery of pending virtual interrupts. It also enables the emulation of writes (memory-mapped or MSR-based, as enabled) to the APIC registers that control interrupt prioritization.
- Use TPR shadow. This control enables emulation of accesses to the APIC’s task-priority register (TPR) via CR8  and, if enabled, via the memory-mapped or MSR-based interfaces.
- Virtualize APIC accesses. This control enables virtualization of memory-mapped accesses to the APIC by causing VM exits on accesses to a VMM-specified APIC-access page. Some of the other controls, if set, may cause some of these accesses to be emulated rather than causing VM exits.
- Virtualize x2APIC mode. This control enables virtualization of MSR-based accesses to the APIC .
- APIC-register virtualization. This control allows memory-mapped and MSR-based reads of most APIC registers (as enabled) by satisfying them from the virtual-APIC page. It directs memory-mapped writes to the APIC-access page to the virtual-APIC page, following them by VM exits for VMM emulation.
- Process posted interrupts. This control allows software to post virtual interrupts in a data structure and send a notification to another logical processor; upon receipt of the notification, the target processor will process the posted interrupts by copying them into the virtual-APIC page .


**Virtualized APIC Registers**
- Virtual task-priority register (VTPR): the 32-bit field located at offset 080H on the virtual-APIC page.
- Virtual processor-priority register (VPPR): the 32-bit field located at offset 0A0H on the virtual-APIC page.
- Virtual end-of-interrupt register (VEOI): the 32-bit field located at offset 0B0H on the virtual-APIC page.
- Virtual interrupt-service register (VISR)
- Virtual interrupt-request register (VIRR)
- Virtual interrupt-command register (VICR_LO): the 32-bit field located at offset 300H on the virtual-APIC page
- Virtual interrupt-command register (VICR_HI): the 32-bit field located at offset 310H on the virtual-APIC page.

### vmcs结构

```text
    vmcs
    +----------------------------------+
    |guest state area                  |
    |   +------------------------------+
    |   |guest non-register state      |
    |   |   +--------------------------+
    |   |   |Guest interrupt status    |
    |   |   |   +----------------------+
    |   |   |   |Requesting virtual    |
    |   |   |   |   interrupt (RVI).   |
    |   |   |   +----------------------+
    |   |   |   |Servicing virtual     |
    |   |   |   |   interrupt (RVI).   |
    |   |   |   |                      |
    |   |   +---+----------------------+
    |   |                              |
    |   +------------------------------+
    |                                  |
    |vm-execution control              |
    |   +------------------------------+
    |   |APIC-access address           |
    |   |                              |
    |   |                              |         4K Virtual-APIC page
    |   |Virtual-APIC address      ----|-------->+-------------------------+
    |   |                              |     080H|Virtual task-priority    |
    |   |                              |         |        register (VTPR)  |
    |   |                              |     0A0H|Vrtl processor-priority  |
    |   |                              |         |        register (VPPR)  |
    |   |                              |     0B0H|Virtual end-of-interrupt |
    |   |                              |         |        register (VEOI)  |
    |   |                              |         |Virtual interrupt-service|
    |   |                              |         |        register (VISR)  |
    |   |                              |         |Virtual interrupt-request|
    |   |                              |         |        register (VIRR)  |
    |   |                              |     300H|Virtual interrupt-command|
    |   |                              |         |        register(VICR_LO)|
    |   |                              |     310H|Virtual interrupt-command|
    |   |                              |         |        register(VICR_HO)|
    |   |                              |         |                         |
    |   |                              |         +-------------------------+
    |   |                              |
    |   |                              |
    |   |TPR threshold                 |
    |   |EOI-exit bitmap               |
    |   |Posted-interrupt notification |
    |   |        vector                |
    |   |                              |
    |   |                              |    64 byte descriptor
    |   |                              |    511              255              0
    |   |Posted-interrupt descriptor   |--->+----------------+----------------+
    |   |        address               |    |                |                |
    |   |                              |    |                |                |
    |   |                              |    +----------------+----------------+
    |   |Pin-Based VM-Execution Ctrls  |
    |   |    +-------------------------+
    |   |    |Process posted interrupts|
    |   |    |                         |
    |   |    +-------------------------+
    |   |                              |
    |   |Primary Processor-Based       |
    |   |   VM-Execution Controls      |
    |   |    +-------------------------+
    |   |    |Interrupt window exiting |
    |   |    |Use TPR shadow           |
    |   |    |                         |
    |   |    +-------------------------+
    |   |                              |
    |   |Secondary Processor-Based     |
    |   |   VM-Execution Controls      |
    |   |    +-------------------------+
    |   |    |Virtualize APIC access   |
    |   |    |Virtualize x2APIC mode   |
    |   |    |APIC-register virtual    |
    |   |    |Virtual-intr delivery    |
    |   |    |                         |
    |   |    |                         |
    |   |    +-------------------------+
    |   |                              |
    |   +------------------------------+
    |                                  |
    +----------------------------------+
```

### qemu

- APICCommonState 表达LAPIC
- 内存映射： apic-msi， apic_io_ops，大小APIC_SPACE_SIZE
- 时钟： timer_new_ns(QEMU_CLOCK_VIRTUAL, apic_timer, s)
- MSIMessage msi，MSI在pci总线上，apic在cpu上。



apic_send_msi(&msi)


### KVM

1. kvm通过Virtualize APIC accesses来指定一块4k内存，为每个vCPU模拟APIC寄存器的访问和管理中断。 vmx_vcpu_reset =>   vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, __pa(vcpu->arch.apic->regs));
2. 虚拟中断包含了中断检测和中断发送。对virtual-APIC page的操作会触发虚拟中断的检测，如果这个检测得到了一个虚拟中断，则会向guest发送一个中断且不导致guest退出。

虚拟中断检测，以下几种情况将触发虚拟中断的检测：
- VM entry(Section 26.3.2.5)
- TPR virtualization(Section 29.1.2)
- EOI virtualization(Section 29.1.4)
- self-IPI virtualization(Section 29.1.5)
- posted-interrupt processing(Section 29.6)

```shell
IF “interrupt-window exiting” is 0 AND
  RVI[7:4] > VPPR[7:4] (see Section 29.1.1 for definition of VPPR)
    THEN recognize a pending virtual interrupt;
ELSE
    do not recognize a pending virtual interrupt;
FI;
```

虚拟中断发送会改变虚拟机中断状态(RVI/SVI)，并且在vmx non-root 模式下发送一个中断，从而不导致虚拟机退出。中断发送的伪代码如下：

```shell
Vector ← RVI; VISR[Vector] ← 1;
SVI ← Vector;
VPPR ← Vector & F0H; VIRR[Vector] ← 0;
IF any bits set in VIRR
  THEN RVI ← highest index of bit set in VIRR
  ELSE RVI ← 0; FI;
deliver interrupt with Vector through IDT;
cease recognition of any pending virtual interrupt;
```

在kvm代码中首先需要检测硬件是否支持apicv的功能，并作标示。
```shell
vmx_init
    kvm_init
        kvm_arch_hardware_setup
            hardware_setup
                if (!cpu_has_vmx_apicv()) {
                  enable_apicv = 0;
                  kvm_x86_ops->sync_pir_to_irr = NULL;
                }

static inline bool cpu_has_vmx_apicv(void)
{
    return cpu_has_vmx_apic_register_virt() &&
        cpu_has_vmx_virtual_intr_delivery() &&
        cpu_has_vmx_posted_intr();
}
```

使用enable_apicv这个值，而是把它赋值给了vcpu。
```shell
kvm_arch_vcpu_init
    vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu);
        return enable_apicv;
```

- APIC-access page and virtual-APIC page in VMCS field， 虚拟机访问apic-access page，将获得对应的v-apic page.
  - APIC-access page: 4Kb物理地址，kvm->kvm_arch->apic_access_page, 这个在KVM代码中alloc_apic_access_page
  - virtual-apic page：4Kb物理地址， kvm_vcpu->apic->regs
struct kvm_lapic *apic;


int kvm_create_lapic(struct kvm_vcpu *vcpu): // 申请 page
    vcpu->arch.apic = apic;
	apic->regs = (void *)get_zeroed_page(GFP_KERNEL);
    apic->vcpu = vcpu;

alloc_apic_access_page： 分配apic access page
vmx_vcpu_reset’, it writes the APIC-access page and virtual-apic page to VMCS.

申请一个kvm_userspace_mem， gpa地址为0xfee00000ULL，大小一个页面，指向kvm->kvm_arch->apic_access_page。


### Posted Interrupt

虚机处于运行状态。当虚机正在运行时，来个一个外部中断，那么理想的方式就是不用vm exit就可以响应中断，而Posted-Interrupt就是干这个的，针对这种情况，后面会具体阐述。如果没有Posted-Interrupt，那么对于一个正在运行的虚机，通过IPI使其vm exit->中断注入->vm entry响应中断。虚机不在运行。对于一个这样的虚机，只需要中断注入->vm entry响应中断，所以vm entry越早(即尽快使vCPU投入运行)，中断响应越实时。Interrupt Remapping时通过配置urgent选项就是为了提高响应速度
请附上原文出处链接及本声明。



Interrupt-posting是VT-d中中断重映射功能的一个扩展功能，该功能也是针对可重映射的中断请求。Interrupt-posting功能让一个可重映射的中断请求能够被暂时以一定的数据形式post（记录）到物理内存中，并且可选择性地主动告知CPU物理内存中暂时记录着pending的中断请求。
VT-d重映射硬件是否支持Interrupt-posting功能可以通过查询Capability Register的bit 59 Posted Interrupt Support（PI）知道硬件是否支持该功能。

Interrupt Posting的功能就是让系统可以选择性地将中断请求暂存在内存中，让CPU主动去获取，而不是中断请求一过来就让CPU进行处理，这样在虚拟化的环境中，就能够防止外部中断频繁打断vCPU的运行，从而提高系统的能能。

post interrupt是intel提供的一种硬件机制，不用物理cpu从root模式exit到non-root模式就能把虚拟中断注入到non-root模式里，大概实现就是把虚拟中断写到post interrupt descriptor，预定义了一个中断号，然后给non-root模式下的cpu发送这个中断，non-root模式下cpu收到这个中断触发对virtual-apic page的硬件模拟，从post interrupt descriptor取出虚拟中断更新到virtual-apic page中，虚拟机中读virtual-access page，就能取到虚拟中断，处理中断，然后写EOI，触发硬件EOI virtulization，就能把virtual-apic page和post interrupt descriptor中数据清除。

post interrupt descriptor: 512位
PIR(post interrupt registry)总共256位，一位代表一个虚拟中断。ON代表预先定义的中断已经发出，如果已经为1就不要再发预先定义的中断了。SN代表不要再发中断。NV就是预先定义好的那个中断号，NDST就是物理CPU的local apic id。

vmcs中管理pi的字段：
- pi desc address 指向 pir/pid
- posted interrupt notification vector

kvm用post interrupt模式给vcpu注入中断，kvm修改这个vcpu的post interrupt descriptor，然后给这个vcpu所运行的物理cpu发送中断号是post interrupt notification vector的中断。kvm只用到了post interrupt descriptor中的ON，用到的notification vector存放在VMCS中而不是post interrupt descriptor中，主要是kvm运行在另一个物理cpu上，一个vcpu有没有运行，运行在哪个物理cpu上，这个vcpu可不可以接收中断，kvm很好判断，如果没有运行或者不能接收中断kvm在把虚拟中断存放在其它地方。

vmx_x86_ops，.deliver_posted_interrupt = vmx_deliver_posted_interrupt

当vCPU正在运行时，有posted-interrupt notification vector产生，此时虚机不需要vm exit，那么对于3、4两个操作是硬件自己做的，还是通过物理机上的posted-interrupt notification vector服务程序做的。通过查看smp_kvm_posted_intr_ipi函数commit信息，整个posted-interrup过程对vmm是透明的，smp_kvm_posted_intr_ipi函数就是当vcpu挂起的时候用的，通过这些信息说明3、4两个操作是硬件自己做的。

kvm_vcpu_trigger_posted_interrupt 这里面先判断vcpu是否处于guest mode(vcpu->mode == IN_GUEST_MODE)，如果是，说明正在运行，那么假设现在不在运行，然后另一个核给投入运行了，然后在发送也没啥事，因为先给ipr置位了，一旦执行了vm entry就响应中断了。




### IOMMU + PI

IOMMU硬件单元也可以借用post interrupt机制把passthrough设备产生的中断直接投递到虚拟机中，不需要虚拟机exit出来，不需要VMM软件介入，性能非常高。这种情况设备产生的中断从原来interrupt remapping格式变成post interrupt格式，IRTE内容也变了，它中存放post interrupt descriptor的地址和虚拟中断vector，物理中断到了IOMMU，IOMMU硬件单元直接IRTE中虚拟中断vector写到post interrupt descriptor中pir对应的位，然后通过其他CPU给vcpu所在的物理cpu发送一个中断（IPI），中断号就是post interrupt descriptor中的NV。

在passthrough虚拟机外设后，虚拟机中的设备驱动会会通过pci config space注册中断处理函数，qemu会拦截pci配置空间的读写，将虚拟中断同步到kvm的irq routing entry，kvm再将中断信息写入到IRTE中。

一个passthrough给虚拟机的外设，虚拟机里driver给外设分配虚拟中断，qemu拦截到对外设pci config space的写，然后把虚拟中断更新到kvm的irq routing entry中，kvm再调用update_pi_irte把post interrupt descriptor地址和虚拟中断号更新到IRTE中。
```shell
kvm_set_irq_routing()
  void kvm_irq_routing_update(struct kvm *kvm)
    kvm_arch_update_irqfd_routing
      vmx_x86_ops.pi_update_irte = vmx_pi_update_irte
        └─irq_set_vcpu_affinity
            └─intel_ir_set_vcpu_affinity
                  └─modify_irte
```

vt-x posted interrupt就是另一个CPU更新了vcpu的post interrupt descriptor，发送一个ipi给vcpu运行的物理CPU。vt-d posted interrupt就是IOMMU硬件单元更新了vcpu的post interrupt descriptor。vt-x和vt-d post interrupt都不会导致vcpu运行的物理CPU从non-root模式exit到root模式，而且能把vcpu的中断注入到guest。但vt-d相比vt-x就弱智多了，一个vcpu有没有运行，运行在哪个物理cpu上，这个vcpu可不可以接收中断，或者vcpu从一个物理cpu迁移到另一个物理cpu，vt-d IOMMU都不能自己判断，只能通过kvm告诉它，所以kvm就把这些信息写到post interrupt descriptor的其它位中，IOMMU来读，这些位就是SN，NDST和NV。

vcpu转换为运行状态，vmx_vcpu_pi_load清除SN，更新NDST。

```shell
vcpu_load
  └─preempt_notifier_register

context_switch
  └─finish_task_switch
      └─fire_sched_in_preempt_notifiers
          └─ __fire_sched_in_preempt_notifiers
               └─kvm_sched_in
                   └─kvm_arch_vcpu_load
                      └─kvm_x86_vcpu_load
                           └─vmx_vcpu_pi_load
```
vcpu暂时挂起，设置SN。
```shell
vmx_vcpu_put
    └─vmx_vcpu_pi_put
```

虚拟机执行hlt指令vcpu暂停，保留原先运行的物理cpu到NDST，设置NV为wakeup vector
```shell
vcpu_block
    └─vmx_pre_block
         └─pi_pre_block
```

如果此时IRTE中URG为1，IOMMU就给物理cpu发送wakeup vector，pi_wakeup_handler让vcpu开始运行。

```shell
DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_posted_intr_wakeup_ipi)
{
	ack_APIC_irq();
	inc_irq_stat(kvm_posted_intr_wakeup_ipis);
	kvm_posted_intr_wakeup_handler();
}
kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
```

vcpu开始运行，更新NDST，理想NV为post interrupt vector。
```shell
vmx_post_block           
  └─pi_post_block
```

### pv ipi

虚拟机中一个vcpu要向另一个vcpu发送ipi或者向其它vcpu广播ipi，怎么利用post interrupt?

首先源vcpu需要把ipi的目的vcpu的local apic id写到apic寄存器，再写icr寄存器，写icr寄存器就会导致vcpu exit，然后kvm就可以利用vt-x posted interrupt把虚拟中断注入到另一个vcpu。如果是广播ipi，那么源vcpu要exit出来很多次。

kvm_lapic_reg_write->kvm_apic_send_ipi

所以腾讯云李万鹏就想了招，通过hypercall传bitmap一次把所有目的vcpu都传出来，这样源vcpu就可以少exit出来几次。

kvm_emulate_hypercall->kvm_pv_send_ipi

有些虚拟机中的业务会大量用到ipi，导致虚拟机exit出来很多很多次，性能影响太大。有人就想到把源vcpu所运行的物理cpu的lapic的icr寄存器透传给vcpu，把其它vcpu的post interrupt descriptor也透传给虚拟机源vcpu，源vcpu要给目的vcpu发送ipi，源vcpu修改目的vcpu的post interrupt descriptor，源vcpu给真正的硬件寄存器icr写post interrupt notification vector，这样源vcpu不用exit出来。问题就是有点不安全，一个有问题的虚拟机可以频繁给其它物理cpu发送ipi，造成其它物理cpu ipi DDOS攻击，私有云可以用，公有云不行。

### pv eoi
经过posted interrupt技术优化后，注入irq不发生vm exit。但是guest在应答irq的时候，还是要发生vm exit。
所以有了pv eoi技术：
a，guest和host通过msr寄存器，协商出来一个地址，用作eoi使用。前提是host和guest都支持pv eoi。
b，guest的pa，和host的va，通过映射计算，就是在操作同一块内存。
那么就不用发生vm exit的情况下，达到guest和host内外通信的目的。同样原理的还有kvm clock、steal time等。


## 数据结构