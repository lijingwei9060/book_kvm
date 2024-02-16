# 社区版

组成模块：

1. KubeKey：  Go 语言开发的一款全新的安装工具，代替了以前基于 ansible 的安装程序。KubeKey 为用户提供了灵活的安装选择，可以分别安装 KubeSphere 和 Kubernetes 或二者同时安装，既方便又高效。

功能模块：
1. 运行时： containerd， Docker > 19.3.8, iSula, CRI-O
2. 支持的 CNI 插件：Calico 和 Flannel。其他插件也适用（例如 Cilium 和 Kube-OVN 等）
3. OpenEbs： Kubernetes storage simplified， OpenEBS turns any storage available to Kubernetes worker nodes into Local or Distributed Kubernetes Persistent Volumes. OpenEBS helps Application and Platform teams easily deploy Kubernetes Stateful Workloads that require fast and highly durable, reliable and scalable Container Attached Storage.OpenEBS is also a leading choice for NVMe based storage deployments.OpenEBS was originally built by MayaData and donated to the Cloud Native Computing Foundation and is now a CNCF sandbox project.
4. KubeSphere 应用商店：  在 OpenPitrix 的基础上，为用户提供了一个基于 Helm 的应用商店，用于应用生命周期管理。整个生命周期管理应用，包括提交、审核、测试、发布、升级和下架。包含的内置应用： etcd、harbor、memcached、minio、mongodb、mysql、ningx、postgresql、rabbitmq、tomcat、randonDB mysql、randonDB Postgresql、chaos mesh、gitlab、tidb、metersphere、randonDB clickHouse、randonDb mysql operator
5. KubeSphere DevOps： 基于 Jenkins 的 KubeSphere DevOps 系统是专为 Kubernetes 中的 CI/CD 工作流设计的，它提供了一站式的解决方案，帮助开发和运维团队用非常简单的方式构建、测试和发布应用到 Kubernetes。它还具有插件管理、Binary-to-Image (B2I)、Source-to-Image (S2I)、代码依赖缓存、代码质量分析、流水线日志等功能。
6. KubeSphere 日志系统： KubeSphere 基于租户的日志系统中，每个租户只能查看自己的日志，从而可以在租户之间提供更好的隔离性和安全性。除了 KubeSphere 自身的日志系统，该容器平台还允许用户添加第三方日志收集器，如 Elasticsearch、Kafka 和 Fluentd。
7. KubeSphere 审计日志： KubeSphere 审计日志系统提供了一套与安全相关并按时间顺序排列的记录，按顺序记录了与单个用户、管理人员或系统其他组件相关的活动。对 KubeSphere 的每个请求都会生成一个事件，然后写入 Webhook，并根据一定的规则进行处理。
8. KubeSphere 事件系统： KubeSphere 事件系统使用户能够跟踪集群内部发生的事件，例如节点调度状态和镜像拉取结果。这些事件会被准确记录下来，并在 Web 控制台中显示具体的原因、状态和信息。要查询事件，用户可以快速启动 Web 工具箱，在搜索栏中输入相关信息，并有不同的过滤器（如关键字和项目）可供选择。事件也可以归档到第三方工具，例如 Elasticsearch、Kafka 或 Fluentd。
9.  KubeSphere 告警系统： KubeSphere 中的告警系统与其主动式故障通知 (Proactive Failure Notification) 系统相结合，使用户可以基于告警策略了解感兴趣的活动。当达到某个指标的预定义阈值时，会向预先配置的收件人发出告警。因此，您需要预先配置通知方式，包括邮件、Slack、钉钉、企业微信和 Webhook。有了功能强大的告警和通知系统，您就可以迅速发现并提前解决潜在问题，避免您的业务受影响。
10. KubeSphere 服务网格： KubeSphere 服务网格基于 Istio，将微服务治理和流量管理可视化。它拥有强大的工具包，包括熔断机制、蓝绿部署、金丝雀发布、流量镜像、链路追踪、可观测性和流量控制等。KubeSphere 服务网格支持代码无侵入的微服务治理，帮助开发者快速上手，Istio 的学习曲线也极大降低。KubeSphere 服务网格的所有功能都旨在满足用户的业务需求。
11. 网络策略： 网络策略是一种以应用为中心的结构，使您能够指定如何允许容器组通过网络与各种网络实体进行通信。通过网络策略，用户可以在同一集群内实现网络隔离，这意味着可以在某些实例（容器组）之间设置防火墙。在启用之前，请确保集群使用的 CNI 网络插件支持网络策略。支持网络策略的 CNI 网络插件有很多，包括 Calico、Cilium、Kube-router、Romana 和 Weave Net 等。建议您在启用网络策略之前，使用 Calico 作为 CNI 插件。
12. Metrics Server： 在 KubeSphere 中，Metrics Server 控制着 HPA 是否启用。您可以根据不同类型的指标（例如 CPU 和内存使用率，以及最小和最大副本数），使用 HPA 对象对部署 (Deployment) 自动伸缩。通过这种方式，HPA 可以帮助确保您的应用程序在不同情况下都能平稳、一致地运行。
13. 服务拓扑图： 启用服务拓扑图以集成 Weave Scope（Docker 和 Kubernetes 的可视化和监控工具）。Weave Scope 使用既定的 API 收集信息，为应用和容器构建拓扑图。服务拓扑图显示在您的项目中，将服务之间的连接关系可视化。
14. 容器组 IP 池： 容器组 IP 池用于规划容器组网络地址空间，每个容器组 IP 池之间的地址空间不能重叠。创建工作负载时，可选择特定的容器组 IP 池，这样创建出的容器组将从该容器组 IP 池中分配 IP 地址。
15. KubeEdge： KubeEdge 是一个开源系统，用于将容器化应用程序编排功能扩展到边缘的主机。KubeEdge 支持多个边缘协议，旨在对部署于云端和边端的应用程序与资源等进行统一管理。KubeEdge 的组件在两个单独的位置运行——云上和边缘节点上。在云上运行的组件统称为 CloudCore，包括 Controller 和 Cloud Hub。Cloud Hub 作为接收边缘节点发送请求的网关，Controller 则作为编排器。在边缘节点上运行的组件统称为 EdgeCore，包括 EdgeHub，EdgeMesh，MetadataManager 和 DeviceTwin。有关更多信息，请参见 KubeEdge 网站。


