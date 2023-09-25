# Intel VMX ops列表

## Intel 虚拟化功能集

OS中的虚拟化功能与硬件CPU虚拟化的发展是相互促成的过程。需求促使OS快速开发迭代，qemu的出现就是一个典型的代表，qemu的产生明显早于CPU虚拟化的发展，否则也不会出现qemu的tcg功能。CPU硬件虚拟化的出现就是为了稳定和加速软件的虚拟化能力。

Intel的虚拟化分为三个部分，virtualization technoligy、virtualization technoligy for directed io, virtualization technology for connectivity，也就是我们常说的vt-x、vt-d和vt-c。我们只聊一聊前两个吧，最后一个比较新貌似堆硬件的规范，看机缘吧。咱们先从框架上看看vt-x和vt-d是什么，有什么功能，可以有什么特效。

先看一下Intel SDM 第三卷23章节关于Virtual Machine Extension的介绍，先粗略的介绍一下新增加的内容：
1. CPU的运行模式增加新的运行模式，包括VMM root和VMM non-root模式，每种模式都有Ring 0-3这4中模式。VMM root模式就是运行在物理机环境，就是传统的模式，可以执行所有CPU能力。non-root可以理解为虚拟机模式，虚拟机在这个运行态，特权指令可以执行但是会陷入到root模式。陷入是一个什么意思？先简单说一下，后面看代码就可以一目了然。举个例子，虚拟机（non-root模式）修改cpu的属性，比如CR3寄存器，这个修改指令发送给虚拟的CPU，会导致虚拟机退出到root模式的内核态或者用户态进程，由这个进程模拟响应CR3寄存器的修改，然后返回到虚拟机状态。从虚拟机OS感受到的就是完整硬件操作能力，但其实是陷入root模式模拟的。
2. 增加VMX相关的操作指令集，开启和关闭CPU VMX能力。
3. 增加Virtual Machine Control Struct，cpu的模拟可以理解就是对寄存器的模拟，切换虚拟cpu就是切换寄存器，和OS常规的进程切换很类似，要进行上下文切换，所以增加了一个4K的内存页面保存虚拟机切换guest和host的寄存器保存。这个页面不能直接操作，需要通过支持VMX功能的VMCS指令(VMREAD, VMWRITE, VMCLEAR)进行操作。当然vmcs的位置保存在VMCS pointer，可通过VMPTRST和VMPTRLD进行读写。
4. 增加EPT(Extended Page table), 这个功能主要是为了优化虚拟机内存访问性能。CPU里面存在一个MMU(Memory management Unit), 里面有一个TLB，是为了优化进程访问内存的时候从线性地址到物理地址转换。这个转换在MMU出现以前是通过内核的多级页表一层一层跳转而来，MMU通过硬件的方式进行加速。在出现了虚拟机后，虚拟机访问内存最终会变成物理主机的物理地址，会从虚拟机的线性地址到虚拟机的物理机地址、再到物理主机的线性地址最终到物理主机的物理地址，这个转换路径太长了。KVM实现了shadow page table(影子页表)，也就是一个从虚拟机物理地址到物理主机的物理地址，看历史是多么的相似。于是Intel又来一个EPT功能来替换这个影子页表，下面就是用MMU硬件加速。
5. 增加VPID(Virtual Processor IDs)，上面用EPT加速虚拟机内存访问，以前的TLB的实现不能满足对于虚拟机访问的缓存加速，反而会出现混乱。看了TLB的实现，再给每一个缓存在增加一个标签吧，这个标签就是VPID，代表创建给虚拟机的vCPU。
6. 中断虚拟化是在cpu虚拟化中增加的比较大的功能模块。在虚拟化中影响虚拟机性能比较大的就是中断，中断不停地打断正在运行的虚拟机，让虚拟机来响应中断处理。大部分的中断信息是虚拟设备或者外部物理设备发送给虚拟机CPU，这个时候就要将虚拟机vCPU暂停，将中断信息放在vCPU的寄存器中，让后让虚拟机vCPU在运行起来。这种不停的vm-exit、中断注入然后再vm-entry的模式会导致虚拟机vCPU疲于应对，性能影响较大。能不能简单点，不要把vCPU踢出来呢，在运行的时候就可以将中断注入进去。中断虚拟化就是优化这个部分，包括APIC中断寄存器虚拟化让CPU可以直接读写中断寄存器不用vm-exit，让虚拟机不退出就可以进行虚拟中断分发，读写CR8不用vm-exit，利用内存映射访问apic，PI注入？。

