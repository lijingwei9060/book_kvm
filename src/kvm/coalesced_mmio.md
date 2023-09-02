# 功能和作用

## api与用户态交互

## 管理流程

### kvm数据结构


ioctl： 
- KVM_REGISTER_COALESCED_MMIO： 注册一个zone，包含gpa，数量不超过 KVM_COALESCED_MMIO_ZONE_MAX. 
- KVM_UNREGISTER_COALESCED_MMIO: 取消所有注册的zone，地址根据传入参数 kvm_coalesced_mmio_zone).

用户态执行ioctl(KVM_CHECK_EXTENSION)查询kernel是否支持KVM_CAP_COALESCED_MMIO


KVM_COALESCED_MMIO_MAX
kvm_vcpu
kvm_io_device
kvm_io_device_ops colaesced_mmio_ops

kvm_coalesced_mmio_dev{ //mmio_dev包含具体的device, 全局的kvm和具体的聚合MMIO地址空间，dev会关联到具体的虚拟机
    dev:  kvm_io_device,
    kvm:  kvm,
    zone: kvm_coalesced_mmio_zone{
        pio: KVM_PIO_BUS/KVM_MMIO_BUS,
        addr：gpa,
        size：,
        dev： kvm_coalesced_mmio_dev,
    },
}

kvm_coalesced_mmio_ring{
    first: u32,
    last: u32,
    coalesced_mmio: []kvm_coalesced_mmio{
        phys_addr: u64,
        len: u32,
        pio/pad: u32
        data: [8]u8,
    },
}


kvm{
    coalesced_mmio_ring = page_address(page),
    ring_lock: lock,
    coalesced_zones:  list,
}

### qemu数据结构

### kvm管理coalesced mmio

1. 初始化： 分配一个page，挂在kvm->coalesced_mmio_ring, 初始化kvm->coalesced_zones列表。所以这个功能不是针对哪个虚拟机的而是针对所有机器。
2. 写入：传入参数vcpu、gpa、kvm_io_device、addr、len、val, 确定对应gpa在zone里面吗，ring中还有空闲的room吗。在room中保存对应的mmio操作(gpa, len, data, pio), last增长。

什么时候会触发这个呢？

1. 当对coalesced MMIO作写访问时，仍然会陷入到EL2 host上，调用coalesced_mmio_write()将数据缓存到ring中。
2. 当对coalesced MMIO作读访问时，仍然会陷入到EL2 host上（不作任何操作），返回到EL2 QEMU中，首先会flush掉之前缓存的coalesced MMIO操作，然后再执行QEMU中对应的读操作；
3. 对其他MMIO区域的读写访问时，首先陷入到EL2 host上，然后返回到EL2 QEMU中，先flush掉之前缓存coalesced MMIO操作，再执行QEMU中对应的读写操作。
4. 因此对于coalesced MMIO区域的真正写操作，是在对coalesced MMIO区域读操作或对其他MMIO域的读写访问时发生的，它会依次将ring中缓存的coalesced MMIO进行处理
