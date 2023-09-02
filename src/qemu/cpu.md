# qom

TYPE_DEVICE -> TYPE_CPU -> TYPE_X86_CPU -> X86_CPU_TYPE_NAME("max")/X86_CPU_TYPE_NAME("base")

x86_register_cpudef_types(&builtin_x86_defs[i]) // 注册具体的cpu型号

## 初始化CPU

DEFINE_Q35_MACHINE
pc_q35_init(machine);

|-x86_cpus_init
	|-x86_cpu_new                           //CPUState *cs = CPU(dev);
		|-object_new
			|-object_new_with_type
				|-type_initialize
				|-object_initialize_with_type
					|-type_initialize
						|-class_init        //调用x86_cpu_type_info的x86_cpu_common_class_init初始化x86_cpu
		|-object_property_set_bool
			|-object_property_set_qobject
				|-property_set_bool
					|-device_set_realized
						|-x86_cpu_realizefn   //vcpu初始化的实现，先初始化struct X86CPU再初始化struct CPUState 
							|-qemu_init_vcpu  //struct CPUState
								|-kvm_start_vcpu_thread
									|-kvm_vcpu_thread_fn
										|-kvm_init_vcpu
											|-kvm_get_vcpu        //通知kvm创建一个vcpu，返回一个kvm_fd，在kvm的内核中，vpu的操作函数kvm_x86_ops指向(intel)vmx_x86_ops或者(amd)svm_x86_ops
											|-kvm_ioctl           //从kvm获取映射mmap_size(KVM_GET_VCPU_MMAP_SIZE)
											|-mmap                //对kvm_fd进行以一个mmap_size大小映射,映射到CPUState->kvm_run,每次vm_exit都可以通过kvm_run->exit_reason判断退出原因。qemu和kvm建立映射，便于信息同步。所以kvm_run是不是就是4k的vmcs？
											|-kvm_arch_init_vcpu  //前面vcpu创建成功之后现在来真正的初始化
												|-kvm_arch_set_tsc_khz      //时钟设置
												|-kvm_vcpu_ioctl            //KVM_GET_TSC_KHZ时钟可以用户设置和从kvm获取，这里从KVM获取再保存下来
												|-hyperv_handle_properties  //设置cpuids
												|-cpu_x86_cpuid             //获取所有的CPUID信息，填充结构体，设置到寄存器中
												|-kvm_vcpu_ioctl            //前面构造KVM需要的cpuid_data数据，再通过KVM_SET_CPUID2给kvm设置cpuid
												|-kvm_init_msrs             //通知kvm设置msr寄存器
												|-hyperv_init_vcpu          //Hyper-V初始化vcpu保存一些信息在后续迁移时候恢复使用
										|-kvm_init_cpu_signals
										|-kvm_cpu_exec //每个vcpu对应一个线程，该线程循环执行

## x86


保护模式：
1. 设置gdt(global description table).cs(segment descriptor)
2. cr0

```C
static void setup_protected_mode(struct kvm_sregs *sregs) {
    struct kvm_segment seg = {
        .base = 0,
        .limit = 0xffffffff,
        .selector = 1 << 3,
        .present = 1,
        .type = 11, /* Code: execute, read, accessed */
        .dpl = 0,
        .db = 1,
        .s = 1, /* Code/data */
        .l = 0,
        .g = 1, /* 4KB granularity */
    };

    sregs->cr0 |= CR0_PE; /* enter protected mode */

    sregs->cs = seg;

    seg.type = 3; /* Data: read/write, accessed */
    seg.selector = 2 << 3;
    sregs->ds = sregs->es = sregs->fs = sregs->gs = sregs->ss = seg;

    if (ioctl(vcpu->fd, KVM_SET_SREGS, &sregs) < 0) {
        perror("KVM_SET_SREGS");
        exit(1);
    }    
}
```

分页：
```C
static void setup_paged_32bit_mode(struct vm *vm, struct kvm_sregs *sregs) {
    uint32_t pd_addr = 0x2000;
    uint32_t *pd = (void *)(vm->mem + pd_addr);

    /* A single 4MB page to cover the memory region */
    pd[0] = PDE32_PRESENT | PDE32_RW | PDE32_USER | PDE32_PS;
    /* Other PDEs are left zeroed, meaning not present. */

    sregs->cr3 = pd_addr;
    sregs->cr4 = CR4_PSE;
    sregs->cr0 = CR0_PE | CR0_MP | CR0_ET | CR0_NE | CR0_WP | CR0_AM | CR0_PG;
    sregs->efer = 0;

    if (ioctl(vcpu->fd, KVM_SET_SREGS, &sregs) < 0) {
        perror("KVM_SET_SREGS");
        exit(1);
    }
}
```
## ARMv8 cpu状态

