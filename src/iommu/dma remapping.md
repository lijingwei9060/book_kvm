# 概念

I/O设备可以直接存取内存，称为DMA(Direct Memory Access)；DMA要存取的内存地址称为DMA地址（也可称为BUS address）。在DMA技术刚出现的时候，DMA地址都是物理内存地址，简单直接，但缺点是不灵活，比如要求物理内存必须是连续的一整块而且不能是高位地址等等，也不能充分满足虚拟机的需要。后来dmar就出现了。 dmar意为DMA remapping，是Intel为支持虚拟机而设计的I/O虚拟化技术，I/O设备访问的DMA地址不再是物理内存地址，而要通过DMA remapping硬件进行转译，DMA remapping硬件会把DMA地址翻译成物理内存地址，并检查访问权限等等。负责DMA remapping操作的硬件称为IOMMU。

DMA remapping就是在DMA的过程中IOMMU进行了一次转换，MMU把CPU的虚拟地址(va)转换成物理地址(pa)，IOMMU的作用就是把DMA的虚拟地址(iova)转换成物理地址(pa)，MMU转换时用到了pagetable，IOMMU转换也要用到io pagetable，两者都是软件负责创建pagetable，硬件负责转换。IOMMU的作用就是限制DMA可操作的物理内存范围，当一个PCI设备passthrough给虚拟机后，PCI设备DMA的目的地址是虚拟机指定的，必须要有IOMMU限制这个PCI设备只能操作虚拟机用到的物理内存。

intel vt-d spec是IOMMU的标准，标准中一个domain就是一个隔离的空间，一个虚拟机就是一个domain，一个DPDK进行就是一个domain，一个PCI设备分配给这个domain后只能操作这个domain的物理内存。

## IO Pagetable

IOMMU domain page table和MMU的page table一模一样，转换方式也一样，都支持4KB/2M/1G大小的page，都支持4级和5级页表，4级和5级的区别就是va/iova的长度是48位还57位。


DMA类型
- Requests without address-space-identifier：DMA中只带了source-id，也就是PCI设备的BDF, 这种一般是endpoint devices的普通请求，请求内容进包含请求的类型(read/write/atomics)，DMA请求的address/size以及请求设备的标志符等。
- Requests with address-space-identifier：DMA中除了source-id还有PASID，Execute-Requested (ER) flag和 Privileged-mode-Requested 等细节信息。而这个PASID来自于PCIE config space中的PASID Capability，它是软件配置到PCIE config space中的。

转换类型
intel vt-d IOMMU支持四种转换类型： first level/second level/nested /passthrough translation

- first level translation：类似于MMU页表，有可能出现页面不存在/权限不够等问题。
- second level translation：类似于MMU页表，有可能出现页面不存在/权限不够等问题。
- nested translation：类似于vt-x中的EPT，first level任何一级查到的结果是个中间值，并不是真正的物理地址，需要second level再转换一次才能得到真正的物理地址，比如有一个指针指向first level的PML4E，这个指针指向的并不是真正的物理地址，只有经过second level转换一下才能变成真正的物理地址，才能获取first level的PML4E表，从PML4E中得到PDPE指针，这个指针也需要second level进行一次转换，才是真正存放PDPE表的物理地址，依次类推。
- passthrough translation：跳过转换，DMA的iova就是pa。

DMA Address Translation和MMU将va转成PA过程相同。在多路服务器上可能集成有多个DMA Remapping硬件单元。每个硬件单元负责管理挂载到它所在的PCIe Root Port下所有设备的DMA请求。BIOS会将平台上的DMA Remapping硬件信息通过ACPI协议报告给操作系统，再由操作系统来初始化和管理这些硬件设备。

## root-entry/context-entry

为了能够记录直通设备和每个Domain的关系，VT-d引入了root-entry/context-entry的概念，通过查询root-entry/context-entry表就可以获得直通设备和Domain之间的映射关系。

BDF可以唯一表达一个pcie设备。

Root-table是一个4K页，共包含了256项root-entry，分别覆盖了PCI的Bus0-255，每个root-entry占16-Byte，记录了当前PCI Bus上的设备映射关系，通过PCI Bus Number进行索引。 Root-table的基地址存放在`Root Table Address Register`当中。

Root-entry中记录的关键信息有：

- Present Flag：代表着该Bus号对应的Root-Entry是否呈现，CTP域是否初始化；
- Context-table pointer (CTP)：CTP记录了当前Bus号对应点Context Table的地址。

