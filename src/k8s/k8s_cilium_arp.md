# 工作过程



在from_lxc中：
1. 响应arp请求，使用node mac应答网关mac地址，CILIUM_CALL_ARP = tail_handle_arp(ctx)


tail_handle_arp(ctx)运行在veth上的tc egress钩子上，cil_from_container中如果发现是arp请求，并且设置了arp response就调用这个尾调：
1. 对于不知道的arp请求放通到linux的网络栈上。
2. container理论上只应该发出网关的arp和自己ip的arp(用于重复地址检测)，需要处理网关的，自己的放通。
3. 对于网关的mac地址response：
   1. eth_store_saddr(ctx, smac->addr, 0)
   2. eth_store_daddr(ctx, dmac->addr, 0)
   3. ctx_store_bytes(ctx, 20, &arpop, sizeof(arpop), 0)
   4. ctx_store_bytes(ctx, 22, smac, ETH_ALEN, 0)
   5. ctx_store_bytes(ctx, 28, &sip, sizeof(sip), 0)
   6. ctx_store_bytes(ctx, 32, dmac, ETH_ALEN, 0)
   7. ctx_store_bytes(ctx, 38, &tip, sizeof(tip), 0)
   8. ctx_redirect(ctx, ctx_get_ifindex(ctx), direction)


在host上的2层应答， ENABLE_L2_ANNOUNCEMENTS：
cil_from_host(ctx)
  handle_netdev(ctx, from_host: true)
cil_from_netdev(ctx) // 启用noteport，tc ingress filter， 挂载到物理网卡 
  handle_netdev(ctx, from_host: false)
    do_netdev(ctx, proto, from_host)
      handle_l2_announcement(ctx) // ipv4的arp请求，如果是2层代理响应就处理
        arp_respond(ctx, &mac, tip, &smac, sip, 0); // 这里也是node_mac