# intro

Intel VT-d 虚拟化方案主要目的是解决IO虚拟化中的安全和性能这两个问题，这其中最为核心的技术就是DMA Remapping和Interrupt Remapping。 DMA Remapping通过IOMMU页表方式将直通设备对内存的访问限制到特定的domain中，在提高IO性能的同时完成了直通设备的隔离，保证了直通设备DMA的安全性。Interrupt Remapping则提供IO设备的中断重映射和路由功能，来达到中断隔离和中断迁移的目的，提升了虚拟化环境下直通设备的中断处理效率。

使用iommu，可以改变虚拟机外设中断的投递方式。以msi中断为例，msi msg里不再需要填写相关的中断信息，而是转换成`interrput index`的方式。中断的管理信息（投递方式、目标cpu信息、vector信息）存放在一个叫irte的内存区域里，每个iommu最多可以有64k个irte，iommu通过`interrupt index`找到对应的irte，iommu的irte基址信息存放在iommu的`IRTA（Interrupt Remapping Table Address）`寄存器里。






## IRTE

### Redirection Table Entry


ioapic维护了一个redirection table，当某个设备中断到达ioapic时，它会根据Redirection Table格式化出一个message signal interrupt 发往相应的cpu。

在没有使能Interrupt Remapping的情况下，设备中断请求格式称之为`Compatibility format`，其结构主要包含一个32bit的Address和一个32bit的Data字段，Address字段包含了中断要投递的目标CPU的APIC ID信息，Data字段主要包含了要投递的vecotr号和投递方式。在开启了Interrupt Remapping之后，设备的中断请求格式称之为`Remapping format`，其结构同样由一个32bit的Address和一个32bit的Data字段构成。但与`Compatibility format`不同的是此时Adress字段不再包含目标CPU的APIC ID信息而是提供了一个16bit的HANDLE索引，并且Address的bit 4为"1"表示Request为`Remapping format`。同时bit 3是一个标识位(SHV)，用来标志Request是否包含了SubHandle，当该位置位时表示Data字段的低16bit为SubHandle索引。


中断请求的格式有两种（Compatibility Format和Remappable Format），在Compatibility Format格式下，address需要包含中断的Destination ID信息，Data需要包含中断的delivery Mode、Trigger Mode等信息，并且bit 4的interrupt Format需要清0。而在Remappable Format模式下，addess主要保存的是Handle信息，并且bit 4置1，data保存subhandle信息，iommu通过Handle及subhandle找到对应的irte。

Redirection Table Entry(64bits):
- 56-63: destination
- 48-55: extensted destination
- 17-48: reserved
- 16: mask
- 15: E/L: 触发模式，edge边缘触发还是level水平触发
- 14: RIRR： Remote IRR（水平触发），0 ： reset when eoi received from local apic；1：set when local-apics accept level-interrupt sent by io-apic; 
- 13: H/L
- 12: status
- 11: L/P
- 8-10: delivery mode: Fixed(000) Lowest Priority(001) SMI(010) NMI(100) INIT(101) ExtInt(111)
- 0-7: interrupt vector  

address的bit 4为Interrupt Format位，用来标志这个Request是Compatibility format（bit4=0）还是Remapping format (bit 4=1)。




在Interrupt Remapping模式下，硬件查询系统软件在内存中预设的中断重映射表(Interrupt Remapping Table)来投递中断。中断重映射表由中断重映射表项(Interrupt Remapping Table Entry)构成，每个IRTE占用128bit（具体格式介绍见文末），中断重映射表的基地址存放在Interrupt Remapping Table Address Register中。Remappable Format时，不同的中断号可以共享同一个handle（最终对应同一个irte），比如同一个网卡设备的多个队列中断；也可设置每个中断使用独立的irte，这通过address的bit 3（SHV）位来标识（默认置1，使用共享模式）。iommu根据SHV以及handle值来查找interrupte_index。硬件通过下面的方式去计算中断的interrupt_index：

