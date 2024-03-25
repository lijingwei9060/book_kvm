# intro
bpf_alignchecker.c C与Go的消息结构体格式校验
bpf_host.c 物理层的网卡tc ingress\egress相关过滤器
bpf_lxc.c 容器上的网络环境、网络流量管控等
bpf_network.c 网络控制相关
bpf_overlay.c 叠加网络控制代码
bpf_sock.c sock控制相关，包含流量大小控制、TCP状态变化控制
bpf_xdp.c XDP层控制相关
sockops 目录下有多个文件，用于sockops相关控制，流量重定向等性能优化。
cilium-probe-kernel-hz.c probe测试的，忽略


## 模块

1. 虚拟接口(cilium_host、cilium_net)
2. 可选接口(cilium_vxlan)
3. linux内核加密支持
4. 用户空间代理(Envoy)
5. eBPF Hooks

1. XDP层实现的网络流量过滤过滤器规则。比如，由Cilium agent提供的一组CIDR映射用于查找定位、处理丢弃等
2. tc ingress/egress: 运行在网络栈之后可以读取L3信息，可以做l3和l4的流量重定向。TC栈上的HOOK，用于L3/L4层的网络负载均衡功能（bpf_redir.c）。L3 加密器：L3层处理IPsec头的流量加密解密等。
3. socket operations： attach到cgroup上，监控tcp。Socket Layer Enforcement： socket层的两个钩子，即sockops hook和socket send/recv hook(bpf_sockops.c)。用来监视管理Cilium endpoint关联的所有TCP套接字，包括任何L7代理。L7 策略：L7策略对象将代理流量重定向到Cilium用户空间代理实例。使用Envoy实例作为其用户空间代理。然后，根据配置的L7策略转发流量。
4. endpoint策略： Cilium endpoint来继承实现。使用映射查找与身份和策略相关的数据包，该层可以很好地扩展到许多端点。根据策略，该层可能会丢弃数据包、转发到本地端点、转发到服务对象或转发到 L7 策略对象以获取进一步的L7规则。这是Cilium数据路径中的主要对象，负责将数据包映射到身份并执行L3和L4策略。

## conntrack管理

cilium bpf ct list global | grep ICMP |head -n4
cilium bpf nat list | grep ICMP |head -n4
## daemon(管理ebpf)

map列表：
1. lxcmap： 
2. ip cache map：
3. metrics map
4. tunnel map
5. SRv6 map
6. world cidrs map：
7. vtep map
8. svc map
9. policy map：
10. endpoint map
11. ipv4 nat map
12. ipv6 nat map
13. neighbors map
14. frag map
15. ip masq4/6 map
16. session affinity map
17. svc source range map


## bpf 编译
调用外部的shell



## health
1. node之间相互探测(full mesh), health checking 和 endpoint health checking
2. 探测方式： ping nodeIP/HealthIP和get http://<NodeIP|HealthIP>:4240/hello
3. 结果： status、RTT

cilium-health endpoint： 特殊的endpoint，不归属pod，每台节点一个


## 下发ebpf程序
Cilium 针对每一个 pod 创建对应的 CiliumEndpoint 对象，在这一步会下发 tc eBPF 程序到 pod 网卡上。

1. BPF 程序会被下发到宿主机 /var/run/cilium/state 目录中，regenerateBPF() 函数会重写 bpf headers，以及更新 BPF Map。更新 BPF Map 很重要，下发到网卡中的 BPF 程序执行逻辑时会去查 BPF Map 数据。
2. 编译和加载 BPF 程序
```shell
# 编译 BPF C 程序
clang -O2 -emit-llvm -c bpf.c -o - | llc -march=bpf -filetype=obj -o bpf.o
# 下发 BPF 程序到容器网卡
tc filter add dev lxc09e1d2e egress bpf da obj bpf.o sec tc
```


## 数据流

假设容器中 ping clusterip-service-ip，出发走到另外一台机器的pod容器，会经过 from-container -> from-host -> to-netdev -> from-netdev -> to-host BPF 程序。

1. cil_from_container： 来自容器的网络数据包，并根据数据包的协议类型执行相应的处理逻辑。IPv4、IPv6，ARP数据包。
   1. IPv4 -> tail_handle_ipv4
      1. ipv4 fragment
      2. src
      3. igmp
      4. multicast
      5. lb service
      6. 

handle_ipv4_from_lxc： 从容器到宿主机的packet

