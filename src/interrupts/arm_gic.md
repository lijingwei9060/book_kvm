# 概述 

硬件拓扑

IO：寄存器

## 数据结构

## 初始化过程

## 管理过程

1. gic_handle_irq()就是GIC中断处理的入口了，它首先通过gic_read_iar()读取IAR寄存器做出ACK应答，而后判断中断源的类型。如果中断号小于16，说明是SGI，那么就按照IPI核间中断的方式进行处理，当然前提是这是一个SMP的系统。如果中断号介于16和1020之间，或者大于8192，说明是PPI, SPI或者LPI，那么就按照普通流程处理。普通流程的入口函数是handle_domain_irq()，它的作用等同于前面文章讲的do_IRQ()。
2. gic_write_eoir()：写EOI寄存器


## GIC触发方法

边缘触发和水平触发

### 边缘触发

handle_edge_irq()

对于边沿触发，可以是上升沿触发，可以是下降沿触发，亦或上升沿下降沿都触发。触发后，中断源自动从assert的电平位置(假设为高电平)回落到deassert的电平位置(对应为低电平)，但GIC会保持和CPU之间连线的高电平状态(相当于琐存)，直到CPU做出ACK应答。CPU应答后，GIC和CPU的连线也回落到deassert的电平位置。在CPU处理完毕之前(EOI)，如果该中断源上有第二个中断发生，则进入A&P状态，没有则在处理完后回到Inactive状态。

按照GIC的设计，在A&P阶段，正在处理该中断源的上一个中断的CPU是可以对第二个中断做出应答的，但是按照Linux的中断处理机制，hardirq部分是不允许嵌套的，不光是当前正在处理这个中断源的CPU(设为CPU A)不可以，其他CPU也不可以。

不过GIC已经琐存住了第二个中断的pending信息，让CPU稍后应答也不是什么问题，这第二个中断并不会丢掉。可是Linux作为一个通用的操作系统，是面向多种处理器架构和多种中断控制器的，而并不是所有的中断控制器都提供和GIC一样的功能，所以Linux从软件层面实现了类似的机制。

当处于Active状态的中断源产生第二个中断的时候(进入A&P状态)，Linux会让第二个CPU(设为CPU B)去ACK应答这个中断，然后保存住这个pending信息(相当于软件琐存)，这样该中断源又是Active状态了，CPU B也可以去干自己的事了。

CPU B在应答之后，还会让中断控制器屏蔽掉这个中断源，也就是告诉中断控制器，我们CPU这边已经有pending的了，不再接受该中断源上新的中断了。这个跟GIC在pending了中断源上的一个中断之后，屏蔽该中断源，不再接收这个中断源产生的新的中断，简直一模一样啊，可以把CPU B的行为视作对这一功能的软件模拟。

本来呢，对同一中断源，处在pending状态的中断最多只能有一个，但在ARM+Linux的系统中，由于GIC和Linux分别从硬件层面和软件层面提供了pending功能，所以至多有两个。也就是说，中断是没有排队机制的，这就好像前面文章介绍的不可靠信号一样。

不可靠信号之所以没有排队机制是当时的软件设计使然，而中断没有排队机制一方面是由于硬件资源的限制，一方面是因为本来hardirq的执行时间就是很短的，如果在执行一个hardirq的时间里来了两个及以上的中断，那就算排队了，后面也是处理不过来的。

```C
void handle_edge_irq(struct irq_desc *desc)
{
    raw_spin_lock(&desc->lock);

    /* CPU B */
    //当前有irq在运行，或者被禁止，或没有注册处理函数
    if (!irq_may_run(desc) || irqd_irq_disabled(&desc->irq_data) || !desc->action)) {
        desc->istate |= IRQS_PENDING;
        //mask该中断源
	mask_irq(desc);
	goto out_unlock;
    }

    /* CPU A */
    do {
        // 有pending待处理的中断
        if (unlikely(desc->istate & IRQS_PENDING)) {
            //被其他CPU在之前mask掉了
	    if (!irqd_irq_disabled(&desc->irq_data) && irqd_irq_masked(&desc->irq_data))
	        unmask_irq(desc);
	}
        //处理中断
	handle_irq_event(desc);
    } while ((desc->istate & IRQS_PENDING));
    goto out_unlock;

out_unlock:
	raw_spin_unlock(&desc->lock);
}
```

PU B在ACK应答后进入这个函数，它需要知道当前有无其他CPU正在处理这个中断源(通过IRQD_IRQ_INPROGRESS标志)，如果有(设为CPU A)，那么CPU B将转化为软件琐存的角色，设置IRQS_PENDING标志位，并屏蔽(mask)该中断源。

如果当前没有其他CPU在处理，CPU B还需要看下这个中断源上，驱动有没有注册第二级的处理函数(desc->action)，没有的话也是没法往下走的，也是只能pending并mask。