# 概念

在内核中，PCI Express(PCIe)设备的管理框架由多个子系统组成，包括PCIe核心、设备驱动、层次性拓扑结构和电源管理等。

- PCIe核心：负责PCIe总线的探测、初始化、资源分配和设备驱动程序的注册等。在内核中，PCIe核心由PCI子系统和PCIe子系统组成。主要包括PCI子系统和PCIe子系统，以及一些共同的函数和数据结构，如pci_dev、pci_bus、pci_driver等。其中，pci_dev结构体表示一个PCI设备，pci_bus结构体表示一个PCI总线，pci_driver结构体表示一个PCI设备驱动程序。PCI子系统负责PCI总线的探测、资源分配和设备注册等，而PCIe子系统则负责PCIe总线的探测、初始化和设备注册等。
- 设备驱动程序：对不同类型的PCIe设备提供支持。设备驱动程序包括网络设备、存储设备、图形设备和多媒体设备等。主要包括网络设备驱动程序、存储设备驱动程序、图形设备驱动程序和多媒体设备驱动程序等。这些驱动程序使用pci_driver结构体注册到PCI子系统中，以实现对PCIe设备的支持。驱动程序中主要包括与硬件相关的函数和数据结构，以及与内核其他模块的交互函数。
- 层次性拓扑结构：表示与PCIe设备相关的拓扑结构。层次性拓扑结构由PCIe核心自动建立，它提供了PCIe设备的物理连通性和逻辑层次结构，有助于设备驱动程序的管理和维护。
- 电源管理：负责PCIe设备的电源管理，它可以使PCIe设备在不使用时降低功耗，从而延长电池寿命或节省电费。PCIe设备的电源管理由ACPI子系统提供支持。ACPI子系统中包括与硬件相关的函数和数据结构，以及与操作系统其他模块的交互函数。PCIe设备的电源管理可以包括设备的启动、挂起和恢复等。
- 中断处理：PCIe设备的中断处理通常由驱动程序负责。驱动程序使用pci_enable_msi()和pci_enable_msix()函数注册MSI或MSI-X中断，然后使用request_irq()函数注册中断处理函数，以响应设备产生的中断。中断处理函数通常负责处理中断，然后返回以结束中断处理。

总之，内核中的PCIe管理框架提供了一系列的子系统和工具，以帮助开发人员管理和优化PCIe设备的性能，并确保PCIe设备与内核之间的协议兼容性。

## 物理结构

PCIe的架构主要由五个部分组成：Root Complex，PCIe Bus，Endpoint，Port and Bridge，Switch。其整体架构呈现一个树状结构。

1. Root Complex是整个PCIe设备树的根节点，CPU通过它与PCIe的总线相连，并最终连接到所有的PCIe设备上。由于Root Complex是管理外部IO设备的，所以在早期的CPU上，Root Complex其实是放在了北桥（MCU）上 [5]，后来随着技术的发展，现在已经都集成进了CPU内部了 [8]。（注意下图的System Agent的部分，他就是PCIe Root Complex所在的位置。）虽然是根节点，但是系统里面可以存在不只一个Root Complex。随着PCIe Lane的增加，PCIe控制器和Root Complex的数量也随之增加。比如，我的台式机的CPU是i9-10980xe，上面就有4个Root Complex，而我的笔记本是i7-9750H，上面就只有一个Root Complex。我们在Windows上可以通过设备管理器来查看

可以通过lspci命令来查看所有的Root Complex：
```shell
$ lspci -t -v
-+-[0000:c0]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
 +-[0000:80]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
 +-[0000:40]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
 \-[0000:00]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
 ```
