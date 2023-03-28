# 传统时钟
## 时钟可以做什么？
时间管理本身是OS内的一个重要功能。其次，内部的进程切换、性能分析统计等都需要以时间为基础的。内核需要一种方法获取现在的时间点，服务器的运行时间，从某一时刻到当前的时刻度过的时间，以及定时提醒等类似功能。

有人总结的一句话：知时、定时、计时。

从功能上现有的时钟分为(RTC、Timer、Counter)：
1. RTC(Real Time Clock)真实的时钟，可以获取具体的时间点，和CMOS集成供电，这样一直跳动，可以获得当前时间。
2. (Periodic Timer)周期性中断的时钟，比如PIT(Programable Interval Timer)、HPET(高精度时钟)。这些设备一般在主板上(南桥、北桥？)，时钟内部有一些寄存器保存周期评率的设置和当前的运行的状态。PIT就是1000Hz
3. (Oneshot Timer)单次触发中断的时钟，由内核设置中断触发阈值，到达阈值后触发。大部分时钟设备都支持单次触发，PIT、HPET均支持单次触发模式。OS内核可以根据需要来定制触发的周期，在低负载或者需要CPU休眠的时候降低触发的频率实现低功耗，是实现tickless kernel的基础。
4. monotonic Counter，单调递增的计数器，不产生中断，比如TSC(timestamp counter)， 可以获取CPU加电后计数器，根据CPU的频率来计算经过的时间。Counter需要以一个固定时间间隔单调递增，现在的cpu都支持睿频、休眠等功能，所以Counter又分为多种情况：不计入休眠时间的counter、所有经过的counter。

物理上一个时钟设备可能包含多种模式，比如上面提到的PIT和hPET支持周期和单发。一般来说，单发的精度高于周期的精度，counter的精度高于单发的精度。


## X86架构下有哪些时钟设备？

1. RTC: 真实时钟，和CMOS集成，由纽扣电池供电。开机关机的时候通过hwclock指令进行读写。Linux提供`/dev/rtc`设备提供时间读取。集成到CMOS上，断电后从1970年开始计时。
2. PIT： 支持100,250,300,1000 Hz。
3. CPU Local Timer： CPU本地的晶振时钟，PIT是在UP时代的，SMP时代使用Local Timer， 和CPU的核绑定。
4. TSC: 64位整数寄存器, 是CPU寄存器。
5. HPET(High Precision Event Timer) , 
6. ACPI Power Management Timer(ACPI PMT)设备寄存器，需要通过IO端口来读取 。

 
其中pit 是操作系统传统上使用的timekeeping 时钟,其精度不是很高，因此很多操作系统(如vista/Linux)目前都使用或支持使用RTC中的周期性定时器来做timekeeping的时钟源。TSC不能产生中断,只能读取，因而多用来配合其它时钟做些校正等工作。


## 虚拟机环境下的问题

我们上面说的wall clock不准,问题主要就出在”更新wall clock”这一过程中。该过程其实很简单,就是在每次时钟中断时刻更新系统的wall clock。然而要想wall clock准确，必须基于一个事实――系统的时钟中断准确送上来，且能及时被处理。别看这么简单，在传统环境下它不是个问题，然后在虚拟环境下可很难保证这个事实。因为传统的抢占式中断处理过程在虚拟环境下变成了类似信号处理的延迟执行方式了。更确切的说就是虚拟环境下 1 模拟的时钟中断不能保证精确的按时发出,它有可能延迟；2 时钟中断的处理并非”抢占”式,只有到guest os获得运行时刻才可执行。上述两点便是时钟问题的根本症结。

## 内核中的时钟工作架构

PIT/TSC/HPET 作为系统时钟的硬件时钟源，三者主要提供的精度不同，系统时钟主要更新系统jiffies。系统时钟由global_clock_event表示，如果使用PIC则global_clock_event指向i8235_clockevent对象；如果使用HPET则指向hpet_clockevent。

APIC作为每个cpu本地时钟的硬件时钟源，主要用来更新本cpu上的一些定时事件以及本地任务调度相关的时间更新。

