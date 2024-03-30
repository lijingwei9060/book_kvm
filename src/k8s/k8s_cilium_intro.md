# intro

1. 支持l3/l4/l7的安全策略
2. 支持三层平面网络： overlay、vxlan、geneve
3. 基于bpf的负载均衡

要求： 
1. 内核4.9.17，官方建议5.3
2. 网卡tx

功能：
1. node-cidr
2. cluster-cidr
3. cni

相关组件：

关联组件：
1. hubble：云原生工作负载的分布式网络和安全可观察性平台
2. cillium-agent

## 概念
1. endpoint：相当于一个pod以及对应的ip，crd： ciliumendpoint
2. identity： 每个endpoint都有一个标签表示，crd：ciliumidentities，bpf会用到


## features
1. datapath mode： tunnel，基于vxlan，overlay网络结构
2. kubeproxy replacement：
3. ipv6 big ip： linux kernel > 5.19
4. bandwidth manager: linux kernel > 5.1
5. host routing: linux kernel > 5.10, 否则legacy iptables
6. masquerading： ebpf or iptables
7. hubble relay： 
8. native routing： 本地路由，在tunnel：disabled模式下启用

## 安装

1. bpffs：/sys/fs/bpf
2. 替换kubeProxy，以实现clusterIP、NodePort、ExternalIPs、LoadBalance。如果内核不支持Host-reachable Service，则通过kube-proxy的iptables规则完成节点的clusterIP转换。


## 网络模型

节点之间通信：
1. VXLAN或Geneve形成网状隧道，对现网要求低
2. native-Routing: pod的地址交给节点，就是节点和pod共享2层网络。
3. masquerading伪装，也就是nat，通过ebpf进行伪装IP
4. host-routing： 内核大于5.10
   1. Kernel >= 5.10
   2. Direct-routing configuration or tunneling
   3. eBPF-based kube-proxy replacement
   4. eBPF-based masquerading


网络模型：
1. cilium_net@cilium_host： 一对 veth-pair, 一端插在主机上，一端插在容器里
2. cilium_host@cilium_net: 在容器空间，充当网关，当时网关的mac地址由lxcxxxx来充当
3. cilium_vxlan： 主要是对数据包进行vxlan封装和解封装操作， cilium bpf tunnel list # 查看各个节点的vxlan tunnel
4. cilium_health 
5. lxc_health@if24:
6. eth0@if43： pod内部的网卡，是一个veth pair，和下面的网卡是一对。
7. lxc48c4aa0637ce@if42: 在host的网卡，是一个veth pair。 pod内的流量会经过这个网卡流动。
   1. pod的出流量是lxc网卡的ingress：lxc48c4aa0637ce(43) clsact/ingress bpf_lxc.o:[from-container] id 2901


1. pod lxc bpf ingress: pod中veth的BPF程序（BPF 程序 bpf_lxc.o 的 from-container，handle_xgress）
2. Node vxlan BPF Egress,容器的出口流量对 cilium_vxlan 来说也是 engress，因此这里的程序是 to-overlay
3. Node nic bpf egress: egress 程序 to-netdev 位于 bpf_host.c。实际上没做重要的处理，只是返回 CTX_ACT_OK 交给内核网络栈继续处理：将网络包发送到 vxlan 隧道发送到对端，也就是节点 192.168.1.13 。中间数据的传输，实际上用的还是 underlaying 网络，从主机的 eth0 接口经过 underlaying 网络到达目标主机的 eth0 接口。
4. node nic bpf ingress: vxlan 网络包到达节点的 eth0 接口，也会触发 BPF 程序from-netdev，位于 bpf_host.c 中。当判断网络包是 vxlan 的并确认允许 vlan 后，直接返回 CTX_ACT_OK 将处理交给内核网络栈。
5. node vxlan bpf ingress: 网络包通过内核网络栈来到了接口 cilium_vxlan。程序位于 from-overlay bpf_overlay.c 中。
6. piod lxc bpf egress: egress to-container（与 from-container）。

## 网络流量

pod中的网络：
1. eth0@if43: pod内部的网卡
2. 默认路由
3. 网关mac地址，网关mac地址指向if43，也就是lxc113dd6a50a7a的mac地址。意味着每个pod的网关mac地址都不一样？
```shell
[root@host]kubectl exec curl -n default -- arp -n
? (10.42.1.247) at ae:36:76:3e:c3:03 [ether]  on eth0
[root@host]kubectl exec curl -n default -- ip link show eth0
42: eth0@if43: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether f6:00:50:f9:92:a1 brd ff:ff:ff:ff:ff:ff
[root@host]ip link | grep -A1 ^43
43: lxc48c4aa0637ce@if42: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ae:36:76:3e:c3:03 brd ff:ff:ff:ff:ff:ff link-netns cni-407cd7d8-7c02-cfa7-bf93-22946f923ffd
[root@host]ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether fa:cb:49:4a:28:21 brd ff:ff:ff:ff:ff:ff
3: cilium_net@cilium_host: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 36:d5:5a:2a:ce:80 brd ff:ff:ff:ff:ff:ff
4: cilium_host@cilium_net: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 12:82:fb:78:16:6a brd ff:ff:ff:ff:ff:ff
5: cilium_vxlan: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fa:42:4d:22:b7:d0 brd ff:ff:ff:ff:ff:ff
25: lxc_health@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 3e:4f:b3:56:67:2b brd ff:ff:ff:ff:ff:ff link-netnsid 0
33: lxc113dd6a50a7a@if32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 32:3a:5b:15:44:ff brd ff:ff:ff:ff:ff:ff link-netns cni-07cffbd8-83dd-dcc1-0b57-5c59c1c037e9
43: lxc48c4aa0637ce@if42: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ae:36:76:3e:c3:03 brd ff:ff:ff:ff:ff:ff link-netns cni-407cd7d8-7c02-cfa7-bf93-22946f923ffd
```