通用寄存器：
- AArch32 有 R0 -R14
- AArch64 64bit X0-X30 32bit W0-W30

特殊寄存器，
1）存放异常返回地址的ELR_ELx；
2）各个EL的栈指针SP_ELx；
3）CPU的状态相关寄存器；

- CurrentEL： 保存PSTATE.EL
- DAIF: 保存PSTATE.{D,A,I,F}中断掩码位
- DIT: 保存PSTATE.DIT位
- ELR_EL1: 保存从EL1异常返回的地址



## vpu的生命周期管理

```C
static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
{
    AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);

    ops->create_vcpu_thread = kvm_start_vcpu_thread;
    ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
    ops->cpus_are_resettable = kvm_cpus_are_resettable;
    ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
    ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
    ops->synchronize_state = kvm_cpu_synchronize_state;
    ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;

#ifdef KVM_CAP_SET_GUEST_DEBUG
    ops->update_guest_debug = kvm_update_guest_debug_ops;
    ops->supports_guest_debug = kvm_supports_guest_debug;
    ops->insert_breakpoint = kvm_insert_breakpoint;
    ops->remove_breakpoint = kvm_remove_breakpoint;
    ops->remove_all_breakpoints = kvm_remove_all_breakpoints;
#endif
}
```
### 初始化vCPU

```C
struct CPUState {
    DeviceState parent_obj;
    CPUClass *cc;
    int nr_cores;
    int nr_threads;
    struct QemuThread *thread;
    QemuSemaphore sem;
    int thread_id;
    bool running, has_waiter;
    struct QemuCond *halt_cond;
    bool thread_kicked;
    bool created;
    bool stop;
    bool stopped;    
    bool start_powered_off;
    bool unplug;
    bool crash_occurred;
    bool exit_request;
    int exclusive_context_count;
    uint32_t cflags_next_tb;
    /* updates protected by BQL */
    uint32_t interrupt_request;
    int singlestep_enabled;
    int64_t icount_budget;
    int64_t icount_extra;
    uint64_t random_seed;
    sigjmp_buf jmp_env;

    QemuMutex work_mutex;
    QSIMPLEQ_HEAD(, qemu_work_item) work_list;

    CPUAddressSpace *cpu_ases;
    int num_ases;
    AddressSpace *as;
    MemoryRegion *memory;

    CPUArchState *env_ptr;
    IcountDecr *icount_decr_ptr;

    CPUJumpCache *tb_jmp_cache;

    struct GDBRegisterState *gdb_regs;
    int gdb_num_regs;
    int gdb_num_g_regs;
    QTAILQ_ENTRY(CPUState) node;

    /* ice debug support */
    QTAILQ_HEAD(, CPUBreakpoint) breakpoints;

    QTAILQ_HEAD(, CPUWatchpoint) watchpoints;
    CPUWatchpoint *watchpoint_hit;

    void *opaque;
    uintptr_t mem_io_pc;
    int kvm_fd;
    struct KVMState *kvm_state;
    struct kvm_run *kvm_run;
    struct kvm_dirty_gfn *kvm_dirty_gfns;
    uint32_t kvm_fetch_index;
    uint64_t dirty_pages;
    int kvm_vcpu_stats_fd;

    QemuLockCnt in_ioctl_lock;
    DECLARE_BITMAP(plugin_mask, QEMU_PLUGIN_EV_MAX);

    GArray *plugin_mem_cbs;
    SavedIOTLB saved_iotlb;

    int cpu_index;
    int cluster_index;
    uint32_t tcg_cflags;
    uint32_t halted;
    uint32_t can_do_io;
    int32_t exception_index;

    AccelCPUState *accel;
    bool vcpu_dirty;
    bool throttle_thread_scheduled;


    int64_t throttle_us_per_full;
    bool ignore_memory_transaction_failures;
    bool prctl_unalign_sigbus;
    GArray *iommu_notifiers;
};

```

