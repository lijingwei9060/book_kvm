# time keeping
对于用户来说，我们感知的是真实世界的真实时间，也就是墙上时间（wall time），clocksource 只能提供一个按给定频率不停递增的周期计数，需要把它和真实的墙上时间相关联。

Linux 时间种类:
- RTC: 又称 CMOS 时间，维护了 wall time。精度低，一般只有毫秒级。通常由一个专门的计时硬件来实现。不管系统是否上电，RTC 中的时间信息都不会丢失，计时会一直持续进行，硬件上通常使用一个电池对其进行单独的供电。
- xtime: 同样维护了 wall time，保存在内存中，基于 clocksource 实现。精度自然也就取决于 clocksource，最高可达纳秒级。当用户修改时间时，可能会发生跳变。
- monotonic time: 单调递增，自系统开机后就一直单调增加，但系统休眠时不会递增。
- raw monotonic time: 原始单调递增，与 monotonic time 类似，也是单调递增的时间，但不会受到 NTP 时间调整的影响，代表着系统独立时钟硬件对时间的统计。
- boot time: 与 monotonic time 类型，但会加上系统休眠的时间，代表系统上电后的总时间。
- 原子时间（CLOCK_TAI）：表示原子国际时间（Atomic International Time），该时间和实时时间只是相差一定的偏移。

|时间种类|精度（统计单位）|访问速度|累计休眠时间|受NTP调整的影响|
|----|----|----|----|----|
|xtime|高|快|Yes|Yes|
|monotonic|高|快|No|Yes|
|raw monotonic|高|快|No|No|
|boot time|高|快|Yes|Yes|

timekeeper 维护了 monotonic time, raw monotonic time, xtime。

# 工作原理

timekeeper提供time 功能，提供time的多种视图。
timekeeper保留mono和raw两个时钟，两个时钟指向的同一个clocksource, 最优的clock_source设备，
初始时间从持久化clock设备上获取, X86上就是RTC时钟。其他平台呢？
初始默认时钟为`clocksource_default_clock()`，也就是`clocksource_jiffies`

# 重要数据结构
```C
struct timekeeper {
    struct tk_read_base tkr_mono;               // 维护 CLOCK_MONOTONIC
    struct tk_read_base tkr_raw;                // 维护 CLOCK_MONOTONIC_RAW
    u64         xtime_sec;                      // 当前 CLOCK_REALTIME，单位秒
    unsigned long       ktime_sec;              // 当前 CLOCK_MONOTONIC，单位秒
    struct timespec64   wall_to_monotonic;      // CLOCK_REALTIME 和 CLOCK_MONOTONIC 的差值
    ktime_t         offs_real;                  // CLOCK_MONOTONIC 和 CLOCK_REALTIME 的差值
    ktime_t         offs_boot;                  // CLOCK_MONOTONIC 和 boot time 的差值
    ktime_t         offs_tai;                   // CLOCK_MONOTONIC 和 CLOCK_TAI 的差值
    s32         tai_offset;                     // UTC 和 TAI 的差值，单位秒， offs_tai=offs_real+tai_offset
    unsigned int        clock_was_set_seq;      // 表示时钟被设置的序数。
    u8          cs_was_changed_seq;             // 表示时钟源更换的序数。
    ktime_t         next_leap_ktime;            // 下一次需要闰秒（跳变秒）的时间
    u64			raw_sec;                        // 当前CLOCK_MONOTONIC_RAW，单位秒
    struct timespec64   monotonic_to_boot;      // 单调时间和启动时间之间的差值
    u64         cycle_interval;                 // 一个 NTP interval包含多少个时钟 cycle 数
    u64         xtime_interval;                 // 一个 NTP interval 的 ns 数，纳秒数向左位移了shift位，而且这个值会根据NTP层的状况做出调整
    s64         xtime_remainder;                // 周期数转换成纳秒数时候的精度损失
    u64         raw_interval;                   // NTP周期包含多少纳秒(位移后)，不会根据NTP的状况做出调整，设置好后不变。初始值xtime_interval == raw_interval
    u64         ntp_tick;                       // NTP周期的纳秒数(位移后)，但其位移的位数不是有时钟源设备决定的，而是一个固定的值
    s64         ntp_error;                      // NTP时间和当前实时时间之间的差值，如果ntp_error大于0，表示当前系统的实时时间慢于NTP时间，相反如果小于0则表示快于。
    u32         ntp_error_shift;                // 存放了NTP的shift和时钟源设备shift之间的差值。 NTP_SCALE_SHIFT
    u32         ntp_err_mult;                   // 如果ntp_error大于0，则为1，否则都是0
    u32			skip_second_overflow;           // 处理闰秒的时候是否需要跳过这一秒
#ifdef CONFIG_DEBUG_TIMEKEEPING
    long            last_warning;
    int         underflow_seen;
    int         overflow_seen;
#endif
};
```

