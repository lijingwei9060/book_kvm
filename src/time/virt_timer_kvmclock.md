# 概述，虚拟化下的时钟

1. TSC：Guest中使用rdtsc指令读取TSC时，会因为EXIT_REASON_RDTSC导致VM Exit。VMM读取Host的TSC和VMCS中的TSC_OFFSET，然后把host_tst+tsc_offset返回给Guest。要做出OFFSET的原因是考虑到vcpu热插拔和Guest会在不同的Host间迁移。
2. qemu软件模拟的时钟：qemu中有对RTC和hpet都模拟出了相应的设备，例如RTC的典型芯片mc146818。这种软件模拟时钟中断存在的问题：由于qemu也是应用程序，受到cpu调度的影响，软件时钟中断不能及时产生，并且软件时钟中断注入则是每次发生VM Exit/Vm Entry的时刻。所以软件模拟时钟就无法精准的出发并注入到Guest，存在延迟较大的问题。
3. kvm-clock是KVM下Linux Guest默认的半虚拟化时钟源。在Guest上实现一个kvmclock驱动，Guest通过该驱动向VMM查询时间。其工作流程也比较简单：Guest分配一个内存页，将该内存地址通过写入MSR告诉VMM，VMM把Host系统时间写入这个内存页，然后Guest去读取这个时间来更新。这里使用到的两个MSR是：MSR_KVM_WALL_CLOCK_NEW和MSR_KVM_SYSTEM_TIME_NEW（这是新的，使用cpuid 0x40000001来标志使用新的还是旧的）分别对应pvclock_wall_clock和pvclock_vcpu_time_info（具体结构体中的内容在内核代码中可查看）。

# 虚拟化下，时钟管理的问题
1. 对于传统时钟硬件的模拟，比如rtc、pit、hpet等设备。需要在qemu中实现对应的硬件模拟，对应IO读写则陷入到qemu，再由qemu创建对应的hrtimer？这个效率和延迟可想而知会比较大。
2. 对于Linux虚拟机使用kvm-clock，通过host主机sched_clock更新虚拟机的时间。由于vcpu和pcpu的关系是动态的，tsc可能导致后退，带来大量的tsc问题。
3. 虚拟机热迁移，不同cpu的tsc_khz不同，如何保证时间在热迁移后正常。


# 原理
     PVTI(pvclock_vsyscall_time_info)


# Basics
- 每300秒（KVMCLOCK_SYNC_PERIOD）调用一次kvmclock_sync_fn，它会调用kvmclock_update_fn
- kvmclock_update_fn会对每个vCPU发送KVM_REQ_CLOCK_UPDATE
- KVM_REQ_CLOCK_UPDATE ==> kvm_guest_time_update(vcpu)
- KVM_REQ_GLOBAL_CLOCK_UPDATE ==> kvm_gen_kvmclock_update(vcpu)
- 立即对当前vCPU发送KVM_REQ_CLOCK_UPDATE
- 100毫秒后触发kvmclock_update_fn
- KVM_REQ_MASTER_CLOCK_UPDATE ==> kvm_update_masterclock


# kvm host部分(gtod: generic time of day)
- pvclock_vcpu_time_info: 在host中保存，用于guest和host之间进行时间更新同步，每个vcpu有一个数据结构，保存system time 和tsc timestamp。
- pvclock_wall_clock： 在host中记录的虚拟机启动时间点
- static struct pvclock_gtod_data pvclock_gtod_data: kvm定义，是一个全局变量，kvm会在host的每个tick时更新该变量的内容。也就是这个对应多有的虚拟机，不是某个vcpu的。只有use_master_clock为真时,kvm维护的pvclock_gtod_data的内容才会起作用。 这个变量和pvti以及use_master的关系是什么？

KVM中定义了如下数据结构（pvclock），用来提供kvmclock：共享吗？
```C
struct pvclock_gtod_data {
    seqcount_t  seq;

    struct { /* extract of a clocksource struct */
        int vclock_mode;
        u64 cycle_last;
        u64 mask;
        u32 mult;
        u32 shift;
    } clock;

    u64     boot_ns;
    u64     nsec_base;
    u64     wall_time_sec;
};

static struct pvclock_gtod_data pvclock_gtod_data;
```
## KVM写入system time
host对system time的写入一般来说有2种情况,同步写入和异步写入.
1. 同步写入指的是随着host中sched_time的tick周期性更新Host kvm全局变量`pvclock_gtod_data`。 vm读取的是kvm_arch.master_cycle_now和kvm_arch.master_kernel_ns。如何从`pvclock_gtod_data`到`kvm_arm。master_cycle_now`(host_tsc)和`kvm_arch.master_kernel_ns`(kernel_ns) 呢？从直觉上可以判定几个地方会出现： 
   1. 虚拟机创建进行初始化的时候，调用链`struct kvm *kvm_create_vm(unsigned long type)` => `kvm_arch_init_vm` => `pvclock_update_vm_gtod_copy(kvm)`。
   2. 虚拟机vm-enter的时候检测到`KVM_REQ_MASTERCLOCK_UPDATE`, 调用链 `static int vcpu_enter_guest(struct kvm_vcpu *vcpu)` => `kvm_update_masterclock(kvm)` =>` pvclock_update_vm_gtod_copy(kvm)`。
   3. 在userspace(如qemu)主动发起更新时间的请求时，调用链`kvm_vm_ioctl_set_clock(kvm)` => `pvclock_update_vm_gtod_copy(kvm)`。
   4. 对于hyper-v的支持，调用链`kvm_hyperv_tsc_notifier()` => `pvclock_update_vm_gtod_copy(kvm)`。
2. 异步写入指的是在特殊事件发生时(如guest suspend时),更新guest中system time的值,防止guest中的时间出错.

### kvm host对guest system time的同步写入
kvm模块在初始化(`kvm_init` => `kvm_arch_init`)的时候注册了2个回调函数：
1. 对于不支持`X86_FEATURE_CONSTANT_TSC`的CPU频率变化的回调函数，调用链`kvm_timer_init` => `cpufreq_register_notifier`(&`kvmclock_cpufreq_notifier_block`, `CPUFREQ_TRANSITION_NOTIFIER`)。同时，也注册一个CPU上下线的对tsc_khz的变更函数。
2. 向timekeeper注册了一个回调函数, 调用链`pvclock_gtod_register_notifier`(&`pvclock_gtod_notifier`)。关于`pvclock_gtod_register_notifier`在注释上已经说明是每次系统时间更新后会调用`pvclcok gtod notifer`。 这个回调函数会随着tick的周期更新全局变量`pvclock_gtod_notify`。但是并没有直接修改PVTI，为什么呢？


