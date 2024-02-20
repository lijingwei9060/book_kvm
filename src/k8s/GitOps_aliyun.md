# GitOps 

1. ACK One舰队的Fleet实例托管了ArgoCD,提供ArgoCD原生CLI和UI体验,集成阿里云账号SSO登录，支持ArgoCD多用户权限设置
2. 集成ACK One多集群能力
3. 应用的高可用部署、系统组件多集群分发
## 功能

- repo管理： helm、git
- 应用管理： 拓扑、列表、更新、回滚
- ApplicationSet用于简化多集群应用编排： 它可以基于单一应用编排并根据用户的编排内容自动生成一个或多个Application。
- 多集群管理： ack one fleet
- Velero实现集群中应用（资源YAML）的备份和恢复
- OpenKruise是阿里云开源的云原生应用自动化引擎，也是阿里巴巴经济体上云全面使用的部署基座，已正式加入CNCF Sandbox。OpenKruise包含了多种自定义Workload，用于无状态应用、有状态应用、Sidecar容器、Daemon应用等部署管理，提供了原地升级、灰度发布、流式发布、发布优先级等策略。
- ack-helm-manager是一个帮您管理存储在ACR EE上自定义Chart的组件，当您需要安装储存在ACR EE上的自定义Chart时，需要安装此组件
- Knative是基于K8s提供的一款开源Serverless应用框架，其目标是制定云原生、跨平台的Serverless容器编排标准，帮助您部署和管理现代化的Serverless工作负载，打造企业级Serverless容器平台。