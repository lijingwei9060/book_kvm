# IOMMU + PI

IOMMU硬件单元也可以借用post interrupt机制把passthrough设备产生的中断直接投递到虚拟机中，不需要虚拟机exit出来，不需要VMM软件介入，性能非常高。这种情况设备产生的中断从原来`interrupt remapping`格式变成`post interrupt`格式，IRTE内容也变了，它中存放`post interrupt descriptor`的地址和虚拟中断vector，物理中断到了IOMMU，IOMMU硬件单元直接IRTE中虚拟中断vector写到`post interrupt descriptor`中pir对应的位，然后通过其他CPU给vcpu所在的物理cpu发送一个中断（IPI），中断号就是`post interrupt descriptor`中的NV。



虚机处于运行状态。当虚机正在运行时，来个一个外部中断，那么理想的方式就是不用vm exit就可以响应中断，而Posted-Interrupt就是干这个的，针对这种情况，后面会具体阐述。如果没有Posted-Interrupt，那么对于一个正在运行的虚机，通过IPI使其vm exit->中断注入->vm entry响应中断。虚机不在运行。对于一个这样的虚机，只需要中断注入->vm entry响应中断，所以vm entry越早(即尽快使vCPU投入运行)，中断响应越实时。Interrupt Remapping时通过配置urgent选项就是为了提高响应速度。

Interrupt-posting是VT-d中中断重映射功能的一个扩展功能，该功能也是针对可重映射的中断请求。Interrupt-posting功能让一个可重映射的中断请求能够被暂时以一定的数据形式post（记录）到物理内存中，并且可选择性地主动告知CPU物理内存中暂时记录着pending的中断请求。
VT-d重映射硬件是否支持Interrupt-posting功能可以通过查询Capability Register的bit 59 Posted Interrupt Support（PI）知道硬件是否支持该功能。

Interrupt Posting的功能就是让系统可以选择性地将中断请求暂存在内存中，让CPU主动去获取，而不是中断请求一过来就让CPU进行处理，这样在虚拟化的环境中，就能够防止外部中断频繁打断vCPU的运行，从而提高系统的能能。

post interrupt是intel提供的一种硬件机制，不用物理cpu从root模式exit到non-root模式就能把虚拟中断注入到non-root模式里，大概实现就是把虚拟中断写到post interrupt descriptor，预定义了一个中断号，然后给non-root模式下的cpu发送这个中断，non-root模式下cpu收到这个中断触发对virtual-apic page的硬件模拟，从post interrupt descriptor取出虚拟中断更新到virtual-apic page中，虚拟机中读virtual-access page，就能取到虚拟中断，处理中断，然后写EOI，触发硬件EOI virtulization，就能把virtual-apic page和post interrupt descriptor中数据清除。

post interrupt descriptor: 512位
PIR(post interrupt registry)总共256位，一位代表一个虚拟中断。ON代表预先定义的中断已经发出，如果已经为1就不要再发预先定义的中断了。SN代表不要再发中断。NV就是预先定义好的那个中断号，NDST就是物理CPU的local apic id。

vmcs中管理pi的字段：
- pi desc address 指向 pir/pid
- posted interrupt notification vector

kvm用post interrupt模式给vcpu注入中断，kvm修改这个vcpu的post interrupt descriptor，然后给这个vcpu所运行的物理cpu发送中断号是post interrupt notification vector的中断。kvm只用到了post interrupt descriptor中的ON，用到的notification vector存放在VMCS中而不是post interrupt descriptor中，主要是kvm运行在另一个物理cpu上，一个vcpu有没有运行，运行在哪个物理cpu上，这个vcpu可不可以接收中断，kvm很好判断，如果没有运行或者不能接收中断kvm在把虚拟中断存放在其它地方。

vmx_x86_ops，.deliver_posted_interrupt = vmx_deliver_posted_interrupt

当vCPU正在运行时，有posted-interrupt notification vector产生，此时虚机不需要vm exit，那么对于3、4两个操作是硬件自己做的，还是通过物理机上的posted-interrupt notification vector服务程序做的。通过查看smp_kvm_posted_intr_ipi函数commit信息，整个posted-interrup过程对vmm是透明的，smp_kvm_posted_intr_ipi函数就是当vcpu挂起的时候用的，通过这些信息说明3、4两个操作是硬件自己做的。

kvm_vcpu_trigger_posted_interrupt 这里面先判断vcpu是否处于guest mode(vcpu->mode == IN_GUEST_MODE)，如果是，说明正在运行，那么假设现在不在运行，然后另一个核给投入运行了，然后在发送也没啥事，因为先给ipr置位了，一旦执行了vm entry就响应中断了。

## 功能逻辑

