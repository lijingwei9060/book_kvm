# 概述
Linux 中的三种推迟中断执行的方式：softirq、tasklet、workqueue。softirq 和 tasklet 依赖软中断子系统，运行在软中断上下文中；workqueue 不依赖软中断子系统，运行在进程上下文中。workqueue 的本质是把 work 交给一个内核线程，在进程上下文调度的时候执行。因为这个特点，所以 workqueue 允许重新调度和睡眠，这种异步执行的进程上下文，能解决因为 softirq 和 tasklet 执行时间长而导致的系统实时性下降等问题。

- tasklet 是运行在 softirq 上下文中，tasklet 永远运行在指定 CPU，这是初始化时就确定了的；
- workqueue 运行在内核进程上下文中； 这意味着 wq 不能像 tasklet 那样是原子的；workqueue 默认行为也是这样，但是可以通过配置修改这种行为。

workqueue 子系统提供了一个接口，通过这个接口可以创建内核线程来处理从其他地方 enqueue 过来的任务。 这些内核线程就称为 worker threads，

workqueue 机制不光用于中断底半部的实现，对于一般的小型任务，也可按照这种思路，不用自己起一个线程，而是扔到 workqueue 中去处理，以节约资源开销，因此 workqueue 现在已经扩展成为内核中一种通用的异步处理手段。

## 数据结构
- worker_pool: 工人的集合，pool_workqueue 和 worker_pool 是一对一的关系，worker_pool 和 worker 是一对多的关系。bound 类型的工作队列：worker_pool 是 Per-CPU 创建，每个 CPU 都有两个 worker_pool，对应不同的优先级，nice 值分别为 0 和 -20。unbound 类型的工作队列： worker_pool 创建后会添加到 unbound_pool_hash 哈希表中。
  - cpu：绑定到 CPU 的 workqueue，代表 CPU ID
  - node：非绑定类型的 workqueue，代表内存 Node ID
  - worklist：pending 状态的 work 添加到本链表
  - nr_workers：worker 的数量
  - idle_list：处于 IDLE 状态的 worker 添加到本链表
  - busy_hash：工作状态的 worker 添加到本哈希表中
  - workers：worker_pool 管理的 worker 添加到本链表中
  - hash_node：用于添加到 unbound_pool_hash 中
- worker： 工人。在代码中 worker 对应一个 work_thread() 内核线程。
  - entry：用于添加到 worker_pool 的空闲链表中
  - hentry：用于添加到 worker_pool 的忙碌列表中
  - current_work：当前正在处理的 work
  - current_func：当前正在执行的 work 回调函数
  - current_pwq：指向当前 work 所属的 pool_workqueue
  - scheduled：所有被调度执行的 work 都将添加到该链表中
  - task：指向内核线程
  - pool：该 worker 所属的 worker_pool
  - node：添加到 worker_pool->workers 链表中
- pool_workqueue ：中间人 / 中介，负责建立起 workqueue 和 worker_pool 之间的关系。workqueue 和 pool_workqueue 是一对多的关系。 
  - pool：指向 worker_pool
  - wq：指向所属的 workqueue
  - nr_active：活跃的 work 数量
  - max_active：活跃的最大 work 数量
  - delayed_works：延迟执行的 work 挂入本链表
  - pwqs_node：用于添加到 workqueue 链表中
  - mayday_node：用于添加到 workqueue 链表中
- work_struct ： 工作任务，调度的最小单位
  - data：低比特存放状态位，高比特存放 worker_pool 的ID或者 pool_workqueue 的指针
  - entry：用于添加到其他队列上
  - func：工作任务的处理函数，在内核线程中回调
- workqueue_struct : 工作任务集合，相当于多个work_struct。内核中有两种工作队列，bound到具体的处理器上，和unbound到具体的cpu
  - pwqs：所有的 pool_workqueue 都添加到本链表中
  - list：用于将工作队列添加到全局链表 workqueues 中
  - maydays：rescue状态下的 pool_workqueue 添加到本链表中
  - rescuer：rescuer 内核线程，用于处理内存紧张时创建工作线程失败的情况
  - cpu_pwqs：Per-CPU 创建 pool_workqueue
  - numa_pwq_tbl[]：Per-Node 创建 pool_workqueue

