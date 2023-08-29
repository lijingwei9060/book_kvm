# intro

1. virtio-blk是一个virtio设备，它看到的队列是virtqueue，里面没有vring的实现，只记录了vring中还有多少空闲的buffer可以使用
2. vring_virtqueue是一个virtqueue，它将VRing的实现隐藏在virtqueue下面，当一个virtio-blk设备真正要发送数据时，只要传入virtqueue就能找到VRing并实现数据收发


VRing由三部分组成：
1. Descriptor Table: 存放Guest Driver提供的buffer的指针，每个条目指向一个Guest Driver分配的收发数据buffer。VRing中buffer空间的分配永远由Guest Driver负责，Guest Driver发数据时，还需要向buffer填写数据，Guest Driver收数据时，分配buffer空间后通知Host向buffer中填写数据
2. Avail Ring: 存放Decriptor Table索引，指向Descriptor Table中的一个entry。当Guest Driver向Vring中添加buffer时，可以一次添加一个或多个buffer，所有buffer组成一个Descriptor chain，Guest Driver添加buffer成功后，需要将Descriptor chain头部的地址记录到Avail Ring中，让Host端能够知道新的可用的buffer是从VRing的哪个地方开始的。Host查找Descriptor chain头部地址，需要经过两次索引Buffer Adress = Descriptor Table[Avail Ring[last_avail_idx]]，last_avail_idx是Host端记录的Guest上一次增加的buffer在Avail Ring中的位置。Guest Driver每添加一次buffer，就将Avail Ring的idx加1，以表示自己工作在Avail Ring中的哪个位置。Avail Rring是Guest维护，提供给Host用。driver生产的data，device来消费，被称为avail virtqueue,该表只有driver可写.
3. Used Ring: 存放Decriptor Table索引。当Host根据Avail Ring中提供的信息从VRing中取出buffer，处理完之后，更新Used Ring，把这一次处理的Descriptor chain头部的地址放到Used Ring中。Host每取一次buffer，就将Used Ring的idx加1，以表示自己工作在Used Ring中的哪个位置。Used Ring是Host维护，提供给Guest用。device生产的data，driver来消费,该表只有device可写。


struct vring_avail, Guest通过Avail Ring向Host提供buffer，指示Guest增加的buffer位置和当前工作的位置
```C
struct vring_avail {
   __virtio16 flags;
   __virtio16 idx;
   __virtio16 ring[];
}; 
```
1. flags：用于指示Host当它处理完buffer，将Descriptor index写入Used Ring之后，是否通过注入中断通知Guest。如果flags设置为0，Host每处理完一次buffer就会中断通知Guest，从而触发VMExit，增加开销。如果flags为1，不通知Guest。这是一种比较粗糙的方式，要么不通知，要么通知。还有一种比较优雅的方式，叫做`VIRTIO_F_EVENT_IDX`特性，它根据前后端的处理速度，来判断是否进行通知。如果该特性开启，那么flags的意义将会改变，Guest必须把flags设置为0，然后通过used_event机制实现通知。
2. idx：指示Guest下一次添加buffer时的在Avail Ring所处的位置，换句话说，idx存放的ring[]数组索引，ring[idx]存放才是下一次添加的buffer头在Descriptor Table的位置。
3. ring：存放Descriptor Table索引的环，是一个数组，长度是队列深度加1个。其中最后一个用作Event方式通知机制。VirtIO实现了两级索引，一级索引指向Descriptor Table中的元素，Avail Ring和Used Ring代表的是一级索引，核心就是这里的ring[]数组成员。二级索引指向buffer的物理地址，Descriptor Table是二级索引。


struct vring_used, Host通过Used Ring向Guest提供信息，指示Host处理buffer的位置
```C
struct vring_used {
    __virtio16 flags;
    __virtio16 idx;
    struct vring_used_elem ring[];
};

/* u32 is used here for ids for padding reasons. */
struct vring_used_elem {
    /* Index of start of used descriptor chain. */
    __virtio32 id;
    /* Total length of the descriptor chain which was used (written to) */
    __virtio32 len;
};
```

