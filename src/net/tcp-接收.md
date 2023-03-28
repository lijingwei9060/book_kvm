
# 框架
L3->L4的接口：，数据格式为sk_buff数据。
# IP层

`ip_local_deliver`函数在IP数据包协议头iphdr->protocol数据域中设定的值，在传输层与IP层之间管理协议处理接口的哈希链表inet_protocol中查询，找到正确的传输层协议处理函数块，并上传数据包。
对于TCP协议，它在`inet_protocol`结构中初始化的输入数据包处理函数是`tcp_v4_rcv`。

# TCP接收

## tcp_v4_rcv接收数据包

- 数据包合法性检查
  - skb->pkt_type指明数据包的目标地址不是本主机地址时，扔掉数据包，这种情况可能发生于网络设备工作在混杂模式状态时。
  - pskb_may_pull函数查看TCP协议头的正确性
  - 保存在局部指针th变量中的TCP协议头数据结构地址，获取TCP协议头信息。查看协议头长度值th->doff的正确性，其长度至少应为不包含TCP协议选项时的协议头长度。th->doff中保存的是TCP协议头的单元数。从9.1.1节中给出的TCP协议数据段格式可知，TCP协议头的每个单元占32位，即4个字节。所以sizeof( struct tcphdr)/4为TCP协议头占用的单元数。
  - 查看TCP数据段的校验和是否正确，如果校验和不正确则说明数据段已损坏。
- 调用`__inet_lookup_skb`查看接收到的数据包是否属于某个打开的套接字，查看的依据是接收数据包的网络接口、源端口号和目的端口号。如果数据段属于某个套接字，则将sk变量设置为指向打开的套接字的数据结构，接着继续处理数据段。
- 数据段处理
  - 如果`socket`的连接状态为`TIME_WAIT`(sk->sk_state == TCP_TIME_WAIT)，这个时候socket主动关闭链接应该等待2MSL后变成Close。 如果此时收到syn报文也会处理。如果处于 `TIME_WAIT` 状态的连接收到「合法的 SYN 」（SYN包、没有RST、没有ACK、时间戳没有回绕，并且序列号也没有回绕）后，就会重用此四元组连接，跳过 `2MSL` 而转变为 `SYN_RECV` 状态，接着就能进行建立连接过程。如果处于 `TIME_WAIT` 状态的连接收到「非法的 SYN 」后，就会再回复一个第四次挥手的 `ACK` 报文，客户端收到后，发现并不是自己期望收到确认号（ack num），就回 `RST` 报文给服务端。代码处理过程：如果收到的 SYN 是合法的，`tcp_timewait_state_process()` 函数就会返回 `TCP_TW_SYN`，然后重用此连接。如果收到的 SYN 是非法(如果时间戳回绕，或者报文里包含ack，则将 TIMEWAIT 状态的持续时间重新延长)的，`tcp_timewait_state_process()` 函数就会返回 `TCP_TW_ACK`，然后会回上次发过的 ACK。如果收到的包是RST包，根据`net.ipv4.tcp_rfc1337`参数配置，如果为0，提前结束`TIME_WAIT`,释放链接，如果为1，返回`TCP_TW_RST`直接发送RESET包，延长 `TIME_WAIT`时间； 如果是`TCP_TW_SUCCESS`则直接丢弃此包，不做任何响应。
  - IPsec策略检查和网络过滤(xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))。如果内核配置使用了IPsec协议栈，则对数据包进行IPsec策略检查，此项检查由网络过滤子系统完成。如果未通过检查，则扔掉数据包。
  - checksum校验(tcp_checksum_complete()), 不正确丢弃。
  - 如果没有监听这个端口，可能是reuse的port，重新启用这个链接reuseport_migrate_sock()
  - tcp_filter(), 这个又是在干什么？(TODO: )
  - 获取套接字锁并开始处理数据。在开始将数据向套接字传送前，首先要获取防止并发访问套接字的锁。如果获取套接字的保护锁不成功，说明有其他进程锁定了套接字，这时套接字不能接收其他数据段，则调用sk_add_backlog函数将输入段放入backlog queue队列中。
  - tcp_v4_fill_cb： 将TCP协议头的某些数据域保存在skb的控制缓冲区中，便于以后访问。skb控制缓冲区是为各层协议存放私有数据缓冲区的。例如，在第7章介绍过的，IP层协议实例用skb控制缓冲区来存放IP选项。TCP协议用它来保存：● TCP数据段的起始序列号seq。● TCP回答序列号ack_seq。输入数据段最后一个字节的位置end_seq。end_seq的值应为seq+数据段长度+SYN序列号或FIN序列号。● when和sacked数据域设为0。when用于计算数据包重传时间。sacked用于选择回答。 TCP数据段的起始序列号seq。TCP回答序列号ack_seq。输入数据段最后一个字节的位置end_seq。end_seq的值应为seq+数据段长度+SYN序列号或FIN序列号。when和sacked数据域设为0。when用于计算数据包重传时间。sacked用于选择回答。 when和sacked数据域设为0。when用于计算数据包重传时间。sacked用于选择回答。
- 确定数据包是快速路径处理还是慢速处理。快（sk->sk_state == TCP_ESTABLISHED）