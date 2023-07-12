# module

- kubeClient：用于和 apiserver 交互；
- podManager：负责内存中 pod 的维护；
- podStatuses：statusManager 的 cache，保存 pod 与状态的对应关系；
- podStatusesChannel：当其他组件调用 statusManager 更新 pod 状态时，会将 pod 的状态信息发送到podStatusesChannel 中；
- apiStatusVersions：维护最新的 pod status 版本号，每更新一次会加1；
- podDeletionSafety：删除 pod 的接口；


Manager接口:
- PodStatusProvider
- start(): 启动 statusManager 的方法, 创建一个携程监听 m.podStatusChannel channel，当接收到数据时触发同步操作;定时同步.
- SetPodStatus(pod, v1.PodStatus):  是为 pod 设置 status subResource 并会触发同步操作，主要逻辑为: 1、检查 pod.Status.Conditions 中的类型是否为 kubelet 创建的，kubelet 会创建 ContainersReady、Initialized、Ready、PodScheduled 和 Unschedulable 五种类型的 conditions；2、调用 m.updateStatusInternal 触发更新操作；
- SetContainerReadiness(podUID types.UID, containerID kubecontainer.ContainerID, ready bool): 设置 pod .status.containerStatuses 中 container 是否为 ready 状态并触发状态同步操作
- SetContainerStartup(podUID types.UID, containerID kubecontainer.ContainerID, started bool): 设置 pod .status.containerStatuses 中 container 是否为 started 状态并触发状态同步操作
- TerminatePod(pod *v1.Pod): 将 pod .status.containerStatuses 和 .status.initContainerStatuses 中 container 的 state 置为 Terminated 状态并触发状态同步操作
- RemoveOrphanedStatuses(podUIDs map[types.UID]bool): 从 statusManager 缓存 podStatuses 中删除对应的 pod
- syncPod(syncRequest.podUID, syncRequest.status): 同步 pod 最新状态至 apiserver 的方法. apiserver 获取 pod 的 oldStatus；3、检查 pod oldStatus 与 currentStatus 的 uid 是否相等，若不相等则说明 pod 被重建过；4、调用 statusutil.PatchPodStatus 同步 pod 最新的 status 至 apiserver，并将返回的 pod 作为 newPod；5、检查 newPod 是否处于 terminated 状态，若处于 terminated 状态则调用 apiserver 接口进行删除并从 cache 中清除，删除后 pod 会进行重建；
- needsUpdate(uid, status): 判断是否需要同步状态，若 apiStatusVersions 中的 status 版本号小于当前接收到的 status 版本号或者 apistatusVersions 中不存在该 status 版本号则需要同步，若不需要同步则继续检查 pod 是否处于删除状态，若处于删除状态调用 m.podDeletionSafety.PodResourcesAreReclaimed 将  pod 完全删除；
- canBeDeleted(pod, status.status)
- syncBatch(): 是定期将 statusManager 缓存 podStatuses 中的数据同步到 apiserver 的方法.调用 m.podManager.GetUIDTranslations 从 podManager 中获取 mirrorPod uid 与 staticPod uid 的对应关系；2、从  apiStatusVersions 中清理已经不存在的 pod，遍历 apiStatusVersions，检查 podStatuses 以及 mirrorToPod 中是否存在该对应的 pod，若不存在则从 apiStatusVersions 中删除；3、遍历 podStatuses，首先调用 needsUpdate 检查 pod 的状态是否与 apiStatusVersions 中的一致，然后调用 needsReconcile 检查 pod 的状态是否与 podManager 中的一致，若不一致则将需要同步的 pod 加入到 updatedStatuses 列表中；4、遍历 updatedStatuses 列表，调用 m.syncPod 方法同步状态；
- needsReconcile(uid types.UID, status v1.PodStatus)对比当前 pod 的状态与 podManager 中的状态是否一致，podManager 中保存了 node 上 pod 的 object，podManager 中的数据与 apiserver 是一致的，needsReconcile  主要逻辑为：1、通过 uid 从 podManager 中获取 pod 对象；2、检查 pod 是否为 static pod，若为 static pod 则获取其对应的 mirrorPod；3、格式化 pod status subResource；4、检查 podManager 中的 status 与 statusManager cache 中的 status 是否一致，若不一致则以 statusManager 为准进行同步；


PodManager
- GetPodByUID(uid)