2. PCIe总线（Bus）PCIe上的设备通过PCIe总线互相连接。虽然PCIe是从PCI发展而来的，并且甚至有很多地方是兼容的，但是它与老式的PCI和PCI-X有两点特别重要的不同：PCIe的总线并不是我们传统意义上共享线路的总线（Bus），而是一个点对点的网络，我们如果把PCI比喻成网络中的集线器（Hub），那么PCIe对应的就是交换机了。换句话说，当Root Complex或者PCIe上的设备之间需要通信的时候，它们会与对方直接连接或者通过交换电路进行点对点的信号传输。[7]老式的PCI使用的是单端并行信号进行连接，但是由于干扰过大导致频率无法提升，所以后来就演变成PCIe之后就开始使用了高速串行信号。这也导致了PCI设备和PCIe设备无法兼容，只能通过PCI-PCIe桥接器来进行连接。当然这些我们都不需要再去关心了，因为现在已经很少看见PCI的设备了.

3. CIe Device
PCIe上连接的设备可以分为两种类型：

Type 0：它表示一个PCIe上最终端的设备，比如我们常见的显卡，声卡，网卡等等。
Type 1：它表示一个PCIe Switch或者Root Port。和终端设备不同，它的主要作用是用来连接其他的PCIe设备，其中PCIe的Switch和网络中的交换机类似。

4. BDF（Bus Number, Device Number, Function Number）
PCIe上所有的设备，无论是Type 0还是Type 1，在系统启动的时候，都会被分配一个唯一的地址，它有三个部分组成：

Bus Number：8 bits，也就是最多256条总线
Device Number：5 bits，也就是最多32个设备
Function Number：3 bits，也就是最多8个功能
这就是我们常说的BDF，它类似于网络中的IP地址，一般写作BB:DD.F的格式。在Linux上，我们可以通过lspci命令来查看每个设备的BDF，比如，下面这个FCH SMBus Controller就是00:14.0：

由于默认BDF的方式最多只支持8个Function，可能不够用，所以PCIe还支持另一种解析方式，叫做ARI（Alternative Routing-ID Interpretation），它将Device Number和Function Number合并为一个8bit的字段，只用于表示Function，所以最多可以支持256个Function，但是它是可选的，需要通过设备配置启用 [1]。

### Type 0 Device和Endpoint
所有连接到PCIe总线上的Type 0设备（终端设备），都可以来实现PCIe的Endpoint，用来发起或者接收PCIe的请求和消息。每个设备可以实现一个或者多个Endpoint，每个Endpoint都对应着一个特定的功能。比如：

一块双网口的网卡，可以每个为每个网口实现一个单独的Endpoint；
一块显卡，其中实现了4个Endpoint：一个显卡本身的Endpoint，一个Audio Endpoint，一个USB Endpoint，一个UCSI Endpoint；
这些我们都可以通过lspci或者Windows上的设备管理器来查看：
```shell
$ lspci -t -v
-+-[0000:c0]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
             # A NIC card with 2 ports:
 |           +-01.1-[c1]--+-00.0  Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
 |           |            \-00.1  Mellanox Technologies MT2892 Family [ConnectX-6 Dx]
 +-[0000:80]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
             # A graphic card with 4 endpoints:
 |           +-01.1-[81]--+-00.0  NVIDIA Corporation TU104 [GeForce RTX 2080]
 |           |            +-00.1  NVIDIA Corporation TU104 HD Audio Controller
 |           |            +-00.2  NVIDIA Corporation TU104 USB 3.1 Host Controller
 |           |            \-00.3  NVIDIA Corporation TU104 USB Type-C UCSI Controller

```

### RCIE（Root Complex Integrated Endpoint）
说到PCIe设备，脑海里面可能第一反应就是有一个PCIe的插槽，然后把显卡或者其他设备插在里面，就像我们上面看到的这样。但是其实系统中有大量的设备是主板上集成好了的，比如，内存控制器，集成显卡，Ethernet网卡，声卡，USB控制器等等。这些设备在连接PCIe的时候，可以直接连接到Root Complex上面。这种设备就叫做RCIE（Root Complex Integrated Endpoint），如果我们去查看的话，他们的Bus Number都是0，代表Root Complex。

