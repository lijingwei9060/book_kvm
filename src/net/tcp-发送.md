# 数据结构

## msghdr

msghdr: 来自应用层数据信息，tcp协议实例和socket传递接口使用。用于将应用数据从socket复制到内核skb。

- msg_name: 指向soket地址(struct sockaddr_in)数据结构的指针
- msg_namelen：由msg_name指向的地址信息的长度。
- struct iovec *msg_iov：指向缓冲区数组的起始地址。这些缓冲区中包含了要发送或接收到的数据段。我们常把这些缓冲区称做分割/收集数组（Scatter/Gather array），但这些缓冲区不仅用于DMA操作，也用于不使用DMA方式传送数据的操作。
- size_t msg_iovlen: 是msg_iov缓冲区数组中缓冲区的个数。
- msg_control：用于支持应用程序的控制消息API功能，向套接字层下的协议传送控制信息。
- msg_controllen：为控制信息msg_control的长度。
- msg_flags：为套接字从应用层接收到控制的标志。

msg flags: socket控制标志位：

- MSG_OOB:        1, 请求 out of bound 数据
- MSG_PEEK：      2， 从接收队列中返回数据，但不把数据从队列中移走
- MSG_DONTROUTE： 4， 不对该数据路由，常用于ping程序中传递ICMP数据包。
- MSG_TRYHARD：   4， 不用于tcp/ip协议，与MSG_DONTROUTE同义
- MSG_CTRUNC：    8， 用于SOL_IP内部控制信息
- MSG_PROBE：   0x10，用于发现MTU的数据段
- MSG_TRUNC：   0x20， Truncate消息
- MSG_DONTWAIT: 0x40, 应用程序是否使用不被阻塞的IO
- MSG_EOR：     0x80， 信息结束
- MSG_WAITALL： 0x100，在返回数据前等待所有数据到达
- MSG_FIN：     0x200，TCP结束数据段FIN
- MSG_SYN：     0x400， TCP同步数据段SYN
- MSG_CONFIRM： 0x800，在传递数据抱歉确认路径链接有效
- MSG_RST：     0x1000，TCP复位连接数据段RST
- MSG_ERRQUEUE： 0x2000，从错误队列读取数据段
- MSG_NOSIGNAL： 0x4000，当确定连接已断开时，不产生SIGPIPE信号
- MSG_MORE：     0x8000，设置表之后，知名发送者将发送更多的消息

```C
struct msghdr {
    void *msg_name; /* ptr to socket address structure */
    int msg_namelen; /* size of socket address structure */
    struct iov_iter msg_iter; /* data */

    /*
     * Ancillary data. msg_control_user is the user buffer used for the
     * recv* side when msg_control_is_user is set, msg_control is the kernel
     * buffer used for all other cases.
     */
    union {
        void *msg_control;
        void __user *msg_control_user;
    };
    bool msg_control_is_user : 1;
    __kernel_size_t msg_controllen; /* ancillary data buffer length */
    unsigned int msg_flags; /* flags on received message */
    struct kiocb *msg_iocb; /* ptr to iocb for async requests */
};
```

# tcp_sendmsg

- 分配空闲的sk_buff并拷贝msg
- tcp_sendmsg_fasopen: 处理fastopen，在3次握手的同时携带数据。
- sk_stream_wait_connect(sk, &timeo)： 如果连接状态不是在稳态(establieshed, closed)，等待连接建立。
- tcp_send_rcvq(sk, msg, size)： TCP repair 在Linux 3.5引入，实现容器在不同的物理主机之间迁移。迁移后，TCP连接重新设置到之前的状态。
- 调用tcp_send_mss(sk, &size_goal, flags)： 获取MSS 大小。size_goal 是数据报到达网络设备时所允许的最大长度。对于不支持分片的网卡，size_goal 是MSS 的大小。否则，是MSS 的整倍数。计算MSS大小
- 用tcp_write_queue_tail()获取sk_buff链表最后一项，因为可能还有剩余空间
- copy小于0说明当前sk_buff并无可用空间，因此需要调用 sk_stream_alloc_skb()重新分配 sk_buff，然后调用 skb_entail()将新分配的 sk_buff 放到队列尾部，copy赋值为size_goal
- 由于sk_buff存在连续数据区域和离散的数据区skb_shared_info，因此需要分别讨论。调用 skb_add_data_nocache()可以 将数据拷贝到连续的数据区域。调用skb_copy_to_page_nocache() 则将数据拷贝到 struct skb_shared_info 结构指向的不需要连续的页面区域。
- 根据上面得到的sk_buff进行发送。
  - 如果是force_push(tp), 标记push标志位，则调用__tcp_push_pending_frames(sk, mss_now, TCP_NAGLE_PUSH)发送
  - 如果是第一个包(skb == tcp_send_head(sk))则调用tcp_push_one(sk, mss_now)。二者最后均会调用tcp_write_xmit发送。

