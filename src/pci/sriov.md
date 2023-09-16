# 概念

sr-iov: singole root io virtualization

PF: physical function, 支持sr-iov功能，包含sr-iov 功能配置结构体，用于管理sr-iov功能，具备全功能的pcie功能，可以进行pcie发现、管理和处理。
VF
BAR： vf的bar空间是pf的bar空间资源中规划的一部分，vf不支持io空间，所以vf的bar空间也需要映射到系统内存。
ATC: 

PF的PCIe扩展配置空间 SR-IOV Extended Capability支持对SR-IOV功能进行配置
1. 其中SR-IOV Control 字段的bit0位是SR-IOV的使能位，默认为0，表示关闭，如果需要开启SR-IOV功能，需要配置为1。
2. TotalVFs字段表示PCIe Device支持VF的数量。
3. NumVFs字段表示开启VF的数量，此值不应超过PCIe Device支持的VF的数量TotalVFs的值。
4. First VF Offset字段表示第一个各VF相对PF的Routing ID（即Bus number、Device number、Function number）的偏移量。
5. VF Stride字段表示相邻两个VF的Routing ID的偏移量。


写这篇文章之前，正好看到Red Hat 发布了 Red Hat Virtualization V4版，官方文档中，专门有一篇《Hardware considerations for implementing SR-IOV with Red Hat Virtualization》。
主要介绍Red Hat Virtualization 中使用SR-IOV的前提条件：

1. CPU 必须支持IOMMU(input/output memory management unit 输入输出内存管理单元)（比如英特尔的 VT-d 或者AMD的 AMD-Vi，Power8 处理器默认支持IOMMU）
2. 固件Firmware 必须支持IOMMU
3. CPU 根桥必须支持 ACS 或者ACS等价特性
4. PCIe 设备必须支持ACS 或者ACS等价特性
5. 建议根桥和PCIe 设备中间的所有PCIe 交换设备都支持ACS，如果某个PCIe交换设备不支持ACS，其后的所有PCIe设备只能共享某个IOMMU 组，所以只能分配给1台虚机。


## 功能设计

iommu dram
vfio-pci 
vfio_iommu_type1_driver
vfio vfio-pci