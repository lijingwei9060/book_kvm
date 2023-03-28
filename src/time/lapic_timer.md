intel在lapic硬件单元实现的硬件定时器，提供了四个寄存器the divide configuration register, the initialcount and current-count registers, and the LVT timer register和三种模式，Periodic mode很省事，不需要频繁写寄存器，但不符合linux的需求，NO_HZ_IDLE和NO_HZ_FULL都会动态调整下次tick的时间，One-shot和TSC-Deadline有点像，One-shot 通过MMIO给 initial-count register写一个相对时间，比如10ms那就是10ms后来个中断，TSC-Deadline通过给IA32_TSC_DEADLINE MSR写一个tsc的绝对时间，cpu的tsc值到了这个绝对值就来个中断，感觉比One-shot好控制，cpu HZ高点，10ms干的活多，cpu HZ低点10ms干的活少，TSC-Deadline设置一个值 ，HZ高点，那么tsc涨得快，HZ低点tsc涨得慢，两次中断之间cpu干的活是固定的，所以最终linux选择了TSC-Deadline mode。

LVT bits[18:17]
- 00b: one-shot mode, program count down value in an initial-count register
- 01b: periodic mode, program interval value in an initial-count register
- 10b: tsc-deadline mode, program target value in ia32_tsc_deadline msr.
- 11b: reserved

linux要正常运转，不能没有timer中断，就像人不能没有心跳，NO_HZ_IDLE和NO_HZ_FULL也只是把timer中断的周期拉长了一点。

# Preemption Timer
## 什么是Preemption Timer
Preemption Timer是一种可以周期性使VM触发VMEXIT的一种机制。即设置了Preemption Timer之后，可以使得虚拟机在指定的TSC cycle之后产生一次VMEXIT并设置对应的exit_reason，trap到VMM中。该机制很少被社区的开发者使用，甚至连Linux KVM部分代码中连该部分的处理函数都没有，只是定义了相关的宏（这些宏还是在nested virtualization中使用的）。

使用Preemption Timer时需要注意下面两个问题：
1. 在旧版本的Intel CPU中Preemption Timer是不精确的。在Intel的设计中，Preemption Timer应该是严格和TSC保持一致，但是在Haswell之前的处理器并不能严格保持一致。
2. Preemption Timer只有在VCPU进入到Guest时（即进入non-root mode）才会开始工作，在VCPU进入VMM时或者VCPU被调度出CPU时，其值都不会有变化。

## 如何使用Preemption Timer
Preemption Timer在VMCS中有三个域需要设置：
1. Pin-Based VM-Execution Controls，Bit 6，“Activate VMX preemption timer”： 该位如果设置为1，则打开Preemption Timer；如果为0，则下面两个域的设置均无效。该位在Kernel代码中对应的宏为PIN_BASED_VMX_PREEMPTION_TIMER。
2. VM-Exit Controls，Bit 22，”Save VMX preemption timer value“： 如果该位设置为1，则在每次VMEXIT的时候都会将已经消耗过的value存在VMCS中；如果设置为0，则在每次VMEXIT之后，Preemption Value都会被设置成初始值。该位在Kernel代码中对应的宏为VM_EXIT_SAVE_VMX_PREEMPTION_TIMER。
3. VMX-preemption timer value：这个域是VMCS中的一个域，存储Preemption Value。这是一个32bit的域，设置的值是每次VMENTER时的值，在VM运行的过程中逐渐减少。如果设置了Save VMXpreemption timer value，那么在退出时会更新该域为新的值，可以根据两次的差来计算虚拟机运行的多少个TSC cycle。在Kernel对用的宏为VMX_PREEMPTION_TIMER_VALUE。

和Preemption Timer相关的文档参见Intel Manual 3C卷 [1]，25.5.1和26.6.4，以及全文搜索"Preemption Timer"得到的相关内容。

在使用时，需要首先设置 Activate VMX preemption  timer和 VMX-preemption timer value，如果需要VMEXIT时保存preemption value的话，需要设置 Save VMX preemption  timer  value，这样在VM因为其他原因退出的时候不会重置preemption value。

Preemption Timer一个可能的使用环境是：需要让VM定期的产生VMEXIT，那么上述三个域都需要设置。 注意：在由Preemption Timer Time-out产生的VMEXIT中，是需要重置VMX preemption timer value的。

Preemption Timer相关的的VMEXIT reason号是 52，参考Intel Manual 3C  Table C-1 [1]，" VMX-preemption timer expired. The preemption timer counted down to zero"。

## Preemption Timer count down频率的计算

Preemption Timer频率的计算可以参考Intel Manual 3C [1]的" 25.5.1 VMX-Preemption Timer"，在这里我给出一个简单的算法，首先明确如下几个名词：
1. PTTR（Preemption Timer TSC Rate）：在MSR IA32_VMX_MISC的后五位中，存储着一个5 bit的数据，代表着Preemption Timer TSC Rate。该rate表示TSC count down多少次会导致Preemption Timer Value count down一次，所以我成为“Rate”。
2. PTV（Preemption Timer Value）：在VMCS的VMX-preemption timer value域中设置的值
3. CPI（Cycle Per Instruction）：每个CPU指令需要消耗的CPU周期。在Intel架构中的Ideal CPI大约是0.25 [2]，但是在一般的应用中都会比这个值大一些。（注：CPI小于1的原因是多发射和超流水线结构）。
4. IPP（Instructions per Preemption）：Preemption Timer从开始设置到产生相关的VMEXIT时，VCPU执行了多少条CPU指令。
在这里我给出一个简单的计算方法：

