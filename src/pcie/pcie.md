# 概念

在内核中，PCI Express(PCIe)设备的管理框架由多个子系统组成，包括PCIe核心、设备驱动、层次性拓扑结构和电源管理等。

- PCIe核心：负责PCIe总线的探测、初始化、资源分配和设备驱动程序的注册等。在内核中，PCIe核心由PCI子系统和PCIe子系统组成。主要包括PCI子系统和PCIe子系统，以及一些共同的函数和数据结构，如pci_dev、pci_bus、pci_driver等。其中，pci_dev结构体表示一个PCI设备，pci_bus结构体表示一个PCI总线，pci_driver结构体表示一个PCI设备驱动程序。PCI子系统负责PCI总线的探测、资源分配和设备注册等，而PCIe子系统则负责PCIe总线的探测、初始化和设备注册等。
- 设备驱动程序：对不同类型的PCIe设备提供支持。设备驱动程序包括网络设备、存储设备、图形设备和多媒体设备等。主要包括网络设备驱动程序、存储设备驱动程序、图形设备驱动程序和多媒体设备驱动程序等。这些驱动程序使用pci_driver结构体注册到PCI子系统中，以实现对PCIe设备的支持。驱动程序中主要包括与硬件相关的函数和数据结构，以及与内核其他模块的交互函数。
- 层次性拓扑结构：表示与PCIe设备相关的拓扑结构。层次性拓扑结构由PCIe核心自动建立，它提供了PCIe设备的物理连通性和逻辑层次结构，有助于设备驱动程序的管理和维护。
- 电源管理：负责PCIe设备的电源管理，它可以使PCIe设备在不使用时降低功耗，从而延长电池寿命或节省电费。PCIe设备的电源管理由ACPI子系统提供支持。ACPI子系统中包括与硬件相关的函数和数据结构，以及与操作系统其他模块的交互函数。PCIe设备的电源管理可以包括设备的启动、挂起和恢复等。
- 中断处理：PCIe设备的中断处理通常由驱动程序负责。驱动程序使用pci_enable_msi()和pci_enable_msix()函数注册MSI或MSI-X中断，然后使用request_irq()函数注册中断处理函数，以响应设备产生的中断。中断处理函数通常负责处理中断，然后返回以结束中断处理。

总之，内核中的PCIe管理框架提供了一系列的子系统和工具，以帮助开发人员管理和优化PCIe设备的性能，并确保PCIe设备与内核之间的协议兼容性。

## pci设备配置空间

- Device ID和Vendor ID寄存器： 这两个寄存器只读，Vendor ID代表PCI设备的生产厂商，而Device ID代表这个厂商所生产的具体设备。如Intel公司的82571EB芯片网卡，其中Vendor ID为0x8086，Device为0x105E。

- Revision ID和Class Code寄存器：这两个寄存器只读。其中Revision ID寄存器记载PCI设备的版本号。该寄存器可以被认为是Device ID的寄存器的扩展。Class Code寄存器记载PCI设备的分类，该寄存器由三个字段组成，分别是Base Class Code、Sub Class Code和Interface。其中Base Class Code讲PCI设备分类为显卡、网卡、PCI桥等设备；Sub Class Code对这些设备进一步细分。Interface定义编程接口。除此之外硬件逻辑设计也需要使用寄存器识别不同的设备。当Base Class Code寄存器为0x06，Sub Class Code寄存器为0x04时，表示当前PCI设备为一个标准的PCI桥。

- Header Type寄存器：该寄存器只读，由8位组成。第7位为1表示当前PCI设备是多功能设备，为0表示为单功能设备。第0~6位表示当前配置空间的类型，为0表示该设备使用PCI Agent设备的配置空间，普通PCI设备都是用这种配置头；为1表示使用PCI桥的配置空间，PCI桥使用这种配置头。系统软件需要使用该寄存器区分不同类型的PCI配置空间。

- Cache Line Size寄存器：该寄存器记录处理器使用的Cache行长度。在PCI总线中和cache相关的总线事务，如存储器写无效等需要使用这个寄存器。该寄存器由系统软件设置，硬件逻辑使用。

- (5)Expansion ROM base address寄存器：有些PCI设备在处理器还没有运行操作系统前，就需要完成基本的初始化。为了实现这个"预先执行"功能，PCI设备需要提供一段ROM程序，而处理器在初始化过程中将运行这段ROM程序，初始化这些PCI设备。Expansion ROM base address寄存器记载这段ROM程序的基地址。

- (6)Capabilities Pointer寄存器：在PCI设备中，该寄存器是可选的，但是在PCIe设备中必须支持这个寄存器，Capabilities Pointer寄存器存放Capabilitise寄存器组的基地址，利用Capabilities寄存器组存放一些与PCI设备相关的扩展配置信息。

- Base Address Register 0~5寄存器：该组寄存器简称为BAR寄存器，BAR寄存器保存PCI设备使用的地址空间的基地址，该基地址保存的是该设备在PCI总线域中的地址。在PCI设备复位之后，该寄存器存放PCI设备需要使用的基址空间大小，这段空间是I/O空间还是存储器空间。系统软件可以使用该寄存器，获取PCI设备使用的BAR空间的长度，其方法是向BAR寄存器写入0xFFFFFFFF，之后在读取该寄存器。

PCIe扩展了配置空间大小，最大支持到4K。其中：

1) 0 - 3Fh 是基本配置空间，PCI和PCIe都支持

2) PCI Express Capability Structure ，PCI可选支持，PCIe支持

3) PCI Express Extended Capability Structure，PCI不支持，PCIe支持

利用IO的访问方式只能访问256Byte空间，所以为了访问4K Byte，支持通过mmio的方式访问配置空间，但是为了兼容性，保留了I/O访问方式。

## 重要概念

BAR（Base Address Registers）和MMIO（Memory Mapped IO）是两个非常重要的概念。

BAR（Base Address Registers）：BAR是PCIe设备与主机之间通信的基础，它用于标识PCIe设备需要的资源，包括I/O端口和内存地址。每个设备可以拥有多个BAR，每个BAR可以对应一个I/O或内存资源。主机通过读取设备的BAR寄存器，可以获取该设备所占用的资源的起始地址和大小等信息。

MMIO（Memory Mapped IO）：MMIO是一种通过内存地址来访问I/O设备的机制。在PCIe设备中，MMIO用于访问设备的寄存器、配置空间和DMA缓冲区等，主机通过MMIO读写这些资源。MMIO访问与传统I/O端口访问不同，I/O端口访问是通过out/in指令进行的，而MMIO访问则是通过读写内存地址来完成的。

在PCIe设备中，MMIO通常是通过访问设备的BAR来实现的。设备的BAR中存储了一段物理内存地址，主机通过MMIO读写这个地址就可以访问设备的资源。当主机进行MMIO访问时，CPU会将访问请求路由到PCIe设备，设备进行相应的处理并返回结果。

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

