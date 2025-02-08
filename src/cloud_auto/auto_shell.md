# 目标
目标是做一个应用自动化部署，兼容虚拟机、容器


## 阿里云

客户端：云助手
安全中心agent
qga

oos： 

虚拟机客户端： https://github.com/aliyun/aliyun_assist_client， golang
模板中心： ROS资源编排
支持： terraform

功能： 
1. 每日0点扫描实例以查找缺少的补丁
2. 每 1小时从实例中收集一次配置清单
   1. 应用程序：应用程序名称、发布者和版本等。
   2. 网络配置：IP地址、MAC地址、DNS、网关、子网掩码等。
   3. 服务：名称、显示名称、状态、相关服务、服务类型、启动类型等。
   4. Windows 角色：名称、显示名称、路径、功能类型、安装状态等（仅限 Windows Server 节点）。
   5. Windows 更新：补丁 ID、安装者、安装日期等（仅限 Windows Server 节点）。
   6. 实例详细信息：系统名称、操作系统名称、操作系统版本、DNS、域名和操作系统等。
3. 定时开关机
4. 发送运维脚本
5. 从云平台上传文件到ECS实例中，小于24KB文件，文件发送API SendFile, DescribeSendFileResults
   1. 来源： 本地文件、OSS文件、HTTPs文件(需要访问到)
6. 执行命令：
   1. shell、python、perl、bat、powershell
   2. 参数： {{key}}
      1. {{ACS::RegionId}}：地域ID。
      2. {{ACS::AccountId}}：阿里云主账号UID。
      3. {{ACS::InstanceId}}：实例ID。
      4. {{ACS::InstanceName}}：实例名称。
      5. {{ACS::InvokeId}}：命令执行ID。
      6. {{ACS::CommandId}} ：命令ID。
   3. 启动： 立即、下一次启动、系统每次启动、定时执行、指定时间、cron
   4. 用户： root、system
7. session manager
8. 关机和重启， exit代码
   1. Linux 193、194
   2. windows 3009、3010
9. 容器
10. 接口： RunCommand/InvodeCommand
    1.  DescribeCloudAssistantStatus: 云助手首次心跳事件
    2.  云助手首次心跳事件：ecs:CloudAssistant:FirstHeartbeat
    3.  云助手任务状态事件：ecs:CloudAssistant:TaskCompleted

环境上下文： 
不会加载/etc/profile、~/.bash_profile、~/.bashrc等启动文件
```shell
export HOME="/root"
export INVOCATION_ID="0828f2e5b64b4a96****"
export JOURNAL_STREAM="8:23203"
export LANG="en_US.UTF-8"
export OLDPWD
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PWD="/root"
export SHLVL="2"
export TERM="vt220"
export _="/usr/local/share/aliyun-assist/2.2.3.221/../work/script/t-xx.sh"
```
## 华为云
codearts




## terraform

cloud_init



## 腾讯云


客户端： https://github.com/Tencent/tat-agent， rust
可执行： Shell, PowerShell, Python. 

## Nitric 

The cloud aware application framework

## aws

https://github.com/aws/amazon-ssm-agent



## Pulumi 

[pulumi](https://www.pulumi.com/)



## IaC


[Spacelift： The Most Flexible IaC Management Platform ](https://spacelift.io/) is a sophisticated CI/CD platform for OpenTofu, Terraform, Terragrunt, CloudFormation, Pulumi, Kubernetes, and Ansible

[vcs-agent](https://github.com/spacelift-io/vcs-agent)



https://kestra.io/

## OpenTofu 

The open source infrastructure as code tool. Previously named OpenTF, [OpenTofu](https://opentofu.org/) is a fork of Terraform that is open-source, community-driven, and managed by the Linux Foundation.


## Semaphore UI

[Modern UI](https://semaphoreui.com/) for Ansible Terraform OpenTofu Bash Docker PowerShell 