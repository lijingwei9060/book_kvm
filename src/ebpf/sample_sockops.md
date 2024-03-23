
## socket map 维护：sockops
附加到 sock_ops 的程序：监控 socket 状态，当状态为 BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB 或者 BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB 时，使用辅助函数 bpf_sock_hash_update1 将 socket 作为 value 保存到 socket map 中，key 由本地地址 + 端口和远端地址 + 端口组成。

## 消息直通：sk_msg

附加到 socket map 的程序：在每次发送消息时触发该程序，使用当前 socket 的远端地址 + 端口和本地地址 + 端口作为 key 从 map 中定位对端的 socket。如果定位成功，说明客户端和服务端位于同一节点上，使用辅助函数 bpf_msg_redirect_hash2 将数据直接写入到对端 socket。

这里没有直接使用 bpf_msg_redirect_hash，而是通过自定义的 msg_redirect_hash 来访问。因为前者无法直接访问，否则校验会不通过。

与 sockops 一样，消息的重定向也是指针对目标地址和端口或者本地地址和端口是 127.0.0.1、10000 的消息。


## tcpdump监控

使用 tcpdump 抓包看一下。从抓包的结果来看，只有握手和挥手的流量，后续消息的发送完全跳过了内核网络栈。

通过 eBPF 的引入，我们缩短了同节点通信数据包的 datapath，跳过了内核网络栈直接连接两个对端的 socket。

这种设计适用于同 pod 两个应用的通信以及同节点上两个 pod 的通信。


sock_hash_update(skops, &sock_ops_map, &key, BPF_NOEXIST)
bpf_msg_redirect_hash将数据直接写入到对端 socket