# 功能设计

cpu throttle限制vcpu的执行时间，降低脏也产生速度，促进迁移时间收敛。实现的逻辑是让vcpu退出到qemu，qemu让vcpu休眠一段时间。

实现目标是控制： throttle_percentage = sleep_time / (sleep_time + run_time), 分母为一个throttle周期，周期内run_time默认为10ms。

在迁移阶段，通过控制throttle_percentage 实现控制vCPU的总体运行时间，从而降低脏页产生速率。

cpu throttle通过定时器周期性kick vcpu实现，qemu注册定时器，这个动作包含在qemu主线程启动过程中。

## 数据结构

QEMUTimer用来实现定时，周期性触发回调函数，kick处于运行态的vcpu：

qemu_work_item用来实现vcpu运行任务的封装，所有需要vcpu线程在用户态执行的任务会被链表链接起来，放在CPUState结构体的work_list成员中，一旦vcpu退回到用户态，vcpu线程会遍历该链表的所有任务并依次执行

## 执行过程

### 注册定时器：

cpu throttle通过定时器周期性kick vcpu实现，需要注册qemu定时器，这个动作包含在qemu主线程启动过程中，流程如下：
qemu_init
	cpu_timers_init
		cpu_throttle_init
			/* 注册throttle timer
			 * 超时单位：ns
			 * timer回调：cpu_throttle_timer_tick
			 * 超时时间：无
			 * 超时时间类型：虚拟机运行时间
			 * */
			throttle_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL_RT, cpu_throttle_timer_tick, NULL);                


### 启动cpu throttle

迁移线程通过调用cpu_throttle_set函数触发cpu throttle的定时器，参数为vcpu睡眠时间与throttle周期的百分比，qemu定义全局静态变量throttle_percentage来控制throttle的运行，throttle_percentage大于0时触发cpu throttle，等于0时停止cpu throttle，流程如下

```C
void cpu_throttle_set(int new_throttle_pct)
{
    /*
     * boolean to store whether throttle is already active or not,
     * before modifying throttle_percentage
     * 取出全局变量throttle_percentage判断throttle是否启动
     */
    bool throttle_active = cpu_throttle_active();
	/* 确保睡眠百分比在1-99范围内 */
    /* Ensure throttle percentage is within valid range */
    new_throttle_pct = MIN(new_throttle_pct, CPU_THROTTLE_PCT_MAX);
    new_throttle_pct = MAX(new_throttle_pct, CPU_THROTTLE_PCT_MIN);

    qatomic_set(&throttle_percentage, new_throttle_pct);
	/* 如果throttle没有启动，触发 */
    if (!throttle_active) {
        cpu_throttle_timer_tick(NULL);
    }
}
```

cpu_throttle_set对输入进行了检查并查看throttle是否启动，如果没有启动则触发，启动cpu throttle的真正工作在cpu_throttle_timer_tick中完成

```C
static void cpu_throttle_timer_tick(void *opaque)
{
    CPUState *cpu;
    double pct;

    /* Stop the timer if needed */
    if (!cpu_throttle_get_percentage()) {		/* 检查throttle是否有必要停止 */
        return;
    }
    CPU_FOREACH(cpu) {							/* 遍历虚机每个vcpu */
        if (!qatomic_xchg(&cpu->throttle_thread_scheduled, 1)) {	/* 如果vcpu启动throttle任务 */
            async_run_on_cpu(cpu, cpu_throttle_thread,				/* 将cpu_throttle_thread任务添加到vcpu的work_list链表中 */
                             RUN_ON_CPU_NULL);
        }
    }
	/* 根据睡眠百分比计算throttle周期，将其设置为throttle timer的超时时间 
	 * 从这里可以看出，throttle timer的超时时间与睡眠百分比有关
	 **/
    pct = (double)cpu_throttle_get_percentage() / 100;
    timer_mod(throttle_timer, qemu_clock_get_ns(QEMU_CLOCK_VIRTUAL_RT) +  CPU_THROTTLE_TIMESLICE_NS / (1 - pct));
}
```


将cpu_throttle_thread函数封装成任务并挂到vcpu的work_list链表的工作由async_run_on_cpu完成，继续分析：
```C
void async_run_on_cpu(CPUState *cpu, run_on_cpu_func func, run_on_cpu_data data)
{
    struct qemu_work_item *wi;
	/* 将cpu_throttle_thread封装成qemu_work_item */
    wi = g_malloc0(sizeof(struct qemu_work_item));
    wi->func = func;
    wi->data = data;
    wi->free = true;
	/* 挂入work_list链表 */
    queue_work_on_cpu(cpu, wi);
}
```

完成work挂入work_list链表的操作后，queue_work_on_cpu最后会kick vcpu，让vcpu从guest态返回到用户态，如下：
```C
static void queue_work_on_cpu(CPUState *cpu, struct qemu_work_item *wi)
{
    qemu_mutex_lock(&cpu->work_mutex);
    QSIMPLEQ_INSERT_TAIL(&cpu->work_list, wi, node);	/* 任务添加到链表 */
    wi->done = false;
    qemu_mutex_unlock(&cpu->work_mutex);
	/* 使vcpu从guest态退出到用户态，处理work_list上的任务 */
    qemu_cpu_kick(cpu);
}

```




### vcpu睡眠

cpu throttle在work_list上注册的cpu_throttle_thread任务，cpu_throttle_thread要进行以下内容：
1. 根据throttle_percent计算需要睡眠的时间
2. 如果需要睡眠并且休眠时间大于1ms，vcpu 让线程在halt_cond信号量上休眠等待sleeptime_ns，休眠过程中如果信号量halt_cond由信号发来，线程会被唤醒。cpu->stop = true, cpu->halt_cond广播。
3. 如果小于1ms，直接sleep

### 停止cpu throttle

停止cpu throttle通直接设置全局变量throttle_percentage为0，定时器的回调函数和throttle线程都会检查这个变量，一旦为0，就会直接返回。