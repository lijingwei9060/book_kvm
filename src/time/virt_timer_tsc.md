Some CPUs provide a way to read exact TSC frequency, while measuring it
is required on other CPUs. However, measuring is never exact and the
result may slightly differ across reboots. For this reason both Linux
kernel and QEMU recently started allowing for guests TSC frequency to
fall into +/- 250 ppm tolerance interval around the host TSC frequency.
250 parts per million (ppm) is a half of NTP threshold

KVM_SET_TSC_KHZ supports an error of 250 ppm (see tsc_tolerance_ppm and 
adjust_tsc_khz in arch/x86/kvm/x86.c in the kernel source).

# cat /sys/module/kvm/parameters/tsc_tolerance_ppm
    250

TSC可以在用户态通过rdtsc进行读取, 读取出来的是cpu cycle需要进行转换从cycle得到ns。
```C
static uint64_t rdtsc(void)
{
    uint64_t var;
    uint32_t hi, lo;

    __asm volatile
        ("rdtsc" : "=a" (lo), "=d" (hi));

    var = ((uint64_t)hi << 32) | lo;
    return (var);
}
```

cycle2ns的转换过程经历过算法的更新和迭代，主要考虑性能的因素，在内核中避免除法，将除法变成移位操作。
```C
ns = cycles / (freq / ns_per_sec)
ns = cycles * (ns_per_sec / freq)
ns = cycles * (10^9 / (cpu_khz * 10^3))
ns = cycles * (10^6 / cpu_khz)
ns = cycles * (10^6 * SC / cpu_khz) / SC  // SC: scaling match, and is a constant power of two
ns = cycles * cyc2ns_scale / SC  // cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits
```

理想情况下通过下面的程序可以拿到应用程序处理的时长，现实是有问题的。
```C
start = rdtsc();
/* put code you want to measure here */
end = rdtsc();
cycle = end - start;
latency = cycle_2_ns(cycle)
```

# 硬件问题
TSC的硬件不稳定
- Variant TSC： 从Intel P4引入，变化受到主频变化影响。在低功耗TSC计数会变慢，甚至停止.第一代TSC的实现是Varient TSC
- Constant TSC： 固定速率，不受CPU frequency 变化影响。进入deep C-state，会停止。早于Nehalem引入。linux内核在CPU进入深度C-state会打印告警， tsc halt in c2, 在DEEP-C状态下依然会发生停止计数的情况
- Invariant TSC： 在所有ACPI P-, C-, and T-states以固定频率运行，从Nehalem引入。X86_FEATURE_CONSTANT_TSC 和X86_FEATURE_NONSTOP_TSC标志CPU支持。Invariant TSC: Software can modify the value of the time-stamp counter (TSC) of a logical processor by using the WRMSR instruction to write to the IA32_TIME_STAMP_COUNTER MSR

CPU TSC标志位
- X86_FEATURE_TSC有tsc
- X86_FEATURE_CONSTANT_TSC：有constant tsc
- X86_FEATURE_NONSTOP_TSC： c-state不停
- X86_FEATURE_TSC_RELIABLE： TSC sync checks 会被跳过，检查`cat  /proc/cpuinfo | grep "tsc_reliable"`


在SMP下的TSC同步
1. 老版本不支持TSC 同步， 不同CPU时间不同步，任务迁移后可能导致时间后退。
2. 同一主板上的CPU同步，要求CPU支持Invariant TSC。 所有的CPU在引导阶段收到reset 信号重置信息，然后按照固定的频率进行跳动。
3. 多个板卡上的CPU可能不同步，

即使CPU支持“Invariant TSC”，SMP也不一定能提供可靠的时间。Linux kernel通过write_tsc 写入MSR register 来测试是否TSC可靠，只有经过可靠性测试的TSC才会出现在时钟源上。
对于不是Intel的CPU，kernel默认认为他们是不支持tsc 同步的。
CPU 热插拔导致时钟更不稳定。


rdtsc: Read Time-Stamp Counter
rdtscp: Read Time-Stamp Counter and Processor ID

# 数据结构

## 全局变量
- unsigned int tsc_khz： tsc的频率
- static unsigned int tsc_early_khz;
- static DEFINE_PER_CPU(struct tsc_adjust, tsc_adjust);
- static struct timer_list tsc_sync_check_timer;
- bool __read_mostly tsc_async_resets;

