# info

kube-scheduler  的主要作用就是根据特定的调度算法和调度策略将 Pod 调度到合适的 Node 节点上去，是一个独立的二进制程序，启动之后会一直监听 API Server，获取到  PodSpec.NodeName  为空的 Pod，对每个 Pod 都会创建一个 binding。

每当调度一个 Pod 时，都会按照两个过程来执行：调度过程和绑定过程。调度过程为 Pod 选择一个合适的节点，绑定过程则将调度过程的决策应用到集群中（也就是在被选定的节点上运行 Pod），将调度过程和绑定过程合在一起，称之为调度上下文（Scheduling Context）。需要注意的是调度过程是同步运行的（同一时间点只为一个 Pod 进行调度），绑定过程可异步运行（同一时间点可并发为多个 Pod 执行绑定）。

调度过程和绑定过程遇到如下情况时会中途退出：调度程序认为当前没有该 Pod 的可选节点;内部错误.这个时候，该 Pod 将被放回到  待调度队列，并等待下次重试。

Pod调度策略除了系统默认的kube-scheduler调度器外还有以下几种实现方式：
1. nodeName（直接指定Node主机名）
2. nodeSelector （节点选择器，为Node打上标签，然后Pod中通过nodeSelector选择打上标签的Node）
3. 污点taint与容忍度tolerations
4. NodeAffinity 节点亲和性
5. PodAffinity Pod亲和性
6. PodAntAffinity Pod反亲和性

