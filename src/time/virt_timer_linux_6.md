# hrtimers_init高精度时钟

低精度定时器(timer) 存在的以下问题：
- 精度太低。低精度定时器基于 jiffies，以 jiffies 为计数单位，而 jiffies 的精度只有 1 / CONFIG_HZ，前文提到，一般为 1000，因此低精度定时器的精度只有 1 毫秒。
- 虽然在大多数情况下操作分层时间轮的开销为常数级，但在发生进位时需要做 cascade，开销为 O(n)。当然前文提到在新实现中以精度换取了开销的减少
- 低精度定时器在设计时希望在超时到来之前获得正确的结果，然后删除之，精确定时不是其设计目的
- time event device的精度可以达到纳秒级，低精度时钟是无法使用的。

高精度定时器(hrtimer)不是完全替换掉现有的低精度时钟框架，而是基于高精度时间事件设备(lapic 中的timer)的能力补充，精度可以达到纳秒级。
- 工作基础依赖CPU私有的本地时钟，也就是LAPIC timer。使用全局高精度时钟(HPET)会导致CPU之间的IPI(Internal Processor Interrupt)带来较大开销(?)。
- 高精度时钟可以支持`高精度模式`和`低精度模式`,可以在两种模式之间切换。
- 有了高精度时钟后，低精度时钟的tick通过tick sched进行模拟驱动。


# 数据结构
## 全局变量定义
- DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases): 每个cpu都有8科hrtimer的红黑树，分别为[monotonic, realtime, boottime, tai], 以及对应的soft
- hrtimer_hres_enabled： 已经启用了hrtimer吗
- static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched)： cpu专用的模拟tick timer，每一个cpu都有？



## hrtimer代表一个时钟
Linux 重新设计了一套 高精度定时器，可以提供纳秒级的定时精度。
```C
struct hrtimer {
    struct timerqueue_node      node;   // 红黑树节点的封装，expires表示该定时器的硬超时时间，按顺序被插入到红黑树中，树的最左边的节点就是最快到期的定时器
    ktime_t             _softexpires;   // 软超时时间，还可以再拖一会再调用超时回调函数，而到达硬超时时间后就不能再拖了
    enum hrtimer_restart        (*function)(struct hrtimer *);  // 定时器到期后的回调函数
    struct hrtimer_clock_base   *base;  // 指向所属的 hrtimer_clock_base
    u8              state;              // 当前的状态，只有 HRTIMER_STATE_INACTIVE(未激活) 和 HRTIMER_STATE_ENQUEUED(激活) 两种
    u8              is_rel;             // 是否是相对时间
    u8				is_soft;            // 软中断上下文(HRTIMER_SOFTIRQ)
	u8				is_hard;            // 硬中断上下文
};

struct timerqueue_node {
    struct rb_node node;                // 在红黑树中对应的节点
    ktime_t expires;                    // 硬超时时间，等于 _softexpires + slack
};
```
可以发现有两个超时时间： _softexpires 用来维护最早超时时间，而 expires 用来维护最晚超时时间，因此 hrtimer 可能在 [_softexpires, expires] 之间的任意时刻超时。有了这个范围，定时器系统可以让范围接近或重叠的多个定时器在同一时刻同时到期，避免进程频繁地被 hrtimer 进行唤醒。

