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
1. cilium_net@cilium_host
2. cilium_host@cilium_net
3. cilium_vxlan
4. cilium_health 
5. lxc_health@if24:
6. lxc113dd6a50a7a@if32:


1. pod lxc bpf ingress: pod中veth的BPF程序（BPF 程序 bpf_lxc.o 的 from-container，handle_xgress）
2. Node vxlan BPF Egress,容器的出口流量对 cilium_vxlan 来说也是 engress，因此这里的程序是 to-overlay
3. Node nic bpf egress: egress 程序 to-netdev 位于 bpf_host.c。实际上没做重要的处理，只是返回 CTX_ACT_OK 交给内核网络栈继续处理：将网络包发送到 vxlan 隧道发送到对端，也就是节点 192.168.1.13 。中间数据的传输，实际上用的还是 underlaying 网络，从主机的 eth0 接口经过 underlaying 网络到达目标主机的 eth0 接口。
4. node nic bpf ingress: vxlan 网络包到达节点的 eth0 接口，也会触发 BPF 程序from-netdev，位于 bpf_host.c 中。当判断网络包是 vxlan 的并确认允许 vlan 后，直接返回 CTX_ACT_OK 将处理交给内核网络栈。
5. node vxlan bpf ingress: 网络包通过内核网络栈来到了接口 cilium_vxlan。程序位于 from-overlay bpf_overlay.c 中。
6. piod lxc bpf egress: egress to-container（与 from-container）。

## 工具
```shell
[root@jisdjiiwef]kubectl exec -n kube-system $cilium1 -c cilium-agent -- bpftool net show dev lxc48c4aa0637ce
xdp:

tc:
lxc48c4aa0637ce(43) clsact/ingress bpf_lxc.o:[from-container] id 2901

flow_dissector:
```