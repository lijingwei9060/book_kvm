# 介绍

PCI/PCIe设备有3种中断通知方式：
- 传统基于PIN的INTX，往往多个设备共享，延迟较高。每个function智能有一个pin的中断。
- MSI基于消息的中断通知模式，Message Signaled Interrupt。从pci2.2规范引入，设备之间不共享中断信号。通过PCI的事务保证中断发出后，确保数据已经写入到内存中。一个device最大支持32个中断号，要求连续。
- MSI-x，从pci3引入，支持设备2048个终端，

## MSI


### 配置项
- CONFIG_PCI_MSI
- X86_UP_APIC 

### 使用MSI

1. pci设备驱动申请中断，会给一个device申请最多max_vec个中断号，最少min_vec个中断。int pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs, unsigned int max_vecs, unsigned int flags)。中断类型有PCI_IRQ_LEGACY, PCI_IRQ_MSI, PCI_IRQ_MSIX；PCI_IRQ_ALL_TYPES表示自动选择最合适的中断类型。PCI_IRQ_AFFINITY表示在申请中断向量的时候尽量分布到所有的CPU上。