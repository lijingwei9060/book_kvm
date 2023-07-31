# 模式

资源：
- cpu
- memory
- hugepage
- 本地临时存储
- device-plugin
- cluster-level extended source
- gpu
- disk
- ssd
- ip
- ports
- bandwidth

Containermanager: 
- cgroupManager
- recorder
- qosContainermanager
- topologyManager，AddHintProvider(deviceManager/CPUManager/MemoryManager)
- deviceManager
- draManager(DynamicResourceAllocation)
- cpuManager
- memoryManager

PodContainerManager: 


klet:
- secretManager
- configMapManager
- livenessManager: containerID, result 的数据管理
- readinessManager
- startupManager
- podCache
- podManager：负责内存中pod及mirrorPod的维护，任何在本节点上创建或删除操作都会同步更新podManager，即可以认为podManager中存储了本节点上运行的pod的信息。保存UID到Pod映射，mirrorPod映射。
- podKiller：用于pod销毁的goRoutine
- statusManager：负责将Pod状态(pod状态以及容器的状态， versionedPodStatus)及时更新到Api-Server
- resourceAnalyzer
- runtimeService
- containerLogManager
- reasonCache
- workQueue
- podWorkers
- containerRuntime
- streamingRuntime
- runner
- runtimeCache
- pleg：全称是Pod Lifecycle Event Generator，主要负责将Pod状态变化记录event以及触发Pod同步
- eventedPleg
- containerGC
- containerDeletor
- imageManager
- serverCertificateManager
- probeManager：主要涉及liveness和readiness的逻辑，livenessProber: 用来检测容器中的程序是否健康并确定何时重启容器；readinessProber: 用来检测容器中的程序是否就绪，就绪意味着该容器可以接收处理流量。目前支持HTTP, TCP, EXEC(执行命令或脚本)三种检测方式。
- volumePluginMgr
- volumeManager： 容器的镜像挂载、解绑等逻辑，保障存储与容器状态一致
- pluginManager
- evictionManager
- admitHandlers
- syncNetworkUtil：配置节点的防火墙和Masquerade
- syncNodeStatus：将节点注册到k8s集群，并收集节点信息定期上报到api-server
- syncLoop：kubelet的核心主循环，响应各个模块的channel消息，并集中处理pod状态
- syncNetworkStatus：从CNI plugin获取状态
- updateRuntimeUp：主要涉及eviction操作

syncLoop：对pod的生命周期进行管理
SyncHandler来执行pod的增删改查等生命周期的管理，其中的syncHandler包括HandlePodSyncs和HandlePodCleanups等
- configCh：该信息源由 kubeDeps 对象中的 PodConfig 子模块提供，该模块将同时 watch 3 个不同来源的 pod 信息的变化（file，http，apiserver），一旦某个来源的 pod 信息发生了更新（创建/更新/删除/Reconcile/restore/set），这个 channel 中就会出现被更新的 pod 信息和更新的具体操作。
- syncCh：定时器管道，每隔一秒去同步最新保存的 pod 状态
- houseKeepingCh：housekeeping 事件的管道，做 pod 清理工作
- plegCh：该信息源由 kubelet 对象中的 pleg 子模块提供，该模块主要用于周期性地向 container runtime 查询当前所有容器的状态，如果状态发生变化，则这个 channel 产生事件。
- livenessManager.Updates()：健康检查发现某个 pod 不可用，kubelet 将根据 Pod 的restartPolicy 自动执行正确的操作

SyncPod：主要执行sync操作使得运行的pod达到期望状态的pod
- 计算 Pod 中沙盒和容器的变更； 
- 强制停止 Pod 对应的沙盒；
- 强制停止所有不应该运行的容器；
- 为 Pod 创建新的沙盒；
- 创建 Pod 规格中指定的初始化容器；
- 依次创建 Pod 规格中指定的常规容器；

HandlePodAdditions: 新增pod

mirror pod? 在kubernetes中，如果是static pod，则由kubelet直接创建，这时系统很难管理这部分pod；所以系统会在kubelet中创建一个static pod对应的mirrorPod，来表示static pod。


# Reference

1.  http://ljchen.net/2018/10/28/kubelet%E6%BA%90%E7%A0%81%E6%9E%B6%E6%9E%84%E7%AE%80%E4%BB%8B/