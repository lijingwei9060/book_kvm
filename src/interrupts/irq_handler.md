# isr管理

## 中断线程化

最近在为3.8版本的Linux内核打RT_PREEMPT补丁，并且优化系统实时性，这篇文章主要对RTlinux中中断线程化部分进行分析。我们知道在RT_PREEMPT补丁中之所以要将中断线程化就是因为硬中断的实时性太高，会影响实时进程的实时性，所以需要将中断处理程序线程化并设置优先级，使中断处理线程的优先级比实时进程优先级低，从而提高系统实时性。

网上看到一些网友说在2.6.25.8版本的内核，linux引入了中断线程化，具体是不是2.6.25.8版本开始引入中断线程化我没有去求证，因为版本比较老了改动很多，但据我的查证从2.6.30开始内核引入request_threaded_irq函数，从这个版本开始可以通过在申请中断时为request_irq设置不同的参数决定是否线程化该中断。而在2.6.39版内核__setup_irq引入irq_setup_forced_threading函数，开始可以通过#  define force_irqthreads(true)强制使中断线程化，那么从这个版本开始想实现中断线程化就已经变得很简单了，让force_irqthreads为真即可，所以在3.8版本的实时补丁中，正是这一段代码实现了中断的线程

Linux 中断处理分为顶半部（top half）和底半部(bottom half)，一般要求在顶半部里处理优先级比较高的事情，处理时间应尽量短，在处理完成后就激活底半部，在底半处部理其余任务。底半部的处理方式主要有soft_irq, tasklet, workqueue三种，它们的使用方式和适用情况各有不同。

soft_irq 用在对执行时间要求比较紧急或者非常重要的场合。 tasklet 和 work queue 在普通的driver里用的较多，主要区别是tasklet是在中断环境中执行，而work queue 则是在进程中执行，因此可以使用sleep()。

Linux 中断的优先级比进程高，一旦中断过来普通进程实时进程通通都要给中断处理程序让路，如果顶半部处理任务较多就会对实时进程造成很大的影响，并且这种影响存在较大的不确定性因此难以准确评估。为了解决这些实时性相关问题，Linux RT_PREEMPT 补丁引入了中断线程化的机制。在新的机制中，中断虽然还会打断实时进程，但中断处理程序所执行的操作仅仅是唤醒中断线程，原本的中断服务程序主体放到一个内核线程中延迟执行，这样中断执行的速度就很快也很确定，实时进程被打断后可以迅速再次运行，而中断服务程序会在实时进程挂起之后被系统调度执行。

Linux 2.6.30里，在ingo molnar的RT tree里存在有一段时间的interrupt thread终于merge到mainline了。此时如果使用request_threaded_irq申请的中断，handler 不是在中断环境里执行，而是在新创建的线程里执行，这样该handler非常像执行workqueue，拥有所有work queue的特性，但是省掉了创建、初始化、调度workqueue的步骤，处理起来非常简单。

## 中断处理程序

irqaction
irq_desc:代表irq的描述
irq_data
irq_chip: 代表中断控制器，保存了一堆的回调方法
irq_domain： 将中断控制器local的物理中断号转换成Linux全局的虚拟中断号的机制
irq_domain_ops: irq与hwirq的映射关系

irq_affinity_notify

### irq_domain

```C
struct irq_domain {
	const char *name;
	const struct irq_domain_ops *ops;
	irq_hw_number_t hwirq_max;
	struct radix_tree_root revmap_tree;
	unsigned int revmap_size;
	unsigned int linear_revmap[];
	unsigned int revmap_direct_max_irq;
};
```
- "revmap_tree"只对radix tree有意义，revmap_size和linear_revmap[]只对线性映射有意义，revmap_direct_max_irq则只对硬件映射有意义。
- revmap_tree:  Radix tree其实是一种稀疏的多级数组，当IRQ的总数减少时，它所需节点的总数也减少，就可以退化成单级数组，也就是线性映射(linear)，hwirq作为"linear_revmap[]"数组的下标，irq作为该数组元素的值。可见，系统可能的最大IRQ的总数(用"hwirq_max"表示)是决定采用哪种数据结构的依据，其分界线一般为256，大于256采用radix tree映射，小于256则采用线性映射。在大多数系统中，IRQ的总数都不会超过256，所以实际应用以线性映射居多。
- linear_revmap:  线性映射的优点是查找时间固定，但要求数组大小必须等于"hwirq_max"的大小，假设"hwirq_max"的值是64，即便现在只有0和63两个中断，中间暂未使用的部分也需要连续占满。Radix tree映射的优缺点与之正好相反。