IPP = PTV * PTTR / CPI

根据上述公式，可以简单的计算PTV和IPP之间的关系，根据每个Preemption中执行的指令数目来决定设置多大的Preemption Timer Value。

reffer: 
[1](http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html)  
[2](http://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-optimization-manual.html)

# kvm timer
host有自己的lapic timer，硬件实现，guest也有自己的lapic timer，kvm模拟。一个pcup上要运行很多个vcpu，每个vcpu都有自己的lapic timer，kvm要模拟很多个lapic timer，kvm用软件定时器hrtimer来模拟lapic timer，guest写tscdeadline msr，kvm把这个tsc值转换成一个软件定时器的值，启动软件定时器，硬件定时器驱动软件定时器，软件定时器超时后，假如硬件timer中断正好把vcpu exiting出来，那么设置timer interrupt pending，重新enter时把timer中断注入，如果vcpu运行在其它pcpu上，需要把vcpu kick出来，所以最好把timer绑定的物理cpu和vcpu所运行的物理cpu始终一致，如果vcpu运行的物理cpu变化了，migrate timer到新的物理cpu，这样中断来了vcpu自动exit，不再需要kick一次。

vmx-preemption timer: if the last vm entry was performed with the 1-setting of "activate vmx-preemption timer" vm-exection control, the vmx-preemption timer counts down from (from the value loaded by vm entry) in vmx non-root operation. when the timer counts down to zero, it stops counting down and a vm exit occurs. the vmx-preeption timer counts down at rate proportional to that the timestamp counter(tsc). specially, the timer counts down by 1 every time bit x in the tsc changes dues to a a tsc increment. the value of x is in the range 0-31 and can be determined by consulting the vmx capability msr ia32_vmx_misc.

preemption timer是intel vmx技术增加的一种硬件timer，和tsc相关，在VMCS中设置一个值 ，vm entry，时间到了，preemption timer就会触发vcpu exiting出来。vcpu写tscdeadline msr exiting出来，kvm把这个值写到VMCS中，enter non-root，时间到了exiting出来，设置pending，然后重新进入把中断注入。

```C
kvm_set_lapic_tscdeadline_msr
  -->start_apic_timer
      -->restart_apic_timer
          {
            if (!start_hv_timer(apic))
		        start_sw_timer(apic);
           }
```
这儿hv_timer就是preemption timer，sw_timer是软件hrtimer，有preemption timer就用hv_timer，没有就用sw_timer。hv_timer的问题就是可能时间没到，vcpu由于其它原因exit出来，那么就需要kvm_lapic_switch_to_sw_timer，再次enter时kvm_lapic_switch_to_hv_timer。

# 腾讯exit-less timer

guest write msr，kvm把timer配置到其它pcpu的local timer上，timer fire interrupt就不会导致本cpu exit，其它pcup用post interrupt注入本cpu，问题就是本vcpu write msr时还需要exit。

腾讯的补丁[[v7,0/2] KVM: LAPIC: Implement Exitless Timer](https://patchwork.kernel.org/project/kvm/cover/1562376411-3533-1-git-send-email-wanpengli@tencent.com/)

4.18内核没有，需要配置nohz_full隔离vcpu运行的pcpu，upstream已经合入，详见pi_inject_timer。

# 阿里exit-less timer

详见 kvm forum 《KVM performance tunning》by Yang Zhang
guest和kvm share page，kvm用其它pcpu poll这些page，guest配置timer时不write msr而是写这个share page，这样就不存在write msr exit，由于其它pcpu一直要poll有点浪费cpu。

阿里patch [qemu patch](https://www.spinics.net/lists/kvm/msg160295.html)

# 字节跳动exit-less timer

timer passthrough方案，相比阿里方案省了cpu poll，相比腾讯方案少了WRMSR exit，但切换来切换去，太复杂。

详见kvm forum 《Minimizing VMExits in Private Cloud by Aggressive PV IPI and Passthrough Timer》 by Huaqiao & Yibo zhou





```C
vmx_vcpu_run(vcpu) // Intel vm enter
    |-> vmx_exit_handlers_fastpath(vcpu) // Intel vmx vm-exit 快速判断 
            |-> 原因 EXIT_REASON_MSR_WRITE => handle_fastpath_set_msr_irqoff(kvm_vcpu) // 腾讯加速： 能够快速重新进入non-root
                |-> 写入MSR_IA32_TSC_DEADLINE => handle_fastpath_set_tscdeadline
                    |-> kvm_can_use_hv_timer(vcpu)
                    |-> kvm_set_lapic_tscdeadline_msr(vcpu, data); // 写入msr
            |-> EXIT_REASON_PREEMPTION_TIMER => handle_fastpath_preemption_timer(vcpu) // preemption timer
```