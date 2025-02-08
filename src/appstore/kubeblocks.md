

## 概念

一个 Cluster 由若干个 Component 组成，一个 Component 最终管理若干 Pod 和其它对象。
实例（Instance）是 KubeBlocks 中的基本单元，它由一个 Pod 和若干其它辅助对象组成。
可以为一个 Cluster 中的某个 Component 设置若干实例模板（Instance Template），实例模板中包含 Name、Replicas、Annotations、Labels、Env、Tolerations、NodeSelector等多个字段（Field），这些字段最终会覆盖（Override）默认模板（也就是在 ClusterDefinition 和 ComponentDefinition 中定义的 PodTemplate）中相应的字段，并生成最终的模板以便用来渲染实例。

### Reconciler

- appscontrollers.ClusterDefinitionReconciler： appsv1.ClusterDefinition
- appscontrollers.ShardingDefinitionReconciler
- appscontrollers.ComponentDefinitionReconciler
- appscontrollers.ComponentVersionReconciler
- appscontrollers.SidecarDefinitionReconciler
- appscontrollers.ServiceDescriptorReconciler
- cluster.ClusterReconciler
- component.ComponentReconciler
- k8scorecontrollers.EventReconciler
- configuration.ConfigConstraintReconciler
- configuration.ConfigurationReconciler
- configuration.ReconfigureReconciler
- workloadscontrollers.InstanceSetReconciler
- opscontrollers.OpsDefinitionReconciler
- opscontrollers.OpsRequestReconciler
- extensionscontrollers.AddonReconciler
- experimentalcontrollers.NodeCountScalerReconciler
- tracecontrollers.ReconciliationTraceReconciler

## InstanceSet

InstanceSet： 通用 Workload API，负责管理一组实例。KubeBlocks 中所有的 Workload 最终都通过 InstanceSet 进行管理。

InstanceSet 为其管理的每一个实例生成一个固定的名字，并会生成一个 Headless Service，从而使得每一个实例都有一个固定的网络标识。基于该标识，属于同一个 InstanceSet 的实例可以相互发现对方，属于同一个 Kubernetes 集群中的其它系统也可以发现该 InstanceSet 下的每个实例。
InstanceSet 通过 VolumeClaimTemplates 为每个实例生成固定标识的存储卷（Volume），其它实例或系统可以通过实例的固定标识找到实例，进而进一步访问到存储卷里的数据。
在进行更新时，InstanceSet 支持按照确定性顺序对所有实例进行滚动更新（RollingUpdate），并且可配置滚动更新的多种行为。
类似的，在进行水平扩缩容时，InstanceSet 会按照确定性的顺序进行添加或删除实例操作。
在这些基础特性之上，InstanceSet 针对数据库高可用等需求，进一步支持了原地更新、实例模板、指定实例下线、基于角色的服务、基于角色的更新策略等特性。

InstanceSet 在生成二级资源时，会为它们添加两个 Label：workloads.kubeblocks.io/managed-by=InstanceSet 和 workloads.kubeblocks.io/instance=<instanceSet.name>。可通过这两个 label 获取某个 InstanceSet 下的所有二级资源，包括 Pod 和 PVC。
