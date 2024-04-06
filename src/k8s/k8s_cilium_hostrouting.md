# 网络模式

1. 封装模式：tunnel: true
   1. vxlan
   2. geneve
2. 路由模式： tunnel: disabled​​
   1. host routing： 跳过iptables，使用主机的路由表
   2. native routing： 使用主机的路由表，经过iptables

ENABLE_NODEPORT
ENABLE_DSR

ENABLE_ROUTING
ENABLE_HOST_ROUTING
ENABLE_HOST_FIREWALL

ENABLE_EGRESS_GATEWAY_COMMON
ENABLE_HIGH_SCALE_IPCACHE

ENABLE_VTEP
TUNNEL_MODE

ENABLE_CLUSTER_AWARE_ADDRESSING

KubeProxyReplacement: Disabled Cilium 是没有完全替换掉 kube-proxy 的，后面我们会出文章介绍如何实现替换。
IPv6 BIG TCP: Disabled 该功能要求 Linux Kernel >= 5.19, 所以在 Kernel 4.19.232 状态为禁用。
BandwidthManager: Disabled 该功能要求 Linux Kernel >= 5.1, 所以目前是禁用的
Host Routing: Legacy Legacy Host Routing 还是会用到 iptables, 性能较弱；但是 BPF-based host routing 需要 Linux Kernel >= 5.10
Masquerading: IPtables IP 伪装有几种方式：基于 eBPF 的，和基于 iptables 的。默认使用基于 iptables, 推荐使用 基于 eBPF 的。

## 
在Cilium 1.9中引入了基于eBPF的 Host Routing，可以完全绕过iptables和上层主机堆栈，并且与常规的veth设备操作相比，实现了更快的网络命名空间切换。如果你的内核支持这个选项，它会自动启用。要验证你的安装是否运行了eBPF主机路由，请在任何一个Cilium pods中运行cilium status，寻找报告 "Host Routing "状态的行，它应该显示 "BPF"。

进程启动时会进行判断，如果不满足会自动降级为`legacy模式`，也就是`native routing`模式: 
```yaml
Requirements:
Kernel >= 5.10
Direct-routing configuration or tunneling
eBPF-based kube-proxy replacement
eBPF-based masquerading
```

### 配置

```yaml
kube-proxy-replacement: strict
k8s-api-server: https://192.168.56.2:6443
```
kube-proxy-replacement有如下三个可选值，默认为partial，可参考函数initKubeProxyReplacementOptions
1. partial: 只使能部分功能，比如使能--enable-node-port，--enable-host-port等
2. strict: 使能所有功能，如果有不支持的会panic
3. disabled: 关闭replacement

k8s-api-server：用来指定k8s apiserver。cilium启动时默认会通过kubernetes svc(cluster ip 10.96.0.1)连接k8s，	前面已经把kube-proxy相关的删除了，所以也连不上kubernetes svc，只能通过此参数显示指定，可参考函数createConfig。

### 检查
在内核 5.11.0 以后，具备了 ​​bpf_redict_peer()​​​ 和 ​​bpf_redict_neigh()​​ 这两个非常重要的 helper 函数的能力。此能力是来自 Cilium host Routing 的 Feature 引入。

在5.11之前使用bpf_redirect(), 只能转发到lxc网卡上，再进行tc的ingress和egress。

```shell
root@master:~# kubectl -n kube-system exec -it cilium-fxdkr -- cilium status | grep -i "Host Routing"
Defaulted container "cilium-agent" out of: cilium-agent, mount-cgroup (init), clean-cilium-state (init)
Host Routing:           BPF
```



按照 icmp 报文简单推测一下抓包逻辑：
POD1：
- pod1 内veth 网卡：可以正常接收到 request 报文 和 reply 报文
- node 对应veth 网卡：可以正常接收到 request 报文，但是无法接收 reply 报文
POD2：
- pod2 内veth网卡：可以正常接收到 request 报文 和 reply 报文
- node 对应 veth网卡：可以正常接收到 reply 报文，但是无法接收 request 报文

## 优势

bpf_redict_peer()函数可以将同 一个节点的pod 通信的步骤进行省略，报文在从源pod 出来以后，可以直接 redict(直连) 到目的pod 的内部网卡，而不会经过宿主机上与其对应的 LXC 网卡，这样在报文的路径就少了一步转发。这种 redict 的能力，使得 cilium 绕过了 Node 上的 iptables Overhead。