硬件时钟源提供的主要功能就是计时和定时，对应内核抽象出来的两个数据结构则是clocksource和clock_event_device，在此基础上又抽象了timekeeper提供时间，tick_device提供调度需要的tick事件。对于计时功能不做展开，本文主要介绍定时相关机制。定时的机制大概就是：当定时时间到期后时钟源就会产生一个时钟中断，时钟代码中各种**_interrupt的api就是在时钟中断中执行的函数。底层的时钟源有periodic(低精度)和oneshot(高精度)两种定时模式，对上层的定时器而言是无感知的。

时钟中断

## PIT
在PIT 芯片上有3个计数器，它可以按预先设定好的方式每隔一小段时间触发一次中断。在早期的Linux系统内核中采用了10ms触发一次，这也被称作是Linux的心跳。

PIT 芯片有1个控制寄存器和3个计数器。控制寄存器的访问端口为0x43。计数寄存器的访问端口为0x40、0x41和0x42。每个寄存器可以以6个不同模式计数，并可以选择用BCD或者二进制计数。先将控制字写入控制寄存器，告诉它我们选择哪个计数寄存器、写入方式和计数模式等。再向选定的计数寄存器写入计数初值。这3个计数器的输入频率都是 1.19318Mhz。1193180是所有计数器都使用的作为时钟频率的固定值，计数器0作为定时器为系统时钟提供计时基准。计数器0的输出端与中断控制器8259A的IRQ0相连。假如需要计数器0的中断频率为N每秒，则divisor = 1193180/N，然后将divisor的低8位和高8位分别输入计数器0的访问端口：
```C
/* i8253A PIT registers */
#define PIT_MODE	0x43

#define PIT_CH0		0x40
#define PIT_CH2		0x42

#define PIT_LATCH	((PIT_TICK_RATE + HZ/2) / HZ)
```
## RTC

RTC（Real Time Clock，实时时钟）：通常是和CMOS(CMOS是指BIOS设置保存数据的地方)集成在一起的，由CMOS电池供电，故能在关机后继续计时。其频率范围在2~8192Hz，通常接IRQ8，软件可以通过0x70~0x71 I/O端口操作。RTC支持`周期性`和`单次计时`两种方式，此外，它还可以配置成每秒产生一次中断，具有闹钟功能。由于具有关机继续计时的功能，RTC常被用作为操作系统提供日期，即“年/月/日”。

附录 RTC时钟硬件知识 (摘自第七章 Linux内核的时钟中断 (上) By 詹荣开，NUDT)
自从IBM PCAT起，所有的PC机就都包含了一个叫做实时时钟（RTC）的时钟芯片，以便在PC机断电后仍然能够继续保持时间。显然，RTC是通过主板上的电池来供电的，而不是通过PC机电源来供电的，因此当PC机关掉电源后，RTC仍然会继续工作。通常，CMOSRAM和RTC被集成到一块芯片上，因此RTC也称作“CMOSTimer”。最常见的RTC芯片是MC146818（Motorola）和DS12887（maxim），DS12887完全兼容于MC146818，并有一定的扩展。

RTC寄存器 MC146818 RTC芯片一共有64个寄存器。它们的芯片内部地址编号为0x00～0x3F（不是I/O端口地址），这些寄存器一共可以分为三组：
（1）时钟与日历寄存器组：共有10个（0x00~0x09），表示时间、日历的具体信息。在PC机中，这些寄存器中的值都是以BCD格式来存储的（比如23dec＝0x23BCD）。
（2）状态和控制寄存器组：共有4个（0x0A~0x0D），控制RTC芯片的工作方式，并表示当前的状态。
（3）CMOS配置数据：通用的CMOS RAM，它们与时间无关，因此我们不关心它。 

通过I/O端口访问RTC 在PC机中可以通过I/O端口0x70和0x71来读写RTC芯片中的寄存器。其中，端口0x70是RTC的寄存器地址索引端口，0x71是数据端口。 

## HPET

HPET（High Precision Event Timer，高精度时间时钟）：是Intel和微软共同开发的新型高精度时钟，其最低频率为10MHz，可以作为64位或32位时钟使用。HPET可以提供最多8个时钟，典型的实现至少有一个时钟可用。

HPET的时钟通过一个主计数器，和32个比较器、匹配器一起，又可以被配置成32个子时钟（又称为channel），每个子时钟可以按不同频率产生不同的中断。例如，可以将一个子时钟配置成每毫秒产生一个IRQ8中断，另一个子时钟可以被配置成每微秒产生一个IRQ0中断。

