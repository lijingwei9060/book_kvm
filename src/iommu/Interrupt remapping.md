# 硬件工作过程

interrupt remapping of iommu的引入主要是为了解决虚拟化场景直通设备的中断投递问题，由于iommu的最重要的功能是dma处理，因此在interrupt remapping enable的情况下，系统当中所有以message signal 的形式来触发的中断都是需要iommu来处理的。或者有人会问为什么是message singal interrupt(msi 或者msix)呢？因为所有的msi中断最底层的实现方式是往特定的地址(0xFEEX_XXXXh)触发一个dma write操作，iommu也是通过0xFEE 这个prefix来判断某个dma write 是否是一个中断请求。引入了iommu之后，系统当中pcie或者pci设备，ioapic，hpet(有些平台hpet是支持msi中断的)等这些设备的msi or msix中断请求都会经过iommu进行处理。


## 传统的中断

首先介绍一下ioapic，ioapic在系统硬件架构当中所处的位置：

CPU物理核有Local APIC，CPU Core之间通过Processor System Bus 互联，收到外部Interrupt Messages以及IPIs。
通过PCI总线(北桥？）连接IO APIC。

操作系统是通过acpi表来发现ioapic的，当然有些平台也已经支持通过pcie协议来发现ioapic，其他外设比如大部分的legacy设备的中断都是需要通过ioapic进行路由，那么不同设备的中断是如何通过ioapic投递的呢？原来ioapic维护了一个redirection table，当某个设备中断到达ioapic时，它会根据Redirection Table格式化出一个message signal interrupt 发往相应的cpu。



## 终端重映射

interrupt remapping enable场景下，ioapic的redirection table entry格式：
- bits 49:63 对应的是interrupt_index[14:0]，bit 11对应的是interrup_index[15] 即第15位，关于这个16bits的interrupt_index后面会详细说明
- bit 48表示是否为remapping的中断格式，所以必须要置1
- bits 10:8 表示SHV(SubHandle Valid)，强制设置为000b表示SHV不可用。关于SHV后面也会讲到 至于其他两种模式都有的字段比如vector, Trigger Mode, delivery status等需要对齐。


对照图6还是总结一下在remapping模式下的不同点：

address register bit 4需要置为1，表示为interrupt remapping模式。
adress register bit 3 表示的是SubHandle Valid(SHV)，这里强制为1即SubHandle是有效的。
address register bits 19:5 表示的是interrupt_index的0~14位，bit 2表示的是interrupt_index的第15位。这里的interrup_index指的是Interrupt Remapping Table Entry(IRTE) 它里面存储的是interrupt 请求的具体内容。通常情况下pci或者pcie设备一般都会使能多个这里以N来代替中断vector，也就意味着我们要为这个N 个vector分配N个连续的IRTE enteries。这里的interrup_index指的是第一个 IRTE entry，因为SHV是enable的所以后面的N-1个连续的IRTE entries是通过base的interrupt_index加上这个subhandle来寻址的。
第一个 IRTE entry的data register 全部设置为0，后N-1的IRTE的data register bits 15:0 设置为subhandle。
上面讲了IRTE，讲了SHV，讲了interrupt_index，讲了subhandle，这些概念之间有什么关联？iommu硬件又是怎么使用这些信息的呢？要回答好这些问题我们还是要从最底层来看，先来看一下在interrupt remapping模式下以iommu视角看到的message signal interrupt request是什么样子的？




## Reference

https://zhuanlan.zhihu.com/p/479988393
https://www.eet-china.com/mp/a118067.html