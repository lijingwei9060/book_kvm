## 组件

Application
    Components:
        scaler->ref-objects
        env--webservice
    Workflow:
        ref

Template:    
    WorkloadDefinition
    ComponentDefinition
    TraitDefinition
    WorkflowStepDefinition
    PolicyDefinition


```cue
#K8sObject: {
	// +usage=The resource type for the Kubernetes objects
	resource?: string
	// +usage=The group name for the Kubernetes objects
	group?: string
	// +usage=If specified, fetch the Kubernetes objects with the name, exclusive   to labelSelector
	name?: string
	// +usage=If specified, fetch the Kubernetes  objects from the namespace. Otherwise, fetch from the application's namespace.
	namespace?: string
	// +usage=If specified, fetch the Kubernetes objects from the cluster. Otherwise, fetch from the local cluster.
	cluster?: string
	// +usage=If specified, fetch the Kubernetes objects according to the label selector, exclusive to name
	labelSelector?: [string]: string
	...
}

output: {
	if len(parameter.objects) > 0 {
		parameter.objects[0]
	}
	...
}

outputs: {
	for i, v in parameter.objects {
		if i > 0 {
			\"objects-\\(i)\": v
		}
	}
}
parameter: {
	// +usage=If specified, application will fetch native Kubernetes objects according to the object description
	objects?: [...#K8sObject]
	// +usage=If specified, the objects in the urls will be loaded.
	urls?: [...string]
}

```
## Application 应用部署计划

待部署组件 components:   Component[] 
    运维动作（Trait）
应用的执行策略（Policy） : 
部署工作流（Workflow）:


### 组件（Component）

KubeVela 内置即支持多种类型的组件交付，包括 Helm Chart、容器镜像、CUE 模块、Terraform 模块等等

### 运维特征（Trait）

应用的执行策略（Policy）负责定义应用级别的部署特征，比如健康检查规则、安全组、防火墙、SLO、检验等模块。

### 部署执行工作流（Workflow）

内置的工作流步骤节点包括了创建资源、条件判断、数据输入输出等。




### components

DeployWorkflowStepExecutor executor to run deploy workflow step

ResourceKeeper: ResourceKeeper handler for dispatching and deleting resources
ResourceTracker: An ResourceTracker represents a tracker for track cross namespace resources
    - root: ResourceTrackerTypeRoot means resources in this resourceTracker will only be recycled when application is deleted
    - versioned:  ResourceTrackerTypeVersioned means resources in this resourceTracker will be recycled when this version is unused and this resource is not managed by latest RT
    - component-revision: ResourceTrackerTypeComponentRevision stores all component revisions used


multicluster:
    GetClusterGatewayService get cluster gateway backend service reference
    WaitUntilClusterGatewayReady wait cluster gateway service to be ready to serve
    Initialize prepare multicluster environment by checking cluster gateway service in clusters and hack rest config to use cluster gateway
    UpgradeExistingClusterSecret upgrade outdated cluster secrets in v1.1.1 to latest
    ListExistingClusterSecrets list existing cluster secrets
    ListClusters
    Deploy
    GetPlacementsFromTopologyPolicies: gets placements from topology policies
    GetProviders: returns the cue providers.


ComponentApply apply oam component:                        appHandler.applyComponentFunc(appParser, af),
ComponentRender render oam component:                      appHandler.renderComponentFunc(appParser, af),
ComponentHealthCheck health check oam component:           appHandler.checkComponentHealth(appParser, af),
WorkloadRender render application component into workload: appParser.ParseComponentFromRevisionAndClient(ctx, comp, appRev)
                                                           KubeHandlers: &providertypes.KubeHandlers{	Apply:  h.Dispatch,	Delete: h.Delete },
Deploy -> DeployWorkflowStepExecutor


WorkflowInstance: 一个application是一个完成的工作流instance，需要将内容分解成TaskRunner
TaskRunner




Workflow: 有可能指定，也可能没有指定，默认的workflow是什么？


AppFile： 从applicationd的spec生成AppFile，从AppFile生成Workflow、 []WorkflowStep
    


WorkflowStep:
    WorkflowStepBase
    mode: dag/stepbystep
    subSteps: []WorkflowStepBase
    
