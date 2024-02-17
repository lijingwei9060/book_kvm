# intro


## pipeline框架

1. Module
   1. Default(Runtime, PipelineCache, moduleCache)
   2. AutoAssert()
   3. Init()
   4. AppendPostHook()
   5. Slogan()
   6. Util()
   7. Run(result)
   8. Is() => ModuleType: Task/Goroutine
2. Pipelien
   1. Init()
   2. ModulePostHooks
   3. RunModule(module)
3. Runtime框架
   1. BaseHost
   2. BaseRuntime
   3. Connection
   4. Connector
   5. Dialer
   6. Host
   7. ModuleRuntime
   8. Runner
   9. Tee
4. Runtime
   1. GetRunner().SudoCmd(string, boolean)
   2. RemoteHost().GetName()
5.  task.RemoteTask
    1.  Init()
    2.  Execute()
    3.  RunWithTimeout()
    4.  Run()
    5.  When() 
    6.  WhenWithRetry()
    7.  ExecuteWithRetry()
    8.  ExecuteRollback()
    9.  RollbackWithTimeout()
    10. RunRollback()
6.  task.Interface

## 安装流程

- precheck.GreetingsModule: 并行测试所有机器的可连接
- customscripts.CustomScriptsModule{Phase: "PreInstall", Scripts: runtime.Cluster.System.PreInstall}： 如果有PreInstall
- precheck.NodePreCheckModule： 检查docker、containerd版本，存储nfs、ceph、glusterfs，时间
- confirm.InstallConfirmModule： 简单的检查，然后提示是否安装
- artifact.UnArchiveModule： 本地校验md5， 本地解压
- os.RepositoryModule： GetOSData、同步iso文件、挂在iso、添加repo库，添加本地repo，安装软件包、reset repo、umount iso
- binaries.NodeBinariesModule： 下载一堆二进制文件(etcd, kubeadm, kubelet, kubectl, kubecni, helm, docker, cri-dockerd, crictl, containerd, runc, calicoctl), 从github上下载啊
- os.ConfigureOSModule： initOS.sh, Ntp
- kubernetes.StatusModule: Get K8s status
- container.InstallContainerModule: 安装容器运行时 dockerd、containerd，配置私有仓库认证信息
- images.CopyImagesToRegistryModule： push 私有的镜像
- images.PullModule： 在所有节点上拉去镜像
- etcd.PreCheckModule： 检查etcd状态
- etcd.CertsModule： etcd集群的证书
- etcd.InstallETCDBinaryModule： 安装etcd
- etcd.ConfigureModule{Skip: runtime.Cluster.Etcd.Type != kubekeyapiv1alpha2.KubeKey},
- etcd.BackupModule{Skip: runtime.Cluster.Etcd.Type != kubekeyapiv1alpha2.KubeKey},
- kubernetes.InstallKubeBinariesModule： 同步kubelet文件、服务、env
- loadbalancer.KubevipModule： 检查VIP、检查网卡、产生Kubevip-Manifest
- kubernetes.InitKubernetesModule： 生成kubeadm 的配置文件、audit policy、audit webhook、执行KubeadmInit、拷贝admin.conf、移除Master污点
- dns.ClusterDNSModule： 生成coredns configmap，apply、生成manifest、deploy、生成nodelocaldns configmap、apply、部署
- kubernetes.StatusModule： 获取集群状态
- kubernetes.JoinNodesModule： 生成kubeadm config，生成audit policy，生成audit webhook，join control-plane node， join worker node，拷贝admin.conf, 移除master 污点，为所有node添加worker标签
- loadbalancer.KubevipModule： 在master部署Kubevip
- loadbalancer.HaproxyModule{Skip: !runtime.Cluster.ControlPlaneEndpoint.IsInternalLBEnabled()},
- network.DeployNetworkPluginModule：部署网络插件Calico、Flannel、Cilium、KubeOVN、Hybridnet、MultusCNI
- kubernetes.ConfigureKubernetesModule： 配置所有node的名字
- filesystem.ChownModule： 修改$HOME/.kube的权限
- certs.AutoRenewCertsModule： 在master上，/usr/local/bin/kube-scripts/ k8s证书renew脚本，配置服务
- kubernetes.SecurityEnhancementModule： 安全加强，etcd
- kubernetes.SaveKubeConfigModule： 更新Kubeconfig
- plugins.DeployPluginsModule： 部署Kata、NodeFeatureDiscovery
- addons.AddonsModule： 安装Chart、yaml？
- storage.DeployLocalVolumeModule： OpenEBS
- kubesphere.DeployModule： KubeSphere ks-installer crd， kubesphere namespace，apply
- kubesphere.CheckResultModule： check ks-installer
- customscripts.CustomScriptsModule： post scripts