上面主要是介绍vt-x的虚拟化功能，还有独立一份文档介绍vt-d的IO虚拟化功能，主要增加了IOMMU，实现物理PCI设备可以直接透传给虚拟机，比如GPU、加速卡或者其他设备。透传PCI设备会带来一些困惑，设备的中断是发给虚拟机还是物理机，即使是发给虚拟机也要物理机进行中转，如何中转？PCI设备的config space作为虚拟机又如何读写，如果频繁进行vm-exit、vm-entry进行DMA中转吗，这样的性能有个什么用呢？vt-d主要在CPU芯片中增加了IOMMU，增加了PCI设备到CPU的中间设备，从硬件层面增加irq remapping和dma remapping。

vt-C不太理解，主要是针对网络设备，新增虚拟机设备队列（VMDq），可以直接对接virtio，提升vmm网络速度的。

## VMX初始化的过程
如何判断CPU是否支持VMX？通过CPUID.1:ECX.VMX[bit 5] = 1，在/proc/cpuinfo查看vmx 特性在不在，相关的属性还包括ept和vpid。

如何启动和进入vmx模式？ 首先设置CR4.VMXE[bit 13] = 1， 然年执行VMXON，具体实现是`vmx_hardware_enable` 。VMXON 输入参数需要一个4K页面的物理地址， 这个区域也叫做`VMXON region`, 配置要求和VMCS相同, 传递前revision id需要配置，即从`IA32_VMX_BASIC MSR`寄存器中获取到的31bit的VMCS revision identifier， 每一个物理核都需要一个4K页面的配置。这个页面应该是CPU自己管理，放置CPU相关信息，具体的配置并没有文档记录。`VMXON region`是在`hardware_setup` 调用`alloc_kvm_area` 分配。

如何关闭VMX模式？执行 VMXOFF ，清理CR4.VMXE[bit 13]，具体实现在`vmx_hardware_disable`。




## 硬件设置干了什么
1. 保存IDT(Interrupt Description table)表地址到`host_idt_base`, 应该是为了IOMMU的irq remapping做准备。
2. 添加一部分寄存器到kvm_uret_msrs_list，看起来表面意思是拦截对这些寄存器的访问。后面再看看什么意思？(:TODO)
3. 检测vmx能力，配置vmcs_config，检测的项目特别多，要得出vmcs区域里面vm-exec control fields(包括 _pin_based_exec_control, _cpu_based_exec_control, _cpu_based_2nd_exec_control)、vm-exit control fields和vm-entry control fields。有空看一下`vmcs_field` 这个结构，太长了挺绝望的。先不装B，后面再说吧。
   1. _pin_based_exec_control默认包含
      1. CPU_BASED_HLT_EXITING
      2. CPU_BASED_CR8_LOAD_EXITING: 和TPR shadow功能相反
      3. CPU_BASED_CR8_STORE_EXITING: 和TPR shadow功能相反
      4. CPU_BASED_CR3_LOAD_EXITING: 和ept功能相反
      5. CPU_BASED_CR3_STORE_EXITING: 和ept功能相反
      6. CPU_BASED_UNCOND_IO_EXITING
      7. CPU_BASED_MOV_DR_EXITING
      8. CPU_BASED_USE_TSC_OFFSETTING
      9. CPU_BASED_MWAIT_EXITING
      10. CPU_BASED_MONITOR_EXITING
      11. CPU_BASED_INVLPG_EXITING: 和ept功能相反
      12. CPU_BASED_RDPMC_EXITING
      13. CPU_BASED_TPR_SHADOW
      14. CPU_BASED_USE_MSR_BITMAPS
      15. CPU_BASED_ACTIVATE_SECONDARY_CONTROLS
      16. SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
      17. SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE
      18. SECONDARY_EXEC_WBINVD_EXITING
      19. SECONDARY_EXEC_ENABLE_VPID
      20. SECONDARY_EXEC_ENABLE_EPT
      21. SECONDARY_EXEC_UNRESTRICTED_GUEST
      22. SECONDARY_EXEC_PAUSE_LOOP_EXITING
      23. SECONDARY_EXEC_DESC
      24. SECONDARY_EXEC_ENABLE_RDTSCP
      25. SECONDARY_EXEC_ENABLE_INVPCID: 
      26. SECONDARY_EXEC_APIC_REGISTER_VIRT: 
      27. SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY: 
      28. SECONDARY_EXEC_SHADOW_VMCS: 
      29. SECONDARY_EXEC_XSAVES: 
      30. SECONDARY_EXEC_RDSEED_EXITING: 
      31. SECONDARY_EXEC_RDRAND_EXITING: 
      32. SECONDARY_EXEC_ENABLE_PML: 
      33. SECONDARY_EXEC_TSC_SCALING: 
      34. SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE: 
      35. SECONDARY_EXEC_PT_USE_GPA: 
      36. SECONDARY_EXEC_PT_CONCEAL_VMX: 
      37. SECONDARY_EXEC_ENABLE_VMFUNC: 
      38. SECONDARY_EXEC_BUS_LOCK_DETECTION:
   2. virtual apic access 和TPR shadow检测
   3. apic register virt 、virtal x2apic 、virtual interrupt delivery和TPR shadow检测
   4. ept与cr3读写vm-exit、invlpg vm-exit
   5. vpid能力
   6. X86_FEATURE_NX： Extended Feature Enable Register NXE (No-Execute Enable)
   7. X86_FEATURE_MPX：
   8. vpid能力判断
   9. ept能力判断：
   10. hyper-v是一个什么鬼

