# section及其功能
kprobe::inet(6)_bind
kprobe::do_sendfile
kprobe::tcp_sendmsg
kprobe::tcp_retransmit_skb
kprobe::tcp_cleanup_rbuf


Attach kprobe to "inet_listen": 当在 AF_INET 和 SOCK_STREAM 类型的 socket 上调用系统调用 listen() 时，底层负责处理的内核函数就是 inet_listen()。
BPF_CGROUP_INET_SOCK_CREATE

BPF_CGROUP_INET4_BIND

BPF_CGROUP_INET4_CONNECT

BPF_CGROUP_UDP4_SENDMSG

BPF_CGROUP_UDP4_RECVMSG

BPF_CGROUP_GETSOCKOPT

BPF_CGROUP_INET4_GETPEERNAME

BPF_CGROUP_INET_SOCK_RELEASE

# 辅助函数及其功能 bpf-helpers
内核代码位置： `/kernel/bpf/helpers.c`

1. bpf_msg_redirect_hash()
2. bpf_trace_printk(): 从内核管道读取原始格式的输出，bpf_trace_printk() 可以将 tracing 信息打印到 /sys/kernel/debug/tracing/trace_pipe 下面的一个特殊管道。
3. void *bpf_map_lookup_elem(struct bpf_map *map, const void *key)
4. long bpf_map_update_elem(struct bpf_map *map, const void *key, const void *value, u64 flags)
5. long bpf_map_delete_elem(struct bpf_map *map, const void *key)
6. long bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
7. u64 bpf_ktime_get_ns(void)： clock_gettime(CLOCK_MONOTONIC)
8. long bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
9. u32 bpf_get_prandom_u32(void)
10. u32 bpf_get_smp_processor_id(void)
11. long bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *from, u32 len, u64 flags)
12. long bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u64 to, u64 size)
13. long bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u64 to, u64 flags)
14. long bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 index)
15. long bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
16. u64 bpf_get_current_pid_tgid(void)
17. u64 bpf_get_current_uid_gid(void)
18. long bpf_get_current_comm(void *buf, u32 size_of_buf)
19. u32 bpf_get_cgroup_classid(struct sk_buff *skb)
20. long bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci)
21. long bpf_skb_vlan_pop(struct sk_buff *skb)
22. long bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key *key, u32 size, u64 flags)
23. long bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key *key, u32 size, u64 flags)
24. u64 bpf_perf_event_read(struct bpf_map *map, u64 flags)
25. long bpf_redirect(u32 ifindex, u64 flags)
26. u32 bpf_get_route_realm(struct sk_buff *skb)


# 内核相关结构
- struct sock
  - netns = sk->__sk_common.skc_net.net->ns.inum; 是socket的namespace id，对应/proc/PID/ns/net里面的数值
- struct inet_sock: inet_sk(sock) 转成inet_sock, 包含inet_rcv_saddr(source address),inet_sport (source port)
- int backlog: 是 TCP socket 允许建立的最大连接的数量(等待被 accept())

# ebpf 程序类型
每一种 prog type 会定义一个 `struct bpf_verifier_ops` 结构体。当 prog load 到内核时，内核会根据它的 type，调用相应结构体的 get_func_proto 函数。