kvm_start_vcpu_thread(CPUState *cpu)
	qemu_thread_create(cpu->thread, thread_name, kvm_vcpu_thread_fn, .cpu, QEMU_THREAD_JOINABLE);
		kvm_init_vcpu(cpu, &error_fatal)
			|-kvm_get_vcpu => kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id)   // 先从KVMState->kvm_parked_vcpus列表中查找cpu id，如果有就返回cpu的kvm_fd, 如果没有通过kvm创建一个vcpu，返回一个kvm_fd。 这个操作会进入内核态，会调用kvm的内核中vpu的操作函数kvm_x86_ops指向(intel)vmx_x86_ops或者(amd)svm_x86_ops。
			|-kvm_ioctl           //从kvm获取映射mmap_size(KVM_GET_VCPU_MMAP_SIZE), 这个映射的内存区域用于qemu 和kvm进行数据交换，比如IO地址，kvm退出原因等。这个大小包含kvm_run, pio data page, coalesced mmio ring page, 有可能是3*page size。这个大小有点不太明白，好像他意思是支持多个ring的，但是返回的mmpa大小最大只有3个page、
			|-mmap                //对kvm_fd进行以一个mmap_size大小映射,映射到CPUState->kvm_run,每次vm_exit都可以通过kvm_run->exit_reason判断退出原因。qemu和kvm建立映射，便于信息同步。所以kvm_run是不是就是4k的vmcs？
			|-kvm_dirty_gfns： kvm和qemu共享，用于统计vcpu级别的脏也跟踪
			|-kvm_arch_init_vcpu  //前面vcpu创建成功之后现在来真正的初始化
                |-KVM_CAP_XSAVE2：
				|-kvm_arch_set_tsc_khz      //时钟设置
				|-kvm_vcpu_ioctl            //KVM_GET_TSC_KHZ、KVM_SET_TSC_KHZ时钟可以用户设置和从kvm获取，这里从KVM获取再保存下来，涉及到tsc scaling(?)。这个部分会修改CPUState的tsc_khz
                |-apic_bus_freq = KVM_APIC_BUS_FREQUENCY // apic 总线频率
                |-kvm_hyperv_expand_features
                |-hyperv_enabled(cpu) => hyperv_init_vcpu(cpu) // KVM支持hyperv并且传入了hyperv参数
                    |-HV_X64_MSR_VP_INDEX
                    |-KVM_CAP_HYPERV_SYNIC/KVM_CAP_HYPERV_SYNIC2 => kvm_vcpu_enable_cap(cs, synic_cap, 0)
                    |-cpu->hyperv_synic_kvm_only ==false =>  hyperv_x86_synic_add(cpu) // 添加合成中断控制器SyncIC
                    |-HYPERV_FEAT_EVMCS =>  kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENLIGHTENED_VMCS) 
                    |-cpu->hyperv_enforce_cpuid => kvm_vcpu_enable_cap(cs, KVM_CAP_HYPERV_ENFORCE_CPUID)
				|-hyperv_handle_properties  //设置cpuids
                |-cpu->expose_kvm => ?
				|-cpu_x86_cpuid             //获取所有的CPUID信息，填充结构体，设置到寄存器中
                |-cpu->kvm_pv_enforce_cpuid => kvm_vcpu_enable_cap(cs, KVM_CAP_ENFORCE_PV_FEATURE_CPUID)
				|-kvm_vcpu_ioctl            //前面构造KVM需要的cpuid_data数据，再通过KVM_SET_CPUID2给kvm设置cpuid
                |-kvm_init_xsave(env)       // 支持xsave指令集
                |-嵌套支持svm|vmx
				|-kvm_init_msrs             //通知kvm设置msr寄存器

		kvm_init_cpu_signals(cpu)
            |- SIG_IPI => kvm_ipi_signal
		cpu_thread_signal_created(cpu) // 通知县城cpu已经创建
    	qemu_guest_random_seed_thread_part2(cpu->random_seed);
		loop : cpu_can_run(cpu)) =>  
            |-kvm_cpu_exec(cpu)
                |-kvm_arch_process_async_events(cpu)
                |-qemu_mutex_unlock_iothread();
                |-cpu_exec_start(cpu)
                |-vcpu_dirty => kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE);
                |-kvm_arch_pre_run(cpu, run)
                |-exit_request => kvm_cpu_kick_self()
                |-kvm_vcpu_ioctl(cpu, KVM_RUN, 0)
                |-kvm_arch_post_run(cpu, run)
                |-KVM_EXIT_IO => kvm_handle_io
                |-KVM_EXIT_MMIO => address_space_rw
                KVM_EXIT_DIRTY_RING_FULL
                KVM_EXIT_SYSTEM_EVENT
            |-qemu_wait_io_event(cpu)
		kvm_destroy_vcpu(cpu)
		cpu_thread_signal_destroyed(cpu)

### coalesced_mmio_ring

正常每次访问mmio都回导致虚拟机退出到qemu，将多个mmio操作保存起来然后一起退出到qemu中，这个就叫coalesced_mmio(合并mmio)。 目前只支持写操作的coalesced mmio。
对pio和mmio写区分位deferred和非deferred，如果非deferred就会退出。