WorkflowStepBase：
    name
    type
    inputs
    output
    meta: *WorkflowStepMeta
    dependson: []string
    properties: RawExtension

WorkflowInstance
TaskRunner

Application.Status： Parsed -> Revision -> ApplyPolices -> Render -> Workflow -> Ready
    parsed: 从application获取AppFile，AppFile中生成Workflow、[]WorkflowStep， 生成AppHandler
    Revision: todo: ,貌似生成一个Revision， 然后写入到k8s中，更新Application.Status.LastRevision
    ApplyPolicies: todo:， 生成policyManifests， 然后Dispatch
    Render: 生成WorkflowInstance和TaskRunner
    Workflow： 执行WorkflowInstance阶段，WorkflowInstance执行的结果可以是：Suspend、Terminated、Failed、Executing、Succeeded、Skipped
    StateKeep?
    Ready: GC后，正常就Ready

各种client
WorkflowClient 使用 client.Client

Template: component type 对应的模板，可通过vela def list查看所有template，类型有ComponentDefinition, TraitDefinition,

### 如何解析Cue


parseComponent： 根据template和属性生成Component
    1. 通过模板Loader，获取TypeComponentDefinition类型的template，
    2. 属性来自ApplicationComponent.Properties
    3. 生成Component，里面有个AbstractEngine， 什么时候执行这个engine呢？ 在apply、render、healthcheck的时候会调用0



convertTemplate2Component： template就是cue语法写的模板，props从哪里来？


render：
    context： 
        parameter: addon.Parameters
        metadata: addon.Meta
        parameter： input args
    
    addon.CUETemplates
    main.cue: addon.AppCueTemplate.Data,
    parameter.cue: 

```cue
package main
parameter: {
    // +usage=The clusters to install
    clusters?: [...string]
    namespace: string
}
context: {"metadata":{"name":"velaux","version":"","description":"","icon":"","deployTo":{"disableControlPlane":false,"runtimeCluster":true},"invisible":false}}
parameter: {"namespace":"vela-system"}

```

### Workflow工作流

包含Workflow Engine 和Provider system。

WorkflowStepGenerator：负责生成Step，具体的有`ChainWorkflowStepGenerator`, `RefWorkflowStepGenerator`, `ApplyComponentWorkflowStepGenerator`,`Deploy2EnvWorkflowStepGenerator`, `DeployWorkflowStepGenerator`。
StepExecutor：执行workflow steps，调用provider
Provider：`ProviderFn`, 提供信息
HealthChecker：
Statusmanager：

AppFile执行的是ChainWorkflowStepGenerator，包含Ref、Deploy、Deploy2Env、ApplyComponent几个Generator，也是按照这个顺序执行。
WorkflowSteps： 
        WorkflowStepGenerator: 
            ChainWorkflowStepGenerator: 将下面的多个WorkflowStepGenerator串成一个chain，提供Generate方法
            RefWorkflowStepGenerator： 如果workflow.ref 引用了另外一个Workflow，就将这个workflow的steps读取然后复制过来
            DeployWorkflowGenerator： 生成所有的拓扑步骤，根据Spec.Policies中的topology和override配置，生成deploy类型的WorkflowStep。为每个 topology policy 生成一个 step，每个 step 中除了关联当前 topology 之外，还关联了全部的 override policy。
            Deploy2EnvWorkflowStepGenerator: 生成deploy2env workflow step针对application中的所有envs，也就是部署到多个环境时，生成多个WorkflowStep
                1. 如果已经存在steps，使用现有，不要生成
                2. 读取Spec.Policies, 如果类型是EnvBindingPolicy，针对每一个spec.Envs中的env，生成一个deploy2env的WorkflowStep，复制policy和env信息。
            ApplyComponentWorkflowStepGenerator： 
                1. 如果已经存在step就使用现有的不生成。
                2. 如果前面几个步骤都没有成功生成才会执行这部分逻辑，生成一个 apply-component 类型的 WorkflowStep，直接将组件部署到 local 集群的 default 命名空间。根据spec.Components中的组件生成一个ApplyComponent 类型的step，每个component生成一个step，类型有suspend，builtin-apply-component，step-group
        以上 3 个 Generateor 按照层级分可以这样： 
            RefWorkflowStepGenerator：正常逻辑，只是解析了用户指定的 RefWorkflow
            DeployWorkflowStepGenerator：优化逻辑，自动根据 topology policy 生成 Workflow
            ApplyComponentWorkflowStepGenerator：兜底逻辑，就算没有任何 Workflow 以及 topology 类型的 policy 都能生成一个 apply-component 类型的 WorkflowStep 保证 Component 正常部署也就是说，在最极限的情况下，Application 对象里我们可以只写 Component，就能保证正常运行。       

