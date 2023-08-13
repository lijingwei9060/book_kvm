# 模型
QEMU下的内存结构体: 
1. RAMBlock: 真正分配了host内存的地方, 每个RAMBLOCK都有一个唯一的MemoryRegion对应，不是每个MemoryRegion都有RAMBLOCK对应的(比如IO端口就是虚虚拟的，所以不会真的有RAMBlock)。host则是host的线性地址(hva)。offset则是这个block在ram中的base地址(?，是虚拟机中的地址？)。
2. MemoryRegion：是树状父子结构的，这个MemoryRegion是最顶级的MemoryRegion，它还有很多子MemoryRegion，比如在这个ramblock地址范围内的MMIO等。addr是mr的起始地址
3. AddressSpace：本来不同的设备使用的地址空间不同，但是QEMU X86里面只有两种，address_space_memory和address_space_io，所有设备的地址空间都被映射到了这两个上面
4. FlatView/FlatRange: 当memory region发生变化的时候，执行memory_region_transaction_commit，address_space_update_topology，address_space_update_topology_pass最终完成更新FlatView的目标。
5. MemoryRegionSection
6. KVMSlot
7. kvm_userspace_memory_region，

8. 内存条：pc-dimm, memory-backend
9. qemu中的内存块： MemoryRegion， AddressSpace
10. 向host申请的内存块： RAMBlock - RAMList 

11. MemoryRegion重要的特征是形成了一棵内存区域树。
12. 每一个Memory Region对象都包含了RAMBlock
13. RAMBlock是QEMU真正向Host alloc申请空间的数据结构，它的大小可以指定
14. Memory Region是从RAMBlock进行了抽象，有助于Device操作内存空间。
15. QEMU维护了RAMList，每申请一个RAMBlock(Memory Region)添加到List中
16. Address Space包含了一系列Memory Region，在当前上下文空间中，通过地址空间对当前一系列存储对象进行一个统一抽象，很抽象举个例子。比如当前是CPU正在运行的状态，就有了一个Address Space名为CPU-system，此时的寻址空间，高位是操作系统内核空间，中间有0x40000000~0x7FFFFFFF共4G的地址是用于RAM内存空间，还有一些地址用于I/O。后来需要I/O，进入I/O状态后，又有了一个Address Space名为I/O，此时的所有地址都是I/O地址。
17. 对于memory-backend，可以不用理解，只需要知道大多数device都需要和存储交互，操作的对象是Memory Region即可


MemoryRegion
AddressSpace
FlatView
RAMBlock

## 实际结果

```shell
(gdb) dump_address_spaces 0
AddressSpace : memory(0x5555566ed920)
     Root MR : 0x555556804b00
    FlatView : 0x555557a2e650
AddressSpace : I/O(0x5555566ed8c0)
     Root MR : 0x5555567fbf00
    FlatView : 0x555557a47d30
AddressSpace : cpu-memory-0(0x555556877460)
     Root MR : 0x555556804b00
    FlatView : 0x555557a2e650
AddressSpace : cpu-smm-0(0x555556877640)
     Root MR : 0x5555567e0400
    FlatView : 0x555557a3b800
AddressSpace : i440FX(0x5555569de1a0)
     Root MR : 0x5555569de200
    FlatView : 0x5555568301e0
AddressSpace : PIIX3(0x555557177830)
     Root MR : 0x555557177890
    FlatView : 0x5555568301e0
AddressSpace : VGA(0x555557257c30)
     Root MR : 0x555557257c90
    FlatView : 0x5555568301e0
AddressSpace : e1000(0x7ffff7e08220)
     Root MR : 0x7ffff7e08280
    FlatView : 0x5555568301e0
AddressSpace : piix3-ide(0x5555576e3840)
     Root MR : 0x5555576e38a0
    FlatView : 0x5555568301e0
AddressSpace : PIIX4_PM(0x55555781e7b0)
     Root MR : 0x55555781e810
    FlatView : 0x5555568301e0

(gdb) dump_memory_region 0x555556804b00
Dump MemoryRegion:system
[0000000000000000-100000000ffffffff]:system
  [00000000fee00000-000000000feefffff]:apic-msi
  [00000000000ec000-000000000000effff]:pam-ram
  [00000000000ec000-000000000000effff]:pam-pci
  [00000000000ec000-000000000000effff]:pam-rom
  [00000000000a0000-000000000000bffff]:smram-region
  [00000000fed00000-000000000fed003ff]:hpet
  [00000000fec00000-000000000fec00fff]:ioapic
  [0000000000000000-00000000007ffffff]:ram-below-4g
  [0000000000000000-100000000ffffffff]:pci
    [00000000000a0000-000000000000bffff]:vga-lowmem
    [00000000000c0000-000000000000dffff]:pc.rom
    [00000000000e0000-000000000000fffff]:isa-bios
    [00000000fffc0000-000000000ffffffff]:pc.bios
```