```C
struct irq_domain_ops {
	int (*match)(struct irq_domain *d, struct device_node *node, enum irq_domain_bus_token bus_token);
	int (*xlate)(struct irq_domain *d, struct device_node *node, const u32 *intspec, unsigned int intsize,  unsigned long *out_hwirq, unsigned int *out_type);
	int (*map)(struct irq_domain *d, unsigned int virq, irq_hw_number_t hw);
	void (*unmap)(struct irq_domain *d, unsigned int virq);
}
```

- match"是判断dts中由"node"描述的中断控制器是否和由"d"指向的irq_domain相匹配。
- xlate"代表translate，但它并不是用来将物理中断号"翻译"成虚拟中断号的，那是"map"干的事("xlate"和"map"在英文里的语义比较像，确实容易产生歧义)。"xlate"的真正作用是根据dts的信息生成"hwirq"，比如ARM里SPI(Shared Peripheral Interrupt)类型的中断是从0开始编号的，但由于中断控制器GIC的前面32个中断号另有他用，因而SPI中断实际的"hwirq"应该是dts中的编号加上32。在"xlate"的函数参数中，"node"代表dts中对应的设备节点，"out_hwirq"是翻译后形成的硬件中断号。
### irq_chip: 中断控制器

- name是中断控制器的名称，就是在"/proc/interupts"中看到的那个，比如"IO-APIC"。
- irq_enable/irq_unmask用于中断使能，
- irq_disable/irq_mask用于中断屏蔽。
- ipi_send_single表示这个IPI是发给单独的一个CPU，
- ipi_send_mask表示IPI是发给mask范围内是所有CPU。
```C
struct irq_chip {
	const char    *name;
	void	     (*irq_enable)(struct irq_data *data);
	void	     (*irq_disable)(struct irq_data *data);
	void	     (*irq_mask)(struct irq_data *data);
	void	     (*irq_unmask)(struct irq_data *data);

	void	     (*ipi_send_single)(struct irq_data *data, unsigned int cpu);
	void	     (*ipi_send_mask)(struct irq_data *data, const struct cpumask *dest);
	...
};
```

### irqaction： IRQ对应的中断处理函数(ISR - Interrupt Service Routine)

```C
struct irqaction {
    void (*handler)(int, void *, struct pt_regs *);
    unsigned long flags;
    unsigned long mask;
    const char *name;
    void *dev_id;
    struct irqaction *next;
};
```
- handler: 中断处理的入口函数，handler 的第一个参数是中断号，第二个参数是设备对应的ID，第三个参数是中断发生时由内核保存的各个寄存器的值。
- flags: 标志位，用于表示 irqaction 的一些行为，例如是否能够与其他硬件共享IRQ线。
- name: 用于保存中断处理的名字。
- dev_id: 设备ID。
- next: 每个硬件的中断处理入口对应一个 irqaction 结构，由于多个硬件可以共享同一条IRQ线，所以这里通过 next 字段来连接不同的硬件中断处理入口。

### irq_desc: irq的描述
```C
/**
 * struct irq_desc - interrupt descriptor
 * @irq_common_data:	per irq and chip data passed down to chip functions
 * @kstat_irqs:		irq stats per cpu
 * @handle_irq:		highlevel irq-events handler
 * @action:		the irq action chain
 * @status_use_accessors: status information
 * @core_internal_state__do_not_mess_with_it: core internal status information
 * @depth:		disable-depth, for nested irq_disable() calls
 * @wake_depth:		enable depth, for multiple irq_set_irq_wake() callers
 * @tot_count:		stats field for non-percpu irqs
 * @irq_count:		stats field to detect stalled irqs
 * @last_unhandled:	aging timer for unhandled count
 * @irqs_unhandled:	stats field for spurious unhandled interrupts
 * @threads_handled:	stats field for deferred spurious detection of threaded handlers
 * @threads_handled_last: comparator field for deferred spurious detection of threaded handlers
 * @lock:		locking for SMP
 * @affinity_hint:	hint to user space for preferred irq affinity
 * @affinity_notify:	context for notification of affinity changes
 * @pending_mask:	pending rebalanced interrupts
 * @threads_oneshot:	bitfield to handle shared oneshot threads
 * @threads_active:	number of irqaction threads currently running
 * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
 * @nr_actions:		number of installed actions on this descriptor
 * @no_suspend_depth:	number of irqactions on a irq descriptor with
 *			IRQF_NO_SUSPEND set
 * @force_resume_depth:	number of irqactions on a irq descriptor with
 *			IRQF_FORCE_RESUME set
 * @rcu:		rcu head for delayed free
 * @kobj:		kobject used to represent this struct in sysfs
 * @request_mutex:	mutex to protect request/free before locking desc->lock
 * @dir:		/proc/irq/ procfs entry
 * @debugfs_file:	dentry for the debugfs file
 * @name:		flow handler name for /proc/interrupts output
 */
struct irq_desc {
	struct irq_common_data	irq_common_data;
	struct irq_data		irq_data;
	unsigned int __percpu	*kstat_irqs;
	irq_flow_handler_t	handle_irq;
	struct irqaction	*action;	/* IRQ action list */
	unsigned int		status_use_accessors;
	unsigned int		core_internal_state__do_not_mess_with_it;
	unsigned int		depth;		/* nested irq disables */
	unsigned int		wake_depth;	/* nested wake enables */
	unsigned int		tot_count;
	unsigned int		irq_count;	/* For detecting broken IRQs */
	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
	unsigned int		irqs_unhandled;
	atomic_t		threads_handled;
	int			threads_handled_last;
	raw_spinlock_t		lock;
	struct cpumask		*percpu_enabled;
	const struct cpumask	*percpu_affinity;
	const struct cpumask	*affinity_hint;
	struct irq_affinity_notify *affinity_notify;
	cpumask_var_t		pending_mask;
	unsigned long		threads_oneshot;
	atomic_t		threads_active;
	wait_queue_head_t       wait_for_threads;
	unsigned int		nr_actions;
	unsigned int		no_suspend_depth;
	unsigned int		cond_suspend_depth;
	unsigned int		force_resume_depth;
	struct proc_dir_entry	*dir;
	struct dentry		*debugfs_file;
	const char		*dev_name;
	struct rcu_head		rcu;
	struct kobject		kobj;
	struct mutex		request_mutex;
	int			parent_irq;
	struct module		*owner;
	const char		*name;
}
```

