# dirty 

脏页速率在QEMU中定义为虚机单位时间内产生脏内存页的速率，用于描述虚机内存变化的快慢，脏页速率越大，虚机内存变化越快，迁移时花费的时间就越多。脏页速率计算公式为：
dirtyrate = increased_memory / meaurement_time

脏页速率计算的关键是如何获取单位时间内虚拟机新增的脏页数，不同的获取方式有不同的速率计算实现，QEMU已经实现了一种计算方式，即抽样，抽样方式假设虚机读写内存的区间是均匀随机的，但实际情况并非如此，因此存在一定误差。除抽样方式外，还有两种新的脏页速率计算实现（预计在6.1版本合入QEMU主线），分别是dirty-bitmap和dirty-ring。dirty-bitmap是一种新的脏页速率实现，通过查询dirty-bitmap，获取一段时间内新增的脏页数，计算脏页速率。dirty-ring同样是一种新的脏页速率实现，通过查询vcpu上脏页数，获取一段时间内vcpu上新增的脏页数，计算vcpu的脏页速率，从而得到整个虚机的脏页速率。

# Dirty ring
dirty ring和dirty bitmap都用于实现vcpu访问内存页的统计，相对于dirty bitmap，dirty ring的扩展性较好，因此可以在大内存规格的虚机上开启此特性。dirty bitmap的统计粒度是一个slot，而dirty ring的统计粒度更细，可以精确到一个vcpu甚至一个内存页，并且统计可以在用户空间进行，这几个特性对脏页统计的实现更友好。下面对dirty ring实现原理进行分析。

Dirty Ring整体结构如上图所示，每个vcpu维护一个ring，顾名思义ring一旦分配完成，填满了之后可以从头循环。这里ring的实现是一个数组，每个元素用来存放虚机的内存页框号(PFN - Page Frame Number)。当vcpu访问了物理页之后，PML Buffer被硬件填充，kvm会将PML Buffer中记录的GPA信息同步到dirty ring中。因为PML Buffer是per-cpu的，因此dirty ring也能够实现基于cpu粒度的脏页统计。
为了实现脏页统计，dirty ring的entry被定义了三种状态，分别是空状态(empty)、脏状态(dirty)和已搜集状态(collected)。空状态表初始化或无效的状态；脏状态表示kvm将PML Buffer中的信息已经拷贝到dirty ring中，等待用户态查询的状态；已搜集状态表示用户态已经完成查询，等待kvm重新复位dirty ring条目的状态。


三种状态转换如下图所示，初始状态dirty ring的entry处于EMPTY状态，当vcpu线程进入guest态开始运行后，如果开启了PML特性，并清零了shadow ept的脏标志，intel硬件在vcpu访问完物理页之后会填充PML Buffer，每次vm exit或者PML Buffer满的时候，kvm会将PML Buffer的内容填充到dirty ring中，每一个虚机物理页对应dirty ring中的一个entry，被填充的entry标记为DIRTY状态，当用户态需要搜集脏页信息时，按序访问dirty ring中的内容，访问完成后将其标记为COLLECTED状态，同时下发KVM_RESET_DIRTY_RINGS命令字通知KVM，kvm发现dirty ring中有entry为COLLECTED状态，会重新将其复位为EMPTY状态，同时清零shadow ept的脏标志，让硬件再次可以填充PML Buffer。


脏页信息的维护原理如上图所示，dirty ring中维护了三个索引，分别用来指向kvm存放脏页entry的位置(dirty index)，用户态搜集脏页entry的位置(collect index)，以及kvm复位脏页entry的位置。当kvm需要从PML Buffer将GPA内容填入dirty ring时，首先取dirty index，将GPA填入dirty index指向的entry，然后dirty index加1，如果有多个GPA，依次填入dirty ring的entry中，dirty index依次增加；当qemu需要搜集脏页信息时，首先取collect index，将其指向的entry依次读出，然后collect index增加，直到collect index和dirty index的位置相同，说明没有新增的脏页了，用户态搜集脏页完成，将entry标记为COLLECTED态，通过KVM_RESET_DIRTY_RINGS命令字通知kvm复位dirty ring；kvm在合适的时机触发dirty ring的状态复位，首先找到reset index，依次将它之后的entry复位，直到位置和collect index位置相同，说明接下来的entry用户态还没有搜集，不能复位了。


## 管理过程

### qemu


CPUState中维护了从内核mmap映射的dirty ring数据结构以及qemu获取dirty ring entry的索引
```C
struct CPUState {
    ......
    struct kvm_dirty_gfn *kvm_dirty_gfns;   /* 与内核共享的dirty ring */
    uint32_t kvm_fetch_index;               /* 搜集脏页时的起始索引，即上面所说的Collect index */
}
```

