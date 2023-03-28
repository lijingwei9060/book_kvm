
1. Vhost-user protocol中inflight I/O tracking，记录每一个IO request，当vhost target升级重启后可以继续处理升级前的IO requests。
2. vhost target和qemu通过unix domain socket进行通信，协商virtio device feature，vhost-user protocol features等特性，然后是memeory table，virtqueue base address。