## hrtimer_clock_base一颗高精度时钟的红黑树
类似于 timer 需要被注册到 timer_base 上，hrtimer 也需要被注册到 `hrtimer_clock_base` 上。但不同于 timer_base 采用时间轮，hrtimer_clock_back 采用了`红黑树` 来维护 timer，树的最左边的节点就是最快超时的 hrtimer。
```C

struct hrtimer_clock_base {
	struct hrtimer_cpu_base	*cpu_base;    // 指向所属的 hrtimer_cpu_base
	unsigned int		index;            // 类型 index， 表示该结构体在当前CPU的hrtimer_cpu_base结构体中clock_base数组中所处的下标。
	clockid_t		clockid;              // 表示当前时钟类型的ID值。
	seqcount_raw_spinlock_t	seq;          // 顺序锁，在处理到期定时器的函数__run_hrtimer中会用到
	struct hrtimer		*running;         // 指向当前正在处理的那个定时器
	struct timerqueue_head	active;       // 红黑树，包含了所有使用该时间类型的定时器
	ktime_t			(*get_time)(void);    // 函数指针，指定了如何获取该时间类型的当前时间的函数。由于不同类型的时间在Linux中都是由时间维护层来统一管理的，因此这些函数都是在时间维护层里面定义好的。
	ktime_t			offset;               // 表示当前时间类型和单调时间之间的差值
} __hrtimer_clock_base_align;

struct timerqueue_head {
    struct rb_root head;                                    // 红黑树根节点
    struct timerqueue_node *next;                           // 指向树上最早超时的节点，即最左边的节点
};
```
每个 CPU 维护了一个 hrtimer_cpu_base 变量，其维护了其拥有的 hrtimer_clock_base 数组。hrtimer_clock_base 数组有 8 项。有SOFT结尾表示在软中断(HRTIMER_SOFTIRQ)上下文执行，否则通过硬中断上下文执行。
```C
enum  hrtimer_base_type {
	HRTIMER_BASE_MONOTONIC,         // 单调递增的monotonic时间，不包含休眠时间
	HRTIMER_BASE_REALTIME,          // 墙上真实时间
	HRTIMER_BASE_BOOTTIME,          // 单调递增的boottime，包含休眠时间
	HRTIMER_BASE_TAI,               // Temps Atomique International，CLOCK_TAI = CLOCK_REALTIME(UTC) + tai_offset
	HRTIMER_BASE_MONOTONIC_SOFT,
	HRTIMER_BASE_REALTIME_SOFT,
	HRTIMER_BASE_BOOTTIME_SOFT,
	HRTIMER_BASE_TAI_SOFT,
	HRTIMER_MAX_CLOCK_BASES,
};
```
如果这几种 hrtimer_clock_base 都被创建了，则它们最先超时的时间可能不同，此时将它们中最先超时的时间存到 hrtimer_cpu_base.expires_next 中。

## hrtimer_cpu_base 一个cpu上八个高精度时钟红黑树 
没有加SOFT后缀的，表示是“硬”定时器，将直接在中断处理程序中处理；而加了SOFT后缀的，表示是“软”定时器，将在软中断（HRTIMER_SOFTIRQ）中处理。

CPU单独管理属于自己的高分辨率定时器,hrtimer_cpu_base:
```C
struct hrtimer_cpu_base {
	raw_spinlock_t			lock;                     // 用来保护该结构体的自旋锁
	unsigned int			cpu;                      // 绑定到的CPU编号
	unsigned int			active_bases;             // 表示clock_base数组中哪些元素下的红黑树中含有定时器
	unsigned int			clock_was_set_seq;        // 表示时钟被设置的序数
	unsigned int			hres_active		    :1,   // 表示是否已经处在了高精度模式下
					        in_hrtirq		    :1,   // 是否正在执行hrtimer_interrupt中断处理程序中
					        hang_detected		:1,   // 表明在前一次执行hrtimer_interrupt中断处理程序的时候发生了错误
					        softirq_activated   :1;   // 是否正在执行hrtimer_run_softirq软中断处理程序
#ifdef CONFIG_HIGH_RES_TIMERS
	unsigned int			nr_events;                // 表明一共执行了多少次hrtimer_interrupt中断处理程序
	unsigned short			nr_retries;               // 表明在执行hrtimer_interrupt中断处理程序的时候对定时事件设备编程错误后重试的次数
	unsigned short			nr_hangs;                 // 表明在执行hrtimer_interrupt中断处理程序的时候发生错误的次数
	unsigned int			max_hang_time;            // 表明在碰到错误后，在hrtimer_interrupt中断处理程序中停留的最长时间
#endif
#ifdef CONFIG_PREEMPT_RT
	spinlock_t			softirq_expiry_lock;
	atomic_t			timer_waiters;
#endif
	ktime_t				expires_next;                 // 该CPU上即将要到期定时器的到期时间
	struct hrtimer			*next_timer;              // 该CPU上即将要到期的定时器
	ktime_t				softirq_expires_next;         // 该CPU上即将要到期的“软中断”定时器的到期时间
	struct hrtimer			*softirq_next_timer;      // 该CPU上即将要到期的“软”定时器
	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES]; // 高分辨率定时器的到期时间可以基于8种时间类型
} ____cacheline_aligned;
```

