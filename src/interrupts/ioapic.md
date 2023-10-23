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
static struct irq_chip dmar_msi_controller；
static const struct irq_domain_ops msi_domain_ops; // 上一层为 intel_ir_domain_ops ，调用了irq_domain_alloc_irqs_parent 分配中断号


// INTEL-IR
static struct irq_chip intel_ir_chip; // INTEL-IR
static const struct irq_domain_ops intel_ir_domain_ops; // intel_setup_irq_remapping
struct irq_remap_ops intel_irq_remap_ops; // intel架构使用这个ops

// IR-IO-APIC IO-APIC
static struct irq_chip ioapic_ir_chip; // IR-IO-APIC
static struct irq_chip ioapic_chip;    // IO-APIC 上一层为 Vector
const struct irq_domain_ops mp_ioapic_irqdomain_ops;
ioapic->irqdomain = irq_domain_create_hierarchy(parent, 0, hwirqs, fn, cfg->ops, (void *)(long)ioapic); // 动态创建出来的irq_domain

// Local-APIC --edge
static struct irq_chip lapic_chip; // 这个很特别，只处理timer， 只处理lvt0寄存器

// APIC
static struct irq_chip lapic_controller;
static const struct irq_domain_ops x86_vector_domain_ops 
struct irq_domain *x86_vector_domain
static struct irq_domain *irq_default_domain = x86_vector_domain; // 默认的中断控制器

// DMAR-MSI
static struct irq_chip dmar_msi_controller; // DMAR-MSI
static struct msi_domain_info dmar_msi_domain_info;
static struct msi_domain_ops dmar_msi_domain_ops

// IR-PCI-MSIX IR-PCI-MSI 上一层为 x86_vector_domain(APIC)/iommu->ir_domain(INTEL-IR)
bool msi_create_device_irq_domain(); // 动态为每个PCI-E设备创建irq_domain, 模板指向pci_msix_template/pci_msi_template
static const struct msi_domain_template pci_msix_template;
static const struct msi_domain_template pci_msi_template;



```




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
pcie设备为msi-x申请中断号
```C
ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter)
    vectors = pci_enable_msix_range(adapter->pdev, adapter->msix_entries, vector_threshold, vectors); // vectors为tx + rx + 1，收发队列+管理， 不超过cpu数量，确保配置空间可以保存
        __pci_enable_msix_range(dev, entries, minvec, maxvec, NULL, 0); // affinity=NULL
            pci_msi_domain_supports(dev, MSI_FLAG_PCI_MSIX, ALLOW_LEGACY); // 检查msi-x是否初始化完成，irq_domain 已经准备好
            pci_msi_supported(dev, nvec); // msi是否支持，不支持也报错
            hwsize = pci_msix_vec_count(dev); // 读取配置空间中msi-x中的支持中断数量，作为中断数量上限，申请的irq不能超过这个数，否则没法保存到配置空间
            rc = pci_setup_msi_context(dev);
            pci_setup_msix_device_domain(dev, hwsize) // Setup a device MSI-X interrupt domain
            msix_capability_init(dev, entries, nvec, affd) // configure device's MSI-X capability
                dev->msix_enabled = 1; // Mark it enabled so setup functions can query it
                ret = msix_setup_interrupts(dev, entries, nvec, affd);
                    ret = msix_setup_msi_descs(dev, entries, nvec, masks);
*                   ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
                        irq_domain_is_hierarchy => msi_domain_alloc_irqs_all_locked(&dev->dev, MSI_DEFAULT_DOMAIN, nvec);
                            ret = msi_domain_alloc_simple_msi_descs(dev, info, ctrl);
                            __msi_domain_alloc_irqs(dev, domain, ctrl)
                                virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used, dev_to_node(dev), &arg, false, desc->affinity);
                                    irq_domain_alloc_irqs_locked(domain, irq_base, nr_irqs, node, arg, realloc, affinity);
                                        irq_domain_alloc_descs(irq_base, nr_irqs, 0, node, affinity); // 申请nr_irqs个desc
                                            virq = __irq_alloc_descs(-1, hint, cnt, node, THIS_MODULE, affinity);
                                                ret = alloc_descs(start, cnt, node, affinity, owner);
                                                    desc = alloc_desc(start + i, node, flags, mask, owner);
*                                                   irq_insert_desc(start + i, desc);
                                                    irq_sysfs_add(start + i, desc);
                                                    irq_add_debugfs_entry(start + i, desc);
                                        irq_domain_alloc_irq_data(domain, virq, nr_irqs)
                                        ret = irq_domain_alloc_irqs_hierarchy(domain, virq, nr_irqs, arg);
                                        ret = irq_domain_trim_hierarchy(virq + i);
                                        irq_domain_insert_irq(virq + i);
                                            irq_domain_set_mapping(domain, data->hwirq, data);
                                                radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
                                ret = msi_init_virq(domain, virq + i, vflags);
                pci_intx_for_msi(dev, 0);  // Disable INTX

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


## MSI Interrupt Controller
pci_alloc_irq_vectors() // Allocate multiple device interrupt vectors
    pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags, NULL)() // Enable MSI interrupt mode on device
        __pci_enable_msi_range()
            pci_setup_msi_device_domain() // Setup a device MSI interrupt domain
                pci_create_device_domain()
                    msi_create_device_irq_domain(&pdev->dev, MSI_DEFAULT_DOMAIN, tmpl, hwsize, NULL, NULL) // Create a device MSI interrupt domain

pci_create_ims_domain() // Create a secondary IMS domain for a PCI device


## pci设备设置irq_domain的过程

pcie_port_probe_service

int pci_scan_root_bus_bridge(struct pci_host_bridge *bridge)
    static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev, int max, unsigned int available_buses, int pass) //  Scan buses behind a bridge
    unsigned int pci_scan_child_bus(struct pci_bus *bus) // Scan devices below a bus
        static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus, unsigned int available_buses) // Scan devices below a bus
            int pci_scan_slot(struct pci_bus *bus, int devfn)
                struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
                    void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
                        int pcibios_device_add(struct pci_dev *dev)
                            msidom = dev_get_msi_domain(&dev->bus->dev);
                            if (!msidom) msidom = x86_pci_msi_default_domain; // x86_vector_domain, 就是说msi、msi-x的parent就是vector
                            dev_set_msi_domain(&dev->dev, msidom);


static int dmar_pci_bus_add_dev(struct dmar_pci_notify_info *info)
    void intel_irq_remap_add_device(struct dmar_pci_notify_info *info) // Store the MSI remapping domain pointer in the device if enabled.
        dev_set_msi_domain(&info->dev->dev, map_dev_to_ir(info->dev))