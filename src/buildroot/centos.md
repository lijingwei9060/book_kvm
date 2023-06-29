# build


参考下载地址：(http://vault.centos.org/7.6.1810/os/Source/SPackages/ ) wget https://vault.centos.org/7.6.1810/os/Source/SPackages/kernel-alt-4.14.0-115.el7a.0.1.src.rpm

groupadd mockbuild
useradd mockbuild -g mockbuild

安装依赖
yum -y install gcc bc gcc-c++ ncurses ncurses-devel cmake elfutils-libelf-devel openssl-devel

安装rpm包
rpm -ivh kernel-alt-4.14.0-115.el7a.0.1.src.rpm
安装完成后，rpm构建工程自动部署在
/root/rpmbuild/SPECS
/root/rpmbuild/SOURCES

进入内核版本解压目录
cd /root/rpmbuild/SOURCES
tar zvf linux-xxxxx.tar.gz
cd linux-xxxxx
清理内核源目录
make mrproper
make menuconfig
Kernel Features-->Page size (64KB)--> Page size (4KB) 保存 #Page size调整为4K。

注释.config文件中的参数CONFIG_SYSTEM_TRUSTED_KEYS
vim .config
在CONFIG_SYSTEM_TRUSTED_KEYS参数前面添加#，将参数这行注释掉
修改.config文件中的参数CONFIG_ARM64_VA_BITS。
vim .config
修改成下面参数
CONFIG_ARM64_VA_BITS_48=y
CONFIG_ARM64_VA_BITS=48
编译内核
make -j 64
make modules_install
make install
生成系统启动引导配置参数
grub2-mkconfig -o /boot/grub2/grub.cfg
从ibmc重启机器，选对应的操作系统s