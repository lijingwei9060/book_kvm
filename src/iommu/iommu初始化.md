# 初始化的过程

1. 服务器开机由BIOS/UEFI负责检测并初始化DMAR（即VT-d硬件），为其分配相应的物理地址，并且以ACPI表中的DMAR（DMA Remapping Reporting）表的形式告知VT-d硬件的存在。
2. OS启动后加载对应驱动，驱动从ACPI中读取信息。

GAW的定义：Guest Address Width: Physical addressability limit within a partition (virtual machine),可以理解为从虚拟机角度看到的物理地址宽度。举个例子，如果一个虚拟机只能访问2G内存，那么GAW就是31。

AGAW的定义：Adjusted Guest Address Width。为了保证9个bit长度的步长转化，GAW和AGAW之间的转换伪代码如下, 对应的函数是guestwidth_to_adjustwidth。
sagaw： Supported Adjusted Guest Address Widths： 

R = (GAW - 12) MOD 9;
if (R == 0) {
    AGAW = GAW;
} else {
    AGAW = GAW + 9 - R;
}
if (AGAW > 64)
    AGAW = 64;

AGAW的最小长度是30个bit，参考以下规范定义（context-entry格式里的内容）：

• 000b: 30-bit AGAW (2-level page table)
• 001b: 39-bit AGAW (3-level page table)
• 010b: 48-bit AGAW (4-level page table)
• 011b: 57-bit AGAW (5-level page table)
• 100b: 64-bit AGAW (6-level page table)

```C
struct intel_iommu {
        void __iomem    *reg; /* Pointer to hardware regs, virtual addr */
        u64             reg_phys; /* physical address of hw register set */
        u64             reg_size; /* size of hw register set */
        u64             cap;
        u64             ecap;
        u32             gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
        raw_spinlock_t  register_lock; /* protect register handling */
        int             seq_id; /* sequence id of the iommu */
        int             agaw; /* agaw of this iommu */
        int             msagaw; /* max sagaw of this iommu */
        unsigned int    irq, pr_irq;
        u16             segment;     /* PCI segment# */
        unsigned char   name[13];    /* Device Name */

#ifdef CONFIG_INTEL_IOMMU
        unsigned long   *domain_ids; /* bitmap of domains */
        struct dmar_domain ***domains; /* ptr to domains */
        spinlock_t      lock; /* protect context, domain ids*/
        struct root_entry *root_entry; /* virtual address */
  .......
 }

```
初始化过程：

1. 从acpi表中读取drhd，创建iommu设备，获取iommu的capability、映射iommu的IO地址空间。
2. 初始化iommu的remapping，分配irte空间，将物理地址设置IRTA寄存器。
3. 使能iommu的remapping模式。
4. 检查iommu的interrupt post能力， 如果有就设置intel_irq_remap_ops.capabiliy或上IRQ_POSTING_CAP，后续vcpu启动时会检查该标志。
5. 重新安装irq remapping的操作函数
6. irq_domain？
7. pci？


## pasid

IOMMU 是被“多个 I/O 设备 + 多个进程”共享，所以需要有区分设备的 StreamID（ARM）或 Requester ID/BDF（x86），以及区分进程的 SubstreamID（ARM）或 PASID（x86），在查找 I/O page table 之前，得先查找 device table。

PASID（Process Address Space ID）是一种标识符，用于在设备和系统内存之间建立映射关系。PASID的主要用途是为每个进程或虚拟机分配唯一的标识符，以便在设备访问系统内存时进行身份验证和隔离。

通过使用PASID，IOMMU可以实现以下功能：

1. 隔离：每个进程或虚拟机都有自己的PASID，可以确保设备只能访问其分配的内存区域，从而提高系统的安全性和隔离性。
2. 身份验证：通过PASID，IOMMU可以验证设备访问请求的来源，以确保只有经过授权的进程或虚拟机可以访问系统内存。
3. 性能优化：PASID可以帮助IOMMU在设备和系统内存之间建立快速的映射关系，从而提高数据传输的效率和性能。

PASID enables multiple address spaces per device, up to a million in theory (1 << 20).



