# intro
在Cilium 1.9中引入了基于eBPF的 Host Routing，可以完全绕过iptables和上层主机堆栈，并且与常规的veth设备操作相比，实现了更快的网络命名空间切换。如果你的内核支持这个选项，它会自动启用。要验证你的安装是否运行了eBPF主机路由，请在任何一个Cilium pods中运行cilium status，寻找报告 "Host Routing "状态的行，它应该显示 "BPF"。

进程启动时会进行判断，如果不满足会自动降级为legacy模式，也就是native routing模式: 
```yaml
Requirements:
Kernel >= 5.10
Direct-routing configuration or tunneling
eBPF-based kube-proxy replacement
eBPF-based masquerading
```

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

## datapath

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