1. flags：用于指示Guest当它添加完buffer，将Descriptor index写入Avail Ring之后，是否发送notification通知Host。如果flags设置为0，Guest每增加一次buffer就会通知Host，如果flags为1，不通知Host。Used Ring flags的含义和Avail Ring flags的含义类似，都是指示前后端数据处理完后是否通知对方。同样的，当`VIRTIO_F_EVENT_IDX`特性开启时，flags必须被设置成0，Guest使用`avail_event`方式通知Host。
2. idx：指示Host下一次处理的buffer在Used Ring所的位置
3. ring：存放Descriptor Table索引的环。意义和Avail Ring中的ring类似，都是存放指向Descriptor Table的索引。但Used Ring不同的是，它的元素还增加了一个len字段，用来表示Host在buffer中处理了多长的数据。

VRing包含数据传输的所有要素，包括Descriptor Table，Avail Ring和Used Ring，其中Descriptor Table是一个数组，每个Entry描述一个数据的buffer，Descriptor Table存放的是指针，Avail Ring和Used Ring中的ring数组则不同，它们存放的是索引，用来间接记录Descriptor chain
```C
struct vring {
    /* VRing的队列深度，表示一个VRing有多少个buffer */
    unsigned int num;
    /* 指向Descriptor Table */
    struct vring_desc *desc;
    /* 指向Avail Ring */
    struct vring_avail *avail;
    /* 指向Used Ring */
    struct vring_used *used;
};
```

virtqueue用作在Guest与Host之间传递数据，Host可以在用户态（qemu）实现，也可以在内核态（vhost）实现。一个virtio设备可以是磁盘，网卡或者控制台，可以拥有一个或者多个virtqueue，每个virtqueue独立完成数据收发。virtqueue数量多少根据设备的需求来定，比如网卡，通常有两个virtqueue，一个用来接收数据，一个用来发送数据。

```C
/**                   
 * virtqueue - a queue to register buffers for sending or receiving.
 * @list: the chain of virtqueues for this device
 * @callback: the function to call when buffers are consumed (can be NULL).
 * @name: the name of this virtqueue (mainly for debugging)
 * @vdev: the virtio device this queue was created for.
 * @priv: a pointer for the virtqueue implementation to use.
 * @index: the zero-based ordinal number for this queue.
 * @num_free: number of elements we expect to be able to fit.
 *
 * A note on @num_free: with indirect buffers, each buffer needs one
 * element in the queue, otherwise a buffer will need one element per
 * sg element.
 */
struct virtqueue {
    struct list_head list;
    void (*callback)(struct virtqueue *vq);
    const char *name;
    struct virtio_device *vdev;
    unsigned int index;
    unsigned int num_free;	// virtqueue中剩余的buffer数量，初始化时该大小是virtqueue深度
    void *priv;
};
```


struct vring_virtqueue, virtqueue是virtio设备看到的队列形式，真正实现数据传输的VRing不会被设备看见，它隐藏在virtqueue的下面，和virtqueue一起，组成了vring_virtqueue。
```C
struct vring_virtqueue {
	/* 设备看到的VRing */
    struct virtqueue vq;
    
    /* Actual memory layout for this queue 
	 * 实现数据传输的VRing结构
	 */
    struct vring vring;
    
    /* Can we use weak barriers? */
    bool weak_barriers;
    
    /* Other side has made a mess, don't try any more. */
    bool broken;
    
    /* Host supports indirect buffers */
    bool indirect;
    
    /* Host publishes avail event idx 
 	 * 是否开启Event通知机制
     */
    bool event;
    
    /* Head of free buffer list. 
	 * 当前Descriptor Table中空闲buffer的起始位置
     */
    unsigned int free_head;
    
    /* Number we've added since last sync. 
     * 上一次通知Host后，Guest往VRing上添加了多少次buffer
     * 每添加一次buffer，num_added加1，每kick一次Host清空
     */
    unsigned int num_added;	

    /* Last used index we've seen. */
    u16 last_used_idx;

    /* Last written value to avail->flags 
     */
    u16 avail_flags_shadow;

    /* Last written value to avail->idx in guest byte order 
     * Guest每添加一次buffer，avail_idx_shadow加1
     * 每删除一次buffer，avail_idx_shadow减1
	 */
    u16 avail_idx_shadow;

    /* How to notify other side. FIXME: commonalize hcalls! */
    bool (*notify)(struct virtqueue *vq);

    /* DMA, allocation, and size information */
    bool we_own_ring;
    size_t queue_size_in_bytes;
    dma_addr_t queue_dma_addr;
#ifdef DEBUG
    /* They're supposed to lock for us. */
    unsigned int in_use;

    /* Figure out if their kicks are too delayed. */
    bool last_add_time_valid;
    ktime_t last_add_time;
#endif

    /* Per-descriptor state. */
    struct vring_desc_state desc_state[];
};
```

