# 引导过程

## UEFI（Unified Extensible Firmware Interface）

1. 通电 
2. 执行UEFI
3. 查找EFI分区
4. 执行bootx64.efi，加载\EFI\Boot\bootx64.efi，在安装Windows时实际上会使用\EFI\Microsoft\Boot\bootmgfw.efi的内容替换到\EFI\Boot\bootx64.efi，所以\EFI\Boot\bootx64.efi其实就是\EFI\Microsoft\Boot\bootmgfw.efi；执行bootmgrw.efi，bootmgfw.efi会读取BCD文件，BCD是一个数据库文件，如果包含多个系统，信息会包含在BCD中，通过显示一个系统列表供用户选择；
5. BCD，BCD中包含每个系统的引导文件的路径，Windows的是\Windows\System32\winload.efi，加载到内存中并执行；
6. 执行winload.efi，读取\Windows\bootstat.dat文件，有需要则显示引导菜单，比如安全引导等等；
7. 接着加载内核程序Ntoskrnl.exe，相关辅助HAL.dll、CI.dll、PSSHED.dll、BootVID.dll，把CPU执行权交给内核程序；

## MBR

1. 上电并稳定后，CPU执行地址0xFFFF0h处指令，此处为BIOS程序；
2. BIOS进行硬件自检，没有问题后加载硬盘的第一个扇区到内存0x7c00h处，第一个扇区为MBR（Master Boot Record），MBR包含执行程序和分区表；
3. CPU开始执行MBR程序，查找第一个活动分区，把活动分区的第一个扇区加载到内存中，活动分区第一个扇区为PBR（Partition Boot Record）；
4. CPU开始执行PBR，第一个指令就是跳过BPB（BIOS Parameter Block）到可执行代码处；BPB包含比较多参数，有族的大小、MFT记录大小、MFT位置等，用于读取NTFS文件；
5. PBR读取VBR（Volume BootRecord，占用分区开始的16扇区）剩余的15扇区到内存中；接着CPU跳转到0x07C0:027A处，执行BOOTMGR代码（第二个扇区中）；
6. 开始寻找bootmgr.exe，找不到则寻找ntldr.exe（win vista之前的系统）；
7. CPU加载并跳转到bootmgr.exe处执行，读取BCD文件，如果含有多个系统，则列举显示供用户选择；
8. 选择的是Windows则读取winload.exe文件到内存中，CPU跳转到winload.exe处执行，读取文件\windows\bootstat.dat，，有需要则显示引导菜单，比如安全引导等等；接着加载内核程序Ntoskrnl.exe，相关辅助HAL.dll、CI.dll、PSSHED.dll、BootVID.dll，把CPU执行权交给内核程序；
9. 内核程序执行系统初始化。