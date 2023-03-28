在创建客户机时，VMM会通过VMLAUNCH或VMRESUME指令切换到非根模式运行客户机，客户机引起VM-Exit后又切换回根模式运行VMM。

# VM-Entry
VM-Entry是指CPU由根模式切换到非根模式，从软件角度看，是指CPU从VMM切换到客户机执行。这个操作通常由VMM主动发起。在发起之前，VMM会设置好VMCS相关域的内容，例如客户机状态域、宿主机状态域等，然后执行VM-Entry指令。

VT-x为VM-Entry提供了两条指令:
- VMLAUNCH：用于刚执行过VMCLEAER的VMCS的第一次VM-Entry。
- VMRESUME：用于执行过VMLAUNCH的VMCS的后续VM-Entry。

VM-Entry的具体行为由VM-Entry控制域规定，该域的具体定义如下列表：
1. IA-32e mode guest：在支持Intel 64架构的处理器上，此位决定了VM-Entry后处理器是否处于64位模式，当客户机是64位的，需要打开这个标志。
2. MSR Vm-Entry：在Vm-Entry时，vmm可以指定CPU切换到客户机环境之前正确的装载MSR得值，通过两个VMCS寄存器制定。VM-Entry MSR load count指定要装在msr的数量，VM-Entry MSR load address指定要装在MSR的物理地址。
3. 事件注入控制：根据VM-entry Interrupt information 和Vm-entry Exception code注入同步异常、异步中断（外部中断和NMI）。访问MSR导致vm-exit，写入VM-Entry Interrupt infromation 信息注入General Protection fault。


# VM-Entry 过程
当CPU执行VMLAUNCH/VMRESUME进行VM-Entry时，处理器要进行下面的步骤：

1. 执行基本的检查来确保VM-Entry能开始。
2. 对VMCS中的宿主机状态域的有效性进行检查，以确保下一次VM-Exit发生时可以正确地从客户机环境切换到VMM环境。
3. 检查VMCS中客户机状态域的有效性；根据VMCS中客户机状态域来装载处理器的状态。
4. 根据VMCS中VM-Entry MSR-load区域装载MSR寄存器。
5. 根据VMCS中VM-Entry事件注入控制的配置，可能需要注入一个事件到客户机中。
   
第1~4步的检查如果没有通过，CPU会报告VM-Entry失败，这通常意味着VMCS中某些字段的设置有错误。如果所有这些步骤都正常通过了，处理器就会把执行环境从VMM切换到客户机环境，开始执行客户机指令。

VM-Entry控制域中的“事件注入控制”用到了VM-Entry Interruption-Information字段，下图列出该字段的格式。

每次VM-Entry时，在切换到客户机环境后即将执行客户机指令前，CPU会检查这个32位字段的最高位（即bit31）。如果为1，则根据bit10:8指定的中断类型和bit7:0指定的向量号在当前的客户机中引发一个异常、中断或NMI。此外，如果bit11为1，表示要注入的事件有一个错误码（如Page Fault事件），错误码由另一个VMCS的寄存器VM-Entry exception error code指定。注入的事件最终是用客户机自己的IDT里面指定的处理函数来处理的。这样在客户机虚拟CPU看来，这些事件就和没有虚拟化的环境里面对应的事件没有任何区别。

## qemu 过程

## KVM VCPU run过程

函数调用链：
kvm_vcpu_ioctl(kvm_run) -> kvm_arch_vcpu_ioctl_run -> vcpu_run -> vcpu_enter_guest -> vmx_vcpu_run(vcpu) ->  __vmx_vcpu_run -> vmenter.S -> vmx_vmenter
                                                                   vcpu_enter_guest -> vmx_handle_exit->kvm_vmx_exit_handlers

vcpu_enter_guest：vm entry的入口，同时也是vm-exit的出口。
1. 先处理vm-entry的准备工作，调用vmx_vcpu_run进入vmx non-root模式。准备工作包括中断注入。参考[中断注入](中断注入.md)。
2. 在vm-exit，调用退出处理函数r = kvm_x86_ops->handle_exit(vcpu)进行原因分析以及后续处理，如果r等于1表明在内核态已经处理完成可以直接再次run vcpu，如果返回值小于等于0需要转交到用户态进行处理。kvm_vmx_exit_handlers是一个vm-exit操作函数数组，根据退出原因选择具体的处理函数。该函数返回1，继续保持vcpu运行，小于等于0退回到userspace。退出循环之后将会将返回值返回给userspace进行处理，exit reason 被记录在 kvm run中。exit reason 被记录在 kvm run中,kvm_run被映射到qemu层面的CPU结构体中，因此可以在qemu层获得exit_reason。

vmx_vcpu_run： 配置VMCS结构,cpu自动加载，通过vmcs的相关指令读来实现（vmcs_writel，vmcs_write32等等）。
在该函数中会配置好VMCS结构中客户机状态域和宿主机状态域中相关字段的信息，vmcs结构是由CPU自动加载与保存的；另外还会调用汇编函数，主要是KVM为guest加载通用寄存器和调试寄存器信息，因为这些信息CPU不会自动加载，需要手动加载。一切就绪后执行 VMLAUNCH或者VMRESUME指令进入客户机执行环境。另外，guest也可以通过VMCALL指令调用KVM中的服务。

vmenter.S: 将vcpu中的寄存器中的内容加载到cpu的寄存器上