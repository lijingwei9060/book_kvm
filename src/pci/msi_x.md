# 介绍

PCI/PCIe设备有3种中断通知方式，为INTx中断，MSI中断，MSI-X中断，其中INTx是可选的，MSI/MSI-X是必须实现的。
- 传统基于PIN的INTX，往往多个设备共享，延迟较高。每个function只能有一个pin的中断。PCI时期的产物，为了兼容PCI的INTA,INTB,INTC,INTD四个中断线而采用的一种中断机制。由于仅支持四个中断，且采用一个状态来控制，这种机制导致多中断场景软件处理复杂特别是有中断嵌套的场景，比较多的PCIe设备都没有支持该特性。
- MSI基于消息的中断通知模式，Message Signaled Interrupt。从pci2.2规范引入，设备之间不共享中断信号。通过PCI的事务保证中断发出后，确保数据已经写入到内存中。一个device最大支持32个中断号，要求连续。PCI设备通过写一个特定消息到特定地址，从而触发一个CPU中断，最大支持32个中断。
- MSI-x(Message Signaled Interrupt eXtended)，从pci3引入，支持设备2048个终端，

MSI如何保证中断消息和数据到达的一致性？(ARM)
1. HOST枚举到EP(Endpoint) PF设备，配置MSI-x table
2. EP设备通过读取vector table，获取到MSI-x中断对应的message address，构造一个TLP包，往message address地址里面写中断信息。
3. PCIE RC(Root complex)收到包判断是个TLP写后，将写操作转到总线，并返回ACK
4. GIC中的ITS检测到对应DDR有变化，则获取设备和中断信息后分发到经GIC分发到各个CPU核上。


一个设备想产生一个MSI中断话，只需要使用配置空间的message address寄存器和message data寄存器发起一个memory write请求，即往message address寄存器写入memory data。在X86系统下，message address对应的LAPIC的地址。查看lspci看到msi的地址就是/proc/iomem中local apic的地址映射。


在pcie的配置空间里面有msi capability(05)和msi-x的capability(11)，优先msi-x模式。msi支持32bit和64bit模式。


## MSI

msi capability分为32bit、64bit和带per-vector masking，最终有4种组合。
1. Message Control Register用于确定MSI的格式与支持的功能等信息，这个比较复杂，需要每一位进行解释。
   1. 0 (RW)： msi enable，0表示关闭，1表示启用
   2. 3:1(RO): multiple message capable， 中断向量支持的个数，1/2/4/8/16/32
   3. 6:4(RW): multiple message enable, 使用到的中断向量
   4. 7(RO): 是否支持64地址
   5. 8(RO): 是否支持per-vector maskig capable，0 不支持，1支持 
2. Message Address Register：32-bit最低两位固定为0，使得该地址是DW对齐的。分为32bit和64bit版本。
3. Message Data: 
4. Mask Bits: 将相关的中断向量（Interrupt Vector）屏蔽后，该MSI将不会被发送。软件可以通过这种方式来使能或者禁止某些MSI的发送。
5. pending bits： 如果相关中断向量没有被屏蔽，则如果发生了相关中断请求，这时Pending Bits中的相应bit则会被置位。一旦中断信息被发出，则该bit会立即被清零。

### 配置项
- CONFIG_PCI_MSI
- X86_UP_APIC 

### 使用MSI



1. pci设备驱动申请中断，会给一个device申请最多max_vec个中断号，最少min_vec个中断。int pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs, unsigned int max_vecs, unsigned int flags)。中断类型有PCI_IRQ_LEGACY, PCI_IRQ_MSI, PCI_IRQ_MSIX；PCI_IRQ_ALL_TYPES表示自动选择最合适的中断类型。PCI_IRQ_AFFINITY表示在申请中断向量的时候尽量分布到所有的CPU上。


## Config Space

## capability

msi的capability在config space中，msi-x的capability在bar中。


