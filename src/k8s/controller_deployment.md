# 用途

1. 用户通过kubectl命令行或者api，与apiserver交互，创建deployment资源
2. deploymentcontroller一直在watch api server，监听到deployment资源，然后创建replicationset资源
3. replication set controller监听到创建rs资源，创建pod资源
4. 调度器scheduler监听到pod资源，将其与node资源建立关联，创建pod。
5. Node节点上kubelet监听到pod创建，通知cri创建容器。