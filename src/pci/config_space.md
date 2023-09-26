# 介绍

配置空间总体分为两类，type0 (END point)， type1（bridge） ，pcie由pci发展过来，pci的空间只有256个字节，PCIE扩展到4K的空间，所以根据BUS DEVICE FUNCTION，配置空间最大256 * 32 * 8预留16M的空间

规范: 
每个PCIe设备可以有1个function也可以有最多8个Function，每个Function都有一个唯一的配置空间。

pci 配置空间256字节：
1. pci config header 64字节： 分为type0 endpoint 设备，type1 pci-pci桥， type2位pci-cardbus桥。
作用: 配置pci设备和功能的地址空间。
- Vendor ID(16bit RO 00H)代表PCI设备的生产厂商。如Intel公司的82571EB芯片网卡，其中Vendor ID为0x8086，Device为0x105E。
- Device ID(16bit RO 02H)代表这个厂商所生产的具体设备。device ID全部为F的表示无效设备，需要跳过。
- Command(16bit   04H)
- Status(16bit    06H)
- Revision ID(8bit RO 08H)记载PCI设备的版本号。
- Class Code(24bit RO 09H)可以被认为是Device ID的寄存器的扩展。Class Code寄存器记载PCI设备的分类，该寄存器由三个字段组成，分别是Base Class Code、Sub Class Code和Interface。其中Base Class Code讲PCI设备分类为显卡、网卡、PCI桥等设备；Sub Class Code对这些设备进一步细分。Interface定义编程接口。除此之外硬件逻辑设计也需要使用寄存器识别不同的设备。当Base Class Code寄存器为0x06，Sub Class Code寄存器为0x04时，表示当前PCI设备为一个标准的PCI桥。
- Cache Line Size(8bit RW 0CH)：该寄存器记录处理器使用的Cache行长度。在PCI总线中和cache相关的总线事务，如存储器写无效等需要使用这个寄存器。该寄存器由系统软件设置，硬件逻辑使用。
- Primary Latency Timer(8bit RW 0DH)
- Header Type(8bit RO 0EH)：第7位为1表示当前PCI设备是多功能设备，为0表示为单功能设备。第0~6位表示当前配置空间的类型，为0表示该设备使用PCI Agent设备的配置空间，普通PCI设备都是用这种配置头；为1表示使用PCI桥的配置空间，PCI桥使用这种配置头。系统软件需要使用该寄存器区分不同类型的PCI配置空间。
- BIST(8bit 0FH)
- Base Address Register(32bit*6   10H)BAR寄存器保存PCI设备使用的地址空间的基地址，该基地址保存的是该设备在PCI总线域中的地址。在PCI设备复位之后，该寄存器存放PCI设备需要使用的基址空间大小，这段空间是I/O空间还是存储器空间。系统软件可以使用该寄存器，获取PCI设备使用的BAR空间的长度，其方法是向BAR寄存器写入0xFFFFFFFF，之后在读取该寄存器。
- Cardbus CIS Pointer(32bit   28H)
- Subsystem Vendor ID(16bit RO 2CH)
- Subsystem ID(16bit RO 2EH)
- Expansion ROM base address(32bit  30H)：有些PCI设备在处理器还没有运行操作系统前，就需要完成基本的初始化。为了实现这个"预先执行"功能，PCI设备需要提供一段ROM程序，而处理器在初始化过程中将运行这段ROM程序，初始化这些PCI设备。Expansion ROM base address寄存器记载这段ROM程序的基地址。
- Capabilities Pointer(8bit 34H)：在PCI设备中，该寄存器是可选的，但是在PCIe设备中必须支持这个寄存器，Capabilities Pointer寄存器存放Capabilitise寄存器组的基地址，利用Capabilities寄存器组存放一些与PCI设备相关的扩展配置信息。
- Interrupt Line(8bit 3CH)
- Interrupt Pin(8bit 3DH)
- Min_Gnt(8bit 3EH)
- Max_Lat(8bit 3FH)

