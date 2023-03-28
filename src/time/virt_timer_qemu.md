qemu-kvm模拟两个时钟中断设备PIT(i8254)和APIC Timer设备，也就是产生中断源。两者电子线路连接不同，对于i8254设备来说首先连接到i8259中断控制器，i8259中断控制器再连接到ioapic设备中，送到lapic,最后注入到vcpu中。对于APIC Timer设备实际就是lapic的一个功能，意思就是通过编程可以触发lapic设备周期产生中断，然后注入到vcpu。通过上面了解知道两者区别了APIC Timer的是每个cpu内核都有一个定时器，而PIT是共用的一个。
APIC Timer的模式APIC定时器包含3种定时器模式，周期触发periodic和一次性触发one-shot和TSC-Deadline模式(最新的CPU里面支持)。
下面之分析Qemu-kvm模拟APIC Timer周期触发periodic模式中断过程。

1.创建和初始化模拟定时器设备
由于APIC Timer设备实际就是lapic的一个功能，所以在创建lapic设备同时，也就辅助设置了。
```C
int kvm_create_lapic(struct kvm_vcpu *vcpu)
{
 hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
                     HRTIMER_MODE_ABS);
        apic->lapic_timer.timer.function = kvm_timer_fn;
        apic->lapic_timer.t_ops = &lapic_timer_ops;
        apic->lapic_timer.kvm = vcpu->kvm;
        apic->lapic_timer.vcpu = vcpu;
}
```
该如何模拟APIC Timer设备呢？对于周期性时钟中断，我们可以采用定时器方式，一定间隔调用一次中断源产生函数，模拟时钟中断发生。
首先创建一个定时器，然后初始化APIC Timer设备包括对设备的操作，设备属于哪个vcpu和vm,设备额产生中断的函数，实际就是定时器回调函数。

2.启动上面定时器，产生调用回调函数
```C
static void start_apic_timer(struct kvm_lapic *apic)
{
        ktime_t now = apic->lapic_timer.timer.base->get_time();

        apic->lapic_timer.period = (u64)apic_get_reg(apic, APIC_TMICT) *
                    APIC_BUS_CYCLE_NS * apic->divide_count;
        atomic_set(&apic->lapic_timer.pending, 0);

        if (!apic->lapic_timer.period)
                return;
        /*
         * Do not allow the guest to program periodic timers with small
         * interval, since the hrtimers are not throttled by the host
         * scheduler.
         */
        if (apic_lvtt_period(apic)) {
                if (apic->lapic_timer.period < NSEC_PER_MSEC/2)
                        apic->lapic_timer.period = NSEC_PER_MSEC/2;
        }

        hrtimer_start(&apic->lapic_timer.timer,
                      ktime_add_ns(now, apic->lapic_timer.period),
                      HRTIMER_MODE_ABS);
}
```
读取客户机操作系统设置间隔时间，如果没有设置，不调用回调函数。客户机设置值不能太小话，启动主机定时器，按照设置周期，调用回调函数

3。调用回调函数，产生中断
```C
static int __kvm_timer_fn(struct kvm_vcpu *vcpu, struct kvm_timer *ktimer)
{
        int restart_timer = 0;
        wait_queue_head_t *q = &vcpu->wq;

        /*
         * There is a race window between reading and incrementing, but we do
         * not care about potentially loosing timer events in the !reinject
         * case anyway.
         */
        if (ktimer->reinject || !atomic_read(&ktimer->pending)) {
                atomic_inc(&ktimer->pending);
                /* FIXME: this code should not know anything about vcpus */
                set_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
        }
        
        if (waitqueue_active(q))
                wake_up_interruptible(q);

        if (ktimer->t_ops->is_periodic(ktimer)) {
                hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
                restart_timer = 1;
        }
                
        return restart_timer;
}
```
执行atomic_inc(&ktimer->pending)该函数，相当与产生中断。（如果有pending中断，如何不增加计数了吗？还有一个条件要重新注入，注入不成功时，哪些情况造成注入不成功呢）
查看目前等待队列是否为空，不为空，唤醒相应进程，以便下次调度执行相应进程。
如果APIC Timer设备是周期性，再次添加定时器，再次调用回调函数。

4.时钟中断注入
```C
static int __vcpu_run(struct kvm_vcpu *vcpu)
{
   clear_bit(KVM_REQ_PENDING_TIMER, &vcpu->requests);
                if (kvm_cpu_has_pending_timer(vcpu))
                        kvm_inject_pending_timer_irqs(vcpu);
}
/*
 * check if there are pending timer events
 * to be processed.
 */
int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
{                                             
        int ret;

        ret = pit_has_pending_timer(vcpu);
        ret |= apic_has_pending_timer(vcpu);

        return ret;
}
```

下面这两个判断条件 （atomic_read(&lapic->lapic_timer.pending)好像重复，其实不必再判断了。
```C
int apic_has_pending_timer(struct kvm_vcpu *vcpu)
{
        struct kvm_lapic *lapic = vcpu->arch.apic;

        if (lapic && apic_enabled(lapic) && apic_lvt_enabled(lapic, APIC_LVTT))
                return atomic_read(&lapic->lapic_timer.pending);

        return 0;
}
```
读取产生中断，传递中断，成功后清空悬挂中断请求。
```C
void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
{       
        struct kvm_lapic *apic = vcpu->arch.apic;

        if (apic && atomic_read(&apic->lapic_timer.pending) > 0) {
                if (kvm_apic_local_deliver(apic, APIC_LVTT))
                        atomic_dec(&apic->lapic_timer.pending);
        }               
}
```
传递中断到lapci相应功能单元，__apic_accept_irq函数在《qemu-kvm中断虚拟化已分析》
```C
static int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
{                       
        u32 reg = apic_get_reg(apic, lvt_type);
        int vector, mode, trig_mode;

        if (apic_hw_enabled(apic) && !(reg & APIC_LVT_MASKED)) {
                vector = reg & APIC_VECTOR_MASK;
                mode = reg & APIC_MODE_MASK;
                trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
                return __apic_accept_irq(apic, mode, vector, 1, trig_mode);
        }
        return 0;
}
```


[原文](https://blog.csdn.net/zhoujiaxq/article/details/23853575)