## Memory Region 类型
1. RAM类型：内存Memory和Cache就是RAM类型，创建接口为：memory_region_init_ram()，特殊的：memory_region_init_resizeable_ram(), memory_region_init_ram_from_file(), or memory_region_init_ram_ptr()
2. MMIO类型：用于host callbacks创建的guest memory，如每次read or write操作会导致host的一个callback，可以通过memory_region_init_io()创建
3. ROM类型： read-only-memory，主要用于闪存，比如存OS的加载器，创建接口：memory_region_init_rom()
4. ROM Device类型：像RAM一样read，同时write会调用host callback的device，创建接口：memory_region_init_rom_device()
5. IOMMU类型：有IOMMU职责的region，即能将地址直接翻译到目标的memory region，只能用于IOMMU device，创建接口：memory_region_init_iommu()
6. container类型：顾名思义，包含了其他的mr，记录每个mr的offset。container可以管理多个mr为一个单位，十分有用。比如，一个PCI BAR可能包含了一个RAM region和一个MMIO region，创建container mr使用纯净的init方式：memory_region_init()
7. alias类型：一个region的子集。允许将一个region分解成不连续的子region，创建接口：memory_region_add_subregion()，用于将一个已存在的region加入到某个container中；memory_region_init_alias()，用于创建一个新的region
8. reservation region类型：用于debug，在enable-kvm之后使用，memory_region_init_io()

qemu mr支持向所有的非container中add一个subregion，比如MMIO，RAM，ROM region，此时这些Region也表现为container，除非规定了这个region的所有地址都由该region自己处理。但qemu不支持向alias类型的region中加入subregion

## overlapping Priority

1. 一个regions会被解析成一个唯一确定的目标地址，并不会重叠（overlapping），但一些场景下mr会重叠。即，一个mr对应了多个目标地址，在一次调用中使用哪个目标地址，取决于这些目标地址的优先级（priority），即优先级高的被返回。对应的接口：memory_region_add_subregion_overlap()，允许一个region和同一个容器中的其他region重叠，并且声明优先级。
2. visibility：根据地址空间确定当前的地址映射，查找address上的值。
3. FlatView：generate_memory_topology()

## 过程

1. 首先一个mr的诞生从memory_region_init*()函数开始，并且mr属于一个已存在的对象，比如vcpu，说明这个mr是vcpu的一部分，称这个vcpu对象是此mr的owner或者parent
2. QEMU规定只要mr还对guest可见，owner就不会死亡
3. 被创建后的mr，可以被加入到一个address space或container，或者被移除，接口分别为：memory_region_add_subregion()和memory_region_del_subregion()
4. mr被创建后，职责不是一成不变的，可以修改，发生在mr被置为visible的时候赋予
5. 当owner死亡后，mr会被自动析构清除
6. mr也可以手动清除，接口为object_unparent()



全局变量：
1. RAMList ram_list = { .blocks = QLIST_HEAD_INITIALIZER(ram_list.blocks) };
2. static MemoryRegion *system_memory;
3. static MemoryRegion *system_io;
4. AddressSpace address_space_io;
5. AddressSpace address_space_memory;
6. static MemoryRegion io_mem_unassigned;


