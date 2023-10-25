# 编译内核过程

1. 安装内核源码 `dnf install -y kernel-source`
2. 安装编译依赖包： `dnf install -y rpm-build openssl-devel bc rsync gcc gcc-c++ flex bison m4 elfutils-libelf-devel dwarves make ncurses-devel`
3. 打补丁: `patch -d /usr/src/linux-4.19.90-2106.3.0.0095.oe1.x86_64 -p1 < patch_file`, 4.19版本支持vGPU补丁为[vfio/mdev: Add iommu related member in mdev_device](https://patchwork.kernel.org/project/kvm/patch/20190213040301.23021-8-baolu.lu@linux.intel.com/)。
4. 修改内核版本号，避免安装的时候版本冲突
```shell
#cd /usr/src/linux-4.19.90-2202.1.0.0136.oe1.x86_64/
#vi Makefile
VERSION = 4
PATHLEVEL = 19
SUBLEVEL = 91
EXTRAVERSION = 
NAME = "People's Front"
```
5. 编译config文件: `make openeuler_defconfig`, 该文件在`/usr/src/linux-4.19.90-2202.1.0.0136.oe1.x86_64/arch/x86/config` 目录下。
6. 编译内核：`make binrpm-pkg -j{num}`, -j 代表并发线程数量。
7. 编译后的软件包在`/root/rpmbuild/RPMS/x86_64`路径下。
8. 安装新版本的内核包： `rpm -ivh /root/rpmbuild/RPMS/x86_64/kernel-4.19.91-1.x86_64.rpm`。
9. 执行以下命令可以单独编译内核驱动： `make ARCH=x86_64 CONFIG_IGC=m drivers/net/ethernet/intel/igc/igc.ko`



## debug in gdb
```shell
virsh-edit your-virt-host-name
<qemu:commandline>
    <qemu:arg value='-s'/>
</qemu:commandline>
```


## loglevel
/etc/default/grub

loglevel=7