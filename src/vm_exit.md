# VM-Exit
VM-Exit是指CPU从非根模式切换到根模式，从客户机切换到VMM的操作。引发VM-Exit的原因很多，例如在非根模式执行了敏感指令、发生了中断等。处理VM-Exit时间是VMM模拟指令、虚拟特权资源的一大任务。

# VM-Exit control fields
VM-Exit控制域规定了VM-Exit发生时CPU的行为，下图描述了该域的内容。
1. Host Address Space： 在支持Intel 64架构的处理器上，此位决定了在下一次VM-Exit后处理器是否处于64位模式，64bit的VMM需要打开这一位。
2. Acknownledge interrpt on exit： 当一个外部中断引起VM-Exit时，是否应答中断控制器。
3. VM-EXIT MSR-store count: 制定vm-exit发生时，CPU要保存的MSR数目。
4. VM-EXIT MSR-store address: 制定了要保存的MSR区域的物理地址。
5. VM-Exit MSR-load count： 指定VM-EXIT发生时，cpu要装载的MSR数目
6. VM-Exit MSR-load address：制定了要装在的MSR区域的物理地址

# VM-Exit信息域
VMM除了要通过VM-Exit控制域来控制VM-Exit的行为外，还需要知道VM-Exit的相关信息（如退出原因）。VM-Exit信息域满足了这个要求，其提供的信息可以分为如下4类。
1. 基本的VM-exit信息：包括基本原因(Exit Reason 32bit)、进一步原因(Exit qualification 64bit，debug exceptions; page-fault exceptions; start-up IPIs (SIPIs); task switches; INVEPT; INVLPG;INVVPID; LGDT; LIDT; LLDT; LTR; SGDT; SIDT; SLDT; STR; VMCLEAR; VMPTRLD; VMPTRST; VMREAD; VMWRITE; VMXON; XRSTORS; XSAVES; control register accesses; MOV DR; I/O instructions; and MWAIT.)、GVA(Guest-linear address，LMSW，INS、OUTS，IO后紧跟SMIs，EPT violation)、GPA(Guest-physical address, EPT misconfig和EPT violation时设置)。
2. 由于向量事件导致vm exit的信息：事件包括异常(exceptions,  包括指令发出的INT3(调试断点异常), INTO(溢出异常), INT1(调试异常), BOUND(边界检查异常), UD0(非法指令异常), UD1, and UD2), 外部中断( “**acknowledge interrupt on exit**” VM-exit control is 1)和NMI。提供的信息**VM-exit interruption information** (32bit)和 **VM-exit interruption error code** (32bit)。VM-exit interruption information提供中断向量号、中断类型；VM-exit interruption error code保存硬件异常投递的error code。
3. 由于事件投递导致vm exit的信息：包括在VM Entry阶段的中断注入信息和VMX non-root模式下的中断注入导致vm-exit所需要的信息，包括**IDT-vectoring information**和**IDT-vectoring error code**，内容类似。
4. 由于指令执行导致vm exit的信息：在VMX non-root模式下执行特殊指令导致vm-exit，包含**VM-exit instruction length** (32 bits)和**VM-exit instruction information**(32 bits)(指令： INS, INVEPT, INVVPID, LIDT, LGDT, LLDT, LTR, OUTS, SIDT, SGDT, SLDT, STR, VMCLEAR, VMPTRLD, VMPTRST, VMREAD, VMWRITE, or VMXON.).
5. error fields：
   
# VM-Exit的具体过程
当一个VM-Exit发生时，依次执行下列步骤。

1. CPU首先将此次VM-Exit的原因信息记录到VMCS相应的信息域中，VM-Entry interruption-information字段的有效位（bit 31）被清零。
2. CPU状态被保存到VMCS客户机状态域。根据设置，CPU也可能将客户机的MSR保存到VM-Exit MSR-store区域。
3. 根据VMCS中宿主机状态域和VM-Exit控制域中的设置，将宿主机状态加载到CPU相应寄存器。CPU也可能根据VM-Exit MSR-store区域来加载VMM的MSR。
4. CPU由非根模式切换到了根模式，从宿主机状态域中CS：RIP指定的VM-Exit入口函数开始执行, 在vcpu_enter_guest里面配置vm-exit后的rip，最后调用static_call(kvm_x86_handle_exit)(vcpu, exit_fastpath)。

int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
    ret = __vmx_handle_exit(vcpu, exit_fastpath)
        1. enable_pml && !is_guest_mode(vcpu)： 启动pml并且不是guest模式，清空gpa pml buffer，更新dirty_bitmap
        2. KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm)： 嵌套的kvm
        3. 嵌套的kvm，pml是不能启用的，如果突出原因是pml满了，又是l2就是有问题。


