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
