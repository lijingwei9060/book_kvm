# 概念与结构

Virtual Function I/O (VFIO) 是一种现代化的设备直通方案，它充分利用了VT-d/AMD-Vi技术提供的DMA Remapping和Interrupt Remapping特性， 在保证直通设备的DMA安全性同时可以达到接近物理设备的I/O的性能。 用户态进程可以直接使用VFIO驱动直接访问硬件，并且由于整个过程是在IOMMU的保护下进行因此十分安全， 而且非特权用户也是可以直接使用。 换句话说，VFIO是一套完整的用户态驱动(userspace driver)方案，因为它可以安全地把设备I/O、中断、DMA等能力呈现给用户空间。

为了达到最高的IO性能，虚拟机就需要VFIO这种设备直通方式，因为它具有低延时、高带宽的特点，并且guest也能够直接使用设备的原生驱动。 这些优异的特点得益于VFIO对VT-d/AMD-Vi所提供的DMA Remapping和Interrupt Remapping机制的应用。 VFIO使用DMA Remapping为每个Domain建立独立的IOMMU Page Table将直通设备的DMA访问限制在Domain的地址空间之内保证了用户态DMA的安全性， 使用Interrupt Remapping来完成中断重映射和Interrupt Posting来达到中断隔离和中断直接投递的目的。


VFIO驱动框架为直接设备访问提供了统一的API。它将设备直接访问安全地(以一种IOMMU保护的环境)暴露给用户，是一种IOMMU/设备无关的框架。此框架用于多种设备，如GPU、网卡和计算加速器等。有了这种直接设备访问，虚拟机或者用户态应用可以直接访问物理设备。Mdeiated devices便是重用了VFIO这种框架。

Mediated core driver为mdiated device提供了一个公共的管理接口，它可以被不同类型的设备驱动所利用。
Mediated core driver也提供注册总线驱动的接口。比如，一个mediated VFIO mdev驱动就是为mediated devices设计的，并且支持VFIO的API。Mediated bus driver可以将一个mediated device加入或者移出一个VFIO group。

相关概念： 
- iommu：硬件单元，它可以把设备的IO地址映射成虚拟地址，为设备提供页表映射，设备通过IOMMU将数据直接DMA写到用户空间。
- device：要操作的硬件设备，这里的设备需要从IOMMU拓扑的角度来看。如果device 是一个硬件拓扑上是独立那么这个设备构成了一个IOMMU group。如果多个设备在硬件是互联的，需要相互访问数据，那么这些设备需要放到一个IOMMU group 中隔离起来。
- group：IOMMU 能进行DMA隔离的最小单元。一个group 可以有一个或者多个device。
- container： 由多个group 组成。虽然group 是VFIO 的最小隔离单元，但是并不是最好的分割粒度，比如多个group 需要共享一个页表的时候。将多个group 组成一个container来提高系统的性能，也方便用户管理。一般一个进程作为一个container。

VFIO的关键技术：
1. VFIO对完备的设备访问支持：其中包括MMIO， I/O Port，PCI 配置空间，PCI BAR空间；
2. VFIO中高效的设备中断机制，其中包括MSI/MSI-X，Interrupt Remapping，以及Posted Interrupt等；
3. VFIO对直通设备热插拔支持。

## 架构图

vfio驱动框架： 
1. vfio interface暴露给用户态程序进行ioctl的接口，代码在 drivers\vfio\vfio。
2. vifo_iommu 是对IOMMU driver 的封装，为vfio interface 提供IOMMU 功能，在内核源码中代码路径为：drivers\vfio\vfio_iommu_type1.c。
3. vfio_pci 是的device 驱动的封装，为vfio interface 提供设备的访问能力，例如访问设备的配置空间，bar空间。在内核源码中代码路径为：drivers\vfio\pci\vfio_pci.c 。
4. iommu driver 是物理硬件的IOMMU 实现，例如intel VT-D。
5. pci_bus driver 是物理PCI 设备的驱动。
6. VFIO的中断重映射相关的部分需要有kvm 相关的代码分析，本文没有分析。？？？？

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

## vfio用户态接口

