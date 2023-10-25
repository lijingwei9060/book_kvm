# 编译参数

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_INFO=y
CONFIG_CONSOLE_POLL=y
CONFIG_KDB_CONTINUE_CATASTROPHIC=0
CONFIG_KDB_DEFAULT_ENABLE=0x1
CONFIG_KDB_KEYBOARD=y
CONFIG_KGDB=y
CONFIG_KGDB_KDB=y
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=n
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_SERIAL_KGDB_NMI=n


在Guest的启动选项中，选择Advanced Options,然后在需要debug的kernel版本上按e，编辑该内核的启动项，加入：
kgdbwait kgdboc=ttyS0,115200 nokaslr


在Host上，之前从Guest传输过来的内核源码目录下，启动gdb
gdb -ex 'file vmlinux' -ex 'target remote localhost:1234'
然后在gdb中，输入c，并回车

在Guest中，输入
sudo echo g > /proc/sysrq-trigger  // 将Target的运行暂停
然后就会发现Guest卡住了，回到Host看gdb所在的terminal，发现gdb可以操作了，之后就可以使用该gdb对内核进行debug了。



kvm和kvm_intel都是内核的module，vmlinux默认情况下是不加载module的符号的，需要手动加载。

在target上找到kvm和kvm_intel的.text段地址
cat /sys/module/kvm/sections/.text
cat /sys/module/kvm_intel/sections/.text
我获得的target上kvm和kvm_intel两个module在内核中的.text位置分别为:

0xffffffffc0205000,0xffffffffc0335000.

在host上的gdb调试窗口将这两个地址的符号加载进gdb
注意这一步中，gdb vmlinux运行的目录为从target复制过来的Linux源码的目录

(gdb) add-symbol-file arch/x86/kvm/kvm.ko 0xffffffffc0205000

(gdb) add-symbol-file arch/x86/kvm/kvm.ko 0xffffffffc0335000
然后就可以在类似于handle_io的kvm代码出下断点了。