功能列表：
1. 集群管理
   1. 节点管理：调度、终端、污点、添加、删除
   2. 集群配置：重启、设置
   3. 集群状态管理：资源用量、已分配资源、健康状态、监控： CPU 用量、CPU 平均负载、内存用量、磁盘用量、Inode 用量、IOPS、磁盘吞吐和网络带宽
   4. 系统组件状态：
      1. etcd
      2. apiserver：请求延迟、每秒请求次数
      3. 调度器监控：次数、频率、延迟
   5. 物理资源监控：CPU 用量、内存用量、CPU 平均负载（1 分钟/5 分钟/15 分钟）、磁盘用量、Inode 用量、磁盘吞吐（读写）、IOPS（读写）、网络带宽和容器组状态
   6. 容器状态： 运行中、已完成和异常状态
   7. 节点量排行
2. 应用资源监控： CPU 用量、内存用量、容器组数量、网络流出速率和网络流入速率
3. Alertmanager 管理告警： 将告警去重、分组 (Grouping) 并路由至正确的接收器，例如电子邮件、PagerDuty 或者 OpsGenie。它还负责告警沉默 (Silencing) 和抑制 (Inhibition)
4. 存储卷管理： in-tree、extrenal-provisioner、csi
5. 卷快照类：
6. 企业空间： 管理项目、DevOps 项目、应用模板和应用仓库的一种逻辑单元。同一名租户可以在多个企业空间中工作，并且多个租户可以通过不同方式访问同一个企业空间。
   1. 配额：企业空间配额用于管理企业空间中所有项目和 DevOps 项目的总资源用量。企业空间配额与项目配额相似，也包含 CPU 和内存的预留（Request）和限制（Limit）。预留确保企业空间中的项目能够获得其所需的资源，因为这些资源已经得到明确保障和预留。相反，限制则确保企业空间中的所有项目的资源用量不能超过特定数值。在多集群架构中，由于您需要将一个或多个集群分配到企业空间中，您可以设置该企业空间在不同集群上的资源用量。
   2. 网络隔离：
   3. 部门管理：部门是用来管理权限的逻辑单元。您可以在部门中设置企业空间角色、多个项目角色以及多个 DevOps 项目角色，还可以将用户分配到部门中以批量管理用户权限。
7. 项目： KubeSphere 使用预留（Request）和限制（Limit）来控制项目中的资源（例如 CPU 和内存）使用情况，在 Kubernetes 中也称为资源配额。请求确保项目能够获得其所需的资源，因为这些资源已经得到明确保障和预留。相反地，限制确保项目不能使用超过特定值的资源。除了 CPU 和内存，您还可以单独为其他对象设置资源配额，例如项目中的容器组、部署、任务、服务和配置字典。
   1. 应用程序管理： 应用模板(helm),负载、配置、持久卷、回复发布、镜像构造器、告警、自定义应用监控
8. Devops：
   1. S2I、B2I快速交付镜像
   2. 流水线jenkinsfile
   3. 图形面板
   4. 代码质量检查SonarQube
