虚拟机中时间存在很多问题，如时间跳跃，时间倒退，而且虚拟机要热迁移，两台host情况不一样，会报错。
2020-09-14T02:58:56.537854Z qemu-kvm: warning: TSC frequency mismatch between VM (2094951 kHz) and host (2593749 kHz), and TSC scaling unavailable

```shell
[root@syh2021v ~]# cat /sys/devices/system/clockevents/broadcast/current_device
pit
[root@syh2021v ~]# cat /sys/devices/system/clockevents/clockevent0/current_device
lapic-deadline
```
读counter exit出来，模拟出一个值，那怎么个模拟法，这个模拟过程用了多久时间，重新enter又要用多久，最后在虚拟机中看到的counter就是不准，而且exit出来影响性能，所以就有kvmclock这样的pv方案，读counter不exit出来，或者pasthrough方案，如虚拟机中rdtsc直接读cpu内部counter，或者硬件辅助一下的方案。物理cpu exit出来后再重新enter执行guest，那谁来让软件定时器超时？软件定时器是不准的，kvm软件定时器模拟硬件定时器肯定不准，而且时间虚拟中断不一定能及时注入虚拟机中。

再考虑一些问题，有全局hpet和局部local apic timer，cpu会用哪个呢？hpet中断哪个cpu处理？其它cpu收不到这个中断怎么tick呢？软件定时器是全局的还是局部的？