对于p2p的桥，从BAR1后开始不同：
- Primary Bus Number(8bit 18H)
- Secondary Bus Number(8bit RW 19H)
- SubOrdinate Bus Number(8bit RW 1AH)
- Secondary Latency Timer(8bit RW 1BH)
- IOBase(8bit  RW 1CH)
- IO Limit(8bit RW 1DH)
- Secondary Status(16bit RW 1EH)
- Memory Base(16bit RW 20H)
- Memory Limit(16bit rw 22H)

2. PCI Device Specific Register(192字节)
3. PCIe 
内容


## BAR

BAR是PCI配置空间中从0x10 到 0x24的6个register，用来定义PCI需要的配置空间大小以及配置PCI设备占用的地址空间。每个PCI设备在BAR中描述自己需要占用多少地址空间，UEFI通过所有设备的这些信息构建一张完整的关系图，描述系统中资源的分配情况，然后在合理的将地址空间配置给每个PCI设备。
1. Memory Space Indicator: bit0来表示该设备是映射到memory还是IO，bar的bit0是readonly的，也就是说，设备寄存器是映射到memory还是IO是由设备制造商决定的，其他人无法修改。
2. 


## BAR-type0

BAR（Base Address Registers）和MMIO（Memory Mapped IO）是两个非常重要的概念。

BAR（Base Address Registers）：BAR是PCIe设备与主机之间通信的基础，它用于标识PCIe设备需要的资源，包括I/O端口和内存地址。每个设备可以拥有多个BAR，每个BAR可以对应一个I/O或内存资源。主机通过读取设备的BAR寄存器，可以获取该设备所占用的资源的起始地址和大小等信息。

在Type 0的配置空间中，BAR区域有24个字节，可以保存6个指针/地址，每一个都可以用来描述一个不同的内存空间或者IO空间的地址和范围。Type1的配置空间有2个BAR地址区域。

地址空间结构：

- 最低位Bit 0：是一个标志位，用于描述地址空间的类型，0表示内存空间，1表示IO空间
- Memory Space中的Bit [2:1] - Type：用于描述内存空间的类型，00表示32位地址空间，10表示64位地址空间
- Memory Space中的Bit 3 - Prefetchable：用于描述内存空间是否支持预取，0表示不支持，1表示支持。如果一段内存空间支持预取，它意味着读取时不会产生任何副作用，所以CPU可以随时将其预取到DRAM中。而如果预取被启用，在读取数据时，内存控制器也会先去DRAM查看是否有缓存。当然，这是一把双刃剑，如果数据本身不支持预取，那么除了可能导致数据不一致，多一次DRAM的查询还会导致速度下降。

一个32位的空间，又是如何又表示地址又表示范围呢？这里其实和BAR的初始化过程有关。BAR的寄存器初始化主要有三步 [1]（7.5.1.2.1 Base Address Registers）：

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


## Capabilities结构

PCI-X和PCIe总线规范要求其设备必须支持Capabilities结构。在PCI总线的基本配置空间中，包含一个Capabilities Pointer寄存器，该寄存器存放Capabilities结构链表的头指针。在一个PCIe设备中，可能含有多个Capability结构，这些寄存器组成一个链表。

PCIe的各种特性如Max Payload、Complete Timeout(CTO)等等都通过这个链表链接在一起，Capabilities ID由PCIe spec规定。链表的好处是如果你不关心这个Capabilities（或不知道怎么处理），直接跳过，处理关心的即可，兼容性比较好。另外扩展性也强，新加的功能不会固定放在某个位置，淘汰的功能删掉即好。

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

Capabilities list: 

