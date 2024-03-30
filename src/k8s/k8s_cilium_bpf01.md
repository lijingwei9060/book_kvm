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

### ipcache map结构
cilium_ipcache map保存的是整个集群的endpoint，其中tunnelendpoint说明endpoint所在的node，如果为0说明是本node

root@master:/home/cilium# cilium map get cilium_ipcache
Key               Value                                                    State   Error
10.0.3.178/32     identity=4 encryptkey=0 tunnelendpoint=0.0.0.0           sync
10.0.3.61/32      identity=3729 encryptkey=0 tunnelendpoint=0.0.0.0        sync
10.0.1.84/32      identity=4343 encryptkey=0 tunnelendpoint=192.168.56.3   sync
192.168.56.3/32   identity=6 encryptkey=0 tunnelendpoint=0.0.0.0           sync
192.168.56.2/32   identity=1 encryptkey=0 tunnelendpoint=0.0.0.0           sync
10.0.3.17/32      identity=1 encryptkey=0 tunnelendpoint=0.0.0.0           sync
10.0.2.15/32      identity=1 encryptkey=0 tunnelendpoint=0.0.0.0           sync
10.0.3.7/32       identity=3729 encryptkey=0 tunnelendpoint=0.0.0.0        sync
10.0.3.30/32      identity=22960 encryptkey=0 tunnelendpoint=0.0.0.0       sync
10.0.1.38/32      identity=6 encryptkey=0 tunnelendpoint=192.168.56.3      sync
0.0.0.0/0         identity=2 encryptkey=0 tunnelendpoint=0.0.0.0           sync
10.0.1.36/32      identity=4 encryptkey=0 tunnelendpoint=192.168.56.3      sync

### pod lxc ingress: pod出流量
cil_from_container(ctx)
   validate_ethertype(ctx, &proto)
   IPV6 -> CILIUM_CALL_IPV6_FROM_LXC = 
   IPv4 -> CILIUM_CALL_IPV4_FROM_LXC = tail_handle_ipv4(ctx) => __tail_handle_ipv4(ctx)
   Arp passthrough => CTX_ACT_OK
   arp response -> CILIUM_CALL_ARP = tail_handle_arp(ctx)

1. cil_from_container： 来自容器的网络数据包，并根据数据包的协议类型执行相应的处理逻辑。IPv4、IPv6，ARP数据包。
   1. IPv4 -> tail_handle_ipv4
      1. ipv4 fragment
      2. src
      3. igmp
      4. multicast
      5. lb service
      6. 

handle_ipv4_from_lxc： 从容器到宿主机的packet

__tail_handle_ipv4
1. revalidate data pull
2. ipv4 is fragment: 如果没有启用fragmentation，收到的是fragmentation，就丢掉
3. valid src ipv4： 在生成bpf程序的时候已经把地址写入到程序中，验证这个地址想不想等
4. ip4->protocol == IPPROTO_IGMP => 组播， mcast_ipv4_handle_igmp(ctx, ipv4, data, data_end), 成员管理
5. ip4->daddr is multicast -> CILIUM_CALL_MULTICAST_EP_DELIVERY = tail_mcast_ep_delivery(ctx)
6. per packet lb => __per_packet_lb_svc_xlate_4(ctx, ip4) // 每个包都进行负载均衡
   svc = lb4_lookup_service(&key, is_defined(ENABLE_NODEPORT), false);
   L7LB -> CILIUM_CALL_IPV4_CT_EGRESS = tail_ipv4_ct_egress
   L4LB
7. tail_ipv4_ct_egress = TAIL_CT_LOOKUP4(CILIUM_CALL_IPV4_CT_EGRESS, tail_ipv4_ct_egress, CT_EGRESS,	is_defined(ENABLE_PER_PACKET_LB),CILIUM_CALL_IPV4_FROM_LXC_CONT, tail_handle_ipv4_cont)

ct_state = (struct ct_state *)&ct_buffer.ct_state;
tuple = (struct ipv4_ct_tuple *)&ct_buffer.tuple;
tuple->nexthdr = ip4->protocol;
tuple->daddr = ip4->daddr;
tuple->saddr = ip4->saddr;
ct_buffer.l4_off = ETH_HLEN + ipv4_hdrlen(ip4);	

