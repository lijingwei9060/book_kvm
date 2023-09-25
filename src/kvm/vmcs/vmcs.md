# VMCS结构

# 初始化过程

## 分配VMCS

vmcs在kvm_intel模块加载的时候会为每一个物理CPU分配一个vmcs页面，然后启动vmxon时候传递vmcs的物理地址。这个vmcs的配置信息完全是CPU自己在使用和管理，vmm不需要进行管理。SDM手册上没有详细的说明，所以保持黑盒吧。在创建vm分配vcpu的时候，每创建一个vcpu就会创建vmcs和vcpu进行关联，这个是vmx使用到的vmcs配置。

kvm加载时为物理cpu分配vmcs，调用链比较简单：hardware_setup(vmx.c)->setup_vmcs_config(vmx.c)->alloc_kvm_area(vmx.c)->alloc_vmcs_cpu(vmx.c)
创建vcpu时，为vcpu分配cmcs： kvm_vm_ioctl_create_vcpu(kvm_main.c)->alloc_vmcs_cpu(vmx.c)->vmx_vcpu_setup(vmx.c)->vmcs_writel-> guest_write_tsc。

最大的区别是vmcs分配后，调用了vmx_vcpu_setup根据vmcs_config进行vmcs初始化。 vmcs配置信息比较多，对于多个域进行配置的地方分散到各个地方：
1. IO bitmap A and B在vmx_init中配置，毕竟vmcs中记录的只是IO bitmap的物理地址。
2. VM execution control、VM entry control及VM exit control三个部分。它们的具体配置是在setup_vmcs_config(注意这个是通用配置，后面特定的vcpu可以有修改)，其中重要的设置有：
3. PIN_BASED_EXT_INTR_MASK；标志着external interrupt会导致VMExit；
4. 没有RDTSC_EXITING；标志着rdtsc指令不会导致VMExit，guest可以直接读取物理TSC；
5. CPU_BASED_USE_TSC_OFFSETTING；标志着读取的物理TSC还要加上一个TSC_OFFSET才得到guest TSC；
6. CPU_BASED_USE_IO_BITMAPS；标志着每个guest IO指令产不产生VMExit要去查IO bitmap；
7. SECONDARY_EXEC_ENABLE_EPT；标志着默认是打开ept特性的；6. 没有VM_EXIT_ACK_INTR_ON_EXIT；我的理解是这样的—原来在guest模式下，中断是关闭的，但是会导致VMExit(上1配置)。Exit后kvm内核代码立刻开中断，这时必须能检测到这个中断。如果VMExit时就自动ack了，再开中断时就检测不到这个中断了。
8. 1-6都是Execution control，至于Entry和Exit control在setup_vmcs_config中固定配置比较少。

# 切换过程  


# 数据结构
- vmcs_config
- vmcs