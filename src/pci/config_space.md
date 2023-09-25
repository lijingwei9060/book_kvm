# 介绍

规范
作用
内容



## pci-bridge config space

## pci-ep config space

## pcie-ep config space

BAR0
BAR1
BAR2
BAR3
BAR4
BAR5

MSI-X Capability32bit长度为12个字节。
1. Capability ID(0-7)
2. Next Capability Pointer(8-15)
3. Message Control(16-31)
   1. Table Size in N-1(RO)(0-10): 向量表总数，存放Vector Table Size，最大0x7FF，最大11为也就是2^11也就是2048个中断号。
   2. Resv(11-13)
   3. Function Mask(RW)(14)
   4. MSI-X enable(RW)(15)
4. Table BIR（BAR Index Register）(RO)(0-2)
5. MSI-X Table Offset(RO)(3-31): MSI-X将MSI的Message Data和Message Address放到了一个表(MSIX-Table)中, table Offset说明MSIX-Table在该BAR中的offset。
6. PBA BIR(RO)(0-2)
7. Pending Bit Array(PBA) offset(RO)(3-31)： BA BIR和PBA offset分别说明MSIX-PBA在哪个BAR中，在BAR中的什么位置。

MSI-X Table: 中存放着所有PCIE 设备的中断向量号, 每个Entry 代表一个中断向量16个字节，Msg Data 中包括了中断向量号，Msg Addr 中通常包含了多核CPU用于处理 中断的 Local APIC 编号。访问第N个Entry地址为： n_entry_address = base adress[BAR] + 16 *n。

Entry = struct msi_msg(lower address + upper address + data) + ctl flag

msi_msg - Representation of a MSI message
1. address_lo:		Low 32 bits of msi message address
2. address_hi:		High 32 bits of msi message address
3. data:		MSI message data (usually 16 bits)


## 如何管理


1. pci_read_config_word 来读取PCIE EP（end point）设备的配置空间信息。