- Null Capability (00h)
- PCI Power Management Interface (01h)
- AGP (02h)
- VPD (03h)
- Slot Identification (04h)
- Message Signaled Interrupts (05h)
- CompactPCI Hot Swap (06h)
- PCI-X (07h)
- HyperTransport (08h)
- Vendor Specific (09h)
- Debug port (0Ah)
- CompactPCI central resource control (0Bh)
- PCI Hot-Plug (0Ch)
- PCI Bridge Subsystem Vendor ID (0Dh)
- AGP 8x (0Eh)
- Secure Device (0Fh)
- PCI Express (10h)
- MSI-X (11h)
- Serial ATA Data/Index Configuration (12h)
- Advanced Features (13h)
- Enhanced Allocation (14h)
- Flattening Portal Bridge (15h)

Extended Capabilities list:

- Null Capability (0000h)
- Advanced Error Reporting (AER) (0001h)
- Virtual Channel (VC) (0002h) - used if an MFVC Extended Cap structure is not present in the - device
- Device Serial Number (0003h)
- Power Budgeting (0004h)
- Root Complex Link Declaration (0005h)
- Root Complex Internal Link Control (0006h)
- Root Complex Event Collector Endpoint Association (0007h)
- Multi-Function Virtual Channel (MFVC) (0008h)
- Virtual Channel (VC) (0009h) – used if an MFVC Extended Cap structure is present in the device
- Root Complex Register Block (RCRB) Header (000Ah)
- Vendor-Specific Extended Capability (VSEC) (000Bh)
- Configuration Access Correlation (CAC) (000Ch)
- Access Control Services (ACS) (000Dh)
- Alternative Routing-ID Interpretation (ARI) (000Eh)
- Address Translation Services (ATS) (000Fh)
- Single Root I/O Virtualization (SR-IOV) (0010h)
- Multi-Root I/O Virtualization (MR-IOV) (0011h)
- Multicast (0012h)
- Page Request Interface (PRI) (0013h)
- Reserved for AMD (0014h)
- Resizable BAR (0015h)
- Dynamic Power Allocation (DPA) (0016h)
- TPH Requester (0017h)
- Latency Tolerance Reporting (LTR) (0018h)
- Secondary PCI Express (0019h)
- Protocol Multiplexing (PMUX) (001Ah)
- Process Address Space ID (PASID) (001Bh)
- LN Requester (LNR) (001Ch)
- Downstream Port Containment (DPC) (001Dh)
- L1 PM Substates (001Eh)
- Precision Time Measurement (PTM) (001Fh)
- PCI Express over M-PHY (M-PCIe) (0020h)
- FRS Queuing (0021h)
- Readiness Time Reporting (0022h)
- Designated Vendor-Specific Extended Capability (0023h)
- VF Resizable BAR (0024h)
- Data Link Feature (0025h)
- Physical Layer 16.0 GT/s (0026h)
- Lane Margining at the Receiver (0027h)
- Hierarchy ID (0028h)
- Native PCIe Enclosure Management (NPEM) (0029h)
- Physical Layer 32.0 GT/s (002Ah)
- Alternate Protocol (002Bh)
- System Firmware Intermediary (SFI) (002Ch)
- Shadow Functions (002Dh)
- Data Object Exchange (002Eh)
- Device 3 (002Fh)
- Integrity and Data Encryption (IDE) (0030h)
- Physical Layer 64.0 GT/s Capability (0031h)
- Flit Logging (0032h)
- Flit Performance Measurement (0033h)
- Flit Error Injection (0034h)


## MSI-X

MSI-X Table: 中存放着所有PCIE 设备的中断向量号, 每个Entry 代表一个中断向量16个字节，Msg Data 中包括了中断向量号，Msg Addr 中通常包含了多核CPU用于处理 中断的 Local APIC 编号。访问第N个Entry地址为： n_entry_address = base adress[BAR] + 16 *n。

Entry = struct msi_msg(lower address + upper address + data) + ctl flag

msi_msg - Representation of a MSI message
1. address_lo:		Low 32 bits of msi message address
2. address_hi:		High 32 bits of msi message address
3. data:		MSI message data (usually 16 bits)


## 如何管理


