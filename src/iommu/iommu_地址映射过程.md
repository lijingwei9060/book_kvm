# 工作原理

## DMAR工作过程

DMAR当IO设备发起DMA访问请求时，IOMMU会将请求的地址进行一次转换，通过这样的方式，将guest的物理地址映射到host上真实的物理地址上去。DMA重映射的核心就是地址转换。
IOMMU提供了次级页表（Second-Level Page Table Structures）来存储一个IO设备所在虚机的IO内存映射。次级页表描述了一个虚机包含的IO设备可访问的物理页。如果两个IO设备都使用一个次级页表，那么他们必然属于同一个虚机。
IOMMU要求发送内存访问请求的IO设备表明自己的source-id，对于pci设备source-id就是BDF，IOMMU用这个东西作为索引，就能查找到IO设备所在虚机拥有的页表结构。因此还需要以BDF为关键字的表，用来存放页表的物理地址。IOMMU将这个页表分为两级，分别是Root Table和Context Table。

总结， IOMMU为实现DMA Remapping实现了两类表：Root Table/Context Table和Second-Level Page Table。同时要求访问物理内存的IO设备表明自己的source-id BDF。

intel iommu 通过RTADDR_REG指向空间为基地址指向Root Table，然后利用Bus、Device、Func在Context Table(for bus 0..255)中找到对应的Context Entry，即次级页表(second level page table)首地址，然后利用页表即可将设备请求的虚拟地址翻译成物理地址。

ARM smmu的寄存器(STRTAB_BASE)保存着这些表在内存中的基地址，首先就是StreamTable(STE)，这ste 表既包含stage1的翻译表结构也包含stage2的翻译结构，所谓stage1负责VA 到 PA的转换，stage2负责IPA到PA的转换。
在arm smmu v3 第一层的目录desc的目录结够，大小采用8（STRTAB_SPLIT）位，也就是stream id的高8位，stream id剩下的低位全部用来寻址第二层真正的ste entry;


## Intel IOMMU 工作模式



intel vt-d iommu可以工作于legacy和scale模式。

legacy mode： `Root Table Address Register`指向root table，`translation Table Mode`是00b，root table和conext table是真正的物理地址。legacy mode采用Requests without address-space-identifier，DMA中带有bus/dev/function，bus查root table，dev和function查context table，context table结果指向second level pagetable，查pagetable得到最终的物理地址。

scale mode： `Root Table Address Register`指向root table，`translation Table Mode`是01b，root/context/PASID-directory/PASID-tables是真正的物理地址。scale mode同时支持Requests without address-space-identifier和Requests with address-space-identifier，如果没有PASID，那么就取context table中默认的RID_PASID。bus查root table，dev和function查context table，context table的结果指向PASID directory，PASID directory的结果指向PASID table，PASID table的结果同时包含first level pagetable, second level pagetable和PASID Granular Translation Type (PGTT)，PGTT中指明进行first level/second level/nested/passthrough translation。


RTADDR_REG: root table address register,
1. 63:12, RW, root Table Address， 4k大小并对其的地址， SRTP Global Command Register
2. 11: RW, RTT root table type, 0 root tabkle, 1 extended root table, TES = 1 in global status register运行过程中不能修改他

Root-table是一个4K页，共包含了256项root-entry，分别覆盖了PCI的Bus0-255，每个root-entry占16-Byte，记录了当前PCI Bus上的设备映射关系，通过PCI Bus Number进行索引。 Root-table的基地址存放在Root Table Address Register当中。
Root-entry，128bit中记录的关键信息有：

1. 0： Present Flag：代表着该Bus号对应的Root-Entry是否呈现，CTP域是否初始化；
2. 12：63， Context-table pointer (CTP)：CTP记录了当前Bus号对应点Context Table的地址，指向一个4KB地址。