## Indirect descriptors

上面的普通或者chained方式，一个 descriptor desc只能存储一块buffer的元数据，当提供大量的小块buffer给device时势必需要很多的desc,这样就要求virtqueue size往往按照最坏的情景来申请资源，会多占点内存。所以就增加了一个indirect descriptor,相当于原来的一级指针数据扩充成了二级指针数据，间接地扩充了vring的长度。

driver可以额外申请一个indriect descriptor的表，它的使用方式和virtqueue中的descriptor是完全相同的，然后在virtqueue desc中插入indirect descriptor的信息，和普通的buffer基本相同，只是需要标记flag `VIRTQ_DESC_F_INDIRECT`来表明它指向的是一个indirect descriptor table而不是普通的buffer，desc的长度对应了indirect table本身所占的长度。

如果我们想要在indirect table中使用chain descriptor，我们需要插入两个buffer，首先driver需要首先申请indirect table的空间，从0x2000处申请到了合适的空间，即两个desc，更新desc指向buffer基址；indirect desc 0还需要标记flag NEXT并且next域指向下一个desc的索引1

之后更新descriptor table中的项，buffer地址指向indirect table地址0x2000，len为indirect table长度，flags标记上INDIRECT。

device使用indirect+ chained buffer时，将会根据descriptor flags获取indirect table，再从indirect table中遍历chained descriptor拿到总共0x3000长度的buffer（ 0x8000-0x9FFF 和 0xD000-0xDFFF)）。一旦device通过used ring通知已经消费完后，driver就可以释放indirect table，indirect生命周期到此结束。

descriptor如果被标记了INDIRECT，它指向的不再是普通的buffer而是buffer的元数据，所以不可以再标记WRITE flags。同时也不能再标记NEXT标记，目前只支持在indirect table中存放chained descriptor而不支持将indirect table像普通buffer一样形成chained descriptor. 同时，单个indirect table中存放的desc数目不能超过queue size，它只是间接地扩大了queue地size，但是一次性超越了queue size可能会导致device或者driver出现问题。

## notification

driver和device协商使用`VIRTIO_F_EVENT_IDX`，不再是disable通知而是指定一个notification index来暗示对方何时需要发送notification，这个index位于ring的尾部，ring实际的布局是增加used_event/avail_event。

driver每次发布一个avail buffer时都检查used ring中的avail_event: 如果driver的idx域等于avail_event,需要发送notification到device，此时会忽略used ring的VIRTQ_USED_F_NO_NOTIFY标志。同样的，如果driver支持`VIRTIO_F_EVENT_IDX` ，device每次发一个used buffer都会检查avail ring中的used_event.这种方式可以减少无意义的notification带来的损耗。

## 管理过程

1. 在 Guest driver 初始化的时候，提前注册了PCI 的 irq 的 handler。
2. 完成 PCI 设置注册之后，前端 virtio-blk 调用 probe 来装载驱动。在probe阶段完成VirtQueue创建，Feature协商，PCI配置空间读取block设备的空间布局信息。进行 feature 协商，以及基本的 IO 空间配置，此时前后端就可以进行数据传递。
3. Guest 构建好 desc table；
4. 通过写 PCI IO 空间 `VIRTIO_PCI_QUEUE_PFN` 来告知 Host ，Guest 的 virtqueue 的 GPA 地址；
5. Host 收到了 GPA，然后转换成 Host 的虚拟地址。
6. driver分配内存，需要更新并填充desc指向这块buffer，driver发布这块desc到avail ring中。它将desc index 0写入avail ring数组的第一项，之后更新idx域。如果提供了chained buffer时，只需要将descriptor的头写入avail 的数组中，avail idx只需要加1，和添加一个desc的情况处理是相同的。
7. driver通知device，发送notifications。
8. device感知到新可用描述符，在使用完成后，更新 Used Ring
9. device通过虚拟中断方式通知驱动，有新的 Used 描述符，请及时处理
10. Host 在处理完请求之后，将 desc 的 head 编号放到 used table 里面，然后构造 irq，通过 ioctl 通知 KVM，有请求完成了。
11. Guest irq handler 调用 get_buf 来获取 last_used_idx 到 used->idx 区间，已经完成的请求，从 data 数组里面找到 request 的指针，调用对应的回调即可