# IOMMU驱动（硬件厂商：Intel AMD ARM PPC）

SWIOTLB：software io translation lookaside buffer，纯软件的地址映射技术，主要为寻址能力受限的DMA提供软件上的地址映射。在大于4G物理内存的环境下，开启IOMMU会导致该功能开启。bounce memory
amd：
xen：
intel：

IOMMU厂商注册自己的IOMMU硬件的
- detect
- depend
- early_init
- late_init函数。



intel注册了detect_intel_iommu来检测自己的IOMMU，其它函数都为NULL，finish为0表示检测到自己就不用再检测其它IOMMU硬件了。

```C
struct iommu_table_entry {
	initcall_t	detect;
	initcall_t	depend;
	void	(*early_init)(void); /* No memory allocate available. */
	void	(*late_init)(void); /* Yes, can allocate memory. */
#define IOMMU_FINISH_IF_DETECTED (1<<0)
#define IOMMU_DETECTED		 (1<<1)
	int		flags;
};
```

## Intel架构解析ACPI表创建IOMMU设备


全局变量：
3个kmem_cache：iova_cache（”iommu_iova”）、iommu_domain_cache（”iommu_domain”）、iommu_devinfo_cache（”iommu_devinfo”）
- int dmar_table_initialized：表示dmar表是否初始化，如果parse_dmar_table成功就设为1；
- struct acpi_table_header dmar_tbl：dmar表的地址
- int dmar_dev_scope_status： dev scope初始化状态，1未开始，0表示完成，负数失败
- iommu_device_list： 全局链表，iommu列表
- iommu_detected： 是否检测到了iommu设备
- pci_acs_enable： PCI ACS支持


内核启动后从ACPI中获取DMAR table，解析ACPI表中两项：DRHD,DMA Engine Reporting Structure 和 RMRR, Reserved memory Region Reporting Structure。

start_kernel() -> mm_core_init() -> mem_init() -> pci_iommu_alloc() -> detect_intel_iommu();

- dmar_table_detect();
- dmar_validate_one_drhd
- iommu_detected = 1
- pci_acs_enable = 1 
- x86_init.iommu.iommu_init = intel_iommu_init 在内存管理模块初始化后再进行调用初始化相关内存管理模块

调用`detect_intel_iommu`，它只检测了类型为`ACPI_DMAR_TYPE_HARDWARE_UNIT`的数据，也就是IOMMU硬件单元，读取IOMMU硬件的capability和extended capability，如果都成功说明IOMMU可以初始化，设置给x86_init.iommu.iommu_init = intel_iommu_init，在内存管理模块初始化后再进行调用初始化相关内存管理模块。初始化iommu内存管理数据在`rootfs_initcall(pci_iommu_init)`中，在pci子系统初始化后执行。

detect_intel_iommu执行时还没有memory allocator，所以干的活很简单，但intel_iommu_init执行时memory allocator已经形成，所以intel_iommu_init就大量分配内存建立iommu的数据结构，主要是`struct dmar_drhd_unit`和`struct intel_iommu`。

- `dmar_parse_one_drhd`解析DRHD，对应创建dmaru和iommu设备。
  - 将dmaru挂载到全局链表上`dmar_drhd_units`。
  - 初始化IOMMU
    - 读取IOMMU硬件的capability和extended capability
    - segment、version
    - 配置agaw
    - 分配PMU
    - PASID
    - 注册sysfs
    - 注册iommu_ops = intel_iommu_ops, 将IOMMU设备追加到全局链表iommu_device_list，会触发iommu group探测`bus_iommu_probe`

detect_intel_iommu函数主要作用就是获取dmar acpi表，然后解析表里面的相关信息如果表里面remapping structure为drhd则通过cb函数来验证dma remapping hardware unit是否可用，具体是`dmar_validate_one_dh`， 然后指定iommu_init函数入口为intel_iommu_init。


