# 初始化过程

PCI-e 初始化可以分为以下几步：
1. 获得 PCI-e 设备配置空间
2. 为设备加载相应的驱动程序
3. 由驱动程序完成硬件配置 


ECAM (Enhanced Configuration Address Mapping) 基址由固件或桥设备提供

ACPI 体系计算机的 ECAM 基址 (Base address of enhanced configuration mechanism) 储存在 MCFG 中。
1. 0-3：   MCFG
2. 4-7：   长度(byte)
3. 8:      revision
4. 9:      checksum(所有字节sum & 0xFF = 0)
5. 10-15:  OEM ID
6. 16-23:  OEM Table id( manufacturer model id)
7. 24-27:  OEM Revision 
8. 28-31:  Creator ID
9. 32-35:  Creator Revision
10. 36-44: Reserved
11. 44 + (16*n): 
    1.  0-7: base address of enchanced configuration mechanism
    2.  8-9: pci segment group number
    3.  10:  start pci bus number
    4.  11:  end pci bus number
    5.  12-: Reserved

获取 ECAM 基址的具体方式：

1. 系统在初始化时，先获取 RSDP （Root System Description Ptr）,不同平台拥获取 RSDP 实现方法不同，具体见 ACPI_Spec 的 5.2.5 Root System Description Pointer (RSDP) 章节 
2. 根据 RSDP 找到 RSDT ( Root System Decription ) 或 XSDT ( Extend System Decription )XSDT 目的是取代 RSDT 而并非 RSDT 的拓展。所以，所以这里就只提 XSDT。固件加载 boot*.efi 后，会将 SystemTable 传入主函数。详细的内容后续会补充在 UEFI 引导编写教程的相关章节。EDK2 规范中指明的 XSDT 位置 ：SystemTable -> XSDT -> MCFG, 通过 图 APCI MCFG Table 构建结构体，即可导出ECAM基址 (Base address of enhanced configuration mechanism) 


ACPI与PCI的关系，需要描述。

acpi_init
acpi_pci_root_init
acpi_pci_link_init

postcore_initcall(pcibus_class_init) -> class_register(&pcibus_class); 注册pci_bus class，完成后创建了/sys/class/pci_bus目录。
pci_driver_init(): 注册pci_bus_type, 完成后创建了/sys/bus/pci目录。
acpi_pci_init(): 注册acpi_pci_bus, 并设置电源管理相应的操作。
acpi_init(): apci启动所涉及到的初始化流程，PCIe基于acpi的启动流程从该接口进入。

## kernel 初始化流程

pcibus_class_init： 注册pci设备class， class_register(pcibus_class)，完成后创建了/sys/class/pci_bus目录
pci_driver_init: 注册pci总线和pcie总线，总线的驱动，完成后创建了/sys/bus/pci目录
acpi_pci_init: ACPI下对PCI总线的枚举操作，ACPI的Definition Block中使用PNP0A03表示一个PCI Host Bridge。
- acpi_pci_root_add设备枚举,函数首先通过_SEG确定该PCI Host bridge(这个在root complex里面，也就是iommu)的segment group,随后通过_CRS里的BusRange类型资源取得该Host Bridge的Secondary总线范围，保存在root->secondary这个resource中。
- 然后设置基本属性
- _CBA对象中可以保存这个PCI Host Bridge的用于MMCONFIG枚举的基址
- pci_acpi_scan_root函数枚举这个Host Bridge上的设备, 该函数是一个平台相关的函数
acpi_init(): apci启动所涉及到的初始化流程，PCIe基于acpi的启动流程从该接口进入。
pci_arch_init
pci_slot_init
pci_subsys_init
pcibios_assign_resources5
pci_apply_final_quirks5s
pci_iommu_initrootfs
pci_proc_init6
pcie_portdrv_init6
pci_hotplug_init6
pci_stub_init6
dw_pci_driver_init6
virtio_pci_driver_init6
serial_pci_driver_init6
exar_pci_driver_init6
lpss8250_pci_driver_init6
mid8250_pci_driver_init6
intel_lpss_pci_driver_init6
ehci_pci_init6
ohci_pci_init6
xhci_pci_init6
tcpci_i2c_driver_init6
pci_resource_alignment_sysfs_init7
pci_sysfs_init7
pci_mmcfg_late_insert_resources7


## acpi pci 初始化

ACPI Namespace就是表示系统上所有可枚举的ACPI设备的层次结构。

现在对acpi_init()流程展开，主要找和pci初始化相关的调用:

acpi_init() /* subsys_initcall(acpi_init) */
    +-> mmcfg_late_init()
    +-> acpi_scan_init()
        +-> acpi_pci_root_init()
            +-> acpi_scan_add_handler_with_hotplug(&pci_root_handler, "pci_root");
                +-> .attach = acpi_pci_root_add
        /*
         * register pci_link_handler to list: acpi_scan_handlers_list.
         * this handler has relationship with PCI IRQ.
         */
        +-> acpi_pci_link_init()
        /* we facus on PCI-ACPI, ignore other handlers' init */
        ...
        +-> acpi_bus_scan()
            /* create struct acpi_devices for all device in this system */
            --> acpi_walk_namespace()
            --> acpi_bus_attach()
                --> acpi_scan_attach_handler()
                    --> acpi_scan_match_handler()
                    --> handler->attach /* attach is acpi_pci_root_add */

1. mmcfg_late_init(), acpi先扫描MCFG表，MCFG表定义了ecam的相关资源。
2. acpi_pci_root_init()，定义pcie host bridge device的attach函数, ACPI的Definition Block中使用PNP0A03表示一个PCI Host Bridge。
3. acpi_pci_link_init(), 注册pci_link_handler, 主要和pcie IRQ相关。
4. acpi_bus_scan(), 会通过acpi_walk_namespace()会遍历system中所有的device，并为这些acpi device创建数据结构，执行对应device的attatch函数。根据ACPI spec定义，pcie host bridge device定义在DSDT表中，acpi在扫描过程中扫描DSDT，如果发现了pcie host bridge, 就会执行device对应的attach函数，调用到acpi_pci_root_add()。