1. BPF_PROG_TYPE_SOCKET_FILTER：一种网络数据包过滤器, 是第一个被添加到内核的程序类型。当你 attach 一个 bpf 程序到 socket 上，你可以获取到被 socket 处理的所有数据包。socket 过滤不允许你修改这些数据包以及这些数据包的目的地。仅仅是提供给你观察这些数据包。在你的程序中可以获取到诸如 protocol type 类型等。以 tcp 为 example，调用的地点是 tcp_v4_rcv->tcp_filter->sk_filter_trim_cap 作用是过滤报文，或者 trim 报文。udp, icmp 中也有相关的调用。
2. BPF_PROG_TYPE_KPROBE：确定 kprobe 是否应该触发，类似 ftrace 的 kprobe，在函数出入口的 hook 点，debug 用的。
3. BPF_PROG_TYPE_SCHED_CLS：一种网络流量控制分类器
   1. egress 方向上，tcp/ip 协议栈运行之后，有一个 hook 点。这个 hook 点可以 attach BPF_PROG_TYPE_SCHED_CLS type 的 egress 方向的 bpf prog。在这段 bpf 代码执行之后，才会运行 qos，tcpdump, xmit 到网卡 driver 的代码。在这段 bpf 代码中你可以修改报文里面的内容，地址等。修改之后，通过 tcpdump 可以看到，因为 tcpdump 代码在此之后才执行。
```C
static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
{
   skb = sch_handle_egress(skb, &rc, dev);
   // enqueue tc qos
   // dequeue tc qos
   // dev_hard_start_xmit
   // tcpdump works here! dev_queue_xmit_nit
   // nic driver->ndo_start_xmit
}
  ```
   2. ingress 方向上，在 deliver to tcp/ip 协议栈之前，在 tcpdump 之后，有一个 hook 点。这个 hook 点可以 attach BPF_PROG_TYPE_SCHED_CLS type 的 ingress 方向的 bpf prog。在这里你也可以修改报文。但是修改之后的结果在 tcpdump 中是看不到的。