intel_iommu_init: 分配内存建立iommu的数据结构，主要是`struct dmar_drhd_unit`和`struct intel_iommu`。
1. dmar_table_init：解析dmar表中不同类型的remapping structures。
2. dmar_dev_scope_init()： 主要是初始化每个dmar unit(iommu硬件)下挂载的设备。
3. dmar_register_bus_notifier()
4. intel_iommu_debugfs_init()
5. init_no_remapping_devices();
6. init_dmars()：对dma remapping 做一些初始化的工作。具体的比如把每个drhd关联到struct intel_iommu，假设系统当中如果有n个dma硬件则系统会创建一个大小为n* sizeof(struct intel_iommu*)的g_iommu数组，
7. init_iommu_pm_ops()
8. 注册sysfs， iommu_device_sysfs_add
9. 注册device，iommu_device_register
10. 注册pmu，iommu_pmu_register

iommu_init_mempool：为iova, iommu_dmoain, devinfo创建内存池。

dmar_table_init：调用`parse_dmar_table`解析dmar表中不同类型的remapping structures,解析成功并有IOMMU设备设置全局变量`dmar_table_initialized`为1。当前IOMMU设备类型支持6类，它们分别是HARDWARE_UNIT，RESERVED_MEMORY，ROOT_ATS ，HARDWARE_AFFINITY，NAMESPACE, SATC。
- hardware_unit指的就是iommu硬件
- ATS指的是pcie 的一个重要feature。
- HARDWARE_AFFINITY具体指的是Remapping Hardware Status Affinity(RHSA)信息，主要因为在numa架构下iommu硬件可能会跨node，而通过RHSA信息来报告cpu和内存跟每个iommu硬件的亲和性，从而 保证了iommu硬件的perfomace。
- RESERVED_MEMORY 类型的structures描述的是专门给一些设备预留的DMA内存信息，RMRR 的内存区域必须是4k对齐的，原则上RMRR只针对一些legacy设备比如USB，UMA graphics等设备来使用，而其他设备类型一般不建议使用RMRR。

dmar_parse_one_drhd： 接些ACPI DMAR表中的DRHD信息，初始化`acpi_dmar_hardware_unit` 与 `dmar_drhd_unit dmaru`对象，初始化dmaru的信息，包括寄存器地址，寄存器表达4K页面大小(1 << size +12 )，是否包含所的有device，以及device列表。此时的device scope列表只是分配空间没有进行初始化。通过alloc_iommu分配intel_iommu对象，检查iommu的地址转换能力，注册pmu。



```C
├─dmar_table_init
    ├─parse_dmar_table
    |   ├─dmar_table_detect
    |       |-acpi_get_table //在acpi表中查找"DMAR"开头的表。找到放到全局变量dmar_tbl中。 
    |   |-tboot_get_dmar_table(dmar_tbl) // ?tboot?
    |   └─dmar_walk_remapping_entries
    |       ├─dmar_parse_one_drhd
    |       |  ├─dmar_find_dmaru // 在dmar数据结构中查找drhd结构
    |       |  ├─dmar_alloc_dev_scope // 针对namespace、endpoint、bridge分配dmar_dev_scope内存,还没有进行初始化
    |       |  ├─alloc_iommu
    |       |  |   |- ida_alloc_range // 给intel_iommu分配一个未使用的seq_id
    |       |  |   |- map_iommu
    |       |  |   |- sagaw: supported address widths, smts slts // 判断iommu的地址转换能力，address width ，//根据iommu寄存器中SAGAW field确定能支持的最大位宽
    |       |  |   |- msagaw:max sagaw, gcmd
    |       |  |   |- alloc_iommu_pmu(iommu) 
    |       |  |   |- pasid_supported(iommu)
    |       |  |   |- iommu_device_sysfs_add
    |       |  |   |- iommu_device_register
    |       |  |   |- iommu_pmu_register
    |       |  |─dmar_register_drhd_unit
    |       ├─dmar_parse_one_rmrr
    |       ├─dmar_parse_one_atsr
    |       ├─dmar_parse_one_rhsa
    |       |─dmar_parse_one_andd
    |       |-dmar_parse_one_satc
```
dmar_dev_scope_init: 这个函数里面主要是初始化每个dmar unit(iommu硬件)下挂载的设备。device scope也就是文章开头所描述的每个dmar unit下可以关联不同的设备；一个是INCLUDE_PCI_ALL这个标志位，当这个bit被设置上时驱动会扫描pcie bus下面的所有设备并把这些设备跟这个dmar unit 关联起来，如果这个bit没有设置上则驱动需要解析device scope 然后把这个scope下面的设备跟这个dmar unit关联起来。

