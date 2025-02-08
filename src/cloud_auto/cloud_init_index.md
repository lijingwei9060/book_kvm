# 特点

1. 无代理设计：Cloud-init 采用无代理设计，不需要在实例中运行长期驻留的代理进程。这种设计简化了系统架构，减少了资源占用和潜在的安全风险。
2. 基于云元数据的初始化：Cloud-init 利用云服务提供的元数据服务，在实例启动时获取必要的配置信息。元数据通常包含实例的网络配置、用户数据脚本、公钥等，Cloud-init 通过读取这些元数据进行相应的配置操作。
3. 支持多种云平台：Cloud-init 支持广泛的云平台，包括但不限于：Amazon Web Services (AWS)、Microsoft Azure、Google Cloud Platform (GCP)、OpenStack、Oracle Cloud Infrastructure (OCI)、DigitalOcean。


## 模块

1. config
   1. data source
   2. handlers
   3. modules
   4. init config
2. boot
   1. read metadata
   2. write files
3. init： 
   1. install packages
4. final
   1. run command


## 配置实例

```yaml
#cloud-config
 
# 1. 定义用户和其相关配置
# 配置了一个名为 `ubuntu` 的用户，并设置了 SSH 公钥、sudo 权限和 shell。
users:
  - name: ubuntu
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr...  # 用户的 SSH 公钥
    shell: /bin/bash
 
# 2. 配置网络设置
# 启用了 DHCP 以自动获取 IP 地址。
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
 
# 3. 配置系统包更新和升级选项
# 启用了系统包更新和升级。
package_update: true
package_upgrade: true
 
# 4. 配置 apt 包管理器的相关选项
apt:
  sources:
    my_ppa:
      source: "ppa:my/ppa"
  preserve_sources_list: false
 
# 5. 配置 snap 包管理器的相关选项
snappy:
  snaps:
    - name: core
      channel: stable
    - name: docker
      channel: stable
 
# 6. 创建或修改两个文件
write_files:
  - path: /etc/myconfig.conf
    content: |
      This is my config file
  - path: /etc/motd
    content: |
      Welcome to my custom server!
 
# 7. 在实例引导过程中运行命令
bootcmd:
  - echo 'Booting...'
  - mkdir -p /etc/mydir
 
# 8. 在实例初始化过程中运行自定义命令
runcmd:
  - echo 'Hello, world!'
  - [ cloud-init, status, --wait ]
 
# 9. 配置系统的语言环境（locale）
locale: en_US.UTF-8
 
# 10. 配置系统时区
timezone: America/New_York
 
# 11. 配置 NTP（网络时间协议）服务
ntp:
  servers:
    - ntp.ubuntu.com
    - ntp.ubuntu.net
 
# 12. 配置用户的 SSH 公钥，用于无密码登录
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr...
 
# 13. 配置根文件系统自动扩展
resize_rootfs: true
 
# 14. 配置在 Cloud-init 最终阶段运行的模块
cloud_final_modules:
  - [scripts-user]
  - [phone-home, service]
 
# 15. 配置实例初始化完成后发送通知
phone_home:
  url: http://example.com/phone_home
  post:
    - instance_id
    - hostname
```