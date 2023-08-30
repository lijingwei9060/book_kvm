# qom

TYPE_DEVICE -> TYPE_CPU -> TYPE_X86_CPU -> X86_CPU_TYPE_NAME("max")/X86_CPU_TYPE_NAME("base")

x86_register_cpudef_types(&builtin_x86_defs[i]) // 注册具体的cpu型号

## 初始化CPU

DEFINE_Q35_MACHINE
pc_q35_init(machine);

|-x86_cpus_init
	|-x86_cpu_new                           //CPUState *cs = CPU(dev);
		|-object_new
			|-object_new_with_type
				|-type_initialize
				|-object_initialize_with_type
					|-type_initialize
						|-class_init        //调用x86_cpu_type_info的x86_cpu_common_class_init初始化x86_cpu
		|-object_property_set_bool
			|-object_property_set_qobject
				|-property_set_bool
					|-device_set_realized
						|-x86_cpu_realizefn   //vcpu初始化的实现，先初始化struct X86CPU再初始化struct CPUState 
							|-qemu_init_vcpu  //struct CPUState
								|-qemu_kvm_start_vcpu
									|-qemu_kvm_cpu_thread_fn
										|-kvm_init_vcpu
											|-kvm_get_vcpu        //通知kvm创建一个vcpu，返回一个kvm_fd，在kvm的内核中，vpu的操作函数kvm_x86_ops指向(intel)vmx_x86_ops或者(amd)svm_x86_ops
											|-kvm_ioctl           //从kvm获取映射mmap_size(KVM_GET_VCPU_MMAP_SIZE)
											|-mmap                //对kvm_fd进行以一个mmap_size大小映射,映射到CPUState->kvm_run,每次vm_exit都可以通过kvm_run->exit_reason判断退出原因。qemu和kvm建立映射，便于信息同步。所以kvm_run是不是就是4k的vmcs？
											|-kvm_arch_init_vcpu  //前面vcpu创建成功之后现在来真正的初始化
												|-kvm_arch_set_tsc_khz      //时钟设置
												|-kvm_vcpu_ioctl            //KVM_GET_TSC_KHZ时钟可以用户设置和从kvm获取，这里从KVM获取再保存下来
												|-hyperv_handle_properties  //设置cpuids
												|-cpu_x86_cpuid             //获取所有的CPUID信息，填充结构体，设置到寄存器中
												|-kvm_vcpu_ioctl            //前面构造KVM需要的cpuid_data数据，再通过KVM_SET_CPUID2给kvm设置cpuid
												|-kvm_init_msrs             //通知kvm设置msr寄存器
												|-hyperv_init_vcpu          //Hyper-V初始化vcpu保存一些信息在后续迁移时候恢复使用
										|-kvm_init_cpu_signals
										|-kvm_cpu_exec //每个vcpu对应一个线程，该线程循环执行

## ARMv8 cpu状态

通用寄存器：
- AArch32 有 R0 -R14
- AArch64 64bit X0-X30 32bit W0-W30

特殊寄存器，
1）存放异常返回地址的ELR_ELx；
2）各个EL的栈指针SP_ELx；
3）CPU的状态相关寄存器；

- CurrentEL： 保存PSTATE.EL
- DAIF: 保存PSTATE.{D,A,I,F}中断掩码位
- DIT: 保存PSTATE.DIT位
- ELR_EL1: 保存从EL1异常返回的地址




## vCPU运行

qemu_kvm_cpu_thread_fn -> kvm_cpu_exec -> kvm_vcpu_ioctl(cpu, KVM_RUN, 0) -> ... -> kvm

kvm_cpu_exec: 调用kvm_run 运行子机; 分析exit的原因，进行处理

qemu_kvm_cpu_thread_fn: 由于处于while循环中，处理完一次exit后又进行ioctl调用运行虚拟机并切换到客户模式

### kvm

kvm_vcpu_ioctl(kvm_run) -> kvm_arch_vcpu_ioctl_run -> vcpu_run -> vcpu_enter_guest -> vmx_vcpu_run(vcpu) ->  __vmx_vcpu_run -> vmenter.S -> vmx_vmenter

vmenter.S执行相关的汇编指令， 调用 VMLAUNCH启动vm, VMRESUME再次进入vm. 当退出vm时，将会进行vm_exit处理。
vmx_vcpu_run：在该函数中会配置好VMCS结构中客户机状态域和宿主机状态域中相关字段的信息，vmcs结构是由CPU自动加载与保存的 ，通过vmcs的相关指令读来实现（vmcs_writel，vmcs_write32等等）；另外还会调用汇编函数，主要是KVM为guest加载通用寄存器和调试寄存器信息，因为这些信息CPU不会自动加载，需要手动加载。一切就绪后执行 VMLAUNCH或者VMRESUME指令进入客户机执行环境。另外，guest也可以通过VMCALL指令调用KVM中的服务。
vcpu_enter_guest：该函数返回1，继续保持vcpu运行，否则退回到userspace.

r = kvm_x86_ops->handle_exit(vcpu)：需要对exit的原因进行处理，根据exit reason来决定是否交由userspace处理。
vmx_henadle_exit->handle_io
                ->handle_rdmsr
                ->handle_ept_violation
                ->handle_vmx_instruction return 1;
exit reason 被记录在 kvm run中,kvm_run被映射到qemu层面的CPU结构体中，因此可以在qemu层获得exit_reason