# intro

1. API： 核心api/分组api/健康检查/日志/openapi/性能度量
2. filter chain：认证 授权 准入控制 mutating validating webhook
3. registry： pod namespace apps crd
4. cache：apps 
5. storage: etcd

kube-apiserver提供了3种http server服务，用于将庞大的kube-apiserver组件功能进行解耦，这三种Http Server分别如下， 三种服务底层都依赖GenericAPIServer，通过GenericAPIServer可以将k8s资源与rest api进行映射：
1. KubeAPIServer： 核心服务，提供k8s内置核心资源服务，不允许开发者随意修改，如：Pod，Service等。Master，Legacyscheme.Scheme
2. APIExtensionsServer：API扩展服务，该服务提供了CRD自定义资源服务，CustomResourceDefinitions，extensionsapiserver.Scheme
3. AggregatorServer： API聚合服务，提供了聚合服务，APIAggregator，aggregatorscheme.Scheme

启动：按序分别初始化 APIServer 链(APIExtensionsServer、KubeAPIServer、AggregatorServer)，分别服务于 CRD(用户自定义资源)、K8s API(内置资源)、API Service(API 扩展资源) 对应的资源请求。


## 存储接口

第一步创建 RESTStorage 将后端存储与资源进行绑定，第二步才进行路由注册
NewLegacyRESTStorage 方法，先为每个资源的 RESTStorage 初始化，资源：podTemplate, Event, limitRange, ResourceQuota, Secret, PV, PVC
再将资源和对应的 RESTStorage 进行绑定map[string]rest.Storage{}

存储接口的实现：

CreateServerChain 创建服务调用链 → CreateKubeAPIServerConfig 创建 kubeAPIServerConfig 配置 → buildGenericConfig 生成 kubeAPIServerConfig 配置中的 genericConfig 配置 → ApplyWithStorageFactoryTo 初始化 genericConfig 配置的 RESTOptionsGetter

存储接口的使用：

CreateServerChain 创建服务调用链 → CreateKubeAPIServer 初始化服务传入 kubeAPIServerConfig 配置 → kubeAPIServerConfig.Complete().New(delegateAPIServer) → InstallLegacyAPI 核心路由注册传入 kubeAPIServerConfig.GenericConfig.RESTOptionsGetter 存储实现

## REF

https://qiankunli.github.io/2019/01/05/kubernetes_source_apiserver.html

https://mp.weixin.qq.com/s/L0DI_w-dVWxiHoSBnPUUtg