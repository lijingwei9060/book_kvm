# 概念与结构

Virtual Function I/O (VFIO) 是一种现代化的设备直通方案，它充分利用了VT-d/AMD-Vi技术提供的DMA Remapping和Interrupt Remapping特性， 在保证直通设备的DMA安全性同时可以达到接近物理设备的I/O的性能。 用户态进程可以直接使用VFIO驱动直接访问硬件，并且由于整个过程是在IOMMU的保护下进行因此十分安全， 而且非特权用户也是可以直接使用。 换句话说，VFIO是一套完整的用户态驱动(userspace driver)方案，因为它可以安全地把设备I/O、中断、DMA等能力呈现给用户空间。

为了达到最高的IO性能，虚拟机就需要VFIO这种设备直通方式，因为它具有低延时、高带宽的特点，并且guest也能够直接使用设备的原生驱动。 这些优异的特点得益于VFIO对VT-d/AMD-Vi所提供的DMA Remapping和Interrupt Remapping机制的应用。 VFIO使用DMA Remapping为每个Domain建立独立的IOMMU Page Table将直通设备的DMA访问限制在Domain的地址空间之内保证了用户态DMA的安全性， 使用Interrupt Remapping来完成中断重映射和Interrupt Posting来达到中断隔离和中断直接投递的目的。


VFIO驱动框架为直接设备访问提供了统一的API。它将设备直接访问安全地(以一种IOMMU保护的环境)暴露给用户，是一种IOMMU/设备无关的框架。此框架用于多种设备，如GPU、网卡和计算加速器等。有了这种直接设备访问，虚拟机或者用户态应用可以直接访问物理设备。Mdeiated devices便是重用了VFIO这种框架。

Mediated core driver为mdiated device提供了一个公共的管理接口，它可以被不同类型的设备驱动所利用。
Mediated core driver也提供注册总线驱动的接口。比如，一个mediated VFIO mdev驱动就是为mediated devices设计的，并且支持VFIO的API。Mediated bus driver可以将一个mediated device加入或者移出一个VFIO group。

## 架构图

模块：
vfio_mdev
mdev: vfio_mdev
vfio_pci
vfio_virqfd: vfio_pci
vfio_iommu_type1:
vfio: vfio_mdev, vfio_iommu_type1, vfio_pci
irqbypass: vfio_pci, kvm


vfio.io: vfio interface, 提供用户太的统一访问接口，提供/dev/vfio在内核给用户态提供api， qemu 和dpdk通过api和内核交互，使用ioctl进行访问。
vfio_iommu：对iiommu层统一封装提供DMA remapping的功能，及管理iommu页表的能力
vfio_pci：对pci设备统一封装，包括pci配置空间模拟，pci bar空间重定向， interrupt remapping。vfio-pci是内核驱动，网卡和NVME盘等设备就可以使用这个驱动，使用vfio-pci就会调用到vfio-pci的probe。vfio-pci用于标准的pci设备，如果多个虚拟机想用这个pci设备就开启这个pci设备的sr-iov功能，这个pci设备就变成多个标准的pci设备，每个虚拟机用一个。sr-iov是硬件资源的一种切分方法，不但DMA queue这样的数据面切分，pci config space等控制面也切分，硬件实现过于复杂，GPU和NVME这些设备很难实现控制面的切分，但数据面有其它方法切分，不同虚拟机可以共享数据面功能又能保证隔离，把这种设备叫做mdev设备，就是严格mediated下能做虚拟化的设备。例如`ll /sys/class/vfio/81/dev`。

mdev.ko给用户提供接口创建虚拟的mdev设备，把虚拟mdev和真实mdev关联，把真实的mdev叫做父设备，同时把虚拟mdev和驱动vfio-mdev匹配，vfio-mdev就开始probe

