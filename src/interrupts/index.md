1. 中断介绍
   1. 哪些类型：NMI、INTX(异常、中断、陷入)
   2. 什么作用？ 通知事件发生，需要CPU介入处理
   3. 信号形式： INTR、MSI、MSI-X
2. 中断控制器
   1. PIC：PIN、寄存器、存在问题
   2. APIC
      1. IOAPIC： PIN、寄存器
      2. LAPIC： PIN、寄存器
      3. IOMMU： 寄存器
      4. DMAR： 寄存器
   3. MSI
      1. PIN
      2. MSI-x
   4. 中断处理过程
      1. level
      2. edge
   5. 中断拓扑结构：APIC_PIC、APIC_VIRTUAL_WIRE、APIC_SYMMETRIC_IO
3. 中断框架
   1. 中断管理： irq_desc,链表，申请，释放
   2. 中断控制器管理
   3. 中断处理过程
   4. 
4. 虚拟中断
   1. 虚拟中断控制器
   2. 虚拟中断投递
   3. APIC虚拟化
   4. PI
   5. vIPI
   6. vEOI