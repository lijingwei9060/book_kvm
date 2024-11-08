#
## 模块列表

- Registrar
- CredentialRefresher
- EC2Identity
- EC2RoleProvider
- amazon-ssm-agent
- ssm-document-worker
- ssm-agent-worker 
  - StartupProcessor
  - MessageService
  - LongRunningPluginsManager
  - HealthCheck
  - Core Agent termination channel
  - Core Agent health channel、



## StartupProcessor

linux：  获取ec2metadata，获取到就执行初始化工作，当前只有向串口写信息。
windows： 版本检查、ec2环境，向串口写信息：agent版本、os版本、驱动版本、bugcheck，需要powershell

## ssm-agent-worker

bookeeing folder： /var/lib/amazon/ssm/${short_instance_id}/document/state/{pending, current, completed, corrupt}
/var/lib/amazon/ssm/
/var/lib/amazon/ec2config/
/var/lib/amazon/ec2configservice/
/var/log/amazon/ssm/download
/etc/amazon/ssm/


CoreManager: 包含核心模块的启动、关闭、配置等逻辑管理

核心模块ICoreModule：
1. HealthCheck, 非容器模式下
2. MessageService： 支持MDS或者MGS消息解析
3. OfflineService： 离线文档处理
4. LongRunningPluginsManager： 长时运行命令管理

工作插件：
1. CloudWatchPublisher： 
2. aws:cloudWatch： 
3. aws:runPowerShellScript
4. aws:updateSsmAgent
5. aws:configureContainers
6. aws:runDockerAction
7. aws:refreshAssociation
8. aws:configurePackage
9. aws:downloadContent
10. aws:runDocument
11. aws:runShellScript
12. aws:domainJoin

工作逻辑就是New，Start和Stop。




### IHealthCheck 模块

这个模块还和hibernation相关，Agent 为active就可以Start，退出loop。

1. ssmconnectionchannel.GetConnectionChannel()
2. service.UpdateInstanceInformation() // 设置版本、Active ，周期运行，不超过5分钟。
3. 如果不健康，重新生成这个服务模块，增加ResetErrorCount



## Out of Proc Worker： 分割成另外一个进程执行document

避免脚本产生的问题导致进程异常，优先这种模式。


## IRegisterManager 注册管理器

1. 调用命令注册 amazon-ssm-agent -register -y -region region -code activation_code -id activeation_id
2. 启动agent

注册过程： 
1. generating signing keys： registration.GenerateKeyPair()
2. generate fingerprint： registration.Fingerprint(log)
3. 调用服务注册： service.RegisterManagedInstance(),返回 managedInstanceID
4. 上传服务器信息： registration.UpdateServerInfo()
5. 写入本地注册文件： registration
6. 退出进程

问题： 
1. 如何指定endpoint地址? 通过/etc/amazon/ssm/amazon-ssm-agent.json修改endpoint