select_ct_map4(ctx, CT_EGRESS, tuple) : 连接状态跟踪，五元组（源IP、源端口、目的IP、目的端口、协议类型）、连接创建时间、到期时间、连接状态（新建、已建立、关闭等）和其他可能的标记信息。
ct_buffer.ret = ct_lookup4(map, tuple, ctx, ip4, ct_buffer.l4_off,	CT_EGRESS, ct_state, &ct_buffer.monitor)
map_update_elem(&CT_TAIL_CALL_BUFFER4, &zero, &ct_buffer, 0)
-> tail_handle_ipv4_cont
   => handle_ipv4_from_lxc(ctx, &dst_sec_identity, &ext_err)
      union macaddr router_mac = NODE_MAC // 网关的mac地址也是写死的
      dst_endpoint = lookup_ip4_remote_endpoint(ip4->daddr, cluster_id) // 根据目标IP从IPCACHE Map查找目标网卡，外部网卡为world
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
      
      lookup_ip4_endpoint(ip4) // 根据目标IP从ENDPOINTS_MAP找endpoint，返回的可以是本地ep、host ep
      
      // SECLABEL 为发送vxlan报文时填写的 vni，其值为本端endpoint的identify，在编译时就确定好了，
		// 注意vni用的不是目的endpoint的identify
      // (a) the encap and redirect could not find the tunnel so fallthrough to nat46 and stack
      // (b) the packet needs IPSec encap so push ctx to stack for encap
		// (c) packet was redirected to tunnel device so return.
      ipv4_local_delivery(ctx, ETH_HLEN, SECLABEL_IPV4, MARK_MAGIC_IDENTITY, ip4, ep, METRIC_EGRESS, from_l7lb, bypass_ingress_policy, false, 0)
      encap_and_redirect_lxc(ctx, tunnel_endpoint, 0, 0, encrypt_key, &key, SECLABEL_IPV6, *dst_sec_identity, &trace)
         ENABLE_HIGH_SCALE_IPCACHE && needs_encapsulation(dst_ip)
         tunnel_endpoint
         ENABLE_IPSEC
         other => encap_and_redirect_with_nodeid(ctx, tunnel->ip4, 0, seclabel, dstid, trace)
      __encap_and_redirect_lxc(ctx, tunnel_endpoint, 0,SECLABEL_IPV4,*dst_sec_identity, &trace) // Send the packet to egress gateway node through a tunnel
   => encode_custom_prog_meta(ctx, ret, dst_sec_identity)

本地路由、主机路由、hairpin：


redirect_ep将报文重定向到lxc接口或者lxc的peer接口，这主要取决于ENABLE_HOST_ROUTING是否被定义。如果ENABLE_HOST_ROUTING被定义了说明是host routing模式，可将报文直接重定向到lxc的peer接口，即pod内部的eth0。
redirect_ep():
needs_backlog || !is_defined(ENABLE_HOST_ROUTING) => ctx_redirect(ctx, ifindex, 0)
from_tunnel => ctx_change_type(ctx, PACKET_HOST) // coming from overlay, we need to set packet type to HOST as otherwise we might get dropped in IP layer.
ctx_redirect_peer(ctx, ifindex, 0)

### host nic vxlan egress

容器的出口流量对 cilium_vxlan 来说也是 egress，因此这里的程序是 to-overlay。程序位于 bpf_overlay.c 中，这个程序的处理很简单，如果是 IPv6 协议会将封包使用 IPv6 的地址封装一次。这里是 IPv4 ，直接返回 CTX_ACT_OK。将网络包交给内核网络栈，进入 eth0 接口。

```shell
[root@host]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool net show dev cilium_vxlan
xdp:

tc:
cilium_vxlan(5) clsact/ingress bpf_overlay.o:[from-overlay] id 2699
cilium_vxlan(5) clsact/egress bpf_overlay.o:[to-overlay] id 2707

flow_dissector:
```
cil_to_overlay(ctx):
1. 带宽管理
2. nodeport： 
   1. 源地址转换检查：ctx_snat_done(ctx)
   2. 集群地址管理 handle_nat_fwd(ctx, cluster_id, &trace, &ext_err)
   3. 其他通过