1. pci_read_config_word 来读取PCIE EP（end point）设备的配置空间信息。

## 对配置空间的访问
x86架构中pci配置空间的访问有4种方式：pci_bios、pci_conf1、pci_conf2、pci_mmcfg。最优的方式是mmcfg，这需要bios配置，把pci配置空间映射到cpu mem空间；pci_conf1、pci_conf2方式是通过io指针间接访问的；pci_bios方式应该是调用bios提供的服务进程进行访问。使用I/O访问的方式只可以访问配置空间的前256字节，而使用mmcfg的方式则可以完全支持PCIE的扩展寄存器即4K字节的配置空间。在linux初始化的时候，需要给驱动程序选择一种最优的访问方式。


系统在初始化PCI总线的时候，会设置好读取配置空间的方法，读取的方式就上述的两大类（I/O端口访问、MEM访问），提供给上层的可用接口函数是read函数和write函数，系统初始化完成后会将实现好的read方法和write方法绑定至结构体pci_ops


const struct pci_raw_ops *raw_pci_ops; //pci设备访问,访问范围小于256
const struct pci_raw_ops *raw_pci_ext_ops; //pcie设备扩展寄存器访问
const struct pci_raw_ops pci_mmcfg;
const struct pci_raw_ops pci_direct_conf1;


## IO地址空间

cat /proc/ioports

外设寄存器也称为I/O端口，通常包括：控制寄存器、状态寄存器和数据寄存器三大类。根据访问外设寄存器的不同方式，可以把CPU分成两大类。一类CPU（如M68K，Power PC等）把这些寄存器看作内存的一部分，寄存器参与内存统一编址，访问寄存器就通过访问一般的内存指令进行，所以，这种CPU没有专门用于设备I/O的指令。这就是所谓的“I/O内存”方式。另一类CPU（典型地如X86）将外设的寄存器看成一个独立的地址空间，所以访问内存的指令不能用来访问这些寄存器，而要为对外设寄存器的读／写设置专用指令，如IN和OUT指令。这就是所谓的” I/O端口”方式 。但是，用于I/O指令的“地址空间”相对来说是很小的。事实上，现在x86的I/O地址空间已经非常拥挤。但是，随着计算机技术的发展，单纯的I/O端口方式无法满足实际需要了，因为这种方式只能对外设中的几个寄存器进行操作。而实际上，需求在不断发生变化，例如，在PC上可以插上一块图形卡，有2MB的存储空间，甚至可能还带有ROM,其中装有可执行代码。自从PCI总线出现后，不管是CPU的设计采用I/O端口方式还是I/O内存方式，都必须将外设卡上的存储器映射到内存空间，实际上是采用了虚存空间的手段，这样的映射是通过ioremap（）来建立的。IO地址空间的大小是4GB（32bits）。

in、out、ins和outs汇编语言指令都可以访问I/O端口。内核中包含了以下辅助函数来简化这种访问：

- inb( )、inw( )、inl( )：分别从I/O端口读取1、2或4个连续字节。后缀“b”、“w”、“l”分别代表一个字节（8位）、一个字（16位）以及一个长整型（32位）。
- inb_p( )、inw_p( )、inl_p( )：分别从I/O端口读取1、2或4个连续字节，然后执行一条“哑元（dummy，即空指令）”指令使CPU暂停。
- outb( )、outw( )、outl( )：分别向一个I/O端口写入1、2或4个连续字节。
- outb_p( )、outw_p( )、outl_p( )：分别向一个I/O端口写入1、2或4个连续字节，然后执行一条“哑元”指令使CPU暂停。
- insb( )、insw( )、insl( )：分别从I/O端口读入以1、2或4个字节为一组的连续字节序列。字节序列的长度由该函数的参数给出。
- outsb( )、outsw( )、outsl( )：分别向I/O端口写入以1、2或4个字节为一组的连续字节序列。

