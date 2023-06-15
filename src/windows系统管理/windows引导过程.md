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

## 引导区结构

### ESP分区

1. 使用diskpart建立efi分区，260M，格式化为ntfs，设置c:\windows引导。

diskpart 
list disk 
select disk *                       // 选择你要重建EFI分区的盘的编号，以数字代替*
list partition 
create partition efi size = 260     // 260M，分配给EFI分区的容量
format quick fs = fat32 
exit 
 
bcdboot C:\Windows                  // 注意盘符

### BCD

```txt
C:\Users\Administrator>Bcdedit /enum all /v

Windows 启动管理器
--------------------
标识符                  {9dea862c-5cdd-4e70-acc1-f32b344d4795}
device                  partition=G:
description             Windows Boot Manager
locale                  zh-CN
inherit                 {7ea2e1ac-2e61-4728-aaa3-896d9d0a9f0e}
default                 {3a83f409-85ca-11e9-82a5-ee8f458de4b5}
resumeobject            {3a83f408-85ca-11e9-82a5-ee8f458de4b5}
displayorder            {3a83f409-85ca-11e9-82a5-ee8f458de4b5}
toolsdisplayorder       {b2721d73-1db4-4c62-bf78-c548a880142d}
timeout                 30

Windows 启动加载器
-------------------
标识符                  {3a83f409-85ca-11e9-82a5-ee8f458de4b5}
device                  partition=C:
path                    \Windows\system32\winload.exe
description             Windows Server 2008 R2
locale                  zh-CN
inherit                 {6efb52bf-1766-41db-a6b3-0ee5eff72bd7}
recoverysequence        {3a83f40c-85ca-11e9-82a5-ee8f458de4b5}
recoveryenabled         No
testsigning             Yes
osdevice                partition=C:
systemroot              \Windows
resumeobject            {3a83f408-85ca-11e9-82a5-ee8f458de4b5}
nx                      OptOut
bootstatuspolicy        IgnoreAllFailures

Windows 启动加载器
-------------------
标识符                  {3a83f40c-85ca-11e9-82a5-ee8f458de4b5}
device                  ramdisk=[C:]\Recovery\3a83f40c-85ca-11e9-82a5-ee8f458de
b5\Winre.wim,{3a83f40d-85ca-11e9-82a5-ee8f458de4b5}
path                    \windows\system32\winload.exe
description             Windows Recovery Environment
inherit                 {6efb52bf-1766-41db-a6b3-0ee5eff72bd7}
osdevice                ramdisk=[C:]\Recovery\3a83f40c-85ca-11e9-82a5-ee8f458de
b5\Winre.wim,{3a83f40d-85ca-11e9-82a5-ee8f458de4b5}
systemroot              \windows
nx                      OptIn
winpe                   Yes
custom:46000010         Yes

从休眠状态恢复
---------------------
标识符                  {3a83f408-85ca-11e9-82a5-ee8f458de4b5}
device                  partition=C:
path                    \Windows\system32\winresume.exe
description             Windows Resume Application
locale                  zh-CN
inherit                 {1afa9c49-16ab-4a5c-901b-212802da9460}
filedevice              partition=C:
filepath                \hiberfil.sys
debugoptionenabled      No

Windows 内存测试程序
---------------------
标识符                  {b2721d73-1db4-4c62-bf78-c548a880142d}
device                  partition=G:
path                    \boot\memtest.exe
description             Windows 内存诊断
locale                  zh-CN
inherit                 {7ea2e1ac-2e61-4728-aaa3-896d9d0a9f0e}
badmemoryaccess         Yes

EMS 设置
------------
标识符                  {0ce4991b-e6b3-4b16-b23c-5e0d9250e5d9}
bootems                 Yes

调试器设置
-----------------
标识符                  {4636856e-540f-4170-a130-a84776f4c654}
debugtype               Serial
debugport               1
baudrate                115200

RAM 故障
-----------
标识符                  {5189b25c-5558-4bf2-bca4-289b11bd29e2}

全局设置
---------------
标识符                  {7ea2e1ac-2e61-4728-aaa3-896d9d0a9f0e}
inherit                 {4636856e-540f-4170-a130-a84776f4c654}
                        {0ce4991b-e6b3-4b16-b23c-5e0d9250e5d9}
                        {5189b25c-5558-4bf2-bca4-289b11bd29e2}

启动加载器设置
--------------------
标识符                  {6efb52bf-1766-41db-a6b3-0ee5eff72bd7}
inherit                 {7ea2e1ac-2e61-4728-aaa3-896d9d0a9f0e}
                        {7ff607e0-4395-11db-b0de-0800200c9a66}

虚拟机监控程序设置
-------------------
标识符                  {7ff607e0-4395-11db-b0de-0800200c9a66}
hypervisordebugtype     Serial
hypervisordebugport     1
hypervisorbaudrate      115200

恢复加载器设置
----------------------
标识符                  {1afa9c49-16ab-4a5c-901b-212802da9460}
inherit                 {7ea2e1ac-2e61-4728-aaa3-896d9d0a9f0e}

设备选项
--------------
标识符                  {3a83f40d-85ca-11e9-82a5-ee8f458de4b5}
description             Ramdisk Options
ramdisksdidevice        partition=C:
ramdisksdipath          \Recovery\3a83f40c-85ca-11e9-82a5-ee8f458de4b5\boot.sdi
```

## 引导区管理工具

windows7的引导文件主要是bootmgr和boot文件夹里面的文件，而boot文件夹里面的文件主要是bcd文件。

bcdedit：允许详细编辑BCD的条目。它是bcdboot的兄弟，也是微软出品，但是它的命令行比bcdboot复杂很多。
bootsect：还是是微软出品的程序，它比bcdboot还要简单，而且允许修复xp的引导。但是对UEFI的支持不好。
bootrec：过时了，不要用。
bootice：国产的处理引导的多功能软件，功能之一是编辑BCD条目。单文件体积小，合格的PE都会带；可惜有一段时间没有更新了。
EasyBCD：有名的国外的图形化编辑BCD和Grub的软件。不过我没用过。PE可能不自带，下载最新版需要注册，有点麻烦


## 引导区修复

bootrec /fixmbr用于修复Windows 7/10/11中的MBR。
bootrec /fixboot用于修复Windows 7/10/11中的引导扇区。
bootrec /scannos用于修复Windows 7/10/11缺少的bootmgr。
bootrec /rebuildbcd用于重建您的BCD并修复丢失的Windows系统文件。
bootsect.exe /nt60 all /force用于重建Windows引导扇区。其中：/nt60参数会修复与BOOTMGR兼容的主引导代码。/all参数会更新分区上的主引导代码。/force参数会在引导代码更新期间强制卸载卷，以便Bootsect.exe工具无法获得独占卷访问权限。


diskpart修复引导

diskpart
select disk 0
list volume
d:
cd boot
dir
bootsect /nt60 SYS /mbr


通过重命名重建BCD
1. 在命令提示符中，输入bcdedit /export C:\BCD_Backup以备份BCD。
2. 然后，在命令提示符中输入“notepad”。点击文件>打开>电脑，找到BCD文件并将其重命名为“BCD.old”，保存更改并退出此窗口。
3. 再次进入命令提示符。输入“bootrec /rebuildbcd”并按“回车”。输入“Yes”以确认。
4. 在窗口中输入“bcdedit /enum all”。然后，按“回车”。
5. 输入“exit”并重启电脑检查问题是否已被解决。

## MBR2GPT