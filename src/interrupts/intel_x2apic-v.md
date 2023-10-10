# 概念

lapic需要虚拟的内容：
1. virtual apic state： lapic寄存器虚拟化， apic-register virtualization，virtual apic page对应apic的寄存器，地址保存在VMCS[vm-execution control]中。
2. apic-access 使能
3. x2apic
4. virtual-interrupt delivery
5. post interrupt

## VMCS VM-Execution Controls
VMCS 中有中断和 APIC 虚拟化相关的控制位，启用这些特性后，处理器会模拟对 APIC 的大多数访问，跟踪 vAPIC 状态并交付中断——这些都在 non-root 模式下进行，不触发 VM Exit。处理器根据 VMM 指定的 virtual-APIC page 跟踪 vAPIC 状态。

1. Virtual-interrupt delivery：启用对挂起虚拟中断的评估和交付，支持模拟写入控制中断优先级的 APIC 寄存器（MMIO 或 MSR）。
2. Use TPR shadow：启用通过 CR8 模拟对 APIC 任务优先级寄存器 TPR 的访问（MMIO 或 MSR）。
3. Virtualize APIC accesses：启用 MMIO 访问 APIC 的虚拟化，处理器访问 VMM 指定的 APIC-access page 时触发 VM Exit，或模拟访问。
4. Virtualize x2APIC mode：启用基于 MSR 访问 APIC。
5. APIC-register virtualization：对大多数 APIC 寄存器的读都重定向到 virtual-APIC page，而写操作会定向到 APCI-access page 触发 VM Exit。
6. Process posted Interrupts：允许软件在数据结构中发送中断，并向另一个逻辑处理器发送通知，收到通知的目标处理器会将发送来的中断复制到 virtual-APIC page 做进一步处理。

## virtual apic state

为了让Guest对其（虚拟）APIC的访问不必引起VM Exit，引入了Virtual-APIC Page的概念。它相当于是一个Shadow APIC，Guest对其APIC的部分甚至全部访问都可以被硬件翻译成对Virtual-APIC Page的访问，这样就不必频繁引起VM Exit了。我们可以通过Virtual-APIC Address（VMCS[0x2012]/VMCS[0x2013](64 bit full/high)）指定Virtual-APIC Page的物理地址。

我们知道，x86 CPU中一共有三种访问APIC的方式：
1. 通过CR8来访问TPR寄存器（仅IA32-e即64位模式）
2. 通过MMIO来访问APIC的寄存器, 基地址位 IA32_APIC_BASE MSR 的 4K 页，这是xAPIC模式提供的访问方式
3. 通过MSR来访问APIC的寄存器，使用 RDMSR 和 WRMSR 访问, 这是x2APIC模式提供的访问方式

无论哪种方式，Guest对APIC的访问都可以配置为访问Virtual-APIC Page，下面几节会分别介绍三种访问方式的具体配置和虚拟化方式。

Virtual-APIC Page中的寄存器的偏移量，vapic与APIC中对应的寄存器的偏移量相同，例如TPR寄存器位于APIC_Page[0x80]，则Virtual TPR寄存器位于vAPIC_Page[0x80]


## Virtual APIC Accesses

### CR8-Based TPR Accesses
默认情况下，Non-root模式下进行MOV CR8操作，会直接操作CPU硬件的CR8寄存器从而操作其APIC的TPR寄存器的第4-7位。

1. 为了实现CR8寄存器的虚拟化，可以利用Primary Processor-Based VM-Execution Controls.CR8-Load Exiting[bit 19]和Primary Processor-Based VM-Execution Controls.CR8-Store Exiting[bit 20]这两个位，分别可以让Guest在Mov-to-CR8和Mov-from-CR8时发生VM Exit（EXIT_REASON_CR_ACCESS, VM Exit No.28 Control-Register Accesses），从而实现Trap-and-Emulate(handle_cr kvm_get_cr8 kvm_set_cr8)。
2. 另一种更好的方式是设置Primary Processor-Based VM-Execution Controls.Use TPR Shadow[bit 21] = 1，这样Guest在访问CR8时实际上会访问Virtual-APIC Page中的Virtual TPR (VTPR)寄存器的第4-7位。

