# MSI/MSI-X中断
MSI(Message Signaled Interrupts)中断的目的是绕过IOAPIC，使中断能够直接从设备到达LAPIC，达到降低延时的目的。从MSI的名字可以看出，MSI不基于管脚而是基于消息。MSI由PCI2.2引入，当时是PCI设备的一个可选特性，到了2004年，PCIE SPEC发布，MSI成了PCIE设备强制要求的特性，在PCI3.3时，又对MSI进行了一定的增强，称为MSI-X，相比于MSI，MSI-X的每个设备可以支持更多的中断，且每个中断可以独立配置。

除了减少中断延迟外，因为不存在管脚的概念了，所以之前因为管脚有限而共享管脚的问题自然就消失了，之前当某个管脚有信号时，操作系统需要逐个调用共享这个管脚的中断服务程序去试探，是否可以处理这个中断，直到某个中断服务程序可以正确处理，同样，不再受管脚数量的约束，MSI能够支持的中断数也显著变多了。

## msi
支持MSI的设备绕过IOAPIC，直接通过系统总线与LAPIC相连。

从PCI2.1开始，如果设备需要扩展某种特性，可以向配置空间中的Capabilities List中增加一个Capability，MSI利用该特性，将IOAPIC中的功能扩展到设备本身了。

 MSI Capability Structure.
- Next Pointer、Capability ID这两个field是PCI的任何Capability都具有的field，分别表示下一个Capability在配置空间的位置、以及当前Capability的ID。
- Message Address和Message Data是MSI的关键，只要将Message Data中的内容写入到Message Address中，就会产生一个MSI中断。
- Message Control用于系统软件对MSI的控制，如enable MSI、使能64bit地址等。
- Mask Bits用于在CPU处理某中断时可以屏蔽其它同样的中断。类似PIC中的IMR。
- Pending Bits用于指示当前正在等待的MSI中断，类似于PIC中的IRR.

## MSI-X

为了支持多个中断，MSI-X的Capability Structure做出了变化，如Figure6-12所示:

Capability ID, Next Pointer, Message Control这3个field依然具有原来的功能。

MSI-X将MSI的Message Data和Message Address放到了一个表(MSIX-Table)中，Pending Bits也被放到了一个表（MSIX-Pending Bit Array）中。

MSI-X的Capability Structure中的Table BIR说明MSIX-Table在哪个BAR中，Table Offset说明MSIX-Table在该BAR中的offset。类似的，PBA BIR和PBA offset分别说明MSIX-PBA在哪个BAR中，在BAR中的什么位置。

BIR : BAR Indicator Register

msi-x capability struct
msi-x table struct
msi-x pba structure

## MSI/MSIX中断流程(以VFIO设备为例)

在QEMU中初始化虚拟设备(VFIO)时，会对MSI/MSIX做最初的初始化。其根据都是对MSI/MSIX Capability Structure的创建，以及对对应memory的映射。
```C
static void vfio_realize(PCIDevice *pdev, Error **errp)
{
    ...
        vfio_msix_early_setup(vdev, &err);
    ...
        ret = vfio_add_capabilities(vdev, errp);
    ...
}
```   
提前说明，具体的MSI/MSIX初始化是在vfio_add_capabilities中完成的，那为什么要进行vfio_msix_early_setup呢？
```c
/*
 * We don't have any control over how pci_add_capability() inserts
 * capabilities into the chain.  In order to setup MSI-X we need a
 * MemoryRegion for the BAR.  In order to setup the BAR and not
 * attempt to mmap the MSI-X table area, which VFIO won't allow, we
 * need to first look for where the MSI-X table lives.  So we
 * unfortunately split MSI-X setup across two functions.
 */
static void vfio_msix_early_setup(VFIOPCIDevice *vdev, Error **errp)
{
    if (pread(fd, &ctrl, sizeof(ctrl),
              vdev->config_offset + pos + PCI_MSIX_FLAGS) != sizeof(ctrl)) {
        error_setg_errno(errp, errno, "failed to read PCI MSIX FLAGS");
        return;
    } // 读取MSIX Capability Structure中的Message Control到ctrl

    if (pread(fd, &table, sizeof(table),
              vdev->config_offset + pos + PCI_MSIX_TABLE) != sizeof(table)) {
        error_setg_errno(errp, errno, "failed to read PCI MSIX TABLE");
        return;
    } // 读取MSIX Capability Structure中的Table Offset + Table BIR到table

    if (pread(fd, &pba, sizeof(pba),
              vdev->config_offset + pos + PCI_MSIX_PBA) != sizeof(pba)) {
        error_setg_errno(errp, errno, "failed to read PCI MSIX PBA");
        return;
    } // 读取MSIX Capability Structure中的PBA Offset + PBA BIR到pba

    ctrl = le16_to_cpu(ctrl);
    table = le32_to_cpu(table);
    pba = le32_to_cpu(pba);

    msix = g_malloc0(sizeof(*msix));
    msix->table_bar = table & PCI_MSIX_FLAGS_BIRMASK;
    msix->table_offset = table & ~PCI_MSIX_FLAGS_BIRMASK;
    msix->pba_bar = pba & PCI_MSIX_FLAGS_BIRMASK;
    msix->pba_offset = pba & ~PCI_MSIX_FLAGS_BIRMASK;
    msix->entries = (ctrl & PCI_MSIX_FLAGS_QSIZE) + 1; // table中的entry数量

    /* 如果VFIO同意映射Table所在的整个BAR，就可以在之后直接mmap.
     * 如果VFIO不同意映射Table所在的整个BAR，就只对Table进行mmap.
     */
    vfio_pci_fixup_msix_region(vdev);

    ...
}
```
注释中写的很清楚，因为之后的pci_add_capability()中对MSIX进行如何配置是未知的，也许会配置MSIX Capability，也许不会，但是如果想要配置MSIX，就要给MSIX对应的BAR一个MemoryRegion，VFIO不同意将MSIX Table所在的BAR映射到Guest，因为这将会导致安全问题，所以我们得提前找到MSIX Table所在的BAR，由于该原因，MSIX的建立分成了2部分。

