## bach job

自动清理： 每次 job 执行完成后手动回收非常麻烦，k8s 在 v1.12 版本中加入了 TTLAfterFinished feature-gates，启用该特性后会启动一个 TTL 控制器，在创建 job 时指定后可在 job 运行完成后自动回收相关联的 pod，如上文中的 yaml 所示，创建 job 时指定了 ttlSecondsAfterFinished: 60，job 在执行完成后停留 60s 会被自动回收， 若 ttlSecondsAfterFinished 设置为 0 则表示在 job 执行完成后立刻回收。当 TTL 控制器清理 job 时，它将级联删除 job，即 pod 和 job 一起被删除。不过该特性截止目前还是 Alpha 版本，请谨慎使用。
扩缩容： job 不支持运行时扩缩容，job 在创建后其 spec.completions 字段也不支持修改。
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  backoffLimit: 6                // 标记为 failed 前的重试次数，默认为 6
  completions: 4                 // 要完成job 的 pod 数，若没有设定该值则默认等于 parallelism 的值
  parallelism: 2                 // 任意时间最多可以启动多少个 pod 同时运行，默认为 1
  activeDeadlineSeconds: 120     // job 运行时间
  ttlSecondsAfterFinished: 60    // job 在运行完成后 60 秒就会自动删除掉
  template:
    spec:
      containers:
      - command:
        - sh
        - -c
        - 'echo ''scale=5000; 4*a(1)'' | bc -l '
        image: resouer/ubuntu-bc
        name: pi
      restartPolicy: Never
```

```shell
$ kubectl get pod
pi-gdrwr                            0/1     Completed   0          10m
pi-rjphf                            0/1     Completed   0          10m

$ kubectl delete job pi
```

### 数据结构

Job

### syncjob

syncJob 是 jobController 的核心方法，其主要逻辑为：
1、从 lister 中获取 job 对象；
2、判断 job 是否已经执行完成，当 job 的 .status.conditions 中有 Complete 或 Failed 的 type 且对应的 status 为 true 时表示该 job 已经执行完成。
3、获取 job 重试的次数；
4、调用 jm.expectations.SatisfiedExpectations 判断 job 是否需能进行 sync 操作，Expectations 机制在之前写的” ReplicaSetController 源码分析“一文中详细讲解过，其主要判断条件如下：
    1、该 key 在 ControllerExpectations 中的 adds 和 dels 都 <= 0，即调用 apiserver 的创建和删除接口没有失败过；
    2、该 key 在 ControllerExpectations 中已经超过 5min 没有更新了；
    3、该 key 在 ControllerExpectations 中不存在，即该对象是新创建的；
    4、调用 GetExpectations 方法失败，内部错误；
5、调用 jm.getPodsForJob 通过 selector 获取 job 关联的 pod，若有孤儿 pod 的 label 与 job 的能匹配则进行关联，若已关联的 pod label 有变化则解除与 job 的关联关系；
6、分别计算 active、succeeded、failed 状态的 pod 数；
7、判断 job 是否为首次启动，若首次启动其 job.Status.StartTime 为空，此时首先设置 startTime，然后检查是否有 job.Spec.ActiveDeadlineSeconds 是否为空，若不为空则将其再加入到延迟队列中，等待 ActiveDeadlineSeconds 时间后会再次触发 sync 操作；
8、判断 job 的重试次数是否超过了 job.Spec.BackoffLimit(默认是6次)，有两个判断方法一是 job 的重试次数以及 job 的状态，二是当 job 的 restartPolicy 为 OnFailure 时 container 的重启次数，两者任一个符合都说明 job 处于 failed 状态且原因为 BackoffLimitExceeded；
9、判断 job 的运行时间是否达到 job.Spec.ActiveDeadlineSeconds 中设定的值，若已达到则说明 job 此时处于 failed 状态且原因为 DeadlineExceeded；
10、根据以上判断如果 job 处于 failed 状态，则调用 jm.deleteJobPods 并发删除所有 active pods ；
11、若非 failed 状态，根据 jobNeedsSync 判断是否要进行同步，若需要同步则调用 jm.manageJob 进行同步；
12、通过检查 job.Spec.Completions 判断 job 是否已经运行完成，若 job.Spec.Completions 字段没有设置值则只要有一个 pod 运行完成该 job 就为 Completed 状态，若设置了 job.Spec.Completions 会通过判断已经运行完成状态的 pod 即 succeeded pod 数是否大于等于该值；
13、通过以上判断若 job 运行完成了，则更新 job.Status.Conditions 和 job.Status.CompletionTime 字段；
14、如果 job 的 status 有变化，将 job 的 status 更新到 apiserver；

### manageJob： 并发管理

jm.manageJob它主要做的事情就是根据 job 配置的并发数来确认当前处于 active 的 pods 数量是否合理，如果不合理的话则进行调整，其主要逻辑为：

1、首先获取 job 的 active pods 数与可运行的 pod 数即 job.Spec.Parallelism；
2、判断如果处于 active 状态的 pods 数大于 job 设置的并发数 job.Spec.Parallelism，则并发删除多余的 active pods，需要删除的 active pods 是有一定的优先级的，删除的优先级为：
    1、判断是否绑定了 node：Unassigned < assigned；
    2、判断 pod phase：PodPending < PodUnknown < PodRunning；
    3、判断 pod 状态：Not ready < ready；
    4、若 pod 都为 ready，则按运行时间排序，运行时间最短会被删除：empty time < less time < more time；
    5、根据 pod 重启次数排序：higher restart counts < lower restart counts；
    6、按 pod 创建时间进行排序：Empty creation time pods < newer pods < older pods；
3、若处于 active 状态的 pods 数小于 job 设置的并发数，则需要根据 job 的配置计算 pod 的 diff 数并进行创建，计算方法与 completions、parallelism 以及 succeeded 的 pods 数有关，计算出 diff 数后会进行批量创建，创建的 pod 数依次为 1、2、4、8......，呈指数级增长，job 创建 pod 的方式与 rs 创建 pod 是类似的，但是此处并没有限制在一个 syncLoop 中创建 pod 的上限值，创建完 pod 后会将结果记录在 job 的 expectations 中，此处并非所有的 pod 都能创建成功，若超时错误会直接忽略，因其他错误创建失败的 pod 会记录在 expectations 中，expectations 机制的主要目的是减少不必要的 sync 操作，至于其详细的说明可以参考之前写的 ” ReplicaSetController 源码分析“ 一文；