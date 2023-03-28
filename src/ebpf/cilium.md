# 工具
网络可视化工具hubble


# 功能

1. (veth-pair）。这个ARP响应是通过Cilium Agent通过挂载的eBPF程序实现的自动应答，并且将veth-pair对端的MAC地址返回，避免了虚拟网络中的ARP广播问题。
2. cilium_vxlan进行隧道相关的封包、解包处理。在物理网卡eth0抓包可以发现，Pod1出发的数据包经过cilium_vxlan的封装处理之后，其源目的地址已经变成物理主机node-161和node-162，这是经典的overlay封装。同时，还可以发现，cilium_vxlan除了对数据包进行了隧道封装之外，还将原始数据包进行了TLS加密处理，保障了数据包在主机外的物理网络中的安全性
3. Cilium Agent采用eBPF实现对数据包的重定向，将需要进行过滤的数据包首先转发至Proxy代理，Proxy代理根据其相应的过滤规则，对收到的数据包进行过滤，然后再将其发回至数据包的原始路径，而Proxy代理进行过滤的规则，则通过Cilium Agent进行下发和管理。



# datapath
## L2层
![l2](./images/l2.png)
1. napi poll
2. xdp在驱动层poll，要求驱动支持xdp。XDP 程序返回一个判决结果给驱动，可以是 PASS, TRANSMIT, 或 DROP。
   1. transmit可以做数据包修改，在转发给设备
   2. drop直接删除
   3. pass默认路径处理，进入clean_rx()
3. clean_rx()：创建 skb, 更新一些统计信息，对 skb 进行硬件校验和检查，然后将其交给 gro_receive() 方法.
4. gro_receive(): GRO 是一种较老的硬件特性（LRO）的软件实现，功能是对分片的包进行重组然后交给更 上层，以提高吞吐。GRO 给协议栈提供了一次将包交给网络协议栈之前，对其检查校验和 、修改协议头和发送应答包（ACK packets）的机会。
   1. 如果 GRO 的 buffer 相比于包太小了，它可能会选择什么都不做。
   2. 如果当前包属于某个更大包的一个分片，调用 enqueue_backlog 将这个分片放到某个 CPU 的包队列。当包重组完成后，会交给 receive_skb() 方法处理。
   3. 如果当前包不是分片包，直接调用 receive_skb()，进行一些网络栈最底层的处理。
5. receive_skb() 之后会再次进入 XDP 程序点。

## L2 -> L3 
![l2_2l3](./images/l2_l3.png)
6. 通用 XDP 处理（gXDP）: Step 2 中提到，如果网卡驱动不支持 XDP，那 XDP 程序将延迟到更后面执行，这个 “更后面”的位置指的就是这里的 (g)XDP。有3中处理结果： transmit、pass和drop。
7. Tap 设备处理: 图中有个 *check_taps 框，但其实并没有这个方法：receive_skb() 会轮询所有的 socket tap，将包放到正确的 tap 设备的缓冲区。tap 设备监听的是三层协议（L3 protocols），例如 IPv4、ARP、IPv6 等等。如果 tap 设 备存在，它就可以操作这个 skb 了。
8. tc（traffic classifier）处理, 接下来我们遇到了第二种 eBPF 程序：tc eBPF。tc（traffic classifier，流量分类器）是 Cilium 依赖的最基础的东西，它提供了多种功 能，例如修改包（mangle，给 skb 打标记）、重路由（reroute）、丢弃包（drop），这 些操作都会影响到内核的流量统计，因此也影响着包的排队规则（queueing discipline ）。Cilium 控制的网络设备，[至少被加载了一个 tc eBPF 程序](http://arthurchiao.art/blog/cilium-network-topology-on-aws/)。
9. Netfilter 处理: 如果 tc BPF 返回 OK，包会再次进入 Netfilter。Netfilter 也会对入向的包进行处理，这里包括 nftables 和 iptables 模块。有一点需要记住的是：Netfilter 是网络栈的下半部分（the “bottom half” of the network stack），因此 iptables 规则越多，给网络栈下半部分造成的瓶颈就越大。*def_dev_protocol 框是二层过滤器（L2 net filter），由于 Cilium 没有用到任何 L2 filter，因此这里我就不展开了。

## L3 协议层处理：ip_rcv()
如果包没有被前面丢弃，就会通过网络设备的 ip_rcv() 方法进入协议栈的三层（ L3）—— 即 IP 层 —— 进行处理。
## L3 -> L4（网络层 -> 传输层）
![l3_l4](./images/L3_l4.png)

11. ip_rcv() 做的第一件事情是再次执行 Netfilter 过滤，因为我们现在是从四层（L4）的 视角来处理 socker buffer。因此，这里会执行 Netfilter 中的任何四层规则（L4 rules ）。
12. ip_rcv_finish() 处理: Netfilter 执行完成后，调用回调函数 ip_rcv_finish()。ip_rcv_finish() 立即调用 ip_routing() 对包进行路由判断。
13. ip_routing() 处理: ip_routing() 对包进行路由判断，例如看它是否是在 lookback 设备上，是否能 路由出去（could egress），或者能否被路由，能否被 unmangle 到其他设备等等。在 Cilium 中，如果没有使用隧道模式（tunneling），那就会用到这里的路由功能。相比 隧道模式，路由模式会的 datapath 路径更短，因此性能更高。
14. 目的是本机：ip_local_deliver() 处理: 根据路由判断的结果，如果包的目的端是本机，会调用 ip_local_deliver() 方法。ip_local_deliver() 会调用 xfrm4_policy()。
15. xfrm4_policy() 处理: xfrm4_policy() 完成对包的封装、解封装、加解密等工作。例如，IPSec 就是在这里完成的最后，根据四层协议的不同，ip_local_deliver() 会将最终的包送到 TCP 或 UDP 协议 栈。这里必须是这两种协议之一，否则设备会给源 IP 地址回一个 ICMP destination unreachable 消息。


## L4（传输层，以 UDP 为例）
接下来我将拿 UDP 协议作为例子，因为 TCP 状态机太复杂了，不适合这里用于理解 datapath 和数据流。但不是说 TCP 不重要，Linux TCP 状态机还是非常值得好好学习的。
![l4_udp](./images/l4_udp.png)
16. udp_rcv() 处理: udp_rcv() 对包的合法性进行验证，检查 UDP 校验和。然后，再次将包送到 xfrm4_policy() 进行处理。
17. xfrm4_policy() 再次处理: 这里再次对包执行 transform policies 是因为，某些规则能指定具体的四层协议，所以只 有到了协议层之后才能执行这些策略。
18. 将包放入 socket_receive_queue: 这一步会拿端口（port）查找相应的 socket，然后将 skb 放到一个名为 socket_receive_queue 的链表。
19. 通知 socket 收数据：sk_data_ready(),最后，udp_rcv() 调用 sk_data_ready() 方法，标记这个 socket 有数据待收。一个 socket 就是 Linux 中的一个文件描述符，这个描述符有一组相关的文件操 作抽象，例如 read、write 等等。