### Port / Bridge
那么其他的需要通过插槽连接的设备呢？这些设备就需要通过PCIe Port来连接了。

在Root Complex上，有很多的Root Port，这些Port每一个都可以连接一个PCIe设备（Type 0或者Type 1）。本质上，所有这些连接其他设备用的部件都是由桥（Bridge）来实现的，这些桥的两端连接着两个不同的PCIe Bus（Bus Number不同）。比如，一个Root Port其实是靠两个Bridge来实现的：一个（共享的）Host Bridge（上游连接着CPU，下游连接着Bus 0）和一个PCI Bridge用来连接下游设备（上游连着的是Bus 0（Root Complex），下游连着的PCIe的设备（Bus Number在启动过程中自动分配）） [1]。

通过lspci命令可以看到这些桥的存在（注意设备详情中的Kernel driver in use: pcieport）：
```
 +-[0000:80]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
             # This is the Host bridge that connects to the root port and CPU:
 |           +-01.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
             # This is the PCI bridge that connects to the root port and device with a new bus - 0x81:
 |           +-01.1-[81]--+-00.0  NVIDIA Corporation TU104 [GeForce RTX 2080]
 |           |            +-00.1  NVIDIA Corporation TU104 HD Audio Controller
 |           |            +-00.2  NVIDIA Corporation TU104 USB 3.1 Host Controller
 |           |            \-00.3  NVIDIA Corporation TU104 USB Type-C UCSI Controller

# Host bridge
$ sudo lspci -s 80:01.0 -v
80:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
        Flags: fast devsel, IOMMU group 13

# PCI bridge
$ sudo lspci -s 80:01.1 -v
80:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0, IRQ 35, IOMMU group 13
        Bus: primary=80, secondary=81, subordinate=81, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff [size=4K]
        Memory behind bridge: f0000000-f10fffff [size=17M]
        Prefetchable memory behind bridge: 0000020030000000-00000200420fffff [size=289M]
        ....
        Kernel driver in use: pcieport
```
注意：是否使用PCIe Bridge和是否通过插槽连接不能直接划等号，这取决于你系统的硬件实现，比如，从上面RCIE的截图中我们可以看到USB Controller作为RCIE存在，而下面EPYC的CPU则不同，USB控制器是通过Root Port连接的，但是它在主板上并没有插槽。
```
$ lspci -t -v
 +-[0000:40]-+-00.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex
             +-03.0  Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge
 |           +-03.3-[42]----00.0  ASMedia Technology Inc. ASM1042A USB 3.0 Host Controller
             # ^====== 40:03.3 here is a Bridge. And USB controller is connected
             #         to this Bridge with a new Bus Number 42.
```

### Switch
如果我们需要连接不止一个设备怎么办呢？这时候就需要用到PCIe Switch了。

PCIe Switch内部主要有三个部分：

一个Upstream Port和Bridge：用于连接到上游的Port，比如，Root Port或者上游Switch的Downstream Port
一组Downstream Port和Bridge：用于连接下游的设备，比如，显卡，网卡，或者下游Switch的Upstream Port
一根虚拟总线：用于将上游和下游的所有端口连接起来，这样，上游的Port就可以访问下游的设备了


另外，这里再说明一次 —— 由于PCIe的信号传输是点对点的，所以Switch中间的这个总线只是一个逻辑上的虚拟的总线，其实并不存在，里面真正的结构是一套用于转发的交换电路 [9]。

最后，看到这里也许你会突然想到Root Complex是不是也可以看成是一个Switch呢？我觉得这两个概念最好还是分开，虽然从很多框图上看着确实很像，只不过Root Complex没有Upstream Port，连接上游的Host Bridge是连接到CPU上，不过Root Complex内部的功能要远比Switch复杂的多，里面不仅仅是简单的包转发，比如，后面会说到的PCIe请求的生成和转换等等。

## pci设备配置空间 configuration space

PCIe中有两类设备：Type 0表示终端设备，和Type 1表示Switch。

