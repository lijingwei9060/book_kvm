# CPU与CPU虚拟化


## 关于虚拟化的学术型论证
G.Popek和R.Goldberg在1974年发表的论文(Formal Requirements for Virtualizable Third Generation Architectures)中提到，作为向上层VM提供底层硬件抽象的一层轻量级的软件，VMM必须满足以下3个条件：

1.等价性(Equivalence) ：应用程序在VMM 上的虚拟机执行，应与物理硬件上的执行行为相同。
2.资源控制(Resource Control) ：物理硬件由VMM全权控，VM 及VM上的应用程序不得直接访问硬件。
3.有效性(Efficiency) ：在虚拟执行环境中应用程序的绝大多数指令能够在VMM不干预的情况下，直接在物理硬件上执行。

CPU的指令按照运行级别的不同，可以划分为两类：
1.特权指令 ：只能在最高级别上运行，在低级别状态下执行会产生trap。例如：LIDT只能在系统模式下执行，在其他模式下都会产生trap，中止执行。
2.非特权指令 ：可以在各个级别的状态下执行。

引入虚拟化后，Guest OS就不能运行在Ring 0上。因此，原本需要在最高级别下执行的指令就不能够直接执行，而是交由VMM处理执行。这部分指令称为敏感指令 。当执行这些指令时，理论上都要产生trap被VMM捕获执行。敏感指令：Guest OS中必须由VMM处理的指令，因为这些指令必须工作在0环。 
敏感指令包括：
1. 企图访问或修改虚拟机模式或机器状态的指令。
2. 企图访问或修改敏感寄存器或存储单元，如时钟寄存器、中断寄存器等的指令。
3. 企图访问存储保护系统或内存、地址分配系统的指令。
4. 所有I/O指令。

根据Popek和Goldberg的理论，如果指令集支持虚拟化就必须满足所有的敏感指令都是特权指令 。这样，当Guest OS运行在非最高特权级时，执行任意特权指令都能产生trap。该条件保证了任何影响VMM或VM正确运行的指令在VM上执行时都能被VMM捕获并将控制权转移到VMM上，从而保证了虚拟机环境的等价性和资源可控制性，保证虚拟机正确运行。

