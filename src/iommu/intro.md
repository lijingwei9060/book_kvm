# 概念
物理特性
BAR
MMIO
终端

SRIOV
MDEV
VFIO

## DMA 框架内容

DMA讲内存地址PA映射到设备可以访问的IOVA，提供接口：
1. IOVA框架管理： IOVA的分配和释放， RCache缓存机制
2. IOMMU框架：DMA MAP和Unmap过程管理
3. 页表操作
4. 驱动框架：DMA 分配与释放，包括一致性DMA和流式DMA
5. ARM SMMU驱动： SMMU识别、外设识别


## 数据结构
STRTAB_BASE寄存器：指向STE表
ID0寄存器：

StreamTable(STE)，这ste 表既包含stage1的翻译表结构也包含stage2的翻译结构，所谓stage1负责VA 到 PA的转换，stage2负责IPA到PA的转换。

STE Entry：每个设备一个ste entry，设备的device id== stream id

smmu-v3：
- 第一层： Desc目录，8位，STRTAB_SPLIT，就是stream id的高8位
- 第二层： ste entry， stream id 的剩下位数

STE(Stream table entry) Entry：
- config
- s1contextptr
- vmid
- s2ttb
- 

## DMA Map：设备访问地址IOVA到PA的映射

建立
取消
缺页中断

RBTree

IOVA Address Space
Level 0 table
level 1 table
level 2 table 
level 3 table

TLB

TTBR