- Device ID和Vendor ID寄存器： 这两个寄存器只读，Vendor ID代表PCI设备的生产厂商，而Device ID代表这个厂商所生产的具体设备。如Intel公司的82571EB芯片网卡，其中Vendor ID为0x8086，Device为0x105E。

- Revision ID和Class Code寄存器：这两个寄存器只读。其中Revision ID寄存器记载PCI设备的版本号。该寄存器可以被认为是Device ID的寄存器的扩展。Class Code寄存器记载PCI设备的分类，该寄存器由三个字段组成，分别是Base Class Code、Sub Class Code和Interface。其中Base Class Code讲PCI设备分类为显卡、网卡、PCI桥等设备；Sub Class Code对这些设备进一步细分。Interface定义编程接口。除此之外硬件逻辑设计也需要使用寄存器识别不同的设备。当Base Class Code寄存器为0x06，Sub Class Code寄存器为0x04时，表示当前PCI设备为一个标准的PCI桥。

- Header Type寄存器：该寄存器只读，由8位组成。第7位为1表示当前PCI设备是多功能设备，为0表示为单功能设备。第0~6位表示当前配置空间的类型，为0表示该设备使用PCI Agent设备的配置空间，普通PCI设备都是用这种配置头；为1表示使用PCI桥的配置空间，PCI桥使用这种配置头。系统软件需要使用该寄存器区分不同类型的PCI配置空间。

- Cache Line Size寄存器：该寄存器记录处理器使用的Cache行长度。在PCI总线中和cache相关的总线事务，如存储器写无效等需要使用这个寄存器。该寄存器由系统软件设置，硬件逻辑使用。

- (5)Expansion ROM base address寄存器：有些PCI设备在处理器还没有运行操作系统前，就需要完成基本的初始化。为了实现这个"预先执行"功能，PCI设备需要提供一段ROM程序，而处理器在初始化过程中将运行这段ROM程序，初始化这些PCI设备。Expansion ROM base address寄存器记载这段ROM程序的基地址。

- (6)Capabilities Pointer寄存器：在PCI设备中，该寄存器是可选的，但是在PCIe设备中必须支持这个寄存器，Capabilities Pointer寄存器存放Capabilitise寄存器组的基地址，利用Capabilities寄存器组存放一些与PCI设备相关的扩展配置信息。

- Base Address Register 0~5寄存器：该组寄存器简称为BAR寄存器，BAR寄存器保存PCI设备使用的地址空间的基地址，该基地址保存的是该设备在PCI总线域中的地址。在PCI设备复位之后，该寄存器存放PCI设备需要使用的基址空间大小，这段空间是I/O空间还是存储器空间。系统软件可以使用该寄存器，获取PCI设备使用的BAR空间的长度，其方法是向BAR寄存器写入0xFFFFFFFF，之后在读取该寄存器。


这块空间的大小是4096字节，其中头部和PCI3.0保持兼容，有64个字节，这块空间的大小是固定的，不会随着设备的类型或者系统的重启而改变。

PCIe扩展了配置空间大小，最大支持到4K。其中：

1) 0 - 3Fh 是基本配置空间，PCI和PCIe都支持，pci3.0 conpatible configuration space header

2) PCI Express Capability Structure ，PCI可选支持，PCIe支持

3) PCI Express Extended Capability Structure，PCI不支持，PCIe支持

利用IO的访问方式只能访问256Byte空间，所以为了访问4K Byte，支持通过mmio的方式访问配置空间，但是为了兼容性，保留了I/O访问方式。

在系统启动时，BIOS会通过ACPI（Advanced Configuration and Power Interface）找到所有的PCIe设备，并为其分配配置空间，映射到物理地址空间中，然后通过ECAM（Enhanced Configuration Access Mechanism）转交给操作系统。我们通过acpidump对MCFG表进行导出，然后使用iasl就可以查看到ECAM的基址了：

