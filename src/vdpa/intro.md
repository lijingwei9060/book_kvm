# What

[Introduction to vDPA kernel framework](https://www.redhat.com/en/blog/introduction-vdpa-kernel-framework) 

[Achieving network wirespeed in an open standard manner: introducing vDPA](https://www.redhat.com/en/blog/achieving-network-wirespeed-open-standard-manner-introducing-vdpa)

[https://vdpa-dev.gitlab.io/](https://vdpa-dev.gitlab.io/)

物理网卡支持vDPA，增加网卡控制平面
物理机kernel： vdpa framework +vdpa vendor driver
虚拟机： virtiio-net-pmd
容器： vdpa device plugin +  vdpa cni(multus cni)

vDPA DPDK(host): qemu 可以连接vDPA硬件作为vhost-user backend，由网卡提供。
以下限制推动 vDPA kerne(5.7)：

1. DPDK 库的依赖问题
2. vhost-user只有用户态的api，内核态访问不到，失去了内核态工具支持，比如eBPF
3. DPDK缺少对硬件管理的接口和工具

## vdpa kernel framework