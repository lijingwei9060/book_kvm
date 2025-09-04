
# intro


argo-exec是实际流水线中执行每一步操作时创建的pod所用的容器，根据参数不同执行不同的操作。
每个pod都会有至少两个可见容器（不包括init），wait（等待容器），main（主要容器）。
1. init容器，挂载参数与制品
2. main的用处是执行本步骤需要完成的工作。
3. wait容器的作用时等待主要容器完成后输出制品与参数到流水线供其他步骤使用。


```shell
$ kubectl -n workflow describe pods custom-workflow-111-2fw2f-2639432629

Name:           custom-workflow-111-2fw2f-2639432629
Namespace:      workflow
Labels:         pipeline.starx.com/nodeID=743
                workflows.argoproj.io/completed=true
                workflows.argoproj.io/workflow=custom-workflow-111-2fw2f
Annotations:    cni.projectcalico.org/podIP: 10.42.0.83/32
                workflows.argoproj.io/node-name: custom-workflow-111-2fw2f.yolov3-evaluate-743
                workflows.argoproj.io/outputs:
                  {"result":...
                workflows.argoproj.io/template:
                  {"name":"yolov3-evaluate-743","inputs":{"parameters":[{"name":"userParam","value":"eyJTY29yZVRocmVzaG9sZCI6MC41LCJJb3VfVGhyZXNob2xkIjowLjQ...
Controlled By:  Workflow/custom-workflow-111-2fw2f
Init Containers:
  init:
    Image:         argoproj/argoexec:v2.3.0
    Command:
      argoexec
      init
    Environment:
      ARGO_POD_NAME:  custom-workflow-111-2fw2f-2639432629 (v1:metadata.name)
    Mounts:
      /argo/inputs/artifacts from input-artifacts (rw)
      /argo/podmetadata from podmetadata (rw)
      /argo/staging from argo-staging (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-lfk5b (ro)
Containers:
  wait:
    Image:         argoproj/argoexec:v2.3.0
    Command:
      argoexec
      wait
    Environment:
      ARGO_POD_NAME:  custom-workflow-111-2fw2f-2639432629 (v1:metadata.name)
    Mounts:
      /argo/podmetadata from podmetadata (rw)
      /mainctrfs/argo/staging from argo-staging (rw)
      /mainctrfs/tmp/artifacts/artifact-input0 from input-artifacts (rw,path="artifact0")
      /mainctrfs/tmp/artifacts/artifact-input1 from input-artifacts (rw,path="artifact1")
      /var/run/docker.sock from docker-sock (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-lfk5b (ro)
  main:
    Image:         registry.cn-shanghai.aliyuncs.com/xinhuodev/wt:0.4
    Command:
      sh
    Args:
      /argo/staging/script
    Mounts:
      /argo/staging from argo-staging (rw)
      /tmp/artifacts/artifact-input0 from input-artifacts (rw,path="artifact0")
      /tmp/artifacts/artifact-input1 from input-artifacts (rw,path="artifact1")
Volumes:
  podmetadata:
    Type:  DownwardAPI (a volume populated by information about the pod)
    Items:
      metadata.annotations -> annotations
  docker-sock:
    Type:          HostPath (bare host directory volume)
    Path:          /var/run/docker.sock
    HostPathType:  Socket
  input-artifacts:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  argo-staging:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  default-token-lfk5b:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-lfk5b
    Optional:    false
```

data处理，数据下载与转换两个步骤


## 过程

初始化容器 loadArtifacts: argo 创建的 Pod 的初始化容器执行了 argoexec init 命令，从名字上可以猜测出，这个容器负责初始化 Pod 中的环境，比如获取来上一步的输入等等，对应的代码是 cmd/argoexec/commands/init.go， 我们的分析也从这里开始。在执行 argo exec init之后，第一个调用的函数应该是loadArtifacts()。这个方法中做了三件事: initExecutor()、wfExecutor.StageFiles()、wfExecutor.LoadArtifacts()
1. 将input中的中间产物下载
2. 将script与resource中的资源写入到本地文件

InitDriver是初始化 Artifacts 的驱动。Argo 支持多种类型的存储系统，在 v2.3.0 这个版本支持: s3, http, git, artifactory, hdfs, raw。FindOverlappingVolume 是检查 artifacts 的路径和用户挂载的路径是否有重合。如果有，则返回深度最深的路径，如果没有，则返回 nil。如果返回 nil, 则使用 /argo/inputs/artifacts 作为 artifacts 的基础路径。否则使用 /mainctrfs 作为路径。下面就是下载文件，解压文件并修改权限了。注意在这里，init、wait和main容器都挂载了input-artifacts和argo-staging，并且 init 将输入和script放在了这两个卷中，所以其他几个卷都可以共享这些文件。

等待容器 waitContainer

wait容器的职责有以下几点:

等待 main 容器结束,杀死 sidecar,保存日志, 保存 parameters, 保存 artifacts, 获取脚本的输出流,将输出放在 Annotations 上

1. 等待main容器完成: Wait\KillSidecars, main 容器运行结束后，wait 容器会负责杀死其他容器, 遍历pod中的容器，排除main和wait,然后调用runtime来杀死容器
2. 捕获脚本输出: CaptureScriptResult 直接调用 runtime 去获取 main 容器的输出流，然后保存到 template.outputs 中
3. 保存参数与制品: SaveParameters/SaveArtifacts
4. 保存制品日志: argo 是支持将 main 容器中的日志持久化并保存到指定的地方的(s3, hdfs, Artifactory)。这在 argo 的文档上好像没有提到过。这一部分的逻辑比较简单，就是通过 ContainerRuntime 获取获取容器中的输出流，然后存成文件，通过 argo 中的 storage driver 保存下来。
5. 输出到任务结果: AnnotateOutputs 将 outputs 存在 pod 的 annotations 上。

主要容器