# 概述

1. 内核中创建了一个struct eventfd_ctx结构体，该结构体中维护一个count计数，以及一个等待队列头；
2. 线程/进程在读eventfd时，如果count值等于0时，将当前任务添加到等待队列中，并进行调度，让出CPU。读过程count值会进行减操作；
3. 线程/进程在写eventfd时，如果count值超过最大值时，会将当前任务添加到等待队列中（特殊情况），写过程count值会进行加操作，并唤醒在等待队列上的任务；
4. 内核的其他模块也可以通过eventfd_signal接口，将count值加操作，并唤醒在等待队列上的任务；

eventfd机制对用户层提供的系统调用接口包括eventfd()，write()，read()，select/poll等；

通过eventfd来创建文件描述符，从代码中可以看出，该接口的实现为do_eventfd，完成的工作包括：
1. 在内核中分配struct eventfd_ctx结构体来维护上下文；
2. 初始化等待队列头用于存放睡眠等待的任务；
3. 分配未使用的文件描述符fd，创建file实例（该实例会绑定操作函数集），将文件描述符fd与file实例建立连接等；

最终系统调用read/write时，便会分别调用到eventfd_read/eventfd_write函数：
- eventfd_read：如果count值为0，将自身添加到等待队列中，设置任务的状态后调用schedule让出CPU，等待被唤醒。读操作中会对count值进行减操作，最后再判断等待队列中是否有任务，有则进行唤醒；
- eventfd_write：判断count值在增加ucnt后是否会越界，越界则将自身添加到等待队列中，设置任务的状态后调用schedule让出CPU，等待被唤醒。写操作会对count值进行加操作，最后再判断等待队列中是否有任务，有则进行唤醒；

此外，还有eventfd_signal接口，比较简单，完成的工作就是对count值进行加操作，并唤醒等待任务；

## 内核过程

do_eventfd() // 初始化
|-> kmalloc() // 分配eventfd_ctx结构
|-> init_waitqueue_head() //  初始化结构体的等待队列头
|-> get_unused_fd_flags() // 分配文件描述符fd
|-> anon_inode_getfile(,&ventfd_ops) // 分配文件file实例， ops包含poll、read/write
|-> fd_install() // 将file实例添加到fd数组中

eventfd_write()
|-> count > max => __add_wait_queue 数值越界需要休眠，让出cpu，放到等待队列里面
|-> count += cnt => waitqueue_active 激活任务


## ioeventfd

ioeventfd： 提供一种机制，可以通过文件描述符fd来接收Guest的信号

1. Qemu中模拟PCI设备时，在初始化过程中会调用memory_region_init_io来进行IO内存空间初始化，这个过程中会绑定内存区域的回调函数集，当Guest OS访问这个IO区域时，可能触发这些回调函数的调用；
2. Guest OS中的Virtio驱动配置完成后会将状态位置上VIRTIO_CONFIG_S_DRIVER_OK，此时Qemu中的操作函数调用virtio_pci_common_write，调用流逐级往下；
3. Qemu中 event_notifier_init：完成eventfd的创建工作，它实际上就是调用系统调用eventfd()的接口，得到对应的文件描述符；
4. Qemu中 memory_region_add_eventfd：为内存区域添加eventfd，将eventfd和对应的内存区域关联起来；
5. 内存区域MemoryRegion中的ioeventfds成员按照地址从小到大排序，memory_region_add_eventfd函数会选择合适的位置将ioeventfds插入，并提交更新；
6. 提交更新过程中最终触发回调函数kvm_mem_ioeventfd_add的执行，这个函数指针的初始化是在Qemu进行kvm_init时，针对不同类型的内存区域注册了对应的memory_listener用于监听变化；
7. kvm_vm_ioctl：向KVM注册ioeventfd；进入kvm处理。
8. KVM中注册ioeventfd的核心函数为kvm_assign_ioeventfd_idx，该函数中主要工作包括：
   - 根据用户空间传递过来的fd获取到内核中对应的struct eventfd_ctx结构体上下文；
   - 使用ioeventfd_ops操作函数集来初始化IO设备操作；
   - 向KVM注册IO总线，比如KVM_MMIO_BUS，注册了一段IO地址区域，当操作这段区域的时候出发对应的操作函数回调；
9. 当Guest OS中进行IO操作时，触发VM异常退出，KVM进行捕获处理，最终调用注册的ioevnetfd_write，在该函数中调用eventfd_signal唤醒阻塞在eventfd上的任务，Qemu和KVM完成了闭环；


## irqfd