

1. xdp进入阶段
   1. 表 cilium_xdp_scratch(per cpu array)保存了一个META_PIVOT, (cb + RECIRC_MARKER + XFER_MARKER)7个u32。
   2. 设置表cilium_xdp_scratch[XFER_MARKER]=0
   3. 设置表cilium_xdp_scratch[RECIRC_MARKER]=0
   4. enable-xdp-prefilter = false(default), 
      1. default 放行
      2. true： 
         1. 检查CIDR4_LMAP_NAME表，有规则就drop
         2. 检查CIDR4_HMAP_NAME表，有规则就drop
         3. check_v4_lb(ctx): 当开启ENABLE_NODEPORT_ACCELERATION 能力，才会在 XDP 阶段直接接手处理 NodePort 的访问。如果是没有开启的，数据包会直接进入内核，由 tc 的 from-netdev 来完成 NodePort 的处理。
            1. CILIUM_CALL_IPV4_FROM_NETDEV = tail_lb_ipv4(ctx)
            2. 读取cilium_xdp_scratch[RECIRC_MARKER]， 
            3. dsr geneve
            4. nodeport_lb4()
               1. svc => nodeport_svc_lb4
               2. ENABLE_NAT_46X64_GATEWAY -> CILIUM_CALL_IPV46_RFC8215
               3. XFER_PKT_NO_SVC = 1
               4. dsr => nodeport_dsr_ingress_ipv4()
               5. no ip masquerade => ok???
               6. CB_SRC_LABEL = src_sec_identity
               7. nat64 -> CILIUM_CALL_IPV6_NODEPORT_NAT_INGRESS
               8. nat -> CILIUM_CALL_IPV4_NODEPORT_NAT_INGRESS


   