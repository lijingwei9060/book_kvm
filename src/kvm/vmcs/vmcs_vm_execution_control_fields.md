# VM-Execution控制域
VM-Execution控制域用来控制CPU在非根模式运行时的行为，根据虚拟机的实际应用，VMM可以通过配置VM-Execution控制域达到性能优化等目的。VM-Execution控制域主要控制三个方面。

1. 控制某条敏感指令是否产生VM-Exit，如果产生VM-Exit，退出到VMM，由VMM模拟该指令。
2. 在某些敏感指令不产生VM-Exit时，控制该指令的行为，CPU会处理该行为，从指定的地方读写数据。
3. 异常和中断是否产生VM-Exit。

Pin-Based VM-Execution Controls(32bit): 保存针对异步事件退出控制，异步事件指的是中断了。能力判断msr： IA32_VMX_PINBASED_CTLS， IA32_VMX_TRUE_PINBASED_CTLS
1. External-interrupt exiting(bit 0): 置位后，外部中断会导致虚拟机 vm-exit，否则是根据Guest 的IDT表进行中断投递给虚拟机。(是否就是pcie的中断虚拟化呢)
2. NMI exiting(bit 3): 置位后，NMI会导致vm-exit。否则根据Guest的IDT表2号描述处理，就是投递给虚拟机。
3. Virtual NMIs(bit 5): 置位后，NMIs不会被阻塞。If this control is 1, NMIs are never blocked and the “blocking by NMI” bit (bit 3) in the interruptibility-state field indicates “virtual-NMI blocking” (see Table 24-3). This control also interacts with the “NMI-window exiting” VM-execution control (see Section 24.6.2)
4. Activate VMX-preemption timer(bit 6): If this control is 1, the VMX-preemption timer counts down in VMX non-root operation; see Section 25.5.1. A VM exit occurs when the timer counts down to zero; see Section 25.2.
5. Process posted interrupts(bit 7): If this control is 1, the processor treats interrupts with the posted-interrupt notification vector (see Section 24.6.8) specially, updating the virtual-APIC page with posted-interrupt requests (see Section 29.6)

Processor-Based VM-Execution Controls:

