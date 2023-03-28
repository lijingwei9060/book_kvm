
# 原理
vPerCPUTime = ((RDTSC() - pvti.tsc_timestamp) >> tsc_shift) * tsc_to_system_mul + pvti.system_time

# 数据结构
x86_init_ops.x86_hyper_init
x86_hyper_kvm.init.init_platform		= kvm_init_platform,
struct x86_init_ops x86_init
const struct hypervisor_x86 x86_hyper_kvm

- #define HVC_BOOT_ARRAY_SIZE (PAGE_SIZE / sizeof(struct pvclock_vsyscall_time_info))
- static struct pvclock_vsyscall_time_info hv_clock_boot[HVC_BOOT_ARRAY_SIZE] : 1个Page中包含`HVC_BOOT_ARRAY_SIZE`个 time_info, 对应vcpu的个数
- static struct pvclock_wall_clock wall_clock：  静态全局变量wall_clock,存储于bss段 
- static struct pvclock_vsyscall_time_info *hvclock_mem;
- DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
- EXPORT_PER_CPU_SYMBOL_GPL(hv_clock_per_cpu);
- struct clocksource kvm_clock;
- DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
- static int kvmclock  = 1; // 默认支持kvmclock，可以指定no_kvmclock覆盖。
- static int kvmclock_vsyscall  = 1;
- static int msr_kvm_system_time  = MSR_KVM_SYSTEM_TIME; // 读写system_time的msr
- static int msr_kvm_wall_clock  = MSR_KVM_WALL_CLOCK;   // 读写wall_clock的msr
- static u64 kvm_sched_clock_offset： //sched_clock启动的时间，单位为cycle
- DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
- DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
# clocksource

```C
struct clocksource kvm_clock = {
	.name	= "kvm-clock",
	.read	= kvm_clock_get_cycles,
	.rating	= 400,
	.mask	= CLOCKSOURCE_MASK(64),
	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
	.enable	= kvm_cs_enable,
};
```
注册的时候会调用enable：
```C
kvm_cs_enable()
    |-> vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK)
        |-> WRITE_ONCE(vclocks_used, READ_ONCE(vclocks_used) | (1 << which))
```

读取cycle：
```C
kvm_clock_get_cycles(clocksource *cs)   // 整个过程只有读取tsc读取涉及到硬件其他都是virtio完成，也就不会有vmexit退出
|-> kvm_clock_read()
    |-> ret = pvclock_clocksource_read(this_cpu_pvti())
        |-> ret = __pvclock_read_cycles(src, rdtsc_ordered()); // rdtsc_ordered读出tsc，
            |->  src->system_time + (tsc - src->tsc_timestamp) src->tsc_to_system_mul >> src->tsc_shift // 这里读出来的应该是时间了
        |-> last = atomic64_cmpxchg(&last_value, last, ret); // 保存上一次读出来的值
```

# 初始化过程

early_param("no-kvmclock", parse_no_kvmclock);
early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);

```C
kvm_init_platform
    |-> kvmclock_init()
        |-> msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW; `0x4b564d01`
		|-> msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW; `0x4b564d00`
        |-> cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu", kvmclock_setup_percpu, NULL) // // hp：hotplug, BP:bootstrap启动 启动热插拔主核的动态准备
        |-> this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0])// 将hv_clock_boot数组第一个元素的地址(虚拟地址)赋值, 给local cpu变量hv_clock_per_cpu
        |-> kvm_register_clock("primary cpu clock") // 将vcpu0的hv_clock_per_cpu物理地址写入msr_kvm_system_time指向的msr中,
        |-> pvclock_set_pvti_cpu0_va(hv_clock_boot) // 将hv_clock_boot的数组地址写入pvti_cpu0_va中，pvti_cpu0_va是一个pvti类型的指针
        |-> pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT) // 半虚拟化时钟TSC是否稳定指示bit，什么作用呢？
        |-> kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT) // 进行时钟调度初始化，sched_clock()用于时钟调度、时间戳，及利用硬件计数器的延时以提供一个精确的延迟时钟源
            |-> kvm_sched_clock_offset = kvm_clock_read();   
	        |-> paravirt_set_sched_clock(kvm_sched_clock_read); // 注册sched_clock
        |-> x86_platform.calibrate_tsc = kvm_get_tsc_khz; // tsc_khz为Host的pTSCfreq，指向host TSC频率的指针
        |-> x86_platform.calibrate_cpu = kvm_get_tsc_khz;
        |-> x86_platform.get_wallclock = kvm_get_wallclock; // wallclock：获得系统boot时的秒数和纳秒数（绝对时间，自1970）
        |-> x86_platform.set_wallclock = kvm_set_wallclock;
        |-> x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;  // 注册各非vcpu0的时钟，将各vCPU0的vptihv_clock_per_cpu写入各自的msr_kvm_system_time指向的msr中
        |-> x86_platform.save_sched_clock_state = kvm_save_sched_clock_state; // 保存sched_clock的状态，事实什么都没做
        |-> x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
        |-> kvm_get_preset_lpj();  // lpj:loops_per_jiffy
        |-> clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);  // 1Ghz的kvmclock source的注册
    |-> x86_platform.apic_post_init = kvm_apic_init;
```


# wall_clock

kvm_get_wallclock
```C
read_persistent_clock64(wall_time) => x86_platform.get_wallclock(ts) => x86_platform.kvm_get_wallclock(ts)
|-> rmsrl(msr_kvm_wall_clock, slow_virt_to_phys(&wall_clock)); // 将wall_clock的物理地址写入到MSR_KVM_WALL_CLOCK, 触发wrmsr_vmexit
    |-> handle_wrmsr=>kvm_set_msr=>kvm_x86_ops->set_msr=>vmx_set_msr=>kvm_set_msr_common // 这个过程是在host的kvm模块中
        |-> MSR_KVM_WALL_CLOCK_NEW, MSR_KVM_WALL_CLOCK, vcpu->kvm->arch.wall_clock = data; kvm_write_wall_clock(vcpu->kvm, data);
            |-> getboottime64(&boot); // 获取host的boot time并写入boot变量,
            |-> boot = timespec64_sub(boot, ts); //对host boot time做一些调整
            |-> kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc)); // 将wc即host boot time的内容写入guest的wallclock中
|-> pvclock_read_wallclock(&wall_clock, this_cpu_pvti(), now); // 从地址中读取时间
```