# 定时器(低精度时钟)
定时器基于tick工作，根据jiffies进行触发(1ms)，精度相对比较低。利用定时器，我们可以设定在未来的某一时刻，触发一个特定的事件。经常，也会把这种低精度定时器称作时间轮（Timer Wheel）。

# 数据结构
## 全局变量

## 核心数据结构

- timer_list: 表示一个低精度时钟
- timer_base: 表示一组时钟，包含`WHEEL_SIZE` 个链表，也就是著名的时间轮链表。

### timer 的结构是 `timer_list`，这不是一个列表吗？
```C
struct timer_list {
    struct hlist_node   entry;                          // 链表节点，用于加入到链表
    unsigned long       expires;                        // 定时器超时时间
    void            (*function)(unsigned long);         // 超时时的回调函数
    unsigned long       data;                           // 调用 function 时的参数
    u32         flags;
#ifdef CONFIG_TIMER_STATS
    int         start_pid;
    void            *start_site;
    char            start_comm[16];
#endif
#ifdef CONFIG_LOCKDEP
    struct lockdep_map  lockdep_map;
#endif
};
```
- entry：所有的定时器都会根据到期的时间被分配到`一组链表中`的一个中，该字段是链表的节点成员。
- expires：字段指出了该定时器的到期时刻，也就是期望定时器到期时刻的jiffies计数值。这是一个绝对值，不是距离当前时刻再过多少jiffies。
- function：是一个回调函数指针，定时器到期时，系统将会调用该函数，用于响应该定时器的到期事件。
- flags：看名字应该是标志位，其定义如下, 其最高10位记录了定时器放置到桶的编号，后面会提到一共最多只有576个桶，所以10位足够了。而最低的18位指示了该定时器绑定到了哪个CPU上，注意是一个数值，而不是位图。夹在中间的一些位到真的是一些标志位。
```C
#define TIMER_CPUMASK		0x0003FFFF  // 最低的18位指示了该定时器绑定到了哪个CPU上
#define TIMER_MIGRATING		0x00040000  // 表示定时器正在从一个CPU迁移到另外一个CPU
#define TIMER_BASEMASK		(TIMER_CPUMASK | TIMER_MIGRATING)
#define TIMER_DEFERRABLE	0x00080000  // 表示该定时器是可延迟的
#define TIMER_PINNED		0x00100000  // 表示定时器已经绑死了当前的CPU, 不可迁移
#define TIMER_IRQSAFE		0x00200000  // 表示定时器是中断安全的，使用的时候只需要加锁，不需要关中断
#define TIMER_ARRAYSHIFT	22
#define TIMER_ARRAYMASK		0xFFC00000 // 最高10位记录了定时器放置到桶的编号
```
### timer_base: 一组时钟

在现代的 OS 中，可能同时激活了几百个甚至几千个 timer，为了对它们进行有效的管理，Linux 使用了 分 `CPU + 类别(是否支持延迟) + 分层时间轮` 的分组方案：
- 在多核架构下同时存在多个运行的 CPU，为了避免打架，每个 CPU 各自维护自己的 timer 。于是定义了 per-cpu 变量 timer_bases 。
- timer_bases 是一个 timer_base 的数组，长度为NR_BASES，原因在于有不同的 timer 类别：如果支持 NO_HZ，会分为 BASE_STD 和 BASE_DEF 两个 timer_base 分别维护普通的 timer 和 NOHZ 的 timer。NR_BASES在NO_HZ模式下为2，也就是BASE_STD=0 BASE_DEF =1，否则为1， BASE_STD=0 BASE_DEF =0。
  - BASE_STD表示这是标准的定时器，无论如何都会存在的。
  - BASE_DEF表示定时器可以延迟触发，也就是timer_list的flags包含`TIMER_DEFERRABLE`, 用于支撑`NO_HZ`模式下对于降低功耗的CPU，延迟触发上面的时钟。
- 时间轮呢

