# DMAR ACPI Table结构
在系统上电的时候，BIOS/UEFI负责检测并初始化DMAR（即VT-d硬件），为其分配相应的物理地址，并且以ACPI表中的DMAR（DMA Remapping Reporting）表的形式告知VT-d硬件的存在。
DMAR的格式如下所示，先是标准的APCI表的表头，然后是Host Address Width表示该系统中支持的物理地址宽度；标志字节Flag表示VT-d硬件支持的一些功能，最后是Remapping Structures，即一堆有组织的结构体用来描述VT-d硬件的功能.

##  DMA Remapping Reporting Structure
Field	Byte Length	Byte Offset	Description
Signature	4	0	“DMAR”. Signature for the DMA Remapping Description table.
Length	4	4	Length, in bytes, of the description table including the length of the associated DMAremapping structures.
Revision	1	8	1
Checksum	1	9	Entire table must sum to zero.
OEMID	6	10	OEM ID
OEM Table ID	8	16	For DMAR description table, the Table ID is the manufacturer model ID.
OEM Revision	4	24	OEM Revision of DMAR Table for OEM Table ID.
Creator ID	4	28	Vendor ID of utility that created the table.
Creator Revision	4	32	Revision of utility that created the table.
Host Address Width	1	36	This field indicates the maximum DMA physical addressability supported by this platform. The system address map reported by the BIOS indicates what portions of this addresses are populated.	The Host Address Width (HAW) of the platform is computed as (N+1), where N is the value reported in this field. For example, for a platform supporting 40 bits of physical addressability, the value of 100111b is reported in this field.
Flags	1	37	• Bit 0: INTR_REMAP - If Clear, the platform does not support interrupt remapping. If Set, the platform supports interrupt remapping. Bits 1-7: Reserved.
Reserved	10	38	Reserved (0).
Remapping Structures[]	-	48	A list of structures. The list will contain one or more DMA Remapping Hardware Unit Definition (DRHD) structures, and zero or more Reserved Memory Region Reporting (RMRR) and Root Port ATS Capability Reporting (ATSR) structures. These structures are described below.


## Remapping Structure Types
每个Remapping Structure的开始部分包含type和length两个字段。其中，type表示DMA-remapping structure的类型，而length表示该structure的长度。下表定义了type的可能值：

Value	Description
0	DMA Remapping Hardware Unit Definition (DRHD) Structure
1	Reserved Memory Region Reporting (RMRR) Structure
2	Root Port ATS Capability Reporting (ATSR) Structure
>2	Reserved for future use. For forward compatibility, software skips structures it does not comprehend by skipping the appropriate number of bytes indicated by the Length field.
注：BIOS implementations must report these remapping structure types in numerical order. i.e., All remapping structures of type 0 (DRHD) enumerated before remapping structures of type 1 (RMRR), and so forth.
　BIOS/UEFI负责在初始化系统的时候将这些结构体以类型为顺序有序地组织起来（同种类型的结构体可能有多个，也可能压根就不存在）。第一个结构体必须是DRHD（DMA Remapping Hardware Unit Definition）结构体。

## DRHD（DMA Remapping Hardware Unit Definition）表
一个DMAR结构体用于唯一定义系统中存在的一个VT-d重定向硬件。其结构体如下所示：

Field	Byte Length	Byte Offset	Description
Type	2	0	0 - DMA Remapping Hardware Unit Definition (DRHD) structure
Length	2	2	Varies (16 + size of Device Scope Structure)
Flags	1	4	Bit 0: INCLUDE_PCI_ALL If Set, this remapping hardware unit has under its scope all PCI compatible devices in the specified Segment, except devices reported under the scope of other remapping hardware units for the same Segment. If a DRHD structure with INCLUDE_PCI_ALL flag Set is reported for a Segment, it must be enumerated by BIOS after all other DRHD structures for the same Segment. A DRHD structure with INCLUDE_PCI_ALL flag Set may use the ‘Device Scope’ field to enumerate I/OxAPIC and HPET devices under its scope. If Clear, this remapping hardware unit has under its scope only devices in the specified Segment that are explicitly identified through the ‘Device Scope’ field. Bits 1-7: Reserved.
Reserved	1	5	Reserved (0).
Segment Number	2	6	The PCI Segment associated with this unit.
Register Base Address	8	8	Base address of remapping hardware register-set for this unit.
Device Scope []	-	16	The Device Scope structure contains one or more Device Scope Entries that identify devices in the specified segment and under the scope of this remapping hardware unit.

