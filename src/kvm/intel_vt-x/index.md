# 概述

Intel Virtual-Machine eXtensions (VMX)(也叫 Intel VT-x)，是 Intel 处理器提供的硬件虚拟化的技术。虽然同为 x86 架构，但 AMD 与 Intel 的硬件虚拟化技术不同，AMD 的被称为 SVM 或 AMD-V。

在处理器使能 VMX 后，将具有两种运行模式 (统称 VMX operation)：

- VMX root operation：即 host 模式，运行 hypervisor。
- VMX non-root operation：即 guest 模式，运行 guest 软件。

VMX operation 可以和 x86 特权级相结合，如 VMX non-root ring-0 表示 guest 内核态，运行 guest OS；VMX non-root ring-3 表示 guest 用户态，运行 guest 用户程序。

为了配置 VMX non-root operation 的进入、运行、退出，以及保存 guest 的状态，VMX 中还有一个重要数据结构 Virtual-Machine Control Structure (VMCS)，我们将在 Step 2 详细介绍。

此外 VMX 还提供了一些额外的指令，主要有：

指令	描述
1. VMXON	使能 VMX，进入 VMX (root) operation
2. VMXOFF	退出 VMX operation
3. VMCLEAR	清除指定 VMCS，使得其可以被激活
4. VMPTRLD	在当前 CPU 上激活指定 VMCS，使其成为当前 VMCS
5. VMREAD	读当前 VMCS 字段
6. VMWRITE	写当前 VMCS 字段
7. VMLAUNCH	进入 VMX non-root operation (当前 VMCS 首次进入)
9. VMRESUME	进入 VMX non-root operation (当前 VMCS 非首次进入)
10. VMCALL	在 VMX non-root operation 执行，触发 VM exit，从而调用 hypervisor 的功能 (类似 syscall)


## 使能VMX


1. 对于 CPU 支持情况，是通过 CPUID 指令 查询 Processor Info and Feature Bits (EAX=1) 中的相关位获知。
2. 对于 BIOS 支持情况，需要查询 `IA32_FEATURE_CONTROL` MSR 的以下两位(从技术上讲为什么要BIOS支持呢?)：
   1. Bit 0 lock bit：如果设置，无法修改该 MSR；如果不设置，无法执行 VMXON。
   2. Bit 2 enables VMXON outside SMX operation：如果不设置，无法 (在 SMX 模式外) 执行 VMXON。

我们希望这两个位都已被设为了 1，否则就要重新设置。不过在 bit 0 为 1，而 bit 2 为 0 时，我们既无法使用 VMXON 指令，又无法修改该 MSR。此时说明 VMX 被 BIOS 禁用，需要在 BIOS 中手动开启。

1. 先将 CR4 的 VMXE 位 (13 位) 设为 1。
2. 创建 VMXON region, 4K大小并4K对齐，物理地址作为VMXON指令参数。前 4 字节的低 31 位需要设置为 VMCS revision identifier，该值可以在 `IA32_VMX_BASIC` MSR 的低 31 位中查到。
3. 每个CPU 各自执行一遍 VMXON 指令，并提供不同的 VMXON region。


## VMCS

VMCS 是一个存储在内存中的数据结构，和 vCPU 一一对应，每有一个 vCPU 都需要配置其相应的 VMCS。其中的字段除了用于存储 guest/host 状态外，还用于控制虚拟化的行为，具体包括以下几类：

1. Guest-state area：在 VM exit 时，guest 的状态会被保存到该区域，并在 VM entry 时从该区域恢复。
2. Host-state area：在 VM exit 时，host 的状态会从该区域恢复 (VM entry 时不保存)。
3. VM execution/entry/exit control fields：对运行、进入、退出 non-root 模式时处理器的行为进行配置，如配置哪些情况下会发生 VM exit。
4. VM exit information fields：只读字段，报告 VM exit 发生时的一些信息，如发生 VM exit 的原因。


VMCS 所在的内存被称为 VMCS region，与 VMXON region 一样，也是 4KB 大小 4KB 对齐的，且需要向前 4 字节写入 VMCS revision identifier。VMCS region 的物理地址被称为 VMCS pointer。

物理 CPU 在首次进入 non-root 模式之前，需要先激活 vCPU 对应的 VMCS，方法是依次执行以下两条指令 (VMCS pointer 作为操作数)：

