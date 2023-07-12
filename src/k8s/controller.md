# list

## Deployment
DeploymentController 控制器内通过 informer 监听 deployment, replicaset, pod 三个资源的add/update/delete事件.
Run() 启动控制器, 阻塞等待 informer 的缓存同步完毕, 启动 workers 数量的 worker 协程, 默认为 5 个.
worker 循环的从队列获取数据, 然后交给 syncHandler 处理. 队列里的数据是由 informer 注册的 eventHandler 写入的.

syncDeployment 核心处理方法, syncStatusOnly 处理删除操作, sync 处理状态为 pause 暂停的操作, rollback 处理回滚版本的操作, 最后由 rolloutRecreate 和 rolloutRolling 实现升级操作.
1. 从 key 中拆解 namespace 和 name 信息
2. 从 informer cache 中获取指定 ns 和 name 的 deployment 对象
3. 判断 selecor 是否为空
4. 获取 deployment 对应的所有 rs, 通过 LabelSelector 进行匹配
5. 获取当前 Deployment 对象关联的 pod
6. 如果该 deployment 处于删除状态，则更新其 status
7. 检查 pause 状态, 如果是 pause 状态则进行 sync 同步.
8. 检查是否为回滚操作
9. 检查 deployment 是否处于 scale 状态, 重建或者滚动更新

操作优先级： delete > pause > rollback > scale > rollout

删除 deployment： 当 DeletionTimestamp 字段存在时, 就意味着需要删除该 deployment。
1. 通过当前 dm 和 rs 对象获取新旧副本集对象.
2. 通过 newRS 和 allRSs 计算 deployment 当前的 status, 然后和 deployment 中的 status 进行比较，若二者有差异则更新 deployment 使用最新的 status.
3. 真正的删除 deployment, rs, pods 操作是放在垃圾回收控制器器 garbagecollector controller 完成的. 在其他控制里的删除只是配置 DeletionTimestamp 字段，并标记 orphan、background 或者 foreground 删除标签.

scale deployment： 当执行 scale 操作时，首先会通过 isScalingEvent 方法判断是否为扩缩容操作，然后通过 dc.sync 方法来执行实际的扩缩容动作。
1. 获取所有的 rs
2. 过滤出 activeRS, rs.Spec.Replicas > 0 的为 activeRS
3. 判断 rs 的 desired 值是否等于 deployment.Spec.Replicas, 若不等于则需要为 rs 进行 scale 操作.
4. 获取新旧两个 replicaset 副本集, newRs 是预期的, oldRss 为当前的存在副本集, 调用 scale 扩缩容方法, 最后同步当前的状态.
5. scale 方法首先求出需要扩缩容的 pod 数量, 按照策略对 rs 数组进行新旧排序, 为了让每个 rs 都扩缩点, 经过一轮 proportion 计算再对 rs 进行 scale 扩缩容.
6. k8s 里更新策略有两种, 一种为重建模式, 另一种为滚动更新模式. 当在 yaml 里不定义 .spec.strategy 策略时, 默认会给填充 RollingUpdate.
7. rolloutRolling 负责负责滚动更新操作, 先尝试对新的 rs 进行扩容, 在扩容后更新状态后就跳出. 等再次 informer 触发事件, 再次进入方法内时, 滚动更新场景下这时当前 pods 数量超过预期值无法 scale up. 后面会尝试对旧的 rs 进行缩容, 缩容完成后需要更新 rollout 状态, 再次跳出.滚动升级就是这样循环反复地对新 rs 进行扩容, 同时对老的 rs 进行缩容, 一边增一边减, 直到达到预期状态.
8. rolloutRecreate 在设计上显得 简单粗暴, 正常互联网业务场景下, 应该不会有人用这个模式吧.Recreate 的逻辑不复杂, 首先对旧的 rs 缩容到 0, 等待所有 pods 状态为 not running 后, 再创建新的 rs, 副本数跟 deployment 期望的值一致.


## DaemonSet 

DaemonSet Controller 关心的是 daemonset、controllerrevision、pod、node 四种资源的变动，其中 ConcurrentDaemonSetSyncs 默认是 2。
sync 操作是 controller 的核心代码，响应上述所有操作。在初始化 controller 对象时，指定了 failedPodsBackoff 的参数，defaultDuration = 1s，maxDuration = 15min；
gc 的主要作用是发现 daemonset 的 pod 的 phase 为 failed，就会重启该 Pod，如果已经超时（2*15min）会删除该条记录。

syncDaemonSet()： DaemonSet 的 Pod 的创建/删除都是和 Node 相关，所以每次 sync 操作，需要遍历所有的 Node 进行判断。syncDaemonSet() 的主要逻辑为：
1. 通过 key 获取 ns 和 name
2. 从 dsLister 获取 ds 对象
3. 从 nodeLister 获取全部 node 对象
4. 获取 dsKey， 即：<namespace>/<name>
5. 判断 ds 是否处于删除中，如果正在删除，则等待删除完毕后再次进入 sync
6. 获取 cur 和 old controllerrevision
7. 判断是否满足 expectation 机制，expectation 机制就是为了减少不必要的 sync 操作
8. 调用 dsc.manage()，执行实际的 sync 操作
9. 判断是否为更新操作，并执行
10. 调用 dsc.cleanupHistory() 根据 spec.revisionHistroyLimit 清理过期的 controllerrevision
11. 调用 dsc.updateDaemonSetStatus()，更新 status 子资源