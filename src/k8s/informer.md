# intro

1. informer: Informer 能保证通过list+watch不会丢失事件，如果网络抖动重新恢复后，watch会带着之前的resourceVersion号重连，resourceVersion是单调递增的， API Server 收到该请求后会将所有大于该resourceVersion的变更同步过来。
2. Reflector: 用于 Watch 指定的 Kubernetes 资源，当 watch 的资源发生变化时，触发变更的事件，比如 Added，Updated 和 Deleted 事件，并将资源对象存放到本地缓存 DeltaFIFO；
3. DeltaFIFO：拆开理解，FIFO 就是一个队列，拥有队列基本方法（ADD，UPDATE，DELETE，LIST，POP，CLOSE 等），Delta 是一个资源对象存储，保存存储对象的消费类型，比如 Added，Updated，Deleted，Sync 等；
4. indexer: Client-go 用来存储资源对象并自带索引功能的本地存储，Reflector 从 DeltaFIFO 中将消费出来的资源对象存储到 Indexer，Indexer 与 Etcd 集群中的数据完全保持一致。从而 client-go 可以本地读取，减少 Kubernetes API 和 Etcd 集群的压力。
## informer
client-go 中提供了几种不同的 Informer：

1. 通过调用 NewInformer 函数创建一个简单的不带 indexer 的 Informer。
2. 通过调用 NewIndexerInformer 函数创建一个简单的带 indexer 的 Informer。
3. 通过调用 NewSharedIndexInformer 函数创建一个 Shared 的 Informer。
4. 通过调用 NewDynamicSharedInformerFactory 函数创建一个为 Dynamic 客户端的 Shared 的 Informer。

SharedInformerFactory.Core().V1().Nodes()
SharedInformerFactory.Core().V1().Pods()
SharedInformerFactory.Apps().V1().Deployments()
SharedInformerFactory.Core().V1().Secrets()
SharedInformerFactory.Batch().V1beta1().CronJobs()

### 二级缓存
二级缓存属于 Informer 的底层缓存机制，这两级缓存分别是 DeltaFIFO 和 LocalStore。这两级缓存的用途各不相同。DeltaFIFO 用来存储 Watch API 返回的各种事件 ，LocalStore 只会被 Lister 的 List/Get 方法访问 。

如果K8s每次想查看资源对象的状态，都要经历一遍List调用，显然对 API Server 也是一个不小的负担，对此，一个容易想到的方法是使用一个cache作保存，需要获取资源状态时直接调cache，当事件来临时除了响应事件外，也对cache进行刷新。

虽然 Informer 和 Kubernetes 之间没有 resync 机制，但 Informer 内部的这两级缓存之间存在 resync 机制。

### Resync
Resync 机制会将 Indexer 的本地缓存重新同步到 DeltaFIFO 队列中。一般我们会设置一个时间周期，让 Indexer 周期性地将缓存同步到队列中。直接 list/watch API Server 就已经能拿到集群中资源对象变化的 event 了，这里引入 Resync 的作用是什么呢？去掉会有什么影响呢？
