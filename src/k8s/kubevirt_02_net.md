# intro

1. bridge:Bridge 模式下 pod 的 veth pair 仍然由 cni 管理创建，而 virt-launcher 会将 Pod IP 摘掉，pod veth 设备 eth0 仅作为虚拟机的虚拟网卡与外部网络通信的桥梁。
2. slirp
3. masquerade
4. sriov