同样每个context-table也是一个4K页，记录一个特定的PCI设备和它被分配的Domain的映射关系，即对应Domain的DMA地址翻译结构信息的地址。 每个root-entry包含了该Bus号对应的context-table指针，指向一个context-table，而每张context-table包又含256个context-entry， 其中每个entry对应了一个Device Function号所确认的设备的信息。通过2级表项的查询我们就能够获得指定PCI被分配的Domain的地址翻译结构信息。

Context-entry中记录的信息有：

- Present Flag：表示该设备对应的context-entry是否被初始化，如果当前平台上没有该设备Preset域为0，索引到该设备的请求也会被block掉。
- Translation Type：表示哪种请求将被允许；
- Address Width：表示该设备被分配的Domain的地址宽度；
- Second-level Page-table Pointer：二阶页表指针提供了DMA地址翻译结构的HPA地址（这里仅针对Requests-without-PASID而言）；
- Domain Identifier: Domain标志符表示当前设备的被分配到的Domain的标志，硬件会利用此域来标记context-entry cache，这里有点类似VPID的意思；
- Fault Processing Disable Flag：此域表示是否需要选择性的disable此entry相关的remapping faults reporting。

因为多个设备有可能被分配到同一个Domain，这时只需要将其中每个设备context-entry项的 Second-level Page-table Pointer 设置为对同一个Domain的引用， 并将Domain ID赋值为同一个Domian的就行了。


IOMMU硬件会截获直通设备发出的请求，然后根据其Request ID查表找到对应的Address Translation Structure即该Domain的IOMMU页表基地址， 这样一来该设备的DMA地址翻译就只会按这个Domain的IOMMU页表的方式进行翻译，翻译后的HPA必然落在此Domain的地址空间内（这个过程由IOMMU硬件中自动完成）， 而不会访问到其他Domain的地址空间，这样就达到了DMA隔离的目的。

IOMMU地址翻译则是将虚拟机物理地址空间内的GPA翻译成HPA。IOMMU页表和MMU页表一样，都采用了多级页表的方式来进行翻译。 对于一个48bit的GPA地址空间的Domain而言，其IOMMU Page Table共分4级，每一级都是一个4KB页含有512个8-Byte的目录项。和MMU页表一样，IOMMU页表页支持2M/1G大页内存，同时硬件上还提供了IO-TLB来缓存最近翻译过的地址来提升地址翻译的速度。


## IO MMU 工作模式

intel vt-d iommu可以工作于legacy和scale模式。

legacy mode： Root Table Address Register指向root table，它中translation Table Mode是00b，root table和conext table是真正的物理地址。legacy mode采用Requests without address-space-identifier，DMA中带有bus/dev/function，bus查root table，dev和function查context table，context table结果指向second level pagetable，查pagetable得到最终的物理地址。

scale mode： Root Table Address Register指向root table，它中ranslation Table Mode是01b，root/context/PASID-directory/PASID-tables是真正的物理地址。scale mode同时支持Requests without address-space-identifier和Requests with address-space-identifier，如果没有PASID，那么就取context table中默认的RID_PASID。bus查root table，dev和function查context table，context table的结果指向PASID directory，PASID directory的结果指向PASID table，PASID table的结果同时包含first level pagetable, second level pagetable和PASID Granular Translation Type (PGTT)，PGTT中指明进行first level/second level/nested/passthrough translation。



## fault中断处理：dmar_fault

dmar的初始化是kernel根据ACPI中的dmar table进行的，每一个表项对应一个dmar设备，名称从dmar0开始依次递增。涉及到的函数在alloc_iommu。
dmar_fault_do_one()会报告fault的具体信息，包括对应设备的物理位置。由于一个dmar对应着很多个I/O设备，这条信息可以帮助定位到具体哪一个设备。

过去的AMD64芯片也提供一个功能有限的地址转译模块——GART (Graphics Address Remapping Table)，有时候它也可以充当IOMMU，这导致了人们对GART和新的IOMMU的混淆。最初设计GART是为了方便图形芯片直接读取内存：使用地址转译功能将收集到内存中的数据映射到一个图形芯片可以“看”到的地址。后来GART被Linux kernel用来帮助传统的32位PCI设备访问可寻址范围之外的内存区域。这件事新的IOMMU当然也可以做到，而且没有GART的局限性（它仅限于显存的范围之内），IOMMU可以将I/O设备的任何DMA地址转换为物理内存地址。