回调函数的工作, 随着host的tick_sched中的时钟周期型调用，更新`pvclock_gtod_notify`。这个回调函数首先将timekeeper中的monotonic时钟、raw monotonic时钟、wall time(xtime_sec)、offs_boot拷贝到`pvclock_gtod_data`上。如若发现物理机不是基于tsc而虚拟机基于使用了master clock，说明物理机的时钟发生了变化这个时候需要发出`KVM_REQ_MASTERCLOCK_UPDATE`请求，要求所有虚拟机退出更新master 时钟。

疑问： 在这个过程中，虚拟机和物理机同步的pvti并没有更新，所以虚拟机这个时候读取时间会不会有问题呢？
```C
pvclock_gtod_notifier => pvclock_gtod_notify
|-> update_pvclock_gtod(tk) // 更新pvclock
    |-> 将tk的monotonic时钟(tkr_mono), raw monotonic时钟(tkr_raw), 墙上时间(xtime_sec), offs_boot复制到`pvclock_gtod_data` => raw_clock,  xtime_sec => wall_time_sec, offf_boot => offs_boot // pvclock_gtod获得了更新
|-> irq_work_queue(&pvclock_irq_work) => pvclock_irq_work_fn => pvclock_gtod_work => pvclock_gtod_update_fn // 如果物理机不使用tsc，禁用master clock
    |-> pvclock_gtod.clock不是tsc并且kvm_guest_has_master_clock !=0 => kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu) // 对所有vm的所有vcpu发送KVM_REQ_MASTERCLOCK_UPDATE, 这是一个异步事件
        |-> set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests) // 可以看出来make request是在vcpu的requests上设置一个标记
```

回调函数的触发机制：
调用点： 
- int do_settimeofday64(const struct timespec64 *ts)
- int do_adjtimex(struct __kernel_timex *txc)
- static bool timekeeping_advance(enum timekeeping_adv_mode mode)
- int timekeeping_suspend(void)
- void timekeeping_resume(void)
- void timekeeping_inject_sleeptime64(const struct timespec64 *delta)
- void __init timekeeping_init(void)
- static int change_clocksource(void *data)
- static int timekeeping_inject_offset(const struct timespec64 *ts)

```C
timekeeping_update(tk, action)
|-> update_pvclock_gtod(tk, action & TK_CLOCK_WAS_SET)
	|-> raw_notifier_call_chain(&pvclock_gtod_chain, was_set, tk)
```

### kvm host对guest system time的异步写入
host对system time的异步写入通过qemu实现,利用kvm_vm_ioctl(KVM_SET_CLOCK),与kvm发生交互。触发的场景以及态如何触发呢？
而kvm中,KVM_SET_CLOCK的ioctl的定义如下:
```C
case KVM_SET_CLOCK: {
		struct kvm_clock_data user_ns;
		u64 now_ns;

		r = -EFAULT;
		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
			goto out;

		r = -EINVAL;
		if (user_ns.flags)
			goto out;

		r = 0;
		/*
		 * TODO: userspace has to take care of races with VCPU_RUN, so
		 * kvm_gen_update_masterclock() can be cut down to locked
		 * pvclock_update_vm_gtod_copy().
		 */
		kvm_gen_update_masterclock(kvm); // 确认guest能否使用masterclock,并向所有vcpu发出时间更新请求
		now_ns = get_kvmclock_ns(kvm); // 读取当前cpu的时间
		kvm->arch.kvmclock_offset += user_ns.clock - now_ns; // 确认当前cpu和qemu传入的cpu时间的offset
		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE); // 利用新的offset对所有vcpu的时间进行更新
		break;
	}
```
可以看到,kvm_vm_ioctl(KVM_SET_CLOCK)做了以下几件事情:
1. 确认guest能否使用masterclock,并向所有vcpu发出时间更新请求
2. 读取当前cpu的时间(根据是否使用masterclock,读取时间的方式不同)
3. 计算当前cpu和qemu传入的cpu时间的offset
4. 利用新的offset对所有vcpu的时间进行更新

masterclock: 由于我们的kvmclock依赖于Host Boot Time和Host TSC两个量，即使Host TSC同步且Guest TSC同步，在pCPU0和pCPU1分别取两者，前者的差值和后者的差值也可能不相等，并且谁大谁小都有可能，从而可能违反kvmclock的单调性。因此，我们通过只使用一份Master Copy，即Master Clock,来解决这个问题。

# kvm对时钟处理
guest从pvti结构读取system time的触发点为上面提到的3种request:
- KVM_REQ_MASTERCLOCK_UPDATE
- KVM_REQ_GLOBAL_CLOCK_UPDATE
- KVM_REQ_CLOCK_UPDATE


### KVM_REQ_MASTERCLOCK_UPDATE: 请求更新master时钟
这个请求的作用：判断虚拟机的时钟能不能进入master模式，或者需要从master模式退出后需要再次进入master。如果不行(host 时钟不稳定)，在需要每个vCPU分配时间。

