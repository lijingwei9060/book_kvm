# 初始化过程
ACPI与PCI的关系，需要描述。



acpi_init
acpi_pci_root_init
acpi_pci_link_init

postcore_initcall(pcibus_class_init);
class_register(&pcibus_class);

## 全局变量

acpi_scan_initialized = false: acpi scan完成了吗？
acpi_pci_disabled： 
pci_use_crs=true
pci_use_e820=true
acpi_scan_handlers_list: 全局list，用于scan设备的handler，包含attach、hotplug等


## 数据结构

系统初始化过程中和基于ACPI的设备热拔插过程中，ACPI扫描命名空间查找各种硬件信息，对应的会创建`acpi_device`对象，并注册对应的驱动函数。扫描通过扫描acpi_device_id查找对应的扫描函数`acpi_scan_handler`
acpi_status
acpi_object
acpi_buffer
- acpi_device
   - u32 pld_crc;
   - int device_type;
   - acpi_handle handle;		/* no handle for fixed hardware */
   - struct fwnode_handle fwnode;
   - struct list_head wakeup_list;
   - struct list_head del_list;
   - struct acpi_device_status status;
   - struct acpi_device_flags flags;
   - struct acpi_device_pnp pnp;
   - struct acpi_device_power power;
   - struct acpi_device_wakeup wakeup;
   - struct acpi_device_perf performance;
   - struct acpi_device_dir dir;
   - struct acpi_device_data data;
   - struct acpi_scan_handler *handler;
   - struct acpi_hotplug_context *hp;
   - const struct acpi_gpio_mapping *driver_gpios;
   - void *driver_data;
   - struct device dev;
   - unsigned int physical_node_count;
   - unsigned int dep_unmet;
   - struct list_head physical_node_list;
   - struct mutex physical_node_lock;
   - void (*remove)(struct acpi_device *);
- acpi_pci_root
   - struct acpi_device * device;
   - struct pci_bus *bus;
   - u16 segment;
   - int bridge_type;
   - struct resource secondary;	/* downstream bus range */ 
   - u32 osc_support_set;		/* _OSC state of support bits */
   - u32 osc_control_set;		/* _OSC state of control bits */
   - u32 osc_ext_support_set;	/* _OSC state of extended support bits */
   - u32 osc_ext_control_set;	/* _OSC state of extended control bits */
   - phys_addr_t mcfg_addr;
- acpi_scan_handler: id代表次handler支持的扫描对象，list_node是全局的列表保存handler列表，指向`acpi_scan_handlers_list`, 有attach（找到设备病初始化）、detach和hotplug函数
- acpi_handle
- acpi_pci_root_ops
- pci_bus： 表示PCI总线的数据结构，用于存储和管理PCI设备的信息，包括该总线上的设备列表、子总线等。
- pci_device_id：用于表示一个PCI设备的标识信息，包括设备的厂商ID、设备ID、子系统厂商ID、子系统ID等，用于在内核中匹配和识别PCI设备。
- pci_dev: 表示一个PCI设备的数据结构，用于存储和管理PCI设备的属性信息，包括设备的地址、中断号、资源分配等。
- resource：表示一个设备的资源，包括IO地址空间、内存地址空间等，用于描述和管理设备的资源分配情况。
- pci_sysdata
- pci_root_info
- pci_host_bridge
- 
- 
## 枚举过程

命令行参数
pci=use_crs  pci=nocrs
pci=use_e820 pci=no_e820

PCI设备的枚举只是ACPI要实现的一个功能之一。

subsys_initcall(acpi_init) ->acpi_scan_init

调用树
```C
acpi_scan_init
|-> acpi_pci_root_init() // 完成PCI设备的相关操作(包括PCI主桥，PCI桥、PCI设备的枚举，配置空间的设置，总线号的分配等)
|-> acpi_pci_link_init() // 完成PCI中断的相关操作
|-> acpi_scan_add_handler(&generic_device_handler)
|-> acpi_bus_scan(ACPI_ROOT_OBJECT) // 利用注册的attach函数进行初始化扫描
|-> acpi_root = acpi_fetch_acpi_dev(ACPI_ROOT_OBJECT)
|-> acpi_turn_off_unused_power_resources()
|-> acpi_scan_initialized = true



```