vfio-pci和mdev-vfio的probe都调用vfio_add_group_dev添加自己的ops，同时生成一个dev，qemu通过/dev/vfio获取这个dev，再操作这个dev时就调用到vfio-pci和vfio-mdev的ops函数，vfio-pci干活，vfio-mdev基本上什么也不干，一转手就调用父设备的ops干活，相当于调用到GPU或者NVME的驱动。sr-iov是pci标准的设备虚拟化方案，mdev就厂商私有的设备虚拟化方案，驱动是厂商实现的，硬件也是厂商搞的，驱动和硬件配合能达到虚拟化的效果就行

iommu driver：硬件平台相关的iommu模块，有 intel iommu， amd iommu 和 ppc iommu，arm smmu。

pci_bus driver

mdev.ko   -> vfio_mdev.ko  ->vfio user api
mdev.ko   -(mdev_register_device)->       nvidia.ko/i915.ko/ccw_devide.ko


3个管理概念：device、group、container

- Group 是IOMMU能够进行DMA隔离的最小硬件单元，一个group内可能只有一个device，也可能有多个device，这取决于物理平台上硬件的IOMMU拓扑结构。 设备直通的时候一个group里面的设备必须都直通给一个虚拟机。 不能够让一个group里的多个device分别从属于2个不同的VM，也不允许部分device在host上而另一部分被分配到guest里， 因为就这样一个guest中的device可以利用DMA攻击获取另外一个guest里的数据，就无法做到物理上的DMA隔离。 另外，VFIO中的group和iommu group可以认为是同一个概念。
- Device 指的是我们要操作的硬件设备，不过这里的“设备”需要从IOMMU拓扑的角度去理解。如果该设备是一个硬件拓扑上独立的设备，那么它自己就构成一个iommu group。 如果这里是一个multi-function设备，那么它和其他的function一起组成一个iommu group，因为多个function设备在物理硬件上就是互联的， 他们可以互相访问对方的数据，所以必须放到一个group里隔离起来。值得一提的是，对于支持**PCIe ACS**特性的硬件设备，我们可以认为他们在物理上是互相隔离的。
- Container 是一个和地址空间相关联的概念，这里可以简单把它理解为一个VM Domain的物理内存空间。对于用户态驱动，Container可以是多个Group的集合。

## vfio将设备暴露给用户

正常的IO

cpu -  memory controller（访问内存） -(host 主桥和pci总线)- device

## vfio_mdev
vfio_mdev是Linux内核中的一个虚拟化框架，用于将物理设备转换为虚拟设备，以支持虚拟化环境中的设备直通功能。其源码位于drivers/vfio/mdev。

### vfio_mdev核心数据结构

VFIO驱动在加载的时候会创建一个名为`/dev/vfio/vfio`的文件，而这个文件的句柄关联到了`vfio_container`上，用户态进程打开这个文件就可以初始化和访问`vfio_container`。 当我们把一个设备直通给虚拟机时，首先要做的就是将这个设备从host上进行解绑，即解除host上此设备的驱动，然后将设备驱动绑定为“vfio-pci”， 在完成绑定后会新增一个`/dev/vfio/$groupid`的文件，其中`$groupid`为此PCI设备的iommu group id， 这个id号是在操作系统加载iommu driver遍历扫描host上的PCI设备的时候就已经分配好的，可以使用`readlink -f /sys/bus/pci/devices/$bdf/iommu_group`来查询。 类似的，`/dev/vfio/$groupid`这个文件的句柄被关联到vfio_group上，用户态进程打开这个文件就可以管理这个iommu group里的设备。 然而VFIO中并没有为每个device单独创建一个文件，而是通过VFIO_GROUP_GET_DEVICE_FD这个ioctl来获取device的句柄，然后再通过这个句柄来管理设备。

