# namespace

```txt
     +---------+    +-------+    +--------+    +------------------------+
     |  RSDP   | +->| XSDT  | +->|  FADT  |    |  +-------------------+ |
     +---------+ |  +-------+ |  +--------+  +-|->|       DSDT        | |
     | Pointer | |  | Entry |-+  | ...... |  | |  +-------------------+ |
     +---------+ |  +-------+    | X_DSDT |--+ |  | Definition Blocks | |
     | Pointer |-+  | ..... |    | ...... |    |  +-------------------+ |
     +---------+    +-------+    +--------+    |  +-------------------+ |
                    | Entry |------------------|->|       SSDT        | |
                    +- - - -+                  |  +-------------------| |
                    | Entry | - - - - - - - -+ |  | Definition Blocks | |
                    +- - - -+                | |  +-------------------+ |
                                             | |  +- - - - - - - - - -+ |
                                             +-|->|       SSDT        | |
                                               |  +-------------------+ |
                                               |  | Definition Blocks | |
                                               |  +- - - - - - - - - -+ |
                                               +------------------------+
                                                           |
                                              OSPM Loading |
                                                          \|/
                                                    +----------------+
                                                    | ACPI Namespace |
                                                    +----------------+

```
## DMAR 表结构

BIOS收集IOMMU相关的信息，通过ACPI中的特定表组织数据，放置在内存中，等操作系统接管硬件后，它会加载驱动，驱动再详细解析ACPI表中的信息。
DMA Remapping Reporting Structure，
- 0：DMA Remapping Hardware unit Definition(DRHD) Structure， 用来描述真实的iommu硬件的结构
- 1: Reserved Memory Region Reporting(RMRR) Structure
- 2: Root Port ATS Capability Reporting(ATSR) Structure
- 3: Remapping Hardware Static Affinity(RHSA)  Structure
- 4: ACPI Name-space Device Declaration(ANDD) Structure
- 5: Soc Integrated Address Tranlation Cache(SATC) Reporting structure
- 5+: Reserve

对应代码宏定义如下：
```C
/* Values for subtable type in struct acpi_dmar_header */
enum acpi_dmar_type {
	ACPI_DMAR_TYPE_HARDWARE_UNIT = 0,
	ACPI_DMAR_TYPE_RESERVED_MEMORY = 1,
	ACPI_DMAR_TYPE_ROOT_ATS = 2,
	ACPI_DMAR_TYPE_HARDWARE_AFFINITY = 3,
	ACPI_DMAR_TYPE_NAMESPACE = 4,
	ACPI_DMAR_TYPE_SATC = 5,
	ACPI_DMAR_TYPE_RESERVED = 6	/* 6 and greater are reserved */
};
```

## DMA Remapping Reporting Structure

| Field                  | Byte Length | Byte Offset | Description    |
| ---------------------- | ----------- | ----------- | ------------------------------------------------------------ |
| Signature              | 4           | 0           | “DMAR”, 固定签名 |
| Length                 | 4           | 4           | Length, in bytes |
| Revision               | 1           | 8           | 1 |
| Checksum               | 1           | 9           | Entire table must sum to zero. |
| OEMID                  | 6           | 10          | OEM ID  |
| OEM Table ID           | 8           | 16          | For DMAR description table, the Table ID is the manufacturer model ID. |
| OEM Revision           | 4           | 24          | OEM Revision of DMAR Table for OEM Table |
| Creator ID             | 4           | 28          | Vendor ID of utility that created the table. |
| Creator Revision       | 4           | 32          | Revision of utility that created the table.   |
| Host Address Width     | 1           | 36          | DMA 物理地址宽度 = HAW +1， 最大可访问的物理地址由该值决定 |
| Flags                  | 1           | 37          | Bit 0: INTR_REMAP， 0表示不支持中断重映射，1表示支持. Bits 1-7:Reserved. |
| Reserved               | 10          | 38          | Reserved (0).  |
| Remapping Structures[] | -           | 48          | 对应真实的DMAR设备结构列表：DMA Remapping Hardware Unit Definition (DRHD) ,  Reserved Memory Region Reporting (RMRR) ， Root Port ATS Capability Reporting (ATSR) |

