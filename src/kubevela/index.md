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
ComponentHealthCheck health check oam component:           appHander.checkComponentHealth(appParser, af),
WorkloadRender render application component into workload: appParser.ParseComponentFromRevisionAndClient(ctx, comp, appRev)
                                                           KubeHandlers: &providertypes.KubeHandlers{	Apply:  h.Dispatch,	Delete: h.Delete },
Deploy -> DeployWorkflowStepExecutor


WorkflowInstance: 一个application是一个完成的工作流instance，需要将内容分解成TaskRunner
TaskRunner




Workflow: 有可能指定，也可能没有指定，默认的workflow是什么？


AppFile： 从applicationd的spec生成AppFile，从AppFile生成Workflow、 []WorkflowStep
    WorkflowSteps： 从哪里来， 没有定义则NewChainWorkflowStepGenerator 生成
        WorkflowStepGenerator: 
            ChainWorkflowStepGenerator: 将下面的多个WorkflowStepGenerator串成一个chain，提供Generate方法
            RefWorkflowStepGenerator： 如果workflow.ref 引用了另外一个Workflow，就将这个workflow的steps读取然后复制过来
            
            Deploy2EnvWorkflowStepGenerator: 生成deploy2env workflow step针对application中的所有envs，也就是部署到多个环境时，生成多个WorkflowStep
                1. 如果已经存在steps，使用现有，不要生成
                2. 读取Spec.Policies, 如果类型是EnvBindingPolicy，针对每一个spec.Envs中的env，生成一个deploy2env的WorkflowStep，复制policy和env信息。
            ApplyComponentWorkflowStepGenerator： 
                1. 如果已经存在step就使用现有的不生成。
                2. 根据spec.Components中的组件生成一个ApplyComponent 类型的step，每个component生成一个step，类型有suspend，builtin-apply-component，step-group
            DeployWorkflowGenerator： 生成所有的拓扑步骤，根据Spec.Policies中的topology和override配置，生成deploy类型的WorkflowStep


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



### Workflow执行过程 kubevela/workflow

WorkflowEngine: 包含Instance、InstanceStatus、Steps和StepStatus

WorkflowInstance： 
    Status：保留整个工作流的运行状态信息
            ： Phase: initializing, executing, suspending, terminated, failed, succeeded, skipped
            Finished:
            Terminated:
    Mode： 保存step和subSteps类型是StepByStep还是Dag
StepStatusCache： 缓存执行Step结束的个数
WorkflowExecutor:
    ExecuteRunners(ctx monitorContext.Context, taskRunners []types.TaskRunner) (v1alpha1.WorkflowRunPhase, error): 按顺序执行task runner

StepStatus：


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

Deploy：
    1. policies处理
    2. 根据拓扑生成ReplicateComponents
    3. 根据override策略，覆盖配置
    4. 根据Replicate策略，修改components
    5. apply最终调用resourceKeeper的Dispatch
### cue

cuex.Compiler
GetProviders() map[string]cuexruntime.ProviderFn
### Context

wfContext.Context
monitor.Context
process.Context