- name是这个IRQ的名称，同样可以在"/proc/interupts"中查看，如timer、acpi、rtc0等。
- depth是关闭该IRQ的嵌套深度，正值表示禁用中断，而0表示可启用中断。
- action是IRQ对应的中断处理函数(ISR - Interrupt Service Routine)，按理ISR应该就是一个函数指针，可这里确是一个指向struct irqaction的指针。
## 数据结构
驱动注册中断处理函数： 

request_irq(irq, handler, flags, name, dev)
|-- request_threaded_irq(irq, handler, NULL, flags, name, dev)
    |-- irq_to_desc(irq)
    |-- irq_chip_pm_get(&desc->irq_data)
    |-- __setup_irq(irq, desc, action)
        irq_settings_is_nested_thread(desc)
        irq_setup_forced_threading(new)
        setup_irq_thread(new, irq, false)
        

```C
/* request_irq: 分配一条给定的中断线 */
int request_irq(unsigned int irq,  /* 要分配的中断号 */
                irqreturn_t (*handler)(int, void *, struct pt_regs *), /* 指向实际中断处理程序, 收到中断时由内核调用 */
                unsigned long irqflags, /* 标志位 */
                const char* devname, /* 中断相关的设备ASCII文本表示法 */
                void *dev_id); /* 用于共享中断线 */
```

- irq 表示要分配的中断号。对某些设备，该值通常预先固定的；对于大部分设备，该值可以探测，或者通过编程动态决定。
- handler 一个函数指针，指向该中断的实际中断处理程序。OS收到中断，该函数就会被调用。
- irqflags 可以为0，也可以是下面一个或多个标志的位掩码：
    - 1）SA_INTERRUPT 表明给定的中断处理程序是一个快速中断处理程序（fast interrupt handler），默认不带该标志。过去，Linux将中断处理程序分为快速和慢速两种。哪些可以迅速执行但调用频率可能会很高的中断处理程序会贴上这样的标签。这样做，通常需要修改中断处理程序的行为，使得它们能尽可能快地执行。现在，加不加此标志的区别只剩一条：在本地处理器上，快速中断处理程序在禁止所有中断的情况下运行。好处是可以快速执行，不受其他中断干扰。默认没有该标志，除了正运行的中断处理程序对应那条中断线，其他所有中断都是激活的。除了时钟中断，绝大多数中断都不使用该标志。
    - 2）SA_SAMPLE_RANDOM 表明该设备产生的中断对内核熵池（entropy pool）有贡献。内核熵池负责提供从各种随机事件导出真正的随机数。如果指定该标志，那么来自该设备的中断时间间隔就会作为熵填充到熵池。如果你的设备以预知的速率产生中断（如系统定时器），或可能受到外部攻击（如网卡）的影响，那么就不要设置该标志。
    - 3）SA_SHIRQ 表明可以在多个中断处理程序之间共享中断线。在同一个给定线上注册的每个处理程序必须指定这个标志；否则，在每条线上只能有一个处理程序。
