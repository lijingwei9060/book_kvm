
qemu初始化逻辑：

pc_init1
    pc_cpus_init
        pc_new_cpu
            set cpu's apic_id
            realized: x86_cpu_realizefn
                x86_cpu_apic_create
                    cpu->apic_state
                    object_property_add_child(lapic)
                    qdev_prop_set_uint32(id)
                    apic->apicbase = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
                x86_cpu_apic_realize
                    device_set_realized
                        apic_common_realize
                            apic_realize
                                memory_region_init_io(apic-msi)
                                s->timer
                                local_apics[s->id] = s
                memory_region_add_subregion_overlap
    pcms->gsi
        qemu_allocate_irqs(gsi_handler)
    i8259_init
        master:i8259_init_chip
            isa_create(TYPE_I8259)
            iobase:0x20
            elcr_addr:0x4d0
            elcr_mask:0xf8
            master:true
            qdev_init_nofail
                pic_realize
                    memory_region_init_io(base_io)
                        pic_ioport_read
                        pic_ioport_write
                    memory_region_init_io(elcr_io)
                        elcr_ioport_read
                        elcr_ioport_write
                    qdev_init_gpio_out
                    qdev_init_gpio_in(pic_set_irq)
                        qdev_init_gpio_in_named_with_opaque
                            gpio_list->in[8]
                    pic_common_realize
                        isa_register_ioport
                        qdev_set_legacy_instance_id
        qdev_connect_gpio_out(pic_irq_request)
            qdev_connect_gpio_out_named
        irq_set[0-7] = qdev_get_gpio_in(0-7)
        slave:i8259_init_chip
            isa_create(TYPE_I8259)
            iobase:0xa0
            elcr_addr:0x4d1
            elcr_mask:0xde
            master:false
            qdev_init_nofail
                pic_realize
        qdev_connect_gpio_out(irq_set[2])
            qdev_connect_gpio_out_named
        irq_set[8-15] = qdev_get_gpio_in(0-7)
    ioapic_init_gsi
        qdev_create(ioapic)
        object_property_add_child(ioapic)
        qdev_init_nofail
            ioapic_common_realize
                ioapic_realize
                    memory_region_init_io(ioapic,0x1000)
                    qdev_init_gpio_in(ioapic_set_irq)
                    ioapics[ioapic_no] = s
                sysbus_init_mmio(0xfec00000)
                    IOAPICCommonState->mmio[n].memory = s->io_memory
        sysbus_mmio_map(0xfec00000)
        gsi_state->ioapic_irq[i] = qdev_get_gpio_in
main_impl
    configure_accelerator
        accel_init_machine
            init_machine:hax_accel_init
    machine_run_board_init
        machine_class->init