处理器针对以下操作执行 Task-Priority Register, TPR 虚拟化：

1. MOV to CR8 指令的虚拟化
2. 对 `APIC-access page` 080H 偏移写操作的虚拟化
3. 对 ECX =808H，WRMSR 指令的虚拟化

IF “virtual-interrupt delivery” is 0
    THEN
        IF VTPR[7:4] < TPR threshold (see Section 23.6.8)
            THEN cause VM exit due to TPR below threshold;(EXIT_REASON_TPR_BELOW_THRESHOLD, handle_tpr_below_threshold)
        FI;
    ELSE
        perform PPR virtualization (see Section 28.1.3);
        evaluate pending virtual interrupts (see Section 28.2.1);
FI;
由 TPR 虚拟化触发的 VM Exit 类似 trap。


### Memory-Mapped APIC Accesses(XAPIC?)
默认情况下，Non-root模式下CPU访问APIC的MMIO地址（HPA, Host Physical Address），会直接访问到CPU的APIC, 默认的MMIO地址为0xfee00000。

为了不让Guest访问到Host的APIC，早期采取的做法是利用Hypervisor对Shadow Page Table或EPT的控制，令Guest在访问落在APIC的MMIO区间的GPA (Guest Physical Address)时VM Exit(EXIT_REASON_EPT_VIOLATION)，从而实现Trap-and-Emulate(`handle_ept_violation`)。KVM会从vmcs中得到GUEST_PHYSICAL_ADDRESS地址、退出的原因EXIT_QUALIFICATION。

现在已经有了更好的做法：当Secondary Processor-Based VM-Execution Controls.Virtualize APIC Accesses[bit 0] = 1时，可以通过设置`APIC-Access Address`（VMCS[0x2014]/VMCS[0x2015](64 bit full/high)）指定一个APIC-Access Page，Non-root模式下对HPA落在APIC-Access Page的内存访问默认的处理是引起一个VM Exit（ `EXIT_REASON_APIC_ACCESS` VM Exit No.44 APIC Access ）。

Virtualize APIC Accesses 功能可以单独开启，此时它的作用仅仅是将Guest APIC访问的VM Exit从EPT Violaton改为了APIC Access(`EXIT_REASON_APIC_ACCESS`)，对Guest的APIC访问仍需要以Trap-and-Emulate(`handle_apic_access`)方式实现。但是，若进一步开启其他APIC虚拟化功能，则可以将Guest APIC访问转变为访问Virtual-APIC Page中的虚拟寄存器。

APIC Access VM Exit(`EXIT_REASON_APIC_ACCESS`)发生在Pagewalk之后，更进一步说是在页表项的A/D位被设置后，因为Pagewalk完成前还未获知HPA。另外，APIC-Access Page不能位于大页，否则可能失效。

这里所说的内存访问指的是所谓的`Linear Access`，不包括Pagewalk时产生的内存访问等不使用Linear Address进行的内存访问，软件最好保证不要让Non-Linear Access访问到APIC-Access Page。

APIC-access address：申请4K空间，通过ept map到GPA的0xfee00000。

APIC-access page and virtual-APIC page in VMCS field， 虚拟机访问apic-access page，将获得对应的v-apic page.
- APIC-access page: 4Kb物理地址，kvm->kvm_arch->apic_access_page, 这个在KVM代码中alloc_apic_access_page
- virtual-apic page：4Kb物理地址， kvm_vcpu->apic->regs

```C
int kvm_create_lapic(struct kvm_vcpu *vcpu): // 申请 page
    vcpu->arch.apic = apic;
	  apic->regs = (void *)get_zeroed_page(GFP_KERNEL);
    apic->vcpu = vcpu;
```


alloc_apic_access_page： 分配apic access page
vmx_vcpu_reset: it writes the APIC-access page and virtual-apic page to VMCS.

申请一个kvm_userspace_mem， gpa地址为0xfee00000ULL，大小一个页面，指向kvm->kvm_arch->apic_access_page。

#### Memory Reads

若满足下列任意条件，则对APIC-Access Page的读取会引起APIC Access VM Exit：

