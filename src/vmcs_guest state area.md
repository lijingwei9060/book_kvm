# VMCS Guest状态域
客户机状态域用于保存CPU在非根模式下运行时的状态。当发生VM-Entry时，CPU**自动**将客户机状态域保存的状态加载到CPU中；当发生VM-Exit时，CPU自动将CPU的状态保存回客户机状态域，这是硬件机制。Guest状态域包含寄存器状态和非寄存器状态。

寄存器状态包含vm-exit时的
- 控制寄存器(CR0,CR3,CR4)
- debug寄存器(DR7)
- RSP、RIP、RFLAGS
- CS、SS、DS、FS、GS、LDTR、TR(包含段选择子16bit、基地址64bit，段limit32bit，访问权限32bit)
- msr，有一部分MSR需要根据VM-Entry control域的配置确定是否保存和加载
- SSP 寄存器，shadow-stack pointer register, 根据VM-Entry 控制域中"**load CET state**"置位。
- SMBASE(32bit) 寄存器, 包含CPU SMRAM镜像的基址.

非寄存器状态： 
- Activity state(32bit): active, HLT, Shutdown, Wait-for-sipi
- Interruptibility State(32bit)
- Pending debug exceptions
- VMCS link pointer (64 bits): 
- VMX-preemption timer value (32 bits)
- Page-directory-pointer-table entries (PDPTEs; 64 bits each)
- Guest interrupt status (16 bits)(RVI, SVI):
- PML index (16 bits): “enable PML” VM-execution 控制域置位时启用，指向PML(page-modification log) entry index(0-511)。PML包含512个entry，每个entry代表1个GPA，每个entry 8字节64bit，大小4Kb，物理地址保存在VM-Execution 控制域“PML address”字段。KVM就是通过这个区域来跟踪内存脏页。在硬件引入PML之前是通过SPTE(shadow page table entry)中的D状态位(#6位)进行跟踪内存的脏页管理。使用方法： EPTP字段中位于bit 6的一个标志位(Accessed and Dirty flags)置位，当CPU使用EPT查询HPA时，将表项的Access位(#8位)置位；写数据时会将Dirty位(#9bit)置位。当PML Buffer被填满时，会产生page-modification log-full event，然后触发VMExit。


## PML 脏页跟踪
- struct vcpu_vmx: struct page *pml_pg, 是PML buffer，指向VMCS Vm-Execution控制域PML Address字段。
- struct kvm_dirty_log： 为了用户态程序交互内存dirty信息，KVM_GET_DIRTY_LOG

脏页配置启用
1. vmx_x86_ops.hardware_setup-> setup_vmcs_config 设置SECONDARY_EXEC_ENABLE_PML标识使能PML
2. vmx_create_vcpu -> vmx_vcpu_setup,分配一个物理页给pml_pg用作PML Buffer,将分配好的PML Buffer地址写入VMCS的对应区域，同时初始化PMLIndex为511 。

脏页获取：

脏页清理：