VFIO 给用户空间提供的接口主要是有三个层面上的，第一个是container 层面，第二个是group 层面，第三个是device层面。

### container的操作
第一个层面，container的操作是通过打开`/dev/vifo/vifo` 文件对其执行ioctl操作，主要的操作有：

1. VFIO_GET_API_VERSION：获取VFIO版本信息
2. VFIO_CHECK_EXTENSION：检测是否支持特定扩展，支持哪些类型的IOMMU
3. VFIO_SET_IOMMU:设置指定的IOMMU类型
4. VFIO_IOMMU_GET_INFO：获取IOMMU的信息
5. VFIO_IOMMU_MAP_DMA：

### group的操作

第二个层面，group的操作是通过打开`/dev/vifo/<group_id>`文件, 对其执行ioctl操作，主要的操作有：

1. VFIO_GROUP_GET_STATUS:获取group 的状态信息
2. VFIO_GROUP_SET_CONTAINER:设置group 和container 之间的绑定关系
3. VFIO_GROUP_GET_DEVICE_FD:获取device 的文件描述符fd.


### device的操作
第三个层面的是device ,通过group 层面的ioctl的VFIO_GROUP_GET_DEVICE_FD 命令获取fd, 对获取的fd执行ioctl操作，主要的操作有：

1. VFIO_DEVICE_GET_REGION_INFO:用来获得设备指定区域region的数据，这里的region 不仅仅是指bar 空间还包括rom空间和配置空间。
2. VFIO_DEVICE_GET_IRQ_INFO:得到设备的中断信息
3. VFIO_DEVICE_RESET:重置设备

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

- vfio
  - iommu_drivers_list：挂接在container 上的所有vfio iommu_drivers，是对IOMMU driver 的一种封装。
  - group_list：挂接所有 vfio_group, 
  - group_idr :idr 值，关联次设备号，
  - group_devt：group 的设备号，
  - group_cdev：表明为一个字符设备。
- vfio_container： 可以理解为一个vm。用户态的接口文件为/dev/vfio/vfio
  - group_list：关联到vfio_container 上的所有vifo_ group, 一个container可以挂载多个container。
  - iommu_driver: vfio_container对iommu设备驱动(vfio_iommu_driver)的封装。
  - iommu_data：iommu_driver->open（）函数的返回值，vifo_iommu对象。
  - noiommu：是否是no iommu
  - 支持的用户态ioctl接口`/dev/vifo/vifo`
    - VFIO_GET_API_VERSION： 获取vfio的版本
    - VFIO_CHECK_EXTENSION
    - VFIO_SET_IOMMU： 设置iommu模式 VFIO_TYPE1_IOMMU
    - VFIO_IOMMU_GET_INFO： 
    - VFIO_IOMMU_MAP_DMA： 指定设备端看到的IO地址到进程的虚拟地址之间的映射
- vfio_group: 是IOMMU能够进行DMA隔离的最小硬件单元，一个group内可能只有一个device，也可能有多个device，取决于物理平台上硬件的IOMMU拓扑结构。VFIO中的group和iommu group可以认为是同一个概念。一个group里面的device无法做到dma隔离，也就是不能分配给不同的VM。设备属于哪个group取决于IOMMU和设备的物理结构，在设备直通时需要将一个group里的所有设备都分配给一个虚拟机，其实就是多个group可以从属于一个container，而group下的所有设备也随着该group从属于该container。用户态文件接口`/dev/vfio/$groupid`。
  - minor为在注册group设备时的次设备号，
  - container_users为该group的container的计数，
  - iommu_group为该group封装的iommu-group, 
  - container为该group关联的container，
  - device_list将属于该group下的所有设备连接起来，
  - vfio_next 挂接在vfio.group_list 上，
  - container_next挂接在vfio_container.group_list上，
  - unbound_lock 是挂在vfio_unbound_dev.unbound_next 上，
  - opened表明该group 是否初始化完成。
  - 支持的用户态ioctl接口`/dev/vfio/$groupid`
    - VFIO_GROUP_GET_STATUS:获取group 的状态信息
    - VFIO_GROUP_SET_CONTAINER:设置group 和container 之间的绑定关系
    - VFIO_GROUP_GET_DEVICE_FD:获取device 的文件描述符fd.