eBPF host-routing 允许绕过主机命名空间中的所有的 iptables 和 上层的overhead 开销，以及穿过 Veth Pair 时的 context-switching 开销，这样网络数据包尽可能早的面向网络设备拾取，并直接传递到 Kubernetes Pod的网络命名空间，在出口端，数据包仍然需要穿过 Veth Pair，被eBPF拾取并直接提交给面向外部的网络接口（就是 宿主机eth0），路由表是直接从 eBPF 查询的，所以这种优化是完全透明，并且与系统上运行的其他提供路由分配的服务兼容。

master上发报文方向时，在lxc1的ebpf程序中执行路由(图中的路由表是在ebpf程序中被查找)和邻居查找，如果成功则调用bpf_redirect/bpf_redirect_neigh直接将报文从出接口enp0s8发出，跳过了host协议栈中netfilter的处理。
node1上收报文方向时，在enp0s8收到报文执行ebpf程序，查找podmap确认目的ip为本地pod后，则调用bpf_redirect_peer将报文直接发到pod内部的eth0，不仅跳过了host协议栈中netfilter的处理，也减少了一次软中断的处理

由此可见bpf_redirect_neigh和bpf_redirect_peer是实现host routing模式的关键。

### datapath

1. eth0(pod1) -> lxc1(tc ingress:from-container) -> enp0s8(master，tc egress:to-netdev)
   1. pod内部发出的报文，最终会调用veth_xmit发出
   2. 根据veth原理，会将报文的dev改成对端dev(即lxc)后调用netif_rx走host协议栈
   3. 在协议栈入口调用sch_handle_ingress执行ebpf程序，查路由表和邻居表，如果成功的互，会返回CTX_ACT_REDIRECT
   4. 调用skb_do_redirect将报文重定向到出接口
   5. ebpf： lxc1(tc ingress:from-container)
      1. 在host routing模式下，直接在ebpf程序中查找路由，如果查找成功则直接重定向到出接口，不用再返回host协议栈处理
      2. 调用bpf helper函数 fib_lookup(bpf_ipv4_fib_lookup)，查找路由和邻居表，如果查找路由表成功，则将下一跳保存到 fib_params->ipv4_dst，将出接口保存到 params->ifindex，如果查找邻居表成功，则将出接口mac保存到params->smac，将下一跳mac保存到params->dmac
      3. 路由表和邻居表都查到了，则更改报文源目的mac，调用bpf helper ctx_redirect将报文重定向到出接口
      4. 只查到路由表，未查到邻居表，调用bpf helper redirect_neigh查找邻居表，如果仍然查不到(大概率还是查不到)，则创建邻居表，发送arp学习对端mac
      5. 其他情况则返回DROP
      6. 已经有了下一跳，则调用redirect_neigh只需要查找邻居表
      7. 这个分支是定义了ENABLE_SKIP_FIB的情况，此时调用redirect_neigh会查找路由表和邻居表
      8. 更新源目的mac
      9. 重定向到出接口(此时还未真正重定向，只是设置了标志位和出接口索引，后面调用skb_do_redirect时才真正执行报文重定向)
2. enp0s8(node1)(tc ingress:from-netdev) -> eth0(pod2)
   1. ingress policy： 如果允许通过则将报文重定向到pod的lxc或者peer口
   2. host routing模式下，ENABLE_HOST_ROUTING会被定义，可将报文直接重定向到lxc的peer接口，即pod内部的eth0


### 代码

fib_do_redirect(ctx, needs_l2_check, fib_params, use_neigh_map,fib_err, oif) // 将包转发到output网卡上
   redirect_neigh(*oif, &nh_params, sizeof(nh_params), 0)
   redirect_neigh(*oif, NULL, 0, 0);
   ctx_redirect(ctx, *oif, 0);

## native routing



### 配置

```yaml
# 修改tunnel 
  tunnel: disabled

# 添加 pod CIDR，使 node 节点能对 pod CIDR 进行路由
  native-routing-cidr: "10.0.0.0/16"

# 修改如下选项为 true
  auto-direct-node-routes: "true"
```



## ip masquerading

Pod 使用的 IPv4 地址通常是从 RFC1918 专用地址块中分配的，因此不可公开路由。Cilium 会自动将离开群集的所有流量的源 IP 地址伪装成 node 的 IPv4 地址，因为 node 的 IP 地址已经可以在网络上路由

如果要禁用该选项:
1. 对于离开主机的 IPv4 流量，可使用选项 enable-ipv4-masquerade：false，
2. 对于 IPv6 流量，可使用选项 enable-ipv6-masquerade：false

### 配置

