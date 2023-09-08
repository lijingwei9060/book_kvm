# 概述
Linux 中的三种推迟中断执行的方式：softirq、tasklet、workqueue。softirq 和 tasklet 依赖软中断子系统，运行在软中断上下文中；workqueue 不依赖软中断子系统，运行在进程上下文中。

- tasklet 是运行在 softirq 上下文中，tasklet 永远运行在指定 CPU，这是初始化时就确定了的；
- workqueue 运行在内核进程上下文中； 这意味着 wq 不能像 tasklet 那样是原子的；workqueue 默认行为也是这样，但是可以通过配置修改这种行为。

workqueue 子系统提供了一个接口，通过这个接口可以创建内核线程来处理从其他地方 enqueue 过来的任务。 这些内核线程就称为 worker threads，

workqueue 机制不光用于中断底半部的实现，对于一般的小型任务，也可按照这种思路，不用自己起一个线程，而是扔到 workqueue 中去处理，以节约资源开销，因此 workqueue 现在已经扩展成为内核中一种通用的异步处理手段。

## 数据结构

- worker_pool 
- work_struct 

## 哪些在使用

## 用户态接口

内置的 per-cpu worker threads：
```shell
$ systemd-cgls -k | grep kworker
├─    5 [kworker/0:0H]
├─   15 [kworker/1:0H]
├─   20 [kworker/2:0H]
├─   25 [kworker/3:0H]
```