硬件是否支持PI？Capability Register的bit 59 Posted Interrupt Support（PI）知道硬件是否支持该功。
IRTE？ 中断都需要经过IRTE（Interrupt Remapping Table Entry）的处理，在进行处理之前会先通过IRTE的bit 15（IRTE Mode）判断该IRTE的模式，如果为0，则VT-d硬件将会以Remapped Interrupt的形式来解析该IRTE（，如果为1，则VT-d硬件将会以Posted Interrupt的形式来解析该IRTE。

当VT-d硬件接收到其旗下I/O设备传递过来的中断请求时：
1. 先查看自己的中断重定向功能是否打开，如果没有打开则，直接上传给LAPIC。
2. 如果中断重定向功能打开，则会查看中断请求的格式，如果是不可重定向格式，则直接将中断请求提交给LAPIC。
3. 如果是可重定向的格式，则会根据算法计算Interrupt_Index值，对中断重定向表进行索引找到相应的IRTE。
4. 查看IRTE中的Interrupt Mode，如果为0，则该IRTE的格式为Remapped Format，即立即根据IRTE的信息产生一个新的中断请求，提交到LAPIC。
5. 如果Interrupt Mode为1，则表示该IRTE的格式为Posted Format，根据IRTE中提供的Posted Interrupt Descriptor的地址，在内存中找到相应Posted Interrupt Descriptor
   1. 并根据其ON、URG和SN的设置判断是否需要立即产生一个Notification Event（Outstanding Notification为0，并且该中断为Urgent（URG=1）或者不抑制该Notification（SN==0））
   2. 如果不需要，则只是将该中断信息记录到Posted Interrupt Descriptor的PIRR（Posted Interrupt Request Register）字段，等待CPU的主动处理。
   3. 如果需要立即产生一个Notification Event，则根据Posted Interrupt Descriptor（会提供目标APIC ID、vector、传输模式和触发模式等信息）产生一个Notification Event，并且将该中断请求记录到PIRR字段。

VMM可能会对Interrupt Posting做如下设置和操作：

1. 对于每个vCPU而言，VMM都会分配一个对应的Posted Interrupt Descriptor用于记录和传递经过重定向，并且目的地为对应vCPU的所有中断请求。
2. VMM软件为所有的Notification Event分配两个物理中断vector：
   1. 第一个称作Active Notification Vector（ANV），该Vector对应到当中断目标vCPU当前正在被逻辑CPU执行（即vCPU的状态为active）时，Notification Event所使用的中断vector。
   2. 第二个称作Wake-up Notification Vector（WNV），该Vector对应到中断目标vCPU当前不在逻辑CPU上被执行时，由于Urgent被置起来产生的Notification Event所使用的中断Vector。
3. 对于从直接分配给VM的I/O设备产生的中断而言，VMM会为每个这样的中断分配一个IRTE。并且VMM可能会为vCPU使能硬件上的APIC Virtualization，APIC Virtualization主要包括两方面功能：virtual-interrupt delivery和process posted-interrupts，其主要工作形式表现在：
   1. 当一个vCPU被VMM调度即将执行的时候，该vCPU的状态为active，该状态的一个表现形式是VMM会将Posted Interrupt Descriptor的Notification Vector字段设置为ANV（Active Notification Vector）。这样就允许当这个vCPU在逻辑CPU上执行的时候，所有指向该vCPU的中断都能够直接被该vCPU处理，不需要经过VMM。vCPU通过将记录在Posted Interrupt Descriptor中的中断直接转移到Virtual-APIC Page中，并直接将中断信号传递给vCPU，让vCPU直接获取到该中断信号的方式来处理Notification Event。
   2. 当一个vCPU被抢占后，即vCPU的状态为ready-to-run，该状态的一个表现形式是VMM会将Posted Interrupt Descriptor的Notification Vector字段设置为WNV（Wake-up Notification Vector），并且SN（Suppress Notification）设置为1。只有当接收到的中断请求为Urgent的时候，才会发出Notification Event，触发VMM的执行，让VMM调度目标vCPU处理该紧急中断。
   3. 当一个vCPU处于Halt状态的时候，逻辑CPU执行VMM软件，VMM将该vCPU标记为halted状态。该状态的一个表现形式就是将Posted Interrupt Descriptor的Notification Vector字段设置为WNV（Wake-up Notification Vector），并且SN（Suppress Notification）设置为0，即任何到达该Posted Interrupt Descriptor的中断请求都会触发Notification Event，让VMM唤醒vCPU，让vCPU处理中断请求。
4. 当VMM调度并执行一个vCPU的时候，VMM会对被记录到Posted Interrupt Descriptor的中断请求进行处理：
   1. 首先，VMM会通过将Posted Interrupt Descriptor的Notification Vector字段的值改为ANV将vCPU的状态变为active。
   2. VMM检测在Posted Interrupt Descriptor中是否有待处理的中断请求。
   3. 如果有待处理的中断请求，则VMM会给当前CPU发送一个sefl-IPI中断（即CPU自己给自己发送一个中断），并且中断向量值为ANV。当vCPU一使能中断的时候，就能够立马识别到该中断。该中断的处理类似于vCPU处于active状态时，接收到了Active Notification Vector的中断请求，vCPU可以直接对其进行处理，不需要VMM的参与。