VFIO框架中很重要的一部分是要完成DMA Remapping，即为Domain创建对应的IOMMU页表，这个部分是由vfio_iommu_driver来完成的。 vfio_container包含一个指针记录vfio_iommu_driver的信息，在x86上vfio_iommu_driver的具体实现是由vfio_iommu_type1来完成的。 其中包含了vfio_iommu, vfio_domain, vfio_group, vfio_dma等关键数据结构（注意这里是iommu里面的），

vfio_iommu可以认为是和container概念相对应的iommu数据结构，在虚拟化场景下每个虚拟机的物理地址空间映射到一个vfio_iommu上。
vfio_group可以认为是和group概念对应的iommu数据结构，它指向一个iommu_group对象，记录了着iommu_group的信息。
vfio_domain这个概念尤其需要注意，这里绝不能把它理解成一个虚拟机domain，它是一个与DRHD（即IOMMU硬件）相关的概念， 它的出现就是为了应对多IOMMU硬件的场景，我们知道在大规格服务器上可能会有多个IOMMU硬件，不同的IOMMU硬件有可能存在差异， 例如IOMMU 0支持IOMMU_CACHE而IOMMU 1不支持IOMMU_CACHE（当然这种情况少见，大部分平台上硬件功能是具备一致性的），这时候我们不能直接将分别属于不同IOMMU硬件管理的设备直接加入到一个container中， 因为它们的IOMMU页表SNP bit是不一致的。 因此，一种合理的解决办法就是把一个container划分多个vfio_domain，当然在大多数情况下我们只需要一个vfio_domain就足够了。 处在同一个vfio_domain中的设备共享IOMMU页表区域，不同的vfio_domain的页表属性又可以不一致，这样我们就可以支持跨IOMMU硬件的设备直通的混合场景。




vfio_mdev使用了三个核心数据结构：
- struct mdev_parent: 代表物理设备的父设备，其包含了所有的mdev_device设备
- struct mdev_device: 代表虚拟设备，其与struct mdev_driver相对应，用于描述虚拟设备的功能和特性
- struct mdev_driver: 代表虚拟驱动程序，用于为mdev_device提供驱动支持。
在物理设备的驱动中：
- mdev_parent_ops[3]结构来定义API，用于管理mediated core driver中和物理设备相关的工作。

```C
struct mdev_driver {
    const char *name;
    int (*probe) (struct device *dev);
    void (*remove) (struct device *dev);
    struct device_driver driver;
};


struct mdev_parent_ops {
	struct module   *owner;
	struct mdev_driver *device_driver;
	const struct attribute_group **dev_attr_groups; // parent device的属性
	const struct attribute_group **mdev_attr_groups; // mediated device的属性
	struct attribute_group **supported_type_groups; //定义所支持配置的属性

	int     (*create)(struct mdev_device *mdev);
	int     (*remove)(struct mdev_device *mdev);
	int     (*open)(struct mdev_device *mdev);
	void    (*release)(struct mdev_device *mdev);
	ssize_t (*read)(struct mdev_device *mdev, char __user *buf, size_t count, loff_t *ppos);
	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf, size_t count, loff_t *ppos);
	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd, unsigned long arg);
	int	    (*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
	void	(*request)(struct mdev_device *mdev, unsigned int count);
};

```

### vfio_mdev设备注册和初始化

vfio_mdev通过sysfs文件系统提供了设备的注册接口，用户可以通过/sys/class/mdev_bus/xxx/mdev_supported_types文件夹下的文件来注册虚拟设备类型，然后通过/sys/class/mdev_bus//mdev_create文件夹下的文件来创建虚拟设备，并可以通过/sys/devices/virtual/mdev//文件夹下的文件来进行设备的配置和管理。

在设备初始化时，vfio_mdev会根据设备类型以及对应的mdev_driver来创建mdev_device设备，并将其注册到mdev_parent设备中。同时，vfio_mdev会在设备初始化时创建一个vfio_iommu_device实例，用于IOMMU的管理和配置。

int mdev_register_driver(struct mdev_driver *drv,struct module *owner);

