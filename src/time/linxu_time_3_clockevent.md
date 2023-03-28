[clock\_event](#clock_event)
- [clock\_event](#clock_event)
- [工作原理](#工作原理)
- [向下层提供管理设备](#向下层提供管理设备)
  - [注册设备：](#注册设备)
  - [卸载设备](#卸载设备)
  - [暂停设备](#暂停设备)
  - [恢复设备](#恢复设备)
  - [热拔插的CPU offline](#热拔插的cpu-offline)
- [向上层提供事件服务](#向上层提供事件服务)
  - [设定clock event device的触发event的时间参数](#设定clock-event-device的触发event的时间参数)
- [sysfs空间暴露接口](#sysfs空间暴露接口)
  - [sysfs接口初始化](#sysfs接口初始化)
  - [属性文件操作：显示current tick device](#属性文件操作显示current-tick-device)
  - [属性文件操作：unbind tick device](#属性文件操作unbind-tick-device)
- [X86有哪些时钟事件设备](#x86有哪些时钟事件设备)
  - [hpet clockevent](#hpet-clockevent)
  - [pit clockevent](#pit-clockevent)
  - [lapic\_clockevent](#lapic_clockevent)
- [数据结构](#数据结构)
  - [全局变量](#全局变量)
  - [重要数据结构](#重要数据结构)
- [设备管理](#设备管理)
  - [对eventdevice事件编程](#对eventdevice事件编程)
- [初始化](#初始化)


# clock_event

时钟源 (cloc-ksource) 只能用来查询时间，不能被编程，就好像一个手表一样，当你想查询时间时看一下，知道现在几点了。但如果你想设定一个闹钟，让它在特定的时间点提醒你，那么就需要时钟事件设备 (`clock_event_device`)。此类设备可以用来注册事件，让它们在未来的特定时间点被触发事件。和 clocksource 一样，可能会存在多种 `clock_event_device`，OS 会根据它们的精度和能力，选择合适的 `clock_event_device` 来提供时钟事件服务。

clocksource不能被编程，clock_event则是可编程的，它可以工作在周期触发或单次触发模式，系统通过clock_event确定下一次事件触发的时间，clock_event主要用于实现普通定时器和高精度定时器，同时也用于产生tick事件，供给进程调度子系统使用。多核系统内，每个CPU形成自己的一个小系统，有自己的调度、有自己的进程统计等，拥有自己的tick设备，而且是唯一的。clock event有多少硬件timer注册多少clock event device，各个cpu的tick device会选择自己适合的那个clock event设备，这个设备称为`clock_event_device`。

# 工作原理
工作内容：
1. 向下层提供管理设备：
   1. 设备配置： `clockevents_config`
   2. 注册设备：`clockevents_register_device`, `clockevents_config_and_register`
2. 向上层提供事件服务： 
   1. 设定clock event device的触发event的时间参数： `clockevents_program_event`
   2. tick层切换设备： `clockevents_exchange_device`
3. sysfs空间暴露接口
   1. sysfs接口初始化
   2. 属性文件操作：显示current tick device
   3. 属性文件操作：unbind tick device

# 向下层提供管理设备
```C
static LIST_HEAD(clockevent_devices);
static LIST_HEAD(clockevents_released);
```
clock event device core模块使用两个链表来管理系统中的clock event device，一个是`clockevent_devices`链表，该链表中的clock event device都是当前active的device。active的clock device有两种情况，一种是cpu core的current  clockevent device，这些device是各个cpu上产生tick的那个clock event device。还有一些active的device由于优先级比较低，当前没有使用，不过可以作为backup的device。比较典型的就是broadcast的时钟事件设备。另外一个是`clockevents_released`链表，这个链表中clock event device都是由于种种原因，无法进入active list，从而挂入了该队列。

## 注册设备：
- 注册的函数是`clockevents_config_and_register`或`clockevents_register_device`，调用基本在设备驱动层调用。前者和后者的区别是，前者先调用`clockevents_config` 然后接着调用后者。所以前者是负责了mult和shift设置。
- 函数`clockevents_config`主要用来设置对应的mult和shift的值：
- `clockevents_register_device`注册设备到`clockevent_devices` 。
  1.  初始化状态为`CLOCK_EVT_STATE_DETACHED`
  2.  配置cpumask
  3.  list_add 到 `clockevent_devices`
  4.  调用tick层对下接口`tick_check_new_device`
  5.  调用`clockevents_notify_released`
- `tick_check_new_device`： tick设备层提供的函数，如果有新的定时事件设备加入内核，则可以将新加的这个设备和原有的设备进行比较，看哪个更适合作为tick设备层的驱动设备。如果新设备更时候的话，tick设备层会调用前面分析的`clockevents_exchange_device`函数。
  - `clockevents_exchange_device`: 切换设备
- `clockevents_notify_released`： 会遍历前一步添加到`clockevents_released`全局链表中的所有设备（在注册的过程中实际只会添加一个，也就是被替换的设备），将其从`clockevents_released`中删除并重新添加回`clockevent_devices`全局链表中，再检查一下这个设备是否是更好的tick设备（在这个场景中，被替换的设备肯定不如替换的新设备，所以其实这个调用应该不起作用）

## 卸载设备
clockevents_unbind_device(struct clock_event_device *ced, int cpu)
ret = clockevents_unbind(ced, cpu);
    smp_call_function_single(cpu, __clockevents_unbind, &cu, 1);
        res = __clockevents_try_unbind(cu->ce, smp_processor_id()); // 如果状态位detached直接删除
        res = clockevents_replace(cu->ce)
            寻找合适的newdev： 
                detached不要；
                cpumask不包含这颗cpu不要，irq亲和性不能设置不要；
                tick_check_preferred： current支持oneshot或者已经启用了oneshot，这个设备不支持，不要；本地设备并且rating高
            tick_install_replacement(newdev);
                clockevents_exchange_device(td->evtdev, newdev); //关闭旧的，放入list列表，关闭新的等待初始化
	        tick_setup_device(td, newdev, cpu, cpumask_of(cpu));
	        if (newdev->features & CLOCK_EVT_FEAT_ONESHOT) tick_oneshot_notify();
            list_del_init(&ced->list);

## 暂停设备
目前只有tk层通过`timekeeping_suspend`调用：
```C
void clockevents_suspend(void)
{
	struct clock_event_device *dev;

	list_for_each_entry_reverse(dev, &clockevent_devices, list)
		if (dev->suspend && !clockevent_state_detached(dev))
			dev->suspend(dev);
}
```

## 恢复设备
目前只有tk层通过`timekeeping_resume`调用：
```C
void clockevents_resume(void)
{
	struct clock_event_device *dev;

	list_for_each_entry(dev, &clockevent_devices, list)
		if (dev->resume && !clockevent_state_detached(dev))
			dev->resume(dev);
}
```
## 热拔插的CPU offline
把CPU从广播队中去掉
```C
void tick_offline_cpu(unsigned int cpu)
|-> tick_broadcast_offline(cpu);
    |-> cpumask_clear_cpu(cpu, tick_broadcast_mask);
	|-> cpumask_clear_cpu(cpu, tick_broadcast_on);
	|-> tick_broadcast_oneshot_offline(cpu); // Remove a dying CPU from broadcasting
        |-> tick_set_oneshot_wakeup_device(newdev, cpu) // 设置cpu对应的唤醒 `tick_oneshot_wakeup_device`, 如果newdev为NULL表示清除
        |-> cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask); // 将该CPU从mask清除
        |-> cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
        |-> cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
	|-> tick_shutdown_broadcast();
        |-> clockevents_shutdown(bc) 


```

# 向上层提供事件服务
## 设定clock event device的触发event的时间参数
当定时事件设备的状态有变化时，比如频率变动了，或者当定时到期且需要设置下一次定时事件的时候，都有可能会对定时事件设备重新进行编程。如果频率变化了，那同样的纳秒数转换成的周期数就肯定会改变，当然需要重新计算编程。而定时事件到期后，且定时事件设备是单触发模式的，如果不对其再编程，那这个设备将不会再产生任何定时中断。
谁调用：
- clockevents_update_freq
- hotplug_cpu__broadcast_tick_pull
- tick_handle_periodic_broadcast： 周期性广播tick
- tick_oneshot_wakeup_control
- tick_handle_periodic
- tick_setup_periodic
- tick_program_event
- tick_resume_oneshot
- tick_setup_oneshot

对定时事件设备重编程是在函数`clockevents_program_event`中完成的：
1. expires表示要设定的下一次到期时间，absolute expiry time (monotonic clock)；
2. 调用设备的关闭方法，先关闭，确认设备在oneshot模式。
3. 如果该设备支持`CLOCK_EVT_FEAT_KTIME`(表示该设备只支持以ktime绝对时间定时，只能调用`set_next_ktime`函数),直接调用该设备的`set_next_ktime`。
4. 计算当前时间(ktime)到过期时间的delta，确保delta在最大和最小间隔之间。
5. 将delta转换成cycle，cycle = delta * mult >> shift。
6. force表示如果这个定时事件设置出了问题，是不是需要尝试用最小的时间间隔设定该设备。可以看到，如果当前时间已经超过了要设定的到期时间，或者在调用set_next_event出错时，且force是真的情况下，还会尝试调用`clockevents_program_min_delta`设置一个最小的到期事件，否则直接返回错误。`clockevents_program_min_delta`共尝试10次设置下一次到期事件，每次将间隔递增`min_delta_ns`，直到成功为止。如果10次都不成功，则返回错误码退出。设备结构体中的retries变量在这里记录尝试了多少次。
7. 如果配置了`CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST `, force为true同时最小delta设置不成功，3次后`clockevents_program_min_delta`会认为这个delta设置过小，会尝试调用`clockevents_increase_min_delta`修改设备的最小delta。最小delta的上限为 `MIN_DELTA_LIMIT`	= `NSEC_PER_SEC / HZ`, 最小为5000ns(固定)，每次增长自身的二分之一。这样循环，直到成功或者超过delta的上限失败。
```C
int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,  bool force)
{
	unsigned long long clc;
	int64_t delta;
	int rc;

	if (WARN_ON_ONCE(expires < 0))
		return -ETIME;

	dev->next_event = expires; /* 储存下一次定时到期时间 */

	if (clockevent_state_shutdown(dev))  /* 先关闭该设备 */
		return 0;

	/* We must be in ONESHOT state here */
	WARN_ONCE(!clockevent_state_oneshot(dev), "Current state: %d\n", clockevent_get_state(dev));

	/* Shortcut for clockevent devices that can deal with ktime. */
	if (dev->features & CLOCK_EVT_FEAT_KTIME) return dev->set_next_ktime(expires, dev);

	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
	if (delta <= 0) return force ? clockevents_program_min_delta(dev) : -ETIME;

	delta = min(delta, (int64_t) dev->max_delta_ns);
	delta = max(delta, (int64_t) dev->min_delta_ns);

	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
	rc = dev->set_next_event((unsigned long) clc, dev);

	return (rc && force) ? clockevents_program_min_delta(dev) : rc; // 如果失败了，并且设置强制，再来10次
}
```

# sysfs空间暴露接口

## sysfs接口初始化
定时事件设备会在sysfs中注册对应的文件，可以通过访问这些文件的内容知道当前系统中关于定时事件设备的基本信息。注册sysfs是在`clockevents_init_sysfs`函数中完成的：
```C
static int __init clockevents_init_sysfs(void)
{
    /* 注册子系统 */
    int err = subsys_system_register(&clockevents_subsys, NULL);
    if (!err) err = tick_init_sysfs();
    return err;
}
device_initcall(clockevents_init_sysfs);
```
`subsys_system_register`函数会根据参数将一个子系统注册在`/sys/devices/system/`目录下。注册信息保存在`clockevents_subsys`静态全局变量中：
```C
static struct bus_type clockevents_subsys = {
	.name		= "clockevents",
	.dev_name       = "clockevent",
};
```
所以总线名字叫做`clockevents`，而设备名字叫做`clockevent`。

注册完子系统后，如果没问题，会接着调用`tick_init_sysfs`函数：
```C
static int __init tick_init_sysfs(void)
{
	int cpu;
 
        /* 遍历系统中的每个CPU */
	for_each_possible_cpu(cpu) {
                /* 读取每CPU变量tick_percpu_dev */
		struct device *dev = &per_cpu(tick_percpu_dev, cpu);
		int err;
 
                /* 填写要注册的设备信息 */
		dev->id = cpu;
		dev->bus = &clockevents_subsys;
                /* 注册设备 */
		err = device_register(dev);
		if (!err)
                        /* 在设备目录下创建current_device文件 */
			err = device_create_file(dev, &dev_attr_current_device);
		if (!err)
                        /* 在设备目录下创建unbind_device文件 */
			err = device_create_file(dev, &dev_attr_unbind_device);
		if (err)
			return err;
	}
	return tick_broadcast_init_sysfs();
}
```
经过这些函数的注册后，将会在`/sys/devices/system/clockevents`/目录下创建多个目录，系统中有几个CPU（包含超线程）就会创建几个目录，例如笔者的笔记本是4核8线程的，就会创建clockevent0到clockevent7，共8个目录。每个目录下会创建两个文件，分别是`current_device`和`unbind_device`。以`current_device`为例。
## 属性文件操作：显示current tick device
其文件属性定义为：
```C
static ssize_t sysfs_show_current_tick_dev(struct device *dev, struct device_attribute *attr, char *buf)
{
	struct tick_device *td;
	ssize_t count = 0; 
        /* 获得自旋锁并关闭本地中断 */
	raw_spin_lock_irq(&clockevents_lock);
        /* 获得当前tick设备所使用的定时事件设备 */
	td = tick_get_tick_dev(dev);
	if (td && td->evtdev)
                /* 输出定时事件设备的名字 */
		count = snprintf(buf, PAGE_SIZE, "%s\n", td->evtdev->name);
        /* 释放自旋锁并打开本地中断 */
	raw_spin_unlock_irq(&clockevents_lock);
	return count;
}
/* 申明了dev_attr_current_device全局变量 */
static DEVICE_ATTR(current_device, 0444, sysfs_show_current_tick_dev, NULL);
```
所以，访问了对应目录下的current_device文件，其内容将是对应CPU所使用的定时事件设备的名字。
## 属性文件操作：unbind tick device
一个tick device总是绑定一个属于该cpu core并且精度最高的那个clock event device。通过sysfs的接口可以解除这个绑定。如果解除绑定的那个clock event device是unused，可以直接从clockevent_devices全局链表中删除。如果该设备当前使用中，那么需要找到一个替代的clock event device。如果找不到一个替代的clock event device，那么不能unbind当前的device，返回EBUSY。具体的代码逻辑就不分析，大家可以自己阅读代码理解。

```C
static ssize_t unbind_device_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
{
	char name[CS_NAME_LEN];
	ssize_t ret = sysfs_get_uname(buf, name, count);
	struct clock_event_device *ce = NULL, *iter;

	if (ret < 0)
		return ret;

	ret = -ENODEV;
	mutex_lock(&clockevents_mutex);
	raw_spin_lock_irq(&clockevents_lock);
	list_for_each_entry(iter, &clockevent_devices, list) {
		if (!strcmp(iter->name, name)) {
			ret = __clockevents_try_unbind(iter, dev->id);
			ce = iter;
			break;
		}
	}
	raw_spin_unlock_irq(&clockevents_lock);
	/*
	 * We hold clockevents_mutex, so ce can't go away
	 */
	if (ret == -EAGAIN)
		ret = clockevents_unbind(ce, dev->id);
	mutex_unlock(&clockevents_mutex);
	return ret ? ret : count;
}
```

例如，在64位树莓派4系统下，访问/sys/devices/system/clockevents/clockevent3/current_device将会返回arch_sys_timer，表明其当前使用的是Arm通用计时器。

# X86有哪些时钟事件设备
- hpet
- pit
- lapic


## hpet clockevent
HPET是由微软和英特尔联合开发的定时器芯片，用以取代PIT提供高精度的时钟中断（10MHz以上），所以精度在100ns。一个HPET芯片包含了8个32位或64位的独立计数器，每个计数器由自己的时钟信号驱动，每个计时器又包含了一个比较器和一个寄存器（保存一个数值，表示触发中断的时机）。每一个比较器都比较计数器中的数值和寄存器的数值，相等就会产生中断。


```C
static void hpet_init_clockevent(struct hpet_channel *hc, unsigned int rating)
```
## pit clockevent

```C
/*
 * On UP the PIT can serve all of the possible timer functions. On SMP systems
 * it can be solely used for the global tick.
 */
struct clock_event_device i8253_clockevent = {
	.name			= "pit",
	.features		= CLOCK_EVT_FEAT_PERIODIC,
	.set_state_shutdown	= pit_shutdown,
	.set_state_periodic	= pit_set_periodic,
	.set_next_event		= pit_next_event,
};
/*
 * Initialize the conversion factor and the min/max deltas of the clock event
 * structure and register the clock event source with the framework.
 */
void __init clockevent_i8253_init(bool oneshot)
{
	if (oneshot) {
		i8253_clockevent.features |= CLOCK_EVT_FEAT_ONESHOT;
		i8253_clockevent.set_state_oneshot = pit_set_oneshot;
	}
	/*
	 * Start pit with the boot cpu mask. x86 might make it global
	 * when it is used as broadcast device later.
	 */
	i8253_clockevent.cpumask = cpumask_of(smp_processor_id());

	clockevents_config_and_register(&i8253_clockevent, PIT_TICK_RATE,
					0xF, 0x7FFF);
}
```

## lapic_clockevent
`lapic_clockevent` 是local apic timer的功能，每个cpu core都有一个lapic所以每个core对应一个timer， 提供4个寄存器，3种工作模式。apic timer支持3种工作模式， oneshot、Periodic（01b）和TSC-Deadline Mode（10b），最后一种模式需要CPU支持。tick的频率根据外频(bus/external frequency) / (Divide Configuration Register)。
Periodic mode很省事，不需要频繁写寄存器，但不符合linux的需求，NO_HZ_IDLE和NO_HZ_FULL都会动态调整下次tick的时间；One-shot和TSC-Deadline有点像，One-shot 通过MMIO给 initial-count register写一个相对时间，比如10ms那就是10ms后来个中断，TSC-Deadline通过给IA32_TSC_DEADLINE MSR写一个tsc的绝对时间，cpu的tsc值到了这个绝对值就来个中断，比One-shot好控制。cpu HZ高点，10ms干的活多，cpu HZ低点10ms干的活少，TSC-Deadline设置一个值 ，HZ高点，那么tsc涨得快，HZ低点tsc涨得慢，两次中断之间cpu干的活是固定的，所以最终linux选择了TSC-Deadline mode。

```C
static struct clock_event_device lapic_clockevent = {
    .name           ="lapic",
    .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
    .shift          = 32,
    .set_state_shutdown = lapic_timer_shutdown,
    .set_state_periodic = lapic_timer_set_periodic,
    .set_state_oneshot  = lapic_timer_set_oneshot,
    .set_next_event     = lapic_next_event,
    .broadcast      = lapic_timer_broadcast,
    .rating         = 100,
    .irq            = -1,
};
```

```C
/*
 * Setup the local APIC timer for this CPU. Copy the initialized values
 * of the boot CPU and register the clock event in the framework.
 */
static void setup_APIC_timer(void)
{
	struct clock_event_device *levt = this_cpu_ptr(&lapic_events);

	if (this_cpu_has(X86_FEATURE_ARAT)) {
		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
		/* Make LAPIC timer preferable over percpu HPET */
		lapic_clockevent.rating = 150;
	}

	memcpy(levt, &lapic_clockevent, sizeof(*levt));
	levt->cpumask = cpumask_of(smp_processor_id());

	if (this_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER)) {
		levt->name = "lapic-deadline";
		levt->features &= ~(CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_DUMMY); //DUMMY标志在BSP初始化时将会被清除
		levt->set_next_event = lapic_next_deadline;
		clockevents_config_and_register(levt, tsc_khz * (1000 / TSC_DIVISOR), 0xF, ~0UL);
	} else
		clockevents_register_device(levt);
}
```
对于 APIC timer 来说，在

start_kernel => rest_init => kernel_thread(kernel_init) => kernel_init_freeable => smp_prepare_cpus(setup_max_cpus) => smp_ops.smp_prepare_cpus => native_smp_prepare_cpus => apic_bsp_setup => x86_init.timers.setup_percpu_clockev (setup_boot_APIC_clock) => setup_APIC_timer

时会调用 clockevents_register_device 注册 APIC timer。在注册 clock_event_device 会和当前 tick_device 绑定的 clock_event_device 比较，如果它更优，则换绑。
```C
void clockevents_register_device(struct clock_event_device *dev)
{
    unsigned long flags;

    /* Initialize state to DETACHED */
    // 设置设备状态
    clockevent_set_state(dev, CLOCK_EVT_STATE_DETACHED);

    // 如果未指配所属 CPU，设置为当前 CPU
    if (!dev->cpumask) {WARN_ON(num_possible_cpus() > 1);
        dev->cpumask = cpumask_of(smp_processor_id());
    }
    // 关闭抢占，加锁
    raw_spin_lock_irqsave(&clockevents_lock, flags);
    // 加入到 clockevent_devices 链表中
    list_add(&dev->list, &clockevent_devices);
    // 和 tick_device 当前的绑定的 clock_event_device 比较，如果新设备更优，则切换到新设备
    tick_check_new_device(dev);
    // 清除 clockevents_released 上的 clockevent 设备，转移到 clockevent_devices
    clockevents_notify_released();

    raw_spin_unlock_irqrestore(&clockevents_lock, flags);
}
```

# 数据结构
## 全局变量
除核心的结构体外，clock_event同时还有两个相关的全局变量：
- static LIST_HEAD(clockevent_devices): 定义在在kernel/time/clockevents.c，系统内所有注册的clock_event_device都会挂载到该链表
- static LIST_HEAD(clockevents_released)：定义在在kernel/time/clockevents.c，被移除的clock_event_device都会挂载到该链表
- clockevents_chain: 系统中的clock_event设备的状态发生变化时，利用该通知链通知系统的其它模块。(可能不存在了)

## 重要数据结构
```C
struct clock_event_device {
    void            (*event_handler)(struct clock_event_device *);                  // 当定时器触发条件满足后，会发送中断给处理器，对应的中断处理程序在执行的时候会调用这个函数。
    int         (*set_next_event)(unsigned long evt, struct clock_event_device *);  // 设置下一次触发的时间，用经过了多少个时钟源的周期数作为参数。
    int         (*set_next_ktime)(ktime_t expires, struct clock_event_device *);    // 同样是设置下一次触发的时间，直接使用ktime时间作为参数
    ktime_t         next_event;                                                     // 该定时事件设备的下一次到期绝对时间，用ktime表示
    u64         max_delta_ns;                                                       // 表示当前定时事件设备能分辨的最大定时时间间隔，以纳秒数表示, 可设置的最大时间差
    u64         min_delta_ns;                                                       // 可设置的最小时间差
    u32         mult;                                                               // 用于 cycle 和 ns 的转换
    u32         shift;
    enum clock_event_state  state_use_accessors;
    unsigned int        features;
    unsigned long       retries;

    int         (*set_state_periodic)(struct clock_event_device *);                 // 状态转换的回调函数
    int         (*set_state_oneshot)(struct clock_event_device *);
    int         (*set_state_oneshot_stopped)(struct clock_event_device *);
    int         (*set_state_shutdown)(struct clock_event_device *);
    int         (*tick_resume)(struct clock_event_device *);

    void            (*broadcast)(const struct cpumask *mask);
    void            (*suspend)(struct clock_event_device *);
    void            (*resume)(struct clock_event_device *);
    unsigned long       min_delta_ticks;
    unsigned long       max_delta_ticks;

    const char      *name;
    int         rating;                                                             // 优先级
    int         irq;
    int         bound_on;
    const struct cpumask    *cpumask;
    struct list_head    list;                                                       // 用来加入到 clockevent_devices 链表
    struct module       *owner;
} ____cacheline_aligned;
```
clock_event_device是clock_event的核心数据结构，比较重要部分：

- event_handler 一个回调函数指针，通常由通用框架层设置，在时间中断到来时，硬件的中断服务程序会调用该回调，实现对时钟事件的处理。
- set_next_event 设置下一次时间触发的时间，使用离现在的cycle差值作为参数。
- set_next_ktime 设置下一次时间触发的时间，直接使用ktime时间作为参数。
- max_delta_ns 表示当前定时事件设备能分辨的最大定时时间间隔，以纳秒数表示。系统中的时钟源计数器一般都有一个最大计数值，超过这个值后就会回滚了，这也就是单次定时能设定的最大时间间隔。假如系统时钟源计数超过10分钟就会越界回滚，如果定时在10分钟内，那没关系，即使会越界系统回滚后也可以正确定时。而如果定时超过10分钟，那系统就无法区分到底是越界之前的值是对了还是越界之后的值是对的。所以，超过这个定时间隔系统一定会出错。这个值可以和max_delta_ticks通过mult和shift互相转换。
- min_delta_ns 可设置的最小时间差，单位是纳秒。表示当前定时事件设备能分辨的最小定时时间间隔，以纳秒数表示。系统中的时钟源一般都有一个最小分辨率，如果时钟源以10MHz运行，那么其最小的定时时间间隔肯定要大于100纳秒，小于这个定时间隔在这个系统上是无法实现的。这个值可以和min_delta_ticks通过mult和shift互相转换。
- mult shift 与clocksource中的类似，只不过是用于把纳秒转换为cycle。统中都会有一个时钟源（Clock Source），有的系统会将其称作计数器，它会按照一个固定的频率周期工作，不停的累加。注意区分时钟源和本文说的定时器，时钟源只是自顾自的累加，频率很高，让系统“感知”时间的流逝，它不会触发中断，计数器的值是CPU自己主动读取的；而定时器是会触发中断的，而且其定时间隔肯定比时钟源的周期间隔要大。内核可以通过不同渠道知道时钟源的频率（Frequency），也可以通过比较现在的时钟计数器数值和上一次时钟计数器数值获得已经过去了多少个周期（Cycle），有了这两个参数就可以知道过去了多少秒了（Cycle / Frequency）。但是，内核是没有浮点运算单元的，因此，只能通过整数运算进行模拟。mult表示乘数，shift表示位移多少位。这样，拿到了计数器的值后，先用shift左移位，然后再整数除以mult之后，就可以算出过了多少纳秒（(Cycle << shift) / mult）。这两个值是需要精心计算了，如果太大了会造成溢出，如果太小了，会造成精度不够。关于如何计算这两个值，以及如何将周期数转换成纳秒数在后面章节中有介绍。
- rating 表示该设备的精度等级。
- list 系统中注册的时钟事件设备用该字段挂在全局链表变量clockevent_devices上。
- state_use_accessors：表示当前定时事件设备所处的状态，是一个枚举变量，一共有五种。代码位于include/linux/clockchips.h
  - CLOCK_EVT_STATE_DETACHED，表示这个设备目前没有被内核事件子系统使用，也是设备的初始状态；
  - CLOCK_EVT_STATE_SHUTDOWN，表示该设备已经被关闭了；
  - CLOCK_EVT_STATE_PERIODIC，表示这个设备一旦设置完成后就可以产生周期性事件，一般都是低精度的设备；
  - CLOCK_EVT_STATE_ONESHOT，表示该设备只能产生单次触发的时钟事件，一般都是高精度设备；
  - CLOCK_EVT_STATE_ONESHOT_STOPPED，表示该设备是单次触发设备，但是已经被停止了。
- features：表示这个定时事件设备支持的功能特性。例如，如果是周期设备那就要包含CLOCK_EVT_FEAT_PERIODIC。不像前面说的clock_event_state是排它的，这个字段是按位与的，可以包含多个。但有些也是互斥的，比如CLOCK_EVT_FEAT_PERIODIC（表示该设备可以支持周期触发）和CLOCK_EVT_FEAT_ONESHOT（表示该设备只支持单次触发）一般不会在一起出现。
  - CLOCK_EVT_FEAT_ONESHOT表示该设备只支持单次触发
  - CLOCK_EVT_FEAT_PERIODIC表示该设备可以支持周期触发
  - CLOCK_EVT_FEAT_KTIME表示该设备只支持以ktime绝对时间定时，只能调用set_next_ktime函数。
  - CLOCK_EVT_FEAT_C3STOP表示该定时事件设备支持C3_STOP工作模式，在对应的CPU进入空闲状态后，有可能会被关闭。
  - CLOCK_EVT_FEAT_PERCPU表示该定时事件设备是某个CPU私有的。
  - CLOCK_EVT_FEAT_DYNIRQ表示该定时事件设备可以设定CPU亲缘性，也就是可以指定到期后触发某个特定CPU的中断。
  - CLOCK_EVT_FEAT_DUMMY表示这个定时事件设备是一个“假”的占位设备。
  - CLOCK_EVT_FEAT_HRTIMER表示该定时事件设备实际上是有高分辨率定时器模拟出来的。
- retries：重试次数（在clockevents_program_min_delta函数中使用）。
- set_state_periodic：当定时事件设备将要被切换到周期触发状态（也就是CLOCK_EVT_STATE_PERIODIC）时，时间子系统会调用这个函数。
- set_state_oneshot：当定时事件设备将要被切换到单次触发状态（也就是CLOCK_EVT_STATE_ONESHOT）时，时间子系统会调用这个函数。
- set_state_oneshot_stopped：当定时事件设备将要被切换到单次触发停止状态（也就是CLOCK_EVT_STATE_ONESHOT_STOPPED）时，时间子系统会调用这个函数。
- set_state_shutdown：当定时事件设备将要被切换到关闭状态（也就是CLOCK_EVT_STATE_SHUTDOWN）时，时间子系统会调用这个函数。
- tick_resume：当一个tick设备恢复的时候，会调用对应的定时事件设备的该函数。
- broadcast：发送广播事件的函数。
- suspend：当要暂停定时事件设备时，会调用对应设备的该函数。
- resume：当要恢复定时事件设备时，会调用对应设备的该函数。
- min_delta_ticks：表示当前定时事件设备能分辨的最小定时时间间隔，以时钟源设备的周期数表示，肯定是一个大于1的值。
- max_delta_ticks：表示当前定时事件设备能分辨的最大定时时间间隔，以时钟源设备的周期数表示，肯定不能大于时钟源设备的最大计数器值。
- name：是给这个定时事件设备起的一个名字，一般比较直观，在/proc/timer_list中或者dmesg中都会出现。
- rating：代表这个定时事件设备的精度值，其取值范围从1到499，数字越大代表设备的精度越高。当系统中同时有多个定时事件设备存在的时候，内核可以根据这个值选一个最佳的设备。
- irq：指定了该定时事件设备使用的中断号。
- bound_on：绑定的CPU，主要在Tick广播层使用。
- cpumask：指定了这个定时事件设备所服务的CPU号，系统中高精度定时事件设备一般都是每个CPU核私有的。
- list：系统中所有的定时事件设备实例都会保存在全局链表clockevent_devices中，这个变量作为链表的元素（代码位于kernel/time/clockevents.c）。`static LIST_HEAD(clockevent_devices);`
- owner：拥有这个定时事件设备的模块。




# 设备管理


## 对eventdevice事件编程





# 初始化