MSI-X ：中断能力 为 Enable 状态，支持 129 中断向量号
MSI-X Vector Table：位于 Bar3，起始地址或 offset 为 0
MSI-X PBA (pending table）：也位于Bar3，但起始地址为 0x00001000

### MSI

### MSIX


MSI-X Capability32bit长度为12个字节。
1. Capability ID(0-7)
2. Next Capability Pointer(8-15)
3. Message Control(16-31)
   1. Table Size in N-1(RO)(0-10): 向量表总数，存放Vector Table Size，最大0x7FF，最大11为也就是2^11也就是2048个中断号。
   2. Resv(11-13)
   3. Function Mask(RW)(14)： 全局vector mask
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

### MSI-X table初始化

1. PCIE 驱动，内核会调用pci_driver 注册的 probe 函数，而probe 函数会负责中断向量的申请：
- 调用 pci_msix_vec_count 获取当前PCIE 设备支持的中断向量总数
- 调用pci_enable_msix_range 分配 MSIX Table 中每一个中断向量 Entry，获得软件可以使用的所有中断向量号，即msix_entry 的 vector 成员。

```C
struct msix_entry {
	u32	vector;	/* Kernel uses to write allocated vector */
	u16	entry;	/* Driver uses to specify entry, OS writes */
};

// 获取PCIE 设备支持的中断向量总数，pdev 为probe传入的struct pci_dev *
int num_vectors = pci_msix_vec_count(pdev);

// num_vectors 为从MSIX Capability中获取到的 Table Size
// 根据PCIE 设备支持的中断向量总数，申请msix_entries 向量数组
struct msix_entry *msix_entries = kzalloc((sizeof(struct msix_entry) * num_vectors), GFP_KERNEL);

// entry 的编号由驱动程序自己维护，而 vector 是具体的中断向量号，被 request_irq 使用
for (i=0; i<num_vectors; i++) {
    msix_entries[i].entry = i;
}

// 返回申请成功的中断向量总数total_vecs ，pdev 为probe传入的struct pci_dev *，
// 2 为最小申请的中断向量数（少于2则返回-ENOSPC）,num_vectors为（最大）需要申请的向量总数
total_vecs = pci_enable_msix_range(pdev, msix_entries, 2, num_vectors);


probe
|--- pci_msix_vec_count 
|--- pci_enable_msix_range (__pci_enable_msix_range)
   |---__pci_enable_msix
      |--- msix_capability_init
         |--- pci_msi_setup_msi_irqs
            |--- arch_setup_msi_irqs
               // 调用硬件（如X86）相关的接口获得IRQ Domain信息，Domain负责将硬件中断ID映射到软件的IRQ Number（vector）
               |--- native_setup_msi_irqs 
                  |--- [ msi_domain_alloc_irqs ]

[ msi_domain_alloc_irqs ]
|--- irq_domain_activate_irq ( __irq_domain_activate_irq )
   |--- msi_domain_activate ( domain->ops->activate )
      |--- irq_chip_write_msi_msg 
         |--- pci_msi_domain_write_msg (data->chip->irq_write_msi_msg)
            |--- " __pci_write_msi_msg "


// 在函数 [ msi_domain_alloc_irqs ] 中循环每一个中断号，最终调用 __pci_write_msi_msg
int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
			  int nvec)
{
    int i, ret, virq;
    for_each_msi_entry(desc, dev) {
        virq = desc->irq;// 中断号  
	irq_data = irq_domain_get_irq_data(domain, desc->irq);
        ret = irq_domain_activate_irq(irq_data, can_reserve);
    }
}

// " __pci_write_msi_msg " 负责将每一个中断向量 Entry 写入 MSIX Table
void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
{
	struct pci_dev *dev = msi_desc_to_pci_dev(entry);

	if (dev->current_state != PCI_D0 || pci_dev_is_disconnected(dev)) {
		/* Don't touch the hardware now */
	} else if (entry->msi_attrib.is_msix) {
		void __iomem *base = pci_msix_desc_addr(entry);

                // 将message address 和 message data 写入 MSIX table
		writel(msg->address_lo, base + PCI_MSIX_ENTRY_LOWER_ADDR);
		writel(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
		writel(msg->data, base + PCI_MSIX_ENTRY_DATA);
	}
}
```

### MSIX Table访问

MSIX Table Entry 的访问，需要借助于pci_ioremap_bar（ioremap), 将PCIE 设备Bar空间对应的设备内存（即PCIE终端设备上的Register空间）映射到主机的__iomem 类型虚拟地址，才可以被驱动程序访问

```C
// 输入输入参数：struct pci_dev *pdev
void __iomem		*bar3;

// 将 iomem* 强制转换为 u32 *，则msi_tbl_addr 每次+1，就偏移 4 bytes
u32 *msi_tbl_addr = (u32*) bar3;
bar3 = pci_ioremap_bar(pdev, 3);

u32 one_table_entry_size = sizeof(u32) * 4;
u32 ** msi_table_entry  = kzalloc(one_table_entry_size  * num_vectors), GFP_KERNEL);

// 读取所有的 MSIX Table Entries 的方法
for (i = 0; i < num_vectors; ++i)
  for (j = 0; j < 4; ++j)
    msi_table_entry [i][j] = readl(msi_tbl_addr + i * 4 + j)


// 读出第一条 MSIX Table Entry 的方法
u32 first_msi_table_entry[4] = {0};
first_msi_table_entry[0] = readl(msi_tbl_addr);
first_msi_table_entry[1] = readl(msi_tbl_addr+1);
first_msi_table_entry[2] = readl(msi_tbl_addr+2);
first_msi_table_entry[3] = readl(msi_tbl_addr+3);
```




## REF

https://zhuanlan.zhihu.com/p/517861200