# 高精度时钟管理
- 系统初始化
- 创建一个高精度时钟
- 激活hrtimer
- 删除hrtimer
- 迁移hrtimer
- 查找快要到期的hrtimer
- 对设备设定到期时间
- 周期触发-低精度模式
- 低精度切换高精度
- 周期触发-高精度模式

## 系统初始化
hrtimers_init函数对高分辨率定时器层数据结构初始化，hrtimers_init => hrtimers_prepare_cpu(smp_processor_id())

```C
void __init hrtimers_init(void)
{
	hrtimers_prepare_cpu(smp_processor_id());
	open_softirq(HRTIMER_SOFTIRQ, hrtimer_run_softirq);
}
```

```C
int hrtimers_prepare_cpu(unsigned int cpu)   // 引导时初始化
{
    // 取出 CPU 对应的 hrtimer_cpu_base
    struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
    int i;

    // 初始化各种 hrtimer_clock_base
    for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
        cpu_base->clock_base[i].cpu_base = cpu_base;
        timerqueue_init_head(&cpu_base->clock_base[i].active);
    }

    cpu_base->cpu = cpu;
    // 初始化超时时间为 KTIME_MAX，active hrtimer_cpu_base 数为 0
    hrtimer_init_hres(cpu_base);
    return 0;
}
```