在acpi初始化`acpi_scan_init`过程中:
1. `acpi_pci_root_init`完成PCI设备的相关操作（包括PCI主桥，PCI桥、PCI设备的枚举，配置空间的设置，总线号的分配等）,定义pcie主桥的`pci_root_handler->attach`函数, ACPI的Definition Block中使用PNP0A03表示一个PCI Host Bridge。
   1. `pci_acpi_crs_quirks`检查Bios日期是否是2008年以后的，如果不是则kernel将pci_use_crs变量置为false(默认是true)。用户也可以在cmd_line中加入“pci=use_crs”表示将使用ACPI提供的`PCI Host Bridge Windows Info`(即Bar资源)，或者“pci=nocrs”表示将不使用ACPI提供的`PCI Host Bridge Windows Info`。
   2. 如果是2023以后，`pci_use_e820=false`，这是bios有bug，爆出来的内存有问题，参考[Add pci=no_e820 cmdline option to ignore E820 reservations for bridge windows](https://lore.kernel.org/all/20211005150956.303707-1-hdegoede@redhat.com/T/)。
   3. `acpi_scan_add_handler`向全局变量`acpi_scan_handlers_list`中插入pci host bridge的`pci_root_handler->attach`处理函数。root_device_ids的值是“PNP0A03”,而在ACPI spec中ACPI_ID值为PNP0A03表示PCI Host Bridge。
   4. `acpi_sysfs_add_hotplug_profile`向sysfs追加hotplug处理函数。
   5. 后面在`acpi_bus_scan(ACPI_ROOT_OBJECT)`中会通过遍历system中所有的acpi dev,并为这些acpi dev创建数据结构。之后会将acpi dev的acpi Id值与注册的device handler中的acpi Id值匹配，如果匹配成功则执行相应的handler->attach函数。
2. acpi_pci_link_init注册`pci_link_handler`， 完成PCI中断的相关操作
3. `acpi_bus_scan`会通过`acpi_walk_namespace`会遍历system中所有的device，并为这些acpi device创建数据结构，执行对应device的attatch函数。根据ACPI spec定义，pcie host bridge device定义在`DSDT`表中，acpi在扫描过程中扫描DSDT，如果发现了pcie host bridge, 就会执行device对应的attach函数，调用到`acpi_pci_root_add`()。
4. `acpi_pci_root_add`开始PCIE/PCI设备的枚举
   1. 系统调用kzalloc分配`acpi_pci_root`结构体，用来表示Host Bridge信息。
   2. 通过`acpi_evaluate_integer`函数获取acpi table中acpi Host Bridge dev `METHOD_NAME__SEG=="_SEG"`保存到root->segment。通过ACPI的_SEG参数, 获取host bridge使用的segment号， segment指的就是pcie domain, 主要目的是为了突破pcie最大256条bus的限制。
   3. 通过`try_get_root_bridge_busnr`查询ACPI的_CRS里的BusRange类型资源取得该Host Bridge的Secondary总线范围，保存在root->secondary这个resource中。
   4. 上一步失败 => 通过`acpi_evaluate_integer`获取ACPI的_BNN参数获取host bridge的根总线号。执行到这里如果没有返回失败，硬件设备上会有如下打印：ACPI: PCI Root Bridge [PCI0](domain 0000 [bus 00-7f])。
   5. 设置`device.pnp.device_name = "PCI Root Bridge"`, `device.pnp.device_class = "pci_bridge"`。
   6. 设置`device.driver_data = root(acpi_pci_root)`
   7. 如果是hostplug，调用`dmar_device_add(handle)`
   8. 调用acpi_pci_root_get_mcfg_addr函数获取acpi host bridge dev节点中的mcfg (Memory mapped Configuration Base Address)地址并保存到root->mcfg_addr中,实现就是查询ACPI表中的METHOD_NAME__CBA字段。
   9. 判断硬件类型acpi_hardware_id，判断device->pnp.ids->id是否等于"PNP0A08"，如果相等则`root->bridge_type = ACPI_BRIDGE_TYPE_PCIE`, 表示acpi host bridge dev支持PCIE Root Bridge。
   10. 判断device->pnp.ids->id是否等于"ACPI0016"，如果相等`root->bridge_type = ACPI_BRIDGE_TYPE_CXL`, 表示acpi host bridge dev支持CXL。(这个地方有点没太明白，明明是PCI设备，怎么)
   11. 调用函数`negotiate_os_control`通过acpi _osc method协商Bios和OS对PCIE Feature的控制权。相关打印信息如下：
   acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
   acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR]
   acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
   12. 完成root结构体的初始化后，调用`pci_acpi_scan_root(root)`函数开始扫描Root Bridge完成PCIE/PCI设备的枚举。
   13. `pci_acpi_add_bus_pm_notifier(device)` 注册电源管理通知
   14. `device_set_wakeup_capable` 设置唤醒能力
   15. 如果是hotplug的还需要`pcibios_resource_survey_bus`，`pci_assign_unassigned_root_bus_resources`，`acpi_ioapic_add`
   16. `pci_bus_add_devices`添加pci_bus总线