### vfio_mdev设备操作和管道通信

vfio_mdev通过一个管道机制实现了用户空间程序与虚拟设备之间的通信，即用户空间程序通过管道向驱动程序发送命令，驱动程序再将命令传递给虚拟设备进行相应的操作。vfio_mdev使用了ioctl接口来实现用户空间程序与驱动程序之间的交互，并通过虚拟设备提供的各种操作接口来实现具体的设备操作。

### vfio_mdev设备销毁

在设备销毁时，vfio_mdev会先将mdev_device从mdev_parent设备中注销，并将其所有的vfio_iommu_device实例都销毁。然后，vfio_mdev会根据设备类型和mdev_driver来销毁mdev_device设备，并释放所有相关资源。

void mdev_unregister_driver(struct mdev_driver *drv);


## 工具函数

以下API用于提供在VFIO驱动中从User PFN到Host PFN的转换：
```C
int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage, int prot, unsigned long *phys_pfn); 
int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage);
```

这些函数会回调后端IOMMU模块(struct vfio_iommu_driver_ops[4]结构中的pin_pages函数和unpin_pages函数)。挡墙这些回调在TYPE1 IOMMU模块中被支持。其他IOMMU后端模块中(如PPC64 sPAPR模块)若想支持，他们就需要提过这两个回调函数的实现。

## vfio_dev driver access vm's memory

when the virtual machine attaches the virtual device, VFIO will nofity the virtual machine's kvm structure to my driver.

mdev_device
mdev_stat->group_notifier.notifier_call = 注册一个函数
vfio_register_notifier

定义mdev_parent_ops

## VFIO-MDEV driver(virtual device) trigger interrupt to virtual machine

VFIO-MDEV driver 发送给event(msi或者中断) 给虚拟机


Host: tranx_mdev_trigger_interrupt, 发送中断
VM：vm_tranx_irq_handler ->  vm_tranx_get_irq


## 数据结构

VFIO提供了两个字符设备文件作为提供给用户程序的入口点，分别是/dev/vfio/vfio和/dev/vfio/$GROUP，此外还在sysfs中添加了一些文件。

首先看/dev/vfio/vfio，它是一个misc device，在vfio模块的初始化函数vfio_init中注册：

