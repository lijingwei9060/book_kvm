# 概念
lapic上的设备：
1. 一些列寄存器：ICR、IRR、ISR、TPR、PPR
    - version register
    - Time: Current count Register/Initial count Register/Divide configuration register
    - apic id register
    - local destination register
    - destination format register
    - spurious vector register
    - LVT(local vector table)
    - EOI register
    - ICR(Interrupt Command Register) 用于发送 IPI
    - IRR(Interrupt Request Register) 当前 LAPIC 接收到的中断请求
    - ISR(In-Service Register) 当前 LAPIC 送入 CPU 中 (CPU 正在处理) 的中断请求
    - TPR(Task Priority Register) 当前 CPU 处理中断所需的优先级
    - PPR(Processor Priority Register) 当前 CPU 处理中断所需的优先级，只读，由 TPR 决定
2. 内部时钟TSC
3. 热传感器
4. 本地定时设备 apic-timer
5. 两条irq线： lint0和lint1

## 中断优先级


中断向量的vector的高4位(bit4-7)为Interrupt-Priority class，每个 class 包含 16 个中断向量。0-15 号中断向量的 class 为 0，但其不合法，这些中断永远不会提交。在 Intel 64 和 IA-32 架构中，0-31 号中断向量被保留，因此 class 0-1 不可用。中断向量的 bit0-3 决定了同 class 下的优先级，越大在 class 内的优先级就越高，由于vector 0-31是CPU保留，所以可用中断优先级范围为2-15。

PPR 决定了 CPU 接受的中断。只有 Interrupt-Priority class 大于 Processor-Priority Class 的中断才会被送到 CPU 中(注意， NMI / SMI / INIT / ExtINT / SIPI 不受该限制)。Processor-Priority Sub-Class 不影响中断的送达，只是用来凑数而已。

Local APIC的TPR和PPR用于设置task优先级和CPU优先级，这两个寄存器的值控制着CPU处理该中断行为，当I/O APIC转发的中断vector优先级小于Local APIC TPR设置的值时，此中断不会打断该CPU上运行的task,当I/O APIC转发的中断vector优先级小于Local APIC PPR值时，该CPU不处理该中断，操作系统通过动态设置local APIC TPR和PPR，来实现操作系统的实时性需求和负载均衡。

## 中断类型 

LAPIC 主要处理以下中断，前 5 种中断被称为本地中断，LAPIC 在收到后会设置好 LVT(Local Vector Table)的相关寄存器，通过 interrupt delivery protocol 送达 CPU。
- APIC Timer 产生的中断(APIC timer generated interrupts)
- Performance Monitoring Counter 在 overflow 时产生的中断(Performance monitoring counter interrupts)
- 温度传感器产生的中断(Thermal Sensor interrupts)
- LAPIC 内部错误时产生的中断(APIC internal error interrupts)
- 本地直连 IO 设备 (Locally connected I/O devices) 通过 LINT0 和 LINT1 引脚发来的中断
- 其他 CPU (甚至是自己，称为 self-interrupt)发来的 IPI(Inter-processor interrupts)
- IOAPIC 发来的中断

## lvt
LVT(Local vector table) 实际上是一片连续的地址空间，每 32-bit 一项，作为各个本地中断源的 APIC register ：
- timer
- cmci
- lint0
- lint1
- error
- performance monitor counters
- thermal sensor

register 被划分成多个部分：

- bit 0-7: Vector，即CPU收到的中断向量号，其中0-15号被视为非法，会产生一个Illegal Vector错误（即ESR的bit 6，详下）
- bit 8-10: Delivery Mode，有以下几种取值：
- 000 (Fixed)：按Vector的值向CPU发送相应的中断向量号
- 010 (SMI)：向CPU发送一个SMI，此模式下Vector必须为0
- 100 (NMI)：向CPU发送一个NMI，此时Vector会被忽略
- 101 (INIT)：向CPU发送一个 INIT，此模式下Vector必须为0
- 111 (ExtINT)：令CPU按照响应外部8259A的方式响应中断，这将会引起一个INTA周期，CPU在该周期向外部控制器索取Vector。APIC只支持一个ExtINT中断源，整个系统中应当只有一个CPU的其中一个LVT表项配置为ExtINT模式
- bit 12: Delivery Status（只读），取0表示空闲，取1表示CPU尚未接受该中断（尚未EOI）
- bit 13: Interrupt Input Pin Polarity，取0表示active high，取1表示active low
- bit 14: Remote IRR Flag（只读），若当前接受的中断为fixed mode且是level triggered的，则该位为1表示CPU已经接受中断（已将中断加入IRR），但尚未进行EOI。CPU执行EOI后，该位就恢复到0
- bit 15: Trigger Mode，取0表示edge triggered，取1表示level triggered（具体使用时尚有许多注意点，详见手册10.5.1节）
- bit 16: 为Mask，取0表示允许接受中断，取1表示禁止，reset后初始值为1
- bit 17/17-18: Timer Mode，只有LVT Timer Register有，用于切换APIC Timer的三种模式


最后两种中断通过写 ICR 来发送。当对 ICR 进行写入时，将产生 interrupt message 并通过 system bus(Pentium 4 / Intel Xeon) 或 APIC bus(Pentium / P6 family) 送达目标 LAPIC 。

当有多个 APIC 向通过 system bus / APIC bus 发送 message 时，需要进行仲裁。每个 LAPIC 会被分配一个仲裁优先级(范围为 0-15)，优先级最高的拿到 bus，从而能够发送消息。在消息发送完成后，刚刚发送消息的 LAPIC 的仲裁优先级会被设置为 0，其他的 LAPIC 会加 1。

## 中断发送流程
举个例子：当一个 CPU 想要向其他 CPU 发送中断时，就在自己的 ICR(interrupt command ragister) 中存放对应的中断向量和目标 LAPIC ID 标识。然后由 system bus(Pentium 4 / Intel Xeon) 或 APIC bus(Pentium / P6 family) 直接传递到目标 LAPIC。

## 中断接收流程
一个 LAPIC 在收到一个 interrupt message 后，执行以下流程：

1. 判断自己是否属于消息指定的 destination ，如果不是，抛弃该消息
2. 如果中断的 Delivery Mode 为 NMI / SMI / INIT / ExtINT / SIPI ，则直接将中断发送给 CPU
3. 如果不是以上的 Mode ，则设置中断消息在 IRR 中对应的 bit。如果 IRR 中 bit 已被设置(没有 open slot)，则拒绝该请求，然后给 sender 发送一个 retry 的消息
4. 对于 IRR 中的中断，LAPIC 每次会根据中断的优先级和当前 CPU 的优先级 PPR 选出一个发送给 CPU，会清空该中断在 IRR 中对应的 bit，并设置该中断在 ISR 中对应的 bit
5. CPU 在收到 LAPIC 发来的中断后，通过中断 / 异常处理机制进行处理。处理完毕后，向 LAPIC 的 EOI(end-of-interrupt)寄存器进行写入(NMI / SMI / INIT / ExtINT / SIPI 无需写入)
6. LAPIC 清除 ISR 中该中断对应的 bit(只针对 level-triggered interrupts)
7. 对于 level-triggered interrupt， EOI 会被发送给所有的 IOAPIC。可以通过设置 Spurious Interrupt Vector Register 的 bit12 来避免 EOI 广播

IRR + ISR 的机制决定了同一个中断最多可以 pending 两次，第一次已被送到 CPU 中进行处理，而第二次处于 IRR 中等待送到 CPU 中。