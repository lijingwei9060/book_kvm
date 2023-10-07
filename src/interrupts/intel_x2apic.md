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

x86 CPU中一共有三种访问APIC的方式：
1. 通过CR8来访问TPR寄存器（仅IA32-e即64位模式）
2. 通过MMIO来访问APIC的寄存器，这是xAPIC模式提供的访问方式
3. 通过MSR来访问APIC的寄存器，这是x2APIC模式提供的访问方式

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

分一下组：
Timer related:
CCR: Current Count Register
ICR: Initial Count Register
DCR: Divide Configuration Register
Timer: in LVT
 
LVT (Local Vector Table):
 
Timer
Local Interrupt
Performance Monitor Counters
Thermal Sensor
Error
 
IPI: 
- ICR: Interrupt Command Register
- LDR: Logical Destination Register
- DFR: Destination Format Register
 
Interrupt State: 
- ISR: In-Service Register
- IRR: Interrupt Request Register
- TMR: Trigger Mode Register

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
   2. 001b (Lowest)
   3. 010b (SMI)：向CPU发送一个SMI，为了兼容性Vector必须为0，SMI总是Edge Triggered的（即会忽略Trigger Mode的设置）
   4. 011b (REMAPED)
   5. 100b (NMI)：向CPU发送一个NMI，此时Vector会被忽略，NMI总是Edge Triggered的
   6. 101b (INIT)
   7. 110b (STARTUP)
   8. 111b (ExtINT)：令CPU按照响应外部8259A PIC的方式响应中断，这将会引起一个INTA周期，CPU在该周期向外部控制器索取Vector
   9. 整个系统中应当只有一个CPU的其中一个LVT表项配置为ExtINT模式，因为整个系统应该只有一个PIC
3. 第12位为Delivery Status（只读），取0表示空闲，取1表示CPU尚未接受该中断（尚未EOI）
4. 第13位为Interrupt Input Pin Polarity，取0表示LINT0/LINT1引脚上的信号是Active High的，取1表示Active Low
5. 第14位为Remote IRR Flag（只读），若当前接受的中断为Fixed Mode且是Level Triggered的，则该位为1表示CPU已经接受中断（已将中断加入IRR），但尚未进行EOI。CPU执行EOI后，该位就恢复到0
6. 第15位为Trigger Mode，取0表示Edge Triggered，取1表示Level Triggered，该选项只适用于LINT0/LINT1，LINT1只支持Edge Triggered模式，软件应将其Trigger Mode设为0
7. 第16位为Mask，取0表示允许接受中断，取1表示禁止，reset后初始值为1
8. 第17/17-18位为Timer Mode，只有LVT Timer Register有，用于切换APIC Timer的三种模式

并不是LVT中每个寄存器都拥有所有的field。


### APIC Timer

APIC Timer是一个32位的Timer，通过两个32位的Counter寄存器实现：
1. Initial Count Register（APIC_Page[0x380]）
2. Current Count Register（APIC_Page[0x390]，只读）

Counter的频率由APIC Timer的基准频率除以Divide Configuration Register确定的除数获得, 地址0xFEE003E0H， reset后为0。

Divide Configuration Register（APIC_Page[0x3E0]）的第0、1、3位决定了除数：
- 000: divided by 2
- 001: divided by 4
- 010: divided by 8
- 011: divided by 16
- 100: divided by 32
- 101: divided by 64
- 110: divided by 128
- 111: divided by 1 

APIC Timer可能会随CPU休眠而停止运作，检查CPUID.06H.EAX.ARAT[bit 2]（APIC Timer Always Running bit）可知其是否会永远保持运作。APIC Timer的基准频率是总线频率（外频）或Core晶振频率（如果能通过CPUID.15H.ECX查到的话）。

APIC Timer有三种操作模式，可以通过LVT Timer Register的第17-18位设置，分别是：

1. One shot（00b）：写入Initial Count以启动Timer，Current Count会从Initial Count开始不断减小，直到最后降到零触发一个中断，并停止变化。One-shot 通过MMIO给 initial-count register写一个相对时间，比如10ms那就是10ms后来个中断，
2. Periodic（01b）：写入Initial Count以重启Timer，Current Count会反复从Initial Count减小到0，并在减小到0时触发中断
3. TSC-Deadline Mode（10b： TSC-Deadline通过给IA32_TSC_DEADLINE MSR写一个tsc的绝对时间，cpu的tsc值到了这个绝对值就来个中断
   - CPUID.01H.ECX.TSC_Deadline[bit 24]表示是否支持TSC-Deadline模式，若不支持，第18位为reserved
   - 此模式下，对Initial Count的写入会被忽略，Current Count永远为0。此时Timer受MSR[IA32_TSC_DEADLINE_MSR]控制，为其写入一个非零64位值即可激活Timer，使得在TSC达到该值时触发一个中断。该中断只会触发一次，触发后IA32_TSC_DEADLINE_MSR就被重置为零。