Provider system： 注册为CUE运行时函数

RenderComponent： 渲染组件
ApplyComponent： 应用组件到集群中，等待健康
LoadComponent： 加载组件定义
LoadComponentInOrder： 按序加载组件
LoadPolicies： 加载policy 定义

### Workflow Engine 执行过程 kubevela/workflow

1. 并行、串行的管理
2. 步骤的管理
3. 外部依赖函数的注入
4. 状态管理

工作流执行引擎中包含哪些组件？：
1. RuntimeParams： 将Provider系统注册进去
2. WorkflowInstance： 记录step和step的运行状态结果
3. TaskRunner： 每个WorkflowStep转换成TaskRunner，后续执行。为什么需要一个Runner，它转换了什么，增加了什么？
4. WorkflowExecutor： 
5. WorkflowRunStatus: phase、子steps，开始结束时间，
6. WorkflowRunPhase： initializing/executing/suspending/terminated/failed/succeeded/skipped
7. StepStatusCache： 一个Map，缓存runner运行到哪里了
8. engine： 私有组件，主要以steps方式或者dag方式执行runner。
9. executor: 私有组件，代表一个TaskRunner
10. StepStatus

engine：
    runAsDAG(): 有向无环图执行，
        将runner根据Pending()判断分为马上可以执行的todoTasks和需要等待的pendingTasks
        对于todoTasks使用steps()按序执行
        needStop():
        对于pendingTasks再次使用runAsDAG()进行执行
    steps()： 按照顺序执行：

WorkflowEngine: 包含Instance、InstanceStatus、Steps和StepStatus

WorkflowInstance： 总集WorkflowStep，Appfile，Application
    Status：保留整个工作流的运行状态信息
            ： Phase: initializing, executing, suspending, terminated, failed, succeeded, skipped
            Finished:
            Terminated:
    Mode： 保存step和subSteps类型是StepByStep还是Dag
StepStatusCache： 缓存执行Step结束的个数
WorkflowExecutor:
    ExecuteRunners(ctx monitorContext.Context, taskRunners []types.TaskRunner) (v1alpha1.WorkflowRunPhase, error): 按顺序执行task runner


executor：
    tracer
    Skip()
    Suspend()
    Resume()
    Terminate()
    Wait()
    Fail()
    Message()
    operation()
    status()
    operation()
    timeout()
    err()
TaskLoader:

