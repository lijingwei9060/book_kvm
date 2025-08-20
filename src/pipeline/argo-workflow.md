# intro

## TemplateType

TemplateTypeContainer    TemplateType = "Container"
TemplateTypeContainerSet TemplateType = "ContainerSet"
TemplateTypeSteps        TemplateType = "Steps"
TemplateTypeScript       TemplateType = "Script"
TemplateTypeResource     TemplateType = "Resource"
TemplateTypeDAG          TemplateType = "DAG"
TemplateTypeSuspend      TemplateType = "Suspend"
TemplateTypeData         TemplateType = "Data"
TemplateTypeHTTP         TemplateType = "HTTP"
TemplateTypePlugin       TemplateType = "Plugin"
TemplateTypeUnknown      TemplateType = "Unknown"


## NodePhase

// Node is waiting to run
NodePending NodePhase = "Pending"
// Node is running
NodeRunning NodePhase = "Running"
// Node finished with no errors
NodeSucceeded NodePhase = "Succeeded"
// Node was skipped
NodeSkipped NodePhase = "Skipped"
// Node or child of node exited with non-0 code
NodeFailed NodePhase = "Failed"
// Node had an error other than a non 0 exit code
NodeError NodePhase = "Error"
// Node was omitted because its `depends` condition was not met (only relevant in DAGs)
NodeOmitted NodePhase = "Omitted"

## NodeType

NodeTypePod       NodeType = "Pod"
NodeTypeContainer NodeType = "Container"
NodeTypeSteps     NodeType = "Steps"
NodeTypeStepGroup NodeType = "StepGroup"
NodeTypeDAG       NodeType = "DAG"
NodeTypeTaskGroup NodeType = "TaskGroup"
NodeTypeRetry     NodeType = "Retry"
NodeTypeSkipped   NodeType = "Skipped"
NodeTypeSuspend   NodeType = "Suspend"
NodeTypeHTTP      NodeType = "HTTP"
NodeTypePlugin    NodeType = "Plugin"


template(type)： 
    leaf -> 
        http
        script
        container
        containerSet(group of container 可以有依赖关系) A single Pod
        suspend：可以实现人工approval，wait timeout效果
        k8s resource:  
            Action(kubectl action): create, delete, apply, patch manifest(Job)， 注意他不会随着workflow删除而删除，可以配置GC
        plugin： slack、argo cd，python， chaos ， pr build，aws， pytorch， ray job
        start
        end
steps： list of lists, 外层顺序执行，内层并行执行
    parralel group：group有什么属性，人一
        steps： []WorkflowStep: 可以是一个template也可以是inline template。 需要配置对应的参数
    serial：
DAG：
    tasks： 默认并行，通过dependencies进行控制顺序


template 列表： name、template

所以有孤儿节点： add template， start链接谁，谁就是entrypoint，end怎么处理？




### features

retry：  
    retryStrategy： 
        limit "10"
        retryPolicy 

## workflow Spec

