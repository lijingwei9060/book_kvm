# DMAR ACPI Table结构
在系统上电的时候，BIOS/UEFI负责检测并初始化DMAR（即VT-d硬件），为其分配相应的物理地址，并且以ACPI表中的DMAR（DMA Remapping Reporting）表的形式告知VT-d硬件的存在。
DMAR的格式如下所示，先是标准的APCI表的表头，然后是Host Address Width表示该系统中支持的物理地址宽度；标志字节Flag表示VT-d硬件支持的一些功能，最后是Remapping Structures，即一堆有组织的结构体用来描述VT-d硬件的功能.







