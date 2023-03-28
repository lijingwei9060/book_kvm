# tick_device

tick_device 和 clock_event_device 紧密相关。它是对 clock_event_device 进一步封装，用于代替时钟滴答中断，给内核提供 tick 事件。

# 数据结构
## 全局变量


- ktime_t tick_next_period：表示下一次Tick的到期时间
- ktime_t tick_period: 被设置成了NSEC_PER_SEC / HZ，表示一个Tick的周期是多少纳秒
- int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT(-2): 表示当前系统中由哪个CPU上的Tick设备负责更新系统jiffies。目前还没有任何CPU上的Tick设备被选为主设备更新系统jiffies，也就意味着目前还没有任何Tick设备被初始化过，因为第一个被初始化的设备肯定会被选中

## 核心结构
在 include/linux/hrtimer.h 和 kernel/time/tick-internal.h 都有以下定义：
```C
DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
```
每个 CPU 都定义了一个 tick_device 类型的 per-CPU 变量 tick_cpu_device ：tick_device 类型定义如下：
```C
struct tick_device {
    struct clock_event_device *evtdev;
    enum tick_device_mode mode;
};
```
tick_device 需要和 clock_event_device 关联起来才生效。也就是说，tick_device 的 tick 依赖于 clock_event_device 发出的 event。在使用时，往往通过 per-CPU 变量找到当前 CPU 对应的 tick_device，然后通过其 evtdev 成员找到 clock_event_device 。在注册 clock_event_device 时，会调用 tick_check_new_device ，检查 tick_device 是否应该更换 clock_event_device。  

tick device可以有两种模式，一种是周期性tick模式(TICKDEV_MODE_PERIODIC)，另外一种是one shot模式(TICKDEV_MODE_ONESHOT)。

# 设备管理

## tick_check_new_device
定时事件设备注册过程的时候，当注册上来一个新的定时事件设备的时候会调用Tick层的tick_check_new_device函数。和当前 tick_device 绑定的 clock_event_device 比较，如果新的 clock_event_device 更优，则切换到新设备，即更新 tick_device.evtdev。

该函数先调用tick_check_percpu函数和tick_check_preferred函数判断是否要用新添加的设备替换当前的定时事件设备，如果不需要的话，会调用tick_install_broadcast_device函数看是不是可以用这个设备替换当前的广播设备。如果判断都通过了，确实需要用新设备替换老设备，则先调用clockevents_exchange_device函数通知ClockEvents层要更换设备了，然后调用tick_setup_device函数真的用新注册的定时事件设备替换当前的，作为当前CPU使用的Tick设备。最后，会调用tick_oneshot_notify函数通知**TickSched**层，对应的定时事件设备已经改变。为什么只有设备是单次触发的才通知？TickSched层是高分辨率定时器（High Resolution Timer）切换到高分辨率模式后，用来模拟系统Tick的，而切换到高分辨率模式的前提条件是设备必须是单次触发的。

注意，在替换的时候，有可能并没有当前正在运行的定时事件设备，这种情况表明本CPU可能刚刚初始化，第一次设置Tick设备。
```C
void tick_check_new_device(struct clock_event_device *newdev)
{
	struct clock_event_device *curdev;
	struct tick_device *td;
	int cpu;
         
	cpu = smp_processor_id();            /* 获得当前正在运行CPU的id */  
	td = &per_cpu(tick_cpu_device, cpu); /* 获得对应CPU的Per CPU数据中存放的tick_device结构 */
	curdev = td->evtdev; 
	
	if (!tick_check_percpu(curdev, newdev, cpu)) /* 根据新老设备是否绑定到当前CPU的情况做出判断：如果当前 CPU 不在新设备的 bitmask 中 ，不能设置 irq affinity （非本地设备），不换 */
		goto out_bc; 	
	if (!tick_check_preferred(curdev, newdev))   /* 如果新设备不支持 ONESHOT，而当前设备支持已处于 ONESHOT 模式，不换；否则，检查新设备 rating 是否大于当前设备，如果是，换 */
		goto out_bc;         
	if (!try_module_get(newdev->owner))/* 对应的驱动模块存不存在 */
		return; 
	if (tick_is_broadcast_device(curdev)) { /* 如果当前设备是广播设备，需要关掉，包括更新其状态为 CLOCK_EVT_STATE_SHUTDOWN 和将下次触发时间设为 KTIME_MAX */
		clockevents_shutdown(curdev);
		curdev = NULL;
	}        
	clockevents_exchange_device(curdev, newdev);/* 通知定时事件层切换设备 */        
	tick_setup_device(td, newdev, cpu, cpumask_of(cpu));/* 用该定时事件设备设置本CPU的Tick设备，设置当前 CPU 的 tick_device.evtdev 为新设备 */        
	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)/* 通知Tick模拟层定时事件设备已经改变 */
		tick_oneshot_notify();
	return; 
out_bc:
	tick_install_broadcast_device(newdev);/* 尝试用新设备替换当前的广播设备 */
}
```
一般来说，支持 oneshot 的 clock_event_device 比只支持 periodic 的精度更高。因此我们在选择 tick_device 对应的 clock_event_device 时更偏好于支持 oneshot 的设备。在系统的启动阶段，tick_device 工作在周期触发模式的，直到在合适的时机，才会开启单触发模式，以便支持 NO_HZ 和 hrtimer 。于是 tick_setup_device 会检查 tick_device.evtdev 是否为空，如果是，表示当前 CPU 是**第一次**注册 tick_device，则需要将其设置为 TICKDEV_MODE_PERIODIC 模式（因为许多时间系统依赖于周期性的定时器中断，比如 jiffies），调用 tick_setup_periodic 初始化。如果不是，则根据 tick_device 能力进行设置，支持 oneshot 则设置为 TICKDEV_MODE_ONESHOT 模型，调用 tick_setup_oneshot 初始化。

