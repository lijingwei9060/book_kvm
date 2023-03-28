Linux kernel 时钟子系统功能上包括如下工作：
1. 显时功能(time library)：对外提供当前的时间。OS的时间受到休眠、ntp的影响存在多种类型。内核里面时间都是从1972年开始算起，保存的是经过的秒数和ns，经过转换成现实世界的时间。
   1. wall time(xtime): 墙上时间，收到ntp和人为调整的影响，是真实世界的时间。
   2. monotonic time(mono_time): 单调递增，休眠的时候不增长，受ntp调整影响，只能增长不能回退。
   3. raw monotonic time(raw_mono): 类似monotonic，把休眠的时间也计算进去。
   4. boot time(): 单调递增，这个时间不受到休眠和ntp的影响，表示服务器开机后的时间。这个非常重要，需要计算准确的时间间隔需要使用这个时间。
2. 定时器管理(timer library): 到达某个时间点调用回调函数。具体分为`hrtimer`高精度定时器(ns纳秒级)和低精度定时器(ms毫秒级)。
3. 时钟源设备(`clock_source`)管理：时钟源设备是可以从中读取时间的设备，只读。内核使用一条链表(`clocksource_list`)对一些列的时钟源设备(`clocksource`)按照rating进行倒序排列进行管理，包括选择一个最佳(rating最高)的时钟源为系统计时、增删改查时钟源设备、时钟源设备变更的时候需要通知`tick_shed`层切换计时设备。
   1. 在X86架构下有哪些时钟源：PIT/HPET/RTC/PM-APIC/TSC
   2. ARM架构下的时钟源: 
   3. kvm虚拟化下的时钟源：
   4. hyperv虚拟化下的时钟源：
4. 时钟事件设备(`clock_event_device)`管理： tick设备是可以周期性(perodic)或者一次性(oneshot)发出中断信号通知CPU响应的设备。 内核通过一条链表(`clockevent_devices`)管理一些列时钟事件设备(clock_event_device)，通过对硬件编程实现定时或者周期性tick事件，驱动时间更新。上面提到的时钟源设备基本也是`clock_event_device`。 根据中断信号的发送范围分为全局和local的， `lapic_clockevent`是cpu核内部的设备，对本cpu发送中断，一些特殊情况需要向其他cpu发送中断。
   1. 设备有： `lapic_clockevent`，
5. tick层是建立在时钟源和时钟事件设备管理层之上的虚拟管理层，定期(HZ)或者根据需要(no_HZ)进行发出tick，所以对下要管理`clock_event_device`设置周期性或者单次中断, 对上通过tick推动检查timer是否超时，推动`timekeeping`层更新时间。每个cpu都有对应tick的`tick_device`，每个`tick_device`对应一个`clock_event_device`，在时钟时间设备层发生设备变更时会触发tick层选出最优的tick设备。根据职能，有cpu内的tick设备，有全局的tick设备，有广播的tick设备。
6. `timekeeping`层就是提供time library的管理层，`timekeeper`对应一个`clocksource`, 底层设备层变化会推动`timekeeper`选举新的时钟源。它的重要作用就是更新`tkr_mono`, `tkr_raw`, `boot_time`, `xtime`。

todo:来个框架图