5. pci_acpi_scan_root： 枚举PCI入口
   1. 调用`pci_find_bus(domain,busnum)`在全局变量的bus list `pci_root_buses`中查找domain为root->segment，busnum为root->secondary.start的bus。如果该函数返回的bus存在则表示root bus已经被扫描过了(只有扫描过后，才会将bus的信息插入到bus list中，因为这里是第一次扫描所以该函数返回的bus为空)，将struct pci_sysdata sd的内容复制到bus->sysdata中。
   2. 查不到就表示首次扫描，首先创建`struct pci_root_info`结构体，完成以下变量的赋值 info->sd。调用函数`acpi_pci_root_create(root,&acpi_pci_root_ops,&info->common, &info->sd)`
6. `acpi_pci_root_create`函数去对这条PCI总线进行遍历，在这里我们需注意一个结构就是`acpi_pci_root_ops`，它是新版本的内核提供给我们对于PCI信息的一些接口函数的集合（这其中就包括对配置空间的读写方法）
   1. 检查ops->init_info函数是否存在，如果存在则执行ops->init_info函数。其中ops就是传递进来的参数acpi_pci_root_ops。其中ops->init_info = pci_acpi_root_init_info。在函数pci_acpi_root_init_info中首先初始化pci_root_info结构体，之后调用函数pci_mmconfig_insert为Host Bridge dev增加MMCFG信息。
   2. 检查ops-> prepare_resources函数是否存在，如果存在则执行ops->prepare_resources函数，否则执行acpi_pci_probe_root_resources(info)函数。其中ops->prepare_resources函数最终指向函数`pci_acpi_prepare_resources`。在该函数中首先调用函数`acpi_pci_probe_root_resources`通过执行acpi host bridge dev中定义的_CRS method从acpi host bridge dev中获取root bus resources。将获取的root bus resources保存到info->resources中。
   3. 调用函数`pci_acpi_root_add_resources(info)`将获取的Host Bridge resources按照IO还是Memory的属性插入到`iomem_resource`或者`ioport_resource`的resources tree中。
   4. 调用`pci_add_resource`(&info->resources,&root->secondary)函数将info->resources插入到root->secondary resource_entry中。
   5. 调用函数`pci_create_root_bus`创建并初始化`pci_host_bridge`结构体.之后调用pci_register_host_bridge创建并初始化pci_bus结构体。该bus就表示Host Bridge下的secondary bus即bus 0。调用pci_find_bus(pci_domain_nr(bus),bridge->busnr)尝试在pci bus list中查找domain为pci_domain_nr(bus)，bus num为bridge->busnr的bus struct是否存在。如果存在则说明bus已经注册过了，系统将从此处退出。
   6. 根据之前函数`negotiate_os_control`的执行结果，更新host_bridge->native_pcie_hotplug，native_shpc_hotplug，native_aer，native_pme，native_ltr，native_dpc的值(之前被系统全部赋值为1)。
   7. 在完成pci host bridge dev的resource获取和初始化后，系统调用pci_scan_child_bus(bus)开始扫描bus 0下的所有devfunc。
   8. 调用函数pci_set_host_bridge_release设置bridge->release_fn的函数指针。
7. pci_scan_child_bus扫描bus 0下的所有pcie/pci设备, 调用函数pci_scan_child_bus_extend(bus,0)完成扫描设备的工作。
   1. 系统调用函数`pci_scan_slot(bus，devfn)`来扫描bus号为0上挂接的所有dev。
   2. 执行pcibios_fixup_bus函数。在该函数中首先调用函数pci_read_bridge_bases读取当前pci桥的I/O Limit, I/O Base, Memory Limit, Memory Base, Prefetchable Memory Limit和Prefetchable Memory Base寄存器，并根据这些寄存器的值初始化pci_bus->resource参数，该参数存放当前PCI桥所能管理的地址空间。之后遍历该bus下所有的pci dev，为每个pci设备调用函数pcibios_fixup_device_resources。该函数的主要作用是如果用户在cmdline中加入“pci=nobar”或者“pci=norom”，在系统中不再为那些Bios没有分配的Bar或者Rom Bar分配Bar资源。
8. pci_scan_slog(bus,devfn)
   1. 调用only_one_child(bus)检查该bus所在的Host Bridge dev是否是PCIE Bridge dev且devfn的值大于0时，则表示已经扫描过该bus下的所有dev了，则函数从此处返回。
   2. 调用pci_scan_single_device(bus,devfn)