- vfio_device: 为了兼顾platform和pci设备，vfio统一对外提供 struct vfio_device 来描述vfio设备，并用device_data来指向如 struct vfio_pci_device。
  - struct vfio_device_ops *ops => vfio_pci_ops, 静态的操作函数。支持的ioctl用户态接口：
    - VFIO_DEVICE_GET_INFO：获取设备信息，region数量、irq数量等
	- VFIO_DEVICE_GET_REGION_INFO：获取vfio_region的信息，包括配置空间的region和bar空间的region等
	- VFIO_DEVICE_GET_IRQ_INFO：获取设备中断相关的信息
	- VFIO_DEVICE_SET_IRQS：完成中断相关的设置
	- VFIO_DEVICE_RESET：设备复位
	- VFIO_DEVICE_GET_PCI_HOT_RESET_INFO：获取PCI设备hot reset信息
	- VFIO_DEVICE_PCI_HOT_RESET：设置PCI设备 hot reset
	- VFIO_DEVICE_IOEVENTFD：设置ioeventfd
  - group表示所属group,
  - group_next连接同一个group 中的设备，
  - device_data指向vfio_pci_device.
  - kvm
  - iommufd_access
  - dev_set
- vfio_device_ops：vfio 设备操作函数callback
  - init： initialize private fields in device structure
  - release： Reclaim private fields in device structure
  - bind_iommufd： Called when binding the device to an iommufd
  - unbind_iommufd：Opposite of bind_iommufd
  - attach_ioas：Called when attaching device to an IOAS/HWPT managed by the	 bound iommufd. Undo in unbind_iommufd.
  - open_device： Called when the first file descriptor is opened for this device
  - close_device：
  - read： Perform read(2) on device file descriptor
  - write：
  - ioctl：
  - mmap：
  - request：
  - match： Optional device name match callback (return: 0 for no-match, >0 for match, -errno for abort 
  - dma_unmap：Called when userspace unmaps IOVA from the container   this device is attached to.
  - device_feature： Optional, fill in the VFIO_DEVICE_FEATURE ioctl
- vfio_pci是VFIO对pci设备驱动的统一封装，它和用户态进程一起配合完成设备访问直接访问，具体包括PCI配置空间模拟、PCI Bar空间重定向，Interrupt Remapping等。
- vfio_domain
- vfio_iommu: 是VFIO对iommu层的统一封装主要用来实现DMAP Remapping的功能，即管理IOMMU页表的能力
  - domain_list 为该vfio_iommu下挂接的vfio_domain，
  - external_domain 用于pci_mdev下的vfio_domain，
  - dma_list为dma 的rb_root的根节点，
  - dma_avail表示dma 条目数量。

VFIO提供了两个字符设备文件作为提供给用户程序的入口点，分别是/dev/vfio/vfio和/dev/vfio/$GROUP，此外还在sysfs中添加了一些文件。

VFIO驱动在加载的时候会创建一个名为/dev/vfio/vfio的文件，而这个文件的句柄关联到了vfio_container上，用户态进程打开这个文件就可以初始化和访问vfio_container。

首先看/dev/vfio/vfio，它是一个misc device，在vfio模块的初始化函数vfio_init中注册：

```c

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

```

## vfio

vfio_init() // 初始化vfio模块
|-> ida_init(&vfio.device_ida);  // XArray
|-> ret = vfio_group_init();
	|-> ida_init(&vfio.group_ida);
	|-> ret = vfio_container_init();
		|-> ret = misc_register(&vfio_dev);  // 注册vifo 作为一个混杂字符设备注册进内核，混杂设备为定义为vfio_dev
		|-> CONFIG_VFIO_NOIOMMU => ret = vfio_register_iommu_driver(&vfio_noiommu_ops); //CONFIG_VFIO_NOIOMMU：VFIO驱动程序是否支持无 IOMMU 模式
	|-> vfio.class = class_create(THIS_MODULE, "vfio");
	|-> vfio.class->devnode = vfio_devnode; // 设备名称：vfio/%s
	|-> ret = alloc_chrdev_region(&vfio.group_devt, 0, MINORMASK + 1, "vfio");
|-> ret = vfio_virqfd_init();
|-> vfio.device_class = class_create(THIS_MODULE, "vfio-dev");

/dev/vfio/vfio用户态接口vfio_fops：

1. vfio_fops_open（）函数主要完成struct vfio_container 对象的实例化，并将实例化的对象放到filep->private_data中。
2. vfio_fops_release（）函数主要完成vfio_container对象的释放。
3. vfio_fops_read（），vfio_fops_write（），vfio_fops_mmap（）主要是对vfio_iommu_driver 的read(),write(),mmap()函数的封装。
4. vfio_fops_unl_ioctl（）函数大部分cmd 也是对vfio_iommu_driver 的ioctl()函数的封装，主要有一个VFIO_SET_IOMMU命令，完成vfio_container和vfio_iommu_driver的绑定。

```C
static const struct file_operations vfio_fops = {
	.owner		= THIS_MODULE,
	.open		= vfio_fops_open,
	.release	= vfio_fops_release,
	.unlocked_ioctl	= vfio_fops_unl_ioctl,
	.compat_ioctl	= compat_ptr_ioctl,
};
```

vfio_fops_open： 设置vfio_container作为filep->private_data 
vfio_group_set_container: 通过open(/dev/vfio/vfio)获得container，open(/dev/vfio/$group_id)获得group，需要将group 链接contailer
vfio_ioctl_set_iommu： 用户态设置container的iommu
vfio_iommu_type1_open： 分配和初始化vfio_iommu
vfio_iommu_type1_attach_group: 创建和分配 vfio_group vfio_domain

struct pci_driver vfio_pci_driver.probe = vfio_pci_probe // vfio_pci驱动注册, 驱动加载的时候执行，注册vfio_group_fops接口
|-> vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev, &vfio_pci_ops)
|-> ret = vfio_pci_core_register_device(vdev);
	|-> rootbus => ret = vfio_assign_device_set(&vdev->vdev, vdev);
	|-> reset_slot => ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
	|-> other => ret = vfio_assign_device_set(&vdev->vdev, pdev->bus);
	|-> ret = vfio_pci_vf_init(vdev);
	|-> ret = vfio_pci_vga_init(vdev);
	|-> vfio_pci_probe_power_state(vdev);
	|-> vfio_pci_set_power_state(vdev, PCI_D0);
	|-> dev->driver->pm = &vfio_pci_core_pm_ops;
	|-> pm_runtime_allow(dev);
	|-> ret = vfio_register_group_dev(&vdev->vdev);
		|-> vfio_device_set_group(device, type)
			|-> vfio_group_find_or_alloc(device->dev)
				|-> iommu_group = iommu_group_get(dev)
				|-> vfio_group = vfio_group_find_from_iommu(iommu_group)
				|-> vfio_create_group(iommu_group, VFIO_IOMMU)
					|-> group = vfio_group_alloc(iommu_group, type)
						|-> device_initialize(&group->dev);
						|-> cdev_init(&group->cdev, &vfio_group_fops); // 注册group_id的fops
						|-> group->iommu_group = iommu_group;
					|-> dev_set_name(&group->dev, "%s%d",group_id)
					|-> cdev_device_add(&group->cdev, &group->dev);
			|-> device->group = group