```C
static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc, struct packet_type **ppt_prev)
{
  // generic xdp bpf hook
  // tcpdump
  // tc ingress hook
  skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev, &another);
  // deliver to tcp/ip stack or bridge/ipvlan device
}
```
4. BPF_PROG_TYPE_SCHED_ACT：一种网络流量控制动作
5. BPF_PROG_TYPE_TRACEPOINT：确定 tracepoint 是否应该触发，类似 ftrace 的 tracepoint。
6. BPF_PROG_TYPE_XDP：从设备驱动程序接收路径运行的网络数据包过滤器，网卡驱动收到 packet 时，尚未生成 sk_buff 数据结构之前的一个 hook 点。BPF_PROG_TYPE_XDP 允许你的 bpf 程序，在网络数据包到达 kernel 很早的时候。在这样的 bpf 程序中，你仅仅可能获取到一点点的信息，因为 kernel 还没有足够的时间去处理。因为时间足够的早，所以你可以在网络很高的层面上去处理这些 packet。XDP 定义了很多的处理方式，例如XDP_PASS 就意味着，你会把 packet 交给内核的另一个子系统去处理；XDP_DROP 就意味着，内核应该丢弃这个数据包；XDP_TX 意味着，你可以把这个包转发到 network interface card(NIC)第一次接收到这个包的时候
7. BPF_PROG_TYPE_PERF_EVENT：确定是否应该触发 perf 事件处理程序
8. BPF_PROG_TYPE_CGROUP_SKB：一种用于控制组的网络数据包过滤器，BPF_PROG_TYPE_CGROUP_SKB 允许你过滤整个 cgroup 的网络流量。在这种程序类型中，你可以在网络流量到达这个 cgoup 中的程序前做一些控制。内核试图传递给同一 cgroup 中任何进程的任何数据包都将通过这些过滤器之一。同时，您可以决定 cgroup 中的进程通过该接口发送网络数据包时该怎么做。其实，你可以发现它和 BPF_PROG_TYPE_SOCKET_FILTER 的类型很类似。最大的不同是 cgroup_skb 是 attach 到这个 cgroup 中的所有进程，而不是特殊的进程。在 container 的环境中，bpf 是非常有用的。ingress 方向上，tcp 收到报文时（tcp_v4_rcv），会调用这个 bpf 做过滤。egress 方向上，ip 在出报文时（ip_finish_output）会调用它做丢包过滤 输入参数是 skb。
9. BPF_PROG_TYPE_CGROUP_SOCK_ADDR: 它对应很多 attach type，一般在 `bind`, `connect` 时调用, 传入 sock 的地址。主要作用：例如 cilium 中 `clusterip` 的实现，在主动 `connect` 时，修改了目的 ip 地址，就是利用这个。`BPF_PROG_TYPE_CGROUP_SOCK_ADDR`，这种类型的程序使您可以在由特定 cgroup 控制的用户空间程序中操纵 IP 地址和端口号。在某些情况下，当您要确保一组特定的用户空间程序使用相同的 IP 地址和端口时，系统将使用多个 IP 地址.当您将这些用户空间程序放在同一 cgroup 中时，这些 BPF 程序使您可以灵活地操作这些绑定。这样可以确保这些应用程序的所有传入和传出连接均使用 BPF 程序提供的 IP 和端口。
10. BPF_PROG_TYPE_CGROUP_SOCK：一种由于控制组的网络包筛选器，它被允许修改套接字选项。在 sock create, release, post_bind 时调用的。主要用来做一些权限检查的。BPF_PROG_TYPE_CGROUP_SOCK，这种类型的 bpf 程序允许你，在一个 cgroup 中的任何进程打开一个 socket 的时候，去执行你的 Bpf 程序。这个行为和 CGROUP_SKB 的行为类似，但是它是提供给你 cgoup 中的进程打开一个新的 socket 的时候的情况，而不是给你网络数据包通过的权限控制。这对于为可以打开套接字的程序组提供安全性和访问控制很有用，而不必分别限制每个进程的功能。
11. BPF_PROG_TYPE_CGROUP_SOCKOPT：调用点：getsockopt, setsockopt
12. BPF_PROG_TYPE_LWT_*：用于轻量级隧道的网络数据包过滤器
13. BPF_PROG_TYPE_SOCK_OPS：一个用于设置套接字参数的程序,主要作用：tcp 调优，event 统计等。在 tcp 协议 event 发生时调用的 bpf 钩子，定义了 15 种 event。这些 event 的 attach type 都是 `BPF_CGROUP_SOCK_OPS`。不同的调用点会传入不同的 enum, 比如：`BPF_SOCK_OPS_TCP_CONNECT_CB` 是主动 tcp connect call 的；`BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB` 是被动 connect 成功时调用的。`BPF_PROG_TYPE_SOCK_OPS` 这种程序类型，允许你当数据包在内核网络协议栈的各个阶段传输的时候，去修改套接字的链接选项。他们 attach 到 cgroups 上，和 `BPF_PROG_TYPE_CGROUP_SOCK` 以及 `BPF_PROG_TYPE_CGROUP_SKB` 很像，但是不同的是，他们可以在整个连接的生命周期内被调用好多次。你的 bpf 程序会接受到一个 op 的参数，该参数代表内核将通过套接字链接执行的操作。因此，你知道在链接的生命周期内何时调用该程序。另一方面，你可以获取 ip 地址，端口等。你还可以修改链接的链接的选项以设置超时并更改数据包的往返延迟时间。举个例子，Facebook 使用它来为同一数据中心内的连接设置短恢复时间目标（RTO）。RTO 是一种时间，它指的是网络在出现故障后的恢复时间，这个指标也表示网络在受到不可接受到情况下的，不能被使用的时间。Facebook 认为，在同一数据中心中，应该有一个很短的 RTO,Facebook 修改了这个时间，使用 bpf 程序。
14. BPF_PROG_TYPE_SK_SKB：一个用于套接字之间转发数据包的网络包过滤器，调用点：tcp sendmsg 时会调用。主要作用：做 sock redir 用的。BPF_PROG_TYPE_SK_SKB，这类程序可以让你获取 socket maps 和 socket redirects。socket maps 可以让你获得一些 socket 的引用。当你有了这些引用，你可以使用相关的 helpers，去重定向一个 incoming 的 packet ，从一个 socket 去另外一个 scoket.这在使用 BPF 来做负载均衡时是非常有用的。你可以在 socket 之间转发网络数据包，而不需要离开内核空间。Cillium 和 facebook 的 Katran 广泛的使用这种类型的程序去做流量控制。
15. BPF_PROG_TYPE_SK_MSG: These types of programs let you control whether a message sent to a socket should be delivered.当内核创建了一个 socket，它会被存储在前面提到的 map 中。当你 attach 一个程序到这个 socket map 的时候，所有的被发送到那些 socket 的 message 都会被 filter。在 filter message 之前，内核拷贝了这些 data，因此你可以读取这些 message，而且可以给出你的决定：例如，SK_PASS 和 SK_DROP。
16. BPF_PROG_CGROUP_DEVICE：确定是否允许设备操作