```C
struct work_struct {
    atomic_long_t data;     
    struct list_head entry; 
    work_func_t func;       
    #ifdef CONFIG_LOCKDEP
    struct lockdep_map lockdep_map;
    #endif
};

struct workqueue_struct {
    struct list_head pwqs;  /* WR: all pwqs of this wq */   
    struct list_head list;  /* PR: list of all workqueues */  
     
    struct list_head maydays; /* MD: pwqs requesting rescue */    
    struct worker  *rescuer; /* I: rescue worker */  
     
    struct pool_workqueue *dfl_pwq; /* PW: only for unbound wqs */
     
    char   name[WQ_NAME_LEN]; /* I: workqueue name */
     
    /* hot fields used during command issue, aligned to cacheline */
    unsigned int  flags ____cacheline_aligned; /* WQ: WQ_* flags */
    struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwqs */    
    struct pool_workqueue __rcu *numa_pwq_tbl[]; /* PWR: unbound pwqs indexed by node */    //Per-Node创建pool_workqueue
    ...
};

struct pool_workqueue {
    struct worker_pool *pool;  /* I: the associated pool */    
    struct workqueue_struct *wq;  /* I: the owning workqueue */   
     
    int   nr_active; /* L: nr of active works */    
    int   max_active; /* L: max active works */   
    struct list_head delayed_works; /* L: delayed works */     
    struct list_head pwqs_node; /* WR: node on wq->pwqs */    
    struct list_head mayday_node; /* MD: node on wq->maydays */   //用于添加到workqueue链表中
    ...
} __aligned(1 << WORK_STRUCT_FLAG_BITS);

struct worker_pool {
    spinlock_t  lock;  /* the pool lock */
    int   cpu;  /* I: the associated cpu */     
    int   node;  /* I: the associated node ID */ 
    int   id;  /* I: pool ID */
    unsigned int  flags;  /* X: flags */
     
    unsigned long  watchdog_ts; /* L: watchdog timestamp */
     
    struct list_head worklist; /* L: list of pending works */  
    int   nr_workers; /* L: total number of workers */   
     
    /* nr_idle includes the ones off idle_list for rebinding */
    int   nr_idle; /* L: currently idle ones */
     
    struct list_head idle_list; /* X: list of idle workers */  
    struct timer_list idle_timer; /* L: worker idle timeout */
    struct timer_list mayday_timer; /* L: SOS timer for workers */
     
    /* a workers is either on busy_hash or idle_list, or the manager */
    DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);   /* L: hash of busy workers */
     
    /* see manage_workers() for details on the two manager mutexes */
    struct worker  *manager; /* L: purely informational */
    struct mutex  attach_mutex; /* attach/detach exclusion */
    struct list_head workers; /* A: attached workers */   
    struct completion *detach_completion; /* all workers detached */
     
    struct ida  worker_ida; /* worker IDs for task name */
     
    struct workqueue_attrs *attrs;  /* I: worker attributes */
    struct hlist_node hash_node; /* PL: unbound_pool_hash node */    
    ...
} ____cacheline_aligned_in_smp;

struct worker {
    /* on idle list while idle, on busy hash table while busy */
    union {
     struct list_head entry; /* L: while idle */     
     struct hlist_node hentry; /* L: while busy */ 
    };
     
    struct work_struct *current_work; /* L: work being processed */  
    work_func_t  current_func; /* L: current_work's fn */                
    struct pool_workqueue *current_pwq; /* L: current_work's pwq */   
     
    struct list_head scheduled; /* L: scheduled works */   
      
    /* 64 bytes boundary on 64bit, 32 on 32bit */
     
    struct task_struct *task;  /* I: worker task */   
    struct worker_pool *pool;  /* I: the associated pool */   
    /* L: for rescuers */
    struct list_head node;  /* A: anchored at pool->workers */  //添加到worker_pool->workers链表中
    /* A: runs through worker->node */
    ...
};
```

## 初始化过程

内核在启动的时候会对 workqueue 做初始化，workqueue 的初始化包含两个阶段，分别是 workqueue_init_early 和 workqueue_init。

workqueue_init_early: 
1. 分配 worker_pool，并且对该结构中的字段进行初始化操作
2. 分配 workqueue_struct，并且对该结构中的字段进行初始化操作
3. alloc_and_link_pwqs：分配 pool_workqueue，将 workqueue_struct 和 worker_pool 关联起来

workqueue_init: 里主要完成的工作是给之前创建好的 worker_pool，添加一个初始的 worker，然后利用函数 create_worker，创建名字为 kworker/XX:YY 或者 kworker/uXX:YY 的内核线程。其中 XX 表示 worker_pool 的编号，YY 表示 worker 的编号，u 表示unbound。
1. 分配 worker，并且对该结构中的字段进行初始化操作
2. 为 worker 创建内核线程 worker_thread
3. 将 worker 添加到 worker_pool 中
4. worker 进入 IDLE 状态

全局变量： cpu_worker_pools

```C
workqueue_init(void) // kthread已经准备完毕，可以创建工作
|-> wq_numa_init()
|-> 初始化pool->node = cpu_to_node(cpu)
|-> wq_update_unbound_numa(sq, cpu_id, true)
|-> pool->flags &= ~POOL_DISASSOCIATED;
|-> bound -> create_worker(pool) // 创建一个work放在pool里面
|-> unbound_pool_hash -> create_worker(pool)
    |-> kthread_create_on_node(worker_thread, worker, pool->node,"kworker/%s", id_buf);
    |-> worker_enter_idle(worker);  // 进worker入idle state
	|-> wake_up_process(worker->task); // 唤醒task，让它工作
|-> wq_online = true
|-> wq_watchdog_init()
```
经过上面两个阶段的初始化，workqueue 子系统基本就已经将数据结构的关联建立好了，当有 work 来进行调度的时候，就可以进行处理了。

## work调度

## 使用workqueue

1. 初始化work
2. 初始化 work 后，就可以调用 shedule_work 函数把 work 挂入系统默认的 workqueue 中。

```C
#define INIT_WORK(_work, _func)     __INIT_WORK((_work), (_func), 0)
   
#define __INIT_WORK(_work, _func, _onstack)    \
do {        \
    __init_work((_work), _onstack);    \
    (_work)->data = (atomic_long_t) WORK_DATA_INIT(); \
    INIT_LIST_HEAD(&(_work)->entry);   \
    (_work)->func = (_func);    \
} while (0)
```

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
