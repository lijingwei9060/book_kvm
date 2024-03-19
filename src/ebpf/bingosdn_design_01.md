# 流量 

package -> NIC( 物理) --(xdp1)--> veth(Host) --(xdp02)--> veth(vm)

```shell
$su_do ip netns add vpc-25932F01
$su_do ip link add vpc-25932F01 type veth peer name vpc-25932F01-1
$su_do ifconfig vpc-25932F01 hw ether fe:00:25:93:2F:01 up
$su_do ovs-vsctl add-port br0 vpc-25932F01
$su_do ip link set vpc-25932F01-1 netns vpc-25932F01
$su_do ip netns exec vpc-25932F01 ifconfig vpc-25932F01-1 hw ether d0:00:25:93:2F:01 up
$su_do ip netns exec vpc-25932F01 ip a a 169.254.169.254/32 dev vpc-25932F01-1
$su_do ip netns exec vpc-25932F01 ip r a 10.16.66.0/24 dev vpc-25932F01-1
$su_do ip netns exec vpc-25932F01 ip a a 169.254.169.3/32 dev vpc-25932F01-1
ps -ef|grep nginx |grep '/opt/bingocloud/run/metaweb/md-netns-vpc-25932F01.conf'
ip netns exec vpc-25932F01 nginx -p /opt/bingocloud/run/metaweb -c /opt/bingocloud/run/metaweb/md-netns-vpc-25932F01.conf; echo __exit_code__:$?
```

## 从外边访问虚拟机

xdp01: 
1. 根据目标mac转发到对应的tap/veth设备(bc-mac-addr)
   1. hasmap：mac-ifaceID-nicID-ip-subnetID地址表(单向更新u2k)
   2. array： mac-sgIDs(u2k)
   3. array： mac-IPs(u2k, k2u? arp)是否要学习arp
   4. array:  mac-lvsPorts(u2k)
   5. 删除vm nic时要删除对应的目录
   6. daemon有一个全局的mac-iface表，实时同步
2. sg的校验应该在这里
   1. array：mac-sgIDs
   2. trie: array_trie(sgid-ruleset)

## 同一子网同一主机vm相互访问
## 同一子网不同主机vm相互访问
## 不同子网同一主机vm相互访问
## 不同子网不同主机vm相互访问
## 通过vpcpeering访问
## LVS访问
## 虚拟机访问外部
## 虚拟机访问api、metaweb
