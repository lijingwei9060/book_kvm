# what

PCI设备有三个相互独立的物理空间地址：存储器地址空间（Memory 地址空间）、I/O地址空间、配置空间地址空间，而配置空间是一个PCI特有的物理空间。系统上电时BIOS检测PCI总线，确定所有连接在PCI连接在PCI总线上的设备以及它们的配置要求，并进行系统配置。所以PCI设备必须实现配置空间，从而实现参数的自动配置。

相关的基本概念可参考如下文章：

【精讲】PCIe基础篇——Memory & IO 地址空间

【精讲】PCIe基础篇——BDF与配置空间

【精讲】PCIe基础篇——BAR配置过程

## 对配置空间的访问
x86架构中pci配置空间的访问有4种方式：pci_bios、pci_conf1、pci_conf2、pci_mmcfg。最优的方式是mmcfg，这需要bios配置，把pci配置空间映射到cpu mem空间；pci_conf1、pci_conf2方式是通过io指针间接访问的；pci_bios方式应该是调用bios提供的服务进程进行访问。使用I/O访问的方式只可以访问配置空间的前256字节，而使用mmcfg的方式则可以完全支持PCIE的扩展寄存器即4K字节的配置空间。在linux初始化的时候，需要给驱动程序选择一种最优的访问方式。


系统在初始化PCI总线的时候，会设置好读取配置空间的方法，读取的方式就上述的两大类（I/O端口访问、MEM访问），提供给上层的可用接口函数是read函数和write函数，系统初始化完成后会将实现好的read方法和write方法绑定至结构体pci_ops


const struct pci_raw_ops *raw_pci_ops; //pci设备访问,访问范围小于256
const struct pci_raw_ops *raw_pci_ext_ops; //pcie设备扩展寄存器访问
const struct pci_raw_ops pci_mmcfg;
const struct pci_raw_ops pci_direct_conf1;


## IO地址空间

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

## 用户接口
cat /proc/ioports

## MMIO

PCIe总线中有两种MMIO：P-MMIO和NP-MMIO。P-MMIO，即可预取的MMIO（Prefetchable MMIO）；NP-MMIO，即不可预取的MMIO（Non-Prefetchable MMIO）。其中P-MMIO读取数据并不会改变数据的值。

Prefetchable MMIO：将MMIO的一个区域设置为可预取的，允许CPU提前获取该区域中的数据，以预测请求者在不久的将来可能需要比实际请求更多的数据。对数据进行这种小规模缓存是安全的，因为读取数据不会改变目标设备上的任何状态信息。也就是说，读取位置的行为没有副作用。例如，如果请求者请求从一个地址读取128个字节，则Completer可能也会预取下一个128字节，以便在被请求时将其放在手边以提高性能。因此可预取必须有两个特性：读数据无副作用和允许写合并（您可能想知道哪种内存空间可能会产生副作用?一个例子是内存映射状态寄存器，它被设计成在读取时自动清除自身，以节省程序员在读取状态后显式清除位的额外步骤）
Non-Prefetchable MMIO：将MMIO的一个区域设置为非预取的，就象FIFO地址影射到内存地址,读取数据以后会引起FIFO指针的改变.另外还象一些中断状态I/O影射到内存,读取这个内存后,可能会清除中断标志等等,所以CPU不可缓存这个内存地址。


void* mmap(void* start,size_t length,int prot,int flags,int fd,off_toffset)：mmap函数用来将内存空间映射到内核空间，tart映射区開始地址，設置為NULL時表示由系統決定，length映射区長度單位，地址自然是sizeof(unsigned long) ，prot設置為PORT_READ|PORT_WRITE表示頁可以被读写；flag指定映射对象类型，MAP_SHARED表示與其他所有映射這個对象的所有进程共享映射空间；fd，/dev/mem文件描述符；offset被映射對象內容的起點。

int munmap(void* start,size_t length)：munmap用来解除这个映射关系

## PCI配置空间读写实现

三个函数都是位于pci_arch_init（）函数中，该函数的启动等级为3，此函数就是设置整个PCI总线设备配置空间的读写方法。
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