发出这种请求的原因和调用链：
可能1: 在guest os运行过程中,如果出现kvm_set_msr_common(MSR_IA32_TSC), 且满足masterclock使能条件,且masterclock使能,则发出KVM_REQ_MASTERCLOCK_UPDATE请求。调用链： kvm_track_tsc_matching => kvm_write_tsc => kvm_set_msr_common写MSR_IA32_TSC 。虚拟机在什么情况下会触发这种情况？
```C
int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
|-> MSR_IA32_TSC if (msr_info->host_initiated) 
	|-> static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
		|-> static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc, u64 ns, bool matched)
			|-> kvm_track_tsc_matching(vcpu);
				|-> 使用master_clock或者基于tsc，kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
```
可能2: 在创建vcpu时,满足masterclock使能条件,且masterclock使能,则发出KVM_REQ_MASTERCLOCK_UPDATE请求. 调用链： kvm_track_tsc_matching => kvm_write_tsc => kvm_arch_vcpu_postcreate => kvm_vm_ioctl_create_vcpu。
```C
kvm_vm_ioctl_create_vcpu()
|-> void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
	|->static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
		|-> static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc, u64 ns, bool matched)
			|-> kvm_track_tsc_matching(vcpu);
```
可能3： 写MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW时,如果使用的是新版kvmclock,即写的是MSR_KVM_SYSTEM_TIME_NEW, 则发出KVM_REQ_MASTERCLOCK_UPDATE.这是systemTime的初始化期间的一段.
```C
static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time, bool old_msr, bool host_initiated)
|-> 第一个cpu，kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
```
可能4： 在pvclock_gtod_update_fn中,对所有vcpu发出了KVM_REQ_MASTERCLOCK_UPDATE.而pvclock_gtod_update_fn的调用路径为:`xxx`。 当host更新时间,且kvm发现guest的clocksource从TSC变为非TSC时,发出KVM_REQ_MASTERCLOCK_UPDATE请求.
```C
pvclock_gtod_update_fn(work)
|-> kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
|-> kvm_guest_has_master_clock = 0
```
可能5： 在kvm_arch_hardware_enable中,发现guest tsc发生了倒退,那么向所有vcpu发出KVM_REQ_MASTERCLOCK_UPDATE请求.
```C
int kvm_init()
|-> int kvm_starting_cpu(cpu)
	|-> void hardware_enable_nolock(void *junk)
		|-> kvm_arch_hardware_enable()
			|-> backwards_tsc => kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu)
```

```C
kvm_synchronize_tsc(vcpu, data)
|-> __kvm_synchronize_tsc(vcpu, offset, data, ns, matched)
	|-> kvm_track_tsc_matching(vcpu)
		|-> kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu)
		|-> trace_kvm_track_tsc()
```
当masterclock被使能,就一直发出`KVM_REQ_MASTERCLOCK_UPDATE`请求,以更新masterclock. 这样情况的代码在`kvm_track_tsc_matching`中。
masterclock何时可以被使能:
1. host clocksource必须为tsc
2. vcpus必须有matched tsc,即vcpus的v_tsc必须与host_tsc频率一直

KVM处理过程：
在`KVM_REQ_MASTER_CLOCK_UPDATE`的handler `kvm_update_masterclock`中做了以下几件事:
1. 给所有vCPU发送`KVM_REQ_MCLOCK_INPROGRESS`，将它们踢出Guest模式，该请求没有Handler，因此vCPU无法再进入Guest
2. 更新hyper-v虚拟机的hv_tsc_page_status为`HV_TSC_PAGE_HOST_CHANGED`
3. 确认guest能否使用master_clock(用于vcpu之间的时间同步): host使用tsc，所有vcpu的tsc相等，没有观察到tsc倒退，没有使用旧版kvmclock
4. 如果use_master_clock为1, 就将kvm_guest_has_master_clock设为1
5. 更新master时钟
6. 对所有vcpu发出了更基本的请求,即KVM_REQ_CLOCK_UPDATE请求(在KVM_REQ_CLOCK_UPDATE的处理中说明).
7. 清除所有vCPU的KVM_REQ_MCLOCK_INPROGRESS request bit，让vCPU重新进入Guest

调用链：
```C
static void kvm_update_masterclock(struct kvm *kvm)
|-> kvm_make_mclock_inprogress_request(kvm) 
	|-> kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS) // 给所有vCPU发送`KVM_REQ_MCLOCK_INPROGRESS`，将它们踢出Guest模式，该请求没有Handler，因此vCPU无法再进入Guest
|-> __kvm_start_pvclock_update(kvm)
|-> kvm_hv_request_tsc_page_update(kvm) // 更新hyper-v虚拟机的hv_tsc_page_status为`HV_TSC_PAGE_HOST_CHANGED`
	|-> struct kvm_hv *hv = to_kvm_hv(kvm);
	|-> hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
|-> pvclock_update_vm_gtod_copy(kvm) //确认guest能否使用master_clock(用于vcpu之间的时间同步)
    |-> vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 == atomic_read(&kvm->online_vcpus)); // 表示vcpus的tsc频率是否match
    |-> host_tsc_clocksource = kvm_get_time_and_clockread(&ka->master_kernel_ns, &ka->master_cycle_now); // 如果host使用tsc,host_tsc_clocksource为true
    |-> ka->use_master_clock = host_tsc_clocksource && vcpus_matched && !ka->backwards_tsc_observed	&& !ka->boot_vcpu_runs_old_kvmclock; // backwards_tsc_observed表示是否观察到tsc倒退现象
    |-> atomic_set(&kvm_guest_has_master_clock, 1); // 如果use_master_clock为1,就将kvm_guest_has_master_clock设为1
    |-> trace_kvm_update_master_clock(ka->use_master_clock, vclock_mode, vcpus_matched)
|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu) //给所有vCPU发送KVM_REQ_CLOCK_UPDATE
|-> kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu) // 清除所有vCPU的KVM_REQ_MCLOCK_INPROGRESS request bit，让vCPU重新进入Guest
```

### KVM_REQ_GLOBAL_CLOCK_UPDATE： 单个vCPU变化导致所有时钟同步
1. 在kvmclock驱动初始化时,kvmclock_init()中的kvm_register_clock触发wrmsr进而调用kvm_set_msr_common写MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW, 发出KVM_REQ_GLOBAL_CLOCK_UPDATE请求。
```C
static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time, bool old_msr, bool host_initiated)
|-> kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
```
2. 在做从vcpu到pcpu(物理cpu)的迁移时, 如果guest的tsc不一致,则需要发KVM_REQ_GLOBAL_CLOCK_UPDATE请求.
```C
static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
|->	void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
	|-> if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1) kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
```

KVM处理：
对于`KVM_REQ_GLOBAL_CLOCK_UPDATE`请求, kvm首先对当前vcpu发送了更基本请求,即`KVM_REQ_CLOCK_UPDATE`请求,在发出请求后100ms,调用`kvmclock_update_fn`,`kvmclock_update_fn`的作用是对所有vcpu发出KVM_REQ_CLOCK_UPDATE请求。也就是说,`KVM_REQ_GLOBAL_CLOCK_UPDATE`的处理为:
1. 向当前vcpu发送KVM_REQ_CLOCK_UPDATE请求
2. 向所有vcpu发送KVM_REQ_CLOCK_UPDATE请求,并kick所有vcpu.

