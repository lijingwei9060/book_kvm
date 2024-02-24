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