同样VMM可以可以利用Posted Interrupt的处理机制，通过设置Posted Interrupt Descriptor向vCPU注入中断请求。

Posted Interrupt Descriptor 格式：

1. Posted Interrupt Requests （PIR），一共256 bit，每个bit对应一个中断向量（Vector），当VT-d硬件将中断请求post过来的时候，中断请求相应的vector对应的bit将会被置起来。
2. Outstanding Notification（ON），表示对于该Posted Interrupt Descriptor当前是否已经发出了一个Notification Event等待CPU的处理。当VT-d硬件将中断请求记录到PIR的时候，如果ON为0，并且允许立即发出一个Notification Event时，则将会将ON置起来，并且产生一个Notification Event；如果ON已经被置起来，则VT-d硬件不做其他动作。
3. Suppress Notification（SN），表示当PIR寄存器记录到non-urgent的中断时，是否不发出Notification Event，如果该位为1，则当PIR记录到中断的时候，则不发出Notification Event，并且不更改Outstanding Notification位的值。
4. Notification Vector（NV）表示如果发出Notification Event时，具体的Vector值。
5. Notification Destination（NDST），表示若产生Notification Event时，传递的目标逻辑CPU的LAPIC ID（系统中以逻辑CPU的LAPIC ID来表示具体的逻辑CPU，BIOS/UEFI其初始化系统的时候，会为每个逻辑CPU分配一个唯一的LAPIC ID）。

## 设置irte

在passthrough虚拟机外设后，虚拟机中的设备驱动会会通过pci config space注册中断处理函数，qemu会拦截pci配置空间的读写，将虚拟中断同步到kvm的irq routing entry，kvm再将中断信息写入到IRTE中。

一个passthrough给虚拟机的外设，虚拟机里driver给外设分配虚拟中断，qemu拦截到对外设pci config space的写，然后把虚拟中断更新到kvm的irq routing entry中，kvm再调用`pi_update_irte`把post interrupt descriptor地址和虚拟中断号更新到IRTE中。

```shell
kvm_set_irq_routing()
  void kvm_irq_routing_update(struct kvm *kvm)
    kvm_arch_update_irqfd_routing
      vmx_x86_ops.pi_update_irte = vmx_pi_update_irte
        └─irq_set_vcpu_affinity
            └─intel_ir_set_vcpu_affinity
                  └─modify_irte
```
## sched in设置通知中断NV/NDST,清楚SN

vt-x posted interrupt就是另一个CPU更新了vcpu的post interrupt descriptor，发送一个ipi给vcpu运行的物理CPU。vt-d posted interrupt就是IOMMU硬件单元更新了vcpu的post interrupt descriptor。vt-x和vt-d post interrupt都不会导致vcpu运行的物理CPU从non-root模式exit到root模式，而且能把vcpu的中断注入到guest。但vt-d相比vt-x就弱智多了，一个vcpu有没有运行，运行在哪个物理cpu上，这个vcpu可不可以接收中断，或者vcpu从一个物理cpu迁移到另一个物理cpu，vt-d IOMMU都不能自己判断，只能通过kvm告诉它，所以kvm就把这些信息写到post interrupt descriptor的其它位中，IOMMU来读，这些位就是SN，NDST和NV。

vcpu转换为运行状态，vmx_vcpu_pi_load清除SN，更新NDST。

```shell
vcpu_load
  └─preempt_notifier_register

context_switch
  └─finish_task_switch
      └─fire_sched_in_preempt_notifiers
          └─ __fire_sched_in_preempt_notifiers
               └─kvm_sched_in
                   └─kvm_arch_vcpu_load
                      └─kvm_x86_vcpu_load
                           └─vmx_vcpu_pi_load
```
## sched out, 设置SN

vcpu暂时挂起，设置SN。
```shell
vmx_vcpu_put
    └─vmx_vcpu_pi_put
        pi_set_sn(pi_desc); // 设置SN
```
## block， 设置NDST，NV= wakeup

虚拟机执行hlt指令vcpu暂停，保留原先运行的物理cpu到NDST，设置NV为wakeup vector
```shell
vcpu_block
    └─vmx_pre_block
         └─pi_pre_block
```

如果此时IRTE中URG为1，IOMMU就给物理cpu发送wakeup vector，`pi_wakeup_handler`让vcpu开始运行。

```shell
DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_posted_intr_wakeup_ipi)
{
	ack_APIC_irq();
	inc_irq_stat(kvm_posted_intr_wakeup_ipis);
	kvm_posted_intr_wakeup_handler();
}
kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
```

vcpu开始运行，更新NDST，理想NV为post interrupt vector。
```shell
vmx_post_block           
  └─pi_post_block
```