/dev/vfio/group_id注册vfio_group_fops用户态接口：

```C
static const struct file_operations vfio_group_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl	= vfio_group_fops_unl_ioctl,
	.compat_ioctl	= compat_ptr_ioctl,
	.open		= vfio_group_fops_open,
	.release	= vfio_group_fops_release,
};
```

vfio_device的用户态接口vfio_device_fops:

VFIO_GROUP_GET_DEVICE_FD => vfio_group_ioctl_get_device_fd
|-> device = vfio_device_get_from_name(group, buf);
|-> fdno = get_unused_fd_flags(O_CLOEXEC);
|-> filep = vfio_device_open_file(device);
	|-> ret = vfio_device_group_open(device)
	|-> filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops, device, O_RDWR);
	|-> filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
|-> fd_install(fdno, filep);

```C
const struct file_operations vfio_device_fops = {
	.owner		= THIS_MODULE,
	.release	= vfio_device_fops_release,
	.read		= vfio_device_fops_read,
	.write		= vfio_device_fops_write,
	.unlocked_ioctl	= vfio_device_fops_unl_ioctl,
	.compat_ioctl	= compat_ptr_ioctl,
	.mmap		= vfio_device_fops_mmap,
};
```

## vfio驱动分析

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


## vfio_iommu驱动

