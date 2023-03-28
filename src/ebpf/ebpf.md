# conception

Extended Berkeley Packet Filter

BPF is a Tracing Framework: Used to access kernel trace backend instrumentation tools

```shell
# ls /sys/kernel/debug/tracing/events/irq/
enable filter irq_handler_entry 
irq_handler_exit softirq_entry softirq_exit 
softirq_raise
```

Static tracepoints : `cat /sys/kernel/debug/tracing/available_events`

Dynamic trace functionalities: uprobes, kprobes



# 语法
bpftrace -e 'BEGIN { printf("%u\n", *kaddr("tsc_khz")); exit(); }'


# BPF超能的核心技能点——BPF Hooks
在目前的Linux内核中已经有了近10种的钩子，如下所示：

- kernel functions (kprobes)
- userspace functions (uprobes)
- system calls
- fentry/fexit
- Tracepoints
- network devices (tc/xdp)
- network routes
- TCP congestion algorithms
- sockets (data level)

# 第二个核心技能点——「BPF Map」。
Map类型： 
- Hash tables, Arrays
- LRU (Least Recently Used)
- Ring Buffer
- Stack Trace
- LPM (Longest Prefix match)

Map功能： 
- Program state
- program configuration
- share data between programs
- share state、metric and statistics betweeen with user space

# BPF超功能的核心技能点——BPF Helper Function

- random numbers
- get current time
- map access
- get process/cgroup context
- manipulate network packets and forwarding
- access cokcet data
-  perform tail call
-  access process stack
-  access syscall arguments

# 几个重点限制：

eBPF 程序不能调用任意的内核参数，只限于内核模块中列出的 BPF Helper 函数，函数支持列表也随着内核的演进在不断增加
eBPF程序不允许包含无法到达的指令，防止加载无效代码，延迟程序的终止
eBPF 程序中循环次数限制且必须在有限时间内结束
eBPF 堆栈大小被限制在 MAXBPFSTACK，截止到内核 Linux 5.8 版本，被设置为 512。目前没有计划增加这个限制，解决方法是改用 BPF Map，它的大小是无限的。
eBPF 字节码大小最初被限制为 4096 条指令，截止到内核 Linux 5.8 版本， 当前已将放宽至 100 万指令（ BPF_COMPLEXITY_LIMIT_INSNS），对于无权限的BPF程序，仍然保留4096条限制 ( BPF_MAXINSNS )


# 工具： 

bpfcc-tools：
bcc 自带超过 70 多个工具可以直接使用。bcc 入门教程里你将接触 其中 11 个工具：execsnoop,  opensnoop, ext4slower (or btrfs, xfs, zfs), biolatency, biosnoop,  cachestat, tcpconnect, tcpaccept, tcpretrans, runqlat, and profile.

## IOVisor项目中的bcc的工具：
- 应用层
- 
- 系统调用层：oepnsnoop statsnoop syncsnoop 
- scheduler
- virtual memory
- sockets: sofdsnoop
- tcp、udp
- ip
- net device
- vfs: cachestat cachetop dcstat dcsnoop mountsnoop filetop filelife fileslower vfscount vfsstat
- file systems: btrfsdist btrfsslower ext4dist ext4slower nfsslower nfsdist xfsslower xfsdist zfsslower zfsdist
- volume manager: mdflush
- block device： biotop biosnoop biolatency bitesize
- 设备驱动层： 