- [功能设计](#功能设计)
- [数据结构](#数据结构)
  - [TCP连接状态机](#tcp连接状态机)
  - [TCP头部数据结构](#tcp头部数据结构)
    - [TCP Option字段](#tcp-option字段)
  - [tcp\_sock管理tcp连接](#tcp_sock管理tcp连接)
  - [内核参数](#内核参数)
- [连接过程管理](#连接过程管理)
  - [三次握手(three-way handshake)](#三次握手three-way-handshake)
  - [syncookies 加速tcp建立](#syncookies-加速tcp建立)
  - [tcp fast open： 减少tcp建立的时延](#tcp-fast-open-减少tcp建立的时延)
  - [四次挥手](#四次挥手)
    - [异常退出](#异常退出)
    - [主动close发起](#主动close发起)
    - [主动shutdown发起](#主动shutdown发起)
    - [FIN\_WAIT1 加速](#fin_wait1-加速)
    - [FIN\_WAIT2加速](#fin_wait2加速)
    - [TIME\_WAIT 加速](#time_wait-加速)
  - [timestamp时间戳功能](#timestamp时间戳功能)
- [可靠传输](#可靠传输)
  - [超时重传](#超时重传)
  - [丢失重传](#丢失重传)
  - [sack(Selective Acknowledgment 选择性确认)](#sackselective-acknowledgment-选择性确认)
  - [d-sack(Duplicate SACK，使用 SACK 来告诉「发送方」有哪些数据被重复接收了)](#d-sackduplicate-sack使用-sack-来告诉发送方有哪些数据被重复接收了)
- [流量控制](#流量控制)
  - [滑动窗口](#滑动窗口)
  - [接收窗口](#接收窗口)
- [拥塞控制](#拥塞控制)
  - [慢启动](#慢启动)
  - [拥塞避免](#拥塞避免)
  - [拥塞恢复](#拥塞恢复)

# 功能设计

- 可靠传输： 肯定回答和重传（PAR：Positive Acknowledgment with Re-transmission）
- 分段传输： mss，max segment size
- 面向连接
- 具备流量控制
- 拥塞控制的
- 安全传输协议

# 数据结构

## TCP连接状态机

- Closed： 初始状态，或者已经建立的连接超时、reset后的状态。
- SYN-SEND： 主动方发送SYN后状态，
- LISTEN： 服务器端listen后的状态，这个不是个状态
- SYN-RCVD: 被动方(服务器端)，收到SYN后状态，这个是半连接状态
- ESTABLISHED： 客户端收到SYN+ACK后回复ACK进入该状态，服务器端收到ACK后进入该状态
- FIN-WAIT1： 主动方调用close()主动关闭，发送FIN进入该状态
- CLOSE_WAIT： 被动方，收到FIN报文，发送FIN + ACK，连接进入该状态，被动方在等待进程调用 close 函数关闭连接。被动房可以继续处理数据，read函数返回0后，应用程序应该调用close(),会触发发送FIN报文，进入LAST_ACK.
- FIN_WAIT2： 主动方收到FIN + ACK，发送ACK, 连接进入该状态.主动方通道关闭了
- LAST_ACK: 被动方调用close()函数，会发送FIN报文给主动方，进入该状态。
- TIME_WAIT： 主动方收到FIN报文，回复ACK报文，进入该状态。收到SYN可能会重新建立链接。收到ACK会延长该状态，收到RST根据参数`net.ipv4.tcp_rfc1337`为0提前结束，释放连接；为1丢掉RST报文。
- CLOSE: 主动方等待2MSL从TIME_WAIT进入CLOSE状态。被动方收到主动方发起的ACK会从LAST_ACK进入CLOSE.
- CLOSING

## TCP头部数据结构

```C
struct tcphdr {
 __be16 source;
 __be16 dest;
 __be32 seq;
 __be32 ack_seq;
 __u16 doff:4,
  res1:4,
  cwr:1,
  ece:1,
  urg:1,
  ack:1,
  psh:1,
  rst:1,
  syn:1,
  fin:1;
 __be16 window;
 __sum16 check;
 __be16 urg_ptr;
};
```

1. 源端口： 16bit
2. 目标端口： 16bit
3. 序列号：32bit，占4个字节。TCP连接传送的数据流中的每一个字节都被编上一个序号。每个tcp连接都需要设置初始序列号，满足部分随机性和自增，一般是时间+hash(源端口、目标端口)。ISN初始序列号，基于时钟，每4ms加一， 4.55小时耗尽然后轮回。每次建立连接前重新初始化一个序列号主要是为了通信双方能够根据序号将不属于本连接的报文段丢弃,同时防止伪造的序列号被tcp攻击。RFC1948 中提出了一个较好的初始化序列号 ISN 随机生成算法，`ISN = M + F (localhost, localport, remotehost, remoteport)`。M为时间，F为hash算法，可能是MD5.
4. 确认应答号：32bit，占4个字节，是期望收到对方下一个报文段的数据包的序号。用来解决丢包的问题。
5. 数据偏移：占4 bit，它指出报文段的数据起始处距离TCP报文段的起始处有多远，这个单位是4个字节32bit。也就是tcp头部最长15*4=60byte。实际上就是TCP报文段首部的长度。TCPOptions 部分是变长的，其他是固定的。
6. 保留：占4 bit，保留为今后使用，设置为NULL。
7. 6个标志位
   1. URG：当URG=1时，表明紧急指针有效。它告诉系统报文段中有紧急数据，应尽快传送。
   2. ACK：ACK=1时确认号字段才有效，ACK=0时确认号字段无效。
   3. PUSH：接收方接收到PUSH=1的报文段时会尽快的将其交付给接收应用进程，而不再等到整个接收缓存都填满后再向上交付。
   4. RST：当RST=1时，表明TCP连接中出现严重差错，必须释放连接。复位比特还用来拒绝一个非法的报文段或拒绝打开一个连接。
   5. SYN：在连接建立时用来同步序号。当SYN=1而ACK=0时，表明这是一个连接请求报文段。对方若同意建立连接，应在响应的报文段中使SYN=1和ACK=1。因此，SYN=1就表示这是一个连接请求或连接接收报文。
   6. FIN：当FIN=1时，表明此报文段的发送端的数据已发送完毕，并要求释放运输连接。
   7. ECE: 拥塞标志位，RFC未定义
   8. CWR: 窗口控制，RFC未定义
8. 窗口：占2个字节，用来控制对方发送的数据量，单位是字节，指明对方发送窗口的上限。用来做流量控制。这个只有65535大小，也就是64Kb。在TCP options中有窗口扩大因子，14位，可以表达30位大小也就是1GB窗口。使用窗口扩大因子需要建立连接时双方协商。
9. 校验和：占2个字节，校验的范围包括**首部**和**数据**两个部分，计算校验和时需要在报文段前加上12字节的伪首部。用来判断损坏。
10. 紧急指针：占2个字节，指出本报文段中紧急数据最后一个字节的序号。只有当紧急比特URG=1时才有效。
11. 选项：长度可变。TCP只规定了一种选项，即最大报文段长度MSS (Maximum Segment Size)。

### TCP Option字段

- 类型0， 选项列表末尾表示
- 类型1，用于32位对齐
- MSS，类型2，长度4字节，数据为MSS值，3次握手时，发送端告知可以接受的最大报文段大小
- Windows 类型3，长度3字节，窗口移位，指明最大窗口扩展后的大小
- 类型4，长度2字节，表明支持SACK选择性确认功能
- 类型5，长度可变，确认报文段，选择性确认窗口中间的报文段
- Timestamps 类型8，长度10字节，timestamps时间戳，用于更精确的计算RTT，以及解决序列号绕回的问题
- 类型14，长度3，校验和算法，双方认可后，可使用心得校验和算法
- 类型15，长度可变，校验和，当16位标准校验和放不下时，放置在这里
- 类型34，长度可变，FOC(fast open cookie), TFO中的cookie

## tcp_sock管理tcp连接

struct tcp_sock: TCP层管理数据传送需要的所有信息

1. inet_conn：INET协议族是面向连接的套接字结构，定义在include/net/inet_connection_sock文件中，其中包含的struct inet_connection_sock_af_ops*icsk_af_ops数据结构，是套接字操作函数指针数据块，各协议实例在初始化时将函数指针初始化为自己的函数实例。struct inet_connection_sock inet_conn数据结构必须为tcp_sock的第一个成员
1. tcp_header_len：传送数据段TCP协议头的长度。
1. xmit_size_goal：输出数据段的目标。
1. pred_flags：TCP协议头预定向完成标志，用该标志确定数据包是否通过“Fast Path”接收。
1. rcv_nxt：下一个输入数据段的序列号。
1. snd_nxt：下一个发送数据段的序列号。

struct ucopy: 实现数据段“Fast Path”接收的关键:

- prequeue：输入队列。其中包含等待由“Fast Path”处理的Socket Buffer链表。
- task：用户进程。接收prequeue队列中数据段的用户进程。
- iov：向量指针。指向用户地址空间中存放接收数据的数组。
- memory：在prequeue队列中所有Socket Buffer中数据长度的总和。
- Len： prequeue队列上Socket Buffer缓冲区的个数。
- `struct dma_chan *dma_chan`: 用于数据异步复制。当网络设备支持Scatter/Gather I/O功能时，可以利用DMA直接内存访问，将数据异步从网络设备硬件缓冲区中复制到应用程序地址空间的缓冲区。

`struct tcp_info`: tcp套接字的配置信息

- __u8  tcpi_state: 当前TCP的连接状态
- __u32 tcpi_fackets
- __u32 tcpi_last_data_sent: 事件的时间戳信息
- __u32 tcpi_last_ack_recv: 事件的时间戳信息
- __u32 tcpi_pmtu: MTU
- __u32 tcpi_total_retrans

TCP Options:

- TCP_CORK/nonagle: 如果设置了这个选项，TCP不立即发送数据段，直到数据段中的数据达到TCP协议数据段的最大长度。它使应用程序可以在路由的MTU小于TCP数据段最大段大小（MSS：Maximum Segment Size）时停止传送，该选项存放在struct tcp_sock数据结构的nonagle数据域中，TCP_CORK选项与TCP_NODELAY选项是互斥的。
- TCP_DEFER_ACCEPT/defer_accept: 应用程序调用者在数据还没到达套接字之前，可以处于休眠状态。但当数据到达套接字时则应用程序被唤醒。如果等待超时应用程序也会被唤醒。调用者设定一个时间值（秒）来描述应用程序等待数据到达超时时间。该选项保存在struct tcp_sock数据结构的defer_accept数据域中。
- TCP_INFO: 调用程序使用此选项可以提取大部分套接字的配置信息。在提取配置信息后，返回到struct tcp_info数据结构中。
- TCP_KEEPCNT: 使用此选项，应用程序调用者可以设置在断开连接之前通过套接字发送多少个保持连接活动（keepalive）的探测数据段。该选项存放在struct tcp_sock数据结构中的keepalive_probes数据域中，如果要使这个选项有效，则还必须设置套接字层的SO_KEEPALIVE选项。
- TCP_KEEPIDLE: 在TCP开始传送连接是否保持活动的探测数据段之前，连接处于空闲状态的时间值（以秒为单位）。该选项存放在struct tcp_sock数据结构的keepalive_time数据域中，默认值为两个小时。该选项只有在套接字设置了SO_KEEPALIVE选项时才有效。
- TCP_KEEPINTVL: 设定在两次传送探测连接保持活动数据段之间要等待多少秒。该值存放在struct tcp_sock数据结构的deepalive_intvl数据域中，初始值为75秒。
- TCP_LINGER2: 这个选项指定处于FIN_WAIT2状态的孤立套接字还应保持存活多长时间。如果其值为0，则关闭选项。Linux使用常规方式处理FIN_WAIT_2和TIME_WAIT状态。如果值小于0，则套接字立即从FIN_WAIT_2状态进入CLOSED状态，不经过TIME_WAIT。该选项的值存放在struct tcp_sock数据结构的linger2数据域中，默认值由sysctl决定。
- TCP_MAXSEG: 在套接字连接建立之前，该选项指定最大数据段大小的值。送给TCP选项的MSS值就是由此选项决定的，但MSS的值不能超过接口的MTU。TCP连接两端的站点可以协商数据段大小的值。
- TCP_NODELAY: 当设置这个选项后，TCP会立即向外发送数据段，而不会等待数据段中填入更多数据。该选项值存放在struct tcp_sock数据结构的nonagle数据域中。如果设置了TCP_CORK选项，这个选项就失效。
- TCP_QUICKACK: 当这个选项的值设置为1时，会关闭延迟回答，或为0时允许延迟回答。延迟回答是Linux TCP操作的一个常规模式。在延迟回答时，ACK数据的发送会延迟到可以与一个等待发送到另一端的数据段合并时，才发送出去。如果这个选项的值设为1，则将struct tcp_sock数据结构中的ack部分的pingpong数据域设为0，就可以禁止延迟发送。TCP_QUICKACK选项只会暂时影响TCP协议的操作行为。
- TCP_SYNCNT: 这个选项用于在尝试建立TCP连接时，如果连接没能建立起来，在重发多少次SYN后，才放弃建立连接请求。这个选项存放在struct tcp_syn_retries数据域中。
- TCP_WINDOW_CLAMP: 指定套接字窗口大小。窗口的最小值是SOCK_MIN_RCVBUF除以2，等于128个字节。这个选项的值存放在struct tcp_sock数据结构的window_clamp数据域中。

## 内核参数

1. net.core.somaxconn = 128
2. backlog， backlog 是 listen(int sockfd, int backlog) 函数中的 backlog 大小；默认为511.
3. tcp_synack_retries
4. net.core.netdev_max_backlog
5. net.ipv4.tcp_max_syn_backlog： SYN_RCVD 状态连接的最大个数。SYN 半连接队列和 accept 队列都是在 listen() 初始化的
6. net.ipv4.tcp_abort_on_overflow = 0： 服务器端全连接队列溢出(accept队列)，超出处理能时，默认丢弃连接，为1时对新的 SYN 直接回报 RST，废掉这个握手过程和连接：
7. net.ipv4.tcp_syn_retries = 5: sync 重发的次数由 tcp_syn_retries 参数控制，默认是 5 次, 第一次超时重传是在 1 秒后，第二次超时重传是在 2 秒，第三次超时重传是在 4 秒后，第四次超时重传是在 8 秒后，第五次是在超时重传 16 秒后。没错，每次超时的时间是上一次的 2 倍。当第五次超时重传后，会继续等待 32 秒，如果服务端仍然没有回应 ACK，客户端就会终止三次握手。总耗时是 1+2+4+8+16+32=63 秒，大约 1 分钟左右。
8. net.ipv4.tcp_synack_retries = 5: SYN+ACK包重传次数，与客户端重传 SYN 类似，它的重传会经历 1、2、4、8、16 秒，最后一次重传后会继续等待 32 秒，如果服务端仍然没有收到 ACK，才会关闭连接，故共需要等待 63 秒。

# 连接过程管理

MTU是传输链路的最大数据包长度，MSS是出去IP和TCP头部后，一个网络包能容纳的TCP数据最大长度。
MSS： 在TCP协商阶段确定值，经过tcp分层后，以mss为单位进行切片传输。

ss -ltn

- Recv-Q：当前 accept 队列的大小，也就是当前已完成三次握手并等待服务端 accept() 的 TCP 连接；
- Send-Q：accept 队列最大长度，上面的输出结果说明监听 8088 端口的 TCP 服务，accept 队列的最大长度为 128；

## 三次握手(three-way handshake)

1. 客户端发送syn包(syn=1，ack=0，sn=client_isn)到服务器，连接进入SYN_SEND状态，等待服务器确认。
2. 服务器端收到syn请求包，发送syn+ack包(syn=1,ack=client_isn + 1,sn=server_isn,确认序列号=J+1)，服务器端进入SYN_RECV状态。Linux 内核就会建立一个「半连接队列」来维护「未完成」的握手信息，当半连接队列溢出后，服务端就无法再建立新的连接。SYN 攻击，攻击的是就是这个半连接队列。半连接队列， spoofed syn package 攻击
3. 客户端收到syn+ack包，向服务器发送确认包(syn=0, ack=server_isn + 1, sn=j+1, 确认序列号=k+1)，客户端进入ESTABLISHED.
4. 服务器端收到ack包后进入ESTABLISHED状态。将连接放到accept队列，也就是全连接队列。

tcp_syn_retries: 重发次数， 1+2+4+8+16+32 = 63

ISN： initial sequence number，初始序列号，基于时钟，每4ms加一， 4.55小时耗尽然后轮回。每次建立连接前重新初始化一个序列号主要是为了通信双方能够根据序号将不属于本连接的报文段丢弃,同时防止伪造的序列号被tcp攻击。RFC1948 中提出了一个较好的初始化序列号 ISN 随机生成算法，`ISN = M + F (localhost, localport, remotehost, remoteport)`

- M 是一个计时器，这个计时器每隔 4 毫秒加 1。
- F 是一个 Hash 算法，根据源 IP、目的 IP、源端口、目的端口生成一个随机数值。要保证 Hash 算法不能被外部轻易推算得出，用 MD5 算法是一个比较好的选择。

三次握手过程分析【V5.8，正常流程】

1. 客户端发起第一次握手，状态调变为TCP_SYN_SENT，发送SYN包

```text
connect->__sys_connect->__sys_connect_file->【sock->ops->connect】tcp_v4_connect
A、状态变化
->tcp_set_state(sk, TCP_SYN_SENT);
B、发送SYN
->tcp_connect->tcp_send_syn_data
```

2. 服务端收到客户端的SYN包，初始化socket，状态从TCP_LISTEN变为TCP_NEW_SYN_RECV，发送第二次握手SYN_ACK包

```text
A、收到连接，初始化socket
accept->__sys_accept4->__sys_accept4_file->【sock->ops->accept】inet_csk_accept
 
B、收到SYN，改变状态
【tcp_protocol.handler】tcp_v4_rcv->tcp_v4_do_rcv->tcp_rcv_state_process->
->case TCP_LISTEN:
->[sock->ops->conn_request]tcp_v4_conn_request->tcp_conn_request
->->inet_reqsk_alloc
->->->ireq->ireq_state = TCP_NEW_SYN_RECV;
 
C、发送SYN_ACK包
->[sock->ops->conn_request]tcp_v4_conn_request->tcp_conn_request【和B路径一样】
->->【af_ops->send_synack】tcp_v4_send_synack
->->->tcp_make_synack
->->->__tcp_v4_send_check
```

3. 客户端收到SYN_ACK包，状态从TCP_SYN_SENT变为TCP_ESTABLISHED，并发送ACK包

```text
A、收到SYN_ACK包
【tcp_protocol.handler】tcp_v4_rcv->tcp_v4_do_rcv->tcp_rcv_state_process
->case TCP_SYN_SENT:
->tcp_rcv_synsent_state_process->tcp_finish_connect
->->tcp_set_state(sk, TCP_ESTABLISHED);
 
B、发送ACK包
->tcp_rcv_synsent_state_process->tcp_send_ack->__tcp_send_ack
```

4. 服务端收到ACK包，状态从TCP_NEW_SYN_RECV变为TCP_SYN_RECV【实际上是新建了一个sock】

```text
【tcp_protocol.handler】tcp_v4_rcv->
->if (sk->sk_state == TCP_NEW_SYN_RECV)
->tcp_check_req
->->【inet_csk(sk)->icsk_af_ops->syn_recv_sock】tcp_v4_syn_recv_sock->tcp_create_openreq_child->inet_csk_clone_lock
->->->inet_sk_set_state(newsk, TCP_SYN_RECV);
```

5. 服务端状态从TCP_SYN_RECV变为TCP_ESTABLISHED

```text
【tcp_protocol.handler】tcp_v4_rcv->tcp_v4_do_rcv->tcp_rcv_state_process
->case TCP_SYN_RECV:
->tcp_set_state(sk, TCP_ESTABLISHED);
```

## syncookies 加速tcp建立

syncookies 的工作原理：服务器根据当前状态计算出一个值，放在己方发出的 SYN+ACK 报文中发出，当客户端返回 ACK 报文时，取出该值验证，如果合法，就认为连接建立成功，
开启 syncookies 功能， net.ipv4.syncookies 参数主要有以下三个值：

- 0 值，表示关闭该功能；
- 1 值，表示仅当 SYN 半连接队列放不下时，再启用它；
- 2 值，表示无条件开启功能；

## tcp fast open： 减少tcp建立的时延

参数：
/proc/sys/net/ipv4/tcp_fastopn 各个值的意义:

- 0 关闭
- 1 作为客户端使用 Fast Open 功能
- 2 作为服务端使用 Fast Open 功能
- 3 无论作为客户端还是服务器，都可以使用 Fast Open 功能

在客户端首次建立连接时的过程：

1. 客户端发送 SYN 报文，该报文包含 Fast Open 选项，且该选项的 Cookie 为空，这表明客户端请求 Fast Open Cookie；cookie 的值是存放到 TCP option 字段里的
2. 支持 TCP Fast Open 的服务器生成 Cookie，并将其置于 SYN-ACK 数据包中的 Fast Open 选项以发回客户端；
3. 客户端收到 SYN-ACK 后，本地缓存 Fast Open 选项中的 Cookie。

之后，如果客户端再次向服务器建立连接时的过程：

1. 客户端发送 SYN 报文，该报文包含「数据」（对于非 TFO 的普通 TCP 握手过程，SYN 报文中不包含「数据」）以及此前记录的 Cookie；
2. 支持 TCP Fast Open 的服务器会对收到 Cookie 进行校验：如果 Cookie 有效，服务器将在 SYN-ACK 报文中对 SYN 和「数据」进行确认，服务器随后将「数据」递送至相应的应用程序；如果 Cookie 无效，服务器将丢弃 SYN 报文中包含的「数据」，且其随后发出的 SYN-ACK 报文将只确认 SYN 的对应序列号；
3. 如果服务器接受了 SYN 报文中的「数据」，服务器可在握手完成之前发送「数据」，这就减少了握手带来的 1 个 RTT 的时间消耗；
4. 客户端将发送 ACK 确认服务器发回的 SYN 以及「数据」，但如果客户端在初始的 SYN 报文中发送的「数据」没有被确认，则客户端将重新发送「数据」；
5. 此后的 TCP 连接的数据传输过程和非 TFO 的正常情况一致。

客户端在请求并存储了 Fast Open Cookie 之后，可以不断重复 TCP Fast Open 直至服务器认为 Cookie 无效（通常为过期）。

## 四次挥手

调用 close 函数和 shutdown 函数有什么区别？

客户端和服务端双方都可以主动断开连接，通常先关闭连接的一方称为主动方，后关闭连接的一方称为被动方。四次挥手过程只涉及了两种报文，分别是 FIN 和 ACK：

- FIN 就是结束连接的意思，谁发出 FIN 报文，就表示它将不会再发送任何数据，关闭这一方向上的传输通道；
- ACK 就是确认的意思，用来通知对方：你方的发送通道已经关闭；

四次挥手的过程:

1. 当主动方关闭连接时，会发送 FIN 报文，此时发送方的 TCP 连接将从 ESTABLISHED 变成 `FIN_WAIT1`。
2. 当被动方收到 FIN 报文后，内核会自动回复 ACK 报文，连接状态将从 ESTABLISHED 变成 `CLOSE_WAIT`，表示被动方在等待进程调用 close 函数关闭连接。
3. 当主动方收到这个 ACK 后，连接状态由 `FIN_WAIT1` 变为 `FIN_WAIT2`，也就是表示主动方的发送通道就关闭了。
4. 当被动方进入 CLOSE_WAIT 时，被动方还会继续处理数据，等到进程的 read 函数返回 0 后，应用程序就会调用 close 函数，进而触发内核发送 `FIN` 报文，此时被动方的连接状态变为 `LAST_ACK`。
5. 当主动方收到这个 FIN 报文后，内核会回复 ACK 报文给被动方，同时主动方的连接状态由 `FIN_WAIT2` 变为 `TIME_WAIT`，在 Linux 系统下大约等待 1 分钟后，TIME_WAIT 状态的连接才会彻底关闭。
6. 当被动方收到最后的 ACK 报文后，被动方的连接就会关闭。

你可以看到，每个方向都需要一个 FIN 和一个 ACK，因此通常被称为四次挥手。这里一点需要注意是：主动关闭连接的，才有 `TIME_WAIT` 状态。

### 异常退出

进程异常退出，内核发送RST报文来关闭，不走四次握手流程。正常进程可以通过close或者shutdown函数发送FIN报文发起关闭连接。

### 主动close发起

调用了 close 函数意味着完全断开连接，完全断开不仅指无法传输数据，而且也不能发送数据。 此时，调用了 close 函数的一方的连接叫做「孤儿连接」，如果你用 netstat -p 命令，会发现连接对应的进程名为空。

### 主动shutdown发起

使用 close 函数关闭连接是不优雅的。于是，就出现了一种优雅关闭连接的 shutdown 函数，它可以控制只关闭一个方向的连接：`int shutdown(int sock, int howto)`
第二个参数决定断开连接的方式，主要有以下三种方式：

- SHUT_RD(0)：关闭连接的「读」这个方向，如果接收缓冲区有已接收的数据，则将会被丢弃，并且后续再收到新的数据，会对数据进行 ACK，然后悄悄地丢弃。也就是说，对端还是会接收到 ACK，在这种情况下根本不知道数据已经被丢弃了。
- SHUT_WR(1)：关闭连接的「写」这个方向，这就是常被称为「半关闭」的连接。如果发送缓冲区还有未发送的数据，将被立即发送出去，并发送一个 FIN 报文给对端。
- SHUT_RDWR(2)：相当于 SHUT_RD 和 SHUT_WR 操作各一次，关闭套接字的读和写两个方向。

### FIN_WAIT1 加速

1. net.ipv4.tcp_orphan_retries=0， 控制fin报文发从重试次数，对FIN_WAIT1状态的连接有效.0 是8次的意思，代码是这么写的。
2. net.ipv4.tcp_max_orphans=16384: 最大孤儿连接数量.当进程调用了 close 函数关闭连接，此时连接就会是「孤儿连接」，因为它无法再发送和接收数据。Linux 系统为了防止孤儿连接过多，导致系统资源长时间被占用，就提供了 tcp_max_orphans 参数。如果孤儿连接数量大于它，新增的孤儿连接将不再走四次挥手，而是直接发送 RST 复位报文强制关闭。

### FIN_WAIT2加速

1. net.ipv4.tcp_fin_timeout=60 控制了这个状态下连接的持续时长，默认值是 60 秒.如果连接是用 shutdown 函数关闭的，连接可以一直处于 FIN_WAIT2 状态，因为它可能还可以发送或接收数据。但对于 close 函数关闭的孤儿连接，由于无法再发送和接收数据，所以这个状态不可以持续太久.它意味着对于孤儿连接（调用 close 关闭的连接），如果在 60 秒后还没有收到 FIN 报文，连接就会直接关闭。

### TIME_WAIT 加速

1. net.ipv4.tcp_max_tw_buckets: 当 TIME_WAIT 的连接数量超过该参数时，新关闭的连接就不再经历 TIME_WAIT 而直接关闭
2. net.ipv4.tcp_tw_reuse=1: 复用处于 TIME_WAIT 状态的连接.只用于客户端（建立连接的发起方），因为是在调用 connect() 时起作用的，而对于服务端（被动连接方）是没有用的。
3. net.ipv4.tcp_timestamps = 1： tcp时间戳功能，2MSL 问题就不复存在了，因为重复的数据包会因为时间戳过期被自然丢弃；可以防止序列号绕回，也是因为重复的数据包会由于时间戳过期被自然丢弃；

MSL 全称是 Maximum Segment Lifetime，它定义了一个报文在网络中的最长生存时间（报文每经过一次路由器的转发，IP 头部的 TTL 字段就会减 1，减到 0 时报文就被丢弃，这就限制了报文的最长存活时间）

TIME-WAIT 的状态尤其重要，主要是两个原因：

- 防止具有相同「四元组」的「旧」数据包被收到；TCP 就设计出了这么一个机制，经过 `2MSL` 这个时间，足以让两个方向上的数据包都被丢弃，使得原来连接的数据包在网络中都自然消失，再出现的数据包一定都是新建立连接所产生的
- 保证「被动关闭连接」的一方能被正确的关闭，即保证最后的 ACK 能让被动关闭方接收，从而帮助其正常关闭；客户端四次挥手的最后一个 ACK 报文如果在网络中被丢失了，此时如果客户端 TIME-WAIT 过短或没有，则就直接进入了 CLOSE 状态了，那么服务端则会一直处在 LAST-ACK 状态。当客户端发起建立连接的 SYN 请求报文后，服务端会发送 RST 报文给客户端，连接建立的过程就会被终止。

为什么是 2 MSL 的时长呢？这其实是相当于至少允许报文丢失一次。比如，若 ACK 在一个 MSL 内丢失，这样被动方重发的 FIN 会在第 2 个 MSL 内到达，TIME_WAIT 状态的连接可以应对。

为什么不是 4 或者 8 MSL 的时长呢？你可以想象一个丢包率达到百分之一的糟糕网络，连续两次丢包的概率只有万分之一，这个概率实在是太小了，忽略它比解决它更具性价比。

因此，TIME_WAIT 和 FIN_WAIT2 状态的最大时长都是 2 MSL，由于在 Linux 系统中，MSL 的值固定为 30 秒，所以它们都是 60 秒。

虽然 TIME_WAIT 状态有存在的必要，但它毕竟会消耗系统资源。如果发起连接一方的 TIME_WAIT 状态过多，占满了所有端口资源，则会导致无法创建新连接。

- 客户端受端口资源限制：如果客户端 TIME_WAIT 过多，就会导致端口资源被占用，因为端口就65536个，被占满就会导致无法创建新的连接；
-服务端受系统资源限制：由于一个四元组表示TCP连接，理论上服务端可以建立很多连接，服务端确实只监听一个端口，但是会把连接扔给处理线程，所以理论上监听的端口可以继续监听。但是线程池处理不了那么多一直不断的连接了。所以当服务端出现大量 TIME_WAIT 时，系统资源被占满时，会导致处理不过来新的连接；

## timestamp时间戳功能

# 可靠传输

## 超时重传

## 丢失重传

## sack(Selective Acknowledgment 选择性确认)

1. net.ipv4.tcp_sack=1 参数打开这个功能,TCP 头部「选项」字段里加一个 SACK 的东西，它可以将缓存的地图发送给发送方，这样发送方就可以知道哪些数据收到了，哪些数据没收到，知道了这些信息，就可以只重传丢失的数据

## d-sack(Duplicate SACK，使用 SACK 来告诉「发送方」有哪些数据被重复接收了)

1. net.ipv4.tcp_dsack =1

# 流量控制

TCP头部窗口的字段2个字节，可以表达64KB大小。TCP选线该字段定义了窗口扩大因子(类型3，长度3， 窗口移位)，14个字节，和窗口大小一共30个字节，也就是1GB大小。

- net.ipv4.tcp_window_scaling=1: 默认启动窗口扩大因子。在建立tcp连接的时候发送的syn和syn+ack报文都应包含这个选项。
- net.ipv4.tcp_wmem = 4096 16384 4194304 : tcp发送缓冲区，最小值4k，默认值86k，最大值4m
- net.ipv4.tcp_rmem = 4096 87380 6291456: tcp接收缓冲区，最小值4k，默认值86K， 最大值6m
- net.ipv4.tcp_moderate_rcvbuf=1： tcp接收缓冲区自动调节
- net.ipv4.tcp_mem = 88560 118080 177120, 单位为页面，tcp内存小于1时不调节，在1和2之间，调节，大于3时(692M)，不分配。

## 滑动窗口

滑动窗口大小由内核缓冲区大小决定，
带宽时延积(BDP: bandwidth delay product) = rtt(Round-Trip Time 往返时延) * 带宽

发送状态：

1. 已发送，并受到ack确认
2. 已发送，未收到ack确认。SND.UNA：是一个绝对指针，它指向的是已发送但未收到确认的第一个字节的序列号，也就是 #2 的第一个字节。
3. 未发送，大小在接收方处理范围内。SND.NXT：也是一个绝对指针，它指向未发送但可发送范围的第一个字节的序列号，也就是 #3 的第一个字节。
4. 未发送，大小超过接收方处理范围。SND.UNA 指针加上 SND.WND 大小的偏移量，就可以指向 #4 的第一个字节。

可用窗口大小 = SND.WND -（SND.NXT - SND.UNA）

SND.WND：表示发送窗口的大小（大小是由接收方指定的）；
SND.UNA：是一个绝对指针，它指向的是已发送但未收到确认的第一个字节的序列号，也就是 #2 的第一个字节。
SND.NXT：也是一个绝对指针，它指向未发送但可发送范围的第一个字节的序列号，也就是 #3 的第一个字节。

## 接收窗口

# 拥塞控制

## 慢启动

## 拥塞避免

## 拥塞恢复
