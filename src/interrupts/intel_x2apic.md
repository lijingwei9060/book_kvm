
## Message Signalled Interrupts
MSI (Message Signalled Interrupt)是PCI总线引入的功能，它本质上就是在中断发生时，不通过带外（Side-band）的中断信号线（INTx机制），而是通过带内（In-band）的PCI写入事务来通知中断的发生。

从原理上来说，MSI产生的事务与一般的DMA事务并无本质区别，需要依赖Platform Specific的特殊机制从总线事务中区分出MSI并作赋予其中断的语义。在x86平台上，是由Host Bridge/Root Complex负责这一职责，将MSI事务翻译成System Bus上的中断消息，凡目标地址落在`[0xFEE00000, 0xFEEFFFFF]`这个区间的写入事务都会被视为MSI中断请求并翻译成中断消息。

一个MSI事务由Address和Data构成，每个设备可以配置其发生中断时产生的MSI事务的Address和Data，并且可以在不同事件发生时产生不同的MSI事务（即不同的Address, Data对），在x86平台上它们的格式分别定义如下：

Message Address：

1. 第0-1位为Ignored
2. 第2位为Destination Mode (DM)，取0表示Physical Mode，取1表示Logical Mode
3. 第3位为Redirection Hint (RH)，取1表示Lowest Priority Mode
  - RH = 0时，DM = 0表示Physical Mode，DM = 1表示Logical Mode,手册上写DM会被忽略，但实际上它是起作用的
  - RH = 1, DM = 0的组合相当于Physical Mode，但禁止进行广播
  - RH = 1, DM = 1的组合表示通常理解的Lowest Priority Mode（即一组CPU中选取一个发送）
4. 第12-19位为Destination ID，和ICR寄存器中的Destination作用相同
5. 第20-31位，必须为0xFEE
6. 其余位保留

Message Data：

1. 第0-7位为Vector，即目标CPU收到的中断向量号，其中0-15号被视为非法，会给目标CPU的APIC产生一个Illegal Vector错误
2. 第8-10位为Delivery Mode，有以下几种取值：
  - 000b (Fixed)：按Vector的值向所有目标CPU发送相应的中断向量号
  - 001b (Lowest Priority)：按Vector的值向所有目标CPU中优先级最低的CPU发送相应的中断向量号
  - 010b (SMI)：向所有目标CPU发送一个SMI，为了兼容性Vector必须为0，SMI总是Edge Triggered的（即会忽略TM的设置）
  - 100b (NMI)：向所有目标CPU发送一个NMI，此时Vector会被忽略，NMI总是Edge Triggered的
  - 101b (INIT)：向所有目标CPU发送一个INIT IPI，导致该CPU发生一次INIT，此模式下Vector必须为0，INIT总是Edge Triggered的
  - 111b（ExtINT）：向所有目标CPU发送一个与8259A PIC兼容的中断信号，将会引起一个INTA周期，目标CPU在该周期向外部控制器索取Vector，ExtINT总是Edge Triggered的
3. 第14位为Level，若中断是Level Triggered的，则取1表示Assert，取0表示Deassert
4. 第15位为Trigger Mode，取0表示Edge Triggered，取1表示Level Triggered
5. 其余位保留

关于RH、DM和Delivery Mode的作用，手册语焉不详，我们需要对手册进行解读和澄清。

首先，手册称RH = 0时，会忽略DM的值：

When RH is 0, the interrupt is directed to the processor listed in the Destination ID field.If RH is 0, then the DM bit is ignored and the message is sent ahead independent of whether the physical or logical destination mode is used.按照通常的理解，这表示DM位取0或取1没有区别。根据手册中的描述，似乎RH = 0时中断是按照Physical Mode发送的。然而，这种理解是错误的，实际上RH = 0时，DM位仍然起作用，DM = 1仍旧表示Logical Mode。我们可以这样理解：在ICR寄存器中有Destination Mode位，显然DM位是System Bus上中断消息的一部分。尽管手册中说DM位被忽略，但北桥产生的中断消息中DM位仍是取自MSI Message的DM位，而不是设置为0。

其次，Delivery Mode中已经有了Lowest Priority Mode，再添加Redirection Hint这个位功能上岂不是重复了？这个问题要分两个角度看：

从功能的角度看，实际上Delivery Mode不选择Fixed/Lowest Priority，RH取1，能够实现SMI/NMI/INIT/ExtINT发送到Lowest Priority的CPU，这是原本没有RH时做不到的，说明RH位确实提供了新功能
从设计的角度看，Redirection Hint位本身是为Itanium设计的，只是为了同一套北桥硬件同时支持Itanium和x86，才将RH套用到了x86上，从而和其已有的Lowest Priority Mode功能形成了重复
总而言之，功能确实部分重叠，但RH位也带来了新的可能性，不算完全没用。

References:
[1] https://lkml.org/lkml/2018/9/6/365
[2] https://software.intel.com/en-us/forums/virtualization-software-development/topic/288883
[3] https://www.spinics.net/lists/kvm/msg114915.html
[4] https://lists.gnu.org/archive/html/qemu-devel/2015-03/msg04949.html
[5] https://github.com/jfsulliv/JamesSullivan1.github.io/blob/master/_posts/2015-03-14-understanding-message-signalled-interrupts.md


