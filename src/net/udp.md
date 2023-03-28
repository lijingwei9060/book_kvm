# 概述


## 初始化

UDP 和 UDP-Lite 都会执行哈希表的创建, 传过来的 name 分别是 UDP 和 UDP-Lite。 alloc_large_system_hash() 在哈希表创建成功之后会打印哈希表的信息：

```C
// net/ipv4/udp.c
void __init udp_table_init(struct udp_table *table, const char *name) {
    table->hash = alloc_large_system_hash(name,
                          2 * sizeof(struct udp_hslot),
                          uhash_entries,
                          21, /* one slot per 2 MB */
                          0,
                          &table->log,
                          &table->mask,
                          UDP_HTABLE_SIZE_MIN,
                          64 * 1024);
    ...
}

// mm/page_alloc.c
pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n", tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,  virt ? "vmalloc" : "linear");
```

## 从IP层接收

1. udp调用udp_rcv，最后调用__udp4_lib_rcv。__udp4_lib_rcv() 封装了两种 UDP 协议的处理`IPPROTO_UDP`，`IPPROTO_UDPLITE`。
2. __udp4_lib_rcv():  首先对包数据进行合法性检查，获取 UDP 头、UDP 数据报长度、源地址、目 标地址等信息。然后进行其他一些完整性检测和 checksum 验证。回忆前面的 IP 层内容，在送到更上面一层协议（这里是 UDP）之前，会将一个 dst_entry 会关联到 skb。如果对应的 dst_entry 找到了，并且有对应的 socket，__udp4_lib_rcv 会将 packet 放到 socket 的接收队列； 如果 socket 没有找到，数据报(datagram)会被丢弃。
3. udp_unicast_rcv_skb(): 如果对应的 dst_entry 找到了，并且有对应的 socket，__udp4_lib_rcv 会将 packet 放到 socket 的接收队列； 如果 early_demux 中没有关联 socket 信息，那此时会调用__udp4_lib_lookup_skb 查找对应的 socket。最后都会将 packet 放到 socket 的接收队列。
4. udp_queue_rcv_skb(): 判断 queue 未满之后，就会将数据报放到里面。1. 判断和这个数据报关联的 socket 是不是 encapsulation socket。如果是，将 packet 送到该层的处理函数。2. 判断这个数据报是不是 UDP-Lite 数据报，做一些完整性检测。3. 验证 UDP 数据报的校验和，如果校验失败，就丢弃。
5. __skb_queue_tail()：网络数据通过 `__skb_queue_tail()` 进入 socket 的接收队列，在此之前，会做几件事情：
   1. 检查 socket 已分配的内存，如果超过了 receive buffer 的大小，丢弃这个包并更新计数
   2. 应用 sk_filter，这允许在 socket 上执行 BPF 程序；
   3. 执行 sk_rmem_scedule，确保有足够大的 receive buffer 接收这个数据报
   4. 执行 skb_set_owner_r，这会计算数据报的长度并更新 sk->sk_rmem_alloc 计数
   5. 调用__skb_queue_tail 将数据加到队列尾端
   6. 最后，所有在这个 socket 上等待数据的进程都收到一个通知通过 sk_data_ready 通知处理 函数。


```C
int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable, int proto)
{
    struct sock *sk;
    struct udphdr *uh;
    unsigned short ulen;
    struct rtable *rt = skb_rtable(skb);
    __be32 saddr, daddr;
    struct net *net = dev_net(skb->dev);
    bool refcounted;
    int drop_reason;

    drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;

    /*
     *  Validate the packet.
     */
    if (!pskb_may_pull(skb, sizeof(struct udphdr)))
        goto drop;        /* No space for header. */

    uh   = udp_hdr(skb);
    ulen = ntohs(uh->len);
    saddr = ip_hdr(skb)->saddr;
    daddr = ip_hdr(skb)->daddr;

    if (ulen > skb->len)
        goto short_packet;

    if (proto == IPPROTO_UDP) {
        /* UDP validates ulen. */
        if (ulen < sizeof(*uh) || pskb_trim_rcsum(skb, ulen))
            goto short_packet;
        uh = udp_hdr(skb); // 如果是 UDP 而非 UDPLITE，需要再次获取 UDP header
    }

    if (udp4_csum_init(skb, uh, proto))
        goto csum_error;

    sk = skb_steal_sock(skb, &refcounted); // 如果能直接从 skb 中获取 sk 信息（skb->sk 字段）
    if (sk) {
        struct dst_entry *dst = skb_dst(skb);
        int ret;

        if (unlikely(rcu_dereference(sk->sk_rx_dst) != dst))
            udp_sk_rx_dst_set(sk, dst);

        ret = udp_unicast_rcv_skb(sk, skb, uh);
        if (refcounted)
            sock_put(sk);
        return ret;
    }

    if (rt->rt_flags & (RTCF_BROADCAST|RTCF_MULTICAST))
        return __udp4_lib_mcast_deliver(net, skb, uh,
                        saddr, daddr, udptable, proto);
    // 从 udp hash list 中搜索有没有关联的 socket，或者查看有没有 BPF redirect socket
    sk = __udp4_lib_lookup_skb(skb, uh->source, uh->dest, udptable);
    if (sk)
        return udp_unicast_rcv_skb(sk, skb, uh);

    if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
        goto drop;
    nf_reset_ct(skb);

    /* No socket. Drop packet silently, if checksum is wrong */
    if (udp_lib_checksum_complete(skb))
        goto csum_error;

    drop_reason = SKB_DROP_REASON_NO_SOCKET;
    __UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
    icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);

    /*
     * Hmm.  We got an UDP packet to a port to which we
     * don't wanna listen.  Ignore it.
     */
    kfree_skb_reason(skb, drop_reason);
    return 0;

short_packet:
    drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
    net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
                proto == IPPROTO_UDPLITE ? "Lite" : "",
                &saddr, ntohs(uh->source),
                ulen, skb->len,
                &daddr, ntohs(uh->dest));
    goto drop;

csum_error:
    /*
     * RFC1122: OK.  Discards the bad packet silently (as far as
     * the network is concerned, anyway) as per 4.1.3.4 (MUST).
     */
    drop_reason = SKB_DROP_REASON_UDP_CSUM;
    net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
                proto == IPPROTO_UDPLITE ? "Lite" : "",
                &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
                ulen);
    __UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
drop:
    __UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
    kfree_skb_reason(skb, drop_reason);
    return 0;
}
```