```C 
static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, v); // 立即发送KVM_REQ_CLOCK_UPDATE请求
|-> schedule_delayed_work(&kvm->arch.kvmclock_update_work, KVMCLOCK_UPDATE_DELAY); // 100ms后触发kvmclock_update_fn
	|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
	|-> kvm_vcpu_kick(vcpu);
```

# kvm vm部分

kvmclock_setup_percpu(cpu) // 设置对应cpu的pvti地址，这个地址可能是静态的也可能是动态的。地址是gva、gpa？
early_initcall(kvm_setup_vsyscall_timeinfo) 
|-> kvmclock_init_mem() // 分配hv_clock_boot[HVC_BOOT_ARRAY_SIZE] 动态部分，如果HVC_BOOT_ARRAY_SIZE > cpus不用做什么，否则分配hvclock_mem。内存是host和vm同步，不能加密
## 数据结构
- pvclock_vsyscall_time_info： 虚拟机中每cpu变量， 和host中的`pvclock_vcpu_time_info`对应，通过这个部分进行时间交互。
- struct clocksource kvm_clock : 虚拟机中kvm_clock, rating = 400,
- static u8 valid_flags = 0: kvm-clock的flag，从pvti的flags中读取，由host设置
- static atomic64_t last_value = 0: 若不在Master Clock模式，则上述求得的System Time可能出现倒退，我们用一个全局变量last_value记录上次kvm_clock读到的值，若当前求得的System Time小于last_value，则本次读取返回last_value，否则返回System Time并设置last_value为System Time
- static struct pvclock_vsyscall_time_info *pvti_cpu0_va： vCPU0对应的pvti地址，指向hv_clock_boot[0]的地址，也就是gva。
- #define HVC_BOOT_ARRAY_SIZE (PAGE_SIZE / sizeof(struct pvclock_vsyscall_time_info)): 一个页面包含多少个pvti，如果比cpu的个数少，初始化内存的时候再申请。
- static struct pvclock_vsyscall_time_info hv_clock_boot[HVC_BOOT_ARRAY_SIZE]： 在bss段静态初始化
- static struct pvclock_vsyscall_time_info *hvclock_mem： vm中动态初始化的pvti，`HVC_BOOT_ARRAY_SIZE` 可能比vCPU数量少。
- DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu)： 每个vCPU的pvti。


## vm中激活kvm_clock
`kvmclock_init()`检查kvm版本特性是否支持kvmclock，配置msr地址，准备setup_percpu的变量。
1. 确定了各vcpu要使用的MSR
2. 将各vcpu在kvmclock中实际使用的数据结构pvclock_vsyscall_time_info的物理地址利用write_msr写到属于每个vcpu的MSR
3. 将1GHz的kvmclock作为clocksource注册到系统clocksource中

```C
kvm_init_platform
    |-> kvmclock_init()
        |-> msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW; `0x4b564d01`
		|-> msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW; `0x4b564d00`
        |-> cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu", kvmclock_setup_percpu, NULL) => kvmclock_setup_percpu(cpu) // hp：hotplug, BP:bootstrap启动 启动热插拔主核的动态准备, 给每个cpu分配pvti地址
        |-> this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0])// 将hv_clock_boot数组第一个元素的地址(虚拟地址)赋值, 给local cpu变量hv_clock_per_cpu
        |-> kvm_register_clock("primary cpu clock") // 将vcpu0的hv_clock_per_cpu物理地址写入msr_kvm_system_time指向的msr中,todo: 这个肯定导致vcpu退出到kvm，由kvm处理，对应哪里？
            |-> pa = slow_virt_to_phys(&src->pvti) | 0x01ULL; // 由va获得pa
	        |-> wrmsrl(msr_kvm_system_time, pa); => //todo: vmexit后的处理
        |-> pvclock_set_pvti_cpu0_va(hv_clock_boot) // 将hv_clock_boot的数组地址写入pvti_cpu0_va中，pvti_cpu0_va是一个pvti类型的指针，全局变量，方便快速查找。
        |-> pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT) // 半虚拟化时钟TSC是否稳定指示bit，什么作用呢？
        |-> kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT) // 进行时钟调度初始化，sched_clock()用于时钟调度、时间戳，及利用硬件计数器的延时以提供一个精确的延迟时钟源
            |-> kvm_sched_clock_offset = kvm_clock_read();   
	        |-> paravirt_set_sched_clock(kvm_sched_clock_read); // 注册sched_clock
        |-> x86_platform.calibrate_tsc = kvm_get_tsc_khz; // tsc_khz为Host的pTSCfreq，指向host TSC频率的指针
        |-> x86_platform.calibrate_cpu = kvm_get_tsc_khz;
        |-> x86_platform.get_wallclock = kvm_get_wallclock; // wallclock：获得系统boot时的秒数和纳秒数（绝对时间，自1970）
        |-> x86_platform.set_wallclock = kvm_set_wallclock; // 返回-ENODEV，虚拟机不能写入
        |-> x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;  // 注册各非vcpu0的时钟，将各vCPU0的vptihv_clock_per_cpu写入各自的msr_kvm_system_time指向的msr中
        |-> x86_platform.save_sched_clock_state = kvm_save_sched_clock_state; // 保存sched_clock的状态，事实什么都没做
        |-> x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
        |-> kvm_get_preset_lpj();  // lpj:loops_per_jiffy
        |-> clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);  // 1Ghz的kvmclock source的注册
    |-> x86_platform.apic_post_init = kvm_apic_init;
```

## vm中墙上时钟管理

kvmclock还提供了读取wall clock的功能，模拟物理机的RTC功能，读取`kvm_get_wallclock`和写入`kvm_set_wallclock`墙上始终。因为是模拟的，关机的时候也会调用写入，但写入其实什么也没有做。虚拟机里面有一个类型为struct pvclock_wall_clock的全局变量wall_clock(静态初始化在bss端，不能内存加密，加密kvm就没法和虚拟机通信了)，保存着启动wall_clock。这个变量的地址需要通过msr`msr_kvm_wall_clock`告诉kvm，然后通过这个地址读取wall_clock.

