# MMU
kvm中的MMU支持传统的MMU和硬件支持的TDP(NPT和EPT)，支持2、3、4、5级别地址转换支持global page、pae、pse(page size extension)、pse36(36位地址)，cr0.wp(write protect)和1GB的大页。
支持转换的场景, 如果请求的地址转换硬件支持，则采用direct mode，否则用shadow mode：
1. Guest的分页关闭，则支持gpa -> hpa。
2. Guest分页打开，支持gva-> gpa -> hpa
3. Guest嵌入guest， 支持ngva->ngpa->gpa->hpa
   
事件驱动：
Guest事件：写入控制寄存器；invlpg、invlpga指令；访问缺失的或者保护的地址转换；
host事件：改变从gpa到hpa的转换，包括gpa到hva和hva到hpa；内存收缩。

# 创建TDP MMU

kvm_mmu_set_ept_masks(enable_ept_ad_bits, cpu_has_vmx_ept_execute_only());
kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(), ept_caps_to_lpage_level(vmx_capability.ept));
PML