indirect descriptor： 间接描述符表示一个描述符指向的数据还是描述符

packed descriptors 是 virtio spec 1.1 提出的描述符格式。主要为为了提高性能。因为 split descriptors 每次操作涉及三个内存区域，cache miss 较多，packed descriptors 将三区域融合到一个区域，提高 cache 利用率。

## split queue

VM发送数据时，首先将数据buffer的信息写入descriptor表里，然后向队列中追加一个元素，HOST上的virtio后端就从队列中拿到这个元素，获取到数据的起始地址+长度（地址是GPA），然后通过GPA转换到HVA或者HPA，最后操作硬件真实的把数据发送出去。数据的存储空间是VM中申请的，是在VM中看到的一块空间，所以必须由VM来释放。vring结构关联的内存由客户机中的前端驱动负责分配和回收。

HOST上的virtio后端在发送完数据后，如何通知VM释放这一块空间呢？考虑到这一点，virtio将一个队列分成了两个，一个队列用于VM向VMM提供buffer，称为available ring；一个队列用于VMM向VM返回buffer，称为used ring。available ring是VM写VMM读，used ring是VMM写和VM读。

vring_desc 描述符表用于保存一系列描述符，每一个描述符都被用来描述客户机内的一块内存区域。对于这块内存区域，如果存放的是前端驱动写给设备的数据，称这个描述符为out类型的；如果存放的是前端驱动从设备读取的数据，称这个描述符为in类型的。
1. addr：表示内存区域在客户机物理地址空间中的起始地址
2. len： 该字段的意义取决于该内存区域的读写属性。如果该区域是只写的，数据传递方向只能从后端设备到前端驱动，此时len表示设备最多可以向该内存块写入的数据长度。反之，如果该区域是只读的，此时len表示后端设备必须读取的来自前端驱动的数据量。
3. flags： 用于标识描述符自身的特性，一共有三种可选值。`VRING_DESC_F_WRITE`表示当前内存区域是只写的，即该内存区域只能被后端设备用来向前端驱动传递数据。`VRING_DESC_F_NEXT`表明该描述符的next字段是否有效。`VRING_DESC_F_INDIRECT`表明该描述符是否指向一个间接描述符表。
4. next： 驱动和设备的一次数据交互往往会涉及多个不连续的内存区域。通常的做法是将描述符组织成描述符链表的形式来表示所有的内存区域。next字段便是用来指向下一个描述符。通过flag字段中的值`VRING_DESC_F_NEXT`，就可以间接地确定该描述符是否为描述符链表的最后一个。

vring_avail 可用描述符表用于保存前端驱动提供给后端设备且后端设备可以使用的描述符。可用描述符表由一个flags字段、idx索引字段以及一个以数组形式实现的环组成。

## Packed queue(virtio 1.1)

spilt virtqueue因其简约的设计而备受欢迎，但是它有一个基本的问题:avail, used ring 是分离的，cpu cache miss的概率比较大，从硬件角度来看意味着每个descriptor的读写操作都需要几个PC事务。packed virtqueue通过将三个ring合并到一起来改善这个问题.不过这种方式看起来非常复杂，远不如split virtqueue简约。


### 前后端协商feature
在virtio设备初始化阶段，split virtqueue和packed virtqueue的过程是相同的: 协商feature, 申请virtqueue,packed virtqueue的布局如下:
```C
struct virtq_desc { 
        le64 addr;
        le32 len;
        le16 id;
        le16 flags;
};
```


## virtio协议

PCI抽象，PCI 配置操作分成以下几个部分：

