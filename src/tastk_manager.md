# 内存结构

# 地址空间 


# current task
# 寄存器关系
EBP:  stack base, 栈基
ESP： stack pointer，栈顶

## 一次入栈(x86)
caller stack: 参数n...参数1，返回地址
%ebp: 栈基
callee stack: 寄存器、本地变量、临时变量，参数构造区域
%esp

## 内核栈
每个进程有一个内核栈、一个用户栈，内核栈THREAD_SIZE，如下在x86 64位系统上定义，为16K。

内核栈保存什么信息？
```C
union thread_union {
#ifndef CONFIG_THREAD_INFO_IN_TASK
    struct thread_info thread_info; // 不在这里就在task_struct的第一个字段
#endif
    unsigned long stack[THREAD_SIZE/sizeof(long)];
};
```

stack保存寄存器信息:
```C
struct pt_regs {
    /*
    * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
    * unless syscall needs a complete, fully filled "struct pt_regs".
    */
    unsigned long r15;
    unsigned long r14;
    unsigned long r13;
    unsigned long r12;
    unsigned long bp;
    unsigned long bx;
    /* These regs are callee-clobbered. Always saved on kernel entry. */
    unsigned long r11;
    unsigned long r10;
    unsigned long r9;
    unsigned long r8;
    unsigned long ax;
    unsigned long cx;
    unsigned long dx;
    unsigned long si;
    unsigned long di;
    /*
    * On syscall entry, this is syscall#. On CPU exception, this is error code.
    * On hw interrupt, it's IRQ number:
    */
    unsigned long orig_ax;
    /* Return frame for iretq */
    unsigned long ip;
    unsigned long cs;
    unsigned long flags;
    unsigned long sp;
    unsigned long ss;
    /* top of stack page */
};
```
内核栈保存在哪里？
# 数据结构


# idle进程
start_kernel() -> init内核线程 -> cpu_idle, 从bios-->bootloader-->idle
# ref

1. [Linux 函数栈（内核态和用户态）](http://119.23.219.145/posts/linux-kernel-linux-%E5%87%BD%E6%95%B0%E6%A0%88%E5%86%85%E6%A0%B8%E6%80%81%E5%92%8C%E7%94%A8%E6%88%B7%E6%80%81/)
2. [漫话Linux之“躺平”: IDLE 子系统](https://www.eet-china.com/mp/a55387.html)