## 替换tick设备

```C
static void tick_setup_device(struct tick_device *td, struct clock_event_device *newdev, int cpu,  const struct cpumask *cpumask)
{
	void (*handler)(struct clock_event_device *) = NULL;
	ktime_t next_event = 0;

	if (!td->evtdev) { // 如果为空，第一次配置
		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) { // 全局变量tick_do_timer_cpu还没有选择确定的cpu负责tick，选择当前cpu 进行tick
			tick_do_timer_cpu = cpu;

			tick_next_period = ktime_get();
#ifdef CONFIG_NO_HZ_FULL
			/*
			 * The boot CPU may be nohz_full, in which case set
			 * tick_do_timer_boot_cpu so the first housekeeping
			 * secondary that comes up will take do_timer from
			 * us.
			 */
			if (tick_nohz_full_cpu(cpu))
				tick_do_timer_boot_cpu = cpu;

		} else if (tick_do_timer_boot_cpu != -1 &&
						!tick_nohz_full_cpu(cpu)) {
			tick_take_do_timer_from_boot();
			tick_do_timer_boot_cpu = -1;
			WARN_ON(tick_do_timer_cpu != cpu);
#endif
		}
		td->mode = TICKDEV_MODE_PERIODIC; // 初始注册的tick设备运行在TICKDEV_MODE_PERIODIC模式下
	} else {
		handler = td->evtdev->event_handler; /* 取出原定时事件设备的event_handler回调函数和next_event到期时间 */
		next_event = td->evtdev->next_event;
		td->evtdev->event_handler = clockevents_handle_noop; /* 将原定时事件设备的回调函数设置成什么都不做 */
	}

	td->evtdev = newdev; /* 用新设备替换本Per CPU数据中tick_device的设备 */


	if (!cpumask_equal(newdev->cpumask, cpumask)) /* 如果新设备不是本CPU私有的那要将其中断绑定到当前CPU上 */
		irq_set_affinity(newdev->irq, cpumask);

	if (tick_device_uses_broadcast(newdev, cpu)) /* 向Tick广播层询问 */
		return;

	if (td->mode == TICKDEV_MODE_PERIODIC) /* 根据Tick设备的不同模式分别调用不同的设置函数 */
		tick_setup_periodic(newdev, 0);
	else
		tick_setup_oneshot(newdev, handler, next_event);
}
```





## 分类及cpu的关系
Tick device有3种分类:
- local tick device DEFINE_PER_CPU(struct tick_device, tick_cpu_device);(kernel/time/tick-common.c)在多核架构下，系统会为每一个cpu建立了一个tick device。每一个cpu就像是一个小系统一样运行在各自的tick上，实现任务调度等工作。
- global tick device int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;(kernel/time/tick-common.c)有些全局的系统任务，不适合使用local tick device，如更新jiffies、更新wall time等。这时系统会选择一个local tick device，在tick_do_timer_cpu中指明，作为global tick device负责这些全局任务。
- broadcast tick device static struct tick_device tick_broadcast_device;(kernel/time/tick-broadcast.c) 涉及cpu广播模式，当选用的global tick device因cpu休眠等原因而停止运行时，broadcast tick device就会接入global tick device的tick处理程序，代替global tick device产生定期中断。但在系统看来global tick device依旧在运作。如图5-3所示。