Extend-root-table，在支持Extended-Context-Support (ECS=1 in Extended Capability Register)的硬件上，如果RTADDR_REG的RTT=1，则它指向的是一个extended root-table。
1. 0： lower present， 说明lower-context-table 是否present。
2. 12:63: lower CONTEXT-TABLE POINTER， lctp，指向4K对齐的地址，该bus对应的lower-context-table 地址
3. 64： up present， upper—context-table 是否present
4. 76-127： upper context table pointer， 该bus对应的upper—context-table地址，4K对齐

同样每个context-table也是一个4K页，记录一个特定的PCI设备和它被分配的Domain的映射关系，即对应Domain的DMA地址翻译结构信息的地址。 每个root-entry包含了该Bus号对应的context-table指针，指向一个context-table，而每张context-table包又含256个context-entry， 其中每个entry对应了一个Device Function号所确认的设备的信息。通过2级表项的查询我们就能够获得指定PCI被分配的Domain的地址翻译结构信息。

Context-entry 128bit， 只能支持requests-without-PASID，其中记录的信息有：

1. 0： Present Flag：表示该设备对应的context-entry是否被初始化，如果当前平台上没有该设备Preset域为0，索引到该设备的请求也会被block掉。
2. 1： Fault Processing Disable Flag：此域表示是否需要选择性的disable此entry相关的remapping faults reporting。
3. 2-3： Translation Type：表示哪种请求将被允许；
4. Address Width：表示该设备被分配的Domain的地址宽度；
5. HAW-1：12， Second-level Page-table Pointer：二阶页表指针提供了DMA地址翻译结构的HPA地址（这里仅针对Requests-without-PASID而言）；
6. 87:72： Domain Identifier: Domain标志符表示当前设备的被分配到的Domain的标志，硬件会利用此域来标记context-entry cache，这里有点类似VPID的意思；


因为多个设备有可能被分配到同一个Domain，这时只需要将其中每个设备context-entry项的 Second-level Page-table Pointer 设置为对同一个Domain的引用， 并将Domain ID赋值为同一个Domian的就行了。


一个Extended root entry可以同时索引一个lower-context-table和一个upper-context-table，这两者都是4-KB大小、包含128个extended-context-entries。

1. lower-context-table 对应了特定bus（root entry索引）上device#为0-15的PCI设备
2. upper-context-table 对应了特定bus（root entry索引）上device#为16-31的PCI设备

Extended-context-entries既支持requests-without-PASID，也支持requests-with-PASID。对于前者，entry结构与上述regular context entry一致；对于后者，其结构如下所示：
REF： https://nimisolo.github.io/post/vtd-dma-remapping/


First-level Translation
Extended-Context-Entry可以被配置为通过First-level Translation来翻译requests-with-PASID。这种配置下Extended-Context-Entry包含了指向PASID-table的指针和大小，而requests-with-PASID中的PASID-number作为PASID-table中的offset来索引一个PASID-entry。在PASID-entry中包含了相应进程地址空间的first-level translation structure的指针。

Second-level Translation
Extended-Context-Entry可以被配置为使用second-level translation。这种配置下，Extended-Context-Entry中包含了指向second-level translation structure的指针。

second-level translation可以用来转换requests-without-PASID，也可以在nested translation过程中用来转换requests-with-PASID的first-level translation。（这种使用方式还不太明白，或许和嵌套虚拟化相关，L1虚拟机向L2虚拟机呈现vt-d dma remapping功能时或许会用到）

## 如何划分domain


## static identity domain
hw_pass_through指的是iommu硬件上是否支持paas through翻译模式即iova就是真实的物理地址不需要再走一遍从iova转换到hpa的流程。

如果iommu硬件支持hw且iommu配置了pt则这种场景下硬件的DMA到达iommu之后不需要走页表翻译直接跟memory controller进行交互就可以了。但是iommu硬件是如何知道哪些设备的dma要走页表进行转换，哪些设备的dma不需要进行地址转换呢？答案在iommu硬件单元的contex_entry中，设备在通过bus号在root table里面找到相应的root_entry，然后再通过devfn在context table里面找到对应的context_entry，然后才能找到真正的页表。而从vt-d的spec来看，contex_entry的format里面有一个标志位(TT)来表明这个设备的DMA是否是paasthroug。而这个TT位是在设备添加到iommu_domain中，即`domain_add_dev_info` 这个函数并最佳终走到`domain_context_mapping_one`设置的。

