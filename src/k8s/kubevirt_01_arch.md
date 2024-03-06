# intro

1. virt-api: 为 Kubevirt 提供 API 服务能力，比如许多自定义的 API 请求，如开机、关机、重启等操作，通过 APIService 作为 Kubernetes Apiserver 的插件，业务可以通过 Kubernetes Apiserver 直接请求到 virt-api；
2. virt-controller,virt-api：集群层面上全局唯一，主要作用是通过与k8s api server 通信完成vmi资源创建、virt-lanucher pod 的创建及状态更新等。
3. virt-handler:节点层面上唯一DaemonSet，负责与k8s api server、virt-lanucher通信来完成虚拟机的生命周期管理。
   1. 以 Daemonset 形式部署，功能类似于 Kubelet，通过 Watch 本机 VMI 和实例资源，管理本宿主机上所有虚机实例；
   2. 主要执行动作如下:
      1. 使 VMI 中定义的 Spec 与相应的 libvirt （本地 socket 通信）保持同步;
      2. 汇报及控制更新虚拟机状态;
      3. 调用相关插件初始化节点上网络和存储资源;
      4. 热迁移相关操作;
4. virt-launcher：根据vmi 定义生成虚拟机模板，通过与libvirt api 通信提供虚拟机生命周期管理。
   1. Kubevirt 会为每一个 VMI 对象创建一个 Pod，该 Pod 的主进程为 virt-launcher，virt-launcher 的 Pod 提供了 cgroups 和 namespaces 的隔离，virt-launcher 为虚拟机实例的主进程。
   2. virt-handler 通过将 VMI 的 CRD 对象传递给 virt-launcher 来通知 virt-launcher 启动 VMI。然后，virt-launcher 在其容器中使用本地 libvirtd 实例来启动 VMI。virt-launcher 托管 VMI 进程，并在 VMI 退出后终止。
   3. 如果 Kubernetes 运行时在 VMI 退出之前尝试关闭 virt-launcher 容器，virt-launcher 会将信号从Kubernetes 转发到 VMI 进程，并尝试推迟容器的终止，直到 VMI 成功关闭。

## 资源类型

1. VirtualMachineInstance简称VMI,可以简单与实际虚拟机一一对应。会创建一个包含virt-launcher的Pod，该Pod里面通过libvirt创建真实虚拟机。VMI的Spec字段指定虚拟机运行参数，Status字段记录虚拟机运行情况。
2. VirtualMachine简称VM，可以管理和操作VMI对象。一个VM对象只能管理一个VMI对象
3. VirtualMachineInstanceReplicaSet简称replicaset或rs，一个replicaset可以管理多个VMI对象，即一个ReplicaSet可以创建、修改、删除多个虚拟机。
4. VirtualMachineInstanceMigration简称Migration，在Migration对象的Spec字段里面指定要迁移的VMI，然后kubevirt自动对该VMI完成迁移。
5. DataVolume:  是对 PVC 之上的抽象，通过自定义数据源，由 CDI 控制器自动创建 PVC 并导入数据到 PVC 中供虚拟机使用。

## VMSpec

```yaml
apiVersion: kubevirt.io/v1alpha3
kind: VirtualMachine
metadata:
  labels:
    kubevirt.io/vm: vm-cirros
  name: vm-cirros
spec:
  running: false
  template:
    metadata:
      labels:
        kubevirt.io/vm: vm-cirros
    spec:
      domain:
        devices:
          disks:
          - disk:
              bus: virtio
            name: containerdisk
          - disk:
              bus: virtio
            name: cloudinitdisk
        machine:
          type: ""
        resources:
          requests:
            memory: 64M
      terminationGracePeriodSeconds: 0
      volumes:
      - name: containerdisk
        containerDisk:
          image: kubevirt/cirros-container-disk-demo:latest
      - cloudInitNoCloud:
          userDataBase64: IyEvYmluL3NoCgplY2hvICdwcmludGVkIGZyb20gY2xvdWQtaW5pdCB1c2VyZGF0YScK
        name: cloudinitdisk
```

