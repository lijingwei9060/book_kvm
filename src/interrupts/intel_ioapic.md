# 概念

APIC (Advanced Programmable Interrupt Controller)是90年代Intel为了应对将来的多核趋势提出的一整套中断处理方案，用于取代老旧的8259A PIC。这套方案适用于多核（Multi-Processor）机器，每个CPU拥有一个Local APIC，整个机器拥有一个或多个IOAPIC，设备的中断信号先经由IOAPIC汇总，再分发给一个或多个CPU的Local APIC。为了配合APIC，还推出了MPSpec (Multiprocessor Specification)，为BIOS向OS提供中断配置信息的方式提供了规范。

自90年代以来，PCI总线发展出了MSI (Message Signalled Interrupt)，目前的机器中是以MSI为主要的中断机制，IOAPIC作为辅助，但CPU处仍使用Local APIC接收和处理中断。当时提出的MPSpec经过演化目前已成为了ACPI规范的一部分，BIOS可以通过ACPI表向OS报告中断配置情况（e.g. IOAPIC的引脚连接到哪个设备）。

初代奔腾（Pentium）上初次引入Local APIC时，它是外置的Intel 82489DX芯片。在一些奔腾型号以及P6 family（即从奔腾Pro到奔腾3）上则将其改为了内置，但功能保持不变。自奔腾4及至强（Xeon）开始取消了APIC Bus以及一部分相关设置，于是改称xAPIC，目前Intel CPU的默认模式就是xAPIC。后来又增加了x2APIC模式作为xAPIC的扩展，这个功能需要手动开启，并且必须配合VT-d的中断重映射功能使用。

在P6 family的时代，各CPU的APIC间通过一条APIC Bus通信，IPI (Inter Processor Interrupt)消息以及IOAPIC/MSI的中断消息都在APIC Bus上传输。从奔腾4开始，取消了APIC Bus，APIC间的通信改走System Bus，IPI消息和中断消息都通过System Bus传输。

典型的 IOAPIC 有 24 个 input 管脚(INTIN0~INTIN23)，没有优先级之分。I/O APIC提供多处理器中断管理，用于CPU核之间分配外部中断，在某个管脚收到中断后，按一定规则将外部中断处理成中断消息发送到Local APIC。IOAPIC: IOAPIC的主要作用是中断的分发。最初有一条专门的APIC总线用于IOAPIC和LAPIC通信，在Pentium4 和Xeon 系列CPU出现后，他们的通信被合并到系统总线中。


APIC包含LAPIC(local apic)和IO APIC。
1. LAPIC负责传递中断信号到指定的CPU，包含在每个核中一个，也就是一颗cpu可以有多个LAPIC。
2. IOAPIC负责收集IO设备的中断信号，并投递到LAPIC，是一颗cpu一个，现在系统中最多8个IOAPIC。
3. LAPIC包含内部时钟，定时设备，32位寄存器，2条额外的中断信号线LINT0和LINT1，连接到IOAPIC。


## 寄存器

IOAPIC寄存器: IOAPIC寄存器的默认地址是在FEC00000h，其中Index，Data，IRQ Pin Assertion， EOI寄存器是可以直接访问的，其他的寄存器则需要通过读写Index/Data 寄存器的方式去访问（先把8-bit Index写到Index，然后从Data寄存器读写对应的内容）。

直接访问寄存器：
| register | start address | width(bit) | R/W | Description |
|----------|---------------| ---------- | ----| ----------- |
| Index    | 0xFEC00000h   | 8          | R/W | 索引寄存器，用于指定访问的寄存器索引 |
| Data     | 0xFEC00010h   | 32         | R/W | 数据寄存器   |
| IRQ Pin Assertion | 0xFEC00020h | 32  | WO  | 使用MSI时,IRQ写[4:0] |
| EOI      | 0xFEC00040h   | 32         | WO  | 针对Level IRQ有效 |

间接访问寄存器，需要通过index和data寄存器进行读写：

| register       | start address | width(bit) | R/W | Description |
|----------------|---------------| ---------- | ----| ----------- |
| Indentification| Index 00h     | 32         | R/W |  APIC ID    |
| Version        | Index 01h     | 32         | RO  |  IOAPIC 的硬件版本 | 
| Reserved       | Index 02-0Fh  | -          | RO  | reserved |
| Redtb0         | index 10h-11h | 64         | R/W | |
| Redtb23        | -             | 64         | R/W | |
| Reserved       | - FF          | -          | RO  | reserved     |


