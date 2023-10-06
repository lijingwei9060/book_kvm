# 概念介绍

APIC (Advanced Programmable Interrupt Controller)是90年代Intel为了应对将来的多核趋势提出的一整套中断处理方案，用于取代老旧的8259A PIC。这套方案适用于多核（Multi-Processor）机器，每个CPU拥有一个Local APIC，整个机器拥有一个或多个IOAPIC，设备的中断信号先经由IOAPIC汇总，再分发给一个或多个CPU的Local APIC。为了配合APIC，还推出了MPSpec (Multiprocessor Specification)，为BIOS向OS提供中断配置信息的方式提供了规范。

自90年代以来，PCI总线发展出了MSI (Message Signalled Interrupt)，目前的机器中是以MSI为主要的中断机制，IOAPIC作为辅助，但CPU处仍使用Local APIC接收和处理中断。当时提出的MPSpec经过演化目前已成为了ACPI规范的一部分，BIOS可以通过ACPI表向OS报告中断配置情况（e.g. IOAPIC的引脚连接到哪个设备）。

初代奔腾（Pentium）上初次引入Local APIC时，它是外置的Intel 82489DX芯片。在一些奔腾型号以及P6 family（即从奔腾Pro到奔腾3）上则将其改为了内置，但功能保持不变。自奔腾4及至强（Xeon）开始取消了APIC Bus以及一部分相关设置，于是改称xAPIC，目前Intel CPU的默认模式就是xAPIC。后来又增加了x2APIC模式作为xAPIC的扩展，这个功能需要手动开启，并且必须配合VT-d的中断重映射功能使用。

在P6 family的时代，各CPU的APIC间通过一条APIC Bus通信，IPI (Inter Processor Interrupt)消息以及IOAPIC/MSI的中断消息都在APIC Bus上传输。从奔腾4开始，取消了APIC Bus，APIC间的通信改走System Bus，IPI消息和中断消息都通过System Bus传输。

Local APIC（以下简称APIC）可以从以下来源接收中断：

1. 通过LINT0和LINT1这两个引脚接收的本地中断
2. 通过IOAPIC接收的外部中断，以及通过MSI方式收到的外部中断
3. 其他CPU（甚至自己）发来的IPI
4. APIC Timer产生的中断
5. Performance Monitoring Counter产生的中断（见Intel SDM Vol.3 18.6.3.5.8节）
6. 温度传感器产生的中断（见Intel SDM Vol.3 14.7.2节）
7. APIC内部错误引发的中断

它们可以分成三类：

1. 1、4、5、6、7称为本地中断源：中断消息未指定Vector（中断向量号）等信息，因此要通过LVT (Local Vector Table)控制这些中断的分发
2. IPI：由CPU通过写入APIC的Interrupt Control Register (ICR)而主动发起，接收不需要额外配置
3. IOAPIC/MSI方式收到的外部中断：中断消息本质上和IPI相同，接收也不需额外配置

下文会按照本地中断的配置、IPI的发起、中断的接收的顺序介绍相应功能。关于IOAPIC和MSI的配置，请参考IOAPIC手册、Intel南桥手册以及PCI Spec。关于中断虚拟化以及VT-d的中断重映射，请参考Intel SDM Vol.3第29章以及VT-d Spec。


## LAPIC Register

传统上，LAPIC的寄存器是通过MMIO访问的（即xAPIC模式），后来添加的x2APIC模式则通过MSR来访问其寄存器，这里先介绍xAPIC模式，x2APIC模式会在后面详细介绍。APIC默认的物理地址为从`0xFEE00000`起的4KB页，每个CPU使用的物理地址都是一样的，但它们对应的是各自的Local APIC。

寄存器所在页的物理地址可以通过设置改变，这是P6时代遗留下来的上古特性，当时是为了防止与已经使用了这块地址的程序发生冲突，现在已无人使用。此外还需注意，该页在页表中必须设置为`strong uncacheable (UC)`。

APIC可以硬件禁用/启用，禁用再启用后相当于断电重启。此外还可以软件禁用/启用，这只是暂时禁用，重新启用后其状态会得到保留。需要注意的是，APIC在通电后默认是处于软件禁用的状态的。

xAPIC模式下用到的唯一一个MSR是MSR[IA32_APIC_BASE]：

- 第8位，表示该CPU是否为BSP (BootStrap Processor)，取1表示BSP，取0表示AP (Application Processor)
- 第11位，表示硬件启用/禁用APIC（0代表禁用，自奔腾4起禁用后仍可启用，P6则不行），禁用后相当于APIC不存在，CPUID也会显示不支持APIC，重新启用后APIC回到断电重启时的状态
- 第12-35位，表示APIC Base，即APIC的寄存器所在物理地址