`msr_kvm_wall_clock`根据KVM的版本可能指向`MSR_KVM_WALL_CLOCK(0x11)`或者`MSR_KVM_WALL_CLOCK_NEW(0x4b564d00)`。

guest的`wall_clock`来自于RTC时钟, 且该`wall_clock`由该虚拟机所有vcpu共享。如果vcpu想获得wallclock,就得写属于这台虚拟机的msr_wall_clock.每当Host的wallclock的内容更新,kvm会将更新所有vcpu都能读到最新wallclock, 而不是只有写msr_wall_clock的那个vcpu可以读到.

```C
struct pvclock_wall_clock {
    u32   version;
    u32   sec;
    u32   nsec;
} __attribute__((__packed__));
```
kvm对此的模拟如下：
1. 设置kvm->arch.wall_clock = GPA
2. 通过getboottime64获得Host Boot时刻的Wall Clock，再减去kvmclock_offset，得到的值填入wall_clock

然后，虚拟机中`kvm_get_wallclock`调用`pvclock_read_wallclock`，首先通过`pvclock_clocksource_read`获得当前时刻的System Time，然后加上wall_clock中的时间，最终即可得到当前时刻的Wall Clock Time。

```C
kvm_get_wallclock(timespec64 now) // 获得vm启动时候的时间，其他的时间都可以now+ offset推算
|-> wrmsrl(msr_kvm_wall_clock, slow_virt_to_phys(&wall_clock)) // 写入wall_clock的gpa地址到msr_kvm_wall_clock，这个会导致vmexit, todo:kvm做什么
|-> pvclock_read_wallclock(&wall_clock, this_cpu_pvti(), now) 
    |-> 将wall_clock的sec、nsec拷贝到now，wall_clock中的是vm的启动时间
    |-> delta = pvclock_clocksource_read(vcpu_time) // 读取pvti中的cpu启动时间得到启动后时间tsc
    |-> wall_clock + delta => now
```

wrmsrl(msr_kvm_wall_clock, slow_virt_to_phys(&wall_clock)) 会导致wrmsr_vmexit, kvm中系统调用过程handle_wrmsr  => kvm_set_msr => kvm_x86_ops->set_msr => vmx_set_msr => kvm_set_msr_common
```C
kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info) // 处理通用msr设置
|-> u64 data = msr_info->data; // 这个data是虚拟机的wall_clock变量的物理地址
|-> MSR_KVM_WALL_CLOCK_NEW, MSR_KVM_WALL_CLOCK => vcpu->kvm->arch.wall_clock = data; kvm_write_wall_clock(vcpu->kvm, data, 0); 
    |-> wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm) // 获取real_ns - kvmoffset, 
        |-> ka->use_master_clock => kvm_get_walltime_and_clockread() //如果是基于tsc的，修改flags，否则读取tsc，使用master ，flag增加stable，使用kvm.arch.master_kernel来计算及时间
        |-> kvm_get_time_scale()
        |-> __pvclock_read_cycles() 
        |-> get_kvmclock_base_ns() // 如果不是master，直接获取物理主机的boottime
    |-> wc_sec_hi // ?    
    |-> kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc)); // 将wc即host boot time的内容写入guest的wallclock中
```

## guest中system time分配
虚拟机将pvti的物理地址通过msr`msr_kvm_system_time`告知kvm。 `msr_kvm_system_time` 根据KVM版本指向`MSR_KVM_SYSTEM_TIME`或者 `MSR_KVM_SYSTEM_TIME_NEW`。
kvm_register_clock() 
|-> wrmsrl(msr_kvm_system_time, pa); // 将该cpu的pvti结构的物理地址通过写msr的方式写入对应msr_kvm_system_time

虚拟机通过msr写入pvti的物理地址给kvm，会触发wrmsr_vmexit, 处理流程 handle_wrmsr => kvm_set_msr => kvm_x86_ops->set_msr => vmx_set_msr => kvm_set_msr_common。

vcpu0使用旧的kvmclock msr与当前的boot_vcpu_runs_old_kvmclock标志不一致,那么一定是出了一些什么问题,需要校准MASTERCLOCK,发出KVM_REQ_MASTERCLOCK_UPDATE请求, 然后进行普通vcpu的操作.

其他vcpu: 只需要将该vcpu的pvti的物理地址值赋值给该vcpu的arch.time,并发出KVM_REQ_GLOBAL_CLOCK_UPDATE请求。也就是说,vcpu0有可能连续发出两个REQUEST。之后根据kvm_gfn_to_hva_cache_init的结果将pv_time_enabled置为true或false。
```C
int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
|-> kvm_write_system_time(vcpu, data, false, msr_info->host_initiated); // data是pvti的gpa地址, host_initiated在handle_wrmsr()中会被置false
    |-> 如果是cpu_id == 0, kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu) // 如果没有使用旧的kvmclock,则发出KVM_REQ_MASTERCLOCK_UPDATE请求
    |-> vcpu->arch.time = system_time // 保存pvti地址
    |-> kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu); // 将该vcpu的pvti的物理地址值赋值给该vpcu的arch.time,并发出KVM_REQ_GLOBAL_CLOCK_UPDATE请求
    |-> vcpu->arch.pv_time_enabled = false; // 确保pvti的bit0不为0,如果为0,将不使用kvmclock
    |-> gfn_to_hva_cache => vcpu->arch.pv_time_enabled = true
```

### guest从pvti结构读取system time