真正管理timer列表的是 `timer_base` 结构：
```C
struct timer_base { 
	raw_spinlock_t		lock;                // 自旋锁同时保护包含timer_base和vectors链表数组中的timer_list
	struct timer_list	*running_timer;      // 当前CPU正在处理的 timer_list
#ifdef CONFIG_PREEMPT_RT
	spinlock_t		expiry_lock;
	atomic_t		timer_waiters;
#endif
	unsigned long		clk;                 // 当前定时器所经过的 jiffies，用来判断 timer_list 是否超时
	unsigned long		next_expiry;         // 最早 (距离超时最近的 timer) 的超时时间
	unsigned int		cpu;                 // 该 timer 所属 CPU
    bool			next_expiry_recalc;
	bool			is_idle;                 // 是否空闲，NO_HZ模式下会用到
	bool			timers_pending;
	DECLARE_BITMAP(pending_map, WHEEL_SIZE); // 如果某个链表中有 timer，则对应的 bit 被置为 1
	struct hlist_head	vectors[WHEEL_SIZE]; // 维护了所有链表
} ____cacheline_aligned;
```
- lock：保护该timer_base结构体的自旋锁，这个自旋锁还同时保护包含在vectors链表数组中的所有定时器。
- running_timer：该字段指向当前CPU正在处理的定时器所对应的timer_list结构。
- clk：当前定时器所经过的 jiffies，用来判断包含的定时器是否已经到期或超时。
- next_expiry：该字段指向该CPU下一个即将到期的定时器。最早 (距离超时最近的 timer) 的超时时间
- cpu：所属的CPU号。
- is_idle：指示是否处于空闲模式下，在NO_HZ模式下会用到。
- must_forward_clk：指示是否需要更新当前clk的值，在NO_HZ模式下会用到。
- pending_map：一个比特位图，时间轮中有几个桶就有几个比特位。如果某个桶内有定时器存在，那么就将相应的比特位置1。
- vectors：时间轮所有桶的数组，每一个元素是一个链表。

### 时间轮
timer_base包含了很多的timer_list, 根据时钟到期时间按照粒度分了`LVL_DEPTH` 个级别，每个级别的检查间隔是不一样的。
- 在 CONFIG_HZ 大于 100 的情况下LVL_DEPTH 为 9，也就是一个 timer_base 维护了 9 个 level。低于100则LVL_DEPTH 为8。
- 每个 level 可维护 LVL_SIZE(2^6=64) 个链表，在LVL_DEPTH 为 9的情况下，最多有576个链表。
- 每个 level 的粒度 (HZ所代表的tick周期时间) << 3*level, 例如CONFIG_HZ 为 1000，则一个tick为1ms。
- 每个 level 下的链表下的timer_list是按照顺序插入的吗？

以 CONFIG_HZ 为 1000 时的情况为例，一个tick为1ms。
```txt
 * HZ 1000 steps
 * Level Offset  Granularity            Range
 *  0      0         1 ms                0 ms -         63 ms
 *  1     64         8 ms               64 ms -        511 ms
 *  2    128        64 ms              512 ms -       4095 ms (512ms - ~4s)
 *  3    192       512 ms             4096 ms -      32767 ms (~4s - ~32s)
 *  4    256      4096 ms (~4s)      32768 ms -     262143 ms (~32s - ~4m)
 *  5    320     32768 ms (~32s)    262144 ms -    2097151 ms (~4m - ~34m)
 *  6    384    262144 ms (~4m)    2097152 ms -   16777215 ms (~34m - ~4h)
 *  7    448   2097152 ms (~34m)  16777216 ms -  134217727 ms (~4h - ~1d)
 *  8    512  16777216 ms (~4h)  134217728 ms - 1073741822 ms (~1d - ~12d)
 ```
这有点历史故事。
> 看到这里，是不是会产生黑人问号了？这和教科书上说的时间轮实现好像不一样啊？