## Device Scope Structure
The Device Scope Structure is made up of one or more Device Scope Entries. Each Device Scope Entry may be used to indicate a PCI endpoint device, a PCI sub-hierarchy, or devices such as I/OxAPICs or HPET (High Precision Event Timer). In this section, the generic term ‘PCI’ is used to describe conventional PCI, PCI-X, and PCI-Express devices. Similarly, the term ‘PCI-PCI bridge’ is used to refer to conventional PCI bridges, PCI-X bridges, PCI Express root ports, or downstream ports of a PCI Express switch. A PCI sub-hierarchy is defined as the collection of PCI controllers that are downstream to a specific PCI-PCI bridge. To identify a PCI sub-hierarchy, the Device Scope Entry needs to identify only the parent PCI-PCI bridge of the sub-hierarchy.

　主要包括两方面的信息，一是提供VT-d重定向硬件寄存器基地址，为系统软件访问VT-d硬件寄存器提供入口（各个偏移量所指向的具体寄存器在VT-d的spec中有详细的约定，即VT-d硬件的具体实现）；另一个是该VT-d重定向硬件所管辖的硬件，由Segment Number和Device Scope两个区域来定义。Device Scope结构体由Device Scope Entry组成，每个Device Scope Entry可以用来指明一个PCI endpoint device，一个PCI sub-hierarchy，或者其他设备，如I/O xAPIC或者HPET。

## RMRR（Reserved Memory Region Reporting）
RMRR表用于表示BIOS或者UEFI为了DMA的使用而保留的一些系统物理内存，这些内存从操作系统的角度来看其属性为Reserved Memory，因为有一些比较传统的设备（比如USB、UMA显卡等）可能会需要用到一些固定的，或者专用的系统内存，这时候就需要BIOS或UEFI为其保留。
rmrr_table.png

该表中，主要包括两方面信息，即保留的内存的范围（Reserved Memory Region Base Address和Reserved Memory Region Limit Address）和针对的物理设备（Segment Number和Device Scope）。

## ATSR（Root Port ATS Capability Reporting）表
　　ATS是Address Translation Services的意思，它是PCIe Capability的一种，用于表示PCIe设备是否支持经过PCIe Root Port翻译过的地址。ATSR表只适用于那种PCIe设备支持Device-TLB的系统中，即PCIe设备带有地址转换加速功能。一个ATSR表表示一个支持ATS功能的PCIe Root-Port，其结构如下所示：
atsr_table.png

主要包括两方面信息：Segment Number用于定位PCIe Root-Port；Device Scope用于定位位于该PCIe Root-Port下面的设备。

## RHSA（Remapping Hardware Status Affinity）表
　　RHSR表适用于NUMA（Non-Uniform Memory）系统（即不同的CPU Socket都可能会单独连接一些内存条，不同的CPU Socket对同一物理内存的访问路径可能是不同的），并且系统中的VT-d重定向硬件分布于不同的Node上。该表用于表示VT-d重定向硬件从属于哪个Domain。
rhsa_table.png
ANDD（ACPI Name-space Device Declaration）表
一个ANDD表用于表示一个以ACPI name-space规则命名，并且可发出DMA请求的设备。ANDD可以和前面提到的Device Scope Entry结合一起时候。

andd_table.png

其中ACPI Device Number，相当于在该VT-d硬件管辖范围内的以ACPI name-space规则命名的硬件ID号，前面Device Scope Entry值需要这个ID号，就可以找到该ANDD表，并从该表的ACPI Object Name区域找到具体的设备。


https://www.owalle.com/2021/11/01/iommu-code/