acpi_pci_root_add的函数很长，完整代码就不贴了, 它主要做了几个动作
(1)通过ACPI的_SEG参数, 获取host bridge使用的segment号， segment指的就是pcie domain, 主要目的是为了突破pcie最大256条bus的限制。
(2)通过ACPI的_CRS里的BusRange类型资源取得该Host Bridge的Secondary总线范围，保存在root->secondary这个resource中
(3)通过ACPI的_BNN参数获取host bridge的根总线号。
执行到这里如果没有返回失败，硬件设备上会有如下打印：

pci_acpi_scan_root, pcie枚举流程的入口： 
pr_info(PREFIX "%s [%s](domain %04x %pR)\n",
        acpi_device_name(device), acpi_device_bid(device),
        root->segment, &root->secondary);
...
ACPI: PCI Root Bridge [PCI0](domain 0000 [bus 00-7f])


acpi_pci_init 和PCI有关的初始化acpi_init->acpi_scan_init->acpi_pci_root_init / acpi_bus_scan


static struct acpi_scan_handler pci_root_handler = {
	.ids = root_device_ids,
	.attach = acpi_pci_root_add,
	.detach = acpi_pci_root_remove,
	.hotplug = {
		.enabled = true,
		.scan_dependent = acpi_pci_root_scan_dependent,
	},
};
 
void __init acpi_pci_root_init(void)
{
	acpi_hest_init();
	if (acpi_pci_disabled)
		return;
 
	pci_acpi_crs_quirks();
	acpi_scan_add_handler_with_hotplug(&pci_root_handler, "pci_root");
}

acpi_bus_scan(ACPI_ROOT_OBJECT)
->acpi_bus_attach(device);
  ->acpi_scan_attach_handler(device);

static int acpi_scan_attach_handler(struct acpi_device *device)
{
	struct acpi_hardware_id *hwid;
	int ret = 0;
 
	list_for_each_entry(hwid, &device->pnp.ids, list) {
		const struct acpi_device_id *devid;
		struct acpi_scan_handler *handler;
 
		handler = acpi_scan_match_handler(hwid->id, &devid);
		if (handler) {
			if (!handler->attach) {
				device->pnp.type.platform_id = 0;
				continue;
			}
			device->handler = handler;
			ret = handler->attach(device, devid);
			if (ret > 0)
				break;
 
			device->handler = NULL;
			if (ret < 0)
				break;
		}
	}
 
	return ret;
}

遍历的链表就是上面注册的，可以看到先acpi_scan_match_handler，就是分别通过match和id进行匹配，如果匹配成功了就执行handler的attach函数，这就对应到了上面的acpi_pci_root_add函数，函数比较长，分段来看：

static int acpi_pci_root_add(struct acpi_device *device,
			     const struct acpi_device_id *not_used)
{
	unsigned long long segment, bus;
	acpi_status status;
	int result;
	struct acpi_pci_root *root;
	acpi_handle handle = device->handle;
	int no_aspm = 0;
	bool hotadd = system_state == SYSTEM_RUNNING;
 
	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
	if (!root)
		return -ENOMEM;
 
	segment = 0;
	status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
				       &segment);
    ...
 
	/* Check _CRS first, then _BBN.  If no _BBN, default to zero. */
	root->secondary.flags = IORESOURCE_BUS;
	status = try_get_root_bridge_busnr(handle, &root->secondary);
    ...
 
	root->device = device;
	root->segment = segment & 0xFFFF;
	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
	device->driver_data = root;
 
	if (hotadd && dmar_device_add(handle)) {
		result = -ENXIO;
		goto end;
	}
 
	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
	       acpi_device_name(device), acpi_device_bid(device),
	       root->segment, &root->secondary);
 
	root->mcfg_addr = acpi_pci_root_get_mcfg_addr(handle);
 
	negotiate_os_control(root, &no_aspm);
    ...
}

上述过程就是分配一个acpi_pci_root，并对其进行初始化，一般情况下仅含有一个HOST桥。

struct acpi_pci_root {
	struct acpi_device * device;
	struct pci_bus *bus;
	u16 segment;
	struct resource secondary;	/* downstream bus range */
 
	u32 osc_support_set;	/* _OSC state of support bits */
	u32 osc_control_set;	/* _OSC state of control bits */
	phys_addr_t mcfg_addr;
};
通过ACPI表获取HOST主桥的segment和bus号
看一下填充后在虚拟机上的打印信息：