> 是的，在 2015 年，Thomas Gleixne 提交了一个 patch，参考 [timer: Proof of concept wheel replacement](https://lwn.net/Articles/646056/)。他尝试对 Linux 中的时间轮进行改版，此后其修改被合并进主干，成为了 4.X 后的时间轮实现。在此我们将它们区分为 经典时间轮 和 现代时间轮。

> 在经典时间轮中，分为 tv1 到 tv5 五个粒度和精度不同的轮子，tv1 的精度最高，能够表示的时间范围最短。每次只检查 tv1 中是否有 timer 超时，然后每隔 256 jiffies，tv1 中所有 timer 都将超时，于是需要从 tv2 中将 timer 挪到 tv1 中。同理，当 tv2 用完时，需要从 tv3 挪，以此类推，这种操作称为 cascade 。无疑，cascade 是非常昂贵的，同时要找到下一个超时的 timer 需要遍历整套轮子来查找，效率低。为此社区已经讨论多年，就是想取代这个家伙。

> 最终 Thomas Gleixne 站了出来，提出了现代时间轮，但要改变这个存在了近十年的模块，看得出他还是有些慌的：
> "Be aware that it might eat your disk, kill you cat and make your kids miss the bus, but with some care one it should be able to tame the beast and get some real testing done."  

在现代时间轮中，如上所示，在 HZ 为 1000 下分为了 9 个轮子。每一层的粒度都是上一层的 8(2^LVL_CLK_SHIFT)倍，能够表示的范围也是上一层的 8 倍。也就是说，在 level 0 中，64 个链表分别对应 0-63ms，每毫秒(ms) 都维护了一个链表。而对于其他 level，比如 level 1 来说，每 8ms 才对应一个链表，在这 8ms 内的超时 timer 都会被加到这个链表中。因此一个 timer_base 维护了 WHEEL_SIZE = LVL_SIZE * LVL_DEPTH 个链表，在我们的情况下，有 9 * 64 = 576 个链表，覆盖长度为 12 天。

相比经典时间轮，最本质的改变是消除了 cascade 。当然这不是没有代价的：经典时间轮总是检查 tv1，那些最先超时的 timer 总是通过 cascade 被维护在 tv1 中，因此在它们超时时总是能立刻检查到，调用它们的回调函数。然而在新型时间轮中，timer 自被注册后就固定不动了，该在哪一 level 就在哪一 level，然后以不同的时间间隔去检查各 level。比如 level 0 是每个 jiffies 检查一次，而 level 1 要每 8 ms（粒度）才检查一次。也就是说，如果有一个 timer 是 68 jiffies 超时的，那么需要等到 64 + 8 = 72 jiffies 时才会被检查到，相当于晚了 4 jiffies 才超时。更严重的是，level 越高，粒度越大，检查出超时和实际超时时间的差就可能越大。

总结：它与旧的相比，降低了精度，提升了性能，同时利用位图加速next_timer的查找了，这个设计只为异常超时的定时任务服务，并且大部分任务都在超时前撤销了，像tcp ack超时重传这种。个人认为精髓在 calc_index 和 __collect_expired_timers 这俩函数。

但我们认为没关系，这是基于以下几个观察：

- 几乎所有的 timer 都被设置为在不久的将来超时，都集中在低 level
- 几乎所有的 timer 都会在超时前被取消，如果我们的目的是超时触发，那么考虑使用高精度定时器 hrtimer
- timer 的超时意味着出了什么问题，而问题的告知不需要太准时


# 定时器初始化


init_timers 中，我们需要对这些结构进行初始化：
```C
=> init_timer_cpus => init_timer_cpu                                初始化每个 CPU 的所有的 timer_base
=> init_timer_stats => raw_spin_lock_init => __raw_spin_lock_init   初始化每个 CPU 的 tstats_lookup_lock，用于保护 procfs 的 timer 统计操作
=> open_softirq(TIMER_SOFTIRQ, run_timer_softirq)                   注册 timer 软中断的处理函数为 run_timer_softirq
```
open_softirq 为 TIMER_SOFTIRQ 中断注册了处理函数 run_timer_softirq 。因此在收到时钟中断时，调用 run_timer_softirq 。

# 定时器管理
- 根据timer_list查找timer_base
- 删除timer_list
- 添加timer_list: 
- 修改timer_list
- 定时器迁移
- tick触发timer

## 添加timer_list
void add_timer(struct timer_list *timer)
=> __mod_timer(timer, timer->expires, MOD_TIMER_NOTPENDING)

## 删除timer_list
int del_timer(struct timer_list *timer) //  del_timer() of an inactive timer returns 0, del_timer() of an active timer returns 1
=> timer_pending(timer) // timer.entry.pprev 初始化了没有，有值就是挂在链表上了；没挂上就是没激活，直接返回0.
=> base = lock_timer_base(timer, &flags) // 根据timer_list找到timer_base, 先查CPU，如果在迁移就不停的等待；根据cpu找到timer_base。
=> ret = detach_if_pending(timer, base, true); // 根据timer.flags前10位找桶，如果该桶就这一个timer就重置base.pending_map标志位，然后base.next_expiry_recalc=true，重新计算base下一次到期时间。将timer从链表上摘掉，如果clear_pending, 就将timer.entry.pprev = NULL。 clear_pending 主要是为了重复利用这个timer。

谁在调用删除timer：
1. 驱动模块有大量的调用，比如网卡驱动、磁盘驱动、声卡
2. mm/page-writeback.c里面有`del_timer(&bdi->laptop_mode_wb_timer)`
3. kernel/sched/psi.c里面有`del_timer(&group->poll_timer)`



## 修改timer_list
int timer_reduce(struct timer_list *timer, unsigned long expires) // 修改已经存在时钟的到期时间，到期值减少
int mod_timer(struct timer_list *timer, unsigned long expires) // equal del_timer(timer); timer->expires = expires; add_timer(timer);
MOD_TIMER_PENDING_ONLY表示本次修改只针对还存在在系统内的定时器，如果定时器已经被删除了则不会再将其激活。
MOD_TIMER_REDUCE则表示本次修改只会将定时器的到期值减小。
MOD_TIMER_NOTPENDING

```C
static inline int __mod_timer(struct timer_list *timer, unsigned long expires, unsigned int options)
{
	unsigned long clk = 0, flags, bucket_expiry;
	struct timer_base *base, *new_base;
	unsigned int idx = UINT_MAX;
	int ret = 0;

	BUG_ON(!timer->function); // 必须初始化了


	if (!(options & MOD_TIMER_NOTPENDING) && timer_pending(timer)) { // timer已经pending，option不是notpending，就是修改现有timer的时间，这对网络栈友好
		long diff = timer->expires - expires;
		if (!diff)                                                   // 时间都没变，你逗我呢
			return 1;
		if (options & MOD_TIMER_REDUCE && diff <= 0)                 // 时间减少，比现有的时间还晚，啥也没干
			return 1;

		base = lock_timer_base(timer, &flags);
		forward_timer_base(base);                                    // 试着更新timer_base中的clk数                    

		if (timer_pending(timer) && (options & MOD_TIMER_REDUCE) &&  
		    time_before_eq(timer->expires, expires)) {                // 这和刚才不是一个意思吗
			ret = 1;
			goto out_unlock;
		}

		clk = base->clk;
		idx = calc_wheel_index(expires, clk, &bucket_expiry);         // 重新计算一下桶的位置

		if (idx == timer_get_idx(timer)) {                            // 重新算了，还在老地方，更新时间，不重新入队列了，快速处理
			if (!(options & MOD_TIMER_REDUCE))                        // 如果选项不是MOD_TIMER_REDUCE则直接修改定时器的到期时间 
				timer->expires = expires;
			else if (time_after(timer->expires, expires))             // 选项是MOD_TIMER_REDUCE则还要比较新老到期时间再修改
				timer->expires = expires;
			ret = 1;
			goto out_unlock;
		}
	} else {
		base = lock_timer_base(timer, &flags);
		forward_timer_base(base);
	}

	ret = detach_if_pending(timer, base, false);                     // 看来要挪位置了，先从base上取下来
	if (!ret && (options & MOD_TIMER_PENDING_ONLY))                  // 如果定时器(没激活)不在任何链表中且设置了MOD_TIMER_PENDING_ONLY(只pending)选项则直接返回
		goto out_unlock;

	new_base = get_target_base(base, timer->flags);                  // 获得系统指定的最合适的timer_base结构体, 如果开启NO_HZ可能回到不同的cpu上

	if (base != new_base) {                                          // 要更换base，可能和del_timer_sync()锁冲突哦
		if (likely(base->running_timer != timer)) {
			timer->flags |= TIMER_MIGRATING;

			raw_spin_unlock(&base->lock);                            // 释放迁移出的timer_base结构体的自旋锁
			base = new_base;
			raw_spin_lock(&base->lock);                              // 取迁移进的timer_base结构体的自旋锁
			WRITE_ONCE(timer->flags,                                 // 写入新的CPU号并清除TIMER_MIGRATING标记位
				   (timer->flags & ~TIMER_BASEMASK) | base->cpu);
			forward_timer_base(base);                                // 试着更新timer_base中的clk数
		}
	}

	debug_timer_activate(timer);

	timer->expires = expires;                                        // 更新定时器的到期时间
	if (idx != UINT_MAX && clk == base->clk)
		enqueue_timer(base, timer, idx, bucket_expiry);              // 如果桶下标已经计算过了且timer_base的clk没变（也意味着桶下标没变）
	else
		internal_add_timer(base, timer);                             // 重新计算桶下标并添加进去

out_unlock:
	raw_spin_unlock_irqrestore(&base->lock, flags);

	return ret;
}
```

## 触发


timer的触发是基于tick事件的。
通过前面的分析，我们知道在收到 TIMER_SOFTIRQ 时，会调用中断处理函数 run_timer_softirq 来找出超时的 timer，然后调用它们的回调函数。

那么 TIMER_SOFTIRQ 是由何人发出的呢？

在 tick 设备初始化过程中，有 tick_setup_periodic => tick_set_periodic_handler ，会设置收到 clock_event_device 中断时调用的 handler 为 tick_handle_periodic 。
于是 tick_handle_periodic => tick_periodic => update_process_times => run_local_timers => raise_softirq(TIMER_SOFTIRQ)
因此每当收到 tick 时，会发送软中断 TIMER_SOFTIRQ，让中断处理函数 run_timer_softirq 去处理。

// 周期性触发的时钟
static void tick_periodic(int cpu)
void legacy_timer_tick(unsigned long ticks)
static void tick_nohz_handler(struct clock_event_device *dev) // The nohz low res interrupt handler
=> static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)