1. VMCLEAR：将该 VMCS 设为“干净的”，使得其可以被激活。
2. VMPTRLD：将该 VMCS 激活，即将该 VMCS 与当前物理 CPU 绑定，该 VMCS 就被称为“当前 VMCS”，之后的 VMREAD/VMWRITE/VMLAUNCH/VMRESUME 指令只对当前 VMCS 生效。对应的还有 VMPTRST 指令，用于取得当前的 VMCS pointer (在本项目中不需要用到)。
3. 访问 VMCS 中的字段不能直接使用内存读写指令，而是要用专门的 VMREAD/VMWRITE 指令。


### VMCS Host state Area

VMCS host 状态会在发生 VM exit 而从 non-root 切换回 root 时，从 VMCS 自动加载进处理器中，但无需在 VM entry 时保存。这些状态主要包括：

- 控制寄存器：CR0、CR3、CR4。
- 指令指针与栈指针：RIP、RSP。
- 段选择子 (selector)：CS、SS、DS、ES、FS、GS、TR。
- 段基址 (base address)：FS base、GS base、TR base、GDTR base、IDTR base。
- 一些 MSR，如 IA32_PAT、IA32_EFER。

在配置时，一般直接将它们设为当前 (host) 的状态即可。但是 RIP 应该设为 VM exit 处理函数的地址，RSP 应该设为处理 VM exit 时的栈指针。

需要注意，VMCS 也不是包含了所有的机器状态，如 RAX、RBX 等通用寄存器就不在 VMCS 字段中，因此它们需要在 VM entry/exit 时由软件实现保存与恢复。


### VMCS Guest State Area

VMCS guest 状态会在发生 VM entry 时从 VMCS 自动加载进处理器中，并在 VM exit 时自动保存到 VMCS 中。这些状态主要包括：

1. 控制寄存器：CR0、CR3、CR4。
2. RIP、RSP、RFLAGS。
3. 完整的段寄存器：即 CS、SS、DS、ES、FS、GS、TR 段的选择子、基址、界限 (limit) 与访问权限 (access rights)。
4. GDTR 与 IDTR 的基址与界限。
5. 一些 MSR，如 IA32_PAT、IA32_EFER。

在设置时，还需要考虑 guest 的运行模式。在 x86 下，运行模式包括 16 位实模式、32 位保护模式、64 位 IA-32e 模式，不同的运行模式需要配置好对应的段寄存器访问权限。其中 CS 段寄存器的访问权限还指示了 guest 的当前特权级 (CPL)。


### VM-Execution Control Fields
这些字段用于控制在 non-root 模式运行时处理器的行为。常用的有以下几个：

1. Pin-based VM-execution controls：用于配置 hypervisor 对 guest 异步事件的拦截 (例如中断)，是由hypervisor处理还是有Guest处理。例如vfio就是用这个能力，拦截中断，通过eventfd注入中断。
2. Processor-based VM-execution controls：又可分为 primary processor-based 和 secondary processor-based，用于配置 hypervisor 对 guest 同步事件的拦截 (例如执行特定的指令)。
3. Exception bitmap：用于配置 hypervsior 对 guest 异常的拦截。
4. I/O-bitmap address：用于配置 hypervisor 对 guest 读写特定 I/O 端口的拦截。
5. MSR-bitmap address：用于配置 hypervisor 对 guest 读写特定 MSR 的拦截。
6. Extended-page-table pointer：指定扩展页表 (EPT) 的基址。(Step 4)

以上字段除了带 address、pointer 外的都是一个 bitmap，将相应的位设为 1 或 0 就表示启用或关闭了相应的功能。

需要注意，对 pin-based、primary processor-based、secondary processor-based VM-execution controls 以及下文的 VM-exit controls、VM-entry controls 的配置较为繁琐。因为同一个字段，不同的 CPU 对各个位的支持情况 (默认值和允许值) 不同，需要根据支持情况设置未用到的位的默认值。感兴趣的参见代码或 SDM Vol. 3D 附录 A.2 ~ A.5。

Pin-Based VM-Execution Controls(32bit): 保存针对异步事件退出控制，异步事件指的是中断了。能力判断msr： IA32_VMX_PINBASED_CTLS， IA32_VMX_TRUE_PINBASED_CTLS
1. External-interrupt exiting(bit 0): 置位后，外部中断会导致虚拟机 vm-exit，否则是根据Guest 的IDT表进行中断投递给虚拟机。(是否就是pcie的中断虚拟化呢)
2. NMI exiting(bit 3): 置位后，NMI会导致vm-exit。否则根据Guest的IDT表2号描述处理，就是投递给虚拟机。
3. Virtual NMIs(bit 5): 置位后，NMIs不会被阻塞。If this control is 1, NMIs are never blocked and the “blocking by NMI” bit (bit 3) in the interruptibility-state field indicates “virtual-NMI blocking” (see Table 24-3). This control also interacts with the “NMI-window exiting” VM-execution control (see Section 24.6.2)
4. Activate VMX-preemption timer(bit 6): If this control is 1, the VMX-preemption timer counts down in VMX non-root operation; see Section 25.5.1. A VM exit occurs when the timer counts down to zero; see Section 25.2.
5. Process posted interrupts(bit 7): If this control is 1, the processor treats interrupts with the posted-interrupt notification vector (see Section 24.6.8) specially, updating the virtual-APIC page with posted-interrupt requests (see Section 29.6)

