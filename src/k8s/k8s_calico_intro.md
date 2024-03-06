# intro

使用虚拟路由代替虚拟交换，每一台虚拟路由通过BGP协议传播可达信息（路由）到剩余数据中心；Calico在每一个计算节点利用Linux Kernel实现了一个高效的vRouter来负责数据转发，而每个vRouter通过BGP协议负责把自己上运行的workload的路由信息像整个Calico网络内传播——小规模部署可以直接互联，大规模下可通过指定的BGP route reflector来完成。

组件：
1. felix： 每台haost上的agent进程，负责网络接口管理、监听、路由、arp、acl、同步和状态上报。
2. bgp client：bird（BGP Internet Routing Daemon）， 每个host部署一个使用bird实现，支持bgp、ospf、rip。监听host上felix注入的路由信息，通过bgp协议广播到其他节点。
3. bgp route reflector： 大规模网络中，bgp client形成的mesh网络会导致规模受限，因为是两两互联（tunnel）。通过route reflect方式，bgp client仅连接特定的RR节点。
4. confd：开源的、轻量级的配置管理工具。监控Calico数据存储对BGP配置和全局默认的日志变更，如AS号、日志级别和IPAM信息。Confd根据存储中的数据更新，动态生成BIRD配置文件。当配置文件发生变化时，confd会触发BIRD加载新的文件。

概念：
1. BGP运行在tcp上的自治路由协议AS。
2. AS内部有多个BGP speaker，氛围ibgp（internal bgp）、ebgp（external bgp）。
3. ebgp与其他as的互联，也就是说一个as内只有一个ebgp？。
4. 连接模式氛围全连接（node-to-node mesh）和路由反射模式（Route Reflector）。超过100台不推荐全连接。RR中，选定一个speaker为RR，它与其他建立连接
5. calico中的node节点是一个as。
6. calico的实现模式： IPIP（使用ip隧道实现跨节点通信）和BGP

## ipip模式
数据流：
1. pod1发出ping数据包从容器的eth0发出，发现不是一个子网，转发到网关（169.254.1.1）。
2. 网关的mac地址为全E，发起arp请求。网关是什么？
3. 对应node的veth pari段calixxx收到arp请求，网卡的代理arp功能把自己的mac地址返回给pod1.
4. node查找路由表，通过tunl0封包转发给对应的node

网卡arp代理，抑制广播风暴，避免arp表膨胀
/proc/sys/net/ipv4/conf/calixxxx/proxy_arp =1 

tap对管理

tunnel管理


## bgp模式

bgp模式要求节点之间二层互通，在一个子网中。

kube-ipvs0： dummy虚拟网昂卡