- Use TPR Shadow = 0
- 读取访问是一个取指令操作
- 读取访问的Size大于32位
- 导致读取的指令已经进行了一次对APIC-Access Page的写入的虚拟化
- 没有访问到合法的寄存器（e.g. vAPIC_Page[0x80] - vAPIC_Page[0x83]是有效的，而vAPIC_Page[0x84] - vAPIC_Page[0x8F]是非法的）

否则，将有机会避免VM Exit，读到Virtual-APIC Page中的值，这将根据Secondary Processor-Based VM-Execution Controls.APIC-Register Virtualization[bit 8]和Secondary Processor-Based VM-Execution Controls.Virtual-Interrupt Delivery[bit 9]两个位的取值决定：

- APIC-Register Virtualization = 0, Virtual-Interrupt Delivery = 0，则只有对TPR的访问不会引起APIC Access VM Exit
- APIC-Register Virtualization = 0, Virtual-Interrupt Delivery = 1，则只有对TPR、EOI Register和ICR_Low（ICR的低32位）的访问不会引起APIC Access VM Exit
- APIC-Register Virtualization = 1，则对下列寄存器的访问不会引起APIC Access VM Exit
  - APIC ID Register、APIC Version Register
  - TPR、LDR、DFR
  - Spurious-Interrupt Vector Register
  - IRR、ISR、TMR、EOI Register
  - Error Status Register
  - ICR
  - LVT Entries、Initial Count Register、Divide Configuration Register
  - 换句话说除了只读的PPR和Current Count Register，APIC中其余所有寄存器都允许从Virtual-APIC Page中读取

#### Memory Writes

若满足下列任意条件，则对APIC-Access Page的写入会引起APIC Access VM Exit：

- Use TPR Shadow = 0
- 写入访问的Size大于32位
- 导致写入的指令已经进行了一次对APIC-Access Page的写入的虚拟化
- 没有访问到合法的寄存器

否则，将有机会避免VM Exit，写入到Virtual-APIC Page：

- APIC-Register Virtualization = 0, Virtual-Interrupt Delivery = 0，则只有对TPR的访问不会引起APIC Access VM Exit
- APIC-Register Virtualization = 0, Virtual-Interrupt Delivery = 1，则只有对TPR、EOI Register和ICR_Low（ICR的低32位）的访问不会引起APIC Access VM Exit
- APIC-Register Virtualization = 1，则对下列寄存器的访问不会引起APIC Access VM Exit
  - APIC ID Register
  - TPR、LDR、DFR
  - Spurious-Interrupt Vector Register
  - EOI Register
  - Error Status Register
  - ICR
  - LVT Entries、Initial Count Register、Divide Configuration Register
  - 相比读取请求，删去了只读的APIC Verson Register以及IRR、ISR、TMR

值得注意的是，在完成对Virtual-APIC Page的写入后，对APIC寄存器的写入操作产生的副作用可能仍需要模拟。硬件提供了对部分副作用的模拟，称为APIC-write Emulation，对另一些访问则需要Hypervisor模拟，此时会在写入完成后再触发一个VM Exit（VM Exit No.56 APIC Write）：

- 对TPR的写入，会引起TPR virtualization（详下）
- 对EOI Register的写入
  - 若Virtual-Interrupt Delivery = 1，则引起EOI virtualization（详下）
  - 否则，引起APIC Write VM Exit
- 对ICR_Low的写入
  - 若Virtual-Interrupt Delivery = 1，且写入的值满足以下条件，则引起Self-IPI virtualization（详下）：
    - Vector的高4位（bit 4-7）不为0
    - Delivery Mode（bit 8-10）为000b（Fixed）
    - Delivery Status（bit 12）为0
    - Trigger Mode（bit 15）为0（Edge）
    - Destination Shorthand（bit 18-19）为01b（Self）
    - 保留位为0
  - 否则，引起APIC Write VM Exit
- 对ICR_High的写入，不需要任何特殊处理
- 对其余寄存器的写入，都会引起APIC Write VM Exit

对于APIC Access和APIC Write，Exit Qualification（VMCS[0x6400](Natural Width)）的第0-11位会记录导致VM Exit的访问在APIC-Access Page中的偏移量，从而令Hypervisor可以实现Trap-and-Emulate。

### MSR-Based APIC Accesses