[    0.212357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
来看下后半部分：

/*
	 * Scan the Root Bridge
	 * --------------------
	 * Must do this prior to any attempt to bind the root device, as the
	 * PCI namespace does not get created until this call is made (and
	 * thus the root bridge's pci_dev does not exist).
	 */
	root->bus = pci_acpi_scan_root(root);
 
	if (no_aspm)
		pcie_no_aspm();
 
	pci_acpi_add_bus_pm_notifier(device);
	device_set_wakeup_capable(root->bus->bridge, device->wakeup.flags.valid);
 
	if (hotadd) {
		pcibios_resource_survey_bus(root->bus);
		pci_assign_unassigned_root_bus_resources(root->bus);
		/*
		 * This is only called for the hotadd case. For the boot-time
		 * case, we need to wait until after PCI initialization in
		 * order to deal with IOAPICs mapped in on a PCI BAR.
		 *
		 * This is currently x86-specific, because acpi_ioapic_add()
		 * is an empty function without CONFIG_ACPI_HOTPLUG_IOAPIC.
		 * And CONFIG_ACPI_HOTPLUG_IOAPIC depends on CONFIG_X86_IO_APIC
		 * (see drivers/acpi/Kconfig).
		 */
		acpi_ioapic_add(root->device->handle);
	}
 
	pci_lock_rescan_remove();
	pci_bus_add_devices(root->bus);
	pci_unlock_rescan_remove();
	return 1;

pci_acpi_scan_root枚举PCI设备

[arch/x86/pci/acpi.c]

struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
{
	int domain = root->segment;
	int busnum = root->secondary.start;
	int node = pci_acpi_root_get_node(root);
	struct pci_bus *bus;
 
	bus = pci_find_bus(domain, busnum);
	if (bus) {
        ...
		memcpy(bus->sysdata, &sd, sizeof(sd));
	} else {
		struct pci_root_info *info;
 
		info = kzalloc_node(sizeof(*info), GFP_KERNEL, node);
		if (!info)
			dev_err(&root->device->dev,
				"pci_bus %04x:%02x: ignored (out of memory)\n",
				domain, busnum);
		else {
			info->sd.domain = domain;
			info->sd.node = node;
			info->sd.companion = root->device;
			bus = acpi_pci_root_create(root, &acpi_pci_root_ops,
						   &info->common, &info->sd);
		}
	}
 
    ...
 
	return bus;
}

通过pci_find_bus查找HOST Bridge对应的segment，bus num有没有被注册，如果注册了就更新一下信息，没有注册则调用acpi_pci_root_create创建,该函数中有两个比较重要，一个是pci_create_root_bus

struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
		struct pci_ops *ops, void *sysdata, struct list_head *resources)
{
	int error;
	struct pci_host_bridge *bridge;
 
	bridge = pci_alloc_host_bridge(0);
	if (!bridge)
		return NULL;
 
	bridge->dev.parent = parent;
 
	list_splice_init(resources, &bridge->windows);
	bridge->sysdata = sysdata;
	bridge->busnr = bus;
	bridge->ops = ops;
 
	error = pci_register_host_bridge(bridge);
	if (error < 0)
		goto err_out;
 
	return bridge->bus;
 
err_out:
	kfree(bridge);
	return NULL;
}

分配一个主桥结构，就是一个device，其parent为NULL，为PCI设备的顶级顶点
接下来注册主桥
static int pci_register_host_bridge(struct pci_host_bridge *bridge)
{
    ...
 
	bus = pci_alloc_bus(NULL);
 
	bridge->bus = bus;
 
	/* Temporarily move resources off the list */
	list_splice_init(&bridge->windows, &resources);
	bus->sysdata = bridge->sysdata;
	bus->msi = bridge->msi;
	bus->ops = bridge->ops;
	bus->number = bus->busn_res.start = bridge->busnr;  //注意这
 
    ...
 
	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(bus),
		     bridge->busnr);
 
	err = device_register(&bridge->dev);
 
	bus->bridge = get_device(&bridge->dev);
 
	bus->dev.class = &pcibus_class;
	bus->dev.parent = bus->bridge;
 
	dev_set_name(&bus->dev, "%04x:%02x", pci_domain_nr(bus), bus->number);
	name = dev_name(&bus->dev);
 
	err = device_register(&bus->dev);
 
	pcibios_add_bus(bus);
 
	/* Create legacy_io and legacy_mem files for this bus */
	pci_create_legacy_files(bus);
 
	down_write(&pci_bus_sem);
	list_add_tail(&bus->node, &pci_root_buses);
	up_write(&pci_bus_sem);
 
	return 0;
 
unregister:
	put_device(&bridge->dev);
	device_unregister(&bridge->dev);
 
free:
	kfree(bus);
	return err;
}

一个主桥下面新建了一个pci_bus, 其也对应一个设备，这两个设备都注册到系统中，注意他们的名字

dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(bus), bridge->busnr);
dev_set_name(&bus->dev, "%04x:%02x", pci_domain_nr(bus), bus->number);
下图显示了注册后的PCI设备分级情况，其他的PCI设备都挂在主桥下

[root@localhost /]# ls /sys/devices/pci0000:00
0000:00:00.0  0000:00:07.7  0000:00:15.1  0000:00:15.6  0000:00:16.3  0000:00:17.0  0000:00:17.5  0000:00:18.2  0000:00:18.7
0000:00:01.0  0000:00:0f.0  0000:00:15.2  0000:00:15.7  0000:00:16.4  0000:00:17.1  0000:00:17.6  0000:00:18.3  firmware_node
0000:00:07.0  0000:00:10.0  0000:00:15.3  0000:00:16.0  0000:00:16.5  0000:00:17.2  0000:00:17.7  0000:00:18.4  pci_bus
0000:00:07.1  0000:00:11.0  0000:00:15.4  0000:00:16.1  0000:00:16.6  0000:00:17.3  0000:00:18.0  0000:00:18.5  power
0000:00:07.3  0000:00:15.0  0000:00:15.5  0000:00:16.2  0000:00:16.7  0000:00:17.4  0000:00:18.1  0000:00:18.6  uevent
 

我画了个示意图，pci桥本身也是一个设备和其下的pci device一样都挂在同一总线上：


pci_scan_child_bus包含整个的枚举过程,简单而言就是一个DFS,这个过程最终确定了每级PCI桥的bus范围：[secondary, subordinate]
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

```C
struct pci_dev {
	struct list_head bus_list;	/* Node in per-bus list */
	struct pci_bus	*bus;		/* Bus this device is on */
	struct pci_bus	*subordinate;	/* Bus this device bridges to */

	void		*sysdata;	/* Hook for sys-specific extension */
	struct proc_dir_entry *procent;	/* Device entry in /proc/bus/pci */
	struct pci_slot	*slot;		/* Physical slot this device is in */

	unsigned int	devfn;		/* Encoded device & function index */
	unsigned short	vendor;
	unsigned short	device;
	unsigned short	subsystem_vendor;
	unsigned short	subsystem_device;
	unsigned int	class;		/* 3 bytes: (base,sub,prog-if) */
	u8		revision;	/* PCI revision, low byte of class word */
	u8		hdr_type;	/* PCI header type (`multi' flag masked out) */