vfio_msix_early_setup()找到了MSIX-Table所在的BAR、MSIX的相关信息，然后记录到了vdev->msix中。并对MSIX Table的mmap做了预处理。
```c
static int vfio_add_capabilities(VFIOPCIDevice *vdev, Error **errp)
{
    ...
        ret = vfio_add_std_cap(vdev, pdev->config[PCI_CAPABILITY_LIST], errp);
    ...
}

// vfio_add_std_cap本身是一个递归算法，通过`next`不断追溯下一个capability，从最后一个capability开始add并回溯。
// 这里只给出vfio_add_std_cap()的核心添加capability的机制。
static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
{
    ...
        switch (cap_id) {
                ...
                    case PCI_CAP_ID_MSI:
                        ret = vfio_msi_setup(vdev, pos, errp);
                        break;
                ...
                    case PCI_CAP_ID_MSIX:
                        ret = vfio_msix_setup(vdev, pos, errp);
                        break;
                    
        }
    ...
}
```
到了这里分了两个部分，一个是MSI的初始化，一个是MSIX的初始化。分别来看。

## MSI初始化
```c
static int vfio_msi_setup(VFIOPCIDevice *vdev, int pos, Error **errp)
{
    // 读取MSIX Capability Structure中的Message Control Field到ctrl
    if (pread(vdev->vbasedev.fd, &ctrl, sizeof(ctrl),
              vdev->config_offset + pos + PCI_CAP_FLAGS) != sizeof(ctrl)) {
        error_setg_errno(errp, errno, "failed reading MSI PCI_CAP_FLAGS");
        return -errno;
    }
    ctrl = le16_to_cpu(ctrl);

    msi_64bit = !!(ctrl & PCI_MSI_FLAGS_64BIT); // 确定是否支持64bit消息地址
    msi_maskbit = !!(ctrl & PCI_MSI_FLAGS_MASKBIT); // 确定是否支持单Vector屏蔽
    entries = 1 << ((ctrl & PCI_MSI_FLAGS_QMASK) >> 1); // 确定中断vector的数量
    
    ...
    
    // 向vdev->pdev添加的MSI Capability Structure，设置软件维护的配置空间信息
    ret = msi_init(&vdev->pdev, pos, entries, msi_64bit, msi_maskbit, &err);
    ...
}
```
经过msi_init()之后，一个完整的MSI Capability Structure就已经呈现在了vdev->pdev.config + capability_list + msi_offset的位置。当然这个结构是QEMU根据实际物理设备而模拟出来的，实际物理设备中的Capability Structure没有任何变化。

## MSIX初始化

static int vfio_msix_setup(VFIOPCIDevice *vdev, int pos, Error **errp)
{
    ...
        // 因为MSIX的相关信息都已经在vfio_msix_early_setup中获得了，这里只需要用这些信息直接
        // 对MSIX进行初始化
        ret = msix_init(&vdev->pdev, vdev->msix->entries,
                        vdev->bars[vdev->msix->table_bar].mr,
                        vdev->msix->table_bar, vdev->msix->table_offset,
                        vdev->bars[vdev->msix->pba_bar].mr,
                        vdev->msix->pba_bar, vdev->msix->pba_offset, pos,
                        &err);
    ...
}

在msix_init()中，除了向vdev->pdev添加MSIX Capability Structure及MSIX Table和MSIX PBA，还将msix table和PBA table都作为mmio注册到pdev上。mmio操作的回调函数分别为:msix_table_mmio_ops,msix_pba_mmio_ops.