VFIO框架中很重要的一部分是要完成DMA Remapping，即为Domain创建对应的IOMMU页表，这个部分是由vfio_iommu_driver来完成的。 vfio_container包含一个指针记录vfio_iommu_driver的信息，在x86上vfio_iommu_driver的具体实现是由vfio_iommu_type1来完成的。 其中包含了vfio_iommu, vfio_domain, vfio_group, vfio_dma等关键数据结构（注意这里是iommu里面的）。

- vfio_iommu： 可以认为是和container概念相对应的iommu数据结构，在虚拟化场景下每个虚拟机的物理地址空间映射到一个vfio_iommu上。
- vfio_domain： 它是一个与DRHD（即IOMMU硬件）相关的概念， 它的出现就是为了应对多IOMMU硬件的场景。我们知道在大规格服务器上可能会有多个IOMMU硬件，不同的IOMMU硬件有可能存在差异， 例如IOMMU 0支持IOMMU_CACHE而IOMMU 1不支持IOMMU_CACHE（当然这种情况少见，大部分平台上硬件功能是具备一致性的），这时候我们不能直接将分别属于不同IOMMU硬件管理的设备直接加入到一个container中， 因为它们的IOMMU页表SNP bit是不一致的。 因此，一种合理的解决办法就是把一个container划分多个vfio_domain，当然在大多数情况下我们只需要一个vfio_domain就足够了。 处在同一个vfio_domain中的设备共享IOMMU页表区域，不同的vfio_domain的页表属性又可以不一致，这样我们就可以支持跨IOMMU硬件的设备直通的混合场景
- vfio_dma
- vfio_batch
- vfio_iommu_group
- vfio_iova
- vfio_pfn
- vfio_regions
- vfio_iommu_driver_ops vfio_iommu_driver_ops_type1: 是对intel iommu 驱动的封装，最主要的功能是完成group 内的设备的内存映射和解映射。这个功能是通过vfio_iommu_type1_ioctl 的VFIO_IOMMU_MAP_DMA和VFIO_IOMMU_UNMAP_DMA命令来完成。

vfio_register_iommu_driver(&vfio_iommu_driver_ops_type1)
|-> driver = kzalloc(sizeof(vfio_iommu_driver), GFP_KERNEL);
|-> driver->ops = ops;
|-> list_add(&driver->vfio_next, &vfio.iommu_drivers_list) // 将vfio_iommu_driver 对象添加到vfio.iommu_drivers_list链表上。

```C
static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
	.name			= "vfio-iommu-type1",
	.owner			= THIS_MODULE,
	.open			= vfio_iommu_type1_open,
	.release		= vfio_iommu_type1_release,
	.ioctl			= vfio_iommu_type1_ioctl,
	.attach_group		= vfio_iommu_type1_attach_group,
	.detach_group		= vfio_iommu_type1_detach_group,
	.pin_pages		= vfio_iommu_type1_pin_pages,
	.unpin_pages		= vfio_iommu_type1_unpin_pages,
	.register_device	= vfio_iommu_type1_register_device,
	.unregister_device	= vfio_iommu_type1_unregister_device,
	.dma_rw			= vfio_iommu_type1_dma_rw,
	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
};
```
## vfio_group驱动分析

vfio_group_create_device

## vfio_device驱动分析
## vfio_pci驱动分析

### vfio配置空间管理

全局静态变量：
1. static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1]： PCI Capability
2. static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1]： PCI Extended Capability
3. static const u8 pci_cap_length[PCI_CAP_ID_MAX + 1]： pci config cababilities，各个位置的长度，有定长和变长
4. static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1]： pcie config cababilietes