kvm_dirty_gfn: dirty ring entry, 通过slot和offset表示虚拟机的GFN，通过flags维护entry的状态机

```C
/*
 * KVM dirty GFN flags, defined as:
 *
 * |---------------+---------------+--------------|
 * | bit 1 (reset) | bit 0 (dirty) | Status       |
 * |---------------+---------------+--------------|
 * |             0 |             0 | Invalid GFN  |
 * |             0 |             1 | Dirty GFN    |
 * |             1 |             X | GFN to reset |
 * |---------------+---------------+--------------|
 *
 * Lifecycle of a dirty GFN goes like:
 *
 *      dirtied         collected        reset
 * 00 -----------> 01 -------------> 1X -------+
 *  ^                                          |
 *  |                                          |
 *  +------------------------------------------+
 */
struct kvm_dirty_gfn {
    __u32 flags;
    __u32 slot;
    __u64 offset;
};
```



### kvm

```C
struct kvm {
	......
	/* dirty ring大小:dirty ring的实现是一个数组，其大小就是数组元素的个数
	 * qemu在ioctl创建虚拟机之后，会查询内核是否具有dirty ring能力，如果有，
	 * 会通过KVM_CAP_DIRTY_LOG_RING命令字携带的参数设置dirty ring的大小
	 */
    u32 dirty_ring_size;	
}

struct kvm_vcpu {
	......
	/* vcpu维护的dirty ring结构，针对每个vcpu，记录其最近访问的内存页的页框号 */
    struct kvm_dirty_ring dirty_ring;
}
```
kvm_dirty_ring: dirty ring核心数据结构，维护dirty ring的元数据以及dirty ring本身，元数据包括脏页push位置索引和已搜集页reset位置索引

```c
struct kvm_dirty_ring {
	/* kvm填入PML Buffer的索引，每填入一个dirty index加1 */
    u32 dirty_index;    
    /* kvm复位entry为empty状态的索引，每复位一个
     * 需要将其对应的shadow ept表项对应的dirty位清零
     */
    u32 reset_index;
    u32 size;
   /* kvm在实现dirty ring时软件定义了一个ring size的上限
    * 它小于等于kvm真实分配的ring的大小，即soft_limit <= size
    * 当dirty ring被填充的entry大于soft_limit时，kvm会抛出
    * KVM_EXIT_DIRTY_RING_FULL异常，让vcpu退出到用户态 
    * 这个机制可以用来保证dirty ring不会真正的被填满 */
    u32 soft_limit;
    /* 与用户态共享的dirty ring */
    struct kvm_dirty_gfn *dirty_gfns;   
    int index;
};
```

### 配置Dirty Ring

配置dirty ring的主要目的就是设置ring数组的大小。qemu在调用了KVM_CREATE_VM ioctl命令字之后，会立即通过KVM_ENABLE_CAP ioctl命令字使能KVM_CAP_DIRTY_LOG_RING。KVM_ENABLE_CAP的携带的结构体kvm_enable_cap描述了要使能的扩展cap和需要的参数。这里就是KVM_CAP_DIRTY_LOG_RING特性，参数是ring size，放在了kvm_enable_cap结构体args域的第一个元素

vm ioctl 虚机vm fd的命令字，用于使能虚机KVM_CAP_DIRTY_LOG_RING能力
cmd: KVM_ENABLE_CAP
 
 parameter
 ```C
 /* for KVM_ENABLE_CAP */
struct kvm_enable_cap {
    /* in */
    __u32 cap;      /* 携带KVM_CAP_DIRTY_LOG_RING */
    __u32 flags;
    __u64 args[4];  /* args[0]存放dirty ring size */
    __u8  pad[64];
};
 ```

 
 dirty ring cap
Capability: KVM_CAP_DIRTY_LOG_RING
Architectures: x86
Parameters: args[0] - size of the dirty log ring

dirty ring的初始化工作分为两个部分：配置大小，分配并映射空间。第一部分是检查内核是否支持dirty ring并设置其大小。第二部分是内核每创建了一个vcpu，QEMU映射其dirty ring到自己的进程地址空间。实现dirty ring的共享。