要实现对x2APIC的MSR寄存器的虚拟化，一种方式是利用MSR Bitmap（通过MSR Bitmap Address（VMCS[0x2004]/VMCS[0x2005](64 bit full/high)）指定），令对这些寄存器的访问都产生VM Exit（VM Exit No.31 RDMSR或VM Exit No.32 WRMSR），从而实现Trap-and-Emulate。X2APIC和apic-access不能共存。

若Secondary Processor-Based VM-Execution Controls.Virtualize x2APIC Mode[bit 4] = 1，则对于x2APIC MSR的访问会得到特殊处理。

对于RDMSR：

1. 若APIC-Register Virtualization = 0，则只有对TPR的访问会读取Virtual-APIC Page，其余访问会Passthrough（若硬件APIC处于x2APIC模式，则访问对应寄存器，若处于xAPIC模式，则产生#GP）
2. 若APIC-Register Virtualization = 1，则对所有寄存器的访问都会读取Virtual-APIC Page

对于WRMSR：

1. 对TPR的写入，会写入Virtual-APIC Page，并引起TPR virtualization（详下）
2. 对EOI Register的写入
   - 若Virtual-Interrupt Delivery = 1，则会写入Virtual-APIC Page，并引起EOI virtualization（详下）
   - 否则，访问会Passthrough
3. 对Self-IPI Register的写入
   - 若Virtual-Interrupt Delivery = 1，则
     - Vector的高4位非0，则引起Self-IPI virtualization（详下）
     - 否则引起APIC Write VM Exit，其Exit Qualification中报告的偏移量为0x3F0
   - 否则，访问会Passthrough
4. 对其余寄存器的写入都会Passthrough、

### 总结

apic-access page和virtual-apic page这两个page的物理地址写在VMCS中，一个guest只有一个apic-access page，每个虚拟CPU有一个virtual-apic page，guest虚拟CPU读写LAPIC时，EPT把地址翻译指向apic-access page，EPT翻译完了，CPU知道自己此时处于guest模式，正在运行哪个虚拟CPU，加载着哪个VMCS，然后去virtual apic page去拿数据，这样就能保证虚拟CPU访问相同的物理地址拿到不同的结果，而且不需要hypervisor软件介入，比如虚拟CPU读自己的LAPIC ID，那结果肯定不一样，EPT翻译到相同的地址，如果没重定向到virtual-apic page那么结果就一样了。

首先，对于MMIO方式的访问，可以通过Virtualize APIC Access令对APIC-Access Page的访问，产生APIC Access VM Exit，该功能是对MMIO访问进行进一步虚拟化的前提，它可以独立于Use TPR Shadow开启。

其次，Use TPR Shadow 是CR8、MMIO、MSR三种访问方式的虚拟化的总开关，必须开启才能将Guest的APIC访问重定向到Virtual APIC Page：

- 对CR8访问方式，Use TPR Shadow 直接控制其虚拟化
- 对xAPIC模式的MMIO访问，开启Use TPR Shadow才能令对部分或全部寄存器的访问重定向到Virtual APIC Page，否则只会产生APIC Access VM Exit
- 对x2APIC模式的MSR访问，Virtualize x2APIC Mode 控制其虚拟化，而启用该功能的前提是Use TPR Shadow已经启用
- 另外需要注意Virtualize APIC Access和Virtualize x2APIC Mode不能同时启用

开启Use TPR Shadow后仅仅是启用了对TPR寄存器的虚拟化，APIC-Register Virtualization 和Virtual-Interrupt Delivery提供了进一步的控制，这两个功能都必须在Use TPR Shadow启用后才能使用：

- 开启APIC-Register Virtualization就会虚拟化对所有APIC寄存器的读取
- 开启Virtual-Interrupt Delivery就会虚拟化对TPR、EOI Register、Self IPI (ICR_Low/Self-IPI Register)的写入
- 另外开启Virtual-Interrupt Delivery还要求Pin-Based VM-Execution Controls.External-Interrupt Exiting[bit 0] = 1

对xAPIC模式的虚拟化，我们可以认为相比x2APIC模式增加了以下规则：

- 开启APIC-Register Virtualization就会虚拟化对所有APIC寄存器的写入
- 开启Virtual-Interrupt Delivery就会虚拟化对TPR、EOI Register、ICR_Low的读取


