# isr管理

驱动注册中断处理函数
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

## 中断处理程序

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