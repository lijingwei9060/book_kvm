
## tc

### command
tc chain add
tc chain del $chain
tc chain list

tc class del $class
tc class change $class
tc class replace $class
tc class add $class
tc class show

### CT

conntrack -F [table]    //        Flush table
conntrack -D [table] parameters  //       Delete conntrack or expectation
conntrack -L [table] [options]   //       List conntrack or expectation table

// Conntrack parameters and options:
//   -n, --src-nat ip                      source NAT ip
//   -g, --dst-nat ip                      destination NAT ip
//   -j, --any-nat ip                      source or destination NAT ip
//   -m, --mark mark                       Set mark
//   -c, --secmark secmark                 Set selinux secmark
//   -e, --event-mask eventmask            Event mask, eg. NEW,DESTROY
//   -z, --zero                            Zero counters while listing
//   -o, --output type[,...]               Output format, eg. xml
//   -l, --label label[,...]               conntrack labels

// Common parameters and options:
//   -s, --src, --orig-src ip              Source address from original direction
//   -d, --dst, --orig-dst ip              Destination address from original direction
//   -r, --reply-src ip            Source address from reply direction
//   -q, --reply-dst ip            Destination address from reply direction
//   -p, --protonum proto          Layer 4 Protocol, eg. 'tcp'
//   -f, --family proto            Layer 3 Protocol, eg. 'ipv6'
//   -t, --timeout timeout         Set timeout
//   -u, --status status           Set status, eg. ASSURED
//   -w, --zone value              Set conntrack zone
//   --orig-zone value             Set zone for original direction
//   --reply-zone value            Set zone for reply direction
//   -b, --buffer-size             Netlink socket buffer size
//   --mask-src ip                 Source mask address
//   --mask-dst ip                 Destination mask address

// Layer 4 Protocol common parameters and options:
// TCP, UDP, SCTP, UDPLite and DCCP
//    --sport, --orig-port-src port    Source port in original direction
//    --dport, --orig-port-dst port    Destination port in original direction

### bridge
bridge vlan show
bridge vlan add dev DEV vid VID [ pvid ] [ untagged ] [ self ] [ master ]
bridge vlan add dev DEV vid VID-VIDEND [ pvid ] [ untagged ] [ self ] [ master ]
bridge vlan del dev DEV vid VID [ pvid ] [ untagged ] [ self ] [ master ]
bridge vlan del dev DEV vid VID-VIDEND [ pvid ] [ untagged ] [ self ] [ master ]
### filter
tc filter replace $filter
tc filter add $filter
tc filter del $filter
tc filter show

 为目标网卡创建clsact
tc qdisc add dev [network-device] clsact
 加载bpf程序
tc filter add dev [network-device] <direction> bpf da obj [object-name] sec [section-name]
 查看
tc filter show dev [network-device] <direction>
### link
ip link set $link allmulticast on
ip link set $link allmulticast off

ip link set $link multicast on
ip link set $link multicast off

ip link set $link type (macvlan|macvtap) mode $mode

ip link set $link up
ip link set $link down

ip link set $link mtu $mtu
ip link set $link name $name

ip link set dev $link alias $name

ip link property add $link altname $name
ip link property del $link altname $name

ip link set $link address $hwaddr

ip link set $link vf $vf mac $hwaddr
ip link set $link vf $vf vlan $vlan
ip link set $link vf $vf vlan $vlan qos $qos
ip link set $link vf $vf vlan $vlan qos $qos proto $proto
ip link set $link vf $vf rate $rate
ip link set $link vf $vf min_tx_rate $min_rate max_tx_rate $max_rate
ip link set $link vf $vf state $state
ip link set $link vf $vf spoofchk $check
ip link set $link vf $vf trust $state
ip link set dev $link vf $vf node_guid $nodeguid
ip link set $link master $master
ip link set $link nomaster
ip link set $link netns $pid
ip link set $link netns $ns
ip link set $link gso_max_segs $maxSegs // the GSO maximum segment count of the link device
ip link set $link gso_max_size $maxSize // the IPv6 GSO maximum size of the link device
ip link set $link gro_max_size $maxSize // the IPv6 GRO maximum size of the link device
ip link set $link gso_ipv4_max_size $maxSize  //  the IPv4 GSO maximum size of the link device
ip link set $link gro_ipv4_max_size $maxSize  // the IPv4 GRO maximum size of the link device

ip link add $link // adds a new link device
ip link del $link
ip link show
ip link set $link txqlen $qle // the transaction queue length for the link
ip link set $link group $id  // sets the link group id which can be used to perform mass actions with iproute2 as well use it as a reference in nft filters.

### route

ip route add $route
ip route append $route
ip route change $route
ip route replace $route
ip route del $route
ip route show
ip route get <> vrf <VrfName>
ip route get
## tcx

link.AttachNetkit(link.NetkitOptions{
		Program:   prog,
		Attach:    attach,
		Interface: device.Attrs().Index,
		Anchor:    link.Tail(),
	})

fd, err := sys.LinkCreateNetkit(&attr)  => BPF(BPF_LINK_CREATE, unsafe.Pointer(attr), unsafe.Sizeof(*attr))