### KVM_REQ_CLOCK_UPDATE
触发：
1. `kvm_update_masterclock`中, 对所有vcpu发出`KVM_REQ_CLOCK_UPDATE`请求。而`kvm_update_masterclock`为`KVM_REQ_MASTERCLOCK_UPDATE`请求的handler.
2. 在`kvmclock_update_fn`函数中对所有vcpu发出`KVM_REQ_CLOCK_UPDATE`请求,`kvmclock_update_fn`的调用顺序为:即在kvmclock的同步函数中定义了立即作业(更新kvmclock),和延时作业(同步kvmclock).也就是说,kvm第一次调用同步kvmclock函数后,每300s更新和同步一次kvmclock,每次更新kvmclock时都发出`KVM_REQ_CLOCK_UPDATE`请求.
3. `kvm_gen_kvmclock_update`中,对当前vcpu发出`KVM_REQ_CLOCK_UPDATE`请求,100ms后调用更新kvmclock函数`kvmclock_update_fn`,后者对所有vcpu发出`KVM_REQ_CLOCK_UPDATE`请求.`kvm_gen_kvmclock_update`是`KVM_REQ_GLOBAL_CLOCK_UPDATE`请求的handler.
4. `kvm_arch_vcpu_load`中,如果检测到了外部`tsc_offset_adjustment`, 就发出`KVM_REQ_CLOCK_UPDATE`请求, 即在切换到特定vcpu时, 做检测并决定是否发出`KVM_REQ_CLOCK_UPDATE`请求.
5. `kvm_set_guest_paused`中, 会发出`KVM_REQ_CLOCK_UPDATE`请求, `kvm_set_guest_paused`告诉guest kernel, 该guest kernel已经被kvm停止了。即在guest kernel pause时,发出`KVM_REQ_CLOCK_UPDATE`请求.
6. 在qemu发出KVM_SET_CLOCK的ioctl时,向所有vcpu发出`KVM_REQ_CLOCK_UPDATE`请求。qemu设置时钟时,更新guest时钟是理所应当的事情.
7. 在`__kvmclock_cpufreq_notifier`中,对所有vcpu发出了`KVM_REQ_CLOCK_UPDATE`.因为该函数为cpu频率变化时的回调函数,当host cpu频率变化时,应该重新设置guest的时间.
8. 在vmexit时,如果guest的tsc总是追上host的tsc,说明guest的tsc频率高于host的tsc频率,需要重新校准guest的时间.因此向当前vcpu发出`KVM_REQ_CLOCK_UPDATE`.
9. `kvm_arch_hardware_enable`,如果host tsc不稳定,就对所有vcpu发出`KVM_REQ_CLOCK_UPDATE`请求.而`kvm_arch_hardware_enable`的调用路径为: kvm_arch_hardware_enable => hardware_enable_nolock => kvm_starting_cpu​ => kvm_resume 也就是说,在kvm启动vcpu和恢复vcpu的运行时,都需要发出`KVM_REQ_CLOCK_UPDATE`以调整时间.


KVM 处理：
从上面的两种请求的处理可以看到, 上面两种请求都依赖基础请求`KVM_REQ_CLOCK_UPDATE`, 因此`KVM_REQ_CLOCK_UPDATE`的处理非常重要。
kvm_guest_time_update()做了以下几件事情:
1. 获取host的tsc value和host kernel boot以来的ns数
2. 读取当前vcpu的tsc value
3. 经过一系列的校准,将最终时间赋值给vcpu->hv_clock
4. 如果vcpu使能了半虚拟化,就调用kvm_setup_pvclock_page

1. 首先会获取两个变量kernel_ns和host_tsc。在Master Clock模式下，所有vCPU都使用同一组数据，而非Master Clock模式下每个vCPU都自己测量时间。
	1. 若处于Master Clock模式（kvm->arch.use_master_clock = 1），则两者分别取kvm->arch.master_kernel_ns和kvm->arch.master_cycle_now
	2. 若不处于Master Clock模式，则两者分别取当前时刻的Host Boot Time和TSC值
2. 接下来我们要填充struct `pvclock_vcpu_time_info`（简称pvti），这是Host和Guest共享的数据结构，也就是kvmclock的数据源，每个vCPU都有一个。首先设置`tsc_to_system_mul`和`tsc_shift`：
	1. 若支持TSC Scaling，则Guset TSC的运行频率为`cpu_tsc_khz * scale`
    2. 若不支持TSC Scaling，则Guest TSC的运行频率为`cpu_tsc_khz`，即与Host相同
3. 根据Guest TSC的运行频率，可以获得`tsc_to_system_mul`和`tsc_shift`，用于将Guset TSC值转换为纳秒。注意对于Host TSC频率可变的情形，cpu_tsc_khz可以和KVM_SET_TSC_KHZ时的tsc_khz不同。事实上每次pCPU频率改变，就会更新cpu_tsc_khz并对该pCPU上的所有vCPU发送KVM_REQ_CLOCK_UPDATE，但scale始终不变。这说明kvmclock中的vTSC运行频率就是Guest TSC的实际运行频率，和KVM_SET_TSC_KHZ设置的vTSCfreq不一定相等（例如在Host TSC频率可变时会不相等）。
4. 设置tsc_timestamp: 它代表抽样时刻的Guest TSC，其中抽样时刻为pvclock更新即Host Timekeeper更新时（Master Clock模式）或`kvm_guest_time_update`时（非Master Clock模式）：
   1. 若不需要catchup，则根据host_tsc算出tsc_timestamp = vTSC = offset + (host_tsc * scale)即可
   2. 若需要catchup（vcpu->arch.tsc_catchup = 1），则我们根据kernel_ns - vcpu->arch.this_tsc_nsec，计算出从上次写入TSC到抽样时刻的时间差，然后按照vTSCfreq转换成TSC差值，最后加上vcpu->arch.this_tsc_write即上次写入的TSC值，得到抽样时刻的TSC理论值vTSC_theory
   3. 如果vTSC_theory > vTSC，即Guest的TSC走得比设定的慢，则我们可以进行「catch up」，将Guest的TSC Offset增加vTSC_theory - vTSC，并将tsc_timestamp设置为vTSC_theory
   4. 如果vTSC_theory < vTSC，即Guest的TSC走得比设定要快，则我们无法补救，因为TSC必须单调增，因此什么都不做
5. 将vcpu->arch.last_guest_tsc设置为tsc_timestamp的值


kvm_end_pvclock_update(kvm)
|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu)
|-> kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu)

kvm_guest_time_update(struct kvm_vcpu *v)
|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, v)
kvmclock_update_fn(work_struct)
|-> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
|->	kvm_vcpu_kick(vcpu);
void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
|->	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
kvm_set_msr_common
|-> MSR_IA32_TSC_ADJUST => kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
kvm_arch_vcpu_load()
kvm_set_guest_paused(kvm_vcpu)
__kvmclock_cpufreq_notifier(cpufreq, cpu_id)
kvm_arch_hardware_enable()
```C
vcpu_enter_guest(kvm_vcpu)
|-> kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu) => kvm_guest_time_update(kvm_vcpu) // 如果`KVM_REQ_CLOCK_UPDATE` 设置
``` 