// Called from the timer interrupt handler to charge one tick to the current process.  user_tick is 1 if the tick is user time, 0 for system.
void update_process_times(int user_tick)
// Called by the local, per-CPU timer interrupt on SMP.

```txt
static void run_local_timers(void)
=> 获取当前cpu的timer_base, base->next_expiry > jiffies, 还没超时，啥也不干。
=> raise_softirq(TIMER_SOFTIRQ) 
=> open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
=> __run_timers(base) / __run_timers(this_cpu_ptr(&timer_bases[BASE_DEF])) // run all expired timers (if any) on this CPU(???)
    => jiffies >= base->clk &&  jiffies>=  base->next_expiry, 有timer过期，需要触发
    => levels = collect_expired_timers(base, heads) // 最大的level，更低级的level肯定过期
        => idx = (clk & LVL_MASK) + i * LVL_SIZE // 这个level的index
        => hlist_move_list(vec, heads++) // 把整个链移过来
        => base->clk = base->next_expiry // 推进clk，表明小于next_expiry都是触发过的timer
        => if (clk & LVL_CLK_MASK) break; // 末尾3为为0才进行下一个level检查
        => clk >>= LVL_CLK_SHIFT // 进入下一个level再检查
    => base->next_expiry = __next_timer_interrupt(base)
    => expire_timers(base, heads + levels)
        => unsigned long baseclk = base->clk - 1;
        => base->running_timer = timer;       // 更新timer_base的running_timer的值为当前待处理定时器
        => detach_timer(timer, true);         // 从链表中删除该定时器
        => call_timer_fn(timer, fn, baseclk); // 如果是irqsafe，直接执行，否则关闭irq。用定时器到期处理函数
        => base->running_timer = NULL;        
        => timer_sync_wait_running(base)      // 不是irqsafe

```