和 LAPIC 一样，IOAPIC 的寄存器同样是通过映射一片物理地址空间实现的：

- IOREGSEL(I/O REGISTER SELECT REGISTER): 选择要读写的寄存器
- IOWIN(I/O WINDOW REGISTER): 读写 IOREGSEL 选中的寄存器
- IOAPICVER(IOAPIC VERSION REGISTER): IOAPIC 的硬件版本
- IOAPICARB(IOAPIC ARBITRATION REGISTER): IOAPIC 在总线上的仲裁优先级
- IOAPICID(IOAPIC IDENTIFICATION REGISTER): IOAPIC 的 ID，在仲裁时将作为 ID 加载到 IOAPICARB 中
- IOREDTBL(I/O REDIRECTION TABLE REGISTERS): 有 0-23 共 24 个，对应 24 个引脚,每个管脚对应一个RTE (Redirection Table Entry)。每个RTE长 64bit。当该引脚收到中断信号时，将根据该寄存器产生中断消息送给相应的 LAPIC.这些管脚本身并没有优先级的区分，但是RTE中会有Vector，LAPIC会基于Vector设定优先级。

Redirection Table Entry(64bits):
- 56-63: RW, 目的字段，physical mode(Destination Mode = 0)时其值为APIC ID; Logical Mode时(Destination Mode = 1) 代表一组CPU。
- 48-55: extensted destination
- 17-48: reserved
- 16: interrupt Mask， 中断屏蔽位，RW。1： 对应的中断管脚被屏蔽，中断会被忽略；0： 中断会发送到LAPIC。
- 15: RO，触发模式，edge边缘触发还是level水平触发
- 14: RIRR： Remote IRR，RO， 只对水平触发有效，（水平触发），0 ： lapic发送eoi；1：lapic收到然后ack，还没有eoi; 
- 13: RW，Interrupt Input Pin Polarity，中断管脚的极性，是高电平还是低电平，0：高，1：低。
- 12: Delivery status，RO，传送状态，0： idle表示没有中断，1：send pending，ioapic已经收到还没有发给lapic。
- 11: 目的地模式，RW，0：physical mode， 1： logical mode.
- 8-10: delivery mode, 传送模式，RW
  - Fixed(000)： 发送给目标中多有的CPU
  - Lowest Priority(001)，发送给目标中优先级最低的cpu
  - SMI(010)：系统管理终端，vector为0，edge触发
  - NMI(100)： 发送不可屏蔽中断，edge触发，没有vector
  - INIT(101)： 发送目标init中断，edge触发
  - ExtInt(111)： 发送目标中断，会认为是PIC发送的中断
- 0-7: interrupt vector  ，RW， 从10h-FEh，前16个保留

### ioapic拓扑结构

MP spec为PIC和APIC共存的平台规定了三种模式：PIC mode、Virtual Wire Mode、Symmetric I/O Mode。
三种模式中，PIC mode和Virtual Wire Mode互斥存在。Symmetric I/O Mode是所有MP平台最终进入的模式。Spec规定，为了PC/AT compatibility，系统在RESET后首先进入PIC mode或者Virtual Wire mode，操作系统（或BIOS）在适当时候切换入Symmetric I/O Mode。

IMCR，Interrupt Mode Configuration Register，中断模式配置寄存器，控制当前系统的中断模式——PIC还是APIC？当系统RESET后，该寄存器清0，系统默认进入PIC模式。此时BSP（Boot Startup Processor，多处理器系统中第一个启动的CPU）的NMI和INTR脚为硬连线，直接从外部接入，不经过APIC。

对IMCR写1，可将系统切换至Symmetric I/O Mode模式。此时外部中断直接通过APIC到达CPU，NMI则连接LAPIC的LINT1脚。

Virtual Wire Mode:虚拟接线模式，该模式主要是为了向前兼容，可以理解为就是PIC。在这种模式下，IOAPIC会把8259A的模拟硬件产生的中断信号直接送给BSP。


### 使能IOAPIC

### 检测IOAPIC
acpi
### 中断投递过程
设备中断传递大致流程如下(假设设备接在IOAPIC IRQ3，而且PRT3的设置是 电平触发，低有效，Physical Mode APICID23H)，Fixed Delivery Mode Vector为20H：