寄存器列表：ICR、IRR、ISR、TPR、PPR
- version register： 位于APIC_Page[0x30]，只读。
  - 第0-7位为Version Number，取0x10-0x15之间的某个值
  - 第16-23位为Max LVT Entry，其值为LVT条目数-1，Nehalem及以后的产品都应为6（即7条），早期的P6系列为4（即5条），奔腾4开始增加到5（即6条）
  - 第24位表示是否支持Suppress EOI-broadcast
- Time: Current count Register/Initial count Register/Divide configuration register
- Local Apic id register： 位于APIC_Page[0x20]，用作CPU的编号，其初始值为开机时由硬件自动决定并赋予，会被BIOS和/或OS使用，因此不宜再行修改（且仅在部分型号CPU上支持修改）。若已改动其值，则仍可通过CPUID.01H.EBX[31:24]查询到其初始值。奔腾及P6 family仅使用第24-27位（共4位），故最多支持15个CPU（0xF用作广播），奔腾4开始的xAPIC模式使用第24-31位（共8位），故最多支持255个CPU（0xFF用作广播）。x2APIC使用32位的x2APIC ID，存在MSR中，可以认为不存在最大CPU数量限制。
- local destination register
- destination format register
- spurious vector register
- LVT(local vector table)
- EOI register
- ICR(Interrupt Command Register) 用于发送 IPI
- IRR(Interrupt Request Register) 当前 LAPIC 接收到的中断请求
- ISR(In-Service Register) 当前 LAPIC 送入 CPU 中 (CPU 正在处理) 的中断请求
- TPR(Task Priority Register) 当前 CPU 处理中断所需的优先级
- PPR(Processor Priority Register) 当前 CPU 处理中断所需的优先级，只读，由 TPR 决定

### LVT： 本地中断

LVT(local vector table)保存本地设备发出的中断请求，就是LAPIC里面设备发出的，只能向本CPU发出中断，所以不存在中断目标。最多7项，LAPIC 在收到后会设置好 LVT(Local Vector Table)的相关寄存器，通过 interrupt delivery protocol 送达 CPU。

1. LVT CMCI Register（APIC_Page[0x2F0]）：负责发送Corrected Machine Check Error Interrupt，被纠正的Machine Check Error累积至超过一个阈值后，便会引起一个CMCI中断（从至强5500起才有此项，该功能默认禁止）
2. LVT Timer Register（APIC_Page[0x320]）：负责发送由APIC Timer产生的中断
3. LVT Thermal Monitor Register（APIC_Page[0x330]）：负责发送由温度传感器产生的中断（从奔腾4起才有此项）
4. LVT Performance Counter Register（APIC_Page[0x340]，此地址仅供参考，该寄存器具体在何处是implementation specific的）：负责发送由性能计数器Overflow产生的中断（从P6 family起才有此项）
5. LVT LINT0 Register（APIC_Page[0x350]）：负责转发来自LINT0引脚的中断，本地直连 IO 设备 (Locally connected I/O devices) 通过 LINT0 和 LINT1 引脚发来的中断
6. LVT LINT1 Register（APIC_Page[0x360]）：负责转发来自LINT1引脚的中断，本地直连 IO 设备 (Locally connected I/O devices) 通过 LINT0 和 LINT1 引脚发来的中断
7. LVT Error Register（APIC_Page[0x370]）：负责发送APIC内部错误时产生的中断

LVT(Local vector table) 实际上是一片连续的地址空间，每 32-bit 一项，这些寄存器的功能如下：

1. 第0-7位为Vector，即CPU收到的中断向量号，其中0-15号被视为非法，会产生一个Illegal Vector错误（即ESR的第6位，详下）
2. 第8-10位为Delivery Mode，有以下几种取值：
   1. 000b (Fixed)：按Vector的值向APIC所在的CPU发送相应的中断向量号
   2. 010b (SMI)：向CPU发送一个SMI，为了兼容性Vector必须为0，SMI总是Edge Triggered的（即会忽略Trigger Mode的设置）
   3. 100b (NMI)：向CPU发送一个NMI，此时Vector会被忽略，NMI总是Edge Triggered的
   4. 111b (ExtINT)：令CPU按照响应外部8259A PIC的方式响应中断，这将会引起一个INTA周期，CPU在该周期向外部控制器索取Vector
   5. 整个系统中应当只有一个CPU的其中一个LVT表项配置为ExtINT模式，因为整个系统应该只有一个PIC
