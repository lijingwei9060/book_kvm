# 

## slb集群路由

slb 为了高可用，一般都会集群化部署，那么请求怎么路由到每一台 slb 上呢？一般由（动态）路由协议（ospf bgp）实现 ecmp，使得各个 slb 实例从 router/switch 那里均匀地获得流量。 由于配置动态路由协议非常繁杂，不在本文考虑范围之内，这里采用一个简单的脚本来模拟 ecmp。就是将到达 vip 的下一跳在几个 host（混布有 slb 和 app 的机器，以下简称 mix） 之间反复修改即可。

```shell
#!/bin/bash

dst="172.19.0.10"
rs1="172.19.0.2"
rs2="172.19.0.3"
ip route del $dst/32
ip route add $dst/32 nexthop via $rs1 dev eth0 weight 1
while true; do
    nexthop=$(ip route show $dst/32 | awk '{print $3}')
    # nexthop=$(ip route show "$dst" | grep -oP "nexthop \K\S+")
    echo "to ${dst} via ${nexthop} now!"
    sleep 3
    
    # the requirements for blank is crazy!
    if [ "$nexthop" = "$rs1" ]; then
        new_nexthop="$rs2"
    else
        new_nexthop="$rs1"
    fi
    ip route del $dst/32
    ip route add $dst/32 nexthop via $new_nexthop dev eth0 weight 1
done
```

## NAT

1. full nat 模式，在当前混布的模式下不再合适，可能会导致数据包无穷循环。因为不对数据包做一些标记的话，xdp 程序无法区分是来自 client 的数据包还是来自另一个 slb 的包。
2.  DR 模式，除了能避免循环问题以外，性能也更好，因为回包少了一跳,包的修改少了，也不用重新计算 ip、tcp 校验和等

```c
## fullnat
if (dest_ip = vip && dest_port = vport){
	ingress，包来源于 client，要转发给 rs	
	挑选本地一个可用的 port1-ip1 作为新包的 src
	使用负载均衡算法挑选一个 rs，并将其 port2-ip2 作为新包的 dst
	相应的修改 src mac 和 dst mac
	
	此外保存 client 的 port3-ip3 和 port1-ip1 的双向映射关系
	便于后续 ingress 和 egress 使用
}else{
	egress，包来源于 rs， 要转发给 client
	根据包的 dst 找到 port1-ip1
	根据 ingress 里面的映射找到对应的 client 的 port3-ip3 作为新包的 dst
	使用 vip 和 vport 作为新包的 src
	相应的修改 src mac 和 dst mac 
}
重新计算校验和
使用 XDP_TX 将包从本网卡重新扔回去
```