BIOS/UEFI负责在初始化系统的时候将这些结构体以类型为顺序有序地组织起来（同种类型的结构体可能有多个，也可能压根就不存在）。第一个结构体必须是DRHD（DMA Remapping Hardware Unit Definition）结构体。
内核数据结构定义：

```C
struct acpi_table_header {
	char signature[ACPI_NAMESEG_SIZE];	/* ASCII table signature */
	u32 length;		/* Length of table in bytes, including this header */
	u8 revision;		/* ACPI Specification minor version number */
	u8 checksum;		/* To make sum of entire table == 0 */
	char oem_id[ACPI_OEM_ID_SIZE];	/* ASCII OEM identification */
	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];	/* ASCII OEM table identification */
	u32 oem_revision;	/* OEM revision number */
	char asl_compiler_id[ACPI_NAMESEG_SIZE];	/* ASCII ASL compiler vendor ID */
	u32 asl_compiler_revision;	/* ASL compiler version */
};

struct acpi_table_dmar {
    struct acpi_table_header header;	/* Common ACPI table header */
    u8 width;		/* Host Address Width */
    u8 flags;
    u8 reserved[10];
};

struct acpi_dmar_header {
	u16 type;
	u16 length;
};

```

## DRHD（DMA Remapping Hardware Unit Definition）表
一个DMAR结构体用于唯一定义系统中存在的一个VT-d重定向硬件。其结构体如下所示：

| Field                 | Byte Length | Byte Offset | Description  |
| --------------------- | ----------- | ----------- | ----------------------------- |
| Type                  | 2           | 0           | 0 - DMA Remapping Hardware Unit Definition (DRHD) structure   |
| Length                | 2           | 2           | 16 + size of Device Scope Structure|
| Flags                 | 1           | 4           | Bit 0: INCLUDE_PCI_ALL， 1： DRHD表示除了Device Scope特别制定的设备，该domain都收到该DMAR设备管理（BIOS IOxAPIC HPET）， 0表示该DMAR设备只管理Device Scope中的设备。 Bits 1-7: Reserved. |
| Reserved              | 1           | 5           | Reserved (0).   |
| Segment Number        | 2           | 6           | The PCI Segment associated with this unit.  可以理解为 PCIE中的domain |
| Register Base Address | 8           | 8           | DMAR相关寄存器地址？？？？   |
| Device Scope []       | -           | 16          | 每个Entry可以用来指明一个PCI endpoint device，一个PCI sub-hierarchy，或者其他设备，如I/O xAPIC或者HPET。|

```C
struct acpi_dmar_hardware_unit { // type = 0, hardware unit definition
	struct acpi_dmar_header header;
	u8 flags;
	u8 size;		/* Size of the register set */
	u16 segment;
	u64 address;		/* Register Base Address */
};

struct acpi_dmar_device_scope {
	u8 entry_type; // endpoint/bridge/ioapic/hpet/namespace
	u8 length;
	u16 reserved;
	u8 enumeration_id;
	u8 bus;
};

```

- segment number可以理解为与某个dma remapping unit关联的pci domain；
- device scope也就是每个dmar unit下可以关联不同的设备；
- INCLUDE_PCI_ALL当这个bit被设置上时驱动会扫描pcie bus下面的所有设备并把这些设备跟这个dmar unit 关联起来，如果这个bit没有设置上则驱动需要解析device scope 然后把这个scope下面的设备跟这个dmar unit关联起来。
- register base address它定义一系列的register。

