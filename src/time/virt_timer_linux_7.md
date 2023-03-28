# tick_sched 模拟高精度timer驱动时间tick

高精度时钟通过注册`hrtimer_interrupt`中断处理程序接管了`clock_event_device`的中断处理。jiffies和wall time原由tick更新，现在需要hrtimer来负责更新。在hrtimer模拟一个时钟`tick_sched` 负责更新时间。

1. 谁在负责更新jiffeis
2. 谁在负责更新wall time
3. 动态时钟：空闲的cpu停掉tick，省电
4. 哪个cpu负责
5. 为什么timer会迁移
6. 


## 工作原理
jiffies和wall time需要通过timer进行更新。


## 数据结构
### 全局变量
1. #define TICK_NSEC ((NSEC_PER_SEC+HZ/2)/HZ), 这个HZ是100、300、1000， 默认是1000.
2. static DEFINE_PER_CPU(struct tick_sched, tick_cpu_sched)： 每个CPU都定义了一个`tick_sched`, 对应一个`hrtimer`。
3. static int sched_skew_tick：偏移tick，避免所有cpu的tick同时到达，产生竞争。
4. static ktime_t last_jiffies_update: 最后一次jiffies更新的时间
5. ktime_t tick_next_period：下一次tick的时间，由负责tick的cpu更新。
6. #define MAX_STALLED_JIFFIES 5
7. int tick_do_timer_cpu = TICK_DO_TIMER_BOOT： 记录负责do_timer()的cpu编号，只让处理该时间的cpu。
8. bool tick_nohz_full_running： 是否nohz_full 模式运行
9. Never omit scheduling-clock ticks (CONFIG_HZ_PERIODIC=y or CONFIG_NO_HZ=n for older kernels).  You normally will -not- want to choose this option.
10. Omit scheduling-clock ticks on idle CPUs (CONFIG_NO_HZ_IDLE=y or	CONFIG_NO_HZ=y for older kernels).  This is the most common	approach, and should be the default.
11. Omit scheduling-clock ticks on CPUs that are either idle or that	have only one runnable task (CONFIG_NO_HZ_FULL=y).  Unless you are running realtime applications or certain types of HPC	workloads, you will normally -not- want this option.

### 重要数据结构
```C
struct tick_sched {
	struct hrtimer			sched_timer;           // 模拟系统Tick的一个高分辨率定时器。
	unsigned long			check_clocks;          // 该字段用来实现定时事件层和时钟源层向Tick模拟层的通知上报机制。当该字段的第0位被置位是，意味着有一个新的定时事件设备或者一个新的时钟源设备被添加到系统中了。
	enum tick_nohz_mode		nohz_mode;             // 动态时钟工作模式：NOHZ_MODE_INACTIVE未激活，NOHZ_MODE_LOWRES低精度动态时钟，NOHZ_MODE_HIGHRES高精度动态时钟模式。
 
	unsigned int			inidle		: 1;       // 当前CPU处于空闲状态。
	unsigned int			tick_stopped	: 1;   // 当前CPU上的Tick已经被停止了。
	unsigned int			idle_active	: 1;       // 当前CPU确实是处于空闲状态。一般情况下inidle的值和idle_active的值应该是一样的，但有可能在CPU处于空闲状态时，收到一个中断处理请求，这时候当前CPU就会临时退出空闲状态，将idle_active置0，但inidle任然是1。
	unsigned int			do_timer_last	: 1;   // 表示在停止Tick之前，该CPU是否是负责更新系统jiffies的。
	unsigned int			got_idle_tick	: 1;   // 表示是否在空闲状态下仍收到了Tick。
	ktime_t				last_tick;                 // 记录上一次Tick到来的时间。
	ktime_t				next_tick;                 // 记录下一次Tick到来的时间。
	unsigned long			idle_jiffies;          // 在进入空闲状态时，系统jiffies的值。
	unsigned long			idle_calls;            // 记录一共进入了多少次空闲状态。
	unsigned long			idle_sleeps;           // 记录了进入空闲状态后，一共停了多少次Tick。
	ktime_t				idle_entrytime;            // 记录了进入空闲状态的时间。
	ktime_t				idle_waketime;             // 记录了在空闲状态下收到并处理中断的时间。
	ktime_t				idle_exittime;             // 记录上一次退出空闲状态的时间。
	ktime_t				idle_sleeptime;            // 记录了在空闲且Tick停止状态下，并且没有任何IO请求在等待的情况下，一共持续了多长时间。
	ktime_t				iowait_sleeptime;          // 记录了在空闲且Tick停止状态下，同时还有IO请求在等待的情况下，一共持续了多长时间。
	unsigned long			last_jiffies;          // 记录了在停止Tick前，系统jiffies的值。
	u64				timer_expires;                 // 记录了在停止Tick的情况下，下一个预期的定时器到期时间。
	u64				timer_expires_base;            // 记录了在停止Tick的情况下，定时器到期的基准时间，其实就是记录了在停止Tick的时候，上一次Tick到来的时间，也就是上一次更新系统jiffies的时间。
	u64				next_timer;                    // 系统中所有定时器中最近要到期的到期时间。
	ktime_t				idle_expires;              // 记录了在空闲且Tick停止后，下一个到期定时器的到期时间。
	atomic_t			tick_dep_mask;             // 记录了系统中还有哪些功能需要Tick，主要用于将CONFIG_NO_HZ_FULL编译选项打开的情况下。
	unsigned long			last_tick_jiffies;     // Value of jiffies seen on last tick
	unsigned int			stalled_jiffies;       // Number of stalled jiffies detected across ticks
};
```

