# intro

datapath mode: tunnel: 因为兼容性原因，Cilium 会默认启用 tunnel（基于 vxlan) 的 datapatch 模式，也就是 overlay 网络结构。
在未提供任何配置的情况下，Cilium 会自动以这种模式运行，因为这种模式对底层网络基础设施的要求最低。

在这种模式下，所有集群节点都会使用基于 UDP 的封装协议 VXLAN 或 Geneve 形成网状隧道。Cilium 节点之间的所有流量都经过封装.

MTU 开销：由于增加了封装头，有效载荷可用的 MTU 要低于本地路由（VXLAN 每个网络数据包 50 字节）。这导致特定网络连接的最大吞吐率降低。

本地路由(Native-Routing)： 本地路由数据路径在 tunnel: disabled 时启用，并启用本机数据包转发模式。本机数据包转发模式利用 Cilium 运行网络的路由功能，而不是执行封装。在本地路由模式下，Cilium 会将所有未寻址到其他本地端点的数据包委托给 Linux 内核的路由子系统。这意味着，数据包的路由将如同本地进程发出数据包一样。因此，连接集群节点的网络必须能够路由 PodCIDR。配置本地路由时，Cilium 会自动在 Linux 内核中启用 IP 转发。

```text
Node IP: 10.169.72.233                                  Node IP: 10.169.72.238
+---------------------------------------+               +---------------------------------------+ 
| Node1                                 |               | Node2                                 | 
| +-----------------+                   |               | +-----------------+                   | 
| |pod              |                   |               | |pod              |                   | 
| | +------------+  |                   |               | | +------------+  |                   | 
| | | busybox    |  |                   |               | | | busybox    |  |                   | 
| | |10.1.1.154  |  |                   |               | | |10.1.2.154  |  |                   | 
| | +--eth0------+  |                   |               | | +--eth0------+  |                   | 
| +----|------------+                   |               | +----|------------+                   | 
|      |                                |               |      |                                | 
|   lxcxxx <----------> cilium-net      |               |   lxcxxx <----------> cilium-net      | 
|                           |           |               |                           |           | 
|           (10.1.1.208)cilium-host     |               |           (10.1.2.208)cilium-host     | 
|                           |           |               |                           |           | 
|        (20.1.1.236/24)cilium-vxlan    |               |        (20.1.1.236/24)cilium-vxlan    | 
|                           |           |               |                           |           | 
|          (10.169.72.233) eth0         |               |          (10.169.72.238) eth0         | 
+---------------------------|-----------+               +---------------------------|-----------+ 
                            + ------------------------------------------------------+
```

查看建立的tunnel：
```shell
root@node1:/home/cilium# kubectl exec -it -n kube-system cilium-wlkp5 -- cilium bpf tunnel list
TUNNEL       VALUE
10.1.1.0:0   10.169.72.233:0   
10.1.2.0:0   10.169.72.238:0   
```

查看路由：


## features

VTEP devices has been configured with 
1. VTEP endpoint IP
2. VTEP CIDRs
3. VTEP MAC addresses (VTEP MAC). 
4. The VXLAN network identifier (VNI) must be configured as VNI 2, which represents traffic from the VTEP as the world identity。cilium VNID 就是每个应用的 identity，不同的应用具有不同 VNID，这种类似于 不同vlan ID 的 在 trunk 口通信的方式，是需要注意的地方，flannel vxlan 和calico vxlan 都是相同的 VNID

### vtep

vtep： vxlan tunnel endpoint 集成允许第三方vtep设备使用vxlan协议收发流量，可以使用外部的负载均衡例如big-ip。和ipsec加密功能冲突。
```yaml
enable-vtep:   "true"
vtep-endpoint: "10.169.72.236    10.169.72.238"
vtep-cidr:     "10.1.1.0/24   10.1.2.0/24"
vtep-mask:     "255.255.255.0"
vtep-mac:      "82:36:4c:98:2e:56 82:36:4c:98:2e:58"
```

```text
Test VTEP Integration

Node IP: 10.169.72.233
+--------------------------+            VM IP: 10.169.72.236
|                          |            +------------------+
| CiliumNode               |            |  Linux VM        |
|                          |            |                  |
|  +---------+             |            |                  |
|  | busybox |             |            |                  |
|  |         |           ens192<------>ens192              |
|  +--eth0---+             |            |                  |
|      |                   |            +-----vxlan2-------+
|      |                   |
|   lxcxxx                 |
|      |                   |
+------+-----cilium_vxlan--+
```

```shell
# Create a vxlan device and set the MAC address.
ip link add vxlan2 type vxlan id 2 dstport 8472 local 10.169.72.236 dev ens192
ip link set dev vxlan2 address 82:36:4c:98:2e:56
ip link set vxlan2 up
# Configure the VTEP with IP 10.1.1.236 to handle CIDR 10.1.1.0/24.
ip addr add 10.1.1.236/24 dev vxlan2
# Assume Cilium podCIDR network is 10.0.0.0/16, add route to 10.0.0.0/16
ip route add 10.0.0.0/16 dev vxlan2  proto kernel  scope link  src 10.1.1.236
# Allow Linux VM to send ARP broadcast request to Cilium node for busybox pod
# ARP resolution through vxlan2 device
bridge fdb append 00:00:00:00:00:00 dst 10.169.72.233 dev vxlan2
```

test:
```shell
# ping Cilium-managed busybox pod IP 10.0.1.1 for example from Linux VM
ping 10.0.1.1
```

## datapath

跨节点通信的时候，pod 的报文需要pod内部封装一次，然后通过 HOST NS(宿主机)vxlan 在进行封装，然后通过宿主机的物理网卡传到对端 宿主机，在经过 vxlan 解封装后 直接 redict 到pod 内部，而不需要经过它对应的 lxc 网卡