内核必须使用`resource`来记录分配给每个硬件设备的I/O端口。资源表示某个实体的一部分，这部分被互斥地分配给设备驱动程序。在这里，资源表示I/O端口地址的一个范围。每个资源对应的信息存放在resource数据结构中。所有的同种资源都插入到一个树型数据结构（父亲、兄弟和孩子）中；例如，表示I/O端口地址范围的所有资源都包括在一个根节点为ioport_resource的树中。

```C
struct resource {
    resource_size_t start; // 资源范围的开始
    resource_size_t end;   // 资源范围的结束
    const char *name;      // 拥有着的名字
    unsigned long flags;   // 标记
    struct resource *parent, *sibling, *child; // 父亲 兄弟 孩子
};
```

为什么使用树？例如，考虑一下IDE硬盘接口所使用的I/O端口地址－比如说从0xf000 到 0xf00f。那么，start字段为0xf000 且end 字段为0xf00f的这样一个资源包含在树中，控制器的常规名字存放在name字段中。但是，IDE设备驱动程序需要记住另外的信息，也就是IDE链主盘使用0xf000 到 0xf007的子范围，从盘使用0xf008 到 0xf00f的子范围。为了做到这点，设备驱动程序把两个子范围对应的孩子插入到从0xf000 到 0xf00f的整个范围对应的资源下。一般来说，树中的每个节点肯定相当于父节点对应范围的一个子范围。I/O端口资源树(ioport_resource)的根节点跨越了整个I/O地址空间（从端口0到65535）。

request_resource( )：把一个给定范围分配给一个I/O设备。
allocate_resource(  )：在资源树中寻找一个给定大小和排列方式的可用范围；若存在，将这个范围分配给一个I/O设备（主要由PCI设备驱动程序使用，可以使用任意的端口号和主板上的内存地址对其进行配置）。
release_resource(  )：释放以前分配给I/O设备的给定范围。

把I/O端口映射到内存空间： 
 void *ioport_map(unsigned long port, unsigned int count)：通过这个函数，可以把port开始的count个连续的I/O端口重映射为一段“内存空间”。然后就可以在其返回的地址上像访问I/O内存一样访问这些I/O端口。
但请注意，在进行映射前，还必须通过request_region( )分配I/O端口。

void ioport_unmap(void *addr)：当不再需要这种映射时，需要调用下面的函数来撤消

读I/O内存：
unsigned int ioread8(void *addr);
unsigned int ioread16(void *addr);
unsigned int ioread32(void *addr);
unsigned readb(address);
unsigned readw(address);
unsigned readl(address);

写I/O内存
void iowrite8(u8 value, void *addr);
void iowrite16(u16 value, void *addr);
void iowrite32(u32 value, void *addr);

void writeb(unsigned value, address);
void writew(unsigned value, address);
void writel(unsigned value, address);

struct resource *requset_mem_region(unsigned long start, unsigned long len,char *name)：   这个函数从内核申请len个内存地址（在3G~4G之间的虚地址），而这里的start为I/O物理地址，name为设备的名称。注意，。如果分配成功，则返回非NULL，否则，返回NULL。
另外，可以通过/proc/iomem查看系统给各种设备的内存范围。

void release_mem_region(unsigned long start, unsigned long len)：  要释放所申请的I/O内存，应当使用release_mem_region（）函数：

申请一组I/O内存后，  调用ioremap()函数：
void * ioremap(unsigned long phys_addr, unsigned long size, unsigned long flags);
其中三个参数的含义为：
phys_addr：与requset_mem_region函数中参数start相同的I/O物理地址；
size：要映射的空间的大小；
flags：要映射的IO空间的和权限有关的标志；
功能： 将一个I/O地址空间映射到内核的虚拟地址空间上(通过release_mem_region（）申请到的)

## MMIO

PCIe总线中有两种MMIO：P-MMIO和NP-MMIO。P-MMIO，即可预取的MMIO（Prefetchable MMIO）；NP-MMIO，即不可预取的MMIO（Non-Prefetchable MMIO）。其中P-MMIO读取数据并不会改变数据的值。