## 创建VM流程
虚拟机创建分为创建 DataVolume(为虚拟机准备存储)和 VMI 两个部分。简要流程如下：
1. 用户通过 kubectl/api 创建 VM 对象；
2. virt-api 通过 webhook 校验 VM 对象；
3. virt-controller 监听到 VM 的创建，生成 VMI 对象；
4. virt-controller 监听到 VMI 的创建，判断虚拟机 DataVolume 是否被初始化，如果没有被初始化，则创建 DateVolume 初始化准备虚拟机需要的数据；
5. 虚拟机 DataVolume 初始化完成后，virt-controller 创建 virt-launcher Pod 来启动虚机；
6. kubernetes 调度虚拟机 Pod 到集群中的一台主机上；
7. virt-controller Watch 到 VMI 的容器已启动，更新 VMI 对象中的 nodeName 字段。后续工作由 virt-handler 接管以进行进一步的操作；
8. virt-handler（DaemonSet）Watch 到 VMI 已分配给运行它的主机上，通过获取 Domain 与 vmi 状态来决定发送命令启动虚拟机；
9. virt-launcher 获取到 virt-handler 命令，与 libvirtd 实例通信来操作虚拟机。

Pending：虚拟机实例已经创建，等待后续控制流程;
Scheduling：虚拟机 Pod 已经创建，正在调度中;
Scheduled：虚拟机 Pod 调度完成，并处于 running 状态，此状态后 virt-controller 控制结束，由 virt-handler 接管后续工作;
Running：虚拟机正常运行;
Succeeded：虚拟机由于收到 sigterm 信号或者内部关机操纵而退出;
Failed：由于异常情况导致虚拟机 crash;

## virt controller
入口在kubevirt/cmd/virt-controller/virt-controller.go
直接调用kubevirt/pkg/virt-controller/watch/application.go中的Execute函数启动virt-controller。下面主要分析Execute函数中的内容。
1. 获取leaderElectionConfiguration
2. 获取KubevirtClient
3. 获取informerFactory，并实例化一系列具体资源类型的Informer，例如crdInformer、kubeVirtInformer、vmiInformer、kvPodInformer、nodeInformer、vmInformer、migrationInformer等
4. 初始化一系列controller，包括vmiController、nodeController、migrationController、vmController、evacuationController、snapshotController、restoreController、replicaSetController、disruptionBudgetController
5. 通过leaderElector来启动virt-controller，并在leaderElector中启动各个controller的Run函数。


## VMController

代码位于kubevirt/pkg/virt-controller/watch/vm.go文件中。

1. 监听VM对象、VMI对象、DataVolume对象并添加对应的EventHandler。
2. 收到Event事件之后加入到workQueue。
   1. VM对象的Event事件直接加入workQueue。
   2. VMI对象的Event事件先判断是否由VM对象所控制，如果是则将该VM对象加入workQueue，否则找到匹配的VM，将匹配的VM加入到workQueue，尝试收养孤儿的VMI对象。
   3. DataVolume对象的Event事件先判断是否由VM对象所控制，如果是则将该VM对象加入workQueue，否则不处理。
3. 通过Run()->runWorker()->Execute()->execute()，从workQueue中取出对象的key，然后在execute中处理。
4. execute（）函数的处理逻辑
   1. 根据key，从Informer的本地缓存中获取VM对象。
   2. 创建VirtualMachineControllerRefManager。
   3. 根据key，从Informer的本地缓存中获取VMI对象
   4. 如果获取VMI对象成功，则VirtualMachineControllerRefManager尝试收养或遗弃VMI。
   5. 根据Spec.DataVolumeTemplates,从Informer的本地缓存中获取dataVolumes。
   6. 检查dataVolumes是否已经ready，若已经ready则调用startStop()
      1. RunStrategy==Always:虚拟机实例VMI应该总是存在，如果虚拟机实例VMI crash，会创建一个新的虚拟机。等同于spec.running:true。
      2. RunStrategy==RerunOnFailure:如果虚拟机实例VMI运行失败，会创建一个新的虚拟机。如果是由客户端主动成功关闭，则不会再重新创建。
      3. RunStrategy==Manual:虚拟机实例VMI运行状况通过start/stop/restart手工来控制。
      4. RunStrategy==Halted:虚拟机实例VMI应该总是挂起。等同于spec.running:false。
   7. 更新VMStatus
      1. 修改vm.Status.Created，vm.Status.Ready
      2. 修改vm.Status.StateChangeRequests
      3. 修改vm.Status.Conditions
      4. 更新VMStatus


