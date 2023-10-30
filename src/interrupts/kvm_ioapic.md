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