## Autotriggered Behaviors

### FlexPriority
在APICv推出之前，还有一个过渡性的技术，称为VT-x FlexPriority，它引入了Shadow TPR，即VTPR寄存器（Virtual-APIC Page也是此时引入的）。此时，Virtual-APIC Page中仅实现了VTPR一个寄存器，并且尚未发明APIC Write VM Exit，因此对VTPR寄存器的写入会起到类似APIC-Write Emulation的效果，不会引起APIC Write VM Exit。

当Virtual-Interrupt Delivery = 0时，在写入完VTPR寄存器后

若VTPR[7:4] < TPR Threshold，则产生一个VM Exit（VM Exit No.43 TPR Below Threshold）
否则，不会有任何副作用，也不会产生APIC Write VM Exit
这里的TPR Threshold位于VMCS[0x401C](32 bit)，其0-3位表示VTPR的Task Prority Class（即高4位）允许的最小值，若小于TPR Threshold，则禁止进入Guest：

若当前处于Non-root模式，写入了VTPR导致VTPR[7:4] < TPR Threshold，则立即产生TPR Below Threshold VM Exit
若当前处于Root模式，且已满足VTPR[7:4] < TPR Threshold，则VM Entry后会立即产生TPR Below Threshold VM Exit
也就是说，TPR Threshold 的作用是强制令Task Priority较低的vCPU停止执行。

### Virtual Interrupt Delivery
当Virtual-Interrupt Delivery = 1时，Virtual Interrupt Delivery功能就会开启，此时会引入一个Guest Non-Register State.Guest Interrupt Status（VMCS[0x810](16 bit)），它由两个8位的Field构成：

- 低8位为Requesting Virtual Interrupt (RVI)，表示正在等待处理的中断中最大的Vector，相当于IRRV
- 高8位为Servicing Virtual Interrupt (SVI)，表示正在处理的中断中最大的Vector，相当于ISRV

使能条件： 置位VMCS中如下控制区域 secondary processor-based VM-executeion controls： virtual interrupt delivery，控制位使能后将自动使能VMCS的Guest-state区域中的Guest interrupt status区域。

Virtual-interrupt delivery使能后，物理核会执行Evaluation of Pending Virtual Interrupts。会执行Evaluation of Pending Virtual Interrupts的场景：

1. VM entry;
2. TPR virtualization;
3. EOI virtualization;
4. self-IPI virtualization;
5. posted-interrupt processing。

#### PPR virtualization
从前文可知，VPPR寄存器不允许Guest读取，未启用Virtual-Interrupt Delivery时，它等同于不存在。由于Virtual-Interrupt Delivery功能需要判断Guest的虚拟PPR，因此它在VM Entry、TPR virtualization和EOI virtualization时会自动更新VPPR寄存器的值：

- 若VTPR[7:4] >= SVI[7:4]，则VPPR = VTPR & 0xFF
- 否则，VPPR = SVI & 0xF0

这基本上和APIC中PPR根据TPR和ISRV更新的规则相同，即取两者中大者（优先级更高者），从而屏蔽优先级低于两者中任意一个的中断。

VPPR更新的三个时机，选择的依据如下：
1. VM Entry时，VTPR和SVI的值都可能已被Hypervisor修改过
2. TPR virtualization发生时，VTPR的值被Guest改变
3. EOI virtualization发生时，Guest完成了其当前正在处理的中断，VISR发生变化，从而SVI发生变化（详下）

#### Interrupt Delivery
为了解释Virtual-Interrupt Delivery机制，本节需要介绍一些手册中不涉及的背景知识，以及手册前几章节的内容。

顾名思义，Virtual-Interrupt Delivery引入了对Interrupt Delivery功能的（硬件辅助）虚拟化支持。我们首先回顾通常情况（无虚拟化）下的中断处理：

1. IPI以及外源中断首先是由System Bus上的中断消息到达CPU的APIC而触发的，若CPU发现自己是该中断消息的目标，则会根据中断消息的Vector设置IRR中的相应位（不考虑NMI、SMI、INIT、ExtINT和Start-IPI）。
2. 对于来自本地中断源的中断，省略判断是否接收中断的步骤（因为必定接收），根据LVT表中配置的Vector设置IRR中的相应位
3. 对于IRR中Pending的最高优先级中断，若其优先级高于PPR的优先级，则清空IRR中的对应位，设置ISR中的对应位，并将中断分发给CPU
4. 对于NMI、SMI、INIT、ExtINT以及Start-IPI，直接分发给CPU

