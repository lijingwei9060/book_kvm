- [Hyper-v timer服务](#hyper-v-timer服务)
  - [windows version要求](#windows-version要求)
  - [Reference Counter](#reference-counter)
  - [Partition Reference Time Enlightenment](#partition-reference-time-enlightenment)
  - [Partition Reference Time Stamp Counter Page](#partition-reference-time-stamp-counter-page)
- [TSC Page](#tsc-page)
- [Hyper-V SynIC](#hyper-v-synic)
  - [合成时钟Synthetic Timers](#合成时钟synthetic-timers)
    - [周期性timer](#周期性timer)
    - [Direct Synthetic Timers](#direct-synthetic-timers)
- [hyperv\_timer: linux on hyperv](#hyperv_timer-linux-on-hyperv)



ref: https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/timers

# Hyper-v timer服务
Hyperv提供了虚拟的时钟服务给虚拟机，所以运行在hyperv上面的虚拟机都可以使用这种方式，特别是Windows 虚拟机。KVM在2012年就开始作为hyperv兼容的vmm，也遵循hyperv的时钟方式。

4种timer service： 
1. 每个虚拟机有一个Reference Counter，计数器类似于TSC，单调递增，频率固定，不受CPU、总线频率变化影响，也不受CState影响，每个虚拟机有一个。宿主机上的虚拟机的Reference Counter变化频率相同。对于虚拟机而言，只要有一个vCPU没有被显示的停止，这个值就会一直变化。
2. 为每个vCPU提供4个合成的时钟，每个时钟可以配置成periodic或者oneshot模式，发送message或者中断给vCPU。
3. 每个vCPU提供一个vAPIC timer。
4. iTSC，如果物理主机支持invariant TSC，提供虚拟机reference time enlightenment。

Hyper-V还通过RDTSC和相关指令提供对虚拟化TSC的访问。这些TSC指令不会被vmm捕获，因此在VM中提供了优异的性能。Hyper-V执行TSC校准，并通过合成MSR向客户VM提供TSC频率。Linux中的Hyper-V初始化代码读取此MSR以获取频率，因此它跳过TSC校准并设置TSC_reliable。Hyper-V提供PIT的虚拟化版本（仅在Hyper-V第1代虚拟机中）、local APIC timer和RTC。Hyper-V没有给VM提供虚拟化HPET。 

从Windows Server 2022 Hyper-V开始，Hyper-V使用硬件支持TSC frequency scaling，以支持在TSC频率可能不同的Hyper-V主机上实时迁移VM。当Linux vm检测到此Hyper-V功能可用时，它更倾向于使用Linux的基于TSC的标准时钟源。否则，它将使用通过共享页面实现的Hyper-V合成系统时钟的时钟源（标识为`hyperp_clocksource_tsc_page`）。 

Hyper-v上的Linux虚拟机的clockevent使用了合成timer0，驱动为`hyperv_timer`，虽然每个vCPU有4个stimer。stimer0发出的中断记录为"HVS"。 虚拟的PIT和local APIC timer依然有效，不过很明显合成timer的rating更高。

## windows version要求
windows vista、7、8、10
windows 2008、2008r2

##  Reference Counter

hyper-v给每一个虚拟机提供一个单调递增的时间计数器(time counter)。增长的速度固定，不受cpu频率、总线频率、cpu状态影响。初始值为0。所有的虚拟机增长的频率固定。只要有一个vCPU没有被显示的停止，这个值就会一直固定增长。

MSR名称为`HV_X64_MSR_TIME_REF_COUNT`, 地址为`0x40000020`, 该地址为只读，写入会引起`#GP fault(guest page fault)`。

## Partition Reference Time Enlightenment
启用该功能要求物理CPU支持`invariant TSC`, TSC的值可以固定的频率变化，不受到CPU主频和Cstate的影响。
这种方式提供虚拟的TSC、偏移量和multilier，单位为100ns，可以推算出虚拟机启动后的时间。热迁移到具有不同TSC频率的服务器的机制？热迁移到不支持`invariant TSC`的服务器上的fallback机制 ？
```C
static u64 get_time_ref_counter(struct kvm *kvm)
|-> if (hv->hv_tsc_page_status != HV_TSC_PAGE_SET) return div_u64(get_kvmclock_ns(kvm), 100); // Fall back to get_kvmclock_ns() when TSC page hasn't been set up,
|-> tsc = kvm_read_l1_tsc(vcpu, rdtsc()); // 获取vCPU0的时间给虚拟机
```
调用过程：
```C
kvm_get_msr_common()
|-> int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
    |-> r = kvm_hv_get_msr_pw(vcpu, msr, pdata, host);
        |-> case HV_X64_MSR_TIME_REF_COUNT:  data = get_time_ref_counter(kvm);
```

## Partition Reference Time Stamp Counter Page
hyper-v在每个虚拟机的GPA空间提供`virtual reference TSC Page`(虚拟引用TSC Page), 可以通过Reference TSC MSR `HV_X64_MSR_REFERENCE_TSC` 访问 TSC Page。
MSR指向一个64bit数据，初始值为0，虚拟机启动时候需要向最低位写0，让vmm启用该功能；该值高52位(63-12)指向GPA页框数；中间10位没有用，hyperv的规范要求guest要保存好。

Page内部结构：
```C
struct ms_hyperv_tsc_page {
        volatile u32 tsc_sequence; // 乐观锁，如果为0表示tsc不稳定，不要用了
        u32 reserved1;
        volatile u64 tsc_scale;  // 不同的CPU主频来协调变化速率
        volatile s64 tsc_offset;
        u64 reserved2[509];
};
```

如何计算时间： `ReferenceTime = ((VirtualTsc * TscScale) >> 64) + TscOffset`

hyper-v给出了一个参考时间计时：
```C
do
{
    StartSequence = ReferenceTscPage->TscSequence;
    if (StartSequence == 0)
    {
        // 0 means that the Reference TSC enlightenment is not available at
        // the moment, and the Reference Time can only be obtained from
        // reading the Reference Counter MSR.
        ReferenceTime = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
        return ReferenceTime;
    }

    Tsc = rdtsc(); //这个是虚拟的

    // Assigning Scale and Offset should neither happen before
    // setting StartSequence, nor after setting EndSequence.
    Scale = ReferenceTscPage->TscScale;
    Offset = ReferenceTscPage->TscOffset;

    EndSequence = ReferenceTscPage->TscSequence;
} while (EndSequence != StartSequence);

// The result of the multiplication is treated as a 128-bit value.
ReferenceTime = ((Tsc * Scale) >> 64) + Offset;
return ReferenceTime;
```





hv-time
Enables two Hyper-V-specific clocksources available to the guest: MSR-based Hyper-V clocksource (HV_X64_MSR_TIME_REF_COUNT, 0x40000020) and Reference TSC page (enabled via MSR HV_X64_MSR_REFERENCE_TSC, 0x40000021). Both clocksources are per-guest, Reference TSC page clocksource allows for exit-less time stamp readings. Using this enlightenment leads to significant speedup of all timestamp related operations.

hv-stimer
Enables Hyper-V synthetic timers. There are four synthetic timers per virtual CPU controlled through HV_X64_MSR_STIMER0_CONFIG..HV_X64_MSR_STIMER3_COUNT (0x400000B0..0x400000B7) MSRs. These timers can work either in single-shot or periodic mode. It is known that certain Windows versions revert to using HPET (or even RTC when HPET is unavailable) extensively when this enlightenment is not provided; this can lead to significant CPU consumption, even when virtual CPU is idle.

# TSC Page
TSC reference page: similar to kvm_clock
time = (scale * tsc) >> 64 + offset
• no vmexits
• invariant TSC req’d
• one per VM
• read consistency via seqcount
• seqcount == 0 ⇒ fall-back to time ref count
• no seqlock semantics ⇒ use fall-back on updates ⇒ monotonicity with time ref count req’d

• per vCPU: 4 timers × 2 MSRs (config, count)
• in partition reference time
• SynIC messages HVMSG_TIMER_EXPIRED
• expiration time
• delivery time
• in KVM ⇒ first to take message slot
• periodic / one-shot
• lazy (= discard) / period modulation (= slew)

#  Hyper-V SynIC
Hyper-V SynIC (synthetic interrupt controller)
• LAPIC extension managed via MSRs
• 16 SINT’s per vCPU
• AutoEOI support
• incompatible with APICv
• KVM_IRQ_ROUTING_HV_SINT
• GSI → vCPU#, SINT#
• irqfd support
• KVM_EXIT_HYPERV(SYNIC) on MSR access







## 合成时钟Synthetic Timers

`Synthetic Timers`可以产生中断，支持oneshot和periodic模式。中断是向特定的`SynIC SINTx` (synthetic interrupt source) 发送message，这个signal可能会晚不可能早。
每个vCPU包含4对MSR: 
1. `HV_X64_MSR_STIMER0_CONFIG` ~ `HV_X64_MSR_STIMER3_CONFIG`  是合成时钟的配置寄存器，地址从`0x400000B0` ~ `0x400000B6`
2. `HV_X64_MSR_STIMER0_COUNT` ~ `HV_X64_MSR_STIMER3_COUNT` 是合成时钟的过期时间或者周期间隔。

配置寄存器结构：
1. 0bit： enabled，rw
2. 1bit：periodic，rw
3. 2bit： lazy， rw
4. 3bit： autoenable
5. 4-11bit： apic vector
6. 12bit： direct
7. 13-15bit： reserved
8. 16-19bit： SINTx
9. 20-63bit： reserved

技术寄存器结构：
1. 0-63bit： 周期性的间隔或者oneshot的过期时间，单位100ns。写入0会导致counter停止。
### 周期性timer

catches up： 如果vCPU因为争抢不到CPU运行时间，中间的时钟中断信号无法发送给vCPU，超时信号可能会被跳过。
deferred： 对于一些lazy的时钟，可以延迟发送时间信号。

### Direct Synthetic Timers

“Direct” synthetic timers assert an interrupt upon timer expiration instead of sending a message to a SynIc synthetic interrupt source. A synthetic timer is set to “direct” mode by setting the “DirectMode” field of the synthetic timer configuration MSRs. The “ApicVector” field controls the interrupt vector that is asserted upon timer expiration.


# hyperv_timer: linux on hyperv

优先使用TSC page clocksource, 其次使用MSR Clocksource也就是Reference Counter，如果这两个都不可以使用就回归到原始的模拟PIT和LAPIC时钟，hyperv不提供hpet时钟。如果hyperv提供了`TSC_INVARIANT`, linux会将tsc page和msr的rating降到250，在X86上会有优先使用CPU自带的TSC，而不是hyperv的virtual tsc。

```C
static struct clocksource hyperv_cs_tsc = {
	.name	= "hyperv_clocksource_tsc_page",
	.rating	= 500,
	.read	= read_hv_clock_tsc_cs,
	.mask	= CLOCKSOURCE_MASK(64),
	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
	.suspend= suspend_hv_clock_tsc,
	.resume	= resume_hv_clock_tsc,
	.enable = hv_cs_enable,
	.vdso_clock_mode = VDSO_CLOCKMODE_HVCLOCK,
	.vdso_clock_mode = VDSO_CLOCKMODE_NONE,
};
```

```C
static struct clocksource hyperv_cs_msr = {
	.name	= "hyperv_clocksource_msr",
	.rating	= 500,
	.read	= read_hv_clock_msr_cs,
	.mask	= CLOCKSOURCE_MASK(64),
	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
};
```