si_domain_init

Identity mapping for IOMMU defines a single domain to 1:1 map all pci devices to all usable memory. This reduces map/unmap overhead in DMA API's and improve IOMMU performance. On 10Gb network cards, Netperf shows no performance degradation compared to non-IOMMU performance. This method may lose some of DMA remapping benefits like isolation. The patch sets up identity mapping for all pci devices to all usable memory. In the DMA API's, there is no overhead to maintain page tables, invalidate iotlb, flush cache etc. 32 bit DMA devices don't use identity mapping domain in order to access memory beyond 4GB. When kernel option iommu=pt, pass through is first tried. If pass through succeeds, IOMMU goes to pass through. If pass through is not supported in hw or fail for whatever reason, IOMMU goes to identity mapping.  

在iommu=pt的场景下，由于静态映射的存在所以直接返回paddr。

1. 如果这个设备不是pci设备且这个设备有RMRR，则返回False.
2. 如果这个设备是pci设备，则下面几种情况会返回False：
   1. 这个pci设备有rmrr
   2. iommu_identity_mapping 的值不是IDENTMAP_ALL
   3. 是pci设备但不是pcie设备，则如果设备不是 root bus 或者说pci设备的种类是pci bridge
   4. 是pcie设备且pcie 设备是pcie bridge


int domain_context_mapping_one(): 
1. 默认的dmar的转换类型为 translation = CONTEXT_TT_MULTI_LEVEL;
2. if (hw_pass_through && domain_type_is_si(domain)) => translation = CONTEXT_TT_PASS_THROUGH;

int si_domain_init(hw)

## 数据结构

```C
const struct iommu_ops intel_iommu_ops = {//caq:和arm_smmu_ops 并列的一个iommu_ops实例
	.capable = intel_iommu_capable,//caq:该iommu 硬件的能力
	.domain_alloc = intel_iommu_domain_alloc,//caq:分配 dmar_domain,并返回 iommu_domain
	.domain_free = intel_iommu_domain_free,//caq:释放 dmar_domain
	.attach_dev = intel_iommu_attach_device,//caq:将一个设备attach 到一个iommu_domain
	.detach_dev = intel_iommu_detach_device,//caq:将一个设备 从一个iommu_domain 进行detach 掉
	.map = intel_iommu_map,//caq:将iova 与phy addr 进行map
	.unmap = intel_iommu_unmap,//caq:解除某段iova的map
	.iova_to_phys = intel_iommu_iova_to_phys,//caq:获取iova map的phyaddr
	.add_device = intel_iommu_add_device,//caq:将一个 设备添加到 iommu_group中
	.remove_device = intel_iommu_remove_device,//caq:将一个 设备从iommu_group中 移除
	.get_resv_regions = intel_iommu_get_resv_regions,//caq:获取 某个设备的 保存内存区域
	.put_resv_regions = intel_iommu_put_resv_regions,//caq:从某个设备 的保留内存区域摘除
	.device_group = pci_device_group,//caq:获取一个dev的iommu_group
	.pgsize_bitmap = INTEL_IOMMU_PGSIZES,//caq:固定4k
};
```

root table：init_dmars分配intel_iommu中的root_entry(这个是VA),根据node信息分配到对应的内存中，大小为4K, 写入对应CPU的RTADDR_REG寄存器中(这个是PA)。

iommu_alloc_root_entry 对`intel_iommu`分配一个用作iommu root entry的page，存储在iommu->root_entry中, 这个HVA地址
iommu_set_root_entry 设置root table地址为iommu->root_entry的物理地址：设置DMAR_RTADDR_REG（Root Table Address Register），设置root table基地址，写DMAR_GCMD_REG的SRTP位进行设置。