```c

static struct vfio {
	struct list_head		iommu_drivers_list;
	struct mutex			iommu_drivers_lock;
} vfio;

struct vfio_device_set {
	void *set_id;
	struct mutex lock;
	struct list_head device_list;
	unsigned int device_count;
};


struct vfio_device {
	struct device *dev;
	const struct vfio_device_ops *ops;
	/*
	 * mig_ops/log_ops is a static property of the vfio_device which must
	 * be set prior to registering the vfio_device.
	 */
	const struct vfio_migration_ops *mig_ops;
	const struct vfio_log_ops *log_ops;
	struct vfio_group *group;
	struct vfio_device_set *dev_set;
	struct list_head dev_set_list;
	unsigned int migration_flags;
	struct kvm *kvm;

	/* Members below here are private, not for driver use */
	unsigned int index;
	struct device device;	/* device.kref covers object life circle */
	refcount_t refcount;	/* user count on registered device*/
	unsigned int open_count;
	struct completion comp;
	struct list_head group_next;
	struct list_head iommu_entry;
	struct iommufd_access *iommufd_access;
	void (*put_kvm)(struct kvm *kvm);
#if IS_ENABLED(CONFIG_IOMMUFD)
	struct iommufd_device *iommufd_device;
	struct iommufd_ctx *iommufd_ictx;
	bool iommufd_attached;
#endif
};
enum vfio_group_type {
	/*
	 * Physical device with IOMMU backing.
	 */
	VFIO_IOMMU,

	/*
	 * Virtual device without IOMMU backing. The VFIO core fakes up an
	 * iommu_group as the iommu_group sysfs interface is part of the
	 * userspace ABI.  The user of these devices must not be able to
	 * directly trigger unmediated DMA.
	 */
	VFIO_EMULATED_IOMMU,

	/*
	 * Physical device without IOMMU backing. The VFIO core fakes up an
	 * iommu_group as the iommu_group sysfs interface is part of the
	 * userspace ABI.  Users can trigger unmediated DMA by the device,
	 * usage is highly dangerous, requires an explicit opt-in and will
	 * taint the kernel.
	 */
	VFIO_NO_IOMMU,
};
struct vfio_group {
	struct device 			dev; //指向/dev/vfio/$GROUP对应的Device
	struct cdev			cdev;
	/*
	 * When drivers is non-zero a driver is attached to the struct device
	 * that provided the iommu_group and thus the iommu_group is a valid
	 * pointer. When drivers is 0 the driver is being detached. Once users
	 * reaches 0 then the iommu_group is invalid.
	 */
	refcount_t			drivers;
	unsigned int			container_users;
	struct iommu_group		*iommu_group;
	struct vfio_container		*container;
	struct list_head		device_list;
	struct mutex			device_lock;
	struct list_head		vfio_next;
#if IS_ENABLED(CONFIG_VFIO_CONTAINER)
	struct list_head		container_next;
#endif
	enum vfio_group_type		type;
	struct mutex			group_lock;
	struct kvm			*kvm;
	struct file			*opened_file;
	struct blocking_notifier_head	notifier;
	struct iommufd_ctx		*iommufd;
	spinlock_t			kvm_ref_lock;
};

// VFIO bus driver device callbacks
struct vfio_device_ops { 
	char	*name;
	int	(*init)(struct vfio_device *vdev); // initialize private fields in device structure
	void	(*release)(struct vfio_device *vdev); // Reclaim private fields in device structure
	int	(*bind_iommufd)(struct vfio_device *vdev, struct iommufd_ctx *ictx, u32 *out_device_id); //Called when binding the device to an iommufd
	void	(*unbind_iommufd)(struct vfio_device *vdev); //Opposite of bind_iommufd
	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id); //Called when attaching device to an IOAS/HWPT managed by the	 bound iommufd. Undo in unbind_iommufd.
	int	(*open_device)(struct vfio_device *vdev); // Called when the first file descriptor is opened for this device
	void	(*close_device)(struct vfio_device *vdev);
	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,	size_t count, loff_t *ppos); // Perform read(2) on device file descriptor
	ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf, size_t count, loff_t *size);
	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd, unsigned long arg);
	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
	void	(*request)(struct vfio_device *vdev, unsigned int count);
	int	(*match)(struct vfio_device *vdev, char *buf); // Optional device name match callback (return: 0 for no-match, >0 for match, -errno for abort (ex. match with insufficient or incorrect additional args)
	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length); // Called when userspace unmaps IOVA from the container   this device is attached to.
	int	(*device_feature)(struct vfio_device *device, u32 flags,  void __user *arg, size_t argsz); //Optional, fill in the VFIO_DEVICE_FEATURE ioctl
};


/**
 * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
 */
struct vfio_iommu_driver_ops {
	char	*name;
	struct module	*owner;
	void	*(*open)(unsigned long arg);
	void	(*release)(void *iommu_data);
	long	(*ioctl)(void *iommu_data, unsigned int cmd, unsigned long arg);
	int		(*attach_group)(void *iommu_data,struct iommu_group *group,	enum vfio_group_type);
	void	(*detach_group)(void *iommu_data,struct iommu_group *group);
	int		(*pin_pages)(void *iommu_data, struct iommu_group *group,dma_addr_t user_iova,int npage, int prot,  struct page **pages);
	void	(*unpin_pages)(void *iommu_data, dma_addr_t user_iova, int npage);
	void	(*register_device)(void *iommu_data, struct vfio_device *vdev);
	void	(*unregister_device)(void *iommu_data, struct vfio_device *vdev);
	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,  void *data, size_t count, bool write);
	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,  struct iommu_group *group);
};

struct vfio_iommu_driver {
	const struct vfio_iommu_driver_ops	*ops;
	struct list_head			vfio_next;
};

static struct miscdevice vfio_dev = {
	.minor = VFIO_MINOR,
	.name = "vfio",
	.fops = &vfio_fops,
	.nodename = "vfio/vfio",
	.mode = S_IRUGO | S_IWUGO,
};

struct vfio_container {
	struct kref			kref;
	struct list_head		group_list; // Container维护了一个VFIO Group（struct vfio_group）的链表group_list
	struct rw_semaphore		group_lock;
	struct vfio_iommu_driver	*iommu_driver;
	void				*iommu_data;
	bool				noiommu; // 该Container是否用于存放no-iommu的Group, 一个Container不能同时存放no-iommu Group和普通Group）。no-iommu Group即背后没有IOMMU但仍然强行建立的VFIO Group，这个高级特性（CONFIG_VFIO_NOIOMMU）通常不建议开启
};

struct vfio_iommu_driver {
    const struct vfio_iommu_driver_ops  *ops;
    struct list_head                    vfio_next;
};

static int __init vfio_init(void)
{
	int ret;

	ida_init(&vfio.device_ida);

	ret = vfio_group_init();
	if (ret)
		return ret;

	ret = vfio_virqfd_init();
	if (ret)
		goto err_virqfd;

	/* /sys/class/vfio-dev/vfioX */
	vfio.device_class = class_create(THIS_MODULE, "vfio-dev");
	if (IS_ERR(vfio.device_class)) {
		ret = PTR_ERR(vfio.device_class);
		goto err_dev_class;
	}

	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
	return 0;

err_dev_class:
	vfio_virqfd_exit();
err_virqfd:
	vfio_group_cleanup();
	return ret;
}

```
## 初始化