```C
struct dmar_drhd_unit {
        struct list_head list;          /* list of drhd units   */
        struct  acpi_dmar_header *hdr;  /* ACPI header          */
        u64     reg_base_addr;          /* register base address*/
        struct  dmar_dev_scope *devices;/* target device array  */
        int     devices_cnt;            /* target device count  */
        u16     segment;                /* PCI domain           */
        u8      ignored:1;              /* ignore drhd          */
        u8      include_all:1;
        struct intel_iommu *iommu;
}; 
```

- dmar_drhd_units： 全局链表，保存所有drhd，include all类型的放在最后。
- dmar_drhd_unit： 相当于一个iommu，iommu就是根据这个参数创建。解析acpi表的过程中，会根据drhd创建iommu设备，挂载到全局链表中。
- dmar_parse_one_drhd： 解析dmar表中举报提的drhd设备，挂载到全局链表dmar_drhd_units，创建IOMMU设备。解析dev scope，包含多少个设备（namespace、endpoint和bridge，其他的ioapic hpet不算在内）。

## RMRR（Reserved Memory Region Reporting）
RMRR表用于表示BIOS或者UEFI为了DMA的使用而保留的一些系统物理内存，这些内存从操作系统的角度来看其属性为Reserved Memory，因为有一些比较传统的设备（比如USB、UMA显卡等）可能会需要用到一些固定的，或者专用的系统内存，这时候就需要BIOS或UEFI为其保留。即保留的内存的范围（Reserved Memory Region Base Address和Reserved Memory Region Limit Address）和针对的物理设备（Segment Number和Device Scope）。

```C
/* 1: Reserved Memory Definition */
struct acpi_dmar_reserved_memory {
	struct acpi_dmar_header header;
	u16 reserved;
	u16 segment;
	u64 base_address;	/* 4K aligned base address */
	u64 end_address;	/* 4K aligned limit address */
    // device scope[]
};

```


## ATSR（Root Port ATS Capability Reporting）表
ATS是Address Translation Services的意思，它是PCIe Capability的一种，用于表示PCIe设备是否支持经过PCIe Root Port翻译过的地址。ATSR表只适用于那种PCIe设备支持Device-TLB的系统中，即PCIe设备带有地址转换加速功能。一个ATSR表表示一个支持ATS功能的PCIe Root-Port，其结构主要包括两方面信息：Segment Number用于定位PCIe Root-Port；Device Scope用于定位位于该PCIe Root-Port下面的设备。

```C
struct acpi_dmar_atsr {
	struct acpi_dmar_header header;
	u8 flags;
	u8 reserved;
	u16 segment;
    // device scope
};
```

## RHSA（Remapping Hardware Status Affinity）表
　　RHSR表适用于NUMA（Non-Uniform Memory）系统（即不同的CPU Socket都可能会单独连接一些内存条，不同的CPU Socket对同一物理内存的访问路径可能是不同的），并且系统中的VT-d重定向硬件分布于不同的Node上。该表用于表示VT-d重定向硬件从属于哪个Domain。

```C
/* 3: Remapping Hardware Static Affinity Structure */
struct acpi_dmar_rhsa {
	struct acpi_dmar_header header;
	u32 reserved;
	u64 base_address;
	u32 proximity_domain;
};
```
## ANDD（ACPI Name-space Device Declaration）表
一个ANDD表用于表示一个以ACPI name-space规则命名，并且可发出DMA请求的设备。ANDD可以和前面提到的Device Scope Entry结合一起时候。
其中ACPI Device Number，相当于在该VT-d硬件管辖范围内的以ACPI name-space规则命名的硬件ID号，前面Device Scope Entry值需要这个ID号，就可以找到该ANDD表，并从该表的ACPI Object Name区域找到具体的设备。

```C
/* 4: ACPI Namespace Device Declaration Structure */

struct acpi_dmar_andd {
	struct acpi_dmar_header header;
	u8 reserved[3];
	u8 device_number;
	char device_name[1];
};
```