9. 多租户：在 KubeSphere 中企业空间是最小的租户单元，企业空间提供了跨集群、跨项目（即 Kubernetes 中的命名空间）共享资源的能力。企业空间中的成员可以在授权集群中创建项目，并通过邀请授权的方式参与项目协同。用户是 KubeSphere 的帐户实例，可以被设置为平台层面的管理员参与集群的管理，也可以被添加到企业空间中参与项目协同。多级的权限控制和资源配额限制是 KubeSphere 中资源隔离的基础，奠定了多租户最基本的形态。
   1.  多租户
   2.  iam： ldap、oidc、cas、oauth
10. 应用商店
11. 计量计费：
12. DMP数据库管理平台
13. 边缘计算平台
14. GPU
15. Grafana模板支持
16. springCloud

## OpenEBS

In case of Local Volumes:

1. OpenEBS can create Persistent Volumes using raw block devices or partitions, or using sub-directories on Hostpaths or by using LVM,ZFS, or sparse files.
2. The local volumes are directly mounted into the Stateful Pod, without any added overhead from OpenEBS in the data path, decreasing latency.
3. OpenEBS provides additional tooling for Local Volumes for monitoring, backup/restore, disaster recovery, snapshots when backed by ZFS or LVM, capacity based scheduling, and more.

In case of Distributed (aka Replicated) Volumes:

1. OpenEBS creates a Micro-service for each Distributed Persistent volume using one of its engines - Mayastor, cStor or Jiva.
2. The Stateful Pod writes the data to the OpenEBS engines that synchronously replicate the data to multiple nodes in the cluster. The OpenEBS engine itself is deployed as a pod and orchestrated by Kubernetes. When the node running the Stateful pod fails, the pod will be rescheduled to another node in the cluster and OpenEBS provides access to the data using the available data copies on other nodes.
3. The Stateful Pods connect to the OpenEBS Distributed Persistent volume using iSCSI (cStor and Jiva) or NVMeoF (Mayastor).
4. OpenEBS cStor and Jiva focus on ease of use and durability of the storage. These engines use customized versions of ZFS and Longhorn technology respectively for writing the data onto the storage.
5. OpenEBS Mayastor is the latest engine and has been developed with durability and performance as design goals; OpenEBS Mayastor efficiently manages the compute (hugepages, cores) and storage (NVMe Drives) to provide fast distributed block storage.


## openSearch
KubeSphere 在 3.4 版本后默认使用 OpenSearch 作为日志/事件/审计存储后端，用以代替 ElasticSearch，默认我们可以使用 KubeSphere 页面右下角自带的查询工具来检索日志，查询事件和审计记录。

如果您想获得类似 Kibana 页面的体验，如日志图表绘制等，我们可以启用该功能，也就是 OpenSearch Dashboard。


## OpenFunction
openfunction.dev
## 社区版安装

./kk create cluster [--with-kubernetes version] [--with-kubesphere version]


## appcenter

1. postgres: 
   1. source: https://github.com/radondb/multi-platform-postgresql
   2. image: radondb/radondb-postgres-operator:v1.2.2
   3. operation: 
      1. DeletePvc: 
      2. State
      3. VolumeType
      4. FailoverImage
      5. PostgresqlImage
      6. RWnodes
   4. Backup: 


## appcenter api

/clusters/host/kapis/dmp.platform.io/v1/s3List?sortBy=createTime&limit=10&page=1&cluster=host
/clusters/host/kapis/dmp.platform.io/v1/backupList?page=1&limit=10&sortBy=createTime&gv=mysql.v1&cluster=host

/clusters/host/kapis/dmp.kubesphere.io/v1/cluster?gvi=mysql.v1&workspaces=system-workspace
/clusters/host/kapis/dmp.platform.io/v1/backupSummary


/clusters/host/kapis/dmp.kubesphere.io/v1/cluster?gvi=mysql.v1&sortBy=createTime&workspaces=system-workspace&page=1&limit=10

/clusters/host/kapis/dmp.platform.io/v1/app/mysql


## extension-dmp

dmp-agent-postgresql-0:
strimzi-cluster-operator-6bb8d9b895-vn2wl
redis-operator-6967666986-5sj5t
radondb-postgres-operator-77856cdf6d-q2phf

rabbitmq-cluster-operator-57d6fcf688-wbkqs
opensearch-operator-controller-manager-d7965cd85-xj5bw
open-mongodb-operator-5bc5d4f5bb-v5vpk

dmp-agent-mysql-operator-849d5b8c8b-xx4dn
dmp-agent-77b8c9757-jt8np
helm-executor-dmp-agent-k2mt6v-6bcmf
dmp-frontend-5f76454f88-gdm8d: registry.cn-beijing.aliyuncs.com/kse/dmp-frontend:2.0.0
helm-executor-dmp-l7jgxn-ndlwq