```shell
# Dump MCFG table from ACPI as binary file: mcfg.dat
$ sudo acpidump -n MCFG -b

# Disassemble MCFG table
$ iasl ./mcfg.dat; cat mcfg.dsl
...
[000h 0000   4]                    Signature : "MCFG"    [Memory Mapped Configuration table]
...
[02Ch 0044   8]                 Base Address : 00000000E0000000
```

而为了方便访问，PCIe使用BDF来构造每个配置空间相对于ECAM的偏移。由于每个空间都是4096个字节，所以PCIe将BDF向左移位了12位，对其进行预留。打个比方，如果某个设备的BDF是46:00.1，ECAM基址是0xE0000000，那么其配置空间起始地址就是：0xE0000000 + (0x46 << 20) | (0x00 << 15) | (0x01 << 12) = 0xE46001000。或者简单的记忆就是BDF的Hex后面跟三个0。我们这里也可以通过lspci和/dev/mem进行直接的物理内存访问来验证.
```shell
$ lspci -s 46:00.1  -nn
46:00.1 Ethernet controller [0200]: Broadcom Inc. and subsidiaries NetXtreme BCM5720 Gigabit Ethernet PCIe [14e4:165f]

$ sudo hexdump -x --skip 0xe4601000 /dev/mem | head
e4601000    14e4    165f    0406    0010    0000    0200    0010    0080
```

这段内存的前面几个数字14e4和165f就是这个设备的Vendor ID和Device ID，这和我们通过lspci看到的完全一致：[14e4:165f]。

当然，每次这样进行计算和转换来查看原始的配置空间是非常麻烦的，所以我们可以通过setpci来直接访问：
```shell
$ setpci -s 46:00.1 00.w
14e4

$ setpci -s 46:00.1 02.w
165f
```
使用`setpci`的时候需要注意：无论是读取和写入，请务必按照目标字段的长度来进行输入，PCIe的内存地址的IO并不一定是内存的读取，而有可能被转换成PCIe的请求，如果长度不对，则很有可能出现错误。


## BAR-type0

BAR（Base Address Registers）和MMIO（Memory Mapped IO）是两个非常重要的概念。

BAR（Base Address Registers）：BAR是PCIe设备与主机之间通信的基础，它用于标识PCIe设备需要的资源，包括I/O端口和内存地址。每个设备可以拥有多个BAR，每个BAR可以对应一个I/O或内存资源。主机通过读取设备的BAR寄存器，可以获取该设备所占用的资源的起始地址和大小等信息。

在Type 0的配置空间中，BAR区域有24个字节，可以保存6个指针/地址，每一个都可以用来描述一个不同的内存空间或者IO空间的地址和范围。

地址空间结构：

- 最低位Bit 0：是一个标志位，用于描述地址空间的类型，0表示内存空间，1表示IO空间
- Memory Space中的Bit [2:1] - Type：用于描述内存空间的类型，00表示32位地址空间，10表示64位地址空间
- Memory Space中的Bit 3 - Prefetchable：用于描述内存空间是否支持预取，0表示不支持，1表示支持。如果一段内存空间支持预取，它意味着读取时不会产生任何副作用，所以CPU可以随时将其预取到DRAM中。而如果预取被启用，在读取数据时，内存控制器也会先去DRAM查看是否有缓存。当然，这是一把双刃剑，如果数据本身不支持预取，那么除了可能导致数据不一致，多一次DRAM的查询还会导致速度下降。

另外也许你会觉得很奇怪，一个32位的空间，又是如何又表示地址又表示范围呢？这里其实和BAR的初始化过程有关。BAR的寄存器初始化主要有三步 [1]（7.5.1.2.1 Base Address Registers）：

