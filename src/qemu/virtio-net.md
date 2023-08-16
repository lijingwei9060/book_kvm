# 网络模型

- 全模拟：通常指由虚拟化层（通常是Qemu）完全模拟一个设备给虚拟机用。
- virtio驱动半虚拟化：将设备虚拟的工作一拆为二，一部分挪到虚拟机内核中作为前端驱动，一部分放到虚拟化层(通常是Qemu)作为后端，前后端共享Ring环协同完成任务。
- 设备直通、SRIOV：借助硬件技术，如intel的VT-d技术实现PCI设备直接挂载给虚拟机。

网络包含：virtio-net Driver 和 virtio-net Device（由 QEMU 模拟的后端）。
前端：虚拟机的中的内核驱动模块， 接受用户态的IO请求，转发后端的io请求。
后端： qemu中的设备，接受前端请求，进行物理网卡的io操作。

virtio：qemu创建virtio-net 设备，tap作为backend， 2个queue（每个有tx和rx），1个controll queue，

创建参数
```shell
-net nic[,vlan=n][,macaddr=mac][,model=type][,name=name][,addr=addr][,vectors=v]
主要参数说明：

-net nic：这个是必须的参数，表明为客户机创建客户机网卡。
vlan=n：表示将建立一个新的网卡，并把网卡放入到编号为n的VLAN，默认为0。
macaddr=mac：设置网卡的MAC地址，默认会根据宿主机中网卡的地址来分配；若局域网中客户机太多，建议自己设置MAC地址以防止MAC地址冲突。
model=type：设置模拟的网卡的类型，默认为rtl8139。
name=name：设置网卡的名字，该名称仅在QEMU monitor中可能用到，一般由系统自动分配。
addr=addr：设置网卡在客户机中的PCI设备地址为addr。
vectors=v：设置该网卡设备的MSI-X向量的数量为v，该选项仅对使用virtio驱动的网卡有效，设置为“vectors=0”是关闭virtio网卡的MSI-X中断方式。
```

```shell
-net tap[,vlan=n][,name=str][,fd=h][,ifname=name][,script=file][,downscript=dfile][,helper=helper][,sndbuf=nbytes][,vnet_hdr=on|off][,vhost=on|off][,vhostfd=h][,vhostforce=on|off]
```
网络Tap设备: 
- -net tap：这个参数是必须的，表示创建一个tap设备。
- vlan=n：设置该设备VLAN编号，默认值为0。
- name=str：设置网卡的名字。在QEMU monitor里面用到，一般由系统自动分配。
- fd=h：连接到现在已经打开着的TAP接口的文件描述符，一般让QEMU会自动创建一个TAP接口。
- ifname=name：表示tap设备接口名字。
- script=file：表示host在启动guest时自动执行的脚本，默认为/etc/qemu-ifup；如果不需要执行脚本，则设置为“script=no”。
- downscript=dfile：表示host在关闭guest时自动执行的脚本，默认值为/etc/qemu-ifdown；如果不需要执行，则设置为“downscript=no”。
- helper=helper：设置启动客户机时在宿主机中运行的辅助程序，包括去建立一个TAP虚拟设备，它的默认值为/usr/local/libexec/qemu-bridge-helper，一般不用自定义，采用默认值即可。
- sndbuf=nbytes：限制TAP设备的发送缓冲区大小为n字节，当需要流量进行流量控制时可以设置该选项。其默认值为“sndbuf=0”，即不限制发送缓冲区的大小。


新版本的qemu： 
网络设备前端：
-device virtio-net-pci,netdev=tap0
后端参数：
-netdev tap,id=id[,fd=h][,ifname=name][,script=file][,downscript=dfile][,helper=helper]

```shell
-netdev tap,id=hostnet0,queues=2
-device virtio-net-pci,host_mtu=1450,mq=on,vectors=5,netdev=hostnet0,id=net0,mac=fa:16:3e:d8:fe:81,bus=pci.0,addr=0x3
```

-netdev，创建了2个TAPState，每个TAPState包含一个NetClientState，函数qemu_net_client_setup参数peer为空，所以创建的ncs中peer为空。
参数-device中有netdev=hostnet0，而-netdev中有id=hostnet0，根据name找到了刚才tap创建的2个NetClientState和queue个数为2。

