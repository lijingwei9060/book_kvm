# module

apiserver: 提供了资源操作的唯一入口，并提供认证、授权、访问控制、API注册和发现等机制；
scheduler: 负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；由 kube-controller-manager 和 cloud-controller-manager 组成，是 Kubernetes 的大脑，它通过 apiserver 监控整个集群的状态，并确保集群处于预期的工作状态。
controller-manager: 负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
etcd:保存了整个集群的状态；
kubelet: 负责维护容器的生命周期，同时也负责Volume（CVI）和网络（CNI）的管理；
kube-proxy:负责为Service提供cluster内部的服务发现和负载均衡；
Container runtime负责镜像管理以及Pod和容器的真正运行（CRI）

Plugin: container runtime + network + volume + image registry + cloud provider + identity provider

kube-dns负责为整个集群提供DNS服务
Ingress Controller为服务提供外网入口
Heapster提供资源监控
Dashboard提供GUI
Federation提供跨可用区的集群
Fluentd-elasticsearch提供集群日志采集、存储与查询

Master: apiserver + scheduler + controller + etcd
Node: Image Registry + DNS/UI + POD

Nucleus

## kube-controller-manager

Controller Manager 由 kube-controller-manager 和 cloud-controller-manager 组成，是 Kubernetes 的大脑，它通过 apiserver 监控整个集群的状态，并确保集群处于预期的工作状态。

kube-controller-manager 由一系列的控制器组成: 

- Replication Controller
- Node Controller
- CronJob Controller
- Daemon Controller
- Deployment Controller： 
- Endpoint Controller
- Garbage Collector
- Namespace Controller
- Job Controller
- Pod AutoScaler
- RelicaSet
- Service Controller
- ServiceAccount Controller
- StatefulSet Controller
- Volume Controller
- Resource quota Controller

必须启动的控制器
- EndpointController
- ReplicationController
- PodGCController
- ResourceQuotaController
- NamespaceController
- ServiceAccountController
- GarbageCollectorController
- DaemonSetController
- JobController
- DeploymentController
- ReplicaSetController
- HPAController
- DisruptionController
- StatefulSetController
- CronJobController
- CSRSigningController
- CSRApprovingController
- TTLController
默认启动的可选控制器，可通过选项设置是否开启
- TokenController
- NodeController
- ServiceController
- RouteController
- PVBinderController
- AttachDetachController
默认禁止的可选控制器，可通过选项设置是否开启
- BootstrapSignerController
- TokenCleanerController