`tick_periodic`周期性触发处理函数, 这个过程在**硬中断**中
    |-> tick_do_timer_cpu == cpu，当前cpu就是负责tick的cpu, 设置下一个tick时间，do_timer(1) 和 update_wall_time()。
    |-> update_process_times(user_mode(get_irq_regs())): 更新所耗费的各种节拍数
        |-> account_process_tick(p, user_tick)
        |-> run_local_timers() // 处理本CPU上的timer
            |-> hrtimer_run_queues() // 在硬中断上下文，每个jiffy都会触发
                |-> __hrtimer_hres_active(cpu_base): 如果启用了高精度时钟，**退出**，然后呢？
                |-> tick_check_oneshot_change(!hrtimer_is_hres_enabled())
                |-> hrtimer_switch_to_hres() // 切换到高精度时钟，直接**退出**
                |-> raise_softirq_irqoff(HRTIMER_SOFTIRQ)
                |-> __hrtimer_run_queues(cpu_base, now, flags, HRTIMER_ACTIVE_HARD)
            |-> raise_softirq(TIMER_SOFTIRQ) // 触发**软中断**
	    |-> rcu_sched_clock_irq(user_tick)
        |-> scheduler_tick()
        |-> run_posix_cpu_timers()
    |-> profile_tick(CPU_PROFILING)
