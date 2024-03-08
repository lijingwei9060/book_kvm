# intro

CNI插件包括两部分：
1. CNI Plugin负责给容器配置网络，它包括两个基本的接口
   1. 配置网络: AddNetwork(net NetworkConfig, rt RuntimeConf) (types.Result, error)
   2. 清理网络: DelNetwork(net NetworkConfig, rt RuntimeConf) error
2. IPAM Plugin负责给容器分配IP地址，主要实现包括host-local和dhcp。

有哪些：
1. loopback
2. bridge
3. ptp
4. macvlan
5. ipvlan

CNI Plugin Chains： 一些列插件
1. DHCP插件是最主要的IPAM插件之一，用来通过DHCP方式给容器分配IP地址，在macvlan插件中也会用到DHCP插件。
2. host-local是最常用的CNI IPAM插件，用来给container分配IP地址。
3. ptp插件通过veth pair给容器和host创建点对点连接：veth pair一端在container netns内，另一端在host上。可以通过配置host端的IP和路由来让ptp连接的容器之前通信。
4. IPVLAN 和 MACVLAN 类似，都是从一个主机接口虚拟出多个虚拟网络接口。一个重要的区别就是所有的虚拟接口都有相同的 mac 地址，而拥有不同的 ip 地址。
5. flannel通过给每台宿主机分配一个子网的方式为容器提供虚拟网络，它基于Linux TUN/TAP，使用UDP封装IP包来创建overlay网络，并借助etcd维护网络的分配情况。
6. Weave Net是一个多主机容器网络方案，支持去中心化的控制平面，各个host上的wRouter间通过建立Full Mesh的TCP链接，并通过Gossip来同步控制信息。使用udp封装l2 overlay，支持用户态和内核态ovs。


pod创建过程：
1. kubelet调用cri插件创建pod
2. cri创建pod 沙箱id、网络ns
3. cri调用cni，传递pod id、网络ns
4. cni配置pod网络：依次flannel、bridge、host-local ipam cni plugin
5. cri创建pause容器，加入网络ns
6. kubelet调用cri，获取镜像
7. kubelet调用cri创建应用