# ebpf命令
Linux系统的BPF系统调用有10个命令： 
1. BPF_PROG_LOAD 验证并且加载eBPF程序，返回一个新的文件描述符。
2. BPF_MAP_CREATE 创建map并且返回指向map的文件描述符
3. BPF_MAP_LOOKUP_ELEM 通过key从指定的map中查找元素，并且返回value值
4. BPF_MAP_UPDATE_ELEM 在指定的map中创建或者更新元素(key/value 配对)
5. BPF_MAP_DELETE_ELEM 通过key从指定的map中找到元素并且删除
6. BPF_MAP_GET_NEXT_KEY 通过key从指定的map中找到元素，并且返回下个key值
7. BPF_OBJ_PIN 4.4版本新加的，属于持久性eBPF。有了这个，eBPF-maps和eBPF程序可以放入/sys/fs/bpf
8. BPF_OBJ_GET同上，在这之前，没有工具能创建eBPF程序，并且结束，因为会破坏filter，而文件系统可以在创建他们的程序退出后依然保留eBPF-maps和eBPF程序
9. BPF_PROG_ATTACH 4.10版本中添加的，将eBPF程序attach到cgroup，这样适用于container
10. BPF_PROG_DETACH 同上。

# eBPF-map 类型
1. BPF_MAP_TYPE_UNSPEC
2. BPF_MAP_TYPE_HASH eBPF-maps hash表，是主要用的前两种方式之一
3. BPF_MAP_TYPE_ARRAY 和上面类似，除了索引像数组一样
4. BPF_MAP_TYPE_PROG_ARRAY将加载的eBPF程序的文件描述符保存其值，常用的是使用数字识别不同的eBPF程序类型，也可以从一个给定key值的eBPF-maps找到eBPF程序，并且跳转到程序中去
5. BPF_MAP_TYPE_PERF_EVENT_ARRAY配合perf工具，CPU性能计数器，tracepoints，kprobes和uprobes。可以查看路径samples/bpf/下的tracex6_kern.c，tracex6_user.c，tracex6_kern.c，tracex6_user.c
6. BPF_MAP_TYPE_PERCPU_HASH 和BPF_MAP_TYPE_HASH一样，除了是为每个CPU创建
7. BPF_MAP_TYPE_PERCPU_ARRAY 和BPF_MAP_TYPE_ARRAY一样，除了是为每个CPU创建
8. BPF_MAP_TYPE_STACK_TRACE 用于存储stack-traces
9. BPF_MAP_TYPE_CGROUP_ARRAY 检查skb的croup归属
10. BPF_MAP_TYPE_LRU_HASH
11. BPF_MAP_TYPE_LRU_PERCPU_HASH
12. BPF_MAP_TYPE_LPM_TRIE 最专业的用法，LPM(Longest Prefix Match)的一种trie
13. BPF_MAP_TYPE_ARRAY_OF_MAPS 可能是针对每个port的
14. BPF_MAP_TYPE_HASH_OF_MAPS 可能是针对每个port的
15. BPF_MAP_TYPE_DEVMAP 可能是定向报文到dev的
16. BPF_MAP_TYPE_SOCKMAP 可能是连接socket的