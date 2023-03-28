# 功能设计

## features

1. NF_HOOK

## 数据结构

- struct net_protocol *inet_protos[MAX_INET_PROTOS]: 用于存已注册的传输层协议实例从IP层接收数据包的处理函数块。全局向量的基地址由：`struct net_protocol*inet_protocol_base`指定。
- net_protocol: IP层与传输层数据包接收接口

注册几种基础 L4 协议的 rx handler， 放到`inet_protos`全局向量：

1. inet_add_protocol(&icmp_protocol, IPPROTO_ICMP);
2. inet_add_protocol(&udp_protocol,  IPPROTO_UDP);
3. inet_add_protocol(&tcp_protocol,  IPPROTO_TCP);
4. inet_add_protocol(&igmp_protocol, IPPROTO_IGMP);

```C
// https://github.com/torvalds/linux/blob/v5.10/net/ipv4/af_inet.c

static struct net_protocol tcp_protocol = {
    .early_demux    =    tcp_v4_early_demux,
    .early_demux_handler =  tcp_v4_early_demux,
    .handler    =    tcp_v4_rcv,
    .err_handler    =    tcp_v4_err,
    .no_policy    =    1,
    .netns_ok    =    1,
    .icmp_strict_tag_validation = 1,
};

static struct net_protocol udp_protocol = {
    .early_demux =    udp_v4_early_demux,
    .early_demux_handler =    udp_v4_early_demux,
    .handler =    udp_rcv,
    .err_handler =    udp_err,
    .no_policy =    1,
    .netns_ok =    1,
};

static const struct net_protocol icmp_protocol = {
    .handler =    icmp_rcv,
    .err_handler =    icmp_err,
    .no_policy =    1,
    .netns_ok =    1,
};
```

## 接口

- `ip_local_deliver_finish`: 函数将数据包上传给传输层(tcp\udp\icmp\igmp)

## 管理

- int inet_add_protocol(struct net_protocol *prot, unsigned char protocol)： 将协议的struct net_protocol变量实例加入到系统中，即放入inet_protos全局向量中
- int inet_del_protocol(struct net_protocol *prot, unsigned char protocol)： 将协议从inet_protos全局向量中移走
- 初始化

## 初始化

协议栈注册： fs_initcall(inet_init),初始化internet 协议族的协议栈：

   1. 初始化`raw_v4_hashinfo`
   2. 注册协议：`tcp_prot`: sock_register获得net_family_lock自旋锁在下面局部全局数组net_families中添加PF_INET对应的成员
   3. 注册协议：`udp_prot`
   4. 注册协议: `raw_prot`
   5. 注册协议: `ping_prot`
   6. 注册协议簇操作函数集： `inet_family_ops`
   7. `ip_static_sysctl_init()`: 其作用是创建/proc/sys/net/ipv4/route文件，从该文件的名称可以知道是和路由相关的，该文件包含路由参数包括垃圾回收的时间间隔等，系统管理员可以通过这里对系统性能进行调优。inet_init函数的初衷是初始化inet协议，但把路由sysctl参数接口初始化放在这里显得有点不伦不类，至少其它的/proc/sys/net/ipv4/下的sysctl接口的初始化方法和这里的不一样。
   8. 协议簇中注册`icmp_protocol`协议: 基础协议的初始化，它们都是调用inet_add_protocol函数将对应的协议添加到inet_protos的hash表上。
   9. 协议簇中注册`tcp_protocol`传输层协议
   10. 协议簇中注册`udp_protocol`传输层协议
   11. arp模块初始化:arp_init(),根据IP地址获取物理地址的协议，在使用ping命令也许你会注意到一个现象，有时使用ping命令时，ping的第一次输出延迟是后续延迟的几十倍，后续再ping，第一次延迟和后续的延迟相差无几，第一次延迟较大是知道IP但是不知道MAC地址原因，所以先发送了一个地址解析请求，获得目标ip对应的物理地址之后，设备才是真正发送ICMPping包。
   12. ip模块初始化：ip_init(),ip路由和peer子系统初始化，因为ip是无状态连接，内核为了提升性能，路由子系统会使用peer保存一些信息，peer子系统使用avi树保存这些信息。
   13. 初始化per-cpu变量 ipv4 mibs： init_ipv4_mibs()
   14. 初始化tcp slab： tcp_init()
   15. 初始化udp内存限制： udp_init()
   16. udp-lite(RFC 3828)初始化： udplite4_register()
   17. raw_init()
   18. ping_init()
   19. icmp初始化： icmp_init()
   20. 网络层多波路由初始化： ip_mr_init()
   21. ipv4 inet pernet ops初始化： init_inet_pernet_ops()
   22. proc初始化： ipv4_proc_init()
   23. 网络层分片初始化： ipfrag_init()
   24. dev_add_pack(&ip_packet_type)
   25. ip_tunnel_core_init