- Control Plane：virtio-net Driver 和 virtio-net Device 之间使用了 PCI 传输协议。
- Data Plane：virtio-net Driver 和 virtio-net Device 之间使用了 Virtqueues 和 Vrings。而 virtio-net Device 和 Kernel Network Stack 之间使用了 Tap 虚拟网卡设备，作为 User space（QEMU）和 Kernel space（Network Stack）之间的数据传输通道。


Front-end 和 Back-end 之间存在 2 个 Virtqueues，对应到 NIC 的 Rx/Tx Queues。Virtqueues 的底层利用了 IPC 共享内存技术，在 HostOS 和 GuestOS 之间建立直接的传输通道，绕开了 VMM 的低效处理。
1. Receive Queue：是一块 Buffer 内存空间，存放具体的由 Back-end 发送到 Front-end 数据。
2. Send Queue：是一块 Buffer 内存空间，存放具体的由 Front-end 发送到 Back-end 数据。

同时，每个 Virtqueue 都具有 2 个 Vrings，对应到 Kernel 的 Rx/Tx Rings：
1. Available Ring：存放 Front-end 向 Back-end 发送的 Queue 中可用的 Buffer 内存地址。
2. Used Ring：存放 Back-end 向 Front-end 发送的 Queue 中已使用的 Buffer 内存地址。

当然，Front-end 和 Back-end 之间还需要一种双向通知机制，对应到 NIC 和 CPU 之间的硬中断信号：

1. Available Buffer Notification：Front-end 使用此信号通知 Back-end 存在待处理的缓冲区。
2. Used Buffer Notification：Back-end 使用此信号标志已完成处理某些缓冲区。


## 数据结构
TAPState： tap设备状态，只有一个NetClientState
NICState: 虚拟网卡，有多个NetClientState，对应多个queue，最终数据流都是经过一个tap设备
NetClientState
VHostNetState:  vhost-net内核态虚拟网卡状态
NetClientInfo 
NetQueue 
NICPeers [tap.NetClientState - nic.NetClientState]
NICConf 
VirtIODevice
VirtIONet
PCIDevice

虚拟设备： 
VirtIO总线
virtio-net-pci，virtio-balloon-pci，virtio-scsi-pci等PCI代理设备

## 全虚拟化过程
前端e1000，后端tap

发送：

- Guest OS在准备好网络包数据以及描述符资源后，通过写TDT寄存器，触发VM的异常退出，由KVM模块接管；
- KVM模块返回到Qemu后，Qemu会检查VM退出的原因，比如检查到e1000寄存器访问出错，因而触发e1000前端工作；
- Qemu能访问Guest OS中的地址内容，因而e1000前端能获取到Guest OS内存中的网络包数据，发送给后端，后端再将网络包数据发送给TUN/TAP驱动，其中TUN/TAP为虚拟网络设备；
- 数据发送完成后，除了更新ring-buffer的指针及描述符状态信息外，KVM模块会模拟TX中断；
- 当再次进入VM时，Guest OS看到的是数据已经发送完毕，同时还需要进行中断处理；
- Guest OS跑在vCPU线程中，发送数据时相当于会打算它的执行，直到处理完后再恢复回来，也就是一个严格的同步处理过程；

接收：
- 当TUN/TAP有网络包数据时，可以通过读取TAP文件描述符来获取；
- Qemu中的I/O线程会被唤醒并触发后端处理，并将数据发送给e1000前端；
- e1000前端将数据拷贝到Guest OS的物理内存中，并模拟RX中断，触发VM的退出，并由KVM模块接管；
- KVM模块返回到Qemu中进行处理后，并最终重新进入Guest OS的执行中断处理；
- 由于有I/O线程来处理接收，能与vCPU线程做到并行处理，这一点与发送不太一样；

## Virtio-Net 后端

### 设备创建

net_clients全局列表，存放所有的NetClientState单元 

virtio_net_class_init
	virtio_net_device_realize // 完成对 virtio-net 设备的初始化过程
        virtio_net_set_config_size
        virtio_init           // 初始化 VirtIODevice
        virtio_net_set_default_queue_size
        virtio_net_add_queue  //  初始化队列。当设置多队列特性，还要额外增加一个 ctrl_vq 队列，用作控制队列
        n->ctrl_vq = virtio_add_queue(virtio_net_handle_ctrl)
        qemu_new_nic          // 创建一个虚拟机里面的网卡。这里的网卡对应的是后端 tap 设备。
	virtio_net_get_config
	virtio_net_get_features