3. 第12位为Delivery Status（只读），取0表示空闲，取1表示CPU尚未接受该中断（尚未EOI）
4. 第13位为Interrupt Input Pin Polarity，取0表示LINT0/LINT1引脚上的信号是Active High的，取1表示Active Low
5. 第14位为Remote IRR Flag（只读），若当前接受的中断为Fixed Mode且是Level Triggered的，则该位为1表示CPU已经接受中断（已将中断加入IRR），但尚未进行EOI。CPU执行EOI后，该位就恢复到0
6. 第15位为Trigger Mode，取0表示Edge Triggered，取1表示Level Triggered，该选项只适用于LINT0/LINT1，LINT1只支持Edge Triggered模式，软件应将其Trigger Mode设为0
7. 第16位为Mask，取0表示允许接受中断，取1表示禁止，reset后初始值为1
8. 第17/17-18位为Timer Mode，只有LVT Timer Register有，用于切换APIC Timer的三种模式

并不是LVT中每个寄存器都拥有所有的field。


### ICR： Issuing IPI
Selft IPI和IOAPIC本身的中断这两种中断通过写 ICR 来发送。当对 ICR 进行写入时，将产生 interrupt message 并通过 system bus(Pentium 4 / Intel Xeon) 或 APIC bus(Pentium / P6 family) 送达目标 LAPIC 。

Interrupt Command Register (ICR)：是一个64位寄存器，分为ICR_Low（APIC_Page[0x300]）和ICR_High（APIC_Page[0x310]）两部分，写入ICR_Low即可发送一个IPI：ICR_Low的内容可能会在进入深度休眠的C-State后丢失

1. 第0-7位为Vector，即目标CPU收到的中断向量号，其中0-15号被视为非法，会给目标CPU的APIC产生一个Illegal Vector错误
2. 第8-10位为Delivery Mode，有以下几种取值：
  1. 000b (Fixed)：按Vector的值向所有目标CPU发送相应的中断向量号
  2. 001b (Lowest Priority)：按Vector的值向所有目标CPU中优先级最低的CPU发送相应的中断向量号（详下）,发送Lowest Priority模式的IPI的能力取决于CPU型号，不总是有效，建议BIOS和OS不要发送Lowest Priority模式的IPI
  3. 010b (SMI)：向所有目标CPU发送一个SMI，为了兼容性Vector必须为0
  4. 100b (NMI)：向所有目标CPU发送一个NMI，此时Vector会被忽略
  5. 101b (INIT)：向所有目标CPU发送一个INIT IPI，导致该CPU发生一次INIT（INIT后的CPU状态参考Intel SDM Vol.3 Table 9-1），此模式下Vector必须为0。CPU在INIT后其APIC ID和Arb ID（只在奔腾和P6上存在）不变。⚠️ 101b (INIT Level De-assert)：向所有CPU广播一个特殊的IPI，将所有CPU的APIC的Arb ID（只在奔腾和P6上存在）重置为初始值（初始APIC ID）。要使用此模式，Level必须取0，Trigger Mode必须取1，Destination Shorthand必须设置为All Including Self。只在奔腾和P6 family上有效
  6. 110b (Start-up)：向所有目标CPU发送一个Start-up IPI（SIPI），目标会从物理地址0x000VV000开始执行，其中0xVV为Vector的值
3. 第11位为Destination Mode，取0表示Physical，取1表示Logical（详下）
4. 第12位为Delivery Status（只读），取0表示空闲，取1表示上一个IPI尚未发送完毕。
5. 第13位为Level，取0则Delivery Mode = 101b表示INIT Level De-assert，否则表示INIT。在奔腾4及以后的CPU上该位必须永远取1
6. 第14位为Trigger Mode，表示INIT Level De-assert模式下的Trigger Mode，取0表示Edge Triggered，取1表示Level Triggered。在奔腾4及以后的CPU上该位必须永远取0
7. 第18-19位为Destination Shorthand，如果指定了Shorthand，就无需通过ICR_High中的Destination来指定目标CPU，于是可以只通过一次对ICR_Low的写入发送一次IPI。其取值如下：
  1. 00b (No Shorthand)：目标CPU通过Destination指定
  2. 01b (Self)：目标CPU为自身
  3. 10b (All Including Self)：向所有CPU广播IPI，此时发送的IPI Message的Destination会被设置为0xF（奔腾和P6）或0xFF（奔腾4及以后），表示是一个全局广播
  4. 11b (All Excluding Self)：同上，除了不向自己发送以外
8. 第56-63位为Destination，决定了IPI发送的目标CPU(s)，如何决定见下节。

IOAPIC和MSI方式发送的中断，包括经过VT-d重映射的中断，由于System Bus上的中断消息格式相同，其配置涉及的参数都与IPI几乎相同