API：
static int vfio_user_config_read(struct pci_dev *pdev, int offset, __le32 *val, int count)
static int vfio_user_config_write(struct pci_dev *pdev, int offset,__le32 val, int count)
static int vfio_default_config_read(struct vfio_pci_core_device *vdev, int pos, int count, struct perm_bits *perm, int offset, __le32 *val)
static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos, int count, struct perm_bits *perm, int offset, __le32 val)

直通设备的配置空间并不是直接呈现给虚拟机的，VFIO中会对设备的PCI 配置空间进行模拟。 为什么VFIO不直接把直通PCI 配置空间呈现给虚拟机呢？主要原因是一部分PCI Capability不能直接对guest呈现，VFIO需要截获部分guest驱动对某些PCI配置空间的操作， 另外像MSI/MSIx等特性需要QEMU/KVM的特殊处理，所以也不能直接呈现给虚拟机。

VFIO内核模块和QEMU会相互配合来完成设备的PCI配置空间的模拟，在VFIO中vfio_config_init函数中会为PCI设备初始化模拟的PCI配置空间。 对于每个设备而言，VFIO内核模块为其分配了一个pci_config_map结构，每个PCI Capability都有一个与之对应的perm_bits， 我们可以重写其hook函数来截获对这个Capability的访问（读/写）。

static const struct vfio_device_ops vfio_pci_ops.open_device	= vfio_pci_open_device(struct vfio_device *core_vdev) // 使能PCI设备，进行初始化设备，并将配置空间拷贝到相关结构体中。
|-> ret = vfio_pci_core_enable(vdev) // 读取PCI设备，读取配置空间和CAP
	|-> pci_clear_master(pdev);
	|-> ret = pci_enable_device(pdev); // 是能PCI设备
	|-> ret = pci_try_reset_function(pdev); // 复位function
	|-> pci_save_state(pdev);
	|-> no_intx: 是否支持 Masking broken INTx support
	|-> ret = vfio_pci_zdev_open_device(vdev)
	|-> ret = vfio_config_init(vdev) // PCI设备初始化模拟的PCI配置空间,分配pci_config_map结构(大小vdev->cfg_size)，每个PCI Capability都有一个与之对应的perm_bits
		|-> vfio_fill_vconfig_bytes(vdev, 0, PCI_STD_HEADER_SIZEOF)
		|-> vdev->rbar[0]------rbar[6]
		|-> ret = vfio_cap_init(vdev) // 初始化PCI Capability，主要用来填充模拟的vconfig
		|-> ret = vfio_ecap_init(vdev) // 初始化PCI Extended Capability，主要用来填充模拟的vconfig
	|-> vdev->msix_bar
|-> intel + vga => vfio_pci_igd_init(vdev)
|-> vfio_pci_core_finish_enable(vdev);
	|-> vdev->bar_mmap_supported[i] // 设置改BAR是否支持mmap
	|-> vfio_spapr_pci_eeh_open
	|-> vfio_pci_vf_token_user_add

static const struct vfio_device_ops vfio_pci_ops.read = vfio_pci_core_read // 对vfio配置空间进行读取
static const struct vfio_device_ops vfio_pci_ops.write = vfio_pci_core_write //对vfio配置空间进行写入
|-> vfio_pci_rw(vdev, buf, count, ppos, false); // 对VFIO设备的读写操作包括对配置空间的读写，对BAR空间的读写，以及region特定的读写操作
	|-> CONFIG_REGION => vfio_pci_config_rw(vdev, buf, count, ppos, iswrite)
		|-> PCI_CAP_ID_INVALID => vfio_raw_config_*() => pci_user_{read|write}_config来处理
		|-> PCI_CAP_ID_INVALID_VIRT => vfio_virt_config_*() => memcpy将结构体vdev->config上模拟的内部读取；
		|-> PCI_CAP_ID |PCI_ECAP_ID  => vfio_direct_config_*() => pci_user_{read|write}_config，若失败再调用memcpy进行读取；
		|-> PCI_CAP_ID_MSI => vfio_msi_config_x()
	|-> BAR0--BAR5|ROM_REGION => vfio_pci_bar_rw(vdev, buf, count, ppos, false)
		|-> BAR0~BAR5 => vfio_pci_setup_barmap()将BAR区域映射到vdev->barmap[]中
		|-> ROM => pci_map_rom() => io_remap()对ROM区域映射；
		|-> MSIX
	|-> VGA_REGION => vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite)
	|-> default => vdev->region[index].ops->rw(vdev, buf,  count, ppos, iswrite)


