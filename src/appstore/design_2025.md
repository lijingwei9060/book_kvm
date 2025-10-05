目标是什么：
1. 多k8s管理
2. 集成harness的仓库，包括model、数据集、数据源、chart文件等
3. 集成kubeblock的数据库服务
4. 集成argo的ci和cd
5. 提供知识库服务
6. 提供 推理服务管理
7. 提供应用市场服务

组件设计：
1. ingress
2. 存储： openebs-lvs、hostpath, s3
3. 网络
4. 监控： metrics-server\prometheus\loki-destributed
5. 仓库： harbor、harnesss


参考设计： 
1. sealos
2. kit： ui可以快速复制



功能设计：

集群:

集群概览： 
    每个集群的pod状态： komodor参考    
        1. 蜂窝图，绿黄粉红，4个颜色代表不同的状态
        2、provider、 nodes数量，pods数量（严重、告警、缺失、正常）、分配率（cpu、内存、磁盘）、workload health、infrastucture health 
    overview：
        provider、k8s version, age, regions
        health: 
            workload health: service \workflows, jobs
            reliability risks: 
            issures over time: 
            infrastructure health: Nodes, pvc, cluster upgrades
        k8s add-ons: cert-manager , external-dns, node auto-scalers, workflow, lstio, policy as code
        cost optimization:
    
    workload health:
        failed workloads:
            service:  集群>namespace> service> 问题， duration， status(open)
            workflows
            jobs:

    pod详情：
        type： deployment、 cluster、namesapce、image
        health, replicas, duration, reason,         last deploy, changes, started,   

        events:
        logs:
        pods:
        nodes:
        info: 
        metrics:
        dependencies:
        yaml: 


        ai: 进行问题分析


helm管理 https://github.com/komodorio/helm-dashboard
    仓库管理：
    已经安装的服务查看：

KubeVela  也是一个应用交付平台，使用oam模型

用户管理、配额、工作空间管理：

多集群管理：

api聚合：   



## 存储： 
    OpenEBS - Mayastor：
        NVMe/NVMe over Fabrics (NVMe-oF)

    LINSTOR：
    cstor
    proxmox storage 
    Longhorn
    ceph
    Vitastor 

    Piraeus
    HwameiStor 是一款 Kubernetes 原生的容器附加存储 (CAS) 解决方案，将 HDD、SSD 和 NVMe 磁盘形成本地存储资源池进行统一管理，使用 CSI 架构提供分布式的本地数据卷服务，为有状态的云原生应用或组件提供数据持久化能力。
        可以通过cgroup设定最大iops
        使用drbd支持clone卷
        ： lvm volume
        ： disk volume
        ： ha volume： drbd
        dataload manager
        data set manager


## gpu 管理
DataTunerX（DTX）
HAMi - 异构算力虚拟化中间件：  英伟达 GPU， 寒武纪 MLU， 海光 DCU ，天数智芯 GPU

## 可观测行
fitlog trace、metric ebpf
## 巡检、测试
kdoctor 是一个 kubernetes 数据面测试项目，通过压力注入的方式，实现对集群进行功能、性能的主动式巡检。

## 微服务引擎
envoy
## 多云编排

## 服务网络
lstio
## 镜像仓库

harbor
[ORAS](!https://oras.land/)： Distribute Artifacts Across OCI Registries With Ease
## 应用工作台
argo