```C
/*
 * Periodic tick
 */
static void tick_periodic(int cpu)
{
	if (tick_do_timer_cpu == cpu) {
		raw_spin_lock(&jiffies_lock);
		write_seqcount_begin(&jiffies_seq);

		/* Keep track of the next tick event */
		tick_next_period = ktime_add_ns(tick_next_period, TICK_NSEC);

		do_timer(1);
		write_seqcount_end(&jiffies_seq);
		raw_spin_unlock(&jiffies_lock);
		update_wall_time();
	}

	update_process_times(user_mode(get_irq_regs()));// 处理本cpu上的超时时钟
	profile_tick(CPU_PROFILING);
}
```

`update_process_times` : linux中众多进程可以同时执行，是因为采用了时间片轮转方案。每个进程都会分得相应的时间片，当前进程的时间片用完了，CPU就会停止执行当前进程，选择其他合适的进程执行。那么什么时候判断当前进程的时间片是否用完了呢？这依赖于系统timer，timer周期性的产生时钟中断，在中断处理函数中，会更新当前进程的时间等统计信息，并判断当前进程的时间片是否用完，是否需要切换到其他进程执行。这个工作由update_process_times函数来实现。这里需要注意，update_process_times函数不会做实际的进程切换动作，只会设置是否需要做进程切换的标记，真正的切换在schedule函数中实现。

调用方：
1. update_process_times


## run_timer_softirq : 处理时间中断，即调用超时 timer 的回调函数。