## 工作流程
### 注册
在切换到高精度模式时，有 hrtimer_switch_to_hres => tick_setup_sched_timer ，其将 tick_cpu_sched.sched_timer 的回调函数设置为 tick_sched_timer 。

定时器hrtimer的模式为`CLOCK_MONOTONIC` 和 `HRTIMER_MODE_ABS_HARD` , 绝对时间硬中断，处理函数为`tick_sched_timer`。
```C
void tick_setup_sched_timer(void)
{
	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
	ktime_t now = ktime_get();     /* 获得当前时间 */

	/*
	 * Emulate tick processing via per-CPU hrtimers:
	 */
	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD); /* 初始化高分辨率定时器sched_timer */
	ts->sched_timer.function = tick_sched_timer;  /* 将定时器的到期函数设置成tick_sched_timer */

	/* Get the next period (per-CPU) */
	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update()); /* 设置定时器的到期时间为系统中上一次jiffy更新的时间 */

	/* Offset the tick to avert jiffies_lock contention. */
	if (sched_skew_tick) {   /* 是否需要添加偏移避免不必要的竞争 */
		u64 offset = TICK_NSEC >> 1;
		do_div(offset, num_possible_cpus());
		offset *= smp_processor_id();
		hrtimer_add_expires_ns(&ts->sched_timer, offset);  /* 添加偏移到定时器的到期时间上 */
	}

	hrtimer_forward(&ts->sched_timer, now, TICK_NSEC);  /* 更新定时器到期时间到下一个Tick到来的时间 */
	hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS_PINNED_HARD);  /* 激活定时器 */
	tick_nohz_activate(ts, NOHZ_MODE_HIGHRES);  /* 将模式设置成NOHZ_MODE_HIGHRES */
}
```

`tick_init_jiffy_update`函数用来初始化`last_jiffies_update`, 并获得上一次jiffy更新的时间, last_jiffies_update是一个全局变量，用来记录上一次jiffy更新时的时间。如果last_jiffies_update的值为0，表明还没有被初始化过，这时候就用全局变量tick_next_period对其赋值。tick_next_period是在Tick层定义的，表示下一次Tick的到期时间。
```C
static ktime_t tick_init_jiffy_update(void)
{
	ktime_t period;
 
	write_seqlock(&jiffies_lock);
	/* 是否已经被初始化过 */
	if (last_jiffies_update == 0)
		last_jiffies_update = tick_next_period;
	period = last_jiffies_update;
	write_sequnlock(&jiffies_lock);
	return period;
}
```