Physical Destination Mode：若Destination Mode取0，则为Physical模式。在此模式下，Destination表示目标CPU的APIC ID，0xF（奔腾和P6）或0xFF（奔腾4及以后）表示全局广播。

Logical Destination Mode： 若Destination Mode取1，则为Logical模式。在此模式下，Destination不再是物理的APIC ID而是逻辑上代表一组CPU，手册将此时的Destination称为Message Destination Address (MDA)。

IPI Message发送到System Bus上后，各个CPU的APIC会根据自己的Logical Destination Register (LDR)和Destination Format Register (DFR)决定是否要接受这个IPI：

- Logical Destination Register（APIC_Page[0xD0]），第24-31位为Logical APIC ID
- Destination Format Register（APIC_Page[0xE0]），第28-31位为Model，取0000b表示Cluster Model，取1111b表示Flat Model。

所有（软件）启用的APIC的DFR必须设置到同一个模式，应当在尽量早地（在启动的早期阶段）设定好DFR，并且应在设置完DFR模式后再（软件）启用APIC

- Flat Model：APIC将自己的LDR和Destination进行AND操作，结果非零则接受该IPI
- Cluster Model：LDR分成两部分，高4位表示Cluster，低4位为Bitmap，接受IPI的条件是
  - LDR和Destination的高4位完全相同
  - LDR和Destination的低4位取AND结果非零

在Cluster模式下，Cluster取15表示对所有Cluster广播，因此最多只能有15个Cluster。无论如何，Destination取0xFF时仍表示全局广播。

手册还将Cluster Model细分为Flat Cluster和Hierarchical Cluster，前者只有奔腾和P6系列支持，后者所有后续型号都支持。两者本质上应该是相同的，只是硬件结构不同，Hierarchical Cluster模式需要NUMA硬件支持，每个Cluster相当于一个NUMA Node，有一个特殊的硬件称为Cluster Manager，每个Cluster最多有4个Agent，因此总共最多60个APIC Agent。

xAPIC模式下，不建议使用Cluster模式，详情可参考这个贴子

x2APIC只提供Cluster Model，不再支持Flat Model。由于x2APIC将APIC ID扩展为了32位，故Destination也是32位，其高16位为Cluster，低16位为Bitmap。显然x2APIC改进了Cluster Model的支持，鼓励使用该模式。

### Lowest Priority Mode
当使用Logical Destination Mode或使用Destination Shorthand进行IPI群发时，可以使用Lowest Priority Mode，选出目标CPU集合中优先级最低的CPU作为发送对象，最终只有该CPU能收到IPI。

除了IPI以外，IOAPIC发送的中断也可以是Lowest Priority Mode的，通过MSI发送的中断也可是Lowest Priority Mode的。

在奔腾4及以后的架构上，优先级对应于TPR (Task Priority Register)寄存器，TPR取值最小的CPU获得IPI。

手册实际上只说Task Priority最小的CPU获胜，但没有说Task Priority对应于什么寄存器。现代的Intel CPU都采用TPR作为这个Task Priority，而QEMU、KVM实现的虚拟APIC则利用了手册的语焉不详，没有参考TPR进行CPU的选取。

Lowest Priority模式设计的初衷显然是配合TPR寄存器使用，TPR寄存器的另一个功能是屏蔽低优先级（优先级低于TPR）的中断，每当OS切换Task（进程/线程/etc.）时，就更新TPR（即Task Priority），这样可以使得高优先级的Task不被中断打断，中断优先发给低优先级的Task。

不过，目前Linux并未用到TPR寄存器，所有CPU的TPR都取0，这可能导致Lowest Priority中断总是发给同一个CPU。因此Linux中一般每个IRQ只绑定一个CPU（Destination只指定一个CPU），通过irqbalance程序动态改变该绑定，从而平衡中断负载。

在奔腾和P6 family上，优先级取决于Arbitration Priority Register（APR，APIC_Page[0x90]，仅最低8位有效），APR最小者胜出，其取值如下：

if (TPR[7:4] >= IRRV[7:4] && TPR[7:4] > ISRV[7:4]) {
    APR[7:0] = TPR[7:0]
} else {
    APR[7:4] = max(TPR[7:4], ISRV[7:4], IRRV[7:4])
    APR[3:0] = 0
}
其中ISRV是ISR (In-Service Register)中最大的Vector，IRRV是IRR (Interrupt Request Register)中最大的Vector。


## LAPIC中的设备

1. 内部时钟TSC
2. 热传感器
3. 本地定时设备 apic-timer
4. 两条irq线： lint0和lint1