在VMM处理完VM-Exit后，会通过VMLAUNCH/VMRESUME指令发起VM-Entry进而重新运行客户机。当下一次VM-Exit发生后，又会重复上述处理流程。虚拟化的所有内容就在VMM -> 客户机 -> VMM -> ……的不断切换中完成。
# vm exit reason

1. 无条件事件： CPUID， INVD， MOV from CR3, VMCALL, VMCLEAR, VMLAUNCH, VMPTRLD， VMPTRST, VMREAD， VMRESUME, VMWRITE, VMXOFF, VMXON等所有 VMX指令
2. 有条件事件： I/O访问,中断事件, MSR寄存器访问, HTL 等 (要设置VMCS相应部分触发)


-  EXIT_REASON_EXCEPTION_NMI       0: VMX exit due to an exception or non-maskable interrupt (NMI).
-  EXIT_REASON_EXTERNAL_INTERRUPT  1: An external interrupt arrived and the “external-interrupt exiting” VM-execution control was 1.
-  EXIT_REASON_TRIPLE_FAULT        2: VMX exit due to a triple fault.
-  EXIT_REASON_INIT_SIGNAL		   3： VMX exit due to an INIT signal.
-  EXIT_REASON_SIPI_SIGNAL         4： VMS exit due to startup (IPI).

