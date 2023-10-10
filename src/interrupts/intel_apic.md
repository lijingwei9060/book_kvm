## 数据结构

struct local_apic： 保存一堆寄存器



void apic_intr_mode_init(void) // Init the interrupt delivery mode for the BSP
|-> x86_64_probe_apic();
    |-> enable_IR_x2apic(); // 配置IOAPIC上的Interrupt remap
    |-> x2apic_cluster_probe() => apic_install_driver(apic_x2apic_cluster)
    x2apic_prepare_cpu()
    init_x2apic_ldr();
|-> x86_32_install_bigsmp();
|-> void apic_bsp_setup(bool upmode) //  Setup function for local apic and io-apic, up: uniprocessor

```C
start_kernel()
    local_irq_disable();  // cli close interrupt
	early_boot_irqs_disabled = true;
    setup_arch()
        idt_setup_early_traps();  // 注入early_idts2个中断处理函数用于debug，将`idt_table`地址加载到`IDTR`寄存器中。
        apic_setup_apic_calls();  // 静态函数初始化，不过这个时候apic的驱动还没有注册，这个时候更新有什么意义？
        if (acpi_mps_check()) {   // 检查 acpi_disabled || acpi_noirq 参数，一般都是false
                apic_is_disabled = true;
                setup_clear_cpu_cap(X86_FEATURE_APIC);
            }
        check_x2apic(); // 读取msr MSR_IA32_APICBASE，判断x2apic是否enable， 初始化全局变量x2apic_state = X2APIC_ON， x2apic_mode = 1
        idt_setup_early_pf(); // 初始化idt表中的缺页中断X86_TRAP_PF， 这个还不是最终的缺页中断处理函数
        init_apic_mappings(); // initialize APIC mappings, 看不出来maping了什么？
            apic_validate_deadline_timer(); // lapic 中有tsc deadline timer
        io_apic_init_mappings();
        therm_lvt_init();  // masks the thermal LVT interrupt, 读取bsp的apic中的APIC_LVTTHMR，保存到全局变量lvtthmr_init，后续会写入到ap，保持所有processor统一
        mcheck_init();  // 注册mce_irq_work_cb 中断处理函数
    trap_init();        
        setup_cpu_entry_areas();/* Init cpu_entry_area before IST entries are set up */        
        sev_es_init_vc_handling();/* Init GHCB memory pages when running as an SEV-ES guest */        
        cpu_init_exception_handling();/* Initialize TSS before setting up traps so ISTs work */   
            load_current_idt();     
        idt_setup_traps();/* load default IDT entries, Setup traps as cpu_init() might #GP */
        cpu_init();
            x2apic_setup(); // 根据全局变量x2apic_state 启动 x2apic
    early_irq_init();
        init_irq_default_affinity(); // 设置irq默认亲和性为所有cpu
        irq_insert_desc(); // 插入16个irq到全局变量 struct maple_tree sparse_irqs
        arch_early_irq_init(); 
            irq_domain_alloc_named_fwnode("VECTOR");
            x86_vector_domain = irq_domain_create_tree(fn, &x86_vector_domain_ops, NULL);
            irq_set_default_host(x86_vector_domain);
            irq_alloc_matrix(NR_VECTORS, FIRST_EXTERNAL_VECTOR, FIRST_SYSTEM_VECTOR);
            arch_early_ioapic_init();
                alloc_ioapic_saved_registers(i);
	init_IRQ();
        per_cpu(vector_irq, 0)[ISA_IRQ_VECTOR(i)] = irq_to_desc(i); // 硬中断向量号0x30~0x3F和软中断号0~15映射的desc建立映射关系
        irq_init_percpu_irqstack(cpu);
        native_init_IRQ();
        x86_init.irqs.pre_vector_init();
        idt_setup_apic_and_irq_gates();
        lapic_assign_system_vectors();
    softirq_init();
    time_init(); => late_time_init = x86_late_time_init;
    early_boot_irqs_disabled = false;
	local_irq_enable();
    arch_cpu_finalize_init(); 
        identify_boot_cpu(); => init_intel(); => intel_init_thermal(c); //将lvtthmr_init写入ap apic中的APIC_LVTTHMR
    acpi_early_init();
    late_time_init(); // 时间系统后半段初始化会进行apic的探测，注册apic cluster的驱动
        x86_init.irqs.intr_mode_select(); => apic_intr_mode_select(); => APIC_SYMMETRIC_IO
        x86_init.irqs.intr_mode_init();
            x86_64_probe_apic();
            x86_32_install_bigsmp();
            apic_bsp_setup(upmode);
```



```C
static struct irq_domain *irq_default_domain; == x86_vector_domain; (intel x86_64)
struct irq_domain *x86_vector_domain;
static cpumask_var_t vector_searchmask;
static struct irq_chip lapic_controller;
static struct irq_matrix *vector_matrix  = irq_alloc_matrix(NR_VECTORS, FIRST_EXTERNAL_VECTOR, FIRST_SYSTEM_VECTOR);
static struct irq_chip hpet_msi_controller;
struct irqchip_fwid *fwid;
struct fwnode_handle	fwnode
```


```C
pci_subsys_init();
x86_init.pci.init() == pci_acpi_init() 
    for_each_pci_dev(dev) acpi_pci_irq_enable(dev);
```