static const struct vfio_device_ops vfio_pci_ops.mmap = vfio_pci_core_mmap // 对BAR空间进行映射
|-> 非PCI定义的区域 => region->ops->mmap(vdev, region, vma)
|-> 定义的PCI区域，支持mmap => pci_iomap()将BAR空间映射到vdev->barmap[]，并为vma设置回调函数vfio_pci_mmap_ops。
	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
	vma->vm_ops = &vfio_pci_mmap_ops;

```C
static const struct vm_operations_struct vfio_pci_mmap_ops = {
	.open = vfio_pci_mmap_open,
	.close = vfio_pci_mmap_close,
	.fault = vfio_pci_mmap_fault,
};
```

static const struct vfio_device_ops vfio_pci_ops.request = vfio_pci_core_request // 若定义vdev->req_trigger，通过eventfd_signal()往虚拟机中注入模拟中断
static const struct vfio_device_ops vfio_pci_ops.ioctl = vfio_pci_core_ioctl // QEMU要获取设备的信息并设置设备，需要通过设备API进行调用，它们是通过函数vfio_pci_core_ioctl()来分别对不同的设备API进行处理。
|-> VFIO_DEVICE_GET_INFO => vfio_pci_ioctl_get_info // 获取设备region数目和中断的数目
|-> VFIO_DEVICE_GET_IRQ_INFO => vfio_pci_ioctl_get_irq_info // 获取设备对应的中断数目和标志
|-> VFIO_DEVICE_GET_PCI_HOT_RESET_INFO => vfio_pci_ioctl_get_pci_hot_reset_info
|-> VFIO_DEVICE_GET_REGION_INFO => vfio_pci_ioctl_get_region_info： 查看设备在host上呈现的bar空间信息,查询到对应BAR空间的size和offset信息。
|-> VFIO_DEVICE_IOEVENTFD => vfio_pci_ioctl_ioeventfd
|-> VFIO_DEVICE_PCI_HOT_RESET => vfio_pci_ioctl_pci_hot_reset
|-> VFIO_DEVICE_RESET => vfio_pci_ioctl_reset
|-> VFIO_DEVICE_SET_IRQS => vfio_pci_ioctl_set_irqs // 请求中断并设置中断处理函数,使能MSIX中断


- struct vfio_region_info
- struct vfio_info_cap


vfio_pci_core_ioctl：






static const struct vfio_device_ops vfio_pci_ops.mmap = vfio_pci_core_mmap
vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
vma->vm_ops = &vfio_pci_mmap_ops;

vfio_pci_mmap_open: 
|-> zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
	|-> zap_page_range_single(vma, address, size, NULL)

## vfio interrupt

vfio如何通知guest cpu 有事情要做？

qemu为vfio-device注册MSIX Capability Structure及MSIX Table和MSIX PBA，注册配置空间的读写函数

Guest中的驱动读写配置空间，触发qemu的配置空间，使能msi/msi-x时进入到qemu的vfio_msix_enbale配置eventfd和irq关联，qemu会注册eventfd的poll、invoke函数，kvm会记录这些信息。kvm中处理irq的消费者，如果支持PI，还会注册一个consumer，consumer.add_producer函数会更新producer->host_irq对应的IOMMU->IRTE。

vfio通过msi/msi-x写指定内存地址区域导致触发中断，kvm根据中断处理函数gsi routing entry 对应的set方法(kvm_set_msi)，找到目标CPU，调用kvm_apic_set_irq()向Guest注入中断。

```C
 vfio_msihandler()
  |
  |-> eventfd_signal()
      |
      |-> ...
          |
          |->  irqfd_wakeup()
               |
               |->kvm_arch_set_irq_inatomic()
                  |
                  |-> kvm_irq_delivery_to_apic_fast()
                      |
                      |-> kvm_apic_set_irq()
```

