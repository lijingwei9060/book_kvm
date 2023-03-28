# windows引导文件

## EFI系统分区 ESP(EFI system map)
ESP要格式化成FAT32, EFI启动文件要放在\EFI\<厂商>文件夹下面。比如Windows的UEFI启动文件，都在\EFI\Microsoft下面; 比如Ubuntu的UEFI启动文件，都在\EFI\ubuntu下面。\EFI\Boot文件夹中存放要启动的efi文件，无论是\EFI\Microsoft\Boot\Bootmgfw.efi，还是\EFI\ubuntu\grubx64.efi，只要放到\EFI\Boot下并且改名bootX64.efi，就能在没添加文件启动项的情况下，默认加载对应的系统。UEFI固件可从ESP加载EFI启动程式或者EFI应用程序。

UEFI引导过程：上电–>UEFI–>GPT分区表–>EFI系统分区（esp）–>\EFI\Microsoft\Boot\bootmgfw.efi(EFI\Boot\Bootx64.efi)–>\EFI\Microsoft\Boot\BCD→\Windows\system32\winload.efi。
MBR引导过程： 上电–>MBR–>PBR–>NTLDR(XP)/bootmgr(WIN7/Vista)/grldr(Grub)/btldr.mbr(BootLink)/boot\bcd–>\Windows\system32\winload.exe

bootmgr、ntldr：前者用于windows NT6内核（vista之后）系统的引导，后者用于windows NT5内核（xp、2003、2000）系统的引导，且这两者都是以实体文件的形式存在于激活主分区上。 以windows10系统为例，bootmgr存在于系统盘下的"Windows\Boot\PCAT"文件夹中。 

bootmgfw.efi和Bootx64.efi：这两个文件都可以实现windows系统的引导。其中bootmgfw.efi位于ESP分区下"EFI\Microsoft\boot\"文件夹下，该文件为windows系统专用引导文件，一般会写进“Windows Boot Manager”启动项里；而Bootx64.efi位于ESP分区下“EFI\Boot\”文件夹下，一般会写进硬盘启动项里。这两个文件只要有其一就可以引导windows系统，而Bootx64.efi文件的作用和权限更大，它还可以引导非windows系统。bootmgfw.efi如果损坏或丢失，可以从系统盘目录下的“Windows\Boot\PCAT”文件夹中找回。bootx64.efi则位于windows安装镜像中的“efi\boot”文件夹下。

## NTLDR(XP)引导
NTLDR一般存放于C盘根目录下，是一个具有隐藏和只读属性的系统文件。它的主要职责是解析Boot.ini文件。如果你对它的理解还不是很清楚，那么下面我们就以Windows XP为例介绍NTLDR在系统引导过程中的作用。 Windows XP在引导过程中将经历预引导、引导和加载内核三个阶段，这与Windows 9X直接读取引导扇区的方式来启动系统是完全不一样的，NTLDR在这三个阶段的引导过程中将起到至关重要的作用。

在预引导阶段里计算机所做的工作有：运行POST程序，POST将检测系统的总内存以及其他硬件设备的状况，将磁盘第一个物理扇区加载到内存，加载硬盘主引导记录并运行，主引导记录会查找活动分区的起始位置。接着活动分区的引导扇区被加载并执行，最后从引导扇区加载并初始化NTLDR文件。

在引导阶段中，Windows XP将会依次经历初始引导加载器阶段、操作系统选择阶段、硬件检测阶段以及配置选择阶段这四个小的阶段。
- 在初始引导加载器阶段中，NTLDR将把计算机的微处理器从实模式转换为32位平面内存模式，在实模式中，系统会为MS－DOS预留640KB大小的内存空间，其余的内存都被看做是扩展内存，在32位平面模式中系统将所有内存都视为可用内存，然后NTLDR执行适当的小型文件系统驱动程序，这时NTLDR可以识别每一个用NTFS或FAT格式的文件系统分区，至此初始引导加载器阶段结束。
- 当初始引导加载器阶段结束后将会进入操作系统选择阶段，如果计算机上安装了多个操作系统，由于NTLDR加载了正确的Boot.ini文件，那么在启动的时候将会出现要求选择操作系统的菜单，NTLDR正是从boot.ini文件中查找到系统文件的分区位置。如果选择了NT系统，那么NTLDR将会运行NTDETECT.COM文件，否则NTLDR将加载BOOTSECT.DOS，然后将控制权交给BOOTSECT.DOS。如果Boot.ini文件中只有一个操作系统或者其中的timeout值为0，那么将不会出现选择操作系统的菜单画面，如果Boot.ini文件非法或不存在，那么NTLDR将会尝试从默认系统卷启动系统。
小提示：NTLDR启动后，如果在系统根目录下发现有Hiberfil.sys文件且该文件有效，那么NTLDR将读取Hiberfil.sys文件里的信息并让系统恢复到休眠以前的状态，这时并不处理Boot.ini文件。
- 当操作系统选择阶段结束后将会进入硬件检测阶段，这时NTDETECT.COM文件将会收集计算机中硬件信息列表，然后将列表返回到NTLDR，这样NTLDR将把这些硬件信息加载到注册表“HKEY_LOCAL_MACHINE”中的Hardware中。
- 硬件检测阶段结束后将会进入配置选择阶段，如果有多个硬件配置列表，那么将会出现配置文件选择菜单，如果只有一个则不会显示。

