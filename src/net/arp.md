# 概述

- 免费arp(Gratuitous ARP)： 检测网络上是否有其他主机的IP地址与本机相同，即地址冲突检测。 地址发生变化或者ip冲突监测。
- 地址转换
- 代理arp

## 数据结构

- arphdr: arp数据包头， 硬件类型(ar_hdrd)，协议类型(ar_pro)，硬件地址长度(ar_hln)，协议地址长度(ar_pln)，操作码(ar_op)，发送方硬件地址(ar_sha[ETH_ALEN])和IP(ar_sip[4])地址，目标方硬件地址(ar_tha[ETH_ALEN])和IP地址(ar_tip)。
- arp_generic_ops： 邻居项函数指针，通用
- arp_hh_ops： 支持缓存硬件头部
- arp_direct_ops: 不支持arp
- arp_broken_ops： 支持业务无线电设备
- arp_tbl
- rtable
- dst_entry

## 内核参数

1. arp_filter: 0允许从其他设备输出arp应答，1应答本网卡的arp请求。
2. arp_announce: 0,1,2
3. arp_ignore: 0,1,2,3
4. arp_accept: 0,1
5. proxy_arp: 是否允许arp代理

## arp状态机

## arp操作

- ARPOP_REQUEST: 请求，
- ARPOP_REPLY： 应答
- ARPOP_RREQUEST： 反向请求
- ARPOP_RREPLY： 反向应答

## 从设备层接收处理

1. 会在arp_init()中注册进ptype_base链表中。
2. arp_rcv()从IP层接收skb，
   1. 进行合理性检查(网卡设备有IFF_NOARP不支持ARP, PACKET_OTHERHOST其他主机，PACKET_LOOPBACK设备) 消费掉这个skb。消费skb其实也是直接free掉， 但是增加了trace能力。
   2. 调用NF_HOOK(NFPROTO_ARP, NF_ARP_IN)，判断是否对arp进行进一步处理。
   3. 如果要进一步处理调用arp_process()进行处理。
3. arp_process: 只处理request和response。对于request丢弃组播或者loopback的arp请求。
   1. 丢弃目的地址是组播或者loopback的arp数据, 对于组播地址和loopback地址是不需要arp。
   2. For some 802.11 wireless deployments (and possibly other networks), there will be an ARP proxy and gratuitous ARP frames are attacks and thus should not be accepted.
   3. Frame Relay source Q.922 address
   4. IPv4 duplicate address detection packet (RFC2131)重复地址监测请求原地址为0，直接走默认路由。
   5. 对于arp 类型为request的数据包，且能找到到目的地址tip的路由，进行skb缓存路由。如果路由缓存对应的ip地址类型为local，则调用neigh_event_ns（被动学习arp处理），查找符合条件的邻居项：              a)如果找到符合条件的邻居项（找不到则创建一个arp表项），则调用arp_send发送对该arp request包的reply包，并返回；b)直接返回。如果路由缓存对应的ip地址类型不是local，则进行arp proxy的处理，完成后直接返回。
   6. 对于系统允许非arp请求的arp reply，则进行如下处理： 对于非由arp请求的arp reply，且没有相应的neighbour，则强制创建新的neighbour；对于sip与tip相等的arp request，也强制创建新的neighbour（arping -U x.x.x.x）；注意这里源ip有要求：对端必须是网关或者直连路由可达；
   7. garp(gratuitous ARP): arp_is_garp(net, dev, &addr_type, arp->ar_op, sip, tip, sha, tha)
4. arp_send_dst
5. arp_ignore
6. arp_filter
7. IN_DEV_ARPFILTER(in_dev)
8. IN_DEV_FORWARD(in_dev)
9. iptunnel_metadata_reply
10. ip_route_input_noref
11. arp_fwd_proxy(in_dev, dev, rt)
12. arp_fwd_pvlan(in_dev, dev, rt, sip, tip)
13. arp_accept(in_dev, sip)
14. inet_addr_type_dev_table(net, dev, tip)

```C
static struct packet_type arp_packet_type = {
     .type =      cpu_to_be16(ETH_P_ARP),
     .func =      arp_rcv,
};
```

