英特尔 VT-x 的 IPI 虚拟化支持将与 Linux 5.19 内核一起引入，以支持 Xeon Scalable 第四代 “Sapphire Rapids” 服务器 CPU 中的这一新硬件功能。

进程间中断 (IPI) 虚拟化旨在消除在源 vCPU 上发出 IPI（处理器间中断）时的 VM 退出，提供更有效的进程间中断，从而消除 IPI 密集型任务所表现出的 “大量开销”。 英特尔去年在程序员参考手册更新中概述了 IPI 虚拟化，此后不久，英特尔工程师开始发布 Linux 支持补丁。 经过几轮审查后，IPI 虚拟化支持现在已准备好在 Linux 5.19 之前推出。

早期 Linux 内核补丁中，英特尔工程师将 IPI 虚拟化的影响总结为：
    
我们进行了实验，以测量将 IPI 从源 vCPU 发送到目标 vCPU 完成 IPI 处理的平均时间，这些时间由 kvm unittest w/ 和 w/o IPI 虚拟化完成。当 IPI 虚拟化启用后，它将在 xAPIC 模式和 x2APIC 模式下分别减少 22.21% 和 15.98% 的周期消耗。

昨天，剩余的 IPI 虚拟化补丁在本月晚些时候 Linux 5.19 合并窗口打开之前进入了 KVM 的 “next” 分支。 “next” 区域中基于内核的虚拟机补丁已经以支持 CPU 启用 IPI 虚拟化而告终。作为 IPI 虚拟化支持的一部分，还有其他 VT-x 工作，如三级 VM 执行控制。 

https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=next&id=694599c8267d862085324bc1f6ef5e8014abc5c0