## VMX操作函数集


Intel vmx 操作函数集 `struct kvm_x86_ops vmx_x86_ops` 
- `name = "kvm_intel"` kvm 操作函数集的名称，Intel是这个名字，对应的就会有`amd_intel` 。很奇怪，Arm没有这个参数，后续在分析一下Arm的kvm是怎么处理的。
- `hardware_unsetup = vmx_hardware_unsetup` 
- `hardware_enable = vmx_hardware_enable` 对于Intel CPU使能VMX，在CPU启动VMX之前需要执行1. 设置CR4.VMXE[bit 13] = 1 2. 通过vmxon 4k页面启动CPU的vmx。
- `hardware_disable = vmx_hardware_disable` 和`vmx_hardware_enable` 反过程，执行vmxoff，清理CR4标志位。
- `has_emulated_msr = vmx_has_emulated_msr` 
- `vm_size = sizeof(struct kvm_vmx)` 
- `vm_init = vmx_vm_init` 

- `vcpu_create = vmx_vcpu_create` 给虚拟机创建vcpu，分配vpid
- `vcpu_free = vmx_vcpu_free`  释放虚拟机中的vcpu
- `vcpu_reset = vmx_vcpu_reset` 重置虚拟机中的vcpu
- `prepare_switch_to_guest = vmx_prepare_switch_to_guest` 
- `vcpu_load = vmx_vcpu_load` 
- `vcpu_put = vmx_vcpu_put` 


- `update_exception_bitmap = vmx_update_exception_bitmap` 
- `get_msr_feature = vmx_get_msr_feature` 
- `get_msr = vmx_get_msr` 
- `set_msr = vmx_set_msr` 
- `get_segment_base = vmx_get_segment_base` 
- `get_segment = vmx_get_segment` 
- `set_segment = vmx_set_segment` 
- `get_cpl = vmx_get_cpl` 
- `get_cs_db_l_bits = vmx_get_cs_db_l_bits` 
- `set_cr0 = vmx_set_cr0` 
- `is_valid_cr4 = vmx_is_valid_cr4` 
- `set_cr4 = vmx_set_cr4` 
- `set_efer = vmx_set_efer` 
- `get_idt = vmx_get_idt` 
- `set_idt = vmx_set_idt` 
- `get_gdt = vmx_get_gdt` 
- `set_gdt = vmx_set_gdt` 
- `set_dr7 = vmx_set_dr7` 
- `sync_dirty_debug_regs = vmx_sync_dirty_debug_regs` 
- `cache_reg = vmx_cache_reg` 
- `get_rflags = vmx_get_rflags` 
- `set_rflags = vmx_set_rflags` 
- `get_if_flag = vmx_get_if_flag` 
  
