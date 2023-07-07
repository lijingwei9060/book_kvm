# 概念

IOMMU(IO Memory management Unit)将总线域地址转成存储器地址的设备，IOMMU 的主要作用就是保护功能，防止使用 DMA 的设备访问任意存储器的物理地址。IOMMU主要功能包括DMA Remapping和Interrupt Remapping。DMA Remapping让具有DMA (Direct Memory Access)能力的设备可以使用虚拟地址，然后经过IOMMU翻译成可以直接访问内存的物理地址。


- DMAR使用虚拟地址，屏蔽物理地址，起到保护作用。典型应用包括两个：一是实现用户态驱动，由于IOMMU的映射功能，使HPA对用户空间不可见，在vfio部分还会举例。二是将设备透传给虚机，使HPA对虚机不可见，IOMMU将GPA映射为HPA，避免虚拟机之间IO空间冲突.
- IOMMU可以将连续的虚拟地址映射到不连续的多个物理内存片段，这部分功能于MMU类似，对于没有IOMMU的情况，设备访问的物理空间必须是连续的，IOMMU可有效的解决这个问题。

IOMMU 通常是实现在北桥之中，现在北桥通常被集成进SOC中了，所以IOMMU通常都放在SOC内部了，也就是说一台服务器可能有多个IOMMU设备。不同芯片厂商的实现大同小异，可是名字却不太一样。Intel的芯片上叫做 VT-d （Virtualization Technology for Directed I/O ），AMD还是叫做IOMMU， ARM叫做SMMU。最开始针对的设备只是显卡。在 VTd 中，dmar (DMA remapping) 就是那个 IOMMU 设备，通过中断的方式实现类似 page fault 一样的内存分配行为。

DMA 传输是由 CPU 发起的：CPU 会告诉 DMA 控制器，帮忙将 xxx 地方的数据搬到 xxx 地方。CPU 发完指令之后，就当甩手掌柜了。IOMMU 有点像 MMU 是一个将设备地址翻译到内存地址的页表体系，也会有对应的页表，这个东西在虚拟化中也非常有用，可以将原本有软件模拟的设备，用直接的硬件替代，而原本的隔离通过 IOMMU 来完成。原本需要通过软件模拟的驱动设备可以通过 IOMMU 以安全的方式来直接把硬件设备分配个用户态的 Guest OS。

## IOMMU和设备管理关系是什么？

intel vt-d spec是IOMMU的标准，标准中一个domain就是一个隔离的空间，一个虚拟机就是一个domain，一个DPDK进行就是一个domain，一个PCI设备分配给这个domain后只能操作这个domain的物理内存。


## PCIE会越界访问内存吗

## DMAR工作过程

在没有IOMMU的情况下，网卡接收数据时地址转换流程，RC会将网卡请求写入地址addr1直接发送到DDR控制器，然后访问DRAM上的addr1地址，这里的RC对网卡请求地址不做任何转换，网卡访问的地址必须是物理地址。对于有IOMMU的情况，网卡请求写入地址addr1会被IOMMU转换为addr2，然后发送到DDR控制器，最终访问的是DRAM上addr2地址，网卡访问的地址iova被IOMMU转换成真正的物理地址pa，这里可以将addr1理解为虚机地址。

IOMMU的主要功能就是完成映射，类比MMU利用页表实现VA->PA的映射，IOMMU也需要用到页表，那么下一个问题就是如何找到页表。在设备发起DMA请求时，会将自己的`Source Identifier`(BDF,包含Bus、Device、Func)包含在请求中，IOMMU根据这个标识，以`RTADDR_REG`指向空间为基地址，然后利用Bus、Device、Func在`Context Table`中找到对应的`Context Entry`，即页表首地址，然后利用页表即可将设备请求的虚拟地址翻译成物理地址。这里做以下说明：

- 图中红线的部门，是两个Context Entry指向了同一个页表。这种情况在虚拟化场景中的典型用法就是这两个Context Entry对应的不同PCIe设备属于同一个虚机，那样IOMMU在将GPA->HPA过程中要遵循同一规则   ?????
- 由图中可知，每个具有Source Identifier(包含Bus、Device、Func)的设备都会具有一个Context Entry。如果不这样做，所有设备共用同一个页表，隶属于不同虚机的不同GPA就会翻译成相同HPA，会产生问题，

### Source Identifier

在讲述IOMMU的工作原理时，讲到了设备利用自己的Source Identifier(包含Bus、Device、Func)来找到页表项来完成地址映射，不过存在下面几个特殊情况需要考虑。BDF可以唯一表达一个pcie设备。

- 对于由PCIe switch扩展出的PCI桥及桥下设备，在发送DMA请求时，Source Identifier是PCIe switch的，这样的话该PCI桥及桥下所有设备都会使用PCIe switch的Source Identifier去定位Context Entry，找到的页表也是同一个，如果将这个PCI桥下的不同设备分给不同虚机，由于会使用同一份页表，这样会产生问题，针对这种情况，当前PCI桥及桥下的所有设备必须分配给同一个虚机，这就是VFIO中组的概念，下面会再讲到。
- 对于SRIO-V，之前介绍过VF的Bus及devfn的计算方法，所以不同VF会有不同的Source Identifier，映射到不同虚机也是没有问题的

### IO PageTable

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


### root-entry/context-entry

为了能够记录直通设备和每个Domain的关系，VT-d引入了root-entry/context-entry的概念，通过查询root-entry/context-entry表就可以获得直通设备和Domain之间的映射关系。

Root-table是一个4K页，共包含了256项root-entry，分别覆盖了PCI的Bus0-255，每个root-entry占16-Byte，记录了当前PCI Bus上的设备映射关系，通过PCI Bus Number进行索引。 Root-table的基地址存放在`Root Table Address Register`(`RTADDR_REG`)当中。todo: 这个寄存器的结构是什么？