一：配置大小
/* 虚拟机初始化入口 */
kvm_init
    /* 首先通过KVM_CREATE_VM命令字创建一个虚拟机 */
    kvm_ioctl(s, KVM_CREATE_VM, type)
    /* 通过KVM_CHECK_EXTENSION命令字查询kvm是否支持KVM_CAP_DIRTY_LOG_RING的能力 */
    kvm_vm_check_extension(s, KVM_CAP_DIRTY_LOG_RING)
        /******* kvm path start ********/
        kvm_vm_ioctl
        case KVM_CHECK_EXTENSION:
            kvm_vm_ioctl_check_extension_generic(kvm, arg)
            switch (arg)
            case KVM_CAP_DIRTY_LOG_RING:
            /* 内核通过 KVM_DIRTY_LOG_PAGE_OFFSET 宏控制dirty ring相关实现
             * 当 KVM_DIRTY_LOG_PAGE_OFFSET 未定义或者等于0时，表示没有未
             * 实现，反之内核实现了相关功能 */
#if KVM_DIRTY_LOG_PAGE_OFFSET > 0       
                return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
#else
                return 0;
#endif
        /******* kvm path end **********/
    /* 通过KVM_ENABLE_CAP命令将用户配置的dirty ring大小传递给内核进行配置 */
    kvm_vm_enable_cap(s, KVM_CAP_DIRTY_LOG_RING, 0, ring_size)
        /******* kvm path start ********/
        kvm_vm_ioctl
        case KVM_ENABLE_CAP:
            kvm_vm_ioctl_enable_cap_generic(kvm, &cap)
           switch (cap->cap)
            case KVM_CAP_DIRTY_LOG_RING:
                /* 取出QEMU传入的dirty ring大小，让kvm维护起来
                 * 之后每次创建vcpu的时候，据此判断是否初始化dirty ring */
                kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0])
                    kvm->dirty_ring_size = size
        /******* kvm path start ********/
    /* 如果kvm设置成功，设置QEMU KVMState结构体对应的参数，用于控制QEMU的脏页搜集行为
     * 并区分dirty bitmap。之后在搜集脏页时根据kvm_dirty_ring_enabled标志决定使用
     * dirty binmap还是dirty ring。reaper线程是否初始化也根据此标志判断 */
    s->kvm_dirty_ring_size = ring_size;
    s->kvm_dirty_ring_enabled = true;
 
二：分配并映射空间
/* vcpu初始化入口 */
kvm_init_vcpu
    /* 创建vcpu */
    kvm_get_vcpu
        /* QEMU下发KVM_CREATE_VCPU命令字创建vcpu */
        kvm_vm_ioctl(s, KVM_CREATE_VCPU, (void *)vcpu_id)
            /******* kvm path start ********/
            kvm_vm_ioctl
            case KVM_CREATE_VCPU:
                kvm_vm_ioctl_create_vcpu(kvm, arg)
                    /* kvm创建vcpu */
                    kvm_arch_vcpu_create(vcpu);
                    /* vcpu创建完成后，如果发现dirty ring被使能
                     * 为其分配空间，完成vcpu的dirty ring初始化 */
                    if (kvm->dirty_ring_size)
                        kvm_dirty_ring_alloc(&vcpu->dirty_ring, id, kvm->dirty_ring_size);    
            /******* kvm path end *********/
    /* 获取vcpu可mmap的内存大小 */
    mmap_size = kvm_ioctl(s, KVM_GET_VCPU_MMAP_SIZE, 0)
    /* 映射kvm提供的整个vcpu可映射空间 */
    cpu->kvm_run = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, cpu->kvm_fd, 0)
    /* 映射dirty ring到QEMU的进程地址空间 */
    cpu->kvm_dirty_gfns = mmap(NULL, s->kvm_dirty_ring_size, PROT_READ | PROT_WRITE, MAP_SHARED,
                     cpu->kvm_fd, PAGE_SIZE * KVM_DIRTY_LOG_PAGE_OFFSET)


### 初始化Dirty Ring
dirty ring size被设置后，放在kvm结构体中，当qemu下发KVM_CREATE_VCPU ioctl命令字的时候，kvm会检查dirty ring size是否被设置，如果设置了就初始化实现dirty ring的数组
Cmd: KVM_CREATE_VCPU
Capability: basic
Architectures: all
Type: vm ioctl
Parameters: vcpu id (apic id on x86)
Returns: vcpu fd on success, -1 on error
### 映射Dirty Ring
内核态与用户态共享dirty ring数据结构，该共享区域通过mmap实现，通过vcpu的fd映射固定的偏移(KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE)。映射长度通过调用KVM_CAP_DIRTY_LOG_RING查看。
复位Dirty Ring
qemu搜集到dirty ring的信息之后，除了将entry的状态设置为collected，还需要下发ioctl命令字通知kvm复位dirty ring的entry，让kvm清零页表项的脏位。这时候qemu会通过KVM_RESET_DIRTY_RINGS ioctl命令字通知kvm


### 脏页记录

dirty ring的脏页记录主要由kvm负责，其流程和dirty bitmap实现脏页统计的类似，只在具体脏页统计接口实现上有区别