- devname 与中断相关的设备的ASCII文本表示法。例如，PC机上键盘中断对应的这个值为“keyboard”。这些名字会被/proc/irq和/proc/interrupt文件使用，以便与用户通信。
- dev_id 用于共享中断线。当一个中断处理程序需要释放时，dev_id将提供唯一的标志信息（cookie），以便从共享中断线的诸多中断处理程序中删除指定的那一个。如果没有该参数，那么内核不可能知道在给定的中断线上到底要删除哪个处理程序。如果无需共享中断线，那么该参数置为NULL即可；如果需要共享，那么必须传递唯一的信息。除非设备又旧又破且位于ISA总线上，那么必须支持共享中断。另外，内核每次调用中断处理程序时，都会把这个指针传递给它（中断处理程序都是预先在内核进行注册的回调函数（callback function）），不同的函数位于不同的驱动程序中，因此这些函数共享同一个中断线时，内核必须准确为它们创造执行环境，此时就可以通过该指针将有用的环境信息传递给它们了。实践中，往往通过它传递驱动程序的设备结构：这个指针是唯一的，而且有可能在中断处理程序内及设备模式中被用到。

返回值：request_irq()执行成功时，返回0；出错时，返回非0，指定的中断处理程序不会被注册。常见错误-EBUSY，表示给定的中断线已经在使用（或当期用户或者你没有指定SA_SHIRQ）。

注意：request_irq()可能会睡眠，因此不能在中断上下文或其他不允许阻塞的代码中调用。

request_irq()为什么会睡眠？因为在注册过程中，内核需要在/proc/irq文件创建一个与中断对应的项。proc_mkdir()就是用来创建这个新的procfs项的，proc_mkdir()通过调用proc_create()对这个新的profs项进行设置，而proc_create()会调用kmalloc()来请求分配内存。kmalloc()是可以睡眠的。

通过request_irq()注册中断处理程序典型应用：
```C
if (request_irq(irqn, my_interrupt, SA_SHIRQ, "my_device", dev)) { // not 0: error
    printk(KERN_ERR "mydevice:cannot register IRQ %d\n", irqn);
    return -EIO;
}
```
irqn 请求的中断线，my_interrupt 中断处理程序，"my_device" 设备名称，通过dev_id传递dev结构体。返回非0，则表示注册失败；返回0，表示注册成功，响应中断时处理程序会被调用。

释放中断处理程序: 卸载驱动程序，需要注销相应的中断处理程序，并释放中断线。调用：`void free_irq(unsigned int irq, void* dev_id)`
如果指定的中断线不是共享的，那么该函数将删除处理程序同时禁用该中断线；如果是共享的，则仅删除dev_id对应的处理程序，而这条中断线只有在删除了最后一个处理程序时才会被禁用。这也是dev_id必须唯一的原因：共享的中断线中，用来区分不同的处理程序。

必须从进程上下文中调用free_irq();

### request_threaded_irq


```C
int request_threaded_irq(unsigned int irq, irq_handler_t handler,
			 irq_handler_t thread_fn, unsigned long irqflags,
			 const char *devname, void *dev_id)
```


- irq	要注册handler的那个IRQ number。这里要注册的handler包括两个，一个是传统意义的中断handler，我们称之primary handler，另外一个是threaded interrupt handler
- handler	primary handler。需要注意的是primary handler和threaded interrupt handler不能同时为空，否则会出错
- thread_fn	threaded interrupt handler。如果该参数不是NULL，那么系统会创建一个kernel thread，调用的function就是thread_fn
- irqflags
- devname	 
- dev_id
- 输出参数描述: 0表示成功执行，负数表示各种错误原因。

Interrupt type flags

