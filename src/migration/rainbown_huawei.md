
# 支持
vmware vsphere 5.1、5.5、6.0、6.5
hyperv 2008、/012

Windows采用块级迁移和同步: VSS卷影副本技术+ NTFS文件系统
1. 对目的虚拟机进行分区和格式化。
2. 源端启动扇区追踪程序，记录变化的扇区，在内存中生成变化扇区追踪表。从源端获取NTFS文件系统中的bitmap文件内容，通过bitmap识别有效扇区，同时开启一个监听进程，追踪变化的扇区，在内存中生成变化扇区追踪表。
3. 通过bitmap文件内容，复制已使用扇区数据。扇区数据复制完成后，会对系统做一次快照，快照完毕，数据复制任务结束。先对源端分区制作快照，根据第2步产生的变化扇区追踪表的记录，从快照中复制自迁移开始到分区快照之间的变化扇区到目的端，制作快照时，会新开始一个扇区追踪表用于追踪分区快照之后的变化扇区，用户后期同步。
4. 修改Windows启动配置项：修改注册表，磁盘驱动，鼠标键盘驱动，设置活动分区，boot.ini/BCD文件等，重启目的端虚拟机

Windows2003系统关键文件缺失intelide.sys;pciidex.sys，从其他同版本主机中复制文件到%SystemRoot%\System32\Drivers

PV Driver
1. 务必先卸载其他虚拟平台的VM TOOL，再安装PV Driver。特别是从Citrix平台迁移过来的虚拟机。
2. 对于手动迁移的虚拟机，请确保FusionCompute中设置虚拟机操作系统类型跟虚拟机实际运行的操作系统一致，否则挂载的PV Driver不正确。
3. Windows PV Driver依赖于VBS运行环境，如果VBS组件损坏，在目的虚拟机中，点开始->运行"regsvr32 %windir%\system32\WSHom.Ocx"修复。
4. Windows PV Driver依赖WMI组件，如果WMI组件损坏，请先参考微软网站修复WMI组件。
5. Windows系统如果安装PV Driver过程中意外终止或者异常，切勿直接重启虚拟机，可能会导致蓝屏。需从光盘中运行“X:\UpgradeDir\Windows\XXX\uninstall.vbs”卸载脚本，然后重启，再重新安装PV Driver。
6. 确保迁移的系统是目的虚拟机平台支持的系统，否则无对应的PV Driver安装包。
7. 有少量Linux系统平台支持，但需要替换内核才能安装PV Driver。详细清单请参考FusionSphere帮助文档。
8. 安装PV Driver异常或者安装PV Driver后系统不能启动，请联系华为技术支持。


Linux文件级迁移和同步：
1、目的端磁盘分区格式化，卸载目的端所有分区、目的端磁盘分区、目的端分区格式化
用Linux image镜像创建并启动目的VM。根据源端分区对目的VM进行分区并格式化。
对目的端VM分区格式化经过以下几个步骤（以磁盘类型为MBR为例）：
通过脚本DelLvmAmdSwap.sh卸载目的端所有分区，最后卸载/mnt/root，因为目的端的root和boot分区可能挂载到此。
根据源端系统固件类型和目的端磁盘大小，将目的端磁盘转换成MBR或GPT磁盘（根据具体情况），并对其进行分区并格式化。
注意：如果存在LVM分区，还需要先创建LV，因为在上一步进行分区的时候只是将分区类型转换成LVM，并没有创建PV、VG、LV的过程。