## 创建: 定义一个 hrtimer 变量，然后调用 hrtimer_init 进行初始化。
```C
hrtimer_init => __hrtimer_init => hrtimer_clockid_to_base                       根据 clock_id 找到 base
                               => timer->base = &cpu_base->clock_base[base]     填充到当前 CPU 的 clock_base 数组中
                               => timerqueue_init                               初始化自己的红黑树节点
```
## 激活 / 修改
有两种方式可以激活 hrtimer： hrtimer_start 和 hrtimer_start_range_ns：前者指定的是超时的时间点，而后者可以指定超时的时间范围。实际上 hrtimer_start 正是通过调用 hrtimer_start_range_ns 来实现，只是参数 delta_ns 也就是 slack 值为 0。
```C
void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
                u64 delta_ns, const enum hrtimer_mode mode)
{
    struct hrtimer_clock_base *base, *new_base;
    unsigned long flags;
    int leftmost;

    base = lock_hrtimer_base(timer, &flags);

    /* Remove an active timer from the queue: */
    // 如果该 hrtimer 已经在树上，先将它移除
    remove_hrtimer(timer, base, true);

    // 如果是相对时间，则加上 hrtimer_clock_base 的当前时间成为绝对时间
    if (mode & HRTIMER_MODE_REL)
        tim = ktime_add_safe(tim, base->get_time());

    // 如果开启了 CONFIG_TIME_LOW_RES，则需要进入低精度模式，将 hrtimer 粒度设置为 hrtimer_resolution
    tim = hrtimer_update_lowres(timer, tim, mode);

    // 设置软超时时间和硬超时时间
    hrtimer_set_expires_range_ns(timer, tim, delta_ns);

    /* Switch the timer base, if necessary: */
    // 如果 hrtimer 的 base 和当前 CPU 不一致，需要迁移到当前 CPU 的 base
    new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);

    timer_stats_hrtimer_set_start_info(timer);

    // 将 hrtimer 加入到黑红树中，如果当前节点是最早超时的，则返回 true
    leftmost = enqueue_hrtimer(timer, new_base);
    if (!leftmost)
        goto unlock;

    // 如果该 hrtimer 是最早超时的
    if (!hrtimer_is_hres_active(timer)) {
        /*
         * Kick to reschedule the next tick to handle the new timer
         * on dynticks target.
         */
        if (new_base->cpu_base->nohz_active)
            wake_up_nohz_cpu(new_base->cpu_base->cpu);
    } else {
        // 处于高精度模式，调用 tick_program_event 重新编程
        hrtimer_reprogram(timer, new_base);
    }
unlock:
    unlock_hrtimer_base(timer, &flags);
}
```
高分辨率定时器共有以下几种模式：
```C
enum hrtimer_mode {
	HRTIMER_MODE_ABS	= 0x00,
	HRTIMER_MODE_REL	= 0x01,
	HRTIMER_MODE_PINNED	= 0x02,
	HRTIMER_MODE_SOFT	= 0x04,
	HRTIMER_MODE_HARD	= 0x08,
	HRTIMER_MODE_ABS_PINNED = HRTIMER_MODE_ABS | HRTIMER_MODE_PINNED,
	HRTIMER_MODE_REL_PINNED = HRTIMER_MODE_REL | HRTIMER_MODE_PINNED,
	HRTIMER_MODE_ABS_SOFT	= HRTIMER_MODE_ABS | HRTIMER_MODE_SOFT,
	HRTIMER_MODE_REL_SOFT	= HRTIMER_MODE_REL | HRTIMER_MODE_SOFT,
	HRTIMER_MODE_ABS_PINNED_SOFT = HRTIMER_MODE_ABS_PINNED | HRTIMER_MODE_SOFT,
	HRTIMER_MODE_REL_PINNED_SOFT = HRTIMER_MODE_REL_PINNED | HRTIMER_MODE_SOFT,
	HRTIMER_MODE_ABS_HARD	= HRTIMER_MODE_ABS | HRTIMER_MODE_HARD,
	HRTIMER_MODE_REL_HARD	= HRTIMER_MODE_REL | HRTIMER_MODE_HARD,
	HRTIMER_MODE_ABS_PINNED_HARD = HRTIMER_MODE_ABS_PINNED | HRTIMER_MODE_HARD,
	HRTIMER_MODE_REL_PINNED_HARD = HRTIMER_MODE_REL_PINNED | HRTIMER_MODE_HARD,
}
```
共有五种基本模式，其它模式都是由这五种组合而成：
- HRTIMER_MODE_ABS：表示定时器到期时间是一个绝对值。
- HRTIMER_MODE_REL：表示定时器到期时间是一个相对于当前时间之后的值。
- HRTIMER_MODE_PINNED：表示定时器是否需要绑定到某个CPU上。
- HRTIMER_MODE_SOFT：表示该定时器是否是“软”的，也就是定时器到期回调函数是在软中断下被执行的。
- HRTIMER_MODE_HARD：表示该定时器是否是“硬”的，也就是定时器到期回调函数是在中断处理程序中被执行的。

## tick_program_event

```C
int tick_program_event(ktime_t expires, int force)
{
    struct clock_event_device *dev = __this_cpu_read(tick_cpu_device.evtdev);

    if (unlikely(expires.tv64 == KTIME_MAX)) {
        /*
         * We don't need the clock event device any more, stop it.
         */
        clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT_STOPPED);
        return 0;
    }

    if (unlikely(clockevent_state_oneshot_stopped(dev))) {
        /*
         * We need the clock event again, configure it in ONESHOT mode
         * before using it.
         */
        clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT);
    }

    return clockevents_program_event(dev, expires, force);
}
```
找到当前 CPU 的 clock_event_device，将其切换到 oneshot 模式，然后设定超时时间为 hrtimer 超时时间。