9.  pci_scan_single_device/pci_scan_device扫描一个的设备，分配pci_device，初始化vendor、device id;
    1.  检查该设备是否已经被枚举并加入到bus->dev中(通过pci_get_slot(bus,devfn)来完成)，如果已经被枚举则从此处返回。
    2.  如果在bus->dev列表中没有找到该dev,则调用pci_scan_device(bus,devfn)检查该dev(设备的BDF号就是传入的参数)是否存在(通过pci_bus_read_dev_vendor_id)，之后调用函数pci_alloc_dev函数创建新扫描到的pci_dev结构体用来管理新扫描到的pcie/pci设备
    3.  之后调用函数pci_setup_device(dev)初始化pci dev结构体中的设备信息。  
    4.  调用pci_device_add(dev,bus)进行pci dev的配置空间初始化和结构体初始化。
10. pci_setup_device读取pcie设备的头部信息，读取中断，读取寄存器的基地址，标准设备（6个bar），pcie桥设备（2个bar），cardbus桥（1个bar），ide控制器配置，最终初始化pci_dev结构。
    1.  调用pci_hdr_type首先确定pci dev的header type，并初始化
    2.  调用set_pcie_port_dev(dev)函数获取pcie capability的位置以及pcie dev capabikity和pcie Max_Payload_Size的值并记录在dev相对应的位置
    3.  调用函数pci_class获取dev的class类别并保存到dev->class中。在确定扫描到dev type类型后，就需要按照dev type进行寄存器的初始化工作。如果dev header type是标准的header，则首先调用pci_read_irq(dev)从pci config space的interrupt pin和interrupt line中获取pin和line的值并保存到dev->pin和dev->irq中。调用函数pci_read_bases(dev,6,PCI_ROM_ADDRESS)获取bios默认分配的pci bar空间的resource并保存到dev->resource[pos]中。如果dev的class type等于PCI_CLASS_STORAGE_IDE还需要对bar resource进行重新分配。如果dev header type是PCI-PCI bridge则首先调用pci_read_irq函数初始化interrupt line和interrupt pin的值，之后调用函数pci_read_bases(dev,2,PCI_ROM_ADDRESS1)初始化PCI Bridge bar resource和PCI Bridge ROM resource的值。调用函数pci_read_bridge_windows初始化pci bridge dev的PCI_IO_BASE和PCI_PREF_MEMORY_BASE以及PCI_PREF_BASE_UPPER32的寄存器值。调用函数set_pcie_hotplug_bridge查看pcie dev是否支持hot plug功能，如果支持则将pdev->is_hotplug_bridge置1。如果dev header type是CardBus Bridge dev，则系统调用pci_read_irq函数和pci_read_bases(dev,1,0)完成CardBus Bridge的bar资源初始化工作。
11. pci_device_add将扫描到的pci_device添加到pci_bus上。
    1.  调用pci_configure_device函数初始化设备的mps, extended_tags, relaxed_ordering, ltr, eetlp_prefix,hp_params相关功能寄存器配置。
    2.  调用device_initialize(&dev->dev)结构体的初始化。
    3.  调用函数pci_init_capabilities完成pcie/pci设备功能的寄存器初始化工作(drivers/pci/probe.c)。
    4.  调用函数list_add_tail(&dev->bus_list,&bus->devices)将新扫描到的dev结构体插入到bus->devices中。
    5.  调用pci_scan_single_device(bus, devfn + fn)查看该dev是否支持多fun功能，如果支持则将扫描到的每个func都当成一个新的pci dev插入到bus->devices中。
12. pci_scan_bridge本函数调用了两次（通过for循环），原因是：在不同架构的对于PCI设备的枚举实现是不同的，例如在x86架构中有BIOS为我们提前去遍历一遍PCI设备，但是在ARM或者powerPC中uboot是没有这种操作的，所以为了兼容这两种情况，这里就执行两次对应于两种不同的情况，当pci_scan_slot函数执行完了后，我们就得到了一个当前PCI总线的设备链表，在执行pci_scan_bridge函数前，会遍历这个设备链表，如果存在PCI桥设备，就调用pci_scan_bridge函数，而在本函数内部会再次调用pci_scan_child_bus函数，去遍历子PCI总线设备（注意：这时的BUS就已经不是PCI BUS 0了）就是通过这种一级一级的递归调用，在遍历总PCI总线下的每一条PCI子总线。直到某条PCI子总线下无PCI桥设备，就停止递归，并修改subbordinate参数，（最大PCI总线号）返回。