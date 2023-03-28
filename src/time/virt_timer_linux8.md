# nohz

## 工作原理
如果可以用动态时钟，那么下面会将tick_sched结构体的模式设置成NOHZ_MODE_HIGHRES。接着会检查全局变量tick_nohz_active的最低位，如果没有被设置过，则将其置位，然后调用timers_update_nohz函数通知（低分辨率）定时器层切换到NO_HZ模式。这样做可以保证只会通知一次。

接收到通知后，（低分辨率）定时器层会将全局变量timers_nohz_active和timers_migration_enabled都设置成真。

在动态时钟正确工作之前，系统需要切换至动态时钟模式，而要切换至动态时钟模式，需要一些前提条件，最主要的一条就是cpu的时钟事件设备必须要支持单触发模式，当条件满足时，系统切换至动态时钟模式，接着，由idle进程决定是否可以停止周期时钟，退出idle进程时则需要恢复周期时钟。


## 数据结构
### 全局变量

1. bool tick_nohz_enabled = true
2. unsigned long tick_nohz_active  

```C
idle_tick  该字段用于保存停止周期时钟是的内核时间，当退出idle时要恢复周期时钟，需要使用该时间，以保持系统中时间线（jiffies）的正确性。
tick_stopped  该字段用于表明idle状态的周期时钟已经停止。
idle_jiffies  系统进入idle时的jiffies值，用于信息统计。
idle_calls 系统进入idle的统计次数。
idle_sleeps  系统进入idle且成功停掉周期时钟的次数。
idle_active  表明目前系统是否处于idle状态中。
idle_entrytime  系统进入idle的时刻。
idle_waketime  idle状态被打断的时刻。
idle_exittime  系统退出idle的时刻。
idle_sleeptime  累计各次idle中停止周期时钟的总时间。
sleep_length  本次idle中停止周期时钟的时间。
last_jiffies  系统中最后一次周期时钟的jiffies值。
next_jiffies  预计下一次周期时钟的jiffies。
idle_expires  进入idle后，下一个最先到期的定时器时刻。
```

# 在低精度下切换动态时钟

tick_device所关联的clock_event_device的事件回调处理函数都是：`tick_handle_periodic`，不管当前是否处于idle状态，他都会精确地按HZ数来提供周期性的tick事件，这不符合动态时钟的要求，所以，要使动态时钟发挥作用，系统首先要切换至支持动态时钟的工作模式：`NOHZ_MODE_LOWRES`  。

动态时钟模式的切换过程的前半部分和切换至高精度定时器模式所经过的路径是一样的。这里再简单描述一下过程：系统工作于周期时钟模式，定期地发出tick事件中断，tick事件中断触发定时器软中断：`TIMER_SOFTIRQ`，执行软中断处理函数`run_timer_softirq`，`run_timer_softirq`调用`hrtimer_run_pending`函数：



# 在高精度下切换动态时钟

tick_setup_sched_timer函数的最后调用tick_nohz_activate函数，试着将Tick模拟层切换到NOHZ_MODE_HIGHRES模式：
```C
static inline void tick_nohz_activate(struct tick_sched *ts, int mode)
{
    /* 如果没有启用NO_HZ模式则直接退出 */
	if (!tick_nohz_enabled)
		return;
    /* 设置tick_sched结构体的模式 */
	ts->nohz_mode = mode;
	/* One update is enough */
    /* 判断或者设置全局变量tick_nohz_active的最低位 */
	if (!test_and_set_bit(0, &tick_nohz_active))
         /* 通知（低分辨率）定时器层切换到NO_HZ模式 */
		timers_update_nohz();
}
```


/*
 * Check, if a change happened, which makes oneshot possible.
 *
 * Called cyclic from the hrtimer softirq (driven by the timer
 * softirq) allow_nohz signals, that we can switch into low-res nohz
 * mode, because high resolution timers are disabled (either compile
 * or runtime). Called with interrupts disabled.
 */
int tick_check_oneshot_change(int allow_nohz)
{
	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);

	if (!test_and_clear_bit(0, &ts->check_clocks))
		return 0;

	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
		return 0;

	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
		return 0;

	if (!allow_nohz)
		return 1;

	tick_nohz_switch_to_nohz();
	return 0;
}