vfio group不是凭空造出的一个概念，vfio group和IOMMU硬件的group紧密相关，所以vfio还有一个重要的函数就是vfio_register_iommu_driver，vfio_iommu_type1.ko就调用这个函数给vfio注册了操作IOMMU的ops，一个设备DMA用到的pagetable就可以通过这个ops配置到IOMMU中。

qemu调用memory_region_init_io注册vfio-pci设备的config space，虚拟机里驱动写config space，qemu拦截然后模拟。

pci_host_data_write->pci_data_write->pci_host_config_write_common->vfio_pci_write_config->vfio_msi_enable

qemu调用内核vfio，irqbypass用于把vfio和kvm连接起来。

vfio_msi_enable->vfio_enable_vectors(qemu代码)->vfio_pci_set_irqs_ioctl(内核vfio代码)->vfio_pci_set_msi_trigger->vfio_msi_set_block->vfio_msi_set_vector_signal->irq_bypass_register_producer->pi_update_irte

qemu同时调用到内核kvm。

vfio_msi_enable->vfio_add_kvm_msi_virq->kvm_irqchip_add_irqfd_notifier_gsi->kvm_irqchip_assign_irqfd(qemu代码)->kvm_vm_ioctl(kvm代码)->kvm_irqfd->kvm_irqfd_assign->irq_bypass_register_consumer

外设中断来了，vfio处理，signal kvm，kvm再把虚拟中断注入虚拟机。

vfio_msihandler->eventfd_signal wakeup了irqfd_wakeup->schedule_work

irqfd_inject->kvm_set_irq中断就注册了

## demo

https://blog.csdn.net/alex_mianmian/article/details/119428351?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-119428351-blog-110845945.235%5Ev38%5Epc_relevant_anti_vip_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-119428351-blog-110845945.235%5Ev38%5Epc_relevant_anti_vip_base&utm_relevant_index=2

https://rtoax.blog.csdn.net/article/details/110843839