# 引导过程
cpu点亮后，引导过程分为几个阶段：
1. BIOS/UEFI： 执行硬件初始化
2. Stage1： 执行stage2 bootloader(uefi不需要)
3. Stage2： 加载和启动内核
4. kernel Startup： 内核初始化
5. Init： 环境初始化，第一个进程出现，SystemV Init或者Systemd。
6. Runlevels/Targets: 初始化用户态环境


# BIOS/UEFI

## X86硬件：
1. CPU处于Real Mode: 16位指令执行模式，20位段地址空间。地址定位通过cs* 16 + offset得到物理地址。
2. 第一条指令在F000:FFF0(reset vector), BIOS代码在这里
3. 只有一个core可以运行
4. Cache关闭
5. MMU关闭
6. 内存是空的

## BIOS boot

1. BIOS加载固件到内存: 从C000:0000到 C780:0000
2. 执行RAM检测
3. 硬件检测
4. 硬件初始化
5. 从CMOS(64byte)加载引导配置
6. 寻找stage1 bootloader，加载引导程序到0000:7c00, 跳转ljmp $ 0x0000 , $0x7c00
7. OS引导 

## BIOS启动后内存结构

|序号|Function|From|To|
|  --  | --  | -- | -- |
|1|Low Memory| 0x00000000 | 0x000A0000(640Kb)|
|2| VGA Display | - | 0x000C0000(768Kb)|
|3| 16bit devices expansion ROM| - | 0x000F0000(960Kb)|
|4| BIOS ROM| - | 0x00100000(1Mb)|

# Stage1：加载mbr

MBR：第一个扇区512字节，
- boot.img: 436byte + 10disk ID(4 byte disk signature, 6byte disk timestamp)
- 64字节的分区表：包含4条目的分区表(16byte *4)， 
- 结尾是magic number(0xAA55)。

功能目标：
1. 设置A20-line
2. 切换到32位保护模式
3. 设置IDT和GDT表
4. 设置栈
5. 加载内核

## boot.image： 由 boot.S 编译而成，一共 512 字节
- 跳转指令，到达0x4A，长度为3字节
- BIOS Parameters Block： 软驱下使用，长度为
- Grub 参数
- Stage1： 代码
- 分割字符串："GRUB"
- Error字符串：以0分割
- NT disk serial Number

# Stage1.5： 识别不同的文件系统

core.img：
- diskboot.img： core.img的第一个扇区，对应diskboot.S代码。他的功能就是加载core.img的其他部分。
- lzma_decompress.img 对应的代码是 startup_raw.S，kernel.img 是压缩过的，需要解压缩。lzma_decompress.img 做了一个重要的决定，就是调用 real_to_prot，切换到保护模式，这样就能在更大的寻址空间里面，加载更多的东西
- kernel.img： 是grub的内核，对应startup.S 和C文件。
- 其他模块

## 从实地址模式到保护模式
1. 启用分段，建立段描述表，将段寄存器指向段描述符
2. 启动分页
3. 切换保护模式，打开Gate A20，第21根地址线的控制线
4. kernel.img调用grub_main->grub_load_config()解析grub.conf中的文件。
5. grub_menu_execute_entry 选定OS
6. -> grub_cmd_linux读取内核镜像文件头部数据结构加载内核镜像到内存。
7. -> grub_cmd_initrd将initramfs加载进内存
8. -> grub_command_execute ("boot", 0, 0) 才开始真正地启动内核,可以计入start_kernel

# Stage2： 启动内核

1. grub stage2 / c:\ntldr, 读取grub.conf/ boot.ini
2. 加载/boot/vmlinz* 或者c:\windows\system32\ntoskrnl.exe

## x86硬件状态
1. 一个core激活，其他idle
2. 引导过程激活其他core
3. linux启动协议

# kernel 引导
1. set_task_stack_end_magic(&init_task): 0号进程
2. trap_init()： 初始化中断门
3. mm_init(): 内存初始化
4. sched_init(): 调度初始化
5. vfs_caches_init()： 初始化基于内存的文件系统rootfs
6. register_filesystem(&rootfs_fs_type)： 注册文件系统
7. rest_init()： 其他初始化
   1. kernel_thread(kernel_init, NULL, CLONE_FS)： 创建1号进程，(SystemV Init或者SystemD)
   2. kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES)： 2号进程

# 概念

1. Real Mode是80286cpu之前的唯一模式，早于保护模式。为了兼容，后续所有CPU从实地址模式初始化。实地址模式可以访问16bit，cpu可以访问1MB地址(分段?)，可以访问BIOS程序。
2. Protected Mode：可以使用分页和虚拟内存，32bit地址