过滤阶段: [官方文档](https://kubernetes.io/docs/reference/scheduling/policies/)

在调度时的过滤阶段到底时通过什么规则来对Node进行过滤的呢？就是通过以下规则！

1. PodFitsHostPorts：检查Node上是否不存在当前被调度Pod的端口（如果被调度Pod用的端口已被占用，则此Node被Pass）。
2. PodFitsHost：检查Pod是否通过主机名指定了特性的Node (是否在Pod中定义了nodeName) 
3. PodFitsResources：检查Node是否有空闲资源(如CPU和内存)以满足Pod的需求。 
4. PodMatchNodeSelector：检查Pod是否通过节点选择器选择了特定的Node (是否在Pod中定义了nodeSelector)。 
5. NoVolumeZoneConflict：检查Pod请求的卷在Node上是否可用 (不可用的Node被Pass)。 
6. NoDiskConflict：根据Pod请求的卷和已挂载的卷，检查Pod是否合适于某个Node (例如Pod要挂载/data到容器中，Node上/data/已经被其它Pod挂载，那么此Pod则不适合此Node) 
7. MaxCSIVolumeCount：：决定应该附加多少CSI卷，以及是否超过了配置的限制。 
8. CheckNodeMemoryPressure：对于内存有压力的Node，则不会被调度Pod。 
9. CheckNodePIDPressure：对于进程ID不足的Node，则不会调度Pod
10. CheckNodeDiskPressure：对于磁盘存储已满或者接近满的Node，则不会调度Pod。
11. CheckNodeCondition：Node报告给API Server说自己文件系统不足，网络有写问题或者kubelet还没有准备好运行Pods等问题，则不会调度Pod。
12. PodToleratesNodeTaints：检查Pod的容忍度是否能承受被打上污点的Node。
13. CheckVolumeBinding：根据一个Pod并发流量来评估它是否合适（这适用于结合型和非结合型PVCs）。

打分阶段, https://kubernetes.io/docs/reference/scheduling/policies/ 当过滤阶段执行后满足过滤条件的Node，将进行打分阶段。

1. SelectorSpreadPriority：优先减少节点上属于同一个 Service 或 Replication Controller 的 Pod 数量.
2. InterPodAffinityPriority：优先将 Pod 调度到相同的拓扑上（如同一个节点、Rack、Zone 等）
3. LeastRequestedPriority：节点上放置的Pod越多，这些Pod使用的资源越多，这个Node给出的打分就越低，所以优先调度到Pod少及资源使用少的节点上。
4. MostRequestedPriority：尽量调度到已经使用过的 Node 上，将把计划的Pods放到运行整个工作负载所需的最小节点数量上。
5. RequestedToCapacityRatioPriority：使用默认资源评分函数形状创建基于requestedToCapacity的ResourceAllocationPriority。
6. BalancedResourceAllocation：优先平衡各节点的资源使用。
7. NodePreferAvoidPodsPriority：根据节点注释对节点进行优先级排序，以使用它来提示两个不同的 Pod 不应在同一节点上运行。scheduler.alpha.kubernetes.io/preferAvoidPods。
8. NodeAffinityPriority：优先调度到匹配 NodeAffinity （Node亲和性调度）的节点上。
9. TaintTolerationPriority：优先调度到匹配 TaintToleration (污点) 的节点上
10. ImageLocalityPriority：尽量将使用大镜像的容器调度到已经下拉了该镜像的节点上。
11. ServiceSpreadingPriority：尽量将同一个 service 的 Pod 分布到不同节点上，服务对单个节点故障更具弹性。
12. EqualPriority：将所有节点的权重设置为 1。
13. EvenPodsSpreadPriority：实现首选pod拓扑扩展约束。


## scheduler framwork
- QueueSort  扩展用于对 Pod 的待调度队列进行排序，以决定先调度哪个 Pod，QueueSort  扩展本质上只需要实现一个方法  Less(Pod1, Pod2)  用于比较两个 Pod 谁更优先获得调度即可，同一时间点只能有一个  QueueSort  插件生效。
- Pre-filter  扩展用于对 Pod 的信息进行预处理，或者检查一些集群或 Pod 必须满足的前提条件，如果  pre-filter  返回了 error，则调度过程终止。
- Filter  扩展用于排除那些不能运行该 Pod 的节点，对于每一个节点，调度器将按顺序执行  filter  扩展；如果任何一个  filter  将节点标记为不可选，则余下的  filter  扩展将不会被执行。调度器可以同时对多个节点执行  filter  扩展。
- Post-filter  是一个通知类型的扩展点，调用该扩展的参数是  filter  阶段结束后被筛选为可选节点的节点列表，可以在扩展中使用这些信息更新内部状态，或者产生日志或 metrics 信息。
- Scoring  扩展用于为所有可选节点进行打分，调度器将针对每一个节点调用  Soring  扩展，评分结果是一个范围内的整数。在  normalize scoring  阶段，调度器将会把每个  scoring  扩展对具体某个节点的评分结果和该扩展的权重合并起来，作为最终评分结果。
- Normalize scoring  扩展在调度器对节点进行最终排序之前修改每个节点的评分结果，注册到该扩展点的扩展在被调用时，将获得同一个插件中的  scoring  扩展的评分结果作为参数，调度框架每执行一次调度，都将调用所有插件中的一个  normalize scoring  扩展一次。
- Reserve  是一个通知性质的扩展点，有状态的插件可以使用该扩展点来获得节点上为 Pod 预留的资源，该事件发生在调度器将 Pod 绑定到节点之前，目的是避免调度器在等待 Pod 与节点绑定的过程中调度新的 Pod 到节点上时，发生实际使用资源超出可用资源的情况。（因为绑定 Pod 到节点上是异步发生的）。这是调度过程的最后一个步骤，Pod 进入 reserved 状态以后，要么在绑定失败时触发 Unreserve 扩展，要么在绑定成功时，由 Post-bind 扩展结束绑定过程。
- Permit  扩展用于阻止或者延迟 Pod 与节点的绑定。Permit 扩展可以做下面三件事中的一项：
    - approve（批准）：当所有的 permit 扩展都 approve 了 Pod 与节点的绑定，调度器将继续执行绑定过程
    - deny（拒绝）：如果任何一个 permit 扩展 deny 了 Pod 与节点的绑定，Pod 将被放回到待调度队列，此时将触发  Unreserve  扩展
    - wait（等待）：如果一个 permit 扩展返回了 wait，则 Pod 将保持在 permit 阶段，直到被其他扩展 approve，如果超时事件发生，wait 状态变成 deny，Pod 将被放回到待调度队列，此时将触发 Unreserve 扩展
- Pre-bind  扩展用于在 Pod 绑定之前执行某些逻辑。例如，pre-bind 扩展可以将一个基于网络的数据卷挂载到节点上，以便 Pod 可以使用。如果任何一个  pre-bind  扩展返回错误，Pod 将被放回到待调度队列，此时将触发 Unreserve 扩展。
- Bind  扩展用于将 Pod 绑定到节点上：
    - 只有所有的 pre-bind 扩展都成功执行了，bind 扩展才会执行
    - 调度框架按照 bind 扩展注册的顺序逐个调用 bind 扩展
    - 具体某个 bind 扩展可以选择处理或者不处理该 Pod
    - 如果某个 bind 扩展处理了该 Pod 与节点的绑定，余下的 bind 扩展将被忽略
- Post-bind  是一个通知性质的扩展：
    - Post-bind 扩展在 Pod 成功绑定到节点上之后被动调用
    - Post-bind 扩展是绑定过程的最后一个步骤，可以用来执行资源清理的动作
- Unreserve  是一个通知性质的扩展，如果为 Pod 预留了资源，Pod 又在被绑定过程中被拒绝绑定，则 unreserve 扩展将被调用。Unreserve 扩展应该释放已经为 Pod 预留的节点上的计算资源。在一个插件中，reserve 扩展和 unreserve 扩展应该成对出现。



## plugin机制