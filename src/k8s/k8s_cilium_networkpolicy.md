# intro

默认情况下，Kubernetes 集群中的所有 pod 都可被其他 pod 和网络端点访问。

网络策略允许用户定义 Kubernetes 集群允许哪些流量, 禁止哪些流量。传统的防火墙是根据源或目标 IP 地址和端口来配置允许或拒绝流量的(五元组)，而 Cilium 则使用 Kubernetes 的身份信息（如标签选择器、命名空间名称，甚至是完全限定的域名）来定义允许和不允许的流量规则。这样，网络策略就能在 Kubernetes 这样的动态环境中运行，因为在这种环境中，IP 地址会随着不同 pod 的创建和销毁而不断被使用和重复使用。

在 Kubernetes 上运行 Cilium 时，可以使用 Kubernetes 资源定义网络策略(networking.k8s.io/v1 NetworkPolicy)。Cilium Agent 将观察 Kubernetes API 服务器是否有网络策略更新，并加载必要的 eBPF 程序和 map，以确保实施所需的网络策略。启用 Cilium 的 Kubernetes 提供三种网络策略格式：

- 支持第 3 层和第 4 层策略的标准 Kubernetes NetworkPolicy 资源(标准的 Kubernetes NetworkPolicy, Kubernetes 开箱自带, 其他 CNI 如 Calico 也支持)
- 支持第 3、4 和 7 层（应用层）策略的 CiliumNetworkPolicy 资源(Cilium 专有的 CRD: CiliumNetworkPolicy)
- CiliumClusterwideNetworkPolicy 资源，用于指定适用于整个集群而非指定命名空间的策略(Cilium 专有的 CRD: CiliumClusterwideNetworkPolicy, 字面意思, 集群范围的网络策略, 甚至可以进行 Node 级别的网络策略限制.)

Cilium 支持同时使用所有这些策略类型。不过，在使用多种策略类型时应小心谨慎，因为在多种策略类型中理解所允许流量的完整集合可能会造成混乱。如果不密切注意，可能会导致意外的策略行为。因此, 推荐在 Cilium 中, 使用后两种资源.

这次我们主要关注 CiliumNetworkPolicy 资源，因为它代表了标准 Kubernetes NetworkPolicy 功能的超集。

## NetworkPolicy 资源
NetworkPolicy 资源是  Kubernetes 的标准资源(networking.k8s.io/v1 NetworkPolicy)，可让您在 IP 地址或端口级别（OSI模型第 3 层或第 4 层）控制流量。NetworkPolicy 的功能包括:

使用标签(label)匹配的 L3/L4 Ingress 和 Egress 策略
集群外部端点使用 IP/CIDR 的 L3 IP/CIDR Ingress 和 Egress 策略
L4 TCP 和 ICMP 端口 Ingress 和 Egress 策略
🐾Warning

NetworkPolicy 不适用于主机网络命名空间。启用主机网络的 Pod 不受网络策略规则的影响。

网络策略无法阻止来自 localhost 或来自其驻留的节点的流量。

## CiliumNetWorkPolicy 资源
CiliumNetworkPolicy 是标准 NetworkPolicy 的扩展。CiliumNetworkPolicy 扩展了标准 Kubernetes NetworkPolicy 资源的 L3/L4 功能，并增加了多项功能：

L7 HTTP 协议策略规则，将 Ingress 和 Egress 限制为特定的 HTTP 路径
支持  DNS、 Kafka 和  gRPC 等其他 L7 协议
基于服务名称的内部集群通信 Egress 策略
针对特殊实体使用 实体匹配的 L3/L4 Ingress 和 Egress 策略
使用 DNS FQDN 匹配的 L3 Ingress 和 Egress 策略
您可以在  Cilium 项目文档中找到针对几种常见用例的 CiliumNetworkPolicy YAML 清单的具体示例。

要读取网络策略的 YAML 定义并预测它将允许和拒绝哪些流量可能比较困难，而且要使策略精确地达到你想要的效果也并非易事。幸运的是， networkpolicy.io 上的可视化策略编辑器能让这一切变得更容易。