### host nic egress

egress 程序 to-netdev 位于 bpf_host.c。实际上没做重要的处理，只是返回 CTX_ACT_OK 交给内核网络栈继续处理：将网络包发送到 vxlan 隧道发送到对端，也就是节点 192.168.1.13 。中间数据的传输，实际上用的还是 underlaying 网络，从主机的 eth0 接口经过 underlaying 网络到达目标主机的 eth0 接口。

```shell
[root@host]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool net show dev eth0
xdp:

tc:
eth0(2) clsact/ingress bpf_netdev_eth0.o:[from-netdev] id 2823
eth0(2) clsact/egress bpf_netdev_eth0.o:[to-netdev] id 2832

flow_dissector:
```

### host nic ingress
vxlan 网络包到达节点的 eth0 接口，也会触发 BPF 程序。
```shell
kubectl exec -n kube-system $cilium2 -c cilium-agent -- bpftool net show dev eth0
xdp:

tc:
eth0(2) clsact/ingress bpf_netdev_eth0.o:[from-netdev] id 4556
eth0(2) clsact/egress bpf_netdev_eth0.o:[to-netdev] id 4565

flow_dissector:
```
这次触发的是 from-netdev，位于 bpf_host.c 中。
```c
from_netdev
  if vlan
    allow_vlan
    return CTX_ACT_OK
```
对 vxlan tunnel 模式来说，这里的逻辑很简单。当判断网络包是 vxlan 的并确认允许 vlan 后，直接返回 CTX_ACT_OK 将处理交给内核网络栈。

### host vxlan ingress

网络包通过内核网络栈来到了接口 cilium_vxlan。
```shell
kubectl exec -n kube-system $cilium2 -c cilium-agent -- bpftool net show dev cilium_vxlan
xdp:

tc:
cilium_vxlan(5) clsact/ingress bpf_overlay.o:[from-overlay] id 4468
cilium_vxlan(5) clsact/egress bpf_overlay.o:[to-overlay] id 4476

flow_dissector:
```
程序位于 bpf_overlay.c 中。
```c
cil_from_overlay
   validate_ethertype
   ctx_get_tunnel_key(ctx, &key, sizeof(key), 0) //调用bpf helper函数 ctx_get_tunnel_key 获取vxlan信息，保存到key中
   ctx_set_tunnel_key(ctx, &key, sizeof(key), BPF_F_ZERO_CSUM_TX)
   ctx_set_tunnel_opt(ctx, &dsr_opt, sizeof(dsr_opt))
   -> CILIUM_CALL_IPV4_FROM_OVERLAY = tail_handle_ipv4
      handle_ipv4()
         fragment处理
         多播处理 -> CILIUM_CALL_MULTICAST_EP_DELIVERY
         ENABLE_NODEPORT => nodeport_lb4(ctx, ip4, ETH_HLEN, *identity, ext_err, &is_dsr);
         lookup_ip4_remote_endpoint(ip4->saddr, 0) // 查询原始ep，准备解密
         vtep：
         cluster ip进行snat -> CILIUM_CALL_IPV4_INTER_CLUSTER_REVSNAT
         IPSec: node_id = lookup_ip4_node_id(ip4->saddr), 发往协议栈
         ENABLE_EGRESS_GATEWAY_COMMON(网关模式)：ret = ipv4_l3(ctx, ETH_HLEN, NULL, NULL, ip4); 修改ttl等
         Deliver to local (non-host) endpoint:ipv4_local_delivery(ctx, ETH_HLEN, *identity, MARK_MAGIC_IDENTITY, ip4, ep, METRIC_INGRESS, false, false, true, 0);
         to be going to the local host： ipv4_host_delivery(ctx, ip4);
        lookup_ip4_endpoint 1#
          map_lookup_elem
        ipv4_local_delivery 2#
          tail_call_dynamic 3#
```
(1)：lookup_ip4_endpoint 会在 eBPF map cilium_lxc 中检查目标地址是否在当前节点中（这个 map 只保存了当前节点中的 endpoint）。
```shell
kubectl exec -n kube-system $cilium2 -c cilium-agent -- cilium map get cilium_lxc | grep 10.42.0.51
10.42.0.51:0    id=2826  flags=0x0000 ifindex=29  mac=96:86:44:A6:37:EC nodemac=D2:AD:65:4D:D0:7B   sync
```
这里查到目标 endpoint 的信息：id、以太网口索引、mac 地址。在 NODE2 的节点上，查看接口信息发现，这个网口是虚拟以太网设备 lxc65015af813d1，正好是 pod httpbin 接口 eth0 的对端。
```shell
ip link | grep -B1 -i d2:ad
29: lxc65015af813d1@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether d2:ad:65:4d:d0:7b brd ff:ff:ff:ff:ff:ff link-netns cni-395674eb-172b-2234-a9ad-1db78b2a5beb

kubectl exec -n default httpbin -- ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
28: eth0@if29: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 96:86:44:a6:37:ec brd ff:ff:ff:ff:ff:ff link-netnsid
```
(2)：ipv4_local_delivery 的逻辑位于 l3.h 中，这里会 tail-call 通过 endpoint 的 LXC ID（29）定位的 BPF 程序。