# 激活：

Nominal TSC frequency = ( CPUID.15H.ECX[31:0] * CPUID.15H.EBX[31:0] ) ÷ CPUID.15H.EAX[31:0]

tsc时钟源初始化, 调用路径：time_init->tsc_init
函数任务：
	1.矫正tsc，获取tsc频率，设置cpu频率等于tsc频率
	2.初始化基于tsc的延迟函数
	3.检查tsc的特性
		3.1 tsc之间是否同步
			3.1.1 如果tsc之间不同步，标记tsc不稳定，设置rating=0
		3.2 tsc是否稳定

```C
tsc_init() // 内核启动时初始化tsc
   |-> x86_platform.calibrate_cpu = native_calibrate_cpu;
   |-> determine_cpu_tsc_frequencies(false) // 确定tsc_khz和cpu_khz
      |-> pit_hpet_ptimer_calibrate_cpu() // 使用pit/hpet/ptimer时钟来校正cpu_khz, 这个在acpi初始化完成后才能执行
   |-> tsc_enable_sched_clock()
      |-> loops_per_jiffy = get_loops_per_jiffy(); //每个HZ(jiffy) 会有多少个tsc的loop
      |-> use_tsc_delay();
         |-> delay_fn = delay_tsc // 初始化基于tsc的延迟函数
      |-> tsc_store_and_check_tsc_adjust(true);
         |-> rdmsrl(MSR_IA32_TSC_ADJUST, bootval);
         |-> cur->bootval = bootval;
         |-> cur->nextcheck = jiffies + HZ;
         |-> tsc_sanitize_first_cpu(cur, bootval, smp_processor_id(), bootcpu);
      |-> cyc2ns_init_boot_cpu(); 
      |-> static_branch_enable(&__use_tsc);
    |-> cyc2ns_init_secondary_cpus() // 设置辅助CPU的cyc2ns变量参数
    |-> enable_sched_clock_irqtime()
    |-> lpj_fine = get_loops_per_jiffy(); // 一个jiffy(HZ)对应多少个tsc的loop，初始化这个全局变量干什么？
	|-> check_system_tsc_reliable();  // 检查tsc可靠性，tsc_clocksource_reliable = 1
      |-> tsc_disable_clocksource_watchdog() // 如果tsc 可靠，关闭clocksource的watchdog
	|-> if (unsynchronized_tsc()) {	mark_tsc_unstable("TSCs unsynchronized");return;} // 检查CPU之间tsc是否同步
	|-> if (tsc_clocksource_reliable || no_tsc_watchdog)	tsc_disable_clocksource_watchdog(); // tsc稳定，关闭clocksource的watchdog。
	|-> clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
	|-> detect_art(); // 只有物理环境才有ART： Always Running Timer
``` 

`check_system_tsc_reliable`, 
函数内容：
1. 引导cpu有`X86_FEATURE_TSC_RELIABLE`, `tsc_clocksource_reliable` = 1
2. 引导cpu有`X86_FEATURE_CONSTANT_TSC` && `X86_FEATURE_NONSTOP_TSC` && `X86_FEATURE_TSC_ADJUST` , cpu个数不超过2个，关闭clocksource的watchdog。

检查tsc是否同步`unsynchronized_tsc`， 调用路径：tsc_init->unsynchronized_tsc
检查办法：
1. 如果引导cpu没有tsc，肯定不同步
2. 如果apic在多块板卡，则tsc不同步
3. 如果cpuid显示具有稳定的tsc(`X86_FEATURE_CONSTANT_TSC`)，则tsc同步
4. 默认intel cpu的tsc都是同步的
5. 其他品牌的多核的tsc不同步


标记tsc不稳定`mark_tsc_unstable`, 调用路径：tsc_init->mark_tsc_unstable
函数任务：(下面的不完整)
1. 标记`tsc_unstable` 为1
2. 如果tsc时钟已经注册，异步设置tsc的rating=0，标识其不稳定
3. 如果tsc时钟还未注册，同步设置tsc的rating=0，标识其不稳定