Processor-Based VM-Execution Controls:

异常位图(exception bitmap 32bit): 包含32位异常标志位，如果对应的位置1，对应的异常将导致vm-exit；否则，就投递给虚拟机，根据虚拟机的IDT处理。内存页面异常(page fault vector #14)是否vm-exit会比较复杂，除了14位置位外，还需要error code、vmcs中的page-fault error-code mask 和 page-fault error-code match。

I/O-Bitmap Addresses：保存了2个指向4Kb页面的64位物理地址。IO port 一共有65536个，从0000H-FFFFH，切开对应A和B。如果VM-execution control “**use I/O bitmaps**” 控制位置位，并且bitmap中的标志位也是置位，读写IO port(IO, OUT)会导致vm-exit。

#### 控制寄存器 CR0/CR4 加速
有4个控制字段：
1. Guest/Host Masks for CR0 
2. Guest/Host Masks for CR4 
3. Read Shadows for CR0
4. Read Shadows for CR4

CR0是一个控制寄存器，控制处理器的状态，如启动保护模式、打开分页机制。操作CR0的指令有MOV TO CR0、MOV FROM CR0、CLTS和LMSW，这些指令必须在特权级0执行，否则产生保护异常。
在硬件辅助的虚拟机中，虽然CR0的访问同样需要VMM模拟处理，但是VT-x提供了加速方法，能够减少因访问CR0所引起的VM-Exit的次数。首先，VMCS的“VM-Execution控制域”中的CR0 read shadow字段来加速客户机读CR0的指令。每次客户机试图写CR0时，该字段都会自动得到更新，保存客户机要写的值。这样，客户机所有读CR0的指令都不用产生VM-Exit，CPU只要返回CR0 read shadow的值即可。其次，VMCS的“VM-Execution控制域”的CRO guest/host Mask字段提供了客户机写CR0指令的加速。该字段每一位和CR0的每一位对应，表示CR0对应的位是否可以被客户机软件修改。若为0，表示CR0中对应的位可以被客户机软件修改，不产生VM-Exit；若为1，表示CR0中对应的位不能被客户机软件修改，如果客户机软件修改该位，则产生VM-Exit。同样的机制被用于加速CR4的访问。该优化属于条件优化。

#### CR2加速
在发生缺页异常时，CR2保存产生缺页错误的虚拟地址。缺页错误处理程序通常会读取CR2获得产生该错误的虚拟地址。缺页错误时一个发生频率比较高的异常，这决定了读取CR2是一个高频率的操作。读取CR2必须在特权级0上执行，否则产生保护错误。

在基于软件的完全虚拟化技术的虚拟机中，客户机操作系统是在特权级1、特权级2上执行读取CR2指令，产生保护错误，需要VMM模拟该指令。

使用Intel VT-x技术，VM-Entry/VM-Exit时会切换CR2。并且，客户机操作系统是在非根模式的特权级0执行读取CR2指令，不产生保护错误，故无须VMM模拟该指令，此外，如果客户机在特权级0以外的级别执行读CR2指令，会产生保护错误，该错误是否引发VM-Exit由Exception bitmap控制。该优化属于无条件优化。

#### TSC访问加速
相关控制字段：
Primary processor-based VM-execution controls
    Use TSC offsetting
    RDTSC exiting
TSC-offset

在纯虚拟机软件中，因为读取TSC可以在任何特权级别执行，VMM必须想办法截获TSC读取指令。  
在硬件辅助的虚拟机中，当“VM-Execution控制域”中**RDTSC exiting**字段为1时，客户软件执行RDTSC产生VM-Exit，由VMM模拟该指令。客户机读取TSC在某些操作系统里是一个非常频繁的操作，为了提高效率，VT-x提供了下面的硬件加速。当VMCS中RDTSC exiting为1且**Use TSC offset**为1时，硬件加速有效。VMCS中TSC偏移量表示该VMCS所代表的的虚拟CPU TSC相对于物理CPU TSC的偏移，即虚拟TSC = 物理TSC + TSC偏移量。 当客户机软件执行RDTSC时，处理器直接返回虚拟TSC，不产生VM-Exit。这样，对TSC的虚拟化只需要适时地更新VMCS中TSC偏移量即可，不需要每次TSC访问都产生VM-Exit，大大提高了TSC访问的效率。该优化属于条件优化。

#### GDTR/LDTR/IDTR/TR加速
在基于软件的完全虚拟化技术的虚拟机中，客户机操作系统是运行在特权级1、特权级2上，执行LGDT、LIDT、LLDT和LTR指令，会产生保护异常，需要VMM模拟这些指令的执行。在模拟的过程中，对于不同的情况，还有很多复杂的处理。例如，客户机操作系统在GDT（全局描述符表）中，为自身内核段设置的描述符的DPL（描述符特权级）是0（特权级最高）。由于它本身运行在非特权级0上，所以VMM要通过截获LGDT指令，对GDT中的描述符进行修改。同时，像SGDT这样的指令可以在任何特权级下执行，客户机操作系统中的程序只需要读取GDT并判断描述符的DPL就知道自身运行在虚拟机环境下，这也是一个虚拟化的漏洞。

使用Intel VT-x技术，VMCS为客户机和VMM都提供了一套GDTR、IDTR、LDTR和TR，分别保存在客户机状态域和宿主机状态域中（宿主机状态域不包括LDTR，VMM不需要使用它），由硬件切换。而客户机运行在非根模式的特权级0，所以也无须对GDT表等作出任何修改，客户机执行LGDT等指令也无须产生VM-Exit。这样的优化大大降低了VMM的复杂度，使实现一个VMM变得简单。该优化属于无条件优化。


#### SYSENTER/SYSEXIT 加速
早期的系统调用是通过INT指令和IRET指令实现的。在当前主流的IA32 CPU中，Intel推出了经过优化的SYSENTER/SYSEXIT指令以提高效率。现代操作系统都倾向于使用SYSENTER/SYSEXIT实现系统调用。

SYSENTER指令要求跳转的目标代码段运行在特权级0，否则产生保护错误。在软件虚拟化技术中，客户操作系统运行在特权级1、特权级2，当客户应用程序执行SYSENTER会产生保护错误，需要由VMM模拟SYSENTER指令。SYSEXIT指令必须在特权级0执行，否则产生保护错误。和SYSENTER一样，SYSEXIT在软件虚拟化技术中必须由VMM模拟。

使用Intel VT-x技术，客户操作系统运行在非根模式的特权级0，SYSENTER/SYSEXIT都不会引起VM-Exit，即客户机操作系统的系统调用无须VMM干预而直接执行。该优化属于无条件优化。


#### APIC访问控制

相关字段：
Primary processor-based VM-execution controls
    CR8-load exiting
    CR8-store exiting
    Use TPR shadow
Secondary processor-based VM-execution controls
    Virtualize APIC accesses
    Virtualize x2APIC mode
    APIC-register virtualization

APIC Virtualization 
    APIC-access address 
    Virtual-APIC address 
    TPR threshold 
    EOI-exit bitmap 0 
    EOI-exit bitmap 1 
    EOI-exit bitmap 2 
    EOI-exit bitmap 3 
    Posted-interrupt notification vector 
    Posted-interrupt descriptor address

对于现代主流的支持SMP的操作系统来说，LAPIC（高级可编程中断控制器）在中断的递交中扮演着一个非常重要的角色。LAPIC里面有很多寄存器，通常操作系统会以MMIO（内存映射I/O）方式来访问它们。在这些寄存器里，操作系统使用其中的TPR（Task Priority Register）来屏蔽中断优先级小于或者等于TPR的外部中断。

通过虚拟化客户机的MMU，当客户机试图访问LAPIC时，会发生一个缺页异常类型的VM-Exit，从而被VMM拦截到。VMM经过分析，知道客户机正在试图访问LAPIC后，就会模拟客户机对LAPIC的访问。通常，对于客户机的每一个虚拟CPU，VMM都会分配一个虚拟LAPIC结构与之对应，客户机的MMIO操作不会真的影响物理的LAPIC，而只是反映到相应的虚拟LAPIC结构里面。VMM的这种模拟有相当大的开销，如果客户机的每一个LAPIC访问都导致一次缺页异常类型的VM-Exit并由VMM模拟的话，会严重影响到客户机的性能。

针对这种情况，VT-x提供了硬件加速支持。可以设置VMCS中的Use TPR shadow = 1，Virtualize APIC accesses = 1，设置Virtual APIC page为虚拟LAPIC结构的地址，同时修改VCPU页表，使得客户机访问LAPIC时不发生Page Fault（这需要相应地设置VMCS中的Virtual-APIC address寄存器）。同时，对于那些暂时不能注入客户机的中断（如果有的话），还需要挑出优先级最高的那个（就是向量号最大的那个），将其优先级填入VMCS中的TPR threshold寄存器。

这样设置后，对于除了TPR以外的LAPIC寄存器的访问，客户机会直接发生APIC-Access类型的VM-Exit。此时，CPU可告知VMM客户机正试图访问哪个LAPIC寄存器，这可降低VMM对客户机此次访问的模拟开销；而客户机对TPR的读操作则可以直接从虚拟LAPIC结构中的相应偏移出读取而无须发生任何VM-Exit。最后，客户机对TPR的写操作只在必要的时候（客户机把TPR减小到比TPR threshold还要小的时候）才发生TPR-Below-Threshold类型的VM-Exit，这种情况下VMM可检测是否有虚拟中断可以注入客户机。

上面谈到TPR寄存器时，说是用MMIO方式来访问的，其实对于64位的x86平台，专门有一个特别的系统控制寄存器CR8被映射到了TPR（读写CR8就等效于读写TPR），64位的客户机通常CR8寄存器来访问TPR。当客户机试图访问CR8时，会发生一个Control-Register-Accesses类型的VM-Exit。为了更快地模拟客户机对CR8的访问，除了上面提到的设置外，可以设置VMCS中的CR8-load exiting = 0和CR8-store exiting = 0。这样，客户机读CR8时，CPU可以从虚拟LAPIC结构中相应的偏移处直接返回正确的值，而不会发生任何VM-Exit；当客户机写CR8时，只在必要的时候才发生TPR-Below-Threshold类型的VM-Exit。

#### 异常控制
相关字段：
Exception Bitmap

在基于软件的完全虚拟化技术中，客户机产生的异常都会被VMM截获，由VMM决定如何处理，通常是注入给客户机操作系统。

使用Intel VT-x技术，可以用Exception bitmap配置哪些异常需要由VMM截获。对于不需要VMM截获的异常，可以将Exception bitmap中对应的位置为1，则异常发生时直接由客户机操作系统处理。这样的优化可以大大减少由客户机异常引起的VM-Exit。该优化属于条件优化。

#### I/O控制

相关字段：
Primary processor-based VM-execution controls
    Unconditional I/O exiting
    Use I/O bitmaps
    I/O-Bitmap Addresses

在基于软件的完全虚拟化技术中，VMM需要截获I/O指令来实现I/O虚拟化。但由于I/O指令通过设置可以在特权级3执行，截获I/O指令需要额外的处理。

使用Intel VT-x技术，可以通过VMCS的Unconditional I/O exiting、Use I/O bitmaps、I/O bitmap进行配置，选择性地让I/O访问产生VM-Exit而陷入VMM中。这样，对于不需要模拟的I/O端口，可以让客户机直接访问。该优化属于条件优化。

#### MSR优化

相关字段：
Primary processor-based VM-execution controls
    Use MSR bitmaps
Read bitmap for low MSRs 
Read bitmap for high MSRs 
Write bitmap for low MSRs 
Write bitmap for low MSRs

x86包括很多MSR寄存器，使用Intel VT-x和I/O控制一样，可以通过use MSR bitmaps、 MSR bitmap来控制对MSR的访问是否触发VM-Exit。该优化属于条件优化。

### VM-Exit Control Fields
这些字段用于控制在 VM exit 发生时处理器的行为。除了 VM-exit controls 外，还有：

1. VM-exit MSR-store count、VM-exit MSR-store address：VM exit 时要保存的 (guest) MSR 数量与内存区域。
2. VM-exit MSR-load count、VM-exit MSR-load address：VM exit 时要载入的 (host) MSR 数量与内存区域。

因为除了 IA32_EFER、IA32_PAT 等少量 MSR 外，VMCS 中没有空间存储其他 MSR 了，因此在这里指定了一个要额外保存与恢复的 MSR 的列表。这样的设计也使得在 VM exit 时避免切换不常用的 MSR，从而减少 guest 与 host 间的切换开销。VM-entry control fields 中也有类似的字段。

### VM-Entry Control Fields
这些字段用于控制在 VM entry 发生时处理器的行为。除了 VM-entry controls 外，还有：

1. VM-entry MSR-load count、VM-entry MSR-load address：VM entry 时要载入的 (guest) MSR 数量与内存区域。
2. VM-entry interruption-information field：用于向 guest 注入虚拟中断或异常。(Step 6)