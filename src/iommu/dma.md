# DMA
DMA全称Direct Memory Access，CPU访问外设内存很慢，如果由CPU给外设大量搬运数据，CPU会大量空转等待搬运数据完成，所以发明出DMA engine，把搬运数据的任务由DMA engine来完成，CPU只要告诉DMA engine从什么地方开始搬运多大数据就行了，然后就可能干其它有意义的工作，DMA engine搬运完数据就打断CPU说搬运完了，接着搬运哪的数据手动多大。

CPU访问内存用virtual_address，然后通过MMU转换成physical_address，外设访问内存用的`bus_address`，由bus把`bus_address`定位到物理内存上，不同的bus可能处理方法还不一样。但在pci下，目前bus_address就是`phiscal_address`。DMA内存由CPU分配，CPU需要把virtual_address转换成bus_address，然后DMA engine进行DMA操作。DMA_ZONE表示DMA可使用的内存范围，现在x86_64下一般设备所有内存都可用，所以说DMA_ZONE和`bus_address`为了兼容而保留其实不用特殊考虑。

DMA内存分配和回收，CPU分配内存，设备做DMA操作，然后CPU回收内存，这些内存是等下次DMA继续用还是一次就回收用到的api也不一样。
cache一致性，由体系保证，如果体系不能保证则只能禁止CPU对做DMA的内存缓存了。
cache aligned，由提供内存者保证，不aligned一些外设可能搞不定。

## 内核态DMA驱动和DMA API
一般外设都自带DMA功能，DMA只是外设的数据传输通道，外设的功能各不一样，但DMA传输数据通道功能都一样，所以内核就有了DMA API，其它外设驱动只要调用内核DMA API就可以搞定DMA相关的功能了，内存映射/数据对齐/缓存一致性等都由内核DMA API搞定。


## Map过程

1. 分配需要映射的物理内存；
2. 根据RCACE缓存机制分配IOVA；
3. 根据TTBR及IOVA，建立页表项，建立IOVA与PA之间的映射；
4. 默认在SMMU硬件内部TLB中会缓存IOVA到PA的映射，设备访问对应IOVA时首先从TLB缓存中取，若失败，根据IOVA一级一级查找页表（内存），若没有找到，产生缺页中断；



## 用户态DMA驱动
外设通过DMA把数据放到内核，用户态再系统调用把数据手动到用户态，开销很大，所以想着外设直接把数据手动到用户态，可用户态用的都是虚拟地址，第一个问题就是得把虚拟地址转换成物理地址，用/proc/self/pagemap正好可以获取虚拟地址对应的物理地址。第二个问题是怎么保证虚拟地址对应的物理地址一定存在于内存中并且固定在内存中的同一个物理地址，虚拟地址一定有对应的物理地址好说，可以直接把page的ref加1，并且强行给page写个0数据，但虚拟地址固定对应到一个物理地址就难说了，假如进程给一个虚拟地址找了一个page让设备给这个page DMA写数据，同时kernel开始了page migration或者same page merge，把进程的虚拟地址对应的物理设置成其它page，但设备DMA写的page还是原来的page，这样导致进程访问的数据就不是设备定到内存中的数据，但这种概率很小啊。总之hugepage能满足大部分特性。



## 为什么直通设备会存在DMA访问的安全性问题呢？

在设备直通(Device Passthough)的虚拟化场景下，直通设备在工作的时候同样要使用DMA技术来访问虚拟机的主存以提升IO性能。那么问题来了，直接分配给某个特定的虚拟机的，我们必须要保证直通设备DMA的安全性，一个VM的直通设备不能通过DMA访问到其他VM的内存，同时也不能直接访问Host的内存，否则会造成极其严重的后果。因此，必须对直通设备进行“DMA隔离”和“DMA地址翻译”，隔离将直通设备的DMA访问限制在其所在VM的物理地址空间内保证不发生访问越界，地址翻译则保证了直通设备的DMA能够被正确重定向到虚拟机的物理地址空间内。

由于直通设备进行DMA操作的时候guest驱动直接使用gpa来访问内存的，这就导致如果不加以隔离和地址翻译必然会访问到其他VM的物理内存或者破坏Host内存，因此必须有一套机制能够将gpa转换为对应的hpa这样直通设备的DMA操作才能够顺利完成。

VT-d DMA Remapping的引入就是为了解决直通设备DMA隔离和DMA地址翻译的问题，下面我们将对其原理进行分析，主要参考资料是Intel VT-d SPEC Chapter 3。


## 数据结构

- struct dma_map_ops: 
  - map_page:  => intel_map_page
- dma_addr_t 

## 管理

dma_map_single_attrs(): 
- dma_map_direct() 是，调用dma_direct_map_page()
- 否： ops->map_page)_ --> iommu_dma_map_page()
dma_map_single()：一块物理连续内存进行映射
dma_map_page()：将一页物理内存进行映射
dma_map_page_attrs():
dma_direct_map_page():
- is_swiotlb_force_bounce() 是 swiotlb_map(dev,phys, size, dir)进行swiotlb映射
- 否： 
dma_map_sg(): 

### Intel IOMMU在DMA Coherent 

设备发起DMA Coherent Mapping申请`dma_alloc_coherent`， 请求分配DMA Buffer
- 获取设备或者平台提供的dma操作函数`get_dma_ops`, 传统的申请路程`dma_direct_alloc`，iommu申请流程`iommu_dma_alloc`
- Intel IOMMU是否已经启动，没有启动进入传统的DMA Coherent Mapping 流程，如果开启进入IOMMU的申请过程
  - 申请DMA buffer，地址为PA
  - 从slab中申请一个IOVA，在IO页表中建立从IOVA到PA映射的关系
  - 将IOVA作为DMA地址返回给设备
- 传统的DMA Coherent Mapping 流程：
  - 申请DMA Buffer，物理地址为PA，将PA作为DMA地址返回给设备。
  - 