异常位图(exception bitmap 32bit): 包含32位异常标志位，如果对应的位置1，对应的异常将导致vm-exit；否则，就投递给虚拟机，根据虚拟机的IDT处理。内存页面异常(page fault vector #14)是否vm-exit会比较复杂，除了14位置位外，还需要error code、vmcs中的page-fault error-code mask 和 page-fault error-code match。

I/O-Bitmap Addresses：保存了2个指向4Kb页面的64位物理地址。IO port 一共有65536个，从0000H-FFFFH，切开对应A和B。如果VM-execution control “**use I/O bitmaps**” 控制位置位，并且bitmap中的标志位也是置位，读写IO port(IO, OUT)会导致vm-exit。


## 控制寄存器 CR0/CR4 加速
CR0是一个控制寄存器，控制处理器的状态，如启动保护模式、打开分页机制。操作CR0的指令有MOV TO CR0、MOV FROM CR0、CLTS和LMSW，这些指令必须在特权级0执行，否则产生保护异常。
在硬件辅助的虚拟机中，虽然CR0的访问同样需要VMM模拟处理，但是VT-x提供了加速方法，能够减少因访问CR0所引起的VM-Exit的次数。首先，VMCS的“VM-Execution控制域”中的CR0 read shadow字段来加速客户机读CR0的指令。每次客户机试图写CR0时，该字段都会自动得到更新，保存客户机要写的值。这样，客户机所有读CR0的指令都不用产生VM-Exit，CPU只要返回CR0 read shadow的值即可。其次，VMCS的“VM-Execution控制域”的CRO guest/host Mask字段提供了客户机写CR0指令的加速。该字段每一位和CR0的每一位对应，表示CR0对应的位是否可以被客户机软件修改。若为0，表示CR0中对应的位可以被客户机软件修改，不产生VM-Exit；若为1，表示CR0中对应的位不能被客户机软件修改，如果客户机软件修改该位，则产生VM-Exit。同样的机制被用于加速CR4的访问。该优化属于条件优化。

## CR2加速
在发生缺页异常时，CR2保存产生缺页错误的虚拟地址。缺页错误处理程序通常会读取CR2获得产生该错误的虚拟地址。缺页错误时一个发生频率比较高的异常，这决定了读取CR2是一个高频率的操作。读取CR2必须在特权级0上执行，否则产生保护错误。

在基于软件的完全虚拟化技术的虚拟机中，客户机操作系统是在特权级1、特权级2上执行读取CR2指令，产生保护错误，需要VMM模拟该指令。

使用Intel VT-x技术，VM-Entry/VM-Exit时会切换CR2。并且，客户机操作系统是在非根模式的特权级0执行读取CR2指令，不产生保护错误，故无须VMM模拟该指令，此外，如果客户机在特权级0以外的级别执行读CR2指令，会产生保护错误，该错误是否引发VM-Exit由Exception bitmap控制。该优化属于无条件优化。
## TSC访问加速
在纯虚拟机软件中，因为读取TSC可以在任何特权级别执行，VMM必须想办法截获TSC读取指令。  
在硬件辅助的虚拟机中，当“VM-Execution控制域”中**RDTSC exiting**字段为1时，客户软件执行RDTSC产生VM-Exit，由VMM模拟该指令。客户机读取TSC在某些操作系统里是一个非常频繁的操作，为了提高效率，VT-x提供了下面的硬件加速。当VMCS中RDTSC exiting为1且**Use TSC offset**为1时，硬件加速有效。VMCS中TSC偏移量表示该VMCS所代表的的虚拟CPU TSC相对于物理CPU TSC的偏移，即虚拟TSC = 物理TSC + TSC偏移量。 当客户机软件执行RDTSC时，处理器直接返回虚拟TSC，不产生VM-Exit。这样，对TSC的虚拟化只需要适时地更新VMCS中TSC偏移量即可，不需要每次TSC访问都产生VM-Exit，大大提高了TSC访问的效率。该优化属于条件优化。

## GDTR/LDTR/IDTR/TR加速
在基于软件的完全虚拟化技术的虚拟机中，客户机操作系统是运行在特权级1、特权级2上，执行LGDT、LIDT、LLDT和LTR指令，会产生保护异常，需要VMM模拟这些指令的执行。在模拟的过程中，对于不同的情况，还有很多复杂的处理。例如，客户机操作系统在GDT（全局描述符表）中，为自身内核段设置的描述符的DPL（描述符特权级）是0（特权级最高）。由于它本身运行在非特权级0上，所以VMM要通过截获LGDT指令，对GDT中的描述符进行修改。同时，像SGDT这样的指令可以在任何特权级下执行，客户机操作系统中的程序只需要读取GDT并判断描述符的DPL就知道自身运行在虚拟机环境下，这也是一个虚拟化的漏洞。

使用Intel VT-x技术，VMCS为客户机和VMM都提供了一套GDTR、IDTR、LDTR和TR，分别保存在客户机状态域和宿主机状态域中（宿主机状态域不包括LDTR，VMM不需要使用它），由硬件切换。而客户机运行在非根模式的特权级0，所以也无须对GDT表等作出任何修改，客户机执行LGDT等指令也无须产生VM-Exit。这样的优化大大降低了VMM的复杂度，使实现一个VMM变得简单。该优化属于无条件优化。

## SYSENTER/SYSEXIT 加速
早期的系统调用是通过INT指令和IRET指令实现的。在当前主流的IA32 CPU中，Intel推出了经过优化的SYSENTER/SYSEXIT指令以提高效率。现代操作系统都倾向于使用SYSENTER/SYSEXIT实现系统调用。

SYSENTER指令要求跳转的目标代码段运行在特权级0，否则产生保护错误。在软件虚拟化技术中，客户操作系统运行在特权级1、特权级2，当客户应用程序执行SYSENTER会产生保护错误，需要由VMM模拟SYSENTER指令。SYSEXIT指令必须在特权级0执行，否则产生保护错误。和SYSENTER一样，SYSEXIT在软件虚拟化技术中必须由VMM模拟。

使用Intel VT-x技术，客户操作系统运行在非根模式的特权级0，SYSENTER/SYSEXIT都不会引起VM-Exit，即客户机操作系统的系统调用无须VMM干预而直接执行。该优化属于无条件优化。

## APIC访问控制

对于现代主流的支持SMP的操作系统来说，LAPIC（高级可编程中断控制器）在中断的递交中扮演着一个非常重要的角色。LAPIC里面有很多寄存器，通常操作系统会以MMIO（内存映射I/O）方式来访问它们。在这些寄存器里，操作系统使用其中的TPR（Task Priority Register）来屏蔽中断优先级小于或者等于TPR的外部中断。

通过虚拟化客户机的MMU，当客户机试图访问LAPIC时，会发生一个缺页异常类型的VM-Exit，从而被VMM拦截到。VMM经过分析，知道客户机正在试图访问LAPIC后，就会模拟客户机对LAPIC的访问。通常，对于客户机的每一个虚拟CPU，VMM都会分配一个虚拟LAPIC结构与之对应，客户机的MMIO操作不会真的影响物理的LAPIC，而只是反映到相应的虚拟LAPIC结构里面。VMM的这种模拟有相当大的开销，如果客户机的每一个LAPIC访问都导致一次缺页异常类型的VM-Exit并由VMM模拟的话，会严重影响到客户机的性能。

针对这种情况，VT-x提供了硬件加速支持。可以设置VMCS中的Use TPR shadow = 1，Virtualize APIC accesses = 1，设置Virtual APIC page为虚拟LAPIC结构的地址，同时修改VCPU页表，使得客户机访问LAPIC时不发生Page Fault（这需要相应地设置VMCS中的Virtual-APIC address寄存器）。同时，对于那些暂时不能注入客户机的中断（如果有的话），还需要挑出优先级最高的那个（就是向量号最大的那个），将其优先级填入VMCS中的TPR threshold寄存器。

这样设置后，对于除了TPR以外的LAPIC寄存器的访问，客户机会直接发生APIC-Access类型的VM-Exit。此时，CPU可告知VMM客户机正试图访问哪个LAPIC寄存器，这可降低VMM对客户机此次访问的模拟开销；而客户机对TPR的读操作则可以直接从虚拟LAPIC结构中的相应偏移出读取而无须发生任何VM-Exit。最后，客户机对TPR的写操作只在必要的时候（客户机把TPR减小到比TPR threshold还要小的时候）才发生TPR-Below-Threshold类型的VM-Exit，这种情况下VMM可检测是否有虚拟中断可以注入客户机。

上面谈到TPR寄存器时，说是用MMIO方式来访问的，其实对于64位的x86平台，专门有一个特别的系统控制寄存器CR8被映射到了TPR（读写CR8就等效于读写TPR），64位的客户机通常CR8寄存器来访问TPR。当客户机试图访问CR8时，会发生一个Control-Register-Accesses类型的VM-Exit。为了更快地模拟客户机对CR8的访问，除了上面提到的设置外，可以设置VMCS中的CR8-load exiting = 0和CR8-store exiting = 0。这样，客户机读CR8时，CPU可以从虚拟LAPIC结构中相应的偏移处直接返回正确的值，而不会发生任何VM-Exit；当客户机写CR8时，只在必要的时候才发生TPR-Below-Threshold类型的VM-Exit。

## 异常控制

在基于软件的完全虚拟化技术中，客户机产生的异常都会被VMM截获，由VMM决定如何处理，通常是注入给客户机操作系统。

使用Intel VT-x技术，可以用Exception bitmap配置哪些异常需要由VMM截获。对于不需要VMM截获的异常，可以将Exception bitmap中对应的位置为1，则异常发生时直接由客户机操作系统处理。这样的优化可以大大减少由客户机异常引起的VM-Exit。该优化属于条件优化。

## I/O控制

在基于软件的完全虚拟化技术中，VMM需要截获I/O指令来实现I/O虚拟化。但由于I/O指令通过设置可以在特权级3执行，截获I/O指令需要额外的处理。

使用Intel VT-x技术，可以通过VMCS的Unconditional I/O exiting、Use I/O bitmaps、I/O bitmap进行配置，选择性地让I/O访问产生VM-Exit而陷入VMM中。这样，对于不需要模拟的I/O端口，可以让客户机直接访问。该优化属于条件优化。

## MSR优化
x86包括很多MSR寄存器，使用Intel VT-x和I/O控制一样，可以通过use MSR bitmaps、 MSR bitmap来控制对MSR的访问是否触发VM-Exit。该优化属于条件优化。