#ifdef CONFIG_PCIEAER
	u16		aer_cap;	/* AER capability offset */
	struct aer_stats *aer_stats;	/* AER stats for this device */
#endif
#ifdef CONFIG_PCIEPORTBUS
	struct rcec_ea	*rcec_ea;	/* RCEC cached endpoint association */
	struct pci_dev  *rcec;          /* Associated RCEC device */
#endif
	u32		devcap;		/* PCIe Device Capabilities */
	u8		pcie_cap;	/* PCIe capability offset */
	u8		msi_cap;	/* MSI capability offset */
	u8		msix_cap;	/* MSI-X capability offset */
	u8		pcie_mpss:3;	/* PCIe Max Payload Size Supported */
	u8		rom_base_reg;	/* Config register controlling ROM */
	u8		pin;		/* Interrupt pin this device uses */
	u16		pcie_flags_reg;	/* Cached PCIe Capabilities Register */
	unsigned long	*dma_alias_mask;/* Mask of enabled devfn aliases */

	struct pci_driver *driver;	/* Driver bound to this device */
	u64		dma_mask;	/* Mask of the bits of bus address this
					   device implements.  Normally this is
					   0xffffffff.  You only need to change
					   this if your device has broken DMA
					   or supports 64-bit transfers.  */

	struct device_dma_parameters dma_parms;

	pci_power_t	current_state;	/* Current operating state. In ACPI,
					   this is D0-D3, D0 being fully
					   functional, and D3 being off. */
	unsigned int	imm_ready:1;	/* Supports Immediate Readiness */
	u8		pm_cap;		/* PM capability offset */
	unsigned int	pme_support:5;	/* Bitmask of states from which PME#
					   can be generated */
	unsigned int	pme_poll:1;	/* Poll device's PME status bit */
	unsigned int	d1_support:1;	/* Low power state D1 is supported */
	unsigned int	d2_support:1;	/* Low power state D2 is supported */
	unsigned int	no_d1d2:1;	/* D1 and D2 are forbidden */
	unsigned int	no_d3cold:1;	/* D3cold is forbidden */
	unsigned int	bridge_d3:1;	/* Allow D3 for bridge */
	unsigned int	d3cold_allowed:1;	/* D3cold is allowed by user */
	unsigned int	mmio_always_on:1;	/* Disallow turning off io/mem
						   decoding during BAR sizing */
	unsigned int	wakeup_prepared:1;
	unsigned int	skip_bus_pm:1;	/* Internal: Skip bus-level PM */
	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
	unsigned int	hotplug_user_indicators:1; /* SlotCtl indicators
						      controlled exclusively by
						      user sysfs */
	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
						   bit manually */
	unsigned int	d3hot_delay;	/* D3hot->D0 transition time in ms */
	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */

#ifdef CONFIG_PCIEASPM
	struct pcie_link_state	*link_state;	/* ASPM link state */
	unsigned int	ltr_path:1;	/* Latency Tolerance Reporting
					   supported from root to here */
	u16		l1ss;		/* L1SS Capability pointer */
#endif
	unsigned int	pasid_no_tlp:1;		/* PASID works without TLP Prefix */
	unsigned int	eetlp_prefix_path:1;	/* End-to-End TLP Prefix */

	pci_channel_state_t error_state;	/* Current connectivity state */
	struct device	dev;			/* Generic device interface */

	int		cfg_size;		/* Size of config space */

	/*
	 * Instead of touching interrupt line and base address registers
	 * directly, use the values stored here. They might be different!
	 */
	unsigned int	irq;
	struct resource resource[DEVICE_COUNT_RESOURCE]; /* I/O and memory regions + expansion ROMs */
	struct resource driver_exclusive_resource;	 /* driver exclusive resource ranges */

	bool		match_driver;		/* Skip attaching driver */

	unsigned int	transparent:1;		/* Subtractive decode bridge */
	unsigned int	io_window:1;		/* Bridge has I/O window */
	unsigned int	pref_window:1;		/* Bridge has pref mem window */
	unsigned int	pref_64_window:1;	/* Pref mem window is 64-bit */
	unsigned int	multifunction:1;	/* Multi-function device */

	unsigned int	is_busmaster:1;		/* Is busmaster */
	unsigned int	no_msi:1;		/* May not use MSI */
	unsigned int	no_64bit_msi:1;		/* May only use 32-bit MSIs */
	unsigned int	block_cfg_access:1;	/* Config space access blocked */
	unsigned int	broken_parity_status:1;	/* Generates false positive parity */
	unsigned int	irq_reroute_variant:2;	/* Needs IRQ rerouting variant */
	unsigned int	msi_enabled:1;
	unsigned int	msix_enabled:1;
	unsigned int	ari_enabled:1;		/* ARI forwarding */
	unsigned int	ats_enabled:1;		/* Address Translation Svc */
	unsigned int	pasid_enabled:1;	/* Process Address Space ID */
	unsigned int	pri_enabled:1;		/* Page Request Interface */
	unsigned int	is_managed:1;		/* Managed via devres */
	unsigned int	is_msi_managed:1;	/* MSI release via devres installed */
	unsigned int	needs_freset:1;		/* Requires fundamental reset */
	unsigned int	state_saved:1;
	unsigned int	is_physfn:1;
	unsigned int	is_virtfn:1;
	unsigned int	is_hotplug_bridge:1;
	unsigned int	shpc_managed:1;		/* SHPC owned by shpchp */
	unsigned int	is_thunderbolt:1;	/* Thunderbolt controller */
	/*
	 * Devices marked being untrusted are the ones that can potentially
	 * execute DMA attacks and similar. They are typically connected
	 * through external ports such as Thunderbolt but not limited to
	 * that. When an IOMMU is enabled they should be getting full
	 * mappings to make sure they cannot access arbitrary memory.
	 */
	unsigned int	untrusted:1;
	/*
	 * Info from the platform, e.g., ACPI or device tree, may mark a
	 * device as "external-facing".  An external-facing device is
	 * itself internal but devices downstream from it are external.
	 */
	unsigned int	external_facing:1;
	unsigned int	broken_intx_masking:1;	/* INTx masking can't be used */
	unsigned int	io_window_1k:1;		/* Intel bridge 1K I/O windows */
	unsigned int	irq_managed:1;
	unsigned int	non_compliant_bars:1;	/* Broken BARs; ignore them */
	unsigned int	is_probed:1;		/* Device probing in progress */
	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
	pci_dev_flags_t dev_flags;
	atomic_t	enable_cnt;	/* pci_enable_device has been called */

	u32		saved_config_space[16]; /* Config space saved at suspend time */
	struct hlist_head saved_cap_space;
	int		rom_attr_enabled;	/* Display of ROM attribute enabled? */
	struct bin_attribute *res_attr[DEVICE_COUNT_RESOURCE]; /* sysfs file for resources */
	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */

