# 数据结构



PCMachineClass(i440fx, q35) 
MachineClass
CPUClass

MachineState
X86MachineState
PCMachineState

```C
struct PCMachineState {
    X86MachineState parent_obj;
    Notifier machine_done;

    PCIBus *bus;
    I2CBus *smbus;
    PFlashCFI01 *flash[2];
    ISADevice *pcspk;
    DeviceState *iommu;

    uint64_t max_ram_below_4g;
    OnOffAuto vmport;
    SmbiosEntryPointType smbios_entry_point_type;

    bool acpi_build_enabled;
    bool smbus_enabled;
    bool sata_enabled;
    bool hpet_enabled;
    bool i8042_enabled;
    bool default_bus_bypass_iommu;
    uint64_t max_fw_size;

    hwaddr memhp_io_base;

    SGXEPCState sgx_epc;
    CXLState cxl_devices_state;
}

struct X86MachineState {
    MachineState parent;

    ISADevice *rtc;
    FWCfgState *fw_cfg;
    qemu_irq *gsi;
    DeviceState *ioapic2;
    GMappedFile *initrd_mapped_file;
    HotplugHandler *acpi_dev;

    ram_addr_t below_4g_mem_size, above_4g_mem_size;

    uint64_t above_4g_mem_start;

    bool apic_xrupt_override;
    unsigned pci_irq_mask;
    unsigned apic_id_limit;
    uint16_t boot_cpus;
    SgxEPCList *sgx_epc_list;

    OnOffAuto smm;
    OnOffAuto acpi;
    OnOffAuto pit;
    OnOffAuto pic;

    char *oem_id;
    char *oem_table_id;

    AddressSpace *ioapic_as;

    /*
     * Ratelimit enforced on detected bus locks in guest.
     * The default value of the bus_lock_ratelimit is 0 per second,
     * which means no limitation on the guest's bus locks.
     */
    uint64_t bus_lock_ratelimit;
};

struct MachineState {
    Object parent_obj;

    void *fdt;
    char *dtb;
    char *dumpdtb;
    int phandle_start;
    char *dt_compatible;
    bool dump_guest_core;
    bool mem_merge;
    bool usb;
    bool usb_disabled;
    char *firmware;
    bool iommu;
    bool suppress_vmdesc;
    bool enable_graphics;
    ConfidentialGuestSupport *cgs;
    HostMemoryBackend *memdev;

    MemoryRegion *ram;
    DeviceMemoryState *device_memory;

    ram_addr_t ram_size;
    ram_addr_t maxram_size;
    uint64_t   ram_slots;
    BootConfiguration boot_config;
    char *kernel_filename;
    char *kernel_cmdline;
    char *initrd_filename;
    const char *cpu_type;
    AccelState *accelerator;
    CPUArchIdList *possible_cpus;
    CpuTopology smp;
    struct NVDIMMState *nvdimms_state;
    struct NumaState *numa_state;
};

```

DEFINE_I440FX_MACHINE(v8_1, "pc-i440fx-8.1", NULL, pc_i440fx_8_1_machine_options);
pc_init1(machine, TYPE_I440FX_PCI_HOST_BRIDGE, TYPE_I440FX_PCI_DEVICE);
- cpu
- memory
- kvmclock
- pci : 
- pic
- tcg
- vga
- isa
- gsi
- hpet
- rtc
- ide
- cmos
- usb_uhci
- acpi: pm
- nvdimms

DEFINE_Q35_MACHINE(v8_1, "pc-q35-8.1", NULL, pc_q35_8_1_machine_options);
pc_q35_init(machine);

MemoryRegion   
PCIBus
ISABus

| name           | type            | parent   | desc     |
| -------------- | --------------- | -------- | -------- |
| main-sytem-bus | TYPE_SYSTEM_BUS | TYPE_BUS | 系统总线 |


## init
全局变量 current_machine： MachineState
GHashTable *type_table;  DeviceClass
monitor_block_backends: 全局变量，包含BlockBackends
static Object *root; // container
static Object *internal_root; // container


qmp_x_exit_preconfig
    qemu_init_board
        machine_run_board_init: 
            CPU valid检查，有class的valid_cpu_types
            CPU deprecation检查， 有CPUClass
            AccelClass/AccelState： 加速器kvm初始化
            machine_class->init(), 推进状态：PHASE_MACHINE_INITIALIZED
        drive_check_orphaned:  monitor_block_backends 
        realtime_init
        hax_sync_vcpus: hax?
    qemu_create_cli_devices
        soudhw_init(): 
        fw_cfg: 
        init usb device:
        rom
        device ->  device_init_func
    qemu_machine_creation_done
    从快照加载：load_snapshot
    relay: replay_vmstate_init
    incoming: qmp_migrate_incoming


static BusState *main_system_bus; BusChildHead/BusStateEntry
qbus
    qdev_print(mon, dev, indent)


static QDict *machine_opts_dict; // 所有选项都在这里
qemu_init
    qemu_create_machine
        select_machine：参数有没有指定type， 所有的TYPE_MACHINE类型，比对一下，如果没有type直接find_default_machine(), default就是预设
qemu_main_loop()