TaskRunner： 
    1. 将provider系统集成进去，增加Apply Function、Render Function、HealthCheck、 WorkloadRender、client。
    Pending(ctx monitorContext.Context, wfCtx wfContext.Context, stepStatus map[string]v1alpha1.StepStatus) (bool, v1alpha1.StepStatus)： 根据DependsOn和Inputs判断是否需要pending
        1. 首先检查DependsOn列表中是否有没有结束的Step，如果有就pending
        2. 根据Inputs列表中，先从WorkflowContext检查需要的变量是否存在，如果不存在从cue中检查变量是否存在，不存在就pending
            1. cue变量的构造：使用cue编译WorkflowStep.Properties
        3. 返回不需要pending
    Run(ctx wfContext.Context, options *types.TaskRunOptions) (v1alpha1.StepStatus, *types.Operation, error)
        1. 创建monitorContext，为后面GetTracer支持
        2. 在context上追加RuntimeParams: workflow.context, process.context, action: executor
        3. 编译cue的变量输入
        4. PreCheckHook： 结果可以是error、skip、timeout，对应返回结果
        5. PreStartHook: 失败返回err
        6. 初始化或者拷贝StepStatus
        7. 将cue变量和传递cue模板，编译执行，⭐️，使用kubevela的扩展cue， 阅读：[CUE Basic](https://kubevela.io/docs/platform-engineers/cue/basic/), 
        8. 这个时候还是展开或者生成各种文本，类型为 WorkflowStepDefinition，
        9. 调用step的方法应用到k8s上，有Deploy、
    FillContextData(ctx monitorContext.Context, processCtx process.Context) types.ContextDataResetter
        1. 构造一个Context填充和删除的过程，添加step的name、id、spanid，起止时间，返回一个删除函数，是一个ContextDataResetter，重置process.Context

从step到runner： AppHandler.GenerateApplicationSteps -> generator.GenerateRunners -> generateTaskRunner()


Deploy：
    1. policies处理
    2. 根据拓扑生成ReplicateComponents
    3. 根据override策略，覆盖配置
    4. 根据Replicate策略，修改components
    5. apply最终调用resourceKeeper的Dispatch

### StepType 和 Provider 系统

apply-component： OAM提供通过ApplyComponentWorkflowStepGenerator注入
suspend： 内置，可暂停workflow 执行，手工通过后恢复
step-group： 多个step 集合
deploy： multi-cluster通过DeployWorkflowStepGenerator
deploy2env： multi-cluster通过Deploy2EnvWorkflowStepGenerator注入。

### cue

cuex.Compiler
GetProviders() map[string]cuexruntime.ProviderFn
### Context

wfContext.Context
monitor.Context
process.Context


### 资源跟踪和管理

要做什么：
1. 资源跟踪，管理集群、命名空间和资源的对应关系。
2. 资源维护： 生命周期，回收，dispatch？
3. 过程： 自动或者手工回收应用程序的资源。从application到资源有个对应关系。
4. 资源策略： 准入控制、共享和更新策略。
5. 多集群管理：
6. 交互管理： cli工具

resourcekeeper： dispatch、delete
ResourceTracker：通过label


ResourceKeeper：
    ResourceTracker
    ApplyOncePolicySpec
    GarbageCollectPolicySpec
    SharedResourcePolicySpec
    TakeOverPolicySpec
    ReadOnlyPolicySpec
    ResourceUpdatePolicySpec
    Applicator
    Cache


#### GC： 回收资源和处理finalizer

1. mark：哪些资源需要回收？rootRT、currentRT会进行标记，historyRT确认管理的资源可回收。工作在拟合阶段。
2. sweep
3. finalize：



#### 资源查看

[kubevela_deepwiki](https://deepwiki.com/search/resourcekeeper_b76f6df4-a8e0-4c47-b288-e65f6dc8f77f)

```shell
root@bcs-ubuntu-01:~# vela status addon-loki  -n vela-system --tree
CLUSTER       NAMESPACE       RESOURCE                                 STATUS    
local     ─┬─ -           ─┬─ ClusterRole/o11y-system:log-event        updated   
           │               ├─ ClusterRole/o11y-system:vector           updated   
           │               ├─ ClusterRoleBinding/o11y-system:log-event updated   
           │               └─ ClusterRoleBinding/o11y-system:vector    updated   
           ├─ o11y-system ─┬─ ConfigMap/loki                           updated   
           │               ├─ ConfigMap/vector                         updated   
           │               ├─ Service/loki                             updated   
           │               ├─ ServiceAccount/log-event                 updated   
           │               ├─ ServiceAccount/vector                    updated   
           │               ├─ DaemonSet/vector                         updated   
           │               ├─ Deployment/event-log                     updated   
           │               ├─ Deployment/loki                          updated   
           │               ├─ Role/vector                              updated   
           │               └─ RoleBinding/vector                       updated   
           └─ vela-system ─── Secret/loki-vela                         updated 
```

首先从集群中加载指定的 Application 对象，然后调用 ListApplicationResourceTrackers() 获取该应用的所有 ResourceTracker。
ResourceTracker 是 KubeVela 的核心资源追踪机制，每个应用会有多个类型的 ResourceTracker：
- 根 RT：记录与应用生命周期绑定的资源
- 当前 RT：记录最新版本应用的资源
- 历史 RT：记录旧版本应用的资源
- 组件 RT：记录组件修订版本信息

从当前和历史 ResourceTracker 中加载所有资源行, 添加应该部署但尚未部署的集群信息，按集群、命名空间和资源类型排序， 以树状结构输出，使用 Unicode 绘图字符显示层级关系