```javascript
TypeMeta,
ObjectMeta,
Spec: WorkflowSpec{
    // Templates is a list of workflow templates used in a workflow
	Templates []Template{
        // Name is the name of the template
        Name string `json:"name,omitempty" protobuf:"bytes,1,opt,name=name"`

        // Inputs describe what inputs parameters and artifacts are supplied to this template
        Inputs Inputs `json:"inputs,omitempty" protobuf:"bytes,5,opt,name=inputs"`

        // Outputs describe the parameters and artifacts that this template produces
        Outputs Outputs `json:"outputs,omitempty" protobuf:"bytes,6,opt,name=outputs"`

        // NodeSelector is a selector to schedule this step of the workflow to be
        // run on the selected node(s). Overrides the selector set at the workflow level.
        NodeSelector map[string]string `json:"nodeSelector,omitempty" protobuf:"bytes,7,opt,name=nodeSelector"`

        // Affinity sets the pod's scheduling constraints
        // Overrides the affinity set at the workflow level (if any)
        Affinity *apiv1.Affinity `json:"affinity,omitempty" protobuf:"bytes,8,opt,name=affinity"`

        // Metdata sets the pods's metadata, i.e. annotations and labels
        Metadata Metadata `json:"metadata,omitempty" protobuf:"bytes,9,opt,name=metadata"`

        // Daemon will allow a workflow to proceed to the next step so long as the container reaches readiness
        Daemon *bool `json:"daemon,omitempty" protobuf:"bytes,10,opt,name=daemon"`

        // Steps define a series of sequential/parallel workflow steps
        Steps []ParallelSteps{
            // Note: the `json:"steps"` part exists to workaround kubebuilder limitations.
            // There isn't actually a "steps" key in the JSON serialization; this is an anonymous list.
            // See the custom Unmarshaller below and ./hack/manifests/crd.go
            Steps []WorkflowStep{
                // Name of the step
                Name string `json:"name,omitempty" protobuf:"bytes,1,opt,name=name"`

                // Template is the name of the template to execute as the step
                Template string `json:"template,omitempty" protobuf:"bytes,2,opt,name=template"`

                // Inline is the template. Template must be empty if this is declared (and vice-versa).
                // Note: This struct is defined recursively, since the inline template can potentially contain
                // steps/DAGs that also has an "inline" field. Kubernetes doesn't allow recursive types, so we
                // need "x-kubernetes-preserve-unknown-fields: true" in the validation schema.
                // +kubebuilder:pruning:PreserveUnknownFields
                Inline *Template `json:"inline,omitempty" protobuf:"bytes,13,opt,name=inline"`

                // Arguments hold arguments to the template
                Arguments Arguments `json:"arguments,omitempty" protobuf:"bytes,3,opt,name=arguments"`

                // TemplateRef is the reference to the template resource to execute as the step.
                TemplateRef *TemplateRef `json:"templateRef,omitempty" protobuf:"bytes,4,opt,name=templateRef"`

                // WithItems expands a step into multiple parallel steps from the items in the list
                // Note: The structure of WithItems is free-form, so we need
                // "x-kubernetes-preserve-unknown-fields: true" in the validation schema.
                // +kubebuilder:validation:Schemaless
                // +kubebuilder:pruning:PreserveUnknownFields
                WithItems []Item `json:"withItems,omitempty" protobuf:"bytes,5,rep,name=withItems"`

                // WithParam expands a step into multiple parallel steps from the value in the parameter,
                // which is expected to be a JSON list.
                WithParam string `json:"withParam,omitempty" protobuf:"bytes,6,opt,name=withParam"`

                // WithSequence expands a step into a numeric sequence
                WithSequence *Sequence `json:"withSequence,omitempty" protobuf:"bytes,7,opt,name=withSequence"`

                // When is an expression in which the step should conditionally execute
                When string `json:"when,omitempty" protobuf:"bytes,8,opt,name=when"`

                // ContinueOn makes argo to proceed with the following step even if this step fails.
                // Errors and Failed states can be specified
                ContinueOn *ContinueOn `json:"continueOn,omitempty" protobuf:"bytes,9,opt,name=continueOn"`

                // OnExit is a template reference which is invoked at the end of the
                // template, irrespective of the success, failure, or error of the
                // primary template.
                // DEPRECATED: Use Hooks[exit].Template instead.
                OnExit string `json:"onExit,omitempty" protobuf:"bytes,11,opt,name=onExit"`

                // Hooks holds the lifecycle hook which is invoked at lifecycle of
                // step, irrespective of the success, failure, or error status of the primary step
                Hooks LifecycleHooks= map[eventType]LifecycleHook{
                    // Template is the name of the template to execute by the hook
                    Template string `json:"template,omitempty" protobuf:"bytes,1,opt,name=template"`
                    // Arguments hold arguments to the template
                    Arguments Arguments `json:"arguments,omitempty" protobuf:"bytes,2,opt,name=arguments"`
                    // TemplateRef is the reference to the template resource to execute by the hook
                    TemplateRef *TemplateRef `json:"templateRef,omitempty" protobuf:"bytes,3,opt,name=templateRef"`
                    // Expression is a condition expression for when a node will be retried. If it evaluates to false, the node will not
                    // be retried and the retry strategy will be ignored
                    Expression string `json:"expression,omitempty" protobuf:"bytes,4,opt,name=expression"`
                }
            }
        }

        // Container is the main container image to run in the pod
        Container *apiv1.Container `json:"container,omitempty" protobuf:"bytes,12,opt,name=container"`

        // ContainerSet groups multiple containers within a single pod.
        ContainerSet *ContainerSetTemplate `json:"containerSet,omitempty" protobuf:"bytes,40,opt,name=containerSet"`

        // Script runs a portion of code against an interpreter
        Script *ScriptTemplate `json:"script,omitempty" protobuf:"bytes,13,opt,name=script"`

        // Resource template subtype which can run k8s resources
        Resource *ResourceTemplate `json:"resource,omitempty" protobuf:"bytes,14,opt,name=resource"`

        // DAG template subtype which runs a DAG
        DAG *DAGTemplate{
            // Target are one or more names of targets to execute in a DAG
            Target string `json:"target,omitempty" protobuf:"bytes,1,opt,name=target"`

            // Tasks are a list of DAG tasks
            // +patchStrategy=merge
            // +patchMergeKey=name
            Tasks []DAGTask{
                // Name is the name of the target
                Name string `json:"name" protobuf:"bytes,1,opt,name=name"`

                // Name of template to execute
                Template string `json:"template,omitempty" protobuf:"bytes,2,opt,name=template"`

                // Inline is the template. Template must be empty if this is declared (and vice-versa).
                // Note: As mentioned in the corresponding definition in WorkflowStep, this struct is defined recursively,
                // so we need "x-kubernetes-preserve-unknown-fields: true" in the validation schema.
                // +kubebuilder:pruning:PreserveUnknownFields
                Inline *Template `json:"inline,omitempty" protobuf:"bytes,14,opt,name=inline"`

                // Arguments are the parameter and artifact arguments to the template
                Arguments Arguments `json:"arguments,omitempty" protobuf:"bytes,3,opt,name=arguments"`

                // TemplateRef is the reference to the template resource to execute.
                TemplateRef *TemplateRef `json:"templateRef,omitempty" protobuf:"bytes,4,opt,name=templateRef"`

                // Dependencies are name of other targets which this depends on
                Dependencies []string `json:"dependencies,omitempty" protobuf:"bytes,5,rep,name=dependencies"`

                // WithItems expands a task into multiple parallel tasks from the items in the list
                // Note: The structure of WithItems is free-form, so we need
                // "x-kubernetes-preserve-unknown-fields: true" in the validation schema.
                // +kubebuilder:validation:Schemaless
                // +kubebuilder:pruning:PreserveUnknownFields
                WithItems []Item `json:"withItems,omitempty" protobuf:"bytes,6,rep,name=withItems"`

                // WithParam expands a task into multiple parallel tasks from the value in the parameter,
                // which is expected to be a JSON list.
                WithParam string `json:"withParam,omitempty" protobuf:"bytes,7,opt,name=withParam"`

                // WithSequence expands a task into a numeric sequence
                WithSequence *Sequence `json:"withSequence,omitempty" protobuf:"bytes,8,opt,name=withSequence"`

                // When is an expression in which the task should conditionally execute
                When string `json:"when,omitempty" protobuf:"bytes,9,opt,name=when"`

                // ContinueOn makes argo to proceed with the following step even if this step fails.
                // Errors and Failed states can be specified
                ContinueOn *ContinueOn `json:"continueOn,omitempty" protobuf:"bytes,10,opt,name=continueOn"`

                // OnExit is a template reference which is invoked at the end of the
                // template, irrespective of the success, failure, or error of the
                // primary template.
                // DEPRECATED: Use Hooks[exit].Template instead.
                OnExit string `json:"onExit,omitempty" protobuf:"bytes,11,opt,name=onExit"`

                // Depends are name of other targets which this depends on
                Depends string `json:"depends,omitempty" protobuf:"bytes,12,opt,name=depends"`

                // Hooks hold the lifecycle hook which is invoked at lifecycle of
                // task, irrespective of the success, failure, or error status of the primary task
                Hooks LifecycleHooks `json:"hooks,omitempty" protobuf:"bytes,13,opt,name=hooks"`
            }

            // This flag is for DAG logic. The DAG logic has a built-in "fail fast" feature to stop scheduling new steps,
            // as soon as it detects that one of the DAG nodes is failed. Then it waits until all DAG nodes are completed
            // before failing the DAG itself.
            // The FailFast flag default is true,  if set to false, it will allow a DAG to run all branches of the DAG to
            // completion (either success or failure), regardless of the failed outcomes of branches in the DAG.
            // More info and example about this feature at https://github.com/argoproj/argo-workflows/issues/1442
            FailFast *bool `json:"failFast,omitempty" protobuf:"varint,3,opt,name=failFast"`
        }

        // Suspend template subtype which can suspend a workflow when reaching the step
        Suspend *SuspendTemplate `json:"suspend,omitempty" protobuf:"bytes,16,opt,name=suspend"`

        // Data is a data template
        Data *Data `json:"data,omitempty" protobuf:"bytes,39,opt,name=data"`

        // HTTP makes a HTTP request
        HTTP *HTTP `json:"http,omitempty" protobuf:"bytes,42,opt,name=http"`

        // Plugin is a plugin template
        // Note: the structure of a plugin template is free-form, so we need to have
        // "x-kubernetes-preserve-unknown-fields: true" in the validation schema.
        // +kubebuilder:pruning:PreserveUnknownFields
        Plugin *Plugin `json:"plugin,omitempty" protobuf:"bytes,43,opt,name=plugin"`

        // Volumes is a list of volumes that can be mounted by containers in a template.
        // +patchStrategy=merge
        // +patchMergeKey=name
        Volumes []apiv1.Volume `json:"volumes,omitempty" patchStrategy:"merge" patchMergeKey:"name" protobuf:"bytes,17,opt,name=volumes"`

        // InitContainers is a list of containers which run before the main container.
        // +patchStrategy=merge
        // +patchMergeKey=name
        InitContainers []UserContainer `json:"initContainers,omitempty" patchStrategy:"merge" patchMergeKey:"name" protobuf:"bytes,18,opt,name=initContainers"`

        // Sidecars is a list of containers which run alongside the main container
        // Sidecars are automatically killed when the main container completes
        // +patchStrategy=merge
        // +patchMergeKey=name
        Sidecars []UserContainer `json:"sidecars,omitempty" patchStrategy:"merge" patchMergeKey:"name" protobuf:"bytes,19,opt,name=sidecars"`

        // Location in which all files related to the step will be stored (logs, artifacts, etc...).
        // Can be overridden by individual items in Outputs. If omitted, will use the default
        // artifact repository location configured in the controller, appended with the
        // <workflowname>/<nodename> in the key.
        ArchiveLocation *ArtifactLocation `json:"archiveLocation,omitempty" protobuf:"bytes,20,opt,name=archiveLocation"`

        // Optional duration in seconds relative to the StartTime that the pod may be active on a node
        // before the system actively tries to terminate the pod; value must be positive integer
        // This field is only applicable to container and script templates.
        ActiveDeadlineSeconds *intstr.IntOrString `json:"activeDeadlineSeconds,omitempty" protobuf:"bytes,21,opt,name=activeDeadlineSeconds"`

        // RetryStrategy describes how to retry a template when it fails
        RetryStrategy *RetryStrategy `json:"retryStrategy,omitempty" protobuf:"bytes,22,opt,name=retryStrategy"`

        // Parallelism limits the max total parallel pods that can execute at the same time within the
        // boundaries of this template invocation. If additional steps/dag templates are invoked, the
        // pods created by those templates will not be counted towards this total.
        Parallelism *int64 `json:"parallelism,omitempty" protobuf:"bytes,23,opt,name=parallelism"`

        // FailFast, if specified, will fail this template if any of its child pods has failed. This is useful for when this
        // template is expanded with `withItems`, etc.
        FailFast *bool `json:"failFast,omitempty" protobuf:"varint,41,opt,name=failFast"`

        // Tolerations to apply to workflow pods.
        // +patchStrategy=merge
        // +patchMergeKey=key
        Tolerations []apiv1.Toleration `json:"tolerations,omitempty" patchStrategy:"merge" patchMergeKey:"key" protobuf:"bytes,24,opt,name=tolerations"`

        // If specified, the pod will be dispatched by specified scheduler.
        // Or it will be dispatched by workflow scope scheduler if specified.
        // If neither specified, the pod will be dispatched by default scheduler.
        // +optional
        SchedulerName string `json:"schedulerName,omitempty" protobuf:"bytes,25,opt,name=schedulerName"`

        // PriorityClassName to apply to workflow pods.
        PriorityClassName string `json:"priorityClassName,omitempty" protobuf:"bytes,26,opt,name=priorityClassName"`

        // ServiceAccountName to apply to workflow pods
        ServiceAccountName string `json:"serviceAccountName,omitempty" protobuf:"bytes,28,opt,name=serviceAccountName"`

        // AutomountServiceAccountToken indicates whether a service account token should be automatically mounted in pods.
        // ServiceAccountName of ExecutorConfig must be specified if this value is false.
        AutomountServiceAccountToken *bool `json:"automountServiceAccountToken,omitempty" protobuf:"varint,32,opt,name=automountServiceAccountToken"`

        // Executor holds configurations of the executor container.
        Executor *ExecutorConfig `json:"executor,omitempty" protobuf:"bytes,33,opt,name=executor"`

        // HostAliases is an optional list of hosts and IPs that will be injected into the pod spec
        // +patchStrategy=merge
        // +patchMergeKey=ip
        HostAliases []apiv1.HostAlias `json:"hostAliases,omitempty" patchStrategy:"merge" patchMergeKey:"ip" protobuf:"bytes,29,opt,name=hostAliases"`

        // SecurityContext holds pod-level security attributes and common container settings.
        // Optional: Defaults to empty.  See type description for default values of each field.
        // +optional
        SecurityContext *apiv1.PodSecurityContext `json:"securityContext,omitempty" protobuf:"bytes,30,opt,name=securityContext"`

        // PodSpecPatch holds strategic merge patch to apply against the pod spec. Allows parameterization of
        // container fields which are not strings (e.g. resource limits).
        PodSpecPatch string `json:"podSpecPatch,omitempty" protobuf:"bytes,31,opt,name=podSpecPatch"`

        // Metrics are a list of metrics emitted from this template
        Metrics *Metrics `json:"metrics,omitempty" protobuf:"bytes,35,opt,name=metrics"`

        // Synchronization holds synchronization lock configuration for this template
        Synchronization *Synchronization `json:"synchronization,omitempty" protobuf:"bytes,36,opt,name=synchronization,casttype=Synchronization"`

        // Memoize allows templates to use outputs generated from already executed templates
        Memoize *Memoize `json:"memoize,omitempty" protobuf:"bytes,37,opt,name=memoize"`

        // Timeout allows to set the total node execution timeout duration counting from the node's start time.
        // This duration also includes time in which the node spends in Pending state. This duration may not be applied to Step or DAG templates.
        Timeout string `json:"timeout,omitempty" protobuf:"bytes,38,opt,name=timeout"`

        // Annotations is a list of annotations to add to the template at runtime
        Annotations map[string]string `json:"annotations,omitempty" protobuf:"bytes,44,opt,name=annotations"`
    },

	// Entrypoint is a template reference to the starting point of the workflow.
	Entrypoint string

	// Arguments contain the parameters and artifacts sent to the workflow entrypoint
	// Parameters are referencable globally using the 'workflow' variable prefix.
	// e.g. {{workflow.parameters.myparam}}
	Arguments Arguments

	// ServiceAccountName is the name of the ServiceAccount to run all pods of the workflow as.
	ServiceAccountName string

	// AutomountServiceAccountToken indicates whether a service account token should be automatically mounted in pods.
	// ServiceAccountName of ExecutorConfig must be specified if this value is false.
	AutomountServiceAccountToken bool

	// Executor holds configurations of executor containers of the workflow.
	Executor *ExecutorConfig

	// Volumes is a list of volumes that can be mounted by containers in a workflow.
	Volumes []apiv1.Volume 

	// VolumeClaimTemplates is a list of claims that containers are allowed to reference.
	// The Workflow controller will create the claims at the beginning of the workflow
	// and delete the claims upon completion of the workflow
	VolumeClaimTemplates []apiv1.PersistentVolumeClaim
	// Parallelism limits the max total parallel pods that can execute at the same time in a workflow
	Parallelism *int64

	// ArtifactRepositoryRef specifies the configMap name and key containing the artifact repository config.
	ArtifactRepositoryRef *ArtifactRepositoryRef

	// Suspend will suspend the workflow and prevent execution of any future steps in the workflow
	Suspend *bool

	// NodeSelector is a selector which will result in all pods of the workflow
	// to be scheduled on the selected node(s). This is able to be overridden by
	// a nodeSelector specified in the template.
	NodeSelector map[string]string 

	// Affinity sets the scheduling constraints for all pods in the workflow.
	// Can be overridden by an affinity specified in the template
	Affinity *apiv1.Affinity 

	// Tolerations to apply to workflow pods.
	// +patchStrategy=merge
	// +patchMergeKey=key
	Tolerations []apiv1.Toleration

	// ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images
	// in pods that reference this ServiceAccount. ImagePullSecrets are distinct from Secrets because Secrets
	// can be mounted in the pod, but ImagePullSecrets are only accessed by the kubelet.
	// More info: https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
	ImagePullSecrets []apiv1.LocalObjectReference

	// Host networking requested for this workflow pod. Default to false.
	HostNetwork *bool

	// Set DNS policy for workflow pods.
	// Defaults to "ClusterFirst".
	// Valid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'.
	// DNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy.
	// To have DNS options set along with hostNetwork, you have to specify DNS policy
	// explicitly to 'ClusterFirstWithHostNet'.
	DNSPolicy *apiv1.DNSPolicy 

	// PodDNSConfig defines the DNS parameters of a pod in addition to
	// those generated from DNSPolicy.
	DNSConfig *apiv1.PodDNSConfig

	// OnExit is a template reference which is invoked at the end of the
	// workflow, irrespective of the success, failure, or error of the
	// primary workflow.
	OnExit string

	// TTLStrategy limits the lifetime of a Workflow that has finished execution depending on if it
	// Succeeded or Failed. If this struct is set, once the Workflow finishes, it will be
	// deleted after the time to live expires. If this field is unset,
	// the controller config map will hold the default values.
	TTLStrategy *TTLStrategy

	// Optional duration in seconds relative to the workflow start time which the workflow is
	// allowed to run before the controller terminates the workflow. A value of zero is used to
	// terminate a Running workflow
	ActiveDeadlineSeconds *int64

	// Priority is used if controller is configured to process limited number of workflows in parallel. Workflows with higher priority are processed first.
	Priority *int32

	// Set scheduler name for all pods.
	// Will be overridden if container/script template's scheduler name is set.
	// Default scheduler will be used if neither specified.
	SchedulerName string

	// PodGC describes the strategy to use when deleting completed pods
	PodGC?: PodGC

	// PriorityClassName to apply to workflow pods.
	PodPriorityClassName?: string,

	HostAliases?: []apiv1.HostAlias,

	// SecurityContext holds pod-level security attributes and common container settings.
	// Optional: Defaults to empty.  See type description for default values of each field.
	SecurityContext?: apiv1.PodSecurityContext 

	// PodSpecPatch holds strategic merge patch to apply against the pod spec. Allows parameterization of
	// container fields which are not strings (e.g. resource limits).
	PodSpecPatch string `json:"podSpecPatch,omitempty" protobuf:"bytes,27,opt,name=podSpecPatch"`

	// PodDisruptionBudget holds the number of concurrent disruptions that you allow for Workflow's Pods.
	// Controller will automatically add the selector with workflow name, if selector is empty.
	// Optional: Defaults to empty.
	// +optional
	PodDisruptionBudget *policyv1.PodDisruptionBudgetSpec `json:"podDisruptionBudget,omitempty" protobuf:"bytes,31,opt,name=podDisruptionBudget"`

	// Metrics are a list of metrics emitted from this Workflow
	Metrics *Metrics `json:"metrics,omitempty" protobuf:"bytes,32,opt,name=metrics"`

	// Shutdown will shutdown the workflow according to its ShutdownStrategy
	Shutdown ShutdownStrategy `json:"shutdown,omitempty" protobuf:"bytes,33,opt,name=shutdown,casttype=ShutdownStrategy"`

	// WorkflowTemplateRef holds a reference to a WorkflowTemplate for execution
	WorkflowTemplateRef *WorkflowTemplateRef `json:"workflowTemplateRef,omitempty" protobuf:"bytes,34,opt,name=workflowTemplateRef"`

	// Synchronization holds synchronization lock configuration for this Workflow
	Synchronization *Synchronization `json:"synchronization,omitempty" protobuf:"bytes,35,opt,name=synchronization,casttype=Synchronization"`

	// VolumeClaimGC describes the strategy to use when deleting volumes from completed workflows
	VolumeClaimGC *VolumeClaimGC `json:"volumeClaimGC,omitempty" protobuf:"bytes,36,opt,name=volumeClaimGC,casttype=VolumeClaimGC"`

	// RetryStrategy for all templates in the workflow.
	RetryStrategy *RetryStrategy `json:"retryStrategy,omitempty" protobuf:"bytes,37,opt,name=retryStrategy"`

	// PodMetadata defines additional metadata that should be applied to workflow pods
	PodMetadata *Metadata `json:"podMetadata,omitempty" protobuf:"bytes,38,opt,name=podMetadata"`

	// TemplateDefaults holds default template values that will apply to all templates in the Workflow, unless overridden on the template-level
	TemplateDefaults?: Template

	// ArchiveLogs indicates if the container logs should be archived
	ArchiveLogs *bool `json:"archiveLogs,omitempty" protobuf:"varint,40,opt,name=archiveLogs"`

	// Hooks holds the lifecycle hook which is invoked at lifecycle of
	// step, irrespective of the success, failure, or error status of the primary step
	Hooks LifecycleHooks `json:"hooks,omitempty" protobuf:"bytes,41,opt,name=hooks"`

	// WorkflowMetadata contains some metadata of the workflow to refer to
	WorkflowMetadata?: WorkflowMetadata,

	// ArtifactGC describes the strategy to use when deleting artifacts from completed or deleted workflows (applies to all output Artifacts
	// unless Artifact.ArtifactGC is specified, which overrides this)
	ArtifactGC?: WorkflowLevelArtifactGC


},

Status: WorkflowStatus{

}
```