HPET可用于替代传统的PIT和RTC，此时平台的IRQ0、IRQ8中断被HPET占用。HPET支持周期性和单次计时两种工作方式。

## 稳定时间戳计数器（Constant TimeStamp Counter, TSC）
Pentium 开始提供的 64 位寄存器。每次外部振荡器产生信号时 (每个 CPU 时钟周期) 加 1，因此频率依赖于 CPU 频率(Intel 手册上说相等)，如果 CPU 频率为 400MHz 则每 2.5 ns 加 1。为了使用 TSC，Linux 在系统初始化的时候必须通过调用 calibrate_tsc(native_calibrate_tsc) 来确定时钟的频率 (编译时无法确定，因为 kernel 可能运行在不同于编译机的其他 CPU 上)。一般用法是在一定时间内(需要通过其他时间源，如 hpet) 执行两次，记录 start 和 end 的时间戳，同时通过 rdtsc 读取 start 和 end 时 TSC counter，通过 (end - start time) / (end - start counter) 算出期间 CPU 实际频率。但在多核时代下，由于不能保证同一块主板上每个核的同步，CPU 变频和指令乱序执行导致 TSC 几乎不可能取到准确的时间，但新式 CPU 中支持频率不变的 constant TSC。

现代Intel和AMD处理器提供了一个稳定时间戳计数器（Constant Time Stamp Counter, TSC）。这个稳定的TSC的计数频率不会随着CPU核心更改频率而改变，例如，节电策略导致的cpu主频降低不会影响TSC计数。一个CPU具有稳定的TSC频率对于使用TSC作为KVM guest的时钟源时非常重要的。要查看CPU是否具有稳定的时间戳计数器（constant TSC）需要检查cpuinfo中是否有constant_tsc标志：`cat /proc/cpuinfo | grep constant_tsc`
如果上述命令没有任何输出，则表明cpu缺少稳定的TSC特性，需要采用其他时钟源。

## ACPI timer
APIC Timer是一个32位的Timer，通过两个32位的Counter寄存器实现：
- Initial Count Register（APIC_Page[0x380]）
- Current Count Register（APIC_Page[0x390]，只读）
Counter的频率由APIC Timer的基准频率除以Divide Configuration Register确定的除数获得。Divide Configuration Register（APIC_Page[0x3E0]）的第0、1、3位决定了除数：
- 000->2, 001->4, 010->8, 011->16, 100->32, 101->64, 110->128, 111->1

APIC Timer可能会随CPU休眠而停止运作，检查CPUID.06H.EAX.ARAT[bit 2]（APIC Timer Always Running bit）可知其是否会永远保持运作。APIC Timer的基准频率是总线频率（外频）或Core晶振频率（如果能通过CPUID.15H.ECX查到的话）。

APIC Timer有三种操作模式，可以通过LVT Timer Register的第17-18位设置，分别是：
- One shot（00b）：写入Initial Count以启动Timer，Current Count会从Initial Count开始不断减小，直到最后降到零触发一个中断，并停止变化
- Periodic（01b）：写入Initial Count以重启Timer，Current Count会反复从Initial Count减小到0，并在减小到0时触发中断
- TSC-Deadline Mode（10b）
  - CPUID.01H.ECX.TSC_Deadline[bit 24]表示是否支持TSC-Deadline模式，若不支持，第18位为reserved
  - 此模式下，对Initial Count的写入会被忽略，Current Count永远为0。此时Timer受MSR[IA32_TSC_DEADLINE_MSR]控制，为其写入一个非零64位值即可激活Timer，使得在TSC达到该值时触发一个中断。该中断只会触发一次，触发后IA32_TSC_DEADLINE_MSR就被重置为零。  

写入LVT Timer Register切换到TSC-Deadline Mode是一个Memory操作，该操作和接下来的WRMSR指令间必须添加一个MFENCE以保证不会乱序。  
注意前两种模式下，为Initial Count写入0即可停止Timer运作，在第三种模式下则是为IA32_TSC_DEADLINE_MSR写入0，此外修改模式也会停止Timer运行。当然，也可以通过LVT Timer Register中的Mask屏蔽Timer中断实现同样的效果。