- BIOS将全1的地址写入BAR寄存器，这样会导致BAR寄存器的值被重置，并被设备重新写入初始值。这个初始值是一个地址，表示如果将这个BAR寄存器指向的内存放在物理内存的最后，其地址为多少。比如，如果我们需要4KB的内存空间，那么这个地址就是0xFFFFF000，当然这里还需要加上最低几位表示类型的Flag。另外，如何这个空间不可用，那么返回全0。
- BIOS读取BAR寄存器的值，并去除掉最后几位Flag，然后将其取反并加1，求出其大小。比如0xFFFFF000，取反之后就是0x00000FFF，加1之后就是0x00001000，也就是4KB。
- BIOS接着进行真正的地址分配和映射，并将这个新的地址重新写入BAR。这个时候设备没有权利拒绝这个修改，并且也不能再对这个地址进行任何的更改了，不然系统可能会整个崩溃。

在这样的握手之后，我们就通过BAR中这一个地址大小的空间，又表示了地址，又传递了大小了。

对于BAR空间中保存的所有的地址，我们都可以通过lspci来查看到：
```shell
$ sudo lspci -s 81:00.0 -nn -vv
81:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104 [GeForce RTX 2080] [10de:1e82] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: Gigabyte Technology Co., Ltd TU104 [GeForce RTX 2080] [1458:37c1]
        ...
        Region 0: Memory at f0000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at 20030000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at 20040000000 (64-bit, prefetchable) [size=32M]
        Region 5: I/O ports at b000 [size=128]
        ...
```

从上面我们可以看到，这块显卡中有4个地址空间，三块是内存空间，一块是I/O空间。Region的编号表示其地址在BAR中间的偏移，比如Region 1就是BAR中的第二个DWORD，Region 3就是BAR中的第4个DWORD（Region 1是64位，所以需要占用8个字节），以此类推。这里我们也可以把原始的物理内存dump出来，进行验证。

`hexdump -C --skip 0xe8100000 /dev/mem |head`


MMIO（Memory Mapped IO）：MMIO是一种通过内存地址来访问I/O设备的机制。在PCIe设备中，MMIO用于访问设备的寄存器、配置空间和DMA缓冲区等，主机通过MMIO读写这些资源。MMIO访问与传统I/O端口访问不同，I/O端口访问是通过out/in指令进行的，而MMIO访问则是通过读写内存地址来完成的。

在PCIe设备中，MMIO通常是通过访问设备的BAR来实现的。设备的BAR中存储了一段物理内存地址，主机通过MMIO读写这个地址就可以访问设备的资源。当主机进行MMIO访问时，CPU会将访问请求路由到PCIe设备，设备进行相应的处理并返回结果。

## type-1桥
作为Switch，它并不需要也不会实现特定的功能，它的作用就是为PCIe的消息提供路由转发的机制，所以中间所有的字段几乎都变成了和路由转发相关的地址信息。

- Primary Bus Number / Secondary Bus Number / Subordinate Bus Number：用于基于BDF的转发
- Memory Base / Memory Limit：用于基于内存空间地址的转发
- Prefetchable Memory Base (Upper) / Prefetchable Memory Limit (Upper)：也是用于基于内存空间地址的转发，不过是Prefetchable的地址
- IO Base / IO Limit：用于基于IO空间地址的转发

### PCIe的遍历（PCIe Enumeration）
整个PCIe的遍历过程其实是一个简单的DFS和线段树，拿上图的BDF来举例子，每一个Bridge中都保存着三个用于路由的关键信息：

- Primary Bus Number（Pri）：这个Bridge所在的Bus Number，也就是它的上游连接的Bus Number
- Secondary Bus Number（Sec）：这个Bridge所连接的下一个Bridge的Bus Number
- Subordinate Bus Number（Sub）：这个Bridge所连接的下游所有的Bus的最大的Bus Number

这些信息形成了一个递归的结构来帮助我们进行基于BDF进行路由，而PCIe的遍历就是来建立这个递归的结构。我们来看看上图中的遍历过程：