```C
__tail_handle_ipv4
1. revalidate data pull
2. ipv4 is fragment
3. valid src ipv4
4. ipv4 is igmp => mcast_ipv4_handle_igmp
5. ip4->daddr is multicast -tail-> CILIUM_CALL_MULTICAST_EP_DELIVERY
6. per packet lb => __per_packet_lb_svc_xlate_4 // 每个包都是lb？
   svc = lb4_lookup_service(&key, is_defined(ENABLE_NODEPORT), false);
   L7LB -> CILIUM_CALL_IPV4_CT_EGRESS = tail_ipv4_ct_egress
   L4LB
7. tail_ipv4_ct_egress

ct_state = (struct ct_state *)&ct_buffer.ct_state;
tuple = (struct ipv4_ct_tuple *)&ct_buffer.tuple;
tuple->nexthdr = ip4->protocol;
tuple->daddr = ip4->daddr;
tuple->saddr = ip4->saddr;
ct_buffer.l4_off = ETH_HLEN + ipv4_hdrlen(ip4);	


select_ct_map4(ctx, CT_EGRESS, tuple)
ct_buffer.ret = ct_lookup4(map, tuple, ctx, ip4, ct_buffer.l4_off,	CT_EGRESS, ct_state, &ct_buffer.monitor)
map_update_elem(&CT_TAIL_CALL_BUFFER4, &zero, &ct_buffer, 0)
-tail-> tail_handle_ipv4_cont
   => handle_ipv4_from_lxc(ctx, &dst_sec_identity, &ext_err)
      dst_endpoint = lookup_ip4_remote_endpoint(ip4->daddr, cluster_id) // 查找目标网卡，外部网卡为world
      ct_buffer = map_lookup_elem(&CT_TAIL_CALL_BUFFER4, &zero) // 申请ct buffer
      ct_status == CT_REPLY || ct_status == CT_RELATED => // Skip policy enforcement for return traffic.
         // return traffic to an ingress proxy,Stack will do a socket match and deliver locally
      // hairpin_flow: an endpoint connects to itself via service clusterIP, 跳过策略检查
      // 正在建立连接、去往集群内部需要策略检查，去host或者外部需要cidr检查
      verdict = policy_can_egress4(ctx, &POLICY_MAP, tuple, l4_off, SECLABEL_IPV4, *dst_sec_identity, &policy_match_type, &audited, ext_err, &proxy_port);
      // Emit verdict if drop or if allow for CT_NEW or CT_REOPENED.
      CT_NEW =>  ct_create4(ct_map, ct_related_map, tuple, ctx, CT_EGRESS, &ct_state_new, ext_err)
      CT_REOPENED | CT_ESTABLISHED
      CT_RELATED | CT_REPLY:
         // dsr => 
         // nodeport -tail-> CILIUM_CALL_IPV4_NODEPORT_REVNAT
         // RevNAT for replies on a loopback connection: lb4_rev_nat(ctx, ETH_HLEN, l4_off, ct_state->rev_nat_index, true, tuple, has_l4_header);
      // ENABLE_SRV6
      // L7 LB does L7 policy enforcement, so we only redirect packets NOT from L7 LB. => ctx_redirect_to_proxy4
      // if the destination is the local host and per-endpoint routes are enabled, jump to the bpf_host program to enforce ingress host policies.
	   // If the packet is from L7 LB it is coming from the host
      // If the packet is destined to an entity inside the cluster, either EP or node, it should not be forwarded to an egress gateway since only traffic leaving the cluster is supposed to be masqueraded with an egress IP.
      // Send the packet to egress gateway node through a tunnel. => __encap_and_redirect_lxc(ctx, tunnel_endpoint, 0, SECLABEL_IPV4,  *dst_sec_identity, &trace);
      // L7 proxy result in VTEP redirection in bpf_host
      // to host =>  ctx_redirect(ctx, HOST_IFINDEX, BPF_F_INGRESS);
      // 主机路由（设置 TTL、MAC 地址） => ipv4_l3(ctx, ETH_HLEN, NULL, (__u8 *)&router_mac.addr, ip4) 
      // TUNNEL_MODE && ENABLE_IPSEC => set_ipsec_encrypt(ctx, encrypt_key, tunnel_endpoint, SECLABEL_IPV4, false);

      dst_ip 已经是真实 Pod IP（POD4_IP）
   => encode_custom_prog_meta(ctx, ret, dst_sec_identity)
```