#ifdef CONFIG_HOTPLUG_PCI_PCIE
	unsigned int	broken_cmd_compl:1;	/* No compl for some cmds */
#endif
#ifdef CONFIG_PCIE_PTM
	u16		ptm_cap;		/* PTM Capability */
	unsigned int	ptm_root:1;
	unsigned int	ptm_enabled:1;
	u8		ptm_granularity;
#endif
#ifdef CONFIG_PCI_MSI
	void __iomem	*msix_base;
	raw_spinlock_t	msi_lock;
#endif
	struct pci_vpd	vpd;
#ifdef CONFIG_PCIE_DPC
	u16		dpc_cap;
	unsigned int	dpc_rp_extensions:1;
	u8		dpc_rp_log_size;
#endif
#ifdef CONFIG_PCI_ATS
	union {
		struct pci_sriov	*sriov;		/* PF: SR-IOV info */
		struct pci_dev		*physfn;	/* VF: related PF */
	};
	u16		ats_cap;	/* ATS Capability offset */
	u8		ats_stu;	/* ATS Smallest Translation Unit */
#endif
#ifdef CONFIG_PCI_PRI
	u16		pri_cap;	/* PRI Capability offset */
	u32		pri_reqs_alloc; /* Number of PRI requests allocated */
	unsigned int	pasid_required:1; /* PRG Response PASID Required */
#endif
#ifdef CONFIG_PCI_PASID
	u16		pasid_cap;	/* PASID Capability offset */
	u16		pasid_features;
#endif
#ifdef CONFIG_PCI_P2PDMA
	struct pci_p2pdma __rcu *p2pdma;