- `IRQF_TRIGGER_XXX`	描述该interrupt line触发类型的flag
- `IRQF_DISABLED`	首先要说明的是这是一个废弃的flag，在新的内核中，该flag没有任何的作用了。具体可以参考：Disabling IRQF_DISABLED
旧的内核（2.6.35版本之前）认为有两种interrupt handler：slow handler和fast handle。在request irq的时候，对于fast handler，需要传递`IRQF_DISABLED`的参数，确保其中断处理过程中是关闭CPU的中断，因为是fast handler，执行很快，即便是关闭CPU中断不会影响系统的性能。但是，并不是每一种外设中断的handler都是那么快（例如磁盘），因此就有 slow handler的概念，说明其在中断处理过程中会耗时比较长。对于这种情况，在执行interrupt handler的时候不能关闭CPU中断，否则对系统的performance会有影响。新的内核已经不区分slow handler和fast handle，都是fast handler，都是需要关闭CPU中断的，那些需要后续处理的内容推到threaded interrupt handler中去执行。
- `IRQF_SHARED`:这是flag用来描述一个interrupt line是否允许在多个设备中共享。如果中断控制器可以支持足够多的interrupt source，那么在两个外设间共享一个interrupt request line是不推荐的，毕竟有一些额外的开销（发生中断的时候要逐个询问是不是你的中断，软件上就是遍历action list），因此外设的irq handler中最好是一开始就启动判断，看看是否是自己的中断，如果不是，返回IRQ_NONE,表示这个中断不归我管。 早期PC时代，使用8259中断控制器，级联的8259最多支持15个外部中断，但是PC外设那么多，因此需要irq share。现在，ARM平台上的系统设计很少会采用外设共享IRQ方式，毕竟一般ARM SOC提供的有中断功能的GPIO非常的多，足够用的。 当然，如果确实需要两个外设共享IRQ，那也只能如此设计了。对于HW，中断控制器的一个interrupt source的引脚要接到两个外设的interrupt request line上，怎么接？直接连接可以吗？当然不行，对于低电平触发的情况，我们可以考虑用与门连接中断控制器和外设。
- `IRQF_PROBE_SHARED`	IRQF_SHARED用来表示该interrupt action descriptor是允许和其他device共享一个interrupt line（IRQ number），但是实际上是否能够share还是需要其他条件：例如触发方式必须相同。有些驱动程序可能有这样的调用场景：我只是想scan一个irq table，看看哪一个是OK的，这时候，如果即便是不能和其他的驱动程序share这个interrupt line，我也没有关系，我就是想scan看看情况。这时候，caller其实可以预见sharing mismatche的发生，因此，不需要内核打印“Flags mismatch irq……“这样冗余的信息
- `IRQF_PERCPU`	在SMP的架构下，中断有两种mode，一种中断是在所有processor之间共享的，也就是global的，一旦中断产生，interrupt controller可以把这个中断送达多个处理器。当然，在具体实现的时候不会同时将中断送达多个CPU，一般是软件和硬件协同处理，将中断送达一个CPU处理。但是一段时间内产生的中断可以平均（或者按照既定的策略）分配到一组CPU上。这种interrupt mode下，interrupt controller针对该中断的operational register是global的，所有的CPU看到的都是一套寄存器，一旦一个CPU ack了该中断，那么其他的CPU看到的该interupt source的状态也是已经ack的状态。和global对应的就是per cpu interrupt了，对于这种interrupt，不是processor之间共享的，而是特定属于一个CPU的。例如GIC中interrupt ID等于30的中断就是per cpu的（这个中断event被用于各个CPU的local timer），这个中断号虽然只有一个，但是，实际上控制该interrupt ID的寄存器有n组（如果系统中有n个processor），每个CPU看到的是不同的控制寄存器。在具体实现中，这些寄存器组有两种形态，一种是banked，所有CPU操作同样的寄存器地址，硬件系统会根据访问的cpu定向到不同的寄存器，另外一种是non banked，也就是说，对于该interrupt source，每个cpu都有自己独特的访问地址。
- `IRQF_NOBALANCING`	这也是和multi-processor相关的一个flag。对于那些可以在多个CPU之间共享的中断，具体送达哪一个processor是有策略的，我们可以在多个CPU之间进行平衡。如果你不想让你的中断参与到irq balancing的过程中那么就设定这个flag
- `IRQF_IRQPOLL`	 
- `IRQF_ONESHOT`	one shot本身的意思的只有一次的，结合到中断这个场景，则表示中断是一次性触发的，不能嵌套。对于primary handler，当然是不会嵌套，但是对于threaded interrupt handler，我们有两种选择，一种是mask该interrupt source，另外一种是unmask该interrupt source。一旦mask住该interrupt source，那么该interrupt source的中断在整个threaded interrupt handler处理过程中都是不会再次触发的，也就是one shot了。这种handler不需要考虑重入问题。
具体是否要设定one shot的flag是和硬件系统有关的，我们举一个例子，比如电池驱动，电池里面有一个电量计，是使用HDQ协议进行通信的，电池驱动会注册一个threaded interrupt handler，在这个handler中，会通过HDQ协议和电量计进行通信。对于这个handler，通过HDQ进行通信是需要一个完整的HDQ交互过程，如果中间被打断，整个通信过程会出问题，因此，这个handler就必须是one shot的。
IRQF_NO_SUSPEND	这个flag比较好理解，就是说在系统suspend的时候，不用disable这个中断，如果disable，可能会导致系统不能正常的resume。
IRQF_FORCE_RESUME	在系统resume的过程中，强制必须进行enable的动作，即便是设定了IRQF_NO_SUSPEND这个flag。这是和特定的硬件行为相关的。
IRQF_NO_THREAD	有些low level的interrupt是不能线程化的（例如系统timer的中断），这个flag就是起这个作用的。另外，有些级联的interrupt controller对应的IRQ也是不能线程化的（例如secondary GIC对应的IRQ），它的线程化可能会影响一大批附属于该interrupt controller的外设的中断响应延迟。
- `IRQF_EARLY_RESUME`	 
- `IRQF_TIMER`