`hrtimer_forward`函数按照给定的当前时间和一个周期经过的时间来更新定时器的到期时间, 函数的返回值表示要添加几个周期。函数先计算出当前时间和定时器到期时间之间的差值，如果这个差值超过了一个周期，那么需要用差值除以周期时间获得差了多少个周期，然后将其加上。如果差值小于一个周期，那么就直接将到期时间加上一个周期的时间就行了。
`hrtimer_start_expire`正式激活该定时器, 该函数分别获得高分辨率定时器的“软”和“硬”到期时间，计算它们的差值，然后最终调用hrtimer_start_range_ns函数激活它。hrtimer_start_range_ns函数在高分辨率定时器层的定时器激活场景下分析过。Tick模拟层的sched_timer高分辨率定时器的“软”到期时间和“硬”到期时间是一样的。

`tick_setup_sched_timer`函数的最后调用`tick_nohz_activate`函数，试着将Tick模拟层切换到NOHZ_MODE_HIGHRES模式：

### 触发后处理
tick_sched对应timer的触发函数为`tick_sched_timer`, 在这里要更新`jiffies`，更新`wall time`，准备进行下一次的tick。

```C
static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
{
    struct tick_sched *ts = container_of(timer, struct tick_sched, sched_timer);  /* 获得包含该定时器的tick_sched结构体 */
    struct pt_regs *regs = get_irq_regs(); /* 获得指向中断上下文中所有寄存器变量的指针 */
    ktime_t now = ktime_get();  /* 获得当前时间，这个其实是上一次的tick的时间，更新这个时间需要推动wall time更新 */

    // 更新 jiffies
    tick_sched_do_timer(now);

    /*
     * Do not call, when we are not in irq context and have
     * no valid regs pointer
     */
    // 处理超时 timer
    if (regs) /* 是否在中断上下文中 */
        tick_sched_handle(ts, regs);

    /* No need to reprogram if we are in idle or full dynticks mode */
    if (unlikely(ts->tick_stopped)) /* 如果Tick被停掉了就没必要再激活该模拟Tick的定时器了 */
        return HRTIMER_NORESTART;

    // 推进一个 tick
    hrtimer_forward(timer, now, tick_period); /* 更新定时器到期时间到下一个Tick到来的时间 */

    // 重启本 hrtimer
    return HRTIMER_RESTART; /* 返回HRTIMER_RESTART表示还需要重新再次激活该定时器 */
}
```
最后，到期处理函数tick_sched_timer的返回值是HRTIMER_RESTART，表示还需要重新再次激活该定时器，剩下的对定时时间设备重新编程的工作将由高分辨率定时器层自动完成。tick_sched_timer函数基本上就是完成了原来Tick层周期处理函数tick_periodic要完成的工作。

`tick_sched_do_timer`  jiffies 也是由 tick 的处理函数来更新的，所以在这里我们也需要更新 jiffies ：
-> 负责tick的cpu，-> `tick_do_update_jiffies64` 
```C
static void tick_sched_do_timer(ktime_t now)
{
    int cpu = smp_processor_id();
    // 只有一个 CPU 能更新 jiffie
    // 如果支持 NO_HZ 特性，可能负责这个的 CPU 睡觉去了，则需要当前 CPU 承担该责任
#ifdef CONFIG_NO_HZ_COMMON
	/*
	 * Check if the do_timer duty was dropped. We don't care about
	 * concurrency: This happens only when the CPU in charge went
	 * into a long sleep. If two CPUs happen to assign themselves to
	 * this duty, then the jiffies update is still serialized by
	 * jiffies_lock.
	 *
	 * If nohz_full is enabled, this should not happen because the
	 * tick_do_timer_cpu never relinquishes.
	 */
	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)) {
#ifdef CONFIG_NO_HZ_FULL
		WARN_ON_ONCE(tick_nohz_full_running);
#endif
		tick_do_timer_cpu = cpu;
	}
#endif

    /* Check, if the jiffies need an update */
    // 如果是当前 CPU 负责更新 jiffie，则更新之
    if (tick_do_timer_cpu == cpu)
        tick_do_update_jiffies64(now);

    /*
	 * 如果jiffies更新失速，或者虚拟机vmexit导致暂停了多个ms。
	 */
	if (ts->last_tick_jiffies != jiffies) {  // jiffies很快更新了，就不相等
		ts->stalled_jiffies = 0;
		ts->last_tick_jiffies = READ_ONCE(jiffies);
	} else {                                 // 相等，就说明jiffies更新的没这么快。
		if (++ts->stalled_jiffies == MAX_STALLED_JIFFIES) { // 5次失速，就再次更新时钟
			tick_do_update_jiffies64(now);   // 失速太久
			ts->stalled_jiffies = 0;
			ts->last_tick_jiffies = READ_ONCE(jiffies);
		}
	}

    if (ts->inidle)
		ts->got_idle_tick = 1;
}
```
`tick_do_update_jiffies64` 更新jiffies64, 第一次读取`tick_next_period`判断还没有到时间就退出，第二次加了一个排他锁再次确认时间，更新jiffies。

