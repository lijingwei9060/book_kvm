# 概述

Linux 内核支持了 IPv6 流量的 BIG TCP，BIG TCP 允许更大的 `TSO/GRO` 数据包，这大大提高了 IPv6 的传输性能，尤其是在 25~100 + Gbit 的网络空间中，升速的同时还降低了延迟。
BIG TCP 支持可以实现更好的网络吞吐量性能和更低的延迟，特别是在具有高速网络适配器的数据中心。

而对于 IPv6 的 BIG TCP，Linux 6.3 内核还扩展了 Intel ICE 驱动程序，感兴趣的朋友可以在 Netdev 0x 15 演示稿中找到关于 BIG TCP 的更多背景信息。

`tot_len` 是16bit， ipv4的header没有exthrs，使用big tcp，设置tot_len=0 表明是一个big tcp包，skb->len为真实的ipv4长度。 所有big tcp包都是GSO、GRO包。skb->len - network_offset就是实际的ipv4数据包大小。
标准的TSO/GRO限制包大小，使用big tcp可以支持更大的传输包。

iph tot_len代表ip头部全部的数据包长度， 在gro中这个大小为(size of one set of IP/TCP header) + size(payload)。因为是16位的，所以最大为64KB。GSO和GRO都有这个限制，即使是IPv6也有这个限制。64KB太小，发送时间为us级别。

RFC 2675规范中，IPv6里面有巨型帧(IPv6 jumbograms)，增加扩展的8byte支持(a jumbo TLV)，这个应用的不是很广泛。

当前内核限制skb的fragments为不超过17个，对于64KB是足够的(17*4K?)，更大的数据包需要修改这个大小是通过配置项呢还是？。



adds a GSO_TCP tp_status for af_packet users
add gso/gro_ipv4_max_size per device and netlink attributes

new netlink attributes to make IPv4 BIG TCP independent from IPv6

## ipv4的big tcp修改了什么

- net: add a couple of helpers for iph tot_len， 如果是0就需要从skb->len获取包的大小，如果包大于0xFFFFU(64KB)tot_len设为0
- bridge: use skb_ip_totlen in br netfilter
- openvswitch: use skb_ip_totlen in conntrack
- net: sched: use skb_ip_totlen and iph_totlen
- netfilter: use skb_ip_totlen and iph_totlen
- cipso_ipv4: use iph_set_totlen in skbuff_setattr
- ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
- packet: add TP_STATUS_GSO_TCP for tp_status： 引入`TP_STATUS_GSO_TCP` 标志tp_status，对于用户空间tcpdump/libpcap表明这是一个IPv4 Big Tcp包，使用tp_len表示包大小，ip头部tot_len大小为0.
- net: add gso_ipv4_max_size and gro_ipv4_max_size per device： 在netlink属性上增加`gso_ipv4_max_size`和`gro_ipv4_max_size`参数设定
- net: add support for ipv4 big tcp
    1. 允许sk->sk_gso_max_size大于`GSO_LEGACY_MAX_SIZE`
    2. 发送：在`__ip_local_out()`中设置tot_len 为0 当skb->len > IP_MAX_MTU。接收：修改`ip_rcv_core()`使用skb->len作为长度。
    3. 对于gro接收，在`skb_gro_receive()`允许合并超过`GRO_LEGACY_MAX_SIZE`大小的包。

## 性能测试

ip link set dev ens1f0np0 gro_ipv4_max_size 128000 gso_ipv4_max_size 128000
for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done