## cache 管理
DMA Remapping转换过程中可能会有多种translation caches，在软件改变转换表时需要invalid相关old caches。vt-d中提供了两种invalid的方式：Register-based invalidation interface 和 Queued invalidation interface，如果需要支持irq remapping，则必须用后者，故我们分析后者（vt-d spec ch6.5.2）。

对于平台上的每个active的iommu，通过 intel_iommu_init_qi 对其进行初始化设置：
- 分配相关数据结构，其中包括了一个作为`Invalidation Queue`的page
- 将`DMAR_IQT_REG（Invalidation Queue Tail Register）`设置为0
- 设置`DMAR_IQA_REG（Invalidation Queue Address Register）`：IQ的地址和大小
- 设置`DMAR_GCMD_REG（Global Command Register）`使能QI功能
- 等待`DMAR_GSTS_REG（Global Status Register）`的QIES置位，表示使能成功
- 设置flush.flush_context和flush.flush_iotlb两个钩子

通过`intel_iommu_init_qi` 为每个iommu初始化`Invalidation Translation Caches`缓存失效 机制。目前有两种一种是Register-based invalidation interface，另外一种是Queued invalidation interface；如果支持queued invalidate就是用qi否则使用register based invalidate。

iommu->ecap标志中有queued invalidation support功能标志位，表示硬件是否支持。
iommu->qi, 有256个int，1个4K页面（HVA，保存虚拟地址），保存标志位状态，

SRTP: Hardware invalidates all DMA remapping hardware translation caches as part of SRTP flow.



## walk root tbl
 
root table address = virt_to_phys(iommu->root_entry)

所有的iommu单元应该共享root table和context table，只是不通的设备关联的iommu不同。在scource id为bdf时使用bdf进行查找root table， 使用pasid时需要查找context table。

Scale mode & support pasid => extend root table

iommu->root_entry 保存hva地址，4K页面，写入物理地址， flag(DMA_RTADDR_SMT) 到寄存器RTADDR_REG.


dmar_fault


dmar_set_interrupt

## 管理过程

struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus, u8 devfn, int alloc) // 根据BDF在iommu查找对应的context entry，没有也可以创建
void free_context_table(struct intel_iommu *iommu): // 删除iommu对用root_entry
int iommu_alloc_root_entry(struct intel_iommu *iommu):
void iommu_set_root_entry(struct intel_iommu *iommu): 写到寄存器里面 DMAR_RTADDR_REG   DMAR_GCMD_REG
iommu_flush_write_buffer(struct intel_iommu *iommu)：
int copy_context_table(struct intel_iommu *iommu,struct root_entry *old_re, struct context_entry **tbl, int bus, bool ext)
int copy_translation_tables(struct intel_iommu *iommu)


## iova

IOVA的真正分配是通过在SLAB中分配结构体[]，并在IOVA所在范围里找到一个对齐于2^n * 4K大小的范围, 并加入到IOVA的红黑树RB TREE中； IOVA的真正释放是将该IOVA从IOVA的红黑树RB TREE中取出，并释放对应的结构体。可以看到，既需要在红黑树中频繁的查找/添加/删除，又需要不断的进行SLAB分配和释放。为了提升性能，采用***RCACHE机制***进行IOVA的分配和释放。

RCACHE机制如下：在申请分配IOVA时，首先从RCACHE中查找对应的大小的IOVA，若存在，直接返回使用； 若不存在，才真正去分配IOVA，并将其放入RB TREE中； 在释放IOVA时，首先尝试在RCACHE中查找是否存在对应大小IOVA的空闲位置，若存在，将要释放的IOVA放于RCACHE中缓存，若不存在，才去真正释放，同时将IOVA从RB TREE中删除。

IOVA的范围由函数iommu_dma_init_domain()决定，可通过ACPI指定，但不能为0，默认在48BIT系统中为[1 2^48-1]。