1. 首先，我们从Root Complex的Host Bridge出发。Host Bridge略有不同，因为他的上游没有连接任何总线，所以没有Pri，它的下游连接的是Root Complex中的总线，也就是Bus 0，所以我们的遍历从Bus 0开始，此时Host Bridge中的Sec是0。另外，虽然此时Sub未知，但是为了安全，在向下遍历的过程中，我们会把Sub设置为最大值，也就是0xFF，这样即便是出错，我们也不会出现无法路由的情况。
2. 然后，我们遍历到了Root Complex中的第一个Bridge，很明显它的Pri是0。由于桥接的原因，它的下游总线的Bus Number要保证唯一，于是我们加1，所以它的Sec是1，同样Sub还是改为0xFF。
3. 然后，我们继续递归，到了第一个Switch的Upstream Bridge，因为它所连接的Bus Number是1，所以它的Pri是1，而同理，它的下游会连接到它的内部总线，于是需要把Bus Number再加1，变成2，于是Sec为2。
4. 继续递归到第一个Downstream Bridge，同样它的下游的Bus Number需要加一，于是Pri为2，Sec为3。
5. 继续递归，到了第一个Endpoint，它的下游没有任何设备，所以开始回溯。
6. 回到了步骤4所在的Bridge，此时最大的Bus Number为3，所以Sub更新为3，最后Pri为3，Sec为3，Sub为3。
7. 同理，第二个Bridge的Pri为3，Sec为4，Sub为4。
8. 然后回到步骤3访问的Bridge，此时最大的Bus Number为4，所以Sub更新为4，最后Pri为1，Sec为2，Sub为4。
9. 依次类推，直到所有的设备完成。

等所有的步骤结束，我们就会得到上面这张图中对应的分配了！类似的，内存的空间，IO的地址空间，Prefetchable的地址空间，都会进行类似的遍历和分配，然后把最后合并的区间保存在上游的配置空间中，这样大家应该就理解了为什么配置空间中只需要保存一个区间就可以进行路由了，而不需要保存复杂的路由表了。

另外，PCIe的热插拔其实就是靠在遍历过程中预留更多的Bus Number来实现的，这样就可以在不影响已有设备的情况下，插入新的设备了。

### 消息路由
现在，有了上面的路由信息，我们就可以很轻松的来对PCIe的消息进行路由了！它其实就是一个非常简单的线段树，我们假设需要将一个消息从CPU发给BDF为04:00.0的设备，那么其路由过程如下：

1. 首先，CPU会请求Host Bridge产生消息，然后由于Bus 4在第一个Bridge的Sec和Sub之间，Root Complex会将这个消息通过这个Bridge转发出去。
2. 然后继续递归，这个消息将通过Bus 1传递给下游Switch中的连接上游总线的Bridge。而这个Switch会来检查它下游所有Bridge的配置，最后发现Bus 4在它的第二个下游Bridge的Sec和Sub之间，于是这个Switch会将这个消息通过这个Bridge转发出去。
3. 消息经过Bus 4到达Function 04:00.0。

### 配置空间访问流程
为了总结，我们就从CPU出发，用对配置空间的读请求做一个例子，来对整体的流程来一个总结吧！

1. 首先，CPU执行内存访问指令来读取虚拟内存中映射的，在ECAM中的，某个配置空间的内容。比如：mov ax, [0x10e8100000]。
2. 然后，这个读请求的地址经过MMU，查询页表得到物理内存的地址。假设，这个物理地址是BDF为 81:00.0 的设备的配置空间地址：0xe8100000。
3. 这个读请求会被发送给Memory Controller，Memory Controller检查这个地址之后，发现这个地址不属于DRAM，于是转发给对应的PCIE控制器，到Root Complex中。
4. Root Complex的Host Bridge收到这个请求，发现这个请求属于设备的配置空间，于是将这个请求转换为一个配置空间的读请求（请求名称叫CfgR0，具体的结构后面会介绍），地址是BDF 81:00.0，Offset是0，长度是2个字节，并利用BDF开始路由。
5. Root Complex根据所有连接到其上面的设备和桥的配置空间里的配置，将这个请求转发给对应的设备。如果是设备本身就检查Device Number和Function Number，如果是桥，就检查Secondary Bus Number和Subordinate Bus Number，然后进行递归的转发。
6. 最后，请求到达设备。