## 建立IRQ Routing entry

之前我们看到在KVM中建立了一个统一的数据结构，即IRQ Routing Entry，能够针对来自IOAPIC，PIC或类型为MSI的中断。对于每个中断，在Routing Table中都应该有1个entry，中断发生时，KVM会根据entry中的信息，调用具体的中断函数。

那么这个entry是如何传递到KVM中去的呢？在APIC虚拟化一节我们知道可以使用IOCTL(KVM_SET_GSI_ROUTING)传入中断路由表。

一般情况下，对于IRQ Routing Entry的建立和传入KVM应该是在设备(中断模块)初始化时就完成的，但是QEMU为了效率采用的Lazy Mode，即只有在真正使用MSI/MSIX中断时，才进行IRQ Routing Entry的建立。

static void vfio_pci_dev_class_init(ObjectClass *klass, void *data)
{
    DeviceClass *dc = DEVICE_CLASS(klass);
    PCIDeviceClass *pdc = PCI_DEVICE_CLASS(klass);

    dc->reset = vfio_pci_reset;
    device_class_set_props(dc, vfio_pci_dev_properties);
    dc->desc = "VFIO-based PCI device assignment";
    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
    pdc->realize = vfio_realize;
    pdc->exit = vfio_exitfn;
    pdc->config_read = vfio_pci_read_config;
    pdc->config_write = vfio_pci_write_config;
}

static void vfio_pci_write_config(PCIDevice *pdev, uint32_t addr,
                                  uint32_t val, int len)
{
    /* MSI/MSI-X Enabling/Disabling */
    if (pdev->cap_present & QEMU_PCI_CAP_MSI &&
        ranges_overlap(addr, len, pdev->msi_cap, vdev->msi_cap_size)) {
        int is_enabled, was_enabled = msi_enabled(pdev);

        ...
            pci_default_write_config(pdev, addr, val, len);
        // MSI
        is_enabled = msi_enabled(pdev);

        if (!was_enabled && is_enabled) {
            vfio_enable_msi(vdev);
        } 
        ...
        // MSIX
        is_enabled = msix_enabled(pdev);
        if (!was_enabled && is_enabled) {
            vfio_msix_enable(vdev);
        }
        ...
}


static void vfio_enable_msix(VFIODevice *vdev)
{
    ...
        if (msix_set_vector_notifiers(&vdev->pdev, vfio_msix_vector_use,
                                      vfio_msix_vector_release)) {
            error_report("vfio: msix_set_vector_notifiers failed\n");
        }
    ...
}
vfio_pci_dev_class_init()将vfio_pci_write_config注册为vfio设备的写配置空间的callback，当Guest对vfio设备的配置空间进行写入时，就会触发:

vfio_pci_write_config()
=> vfio_enable_msi(vdev)-------|// 如果配置空间中的MSI/MSIX Capability Structure有效
=> vfio_msix_enable(vdev)------|
    
static void vfio_msi_enable(VFIOPCIDevice *vdev)
{
    ... 
    vfio_add_kvm_msi_virq(vdev, vector, i, false);
    ...
}
static void vfio_add_kvm_msi_virq(VFIOPCIDevice *vdev, VFIOMSIVector *vector,
                                  int vector_n, bool msix)
{
     virq = kvm_irqchip_add_msi_route(kvm_state, vector_n, &vdev->pdev);
}

int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
{
    kroute.gsi = virq;
    kroute.type = KVM_IRQ_ROUTING_MSI;
    kroute.flags = 0;
    kroute.u.msi.address_lo = (uint32_t)msg.address;
    kroute.u.msi.address_hi = msg.address >> 32;
    kroute.u.msi.data = le32_to_cpu(msg.data);
    ...
    kvm_add_routing_entry(s, &kroute);
    kvm_arch_add_msi_route_post(&kroute, vector, dev);
    kvm_irqchip_commit_routes(s);

}
void kvm_irqchip_commit_routes(KVMState *s)
{

    ret = kvm_vm_ioctl(s, KVM_SET_GSI_ROUTING, s->irq_routes);
}
在vfio_enable_msi()中，通过层层调用最终调用了IOCTL(KVM_SET_GSI_ROUTING)将Routing Entry传入了KVM，vfio_msix_enable()的调用过程稍微复杂以下，这里没有贴出代码，但最终也是调用了IOCTL(KVM_SET_GSI_ROUTING)将Routing Entry传入了KVM。

## 中断流程

当KVM收到外设发送的中断时，就会调用该中断GSI对应的Routing Entry对应的.set方法，对于MSI/MSIX，其方法为kvm_set_msi，该方法的大致流程是，首先从MSIX Capability提取信息，找到目标CPU，然后针对每个目标调用kvm_apic_set_irq()向Guest注入中断。