# 组成

1. pod运行在Node节点上，由kubelet管理。
2. 数据状态保存在etcd中，通过api server提供http访问，通过list和watch接口建立http连接，watch的对象通过resource version获取后续的数据变化。由 API Server 负责写入 etcd 并通过水平触发（level-triggered）机制主动通知给相关的客户端程序以确保其不会错过任何一个事件。控制器通过 API Server 的 Watch 接口实时监控目标资源对象的变动并执行和解操作，但并不会与其他控制器进行任何交互，设置彼此之间根本就意识不到对方的存在。
3. master节点上有controller manager提供控制器有 attachdetach、bootstrapsigner、clusterrole-aggregation、cronjob、csrapproving、csrcleaner、daemonset、deployment、disruption、endpoint、garbagecollector、horizontalpodautoscaling、job、namspace、node、persistentvolume-expander、podgc、pvc-protection、replicaset、replication-controller、resourcequota、route、service、serviceaccount、serviceaccount-token、statefulset、tokencleaner 和 ttl 等数十种。

## Pod Controll

一个 Pod 控制器资源至少应该包含是三个基本的组成部分。

1. 标签选择器：匹配并关联 Pod 资源对象，并据此完成受其管控的 Pod 资源计数。
2. 期望的副本数：期望在集群中精确运行着的 Pod 资源的对象数量。
3. Pod 模版：用于新建 Pod 资源对象的 Pod 模版资源。

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: rs-example
spec:
  replicas: 2
  selector:
    matchLabels:
      app: rs-demo
  template:
    metadata:
      labels:
        app: rs-demo
    spec:
      containers:
      - name: myapp
        image: ikubernetes/myapp:v1
        ports:
        - name: http
          containerPort: 80
```

涉及到的控制器： 
1. ReplicaSet Controller： ReplicaSet 控制器资源启动后会查找集群中匹配其标签选择器的 Pod 资源对象，当前活动对象的数量与期望的数量不吻合时，多则删除，少则通过 Pod 模版创建以补足，等 Pod 资源副本数量符合期望值后即进入下一轮和解循环。
   1. 确保 Pod 资源对象的数量精确反映期望值：ReplicaSet 需要确保由其控制运行的 Pod 副本数量精确吻合配置定义的期望值，否则就会自动补充所缺或终止所余。
   2. 确保 Pod 健康运行：探测到由其管控的 Pod 对象因其所在的工作节点故障而不可用时，自动请求由调度器于其他工作节点创建缺失的 Pod 脚本。
   3. 弹性伸缩：业务规模因各种原因时常存在明显波动，在波峰或波谷期间，可以通过 ReplicaSet 控制器动态调整相关 Pod 资源对象数量。此外，在必要时还可以通过HPA(HroizontalPodAutoscaler)控制器实现 Pod 资源规模的自动伸缩。
   4. replicas <interger>：期望的 Pod 对象副本数。
   5. selector <Object>：当前控制器匹配 Pod 对象副本的标签选择器，支持 matchLabels 和 matchExpressions 两种匹配机制。
   6. template <Object>：用于补足 Pod 副本数量时使用的 Pod 模版资源。
   7. minReadySeconds <interger>： 新建的 Pod 对象，在启动后的多长时间内如果其容器未发生崩溃等异常情况即被视为“就绪”；默认为0秒，表示一旦就绪性探测成功，即被视作可用。
2. Deployment controller： 构建于 ReplicaSet 控制器之上，可为 Pod 和 ReplicaSet 资源提供声明式更新
   1. 事件和状态查看：必要时可以查看 Deployment 对象升级的详细进度和状态。
   2. 回滚：升级操作完成后发现问题时，支持使用回滚机制将应用返回到前一个或由用户指定的历史记录中的版本上。
   3. 版本记录：对 Deployment 对象的每一次操作都予以保存，以供后续可能执行的回滚操作使用。
   4. 暂停和启动：对于每一次升级，都能随时暂停和启动。
   5. 多种自动更新方案：一是 Recreate，及重建更新机制，全面停止、删除旧有的 Pod 后用新版本替代；另一个是 RollingUpdate，即滚动升级机制，逐步替换旧有的 Pod 至新的版本。
3. DaemonSet Controller
4. Job Controller
5. CronJob Controller
6. ReplicationController
7.  POD中断预算， 