(irqflags & IRQF_SHARED) && !dev_id  对于那些需要共享的中断，在request irq的时候需要给出dev id，否则会出错退出。为何对于IRQF_SHARED的中断必须要给出dev id呢？实际上，在共享的情况下，一个IRQ number对应若干个irqaction，当操作irqaction的时候，仅仅给出IRQ number就不是非常的足够了，这时候，需要一个ID表示具体的irqaction，这里就是dev_id的作用了。当释放一个IRQ资源的时候，不但要给出IRQ number，还要给出device ID。只有这样，才能精准的把要释放的那个irqaction 从irq action list上移除。linux interrupt framework虽然支持中断共享，但是它并不会协助解决识别问题，它只会遍历该IRQ number上注册的irqaction的callback函数，这样，虽然只是一个外设产生的中断，linux kernel还是通过`__handle_irq_event_percpu(struct irq_desc *desc)`把所有共享的那些中断handler都逐个调用执行。为了让系统的performance不受影响，irqaction的callback函数必须在函数的最开始进行判断，是否是自己的硬件设备产生了中断（读取硬件的寄存器），如果不是，尽快的退出。需要注意的是，这里dev_id并不能在中断触发的时候用来标识需要调用哪一个irqaction的callback函数，通过上面的代码也可以看出，dev_id有些类似一个参数传递的过程，可以把具体driver的一些硬件信息，组合成一个structure，在触发中断的时候可以把这个structure传递给中断处理函数。

irq_to_desc(irq): 通过IRQ number获取对应的中断描述符。在引入CONFIG_SPARSE_IRQ选项后，这个转换变得不是那么简单了。在过去，我们会以IRQ number为index，从irq_desc这个全局数组中直接获取中断描述符。如果配置CONFIG_SPARSE_IRQ选项，则需要从radix tree中搜索。

irq_settings_can_request(desc): 并非系统中所有的IRQ number都可以request，有些中断描述符被标记为IRQ_NOREQUEST，标识该IRQ number不能被其他的驱动request。一般而言，这些IRQ number有特殊的作用，例如用于级联的那个IRQ number是不能request。irq_settings_can_request函数就是判断一个IRQ是否可以被request。

irq_settings_is_per_cpu_devid函数用来判断一个中断描述符是否需要传递per cpu的device ID。如果一个中断描述符对应的中断 ID是per cpu的，那么在申请其handler的时候就有两种情况，一种是传递统一的dev_id参数（传入request_threaded_irq的最后一个参数），另外一种情况是针对每个CPU，传递不同的dev_id参数。在这种情况下，我们需要调用request_percpu_irq接口函数而不是request_threaded_irq。

irq_default_primary_handler: 系统会帮忙设定一个default的primary handler，协助唤醒threaded handler线程。

__setup_irq: 进行实际的注册过程

### __setup_irq

工作过程：
1. nested IRQ的处理: 如果一个中断描述符是nested thread type的，说明这个中断描述符应该设定threaded interrupt handler（当然，内核是不会单独创建一个thread的，它是借着其parent IRQ的interrupt thread执行），否则就会出错返回。对于primary handler，它应该没有机会被调用到，当然为了调试，kernel将其设定为irq_nested_primary_handler，以便在调用的时候打印一些信息，让工程师直到发生了什么状况。
2. forced irq threading处理:将系统中所有可以被线程化的中断handler全部线程化，即便你在request irq的时候，设定的是primary handler，而不是threaded handler。当然那些不能被线程化的中断（标注了IRQF_NO_THREAD的中断，例如系统timer）还是排除在外的。
   1. 系统中有一个强制线程化的选项：`CONFIG_IRQ_FORCED_THREADING`，如果没有打开该选项，`force_irqthreads()`总是0，因此irq_setup_forced_threading也就没有什么作用，直接return了。如果打开了`CONFIG_IRQ_FORCED_THREADING`，说明系统支持强制线程化，但是具体是否对所有的中断进行强制线程化处理还是要看命令行参数`threadirqs`。如果kernel启动的时候没有传入该参数，那么同样的，irq_setup_forced_threading也就没有什么作用，直接return了。只有bootloader向内核传入threadirqs这个命令行参数，内核才真正在启动过程中，进行各个中断的强制线程化的操作。
   2. 到`IRQF_NO_THREAD`选项你可能会奇怪，前面irq_settings_can_thread函数不是检查过了吗？为何还要重复检查？其实一个中断是否可以进行线程化可以从两个层面看：一个是从底层看，也就是从中断描述符、从实际的中断硬件拓扑等方面看。另外一个是从中断子系统的用户层面看，也就是各个外设在注册自己的handler的时候是否想进行线程化处理。所有的`IRQF_XXX`都是从用户层面看的flag，因此如果用户通过IRQF_NO_THREAD这个flag告知kernel，该interrupt不能被线程化，那么强制线程化的机制还是尊重用户的选择的。`PER CPU`的中断都是一些较为特殊的中断，不是一般意义上的外设中断，因此对`PER CPU`的中断不强制进行线程化。`IRQF_ONESHOT`选项说明该中断已经被线程化了（而且是特殊的one shot类型的），因此也是直接返回了。
   3. 强制线程化只对那些没有设定thread_fn的中断进行处理，这种中断将全部的处理放在了primary interrupt handler中（当然，如果中断处理比较耗时，那么也可能会采用bottom half的机制），由于primary interrupt handler是全程关闭CPU中断的，因此可能对系统的实时性造成影响，因此考虑将其强制线程化。struct irqaction中的thread_flags是和线程相关的flag，我们给它打上`IRQTF_FORCED_THREAD`的标签，表明该threaded handler是被强制threaded的。new->thread_fn = new->handler这段代码表示将原来primary handler中的内容全部放到threaded handler中处理，新的primary handler被设定为default handler。
