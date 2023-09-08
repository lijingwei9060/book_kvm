# 概述

Linux 中的三种推迟中断执行的方式：softirq、tasklet、workqueue。softirq 和 tasklet 依赖软中断子系统，运行在软中断上下文中；workqueue 不依赖软中断子系统，运行在进程上下文中。

Linux 在每个 CPU 上会创建一个 ksoftirqd 内核线程。softirqs 是在 Linux 内核编译时就确定好的，例如网络收包对应的 `NET_RX_SOFTIRQ` 软中断。 因此是一种静态机制。如果想加一种新 softirq 类型，就需要修改并重新编译内核。


## 数据结构

在内部是用一个数组（或称向量）来管理的，每个软中断号对应一个 softirq handler。

- static struct softirq_action softirq_vec[NR_SOFTIRQS]

有10个软中断：
1. HI_SOFTIRQ=0,          // tasklet
2. TIMER_SOFTIRQ,         // timer
3. NET_TX_SOFTIRQ,        // networking
4. NET_RX_SOFTIRQ,        // networking
5. BLOCK_SOFTIRQ,         // IO
6. IRQ_POLL_SOFTIRQ,
7. TASKLET_SOFTIRQ,       // tasklet
8. SCHED_SOFTIRQ,         // schedule
9. HRTIMER_SOFTIRQ,       // timer
10. RCU_SOFTIRQ,           // lock
11. NR_SOFTIRQS 
## 管理接口

- 注册软中断：open_softirq(int nr, softirq_action)，直接设置全局变量softirq_vec[nr] = action。
- 唤醒软中断：raise_softirq(int nr)，关闭当前CPU 中断，唤醒当前CPU对应的ksoftirqd线程， 打开中断。

## 初始化

softirq_init

## 用户态接口

软中断是一个内核子系统：每个 CPU 上会初始化一个 ksoftirqd 内核线程，负责处理各种类型的 softirq 中断事件；

1. 用 cgroup ls 或者 ps -ef 都能看到：
```shell
 $ systemd-cgls -k | grep softirq # -k: include kernel threads in the output
 ├─    12 [ksoftirqd/0]
 ├─    19 [ksoftirqd/1]
 ├─    24 [ksoftirqd/2]
```
1. 软中断事件的 handler 提前注册到 softirq 子系统， 注册方式 open_softirq(softirq_id, handler)。

例如，注册网卡收发包（RX/TX）软中断处理函数：
 // net/core/dev.c
 open_softirq(NET_TX_SOFTIRQ, net_tx_action);
 open_softirq(NET_RX_SOFTIRQ, net_rx_action);

3. 软中断占 CPU 的总开销：可以用 top 查看，里面 si 字段就是系统的软中断开销（第三行倒数第二个指标）：
```shell
 $ top -n1 | head -n3
 top - 18:14:05 up 86 days, 23:45,  2 users,  load average: 5.01, 5.56, 6.26
 Tasks: 969 total,   2 running, 733 sleeping,   0 stopped,   2 zombie
 %Cpu(s): 13.9 us,  3.2 sy,  0.0 ni, 82.7 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
```

也就是在 `cat /proc/softirqs` 看到的那些，
```shell
$ cat /proc/softirqs
                  CPU0     CPU1  ...    CPU46    CPU47
          HI:        2        0  ...        0        1
       TIMER:   443727   467971  ...   313696   270110
      NET_TX:    57919    65998  ...    42287    54840
      NET_RX:    28728  5262341  ...    81106    55244
       BLOCK:      261     1564  ...   268986   463918
    IRQ_POLL:        0        0  ...        0        0
     TASKLET:       98      207  ...      129      122
       SCHED:  1854427  1124268  ...  5154804  5332269
     HRTIMER:    12224    68926  ...    25497    24272
         RCU:  1469356   972856  ...  5961737  5917455
```


```C
mpboot_thread_fn
  |-while (1) {
      set_current_state(TASK_INTERRUPTIBLE); // 设置当前 CPU 为可中断状态

      if !thread_should_run {                // 无 pending 的软中断
          preempt_enable_no_resched();
          schedule();
      } else {                               // 有 pending 的软中断
          __set_current_state(TASK_RUNNING);
          preempt_enable();
          thread_fn(td->cpu);                // 如果此时执行的是 ksoftirqd 线程，
            |-run_ksoftirqd                  // 那会执行 run_ksoftirqd() 回调函数
                |-local_irq_disable();       // 关闭所在 CPU 的所有硬中断
                |
                |-if local_softirq_pending() {
                |    __do_softirq();
                |    local_irq_enable();      // 重新打开所在 CPU 的所有硬中断
                |    cond_resched();          // 将 CPU 交还给调度器
                |    return;
                |-}
                |
                |-local_irq_enable();         // 重新打开所在 CPU 的所有硬中断
      }
    }
```

如果此时调度到的是 ksoftirqd 线程，那 thread_fn() 执行的就是 run_ksoftirqd()。

## 软中断线程初始化：注册 run_ksoftirqd()

软中断对分担硬中断的工作量至关重要，因此软中断线程在内核启动的很早阶段就 spawn 出来了：

```C
// https://github.com/torvalds/linux/blob/v5.10/kernel/softirq.c#L730

static struct smp_hotplug_thread softirq_threads = {
    .store            = &ksoftirqd,
    .thread_should_run= ksoftirqd_should_run,  // 调度到该线程是，判断能否执行
    .thread_fn        = run_ksoftirqd,         // 调度到该线程时，执行的回调函数
    .thread_comm      = "ksoftirqd/%u",        // 线程名字，ps -ef 最后一列可以看到
};

static __init int spawn_ksoftirqd(void) {
    cpuhp_setup_state_nocalls(CPUHP_SOFTIRQ_DEAD, "softirq:dead", NULL, takeover_tasklets);
    BUG_ON(smpboot_register_percpu_thread(&softirq_threads));
}
early_initcall(spawn_ksoftirqd);
```

