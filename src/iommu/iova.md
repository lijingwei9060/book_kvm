# intro

IOVA的真正分配是通过在SLAB中分配结构体[]，并在IOVA所在范围里找到一个对齐于2^n * 4K大小的范围, 并加入到IOVA的红黑树RB TREE中； IOVA的真正释放是将该IOVA从IOVA的红黑树RB TREE中取出，并释放对应的结构体。可以看到，既需要在红黑树中频繁的查找/添加/删除，又需要不断的进行SLAB分配和释放。为了提升性能，采用***RCACHE机制***进行IOVA的分配和释放。

RCACHE机制如下：在申请分配IOVA时，首先从RCACHE中查找对应的大小的IOVA，若存在，直接返回使用； 若不存在，才真正去分配IOVA，并将其放入RB TREE中； 在释放IOVA时，首先尝试在RCACHE中查找是否存在对应大小IOVA的空闲位置，若存在，将要释放的IOVA放于RCACHE中缓存，若不存在，才去真正释放，同时将IOVA从RB TREE中删除。

IOVA的范围由函数iommu_dma_init_domain()决定，可通过ACPI指定，但不能为0，默认在48BIT系统中为[1 2^48-1]。

## 数据结构

iova_domain: 表示一个iova的地址空间，其中rb_root只想当前所使用的iova包括缓存的红黑树，rcaches结构体指向RCACJHE所支持的缓存大小，支持4K 8K 。。 128K。每个缓存大小又分为percpu的缓存和共享缓存，percpu缓存有两个loaded和prev，每个链表最多支持128个iovqa，共享缓存有32组，每组128个iova。


## IOVA管理


### 分配
1. 若果iova的大小超过128K，需要真正分撇iova，进入步骤3
2. 根据iova的大小找到怕对应的rcache节点，首先检查percpu中的loaded链表是否存在可用的iova缓存，有就返回使用。否则检查prev链表是否存在可用的iova缓存，若存在就返回使用，并交换loaded链表和prev链表。否则（loaded链和prev链都为空）检查depot是否存在空闲，若存在，将depot与loaded交换，并从中取空闲IOVA项，否则（loaded/prev/depot都为空）走步骤（3）真正分配IOVA;
3. 从SLAB中分配IOVA，在RB TREE中查找合适的位置，赋值给IOVA，并将其插入到RB TREE中；

### 释放
1. 若需要释放的IOVA超过128K，需要真正释放IOVA，走步骤（3），否则走步骤（2）；
2. 根据IOVA的大小找到对应的RCACHE结点，首先检查percpu中loaded链是否已满，若未满则将其放对应的缓存中，否则检查percpu中的prev链是否已满，若未满则放到对应链中缓存中，否则（loaded和prev链已满）检查共享缓存depot是否已满，若未满则放到depot[]中，否则（loaded/prev/depot都满）分配新的iova magazine，将原来的loaded释放，将新的iova magazine赋给loaded，从loaded找到空闲位置放置缓存；
3. 在RB TREE中找到对应的IOVA，将其从RB TREE中删除，并释放IOVA；