为了厘清它们在虚拟化中的实现，我们将它们分解成几个步骤：

1. 对于IPI和外源中断，第一步是中断路由（Interrupt Routing），这一步可以在软件中模拟（非Passthrough情形），例如QEMU会模拟一个设备产生虚拟中断，然后经过INTx来到IOAPIC最后发送到LAPIC的过程
2. 随后的步骤是设置IRR，将中断加入等待队列（不考虑NMI、SMI、INIT、ExtINT和Start-IPI），我们将这一步称为Interrupt Acceptance（中断接受）
3. 对于将中断分发给CPU执行IDT中注册的中断处理例程这一行为，我们称之为Interrupt Delivery（中断交付）
4. 对于NMI、SMI、INIT、ExtINT以及Start-IPI，可以直接进行Interrupt Delivery
5. 否则要先从IRR中取出最高优先级的中断，设置ISR中对应位，这个过程不妨称之为Interrupt Acknowledgement（中断确认），然后才能进行Interrupt Delivery

通常来说，外部中断（此处的外部中断指的是除NMI、SMI、INIT和Start-IPI外的所有中断，与CPU内部异常相对）和发送给Guest的虚拟中断之间没有必然联系，除了它们可能可以通过上述中断路由的过程间接地联系起来。一个外部中断首先由Host处理，然后可能导致Hypervisor生成一个或多个虚拟中断，并经软件模拟的中断路由，最终注入到vCPU（虚拟CPU）中，当然，也可能不产生任何虚拟中断。对于Passthrough给Guest的设备产生的中断，情况略有不同，其物理中断和虚拟中断基本上是一一对应的关系，并且对中断路由的模拟有所简化甚至完全省略。不论如何，虚拟中断的产生和路由都是System-Specific的，对于不同的虚拟化解决方案、不同的虚拟设备都有所不同，这里我们不关心这一步骤是如何完成的。

对于Interrupt Acceptance，一般来说总是需要Hypervisor进行模拟，也就是虚拟中断到达vCPU的虚拟APIC时，要由Hypervisor手动设置VIRR寄存器，这一步即使使用了Virtual-Interrupt Delivery也是一样的（除非使用了Posted Interrupt）。

真正的区别在于Interrupt Acknowledgement和Interrupt Delivery：

首先来看传统的处理方法，Hypervisor会手动设置VIRR和VISR的位，然后通过Event Injection机制在紧接着的下一次VM Entry时注入一个中断向量号，调用Guest的IDT中注册的中断处理例程。如果Guest正处在屏蔽外部中断的状态，即Guest的RFLAGS.IF = 0或Guest Non-Register State.Interruptibility State（VMCS[0x4824](32 bit)）的Bit 0 (Blocking by STI)和Bit 1 (Blocking by MOV-SS)不全为零，将不允许在VM Entry时进行Event Injection。为了向vCPU注入中断，可以临时设置Primary Processor-Based VM-Execution Controls.Interrupt-Window Exiting = 1，然后主动VM Entry进入Non-root模式。一旦CPU进入能够接收中断的状态，即RFLAGS.IF = 1且Interruptibility State[1:0] = 0，便会产生一个VM Exit（VM Exit No.7 Interrupt Window），此时Hypervisor便可注入刚才无法注入的中断，并将Interrupt-Window Exiting重置为0。

Virtual-Interrupt Delivery解决了上述做法中的两个问题，第一个是需要Hypervisor手动模拟Interrupt Acknowledgement、Interrupt Delivery，第二个是有时需要产生Interrupt Window VM Exit以正确注入中断。

具体来说，在进行VM Entry、TPR virtualization、EOI vitualization、Self-IPI virtualization以及Posted-Interrupt proessing时，会进行一个称为evaluate pending virtual interrupts的行为：