# 校验cpu频率
内核在启动过程中会根据既定的优先级选择时钟源。优先级的排序根据时钟的精度与访问速度。
其中CPU中的TSC寄存器是精度最高（与CPU最高主频等同），访问速度最快（只需一条指令，一个时钟周期）的时钟源，因此内核优选TSC作为计时的时钟源。其它的时钟源，如HPET, ACPI-PM，PIT等则作为备选。但是，TSC不同与HPET等时钟，它的频率不是预知的。因此，内核必须在初始化过程中，利用HPET，PIT等始终来校准TSC的频率。如果两次校准结果偏差较大，则认为TSC是不稳定的，则使用其它时钟源。并打印内核日志：Clocksource tsc unstable.

正常来说，TSC的频率很稳定且不受CPU调频的影响（如果CPU支持constant-tsc）。内核不应该侦测到它是unstable的。但是，计算机系统中存在一种名为SMI（System Management Interrupt）的中断，该中断不可被操作系统感知和屏蔽。如果内核校准TSC频率的计算过程quick_ pit_ calibrate ()被SMI中断干扰，就会导致计算结果偏差较大（超过1%），结果是tsc基准频率不准确。最后导致机器上的时间戳信息都不准确，可能偏慢或者偏快。

当内核认为TSC unstable时，切换到HPET等时钟，不会给你的系统带来过大的影响。当然，时钟精度或访问时钟的速度会受到影响。通过实验测试，访问HPET的时间开销为访问TSC时间开销的7倍左右。如果您的系统无法忍受这些，可以尝试以下解决方法： 在内核启动时，加入启动参数：tsc=reliable

```C
native_calibrate_cpu()
|-> tsc_freq = native_calibrate_cpu_early() // 在引导过程中校验cpu频率
   |-> fast_calibrate = cpu_khz_from_cpuid() // 通过cpuid解析cpu 频率
   |-> fast_calibrate = cpu_khz_from_msr()
   |-> fast_calibrate = quick_pit_calibrate()
|-> tsc_freq = pit_hpet_ptimer_calibrate_cpu()
   |-> tsc_read_refs()
   |-> tsc_pit_khz = pit_calibrate_tsc(latch, ms, loopmin);

```

5次校正循环，2种不同的校正模式：
1. PIT loop， 设置PIT channel 2到oneshot模式，超时50ms，设置PIT超时后读取TSC，计算delta。跟踪delta的max和min，如果max太大就丢掉。
2. HPET或者PMTimer，
pit_hpet_ptimer_calibrate_cpu

# clock source
```C
static struct clocksource clocksource_tsc = {
	.name			= "tsc",
	.rating			= 300,
	.read			= read_tsc,
	.mask			= CLOCKSOURCE_MASK(64),
	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
				  CLOCK_SOURCE_VALID_FOR_HRES |
				  CLOCK_SOURCE_MUST_VERIFY |
				  CLOCK_SOURCE_VERIFY_PERCPU,
	.vdso_clock_mode	= VDSO_CLOCKMODE_TSC,
	.enable			= tsc_cs_enable,
	.resume			= tsc_resume,
	.mark_unstable		= tsc_cs_mark_unstable,
	.tick_stable		= tsc_cs_tick_stable,
	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
};
```


# TSC scaling

# 迁移过程的tsc

  guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET

This attribute is useful to adjust the guest's TSC on live migration,
so that the TSC counts the time during which the VM was paused. The
following describes a possible algorithm to use for this purpose.

From the source VMM process:

1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
   kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
   (host_src).

2. Read the KVM_VCPU_TSC_OFFSET attribute for every vCPU to record the
   guest TSC offset (ofs_src[i]).

3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the
   guest's TSC (freq).

From the destination VMM process:

4. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
   kvmclock (guest_src) and CLOCK_REALTIME (host_src) in their respective
   fields.  Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
   structure.

   KVM will advance the VM's kvmclock to account for elapsed time since
   recording the clock values.  Note that this will cause problems in
   the guest (e.g., timeouts) unless CLOCK_REALTIME is synchronized
   between the source and destination, and a reasonably short time passes
   between the source pausing the VMs and the destination executing
   steps 4-7.

5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
   kvmclock nanoseconds (guest_dest).

6. Adjust the guest TSC offsets for every vCPU to account for (1) time
   elapsed since recording state and (2) difference in TSCs between the
   source and destination machine:

   ofs_dst[i] = ofs_src[i] -
     (guest_src - guest_dest) * freq +
     (tsc_src - tsc_dest)

   ("ofs[i] + tsc - guest * freq" is the guest TSC value corresponding to
   a time of 0 in kvmclock.  The above formula ensures that it is the
   same on the destination as it was on the source).