```C
/*
 *    This structure defines an ethernet arp header.
 */

struct arphdr {
    __be16        ar_hrd; //是硬件地址类型，对于以太网来说，其为0x01。关于可在ARP报头中使用的硬件地址标识符完整列表，请参阅include/uapi/linux/if_arp.h中的ARPHRD_XXX定义。
    __be16        ar_pro; //是协议ID，对于IPv4来说，其为0x80。关于可使用的协议ID完整列表，请参阅include/uapi/linux/if_ether.h中的ETH_P_XXX定义。
    unsigned char    ar_hln; // 是硬件地址长度，单位为字节。对于以太网地址来说，其为6字节。
    unsigned char    ar_pln; // 是协议地址长度,单位为字节。对于IPv4地址来说，其为4字节。
    __be16        ar_op; // 是操作码。ARP请求表示为ARPOP_REQUEST，ARP应答表示为ARPOP_REPLY。

#if 0
    unsigned char        ar_sha[ETH_ALEN];    // 发送方的硬件（MAC）地址
    unsigned char        ar_sip[4];        // 发送方的IPv4地址
    unsigned char        ar_tha[ETH_ALEN];   // 目标硬件（MAC)地址和IPv4地址
    unsigned char        ar_tip[4];        // 目标硬件（MAC)地址和IPv4地址
#endif
};
```

