- [时钟源](#时钟源)
- [全局管理变量](#全局管理变量)
- [重要常量](#重要常量)
- [核心数据结构](#核心数据结构)
- [cycle2ns： cycle转换成时间](#cycle2ns-cycle转换成时间)
- [有哪些时钟源](#有哪些时钟源)
  - [jiffies](#jiffies)
  - [PIT(Programmalbe Interval Timer)](#pitprogrammalbe-interval-timer)
  - [acpi\_pm(ACPI power management timer)](#acpi_pmacpi-power-management-timer)
  - [HPET(High Precision Event Timer)](#hpethigh-precision-event-timer)
  - [TSC时钟](#tsc时钟)
- [对下层时钟源设备进行管理](#对下层时钟源设备进行管理)
  - [注册时钟源](#注册时钟源)
  - [卸载时钟源](#卸载时钟源)
- [对上层tk层提供服务](#对上层tk层提供服务)
  - [时钟源设备选择](#时钟源设备选择)
- [api接口层](#api接口层)
  - [注册到 sysfs](#注册到-sysfs)
  - [clocksource watchdog](#clocksource-watchdog)
  - [系统启动时clocksource变化](#系统启动时clocksource变化)
- [时钟初始化](#时钟初始化)
  - [tick\_init tick 系统初始化。](#tick_init-tick-系统初始化)


# 时钟源
`clocksource`是内核表示可以读取时间的设备在`device`基础上抽象，对软硬件时钟的抽象。时钟源设备可以通过驱动提供的read方法读取内在的值，这个值表达为cycle，需要经过一定的计算才能转换成我们能理解的s、millsec、ns。

硬件因为历史的原因，在一个主板或者服务器上会有多个时钟源设备，内核使用rating代表时钟源设备的精度，精度越高越好。最终只有一个会被使用。
- 1-99 - Only available for bootup and testing purposes;
- 100-199 - Functional for real use, but not desired.
- 200-299 - A correct and usable clocksource.
- 300-399 - A reasonably fast and accurate clocksource.
- 400-499 - The ideal clocksource. A must-use where available; 

# 全局管理变量
- struct clocksource *curr_clocksource： 表明当前选择的最优时钟源设备
- struct clocksource *suspend_clocksource：用于计算暂停时间的时钟源设备，该时钟源设备需要支持暂停的时候不停止，理论上不应该提供suspend和resume接口.
- LIST_HEAD(clocksource_list)； 所有注册的时钟源列表，时钟源的选择也是在这个链表上选择，按照rating排序，高的在前面，所以遍历到第一个合适那就是最合适的了。
- char override_name[CS_NAME_LEN]： 用户指定的时钟源名称
- int finished_booting: 表明时间系统是否初始化完了，只要true的时候才进行时钟源切换。
- u64 suspend_start： suspend开始的时间点，用于计量suspend时间。
- LIST_HEAD(watchdog_list)： watchdog上面的时钟源设备列表。
- struct clocksource *watchdog ： 
- struct timer_list watchdog_timer： 
- DECLARE_WORK(watchdog_work, clocksource_watchdog_work)： 

# 重要常量
- #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 5)： Threshold: 0.0312s 

# 核心数据结构
- clocksource：代表一个时钟源设备


```C
struct clocksource {
    cycle_t (*read)(struct clocksource *cs);            // 指向读取时钟的函数，读取时钟源设备当前的周期数值
    cycle_t mask;                                       // 时钟源一共用了多少二进制位来计数。如果用了56位。能够表示的 cycle 上限，通常是 32/64 位的全 f，做与操作可以避免对 overflow 进行专门处理
    u32 mult;                                           // 将时间源的计数单位 (cycle_t) 转换为 ns
    u32 shift;                                          // 换算公式为 time = (cycles * mult) >> shift
    u64 max_idle_ns;                                    // 允许的最大空闲时间，单位 ns，其值是根据max_cycles、mult和shift算出来的。当设置 CONFIG_NO_HZ 时，使用动态 tick，不限制 kernel 的睡眠时间，需要进行限制。睡眠时间不能超过这个阈值。
    u32 maxadj;                                         // 对mult的最大调整值，其比率是固定的，是mult值的11%，也就是说如果需要对mult值进行调整的话，不能超过正负11%的范围。这个值在时间维持层（Time Keeping）会用到
    struct arch_clocksource_data archdata;              // 架构专有(目前只有 x86 和 ia64)。
    u64 max_cycles;                                     // 表示该时钟源设备最多能记录多长周期数值，设置了 cycle 上限，避免换算时溢出
    const char *name;                                   // 时间源名称，在/proc/timer_list中或者dmesg中都会出现
    struct list_head list;                              // 系统中所有的时钟源设备实例都会保存在全局链表clocksource_list中
    int rating;                                         // 代表这个时钟源设备的精度值，其取值范围从1到499，数字越大代表设备的精度越高。
    int (*enable)(struct clocksource *cs);              // 当要打开时钟源设备时，会调用对应设备的该函数
    void (*disable)(struct clocksource *cs);            // 当要关闭时钟源设备时，会调用对应设备的该函数
    enum clocksource_ids	id;                         // 默认 CSID_GENERIC
	enum vdso_clock_mode	vdso_clock_mode;         
    unsigned long flags;                                // 表示该时钟源设备的一些特征属性，一个时钟源可以同时包含多个属性。如果新注册的时钟源的的属性包含CLOCK_SOURCE_MUST_VERIFY，表示该时钟源需要经过看门狗（Watch Dog）的监测。如果误差过大，则会被标记为CLOCK_SOURCE_UNSTABLE。CLOCK_SOURCE_IS_CONTINUOUS表示该时钟源设备是连续的。CLOCK_SOURCE_VALID_FOR_HRES表明该设备是高分辨率的。
    void (*suspend)(struct clocksource *cs);            // 暂停时间源函数
    void (*resume)(struct clocksource *cs);             // 恢复时间源函数
 	void (*mark_unstable)(struct clocksource *cs);      // 如果Linux的系统看门狗（Watch Dog）发现这个时钟源不稳定，会调用对应设备的该函数
	void (*tick_stable)(struct clocksource *cs);        // 如果Linux的系统看门狗（Watch Dog）发现这个时钟源比较稳定，会调用对应设备的该函数

    // 用于监控时间源，校验时间是否准确
    struct list_head wd_list;
    cycle_t cs_last;
    cycle_t wd_last;
    struct module *owner;                               // 指向拥有该时间源的内核模块
};
```
# cycle2ns： cycle转换成时间

时钟源设备里面保存的是cycle，需要转换成时间：
时间(ns) = cycle / freq  * ns_per_sec = cycle / freq * 10^9 = cycle * mult >> shift , 因为除法很贵。 这个运算有精度损耗的，只能尽量逼近。

由于数据格式的原因要求
1. cycle * mult 不能64位溢出， max_idle_ns 就是说明保证从cycle到ms不产生溢出的那个最大的纳秒数。
2. 计算max_idle_ns的时候，为了安全还设定了12.5％的margin

如何获取最佳的mult和shift组合? mult这个因子一定是越大越好了，越大精度越高，但是，我们的运算过程都是64 比特的，也就是说，中间的结果（cycle x mult）不能超过64bit。对于32bit的count，这个要求还好，因为cycle就是32bit的，只要mult不超过32bit就OK了（mult本来就是u32的）。因此，对于那些超过32 bit的count，我们就需要注意了，我们要人为的限制最大时间值，也就是说，虽然硬件counter可以表示出更大的时间值，但是通过mult和shift将这个大的cycle值转成ns值的时候，如果cycle太大，势必导致mult要小一些（否则溢出），而mult较小会导致精度不足，而精度不足（这时候如果要保证转换算法正确，mult需要取一个较小的数值，从而降低了精度）导致转换失去意义，因此，这里给出一个600秒的限制，这个限制也是和max idle ns相关的，具体参考上面的描述。其实这里仍然是一个设计平衡的问题：一方面希望保持精度，因此mult要大，cycle到ns转换的时间范围就会小。另外一方面，cpuidle模块从电源管理的角度看，当然希望其在没有任务的时候，能够idle的时间越长越好，600秒是一个折衷的选择，让双方都基本满意。

以PIT为例，`PIT_TICK_RATE` = 1193182, mask = 32, 这个频率可以表达的时间范围 2^32/freq ≈ 4G/1M = 4K(s), 4千秒超过1个小时。在注册这个时钟源的时候我们看看计算出来的值：
```C
clocksource_i8253_init(void)
|-> clocksource_register_hz(&i8253_cs, 1193182ul)
    |-> __clocksource_register_scale(cs, 1, 1193182ul)
        |-> __clocksource_update_freq_scale(cs, 1, 1193182ul);
            sec = cs->mask / freq /scale = 4k , > 600 => 600
            clocks_calc_mult_shift(&cs->mult, &cs->shift, 1193182ul, 10^9 / 1, 600 * 1)
```

mult、shift、max_idle_ns和maxadj值得计算：
1. 时钟源的最大时间跨度为mask 除以 freq频率 再除以 scale，人为设定不超过600秒。
2. maxadj的值其实就是mult * 11%，通过不断计算限定在mask内，计算得到maxadj。
3. max_cycles是系统能记录的最大时间跨度的周期数。它有两个限定条件，一个是必须小于mask的值，另外一个是max_cycles * mult的值不能64位溢出。由于在实际计算时，mult有可能要加上最大或减去最大maxadj调整值，所以max_cycles必须小于等于64位无符号数能便是的最大数值除以mult+maxadj。


# 有哪些时钟源
- jiffies: clocksource(clocksource_jiffies),kernel保存的软件时钟源，频率由`CONFIG_HZ` 决定，一般在ms级别。
- PIT： clocksource(i8253_cs),硬件可编程时钟, 频率1193182 Hz。
- ACPI_PM：clocksource(clocksource_acpi_pm), 频率为 3.579545 MHz。
- HPET: clocksource(clocksource_hpet), 频率至少为 10MHz。
- TSC: clocksource(clocksource_tsc), 频率和CPU频率相关。

## jiffies
英语中 jiffy 表示 a moment，即一瞬间。在 Linux 中作为软件维护的时钟。表示一小段短暂而不确定的时间。属于低精度时间源，因为没有 `CLOCK_SOURCE_VALID_FOR_HRES` 的 flag，所以不会出现在 `available_clocksource` 中。

```C
static struct clocksource clocksource_jiffies = {
    .name       = "jiffies",
    .rating     = 1,                              // 优先级最低
    .read       = jiffies_read,                    // 读时返回 jiffies
    .mask       = CLOCKSOURCE_MASK(32),
    .mult       = NSEC_PER_JIFFY << JIFFIES_SHIFT,  
    .shift      = JIFFIES_SHIFT,                                            // NSEC_PER_JIFFY 和 JIFFIES_SHIFT 由 CONFIG_HZ 决定
    .max_cycles = 10,
};
```
Linux 用全局变量 jiffies / jiffies_64 来存放系统启动后经过的 jiffy 数目：
```C
extern u64 __jiffy_data jiffies_64;                     // x86_64 下使用，非原子，读时需要加锁，如 get_jiffies_64 用了 seqlock
extern unsigned long volatile __jiffy_data jiffies;     // x86_32 下使用
```
根据 `arch/x86/kernel/vmlinux.lds.S`，在 32 位下，jiffies 指向 jiffies_64 的低 32 位。每当收到 `clock_event_device`发出的中断时，会调用其 handler ，即 `tick_handle_periodic` ，于是有`tick_handle_periodic => tick_periodic => do_timer => jiffies_64 += ticks`。由于 do_timer 的参数为 1，因此 jiffies_64 += 1。而根据 `tick_setup_device` 中 `tick_period = ktime_set(0, NSEC_PER_SEC / HZ)` ，表示 tick_device 每个 tick 间隔为 1 / HZ 秒。于是每个 jiffies 代表的时间为 1/ HZ 秒，系统启动至今所经过的秒数 = jiffies_64 / HZ。HZ 由 CONFIG_HZ 决定，而 CONFIG_HZ 由 CONFIG_HZ_* 决定，有 100/250/300/1000 可选，一般为 1000。所以每隔 1 毫秒，jiffies "时钟" 就会加一，1 jiffy 等于 1 毫秒。从 jiffies 我们可以发现，时钟源的不仅能够通过读取硬件时钟源来实现，还能通过 `tick_device`，更本质上来说是定时器来实现。  
当 jiffies 值超过它的最大范围后就会发生溢出。在 32 位下为 unsigned long，最大取值为 (2^32)-1 即 429496795 。以 HZ 为 1000 为例，从 0 开始，最多经过 5 天就会达到上限。因此采取回绕措施，达到上限时继续增加就会回绕到 0。time_after、time_before、time_after_eq、time_before_eq 等一些宏会对这种情况进行处理。



## PIT(Programmalbe Interval Timer)
通过 8253/8254 时钟芯片实现，经过适当编程后，能够周期性地发出时钟中断。频率为 1193182 Hz (PIT_TICK_RATE)。由于精度问题，在有 HPET 的情况下不会使用 PIT。
```C
static struct clocksource i8253_cs = {
    .name       = "pit",
    .rating     = 110,
    .read       = i8253_read,
    .mask       = CLOCKSOURCE_MASK(32),
};
```

从PIT中读取当前时间，PIT是定时发送中断的设备，没有计时器能力，tick的数量通过jiffies，一个tick周期内的计时通过channel 0的count down计数器来计算，及PIT_LATCH - 1 - count，所以总体的时间为 (u64)(jifs * PIT_LATCH) + count。转换成时间可以通过HZ进行计算。

```C
static u64 i8253_read(struct clocksource *cs)
{
	static int old_count;
	static u32 old_jifs;
	unsigned long flags;
	int count;
	u32 jifs;

	raw_spin_lock_irqsave(&i8253_lock, flags);
	/*
	 * Although our caller may have the read side of jiffies_lock,
	 * this is now a seqlock, and we are cheating in this routine
	 * by having side effects on state that we cannot undo if
	 * there is a collision on the seqlock and our caller has to
	 * retry.  (Namely, old_jifs and old_count.)  So we must treat
	 * jiffies as volatile despite the lock.  We read jiffies
	 * before latching the timer count to guarantee that although
	 * the jiffies value might be older than the count (that is,
	 * the counter may underflow between the last point where
	 * jiffies was incremented and the point where we latch the
	 * count), it cannot be newer.
	 */
	jifs = jiffies;
	outb_p(0x00, PIT_MODE);	/* latch the count ASAP */
	count = inb_p(PIT_CH0);	/* read the latched count */
	count |= inb_p(PIT_CH0) << 8;

	/* VIA686a test code... reset the latch if count > max + 1 */
	if (count > PIT_LATCH) {
		outb_p(0x34, PIT_MODE);
		outb_p(PIT_LATCH & 0xff, PIT_CH0);
		outb_p(PIT_LATCH >> 8, PIT_CH0);
		count = PIT_LATCH - 1;
	}

	/*
	 * It's possible for count to appear to go the wrong way for a
	 * couple of reasons:
	 *
	 *  1. The timer counter underflows, but we haven't handled the
	 *     resulting interrupt and incremented jiffies yet.
	 *  2. Hardware problem with the timer, not giving us continuous time,
	 *     the counter does small "jumps" upwards on some Pentium systems,
	 *     (see c't 95/10 page 335 for Neptun bug.)
	 *
	 * Previous attempts to handle these cases intelligently were
	 * buggy, so we just do the simple thing now.
	 */
	if (count > old_count && jifs == old_jifs)
		count = old_count;

	old_count = count;
	old_jifs = jifs;

	raw_spin_unlock_irqrestore(&i8253_lock, flags);

	count = (PIT_LATCH - 1) - count;

	return (u64)(jifs * PIT_LATCH) + count;
}
```

在 register_refined_jiffies 中定义。基于 PIT，以 PIT_TICK_RATE （1193182 Hz）为频率，精度更高，但依然属于低精度时间源。
```C
int register_refined_jiffies(long cycles_per_second)
{
    u64 nsec_per_tick, shift_hz;
    long cycles_per_tick;

    refined_jiffies = clocksource_jiffies;
    refined_jiffies.name = "refined-jiffies";
    refined_jiffies.rating++;                           // rating 为 2，比 clocksource_jiffies 高

    /* Calc cycles per tick */                          // 和 clocksource_jiffies 不同，根据传入参数 (CLOCK_TICK_RATE) 来计算 shift_hz，然后算出 mult
    cycles_per_tick = (cycles_per_second + HZ/2)/HZ;    // CLOCK_TICK_RATE = PIT_TICK_RATE
    /* shift_hz stores hz<<8 for extra accuracy */
    shift_hz = (u64)cycles_per_second << 8;
    shift_hz += cycles_per_tick/2;
    do_div(shift_hz, cycles_per_tick);
    /* Calculate nsec_per_tick using shift_hz */
    nsec_per_tick = (u64)NSEC_PER_SEC << 8;
    nsec_per_tick += (u32)shift_hz/2;
    do_div(nsec_per_tick, (u32)shift_hz);

    refined_jiffies.mult = ((u32)nsec_per_tick) << JIFFIES_SHIFT;

    __clocksource_register(&refined_jiffies);           // 注册时间源
    return 0;
}
```
## acpi_pm(ACPI power management timer)
几乎所有 ACPI-based 的主板上都会有该设备。频率为 3.579545 MHz
```C
static struct clocksource clocksource_acpi_pm = {
    .name       = "acpi_pm",
    .rating     = 200,
    .read       = acpi_pm_read,
    .mask       = (cycle_t)ACPI_PM_MASK,
    .flags      = CLOCK_SOURCE_IS_CONTINUOUS,
};
```
通过 pmtmr_ioport 变量指向 Power Management Timer 寄存器，其结构如下。 通过调用 read_pmtmr 函数，会去读取 pmtmr_ioport，与上 24 位的 bitmask（ACPI_PM_MASK），获得其 TMR_VAL 部分
- 0..23: TMR_VAL,running count of the power management timer 
- 24..31: E_TMR_VAL, pper eight bits of a  32-bit power management timer

## HPET(High Precision Event Timer)
提供了更高的时钟频率 (10MHz+) 以及更宽的计数范围(64bit)。通过 APIC 发现，利用 MMIO 进行编程，集成到南桥中。包含一个 64bit 的主计数器 (up-counter) 计数器，频率至少为 10MHz，一堆 (最多 256 个) 32 /64 bit 比较器(comparators)。当一个计数器(相关的位) 等于比较器 (最低有效位) 时，产生中断。将 ACPI HPET table 的 hpet_address 映射到虚拟地址空间中，根据 Intel 手册大小为 1024 bytes，因此 HPET_MMAP_SIZE 为 1024。映射后统一通过 hpet_readl 读取该地址空间。
```C
static struct clocksource clocksource_hpet = {
    .name       ="hpet",
    .rating     = 250,
    .read       = read_hpet,
    .mask       = CLOCKSOURCE_MASK(64),
    .flags      = CLOCK_SOURCE_IS_CONTINUOUS,
};
```
## TSC时钟
Pentium 开始提供的 64 位`寄存器` 。每次外部振荡器产生信号时 (每个 CPU 时钟周期) 加 1，因此频率依赖于 CPU 频率(Intel 手册上说相等)，如果 CPU 频率为 400MHz 则每 2.5 ns 加 1。为了使用 TSC，Linux 在系统初始化的时候必须通过调用 `calibrate_tsc(native_calibrate_tsc)` 来确定时钟的频率 (编译时无法确定，因为 kernel 可能运行在不同于编译机的其他 CPU 上)。一般用法是在一定时间内(需要通过其他时间源，如 hpet) 执行两次，记录 start 和 end 的时间戳，同时通过 rdtsc 读取 start 和 end 时 TSC counter，通过 (end - start time) / (end - start counter) 算出期间 CPU 实际频率。但在多核时代下，由于不能保证同一块主板上每个核的同步，CPU 变频和指令乱序执行导致 TSC 几乎不可能取到准确的时间，但新式 CPU 中支持频率不变的 constant TSC。

现代Intel和AMD处理器提供了一个稳定时间戳计数器（Constant Time Stamp Counter, TSC）。这个稳定的TSC的计数频率不会随着CPU核心更改频率而改变，例如，节电策略导致的cpu主频降低不会影响TSC计数。一个CPU具有稳定的TSC频率对于使用TSC作为KVM guest的时钟源时非常重要的。要查看CPU是否具有稳定的时间戳计数器（constant TSC）需要检查cpuinfo中是否有constant_tsc标志：`cat /proc/cpuinfo | grep constant_tsc`
如果上述命令没有任何输出，则表明cpu缺少稳定的TSC特性，需要采用其他时钟源。
```C
static struct clocksource clocksource_tsc = {
    .name                   = "tsc",
    .rating                 = 300,
    .read                   = read_tsc,
    .mask                   = CLOCKSOURCE_MASK(64),
    .flags                  = CLOCK_SOURCE_IS_CONTINUOUS | CLOCK_SOURCE_MUST_VERIFY,
    .archdata               = { .vclock_mode = VCLOCK_TSC },
};
```


# 对下层时钟源设备进行管理


## 注册时钟源

clocksource 要在`初始化阶段？`通过 `clocksource_register_hz` 函数通知内核它的工作时钟的频率。大部分工作在`clocksource_register_scale` 完成，该函数首先完成对mult和shift值的计算，然后根据mult和shift值，`clocksource_enqueue`函数负责按clocksource的rating的大小，把该clocksource挂载到全局链表`clocksource_list` 上，rating值越大，在链表上的位置越靠前。每次新的clocksource注册进来，都会触发`clocksource_select`函数被调用，它按照rating值选择最好的clocksource，并记录在全局变量`curr_clocksource`中，然后通过timekeeping_notify函数通知timekeeping。

```C
/**
 * @cs:		要注册的clocksource设备
 * @scale:	freq * scacle 是设备的评率，比如10kHZ，scale = 1000，freq=10
 * @freq:	freq * scacle 是设备的评率，比如10kHZ，scale = 1000，freq=10
 * 成功返回0，否则EBUSY
 */
int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
{    
    __clocksource_update_freq_scale(cs, scale, freq);/* 计算mult、shift、max_idle_ns和maxadj的值 */    
    mutex_lock(&clocksource_mutex);                 // 需要加锁，保护 curr_clocksource 和 clocksource_list
    clocksource_enqueue(cs);                        // 将clocksource插入到 clocksource_list，按照rating从高到低
    clocksource_enqueue_watchdog(cs);               // 将 cs 加入到 wd_list，启动一个新的 watchdog timer
    clocksource_select();                           // 设置 curr_clocksource 为当前 rating 最高的作为时间源
    clocksource_select_watchdog(false);
    mutex_unlock(&clocksource_mutex);
    return 0;
}
```
__clocksource_update_freq_scale(struct clocksource *cs, u32 scale, u32 freq)
初始化时钟源设备的maxadj、mult、shift、max_idle_ns参数，让时钟源设备可以在精度和功耗之间进行平衡。
- ((u64) cycles * mult) >> shift 可以得到ns时间，cycles表明运行了多少个cycle
- mask表示时钟源能用多少二进制位计数，那么最大跨度当然就是从mask的值，然后用mask/freq就可以计算出最大跨度是多少秒。如果最大跨度大于10分钟，且mask的位数大于32位的话，为了保证精度，人为限定最大跨度为10分钟。
- maxadj的值其实就是mult * 11%，不过如果mult + maxadj的值越界的话，还需要再相应调小mult和shift的值，然后再计算，直到不越界为止。注意，它们都是32位的。
- max_idle_ns
- max_cycles：必须小于mask的值， 必须保证max_cycles * mult不能64位溢出，必须保证max_cycles* (mult+maxadj) 不能64位溢出。
- 对于freq为0就说明mult和shift已经设定好了，不需要去计算，一般用于虚拟时钟。

## 卸载时钟源
```C
int clocksource_unregister(struct clocksource *cs)
|-> ret = clocksource_unbind(cs);
    |-> clocksource_select_watchdog(true); // 如果是watchdog，需要替换watchdog
    |-> clocksource_select_fallback(); // 如果cs是当前的时钟源，需要替换
    |-> clocksource_suspend_select(true); // 如果cs是suspend 计时时钟源，需要替换
    |-> clocksource_dequeue_watchdog(cs); // 停止该设备上的watchdog
    |-> list_del_init(&cs->list); // 从链表上删除
```

# 对上层tk层提供服务

## 时钟源设备选择
系统正在启动的过程中是不会选择最佳设备的。

注册新的时钟原设备到全局链表`clocksource_list`上的时候可能进行时钟源切换，选择一个最佳的时钟，通知timekeeper，修改全局时钟源变量`static struct clocksource *curr_clocksource`。  
选择最佳时钟的原则：
- 已完成初始化，finished_booting 不为1
- 如果当前的Tick设备已经切换到支持单次触发模式了，则当前高精度定时器已经切换到高精度模式了，所以这里时钟源也必须同步支持高精度模式。(CLOCK_SOURCE_VALID_FOR_HRES)
- rating最大

clocksource_done_booting运行在内核初始化快要结束的阶段，会设置时钟源初始化完成，同时启动kwatchdog线程，同时切换时钟源。
```C
static int __init clocksource_done_booting(void)
{
	mutex_lock(&clocksource_mutex);
        /* 获得系统缺省时钟源设备 */
	curr_clocksource = clocksource_default_clock();
	finished_booting = 1;
	/* 启动看门狗线程去除一些不稳定的时钟源 */
	__clocksource_watchdog_kthread();
        /* 选择时钟源设备 */
	clocksource_select();
	mutex_unlock(&clocksource_mutex);
	return 0;
}
fs_initcall(clocksource_done_booting);
```

```C
static void clocksource_select(void)
|-> __clocksource_select(false); // false： 不跳过当前的current clocksource
    |-> best = clocksource_find_best(oneshot, skipcur); // 查找最好的，找不到就停止了
    |-> 如果override_name提供了，会进行判断oneshot、stable，如果不支持就不替换。`CLOCK_SOURCE_UNSTABLE`, `CLOCK_SOURCE_VALID_FOR_HRES`
    |-> timekeeping_notify(best) // 通知tk层更换，成功就替换curr_clocksource.
```

# api接口层

## 注册到 sysfs
```C
static struct bus_type clocksource_subsys = {
    .name ="clocksource",
    .dev_name = "clocksource",
};

static struct device device_clocksource = {
    .id = 0,
    .bus    = &clocksource_subsys,
    .groups	= clocksource_groups,
};

static struct attribute *clocksource_attrs[] = {
	&dev_attr_current_clocksource.attr,
	&dev_attr_unbind_clocksource.attr,
	&dev_attr_available_clocksource.attr,
	NULL
};
ATTRIBUTE_GROUPS(clocksource);

static int __init init_clocksource_sysfs(void)
{
    // 创建 /sys/devices/system/clocksource 目录
    int error = subsys_system_register(&clocksource_subsys, NULL);
    // 创建 /sys/devices/system/clocksource/clocksource0/ 目录
    if (!error)
        error = device_register(&device_clocksource);
    // 创建 clocksource0 下的 current_clocksource
    if (!error)
        error = device_create_file(
                &device_clocksource,
                &dev_attr_current_clocksource);
    // 创建 clocksource0 下的 unbind_clocksource(write only)
    if (!error)
        error = device_create_file(&device_clocksource,
                       &dev_attr_unbind_clocksource);
    // 创建 clocksource0 下的 available_clocksource(read only)
    if (!error)
        error = device_create_file(
                &device_clocksource,
                &dev_attr_available_clocksource);
    return error;
}
```
三个属性：
1. dev_attr_current_clocksource：对应的文件名是current_clocksource，访问权限是644，对root用户可写，对所有用户可读。写入的内容是时钟源设备的名字，内核会查找并用其替换当前的时钟源。如果读的话，其内容是当前正在使用的时钟源设备名字。
2. dev_attr_unbind_clocksource：对应的文件名是unbind_clocksource，访问权限是200，对root用户可写。写入的内容是时钟源设备的名字，内核会查找并解绑该设备，如果要解绑的时钟源设备是当前正在使用的，还会再选择一个替换的。
3. dev_attr_available_clocksource：对应的文件名是available_clocksource，访问权限是444，对所有用户可读。该文件的内容是系统中所有注册的时钟源设备的名字。

## clocksource watchdog
clocksource不止一个，为了筛选clocksource。内核启用了一个周期为0.5秒的定时器。clocksource被注册时，除clocksource_list外，还会同时挂载到watchdog_list链表。定时器每0.5秒检查watchdog_list上的clocksource，WATCHDOG_THRESHOLD的值定义为0.0625秒，如果在0.5秒内，clocksource的偏差大于这个值就表示这个clocksource是不稳定的，定时器的回调函数通过clocksource_watchdog_kthread线程标记该clocksource，并把它的rate修改为0，表示精度极差。

## 系统启动时clocksource变化
系统的启动时，内核会注册了一个基于jiffies的clocksource（kernel/time/jiffies.c），它精度只有1/HZ秒，rating值为1。如果平台的代码没有提供定制的clocksource_default_clock函数，系统将返回这个基于jiffies的clocksource。启动的后半段，clocksource的代码会把全局变量curr_clocksource设置为clocksource_default_clock返回的clocksource。当然即使平台的代码没有提供clocksource_default_clock函数，在平台的硬件计时器注册时，经过clocksource_select()函数，系统还是会切换到精度更好的硬件计时器上。






# 时钟初始化

x86_init 定义在 arch/x86/kernel/x86_init.c，用于指定平台特有的初始化函数指针：
```C
struct x86_platform_ops x86_platform __ro_after_init = {
	.calibrate_cpu			= native_calibrate_cpu_early,
	.calibrate_tsc			= native_calibrate_tsc,
	.get_wallclock			= mach_get_cmos_time,
	.set_wallclock			= mach_set_rtc_mmss,
	.save_sched_clock_state		= tsc_save_sched_clock_state,
	.restore_sched_clock_state	= tsc_restore_sched_clock_state,
};

struct x86_init_ops x86_init __initdata = {
    ...
    .timers = {
        .setup_percpu_clockev   = setup_boot_APIC_clock,         // 为当前 CPU(boot CPU)初始化 APIC timer
        .timer_init     = hpet_time_init,                        // 初始化 hpet
        .wallclock_init     = x86_wallclock_init,                // 查找x86架构的cmos设备，如果没找到用noop填充
    },
};
```
wallclock_init 在 x86 架构下没实现。register_refined_jiffies 前面提过，于是我们直接来看 tick_init。

## tick_init tick 系统初始化。
```C
=> tick_broadcast_init
=> tick_nohz_init
```
tick_broadcast_init 初始化了 6 个 CPU 的 bitmask：
```C
	void __init tick_broadcast_init(void)
{
    zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);           // 正在处于睡眠的 CPU
    zalloc_cpumask_var(&tick_broadcast_on, GFP_NOWAIT);             // 处于周期性广播状态的 CPU
    zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);                       // 临时变量
#ifdef CONFIG_TICK_ONESHOT
    zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);   // 需要被通知的 CPU
    zalloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);   // 阻塞广播的 CPU
    zalloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);     // 强制执行广播的 CPU
#endif
}
```

而 tick_nohz_init 初始化 tickless 模式：
```C
void __init tick_nohz_init(void)
{
    int cpu;

    if (!tick_nohz_full_running) {
        // 分配 tick_nohz_full_mask，用于标识开启 full NO_HZ 的 CPU。这里设置为全 1，并设置 tick_nohz_full_running = true
        if (tick_nohz_init_all() < 0)
            return;
    }

    // 分配 housekeeping_mask ，用于标识不开启 NO_HZ 的 CPU(至少要有一个)
    if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
        WARN(1, "NO_HZ: Can't allocate not-full dynticks cpumask\n");
        cpumask_clear(tick_nohz_full_mask);
        tick_nohz_full_running = false;
        return;
    }

    /*
     * Full dynticks uses irq work to drive the tick rescheduling on safe
     * locking contexts. But then we need irq work to raise its own
     * interrupts to avoid circular dependency on the tick
     */
    // 查是否支持发送跨处理器中断，因为需要跨处理器唤醒
    if (!arch_irq_work_has_interrupt()) {
        pr_warn("NO_HZ: Can't run full dynticks because arch doesn't support irq work self-IPIs\n");
        cpumask_clear(tick_nohz_full_mask);
        cpumask_copy(housekeeping_mask, cpu_possible_mask);
        tick_nohz_full_running = false;
        return;
    }

    // 获取当前 CPU 的 id，负责 housekeeping，即唤醒其他 CPU
    cpu = smp_processor_id();

    // 如果当前 CPU 在 tick_nohz_full_mask 中，去掉，因为它需要负责 housekeeping
    if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
        pr_warn("NO_HZ: Clearing %d from nohz_full range for timekeeping\n",
            cpu);
        cpumask_clear_cpu(cpu, tick_nohz_full_mask);
    }

    // 将所有不属于 tick_nohz_full_mask 的 CPU 设置到 housekeeping_mask 中
    cpumask_andnot(housekeeping_mask,
               cpu_possible_mask, tick_nohz_full_mask);

    // 为 tick_nohz_full_mask 中的 CPU 设置 context_tracking.active(per-cpu 变量)为 true，让 tracking subsystem 忽略之
    for_each_cpu(cpu, tick_nohz_full_mask)
        context_tracking_cpu_set(cpu);

    cpu_notifier(tick_nohz_cpu_down_callback, 0);
    pr_info("NO_HZ: Full dynticks CPUs: %*pbl.\n",
        cpumask_pr_args(tick_nohz_full_mask));

    /*
     * We need at least one CPU to handle housekeeping work such
     * as timekeeping, unbound timers, workqueues, ...
     */
    // 如果 housekeeping_mask 为空，则没有 CPU 能够来负责 housekeeping，报警告
    WARN_ON_ONCE(cpumask_empty(housekeeping_mask));
}
```
在完成了对 tick_device 的初始化后，基于 tick 的 jiffies 时钟能够正常工作，于是我们可以对依赖于 jiffies 的低精度定时器进行初始化。





[droidphone 的 Linux时间子系统 系列文章](http://blog.csdn.net/droidphone/article/)
[linux-insides](https://0xax.gitbooks.io/linux-insides/content/Timers/)