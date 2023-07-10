# 工作原理

# 工作过程

RTADDR_REG指向空间为基地址，然后利用Bus、Device、Func在Context Table中找到对应的Context Entry，即页表首地址，然后利用页表即可将设备请求的虚拟地址翻译成物理地址。


# Intel IOMMU 工作模式

intel vt-d iommu可以工作于legacy和scale模式。

legacy mode： `Root Table Address Register`指向root table，`translation Table Mode`是00b，root table和conext table是真正的物理地址。legacy mode采用Requests without address-space-identifier，DMA中带有bus/dev/function，bus查root table，dev和function查context table，context table结果指向second level pagetable，查pagetable得到最终的物理地址。

scale mode： `Root Table Address Register`指向root table，`translation Table Mode`是01b，root/context/PASID-directory/PASID-tables是真正的物理地址。scale mode同时支持Requests without address-space-identifier和Requests with address-space-identifier，如果没有PASID，那么就取context table中默认的RID_PASID。bus查root table，dev和function查context table，context table的结果指向PASID directory，PASID directory的结果指向PASID table，PASID table的结果同时包含first level pagetable, second level pagetable和PASID Granular Translation Type (PGTT)，PGTT中指明进行first level/second level/nested/passthrough translation。

# 数据结构

root table：init_dmars分配intel_iommu中的root_entry(这个是VA),根据node信息分配到对应的内存中，大小为4K, 写入对应CPU的RTADDR_REG寄存器中(这个是PA)。

## walk root tbl

root table address = virt_to_phys(iommu->root_entry)




## 管理过程

struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus, u8 devfn, int alloc) // 根据BDF在iommu查找对应的context entry，没有也可以创建