qemu 的 main 函数会调用 net_init_clients 进行网络设备的初始化 ，在该函数内对 netdev 参数进行解析。


main() – vl.c 主函数
 | -> net_client_parse : 解析网络部分命令行参数 QemuOptsList -> QemuOpts -> QemuOpt对应具体键值对
 net_init_clients – net.c : 初始化网络部分，可能存在多个netdev，依次初始化
  -> net_init_client/net_init_netdev -> net_client_init -> net_client_init1 – net.c
​   -> net_client_init_fun [netdev->type] (netdev, name, peer, errp) – net.c
    -> net_init_tap – tap.c
     -> net_tap_init – tap.c // 与Host的tun驱动进行交互，其实质就是打开该设备文件，并进行相应的配置等；
      | -> tap_open – tap-linux.c : 会打开/dev/net/tun字符设备，获取文件描述符
      net_init_tap_one – tap.c
       -> net_tap_fd_init – tap.c  // 会创建tap口对应的NetClientState的结构, 根据net_tap_info结构，创建NetClientState，并进行相关设置，这里边net_tap_info结构体中的接收函数指针用于实际的数据传输处理；
        -> tap_read_poll – tap.c // 用于将fd添加到Qemu的AioContext中，用于异步响应，当有数据来临时，捕获事件并进行处理；
         -> tap_update_fd_handler – tap.c
          -> qemu_set_fd_handler – iohandler.c
           |-> iohandler_init ->aio_context_new -> g_source_new
​           aio_set_fd_handler : 找到iohandler_ctx中对应AioHander节点赋值io_read和io_write
            -> g_source_add_poll : fd会被加入到source(事件源iohandler_ctx)中，并添加到默认contex中


net_init_clients
	qemu_opts_foreach(qemu_find_opts("netdev"),net_init_netdev, NULL, errp))
		net_init_netdev
			net_client_init->net_client_init1 // 根据不同的driver类型，调用不同的初始化函数
				net_init_tap
					net_tap_init
						tap_open  // 打开一个文件 "/dev/net/tun" ，然后通过 ioctl 操作这个文件

```C
tap_open{
    fd = open(PATH_NET_TUN, O_RDWR)
    ioctl(fd, TUNGETFEATURES, &features)
    ioctl(fd, TUNSETVNETHDRSZ, &len)
    ioctl(fd, TUNSETIFF, (void *) &ifr)
}
```
### 收报

当网卡有数据包时，tap 设备首先会收到报文，对应 virtio-net 的 tap 设备 fd 变为可读。qemu 通过 epoll 方式监测到有网络数据包，调用回调函数发起收报流程。virtio_net_receive 函数把数据拷贝到虚拟机的 virtio 网卡接收队列。然后向虚拟机注入一个中断，虚拟机便感知到有网络数据报文。

qemu/hw/net/virtio-net.c
virtio_net_receive
	virtio_net_do_receive
		virtio_net_receive_rcu： 对网络数据包添加到 virtio queue
            virtio_net_can_receive 	// 根据vm running状态，queue和设备状态判断virtio-net是否可以收包
            virtio_net_has_buffers 	// 检查缓冲区，避免出现竞争状况
            receive_filter 		    // 对网络包进行过滤
            elem = virtqueue_pop 	// 从vring中取出一个请求，将信息传递给elem域中
            len = iov_from_buf 		// 负责将报文拷贝到buffer中，实现向guest物理地址写入数据
            virtqueue_fill 		    // 当数据写完后，撤销映射，更新VRingAvail.ring[]的相关字段
            virtqueue_flush 		// 更新VRingUsed.ring的idx，表明可以回收
            virtio_notify 			// 负责注入中断，通知前端虚拟机

### 发包

虚拟机的 virtio 网卡驱动向网卡缓冲区填好报文，然后写 queue notify 寄存器。这样，触发 VM exit ，虚拟机就会退出到root 模式，在 qemu 的 vcpu 线程 virtio_mmio_write 对其处理。

