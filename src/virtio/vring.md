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

1. driver分配内存，需要更新并填充desc指向这块buffer，driver发布这块desc到avail ring中。它将desc index 0写入avail ring数组的第一项，之后更新idx域。如果提供了chained buffer时，只需要将descriptor的头写入avail 的数组中，avail idx只需要加1，和添加一个desc的情况处理是相同的。
2. driver通知device，发送notifications。
3. device感知到新可用描述符，在使用完成后，更新 Used Ring
4. device通过虚拟中断方式通知驱动，有新的 Used 描述符，请及时处理

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