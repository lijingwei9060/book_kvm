#


## 源码

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/netkit.c

介绍：  https://lwn.net/Articles/949960/

## 工作原理

1. NETKIT_NEXT: continue processing with the next BPF program in the series (if any). If there are no more programs to invoke, this return is treated like NETKIT_PASS.
2. NETKIT_PASS: immediately pass the packet into the receiving side's network stack without calling any other BPF programs.
3. NETKIT_DROP: immediately drop the packet.
4. NETKIT_REDIRECT: immediately redirect the packet to a new network device, queuing it for transmission without the need to pass through the host's network stack.

## 原因