qemu/hw/net/virtio-net.c
virtio_net_add_queue
	virtio_net_handle_tx_bh
		qemu_bh_schedule
			virtio_net_tx_bh
				virtio_net_flush_tx  // 发送报文, 获取报文 elem，写 tap 设备的 fd，最终发给 tap 设备，投递出去
                    elem = virtqueue_pop 	// 从vring中取出一个请求
                    qemu_sendv_packet_async // qemu发包函数
                        qemu_net_queue_send_iov
                            qemu_net_queue_flush
                                qemu_net_queue_deliver
                                    tap_write_packet ->writev 写入 tap 字符设备。
                                        进入内核的tap驱动：tun_chr_write_iter 会被调用，在 TCP/IP 协议栈进一步处理网络包
			virtio_queue_set_notification


## Virtio-Net 前端(驱动)
虚拟机里面的进程发送一个网络包，通过文件系统和 Socket 调用网络协议栈，到达网络设备层。 这里将调用 virtio-net 驱动做进一步处理。

前端 driver 将报文发送出去，注册的 ops 函数定义如下，其中指定的发送函数为 start_xmit。

kernel/drivers/net/virtio_net.c
static const struct net_device_ops virtnet_netdev = {
	.ndo_open            = virtnet_open,
	.ndo_stop   	     = virtnet_close,
	.ndo_start_xmit      = start_xmit,
	...
};
调用 start_xmit 函数，将 skb 发送到 virtqueue 中， 然后调用 virtqueue_kick 通知 qemu 后端将数据包发送出去。

start_xmit{
	free_old_xmit_skbs // 释放backend处理过的desc
    xmit_skb 		  // 发包
    	sg_init_table
    	sg_set_buf(sq->sg, hdr, hdr_len); 				     // 数据包头部填入scatterlist
		num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len);  // 数据包填入scatterlist
    	virtqueue_add_outbuf // sg table 写入desc描述符表，head desc信息写vring.avail
    virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq) // kick通知qemu后端
}
当虚拟机写入一个 I/O 会使得 qemu 触发 VM exit 。接下来进入 qemu 做 virtio-net 相关处理。


## vhost-net(后端/内核态)

vhost_net运行在宿主机的内核中，有两个比较重要文件，vhost.c和vhost-net.c。其中前者实现的是脱离具体功能的vhost核心实现，后者实现网络方面的功能。
vhost-net注册为misc device，其file_operations 为 vhost_net_fops。

```C
static const struct file_operations vhost_net_fops = {
    .owner          = THIS_MODULE,
    .release        = vhost_net_release,
    .read_iter      = vhost_net_chr_read_iter,
    .write_iter     = vhost_net_chr_write_iter,
    .poll           = vhost_net_chr_poll,
    .unlocked_ioctl = vhost_net_ioctl,
#ifdef CONFIG_COMPAT
    .compat_ioctl   = vhost_net_compat_ioctl,
#endif
    .open           = vhost_net_open,
    .llseek     = noop_llseek,
};

static struct miscdevice vhost_net_misc = {
    .minor = VHOST_NET_MINOR,
    .name = "vhost-net",
    .fops = &vhost_net_fops,
};

static int vhost_net_init(void)
{
    if (experimental_zcopytx)
        vhost_net_enable_zcopy(VHOST_NET_VQ_TX);
    return misc_register(&vhost_net_misc);
}
```


### qemu初始化

1. struct vhost_net：用于描述Vhost-Net设备。它包含几个关键字段：
   1. struct vhost_dev，通用的vhost设备，可以类比struct device结构体内嵌在其他特定设备的结构体中;
   2. struct vhost_net_virtqueue，实际上对struct vhost_virtqueue进行了封装，用于网络包的数据传输;
   3. struct vhost_poll，用于socket的poll，以便在数据包接收与发送时进行任务调度;
2. struct vhost_dev：描述通用的vhost设备，可内嵌在基于vhost机制的其他设备结构体中，比如struct vhost_net，struct vhost_scsi等。
   1. vqs指针，指向已经分配好的struct vhost_virtqueue，对应数据传输;
   2. work_list，任务链表，用于放置需要在vhost_worker内核线程上执行的任务;
   3. worker，用于指向创建的内核线程，执行任务列表中的任务;
3. vhost_net_virtqueue: 用于描述Vhost-Net设备对应的virtqueue，封装的struct vhost_virtqueue。
4. struct vhost_virtqueue：用于描述vhost设备对应的virtqueue，这部分内容可以参考之前virtqueue机制分析，本质上是将Qemu中virtqueue处理机制下沉到了Kernel中。