```C
if (address.SHV == 0) { // 独享中断号
    interrupt_index = address.handle;
} else {  // 共享中断号
    interrupt_index = (address.handle + data.subhandle);
}
```
中断重映射硬件通过interrupt_index去重映射表中索引对应的IRTE，中断重映射硬件可以缓存那些经常使用的IRTE以提升性能。(注:由于handle为16bit，故每个IRT包含65536个IRTE，占用1MB内存空间)

## 外设的中断投递方式和中断处理
针对不同的中断源，需要采用不同的方式来投递Remapping格式的中断。

对I/OxAPIC而言，其Remapping格式中断投递格式如下图，软件需要按图中的格式来发起Remapping中断请求，这就要求需要修改“中断重定向表项”(Interrupt Redirection Table Entry)，读者可以参考wiki对比下RTE相比于Compatibility格式有哪些不同。值得注意的是bit48这里需要设置为"1"用来标志此RTE为Remapping format，并且RTE的bit10:8固定为000b(即没有SubHandle)。而且vector字段必须和IRTE的vector字段相同！



对于MSI和MSI-X而言，其Remapping格式中断投递格式如下图，值得注意的是在Remapping格式下MSI中断支持multiple vector（大于32个中断向量），但软件必须连续分配N个连续的IRTE并且interrupt_index对应HANDLE号必须为N个连续的IRTE的首个。同样bit 4必须为"1"用来表示中断请求为Remapping格式。Data位全部设置为"0"。



中断重映射的硬件处理步骤如下：

硬件识别到物理地址0xFEEx_xxxx范围内的DWORD写请时，将该请求认定为中断请求；

当Interrupt Remapping没有使能时，所有的中断都按照Compatibility format来处理；

当Intgrrupt Remapping被使能时，中断请求处理流程如下：

如果来的中断请求为Compatibility format：

先检测IRTA寄存器的EIME位，如果该位为“1”那么Compatibility format的中断被blocked，否则Compatibility format中断请求都按照pass-through方式处理（传统方式）。

如果来的中断请求为Remapping format：

先检测reserved fileds是否为0，如果检查失败那么中断请求被blocked。接着硬件按照上面提到的算法计算出interrupt_index并检测其是否合法，如果该interrupt_index合法那么根据interrupt_index索引中断重映射表找到对应的IRTE，然后检测IRTE中的Present位，如果Preset位为0那么中断请求被blocked，如果Present位为1，硬件校验IRTE其他field合法后按照IRTE的约定产生一条中断请求。

中断重映射的软件处理步骤如下：

分配一个IRTE并且按照IRTE的格式要求填好IRTE的每个属性；
按照Remapping format的要求对中断源进行编程，在合适的时候触发一个Remapping format格式的中断请求。


附：Remapping格式中断重映射表项的格式
Interrupt Remapping格式的中断重映射表项的格式为（下篇会介绍Interrupt Posting格式的中断重映射表项）:



其中比较关键的中断描述信息为：

Present域(P)：0b表示此IRTE还没有被分配到任何的中断源，索引到此IRTE的Remapping中断将被blocked掉，1b表示此IRTE是有效的，已经被分配到某个设备。
Destination Mode域(DM)：0b表示Destination ID域为Physical APIC-ID，1b表示Destination ID域是Logical APIC-ID。
IRTE Mode域(IM)：0b表示此中断请求是一个Remapped Interrupt中断请求，1b表示此中断请求是一个Posted Interrupt中断请求。
Vector域(V)：共8个Byte表示了此Remapped Interrupt中断请求的vector号(Remapped Interrupt)。
Destination ID域(DST)：表示此中断请求的目标CPU，根据当前Host中断方式不同具有不同的格式。xAPIC Mode (Cluster)为bit[40:47]， xAPIC Mode (Flat)和xAPIC Mode (Physical)为bit[47:40]， x2APIC Mode (Cluster)和x2APIC Mode (Physical)为bit[31:0]。
SID, SQ, SVT则联合起来表示了中断请求的设备PCI/PCI-e request-id信息。