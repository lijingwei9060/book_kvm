1. linux kernel的时间框架
   1. 驱动层： clock source、clock event
   2. 功能层： timekeeping、hrtimer、sched_timer、posix_timer、broadcast
   3. x86架构的device
   4. arm架构的device
   5. 龙芯架构的device
   6. ntp
   7. ptp
   8. 用户态的查看工具：sysfs/timer_list/timer_state
   9. BPF工具
2. 虚拟化下的时间
   1. KVM下的Linux时间kvm-clock
   2. KVM下的windows时间
   3. hyperv下的linux时间
   4. 物理机内的cpu迁移对时间影响
   5. 热迁移对时间的影响
   6. qemu中的时间设备
   7. firecrack、stratovirt中的时间
3. 时间对性能测试的影响
   1. gettimeofday64的访问路径
   2. 使用tsc和hpet的虚拟机的perf监控