qemu的代码中，创建tap设备时会调用到net_init_tap()函数。net_init_tap()其中会检查选项是否指定vhost=on，如果指定，则会调用到vhost_net_init()进行初始化，其中通过open(“/dev/vhost-net”, O_RDWR)打开了vhost-net driver；并通过ioctl(vhost_fd)进行了一系列的初始化。而open(“/dev/vhost-net”, O_RDWR)，则会调用到vhost-net驱动的vhost_net_fops->open函数，即vhost_net_openc初始化 vhost设备。

```C
struct vhost_net {
    struct vhost_dev dev;
    struct vhost_net_virtqueue vqs[VHOST_NET_VQ_MAX];
    struct vhost_poll poll[VHOST_NET_VQ_MAX];
    /* Number of TX recently submitted.
     * Protected by tx vq lock. */
    unsigned tx_packets;
    /* Number of times zerocopy TX recently failed.
     * Protected by tx vq lock. */
    unsigned tx_zcopy_err;
    /* Flush in progress. Protected by tx vq lock. */
    bool tx_flush;
};

struct vhost_dev {
    /* Readers use RCU to access memory table pointer
     * log base pointer and features.
     * Writers use mutex below.*/
    struct vhost_memory __rcu *memory;
    struct mm_struct *mm;
    struct mutex mutex;
    unsigned acked_features;
    struct vhost_virtqueue **vqs;
    int nvqs;
    struct file *log_file;
    struct eventfd_ctx *log_ctx;
    spinlock_t work_lock;
    struct list_head work_list;
    struct task_struct *worker;
};


struct vhost_net_virtqueue {
    struct vhost_virtqueue vq;
    /* hdr is used to store the virtio header.
     * Since each iovec has >= 1 byte length, we never need more than
     * header length entries to store the header. */
    struct iovec hdr[sizeof(struct virtio_net_hdr_mrg_rxbuf)];
    size_t vhost_hlen;
    size_t sock_hlen;
    /* vhost zerocopy support fields below: */
    /* last used idx for outstanding DMA zerocopy buffers */
    int upend_idx;
    /* first used idx for DMA done zerocopy buffers */
    int done_idx;
    /* an array of userspace buffers info */
    struct ubuf_info *ubuf_info;
    /* Reference counting for outstanding ubufs.
     * Protected by vq mutex. Writers must also take device mutex. */
    struct vhost_net_ubuf_ref *ubufs;
};

/* The virtqueue structure describes a queue attached to a device. */
struct vhost_virtqueue {
    struct vhost_dev *dev;

    /* The actual ring of buffers. */
    struct mutex mutex;
    unsigned int num;
    struct vring_desc __user *desc;
    struct vring_avail __user *avail;
    struct vring_used __user *used;
    struct file *kick;
    struct file *call;
    struct file *error;
    struct eventfd_ctx *call_ctx;
    struct eventfd_ctx *error_ctx;
    struct eventfd_ctx *log_ctx;

    struct vhost_poll poll;

    /* The routine to call when the Guest pings us, or timeout. */
    vhost_work_fn_t handle_kick;

    /* Last available index we saw. */
    u16 last_avail_idx;

    /* Caches available index value from user. */
    u16 avail_idx;

    /* Last index we used. */
    u16 last_used_idx;

    /* Used flags */
    u16 used_flags;

    /* Last used index value we have signalled on */
    u16 signalled_used;

    /* Last used index value we have signalled on */
    bool signalled_used_valid;

    /* Log writes to used structure. */
    bool log_used;
    u64 log_addr;

    struct iovec iov[UIO_MAXIOV];
    struct iovec *indirect;
    struct vring_used_elem *heads;
    /* We use a kind of RCU to access private pointer.
     * All readers access it from worker, which makes it possible to
     * flush the vhost_work instead of synchronize_rcu. Therefore readers do
     * not need to call rcu_read_lock/rcu_read_unlock: the beginning of
     * vhost_work execution acts instead of rcu_read_lock() and the end of
     * vhost_work execution acts instead of rcu_read_unlock().
     * Writers use virtqueue mutex. */
    void __rcu *private_data;
    /* Log write descriptors */
    void __user *log_base;
    struct vhost_log *log;
};

struct vhost_poll {
    poll_table                table;
    wait_queue_head_t        *wqh;
    wait_queue_entry_t              wait;
    struct vhost_work     work;
    __poll_t          mask;
    struct vhost_dev     *dev;
};
```

