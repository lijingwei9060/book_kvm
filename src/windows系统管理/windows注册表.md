# 概述
# HKEY_CLASSES_ROOT
## 主要功能
这个子树包含了所有应用程序运行时必需的信息；
在文件和应用程序之间所有的扩展名和关联所有的驱动程序名称。
类的ID数字（所要存取项的名字用数字来代替）用于应用程序和文件的图标；
在Windows用户图形界面下每件事、每个文件、每个目录、每个小程序、每个连接、每个驱动都被看做一个对象，每个对象都有确定的属性和它联系。HKCR包含着对象类型和他们属性的列表。
HKCR主要功能设置为；
一个对象类型和一个扩展名关联；
一个对象类型和一种图标关联；
一个对象类型和一个命令行动的关联。
定义对象类型相关菜单选项和没一个对象类型属性选项。
## 子键值
# HKEY_CURRENT_USER
## 主要功能
此根键（子树）中记录的是当前用户的配置数据信息，用户可以利用此根键下的子键修改Windows的许多环境配置。
## 重要主键
- AppEvents主键，包含了已注册了的各种应用事件。
- Console主键Windows2003控制台子系统存储设置，控制台子系统运行所有基于字符的应用程序。
- Control Panel主键，包含了与控制面板有关的内容。
- Environment主键，已登录用户表示环境变量的设置的数据项值。
- Identities它是当前用户的ID，但不是主要的ID。在HKEY_USERS中，每个用户都有唯一的ID。这与之相匹配。
- Keyboaed Layout储存安装键盘的布局信息，包含硬件和驱动器设置。
- Network仅当当前用户具有映像的网络磁盘时才存在。是父项，不保留重要数据。
- Printers在计算机打印机上的相关信息，包括用户设置的配置选项。
- Session Information包含当前会话中使用的与应用程序相关的信息。
- Software存储登录用户的特定应用程序用户设置和程序变量、
- Volatile Environment 当前用户会话设置。
# HKEY_LOCAL_MACHINE
## 主要功能
此根键保存与计算机、硬件、所安装的设备驱动器，以及影响所有计算机用户的配置选项（安全和软件设置）等相关信息。它包含了5个项。
## 重要主键
### HARDWARE Ntdetect.com（Windows 2003硬件识别程序）在启动过程中，从头开始建立这个项的内容。该信息保存在RAM中，子项的层次结构保存计算机所有的硬件组件信息。
- SAM 安全账户管理器，存储用户和数据组的地方，SAM数据由所有本地用户和组组成包括用户访问文件夹，文件以及外设的权限。
- SECURITY 有安全有关的数据项，保存安全策略和用户组策略的配置信息。
### SOFTWARE 操作系统在这里保存计算机设置，包括组策略配置生效的设置，所安装的软件、版本等等。
全局计算机配置，应先给所有扽故用户。和HKCU\Software类似。

- The key HKLM\CLASSES contains per-computer file associations. This key contains the vast majority of file associations, as opposed to HKCU\Classes, which contains per-user file associations. Windows merges both subkeys to form HKCR. Appendix A, “File Associations,” describes HKCR in detail.
- The key HKLM\SOFTWARE\Clients defines the client programs that Internet Explorer associates with different Internet services. You configure these clients on the Programs tab of the Internet Properties dialog box, shown in Figure D-2. For example, you can choose the mail client that Internet Explorer uses when you click a mailto link, or you can choose the news client to use when you click a news link. These choices also determine the programs that Internet Explorer launches when you choose one of the tools on the Tools menu.

- https://flylib.com/books/en/1.271.1.183/1/
- - Hkey_local_machine/software/microsoft/windows/currentVersion/explorer/user shell folders
- SYSTEM 控制操作系统的启动。几乎控制操作系统所做的每一件事（特别是内核服务），这是对计算机配置的正确性的方法。
https://flylib.com/books/en/1.271.1.185/1/
# HKEY_USER
## 主要功能
包含计算机默认用户的配置文件和已知用户的配置文件的子项。
## 重要主键
# HKEY_CURRENT_CONFIG
## 主要功能
保存计算机启动时所使用的与硬件配置文件相关信息。它是HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Hardware\Profiles\current的别名。
## 重要主键

# HKEY_DYN_DATA