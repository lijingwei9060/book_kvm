# 初始化过程
ACPI与PCI的关系，需要描述。



acpi_init
acpi_pci_root_init
acpi_pci_link_init

postcore_initcall(pcibus_class_init);
class_register(&pcibus_class);

## 全局变量

acpi_pci_disabled： 
pci_use_crs=true
pci_use_e820=true
acpi_scan_handlers_list: 全局list，用于scan设备的handler，包含attach、hotplug等

## 枚举过程

命令行参数
pci=use_crs  pci=nocrs
pci=use_e820 pci=no_e820

PCI设备的枚举只是ACPI要实现的一个功能之一。

在acpi初始化`acpi_scan_init`过程中:
1. `acpi_pci_root_init`完成PCI设备的相关操作（包括PCI主桥，PCI桥、PCI设备的枚举，配置空间的设置，总线号的分配等）,定义`pcie host bridge device`的`pci_root_handler->attach`函数, ACPI的Definition Block中使用PNP0A03表示一个PCI Host Bridge。
   1. `pci_acpi_crs_quirks`检查Bios日期是否是2008年以后的，如果不是则kernel将pci_use_crs变量置为false(默认是true)。用户也可以在cmd_line中加入“pci=use_crs”表示将使用ACPI提供的`PCI Host Bridge Windows Info`(即Bar资源)，或者“pci=nocrs”表示将不使用ACPI提供的`PCI Host Bridge Windows Info`。
   2. 如果是2023以后，`pci_use_e820=false`
   3. `acpi_scan_add_handler`向全局变量`acpi_scan_handlers_list`中插入pci host bridge的attach处理函数。root_device_ids的值是“PNP0A03”,而在ACPI spec中ACPI_ID值为PNP0A03表示PCI Host Bridge。
   4. `acpi_sysfs_add_hotplug_profile`向sysfs追加hotplug处理函数。
   5. 后面在`acpi_bus_scan(ACPI_ROOT_OBJECT)`中会通过遍历system中所有的acpi dev,并为这些acpi dev创建数据结构。之后会将acpi dev的acpi Id值与注册的device handler中的acpi Id值匹配，如果匹配成功则执行相应的handler->attach函数。
2. acpi_pci_link_init注册`pci_link_handler`， 完成PCI中断的相关操作
3. `acpi_bus_scan`会通过`acpi_walk_namespace`会遍历system中所有的device，并为这些acpi device创建数据结构，执行对应device的attatch函数。根据ACPI spec定义，pcie host bridge device定义在`DSDT`表中，acpi在扫描过程中扫描DSDT，如果发现了pcie host bridge, 就会执行device对应的attach函数，调用到`acpi_pci_root_add`()。
4. `acpi_pci_root_add`
   1. 通过ACPI的_SEG参数, 获取host bridge使用的segment号， segment指的就是pcie domain, 主要目的是为了突破pcie最大256条bus的限制。
   2. 通过ACPI的_CRS里的BusRange类型资源取得该Host Bridge的Secondary总线范围，保存在root->secondary这个resource中。
   3. 通过ACPI的_BNN参数获取host bridge的根总线号。执行到这里如果没有返回失败，硬件设备上会有如下打印：ACPI: PCI Root Bridge [PCI0](domain 0000 [bus 00-7f])。
5. pci_acpi_scan_root： 枚举PCI入口
6. acpi_pci_root_create函数去对这条PCI总线进行遍历，在这里我们需注意一个结构就是acpi_pci_root_ops，它是新版本的内核提供给我们对于PCI信息的一些接口函数的集合（这其中就包括对配置空间的读写方法）
7. pci_scan_child_bus扫描子总线
8. pci_scan_single_device/pci_scan_device扫描一个的设备，分配pci_device，初始化vendor、device id;
9.  pci_setup_device读取pcie设备的头部信息，读取中断，读取寄存器的基地址，标准设备（6个bar），pcie桥设备（2个bar），cardbus桥（1个bar），ide控制器配置，最终初始化pci_dev结构。
10. pci_device_add将扫描到的pci_device添加到pci_bus上。
11. pci_scan_bridge本函数调用了两次（通过for循环），原因是：在不同架构的对于PCI设备的枚举实现是不同的，例如在x86架构中有BIOS为我们提前去遍历一遍PCI设备，但是在ARM或者powerPC中uboot是没有这种操作的，所以为了兼容这两种情况，这里就执行两次对应于两种不同的情况，当pci_scan_slot函数执行完了后，我们就得到了一个当前PCI总线的设备链表，在执行pci_scan_bridge函数前，会遍历这个设备链表，如果存在PCI桥设备，就调用pci_scan_bridge函数，而在本函数内部会再次调用pci_scan_child_bus函数，去遍历子PCI总线设备（注意：这时的BUS就已经不是PCI BUS 0了）就是通过这种一级一级的递归调用，在遍历总PCI总线下的每一条PCI子总线。直到某条PCI子总线下无PCI桥设备，就停止递归，并修改subbordinate参数，（最大PCI总线号）返回。