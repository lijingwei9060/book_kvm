# 功能目标

1. IaC： 可以创建资源、管理资源
2. 脚本调用：正在运行的机器调用脚本
   1. 脚本兼容cloud init
   2. 支持变量
   3. 支持environmnet
   4. 第一个版本目标是类似于阿里云的oos、aws的ssm
   5. 支持key-value

## agent 状态

1. fleet管理：加入fleet就表示这个虚拟机加入了管理。配额
2. label管理：
   1. 从agent收集过来的label
   2. 用户自定义的label
3. agent：代表机器，可以是虚拟机、物理机
   1. DescribeAgentStatus： 版本、uptime



## 任务调用

Invode
Command



## OOS

```yaml
FormatVersion: OOS-2019-06-01
Description:
  en: Use this template to install sls agent on ecs
  zh-cn: 使用这个模板批量的在ECS安装日志服务插件
  name-en: ACS-ECS-BulkyInstallLogAgent
  name-zh-cn: 批量安装日志服务插件
  categories:
    - run_command
Parameters:
  regionId:
    Type: String
    Label:
      en: RegionId
      zh-cn: 地域ID
    AssociationProperty: RegionId
    Default: '{{ ACS::RegionId }}'
  action:
    Type: String
    Label:
      en: Action
      zh-cn: 操作类型
    AllowedValues:
      - install
      - upgrade
      - uninstall
    Default: install
  overwrite:
    Description:
      en: If logAgent exists in the instance, choose whether to overwrite LogAgent(Default no).
      zh-cn: 如果实例内存在logAgent时，选择是否覆盖LogAgent(默认不覆盖)
    Label:
      en: Overwrite
      zh-cn: 是否覆盖LogAgent
    Type: Boolean
    Default: false
  targets:
    Type: Json
    Label:
      en: TargetInstance
      zh-cn: 目标实例
    AssociationProperty: Targets
    AssociationPropertyMetadata:
      ResourceType: ALIYUN::ECS::Instance
      RegionId: regionId
  rateControl:
    Label:
      en: RateControl
      zh-cn: 任务执行的并发比率
    Type: Json
    AssociationProperty: RateControl
    Default:
      Mode: Concurrency
      MaxErrors: 0
      Concurrency: 10
  OOSAssumeRole:
    Label:
      en: OOSAssumeRole
      zh-cn: OOS扮演的RAM角色
    Type: String
    Default: ''
RamRole: '{{ OOSAssumeRole }}'
Tasks:
  - Name: getInstance
    Description:
      en: Views the ECS instances
      zh-cn: 获取ECS实例
    Action: ACS::SelectTargets
    Properties:
      ResourceType: ALIYUN::ECS::Instance
      RegionId: '{{ regionId }}'
      Filters:
        - '{{ targets }}'
    Outputs:
      instanceIds:
        Type: List
        ValueSelector: Instances.Instance[].InstanceId
      instanceInfos:
        Type: List
        ValueSelector: .Instances.Instance[] | {"osType":.OSType, "instanceId":.InstanceId}
  - Name: runCommand
    Action: ACS::ECS::RunCommand
    Properties:
      commandContent:
        Fn::If:
          - Fn::Equals:
              - Fn::Jq:
                  - First
                  - .|map(select(.instanceId == "{{ ACS::TaskLoopItem }}").osType)[]
                  - '{{ getInstance.instanceInfos }}'
              - linux
          - |-
            set -e
            installLogAgent(){
                message=`./logtail.sh install {{ regionId }} 2>/dev/null`
                if [ $? = 0 ]; then
                    cat /usr/local/ilogtail/app_info.json
                else
                    echo "$message"
                    exit 1
                fi
            }
            wget http://logtail-release-{{ regionId }}.oss-{{ regionId }}-internal.aliyuncs.com/linux64/logtail.sh -q -O logtail.sh;
            if [ $? != 0 ]; then
              echo "Failed to download logtail_installer, Please check your network service."
              exit 1
            fi
            chmod 755 logtail.sh;
            if [ "{{action}}" = "install" ]; then
                wetherOverwriteAgent="{{overwrite}}"
                if [ $wetherOverwriteAgent = "true" ]; then
                    installLogAgent
                else
                    logVersionPath="/usr/local/ilogtail/app_info.json"
                    if [ -f "$logVersionPath" ]; then
                        echo 'already has LogAgent'
                        exit 0
                    else
                        installLogAgent
                    fi
                fi
            elif [ "{{action}}" = "upgrade" ]; then
                message=`./logtail.sh upgrade 2>/dev/null`
                if [ $? = 0 ]; then
                  cat /usr/local/ilogtail/app_info.json
                else
                  echo "$message"
                  exit 1
                fi
            else
                ./logtail.sh uninstall
            fi
          - |-
            function installLogAgent
            {
                .\logtail_installer.exe install {{ regionId }}
                if (! $?)
                 {
                   echo "Failed to install install log and to start log service Failed, please try again."
                   exit 1
                 }
                echo 'Install complete'
            }

            $action="{{ action }}"

            $pathExistOrNot = Test-Path -Path "C:\Users\Administrator\OOSPackages"
            if ($pathExistOrNot)
            {
              cd C:\Users\Administrator\OOSPackages
            } else
            {
              mkdir C:\Users\Administrator\OOSPackages
              cd C:\Users\Administrator\OOSPackages
              echo 'File created'
            }

            $client = new-object System.Net.WebClient
            $client.DownloadFile('http://logtail-release-{{ regionId }}.oss-{{ regionId }}-internal.aliyuncs.com/win/logtail_installer.zip', 'C:\Users\Administrator\OOSPackages\logtail_installer.zip')
            if (! $?)
            {
              echo "Failed to download logtail_installer, Please check your network service."
              exit 1
            }
            Expand-Archive -Force -Path C:\Users\Administrator\OOSPackages\logtail_installer.zip -DestinationPath C:\Users\Administrator\OOSPackages
            switch($action)
            {
                "install" {
                    $wetherOverwriteAgent = "{{overwrite}}"

                    if ($wetherOverwriteAgent -eq "true")
                    {
                        installLogAgent
                    } else
                    {
                        if ([Environment]::Is64BitOperatingSystem)
                        {
                            $logAgentPath = Test-Path -Path "C:\Program Files (x86)\Alibaba\Logtail"
                            if ($logAgentPath)
                            {
                                echo 'already has LogAgent'
                                exit 0
                            } else
                            {
                                installLogAgent
                            }
                        } else
                        {
                            $logAgentPath = Test-Path -Path "C:\Program Files\Alibaba\Logtail"
                            if ($logAgentPath)
                            {
                                echo 'already has LogAgent'
                            } else
                            {
                                installLogAgent
                            }
                        }
                    }

                }
                "upgrade" {
                    .\logtail_installer.exe uninstall
                    .\logtail_installer.exe install {{ regionId }}
                    echo 'upgrade complete'
                }
                "uninstall" {
                    .\logtail_installer.exe uninstall
                    echo 'uninstall complete'
                }
            }
            $allFile = Get-ChildItem -Path "C:\Users\Administrator\OOSPackages"
            foreach($file in $allFile)
            {
              Remove-Item $file.FullName -Recurse -Force
            }
            cd ..
            del C:\Users\Administrator\OOSPackages
      instanceId: '{{ ACS::TaskLoopItem }}'
      regionId: '{{ regionId }}'
      commandType:
        Fn::If:
          - Fn::Equals:
              - Fn::Jq:
                  - First
                  - .|map(select(.instanceId == "{{ ACS::TaskLoopItem }}").osType)[]
                  - '{{ getInstance.instanceInfos }}'
              - linux
          - RunShellScript
          - RunPowerShellScript
    Loop:
      Items: '{{ getInstance.instanceIds }}'
      RateControl: '{{ rateControl }}'
      Outputs:
        commandOutputs:
          AggregateType: Fn::ListJoin
          AggregateField: commandOutput
    Outputs:
      commandOutput:
        Type: String
        ValueSelector: invocationOutput
Outputs:
  commandOutput:
    Type: String
    Value: '{{ runCommand.commandOutputs }}'
Metadata:
  ALIYUN::OOS::Interface:
    ParameterGroups:
      - Parameters:
          - action
          - overwrite
        Label:
          default:
            zh-cn: 设置参数
            en: Configure Parameters
      - Parameters:
          - regionId
          - targets
        Label:
          default:
            zh-cn: 选择实例
            en: Select Ecs Instances
      - Parameters:
          - rateControl
          - OOSAssumeRole
        Label:
          default:
            zh-cn: 高级选项
            en: Control Options

```