Prefetchable MMIO：将MMIO的一个区域设置为可预取的，允许CPU提前获取该区域中的数据，以预测请求者在不久的将来可能需要比实际请求更多的数据。对数据进行这种小规模缓存是安全的，因为读取数据不会改变目标设备上的任何状态信息。也就是说，读取位置的行为没有副作用。例如，如果请求者请求从一个地址读取128个字节，则Completer可能也会预取下一个128字节，以便在被请求时将其放在手边以提高性能。因此可预取必须有两个特性：读数据无副作用和允许写合并（您可能想知道哪种内存空间可能会产生副作用?一个例子是内存映射状态寄存器，它被设计成在读取时自动清除自身，以节省程序员在读取状态后显式清除位的额外步骤）
Non-Prefetchable MMIO：将MMIO的一个区域设置为非预取的，就象FIFO地址影射到内存地址,读取数据以后会引起FIFO指针的改变.另外还象一些中断状态I/O影射到内存,读取这个内存后,可能会清除中断标志等等,所以CPU不可缓存这个内存地址。


void* mmap(void* start,size_t length,int prot,int flags,int fd,off_toffset)：mmap函数用来将内存空间映射到内核空间，tart映射区開始地址，設置為NULL時表示由系統決定，length映射区長度單位，地址自然是sizeof(unsigned long) ，prot設置為PORT_READ|PORT_WRITE表示頁可以被读写；flag指定映射对象类型，MAP_SHARED表示與其他所有映射這個对象的所有进程共享映射空间；fd，/dev/mem文件描述符；offset被映射對象內容的起點。

int munmap(void* start,size_t length)：munmap用来解除这个映射关系

## PCI配置空间读写实现

三个函数都是位于`pci_arch_init()`函数中，该函数的启动等级为3，此函数就是设置整个PCI总线设备配置空间的读写方法。
函数执行前：
pci_probe = 0xf(默认值)
raw_pci_ops = 空
raw_pci_ext_ops = 空
函数执行后：
pci_probe = 0x8
raw_pci_ops = pci_direct_conf1
raw_pci_ext_ops = pci_mmcfg


1. pci_direct_probe：该函数通过pci_probe的值来确定访问方法，有bios、config1、config2、mmconfig，内核引导时的参数为pci_probe????。最终该函数将raw_pci_ops结构体绑定为pci_direct_conf1方法，并返回一个类型码1供后续函数使用
2. pci_mmcfg_early_init：该函数配置了raw_pci_ext_ops方式将其绑定为pci_mmcfg的方式并且同时也重新设置了pci_probe的值，通过添加打印调试信息，我们可以清楚的看到pci_probe前后的变化（对于raw_pci_ext_ops和pci_probe内容操作的函数实际为__pci_mmcfg_init(1)中的pci_mmcfg_arch_init()完成的）。在完成了pci_mmcfg_early_init函数后pci_probe的值变为0x08对PCI_PROBE_MMCONF模式
3. pci_direct_init: 该函数根据pci_direct_probe的返回值来对raw_pci_ops和raw_pci_ext_ops进行设置，由于raw_pci_ext_ops在pci_mmcfg_early_init（）这个函数中已经设置完毕，所以在此无需进行设置，因此该函数直接返回。
4. pci_mmcfg_late_init:此函数的执行等级较后，它是pci_mmcfg的第二次配置，即如果前面pci_mmcfg配置异常则再次配置，此时pci_probe的值为0x8而raw_pci_ext_ops绑定pci_mmcfg，所以表示前面的配置成果，所以如果pci_mmcfg_early_init函数完成了配置那么pci_mmcfg_late_init函数一般就直接返回。


## api
pci_read_config_byte(..)     //8
pci_read_config_word(..)     //16
pci_read_config_dword(..)    //32

pci_write_config_byte(..)
pci_write_config_word(..)
pci_write_config_dword(..)