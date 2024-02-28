# 用途

1. 用户通过kubectl命令行或者api，与apiserver交互，创建deployment资源
2. deploymentcontroller一直在watch api server，监听到deployment资源，然后创建replicationset资源
3. replication set controller监听到创建rs资源，创建pod资源
4. 调度器scheduler监听到pod资源，将其与node资源建立关联，创建pod。
5. Node节点上kubelet监听到pod创建，通知cri创建容器。


## 升级

Deployment 控制器支持两种更新策略：滚动更新（rolling update）和重新创建（recreate）。默认为滚动更新。重新创建更新类似于前文中ReplicaSet的第一种更新方式，即首先删除现有的Pod对象，而后由控制器基于新模板重新创建出新版本资源对象。通常，只应该在应用的新旧版本不兼容（如依赖的后端数据库的schema不同且无法兼容）时才会使用recreate策略，因为它会导致应用替换期间暂时不可用，好处在于它不存在中间状态，用户访问到的要么是应用的新版本，要么是旧版本。
```shell
[root@i-xxxxxxxx]kubectl describe deployments myapp-deploy
Name:                   myapp-deploy
Namespace:              default
CreationTimestamp:      Fri, 11 Sep 2020 16:22:37 +0800
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=myapp
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=myapp
  Containers:
   myapp:
    Image:        ikubernetes/myapp:v1
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   myapp-deploy-5cbd66595b (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  2m26s  deployment-controller  Scaled up replica set myapp-deploy-5cbd66595b to 3
```