```C
/*
 *    Receive an arp request from the device layer.
 */
static int arp_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
{
    const struct arphdr *arp;

    /* do not tweak dropwatch on an ARP we will ignore */
    if (dev->flags & IFF_NOARP || skb->pkt_type == PACKET_OTHERHOST || skb->pkt_type == PACKET_LOOPBACK)
        goto consumeskb;

    skb = skb_share_check(skb, GFP_ATOMIC);
    if (!skb)
        goto out_of_mem;

    /* ARP header, plus 2 device addresses, plus 2 IP addresses.  */
    if (!pskb_may_pull(skb, arp_hdr_len(dev)))
        goto freeskb;

    arp = arp_hdr(skb);
    if (arp->ar_hln != dev->addr_len || arp->ar_pln != 4)
        goto freeskb;

    memset(NEIGH_CB(skb), 0, sizeof(struct neighbour_cb));

    return NF_HOOK(NFPROTO_ARP, NF_ARP_IN, dev_net(dev), NULL, skb, dev, NULL, arp_process);

consumeskb:
    consume_skb(skb);
    return NET_RX_SUCCESS;
freeskb:
    kfree_skb(skb);
out_of_mem:
    return NET_RX_DROP;
}

/*
 *    Process an arp request.
 */

static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
{
    struct net_device *dev = skb->dev;
    struct in_device *in_dev = __in_dev_get_rcu(dev);
    struct arphdr *arp;
    unsigned char *arp_ptr;
    struct rtable *rt;
    unsigned char *sha;
    unsigned char *tha = NULL;
    __be32 sip, tip;
    u16 dev_type = dev->type;
    int addr_type;
    struct neighbour *n;
    struct dst_entry *reply_dst = NULL;
    bool is_garp = false;

    /* arp_rcv below verifies the ARP header and verifies the device
     * is ARP'able.
     */

    if (!in_dev)
        goto out_free_skb;

    arp = arp_hdr(skb);

    switch (dev_type) {
    default:
        if (arp->ar_pro != htons(ETH_P_IP) ||
            htons(dev_type) != arp->ar_hrd)
            goto out_free_skb;
        break;
    case ARPHRD_ETHER:
    case ARPHRD_FDDI:
    case ARPHRD_IEEE802:
        /*
         * ETHERNET, and Fibre Channel (which are IEEE 802
         * devices, according to RFC 2625) devices will accept ARP
         * hardware types of either 1 (Ethernet) or 6 (IEEE 802.2).
         * This is the case also of FDDI, where the RFC 1390 says that
         * FDDI devices should accept ARP hardware of (1) Ethernet,
         * however, to be more robust, we'll accept both 1 (Ethernet)
         * or 6 (IEEE 802.2)
         */
        if ((arp->ar_hrd != htons(ARPHRD_ETHER) &&
             arp->ar_hrd != htons(ARPHRD_IEEE802)) ||
            arp->ar_pro != htons(ETH_P_IP))
            goto out_free_skb;
        break;
    case ARPHRD_AX25:
        if (arp->ar_pro != htons(AX25_P_IP) ||
            arp->ar_hrd != htons(ARPHRD_AX25))
            goto out_free_skb;
        break;
    case ARPHRD_NETROM:
        if (arp->ar_pro != htons(AX25_P_IP) ||
            arp->ar_hrd != htons(ARPHRD_NETROM))
            goto out_free_skb;
        break;
    }

    /* Understand only these message types */

    if (arp->ar_op != htons(ARPOP_REPLY) &&
        arp->ar_op != htons(ARPOP_REQUEST))
        goto out_free_skb;

/*
 *    Extract fields
 */
    arp_ptr = (unsigned char *)(arp + 1);
    sha    = arp_ptr;
    arp_ptr += dev->addr_len;
    memcpy(&sip, arp_ptr, 4);
    arp_ptr += 4;
    switch (dev_type) {
#if IS_ENABLED(CONFIG_FIREWIRE_NET)
    case ARPHRD_IEEE1394:
        break;
#endif
    default:
        tha = arp_ptr;
        arp_ptr += dev->addr_len;
    }
    memcpy(&tip, arp_ptr, 4);
/*
 *    Check for bad requests for 127.x.x.x and requests for multicast
 *    addresses.  If this is one such, delete it.
 */
    if (ipv4_is_multicast(tip) ||
        (!IN_DEV_ROUTE_LOCALNET(in_dev) && ipv4_is_loopback(tip)))
        goto out_free_skb;

 /*
  *    For some 802.11 wireless deployments (and possibly other networks),
  *    there will be an ARP proxy and gratuitous ARP frames are attacks
  *    and thus should not be accepted.
  */
    if (sip == tip && IN_DEV_ORCONF(in_dev, DROP_GRATUITOUS_ARP))
        goto out_free_skb;

/*
 *     Special case: We must set Frame Relay source Q.922 address
 */
    if (dev_type == ARPHRD_DLCI)
        sha = dev->broadcast;

/*
 *  Process entry.  The idea here is we want to send a reply if it is a
 *  request for us or if it is a request for someone else that we hold
 *  a proxy for.  We want to add an entry to our cache if it is a reply
 *  to us or if it is a request for our address.
 *  (The assumption for this last is that if someone is requesting our
 *  address, they are probably intending to talk to us, so it saves time
 *  if we cache their address.  Their address is also probably not in
 *  our cache, since ours is not in their cache.)
 *
 *  Putting this another way, we only care about replies if they are to
 *  us, in which case we add them to the cache.  For requests, we care
 *  about those for us and those for our proxies.  We reply to both,
 *  and in the case of requests for us we add the requester to the arp
 *  cache.
 */

    if (arp->ar_op == htons(ARPOP_REQUEST) && skb_metadata_dst(skb))
        reply_dst = (struct dst_entry *)
                iptunnel_metadata_reply(skb_metadata_dst(skb),
                            GFP_ATOMIC);

    /* Special case: IPv4 duplicate address detection packet (RFC2131) */
    if (sip == 0) {
        if (arp->ar_op == htons(ARPOP_REQUEST) &&
            inet_addr_type_dev_table(net, dev, tip) == RTN_LOCAL &&
            !arp_ignore(in_dev, sip, tip))
            arp_send_dst(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip,
                     sha, dev->dev_addr, sha, reply_dst);
        goto out_consume_skb;
    }

    if (arp->ar_op == htons(ARPOP_REQUEST) &&
        ip_route_input_noref(skb, tip, sip, 0, dev) == 0) {

        rt = skb_rtable(skb);
        addr_type = rt->rt_type;

        if (addr_type == RTN_LOCAL) {
            int dont_send;

            dont_send = arp_ignore(in_dev, sip, tip);
            if (!dont_send && IN_DEV_ARPFILTER(in_dev))
                dont_send = arp_filter(sip, tip, dev);
            if (!dont_send) {
                n = neigh_event_ns(&arp_tbl, sha, &sip, dev);
                if (n) {
                    arp_send_dst(ARPOP_REPLY, ETH_P_ARP,
                             sip, dev, tip, sha,
                             dev->dev_addr, sha,
                             reply_dst);
                    neigh_release(n);
                }
            }
            goto out_consume_skb;
        } else if (IN_DEV_FORWARD(in_dev)) {
            if (addr_type == RTN_UNICAST  &&
                (arp_fwd_proxy(in_dev, dev, rt) ||
                 arp_fwd_pvlan(in_dev, dev, rt, sip, tip) ||
                 (rt->dst.dev != dev &&
                  pneigh_lookup(&arp_tbl, net, &tip, dev, 0)))) {
                n = neigh_event_ns(&arp_tbl, sha, &sip, dev);
                if (n)
                    neigh_release(n);

                if (NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED ||
                    skb->pkt_type == PACKET_HOST ||
                    NEIGH_VAR(in_dev->arp_parms, PROXY_DELAY) == 0) {
                    arp_send_dst(ARPOP_REPLY, ETH_P_ARP,
                             sip, dev, tip, sha,
                             dev->dev_addr, sha,
                             reply_dst);
                } else {
                    pneigh_enqueue(&arp_tbl,
                               in_dev->arp_parms, skb);
                    goto out_free_dst;
                }
                goto out_consume_skb;
            }
        }
    }

    /* Update our ARP tables */

    n = __neigh_lookup(&arp_tbl, &sip, dev, 0);

    addr_type = -1;
    if (n || arp_accept(in_dev, sip)) {
        is_garp = arp_is_garp(net, dev, &addr_type, arp->ar_op,
                      sip, tip, sha, tha);
    }

    if (arp_accept(in_dev, sip)) {
        /* Unsolicited ARP is not accepted by default.
           It is possible, that this option should be enabled for some
           devices (strip is candidate)
         */
        if (!n &&
            (is_garp ||
             (arp->ar_op == htons(ARPOP_REPLY) &&
              (addr_type == RTN_UNICAST ||
               (addr_type < 0 &&
            /* postpone calculation to as late as possible */
            inet_addr_type_dev_table(net, dev, sip) ==
                RTN_UNICAST)))))
            n = __neigh_lookup(&arp_tbl, &sip, dev, 1);
    }

    if (n) {
        int state = NUD_REACHABLE;
        int override;

        /* If several different ARP replies follows back-to-back,
           use the FIRST one. It is possible, if several proxy
           agents are active. Taking the first reply prevents
           arp trashing and chooses the fastest router.
         */
        override = time_after(jiffies,
                      n->updated +
                      NEIGH_VAR(n->parms, LOCKTIME)) ||
               is_garp;

        /* Broadcast replies and request packets
           do not assert neighbour reachability.
         */
        if (arp->ar_op != htons(ARPOP_REPLY) ||
            skb->pkt_type != PACKET_HOST)
            state = NUD_STALE;
        neigh_update(n, sha, state,
                 override ? NEIGH_UPDATE_F_OVERRIDE : 0, 0);
        neigh_release(n);
    }

out_consume_skb:
    consume_skb(skb);

out_free_dst:
    dst_release(reply_dst);
    return NET_RX_SUCCESS;

out_free_skb:
    kfree_skb(skb);
    return NET_RX_DROP;
}
```