```C
struct tk_read_base {                           // 帮助clock读取的结构
	struct clocksource	*clock;                 // 指向对应底层时钟源设备结构体的指针
	u64			mask;                           // 对应底层时钟源设备的mask、mult和shift的值，用于将时钟周期数和纳秒数之间互相转换。
	u64			cycle_last;                     // 记录了最近一次时钟源的周期计数。
	u32			mult;
	u32			shift;
	u64			xtime_nsec;                     // 实时时间当前的纳秒数，这个值也是移位过后的，也就是实际的纳秒数向左移动了shift位。累积起来会进位。
	ktime_t			base;                       // 单调时间的基准时间。
	u64			base_real;                      // 实时时间的基准时间，base_real = base + offs_real。
}
```

## 全局变量
- `persistent_clock_exists` : 是否有一个持久化的时钟
- `tk_core`: 
- `shadow_timekeeper`: 
- `tk_fast`: 
- `suspend_timing_needed`: 
- `timekeeping_suspended`: 
- `timekeeping_suspend_time`:  time in seconds when suspend began for persistent clock

## 初始化：timekeeping_init，初始化时钟守护者

我们来看它的初始化函数 timekeeping_init ：
```C
void __init timekeeping_init(void)
{
    ...
    // 获取持久化时间，在 x86 下是调用 x86_platform.get_wallclock (mach_get_cmos_time)，即读取 RTC
    // boot_offset 通过sched_clock读取，架构相关，性能要求较高
    // https://blog.csdn.net/tiantao2012/article/details/54133371
    // https://tuxthink.blogspot.com/2020/03/using-schedclock-to-get-kernel-uptime.html
    read_persistent_wall_and_boot_offset(&wall_time, &boot_offset);
    persistent_clock_exists = true;
    
    // 计算 wall_to_mono差值，wall time + wall_to_mono = boot time
    wall_to_mono = timespec64_sub(boot_offset, wall_time);

    raw_spin_lock_irqsave(&timekeeper_lock, flags);
    write_seqcount_begin(&tk_core.seq);
    // 初始化 NTP，重置相关变量
    ntp_init();

    // 获取默认的时钟源，即 clocksource_jiffies
    clock = clocksource_default_clock();
    
    // 将 timekeeper 和 clocksource_jiffies 关联起来，即使用 clocksource_jiffies 来作为时钟源
    tk_setup_internals(tk, clock);

    // 利用 RTC 读到的时间来设置 xtime / raw time
    tk_set_xtime(tk, &wall_time);
    tk->raw_sec = 0;

    tk_set_wall_to_mono(tk, wall_to_mono);

    timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);

    write_seqcount_end(&tk_core.seq);
    raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
}
```
可以发现此时 timekeeper 以 jiffies 作为时钟源。在收到 tick 或者 模拟 tick 时，都会去更新 timekeeper ：tick_periodic / tick_do_update_jiffies64 => update_wall_time 。




## 切换时钟源
当 注册精度更高的时钟源 / 时钟源的精度(rating)改变 时，会进行时钟源切换。比如注册时钟源时，有 `clocksource_register_hz => __clocksource_register_scale => clocksource_select => __clocksource_select` 。通过 clocksource_find_best 找到 rating 最高的时钟源，然后考虑 override，如果最终选中的时钟源和原来不同，则调用 timekeeping_notify 进行切换：

```C
/**
 * timekeeping_notify - Install a new clock source
 * @clock:      pointer to the clock source
 *
 * This function is called from clocksource.c after a new, better clock
 * source has been registered. The caller holds the clocksource_mutex.
 */
int timekeeping_notify(struct clocksource *clock)
{
    struct timekeeper *tk = &tk_core.timekeeper;
    // 如果时钟源没变，则返回
    if (tk->tkr_mono.clock == clock)
        return 0;
    // 在 machine 停止的状况下执行 change_clocksource，切换时钟源
    stop_machine(change_clocksource, clock, NULL);
    // 通知 tick_cpu_sched 时钟源改变了
    tick_clock_notify();
    return tk->tkr_mono.clock == clock ? 0 : -1;
}
```