## 移除
remove_hrtimer => __remove_hrtimer
```C
static void __remove_hrtimer(struct hrtimer *timer,
                 struct hrtimer_clock_base *base,
                 u8 newstate, int reprogram)
{
    struct hrtimer_cpu_base *cpu_base = base->cpu_base;
    u8 state = timer->state;

    timer->state = newstate;
    if (!(state & HRTIMER_STATE_ENQUEUED))
        return;

    // 从红黑树上移除，返回最早超时 hrtimer 指针，如果返回 NULL，表示树上没有 hrtimer 了，需要更新该 base 状态为非 active
    if (!timerqueue_del(&base->active, &timer->node))
        cpu_base->active_bases &= ~(1 << base->index);

#ifdef CONFIG_HIGH_RES_TIMERS
    /*
     * Note: If reprogram is false we do not update
     * cpu_base->next_timer. This happens when we remove the first
     * timer on a remote cpu. No harm as we never dereference
     * cpu_base->next_timer. So the worst thing what can happen is
     * an superflous call to hrtimer_force_reprogram() on the
     * remote cpu later on if the same timer gets enqueued again.
     */
    // 如果开启了高精度模式且 reprogram 为 1，则重新设置 clock_event_device 的触发时间
    if (reprogram && timer == cpu_base->next_timer)
        hrtimer_force_reprogram(cpu_base, 1);
#endif
}
```
## 超时触发
高精度定时器检查是否有超时的 hrtimer 的时机取决于是否进入高精度模式。

在进入高精度模式前，每当收到 tick 时，有调用链 tick_periodic => update_process_times => run_local_timers => hrtimer_run_queues
```C
void hrtimer_run_queues(void)
{
    struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
    ktime_t now;
    // 当前处于高精度模式，直接返回
    if (__hrtimer_hres_active(cpu_base))
        return;

    /*
     * This _is_ ugly: We have to check periodically, whether we
     * can switch to highres and / or nohz mode. The clocksource
     * switch happens with xtime_lock held. Notification from
     * there only sets the check bit in the tick_oneshot code,
     * otherwise we might deadlock vs. xtime_lock.
     */
    // 如果支持高精度，则切换到高精度模式，否则尝试切换到 nohz 模式
    if (tick_check_oneshot_change(!hrtimer_is_hres_enabled())) {
        hrtimer_switch_to_hres();
        return;
    }

    raw_spin_lock(&cpu_base->lock);
    now = hrtimer_update_base(cpu_base);
    // 遍历 hrtimer_cpu_base 中的各个 base，不断取出它们最早超时的节点(hrtimer), 如果它们相对现在已经超时，调用 __run_hrtimer
    // __run_hrtimer 会将其从红黑树上移除，并调用回调函数
    __hrtimer_run_queues(cpu_base, now);
    raw_spin_unlock(&cpu_base->lock);
}
```
可以看到在进入高精度模式前，处理 hrtimer 的精度为每 tick 一次，因为 jiffies 在每次 tick 时也会加一，也就是说 hrtimer 几乎沦为了 timer。但它会不断尝试进入高精度模式。如果可以能进入高精度模式，通过调用 hrtimer_switch_to_hres => tick_init_highres => tick_switch_to_oneshot(hrtimer_interrupt) 进行切换。它会将 CPU clock_event_device 的回调函数设置为 hrtimer_interrupt ，并将该设备切换到 oneshot mode。一旦 base 进入高精度模式，此后 hrtimer_run_queues 会直接返回。

