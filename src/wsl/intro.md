# install  wsl


wsl --update



## bpf config

git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
git checkout linux-msft-wsl-6.1.21.2


sudo apt install flex bc bison build-essential libelf-dev libncurses-dev  libssl-dev
sudo apt install dwarves

```shell
# Path: $HOME/WSL2-Linux-Kernel
vi Microsoft/config-wsl

# Enable the Kernel modules based on https://docs.cilium.io/en/v1.12/operations/system_requirements/

## Base requirements
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_NET_CLS_BPF=y
CONFIG_BPF_JIT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_BPF=y

## Iptables-based Masquerading
CONFIG_NETFILTER_XT_SET=m
CONFIG_IP_SET=m
CONFIG_IP_SET_HASH_IP=m

## L7 and FQDN Policies
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m

## IPsec
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_AES=m
```

make KCONFIG_CONFIG=Microsoft/config-wsl
sudo make headers_install
sudo make modules_install



# Path: $HOME/WSL2-Linux-Kernel
# [Optional] Create a Kernel directory on Windows filesystem
mkdir /mnt/c/wslkernel

# Copy the compiled Kernel
cp arch/x86_64/boot/bzImage /mnt/c/wslkernel



# Powershell
wsl --shutdown

Create/Update the $env:USERPROFILE/.wslconfig

# Set the Kernel path
[wsl2]
kernel = c:\\wslkernel\\bzImage


# Add the filesystem to the FSTAB file
sudo vi /etc/fstab

## Add the following line
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=700 0 0

# Check if the file has been successfully saved
cat /etc/fstab

# Mount all the filesystems present in FSTAB
sudo mount -a

# Check if the BPF filesystem is correctly mounted
mount | grep bpf
sudo mount -t debugfs debugfs /sys/kernel/debug

vim /etc/wsl.conf
[boot]
systemd=true


## enable systemd

# Create a file to load the modules when the distro boots
## The first line of the modules.alias file is ignored as it's the header "Alias"
awk '(NR>1) { print $2 }' /usr/lib/modules/$(uname -r)/modules.alias | sudo tee /etc/modules-load.d/bpf.conf

wsl --shutdown
wsl --update

vim /etc/wsl.conf
[boot]
systemd=true


# By default, the systemd-modules-load service fails due to the conditions not met
sudo systemctl status systemd-modules-load

# Edit the service and comment the conditions line from the "!container"
sudo vi /lib/systemd/system/systemd-modules-load.service
...
#ConditionVirtualization=!container
#ConditionDirectoryNotEmpty=|/lib/modules-load.d
#ConditionDirectoryNotEmpty=|/usr/lib/modules-load.d
#ConditionDirectoryNotEmpty=|/usr/local/lib/modules-load.d
#ConditionDirectoryNotEmpty=|/etc/modules-load.d
#ConditionDirectoryNotEmpty=|/run/modules-load.d
#ConditionKernelCommandLine=|modules-load
#ConditionKernelCommandLine=|rd.modules-load
...

# Reload the systemD daemon
sudo systemctl daemon-reload

# Restart the systemd-modules-load service
sudo systemctl restart systemd-modules-load

sudo lsmod 


## install bpftool

git clone --recurse-submodules https://github.com/libbpf/bpftool.git
cd bpftool/src
sudo make install

```shell
casoul@casoul:~/workspace/bpftool/src$ sudo bpftool prog list
51: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
52: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
53: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
54: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
55: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
56: cgroup_skb  tag 6deef7357e7b4530  gpl
        loaded_at 2024-03-17T18:10:28+0800  uid 0
        xlated 64B  jited 54B  memlock 4096B
```



## remove windows path

```shell
$ sudo vi /etc/wsl.conf

[interop]
appendWindowsPath = false

$ exit
c:\Users\user> wsl --shutdown
c:\Users\user wsl

$ echo $PATH
```


## enable localhost proxy

在windows系统的%userprofile%创建文件.wslconfig, 保存后重启wsl服务

```shell
#vim .wslconfig
[experimental]
autoMemoryReclaim=gradual # 开启自动回收内存，可在 gradual, dropcache, disabled 之间选择
networkingMode=mirrored # 开启镜像网络
dnsTunneling=true # 开启 DNS Tunneling
firewall=true # 开启 Windows 防火墙
autoProxy=true # 开启自动同步代理
sparseVhd=true # 开启自动释放 WSL2 虚拟硬盘空间


```