```C
static int change_clocksource(void *data) // 切换时钟源
{
	struct timekeeper *tk = &tk_core.timekeeper;
	struct clocksource *new, *old = NULL;
	unsigned long flags;
	bool change = false;

	new = (struct clocksource *) data;

	/*
	 * If the cs is in module, get a module reference. Succeeds
	 * for built-in code (owner == NULL) as well.
	 */
	if (try_module_get(new->owner)) {   // 如果新的时钟是一个module里面的，需要执行enable
		if (!new->enable || new->enable(new) == 0)
			change = true;
		else
			module_put(new->owner);     // 启用失败
	}

	raw_spin_lock_irqsave(&timekeeper_lock, flags); // 关中断，保留中断上下文
	write_seqcount_begin(&tk_core.seq);

	timekeeping_forward_now(tk);        // 累计时间差，更新到now

	if (change) {
		old = tk->tkr_mono.clock;
		tk_setup_internals(tk, new);    // 切换clock
	}

	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);

	write_seqcount_end(&tk_core.seq);
	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);

	if (old) {
		if (old->disable)
			old->disable(old);

		module_put(old->owner);
	}

	return 0;
}
```

```C
static void timekeeping_forward_now(struct timekeeper *tk)  // 更新时间
{
	u64 cycle_now, delta;

	cycle_now = tk_clock_read(&tk->tkr_mono);
	delta = clocksource_delta(cycle_now, tk->tkr_mono.cycle_last, tk->tkr_mono.mask);
	tk->tkr_mono.cycle_last = cycle_now;
	tk->tkr_raw.cycle_last  = cycle_now;

	tk->tkr_mono.xtime_nsec += delta * tk->tkr_mono.mult;
	tk->tkr_raw.xtime_nsec += delta * tk->tkr_raw.mult;

	tk_normalize_xtime(tk);
}
```

# 更新时间

1. 切换clocksource会触发`timekeeping_forward_now(tk)`
2. sleeptime 注入
3. offset注入
4. 设置时间会更新


# 暂停时钟
```C
tick_suspend();
clocksource_suspend();
clockevents_suspend();
```
# 外部API

- getboottime：获取系统启动时刻的时间。 getboottime => getboottime64，将 timekeeper 中的 CLOCK_MONOTONIC 和 CLOCK_REALTIME 的差值 减去 CLOCK_MONOTONIC 和 boot time 的差值 得到 CLOCK_REALTIME 和 boot time 的差值，即得到了启动时刻时间。
```C
void getboottime64(struct timespec64 *ts)
{
    struct timekeeper *tk = &tk_core.timekeeper;
    ktime_t t = ktime_sub(tk->offs_real, tk->offs_boot);

    *ts = ktime_to_timespec64(t);
}
```

- ktime_t ktime_get(void): 获取系统启动以来所经过的时间，不包含休眠时间。返回 ktime 结构, 根据 tkr_mono 得到。
- ktime_get_boottime: 获取系统启动以来所经过的时间，包含休眠时间。返回 ktime 结构, ktime_get_boottime => ktime_get_with_offset(TK_OFFS_BOOT), 由 tkr_mono 时间加上 offsets[TK_OFFS_BOOT] 得到。
- getboottime64：获取系统启动时刻的时间
- ktime_get_coarse_real_ts64 
- ktime_get_coarse_ts64
- get_monotonic_boottime：获取系统启动以来所经过的时间，包含休眠时间。返回 timespec 结构，实际上是对 ktime_get_boottime 结果调用了 ktime_to_timespec。
- get_seconds：获取当前 xtime ，单位为秒，返回 xtime_sec 。
- getnstimeofday：获取当前时间。返回 timespec 结构。getnstimeofday => getnstimeofday64 => __getnstimeofday64， 由 xtime_sec 加上 tkr_mono 提供的 ns 得到
- do_gettimeofday： 获取当前时间。返回 timeval 结构。实际上是对 getnstimeofday64 的结果降低精度得到。

// defined include/linux/time64.h 文件
- void ktime_get_ts64(struct timespec64 *ts)    => xtime_sec + wall_to_monotonic      //CLOCK_MONOTONIC
- void ktime_get_real_ts64(struct timespec64 *) => xtime_sec + ns    //CLOCK_REALTIME
- void ktime_get_boottime_ts64(struct timespec64 *)；//CLOCK_BOOTTIME
- void ktime_get_raw_ts64(struct timespec64 *)  => raw_sec + ns      //CLOCK_MONOTONIC_RAW