异常：
- 内存空间不足，SOCK_NOSPACE，如果拷贝了数据，需要尝试将数据发出
- 

# tcp_write_xmit
tcp_write_xmit()的核心部分为一个循环，每次调用tcp_send_head()获取头部sk_buff，若已经读完则退出循环。循环内逻辑为：

- 调用tcp_init_tso_segs()进行TSO（TCP Segmentation Offload）相关工作。当需要发送较大的网络包的时候，我们可以选择在协议栈中进行分段，也可以选择延迟到硬件网卡去进行自动分段以降低CPU负载。
- 调用tcp_cwnd_test()检查现在拥塞窗口是否允许发包，如果允许，返回可以发送多少个sk_buff。
- 调用tcp_snd_wnd_test()检测当前第一个sk_buff的序列号是否满足要求： sk_buff 中的 end_seq 和 tcp_wnd_end(tp) 之间的关系，也即这个 sk_buff 是否在滑动窗口的允许范围之内。
- tso_segs为1可能是nagle协议导致，需要进行判断。其次需要判断TSO是否延迟到硬件网卡进行。
- 调用tcp_mss_split_point()判断是否会因为超出 mss 而分段，还会判断另一个条件，就是是否在滑动窗口的运行范围之内，如果小于窗口的大小，也需要分段，也即需要调用 tso_fragment()。
- 调用tcp_small_queue_check()检查是否需要采取小队列：TCP小队列对每个TCP数据流中，能够同时参与排队的字节数做出了限制，这个限制是通过net.ipv4.tcp_limit_output_bytes内核选项实现的。当TCP发送的数据超过这个限制时，多余的数据会被放入另外一个队列中，再通过tastlet机制择机发送。由于该限制的存在，TCP通过一味增大缓冲区的方式是无法发出更多的数据包的。
- 调用tcp_transmit_skb()完成sk_buff的真正发送工作。

# tcp_transmit_skb
tcp_transmit_skb()函数主要完成TCP头部的填充。这里面有源端口，设置为 inet_sport，有目标端口，设置为 inet_dport；有序列号，设置为 tcb->seq；有确认序列号，设置为 tp->rcv_nxt。所有的 flags 设置为 tcb->tcp_flags。设置选项为 opts。设置窗口大小为 tp->rcv_wnd。完成之后调用 icsk_af_ops 的 queue_xmit() 方法，icsk_af_ops 指向 ipv4_specific，也即调用的是 ip_queue_xmit() 函数，进入IP层。
## 锁管理:  加锁，避免与软中断的冲突

## zerocopy

## fastopen


# TCP初始化sock

tcp_prot.init = tcp_v4_init_sock : SOCK_STREAM类tcp_sock初始化

- 初始化out_of_order_queue队列；初始化TCP输出队列，该队列只由TCP使用；初始化传送超时时钟；初始化prequeue
- 输入队列，该队列用“Fast Path”接收
- 初始化数据包重传时间、rto、介质偏差时间mdev，mdev用于衡量RTT（Round Trip //Time），设置为3秒
- 接下来就是初始化TCP选项的某些域：发送拥塞窗口的大小（send congestion window，cwnd）=2；send slow start threshold：snd_ssthresh设置为最大值32，有效的禁止slow start算法。发送拥塞窗口声明snd_cwnd_clamp最大设置为16位值mss_cache是TCP最小段大小为536
- 按系统配置控制值初始化TCP选项结构的重排序域reordering。套接字的状态state目前保持关闭。初始化inet连接套接字阻塞管理操作的函数为tcp_init_congestion_ops
- 套接字sk->sk_write_space指针，指向套接字的回调函数，当套接字的写缓冲区有效时调用该函数，它指向sk_stream_write_space。icsk_af_ops设置成TCP协议特定的AF_INET函数
- 将套接字的发送缓冲区sk_sndbuf和接收缓冲区sk_rcvbuf大小初始化为系统配置控制值，可以用系统调用setsockopt来改变它们的大小
- tcp_sockets_allocated是一个全局变量，保存了打开的TCP套接字的数量，这里对该值递增1