- 若Interrupt-Window Exiting = 0，且RVI[7:4] > VPPR[7:4]，则确认一个pending virtual interrupt
- 一旦确认，硬件会持续检查vCPU是否能够接收中断（即RFLAGS.IF = 1且Interruptibility State[1:0] = 0）
  - 若当前已经能接收中断，则立即进行Virtual-Interrupt Delivery
  - 否则令vCPU继续执行，直到vCPU能够接收中断时，进行Virtual-Interrupt Delivery

而所谓的Virtual-Interrupt Delivery，实际上就是进行如下操作：

1. 根据RVI，清除VIRR中对应位，设置VISR中对应位，设置SVI = RVI
2. 设置VPPR = RVI & 0xF0
3. 若VIRR中还有非零位，设置RVI = VIRRV，即VIRR中优先级最高的Vector号，否则设置RVI = 0
4. 根据RVI提供的Vector调用Guest的IDT中注册的中断处理例程

基本上，Virtual-Interrupt Delivery就是用硬件自动执行了我们前文定义的Interrupt Acknowledgement和Interrupt Delivery两个步骤，除了它还需要同步RVI、SVI与VIRRV、VISRV。

现在来考察一下Virtual-Interrupt Delivery的用法：

- 我们仍旧需要在Hypervisor中模拟Interrupt Acceptance，即设置VIRR寄存器
- 但只要设置了RVI，VM Entry时就可以自动进行Interrupt Acknowledgement和Interrupt Delivery，并且硬件会自动阻塞Virtual-Interrupt Delivery直至vCPU允许接收中断，从而避免了此前使用的Interrupt Window VM Exit
- 如果vCPU尚未被调度到，则我们可以在其VIRR寄存器中设置多个位，从而积累多个pending的中断，只要设置RVI为其中优先级最高者，VM Entry后vCPU就会自动对所有pending的中断进行Virtual-Interrupt Delivery，而无需每发送一个中断就VM Exit一次
- 这里的原理是每当vCPU进行EOI时，都会触发EOI virtualization，从而引起下一次Virtual-Interrupt Delivery，整个过程不需要VM Exit。而原本每次进行EOI都要VM Exit到Hypervisor，重新向Guest注入中断。

#### APIC-write Emulation
为了在Non-root模式中不退出地处理VIRR中累积的中断，Virtual-Interrupt Delivery功能引入了APIC-write Emulation，即Guest写入TPR、EOI寄存器以及进行Self-IPI时，除了对Virtual-APIC Page写入，还会进行以下操作：

TPR virtualization：

1. 首先进行PPR virtualization，更新VPPR寄存器的值
2. 其次根据RVI和VPPR的值evaluate pending virtual interrupts

#### EOI virtulization：

1. 根据SVI(Servicing Virtual Interrupt，表示正在处理的中断中最大的Vector)，清除VISR中对应位
2. 若VISR中还有非零位，设置SVI = VISRV，即VISR中优先级最高的Vector号，否则设置SVI = 0
3. 然后进行PPR virtualization，更新VPPR寄存器的值
4. 检查EOI-Exit Bitmap[Vector]，其中Vector为SVI的旧值，即被EOI的中断
   - 若该位为1，则引起VM Exit（VM Exit No.45 Virtualized EOI），Exit Qualification的第0-7位会记录引起VM Exit的Vector值
   - 否则evaluate pending virtual interrupts
   - EOI-Exit Bitmap由4个64位寄存器构成，分别位于VMCS[0x201C]/VMCS[0x201D](64 bit full/high)、VMCS[0x201E]/VMCS[0x201F]、VMCS[0x2020]/VMCS[0x2021]、VMCS[0x2022]/VMCS[0x2023]

Self-IPI virtualization：

1. 根据Self-IPI的Vector，设置VIRR中的对应位
2. 设置RVI = max(RVI, Vector)，其中Vector为Self-IPI的中断向量号
3. 然后evaluate pending virtual interrupts

### Posted Interrupt
Posted Interrupt是对Virtual-Interrupt Delivery的进一步发展，让我们可以省略Interrupt Acceptance的过程，直接令正在运行的vCPU收到一个虚假中断，而不产生VM Exit。它可以向正在运行的vCPU注入中断，配合VT-d的Posted Interrupt功能，还可以实现Passthrough设备的中断直接发给vCPU而不引起VM Exit。

