# intro

steal_time原意是指在虚拟化环境下，hypervisor窃取的vm中的时间，严格讲就是VCPU没有运行的时间。

在guest中执行top选项，就可以看到一个st数据: 
```shell
oenhan@oenhan.com ~$ top
top - 21:04:12 up 1:24, 2 users, load average: 0.45, 0.31, 0.22
Tasks: 268 total, 1 running, 267 sleeping, 0 stopped, 0 zombie
%Cpu(s): 0.5 us, 0.2 sy, 0.3 ni, 98.0 id, 0.9 wa, 0.0 hi, 0.0 si,0.0 st
```
st数据的意义是给guest看到了自己真正占用CPU的时间比例，让guest根据st调整自己的行为，以免影响业务，如果st值比较高，则说明hostvm的CPU比例太小，整个hypervisor的任务比较繁重，有些高计算任务可以跟着自我限制。

MSR_KVM_STEAL_TIME: 0x4b564d03
data: 64-byte alignment physical address of a memory area which must be in guest RAM, plus an enable bit in bit 0. This memory is expected to hold a copy of the following structure:
```C
struct kvm_steal_time { 
  __u64 steal;
  __u32 version;
  __u32 flags;
  __u32 pad[12]; 
}
```
每个vcpu都需要对应的msr，由kvm更新：
- version: 更新序列数字.，奇数表示KVM正在修改.
- flags: 当前是全0
- steal: ns单位，表示vcpu没有运行的时间，Time during which the vcpu is idle, will not be reported as steal time.


在4.2.6后版本加入，由AWS(xen)开发，通过`CONFIG_PARAVIRT=y` 启用。


## guest工作工程

在guest kernel启动的过程中：
1. 内核初始化调用setup_arch
2. 然后是kvm_guest_init
3. 先调用kvm_para_available判断是否是KVM虚拟化环境，原理就是根据CPUID查询的字符串是否有"KVMKVMKVM"
4. 是否启用feature： KVM_FEATURE_STEAL_TIME
5. 然后又将kvm_steal_clock注册到pv_time_ops.steal_clock
6. 调用kvm_guest_cpu_init，进入kvm_register_steal_time函数，把steal_time的每CPU变量的物理地址注册到MSR_KVM_STEAL_TIME中， `wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED))`.


kvm_steal_clock工作过程：
1. kvm_steal_clock调用注册点steal_clock则是paravirt_steal_clock，最终会调用`steal_account_process_tick`函数，top看到的st值就是它计算出来的。
2. account_process_tick和irqtime_account_process_tick中都有调用`steal_account_process_tick`，即是steal_time的更新已经集成到kenrel的定时器更新中
3. 在steal_account_process_tick函数中，paravirt_steal_clock获取steal clock，paravirt_steal_clock的返回值是一个累积值，减去this_rq()->prev_steal_time即得出当前的steal time，然后累加到kcpustat_this_cpu->cpustat[CPUTIME_STEAL]，同时刷新this_rq()->prev_steal_time，而kcpustat_this_cpu则是top命令看到的st数据的来源。


在更新run queue的clock_task，如果配置`CONFIG_PARAVIRT_TIME_ACCOUNTING=y`, task的运行时间会减去steal time，保持调度正常。

## guest数据结构

struct kvm_steal_time
MSR_KVM_STEAL_TIME
struct kcpustat_this_cpu


## kvm工作工程

在kvm_vcpu_arch下有下面的一个结构体记录msr值，steal time
```C
struct {
u64 msr_val;
u64 last_steal;
u64 accum_steal;
struct gfn_to_hva_cache stime;
struct kvm_steal_time steal;
} st;
```
在vcpu_enter_guest函数中，会运行record_steal_time，accumulate_steal_time：
1. kvm_vcpu_ioctl->vcpu_load->kvm_arch_vcpu_load->accumulate_steal_time： 计算steal time
2. kvm_vcpu_ioctl->kvm_arch_vcpu_ioctl_run->vcpu_run->vcpu_enter_guest->record_steal_time

run_delay： 在运行队列上等待的时间
时间段：
1. T1： Guest Time
2. T2： Host Time
3. T3： Guest time
4. T4： Host Time
5. T5： Guest Time

current->sched_info.run_delay就是qemu的run_delay，也就是陷入到guest中的时间，那么在t5时刻(每次enter到guest中的时候)，current->sched_info.run_delay=t2-t1+t4-t3，而vcpu->arch.st.last_steal则是上次enter guest时（t3时刻）的run_delay，即t2-t1，那么本次时间段的steal time则是vcpu->arch.st.accum_steal=t4-t3。这样就将当前时间段内的steal time存储到accum_steal中。

record_steal_time函数，此处使用了kvm_read_guest_cached和kvm_write_guest_cached，本质就是直接读取或写入guest的某段内存，涉及到gfn_to_hva_cache结构体，因为写入的gfn2hva映射关系一般是不变的，所以不需要在guest重复转换浪费计算能力，vcpu->arch.st.stime的gfn_to_hva_cache结构体是在kvm_set_msr_common函数下MSR_KVM_STEAL_TIME case下初始化的。

record_steal_time，kvm_read_guest_cached本质就是__copy_from_user，拷贝到vcpu->arch.st.stime，然后加上vcpu->arch.st.accum_steal，赋值给vcpu->arch.st.steal.steal，然后再通过kvm_write_guest_cached函数写入到guest中的映射地址中，这样就和steal_time每CPU变量对应起来了。


kvm_feature_steal_on()