# 启动
1. 没有BIOS和GRUB引导，X86下如何从实模式跳转到保护模式呢？
2. 没有引导过程，内核是如何加载到内存的？

```shell
# 启动microvm机型
$ ./target/release/stratovirt \
    -machine microvm \
    -kernel /path/to/kernel \
    -append "console=ttyS0 root=/dev/vda reboot=k panic=1" \
    -drive file=/path/to/rootfs,id=rootfs,readonly=off \
    -device virtio-blk-device,drive=rootfs,id=rootfs \
    -qmp unix:/path/to/socket,server,nowait \
    -serial stdio

# x86_64上启动标准机型
$ ./target/release/stratovirt \
    -machine q35 \
    -kernel /path/to/kernel \
    -append "console=ttyS0 root=/dev/vda reboot=k panic=1" \
    -drive file=/path/to/firmware,if=pflash,unit=0,readonly=true \
    -device pcie-root-port,port=0x0,addr=0x1.0x0,bus=pcie.0,id=pcie.1 \
    -drive file=/path/to/rootfs,id=rootfs,readonly=off \
    -device virtio-blk-pci,drive=rootfs,bus=pcie.1,addr=0x0.0x0,id=blk-0 \
    -qmp unix:/path/to/socket,server,nowait \
    -serial stdio
```

# MachineOps

```rust
pub trait MachineOps {
  fn arch_ram_ranges(&self, mem_size: u64) -> Vec<(u64, u64)>;
  fn load_boot_source(&self, fwcfg: Option<&Arc<Mutex<dyn FwCfgOps>>>) -> Result<CPUBootConfig>;
  fn load_cpu_features(&self, vmcfg: &VmConfig) -> Result<CPUFeatures>;
  fn init_memory(&self, mem_config: &MachineMemConfig,  sys_io: &Arc<AddressSpace>, sys_mem: &Arc<AddressSpace>, nr_cpus: u8) -> Result<()>;
  fn init_vcpu(vm: Arc<Mutex<dyn MachineInterface + Send + Sync>>, nr_cpus: u8, topology: &CPUTopology, fds: &[Arc<VcpuFd>],  boot_cfg: &Option<CPUBootConfig>, vcpu_cfg: &Option<CPUFeatures>) -> Result<Vec<Arc<CPU>>>;
  fn init_interrupt_controller(&mut self, vcpu_count: u64) -> Result<()>;
  fn add_rtc_device(&mut self, #[cfg(target_arch = "x86_64")] mem_size: u64) -> Result<()>;
  fn add_serial_device(&mut self, config: &SerialConfig) -> Result<()>;
  fn add_virtio_mmio_block(&mut self, _vm_config: &mut VmConfig, _cfg_args: &str) -> Result<()>
  fn add_virtio_vsock(&mut self, cfg_args: &str) -> Result<()>
  fn realize_virtio_mmio_device(&mut self, _dev: VirtioMmioDevice) -> Result<Arc<Mutex<VirtioMmioDevice>>>
  fn get_sys_mem(&mut self) -> &Arc<AddressSpace>;
  fn get_vm_config(&self) -> &Mutex<VmConfig>;
  fn get_migrate_info(&self) -> Incoming;
}
```

# 内存空间管理

  采用树状管理， 有`FlatView`可以快速查找，每个`Region`有优先级。


- `AddressSpace`
- `Region`: 一段地址区间，根据这段地址区间的使用者，分为RAM(内存)、IO(设备)和Container(容器，包含多个region)。



# vcpu

- CPUBootConfig
- CPUTopology: The wrapper for topology for VCPU. `socket` -> `die` -> `cluster` -> `core` -> `thread`
- VcpuFd:  Wrapper over KVM vCPU ioctls.
- KvmRunWrapper: Safe wrapper over the `kvm_run` struct.
- X86CPUCaps
- X86CPUState: The state of vCPU's register.
- CPU: `CPU` is a wrapper around creating and using a kvm-based VCPU.
- CPUInterface: Trait to handle `CPU` lifetime.
- CpuLifecycleState: 
- CPUBootConfig
- CPUThreadWorker: 




# 启动过程
```rust
QmpChannel::object_init();
EventLoop::object_init(&vm_config.iothreads)?
LightMachine::new(vm_config)
MachineOps::realize(&vm, vm_config)
EventLoop::set_manager(vm.clone(), None)
machine::vm_run(&vm, cmd_args)
  <Self as MachineOps>::vm_start(paused, &self.cpus, &mut self.vm_state.0.lock().unwrap())
    CPU::start(cpu, cpu_thread_barrier, paused)
      cpu_thread_worker.handle(thread_barrier) // 新的线程
EventLoop::loop_run()
```

# 热迁移

# 初始化过程
LightMachine::new(vm_config)：
```rust
sys_mem初始化： 创建第一个`AddressSpace` ， Region::init_container_region(u64::max_value())。
sys_io初始化，和sys_mem初始化过程相同，region的大小为2^16大小，64Kb。
sysbus创建，关联sys_io, sys_mem, free_irqs, mmio_region。
创建vm_state: KvmVmState::Created.
power_button
创建CpuTopology
```
MachineOps::realize(&vm, vm_config)
```rust
vm.init_memory() 初始化内存
vm.init_interrupt_controller()初始化中断控制器
LightMachine::arch_init() //架构相关初始化工作
  vm_fd.set_tss_address(0xfffb_d000)
  kvm_pit_config
  vm_fd.create_pit2
创建vcpu 
vm.create_replaceable_device() // 创建mmio设备
vm.add_device()
  add_rtc_device
  add_serial_device
  add_pflash_device
  add_virtio_mmio_devie
  add_virtio_pci_blk

MachineOps::init_vcpu() // 初始化vcpu
MigrationManager::set_status(MigrationStatus::Setup) 
```

# EventLoop

- trait `EventLoopManager`
- EventLoop: This struct used to manage all events occur during VM lifetime. 
  - io_thread: used to monitor events of specified device
  - main_loop: handle all events not monitored by io-threads
- EventLoopContext: Epoll Loop Context
- EventNotifier: Epoll Event Notifier Entry.
- NotifierOperation: AddExclusion/AddShared/Modify/Delete/Park/Resume
- NotifierCallback: 
- EventSet
- EventStatus: Alive/Parked/Removed
- IothreadInfo: IO thread info

- Time: Timer structure is used for delay function execution.
  - func: Box<dyn Fn()>, 
  - expire_time: Instant,