```C
static int kvm_guest_time_update(struct kvm_vcpu *v){

	use_master_clock = ka->use_master_clock;
	if (use_master_clock) { // 如果host使用tsc clock, 认为tsc稳定，直接将tsc传递给guest即可
		host_tsc = ka->master_cycle_now; // 将master的cycle_now记为host_tsc (tsc数)
		kernel_ns = ka->master_kernel_ns; // 将master的kernel_ns记为kernel_ns (master的kernel 纳秒数) host boot以来的时间
	}

	tgt_tsc_khz = __this_cpu_read(cpu_tsc_khz); // 读取当前cpu的tsc_khz值 作为目标
	if (unlikely(tgt_tsc_khz == 0)) { // 如果当前cpu的tsc值无效,则发出KVM_REQ_CLOCK_UPDATE请求
		local_irq_restore(flags);
		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
		return 1;
	}
	if (!use_master_clock) {//如果host不使用tsc clock, 这个过程每个vcpu都会执行，所以结果是不一样的
		host_tsc = rdtsc(); // 通过手动读取tsc的值获得host的tsc值
		kernel_ns = ktime_get_boottime_ns(); // 获得host kernel boot以来的时间
	}

	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc); // 将host tsc的值通过scale和offset得到当前时间戳

	/*
	 * We may have to catch up the TSC to match elapsed wall clock
	 * time for two reasons, even if kvmclock is used.
	 *   1) CPU could have been running below the maximum TSC rate
	 *   2) Broken TSC compensation resets the base at each VCPU
	 *      entry to avoid unknown leaps of TSC even when running
	 *      again on the same CPU.  This may cause apparent elapsed
	 *      time to disappear, and the guest to stand still or run
	 *	very slowly.
	 */
	if (vcpu->tsc_catchup) {
		u64 tsc = compute_guest_tsc(v, kernel_ns); // 通过host boot以来的时间,计算理论guest tsc
		if (tsc > tsc_timestamp) { // 如果理论guest tsc比经过调整的host tsc大
			adjust_tsc_offset_guest(v, tsc - tsc_timestamp);//将offset调整为原offset+tsc-tsc_timestap
			tsc_timestamp = tsc; // 将tsc赋值给当前时间戳,使其保持一致
		}
	}

	if (kvm_has_tsc_control) // 如果支持tsc scaling
		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz); // 将当前vcpu的tsc值做scale

	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) { // 如果当前vcpu的tsc与vcpu记录的硬件tsc值不同,则调整tsc scale值
		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
				   &vcpu->hv_clock.tsc_shift,
				   &vcpu->hv_clock.tsc_to_system_mul);
		vcpu->hw_tsc_khz = tgt_tsc_khz;
	}

    // 向pvti类型的hv_clock赋值
	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
	vcpu->last_guest_tsc = tsc_timestamp;

	/* If the host uses TSC clocksource, then it is stable */
	pvclock_flags = 0;
	if (use_master_clock)
		pvclock_flags |= PVCLOCK_TSC_STABLE_BIT;

	vcpu->hv_clock.flags = pvclock_flags;

	if (vcpu->pv_time_enabled) // 如果使用半虚拟化(kvmclock)
		kvm_setup_pvclock_page(v); // 就将pv_clock的内容拷贝到pv_clock
	if (v == kvm_get_vcpu(v->kvm, 0))  // hyper-v tsc page set
		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
	return 0;
}
```

来看kvm_setup_pvclock_page.
```C
static void kvm_setup_pvclock_page(struct kvm_vcpu *v)
{
    ...
        	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
				&vcpu->hv_clock,
				sizeof(vcpu->hv_clock)); // 将hv_clock的内容赋值到pv_time中去
    ...
}
```
这里的pv_time就是之前我们提到的每个vcpu都有1个的pvti结构.将将hv_clock的内容赋值到pv_time中去,即将最新时间更新到vcpu的pvti结构中去.



## 重要数据


- struct clocksource kvm_clock： 虚拟机中的时钟源设备，rating =400，比较高。

```C
struct pvclock_vcpu_time_info {
	u32   version;                  // kvm 更新前 + 1， 更新完成后 再+1，虚拟机读取时必须是偶数
	u32   pad0;
	u64   tsc_timestamp;            // guest的last TSC时间戳，在kvm_guest_time_update中会被更新
	u64   system_time;              // guest的墙上时间（1970年距今的绝对日期），和tsc_timestamp在一起更新。system_time = kernel_ns + v->kvm->arch.kvmclock_offset。系统启动后的时间减去VM init的时间，即guest init后到现在的时间
	u32   tsc_to_system_mul;        // KVMCLOCK时钟频率固定在1GHZ，存放当前一nanoseconds多少个counter值，cpu频率调整后该值也会变
	s8    tsc_shift;
	u8    flags;
	u8    pad[2];
} __attribute__((__packed__)); /* 32 bytes */
```

```C
struct pvclock_wall_clock { // 虚拟机启动时间点
u32   version;
u32   sec;
u32   nsec;
} __attribute__((__packed__));
```


# More on kvmclock
在Guest Linux Kernel初始化时，会调用kvmclock_init进行kvmclock的初始化，这个函数在BSP上运行：
```C
start_kernel
--> setup_arch
    --> init_hypervisor_platform
        --> x86_init.hyper.init_platform ==> kvm_init_platform
            --> kvmclock_init
```
下面我们分析kvmclock_init进行了什么初始化操作：

**首先**，我们为所有CPU设置了回调kvmclock_setup_percpu，当该CPU被bringup时就调用该回调，不过此时尚在BSP初始化的阶段，因此不会立即执行。

上文说过，每个vCPU都有一个pvti，现在先将vCPU0的pvti设置为hv_clock_boot[0]，其物理地址为GPA，然后将GPA | 1写入MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW，注册kvmclock。

KVM对这个MSR的写入的模拟如下：