写入LVT Timer Register切换到TSC-Deadline Mode是一个Memory操作，该操作和接下来的WRMSR指令间必须添加一个MFENCE以保证不会乱序

注意前两种模式下，为Initial Count写入0即可停止Timer运作，在第三种模式下则是为IA32_TSC_DEADLINE_MSR写入0，此外修改模式也会停止Timer运行。当然，也可以通过LVT Timer Register中的Mask屏蔽Timer中断实现同样的效果。

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

xAPIC模式下，不建议使用Cluster模式，详情可参考[这个贴子](https://forum.osdev.org/viewtopic.php?f=1&t=14808&start=17)

x2APIC只提供Cluster Model，不再支持Flat Model。由于x2APIC将APIC ID扩展为了32位，故Destination也是32位，其高16位为Cluster，低16位为Bitmap。显然x2APIC改进了Cluster Model的支持，鼓励使用该模式。

内核中有2个lapic驱动apic_x2apic_cluster、apic_x2apic_phys、apic_noop，全局变量apic指向具体哪个驱动, 默认选择的是apic_x2apic_cluster。



```C
apic_intr_mode_select(void) // Select the interrupt delivery mode for the BSP, 设置全局变量apic_intr_mode
enum apic_intr_mode_id apic_intr_mode：
- APIC_PIC: 禁用APIC默认就是PIC模式
- APIC_VIRTUAL_WIRE
- APIC_VIRTUAL_WIRE_NO_CONFIG
- APIC_SYMMETRIC_IO
- APIC_SYMMETRIC_IO_NO_ROUTING
```


```C
apic_intr_mode_init(void) // Init the interrupt delivery mode for the BSP
|-> x86_64_probe_apic()
    |-> enable_IR_x2apic();
    |-> apic_install_driver(*drv);
|-> x86_32_install_bigsmp();
|-> x86_platform.apic_post_init() => kvm_apic_init();
|-> apic_bsp_setup(upmode);
```

### 和PIC共存

MP spec为PIC和APIC共存的平台规定了三种模式：PIC mode、Virtual Wire Mode、Symmetric I/O Mode。
三种模式中，PIC mode和Virtual Wire Mode互斥存在。Symmetric I/O Mode是所有MP平台最终进入的模式。Spec规定，为了PC/AT compatibility，系统在RESET后首先进入PIC mode或者Virtual Wire mode，操作系统（或BIOS）在适当时候切换入Symmetric I/O Mode。

IMCR，Interrupt Mode Configuration Register，中断模式配置寄存器，控制当前系统的中断模式——PIC？还是APIC？当系统RESET后，该寄存器清0，系统默认进入PIC模式。此时BSP（Boot Startup Processor，多处理器系统中第一个启动的CPU）的NMI和INTR脚为硬连线，直接从外部接入，不经过APIC。

对IMCR写1，可将系统切换至Symmetric I/O Mode模式。此时外部中断直接通过APIC到达CPU，NMI则连接LAPIC的LINT1脚。

### Lowest Priority Mode
当使用Logical Destination Mode或使用Destination Shorthand进行IPI群发时，可以使用Lowest Priority Mode，选出目标CPU集合中优先级最低的CPU作为发送对象，最终只有该CPU能收到IPI。

除了IPI以外，IOAPIC发送的中断也可以是Lowest Priority Mode的，通过MSI发送的中断也可是Lowest Priority Mode的。

在奔腾4及以后的架构上，优先级对应于TPR (Task Priority Register)寄存器，TPR取值最小的CPU获得IPI。

手册实际上只说Task Priority最小的CPU获胜，但没有说Task Priority对应于什么寄存器。现代的Intel CPU都采用TPR作为这个Task Priority，而QEMU、KVM实现的虚拟APIC则利用了手册的语焉不详，没有参考TPR进行CPU的选取。

Lowest Priority模式设计的初衷显然是配合TPR寄存器使用，TPR寄存器的另一个功能是屏蔽低优先级（优先级低于TPR）的中断，每当OS切换Task（进程/线程/etc.）时，就更新TPR（即Task Priority），这样可以使得高优先级的Task不被中断打断，中断优先发给低优先级的Task。

不过，目前Linux并未用到TPR寄存器，所有CPU的TPR都取0，这可能导致Lowest Priority中断总是发给同一个CPU。因此Linux中一般每个IRQ只绑定一个CPU（Destination只指定一个CPU），通过irqbalance程序动态改变该绑定，从而平衡中断负载。

在奔腾和P6 family上，优先级取决于Arbitration Priority Register（APR，APIC_Page[0x90]，仅最低8位有效），APR最小者胜出，其取值如下：
```C
if (TPR[7:4] >= IRRV[7:4] && TPR[7:4] > ISRV[7:4]) {
    APR[7:0] = TPR[7:0]
} else {
    APR[7:4] = max(TPR[7:4], ISRV[7:4], IRRV[7:4])
    APR[3:0] = 0
}
```

其中ISRV是ISR (In-Service Register)中最大的Vector，IRRV是IRR (Interrupt Request Register)中最大的Vector。


## LAPIC中的设备

1. 内部时钟TSC
2. 热传感器
3. 本地定时设备 apic-timer
4. 两条irq线： lint0和lint1


## LAPIC 中断处理过程


奔腾4及至强以来的中断处理流程如下：

1. 确认自己是否是Interrupt Message的目标，如果是则继续（对来自本地中断源的中断，可跳过这一步）
2. 如果中断的 Delivery Mode 为 NMI / SMI / INIT / ExtINT / SIPI ，则直接将中断发送给 CPU
3. 如果不是以上的 Mode ，则设置中断消息在 IRR 中对应的 bit, 将中断加入等待队列。如果 IRR 中 bit 已被设置(没有 open slot)，则拒绝该请求，然后给 sender 发送一个 retry 的消息
4. 对于在IRR中pending的中断，APIC根据它们的优先级，以及当前CPU的优先级（存在PPR寄存器中）依次分发，一次只给CPU一个中断，清空该中断在 IRR 中对应的 bit，并设置该中断在 ISR 中对应的 bit
5. 中断处理例程执行完毕时，应写入EOI Register，使得APIC从ISR队列中删除中断对应的项，结束该中断的处理（NMI、SMI、INIT、ExtINT及SIPI不需要写入EOI）
6. LAPIC 清除 ISR 中该中断对应的 bit(只针对 level-triggered interrupts)
7. 对于 level-triggered interrupt， EOI 会被发送给所有的 IOAPIC。可以通过设置 Spurious Interrupt Vector Register 的 bit12 来避免 EOI 广播

### Task and Processor Priority

Interrupt Vector（中断向量号，8位宽）的高4位称为Interrupt Priority Class，也就是说每16个Vector分为一组（一个Class），后16个比前16个优先级高。理论上，Vector的低4位为Interrupt Priority Sub-Class，代表组内的优先级，数值越大优先级越高，但实际上并没有用到。

TPR(Task Priority Register, 当前 CPU 处理中断所需的优先级)和PPR(Process Priority Register,当前 CPU 处理中断所需的优先级)决定了IRR寄存器中pending的中断是否能够发送给CPU：

- Task Priority Register (TPR, APIC_Page[0x80])，仅最低8位有效
- Processor Priority Register (PPR, APIC_Page[0xA0])，仅最低8位有效。PPR是只读的，其取值由TPR(Task Priority Register)和ISR(In Service Register)寄存器的取值决定：
  - PPR[7:4] = max(TPR[7:4], ISRV[7:4])，ISRV是ISR中最大的Vector
  - 若TPR[7:4] > ISRV[7:4]，则PPR[3:0] = TPR[3:0]
  - 若TPR[7:4] < ISRV[7:4]，则PPR[3:0] = 0
  - 若TPR[7:4] = ISRV[7:4]，则PPR[3:0]可以取TPR[3:0]或0，具体取哪个值是model-specific的
IRR中pending的中断是否能发送，仅取决于PPR[7:4]（称之为Processor Priority Class），只有Interrupt Priority Class高于Processor Priority Class的Vector才能被发送给CPU。至于PPR[3:0]，目前并无用途。

换句话说，TPR的高4位为Task Priority Class，表示CPU欲屏蔽Class小于等于Task Priority Class的Vector。同时，CPU还要保证当前正在处理的中断（ISR中的中断）只能被具有更高优先级（Priority Class）的中断打断。

在IA32-e（即x86-64）模式下，有CR8寄存器，其第0-3位就是TPR的第4-7位，即CR8[3:0] = TPR[7:4]恒成立，可以通过CR8寄存器迅速屏蔽/启用部分Vector。OS应在TPR和CR8之间选择一种操作方式，而不应两种方式混用。


### Accepting Fixed Interrupts

与接收中断有关的寄存器有四个：

1. Interrupt Request Register (IRR, APIC_Page[0x200] - APIC_Page[0x270])
2. In-Service Register (ISR, APIC_Page[0x100] - APIC_Page[0x170])
3. Trigger Mode Register (TMR, APIC_Page[0x180] - APIC_Page[0x1F0])
4. End of Interrupt Register (EOI Register, APIC_Page[0xB0])

IRR、ISR、TMR大小都是256位，每一位代表一个Vector，EOI Register则是32位的普通寄存器。

当APIC收到Delivery Mode为Fixed的中断消息时，会根据其Vector的取值，设置IRR中对应的位，表示已收到但尚未发送给CPU的中断，也就是说IRR为中断等待队列。

接着，当CPU准备好接收中断时，APIC会从IRR中取出Vector最大（即优先级最高）的中断发送给CPU（即触发IDT中注册的中断处理例程），并清除IRR中对应位，设置ISR中对应位，这里ISR是CPU正在处理的中断队列。当CPU开启中断（EFLAGFS.IF = 1）且IRR中最大的Vector的优先级（Interrupt Priority Class）高于CPU当前的优先级（Processor Priority Class）时，我们认为CPU已经准备好接收下一个中断。

对于同一个Vector，APIC在CPU未处理完前还能再在IRR中缓存一个中断请求，即总共可以支持两个等待处理的请求。而老式的8259A PIC中Pending和In-Service的请求是互斥的，不允许在In-Service的同时再在Pending队列中缓存一个请求。

当CPU执行完中断处理例程后，在调用IRET指令返回之前，应该向EOI Register进行写入（一般写入0即可），表示中断已经处理完毕。这会导致ISR的最高位被清空，并引起CPU接收IRR中Pending的中断（如果有的话）。

若收到的中断是Level Triggered的，则在设置IRR中Vector对应位的同时，还会设置TMR中的对应位。到写入EOI Register时，就会检查TMR，发现欲完成的中断是Level Triggered的后就会通过总线向所有IOAPIC广播EOI Message。

这个默认的广播行为是可以禁止的，通过设置Spurious Interrupt Vector Register的第12位即可禁止向IOAPIC广播。此时，必须由软件手动设置发送中断的那个IOAPIC的EOI Register（仅后来集成在南桥的IOxAPIC具备，初代IOAPIC芯片不具备该寄存器），来完成EOI的必要步骤。


## Spurious Interrupt

Spurious Interrupt产生的原因如下：当CPU要接受一个ExtINT中断时，第一步获取中断向量号需要经过两个周期，第一个周期INTR引脚收到信号，第二个周期（INTA周期）从外部控制器获取中断向量号。而通常的中断都是在INTR引脚收到信号的周期内，就取得中断向量号。由于这个非原子性，若CPU正好在INTA周期通过LVT表项或是TPR寄存器屏蔽了该ExtINT中断，则APIC会转而发送一个Spurious Interrupt。由于外部中断并未被接收，这个Spurious Interrupt无需进行EOI。

Spurious-Interrupt Vector Register (SVR, APIC_Page[0xF0])的格式如下：

- 第0-7位为Spurious Vector，即APIC产生Spurious Vector时应该发送的Interrupt Vector。对于奔腾和P6 family，第0-3位被hardwire到1，因此Spurious Vector低4位最好设置为全1
- 第8位控制APIC软件启用/禁用，1为启用，0为禁用
  - APIC断电重启后，默认处于软件禁用状态
  - 在软件禁用状态下，IRR和ISR的状态仍会保留
  - 在软件禁用状态下，仍能响应NMI、SMI、INIT、SIPI中断，并且仍可通过ICR发送IPI
  - 在软件禁用状态下，LVT表项的Mask位都被强制设置为1（即屏蔽）
- 第9位为Focus Processor Checking，取1表示禁用Focus Processor，取0表示启用。Focus Processor是奔腾和P6 family在处理Lowest Priority Mode时会涉及到的概念，如今已没有用处
- 第12位为Suppress EOI Broadcasts，设置为1则禁止Level Triggered的中断的EOI默认向IOAPIC广播EOI Message的行为

并非所有型号的CPU都支持Suppress EOI Broadcasts，这个功能实际上是与x2APIC模式一同引入的，可以通过查询APIC Version Register的第24位获知是否支持该功能。换句话说，它实际上是对过去广播EOI Message的改进，现代CPU上建议启用该功能。

## Message Signalled Interrupts
MSI (Message Signalled Interrupt)是PCI总线引入的功能，它本质上就是在中断发生时，不通过带外（Side-band）的中断信号线（INTx机制），而是通过带内（In-band）的PCI写入事务来通知中断的发生。

从原理上来说，MSI产生的事务与一般的DMA事务并无本质区别，需要依赖Platform Specific的特殊机制从总线事务中区分出MSI并作赋予其中断的语义。在x86平台上，是由Host Bridge/Root Complex负责这一职责，将MSI事务翻译成System Bus上的中断消息，凡目标地址落在`[0xFEE00000, 0xFEEFFFFF]`这个区间的写入事务都会被视为MSI中断请求并翻译成中断消息。

一个MSI事务由Address和Data构成，每个设备可以配置其发生中断时产生的MSI事务的Address和Data，并且可以在不同事件发生时产生不同的MSI事务（即不同的Address, Data对），在x86平台上它们的格式分别定义如下：

Message Address：

1. 第0-1位为Ignored
2. 第2位为Destination Mode (DM)，取0表示Physical Mode，取1表示Logical Mode
3. 第3位为Redirection Hint (RH)，取1表示Lowest Priority Mode
  - RH = 0时，DM = 0表示Physical Mode，DM = 1表示Logical Mode,手册上写DM会被忽略，但实际上它是起作用的
  - RH = 1, DM = 0的组合相当于Physical Mode，但禁止进行广播
  - RH = 1, DM = 1的组合表示通常理解的Lowest Priority Mode（即一组CPU中选取一个发送）
4. 第12-19位为Destination ID，和ICR寄存器中的Destination作用相同
5. 第20-31位，必须为0xFEE
6. 其余位保留

Message Data：

1. 第0-7位为Vector，即目标CPU收到的中断向量号，其中0-15号被视为非法，会给目标CPU的APIC产生一个Illegal Vector错误
2. 第8-10位为Delivery Mode，有以下几种取值：
  - 000b (Fixed)：按Vector的值向所有目标CPU发送相应的中断向量号
  - 001b (Lowest Priority)：按Vector的值向所有目标CPU中优先级最低的CPU发送相应的中断向量号
  - 010b (SMI)：向所有目标CPU发送一个SMI，为了兼容性Vector必须为0，SMI总是Edge Triggered的（即会忽略TM的设置）
  - 100b (NMI)：向所有目标CPU发送一个NMI，此时Vector会被忽略，NMI总是Edge Triggered的
  - 101b (INIT)：向所有目标CPU发送一个INIT IPI，导致该CPU发生一次INIT，此模式下Vector必须为0，INIT总是Edge Triggered的
  - 111b（ExtINT）：向所有目标CPU发送一个与8259A PIC兼容的中断信号，将会引起一个INTA周期，目标CPU在该周期向外部控制器索取Vector，ExtINT总是Edge Triggered的
3. 第14位为Level，若中断是Level Triggered的，则取1表示Assert，取0表示Deassert
4. 第15位为Trigger Mode，取0表示Edge Triggered，取1表示Level Triggered
5. 其余位保留

关于RH、DM和Delivery Mode的作用，手册语焉不详，我们需要对手册进行解读和澄清。

首先，手册称RH = 0时，会忽略DM的值：

When RH is 0, the interrupt is directed to the processor listed in the Destination ID field.If RH is 0, then the DM bit is ignored and the message is sent ahead independent of whether the physical or logical destination mode is used.按照通常的理解，这表示DM位取0或取1没有区别。根据手册中的描述，似乎RH = 0时中断是按照Physical Mode发送的。然而，这种理解是错误的，实际上RH = 0时，DM位仍然起作用，DM = 1仍旧表示Logical Mode。我们可以这样理解：在ICR寄存器中有Destination Mode位，显然DM位是System Bus上中断消息的一部分。尽管手册中说DM位被忽略，但北桥产生的中断消息中DM位仍是取自MSI Message的DM位，而不是设置为0。

其次，Delivery Mode中已经有了Lowest Priority Mode，再添加Redirection Hint这个位功能上岂不是重复了？这个问题要分两个角度看：

从功能的角度看，实际上Delivery Mode不选择Fixed/Lowest Priority，RH取1，能够实现SMI/NMI/INIT/ExtINT发送到Lowest Priority的CPU，这是原本没有RH时做不到的，说明RH位确实提供了新功能
从设计的角度看，Redirection Hint位本身是为Itanium设计的，只是为了同一套北桥硬件同时支持Itanium和x86，才将RH套用到了x86上，从而和其已有的Lowest Priority Mode功能形成了重复
总而言之，功能确实部分重叠，但RH位也带来了新的可能性，不算完全没用。

References:
[1] https://lkml.org/lkml/2018/9/6/365
[2] https://software.intel.com/en-us/forums/virtualization-software-development/topic/288883
[3] https://www.spinics.net/lists/kvm/msg114915.html
[4] https://lists.gnu.org/archive/html/qemu-devel/2015-03/msg04949.html
[5] https://github.com/jfsulliv/JamesSullivan1.github.io/blob/master/_posts/2015-03-14-understanding-message-signalled-interrupts.md

## Extended XAPIC (x2APIC)

将MSR[IA32_APIC_BASE]的第10位设置为1，即可启用x2APIC。断电重启后首先进入的是xAPIC模式，随后才能进入x2APIC模式，一旦进入则无法回到xAPIC模式（否则会引起#GP），必须进行一次重启（硬件禁用再启用）才能回到xAPIC模式。

x2APIC模式下INIT，会回到x2APIC模式的初始状态，而不是xAPIC模式。同理xAPIC模式下INIT，会回到xAPIC模式的初始状态。不允许在硬件禁用的同时开启x2APIC模式（试图如此做会引起#GP），硬件禁用时进行INIT，仍保持禁用状态。另外，在启动x2APIC模式前，BIOS还应检查并启用VT-d的中断重映射功能。

x2APIC模式下通过MSR访问其寄存器，0x800到0x8FF的MSR都被预留给x2APIC。在进入x2APIC模式前无法访问这些MSR，否则会引起#GP。同样，进入x2APIC模式后，xAPIC的MMIO区域相当于关闭时的状态。

x2APIC与xAPIC相比，寄存器基本可以一一对应（MSR有64位宽，但只对应到32位的xAPIC寄存器，高32位保留），除了以下变化：

- 取消了Flat Model，故删去了DFR寄存器
- ICR_Low和ICR_High合并为了一个64位的寄存器ICR（MSR 0x830）
- 增加了SELF IPI寄存器（MSR 0x83F）
x
### 2APIC ID
APIC ID被改为32位，扩展后的ID可称之为x2APIC ID，占满了APIC ID Register的32位。寄存器被改为只读，只会在开机时由硬件设置一次，其末8位被作为xAPIC模式下的APIC ID使用。

实际实现中x2APIC ID可能不足32位，此时不支持的高位永远为0，通过写入0xFFFFFFFF再读出即可确定其实际范围。

若支持x2APIC模式，则通过CPUID.0BH.EDX可以获得完整32位的x2APIC ID，从而帮助BIOS在xAPIC模式下判断系统的APIC ID超过了256的上限。若真的超过上限，则BIOS必须 (a).在进入OS前就在所有CPU上均开启x2APIC模式 或 (b).只启用APIC ID小于等于255的CPU（其余CPU令其进入深度睡眠，保证不被OS启动），并且保持在xAPIC模式。

### ICR Operation
与xAPIC模式相比，ICR寄存器中的Delivery Status位被取消，Destination从8位扩展到了32位，占据了ICR寄存器的全部高32位。由于Delivery Status被取消，软件不再有理由读取ICR寄存器（尽管它仍是可读的）。

由于APIC ID扩展到了32位，Destination也相应变为32位，取0xFFFFFFFF时表示广播。在Logical Mode下，取消了Flat Model，故不再需要DFR寄存器，而LDR寄存器的有效内容扩展到了32位，且变为只读。根据Cluster Model，LDR的高16位为Cluster，需与Destination的高16位完全匹配，低16位为Bitmap，只需与Destination的低16位取AND后不为零即可匹配。

LDR寄存器的取值是在初始化时就由x2APIC ID决定的，可以称之为Logical x2APIC ID，其取值为LDR = (APIC_ID[19:4] << 16) | (1 << APIC_ID[3:0])。

### Self IPI Register
该寄存器是一个只写的寄存器，试图读取会造成#GP，仅0-7位有效，代表了Interrupt Vector。写入该寄存器的效果等价于通过写入ICR发送一个Edge Triggered、Fixed Interrupt的Self IPI。