# intro

Cilium DSR(Dircet Server Return) 是一种 南北方向流量的模式，因为如 Cilium Host-Reachable 后边南北流量抓包所发现，其实默认情况下 Cilium NodePort 也是在 SNAT 模式下运行。
也就是说，当外部流量到达时，节点确定后端是在一个远程节点，那么节点就代表他通过执行 SNAT 将请求重定向到远程后端。这种方式不需要额外的封装报文，也就是不会有 MTU 变化，但是代价就是后端的回复需要额外跳回该节点，以便将数据包直接外回给外部客户之前，执行反向 SNAT 转换。

而在 DSR 模式下，后端直接回复到外部客户端，不需要额外的跳转，也就是说，后端通过使用服务 IP或者端口 直接回复。

DSR模式的另一个优势是，客户端的源IP被保留下来，因此策略可以在后端节点上进行匹配。在SNAT模式下是不可能的。鉴于一个特定的后端可以被多个服务使用，后端需要知道他们需要回复的服务IP/端口。因此，Cilium在Cilium特定的IPv4选项或IPv6目的地选项扩展头中编码这一信息，代价是公布一个较低的MTU。对于TCP服务，Cilium只对SYN包的服务IP/端口进行编码，而不对后续包进行编码。

DSR 模式不可以在 VXLAN 模式下运行，只可以在 native-routing 模式下运行，因为是 UDP 没有 SYN握手建立过程。


## 配置

```yaml
bpf-lb-mode: "dsr"
```

## SNAT datapath


## DSR datapath