intel在lapic硬件单元实现的硬件定时器，提供了四个寄存器the divide configuration register, the initialcount and current-count registers, and the LVT timer register和三种模式，Periodic mode很省事，不需要频繁写寄存器，但不符合linux的需求，NO_HZ_IDLE和NO_HZ_FULL都会动态调整下次tick的时间，One-shot和TSC-Deadline有点像，One-shot 通过MMIO给 initial-count register写一个相对时间，比如10ms那就是10ms后来个中断，TSC-Deadline通过给IA32_TSC_DEADLINE MSR写一个tsc的绝对时间，cpu的tsc值到了这个绝对值就来个中断，感觉比One-shot好控制，cpu HZ高点，10ms干的活多，cpu HZ低点10ms干的活少，TSC-Deadline设置一个值 ，HZ高点，那么tsc涨得快，HZ低点tsc涨得慢，两次中断之间cpu干的活是固定的，所以最终linux选择了TSC-Deadline mode。

# windows的时间

windows虚拟机同时使用Real-Time Clock(RTC)和Time Stamp Counter(TSC)。对于Windows guest，Real-Time Clock可以用于取代TSC作为所有的时钟源来解决guest时间问题。详细设置和介绍见Red Hat Enterprise Linux 5 Virtualization Guide: Chapter 17. KVM guest timing management
# 虚拟化下的时钟
 
1.TSC
Guest中使用rdtsc指令读取TSC时，会因为EXIT_REASON_RDTSC导致VM Exit。VMM读取Host的TSC和VMCS中的TSC_OFFSET，然后把host_tst+tsc_offset返回给Guest。
要做出OFFSET的原因是考虑到vcpu热插拔和Guest会在不同的Host间迁移。
 
2.qemu软件模拟的时钟：
qemu中有对RTC和hpet都模拟出了相应的设备，例如RTC的典型芯片mc146818。
这种软件模拟时钟中断存在的问题：由于qemu也是应用程序，收到cpu调度的影响，软件时钟中断不能及时产生，并且软件时钟中断注入则是每次发生VM Exit/Vm Entry的时刻。所以软件模拟时钟就无法精准的出发并注入到Guest，存在延迟较大的问题。
 
3.kvm-clock：
kvm-clock是KVM下Linux Guest默认的半虚拟化时钟源。在Guest上实现一个kvmclock驱动，Guest通过该驱动向VMM查询时间。
其工作流程也比较简单：Guest分配一个内存页，将该内存地址通过写入MSR告诉VMM，VMM把Host系统时间写入这个内存页，然后Guest去读取这个时间来更新。
这里使用到的两个MSR是：MSR_KVM_WALL_CLOCK_NEW和MSR_KVM_SYSTEM_TIME_NEW（这是新的，使用cpuid 0x40000001来标志使用新的还是旧的）分别对应pvclock_wall_clock和pvclock_vcpu_time_info（具体结构体中的内容在内核代码中可查看）。
 
Linux Guest中查看当前时钟源是否为kvm-clock：
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
kvm-clock
 
Windows Guest处理时间漂移问题：
摘一下qemu代码中 qemu-options.hx的原文：
（-rtc [base=utc|localtime|date][,clock=host|vm][,driftfix=none|slew]）
Enable @option{driftfix} (i386 targets only) if you experience time drift problems, specifically with Windows' ACPI HAL. This option will try to figure out how many timer interrupts were not processed by the Windows guest and will re-inject them.

## guest虚拟机时间同步的机制
默认情况下，guest使用以下方式和hypervisor之间进行时间同步：

- guest系统启动时，会从模拟的实时时钟（emulated Real Time Clock, RTC）读取时间
- 当NTP初始化之后，它将自动同步guest时钟。之后，随着常规的guest操作，NTP在guest内部执行时钟校准
- 当guest在暂停（pause）或者还原进程之后继续，通过管理软件（例如virt-manager）发出一个同步guest时钟到指定值的指令。这个同步工作值在QEMU guest agent安装在guest系统中并且支持这个功能的时候才会工作。这个guest时钟同步的值通常就是host主机的时钟值。

chronyd比ntpd具有优势的方便包括：

只需要间歇性访问时钟源
适合拥塞的网络而工作良好
通常同步时钟更快更精确
比ntpd可以更快调整主机时间
chronyd可以在Linux主机中以一个较大范围来调整时钟频率，也就是允许在主机时钟中断或不稳定时工作。例如，适合在虚拟机中
不过，ntpd在标准协议以及支持更多的时钟参考源上比chronyd具有优势。