默认行为是排除本地节点 IP 分配 CIDR 范围内的任何目的地。如果 pod IP 可通过更广泛的网络进行路由，则可使用选项：ipv4-native-routing-cidr: 10.0.0.0/8（或 IPv6 地址的 ipv6-native-routing-cidr: fd00::/100）指定该网络，在这种情况下，该 CIDR 范围内的所有目的地都 不会 被伪装。

### 验证
```shell
$ kubectl -n kube-system exec ds/cilium -- cilium status | grep Masquerading
Masquerading:            IPTables [IPv4: Enabled, IPv6: Disabled]
```

基于 eBPF 的实现是 最有效 的实现。它需要 Linux 内核 4.19，并可通过 bpf.masquerade=true。伪装只能在运行 eBPF 伪装程序的网卡设备上进行。这意味着，如果输出网卡设备运行了该程序，从 pod 发送到外部地址的数据包将被伪装（伪装到输出网卡设备的 IPv4 地址）。如果未指定，程序将自动连接到 BPF NodePort 网卡设备检测机制 选择的网卡设备上。要手动更改，请使用devices helm 选项。

```shell
$ kubectl -n kube-system exec ds/cilium -- cilium status | grep Masquerading
Masquerading:            BPF   [eth0]   10.0.0.0/22 [IPv4: Enabled, IPv6: Disabled]
```

基于 eBPF 的伪装可伪装以下 IPv4 L4 协议的数据包：TCP，UDP，ICMP（仅 Echo request 和 Echo reply）。默认情况下，除了发往其他集群节点的数据包外，所有从 pod 发往 ipv4-native-routing-cidr 范围之外 IP 地址的数据包都会被伪装。排除的 CIDR 显示在上述 cilium status（10.0.0.0/22）输出中。

为实现更精细的控制，Cilium 在 eBPF 中实现了 [ip-masq-agent](https://github.com/kubernetes-sigs/ip-masq-agent)，可通过 ipMasqAgent.enabled=true helm 选项启用。基于 eBPF 的 ip-masq-agent 支持在配置文件中设置 nonMasqueradeCIDRs 和 masqLinkLocal 选项。从 pod 发送到属于 nonMasqueradeCIDRs 中任何 CIDR 的目的地的数据包都不会被伪装。


cil_to_netdev(struct __ctx_buff *ctx) // host
   ret = handle_nat_fwd(ctx, 0, &trace, &ext_err);
cil_to_overlay(struct __ctx_buff *ctx) // overlay
   ret = handle_nat_fwd(ctx, cluster_id, &trace, &ext_err);

      ->CILIUM_CALL_IPV4_NODEPORT_NAT_FWD = tail_handle_nat_fwd_ipv4(struct __ctx_buff *ctx)
         ret = handle_nat_fwd_ipv4(ctx, &trace, &ext_err)
            __handle_nat_fwd_ipv4(ctx, cluster_id, trace, ext_err)
               ret = nodeport_rev_dnat_fwd_ipv4(ctx, trace, ext_err);
               ->CILIUM_CALL_IPV4_NODEPORT_SNAT_FWD = tail_handle_snat_fwd_ipv4(ctx)
                  ret = nodeport_snat_fwd_ipv4(ctx, cluster_id, &saddr, &trace, &ext_err)
                     ret = snat_v4_needs_masquerade(ctx, &tuple, ip4, l4_off, &target)
                     ret = snat_v4_nat(ctx, &tuple, ip4, l4_off, ipv4_has_l4_header(ip4), &target, trace, ext_err)
                     ctx_snat_done_set(ctx)
                     egress_gw_fib_lookup_and_redirect(ctx, target.addr, tuple.daddr, ext_err);



## Egress gateway

kernel ≥ 5.2

egress gateway可以将从pod到集群外部的流量集中到特定的节点上，这些节点就是egress gateway。使能之后，从pod出去外部的流量将伪装成网关节点，

限制：
1. 使能BPF masquerading 
2. 使能the kube-proxy replacement
3. egress gateway policies 延迟生效，需要访问外部的流量进行出站策略，变更成egress gateway ip有延迟。
4. 与l7 的policy会发生冲突，不生效。
5. 不兼容cluster mesh， 必须和pods在一个cluster。
6. 不兼容CiliumEndpointSlice 
7. 不支持ipv6

### 配置
```yaml
enable-bpf-masquerade: true
enable-ipv4-egress-gateway: true
enable-l7-proxy: false
kube-proxy-replacement: true
```


### 验证

```shell
kubectl -n kube-system exec ds/cilium -- cilium-dbg bpf egress list
Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), wait-for-node-init (init), clean-cilium-state (init)
Source IP    Destination CIDR    Egress IP   Gateway IP
192.168.2.23 192.168.60.13/32    0.0.0.0     192.168.60.12
```