### 工作工程

qemu在模拟vfio的时候需要给vfio-devic的配置空间增加msi/msi-x功能状态位，也就是向msi/msi-x的capability structure中写入msi/msi-x enable bit。

### 数据结构

- struct vfio_device_info： 设备信息，包含region数量和irq数量信息。
- struct vfio_region_info： 每个region信息
- struct vfio_irq_info 
- struct vfio_irq_set
- 
### 实现过程

MSI和MSIX的差异点主要有两点：
1. 产生MSI中断的内存映射区在PCIE设备的配置空间，而产生MSIX中断的内存映射区在PCIE设备的BAR空间；
2. MSI中断最多支持32个，且要求申请的中断连续，而MSIX中断可支持的比较多（2048），不要求申请的中断连续；

默认在PCIE设备的配置空间存在着BAR地址指针，MSIX CAP寄存器等。其中MSIX CAP寄存中指定MSIX对应的Table和PBA所对应的BAR空间号以及在BAR中偏移，Table数目(Message Control指定)。在Table空间存放着每个MSIX中断对应的Message Addr/Message Data/Vector control。在PBA空间存放着MSIX中断对应的pending BIT。

中断过程：
1. QEMU通过对设备ioctl（VFIO_DEVICE_SET_IRQS）将VFIO设备中断与eventfd关联，并对VFIO设备申请中断并填充中断处理函数vfio_msihandle()；
2. QEMU中将guest要求的中断virq与eventfd关联，即当eventfd收到事件时，会往guest OS注入中断，这是通过QEMU对调用ioctl(KVM_IRQFD)实现的；
3. Guest OS对可以产生MSI/MSIX中断的内存映射区（设备配置空间或设备BAR空间）发起写操作时，会产生VM Exit到QEMU，QEMU将写的数据填写到设备的BAR空间中MSIX对应的Table中，从而触发ITS产生中断；
4. 当VFIO设备收到中断时，首先触发vfio-pci设备的中断处理函数vfio_msihandler()，它会调用eventfd_signal()向与virq关联的eventfd发送事件，eventfd收到事件后往guest OS注入中断；


VFIO_DEVICE_SET_IRQS => vfio_pci_ioctl_set_irqs // 使能msi中断最终调用vfio_msihandler(),向与virq关联的eventfd发送事件，eventfd收到事件后往guest OS注入中断；
|-> max = vfio_pci_get_irq_count(vdev, hdr.index);
|-> ret = vfio_set_irqs_validate_and_prepare(&hdr, max, VFIO_PCI_NUM_IRQS, &data_size);
|-> ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start, hdr.count, data)
	|-> VFIO_PCI_INTX_IRQ_INDEX => vfio_pci_set_intx_[trigger|mask|unmask](vdev, index, start, count, flags, data)
	|-> VFIO_PCI_MSI[X]_IRQ_INDEX => vfio_pci_set_msi_trigger(vdev, index, start, count, flags, data)
		|-> vfio_msi_set_block(vdev, start, count, fds, msix)
			|-> vfio_msi_set_vector_signal(vdev, j, fd, msix)
				|-> request_irq(irq, vfio_msihandler, 0, vdev->ctx[vector].name, trigger)
	|-> VFIO_PCI_ERR_IRQ_INDEX => vfio_pci_set_err_trigger
	|-> VFIO_PCI_REQ_IRQ_INDEX => vfio_pci_set_req_trigger

## demo

https://blog.csdn.net/alex_mianmian/article/details/119428351?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-119428351-blog-110845945.235%5Ev38%5Epc_relevant_anti_vip_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-119428351-blog-110845945.235%5Ev38%5Epc_relevant_anti_vip_base&utm_relevant_index=2

https://rtoax.blog.csdn.net/article/details/110843839

https://terenceli.github.io/%E6%8A%80%E6%9C%AF/2019/08/21/vfio-driver-analysis

https://www.openeuler.org/en/blog/wxggg/2020-11-29-vfio-passthrough-2.html