```C
├─dmar_dev_scope_init
    |   ├─dmar_acpi_dev_scope_init
    |   |     └─for(dev_scope_num in acpi table)
    |   |           ├─acpi_bus_get_device
    |   |           └─dmar_acpi_insert_dev_scope//给上面注释中指的内存空间中写dev/bus
    |   └─for_each_pci_dev(dev)//把非acpi上报的dev上搞到iommu中来
    |       ├─dmar_alloc_pci_notify_info
    |       ├─dmar_pci_bus_add_dev
    |       |   ├─for_each_drhd_unit//找到dev的hrhd然后加入
    |       |   |    └─dmar_insert_dev_scope
    |       |   ├─dmar_iommu_notify_scope_dev
    |       |   └─intel_irq_remap_add_device
    |       └─dmar_free_pci_notify_info
```

dmar_init_reserved_ranges: 这个函数主要是reserved一些iova ranges防止被其他设备dma，比如ioapic的iova地址范围还有就是各个pci/pcie设备的mmio地址空间。pcie p2p支持的[patch(Enabling peer to peer device transactions for PCIe devices)](https://lists.01.org/pipermail/linux-nvdimm/2017-January/008395.html)

init_no_remapping_devices: 这个函数的主要作用是忽略下面没有设备或者只有gfx设备(显卡驱动不会调用dma相关的api进行相关的操作)的dmar unit硬件。绝大多数gfx drivers不会调用standard PCI DMA APIs来分配DMA buffers，这与IOMMU有冲突。因此如果一个DMA remapping hardware unit中如果只有gdx devices，则根据cmdline配置来决定iommu是否需要将它们bypass掉。[Graphics driver workarounds to provide unity map](https://lkml.org/lkml/2007/4/24/226)

init_dmars:
1. 对 intel_iommu 做详细的初始化设置。把每个drhd关联到struct intel_iommu，假设系统当中如果有n个dma硬件则系统会创建一个大小为n* sizeof(struct intel_iommu*)的g_iommu数组，
2. intel_pasid_max_id
3. 通过`intel_iommu_init_qi` 为每个iommu初始化`Invalidation Translation Caches`缓存失效 机制。目前有两种一种是Register-based invalidation interface，另外一种是Queued invalidation interface；如果支持queued invalidate就是用qi否则使用register based invalidate。
4. 通过`iommu_init_domains` 为每个intel_iommu分配domain_ids和dmar_domains，同时为每个intel_iommu分配root_entry即root_table的基址，然后写到基址寄存器RTADDR_REG当中，写DMAR_GCMD_REG的SRTP位进行设置。FLPT_DEFAULT_DID?
5. init_translation_status
6. iommu_alloc_root_entry
7. iommu_flush_write_buffer
8. iommu_set_root_entry

intel_iommu_init_qi：
- 分配相关数据结构，其中包括了一个作为Invalidation Queue的page
- 将DMAR_IQT_REG（Invalidation Queue Tail Register）设置为0
- 设置DMAR_IQA_REG（Invalidation Queue Address Register）：IQ的地址和大小
- 设置DMAR_GCMD_REG（Global Command Register）使能QI功能
- 等待DMAR_GSTS_REG（Global Status Register）的QIES置位，表示使能成功
- 设置flush.flush_context和flush.flush_iotlb两个钩子

hw_pass_through &iommu_pass_through: 前者表示iommu硬件是否有直通能力是通过读iommu硬件的ecap来获取的，而后者是通过kernel的cmdline人为设置iommu=pt来实现的。当cmdline中有“iommu=pt”（表示只对直通设备做DMA Remapping）时iommu_pass_through会设为1。如果设置为pt，则iommu_pass_through设置为1，相应的iommu_identify_mapping会设置为IDENTMAP_ALL。在这种场景下，系统会通过si_domain_init创建一个全局的dmar_domain，si_domain（statically identity mapping domain），si表示的是static即静态的，之所以说是静态的是因为si_domain会把每个node上的内存提前建立好iova到hpa的mapping。 然后 iommu_prepare_static_identity_mapping再把每个iommu下面挂着的设备跟si_domain关联起来，具体做法是说先找到这个设备所属的iommu在驱动层的表现就是找到所属的struct intel_iommu结构体，然后通过这个设备所在的bus号找到其在root_table的位置，再通过devfn创建相对应的context_entry，然后把si_dmain的pgd设置为contex_entry的基址，具体见iommu_prepare_static_identity_mapping(hw_pass_through)函数。

```C
for_each_online_node(nid) {
  unsigned long start_pfn, end_pfn;
  int i;

  for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
          ret = iommu_domain_identity_map(si_domain,
                          PFN_PHYS(start_pfn), PFN_PHYS(end_pfn));
          if (ret)
                  return ret;
  }
}
```

bus_set_iommu(&pci_bus_type, &intel_iommu_ops):这个函数主要是为pci_bus设置intel_iommu_ops，并通过iommu_bus_init做一些初化的工作。具体的工作包括
1. 为bus注册通知回调函数
2. 还有就是通过add_iommu_group给每个设备创建iommu_group，一个iommu_group可以对一个设备也可以对应多个设备，至于具体是如何分组我们看一下具体的函数实现，这段逻辑最终会调用到pci_device_group函数。这个函数的核心逻辑在于`pci_acs_path_enabled`，简单来说如果是pcie的设备则检查该设备到root complex的路径上如果都开启了ACS则这个设备就单独成一个iommu_group，如果不是则找到它的alias group就行了比如如果这个是传统的pci bus(没有pcie这些ACS的特性)则这个pci bus下面的所有设备就组合成一个iommu_group。

那么为什么要对设备进行分组呢？

我们知道PCIe允许peer-to-peer通信，即PCIe设备发出的数据包可以不一直往上提交到PCIe的根节点，而是在中间的PCIe Switch直接进行转发，转发到其他PCIe设备上。不经过根节点这样就会导致IOMMU无法控制到这种peer-to-peer的数据传输，达不到设备隔离的目的。例如p2p的两个设备一个在虚拟机内，或一个在物理机上或者另一个虚拟机内，不经过IOMMU的话，地址完全乱了。如果不希望P2P直接通信则可以使用PCIe的ACS特性。ACS是PCIe的访问控制服务，控制PCIe数据流向的。ACS可以将peer-to-peer转发的功能关闭，强制将其下所有设备通信送到RootComplex。ACS可以应用于PCIe Switch以及带有VF的PF等所有具有调度功能的节点。所以iommu分组的依据就是ACS。这个从其设备分组实现函数pci_device_group中也可以看出。

这个函数的核心逻辑在于`pci_acs_path_enabled`，从PCIe设备向上通往PCIe根节点的路径上，所有downstream port和multi-function device都要具有ACS特性，若某个downstream port或multi-function的ACS特性关闭，则下面的所有设备都必须归到同一个iommu group，否则该PCIe设备就可以独立成一个iommu group。另外PCI总线上的设备都归一个iommu group。最后同一个iommu group中所有的设备将会共享一个IOVA地址空间。因此，一个iommu group里可能有一个或多个设备。设备透传的时候一个group里面的设备必须都给一个虚拟机，不能给不同的VM，也不能部分被分配到给虚拟机。


```C
struct iommu_group *pci_device_group(struct device *dev)
{
    struct pci_dev *pdev = to_pci_dev(dev);

    /*
     * Find the upstream DMA alias for the device.  A device must not
     * be aliased due to topology in order to have its own IOMMU group.
     * If we find an alias along the way that already belongs to a
     * group, use it.
     */  
    if (pci_for_each_dma_alias(pdev, get_pci_alias_or_group, &data))
        return data.group;

    /*
     * Continue upstream from the point of minimum IOMMU granularity
     * due to aliases to the point where devices are protected from
     * peer-to-peer DMA by PCI ACS.  Again, if we find an existing
     * group, use it.
  */
 for (bus = pdev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
  if (!bus->self)
   continue;

  if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
   break;

  pdev = bus->self;
  group = iommu_group_get(&pdev->dev);
  if (group)
   return group;
   }

    /*   
     * Look for existing groups on device aliases.  If we alias another
     * device or another device aliases us, use the same group.
     */
    group = get_pci_alias_group(pdev, (unsigned long *)devfns);
    if (group)
        return group;

    /*   
     * Look for existing groups on non-isolated functions on the same
     * slot and aliases of those funcions, if any.  No need to clear
     * the search bitmap, the tested devfns are still valid.
     */
    group = get_pci_function_alias_group(pdev, (unsigned long *)devfns);
    if (group)
        return group;

 return iommu_group_alloc();
}
```

```c
struct list_head dmar_drhd_units;
static LIST_HEAD(dmar_rmrr_units);
pci_iommu_init
  └─intel_iommu_init
      ├─dmar_table_init
      ├─parse_dmar_table
      |   ├─dmar_table_detect
      |   └─dmar_walk_remapping_entries
      |       ├─dmar_parse_one_drhd
      |       |  ├─dmar_find_dmaru
      |       |  ├─dmar_alloc_dev_scope//分配好多空内存
      |       |  ├─alloc_iommu
      |       |  |   └─map_iommu
      |       |  └─dmar_register_drhd_unit
      |       ├─dmar_parse_one_rmrr
      |       ├─dmar_parse_one_atsr
      |       ├─dmar_parse_one_rhsa
      |       └─dmar_parse_one_andd
      ├─dmar_dev_scope_init
      | ├─dmar_acpi_dev_scope_init
      | |     └─for(dev_scope_num in acpi table)
      | |           ├─acpi_bus_get_device
      | |           └─dmar_acpi_insert_dev_scope//给上面注释中指的内存空间中写dev/bus
      | └─for_each_pci_dev(dev)//把非acpi上报的dev上搞到iommu中来
      |     ├─dmar_alloc_pci_notify_info
      |     ├─dmar_pci_bus_add_dev
      |     |   ├─for_each_drhd_unit//找到dev的hrhd然后加入
      |     |   |    └─dmar_insert_dev_scope
      |     |   ├─dmar_iommu_notify_scope_dev
      |     |   └─intel_irq_remap_add_device
      |     └─dmar_free_pci_notify_info
      ├─init_dmars//后面单独分析
      ├─bus_set_iommu//后面单独分析
      └─for_each_iommu
             └─iommu_enable_translation
```
单独分析init_dmars，有点复杂。
```c
init_dmars
  ├─for_each_iommu
  |   ├─intel_iommu_init_qi//软件给硬件通过这块内存提交任务，硬件清自己的iotlb缓存
  |   |   └─dmar_enable_qi
  |   |       └─__dmar_enable_qi//写硬件寄存器
  |   ├─iommu_init_domains//分配了很多struct dmar_domain
  |   └─iommu_alloc_root_entry
  ├─for_each_active_iommu
  |   ├─iommu_flush_write_buffer
  |   └─iommu_set_root_entry//写硬件寄存器
  ├─si_domain_init
  |   ├─alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY)//额外创建一个domain
  |   ├─for_each_online_node//在这个domain中dma地址和物理地址一一对应
  |   |   └─for_each_mem_pfn_range
  |   |       └─iommu_domain_identity_map
  |   |           └─__domain_mapping
  |   └─for_each_rmrr_units//rmrr内存在这个domain中一一对应
  |      └─for_each_active_dev_scope
  |           └─iommu_domain_identity_map
  └─for_each_iommu
      ├─iommu_flush_write_buffer
      └─dmar_set_interrupt//iommu硬件自己的中断
          ├─dmar_alloc_hwirq
          └─request_irq(irq, dmar_fault)
```
有四种domain，init_dmars中用到了IOMMU_DOMAIN_IDENTITY，这个类型的domain只能有一个，kvm和dpdk会用到IOMMU_DOMAIN_UNMANAGED，一个qemu或者一个dpdk进程一个domain。IOMMU_DOMAIN_BLOCKED和IOMMU_DOMAIN_DMA是内核用到，它和iommu group有关系，一个group对应一个domain，一个group有可能有多个dev，这个和pci硬件结构有关系，详见函数pci_device_group。
```c
/*
 * This are the possible domain-types
 *
 *	IOMMU_DOMAIN_BLOCKED	- All DMA is blocked, can be used to isolate  devices
 *	IOMMU_DOMAIN_IDENTITY	- DMA addresses are system physical addresses
 *	IOMMU_DOMAIN_UNMANAGED	- DMA mappings managed by IOMMU-API user, used for VMs
 *	IOMMU_DOMAIN_DMA	- Internally used for DMA-API implementations. This flag allows IOMMU drivers to implement certain optimizations for these domains
 */
```
单独分析bus_set_iommu，这个函数中有个default domain，如果内核参数iommu=pt，这个default domain就是唯一类型为IOMMU_DOMAIN_IDENTITY的si，如果内核参数iommu=nopt就是类型为IOMMU_DOMAIN_DMA的domain，内核参数没有iommu，默认为IOMMU_DOMAIN_IDENTITY。
```c
bus_set_iommu
  └─iommu_bus_init
      ├─bus_iommu_probe//处理bus上的设备
      |   ├─bus_for_each_dev//给dev分配group，
      |   |   └─probe_iommu_group
      |   |        └─__iommu_probe_device
      |   |             ├─intel_iommu_probe_device
      |   |             └─iommu_group_get_for_dev
      |   |                   └─pci_device_group//真正决定group的函数
      |   └─for_each_group
      |        ├─probe_alloc_default_domain//给内核管理的dev分配default domain
      |        ├─iommu_group_create_direct_mappings//对系统保留区分建立mapping，如dev和ioapic的关系
      |        |   └─iommu_create_device_direct_mappings
      |        |       ├─list_for_each_entry
      |        |       |   ├─iommu_iova_to_phys
      |        |       |   └─iommu_map
      |        |       └─iommu_flush_iotlb_all
      |        ├─__iommu_group_dma_attach
      |        |     └─dmar_insert_one_dev_info//创建这个dev在IOMMU中的转换表
      |        └─__iommu_group_dma_finalize
      |              └─intel_iommu_probe_finalize
      |                  └─iommu_dma_init_domain//给dev分配iova并且flush到硬件上
      └─bus_register_notifier(iommu_bus_notifier)//用于处理hotplug的设备
```
初始化工作准备了设备动态运行时要用到的数据和函数，后面就得分析设备动态运行时做了什么操作，调用了哪些函数。


- struct inte_iommu：iommu硬件在驱动层所对应的概念
- struct iommu_group: 一个group下面可以对应多个或者一个硬件设备
- struct dmar_domain: dmar_domain里面存储的是iova->hpa的转换页表（即一个IOVA映射空间），一个dmar_domain可以为多个或者一个设备服务。
- struct iommu_domain: iommu_domain作为dmar_domain的成员，主要存放iommu核心层的通用数据信息，如iommu_ops，同时作为group和dmar_domain的关联，一个iommu_domain里面可以有多个iommu_group，然后每个iommu_group通过iommu_domain最终找到dmar_domain进行转换。


根据bdf号进行iova转换流程：
1. device to domain mapping 
2. addrss translation



REF：
https://zhuanlan.zhihu.com/p/492749752
https://zhuanlan.zhihu.com/p/479963917

https://zhuanlan.zhihu.com/p/479988393
https://www.eet-china.com/mp/a118067.html

https://www.owalle.com/2021/11/01/iommu-code/




## api

- struct iommu_domain
- struct dmar_domain
- struct iommu_domain_info
- struct intel_iommu
static void intel_flush_iotlb_all(struct iommu_domain *domain)