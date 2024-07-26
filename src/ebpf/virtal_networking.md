
bridge - Ethernet Bridge device
bond - Bonding device
dummy - Dummy network interface
hsr - High-availability Seamless Redundancy device
ifb - Intermediate Functional Block device
ipoib - IP over Infiniband device
macvlan - Virtual interface base on link layer address (MAC)
macvtap - Virtual interface based on link layer address (MAC) and TAP.
vcan - Virtual Controller Area Network interface
vxcan - Virtual Controller Area Network tunnel interface
veth - Virtual ethernet interface
vlan - 802.1q tagged virtual LAN interface
vxlan - Virtual eXtended LAN
ip6tnl - Virtual tunnel interface IPv4|IPv6 over IPv6
ipip - Virtual tunnel interface IPv4 over IPv4
sit - Virtual tunnel interface IPv6 over IPv4
gre - Virtual tunnel interface GRE over IPv4
gretap - Virtual L2 tunnel interface GRE over IPv4
erspan - Encapsulated Remote SPAN over GRE and IPv4
ip6gre - Virtual tunnel interface GRE over IPv6
ip6gretap - Virtual L2 tunnel interface GRE over IPv6
ip6erspan - Encapsulated Remote SPAN over GRE and IPv6
vti - Virtual tunnel interface
nlmon - Netlink monitoring device
ipvlan - Interface for L3 (IPv6/IPv4) based VLANs
ipvtap - Interface for L3 (IPv6/IPv4) based VLANs and TAP
lowpan - Interface for 6LoWPAN (IPv6) over IEEE 802.15.4 / Bluetooth
geneve - GEneric NEtwork Virtualization Encapsulation
macsec - Interface for IEEE 802.1AE MAC Security (MACsec)
vrf - Interface for L3 VRF domains
netdevsim - Interface for netdev API tests
rmnet - Qualcomm rmnet device

## vepa
Virtual Ethernet Port Aggregator。它是HP在虚拟化支持领域对抗Cisco的VN-Tag的技术。解决了虚拟机之间网络通信的问题，特别是位于同一个宿主机内的虚拟机之间的网络通信问题。VN-Tag在标准的协议头中增加了一个全新的字段，VEPA则是通过修改网卡驱动和交换机，通过发夹弯技术回注报文。

## veth
veth设备是成对创建的： $ ip link add vethA type veth peer name vethB
创建之后，执行ip link就可以看到新创建的veth设备：
```shell
58: vethB@vethA: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
link/ether ee:1b:b0:11:38:eb brd ff:ff:ff:ff:ff:ff
59: vethA@vethB: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
link/ether a6:f8:50:36:2d:1e brd ff:ff:ff:ff:ff:ff
```
注意veth设备前面的ID，58:和59:，一对veth设备的ID是相差1的，并且系统内全局唯一。可以通过ID找到一个veth设备的对端。

## team
和bond区别：
1. lacp load balancing
2. NS/NA IPV6 link monitoring
3. d-Bus interface
4. [more](https://github.com/jpirko/libteam/wiki/Bonding-vs.-Team-features)
5. [net_failover](https://www.kernel.org/doc/html/latest/networking/net_failover.html) a new kernel driver 
```shell
# teamd -o -n -U -d -t team0 -c '{"runner": {"name": "activebackup"},"link_watch": {"name": "ethtool"}}'
# ip link set eth0 down
# ip link set eth1 down
# teamdctl team0 port add eth0
# teamdctl team0 port add eth1
```

## vxlan

24bit segment id, vni, upto 2^24, encapsulates layer 2 frames with a vxlan header into a udp-ip packet 

```shell
ip link add vx0 type vxlan id 100 local 1.1.1.1 remote 2.2.2.2 dev eth0 dstport 4789
```

## MACVLAN

five MACVLAN types:
1. Private: doesn't allow communication between MACVLAN instances on the same physical interface, even if the external switch supports hairpin mode.
2. VEPA: data from one MACVLAN instance to the other on the same physical interface is transmitted over the physical interface. Either the attached switch needs to support hairpin mode or there must be a TCP/IP router forwarding the packets in order to allow communication.
3. Bridge: all endpoints are directly connected to each other with a simple bridge via the physical interface.
4. Passthru: allows a single VM to be connected directly to the physical interface.
5. Source: the source mode is used to filter traffic based on a list of allowed source MAC addresses to create MAC-based VLAN associations. 

```shell
# ip link add macvlan1 link eth0 type macvlan mode bridge
# ip link add macvlan2 link eth0 type macvlan mode bridge
# ip netns add net1
# ip netns add net2
# ip link set macvlan1 netns net1
# ip link set macvlan2 netns net2
```


## IPVLAN

Ipvlan 是 linux kernel 比较新的特性，linux kernel 3.19 开始支持 ipvlan，但是比较稳定推荐的版本是 >=4.2

IPVLAN is similar to MACVLAN with the difference being that the endpoints have the same MAC address.
IPVLAN supports L2 and L3 mode. IPVLAN L2 mode acts like a MACVLAN in bridge mode. The parent interface looks like a bridge or switch.
In IPVLAN L3 mode, the parent interface acts like a router and packets are routed between endpoints, which gives better scalability.

```shell
# ip netns add ns0
# ip link add name ipvl0 link eth0 type ipvlan mode l2
# ip link set dev ipvl0 netns ns0
```


[ref](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#dummy_interface)

## macvtap

MACVTAP 是对 MACVLAN的改进，把 MACVLAN 与 TAP 设备的特点综合一下，使用 MACVLAN 的方式收发数据包，但是收到的包不交给 network stack 处理，而是生成一个 /dev/tapX 文件，交给这个文件。由于 MACVLAN 是工作在 MAC 层的，所以 MACVTAP 也只能工作在 MAC 层。


## tun
Tun是Linux系统里的虚拟网络设备, TUN设备模拟网络层设备(network layer)，处理三层报文，IP报文等，用于将报文注入到网络协议栈

应用程序(app)可以从物理网卡上读写报文，经过处理后通过TUN回送，或者从TUN读取报文处理后经物理网卡送出。

TAP虚拟的是一个二层设备，接收、发送的是二层包。
TUN虚拟的是一个三层设备，接收、发送的是三层包。