1. 看到注册了两个回调函数: ksoftirqd_should_run() 和 run_ksoftirqd()， smpboot_thread_fn() 会调用这两个函数。
2. 线程的命名格式是 ksoftirqd/%u，其中 %u 是该线程所在 CPU 的 ID，

## 处理器调度循环：smpboot_thread_fn() -> run_ksoftirqd()

每个 CPU 上的调度器会调度执行不同的线程，例如处理 OOM 的线程、处理 swap 的线程，以及 我们的软中断处理线程。
查看 CPU 利用率时，si 字段对应的就是 softirq 开销(software interrupt overhead)， 衡量（从硬中断转移过来的）软中断的 CPU 使用量。

```C
// https://github.com/torvalds/linux/blob/v5.10/kernel/smpboot.c#L107

// smpboot_thread_fn - percpu hotplug thread loop function
// @data:    thread data pointer
//
// Returns 1 when the thread should exit, 0 otherwise.
static int smpboot_thread_fn(void *data) {
    struct smpboot_thread_data *td = data;
    struct smp_hotplug_thread *ht = td->ht;

    while (1) {
        set_current_state(TASK_INTERRUPTIBLE); // 设置当前 CPU 为可中断状态
        preempt_disable();

        if (kthread_should_park()) {
            ...
            continue; /* We might have been woken for stop */
        }

        switch (td->status) { /* Check for state change setup */
        case HP_THREAD_NONE:   ...  continue;
        case HP_THREAD_PARKED: ...  continue;
        }

        if (!ht->thread_should_run(td->cpu)) { // 无 pending 的软中断
            preempt_enable_no_resched();
            schedule();
        } else {                               // 有 pending 的软中断
            __set_current_state(TASK_RUNNING);
            preempt_enable();
            ht->thread_fn(td->cpu);            // 执行 `run_ksoftirqd()`
        }
    }
}
```

如果此时调度到的是 ksoftirqd 线程，并且有 pending 的软中断等待处理， 那 thread_fn() 执行的就是 run_ksoftirqd()。

## run_ksoftirqd()

```C
// https://github.com/torvalds/linux/blob/v5.10/kernel/softirq.c#L730

static void run_ksoftirqd(unsigned int cpu) {
    local_irq_disable();           // 关闭所在 CPU 的所有硬中断

    if (local_softirq_pending()) {
         // We can safely run softirq on inline stack, as we are not deep in the task stack here.
        __do_softirq();
        local_irq_enable();       // 重新打开所在 CPU 的所有硬中断
        cond_resched();           // 将 CPU 交还给调度器
        return;
    }

    local_irq_enable();            // 重新打开所在 CPU 的所有硬中断
}
```

1. 首先调用 local_irq_disable()，这是一个宏，最终会 展开成处理器架构相关的函数，功能是关闭所在 CPU 的所有硬中断；
2. 接下来，判断如果有 pending softirq，则 执行 __do_softirq() 处理软中断，然后重新打开所在 CPU 的硬中断，然后返回；否则直接打开所在 CPU 的硬中断，然后返回。

## __do_softirq() -> net_rx_action()

```C
// https://github.com/torvalds/linux/blob/v5.10/kernel/softirq.c#L730

asmlinkage __visible void __softirq_entry __do_softirq(void) {
    unsigned long       end = jiffies + MAX_SOFTIRQ_TIME; // 时间片最晚结束时刻
    unsigned long old_flags = current->flags;
    int max_restart         = MAX_SOFTIRQ_RESTART;        // 最大轮询 pending softirq 次数

    // Mask out PF_MEMALLOC as the current task context is borrowed for the softirq.
    // A softirq handler, such as network RX, might set PF_MEMALLOC again if the socket is related to swapping.
    current->flags &= ~PF_MEMALLOC;

    pending = local_softirq_pending(); // 获取 pending softirq 数量
    account_irq_enter_time(current);

    __local_bh_disable_ip(_RET_IP_, SOFTIRQ_OFFSET);
    in_hardirq = lockdep_softirq_start();

restart:
    set_softirq_pending(0); // Reset the pending bitmask before enabling irqs
    local_irq_enable();     // 打开 IRQ 中断

    struct softirq_action *h = softirq_vec;
    while ((softirq_bit = ffs(pending))) {
        h += softirq_bit - 1;
        unsigned int vec_nr     = h - softirq_vec;
        int          prev_count = preempt_count();
        kstat_incr_softirqs_this_cpu(vec_nr);

        h->action(h);                 // 指向 net_rx_action()
        h++;
        pending >>= softirq_bit;
    }

    if (__this_cpu_read(ksoftirqd) == current)
        rcu_softirq_qs();

    local_irq_disable();               // 关闭 IRQ
    pending = local_softirq_pending(); // 再次获取 pending softirq 的数量
    if (pending) {
        if (time_before(jiffies, end) && !need_resched() && --max_restart)
            goto restart;

        wakeup_softirqd();
    }

    lockdep_softirq_end(in_hardirq);
    account_irq_exit_time(current);
    __local_bh_enable(SOFTIRQ_OFFSET);

    current_restore_flags(old_flags, PF_MEMALLOC);
}
```