7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
   respective value derived in the previous step.



[[PATCH 0/2] RFC: Precise TSC migration](https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2398009.html)

## TSC sync

late_initcall(start_sync_check_timer) // 注册时钟，每`SYNC_CHECK_INTERVAL` 600秒执行一次
|-> tsc_sync_check_timer_fn()
   |-> tsc_verify_tsc_adjust(false)
      |-> `X86_FEATURE_TSC_ADJUST` 没有则不支持检查
      |-> tsc_unstable = true, 也不检查
      |-> adj->adjusted == `MSR_IA32_TSC_ADJUST`， 正常 => 结束
      |-> 如果是tsc_resume, 这两个值不相等，设置adj.warned = true
   |-> add_timer_on(&tsc_sync_check_timer, next_cpu) // 在下一个cpu上添加timer，超时执行verify

检查CPU的tsc是否sync：
start_secondary()
|-> check_tsc_sync_target() // Check TSC synchronization with the boot CPU:
   |-> unsynchronized_tsc() => abort //不支持tsc sync退出
   |-> tsc_store_and_check_tsc_adjust(false) => abort //  verify and sanitize the TSC adjust register. If successful skip the test.
   |-> tsc_clocksource_reliable => abort // The test is also skipped when the TSC is marked reliable

## TSC feature

- X86_FEATURE_TSC: The TSC is available in hardware
- X86_FEATURE_RDTSCP: The RDTSCP instruction is available
- X86_FEATURE_CONSTANT_TSC: The TSC rate is unchanged with P-states
- X86_FEATURE_NONSTOP_TSC :The TSC does not stop in C-states
- X86_FEATURE_TSC_RELIABLE: TSC sync checks are skipped (VMware)

# TSC_ADJUST 
[[tip:x86/timers] x86/tsc: Store and check TSC ADJUST MSR](https://lore.kernel.org/lkml/tip-8b223bc7abe0e30e8d297a24ee6c6c07ef8d0bb9@git.kernel.org/)

# TSC ART

https://lore.kernel.org/lkml/1456978919-30076-7-git-send-email-john.stultz@linaro.org/

On modern Intel systems TSC is derived from the new Always Running Timer
(ART). ART can be captured simultaneous to the capture of
audio and network device clocks, allowing a correlation between timebases
to be constructed. Upon capture, the driver converts the captured ART
value to the appropriate system clock using the correlated clocksource
mechanism.

On systems that support ART a new CPUID leaf (0x15) returns parameters
“m” and “n” such that:

TSC_value = (ART_value * m) / n + k [n >= 1]

[k is an offset that can adjusted by a privileged agent. The
IA32_TSC_ADJUST MSR is an example of an interface to adjust k.
See 17.14.4 of the Intel SDM for more details]


# TSC virtualization

## Basics
- `tsc_khz`为Host的pTSCfreq
- 用户态通过ioctl(vcpu, `KVM_SET_TSC_KHZ`)设置vCPU的vTSCfreq，即使KVM不支持TSC Scaling
- `kvm_has_tsc_control`表示硬件是否支持TSC Scaling, 若不支持，只要vTSCfreq > pTSCfreq，仍可成功设置，此时vcpu->arch.tsc_catchup = 1，vcpu->arch.always_catchup = 1
- vcpu->arch.`virtual_tsc_khz`为vCPU的vTSCfreq, vcpu->arch.virtual_tsc_mult/virtual_tsc_shift用于将nsec转换为tsc value
- vcpu->arch.`tsc_scaling_ratio`为vTSCfreq / pTSCfreq，是一定点浮点数（Intel VT-x中高16位为整数部分，低48位为小数部分）

set_tsc_khz

kvm_set_tsc_khz

compute_guest_tsc

kvm_track_tsc_matching

kvm_scale_tsc

kvm_read_l1_tsc

kvm_compute_l1_tsc_offset

kvm_vcpu_write_tsc_offset

kvm_check_tsc_unstable // TSC is marked unstable when we're running on Hyper-V, 'TSC page' clocksource is good.

kvm_synchronize_tsc

adjust_tsc_offset_guest

adjust_tsc_offset_host


## TSC Matching
Host/Guest写入TSC时，会调用kvm_write_tsc。
0). 写入的值记为vTSC，则我们要将L1 TSC Offset设置为offset = vTSC - (pTSC * scale)
1). 每次写入完会记录kvm->arch.last_tsc_nsec、kvm->arch.last_tsc_write、kvm->arch.last_tsc_khz，以供下次调用时使用：
- nsec表示写入时刻的Host Boot Time（CLOCK_BOOTTIME）
- write表示写入的值
- khz表示vCPU的vTSCfreq