1. 读写 feature bits： 定义了 Guest 和 Host 支持的功能，例如 VIRTIO_NET_F_CSUM bit 表示网络设备是否支持 checksum offload。feature bits 机制提供了未来扩充功能的灵活性，以及兼容旧设备的能力。
2. 读写配置空间： 一般通过一个数据结构和一个虚拟设备关联，Guest 可以读写此空间。
3. 读写 status bits： 这是一个 8 bits 的长度，Guest 用来标识 device probe 的状态，当 VIRIO_CONFIG_S_DRIVE_OK 被设置，那么 Guest 已经完成了 feature 协商，可以跟 host 进行数据交互了。
4. Device reset： 重置设备，配置和 status bits。
5. Virtqueue 的创建和销毁： find_vq 提供了分配 virtqueue 内存，和 Host 的 IO 空间的初始化操作。

```C
struct virtio_config_ops
{
        bool (*feature)(struct virtio_device *vdev, unsigned bit);
        void (*get)(struct virtio_device *vdev, unsigned offset, void *buf, unsigned len);
        void (*set)(struct virtio_device *vdev, unsigned offset, const void *buf, unsigned len);
        u8 (*get_status)(struct virtio_device *vdev);
        void (*set_status)(struct virtio_device *vdev, u8 status);
        void (*reset)(struct virtio_device *vdev);
        struct virtqueue *(*find_vq)(struct virtio_device *vdev, unsigned index, void (*callback)(struct virtqueue *));
        void (*del_vq)(struct virtqueue *vq);
};
```

Virtqueues 抽象: 一个传输层抽象

```C
struct virtqueue_ops {
        int (*add_buf)(struct virtqueue *vq, struct scatterlist sg[],unsigned int out_num,unsigned int in_num,void *data);
        void (*kick)(struct virtqueue *vq);
        void *(*get_buf)(struct virtqueue *vq, unsigned int *len);
        void (*disable_cb)(struct virtqueue *vq);
        bool (*enable_cb)(struct virtqueue *vq);
};
```

Guest OS driver 初始化 Virtqueue 以及提交一个标准的 IO 流程是：

1. Driver 初始化 virtqueue 结构，调用 find_vq，传入 IO 完成时的回调函数；
2. 准备请求，调用 add_buf；
3. Kick 通知后端有新的请求，Qemu/KVM 后端处理请求，先进行地址转换，然后提取数据以及操作，提交给设备；
4. 请求完成，Qemu/KVM 写 IO 空间触发提前定义好的 MSI 中断，进而进入到 VM，Guest OS 回调被调用，接着 get_buf 被调用，一次 IO 到此全部处理完成；


add_buf: 通过 5 个参数的接口定义了所有的通用数据放置的操作。

- vq 表示一个 virtqueue；
- sg 定义了一组 scatterlist，这些 sg 是灵魂，数据或者 header 都可以放在这里，自由定义。
- out_num 表示 sg 中，有多少是 Guest 要丢给 Host 的；
- in_num 表示 sg 中，有多少是 Guest 需要从 Host 拿过来的；
- data 表示 private data，完成时 get_buf 返回此数据，一般代表一个 request 的指针。

1. add_buf 的通用实现是：将 sg 放入到描述符 table 里面，并且串在一起，然后将第一个 desc idx 放到 avail ring 里面，并存放 data 到数组里。
2. get_buf的通用实现是：检查 last_used_idx < used.idx，表示有已经完成的请求需要处理，然后返回 add_buf 存放的 data ,修改 last_used_idx。
3. kick: 通过 PCI 来触发一次通知，表示有新的请求已经准备好了。通用的是现实通过 iowrite 操作来写 PCI 对应的 IO 空间，触发 VMEXIT。
4. disable_cb: 设置 avail flags字段为 VRING_AVAIL_F_NO_INTERRUPT，让 Host 在请求完成后不通知 Guest。
5. enable_cb: disable_cb 的相反操作。

通过写 PCI 的 IO 空间来触发 notify 操作，Host 检查 last_avail_idx 跟 avail->idx 来判断有多少请求需要处理。notify 也会触发 KVM 的 VMEXIT 事件，造成较大开销。virtio 可以利用 flags 以及 features 来控制双向的 notify 频率，降低 VMEXIT 的调用，提高性能

