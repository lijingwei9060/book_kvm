# 概念

I/O设备可以直接存取内存，称为DMA(Direct Memory Access)；DMA要存取的内存地址称为DMA地址（也可称为BUS address）。在DMA技术刚出现的时候，DMA地址都是物理内存地址，简单直接，但缺点是不灵活，比如要求物理内存必须是连续的一整块而且不能是高位地址等等，也不能充分满足虚拟机的需要。后来dmar就出现了。 dmar意为DMA remapping，是Intel为支持虚拟机而设计的I/O虚拟化技术，I/O设备访问的DMA地址不再是物理内存地址，而要通过DMA remapping硬件进行转译，DMA remapping硬件会把DMA地址翻译成物理内存地址，并检查访问权限等等。负责DMA remapping操作的硬件称为IOMMU。

DMA remapping就是在DMA的过程中IOMMU进行了一次转换，MMU把CPU的虚拟地址(va)转换成物理地址(pa)，IOMMU的作用就是把DMA的虚拟地址(iova)转换成物理地址(pa)，MMU转换时用到了pagetable，IOMMU转换也要用到io pagetable，两者都是软件负责创建pagetable，硬件负责转换。IOMMU的作用就是限制DMA可操作的物理内存范围，当一个PCI设备passthrough给虚拟机后，PCI设备DMA的目的地址是虚拟机指定的，必须要有IOMMU限制这个PCI设备只能操作虚拟机用到的物理内存。

intel vt-d spec是IOMMU的标准，标准中一个domain就是一个隔离的空间，一个虚拟机就是一个domain，一个DPDK进行就是一个domain，一个PCI设备分配给这个domain后只能操作这个domain的物理内存。

## IO Pagetable

IOMMU的pagetable和MMU的pagetable一模一样，转换方式也一样，都支持4KB/2M/1G大小的page，都支持4级和5级页表，4级和5级的区别就是va/iova的长度是48位还57位。


DMA类型
- Requests without address-space-identifier：DMA中只带了source-id，也就是PCI设备的bus/dev/funtion。
- Requests with address-space-identifier：DMA中除了source-id还有PASID，而这个PASID来自于PCIE config space中的PASID Capability，它是软件配置到PCIE config space中的。

转换类型
intel vt-d IOMMU支持四种转换类型： first level/second level/nested /passthrough translation

- first level translation：类似于MMU页表，有可能出现页面不存在/权限不够等问题。
- second level translation：类似于MMU页表，有可能出现页面不存在/权限不够等问题。
- nested translation：类似于vt-x中的EPT，first level任何一级查到的结果是个中间值，并不是真正的物理地址，需要second level再转换一次才能得到真正的物理地址，比如有一个指针指向first level的PML4E，这个指针指向的并不是真正的物理地址，只有经过second level转换一下才能变成真正的物理地址，才能获取first level的PML4E表，从PML4E中得到PDPE指针，这个指针也需要second level进行一次转换，才是真正存放PDPE表的物理地址，依次类推。
- passthrough translation：跳过转换，DMA的iova就是pa。

## IO MMU 工作模式

intel vt-d iommu可以工作于legacy和scale模式。

legacy mode： Root Table Address Register指向root table，它中translation Table Mode是00b，root table和conext table是真正的物理地址。legacy mode采用Requests without address-space-identifier，DMA中带有bus/dev/function，bus查root table，dev和function查context table，context table结果指向second level pagetable，查pagetable得到最终的物理地址。

scale mode： Root Table Address Register指向root table，它中ranslation Table Mode是01b，root/context/PASID-directory/PASID-tables是真正的物理地址。scale mode同时支持Requests without address-space-identifier和Requests with address-space-identifier，如果没有PASID，那么就取context table中默认的RID_PASID。bus查root table，dev和function查context table，context table的结果指向PASID directory，PASID directory的结果指向PASID table，PASID table的结果同时包含first level pagetable, second level pagetable和PASID Granular Translation Type (PGTT)，PGTT中指明进行first level/second level/nested/passthrough translation。



## fault中断处理：dmar_fault

dmar的初始化是kernel根据ACPI中的dmar table进行的，每一个表项对应一个dmar设备，名称从dmar0开始依次递增。涉及到的函数在alloc_iommu。
dmar_fault_do_one()会报告fault的具体信息，包括对应设备的物理位置。由于一个dmar对应着很多个I/O设备，这条信息可以帮助定位到具体哪一个设备。

过去的AMD64芯片也提供一个功能有限的地址转译模块——GART (Graphics Address Remapping Table)，有时候它也可以充当IOMMU，这导致了人们对GART和新的IOMMU的混淆。最初设计GART是为了方便图形芯片直接读取内存：使用地址转译功能将收集到内存中的数据映射到一个图形芯片可以“看”到的地址。后来GART被Linux kernel用来帮助传统的32位PCI设备访问可寻址范围之外的内存区域。这件事新的IOMMU当然也可以做到，而且没有GART的局限性（它仅限于显存的范围之内），IOMMU可以将I/O设备的任何DMA地址转换为物理内存地址。