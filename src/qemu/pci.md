# Root Complex上的设备

1. PCI 设备（例如网卡、显卡、IDE 控制器），而不是控制器。仅将传统PCI 设备放在 Root Complex 上。这些将被视为集成端点(Root Complex Integrated Endpoint )。注意：集成端点不可热插拔。尽管 PCI Express 规范不禁止 PCI Express 设备作为集成端点，但现有硬件大多将传统 PCI 设备与 Root Complex 集成。当 PCI Express 设备与 Root Complex 集成时，Guest OS 可能会表现异常。 配置： `-device <dev>[,bus=pcie.0]`
2. PCI Express 根端口 (ioh3420)，用于专门启动 PCI Express 层次结构。
3. PCI Express to PCI Bridge (pcie-pci-bridge)，用于启动传统 PCI 层次结构。
4. Extra Root Complexes (pxb-pcie)，如果需要多个 PCI Express 根总线。

要引入新的 PCI Express 根总线: 
-device pxb-pcie,id=pcie.1,bus_nr=x[,numa_node=y][,addr=z]

PCI Express 根端口和 PCI Express 到 PCI 桥可以连接到 pcie.1 总线：

-device ioh3420,id=root_port1[,bus=pcie.1][,chassis=x][,slot=y][,addr=z]
-device pcie-pci-bridge,id=pcie_pci_bridge1,bus=pcie.1

PCI Express Switch（x3130-upstream，xio3130-downstream）如果没有更多空间用于 PCI Express 根端口


/proc/ioports
/proc/interrupts
/proc/iomem
/proc/irq