### vhost_net设备初始化 vhost_net_open

创建vhost_net，完成一系列初始化，vhost_net 和 vhost_net_virtqueue 是描述vhost-net设备的，vhost_dev和vhost_virtqueue则用于通用的vhost设备，在vhost_dev_init中完成vhost_dev的初始化以及和vhost_virtqueue关联（vhost_dev的vhost_virtqueue指向vhost_net的vhost_virtqueue）。

初始化vhost_poll，理解vhost poll机制对读懂vhost_net 实现非常重要，见数据结构章节vhost_poll的介绍，vhost_net报文收发，前后端事件通知都需要vhost_poll机制；

关联file和vhost_net，file->private_data=vhost_net。

```C
static int vhost_net_open(struct inode *inode, struct file *f)
{
    struct vhost_net *n;
    struct vhost_dev *dev;
    struct vhost_virtqueue **vqs;
    void **queue;
    int i;

    n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
    if (!n)
        return -ENOMEM;
    vqs = kmalloc_array(VHOST_NET_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
    if (!vqs) {
        kvfree(n);
        return -ENOMEM;
    }

    queue = kmalloc_array(VHOST_RX_BATCH, sizeof(void *),
                  GFP_KERNEL);
    if (!queue) {
        kfree(vqs);
        kvfree(n);
        return -ENOMEM;
    }
    n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;

    dev = &n->dev;
    vqs[VHOST_NET_VQ_TX] = &n->vqs[VHOST_NET_VQ_TX].vq;
    vqs[VHOST_NET_VQ_RX] = &n->vqs[VHOST_NET_VQ_RX].vq;
    n->vqs[VHOST_NET_VQ_TX].vq.handle_kick = handle_tx_kick;
    n->vqs[VHOST_NET_VQ_RX].vq.handle_kick = handle_rx_kick;
    for (i = 0; i < VHOST_NET_VQ_MAX; i++) {
        n->vqs[i].ubufs = NULL;
        n->vqs[i].ubuf_info = NULL;
        n->vqs[i].upend_idx = 0;
        n->vqs[i].done_idx = 0;
        n->vqs[i].vhost_hlen = 0;
        n->vqs[i].sock_hlen = 0;
        n->vqs[i].rx_ring = NULL;
        vhost_net_buf_init(&n->vqs[i].rxq);
    }
    vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);

    vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, EPOLLOUT, dev);
    vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, EPOLLIN, dev);

    f->private_data = n;

    return 0;
}

void vhost_dev_init(struct vhost_dev *dev,
            struct vhost_virtqueue **vqs, int nvqs)
{
    struct vhost_virtqueue *vq;
    int i;

    dev->vqs = vqs;
    dev->nvqs = nvqs;
    mutex_init(&dev->mutex);
    dev->log_ctx = NULL;
    dev->umem = NULL;
    dev->iotlb = NULL;
    dev->mm = NULL;
    dev->worker = NULL;
    init_llist_head(&dev->work_list);
    init_waitqueue_head(&dev->wait);
    INIT_LIST_HEAD(&dev->read_list);
    INIT_LIST_HEAD(&dev->pending_list);
    spin_lock_init(&dev->iotlb_lock);


    for (i = 0; i < dev->nvqs; ++i) {
        vq = dev->vqs[i];
        vq->log = NULL;
        vq->indirect = NULL;
        vq->heads = NULL;
        vq->dev = dev;
        mutex_init(&vq->mutex);
        vhost_vq_reset(dev, vq);
        if (vq->handle_kick)
            vhost_poll_init(&vq->poll, vq->handle_kick,
                    EPOLLIN, dev);
    }
}

/* Init poll structure */
void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
             __poll_t mask, struct vhost_dev *dev)
{
    init_waitqueue_func_entry(&poll->wait, vhost_poll_wakeup);
    init_poll_funcptr(&poll->table, vhost_poll_func);
    poll->mask = mask;
    poll->dev = dev;
    poll->wqh = NULL;

    vhost_work_init(&poll->work, fn);
}
```