## 1.1 规范
v1.1.
1. Guest reset device
2. Guest 设置 ACKNOWLEDGE 状态位，表示发现设备。
3. Guest 设置 DRIVER 状态为，表示知道是什么设备
4. Guest 读取 feature，写入guest和设备feature的子集 到 设备的哪里？。
5. Guest 写入FEATURES_OK 状态位，表示完成feature协商，不会再变。
6. Guest 读取 设备状态，确认feature和前面设置一致，不一致则不可用。
7. Guest 准备probe，virtqueue
8. Guest 设置 DRIVER_OK，完成初始化，表明设备可用。
9. Guest 设置 FAILED，如果中间发生问题。

如果是v0.9.5/1.0，可以跳过5和6.

通知： Guest 写入配置 DEVICE_NEEDS_RESET，会触发设备重置。

PCI Vendor ID 0x1AF4
PCI Device ID 0x1000 - 0x107F
Transitional devices MUST have a PCI Revision ID of 0.
Transitional devices MUST have the PCI Subsystem Device ID matching the Virtio Device ID。
Transitional devices MUST have the Transitional PCI Device ID in the range 0x1000 to 0x103f.

virtio设备配置包含几个部分：
1. Common configuration： virtio_pci_common_cfg
2. Notifications： virtio_pci_notify_cap
3. ISR 状态
4. 设备相关配置可选
5. PCI 配置 访问

## vhost 通知机制

前端通知后端，后端通知前端。而我们知道vhost有txq和rxq，对于每种queue都伴随有这两种通知。而通知方式又根据是否支持event_idx有着不同的实现，最后virtio1.1引入的packed ring后，通知相对split ring又有不同。下面我们以txq，rxq的两个方向共四种情况来分析前后端的通知实现。


后端对前端的通知，是以中断方式传递到前端的：
virtnet_probe
    init_vqs
        virt_net_alloc_queues 分配队列send_queue和receive_queue,将q的napi结构加入到dev的napi list
        virtnet_find_vqs
            分配vq结构： struct virtqueue
            callbacks[rxq2vq(i)] = skb_recv_done
            callbacks[txq2vq(i)] = skb_xmit_done
            vi->vdev->config->find_vqs
                vp_modern_find_vqs
                    vp_find_vqs
                        vp_try_to_find_vqs

vp_find_vqs函数完成队列中断处理函数的初始化，根据设备对中断的支持，分为以下三种情况：
1. 所有txq，rxq以及ctrlq都共享一个中断处理, 
2. ctrlq单独使用一个中断处理，其他txq和rxq共享一个中断处理, msi-x with one vector for config, one shared for queue
3. 可以每个queue（包含txq，rxq以及ctrlq）各一个中断处理,msi-x with one vector per queue

### 后端vhost_user的kick

### 发送队列txq前端通知kick后端

发送队列kick后端就是为了告诉后端前端已经将数据放入了共享ring（具体就是avail desc）中，后端可以来取数据了。实现在virtio_net驱动中，最后的start_xmit会调用virtqueue_kick

virtqueue_kick
    virtqueue_kick_prepare: 
        如果支持event_idx就更加old和new以及used->ring[(vr)->num]的范围来通知后端
        如果不支持event_idx就看used->flags是否设置了VRING_USED_F_NO_NOTIFY，如果没有设置就通知后端，否则就不通知。VRING_USED_F_NO_NOTIFY这个flag是后端设置的，对前端是只读的，用来告诉前端是否需要通知后端。
    virtqueue_notify

### 发送队列后端通知前端

后端将前端放入avail ring中的数据取出后需要告诉前端对应的数据已经被取走了，你可以把相关数据buffer释放了。而究竟释放那些buffer是取决于uesd ring的，所以通知前端本质上是为了告诉前端uesd ring有更新了。uesd ring是前后端共享的，所以如果后端更新了uesd ring，即使不通知前端，前端应该也是可以感知到的。所以前端释放buffer不一定要依赖后端kick。

start_xmit
    free_old_xmit_skbs(sq)
        virtqueue_get_buf
            detach_buf： 负责追加uesd ring来将对应的desc释放掉，并将对应地址dma unmmap
            更新avail->ring[(vr)->num]
        dev_kfree_skb_any：释放skb