数据返回的流程和请求的流程非常类似，只不过是从设备出发，返回给CPU，这里就不再赘述了。

## 初始化

PCI子系统初始化：PCI子系统的初始化是通过调用pci_init()函数完成的。这个函数主要是对PCI总线进行初始化，包括创建根总线、设置PCI驱动器程序、初始化PCI设备树等。

PCI驱动程序注册：当PCI子系统初始化完成后，PCI驱动程序开始进行注册。每个PCI驱动程序都是一个结构体，其中包含了所支持的设备ID、对应的设备的操作函数等信息。调用pci_register_driver()函数完成PCI驱动程序的注册。

PCI设备枚举：PCI设备枚举是PCI框架中非常重要的一个环节，它通过PCI总线上扫描每个设备的配置寄存器，以便确定设备的类型、功能、资源需求等信息。在这个过程中，PCI框架会调用PCI驱动程序的probe()函数，该函数会检测设备是否支持该驱动程序，并初始化设备（例如设备的I/O、内存、中断等资源）。

PCI设备树建立：在PCI设备枚举的过程中，PCI框架会根据设备的PCI地址（包括总线号、设备号、函数号）建立PCI设备树。每个设备节点包含了该设备的PCI地址、资源分配情况和驱动程序等信息。

PCI驱动程序初始化：当PCI设备枚举和设备树建立完成后，PCI框架会调用PCI驱动程序的初始化函数init()，该函数对设备进行进一步的初始化操作。例如，设备的中断注册、DMA设置等。

PCI设备注册：当PCI驱动程序初始化完成后，PCI框架会将该设备注册到系统中。注册完成后，系统就可以对设备进行正确的使用和管理。

PCI总线扫描结束：PCI总线扫描结束后，系统就可以正确地访问PCI设备和它们的资源了。此时，系统可以通过读写PCI设备的配置空间进行设备的操作，也可以应用系统提供的API来访问设备的资源。


## 数据结构

- struct pci_dev：这个结构体代表PCIe设备，其中包含这个设备的设备ID、厂商ID、类别码、子类别码、寻址信息、中断信息等。此外，这个结构体还包含一些函数指针，如probe和remove，用于设备的驱动注册和卸载。
- struct pci_driver：这个结构体代表PCIe设备的驱动，其中包含这个驱动支持的设备ID列表、驱动的名称、probe函数和remove函数等。当内核检测到一个PCIe设备时，会遍历所有已注册的驱动，找到匹配的驱动进行设备驱动的注册和初始化。
- struct pci_bus：这个结构体代表PCIe总线，其中包含了这个总线上所有设备的枚举信息和资源分配信息。
- struct pci_dev_resource：这个结构体代表PCIe设备的资源，如IO空间、内存空间、中断等。此外，这个结构体还包含一些函数指针，如request和release，用于资源的申请和释放。资源的起始地址和长度：pci_dev_resource结构中的start和end字段描述了该资源的物理地址范围。在x86架构中，这些地址通常是I/O地址或内存地址。length字段描述了该资源的长度。资源的描述符：res字段是指向该资源的描述符的指针。该描述符包含有关资源的详细信息，例如资源的类型、寻址模式和访问权限等。硬件资源类型：pci_dev_resource结构中的flags字段描述了该资源的类型，例如I/O端口、内存空间或中断线。
- struct pci_host_bridge：这个结构体代表PCIe主机桥，这是一个虚拟设备，用于管理整个PCIe总线。它包含一些与PCIe总线相关的信息和函数指针，如add_bus和remove_bus，用于扩展和移除PCIe总线上的设备。



ref: http://r12f.com/posts/pcie-2-config
http://r12f.com/posts/pcie-1-basics/