1. 设备通过拉低IRQ信号线产生一个中断。
2. 检测到低电平的有效信号之后，IOAPIC 把PRT03 中的Remote IRR(Interrupt Request Register) 和Delivery Status bit设置起来。
3. 使用PRT03中的信息，IOAPIC组成一个中断信息，使用写内存的方式发送给系统总线上。因为是APICID23H，所以LAPIC 23h将会识别这个中断信息是给它的，其他的Local APIC会忽略这个信息。
4. LAPIC 23h会把IRR中对应的bit设置起来（20h），表示Vector 20h有一个中断请求等待送给CPU。LAPIC会判断当前最高优先级的中断能否发送给CPU处理。
5. CPU清掉IRR 设置ISR表示中断开始被处理，处理完成以后写LAPIC EOI寄存器，LAPIC会清掉ISR。同时IOAPIC的EOI寄存器也会被写。
6. IOAPIC 收到EOI的写操作以后，它会比较PRT中的vector，在这里它会把PRT03的Remote IRR清零，之后它由可以识别IRQ3上的中断了。



## 数据结构

X86上有3个终端芯片， ioapic、ioapic-ir、lapic： 
```C
static struct irq_chip ioapic_chip;
static struct irq_chip dmar_msi_controller；
static const struct irq_domain_ops msi_domain_ops; // 上一层为 intel_ir_domain_ops ，调用了irq_domain_alloc_irqs_parent 分配中断号




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

// INTEL-IR
static struct irq_chip intel_ir_chip; // INTEL-IR
static const struct irq_domain_ops intel_ir_domain_ops; // intel_setup_irq_remapping
struct irq_remap_ops intel_irq_remap_ops; // intel架构使用这个ops
cap_caching_mode(iommu->cap) => iommu->ir_domain->msi_parent_ops = &virt_dmar_msi_parent_ops;
                                iommu->ir_domain->msi_parent_ops = &dmar_msi_parent_ops;


// IR-PCI-MSIX IR-PCI-MSI 上一层为 x86_vector_domain(APIC)/iommu->ir_domain(INTEL-IR), iommu->ir_domain的parent为x86_vector_domain
bool msi_create_device_irq_domain(); // 动态为每个PCI-E设备创建irq_domain, 模板指向 pci_msix_template / pci_msi_template
static const struct msi_domain_template pci_msix_template;
static const struct msi_domain_template pci_msi_template;
static const struct irq_domain_ops msi_domain_ops;



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

## IR PCI 设备初始化

rootfs_initcall(ir_dev_scope_init);
	ret = dmar_dev_scope_init(); // 分析每一个pci设备，如果是在acpi的dmar下面，就会配置相关的irq_domain信息
        dmar_acpi_dev_scope_init();
        dmar_pci_bus_add_dev(info);
            intel_irq_remap_add_device(info);
                dev_set_msi_domain(&info->dev->dev, map_dev_to_ir(info->dev)); // 设置pci设备的irq_domain为iommu->irq_domain

## pci驱动申请中断
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


## 中断响应过程
desc->handler
handle_fasteoi_irq: irq handler for transparent controllers
handle_edge_irq: 边缘触发的中断处理函数， 中断控制器需要按照顺序ack

1. state = IRQS_REPLAY | IRQS_WAITING
2. irq_chip.irq_ack()
3. handle_irq_event(desc) 
4. ~IRQS_PENDING 
5. IRQD_IRQ_INPROGRESS 
6. handle_irq_event_percpu(desc) 
   1. 线程化 => lockdep_hardirq_threaded()
   2. action->handler(irq, action->dev_id)
   3. IRQ_WAKE_THREAD => __irq_wake_thread(desc, action)
7. ~ IRQD_IRQ_INPROGRESS
如果运行过程中IRQS_PENDING，说明 reply状态时需要unmask，直接处理就好了，应为另外一个cpu在设置IRQS_PENDING的同时mask并ack了。


handle_level_irq: 水平触发，需要先ack, mask， handle， unmask

1. mask_ack_irq(desc)
2. ~(IRQS_REPLAY | IRQS_WAITING)
3. handle_irq_event(desc)
   1. ~IRQS_PENDING
   2. IRQD_IRQ_INPROGRESS
   3. handle_irq_event_percpu(desc)
   4. ~IRQD_IRQ_INPROGRESS
4. cond_unmask_irq(desc): 正常level中断(不是IRQF_ONESHOT， 或者单发没有唤醒线程)

handle_fasteoi_irq: 透明中断控制器，level-triggered interrupt for the I/O APIC controller
1. ~(IRQS_REPLAY | IRQS_WAITING)
2. handle_irq_event(desc)
3. cond_unmask_eoi_irq(desc, chip);


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