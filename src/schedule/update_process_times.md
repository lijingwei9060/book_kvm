linux中众多进程可以同时执行，是因为采用了时间片轮转方案。每个进程都会分得相应的时间片，当前进程的时间片用完了，CPU就会停止执行当前进程，选择其他合适的进程执行。
那么什么时候判断当前进程的时间片是否用完了呢？这依赖于系统timer，timer周期性的产生时钟中断，在中断处理函数中，会更新当前进程的时间等统计信息，并判断当前进程的时间片是否用完，是否需要切换到其他进程执行。这个工作由update_process_times函数来实现。这里需要注意，update_process_times函数不会做实际的进程切换动作，只会设置是否需要做进程切换的标记，真正的切换在schedule函数中实现。

update_process_times->account_process_tick
```C
void account_process_tick(struct task_struct *p, int user_tick)
{
	cputime_t cputime, scaled, steal;
	struct rq *rq = this_rq();

	if (vtime_accounting_cpu_enabled())
		return;

	if (sched_clock_irqtime) {
		irqtime_account_process_tick(p, user_tick, rq, 1);
		return;
	}
        // 一个jiffy对应的cpu时间，一个jiffy对应1/HZ秒 
  	cputime = cputime_one_jiffy;
	steal = steal_account_process_time(ULONG_MAX);

	if (steal >= cputime)
		return;

	cputime -= steal;
	scaled = cputime_to_scaled(cputime);

        //将cpu time加入到user进程或者内核线程或者idle线程中
	if (user_tick)
		account_user_time(p, cputime, scaled);
	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
		account_system_time(p, HARDIRQ_OFFSET, cputime, scaled);
	else
		account_idle_time(cputime);
}
```

该函数统计当前进程占用cpu的时间，因为定时器中断的产生周期是一个jiffy，所以当前进程需要增加的时间最大是一个jiffy。之所以说最大是因为，在这一个jiffy的时间内，有可能会被中断或者其他进程抢占，被抢占的这部分时间就从当前进程偷走了，所以这里需要减去被偷走的时间。

这里还有一个问题就是如何知道当前进程是用户进程还是内核线程的？在进入定时器中断的时候，会将spsr保存在栈里，pstate寄存器的低四位记录了从何处进入此异常的，具体定义如下：M[3:0], 

保存spsr的逻辑在kernel_entry函数中实现，判断当前进程是用户进程还是内核进程的逻辑在user_mode(get_irq_regs())函数中实现。

update_process_times->scheduler_tick->update_rq_clock

```C
void update_rq_clock(struct rq *rq)
{
	s64 delta;

	lockdep_assert_held(&rq->lock);

	if (rq->clock_skip_update & RQCF_ACT_SKIP)
		return;

	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
	if (delta < 0)
		return;
	rq->clock += delta;
	update_rq_clock_task(rq, delta);
}
```

一个tick对应一个clock，sched_clock_cpu获取系统运行至今的tick计数。该函数更新rq->clock和rq->clock_task，其中rq->clock记录总的tick计数，而clock_task会减去中断占用的tick计数，是真正进程执行所使用的tick计数。

# task_tick_fair
update_process_times->scheduler_tick->curr->sched_class->task_tick
我们以task_tick_fair为例来分析：
task_tick_fair->entity_tick->update_curr(cfs_rq)
```C
static void update_curr(struct cfs_rq *cfs_rq)
{
   struct sched_entity *curr = cfs_rq->curr;
   u64 now = rq_clock_task(rq_of(cfs_rq));
   u64 delta_exec;

   if (unlikely(!curr))
   	return;

   delta_exec = now - curr->exec_start;
   if (unlikely((s64)delta_exec <= 0))
   	return;

   curr->exec_start = now;

   schedstat_set(curr->statistics.exec_max,
   	      max(delta_exec, curr->statistics.exec_max));

   curr->sum_exec_runtime += delta_exec;
   schedstat_add(cfs_rq->exec_clock, delta_exec);

   curr->vruntime += calc_delta_fair(delta_exec, curr);
   update_min_vruntime(cfs_rq);

   if (entity_is_task(curr)) {
   	struct task_struct *curtask = task_of(curr);

   	trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
   	cpuacct_charge(curtask, delta_exec);
   	account_group_exec_runtime(curtask, delta_exec);
   }

   account_cfs_rq_runtime(cfs_rq, delta_exec);
}
```
curr->exec_start记录当前进程最近一次执行的时间点。
curr->sum_exec_runtime记录当前进程运行的总的时间。

task_tick_fair->entity_tick->check_preempt_tick(cfs_rq, curr);

```C
static void
check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
{
   unsigned long ideal_runtime, delta_exec;
   struct sched_entity *se;
   s64 delta;
   #获取当前进程可以持续执行的时间
   ideal_runtime = sched_slice(cfs_rq, curr);
   #获取当前进程已经执行的时间
   delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
   #如果当前进程已经执行了足够长的时间，需要将其调度出去
   if (delta_exec > ideal_runtime) {
   	resched_curr(rq_of(cfs_rq));
   	/*
   	 * The current task ran long enough, ensure it doesn't get
   	 * re-elected due to buddy favours.
   	 */
   	clear_buddies(cfs_rq, curr);
   	return;
   }

   /*
    * Ensure that a task that missed wakeup preemption by a
    * narrow margin doesn't have to wait for a full slice.
    * This also mitigates buddy induced latencies under load.
    */
   if (delta_exec < sysctl_sched_min_granularity)
   	return;

   se = __pick_first_entity(cfs_rq);
   
   delta = curr->vruntime - se->vruntime;

   if (delta < 0)
   	return;

   if (delta > ideal_runtime)
   	resched_curr(rq_of(cfs_rq));
}
```

task_tick_fair->entity_tick->check_preempt_tick(cfs_rq, curr)->resched_curr

```C
void resched_curr(struct rq *rq)
{
   struct task_struct *curr = rq->curr;
   int cpu;

   lockdep_assert_held(&rq->lock);

   if (test_tsk_need_resched(curr))
   	return;

   cpu = cpu_of(rq);

   if (cpu == smp_processor_id()) {
       #设置调度标记TIF_NEED_RESCHED
   	set_tsk_need_resched(curr);
   	set_preempt_need_resched();
   	return;
   }

   if (set_nr_and_not_polling(curr))
   	smp_send_reschedule(cpu);
   else
   	trace_sched_wake_idle_without_ipi(cpu);
}
```

referrence : https://blog.csdn.net/liuhangtiant/article/details/84075876