pod流量的出口流量：
```shell
[root@host]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool net show dev lxc48c4aa0637ce
xdp:

tc:
lxc48c4aa0637ce(43) clsact/ingress bpf_lxc.o:[from-container] id 2901

flow_dissector:
[root@host]tc filter show dev lxc48c4aa0637ce ingress
filter protocol all pref 1 bpf chain 0
filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_lxc.o:[from-container] direct-action not_in_hw id 2901 tag d578585f7e71464b jited
[root@host]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool prog show id 2901
2901: sched_cls  name handle_xgress  tag d578585f7e71464b  gpl
	loaded_at 2023-01-09T19:29:52+0000  uid 0
	xlated 688B  jited 589B  memlock 4096B  map_ids 572,86
	btf_id 301
```

可以看出，这里加载了 BPF 程序 bpf_lxc.o 的 from-container 部分。到 Cilium 的源码 bpf_lxc.c 的 __section("from-container") 部分，程序名 handle_xgress：
```C
handle_xgress #1
  validate_ethertype(ctx, &proto)
  tail_handle_ipv4 #2
    handle_ipv4_from_lxc #3
      lookup_ip4_remote_endpoint => ipcache_lookup4 #4
      policy_can_access #5
      if TUNNEL_MODE #6
        encap_and_redirect_lxc
          ctx_redirect(ctx, ENCAP_IFINDEX, 0)
      if ENABLE_ROUTING
        ipv4_l3
      return CTX_ACT_OK;
```
1. 网络包的头信息发送给 handle_xgress，然后检查其 L3 的协议。
2. 所有 IPv4 的网络包都交由 tail_handle_ipv4 来处理。
3. 核心的逻辑都在 handle_ipv4_from_lxc。tail_handle_ipv4 是如何跳转到 handle_ipv4_from_lxc，这里用到了 Tails Call 。Tails call 允许我们配置在某个 BPF 程序执行完成并满足某个条件时执行指定的另一个程序，且无需返回原程序。这里不做展开有兴趣的可以参考 官方的文档。
4. 接着从 eBPF map cilium_ipcache 中查询目标 endpoint，查询到 tunnel endpoint 192.168.1.13 ，这个地址是目标所在的节点 IP 地址，类型是。
```shell
[root@host]kubectl exec -n kube-system $cilium1 -c cilium-agent -- cilium map get cilium_ipcache | grep 10.42.0.51
10.42.0.51/32     identity=15773 encryptkey=0 tunnelendpoint=192.168.1.13   sync
```
(5)：policy_can_access 这里是执行出口策略的检查，本文不涉及故不展开。
(6)：之后的处理会有两种模式：
- 直接路由：交由内核网络栈进行处理，或者 underlaying SDN 的支持。
- 隧道：会将网络包再次封装，通过隧道传输，比如 vxlan。
- 使用代理：在 #5 中如果 policy_can_access 返回了代理的端口时（如果网络策略作用在 L7，策略中自动指定代理的端口），会使用代理（Node level）进行路由。关于这部分，还是参考另一篇文章 Cilium 如何处理 L7 流量，对借助代理执行 7 层的流量策略进行了深入的解读。

这里我们使用的也是隧道模式。网络包交给 encap_and_redirect_lxc 处理，使用 tunnel endpoint 作为隧道对端。最终转发给 ENCAP_IFINDEX（这个值是接口的索引值，由 cilium-agent 启动时获取的），就是以太网接口 cilium_vxlan。

## 工具
```shell
[root@jisdjiiwef]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool net show dev lxc48c4aa0637ce
xdp:

tc:
lxc48c4aa0637ce(43) clsact/ingress bpf_lxc.o:[from-container] id 2901

flow_dissector:

# 下发 bpf_lxc.c from-container 程序: https://github.com/cilium/cilium/blob/master/bpf/bpf_lxc.c#L970-L1025
tc filter show dev lxc3a01d529e083 ingress
#filter protocol all pref 1 bpf chain 0 
#filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_lxc.o:[from-container] direct-action not_in_hw tag b07a0188f79fbd7b

# 下发 bpf_host.c to-host 程序: https://github.com/cilium/cilium/blob/master/bpf/bpf_host.c#L1106-L1188
tc filter show dev cilium_host ingress
#filter protocol all pref 1 bpf chain 0 
#filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_host.o:[to-host] direct-action not_in_hw tag 7afe1afd2f393b1b

# 下发 bpf_host.c from-host 程序: https://github.com/cilium/cilium/blob/master/bpf/bpf_host.c#L990-L1002
tc filter show dev cilium_host egress
#filter protocol all pref 1 bpf chain 0 
#filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_host.o:[from-host] direct-action not_in_hw tag 9b2b3e068f78309b

# 下发 bpf_host.c from-netdev 程序: https://github.com/cilium/cilium/blob/master/bpf/bpf_host.c#L963-L988
tc filter show dev eth0 ingress
#filter protocol all pref 1 bpf chain 0 
#filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_netdev_eth0.o:[from-netdev] direct-action not_in_hw tag 524a2ea93d920b5f

# 下发 bpf_host.c to-netdev 程序: https://github.com/cilium/cilium/blob/master/bpf/bpf_host.c#L1004-L1104
tc filter show dev eth0 egress
#filter protocol all pref 1 bpf chain 0 
#filter protocol all pref 1 bpf chain 0 handle 0x1 bpf_netdev_eth0.o:[to-netdev] direct-action not_in_hw tag a04f5eef06a7f555 
```