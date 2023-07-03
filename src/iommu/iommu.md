# 概念

IOMMU将总线域地址转成存储器地址的设备，IOMMU 的主要作用就是保护功能，防止使用 DMA 的设备访问任意存储器的物理地址。IOMMU主要功能包括DMA Remapping和Interrupt Remapping。


- 屏蔽物理地址，起到保护作用。典型应用包括两个：一是实现用户态驱动，由于IOMMU的映射功能，使HPA对用户空间不可见，在vfio部分还会举例。二是将设备透传给虚机，使HPA对虚机不可见，并将GPA映射为HPA.
- IOMMU可以将连续的虚拟地址映射到不连续的多个物理内存片段，这部分功能于MMU类似，对于没有IOMMU的情况，设备访问的物理空间必须是连续的，IOMMU可有效的解决这个问题


IOMMU 在不同架构上名字不太一样，AMD 叫 AMD-Vi，最开始针对的设备只是显卡，Intel 叫 VT-d，arm 叫 SMMU，具体对应的手册也不太一样，但是主要解决的问题是一致的。在 VTd 中，dmar (DMA remapping) 就是那个 IOMMU 设备，通过中断的方式实现类似 page fault 一样的内存分配行为。DMA 传输是由 CPU 发起的：CPU 会告诉 DMA 控制器，帮忙将 xxx 地方的数据搬到 xxx 地方。CPU 发完指令之后，就当甩手掌柜了。IOMMU 有点像 MMU 是一个将设备地址翻译到内存地址的页表体系，也会有对应的页表，这个东西在虚拟化中也非常有用，可以将原本有软件模拟的设备，用直接的硬件替代，而原本的隔离通过 IOMMU 来完成。如下图所示，原本需要通过软件模拟的驱动设备可以通过 IOMMU 以安全的方式来直接把硬件设备分配个用户态的 Guest OS。

在没有IOMMU的情况下，网卡接收数据时地址转换流程，RC会将网卡请求写入地址addr1直接发送到DDR控制器，然后访问DRAM上的addr1地址，这里的RC对网卡请求地址不做任何转换，网卡访问的地址必须是物理地址。对于有IOMMU的情况，网卡请求写入地址addr1会被IOMMU转换为addr2，然后发送到DDR控制器，最终访问的是DRAM上addr2地址，网卡访问的地址addr1会被IOMMU转换成真正的物理地址addr2，这里可以将addr1理解为虚机地址。


VFIO 的作用就是通过 IOMMU 以安全的方式来将设备的访问直接暴露到用户空间，而不用专门完成某个驱动等待合并到上游或者使用之前的对 IOMMU 没有感知的 UIO 的框架。通过 VFIO 向用户态开放 IOMMU 的功能，编写用户态的驱动。

对于 IOMMU 来说，隔离的级别不一定是单个设备，比如一个后面有几个设备的 PCI 桥，从 PCI 桥角度来说，都是来自 PCI 桥的总线事务。所以 IOMMU 有一个 iommu_group的概念，代表一组与其他设备隔离的设备的集合。

IOMMU 根据手册上讲还有一个域的概念，可以简单理解为一段物理地址的抽象。

在 iommu_group的层级上，VFIO 封装了一层 container class，这个的作用对应于希望能够在不同的iommu_group 之间共享 TLB 和 page tables，这个就是一个集合的概念，跟容器的那个概念没啥关系，一个集合总归要有个名字。通过把 host 的 device 和 driver 解绑，然后绑定到 VFIO 的 driver 上，就会有个/dev/vfio/$GROUP/ 出现，然后这个 $GROUP代表的就是这个 device 的 iommu_group号，如果要使用 VFIO 就要把这个 group 下的所有 device 都解绑才可以。

通过打开/dev/vfio/vfio就能创建一个 VFIO 的 container，然后再打开/dev/vfio/$GROUP用VFIO_GROUP_SET_CONTAINER ioctl 把文件描述传进去，就把 group 加进去了，如果支持多个 group 共享页表等结构，还可以把相应的 group 也加进去。（再强调一遍这个页表是总线地址到存储器物理地址，IOMMU 管理的那个页表）。

## 工作原理

IOMMU的主要功能就是完成映射，类比MMU利用页表实现VA->PA的映射，IOMMU也需要用到页表，那么下一个问题就是如何找到页表。在设备发起DMA请求时，会将自己的Source Identifier(包含Bus、Device、Func)包含在请求中，IOMMU根据这个标识，以`RTADDR_REG`指向空间为基地址，然后利用Bus、Device、Func在Context Table中找到对应的Context Entry，即页表首地址，然后利用页表即可将设备请求的虚拟地址翻译成物理地址。这里做以下说明：

- 图中红线的部门，是两个Context Entry指向了同一个页表。这种情况在虚拟化场景中的典型用法就是这两个Context Entry对应的不同PCIe设备属于同一个虚机，那样IOMMU在将GPA->HPA过程中要遵循同一规则   ?????
- 由图中可知，每个具有Source Identifier(包含Bus、Device、Func)的设备都会具有一个Context Entry。如果不这样做，所有设备共用同一个页表，隶属于不同虚机的不同GPA就会翻译成相同HPA，会产生问题，

### Source Identifier

在讲述IOMMU的工作原理时，讲到了设备利用自己的Source Identifier(包含Bus、Device、Func)来找到页表项来完成地址映射，不过存在下面几个特殊情况需要考虑。

- 对于由PCIe switch扩展出的PCI桥及桥下设备，在发送DMA请求时，Source Identifier是PCIe switch的，这样的话该PCI桥及桥下所有设备都会使用PCIe switch的Source Identifier去定位Context Entry，找到的页表也是同一个，如果将这个PCI桥下的不同设备分给不同虚机，由于会使用同一份页表，这样会产生问题，针对这种情况，当前PCI桥及桥下的所有设备必须分配给同一个虚机，这就是VFIO中组的概念，下面会再讲到。
- 对于SRIO-V，之前介绍过VF的Bus及devfn的计算方法，所以不同VF会有不同的Source Identifier，映射到不同虚机也是没有问题的
 

## RFIR： Remappable format interrupt request

## 数据结构

- iommu_group
- iommu_fwspec
- iommu_device
  - smmu_device：IOMMU的一种实现 
- iommu_domain
  - arm_smmu_domain(ARM架构)来管理驱动和设备之间的关联的，它为每个domain申请了一个独立的asid（和进程的asid完全无关）。也就是说，ARM认为，一个group只能服务一个进程。