## iova数据结构

iova_domain: 表示一个iova的地址空间，其中rb_root只想当前所使用的iova包括缓存的红黑树，rcaches结构体指向RCACJHE所支持的缓存大小，支持4K 8K 。。 128K。每个缓存大小又分为percpu的缓存和共享缓存，percpu缓存有两个loaded和prev，每个链表最多支持128个iovqa，共享缓存有32组，每组128个iova。


## IOVA管理


### 分配
1. 若果iova的大小超过128K，需要真正分撇iova，进入步骤3
2. 根据iova的大小找到怕对应的rcache节点，首先检查percpu中的loaded链表是否存在可用的iova缓存，有就返回使用。否则检查prev链表是否存在可用的iova缓存，若存在就返回使用，并交换loaded链表和prev链表。否则（loaded链和prev链都为空）检查depot是否存在空闲，若存在，将depot与loaded交换，并从中取空闲IOVA项，否则（loaded/prev/depot都为空）走步骤（3）真正分配IOVA;
3. 从SLAB中分配IOVA，在RB TREE中查找合适的位置，赋值给IOVA，并将其插入到RB TREE中；


intel_alloc_iova()函数: 这个函数申请一个IOVA。我们截取前文函数调用树中从intel_alloc_iova()开始的部分这个函数会调用alloc_iova()，并且最后落到kmem_cache_alloc()函数，分配一个struct iova结构体。kmem_cache_alloc()是从slab分配器申请结构体的入口函数。事实上，内核启动时，就通过iova_cache_get()函数，声明了struct iova结构体专用的slab分配器。

```C
intel_alloc_iova ->
	alloc_iova_fast ->
		iova_rcache_get
		alloc_iova ->
			alloc_iova_mem ->
				kmem_cache_zalloc ->
					kmem_cache_alloc ->
```

### 释放
1. 若需要释放的IOVA超过128K，需要真正释放IOVA，走步骤（3），否则走步骤（2）；
2. 根据IOVA的大小找到对应的RCACHE结点，首先检查percpu中loaded链是否已满，若未满则将其放对应的缓存中，否则检查percpu中的prev链是否已满，若未满则放到对应链中缓存中，否则（loaded和prev链已满）检查共享缓存depot是否已满，若未满则放到depot[]中，否则（loaded/prev/depot都满）分配新的iova magazine，将原来的loaded释放，将新的iova magazine赋给loaded，从loaded找到空闲位置放置缓存；
3. 在RB TREE中找到对应的IOVA，将其从RB TREE中删除，并释放IOVA；


### intel iommu分配

Intel IOMMU参与下的DMA Coherent Mapping（下文称为Intel IOMMU DMA Coherent Mapping）：
```C
intel_alloc_coherent ->
	/* if iommu_need_mapping(dev) returns false */
	dma_direct_alloc -> // 传统DMA Coherent Mapping流程,可以没有开启iommu
		dma_direct_alloc_pages ->
			__dma_direct_alloc_pages ->
				dma_alloc_from_contiguous ->
					cma_alloc
				alloc_pages_node ->
	/* if iommu_need_mapping(dev) returns true */
	dma_alloc_contiguous
	alloc_pages
		__intel_map_single ->
			deferred_attach_domain ->
				find_domain
			domain_get_iommu
			intel_alloc_iova ->
				alloc_iova_fast ->
					iova_rcache_get
					alloc_iova ->
						alloc_iova_mem ->
							kmem_cache_zalloc ->
								kmem_cache_alloc ->
						__alloc_and_insert_iova_range
			domain_pfn_mapping ->
				domain_mapping ->
					__domain_mapping ->
						pfn_to_dma_pte
						domain_flush_cache

```

iommu_need_mapping：判断设备是否需要进行Intel IOMMU映射
domain_pfn_mapping()函数: 它完成从IOVA到PA的映射



# Ref

https://blog.csdn.net/qq_34719392/article/details/117699839
