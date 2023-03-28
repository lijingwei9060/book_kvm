# 软中断

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