RTADDR_REG指向4K页面root-table，对齐后末12位有标志位功能。页面包含256个root-entry，每个16字节。
每个root-entry也是指向4K页面(context-table)，所以末12位也是标志位。
每个context-entry指向 二级页表指针，对应domain。

Root-entry中记录的关键信息有：

- Present Flag：代表着该Bus号对应的Root-Entry是否present，CTP域是否初始化；
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


IOMMU硬件会截获直通设备发出的请求，然后根据其Request ID查表找到对应的`Address Translation Structure`即该Domain的IOMMU页表基地址， 这样一来该设备的DMA地址翻译就只会按这个Domain的IOMMU页表的方式进行翻译，翻译后的HPA必然落在此Domain的地址空间内（这个过程由IOMMU硬件中自动完成）， 而不会访问到其他Domain的地址空间，这样就达到了DMA隔离的目的。

IOMMU地址翻译则是将虚拟机物理地址空间内的GPA翻译成HPA。IOMMU页表和MMU页表一样，都采用了多级页表的方式来进行翻译。 对于一个48bit的GPA地址空间的Domain而言，其IOMMU Page Table共分4级，每一级都是一个4KB页含有512个8-Byte的目录项。和MMU页表一样，IOMMU页表页支持2M/1G大页内存，同时硬件上还提供了IO-TLB来缓存最近翻译过的地址来提升地址翻译的速度。


### fault中断处理：dmar_fault

dmar的初始化是kernel根据ACPI中的dmar table进行的，每一个表项对应一个dmar设备，名称从dmar0开始依次递增。涉及到的函数在alloc_iommu。
dmar_fault_do_one()会报告fault的具体信息，包括对应设备的物理位置。由于一个dmar对应着很多个I/O设备，这条信息可以帮助定位到具体哪一个设备。

过去的AMD64芯片也提供一个功能有限的地址转译模块——GART (Graphics Address Remapping Table)，有时候它也可以充当IOMMU，这导致了人们对GART和新的IOMMU的混淆。最初设计GART是为了方便图形芯片直接读取内存：使用地址转译功能将收集到内存中的数据映射到一个图形芯片可以“看”到的地址。后来GART被Linux kernel用来帮助传统的32位PCI设备访问可寻址范围之外的内存区域。这件事新的IOMMU当然也可以做到，而且没有GART的局限性（它仅限于显存的范围之内），IOMMU可以将I/O设备的任何DMA地址转换为物理内存地址。


### IO MMU 工作模式

intel vt-d iommu可以工作于legacy和scale模式。

legacy mode： Root Table Address Register指向root table，translation Table Mode是00b，root table和conext table是真正的物理地址。legacy mode采用Requests without address-space-identifier，DMA中带有bus/dev/function，bus查root table，dev和function查context table，context table结果指向second level pagetable，查pagetable得到最终的物理地址。

scale mode： Root Table Address Register指向root table，translation Table Mode是01b，root/context/PASID-directory/PASID-tables是真正的物理地址。scale mode同时支持Requests without address-space-identifier和Requests with address-space-identifier，如果没有PASID，那么就取context table中默认的RID_PASID。bus查root table，dev和function查context table，context table的结果指向PASID directory，PASID directory的结果指向PASID table，PASID table的结果同时包含first level pagetable, second level pagetable和PASID Granular Translation Type (PGTT)，PGTT中指明进行first level/second level/nested/passthrough translation。

## RFIR： Remappable format interrupt request

## 数据结构

- iommu_group
- iommu_fwspec
- iommu_device
  - smmu_device：IOMMU的一种实现 
- iommu_domain
  - arm_smmu_domain(ARM架构)来管理驱动和设备之间的关联的，它为每个domain申请了一个独立的asid（和进程的asid完全无关）。也就是说，ARM认为，一个group只能服务一个进程。


## VFIO：todo——move
VFIO 的作用就是通过 IOMMU 以安全的方式来将设备的访问直接暴露到用户空间，而不用专门完成某个驱动等待合并到上游或者使用之前的对 IOMMU 没有感知的 UIO 的框架。通过 VFIO 向用户态开放 IOMMU 的功能，编写用户态的驱动。

对于 IOMMU 来说，隔离的级别不一定是单个设备，比如一个后面有几个设备的 PCI 桥，从 PCI 桥角度来说，都是来自 PCI 桥的总线事务。所以 IOMMU 有一个 iommu_group的概念，代表一组与其他设备隔离的设备的集合。

IOMMU 根据手册上讲还有一个域的概念，可以简单理解为一段物理地址的抽象。

在 iommu_group的层级上，VFIO 封装了一层 container class，这个的作用对应于希望能够在不同的iommu_group 之间共享 TLB 和 page tables，这个就是一个集合的概念，跟容器的那个概念没啥关系，一个集合总归要有个名字。通过把 host 的 device 和 driver 解绑，然后绑定到 VFIO 的 driver 上，就会有个/dev/vfio/$GROUP/ 出现，然后这个 $GROUP代表的就是这个 device 的 iommu_group号，如果要使用 VFIO 就要把这个 group 下的所有 device 都解绑才可以。

通过打开/dev/vfio/vfio就能创建一个 VFIO 的 container，然后再打开/dev/vfio/$GROUP用VFIO_GROUP_SET_CONTAINER ioctl 把文件描述传进去，就把 group 加进去了，如果支持多个 group 共享页表等结构，还可以把相应的 group 也加进去。（再强调一遍这个页表是总线地址到存储器物理地址，IOMMU 管理的那个页表）。

