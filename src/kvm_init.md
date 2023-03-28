# 初始化过程

`kvm` 模块初始化的过程是由`kvm_intel`或者`kvm_amd`模块初始的，kvm作为一个虚拟化框架型结构，针对不同的架构具体的初始化有具体的模块中提供函数进行。

# 大体的初始化内容
1. 判断是否启用hyper-v  enlightened功能，如果启动：
   1. 配置针对每个cpu的vp_assist_page
   2. 如果支持enlightended vmcs，配置evmcs
   3. 如果支持hyperv嵌入(nested), 支持direct flush，配置hv_enable_direct_tlbflush
2. 初始化kvm模块，关键的初始化`kvm_x86_init_ops`已经定义好了，只需要进行调用就可以完成响应架构的初始化操作。
   1. cpu_has_kvm_support: cpu是否支持虚拟化，intel和amd分别传入判断参数
   2. disabled_by_bios
   3. boot_cpu_has(X86_FEATURE_FPU) || boot_cpu_has(X86_FEATURE_FXSR)
   4. IS_ENABLED(CONFIG_PREEMPT_RT) && boot_cpu_has(X86_FEATURE_CONSTANT_TSC)
   5. kvm_alloc_emulator_cache： 创建`x86_emulate_ctxt` ,有故事
   6. kvm_user_return_msrs： 返回到用户态才需要加载的寄存器，原先的名字叫kvm_shared_msrs。
   7. kvm_mmu_vendor_module_init：
   8. kvm_timer_init
   9. XCR0
   10. pi_inject_timer
   11. X86_64=>pvclock_gtod_notifier
   12. X86_HYPER_MS_HYPERV => kvm_hyperv_tsc_notifier
3. vmx_setup_l1d_flush应该是针对一级数据缓存flush管理，针对Intel L1TF(L1 Terminal Fault)硬件缺陷。
4. 检查vmcs12的结构，vmcs12是kvm in kvm嵌入数据管理。