此后在收到 clock_event_device 发来的中断后，调用 hrtimer_interrupt 对超时 hrtimer 进行处理：
```C
void hrtimer_interrupt(struct clock_event_device *dev)
{
    struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
    ktime_t expires_next, now, entry_time, delta;
    int retries = 0;

    BUG_ON(!cpu_base->hres_active);
    cpu_base->nr_events++;
    dev->next_event.tv64 = KTIME_MAX;

    raw_spin_lock(&cpu_base->lock);
    // 记录进入循环时的时间
    entry_time = now = hrtimer_update_base(cpu_base);
retry:
    cpu_base->in_hrtirq = 1;
    /*
     * We set expires_next to KTIME_MAX here with cpu_base->lock
     * held to prevent that a timer is enqueued in our queue via
     * the migration code. This does not affect enqueueing of
     * timers which run their callback and need to be requeued on
     * this CPU.
     */
    cpu_base->expires_next.tv64 = KTIME_MAX;
    // 遍历 hrtimer_cpu_base 中的各个 base，不断取出它们最早超时的节点(hrtimer), 如果它们相对现在已经超时，调用 __run_hrtimer
    // __run_hrtimer 会将其从红黑树上移除，并调用回调函数
    __hrtimer_run_queues(cpu_base, now);

    /* Reevaluate the clock bases for the next expiry */
    // 遍历 hrtimer_cpu_base 中的各个 base，得到下次最早的超时时间
    expires_next = __hrtimer_get_next_event(cpu_base);
    /*
     * Store the new expiry value so the migration code can verify
     * against it.
     */
    cpu_base->expires_next = expires_next;
    cpu_base->in_hrtirq = 0;
    raw_spin_unlock(&cpu_base->lock);

    /* Reprogramming necessary ? */
    // 将新的超时时间设置到 clock_event_device
    if (!tick_program_event(expires_next, 0)) {
        cpu_base->hang_detected = 0;
        return;
    }
    // 如果 tick_program_event 返回非 0，表示 expires_next 已经过期，可能原因如下：

    /*
     * The next timer was already expired due to:
     * - tracing
     * - long lasting callbacks
     * - being scheduled away when running in a VM
     *
     * We need to prevent that we loop forever in the hrtimer
     * interrupt routine. We give it 3 attempts to avoid
     * overreacting on some spurious event.
     *
     * Acquire base lock for updating the offsets and retrieving
     * the current time.
     */
    // 为了解决这个问题，我们提供 3 次机会，重新执行前面的循环，处理到期的 hrtimer
    raw_spin_lock(&cpu_base->lock);
    now = hrtimer_update_base(cpu_base);
    cpu_base->nr_retries++;
    if (++retries < 3)
        goto retry;
    /*
     * Give the system a chance to do something else than looping
     * here. We stored the entry time, so we know exactly how long
     * we spent here. We schedule the next event this amount of
     * time away.
     */
    cpu_base->nr_hangs++;
    cpu_base->hang_detected = 1;
    raw_spin_unlock(&cpu_base->lock);
    delta = ktime_sub(now, entry_time);
    // 如果 3 次尝试后依然失败，则计算 3 次循环的总时间，直接将下次超时的时间推后，最多 100 ms，然后重新通过 tick_program_event 设置
    if ((unsigned int)delta.tv64 > cpu_base->max_hang_time)
        cpu_base->max_hang_time = (unsigned int) delta.tv64;
    /*
     * Limit it to a sensible value as we enforce a longer
     * delay. Give the CPU at least 100ms to catch up.
     */
    if (delta.tv64 > 100 * NSEC_PER_MSEC)
        expires_next = ktime_add_ns(now, 100 * NSEC_PER_MSEC);
    else
        expires_next = ktime_add(now, delta);
    tick_program_event(expires_next, 1);
    printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
            ktime_to_ns(delta));
}
```


# 模拟 tick
前面提到，我们通过 tick_switch_to_oneshot(hrtimer_interrupt) 切换到高精度模式。它会将 CPU clock_event_device 的回调函数设置为 hrtimer_interrupt 。那么原来的回调函数，也就是 tick_handle_periodic 被替换掉了。如此一来，我们就不会再处理 tick ，于是依赖于 jiffies 或者更准确地说是 tick 的低精度定时器 timer 将得不到处理。我们需要对这种情况进行处理，Linux 采用的方法是 tick 模拟：

通过定义一个 hrtimer，把它的超时时间设定为一个 tick ，当这个 hrtimer 到期时，在这个 hrtimer 的回调函数中，调用 tick 的回调函数，如此一来，就实现了通过高精度设备模拟低精度设备的目的。

这个 hrtimer 位于 per-cpu 变量 tick_cpu_sched ，类型为 tick_sched：



由于已经没有Tick了，而这时候高分辨率定时器层是处在高精度模式的，那么想制造一个Tick其实很简单，只需要向高分辨率定时器层添加一个定时间隔是一个Tick的高分辨率定时器模拟一下以前的系统Tick就好了。函数首先初始化了在本CPU结构体变量tick_sched中的sched_timer高分辨率定时器。可以看到，它是用的单调时间，到期时间是绝对值，并且是一个“硬”定时器，定时器的到期函数被设置成了tick_sched_timer。

get_irq_regs函数获得指向中断上下文中所有寄存器栈的指针，如果该函数不是在中断上下文中调用的，则返回的是空指针。