- 如果写入的是MSR_KVM_SYSTEM_TIME，表明Guest使用的是旧版kvmclock，不支持Master Clock模式，此时要设置kvm->arch.boot_vcpu_runs_old_kvmclock = 1，并对当前vCPU（即vCPU0）发送一个KVM_REQ_MASTER_CLOCK_UPDATE，这最终会导致kvm->arch.use_master_clock = 0
- 令vcpu->arch.time = GPA | 1，该变量用于模拟对该MSR的读取
- 向当前vCPU（即vCPU0）发送KVM_REQ_GLOBAL_CLOCK_UPDATE，这最终会导致在所有vCPU上运行kvm_guest_time_update
- 最后，设置vcpu->arch.pv_time为GPA，并令vcpu->arch.pv_time_enabled = true

接着，我们注册了一系列回调：
```C
kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);

x86_platform.calibrate_tsc = kvm_get_tsc_khz;
x86_platform.calibrate_cpu = kvm_get_tsc_khz;
x86_platform.get_wallclock = kvm_get_wallclock;
x86_platform.set_wallclock = kvm_set_wallclock;
#ifdef CONFIG_X86_LOCAL_APIC
x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
#endif
x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
x86_platform.restore_sched_clock_state = kvm_restore_sched_clock_state;
machine_ops.shutdown  = kvm_shutdown;
#ifdef CONFIG_KEXEC_CORE
machine_ops.crash_shutdown  = kvm_crash_shutdown;
#endif
```
最后，我们注册了kvm_clock这个clocksource：
```C
struct clocksource kvm_clock = {
    .name   = "kvm-clock",
    .read   = kvm_clock_get_cycles,
    .rating = 400,
    .mask   = CLOCKSOURCE_MASK(64),
    .flags  = CLOCK_SOURCE_IS_CONTINUOUS,
};
EXPORT_SYMBOL_GPL(kvm_clock);

/*
 * X86_FEATURE_NONSTOP_TSC is TSC runs at constant rate
 * with P/T states and does not stop in deep C-states.
 *
 * Invariant TSC exposed by host means kvmclock is not necessary:
 * can use TSC as clocksource.
 *
 */
if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
    !check_tsc_unstable())
    kvm_clock.rating = 299;

clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
```
注意当Host和Guest都是stable时，我们实际上直接使用TSC作为Clocksource，kvmclock只用于提供wall clock。

kvmclock_init之后运行的是early_initcall(kvm_setup_vsyscall_timeinfo)，该函数也是在BSP上运行，它主要是动态分配并初始化了hv_clock_mem，以防止静态分配的hv_clock_boot数组不够用。

然后，当AP启动时会执行Hotplug回调kvmclock_setup_percpu，将per cpu变量hv_clock_per_cpu设置为hv_clock_boot/hv_clock_mem的成员。

最后，AP启动后初始化时（即start_sencondary函数中），会调用x86_cpuinit.early_percpu_clock_init即kvm_setup_secondary_clock，将AP的pvti地址写入MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW，在KVM中注册kvmclock。

kvm_clock作为一个clocksource，其频率为1GHz，实际上其read回调返回的值是就是System Time（即Host Boot Time + Kvmclock Offset）的读数，单位为纳秒。read回调最终调用到pvclock_clocksource_read，实现如下：

首先，获取当前的System Time，即pvti->system_time + tsc_to_nsec(rdtsc() - pvti->tsc_timestamp)
其次，若不在Master Clock模式，则上述求得的System Time可能出现倒退，我们用一个全局变量last_value记录上次kvm_clock读到的值，若当前求得的System Time小于last_value，则本次读取返回last_value，否则返回System Time并设置last_value为System Time



# backward TSC & TSC adjustment
在系统休眠再恢复后，即使Host TSC是Stable的，也可能发生TSC倒退的情况（即休眠时所有CPU的TSC同步重置为零），这种情况下，我们将所有VM instance的kvm->arch.backwards_tsc_observed设置为true，于是会禁止使用Master Clock模式。

我们取所有VM的所有vCPU的vcpu->arch.last_host_tsc中最大的，记作oldTSC，取当前时刻的TSC记作curTSC，则我们为所有VM的所有vCPU设置vcpu->arch.tsc_offset_adjustment += oldTSC - curTSC以及vcpu->arch.last_host_tsc = curTSC，并发送一个KVM_REQ_MASTER_CLOCK_UPDATE请求（这是为了触发禁用Master Clock模式的操作）。

在vCPU加载时（kvm_arch_vcpu_load），若vcpu->arch.tsc_offset_adjustment非零，则会将L1 TSC Offset增加tsc_offset_adjustment * scale，并将其清零，最后会给自己发送一个KVM_REQ_CLOCK_UPDATE。

PS: TSC adjustment乘以scale ratio的原因是Guest TSC要保持单调性和连续性，其值应该是offset + scale * (newTSC + TSC adjustment)，故TSC Offset应该增加TSC adjustment * scale


# Guest设置vCpu的tsc频率

qemu干了什么？猜测默认调用了kvm_set_tsc_khz, 传递的参数为0， 就是物理机 CPU的tsc频率。

KVM怎么处理：

tsc_khz为Host的pTSCfreq，用户态通过`ioctl(vcpu, KVM_SET_TSC_KHZ)`设置vCPU的vTSCfreq，即使KVM不支持`TSC Scaling`。`kvm_has_tsc_control`表示硬件是否支持`TSC Scaling`。
若不支持，只要vTSCfreq > pTSCfreq，仍可成功设置，此时vcpu->arch.tsc_catchup = 1，vcpu->arch.always_catchup = 1。
vcpu->arch.virtual_tsc_khz为vCPU的`vTSCfreq`，vcpu->arch.virtual_tsc_mult/virtual_tsc_shift用于将nsec转换为tsc value，vcpu->arch.tsc_scaling_ratio为vTSCfreq / pTSCfreq，是一定点浮点数（Intel VT-x中高16位为整数部分，低48位为小数部分）

```C
int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
|-> user_tsc_khz == 0 => kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
|-> kvm_get_time_scale(user_tsc_khz * 1000LL, NSEC_PER_SEC, &vcpu->arch.virtual_tsc_shift, &vcpu->arch.virtual_tsc_mult);
|-> vcpu->arch.virtual_tsc_khz = user_tsc_khz;
|-> set_tsc_khz(vcpu, user_tsc_khz, use_scaling)
```