- `flush_tlb_all = vmx_flush_tlb_all` 
- `flush_tlb_current = vmx_flush_tlb_current` 
- `flush_tlb_gva = vmx_flush_tlb_gva` 
- `flush_tlb_guest = vmx_flush_tlb_guest` 

- `vcpu_pre_run = vmx_vcpu_pre_run` 
- `vcpu_run = vmx_vcpu_run` 
- `handle_exit = vmx_handle_exit` 
- `skip_emulated_instruction = vmx_skip_emulated_instruction` 
- `update_emulated_instruction = vmx_update_emulated_instruction` 
- `set_interrupt_shadow = vmx_set_interrupt_shadow` 
- `get_interrupt_shadow = vmx_get_interrupt_shadow` 
- `patch_hypercall = vmx_patch_hypercall` 
- `inject_irq = vmx_inject_irq` 
- `inject_nmi = vmx_inject_nmi` 
- `queue_exception = vmx_queue_exception` 
- `cancel_injection = vmx_cancel_injection` 
- `interrupt_allowed = vmx_interrupt_allowed` 
- `nmi_allowed = vmx_nmi_allowed` 
- `get_nmi_mask = vmx_get_nmi_mask` 
- `set_nmi_mask = vmx_set_nmi_mask` 
- `enable_nmi_window = vmx_enable_nmi_window` 
- `enable_irq_window = vmx_enable_irq_window` 
- `update_cr8_intercept = vmx_update_cr8_intercept` 
- `set_virtual_apic_mode = vmx_set_virtual_apic_mode` 
- `set_apic_access_page_addr = vmx_set_apic_access_page_addr` 
- `refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl` 
- `load_eoi_exitmap = vmx_load_eoi_exitmap` 
- `apicv_post_state_restore = vmx_apicv_post_state_restore` 
- `check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons` 
- `hwapic_irr_update = vmx_hwapic_irr_update` 
- `hwapic_isr_update = vmx_hwapic_isr_update` 
- `guest_apic_has_interrupt = vmx_guest_apic_has_interrupt` 
- `sync_pir_to_irr = vmx_sync_pir_to_irr` 
- `deliver_interrupt = vmx_deliver_interrupt` 
- `dy_apicv_has_pending_interrupt = pi_has_pending_interrupt` 
- `set_tss_addr = vmx_set_tss_addr` 
- `set_identity_map_addr = vmx_set_identity_map_addr` 
- `get_mt_mask = vmx_get_mt_mask` 
- `get_exit_info = vmx_get_exit_info` 
- `vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid` 
- `has_wbinvd_exit = cpu_has_vmx_wbinvd_exit` 
- `get_l2_tsc_offset = vmx_get_l2_tsc_offset` 
- `get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier` 
- `write_tsc_offset = vmx_write_tsc_offset` 
- `write_tsc_multiplier = vmx_write_tsc_multiplier` 
- `load_mmu_pgd = vmx_load_mmu_pgd` 
- `check_intercept = vmx_check_intercept` 
- `handle_exit_irqoff = vmx_handle_exit_irqoff` 
- `request_immediate_exit = vmx_request_immediate_exit` 
- `sched_in = vmx_sched_in` 
- `cpu_dirty_log_size = PML_ENTITY_NUM` 
- `update_cpu_dirty_logging = vmx_update_cpu_dirty_logging` 
- `pmu_ops = &intel_pmu_ops` 
- `nested_ops = &vmx_nested_ops` 
- `pi_update_irte = vmx_pi_update_irte` 
- `pi_start_assignment = vmx_pi_start_assignment` 
- `set_hv_timer = vmx_set_hv_timer` 
- `cancel_hv_timer = vmx_cancel_hv_timer` 
- `setup_mce = vmx_setup_mce` 
- `smi_allowed = vmx_smi_allowed` 
- `enter_smm = vmx_enter_smm` 
- `leave_smm = vmx_leave_smm` 
- `enable_smi_window = vmx_enable_smi_window` 
- `can_emulate_instruction = vmx_can_emulate_instruction` 
- `apic_init_signal_blocked = vmx_apic_init_signal_blocked` 
- `migrate_timers = vmx_migrate_timers` 
- `msr_filter_changed = vmx_msr_filter_changed` 
- `complete_emulated_msr = kvm_complete_insn_gp` 
- `vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector` 