我们可以通过Pin-Based VM-Execution Controls.Process Posted Interrupts[bit 7]开启Posted Interrupt功能，要启用该功能必须先开启Virtualize-Interrupt Delivery以及VM Exit Controls.Acknowledge Interrupt on Exit[bit 15]。

需置位的VMCS Execution control区域如下：

1. pin-based VM-execution controls: external-interrupt exiting、Process posted interrupts
2. primary processor-based VM-executeion controls： Use TPR shadow， Virtual-APIC address、posted-interrupt notification vector、 posted-interrupt descriptor address
3. secondary processor-based VM-executeion controls：APIC register virtualization、Virtual-interrupt delivery

Posted Interrupt，它引入了一个Posted-Interrupt Notification Vector（VMCS[0x0002](16 bit)，仅最低8位有效）和一个64字节（恰好占满一个Cache Line）的Posted-Interrupt Descriptor。后者位于内存中，其地址（HPA）通过Posted-Interrupt Descriptor Address（VMCS[0x2016]/VMCS[0x2017](64 bit full/high)）指定。

在介绍Posted Interrupt之前，首先来回顾一下，Non-root模式下对外部中断（指除NMI、SMI、INIT和Start-IPI外的所有中断）的处理：

当External-Interrupt Exiting = 1时，Non-root模式下接收到外部中断后，会产生VM Exit（VM Exit No.1 External Interrupt），将中断交给Host处理。开启Virtual-Interrupt Delivery的前提就是开启External-Interrupt Exiting。根据Acknowledge Interrupt on Exit的取值，Host对中断有不同的处理：

- 若Acknowledge Interrupt on Exit = 0，则VM Exit后该中断还在IRR中pending，Host应该开中断（即取消中断屏蔽）以调用其IDT中注册的中断处理例程
- 否则，VM Exit时会进行Interrupt Acknowledgement，但不会进行EOI，中断的向量号会存储在VM-Exit Interruption Information（VMCS[0x4404](32 bit)）中，Host应该读取该向量号然后作出相应的处理

回到Posted Interrupt，它引入了一个Posted-Interrupt Notification Vector（VMCS[0x0002](16 bit)，仅最低8位有效）和一个64字节（恰好占满一个Cache Line）的Posted-Interrupt Descriptor。后者位于内存中，其地址（HPA）通过Posted-Interrupt Descriptor Address（VMCS[0x2016]/VMCS[0x2017](64 bit full/high)）指定，格式如下：

- 第0-255位为Posted-Interrupt Requests (PIR)，是一个Bitmap，每个位对应一个Vector
- 第256位为Outstanding Notification (ON)，取1表示有一个Outstanding的Notificaton Event（即中断）尚未处理
- 第257-511位为Available，即允许软件使用的Ignored位

当Non-root模式下收到一个外部中断时，CPU首先完成Interrupt Acceptance和Interrupt Acknowledgement（因为开启Posted Interrupt必先开启Acknowledge Interrupt on Exit），并取得中断的Vector。然后，若Vector与Posted-Interrupt Notification Vector相等，则进入Posted-Interrupt Processing，否则照常产生External Interrupt VM Exit。Posted-Interrupt Processing的过程如下：

1. 清除Descriptor的ON位
2. 向CPU的EOI寄存器写入0，执行EOI，至此在硬件APIC上该中断已经处理完毕
3. 令VIRR |= PIR，并清空PIR
4. 设置RVI = max(RVI, PIRV)，其中PIRV为PIR的旧值中优先级最高的Vector
5. 最后evaluate pending virtual interrupts
其中步骤1和步骤3都是针对Posted-Interrupt Descriptor所在的Cache Line的原子操作，这就是Descriptor正好占满一个Cache Line的原因。

现在来考察一下Posted Interrupt的用法：

假设现在想给一个正在运行的vCPU注入中断，除非该vCPU正在处理中断，否则仅凭Virtual-Interrupt Delivery，仍需要令其VM Exit并设置RVI，以便在VM Entry时触发Virtual-Interrupt Delivery。若使用Posted Interrupt，则可以设置PIR中对应位，然后给vCPU所在的CPU发送一个Notification Event，即中断向量号为Posted-Interrupt Notification Vector的中断，这样vCPU无需VM Exit就可以被注入一个甚至多个中断。