此外还会将写入的值记录到vcpu->arch.last_guest_tsc

2). KVM希望各个vCPU的TSC处在同步状态，称之为Master Clock模式，每当vTSC被修改，就有两种可能：

- 破坏了已同步的TSC，此时将L1 TSC offset设置为offset即可
  - 此时TSC进入下一代，体现为kvm->arch.cur_tsc_generation++且kvm->arch.nr_vcpus_matched_tsc = 0
  - 此时还会记录kvm->arch.cur_tsc_nsec、kvm->arch.cur_tsc_write、kvm->arch.cur_tsc_offset，其中offset即上述L1 TSC Offset。重新同步后，可以以此为基点导出任意vCPU的TSC值。
- vCPU在尝试重新同步TSC，此时不能将L1 offset设置为offset
此时会设置kvm->arch.nr_vcpus_matched_tsc++，一旦所有vCPU都处于matched状态，就可以重新回到Master Clock模式
在满足vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz的前提下（vTSCfreq相同是TSC能同步的前提），以下情形视为尝试同步TSC：

Host Initiated且写入值为0,视为正在初始化
写入的TSC值与kvm->arch.last_tsc_write偏差在1秒内
按照Host TSC是否同步（即是否stable），会为L1 TSC offset设置不同的值

对于Stable Host，L1 TSC Offset设置为kvm->arch.cur_tsc_offset
对于Unstable Host，则将L1 TSC Offset设置为(vTSC + nsec_to_tsc(boot_time - kvm->arch.last_tsc_nsec)) - (pTSC * scale)，即假设本次和上次写入的TSC值相同，然后补偿上Host Boot Time的差值
此外，我们还会记录当前vCPU和哪一代TSC相同步，存放在vcpu->arch.this_tsc_generation、vcpu->arch.this_tsc_nsec、vcpu->arch.this_tsc_write

3). 若为Guest模拟了IA32_TSC_ADJUST这个MSR，则对TSC Offset的改动，需要同步体现在IA32_TSC_ADJUST，因此需要修改vcpu->arch.ia32_tsc_adjust_msr

PS: Host initiated的IA32_TSC_ADJUST修改，保持vTSC不变，不需要同步改动vTSC

4). 若Host Clocksource为TSC，且Guset TSC已同步，则发送KVM_REQ_MASTER_CLOCK_UPDATE，这会启用Master Clock模式，即设置kvm->arch.use_master_clock = 1。

反之，若已有kvm->arch.use_master_clock = 1，也要发送KVM_REQ_MASTER_CLOCK_UPDATE，它会检查当前是否还满足Master Clock的要求，若不满足则关闭Master Clock模式。



[参考来源](https://tcbbd.moe/linux/qemu-kvm/kvm-time/)

## TSC catchup
除了Always Catchup模式，还有可能触发catchup行为。在vCPU加载时（kvm_arch_vcpu_load），如果Host TSC Unstable，则会进行以下操作：

根据当前时刻的Host TSC值pTSC、vCPU上次记录的TSC值vTSC = vcpu->arch.last_guest_tsc，求得offset = vTSC - pTSC * scale，并将其写入L1 TSC Offset
然后设置vcpu->arch.tsc_catchup = 1
这是一种保守的策略，我们先将vTSC调整到上次记录的vTSC值，这一定是比理论上的正确vTSC值小的，然后设置vcpu->arch.tsc_catchup，在接下来的kvm_gen_kvmclock_update中将vTSC的值修正为理论的正确值。

此后vCPU运行过程中，每次KVM_REQ_CLOCK_UPDATE请求，都会导致一次catch up，这样至少每隔300秒都会有一次catch up。


https://www.cnblogs.com/haiyonghao/p/14440035.html