3. setup_irq_thread创建interrupt线程(irq%d-s-%s), 保存task，设置mask bit。
4. 共享中断的检查，old指向注册之前的action list，如果不是NULL，那么说明需要共享interrupt line。但是如果要共享，需要每一个irqaction都同意共享（IRQF_SHARED），每一个irqaction的触发方式相同（都是level trigger或者都是edge trigger），相同的oneshot类型的中断（都是one shot或者都不是），per cpu类型的相同中断（都是per cpu的中断或者都不是）。将该irqaction挂入队列的尾部。。
5. thread mask的设定：对于one shot类型的中断，我们还需要设定thread mask。如果一个one shot类型的中断只有一个threaded handler（不支持共享），那么事情就很简单（临时变量thread_mask等于0），该irqaction的thread_mask成员总是使用第一个bit来标识该irqaction。但是，如果支持共享的话，事情变得有点复杂。我们假设这个one shot类型的IRQ上有A，B和C三个irqaction，那么A，B和C三个irqaction的thread_mask成员会有不同的bit来标识自己。例如A的thread_mask成员是0x01，B的是0x02，C的是0x04，如果有更多共享的irqaction（必须是oneshot类型），那么其thread_mask成员会依次设定为0x08，0x10……。
   1. 在上面“共享中断的检查”这个section中，thread_mask变量保存了所有的属于该interrupt line的thread_mask，这时候，如果thread_mask变量如果是全1，那么说明irqaction list上已经有了太多的irq action（大于32或者64，和具体系统和编译器相关）。如果没有满，那么通过ffz函数找到第一个为0的bit作为该irq action的thread bit mask。
   2. irq_default_primary_handler直接返回IRQ_WAKE_THREAD，让kernel唤醒threaded handler就OK了。使用irq_default_primary_handler虽然简单，但是有一个风险：如果是电平触发的中断，我们需要操作外设的寄存器才可以让那个asserted的电平信号消失，否则它会一直持续。一般，我们都是直接在primary中操作外设寄存器（slow bus类型的interrupt controller不行），尽早的clear interrupt，但是，对于irq_default_primary_handler，它仅仅是wakeup了threaded interrupt handler，并没有clear interrupt，这样，执行完了primary handler，外设中断仍然是asserted，一旦打开CPU中断，立刻触发下一次的中断，然后不断的循环。因此，如果注册中断的时候没有指定primary interrupt handler，并且没有设定IRQF_ONESHOT，那么系统是会报错的。当然，有一种情况可以豁免，当底层的irq chip是one shot safe的（IRQCHIP_ONESHOT_SAFE）。
6. 用户IRQ flag和底层interrupt flag的同步


### irq_wake_thread

## NMI处理

场景： 硬件通过nmi针脚发给cpu的或者收到apic发来的nmi。
终端初始化的时候注册了nmi handler和nmi_stack,`set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK)`。
写的很好，但是看不懂。https://0xax.gitbooks.io/linux-insides/content/Interrupts/linux-interrupts-6.html

## 中断处理程序

中断源的处理过程包含： Inactive，Pending，Active，Active and Pending四中状态。

中断源没有被assert(触发)的时候，处于初始的"Inactive"状态。如果某个中断源被触发，GIC会将IAR寄存器(Interrupt Acklowlege Register)中该中断源对应的bit置1，然后通知CPU core(PE)。在CPU尚未做出应答之前，该中断源处于"Pending"(待处理)状态。这里IAR可理解为中断标志寄存器。

在Pending状态中，GIC会关闭对该中断源的响应，在此期间，如果该中断源上有新的中断到来，所有连接GIC的CPU都无法收到。因为GIC是中断源和CPU之间的桥梁，GIC已经在桥的这一头挡住了中断源，在桥的另一头的CPU自然是没办法接收的。。