detach_buf: 当前端没有设置VRING_AVAIL_F_NO_INTERRUPT时，会更新avail->ring[(vr)->num]，这也是后端开启event_idx时kick前端的条件。VRING_AVAIL_F_NO_INTERRUPT是前端设置，后端只读的。为什么要更新avail->ring[(vr)->num]呢？avail->ring[(vr)->num]中记录的前端已经处理到那个uesd idx了，因为可以及时告诉后端前端处理到什么位置了，后端来根据情况决定是否需要kick前端。

当前端发送速率过快，从而vq->num_free较少时会调用netif_stop_subqueue（将队列状态设置为__QUEUE_STATE_DRV_XOFF），这样队列的start_xmit函数下次在__dev_queue_xmit中就不会被调用。要想打破这样一个状态，就需要后端的kick了。这里还有一个十分关键的函数，就这在stop_queue之后调用的virtqueue_enable_cb_delayed函数。


### 接收队列rxq后端通知前端

对于接收队列，后端会在将mbuf数据拷贝到avail desc中后，更新uesd ring，然后kick前端。kick前端的目的就是告诉前端，我有数据发送给你了（更新了uesd ring），你可以来取数据了。我们以split方式的接收方向为例。其接收逻辑在virtio_dev_rx_split中实现。

前端接受队列前端注册的中断处理函数最终会调用到skb_recv_done：
调用virtqueue_disable_cb给vring.avail->flags设置上VRING_AVAIL_F_NO_INTERRUPT从而禁止后端发送中断（不开启event_idx的情况），然后唤起NAPI处理。所以在NAPI的情况后端通知是被关闭的。那么这个flag什么时候会被打开呢？答案就是在virtio_net的NAPI处理逻辑中，即virtnet_poll函数。

在NAPI处理（virtnet_poll函数）流程中如果received < budget，证明本轮数据接收已经比较少了，NAPI过程可能要退出了，这时调用virtqueue_enable_cb_prepare将之前的VRING_AVAIL_F_NO_INTERRUPT取消，从NAPI模式进入中断模式。

virtqueue_enable_cb_prepare除了取消VRING_AVAIL_F_NO_INTERRUPT设置之外，还会更新avail->ring[(vr)->num]，以供开启event_idx时后端使用。



### 接收队列前端通知后端

告诉后端avail ring已经更新了（有了更多空buffer），你可以继续放入更多数据了。从这里我们也可以看出，前端通知后端，无论发送还是接收方向，都是告诉后端有了更多的avail desc，而后端通知前端，都是告诉前端有了更多的uesd 的desc。

通知后端的时机就在try_fill_recv函数调用中，函数首先会根据是否支持mergeable已经是否支持收大包来向avail desc注入对应的空buffer。每种情况下注入buffer产生的desc chain长度是不同的。
最后调用virtqueue_kick函数
    virtqueue_kick_prepare： 判断是否发送通知，如果不开启event_idx时，会根据vring.used->flags是否设置VRING_USED_F_NO_NOTIFY来决定是否kick后端，而开启event_idx时，则会根据后端填入(vr)->used->ring[(vr)->num]中的后端消耗位置来决定是否kick。
## virtio-blk

### 后端

前端访问后端，通过ioread/iowrite对应的offset


## 前端

1. pci子系统调用`pci_scan_device`发现pci网卡设备，并初始化对应pci_dev结构，然后将去注册到pci总线上（dev->dev.bus=&pci_bus_type）。同时设置device的vendor_id为0x1AF4（virtio的pci vendor_id），device_id为1。
2. 对pci总线设备链表上未被驱动绑定的每个设备调用pci总线的match（pci_bus_match）回调函数。注册的virtio_bus驱动会调用virtio_dev_match函数，将设备的总线类型设置成virtio。pci_match_device函数判断pci设备结构是否有匹配的pci设备ID结构
4. 调用pci总线的probe函数（pci_deivce_probe函数）
5. 调用pci驱动probe函数(即virtio-pci的probe函数virtio_pci_probe)，传入它应该绑定到的struct pci_dev结构体指针
6. virtio_pci_probe函数主要负责完成pci_dev部分的初始化，已经virtio_device部分初始化，然后调用register_virtio_device函数。
