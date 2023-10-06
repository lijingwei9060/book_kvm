# 介绍

整体的中断优化过程：
1. vt-x里面的virtual interrupt delivery 解决对于虚拟机的虚拟中断投递，但是对于使用sr-iov或者vfio场景中的真实物理中断需要使用posted interrupt。
2. posted interrupt实在vt-d里面提供的技术，解决运行中的虚拟机物理中断投递的问题，减少vm-exit。
3. IPI 虚拟化，什么场景使用ipi呢？
4. EOI 虚拟化，结束中断的时候会写lapic的寄存器，导致vm-exit。vapic page access？


vapic 
apic page base address
apic page access 