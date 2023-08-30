# rom based


## cpu initial

x86_cpu_type_info.class_init = x86_cpu_common_class_init => x86_cpu_realizefn
x86_cpu_type_info.instance_init = x86_cpu_initfn
x86_cpu_type.instance_post_init = x86_cpu_post_initfn

x86_cpu_realizefn()
    x86_cpu_hyperv_realize(cpu)
    x86_cpu_expand_features(cpu)
    FEAT_PERF_CAPABILITIES
    vPMU LBR
    x86_cpu_filter_features(cpu)
    amd: FEAT_8000_0001_EDX // EDX bits must match the bits on CPUID[1].EDX.
    x86_cpu_set_sgxlepubkeyhash() // skylake cpu set
    cpu_exec_realizefn() //?
    cpu->ucode_rev
    cpu->mwait.ecx
    CPUID_EXT2_LM
    cache_info_cpuid2
    qemu_register_reset(x86_cpu_machine_reset_cb, cpu);
    x86_cpu_apic_create(cpu, &local_err);
    mce_init(cpu);
    qemu_init_vcpu(cs);
    x86_cpu_apic_realize(cpu, &local_err)
    cpu_reset(cs)



x86_cpus_init(x86ms, pcmc->default_cpu_version)
    x86ms->apic_id_limit  // used for FW_CFG_MAX_CPUS. See comments on fw_cfg_arch_create(). x2apic 
kvmclock_create()


## rom loading 

pc_memory_init (hw/i386/pc.c)
    pc_system_firmware_init (hw/i386/pc_sysfw.c)
        pci没启用：x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, true);
        没有指定pflash：x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, false);
            memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal); 加载bios到这个地方，gpa：0xfffc0000
            rom_add_file_fixed(bios_name, (uint32_t)(-bios_size), -1)
                rom_insert(rom)
                add_boot_device_path(bootindex, NULL, devpath)
            memory_region_init_alias(isa_bios, NULL, "isa-bios", bios, bios_size - isa_bios_size, isa_bios_size);
        制定了pflash：pc_system_flash_map(pcms, rom_memory)


            


/usr/share/qemu/bios-256k.bin, GPA： 0xfffc0000， region_name: pci.bios/ias-bios

## cpu reset
x86_cpu_reset (target/i386/cpu.c)

Program Counter (EIP register in x86) is set to 0xfff0
the CS selector to 0xf000 
the CS base address to 0xffff0000. 

Adding the PC value to the CS base address we conclude that the CPU will start at 0xfffffff0 (emulated physical address). Note: all of the previous values were artificially set to comply with the x86 specification. In x86 real mode, addresses during run time will be calculated as segment selector * 16 + offset.


## mem 

 a Memory Regions map just before CPU execution begins:

system [0x0 – UINT64_MAX)
    ram-below-4g [0x0 – 0x8000000)       Alias of pc.ram
    smram-region [0xa0000 – 0xc0000)     Alias of pci
    pam-pci [0xf0000 – 0x100000)         Alias of pci
    pam-rom [0xf0000 – 0x100000)         Alias of pc.ram
    pam-pci [0xf0000 – 0x100000)         Alias of pc.ram
    pam-ram [0xf0000 – 0x100000)         Alias of pc.ram
    …
    ioapic [0xfec00000 – 0xfec01000)
    hpet [0xfed00000 – 0xfed00400)
    apic-msi [0xfee00000 – 0xfef00000)
    pci [0x0 – UINT64_MAX)
        vga-lowmem [0xa0000 – 0xc0000)
        pc.rom [0xc0000 – 0xe0000)
        isa-bios [0xe0000 – 0x100000)        Alias of pc.bios
        pc.bios [0xfffc0000 – 0x100000000)

io端口
    piix4-pm [0x0 – 0x40)
        acpi-evt [0x0 – 0x4)
        acpi-cnt [0x4 – 0x6)
        acpi-tmr [0x8 – 0xc)
    dma-chan [0x0 – 0x8)
    dma-cont [0x8 – 0x10)
    pic [0x20 – 0x22)
    pit [0x40 – 0x44)
    i8042-data [0x60]
    pcspk [0x61]
    i8042-cmd [0x64]
    rtc [0x70 – 0x72)
        rtc-index [0x0]
    kvmvapic [0x7e – 0x80)
    ioport80 [0x80]
    dma-page [0x81 – 0x84)
    dma-page [0x87]
    dma-page [0x89 – 0x8c)
    dma-page [0x8f]
    port92 [0x92]
    pic [0xa0 – 0xa2)
    apm-io [0xb2 – 0xb4)
    dma-chan [0xc0 – 0xd0)
    dma-cont [0xd0 – 0xe0)
    ioportF0 [0xf0]
    ide [0x170 – 0x178)
    vbe [0x1ce – 0x1d1)
    ide [0x1f0 – 0x1f8)
    ide [0x376]
    parallel [0x378 – 0x380)
    vga [0x3b4 – 0x3b6)
    vga [0x3ba]
    vga [0x3c0 – 0x3d0)
    vga [0x3d4 – 0x3d6)
    vga [0x3da]
    fdc [0x3f1 – 0x3f6)
    ide [0x3f6]
    fdc [0x3f7]
    serial [0x3f8 – 0x400)
    elcr [0x4d0]
    elcr [0x4d1]
    fwcfg [0x510 – 0x512)
    fwcfg.dma [0x514 – 0x51c)
    pci-conf-idx [0xcf8 – 0xcfc)
    piix3-reset-control [0xcf9]
    pci-conf-data [0xcfc – 0xd00)
    vmport [0x5658]
    acpi-pci-hotplug [0xae00 – 0xae14)
    acpi-cpu-hotplug [0xaf00 – 0xaf20)
    acpi-gpe0 [0xafe0 – 0xafe4)
    pm-smbus [0xb100 – 0xb140)




```text
[root@10.16.161.1 qemu]# ls
bios-256k.bin     efi-ne2k_pci.rom  keymaps            pvh.bin           pxe-rtl8139.rom   vgabios-bochs-display.bin  vgabios-virtio.bin
bios.bin          efi-pcnet.rom     kvmvapic.bin       pxe-e1000.rom     pxe-virtio.rom    vgabios-cirrus.bin         vgabios-vmware.bin
efi-e1000e.rom    efi-rtl8139.rom   linuxboot.bin      pxe-eepro100.rom  sgabios.bin       vgabios-qxl.bin
efi-e1000.rom     efi-virtio.rom    linuxboot_dma.bin  pxe-ne2k_pci.rom  trace-events-all  vgabios-ramfb.bin
efi-eepro100.rom  efi-vmxnet3.rom   multiboot.bin      pxe-pcnet.rom     vgabios.bin       vgabios-stdvga.bin
```