qemu这边的api，增删改查：
1. 增加： void memory_region_add_coalescing(MemoryRegion *mr, hwaddr offset, uint64_t size)
2. 删除： void memory_region_clear_coalescing(MemoryRegion *mr)
3. 刷入： void memory_region_set_flush_coalesced(MemoryRegion *mr)



### intel cpu

#### 控制寄存器

CR0： 包含系统控制标志用于控制操作模式和处理器状态。
CR1
CR2： 存储page-fault 线性地址（即引起缺页的线性地址）
CR3：包含分页使用的物理地址载始的位置和两个标志（PCD和PWT）。只有基地址高bit位（12 bit位前的）指定，低12 bit位才假定为0，这样分页的大小就是4Kbytes。PCD和PWT标志控制分页在处理器内部缓存中的使用。
CR4： 包含的标志可用于开启架构扩展和处理器特定能力。CR4中的标志不是在所有处理器上都实现了，使用带有PCE标志的CPUID指令可以判断在当前CPU上是否实现。
CR8： 用于读写Task Priority Register(TPR)，它指定了外部中断生效的优先级阈值。CR8只对Intel 64架构可用。
XCR0： 

#### 指令集：

(aes)AES-NI指令集：高级加密标准指令集（或称英特尔高级加密标准新指令，简称AES-NI）是一个x86指令集架构的扩展，用于Intel和AMD微处理器，由Intel在2008年3月提出。该指令集的目的是改进应用程序使用高级加密标准（AES）执行加密和解密的速度。

AVX(Advanced Vector Extensions，高级矢量扩展)是Intel 和AMD的x86 架构指令集的一个扩展，2011年Intel 发布Sandy Bridge处理器时开始第一次正式支持 AVX. AVX 中的新特性有：将向量化宽度从128位提升到256位，且将 XMM0~XMM15寄存器重命名为 YMM0~YMM15；引入了三操作数、四操作数的 SIMD 指令格式；弱化了对 SIMD 指令中对内存操作对齐的要求，支持灵活的不对齐内存地址访问。

XSAVE 指令（包括 XSAVE, XRSTOR等）是在 Intel Nehalem处理器中开始引入的，是为了保存和恢复处理器 扩展状态的，在AVX引入后，XSAVE 也要处理 YMM 寄存器状态。在KVM虚拟化环境中，客户机的动态迁移需要保存处理器状态，然后迁移后恢复处理器的执行状态，如果有AVX指令要执行，在保存和恢复时也需要 XSAVE, XRSTOR 指令的支持。

## vCPU运行

qemu_kvm_cpu_thread_fn -> kvm_cpu_exec -> kvm_vcpu_ioctl(cpu, KVM_RUN, 0) -> ... -> kvm

kvm_cpu_exec: 调用kvm_run 运行子机; 分析exit的原因，进行处理

qemu_kvm_cpu_thread_fn: 由于处于while循环中，处理完一次exit后又进行ioctl调用运行虚拟机并切换到客户模式

### kvm

kvm_vcpu_ioctl(kvm_run) -> kvm_arch_vcpu_ioctl_run -> vcpu_run -> vcpu_enter_guest -> vmx_vcpu_run(vcpu) ->  __vmx_vcpu_run -> vmenter.S -> vmx_vmenter

vmenter.S执行相关的汇编指令， 调用 VMLAUNCH启动vm, VMRESUME再次进入vm. 当退出vm时，将会进行vm_exit处理。
vmx_vcpu_run：在该函数中会配置好VMCS结构中客户机状态域和宿主机状态域中相关字段的信息，vmcs结构是由CPU自动加载与保存的 ，通过vmcs的相关指令读来实现（vmcs_writel，vmcs_write32等等）；另外还会调用汇编函数，主要是KVM为guest加载通用寄存器和调试寄存器信息，因为这些信息CPU不会自动加载，需要手动加载。一切就绪后执行 VMLAUNCH或者VMRESUME指令进入客户机执行环境。另外，guest也可以通过VMCALL指令调用KVM中的服务。
vcpu_enter_guest：该函数返回1，继续保持vcpu运行，否则退回到userspace.

r = kvm_x86_ops->handle_exit(vcpu)：需要对exit的原因进行处理，根据exit reason来决定是否交由userspace处理。
vmx_henadle_exit->handle_io
                ->handle_rdmsr
                ->handle_ept_violation
                ->handle_vmx_instruction return 1;
exit reason 被记录在 kvm run中,kvm_run被映射到qemu层面的CPU结构体中，因此可以在qemu层获得exit_reason