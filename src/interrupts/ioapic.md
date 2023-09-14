# 概念

IOAPIC (I/O Advanced Programmable Interrupt Controller) 属于 Intel 芯片组的一部分，也就是说通常位于南桥。像 PIC 一样，连接各个设备，负责接收外部 IO 设备 (Externally connected I/O devices) 发来的中断，典型的 IOAPIC 有 24 个 input 管脚(INTIN0~INTIN23)，没有优先级之分。I/O APIC提供多处理器中断管理，用于CPU核之间分配外部中断，在某个管脚收到中断后，按一定规则将外部中断处理成中断消息发送到Local APIC。

## 寄存器
和 LAPIC 一样，IOAPIC 的寄存器同样是通过映射一片物理地址空间实现的：

- IOREGSEL(I/O REGISTER SELECT REGISTER): 选择要读写的寄存器
- IOWIN(I/O WINDOW REGISTER): 读写 IOREGSEL 选中的寄存器
- IOAPICVER(IOAPIC VERSION REGISTER): IOAPIC 的硬件版本
- IOAPICARB(IOAPIC ARBITRATION REGISTER): IOAPIC 在总线上的仲裁优先级
- IOAPICID(IOAPIC IDENTIFICATION REGISTER): IOAPIC 的 ID，在仲裁时将作为 ID 加载到 IOAPICARB 中
- IOREDTBL(I/O REDIRECTION TABLE REGISTERS): 有 0-23 共 24 个，对应 24 个引脚，每个长 64bit。当该引脚收到中断信号时，将根据该寄存器产生中断消息送给相应的 LAPIC