## VMIC‍ontroller

代码位于kubevirt/pkg/virt-controller/watch/vmi.go文件中。

1. 监听VMI对象、Pod对象、DataVolume对象并添加对应的EventHandler。
2. 收到Event事件之后加入到workQueue。
   1. VMI对象的Event事件直接加入workQueue。
   2. Pod对象的Event事件先判断是否由VM对象所控制，如果是则将该VM对象加入workQueue，否则不处理。
   3. DataVolume对象的Event事件，根据DataVolume的Namespace和Name获取匹配的vmis，然后将vmis对象依次加入到workQueue。
3. 通过Run()->runWorker()->Execute()->execute()，从workQueue中取出对象的key，然后在execute中处理。
4. execute（）函数的处理逻辑
   1. 根据key，从Informer的本地缓存中获取VM对象。
   2. 获取和当前vmi对象匹配的Pod。
   3. 根据vmi.Spec.Volumes，获取匹配的DataVolumes对象。
   4. 同步sync，若Pod不存在，则创建lanucher所在的Pod。
   5. 更新vmi对象的status。


## MigrationController分析

代码位于kubevirt/pkg/virt-controller/watch/migration.go文件中。

1. 监听Migration对象、VMI对象、Pod对象并添加对应的EventHandler。
2. 收到Event事件之后加入到workQueue。
   1. VMI对象的Event事件直接加入workQueue。
   2. Pod对象的Event事件，根据Pod的Annotation中的migrationJonName来找到对应的migration对象，然后加入workQueue。
   3. VMI对象的Event事件，根据vmi的Namespace和Name获取匹配的Migration对象，然后加入到workQueue。
3. 通过Run()->runWorker()->Execute()->execute()，从workQueue中取出对象的key，然后在execute中处理。
4. execute（）函数的处理逻辑
   1. 根据key，从Informer的本地缓存中获取Migration对象。
   2. 根据Migration.namespace和Migration对象.Spec.VMIName来获取VMI对象。
   3. 获取迁移目标Pod。
   4. 同步sync。
   5. 更新Migration对象的status，Migration.Status.Phase状态转换为： unset - pending -scheduling - scheduled -prepareing target - targetReady - running

## ReplicaSetController分析

代码位于kubevirt/pkg/virt-controller/watch/replicaset.go文件中。

1. 监听replicaSet对象、VMI对象并添加对应的EventHandler。
2. 收到Event事件之后加入到workQueue。
   1. VMI对象的Event事件直接加入workQueue。
   2. VMI对象的Event事件，先判断是否由replicaSet对象控制，如果是则将该replicaSet加入到workQueue，否则找到与该VMI对象匹配的replicaSets，然后将replicaSets依次加入workQueue，尝试将该VMI对象收养。
3. 通过Run()->runWorker()->Execute()->execute()，从workQueue中取出对象的key，然后在execute中处理。
4. execute（）函数的处理逻辑
   1. 根据key，从Informer的本地缓存中获取Migration对象。
   2. 根据namespaces获取vmis。
   3. 根据获取replicaSet对象，创建VMControllerRefManager，然后尝试收养或遗弃vmis。
   4. 将vmis分成两组finishedVmis和activeVmis。
   5. 根据Spec.Replicas以及当前replicaset管理的activeVmis，对vmis进行扩容或者缩容。
   6. 更新replicaSet的Status。