### pod lxc egress： pod入流量
执行下面的命令并不会找到想想中的 egress to-container（与 from-container）。
```shell
kubectl exec -n kube-system $cilium2 -c cilium-agent -- bpftool net show | grep 29
lxc65015af813d1(29) clsact/ingress bpf_lxc.o:[from-container] id 4670
```
前面用的 BPF 程序都是附加到接口上的，而这里是直接有 vxlan 附加的程序直接 tail call 的。to-container 可以在 bpf-lxc.c 中找到。
```c
handle_to_container
  tail_ipv4_to_endpoint
    ipv4_policy #1
      policy_can_access_ingress
    redirect_ep
      ctx_redirect
```
(1)：ipv4_policy 会执行配置的策略
(2)：如果策略通过，会调用 redirect_ep 将网络包发送到虚拟以太接口 lxc65015af813d1，进入到 veth 后会直达与其相连的容器 eth0 接口。

### xdp

xdp是物理网卡上的流量：
1. 通过nodeport访问ep，或者ep的返回
2. 不是nodeport就放行，放行到到tc ingress

```C
cil_xdp_entry()
=> check_filters(ctx)
   ctx_store_meta
   ctx_skip_nodeport_clear
   check_v4(ctx)
      -> CILIUM_CALL_IPV4_FROM_NETDEV = tail_lb_ipv4(ctx)
         DSR:
         nodeport_lb4(ctx, ip4, l3_off, 0, err, is_dsr) // 1. 后端是本地ep、远端ep/2. 从其他ep返回
            is_fragment
            cilium_capture_in(ctx)
            has_l4_header
            ipv4/l3_off/l4_off/tuple
            未知L4类型放行
            lb4_fill_key(&key, &tuple)
            lb4_lookup_service(&key, false, false) //通过key查找对应的svc
            svc =>
               1. 校验lb4 src range
               2. svc 是l7lb，在xdp里面处理不了直接放行，需要bpf_host处理(tc ingress); 不是xdp就是hairpin，自己访问自己的svc
               3. lb4访问lb6： lb4_to_lb6_service(svc), lb4_to_lb6(ctx, ip4, l3_off) => nat_46x64_recirc
               4. lb4_local: 如果没有后端svc -> CILIUM_CALL_IPV4_NO_SERVICE = tail_no_service_ipv4
               5. svc 不可路由： DROP_IS_CLUSTER_IP
            no svc => 
               NAT_46X64_RECIRC -> CILIUM_CALL_IPV6_FROM_NETDEV = tail_lb_ipv6
               XFER_PKT_NO_SVC： 
               DSR：  => nodeport_dsr_ingress_ipv4()
               BPF-Masquerading off => 放行
               NAT64: lb4 to lb6 -> CILIUM_CALL_IPV6_NODEPORT_NAT_INGRESS
               other: -> CILIUM_CALL_IPV4_NODEPORT_NAT_INGRESS


   check_v6(ctx)
   bpf_xdp_exit(ctx, ret) // 直接返回，啥也不干

```