arp_rcv函数被注册到内核中，当有ARP协议报文调用arp_rcv处理。某些情况下收到一个ARP报文可能导致发出一个ARP报文，这些情况是：

- 配置了网桥，网桥只是转发报文到其他接口。
- 邻居子系统对请求报文做出应答。

1. 如果收到ARP数据包的网络设备设置标志为IFF_NOARP或者数据包不是发送给当前主机，或数据包是发送给环回设备的，就必须将数据包丢弃。
2. 如果SKB是共享的，就必须复制它，因为在方法arp_rcv()进行处理期间，它可能被其他人修改。如果SKB是共享的，方法skb_share_check()就将创建其副本
3. ARP报头，两个设备地址，两个IP地址
4. ARP报头的ar_hln表示硬件地址的长度。对于以太网报头来说,其应为6字节，并与net_device对象的addr_len相等。ARP报头的ar_pln表示协议地址的长度，它应与IPv4地址的长度相等，即为4字节。
5. 如果一切正常，就接着调用方法arp_process()，由它执行处理ARP数据包的实际工作。

在方法arp_process()中，只处理ARP报文请求和响应（回复）

- 对于ARP请求，将使用方法ip_route_input_noref()执行路由选择子系统查找。如果ARP数据包是发送给当前主机的（路由选择条目的rt_type为RTN_LOCAL)，就接着检查一些条件。如果这些检查都通过了，就使用方法arp_send()发回ARP应答。如果ARP数据包不是发送给当前主机但需要进行转发的(路由选择条目的rt_type为RTN_UNICAST)，也需要检查一些条件。如果这些条件都满足，就调用方法pneigh_lookup()在代理ARP表中进行查找。
- 主机还不知道默认网关的MAC地址，它会发起ARP的请求。主机生成一个包含目的地址为网关路由器 IP 地址(DHCP)的 ARP 查询报文，将该 ARP 查询报文放入一个具有广播目的地址（的以太网帧中，并向交换机发送该以太网帧，交换机将该帧转发给所有的连接设备，包括网关路由器。默认网关把它自己的MAC地址作为应答回来
- Host1开始封装它的数据了，目的为默认网关的MAC地址。Host1发出的数据通过MAC寻址送到了默认网关。默认网关收到数据之后（解封装、提取出目的IP、查表）然后转发出去（重新封装，源/目的MAC地址都发送了转换），最后就把这个数据发往Host4所在的EE网络（当然有可能也不知道Host4的MAC地址，这个时候网关一样会发送ARP请求）


1. 比如arp_process() 首先验证ARP报文头和设备是否使能ARP功能。
2. arp_process函数只处理ARPOP_REPLY和ARPOP_REQUEST报文类型。
3. 如果连续收到多个ARP应答，将使用第一个应答，如果有多个代理处于活动状态，就可能出现这种情况，使用第一个应答可避免ARP受损，并确保选择的是最快的路由器。

## 代理arp

## lvs

## 网桥

## ovs

## ipsec

## dhcp

有些程序可以检测到IP地址冲突的现象。典型的如DHCP服务器准备提供IP地址给客户端之前，会发送一个arp广播，以便确认该IP地址是否已被其他主机使用(例如其他主机使用静态IP时手动输入了该IP)。如果没有收到回应，则表示该IP地址没有被使用，可以提供给客户端使用，如果收到了回应，则表示该IP地址已经被使用了，DHCP会从IP池中换一个IP提供给客户端。