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

IPVLAN is similar to MACVLAN with the difference being that the endpoints have the same MAC address.
IPVLAN supports L2 and L3 mode. IPVLAN L2 mode acts like a MACVLAN in bridge mode. The parent interface looks like a bridge or switch.
In IPVLAN L3 mode, the parent interface acts like a router and packets are routed between endpoints, which gives better scalability.

```shell
# ip netns add ns0
# ip link add name ipvl0 link eth0 type ipvlan mode l2
# ip link set dev ipvl0 netns ns0
```


[ref](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#dummy_interface)