一个典型的中断处理程序声明：`static irqreturn_t intr_handler(int irq, void *dev_id, struct pt_regs *regs)`, 其签名必须与request_irq()中参数handler所要求函数类型一致。

参数说明：

- irq 该处理程序要响应的中断的中断线号。目前，没有太大用处，可能打印LOG时会用到。内核2.0之前，因为没有dev_id参数，必须通过irq才能区分使用相同中断程序、相同的中断处理程序的多个设备。如，具有多个相同类型硬盘驱动控制器的计算机。
- dev_id 与中断处理程序注册时传递给request_irq()的参数dev_id必须一致。如果该值具有唯一确定性（建议采用这样的值，以便支持共享），那么它就相当于一个cookie，可以用来区分共享同一个中断处理程序的多个设备。另外，dev_id也可能指向一个中断处理程序使用的一个数据结构，对每个设备而言，设备结构都是唯一的。
- regs 指向结构的指针，包含处理中断前处理器的寄存器和状态。除了调试，其他时候很少使用。

返回值：irqerturn_t实际是int类型，为了与早期内核兼容，因为2.6以前实际是void类型。可能返回2个特殊值：`IRQ_NONE`和`IRQ_HANDLED`。当中断处理程序检测到一个中断，但该中断并非注册处理函数时指定的产生源时，返回IRQ_NONE；当中断处理程序被正确调用，而且确实是它所对应的设备产生的中断时，返回IRQ_HANDLED。返回值也可以用宏IRQ_RETVAL(x)：x为非0，宏返回IRQ_HANDLED；x为0，返回IRQ_NONE。

定义说明：中断处理程序通常标记为static，因为从来不会在其他文件被直接调用。

可重入性
Linux中中断处理程序无需重入。当一个给定的中断处理程序正在执行时，相应的中断线在所有处理器上都会被屏蔽，以防在同一个中断线上接收另一个新的中断。也就是说，同一个中断线，同一个中断处理程序，在执行完毕之前不可能同时在2个处理器上执行，加上中断处理程序不能休眠，因此无需考虑可重入性。
注意：
1）如果中断处理程序可以被中断（不是同一个中断线的中断），称为嵌套中断，或中断嵌套。
2）旧版本Linux允许中断嵌套，但2010以后提交的版本中，已经禁止了中断嵌套。


共享的和非共享的处理程序，注册和运行方式相似，差异主要有三点：
1）request_irq()的参数flgs必须设置`SA_SHIRQ`标志。
2）对每个注册的中断处理程序来说，dev_id参数必须唯一。指向任一设备结构的指针就可以满足这一要求；通常会选设备结构，因为它是唯一的，而且中断处理性可能会用到。不能给共享的处理程序传递NULL值。
3）中断处理程序必须能区分其设备是否真正产生中断。既需要硬件支持，也需要处理程序中有相关的处理逻辑。

所有共享中断线的驱动程序，都必须满足以上要求。否则，中断线无法共享。

## ISR的执行

- irq_find_mapping()：根据物理中断号"hwirq"的值，查找包含映射关系的radix tree或者线性数组，得到"hwirq"对应的虚拟中断号"irq"。
- generic_handle_irq(): 回调IRQ之前安装的第一级处理函数(desc->handle_irq), 对于电平触发，注册的"handle_irq"是handle_level_irq()。对于边沿触发，注册的"handle_irq"是handle_edge_irq()(相关代码位于"/kernel/irq/chip.c")。
- action->handler: 进入第二级的处理函数，这里需要判断是不是自己的设备产生的中断
- __irq_wake_thread： 唤醒线程


### X86

irqentry_state_t state = irqentry_enter(regs); // 分别用于标记ISR的进入和退出
u32 vector = (u32)(u8)error_code;
instrumentation_begin();
kvm_set_cpu_l1tf_flush_l1d();
run_irq_on_irqstack_cond(__##func, regs, vector);
    set_irq_regs(regs)
    handle_irq(desc, regs)
        64bit => generic_handle_irq_desc(desc) => desc->handle_irq(desc) // 回调IRQ之前安装的第一级处理函数(desc->handle_irq),对于电平触发，注册的"handle_irq"是handle_level_irq()。对于边沿触发，注册的"handle_irq"是handle_edge_irq()(相关代码位于"/kernel/irq/chip.c")
            handle_irq_event(desc)
                handle_irq_event_percpu(desc)
        32bit => __handle_irq(desc, regs)
    ack_APIC_irq(); => VECTOR_UNUSED
    set_irq_regs(old_regs)
instrumentation_end();
irqentry_exit(regs, state); // 分别用于标记ISR的进入和退出