parse_memory_options

qemu_create_machine
    cpu_exec_init_all
        finalize_target_page_bits();
        io_mem_init() -> memory_region_init_io()
        memory_map_init();
            memory_region_init(system_memory, NULL, "system", UINT64_MAX);
            address_space_init(&address_space_memory, system_memory, "memory");
            memory_region_init_io(system_io, NULL, &unassigned_io_ops, NULL, "io", 65536);
            address_space_init(&address_space_io, system_io, "I/O");

    page_size_init

## 握手KVM

当内存树发生变化，Qemu就会对相关的FlatView调用相应的回调函数，而Qemu的内存模型就是在这个过程中 和KVM发生联系的。在Qemu初始化的过程中，通过kvm_memory_listener_register()注册了相应的回调函数kvm_region_add/del。 所以这个对应的回调函数就是kvm_region_add/del。具体的细节就不在这里深究了，我们来看一下究竟Qemu告诉了KVM什么。

```C
struct kvm_userspace_memory_region {
	__u32 slot;
	__u32 flags;
	__u64 guest_phys_addr;
	__u64 memory_size; /* bytes */
	__u64 userspace_addr; /* start of the userspace allocated memory */
};
```

Qemu和KVM之间的通信格式就是上面的这段数据结构。很清楚，我们看到他们交换了这么几个重要的信息
- GPA: guest_phys_addr
- HVA: userspace_addr

## KVM中的内存

把Qemu传递过来的信息记录了起来，保存在了一个叫kvm_memory_slot的结构体中。
```C
struct kvm_memory_slot {
	gfn_t base_gfn;
	unsigned long npages;
	unsigned long *dirty_bitmap;
	struct kvm_arch_memory_slot arch;
	unsigned long userspace_addr;
	u32 flags;
	short id;
};
```
起始也就是记录下来了虚拟机中对应GPA的HVA。那记录下来是要干啥呢？对了，构造EPT表。

用kvm_mmu_page结构体来表示EPT结构中的一个节点。如果大家有过页表的概念，那么可以 将EPT想象为一个树形结构，而其中的每个节点就是用kvm_mmu_page结构来描述。

## 内存监听器

```C
struct MemoryListener {
  void (*begin)(MemoryListener *listener);
  void (*commit)(MemoryListener *listener);
  void (*region_add)(MemoryListener *listener, MemoryRegionSection *section);
  void (*region_del)(MemoryListener *listener, MemoryRegionSection *section);
  void (*region_nop)(MemoryListener *listener, MemoryRegionSection *section);
  void (*log_start)(MemoryListener *listener, MemoryRegionSection *section, int old, int new);
  void (*log_stop)(MemoryListener *listener, MemoryRegionSection *section, int old, int new);
  void (*log_sync)(MemoryListener *listener, MemoryRegionSection *section);
  void (*log_sync_global)(MemoryListener *listener);
  void (*log_clear)(MemoryListener *listener, MemoryRegionSection *section);
  void (*log_global_start)(MemoryListener *listener);
  void (*log_global_stop)(MemoryListener *listener);
  void (*log_global_after_sync)(MemoryListener *listener);
  void (*eventfd_add)(MemoryListener *listener, MemoryRegionSection *section, bool match_data, uint64_t data, EventNotifier *e);
  void (*eventfd_del)(MemoryListener *listener, MemoryRegionSection *section, bool match_data, uint64_t data, EventNotifier *e);
  void (*coalesced_io_add)(MemoryListener *listener, MemoryRegionSection *section, hwaddr addr, hwaddr len);
  void (*coalesced_io_del)(MemoryListener *listener, MemoryRegionSection *section, hwaddr addr, hwaddr len);
  unsigned priority;
  const char *name;
};
```

## Refference

1. https://qemu.readthedocs.io/en/latest/devel/memory.html