## 2层到IP层

- ip_rcv: ip层从2层设备管理层收包接口，数据合法性验证，统计计数器更新等 等，它在最后会以 netfilter hook 的方式调用 ip_rcv_finish() 方法。 这样任何 iptables 规则都能在 packet 刚进入 IP 层协议的时候被应用，在其他处理之前
- Netfilter `NF_INET_PRE_ROUTING` hook: netfilter 或 iptables 规则都是在软中断上下文中执行的， 数量很多或规则很复杂时会导致网络延迟。TC BPF 也是在软中断上下文中， 但要比 netfilter/iptables 规则高效地多，也发生在更前面（能提前返回），所以应尽可能用 BPF。
- ip_rcv_finish(): Netfilter 完成对数据的处理之后，就会调用 ip_rcv_finish() —— 当然，前提是 netfilter 没有丢掉这个包。
- early_demux函数：为了能将包送到合适的目的地，需要一个路由 子系统的 dst_entry 变量。为了获取这个变量，早期的代码调用了 early_demux 函数。 early_demux 是一个优化项，通过检查相应的变量是否缓存在 socket 变量上，来路由 这个包所需要的 dst_entry 变量。默认 early_demux 是打开的`net.ipv4.ip_early_demux = 1`, `net.ipv4.tcp_early_demux = 1`, `net.ipv4.udp_early_demux = 1`.如果这个优化打开了，但是并没有命中缓存（例如，这是第一个包），这个包就会被送到内核的路由子系统，在那里将会计算出一个 `dst_entry` 并赋给相应的字段。路由子系统完成工作后，会更新计数器，然后调用 `dst_input(skb)`，后者会进一步调用 `dst_entry` 变量中的 input 方法，这个方法是一个函数指针，由路由子系统初始化。例如 ，如果 packet 的最终目的地是本机（local system），路由子系统会将 ip_local_deliver 赋 给 input。
- ip_local_deliver(): 只要 packet 没有在 netfilter 被 drop，就会调用 ip_local_deliver_finish 函数。
- ip_local_deliver_finish() -> ip_protocol_deliver_rcu()  -> l4proto.callback: ip_local_deliver_finish 从数据包中读取协议，寻找注册在这个协议上的 struct net_protocol 变量，并调用该变量中的回调方法。这样将包送到协议栈的更上层。根据上层协议类型选择不同的 callback 函数把数据收走：`tcp_v4_rcv`, `udp_v4_rcv`, `icmp_send`

