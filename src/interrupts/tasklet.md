# 概述

Linux 中的三种推迟中断执行的方式：softirq、tasklet、workqueue。softirq 和 tasklet 依赖软中断子系统，运行在软中断上下文中；workqueue 不依赖软中断子系统，运行在进程上下文中。

softirq 用到的地方非常少，原因之一它是静态编译的， 靠内置的 ksoftirqd 线程来调度内置的那 9 种 softirq。如果想新加一种，就得修改并重新编译内核， 所以开发成本非常高。

实际上，实现推迟执行的更常用方式 tasklet。它构建在 softirq 机制之上， 具体来说就是使用了上面提到的两种 softirq：HI_SOFTIRQ、TASKLET_SOFTIRQ。换句话说，tasklet 是可以在运行时（runtime）创建和初始化的 softirq。

内核软中断子系统初始化了两个 per-cpu 变量：

1. tasklet_vec：普通 tasklet，回调 tasklet_action()
2. tasklet_hi_vec：高优先级 tasklet，回调 tasklet_hi_action()

tasklet 支持在运行过程中动态注册，其可扩展性更强，很适合 driver 模块使用。

在 tasklet 的实现中，还有一点和其他的 softirq 不同，那就是它不支持同一种 tasklet（tasklet_struct 相同的就是同一种）在不同的CPU上执行，所以一个 tasklet 在执行前，会首先检测其他CPU上是否有正在执行的同种tasklet。普通的 softirq 可能 parallel 执行，因此需要在处理函数的内部考虑并行性的问题，必要时得加 spinlock 保护，tasklet 不允许 parallel 执行，减少了其处理函数实现的复杂度，但在进入之前，spinlock 的判断依然少不了。

## 数据结构

- tasklet_struct：

## 执行过程

tasklet_schedule() --> raise_softirq_irqoff(TASKLET_SOFTIRQ)

## 那些使用场景


## 触发

static void tasklet_action(struct softirq_action *a)
{
    local_irq_disable();
    list = __this_cpu_read(tasklet_vec.head);
    __this_cpu_write(tasklet_vec.head, NULL);
    __this_cpu_write(tasklet_vec.tail, this_cpu_ptr(&tasklet_vec.head));
    local_irq_enable();

    while (list) {
        if (tasklet_trylock(t)) {
            t->func(t->data);
            tasklet_unlock(t);
        }
        ...
    }
}