```C
static void tick_do_update_jiffies64(ktime_t now)
{
	unsigned long ticks = 0;
	ktime_t delta;
    
    /*
	 * 64位支持smp_load_acquire，可以一次读出来tick_next_period。
     * 32位 使用锁
	 */
    // 还没有到点就tick了，不更新jiffies
	if (IS_ENABLED(CONFIG_64BIT)) {
		if (ktime_before(now, smp_load_acquire(&tick_next_period)))
			return;
	} else {
		unsigned int seq;		
		do {
			seq = read_seqcount_begin(&jiffies_seq);
			nextp = tick_next_period;
		} while (read_seqcount_retry(&jiffies_seq, seq));

		if (ktime_before(now, nextp))
			return;
	}

    /* Quick check failed, i.e. update is required. */
	raw_spin_lock(&jiffies_lock);
	/*
	 * Reevaluate with the lock held. Another CPU might have done the update already.
     * 刚才只是读取，有并发现在下一个排他锁
	 */
	if (ktime_before(now, tick_next_period)) {
		raw_spin_unlock(&jiffies_lock);
		return;
	}

	write_seqcount_begin(&jiffies_seq);
    // 这个地方有变化，使用now和tick_next_period比较
	delta = ktime_sub(now, tick_next_period);
	if (unlikely(delta >= TICK_NSEC)) {
		/* Slow path for long idle sleep times */
		s64 incr = TICK_NSEC;

		ticks += ktime_divns(delta, incr);

		last_jiffies_update = ktime_add_ns(last_jiffies_update,
						   incr * ticks);
	} else {
		last_jiffies_update = ktime_add_ns(last_jiffies_update,
						   TICK_NSEC);
	}

	/* Advance jiffies to complete the jiffies_seq protected job */
	jiffies_64 += ticks;

	/*
	 * Keep the tick_next_period variable up to date.
	 */
	nextp = ktime_add_ns(last_jiffies_update, TICK_NSEC);

	if (IS_ENABLED(CONFIG_64BIT)) {
		/*
		 * Pairs with smp_load_acquire() in the lockless quick
		 * check above and ensures that the update to jiffies_64 is
		 * not reordered vs. the store to tick_next_period, neither
		 * by the compiler nor by the CPU.
		 */
		smp_store_release(&tick_next_period, nextp);
	} else {
		/*
		 * A plain store is good enough on 32bit as the quick check
		 * above is protected by the sequence count.
		 */
		tick_next_period = nextp;
	}

	/*
	 * Release the sequence count. calc_global_load() below is not
	 * protected by it, but jiffies_lock needs to be held to prevent
	 * concurrent invocations.
	 */
	write_seqcount_end(&jiffies_seq);

	calc_global_load();

	raw_spin_unlock(&jiffies_lock);
	/* 更新墙上时间 */
	update_wall_time();
}
```
在更新完系统jiffies后，如果是在中断上下文中，tick_sched_timer函数会接着调用tick_sched_handle函数。tick_sched_handle函数主要的功能是通知（低分辨率）定时器层Tick已经到来了，可以开始处理定时器了。一旦切换到高精度模式，（低分辨率）定时器层实际是由Tick模拟层来触发的。
```C
static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
{
#ifdef CONFIG_NO_HZ_COMMON
	/* 如果当前Tick已经被停止了 */
	if (ts->tick_stopped) {
		touch_softlockup_watchdog_sched();
        /* 如果当前运行的进程是idle */
		if (is_idle_task(current))
            /* 将idle_jiffies加1算上这次的 */
			ts->idle_jiffies++;
		/* 将下一次Tick到来时间设置成0 */
		ts->next_tick = 0;
	}
#endif
    /* 通知（低分辨率）定时器层Tick已到来 */
	update_process_times(user_mode(regs));
	profile_tick(CPU_PROFILING);
}
```
### 更新