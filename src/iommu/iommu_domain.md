# intro

domain这个词是从intel的VT-d文档中继承下来的，其他平台有各自的叫法，比如ARM下叫context。一个domain应该是指一个独立的iommu映射上下文。处于同一个domain中的设备使用同一套映射做地址转换（对于mmio来说就是独立的页表）。

## 数据结构

- struct iommu_domain： 表示一个domain，有4中domain类型，blocked，identity，unmanaged，dma
  - IOMMU_DOMAIN_BLOCKED	- All DMA is blocked, can be used to isolate  devices
  - IOMMU_DOMAIN_IDENTITY	- DMA addresses are system physical addresses
  - IOMMU_DOMAIN_UNMANAGED	- DMA mappings managed by IOMMU-API user, used  for VMs
  - IOMMU_DOMAIN_DMA	- Internally used for DMA-API implementations.  This flag allows IOMMU drivers to implement certain optimizations for these domain
- struct device_domain_info： 设备和domain关联信息
- struct dmar_domain: domain对应的dmar信息，比如pgd信息等。这个结构包含iommu_domain结构。
调用`domain_alloc`分配一个domain。


## API
int iommu_attach_device(struct iommu_domain *domain, struct device *dev) ： 将一个设备添加到domain中，具体的是将dev关联的group关联domain。
1. 如果所在的group有过个dev，操作会失败。
2. 内部具体使用的是iommu_ops.attach_dev()函数，如果已经attach到其他的domain中，会失败。
3. 计算agaw
4. 重新设置dmar_domain.pgd
5. 设置dmar_domain和intel_iommu的关联关系，占位iommu->domain_ids, 

dmar_domain->force_snooping ?
ecap_sc_support(iommu->ecap) ?


request without pasid: source id 是bdf，找到domain
Root-table Address
context-table

request with pasid， 请求单地址类型为GVA，需要进行GVA -> GPA -> HPA, 需要extended-root-table，地址保留在Root table address register， bit11 = 1表示extend-root-table： 
    upper—context-table 指向pasid转换表
    lower-context-table 指向second level translation和request without pasid相同