但是，x86架构并不满足这个条件。由于有些敏感指令不属于特权指令，从而阻碍了指令的虚拟化。(x86不满足的原因：有些必须由VMM处理的0环指令，工作在1环也不会产生trap，即敏感指令包含非特权指令。但是敏感指令必须工作在0环，所以这些非特权指令也必须陷入。）x86结构上的这些不是特权指令的敏感指令，称为临界指令 (Critical Instructions)。这些临界指令在x86架构下有17个，主要包含敏感指令的两类：敏感寄存器指令和保护系统指令(上面的2,3类)。

敏感寄存器指令：SGDT,SIDT,SLDT ；SMSW; PUSHF,POPF;(UMIP user mode instruction prevention)
保护系统指令：LAR,LSL,VERR,VERW;POP ;PUSH ;CALL,JMP,INT n,RET ;STR ;MOV;
SMSW表示存机器状态字(store machine status word)，即将机器状态字的值(CR0中低16位的值)保存到一个寄存器或存储单元中。该指令没有被设定为特权指令。当Guest OS查询机器状态时，其得到的是实际物理寄存器的状态，即VMM的状态，并非是Guest OS的状态。所以也需要设置相应的虚拟寄存器CR0。
POPF(pop stack into EFLAGS register)和PUSHF(push EFLAGS register onto the stack)是一对相反的指令。PUSHF是将EFLAGS的寄存器的低16位压栈，并将栈指针减2。 POPF是从栈顶弹出一个字到EFLAGS的寄存器中，并将栈指针加2。
LAR加载访问权限(load access rights byte)，LSL加载段界限(load segment limit），VERR验证段可读(Verify a segment for reading)、VERW验证段可写(verify a segment for writing).LAR指令是从指定的段描述符中加载访问权限到另一个寄存器，并设置EFLAGS寄存器中的ZF标志位；LSL指令从指定的段描述符中加载段界限到另一个寄存器中，并设置ZF标志位；VERR/VERW指令是在当前的特权级下验证指定的段是否可读/可写。若是，则设置ZF标志位。
STR,Store Task Register，将当前任务寄存器的段选择符存入通用寄存器或存储单元中，这个段选择符指向TSS段。

2017年Intel在新发布的CPU上提供了新的功能进行虚拟化安全加固，UMIP(User mode Instruction prevention)。 在启用UIMP的CPU上，当CPL(Current Privilige Level) > 0 执行SGDT/SIDT/SLDT/STR/SMSW(Store machine status Word)将会被拦截，会产生一个GP(a General Protection Exception)。

操作系统的本质是围绕CPU进行资源管理，充分发挥CPU的服务能力， 具体而言包括CPU全局状态管理，任务上下文的状态管理。暂时把任务的范围泛化，不局限于进程、线程等，中断也可以属于任务范畴。在X86架构下，CPU包含4个运行级别，从Ring0到3， Linux使用了Ring0运行内核态，使用Ring3运行用户态。对CPU操作的指令集一部分是只能运行在内核态的。这个很容易理解，CPU是全局资源，对CPU全局配置进行修改，必然要高等的权限。如果所有用户程序都可以修改全局配置，CPU的运行状态将会混乱。我们很多应用系统的配置只有系统管理员可以更改，针对这个用户的配置才开放给用户修改。CPU的配置状态的变化也是类似。所以我们要区分CPU状态中哪些是用户的，哪些是全局的，哪些修改应该在内核态，哪些修改再用户态。

特权级别： MIPS 有三个特权级（外加一个 Supervisor 态，没什么用），x86 有四个特权级 (Ring0 ~ Ring3)）用来分隔系统软件和应用软件。
敏感指令：x86 的 lgdt/sgdt/lidt/sidt/in/out，MIPS 的 mtc0/mfc0，PowerPC 的 mtmsr/mfmsr SPARC 的 rdpr/wrpr。对于一般 RISC 处理器，如 MIPS，PowerPC 以及SPARC 敏感指令肯定是特权指令 唯 x86 例外
特权资源：x86 的CR0 ~ CR4，MIPS 的 CP0 寄存器，PowerPC 的Privileged SPR。

虚拟化对体系结构(ISA)的要求:
1. 须支持多个特权级
2. 非敏感指令的执行结果不依赖于 CPU 的特权级, “陷入－模拟” 的本质是保证可能影响 VMM 正确运行的指令由 VMM 模拟执行 大部分的非敏感指令还是照常运行 拟执行，大部分的非敏感指令还是照常运行。
3. CPU 需支持一种保护机制，如 MMU，可将物理系统和其它 VM 与当前活动的 VM 隔离
4. 敏感指令需皆为特权指令
 此为保证敏感指令在 VM 上执行时，能陷入到 VMM.控 敏感 令的执行 能 变系统 处 设备 的状态 为保 
 因控制敏感指令的执行可能改变系统（处理器和设备）的状态，为保证 VMM 对资源的绝对控制力维护 VM 的正常运行，这类指令的执行需要陷入而将控制权转移到 VMM，并由其模拟处理之。
 行为敏感指令的执行结果依赖于 CPU 的最高特权级，而 Guest OS 运行于非最高特权级，为保证其结果正确，亦需要陷入 VMM，并由其模拟之。

x86 ISA 中有十多条敏感指令不是特权指令，因此 x86 无法使用经典的虚拟化技术完全虚拟化。如：sgdt/sidt/sldt 可以在用户态读取特权寄存器GDTR/IDTR/LDTR 的值；popf/pushf 在 Ring0 和 Ring 3 的执行结果不同其它的还有 smsw, lar, lsl, verr, verw, pop, push, call, jmp, int n, ret, str, move

在CPU支持虚拟化后，状态的管理变得更复杂，应为还要区分一个维度，在虚拟机里面还是在物理机。作为虚拟机里面的OS，他也有内核态和用户态之分。在没有修改内核代码的前提下，它也会对CPU全局配置进行修改，这就出现了问题。这颗CPU其实不是给这个虚拟机独占，物理机也在管理。如果虚拟机可以随便更改物理CPU的全局属性，这就变成盗梦空间里面的情景，这个人从梦中逃逸到显示，甚至可以操作其他人的梦。所以在虚拟化的环境里面，我们需要隔离这种操作，即使它在虚拟机的内核态，对CPU的修改都要进行变化。

我们不能让每一个OS的开发商进行修改代码，所以虚拟化软件应该对于虚拟机修改CPU的行为进行拦截、伪装然后替代，让虚拟机继续在梦中。

为了理解虚拟化下的CPU是如何工作的，我们需要逐步理解下面几个内容：

1. CPU的寄存器：CPU内部包含哪些状态信息，这些信息有什么用途，如何进行管理。
2. 进程上下文：进程的上下文是什么，如何进行管理，又如何进行切换。
3. vCPU上下文：vCPU的上下文又是什么，如何进行管理和切换。