```C
/*
 * This function runs timers and the timer-tq in bottom half context.
 */
static __latent_entropy void run_timer_softirq(struct softirq_action *h)
{
    struct timer_base *base = this_cpu_ptr(&timer_bases[BASE_STD]);

    /*
     * must_forward_clk must be cleared before running timers so that any
     * timer functions that call mod_timer will not try to forward the
     * base. idle trcking / clock forwarding logic is only used with
     * BASE_STD timers.
     *
     * The deferrable base does not do idle tracking at all, so we do
     * not forward it. This can result in very large variations in
     * granularity for deferrable timers, but they can be deferred for
     * long periods due to idle.
     */
    base->must_forward_clk = false;

    __run_timers(base);
    if (IS_ENABLED(CONFIG_NO_HZ_COMMON))
        __run_timers(this_cpu_ptr(&timer_bases[BASE_DEF]));
}
```
对普通的 timer_base 和 NO_HZ 的 timer_base 分别执行 __run_timers ：
```C
static inline void __run_timers(struct timer_base *base)
{
    // 用来存放各 level 中超时 timer，每层一个链表
    struct hlist_head heads[LVL_DEPTH];
    int levels;

    // 如果当前 jiffies 小于 timer_base 设置的 jiffies ，此时不可能有超时的 timer，返回
    if (!time_after_eq(jiffies, base->clk))
        return;

    spin_lock_irq(&base->lock);

    // 循环至 timer_base 设置的 jiffies 大于当前 jiffies 为止
    while (time_after_eq(jiffies, base->clk)) {
        // 如果当前 jiffies 大于 timer_base 中设置的 jiffies，则 timer_base 维护的 timer 中可能会有到期的
        // 在各 level 中查找 base->clk 时刻时超时的 timer，将它们添加到 heads 的对应链表中。返回超时的最高 level
        levels = collect_expired_timers(base, heads);
        // 增加 timer_base 设置的 jiffies ，这样可能就不会进入下一轮循环
        base->clk++;

        // 遍历 heads 中的链表，将里面的 timer 从链表中移除，并调用 timer_list 中设置的超时回调函数
        while (levels--)
            expire_timers(base, heads + levels);
    }
    base->running_timer = NULL;
    spin_unlock_irq(&base->lock);
}
```

## collect_expired_timers
在 timer_base 的各 level 中查找匹配的链表：
```C
static int collect_expired_timers(struct timer_base *base,
                    struct hlist_head *heads)
{
    unsigned long clk = base->clk;
    struct hlist_head *vec;
    int i, levels = 0;
    unsigned int idx;

    // 从 level 0 开始找(最容易超时)
    for (i = 0; i < LVL_DEPTH; i++) {
        // 计算 timer_base 中设置的 jiffies 时刻所对应的链表索引
        idx = (clk & LVL_MASK) + i * LVL_SIZE;
        // 根据 bitmap 判断链表中有 timer ，如果有，清除该 bit，因为链表中的所有 timer 都会被取出并处理(调用回调)
        if (__test_and_clear_bit(idx, base->pending_map)) {
            vec = base->vectors + idx;
            // 将该链表添加到 heads 中
            hlist_move_list(vec, heads++);
            // 更新发生超时的最高 level 到 levels 中
            levels++;
        }
        /* Is it time to look at the next level? */
        // 如果 clk 低 3 位不为 0 (下一层是上一层粒度的 8 倍)，说明还未到检查下一层的时机，返回
        if (clk & LVL_CLK_MASK)
            break;
        /* Shift clock for the next level granularity */
        // 检查下一层(更大粒度)
        // timer_base 的 jiffies 右移 3 位，因为下一层时间粒度是上一层的 8(2^LVL_CLK_SHIFT) 倍
        clk >>= LVL_CLK_SHIFT;
    }
    return levels;
}
```
从以上的实现我们可以发现，新型时间轮是 轮不动，游标 (timer_base.clk) 动 。每次游标移动时，计算它在当前时刻（jiffies）时所指向的轮位置，然后利用 bitmap 对链表中是否有超时 timer 实现了快速判断。同时只有在相应时刻（粒度对应的 bit 全 0）才会检查下一层，避免了遍历所有轮子。

使用
定义
timer 有两种定义方式，一种是通过 DEFINE_TIMER 宏传入名称、回调函数、超时时间、回调参数来定义，另一种是声明 timer_list 结构变量后调用 init_timer 来初始化，并手动设置各字段的值。

## 激活 / 修改
add_timer 负责将 timer 激活，即将 timer_list 添加到当前 CPU 的 timer_base 中。

激活实际上是复用了修改 timer 的函数 mod_timer，只是参数 expires 就是 timer 的 expires 而已。于是有


## TIMER_SOFTIRQ 触发
