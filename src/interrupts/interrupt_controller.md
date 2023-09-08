# 概述

X86外联针脚有2个，一个用户NMI，一个INTR。NMI不可屏蔽信号，INTR是可屏蔽信号。所以中断控制器链接到CPU上的INTR：
1. PIC（Programable Interrupt Controller， 8259A）：可编程中断控制器，有8个针脚，支持两个级联，Master和Slave模式，除去一个用于上联的针脚，可用的一共15个。部分针脚对应的中断是固定的，有哪些呢？如何进行编程呢？因为针脚数量有限，所以必然出现很多设备共享中断号。存在问题无法对接smp架构cpu。
2. APIC包含LAPIC(local apic)和IO APIC。
   1. LAPIC负责传递中断信号到指定的CPU，包含在每个核中一个，也就是一颗cpu可以有多个LAPIC。
   2. IOAPIC负责收集IO设备的中断信号，并投递到LAPIC，是一颗cpu一个，现在系统中最多8个IOAPIC。
   3. LAPIC包含内部时钟，定时设备，32位寄存器，2条额外的中断信号线LINT0和LINT1，连接到IOAPIC。


## 数据结构

- irq_chip


## PIC 物理和模拟

中断信号：
- 0： 始终
- 1： 键盘


在内核中每条IRQ线由结构体 `irq_desc_t` 来描述，irq_desc_t 定义如下：

```C
typedef struct {
    unsigned int status;        /* IRQ status */
    hw_irq_controller *handler;
    struct irqaction *action;   /* IRQ action list */
    unsigned int depth;         /* nested irq disables */
    spinlock_t lock;
} irq_desc_t;
```

 `irq_desc_t` 结构各个字段的作用：

- status: IRQ线的状态。
- handler: 类型为 hw_interrupt_type 结构，表示IRQ线对应的硬件相关处理函数，比如 8259A中断控制器 接收到一个中断信号时，需要发送一个确认信号才会继续接收中断信号的，发送确认信号的函数就是 hw_interrupt_type 中的 ack 函数。
- action: 类型为 irqaction 结构，中断信号的处理入口。由于一条IRQ线可以被多个硬件共享，所以 action 是一个链表，每个 action 代表一个硬件的中断处理入口。
- depth: 防止多次开启和关闭IRQ线。
- lock: 防止多核CPU同时对IRQ进行操作的自旋锁。



## APIC 物理和模拟

## IOAPIC 物理和模拟

## LAPIC 物理和模拟


## OS接口


辨别一个系统是否正在使用 I/O APIC，可以在命令行输入如下命令：
```shell
# cat /proc/interrupts
           CPU0       
  0:      90504    IO-APIC-edge  timer
  1:        131    IO-APIC-edge  i8042
  8:          4    IO-APIC-edge  rtc
  9:          0    IO-APIC-level  acpi
 12:        111    IO-APIC-edge  i8042
 14:       1862    IO-APIC-edge  ide0
 15:         28    IO-APIC-edge  ide1
177:          9    IO-APIC-level  eth0
185:          0    IO-APIC-level  via82cxxx

```

如果输出结果中列出了 IO-APIC，说明您的系统正在使用 APIC。如果看到 XT-PIC，意味着您的系统正在使用 8259A 芯片。
