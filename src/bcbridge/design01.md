port： 代表物理机上的接口，
1. 类型，vport对应vm、容器、vxlan、物理出口、vs 互联口(虚拟，taptun连接两个switch，属于三层口)、meta端口、mirror端口、代理端口
2. iface：ifindex
3. vlan，默认只有一个，全部都是access类型
4. endpoint_id: 代表虚拟机、容器、proxy、peer相关的业务端口
5. switch_id: 物理网口因为可能是多个switch共享可以没有bridge_id， 需要从underlay 这个map中查找。
6. mac信息，

underlay_map: array
1. iface, bridge_id


switch：
1. 支持peer，peer链接表



peer链接表：
1. ab switch


endpoint_all：
1. mac -> endpoint_info

arp:
1. ip -> mac



场景：
1. vlan 广播：通过vlan 查找所有隶属于同一个switch的iface，查找port表更快，遍历然后复制，send，去除自身
2. 去同一个switch的不同主机上的port，可以通过vxlan、也可以是物理出口。
2.1. 内部网络、非直连路由、启用隧道 -> port转发给 vxlan
2.2. 外部网络 -> port 打上vlan tag 转发给物理网卡
2.3. 内部网络、直连路由 -> port转发给物理网卡
3. arp请求；
3.1. 代理模式，查找arp表找到mac，确认同一vlan就响应，没找到就甩出去外部出口。
3.2. 如果是访问meta端口，无条件响应
3.3. 非代理模式下需要转发给同一个swich下面的所有同一子网的接口，复制转发到所有同一个switch、同一个vlan的port上，也要转发给外部出口卡


从端口发出的数据包需要打上这些标签；
1. src_switch_id： 如果为0表示from_world, 从外部来，需要按照南北向控速，否则东西向控速
2. src_port
3. src_vlan: 只有在外部二层端口转发的时候才真正的打上tag
   to_iface
   to_vlan
4. to_meta: 如果访问到meta
5. to_mirror: 转给mirror端口
6. hairpin：访问自身
9. to_switch: 如果为0表示to_world, 访问外部，需要按照南北向控速，否则东西向控速
10. NAT： 需要nat
11. 4层负载
12. 7层负载


数据流：from_container,
1. 校验mac，ip[根据port的flag判断是否需要校验]，失败drop+update metric+event
2. 打标签：src_switch, src_port, src_vlan
3. 2层解析：
3.1. arp_request，代理arp响应，
3.1.1. 如果是内部网络，但是无相关mac，drop
3.1.2. 如果是外部网络，打上to_vlan, to_switch_id 为0，复制转发redirect_to(外部二层口，可能有多个)，二层口判断是否支持该vlan，来选择转发，需要限速
3.2. arp_response, 正常不应该出现，应该drop
3.3. 广播？
3.4. 多播？
4. 3层分析：// 交换机支持3层，才做3层分析
4.1. 内部交换机，先查ct表，查不到走下面
4.1.1. 交换机对应的子网范围，根据目标IP查找对应的endpoint。
4.1.2.	 内部交换机，找peering后的交换机的子网范围。
4.1.3.	 找到了 =>如果不在同一个物理机，根据switch出口策略，判断是2层出口、host routing，还是vxlan。
4.1.4.   找不到，需要nat出去吗？ 需要改成to_world
4.2. 外部交换机，先查ct表，查不到走下面
4.2.1. 内部IP，直接转。查不到，to_world转给二层口