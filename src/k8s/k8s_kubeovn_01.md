# intro

## 子网
1. 子网： 每个 Namespace 可以归属于特定的子网， Namespace 下的 Pod 会自动从所属的子网中获取 IP 并共享子网的网络配置（CIDR，网关类型，访问控制，NAT 控制等）。子网为一个全局的虚拟网络配置，同一个子网的地址可以分布在任意一个节点上。
2. 子网路由：在 Overlay 模式下，默认子网使用了分布式网关并对出网流量进行 NAT 转换，其行为和 Flannel 的默认行为基本一致， 用户无需额外的配置即可使用到大部分的网络功能。在 Underlay 模式下，默认子网使用物理网关作为出网网关，并开启 arping 检查网络连通性。
3.  join 子网： 每个 Node 节点创建了一块虚拟网卡 ovn0 接入 join 子网，通过该网络完成节点和 Pod 之间的网络互通。
4.  手工指定pod或者workload的子网：设置 Pod 的 Annotation ovn.kubernetes.io/logical_switch 来实现；需要给 Workload 类型资源如 Deployment，StatefulSet 绑定子网，需要将 ovn.kubernetes.io/logical_switch Annotation 设置在 spec.template.metadata.annotations。

## 网关

分布式网关和集中式网关，用户可以在子网中对网关的类型进行调整。
1. 分布式：每个 node 会作为当前 node 上 pod 访问外部网络的网关。 数据包会通过本机的 ovn0 网卡流入主机网络栈，再根据主机的路由规则进行出网。 当 natOutgoing 为 true 时，Pod 访问外部网络将会使用当前所在宿主机的 IP。
2. 集中式： Pod 访问外网的数据包会首先被路由到特定节点的 ovn0 网卡，再通过主机的路由规则进行出网。 当 natOutgoing 为 true 时，Pod 访问外部网络将会使用特定宿主机的 IP。集中式网关默认为主备模式，只有主节点进行流量转发， 如果需要切换为 ECMP 模式。
## acl
## 静态路由