cloud-controller-manager 在 Kubernetes 启用 Cloud Provider 的时候才需要，用来配合云服务提供商的控制，也包括一系列的控制器，如
- Node Controller
- Route Controller
- Service Controller
从 v1.6 开始，cloud provider 已经经历了几次重大重构，以便在不修改 Kubernetes 核心代码的同时构建自定义的云服务商支持。参考 [这里](https://kubernetes.feisky.xyz/extension/cloud-provider) 查看如何为云提供商构建新的 Cloud Provider。

高可用: 在启动时设置 --leader-elect=true 后，controller manager 会使用多节点选主的方式选择主节点。只有主节点才会调用 StartControllers() 启动所有控制器，而其他从节点则仅执行选主算法。
多节点选主的实现方法见 leaderelection.go。它实现了两种资源锁（Endpoint 或 ConfigMap，kube-controller-manager 和 cloud-controller-manager 都使用 Endpoint 锁），通过更新资源的 Annotation（control-plane.alpha.kubernetes.io/leader），来确定主从关系。

高性能: 从 Kubernetes 1.7 开始，所有需要监控资源变化情况的调用均推荐使用 Informer。Informer 提供了基于事件通知的只读缓存机制，可以注册资源变化的回调函数，并可以极大减少 API 的调用。

Node 驱逐: 默认情况下，Kubelet 每隔 10s (--node-status-update-frequency=10s) 更新 Node 的状态，而 kube-controller-manager 每隔 5s 检查一次 Node 的状态 (--node-monitor-period=5s)。kube-controller-manager 会在 Node 未更新状态超过 40s 时 (--node-monitor-grace-period=40s)，将其标记为 NotReady (Node Ready Condition: True on healthy, False on unhealthy and not accepting pods, Unknown on no heartbeat)。当 Node 超过 5m 未更新状态，则 kube-controller-manager 会驱逐该 Node 上的所有 Pod。

## kubelet结构

- Kubelet API：包括 10250 端口的认证 API、4194 端口的 cAdvisor API、10255 端口的只读 API 以及 10248 端口的健康检查 API
- syncLoop：从 API 或者 manifest 目录接收 Pod 更新，发送到 podWorkers 处理，大量使用 channel 处理来处理异步请求
- 辅助的 manager，如 cAdvisor、PLEG、Volume Manager 等，处理 syncLoop 以外的其他工作，有PLEG、cAdvisor、GPUManager、OOMManager、ProbeManager、PodWorker、DiskSpaceManager、StatusManager、EvictionManager、VolumeManager、ImageGC、ContainerGC、ImageManager、Certificate Manager.
- CRI：容器执行引擎接口，负责与 container runtime shim 通信
- 容器执行引擎，如 dockershim、rkt 等（注：rkt 暂未完成 CRI 的迁移）
- 网络插件，目前支持 CNI 和 kubenet

- PLEG(Pod Lifecycle Event Generator）:PLEG 是 kubelet 的核心模块,PLEG 会一直调用 container runtime 获取本节点 containers/sandboxes 的信息，并与自身维护的 pods cache 信息进行对比，生成对应的 PodLifecycleEvent，然后输出到 eventChannel 中，通过 eventChannel 发送到 kubelet syncLoop 进行消费，然后由 kubelet syncPod 来触发 pod 同步处理过程，最终达到用户的期望状态。
- cAdvisor: cAdvisor（https://github.com/google/cadvisor）是 google 开发的容器监控工具，集成在 kubelet 中，起到收集本节点和容器的监控信息，大部分公司对容器的监控数据都是从 cAdvisor 中获取的 ，cAvisor 模块对外提供了 interface 接口，该接口也被 imageManager，OOMWatcher，containerManager 等所使用。
- OOMWatcher: 系统 OOM 的监听器，会与 cadvisor 模块之间建立 SystemOOM,通过 Watch方式从 cadvisor 那里收到的 OOM 信号，并产生相关事件。
- probeManager: probeManager 依赖于 statusManager,livenessManager,containerRefManager，会定时去监控 pod 中容器的健康状况，当前支持两种类型的探针：livenessProbe 和readinessProbe。 livenessProbe：用于判断容器是否存活，如果探测失败，kubelet 会 kill 掉该容器，并根据容器的重启策略做相应的处理。 readinessProbe：用于判断容器是否启动完成，将探测成功的容器加入到该 pod 所在 service 的 endpoints 中，反之则移除。readinessProbe 和 livenessProbe 有三种实现方式：http、tcp 以及 cmd。
- statusManager:  负责维护状态信息，并把 pod 状态更新到 apiserver，但是它并不负责监控 pod 状态的变化，而是提供对应的接口供其他组件调用，比如 probeManager。
- containerRefManager: 容器引用的管理，相对简单的Manager，用来报告容器的创建，失败等事件，通过定义 map 来实现了 containerID 与 v1.ObjectReferece 容器引用的映射。
- evictionManager: 当节点的内存、磁盘或 inode 等资源不足时，达到了配置的 evict 策略， node 会变为 pressure 状态，此时 kubelet 会按照 qosClass 顺序来驱赶 pod，以此来保证节点的稳定性。可以通过配置 kubelet 启动参数 --eviction-hard= 来决定 evict 的策略值。
- imageGC 负责 node 节点的镜像回收，当本地的存放镜像的本地磁盘空间达到某阈值的时候，会触发镜像的回收，删除掉不被 pod 所使用的镜像，回收镜像的阈值可以通过 kubelet 的启动参数 --image-gc-high-threshold 和 --image-gc-low-threshold 来设置。
- containerGC 负责清理 node 节点上已消亡的 container，具体的 GC 操作由runtime 来实现。
- imageManager: 调用 kubecontainer 提供的PullImage/GetImageRef/ListImages/RemoveImage/ImageStates 方法来保证pod 运行所需要的镜像。
- volumeManager: 负责 node 节点上 pod 所使用 volume 的管理，volume 与 pod 的生命周期关联，负责 pod 创建删除过程中 volume 的 mount/umount/attach/detach 流程，kubernetes 采用 volume Plugins 的方式，实现存储卷的挂载等操作，内置几十种存储插件。
- containerManager: 负责 node 节点上运行的容器的 cgroup 配置信息，kubelet 启动参数如果指定 --cgroups-per-qos 的时候，kubelet 会启动 goroutine 来周期性的更新 pod 的 cgroup 信息，维护其正确性，该参数默认为 true，实现了 pod 的Guaranteed/BestEffort/Burstable 三种级别的 Qos。
- containerRuntime:  负责 kubelet 与不同的 runtime 实现进行对接，实现对于底层 container 的操作，初始化之后得到的 runtime 实例将会被之前描述的组件所使用。可以通过 kubelet 的启动参数 --container-runtime 来定义是使用docker 还是 rkt，默认是 docker。
- podManager 提供了接口来存储和访问 pod 的信息，维持 static pod 和 mirror pods 的关系，podManager 会被statusManager/volumeManager/runtimeManager 所调用，podManager 的接口处理流程里面会调用 secretManager 以及 configMapManager。

## Node Controller


v1.16 版本中 NodeController 已经分为了 NodeIpamController 与 NodeLifecycleController。
NodeLifecycleController 主要功能是定期监控 node 的状态并根据 node 的 condition 添加对应的 taint 标签或者直接驱逐 node 上的 pod。

taint 使用效果(Effect):
- PreferNoSchedule：调度器尽量避免把 pod 调度到具有该污点的节点上，如果不能避免(如其他节点资源不足)，pod 也能调度到这个污点节点上，已存在于此节点上的 pod 不会被驱逐；
- NoSchedule：不容忍该污点的 pod 不会被调度到该节点上，通过 kubelet 管理的 pod(static pod)不受限制，之前没有设置污点的 pod 如果已运行在此节点(有污点的节点)上，可以继续运行；
- NoExecute：不容忍该污点的 pod 不会被调度到该节点上，同时会将已调度到该节点上但不容忍 node 污点的 pod 驱逐掉；


NodeLifecycleController 用到了多个 feature-gates，此处先进行解释下：

- NodeDisruptionExclusion：该特性在 v1.16 引入，Alpha 版本，默认为 false，其功能是当 node 存在 node.kubernetes.io/exclude-disruption 标签时，当 node 网络中断时其节点上的 pod 不会被驱逐掉；
- LegacyNodeRoleBehavior：该特性在 v1.16 中引入，Alpha 版本且默认为 true，在创建 load balancers 以及中断处理时不会忽略具有 node-role.kubernetes.io/master label 的 node，该功能在 v1.19 中将被移除；
- TaintBasedEvictions：该特性从 v1.13 开始为 Beta 版本，默认为 true。其功能是当 node 处于 NodeNotReady、NodeUnreachable 状态时为 node 添加对应的 taint，TaintBasedEvictions 添加的 taint effect 为 NoExecute，即会驱逐 node 上对应的 pod；
- TaintNodesByCondition：该特性从 v1.12 开始为 Beta 版本，默认为 true，v1.17 为 GA 版本。其功能是基于节点状态添加 taint，当节点处于 NetworkUnavailable、MemoryPressure、PIDPressure、DiskPressure 状态时会添加对应的 taint，TaintNodesByCondition 添加的 taint effect 仅为NoSchedule，即仅仅不会让新创建的 pod 调度到该 node 上；
- NodeLease：该特性在 v1.12 引入，v 1.14 为 Beta 版本且默认启用，v 1.17 GA，主要功能是减少 node 的心跳请求以减轻 apiserver 的负担；

主要监听 lease、pods、nodes、daemonSets 四种对象。
TaintBasedEvictions 和 TaintNodesByCondition 两个 feature-gates

ctx.InformerFactory.Coordination().V1beta1().Leases(),
ctx.InformerFactory.Core().V1().Pods(),
ctx.InformerFactory.Core().V1().Nodes(),
ctx.InformerFactory.Apps().V1().DaemonSets(),
DefaultFeatureGate TaintBasedEvictions

taintManager *scheduler.NoExecuteTaintManager
computeZoneStateFunc       func(nodeConditions []*v1.NodeCondition) (int, ZoneState):  计算 zone 状态
knownNodeSet map[string]*v1.Node: 用来记录NodeController observed节点的集合
nodeHealthMap map[string]*nodeHealthData 记录 node 最近一次状态的集合
zonePodEvictor map[string]*scheduler.RateLimitedTimedQueue: 需要驱逐节点上 pod 的 node 队列
zoneNoExecuteTainter map[string]*scheduler.RateLimitedTimedQueue: 需要打 taint 标签的 node 队列
zoneStates map[string]ZoneState: 将 node 划分为不同的 zone

## Pod 管理