# vmlinux.h

在 BPF CO-RE 框架下，vmlinux.h 文件包含了内核的数据结构定义，这些定义是通过解析内核 BTF（BPF Type Format）信息自动生成的。BTF 是一种新的内核数据类型格式，它为内核提供了一种描述数据类型的方法，这对于 BPF CO-RE 的运行至关重要。
在编写 eBPF 程序时，vmlinux.h 文件使得开发者可以在用户空间程序中直接使用内核的数据结构，而无需关心内核版本的差异。这是因为 BPF CO-RE 可以在编译时解析这些数据结构，并生成可以在任何内核版本上运行的 eBPF 字节码。
例如，假设你在 eBPF 程序中需要访问 task_struct 结构，你可以在你的 eBPF 程序中包含 vmlinux.h，然后直接使用 struct task_struct。

所以，vmlinux.h 是对于BPF CO-RE编程必不可少的文件。

## vmlinux
vmlinux 是未压缩的 Linux 内核映像。它是在 Linux 内核编译过程中生成的一个文件，包含了整个内核的代码（包括内核模式和用户模式的代码）。vmlinux 包含了内核的符号表，因此它经常被用于调试目的。

vmlinux.h 是一个由 BPF CO-RE（Compile Once, Run Everywhere）框架自动生成的头文件。它包含了内核的数据结构定义，这些定义是通过解析 vmlinux 中的 BTF（BPF Type Format）信息自动生成的。

BTF 是一种新的内核数据类型格式，它为内核提供了一种描述数据类型的方法。通过 BTF，BPF CO-RE 可以解析 vmlinux 中的数据结构定义，并将这些定义写入 vmlinux.h 文件。

因此，vmlinux 和 vmlinux.h 之间的关系是：vmlinux.h 是通过解析 vmlinux 中的 BTF 信息生成的。vmlinux 包含了内核的代码和数据结构定义，而 vmlinux.h 包含了这些数据结构定义的副本，可以在编写 eBPF 程序时使用。

在编写 eBPF 程序时，vmlinux.h 文件使得开发者可以在用户空间程序中直接使用内核的数据结构，而无需关心内核版本的差异。这是因为 BPF CO-RE 可以在编译时解析这些数据结构，并生成可以在任何内核版本上运行的 eBPF 字节码。

## 生成vmlinux.h文件
bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h

内核编译选项：
```txt
CONFIG_BPF=Y
CONFIG_BPF_SYSCALL=y
#[optional, for tc filters]
CONFIG_NET_CLS_BPF=m
#[optional, for tc actions]
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
#[for linux kernel versions 4.1 through 4.6]
CONFIG_HAVE_BPF_JIT=y
#[for linux kernel version 4.7 and later]
CONFIG_HAVE_EBPF_JIT=y
#[optional, for kporbes]
CONFIG_BPF_EVENTS=y
# need kernel headers through /sys/kernel/kheaders.tar.xz
CONFIG_IKHEADERS=y
```


1. 开启CONFIG_DEBUG_INFO_BTF，编译一份带有BTF信息的内核
2. 通过pahole处理编译产物，即vmlinux，然后得到一个.btf文件
3. 通过bpftool处理vmlinux，得到一份vmlinux.h
4. 基于libbpf库开发，引入vmlinux.h，得到一份需要目标环境内核开启CONFIG_DEBUG_INFO_BTF即可顺利运行的eBPF程序
5. 如果目标环境内核没有开CONFIG_DEBUG_INFO_BTF，那么我们可以借助第二步得到的.btf文件和bpftool工具，生成一份精简后的携带有必要BTF信息的文件，然后在eBPF程序运行前需要做重定位工作时，加载该文件。这样同样可以实现一次编译到处运行


1. expose BTF under
2. /sys/kernel/btf/vmlinux. But libbpf should be able to locate vmlinux file
from /usr/lib/debug/lib/modules/5.3.18/vmlinux