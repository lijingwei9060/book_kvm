# 概念

IOAPIC (I/O Advanced Programmable Interrupt Controller) 属于 Intel 芯片组的一部分，也就是说通常位于南桥。像 PIC 一样，连接各个设备，负责接收外部 IO 设备 (Externally connected I/O devices) 发来的中断，典型的 IOAPIC 有 24 个 input 管脚(INTIN0~INTIN23)，没有优先级之分。I/O APIC提供多处理器中断管理，用于CPU核之间分配外部中断，在某个管脚收到中断后，按一定规则将外部中断处理成中断消息发送到Local APIC。

## 寄存器
和 LAPIC 一样，IOAPIC 的寄存器同样是通过映射一片物理地址空间实现的：

- IOREGSEL(I/O REGISTER SELECT REGISTER): 选择要读写的寄存器
- IOWIN(I/O WINDOW REGISTER): 读写 IOREGSEL 选中的寄存器
- IOAPICVER(IOAPIC VERSION REGISTER): IOAPIC 的硬件版本
- IOAPICARB(IOAPIC ARBITRATION REGISTER): IOAPIC 在总线上的仲裁优先级
- IOAPICID(IOAPIC IDENTIFICATION REGISTER): IOAPIC 的 ID，在仲裁时将作为 ID 加载到 IOAPICARB 中
- IOREDTBL(I/O REDIRECTION TABLE REGISTERS): 有 0-23 共 24 个，对应 24 个引脚，每个长 64bit。当该引脚收到中断信号时，将根据该寄存器产生中断消息送给相应的 LAPIC


## 数据结构

X86上有3个终端芯片， ioapic、ioapic-ir、lapic： 
```C
static struct irq_chip ioapic_chip;
static struct irq_chip ioapic_ir_chip;
static struct irq_chip lapic_controller;
static struct irq_chip dmar_msi_controller；

static const struct irq_domain_ops msi_domain_ops; // 上一层为 intel_ir_domain_ops，调用了irq_domain_alloc_irqs_parent 分配中断号

static struct irq_chip intel_ir_chip; // INTEL-IR
static const struct irq_domain_ops intel_ir_domain_ops; // intel_setup_irq_remapping
struct irq_remap_ops intel_irq_remap_ops; // intel架构使用这个ops

static const struct irq_domain_ops x86_vector_domain_ops 
static const struct irq_domain_ops mp_ioapic_irqdomain_ops;
static const struct irq_domain_ops ioapic_irq_domain_ops 

static struct msi_domain_info dmar_msi_domain_info

```


struct irq_domain *x86_vector_domain
static struct irq_domain *irq_default_domain = x86_vector_domain

```C
early_irq_init()
    init_irq_default_affinity(); // 设置默认的irq亲和性irq_default_affinity
    initcnt = arch_probe_nr_irqs(); // 初始化当前阶段的初始的中断数量(PIC中的中断数量，所以大部分是16)，这个数量可能超过256，和idt什么关系呢
    irq_insert_desc(i, desc);  // 初始化pic上面的中断处理，处理节点为bsp，这个地方貌似没有具体的处理函数
    arch_early_irq_init(void)  // 配置lapic上的中断处理函数
        irq_domain_alloc_named_fwnode("VECTOR"); 
        irq_domain_create_tree(fn, &x86_vector_domain_ops, NULL); // 设置irq_domain的ops为x86_vector_domain_ops
        irq_set_default_host(x86_vector_domain); // 设置irq_default_domain为x86_vector_domain，为所有irq_domain的root
        
        x86_vector_alloc_irqs()
            irqd->chip = &lapic_controller;  // 对应的中断控制器为lapic
```

```C
acpi_boot_init()
    acpi_process_madt()
        acpi_parse_madt_ioapic_entries()
            acpi_parse_ioapic()
```

```C
x86_dtb_init();
    dtb_apic_setup();
        dtb_lapic_setup();
        dtb_ioapic_setup();
            dtb_add_ioapic(dn);
                mp_register_ioapic()
```

INTEL-IR: 中断控制器，
```C
apic_intr_mode_init() // x86架构的cpu初始化bsp的中断投递模式
    default_setup_apic_routing() // 64位cpu初始化apic的路由，检查APIC IDS / bios_cpu_apicid 配置合适的APIC模式 (pic/ xapic/x2apic)
        enable_IR_x2apic() // 设置x2apic 和 ir，使能ir、pi
            ir_stat = irq_remapping_prepare(); // 初始化平台iommu的ir_map_ops, 用于支持ir、dmar和pi
                intel_prepare_irq_remapping()
*                   intel_setup_irq_remapping(struct intel_iommu *iommu) // 初始化iommu的ir_table, 包含65536个irte，和对应设置的bitmap
                        irq_domain_alloc_named_id_fwnode("INTEL-IR", iommu->seq_id); // 设置irq_domain的名字为INTEL-IR-%seq_id, 就是说可以有多个iommu
                        irq_domain_create_hierarchy(arch_get_ir_parent_domain(),  0, INTR_REMAP_TABLE_ENTRIES, fn, &intel_ir_domain_ops, iommu); // 创建irq_domain, parent为x86_vector_domain，ops为intel_ir_domain_ops 
                            __irq_domain_publish(domain); // 将domain放到全局列表上irq_domain_list
                        irq_domain_update_bus_token(iommu->ir_domain,  DOMAIN_BUS_DMAR); 将ir_domain设置为DOMAIN_BUS_DMAR
                        init_ir_status(iommu)；
                        iommu_set_irq_remapping(iommu, eim_mode); // 写入iommu寄存器的irtable物理地址和中断模式，x2apic？
*           ir_stat = irq_remapping_enable(); // 启动iommu的ir
                intel_enable_irq_remapping(); // 设置irq_chip具备posted interrupt能力
                    iommu_enable_irq_remapping(iommu); //写入寄存器DMA_GCMD_IRE，使能ire。删除DMA_GCMD_CFI cimpatibility-format msi能力
                    irq_remapping_enabled = 1; // ir 设置完成
                    set_irq_posting_cap();
                irq_remapping_modify_x86_ops();
                    x86_apic_ops.restore = irq_remapping_restore_boot_irq_mode;
            try_to_enable_x2apic(ir_stat); // 使能x2apic
                x2apic_enable(); // 写入msr(MSR_IA32_APICBASE)，x2apic已经可以使用

intel_irq_remapping_alloc

```
## Posted interrupt

static int disable_irq_remap: 全局变量，是否禁用了irq remap。
static struct irq_remap_ops *remap_ops： x86架构上的irq remap操作函数，有intel(`intel_irq_remap_ops`)、amd(`amd_iommu_irq_ops`)和hyperv(`hyperv_irq_remap_ops`)。
static int eim_mode： true代表IRQ_REMAP_X2APIC_MODE， false代表IRQ_REMAP_XAPIC_MODE
```C
irq_remapping_prepare(void)
    remap_ops = &intel_irq_remap_ops;
```

设置irq_chip具备posted interrupt能力
```C
static int __init intel_enable_irq_remapping(void)
    irq_remapping_enabled = 1;
	set_irq_posting_cap();
```