```C
/*
 * IP receive entry point
 */
int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
{
    struct net *net = dev_net(dev);

    skb = ip_rcv_core(skb, net);
    if (skb == NULL)
        return NET_RX_DROP;

    return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, net, NULL, skb, dev, NULL, ip_rcv_finish);
}

/*
 *     Main IP Receive routine.
 */
static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
{
    const struct iphdr *iph;
    int drop_reason;
    u32 len;

    /* When the interface is in promisc. mode, drop all the crap
     * that it receives, do not try to analyse it.
     */
    if (skb->pkt_type == PACKET_OTHERHOST) { //驱动根据MAC地址设置的，如果MAC地址不是本机的话，在这里丢弃。
        dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
        drop_reason = SKB_DROP_REASON_OTHERHOST;
        goto drop;
    }

    __IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);

    skb = skb_share_check(skb, GFP_ATOMIC);
    if (!skb) {
        __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
        goto out;
    }

    drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
    if (!pskb_may_pull(skb, sizeof(struct iphdr)))
        goto inhdr_error;

    iph = ip_hdr(skb);

    /*
     *    RFC1122: 3.2.1.2 MUST silently discard any IP frame that fails the checksum.
     *
     *    Is the datagram acceptable?
     *
     *    1.    Length at least the size of an ip header
     *    2.    Version of 4
     *    3.    Checksums correctly. [Speed optimisation for later, skip loopback checksums]
     *    4.    Doesn't have a bogus length
     */

    if (iph->ihl < 5 || iph->version != 4) //校验ip头是否正确
        goto inhdr_error;

    BUILD_BUG_ON(IPSTATS_MIB_ECT1PKTS != IPSTATS_MIB_NOECTPKTS + INET_ECN_ECT_1);
    BUILD_BUG_ON(IPSTATS_MIB_ECT0PKTS != IPSTATS_MIB_NOECTPKTS + INET_ECN_ECT_0);
    BUILD_BUG_ON(IPSTATS_MIB_CEPKTS != IPSTATS_MIB_NOECTPKTS + INET_ECN_CE);
    __IP_ADD_STATS(net,
               IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
               max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));

    if (!pskb_may_pull(skb, iph->ihl*4))
        goto inhdr_error;

    iph = ip_hdr(skb);

    if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl))) //校验ip头是否正确
        goto csum_error;

    len = ntohs(iph->tot_len);//iph中的大小是真正的大小，skb中len的大小是驱动中设置的，当包很小的时候，会进行填充，因此会比iph中的大
    if (skb->len < len) {//以r8169为例，如果收到udp的包负载为1,则iph中的大小为20+8+1=29。但是此时skb->len=46=64(min)-14-4(vlan)
        drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
        __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
        goto drop;
    } else if (len < (iph->ihl*4))
        goto inhdr_error;

    /* Our transport medium may have padded the buffer out. Now we know it
     * is IP we can trim to the true length of the frame.
     * Note this now means skb->len holds ntohs(iph->tot_len).
     */
    if (pskb_trim_rcsum(skb, len)) {   //去除填充的数据
        __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
        goto drop;
    }

    iph = ip_hdr(skb);
    skb->transport_header = skb->network_header + iph->ihl*4;

    /* Remove any debris in the socket control block */
    memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
    IPCB(skb)->iif = skb->skb_iif;

    /* Must drop socket now because of tproxy. */
    if (!skb_sk_is_prefetched(skb))
        skb_orphan(skb);

    return skb;

csum_error:
    drop_reason = SKB_DROP_REASON_IP_CSUM;
    __IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
inhdr_error:
    if (drop_reason == SKB_DROP_REASON_NOT_SPECIFIED)
        drop_reason = SKB_DROP_REASON_IP_INHDR;
    __IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
drop:
    kfree_skb_reason(skb, drop_reason);
out:
    return NULL;
}

static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
{
    struct net_device *dev = skb->dev;
    int ret;

    /* if ingress device is enslaved to an L3 master device pass the
     * skb to its handler for processing
     */
    skb = l3mdev_ip_rcv(skb);
    if (!skb)
        return NET_RX_SUCCESS;

    ret = ip_rcv_finish_core(net, sk, skb, dev, NULL);
    if (ret != NET_RX_DROP)
        ret =     input(skb); //skb_dst(skb)->input(skb);路由寻找过程中赋值，本地接收的话为：ip_local_deliver
    return ret;
}

static int ip_rcv_finish_core(struct net *net, struct sock *sk, struct sk_buff *skb, struct net_device *dev, const struct sk_buff *hint)
{
    const struct iphdr *iph = ip_hdr(skb);
    int err, drop_reason;
    struct rtable *rt;

    drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;

    if (ip_can_use_hint(skb, iph, hint)) {
        err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos, dev, hint);//路由寻找，根据目的地址判断是本地接收还是转发（使能forward的话）
        if (unlikely(err))
            goto drop_error;
    }

    if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
        !skb_dst(skb) &&
        !skb->sk &&
        !ip_is_fragment(iph)) {
        switch (iph->protocol) {
        case IPPROTO_TCP:
            if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
                tcp_v4_early_demux(skb);

                /* must reload iph, skb->head might have changed */
                iph = ip_hdr(skb);
            }
            break;
        case IPPROTO_UDP:
            if (READ_ONCE(net->ipv4.sysctl_udp_early_demux)) {
                err = udp_v4_early_demux(skb);
                if (unlikely(err))
                    goto drop_error;

                /* must reload iph, skb->head might have changed */
                iph = ip_hdr(skb);
            }
            break;
        }
    }

    /*
     *    Initialise the virtual path cache for the packet. It describes
     *    how the packet travels inside Linux networking.
     */
    if (!skb_valid_dst(skb)) {
        err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
                       iph->tos, dev);
        if (unlikely(err))
            goto drop_error;
    } else {
        struct in_device *in_dev = __in_dev_get_rcu(dev);

        if (in_dev && IN_DEV_ORCONF(in_dev, NOPOLICY))
            IPCB(skb)->flags |= IPSKB_NOPOLICY;
    }

#ifdef CONFIG_IP_ROUTE_CLASSID
    if (unlikely(skb_dst(skb)->tclassid)) {
        struct ip_rt_acct *st = this_cpu_ptr(ip_rt_acct);
        u32 idx = skb_dst(skb)->tclassid;
        st[idx&0xFF].o_packets++;
        st[idx&0xFF].o_bytes += skb->len;
        st[(idx>>16)&0xFF].i_packets++;
        st[(idx>>16)&0xFF].i_bytes += skb->len;
    }
#endif

    if (iph->ihl > 5 && ip_rcv_options(skb, dev))
        goto drop;

    rt = skb_rtable(skb);
    if (rt->rt_type == RTN_MULTICAST) {
        __IP_UPD_PO_STATS(net, IPSTATS_MIB_INMCAST, skb->len);
    } else if (rt->rt_type == RTN_BROADCAST) {
        __IP_UPD_PO_STATS(net, IPSTATS_MIB_INBCAST, skb->len);
    } else if (skb->pkt_type == PACKET_BROADCAST ||
           skb->pkt_type == PACKET_MULTICAST) {
        struct in_device *in_dev = __in_dev_get_rcu(dev);

        /* RFC 1122 3.3.6:
         *
         *   When a host sends a datagram to a link-layer broadcast
         *   address, the IP destination address MUST be a legal IP
         *   broadcast or IP multicast address.
         *
         *   A host SHOULD silently discard a datagram that is received
         *   via a link-layer broadcast (see Section 2.4) but does not
         *   specify an IP multicast or broadcast destination address.
         *
         * This doesn't explicitly say L2 *broadcast*, but broadcast is
         * in a way a form of multicast and the most common use case for
         * this is 802.11 protecting against cross-station spoofing (the
         * so-called "hole-196" attack) so do it for both.
         */
        if (in_dev &&
            IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST)) {
            drop_reason = SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST;
            goto drop;
        }
    }

    return NET_RX_SUCCESS;

drop:
    kfree_skb_reason(skb, drop_reason);
    return NET_RX_DROP;

drop_error:
    if (err == -EXDEV) {
        drop_reason = SKB_DROP_REASON_IP_RPFILTER;
        __NET_INC_STATS(net, LINUX_MIB_IPRPFILTER);
    }
    goto drop;
}

/*
 *     Deliver IP Packets to the higher protocol layers.
 */
int ip_local_deliver(struct sk_buff *skb)
{
    /*
     *    Reassemble IP fragments.
     */
    struct net *net = dev_net(skb->dev);

    if (ip_is_fragment(ip_hdr(skb))) {
        if (ip_defrag(net, skb, IP_DEFRAG_LOCAL_DELIVER))
            return 0;
    }

    return NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_IN,
               net, NULL, skb, skb->dev, NULL,
               ip_local_deliver_finish);
}

// 函数根据L3头指定的L4协议，调用特定的函数
static int ip_local_deliver_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
{
    skb_clear_delivery_time(skb);
    __skb_pull(skb, skb_network_header_len(skb));

    rcu_read_lock();
    ip_protocol_deliver_rcu(net, skb, ip_hdr(skb)->protocol);
    rcu_read_unlock();

    return 0;
}
```