-  EXIT_REASON_INTERRUPT_WINDOW    7： VMX exited due to an Interrupt Window.
-  EXIT_REASON_NMI_WINDOW          8： At the beginning of an instruction, there was no virtual-NMI blocking.
-  EXIT_REASON_TASK_SWITCH         9： The guest attempted a task switch.
-  EXIT_REASON_CPUID               10： The guest software attempted to execute the CPUID instruction.
-  EXIT_REASON_HLT                 12: Guest执行HLT指令，并且VM-execution控制域"HLT exiting" 为1. HLT指令表明虚拟机处于空闲，主动挂起Guest。
-  EXIT_REASON_INVD                13: The guest attempted to execute Invalidate Caches (INVD) instruction.
-  EXIT_REASON_INVLPG              14: The guest attempted to execute the Invalidate TLB Entry (INVLPG) instruction and the “INVLPG exiting” VM-execution control was 1.
-  EXIT_REASON_RDPMC               15: The guest attempted to execute read performance monitoring counters (RDPMC) instruction and the “RDPMC exiting” VM-execution control was 1. 可以协助实现Performance monitor虚拟化。
-  EXIT_REASON_RDTSC               16: The guest attempted to execute read time stamp counter (RDTSC) instruction and the “RDTSC exiting” VM-execution control was 1.可以帮助实现TSC虚拟化。
-  EXIT_REASON_VMCALL              18: The execution of VMCALL by either by the guest or the executive monitor casued an ordinary VM exit or an SMM VM exit, respectively.
-  EXIT_REASON_VMCLEAR             19: The guest attempted to execute VMCLEAR.
-  EXIT_REASON_VMLAUNCH            20
-  EXIT_REASON_VMPTRLD             21
-  EXIT_REASON_VMPTRST             22
-  EXIT_REASON_VMREAD              23
-  EXIT_REASON_VMRESUME            24
-  EXIT_REASON_VMWRITE             25
-  EXIT_REASON_VMOFF               26
-  EXIT_REASON_VMON                27
-  EXIT_REASON_CR_ACCESS           28: The guest attempted to access one of the CR0, CR3, CR4 or CR8 control registers. 和"**CR8 loading exiting**" "**CR8 store exiting**"有关。
-  EXIT_REASON_DR_ACCESS           29: The guest attempted a MOV to or from a debug register and the “**MOV-DR exiting**” VM-execution control was 1.
-  EXIT_REASON_IO_INSTRUCTION      30： Guest attempted to execute an I/O instruction. 如果"**Unconditional IO exiting**"为1，则所有IO全部导致vm-exit；如果启用了"**Use IO bitmap**"则根据bitmap对应值为1才vm_exit。
-  EXIT_REASON_MSR_READ            31: The guest attempted to execute RDMSR. "**Use MSR bitmaps**" VM-execution control位为1并且MSR对应的bitmap为1或者不启用MSR bitmap。
-  EXIT_REASON_MSR_WRITE           32: The guest attempted to execute WRMSR. "**Use MSR bitmaps**" VM-execution control位为1并且MSR对应的bitmap为1或者不启用MSR bitmap。
-  EXIT_REASON_INVALID_STATE       33： VM entry failed one of the entry checks.
-  EXIT_REASON_MSR_LOAD_FAIL       34： A VM entry failed in an attempt to load model specific registers.
-  EXIT_REASON_MWAIT_INSTRUCTION   36： The guest attempted to execute an MWAIT instruction and the “**MWAIT exiting**” VM-execution control was 1.
-  EXIT_REASON_MONITOR_TRAP_FLAG   37： VM exit occurred due to the setting of the monitor trap flag (MTF) or injection of a pending MTF VM exit.
-  EXIT_REASON_MONITOR_INSTRUCTION 39： The guest attempted to execute MONITOR and the “MONITOR exiting” VM-execution control was 1.
-  EXIT_REASON_PAUSE_INSTRUCTION   40： The guest attempted to execute PAUSE when the VM-execution control was 1 or exceeded the execition time window.
-  EXIT_REASON_MCE_DURING_VMENTRY  41： A machine-check event occurred during VM entry.
-  EXIT_REASON_TPR_BELOW_THRESHOLD 43： The logical processor determined that the value of the byte at offset 080H on the virtual-APIC page was below the required TPR threshold.
-  EXIT_REASON_APIC_ACCESS         44： The guest attempted to access memory at a physical address on the APIC-access page and the “virtualize APIC accesses” VM-execution control was 1.
-  EXIT_REASON_EOI_INDUCED         45： The system performed EOI virtualization for a virtual interrupt whose vector indexed a bit set in the EOIexit bitmap.
-  EXIT_REASON_GDTR_IDTR           46： The guest attempted to execute LGDT, LIDT, SGDT, or SIDT instructions and the “descriptor-table exiting” VM-execution control was 1.
-  EXIT_REASON_LDTR_TR             47： The guest attempted to execute LLDT, LTR, SLDT, or STR instructions and the “descriptor-table exiting” VM-execution control was 1.
-  EXIT_REASON_EPT_VIOLATION       48： The configuration of the Extended Page Table (EPT) paging structures disallowed an attempt to access memory with a guest-physical address.
-  EXIT_REASON_EPT_MISCONFIG       49： An attempt to access memory with a guest-physical address encountered a misconfigured Extended Page Table (EPT) paging-structure entry.
-  EXIT_REASON_INVEPT              50： The guest attempted to execute the Invalidate cached Extended Page Table (INVEPT) instruction.
-  EXIT_REASON_RDTSCP              51： The guest attempted to execute an RDTSCP instruction and the “enable RDTSCP” and “RDTSC exiting” VM-execution controls were both 1.
-  EXIT_REASON_PREEMPTION_TIMER    52： The preemption timer counted down to zero.
-  EXIT_REASON_INVVPID             53： The guest attempted to execute the INVVPID instruction.
-  EXIT_REASON_WBINVD              54： The guest attempted to execute WBINVD and the “WBINVD exiting” VM-execution control was 1.
-  EXIT_REASON_XSETBV              55： The guest attempted to execute XSETBV.
-  EXIT_REASON_APIC_WRITE          56： The guest completed a write to the virtual-APIC page that requires virtualization by VMM software.
-  EXIT_REASON_RDRAND              57： The guest software attempted to execute RDRAND instruction and the “RDRAND exiting” VM-execution control was 1.
-  EXIT_REASON_INVPCID             58： The guest attempted to execute an INVPCID instruction and the “enable INVPCID” and “INVLPG exiting” VM-execution controls were both 1.
-  EXIT_REASON_VMFUNC              59： The guest called a VM function and the VM function either wasn’t enabled or generated a function-specific condition causing a VM exit.
-  EXIT_REASON_ENCLS               60： The guest attempted to execute an unsupported ENCLS instruction.
-  EXIT_REASON_RDSEED              61： The guest attempted to execute RDSEED and the “RDSEED exiting” VM-execution control was 1.
-  EXIT_REASON_PML_FULL            62： 当PML Buffer被填满时，会产生page-modification log-full event，然后触发VMExit。热迁移的时候启用PML。
-  EXIT_REASON_XSAVES              63： The guest attempted to execute XSAVES which wasn’t allowed in the current configuration.
-  EXIT_REASON_XRSTORS             64： The guest attempted to execute XRSTORS which wasn’t allowed in the current configuration.
-  EXIT_REASON_UMWAIT              67： The guest attempted to execute a UMWAIT instruction and both the “enable user wait and pause” and “RDTSC exiting” VM-execution controls were both 1.
-  EXIT_REASON_TPAUSE              68： The guest attempted to execute a TPAUSE instuction and both the “enable user wait and pause” and “RDTSC exiting” VM-execution controls were both 1.
-  EXIT_REASON_BUS_LOCK            74