#endif
	u16		acs_cap;	/* ACS Capability offset */
	phys_addr_t	rom;		/* Physical address if not from BAR */
	size_t		romlen;		/* Length if not from BAR */
	/*
	 * Driver name to force a match.  Do not set directly, because core
	 * frees it.  Use driver_set_override() to set or clear it.
	 */
	const char	*driver_override;

	unsigned long	priv_flags;	/* Private flags for the PCI driver */

	/* These methods index pci_reset_fn_methods[] */
	u8 reset_methods[PCI_NUM_RESET_METHODS]; /* In priority order */
};
```

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
   1. `pci_acpi_crs_quirks`检查Bios日期是否是2008年以后的，如果不是则kernel将pci_use_crs变量置为false(默认是true)。用户也可以在cmd_line中加入“pci=use_crs”表示将使用ACPI提供的`PCI Host Bridge Windows Info`(即Bar资源)，或者“pci=nocrs”表示将不使用ACPI提供的`PCI Host Bridge Windows Info`。X86下实现为解析获取dmi信息，当匹配某些信息（板卡名称、厂商、固件版本号等）后，确定是否使用DSDT中_CRS下的资源以及是否忽略_SEG方法（returns a device’s PCI Segment Group number）。前提是使用UEFI作为固件并且支持acpi。
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
   4. 上一步失败 => 通过`acpi_evaluate_integer`获取ACPI的_BBN(base bus number)参数获取host bridge的根总线号。如找到为[_BBN-0xFF] ，否则默认为 [0-0xFF]。执行到这里如果没有返回失败，硬件设备上会有如下打印：ACPI: PCI Root Bridge [PCI0](domain 0000 [bus 00-7f])。
   5. 设置`device.pnp.device_name = "PCI Root Bridge"`, `device.pnp.device_class = "pci_bridge"`。
   6. 设置`device.driver_data = root(acpi_pci_root)`
   7. 如果是hostplug，调用`dmar_device_add(handle)`
   8. 调用acpi_pci_root_get_mcfg_addr函数获取acpi host bridge dev节点中的mcfg (Memory mapped Configuration Base Address)地址并保存到root->mcfg_addr中,实现就是查询ACPI表中的METHOD_NAME__CBA字段。
   9. 判断硬件类型acpi_hardware_id，判断device->pnp.ids->id是否等于"PNP0A08"，如果相等则`root->bridge_type = ACPI_BRIDGE_TYPE_PCIE`, 表示acpi host bridge dev支持PCIE Root Bridge。
   10. 判断device->pnp.ids->id是否等于"ACPI0016"，如果相等`root->bridge_type = ACPI_BRIDGE_TYPE_CXL`, 表示acpi host bridge dev支持CXL。(这个地方有点没太明白，明明是PCI设备，怎么)
   11. 调用函数`negotiate_os_control`通过acpi _osc method协商Bios和OS对PCIE Feature的控制权,判断主桥设备是否支持aspm、run_wake、以及热插拔事件。相关打印信息如下：
   acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
   acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR]
   acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
   12. 完成root结构体的初始化后，调用`pci_acpi_scan_root(root)`函数开始扫描Root Bridge完成PCIE/PCI设备的枚举。必须在尝试绑定根设备之前执行此操作，因为在进行此调用之前不会创建PCI名称空间, 因此根桥的pci_dev不存在。
   13. `pci_acpi_add_bus_pm_notifier(device)` 注册电源管理通知
   14. `device_set_wakeup_capable` 设置唤醒能力
   15. 如果是hotplug的还需要`pcibios_resource_survey_bus`，`pci_assign_unassigned_root_bus_resources`，`acpi_ioapic_add`
   16. `pci_bus_add_devices`添加pci_bus总线
5. pci_acpi_scan_root ：扫描主桥root host bridge下设备
   1. 调用`pci_acpi_root_get_node`检测系统对pci组段的支持情况。acpi的_PXM 表示device所在的numa id，这里通过评估_PXM方法获取node号。
   2. 为结构struct pci_root_info申请空间，填充struct pci_sysdata sd结构成员。
   3. 检测pci主桥总线的0000:00设备，由于pci总线还没有初始化，在这里显然找不到。调用`pci_find_bus(domain,busnum)`在全局变量的bus list `pci_root_buses`中查找domain为root->segment，busnum为root->secondary.start的bus。如果该函数返回的bus存在则表示root bus已经被扫描过了(只有扫描过后，才会将bus的信息插入到bus list中，因为这里是第一次扫描所以该函数返回的bus为空)，将struct pci_sysdata sd的内容复制到bus->sysdata中。
   4. 查不到就表示首次扫描，首先创建`struct pci_root_info`结构体，完成以下变量的赋值 info->sd。调用函数`acpi_pci_root_create(root,&acpi_pci_root_ops,&info->common, &info->sd)`
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

## 非ACPI方式枚举PCIE/PCI设备的软件执行
非ACPI方式枚举pci设备的入口函数是pci_legacy_init->pcibios_scan_root(0)。在pcibios_scan_root函数中首先调用函数x86_pci_root_bus_resources获取PCI Host Bridge resources。系统通过函数x86_find_pci_root_info在pci_root_infos结构体中查找bus号为0的pci_root_info信息，因为之前为注册所以这里会走到default_resources节点。系统调用pci_add_resource为pci host bridge分配io和mem资源。系统log如下：
pci_bus 0000:00: root bus resource [io 0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0x7fffffffff]
系统默认为pci host bridge分配的io资源从0x0-0xffff,分配的mem资源从0x0-0x7fffffffff。之后调用函数pci_scan_root_bus分配分配pci host bridge结构体并枚举pci设备，这与acpi方式类似。

# PCI/PCIe设备的资源分配
pcie枚举完成后，pci总线号已经分配，pcie ecam的映射、 pcie设备信息、BAR的个数及大小等也已经ready, 但此时并没有给各个pci device的BAR寄存器分配资源并检查资源的合理性, pci bridge的mem, I/O, prefetch mem的base/limit寄存器默认使用Bios分配的资源(如果Bios已经分配)。这时就需要走到pcie的资源分配流程，整个资源分配的过程就是从系统的总资源里给每个pci device的bar分配资源，给每个pci桥的base, limit的寄存器分配资源并检查合理性。

## ACPI方式资源分配的软件执行过程
当系统使能ACPI机制枚举PCI设备和对PCI/PCIe设备进行资源分配时，主要通过函数`pci_subsys_init`和`pcibios_assign_resources`完成PCI设备的资源分配。

### pci_subsys_init
1. 首先调用`x86_init.pci.init()`函数，其中x86_init.pci.init实际指向`pci_acpi_init`。该函数的主要作用是初始化中断相关的函数指针。
```C
pcibios_enable_irq = acpi_pci_irq_enable;
pcibios_disable_irq = acpi_pci_irq_disable;
x86_init.pci.init_irq = x86_init_noop;
```
2. 如果(1)中返回非0(acpi=noirq --do not use ACPI for IRQ routing)则调用函数`pci_legacy_init`完成非acpi方式枚举pcie/pci设备的过程。
3. 调用函数`pcibios_fixup_peer_bridges()`查找是否存在`peer host bridge bus`,如果存在则调用函数`pcibios_scan_root`枚举该bus下的所有dev。
4. 调用函数pcibios_init->`pcibios_resource_survey`检查当前处理器系统的所有PCI设备的Bar空间，该函数并不会操作PCI设备的Bar寄存器，而只是检查当前处理器系统中的所有PCI设备的pci_dev->resource参数是否合理。真正为设备分配Bar资源是在函数`pcibios_assign_resources`中完成的。
5. 在该函数中为所有的PCI总线树的根节点调用函数`pcibios_allocate_bus_resources`使用DFS算法检查并分配PCI总线树中所有PCI桥使用的系统资源。系统首先检查bus->self是否存在(即Bus所在的Bridge dev)，如果存在则调用函数`pcibios_allocate_bridge_resources(bus->self)`。在函数pcibios_allocate_bridge_resources中首先遍历该Bridge dev所有的bar资源，如果该dev->resource[idx]->flags为0(表示该Bar资源无效)或者dev->resource[idx]->parent不为空(表示已经分配过了)则跳过该项Bar资源的分配，如果dev->resource[idx]->start为0或者调用函数pci_claim_bridge_resource失败则将r->start = r->end = 0，r->flags = 0。函数pci_claim_bridge_resource的作用就是判断当前Bridge dev的bar资源是否隶属于上游PCI Bridge dev管理的地址空间，如果当前Bridge dev的bar资源与该Bridge dev所在的上游PCI Bridge dev管理的地址空间有重叠，系统将尝试裁剪当前Bridge dev的bar资源以满足PCI Bridge Bar资源分配的要求，后面我们详细介绍pci_claim_bridge_resource函数的实现。
6. 处理根节点的Bridge dev Bar资源检查后，继续遍历该Root Bus下的所有children bus，并为每个children bus调用函数pcibios_allocate_bus_resources完成该bus所在Bridge dev的Bar资源检查。如果该children bus下还有children bus则继续递归调用函数pcibios_allocate_bus_resources直到扫描完所有的bus。
7. 在处理完bridge dev的资源检查后，系统从PCI设备树的根节点root bus出发，为root bus调用函数pcibios_allocate_resources(bus, 0)。该函数的主要作用是为“在Bios中已经启动了PCI设备”优先分配资源。首先系统调用list_for_each_entry函数遍历该bus上所引出的所有devfunc，为每个devfunc都调用pcibios_allocate_dev_resources函数。
8. 调用函数pci_read_config_word获取该pci设备配置空间的COMMAND寄存器值。
9. 依次获取该dev->resource[idx]的Bar资源，检查是否已经被分配过了或者Bar资源无效则跳过该Bar资源的分配，否则检查该r->flags是IO属性还是Memory属性。如果在Bios中已经启动了PCI设备，表示是否允许访问Bar资源的标志Disabled为0，否则为1。
10. 因为第一次调用函数pcibios_allocate_resources传递的参数是0，目的是为“在Bios中已经启动了PCI设备”优先分配资源，调用函数pci_claim_resource为该dev的某个bar分配资源。其主要过程依然是调用pci_find_parent_resource获取上游PCI桥管理的资源并使用request_resource函数为当前PCI设备分配地址空间。如果分配失败，系统将r->flags置为IORESOURCE_UNSET，调用函数pcibios_save_fw_addr记录分配失败的bar资源，并将r->end=r->end-r->start。r->start=0。
11. 因为传入的参数为0，系统将暂时禁止PCI设备的ROM空间(如果r->flags & IORESOURCE_ROM_ENABLE为1)。
12. 如果该dev->subordinate bus存在则继续递归调用pcibios_allocate_resources来为dev->subordinate bus上的所有PCI设备分配Bar空间。
13. 与3)类似，系统调用pcibios_allocate_resources函数(入口参数为1)为其他PCI设备分配资源。实现过程与3)类似，只是为那些PCI dev配置空间COMMAND寄存器的IO Space Enable bit为0或者Memory Space Enable Bit为0的设备分配Bar资源。
14. 调用函数e820__reserve_resources_late()将e820中地址范围在iomem_resource的开始地址空间和结束地址空间范围内的地址空间插入到iomem_resource中。系统打出的log如下：
```Shell
e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
e820: reserve RAM buffer [mem 0x6c46d018-0x6fffffff]
e820: reserve RAM buffer [mem 0x93850000-0x93ffffff]
e820: reserve RAM buffer [mem 0x93e3b000-0x93ffffff]
e820: reserve RAM buffer [mem 0x941e9000-0x97ffffff]
e820: reserve RAM buffer [mem 0x95a52000-0x97ffffff]
e820: reserve RAM buffer [mem 0x9fb3f000-0x9fffffff]
```
15. 调用函数ioapic_insert_resources系统为ioapic使用的资源从iomem_resource中分配资源。

### pcibios_assign_resources函数的执行过程
pci_subsys_init函数执行完毕后，Linux PCI调用pcibios_assign_resources函数，设置PCI设备的Bar寄存器。pcibios_assign_resource函数首先处理PCI设备的ROM空间，并进行资源分配，之后调用函数pci_assign_unassigned_resources函数设置PCI设备的Bar寄存器。接下来我们看看pcibios_assign_resources函数的具体实现细节。

1. 如果pci_probe & PCI_ASSIGN_ROMS为0，表示系统首先尝试使用Bios的配置分配PCI设备的ROM空间。系统从PCI设备树的根节点root bus出发，为root bus调用函数pcibios_allocate_rom_resources(bus)为root bus下的每一个pci设备调用函数pcibios_allocate_dev_rom_resource为pci设备的ROM空间进行资源分配(通过pci_claim_resource函数实现)。分配失败将dev->resource[PCI_ROM_RESOURCE]->flags置为IORESOURCE_UNSET，r->end -= r->start，r->start = 0，之后交给步骤(2)给分配失败的dev尝试分配rom空间。如果该dev->subordinate bus存在，则系统调用函数pcibios_allocate_rom_resources为dev->subordinate bus挂载的pci设备ROM空间进行资源分配。
2. pcibios_resource_survey函数执行完,PCI的所有总线和设备的资源都被验证分配了一次，对于不能正确分配资源的设备,通过pci_assign_unassigned_root_bus_resources函数处理资源分配失败的设备。
3. 调用函数pci_realloc_detect检查用户是否需要重新分配pci bridge resource(通过在cmdline中加入“pci=realloc=on”或者“pci=realloc”) 。如果用户需要重新分配pci bridge resource(如果bios给pci bridge resource太小)，调用函数pci_bus_get_depth(bus)获取整个系统pci设备树的最大深度。
4. 调用函数_pci_bus_size_bridges修复和对齐当前pci总线树下的所有pci设备(包括pci桥)所使用的I/O和存储器地址空间。具体做法是首先递归调pci_bus_size_bridges函数，直到找到当前PCI总线最底层的PCI桥，然后调用pci_bridge_check_ranges函数检查这个PCI桥所管理的地址空间是否满足I/O或者可预读的存储器空间，如果支持，则将当前PCI桥的pci_bus->self->resource参数相应状态位置1。之后调用pbus_size_mem和pbus_size_io函数修复并对齐当前PCI桥的I/O空间和存储器空间，并从低到高逐层递归调用pci_bus_size_bridge函数。
5. 调用函数_pci_bus_assign_resources尝试为“为初始化pci设备的BAR寄存器”分配资源。该函数首先调用pbus_assign_resources_sorted函数遍历并初始化当前pci总线上所有PCI设备的BAR寄存器，包括PCI Agent设备和PCI桥，之后递归调用自身遍历当前PCI总线下的所有下游总线，最后调用pci_setup_bridge函数初始化PCI桥的存储器和I/O Base, Limit寄存器。
6. 该函数首先调用pbus_assign_resources_sorted函数遍历该bus上的所有dev,为遍历到的每一个dev调用函数__dev_sort_resources。该函数的主要作用是将“未初始化”的PCI设备使用的资源进行排序对齐，然后插入到Head链表中。随后调用函数__assign_resources_sorted函数初始化这些PCI设备的BAR寄存器。
7. 在函数__assign_resources_sorted中，首先判断链表realloc_head(该链表的作用是保存那些需要额外增加BAR资源的dev resource信息，realloc_head链表节点的插入是在函数_pci_bus_size_bridges中完成的)是否为空，如果为空则跳转到requested_and_reassign节点处理那些必须重新分配的dev BAR资源。否则根据realloc_head中的bar资源统计结果，更新链表节点dev_res->res的值，之后调用函数assign_requested_resources_sorted遍历head链表中的dev_res节点，为每一个dev_res节点调用函数pci_assign_resource初始化这些PCI设备的BAR寄存器。pci_assign_resource->_pci_assign_resource->__pci_assign_resource中两次调用函数，第一次试图从上游总线的可预取存储器空间为当前的PCI设备分配资源，第二次从“不可预取的存储器空间为当前的PCI设备分配资源。当资源分配成功后，pci_assign_resource->pci_update_resource函数将初始化PCI设备的BAR寄存器。而requested_and_reassign节点调用assign_requested_resources_sorted函数完成未初始化PCI设备BAR资源的分配。如果分配失败则将dev_res插入到fail_head链表中。
8. 再次回到__pci_bus_assign_resources函数中，系统遍历该bus下的所有dev,如果该dev->subordinate存在则递归调用函数__pci_bus_assign_resources寻找当前PCI总线子树的最后一个PCI桥，之后调用函数pci_setup_bridge函数初始化这个pci桥的Base，Limit寄存器。打出的log如下：
```shell
pci 0000:02:01.0: PCI bridge to [bus 03]
pci 0000:02:03.0: PCI bridge to [bus 04]
pci 0000:02:04.0: PCI bridge to [bus 05]
pci 0000:06:00.0: PCI bridge to [bus 07]
pci 0000:02:05.0: PCI bridge to [bus 06-07]
pci 0000:08:00.0: PCI bridge to [bus 09]
pci 0000:08:00.0: bridge window [io 0xe000-0xefff]
pci 0000:08:00.0: bridge window [mem 0xc0100000-0xc01fffff]
pci 0000:02:08.0: PCI bridge to [bus 08-09]
pci 0000:02:08.0: bridge window [io 0xe000-0xefff]
pci 0000:02:08.0: bridge window [mem 0xc0100000-0xc01fffff]
pci 0000:01:00.0: PCI bridge to [bus 02-09]
pci 0000:01:00.0: bridge window [io 0xe000-0xefff]
pci 0000:01:00.0: bridge window [mem 0xc0100000-0xc01fffff]
pci 0000:00:03.0: PCI bridge to [bus 01-09]
pci 0000:00:03.0: bridge window [io 0xe000-0xefff]
pci 0000:00:03.0: bridge window [mem 0xc0100000-0xc02fffff]
pci 0000:00:03.2: PCI bridge to [bus 0a]
pci 0000:00:04.0: PCI bridge to [bus 0b]
pci 0000:00:05.0: PCI bridge to [bus 0c]
pci 0000:00:05.1: PCI bridge to [bus 0d]
pci 0000:00:05.1: bridge window [io 0xd000-0xdfff]
pci 0000:00:05.1: bridge window [mem 0xc0000000-0xc00fffff]
```
9. 遍历fail_head中的所有fail_res节点，为每个节点调用函数pci_bus_release_bridge_resources尝试释放不适合为桥所在的dev分配bar资源剩余的桥资源。
10. 调用函数pci_bus_dump_resources打印该bus下所有的bar resource。Log如下：
```shell
pci_bus 0000:00: resource 4 [io 0x0000-0x03af window]
pci_bus 0000:00: resource 5 [io 0x03e0-0x0cf7 window]
pci_bus 0000:00: resource 6 [io 0x0d00-0xffff window]
pci_bus 0000:00: resource 7 [io 0x03b0-0x03df window]
pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
pci_bus 0000:00: resource 9 [mem 0xa0000000-0xfdffffff window]
pci_bus 0000:01: resource 0 [io 0xe000-0xefff]
pci_bus 0000:01: resource 1 [mem 0xc0100000-0xc02fffff]
pci_bus 0000:02: resource 0 [io 0xe000-0xefff]
pci_bus 0000:02: resource 1 [mem 0xc0100000-0xc01fffff]
pci_bus 0000:08: resource 0 [io 0xe000-0xefff]
pci_bus 0000:08: resource 1 [mem 0xc0100000-0xc01fffff]
pci_bus 0000:09: resource 0 [io 0xe000-0xefff]
pci_bus 0000:09: resource 1 [mem 0xc0100000-0xc01fffff]
pci_bus 0000:0d: resource 0 [io 0xd000-0xdfff]
pci_bus 0000:0d: resource 1 [mem 0xc0000000-0xc00fffff]
```
当Linux PCI执行pci_setup_bridge函数初始化PCI桥后，这个桥的上游设备和这个桥管理的PCI设备的BAR寄存器已经初始化完毕，因此pci_setup_bridge函数通过简单的计算，即可得出当前PCI桥Base,Limit寄存器的值，之后调用pci_write_config_dword函数将这个数据对PCI桥的这些寄存器更新。

至此，PCI总线树上所有PCI设备的BAR寄存器，以及PCI桥的Base,Limit寄存器全部初始化完毕。

## 非ACPI方式资源分配的软件执行过程

非acpi与acpi方式资源分配的软件执行过程一样都是通过函数pcibios_resource_survey和pcibios_assign_resources函数完成的,这里就不做分析了。




# reference

https://zhuanlan.zhihu.com/p/621287008