在加载内核阶段中，NTLDR将加载NTOKRNL.EXE内核程序，然后NTLDR将加载硬件抽象层(HAL.dll)，接着系统将加载注册表中的“HKEY_MACHINESystem”键值，这时NTLDR将读取“HKEY_MACHINESystemselect”键值来决定哪一个ControlSet将被加载。所加载的ControlSet将包含设备的驱动程序以及需要加载的服务。再接着NTLDR加载注册表“HKEY_LOCAL_MACHINESystemservice”下的start键值为0的底层设备驱动。当ControlSet的镜像CurrentControlSet被加载时，NTLDR将把控制权传递给NTOSKRNL.EXE，至此引导过程将结束。小提示：如果在启动的时候按F8键，那么我们将会在启动菜单中看到多种选择启动模式，这时NTLDR将根据用户的选择来使用启动参数加载NT内核，用户也可以在Boot.ini文件里设置启动参数。“BOOT.INI”文件会在已经安装了Windows NT/2000/XP的操作系统的所在分区，一般默认为C:下面存在。但是它默认具有隐藏和系统属性，所以你要设置你的文件夹选项，以便把“BOOT.INI”文件显示出来。我们可以用任何一种文本编辑器来打开他它。一般情况下，它的内容如下:
```text
timeout=30
default=multi(0)disk(0)rdisk(0)partition(1)Windows
[operating systems]
multi(0)disk(0)rdisk(0)partition(1)Windows="Microsoft Windows XP Professional" /fastdetect
```
在Windows 2000或者是XP系统中，我们可以很容易的设置“BOOT.INI”文件。那就是在“我的电脑”上面点击右键，选择“属性”打开“系统属性”对话框，再点击“高级”选项卡，在“启动和故障修复”里面点击“设置”按钮，就可以打开“启动和故障修复”对话框了，在这里面我们就可以对它进行详细设置。

# BCD文件

对于MBR引导，BCD文件位于激活主分区下的“Boot”文件夹；对于UEFI引导，BCD文件位于ESP分区下的“EFI\Microsoft\boot\”文件夹；BCD文件如果丢失，可以从系统盘下的“Windows\Boot\DVD”下找回，也可以直接使用第三方修复工具新建bcd文件。	

BCDBOOT <source> [/l <locale>] [/s <volume-letter> [/f <firmware type>]] [/v] [/m [{OS Loader GUID}]] [/addlast or /p] [/d] [/c]

- <source> location of windows directory  for copying boot-environment files;
- /l locale, species the locale, default is en-US
- /s <volume-letter> system partition,UEFI:copy boot files, create bcd store, **not** create  a boot manager menu in NVRM 
- /f <firmware>: 固件类型，UEFI、bios、all
- /v verbose
- /m [{OS loader GUID}], merge the values from an existing entry into a new entry;
- /addlast, 在最后位置添加引导记录
- /p 在最前面添加引导记录
- /d 保留现有的OS引导记录
- /c 保留现有的BCD元素

- `bcdboot C:\windows /s G: /f UEFI`
- Recreate the BCD using the bcdboot command: `Bcdboot C:\Windows /l en-us /s x: /f ALL`

## BCDEdit： Boot Configuration Data的管理工具

- 操作store
- 操作记录
- 修改entry选项
- 控制输出
- 控制boot manager
- emergency management service选项
- debug

## bootsec: 
用于xp以后mbr的管理

# PE
## oscdimg： 创建winpe文件
