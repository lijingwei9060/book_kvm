
# 概念
Hyper-V Enlightenments 是针对windows虚拟机在虚拟化场景性能的优化，设计的目标是提供一个模拟hyperv的能力，从而可以降低比如内存管理的开销，通过VMBus（一种类似于virtio）的方式进行IO路径的优化。

Enlightments在windows vista之后的系统，一般都提供支持。。

## 优化内容
1. evmcs： 在 L0(KVM)和 L1(Hyper-V)管理程序之间实施半虚拟化协议，从而加快 L2 退出到管理程序的速度。这个功能只供 Intel 处理器使用。
2. frequencies： 启用 Hyper-V 频率机器特定寄存器(MSR)， 新增HV_X64_MSR_TSC_FREQUENCY (0x40000022) 和 HV_X64_MSR_APIC_FREQUENCY (0x40000023) ，guest可以直接读取TSC/APIC 频率，不需要测量。
3. ipi: 启用半虚拟化处理器中断(IPI)支持。HvCallSendSyntheticClusterIpi系统调用可以同时向超过64个vp发送ipi，依赖hv-vpindex。
4. no-nonarch-coresharing: 通知客户端操作系统：虚拟处理器永远不会共享物理内核，除非报告为同级 SMT 线程。Windows 和 Hyper-V 客户机需要这些信息才能正确地缓解并发多线程(SMT)相关 CPU 漏洞。
5. reenlightenment: 仅在迁移期间发生时间戳计数器(TSC)频率更改时通知。它还允许 guest 继续使用旧频率，直到准备好切换至新频率。
6. relaxed: 禁用 Windows 完整性检查(disable watchdog timeouts as it is running on a hypervisor)，该检查通常在大量加载的主机上运行时导致 BSOD。这和 Linux 内核选项 no_timer_check 类似，它会在 Linux 在 KVM 中运行时自动启用。
7. reset: 启用 Hyper-V 重置，新增HV_X64_MSR_RESET (0x40000003) MSR，写入会重启，不推荐使用。
8. runtime: 设定运行客户机代码以及代表客户端代码的处理器时间。提供了 HV_X64_MSR_VP_RUNTIME (0x40000010) MSR ，以100ns为单位保存vp运行时间，可以让虚拟机判断被偷了多少时间。
9. crash: 提供HV_X64_MSR_CRASH_P0..HV_X64_MSR_CRASH_P5 (0x40000100..0x40000105) 和 HV_X64_MSR_CRASH_CTL (0x40000105) 7个MSR。当虚拟机crash的时候保存crash 信息，可以通过AQPI获得。向HV_X64_MSR_CRASH_CTL写入会导致虚拟机关机，会阻止windows虚拟机生成crash dump。
10. spinlock: 虚拟机的操作系统用于通知 Hyper-V，调用虚拟处理器正在尝试获取可能由同一分区中其他虚拟处理器持有的资源;Hyper-V 用于向虚拟机的操作系统指明在 Hyper-V 出现过高峰情况之前应该尝试进行跳锁获取的次数。(0xffffffff indicates "never notify")
11. stimer: 为虚拟处理器启用合成计时器。请注意，某些 Windows 版本在未提供这种功能将恢复到使用 HPET（或在 HPET 不可用时甚至 RTC），这可能导致大量 CPU 消耗，即使虚拟 CPU 处于空闲状态。每个vp有4个复合时钟，增加4个msr HV_X64_MSR_STIMER0_CONFIG..HV_X64_MSR_STIMER3_COUNT (0x400000B0..0x400000B7) MSRs分别进行管理。依赖hv-vpindex, hv-synic, hv-time。
12. stimer-direct: 当通过正常中断发送过期事件时，启用复合计时器。依赖hv-vpindex, hv-synic, hv-time, hv-stimer。
13. synic: 启用Hyper-V Synthetic interrupt controller (hyperv符合中断控制器)，是LAPIC的扩展。与定时器一起激活复合计时器。Windows 以周期性模式使用此功能。可以使用SynIC messages 和 Events对虚拟机进行通信，要求qemu实现vmbus（貌似还没有实现）。增加了MSRs HV_X64_MSR_SCONTROL..HV_X64_MSR_EOM (0x40000080..0x40000084) 和 HV_X64_MSR_SINT0..HV_X64_MSR_SINT15 (0x40000090..0x4000009F)，需要和vpindex一起使用才能工作。
14. time: 启用以下虚拟机可用的特定于 Hyper-V 的时钟源,(1)基于 MSR 的Hyper-V 时钟源(HV_X64_MSR_TIME_REF_COUNT, 0x40000020);(2)参考通过 MSR 启用的 TSC页面(HV_X64_MSR_REFERENCE_TSC，0x40000021)。使用后者将减少退出时间，加速时间相关操作。
15. tlbflush: 清除虚拟处理器的 TLB。
16. vapic: 启用虚拟 APIC，它提供(Virtal Processor Assist page MSR)对高用量内存映射高级编程高级 Interrupt Controller(APIC)寄存器的加快 MSR 访问。
17. vendor_id: 	设置 Hyper-V 厂商 id。
18. vpindex: (HV_X64_MSR_VP_INDEX (0x40000002) MSR to the guest)启用虚拟处理器索引。
19. avic：use Hyper-V SynIC with hardware APICv/AVIC enabled

[hyperv.txt](https://fossies.org/linux/qemu/docs/hyperv.txt)
[ms_virt]https://github.com/MicrosoftDocs/Virtualization-Documentation
## OS支持
Enlightments在windows vista之后的系统，一般都提供支持
## 配置

在虚拟机的xml配置部分增加feature，同时更改clock部分。
```xml
<features>
  [...]
  <hyperv>
    <relaxed state='on'/>
    <vapic state='on'/>
    <spinlocks state='on' retries='8191'/>
    <vpindex state='on'/>
    <runtime state='on' />
    <synic state='on'/>
    <stimer state='on'/>
    <frequencies state='on'/>
  </hyperv>
  [...]
</features>
```

```xml
<clock offset='localtime'>
  <timer name='hypervclock' present='yes'/>
</clock>
```

## qemu 过程

## kvm 过程