vmx_handle_exit
    /* 每次vm exit之后，如果使能了pml特性，硬件会在退出前会更新PML buffer
     * 这个时候根据PML buffer中的GPA，标记bitmap
     */
    vmx_flush_pml_buffer
        pml_buf = page_address(vmx->pml_pg);
        for (; pml_idx < PML_ENTITY_NUM; pml_idx++) {
            /* 遍历PML Buffer中的每个条目，根据GPA地址标记对应的bit或者ring entry */
            gpa = pml_buf[pml_idx];
            kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
                /* 如果虚机开启了dirty ring，使用，反之则用dirty bitmap */
                if (kvm->dirty_ring_size)
                    kvm_dirty_ring_push(kvm_dirty_ring_get(kvm), slot, rel_gfn)
                else
                    set_bit_le(rel_gfn, memslot->dirty_bitmap);
        }
        
/* 脏页统计实现 */
kvm_dirty_ring_push
    /* 根据dirty index取出填入gfn的目的ring entry */
    entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)]
    entry->slot = slot;              /* 填入gfn所在的 slot */
    entry->offset = offset;          /* 填入gfn所在的 slot的偏移 */
    /* 将entry状态设置为脏 */
    kvm_dirty_gfn_set_dirtied(entry);
        gfn->flags = KVM_DIRTY_GFN_F_DIRTY
        
/* 进入guest态的入口 */
vcpu_enter_guest
	/* 如果dirty ring使能，检查dirty ring，计算已经使用的entry的总和
	 * 实际上就是处于COLLECTED+DIRTY状态总和，如果大于了soft_limit
	 * 表示已经达到了软件定义的上限需要标记KVM_EXIT_DIRTY_RING_FULL */
	if (unlikely(vcpu->kvm->dirty_ring_size &&
		kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
	}


### 脏页搜集

使用dirty ring机制实现的脏页统计，它的脏页搜集在QEMU中直接可以做，不需要通过ioctl命令字通知内核。QEMU的脏页搜集核心函数是kvm_dirty_ring_reap。有三种场景下需要调用reap函数。首先是普通的搜集场景。其次是kvm上报异常，dirty ring满的时候，需要搜集脏页，然后让kvm重置dirty ring中的表项。还有一种场景是需要刷新dirty ring的时候，这时kvm首先会kick所有vcpu让它们退出guest态，kvm在处理异常退出时将PML buffer中的内容同步到dirty ring中，这样用户态的QEMU也能获取最新的dirty ring信息。同时，QEMU还为搜集内存脏页专门创建了一个名为kvm-reaper的线程。

1. 普通场景
/* 虚机初始化入口 */
kvm_init
    /* 如果使能了dirty ring，创建kvm-reaper线程
     * 搜集dirty ring记录的脏页信息 */
    if (s->kvm_dirty_ring_enabled)
        kvm_dirty_ring_reaper_init
            kvm_dirty_ring_reaper_thread
                kvm_dirty_ring_reap
                    kvm_dirty_ring_reap_locked
                        kvm_dirty_ring_reap_one
2. dirty ring满的时候
kvm_cpu_exec
    switch (run->exit_reason)
    case KVM_EXIT_DIRTY_RING_FULL:
        kvm_dirty_ring_reap
3. 脏页信息同步时候
kvm_memory_listener_register
    kml->listener.log_sync_global = kvm_log_sync_global
        kvm_log_sync_global
            kvm_dirty_ring_flush
                kvm_dirty_ring_reap


### 状态复位

一旦用户态搜集动作完成，需要下发ioctl通知kvm将dirty ring entry复位，以便下一次迭代。因此这个动作时在脏页搜集之后立马做的。kvm解析KVM_RESET_DIRTY_RINGS命令字之后，会做两个核心动作，一是将dirty ring的entry状态设置成invalid，另一个时更新shadow ept页表，将每个entry对应页表项的脏位清零。这样cpu在开启的PML特性之后，会在访问页表项对应物理页之后，硬件会标脏表项中对应的脏位


用户态：
kvm_dirty_ring_reap
    kvm_dirty_ring_reap_locked
        kvm_vm_ioctl(s, KVM_RESET_DIRTY_RINGS)
内核态：
kvm_vm_ioctl
    case KVM_RESET_DIRTY_RINGS:
    kvm_vm_ioctl_reset_dirty_pages
        kvm_dirty_ring_reset
            /* 将dirty ring的entry使无效 */
            kvm_dirty_gfn_set_invalid
                gfn->flags = 0;
            kvm_reset_dirty_gfn
            /* 清零gfn对应的页表项中的脏位 */
                kvm_arch_mmu_enable_log_dirty_pt_masked
