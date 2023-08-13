# 网络

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
VHostNetState:  
NetClientInfo 
NetQueue 
NICPeers [tap.NetClientState - nic.NetClientState]
NICConf 
VirtIODevice
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