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


## etcd数据

```shell
alias etcdctl='etcdctl \
	--key=/etc/kubernetes/pki/etcd/server.key \
	--cert=/etc/kubernetes/pki/etcd/server.crt  \
	--cacert=/etc/kubernetes/pki/etcd/ca.crt \
	--endpoints https://127.0.0.1:2379'
```


1. 除了/registry/apiregistration.k8s.io是直接存储JSON格式的，其他资源默认都不是使用JSON格式直接存储，而是通过protobuf格式存储, 除非手动配置`--storage-media-type=application/json`。
2. /registry/secret默认仅仅使用了base64编码而并没有加密，secret保存着私钥证书、Docker登录信息、密码等敏感数据


Key列表:
minions其实就是node

```shell
/registry/apiregistration.k8s.io/apiservices/v1.
/registry/apiregistration.k8s.io/apiservices/v1.apps
/registry/apiregistration.k8s.io/apiservices/v1.authentication.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.autoscaling
/registry/apiregistration.k8s.io/apiservices/v1.batch
/registry/apiregistration.k8s.io/apiservices/v1.networking.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.rbac.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1.storage.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.admissionregistration.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.apiextensions.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.apps
/registry/apiregistration.k8s.io/apiservices/v1beta1.authentication.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.batch
/registry/apiregistration.k8s.io/apiservices/v1beta1.certificates.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.events.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.extensions
/registry/apiregistration.k8s.io/apiservices/v1beta1.policy
/registry/apiregistration.k8s.io/apiservices/v1beta1.rbac.authorization.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta1.storage.k8s.io
/registry/apiregistration.k8s.io/apiservices/v1beta2.apps
/registry/apiregistration.k8s.io/apiservices/v2beta1.autoscaling
/registry/certificatesigningrequests/node-csr-NMpLG7rhBYiuAyRD739h79x2qhbhWn-UtLPFwJWJU1Y
/registry/certificatesigningrequests/node-csr-v96LRHUfeRD3iAZgHdUYxDaT1kkHvIilDnLZy2GPSew
/registry/clusterrolebindings/cluster-admin
/registry/clusterrolebindings/flannel
/registry/clusterrolebindings/heapster
/registry/clusterrolebindings/kubeadm:kubelet-bootstrap
/registry/clusterrolebindings/kubeadm:node-autoapprove-bootstrap
/registry/clusterrolebindings/kubeadm:node-autoapprove-certificate-rotation
/registry/clusterrolebindings/kubeadm:node-proxier
/registry/clusterrolebindings/kubernetes-dashboard
/registry/clusterrolebindings/system:aws-cloud-provider
/registry/clusterrolebindings/system:basic-user
/registry/clusterrolebindings/system:controller:attachdetach-controller
/registry/clusterrolebindings/system:controller:certificate-controller
/registry/clusterrolebindings/system:controller:clusterrole-aggregation-controller
/registry/clusterrolebindings/system:controller:cronjob-controller
/registry/clusterrolebindings/system:controller:daemon-set-controller
/registry/clusterrolebindings/system:controller:deployment-controller
/registry/clusterrolebindings/system:controller:disruption-controller
/registry/clusterrolebindings/system:controller:endpoint-controller
/registry/clusterrolebindings/system:controller:generic-garbage-collector
/registry/clusterrolebindings/system:controller:horizontal-pod-autoscaler
/registry/clusterrolebindings/system:controller:job-controller
/registry/clusterrolebindings/system:controller:namespace-controller
/registry/clusterrolebindings/system:controller:node-controller
/registry/clusterrolebindings/system:controller:persistent-volume-binder
/registry/clusterrolebindings/system:controller:pod-garbage-collector
/registry/clusterrolebindings/system:controller:replicaset-controller
/registry/clusterrolebindings/system:controller:replication-controller
/registry/clusterrolebindings/system:controller:resourcequota-controller
/registry/clusterrolebindings/system:controller:route-controller
/registry/clusterrolebindings/system:controller:service-account-controller
/registry/clusterrolebindings/system:controller:service-controller
/registry/clusterrolebindings/system:controller:statefulset-controller
/registry/clusterrolebindings/system:controller:ttl-controller
/registry/clusterrolebindings/system:coredns
/registry/clusterrolebindings/system:discovery
/registry/clusterrolebindings/system:kube-controller-manager
/registry/clusterrolebindings/system:kube-dns
/registry/clusterrolebindings/system:kube-scheduler
/registry/clusterrolebindings/system:node
/registry/clusterrolebindings/system:node-proxier
/registry/clusterroles/admin
/registry/clusterroles/cluster-admin
/registry/clusterroles/edit
/registry/clusterroles/flannel
/registry/clusterroles/system:aggregate-to-admin
/registry/clusterroles/system:aggregate-to-edit
/registry/clusterroles/system:aggregate-to-view
/registry/clusterroles/system:auth-delegator
/registry/clusterroles/system:aws-cloud-provider
/registry/clusterroles/system:basic-user
/registry/clusterroles/system:certificates.k8s.io:certificatesigningrequests:nodeclient
/registry/clusterroles/system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
/registry/clusterroles/system:controller:attachdetach-controller
/registry/clusterroles/system:controller:certificate-controller
/registry/clusterroles/system:controller:clusterrole-aggregation-controller
/registry/clusterroles/system:controller:cronjob-controller
/registry/clusterroles/system:controller:daemon-set-controller
/registry/clusterroles/system:controller:deployment-controller
/registry/clusterroles/system:controller:disruption-controller
/registry/clusterroles/system:controller:endpoint-controller
/registry/clusterroles/system:controller:generic-garbage-collector
/registry/clusterroles/system:controller:horizontal-pod-autoscaler
/registry/clusterroles/system:controller:job-controller
/registry/clusterroles/system:controller:namespace-controller
/registry/clusterroles/system:controller:node-controller
/registry/clusterroles/system:controller:persistent-volume-binder
/registry/clusterroles/system:controller:pod-garbage-collector
/registry/clusterroles/system:controller:replicaset-controller
/registry/clusterroles/system:controller:replication-controller
/registry/clusterroles/system:controller:resourcequota-controller
/registry/clusterroles/system:controller:route-controller
/registry/clusterroles/system:controller:service-account-controller
/registry/clusterroles/system:controller:service-controller
/registry/clusterroles/system:controller:statefulset-controller
/registry/clusterroles/system:controller:ttl-controller
/registry/clusterroles/system:coredns
/registry/clusterroles/system:discovery
/registry/clusterroles/system:heapster
/registry/clusterroles/system:kube-aggregator
/registry/clusterroles/system:kube-controller-manager
/registry/clusterroles/system:kube-dns
/registry/clusterroles/system:kube-scheduler
/registry/clusterroles/system:node
/registry/clusterroles/system:node-bootstrapper
/registry/clusterroles/system:node-problem-detector
/registry/clusterroles/system:node-proxier
/registry/clusterroles/system:persistent-volume-provisioner
/registry/clusterroles/view
/registry/configmaps/kube-public/cluster-info
/registry/configmaps/kube-system/coredns
/registry/configmaps/kube-system/extension-apiserver-authentication
/registry/configmaps/kube-system/kube-flannel-cfg
/registry/configmaps/kube-system/kube-proxy
/registry/configmaps/kube-system/kubeadm-config
/registry/configmaps/kube-system/kubernetes-dashboard-settings
/registry/controllerrevisions/kube-system/kube-flannel-ds-dd8484577
/registry/controllerrevisions/kube-system/kube-proxy-95cfb667c
/registry/cronjobs/default/hello
/registry/daemonsets/kube-system/kube-flannel-ds
/registry/daemonsets/kube-system/kube-proxy
/registry/deployments/default/flower
/registry/deployments/default/pc-saveapi
/registry/deployments/default/pxxxm-django
/registry/deployments/default/pxxxm-redis
/registry/deployments/default/pxxxm-tengine-proxy
/registry/deployments/default/pxxxm-tengine-static
/registry/deployments/default/pxxxmlogapi-nj
/registry/deployments/kube-system/coredns
/registry/deployments/kube-system/heapster
/registry/deployments/kube-system/kubernetes-dashboard
/registry/deployments/kube-system/monitoring-grafana
/registry/deployments/kube-system/monitoring-influxdb
/registry/events/default/flower-554b58b968-n48sj.151de36ccc190d41
/registry/events/default/flower-554b58b968-n48sj.151de36e0d128ca9
/registry/events/default/hello.151e1bcd521ee391
/registry/jobs/default/hello-1521622920
/registry/jobs/default/hello-1521622980
/registry/jobs/default/hello-1521623040
/registry/minions/cnsz131381
/registry/minions/cnsz131382
/registry/minions/cnsz131383
/registry/namespaces/default
/registry/namespaces/kube-public
/registry/namespaces/kube-system
/registry/pods/default/flower-554b58b968-n48sj
/registry/pods/default/hello-1521622920-5z4bl
/registry/pods/default/hello-1521622980-4qcrd
/registry/pods/default/hello-1521623040-szf4f
/registry/pods/default/pc-saveapi-58cf87b4f5-5x2d8
/registry/pods/default/pxxxm-django-8466f46d84-4mjtf
/registry/pods/default/pxxxm-django-8466f46d84-pnqzp
/registry/pods/default/pxxxm-django-8466f46d84-x5d8z
/registry/pods/default/pxxxm-redis-767c5d5966-l88qj
/registry/pods/default/pxxxm-tengine-proxy-75d874d898-8275h
/registry/pods/default/pxxxm-tengine-static-7d7bb5d5b6-7568z
/registry/pods/default/pxxxmlogapi-nj-687cc89b96-ps4np
/registry/pods/kube-system/coredns-65dcdb4cf-hgmdv
/registry/pods/kube-system/etcd-cnsz131383
/registry/pods/kube-system/heapster-5996df699d-d8798
/registry/pods/kube-system/kube-apiserver-cnsz131383
/registry/pods/kube-system/kube-controller-manager-cnsz131383
/registry/pods/kube-system/kube-flannel-ds-gr8jp
/registry/pods/kube-system/kube-flannel-ds-p4tpq
/registry/pods/kube-system/kube-flannel-ds-z7s96
/registry/pods/kube-system/kube-proxy-cgjhk
/registry/pods/kube-system/kube-proxy-f7snz
/registry/pods/kube-system/kube-proxy-l98gl
/registry/pods/kube-system/kube-scheduler-cnsz131383
/registry/pods/kube-system/kubernetes-dashboard-5bd6f767c7-vr6sg
/registry/pods/kube-system/monitoring-grafana-6bf544559d-cd6d4
/registry/pods/kube-system/monitoring-influxdb-865d95895b-n9sls
/registry/ranges/serviceips
/registry/ranges/servicenodeports
/registry/replicasets/default/flower-554b58b968
/registry/replicasets/default/pc-saveapi-58cf87b4f5
/registry/replicasets/default/pxxxm-django-8466f46d84
/registry/replicasets/default/pxxxm-redis-767c5d5966
/registry/replicasets/default/pxxxm-tengine-proxy-75d874d898
/registry/replicasets/default/pxxxm-tengine-static-7d7bb5d5b6
/registry/replicasets/default/pxxxmlogapi-nj-687cc89b96
/registry/replicasets/kube-system/coredns-65dcdb4cf
/registry/replicasets/kube-system/heapster-5996df699d
/registry/replicasets/kube-system/kubernetes-dashboard-5bd6f767c7
/registry/replicasets/kube-system/monitoring-grafana-6bf544559d
/registry/replicasets/kube-system/monitoring-influxdb-865d95895b
/registry/rolebindings/kube-public/kubeadm:bootstrap-signer-clusterinfo
/registry/rolebindings/kube-public/system:controller:bootstrap-signer
/registry/rolebindings/kube-system/kubernetes-dashboard-minimal
/registry/rolebindings/kube-system/system::leader-locking-kube-controller-manager
/registry/rolebindings/kube-system/system::leader-locking-kube-scheduler
/registry/rolebindings/kube-system/system:controller:bootstrap-signer
/registry/rolebindings/kube-system/system:controller:cloud-provider
/registry/rolebindings/kube-system/system:controller:token-cleaner
/registry/roles/kube-public/kubeadm:bootstrap-signer-clusterinfo
/registry/roles/kube-public/system:controller:bootstrap-signer
/registry/roles/kube-system/extension-apiserver-authentication-reader
/registry/roles/kube-system/kubernetes-dashboard-minimal
/registry/roles/kube-system/system::leader-locking-kube-controller-manager
/registry/roles/kube-system/system::leader-locking-kube-scheduler
/registry/roles/kube-system/system:controller:bootstrap-signer
/registry/roles/kube-system/system:controller:cloud-provider
/registry/roles/kube-system/system:controller:token-cleaner
/registry/secrets/default/default-token-hfj82
/registry/secrets/kube-public/default-token-wpbfs
/registry/secrets/kube-system/attachdetach-controller-token-7jsks
/registry/secrets/kube-system/bootstrap-signer-token-xs87g
/registry/secrets/kube-system/certificate-controller-token-x4swr
/registry/secrets/kube-system/clusterrole-aggregation-controller-token-z7w85
/registry/secrets/kube-system/coredns-token-tbbbw
/registry/secrets/kube-system/cronjob-controller-token-p44bn
/registry/secrets/kube-system/daemon-set-controller-token-4klc2
/registry/secrets/kube-system/default-token-g9lcp
/registry/secrets/kube-system/deployment-controller-token-gfcdt
/registry/secrets/kube-system/disruption-controller-token-vs4dz
/registry/secrets/kube-system/endpoint-controller-token-92kn2
/registry/secrets/kube-system/flannel-token-wvgjq
/registry/secrets/kube-system/generic-garbage-collector-token-pcpnq
/registry/secrets/kube-system/heapster-token-6szhz
/registry/secrets/kube-system/horizontal-pod-autoscaler-token-xqcl5
/registry/secrets/kube-system/job-controller-token-422zr
/registry/secrets/kube-system/kube-proxy-token-k5rfq
/registry/secrets/kube-system/kubernetes-dashboard-certs
/registry/secrets/kube-system/kubernetes-dashboard-key-holder
/registry/secrets/kube-system/kubernetes-dashboard-token-kpkw7
/registry/secrets/kube-system/namespace-controller-token-r57ss
/registry/secrets/kube-system/node-controller-token-5f7sm
/registry/secrets/kube-system/persistent-volume-binder-token-7rnt2
/registry/secrets/kube-system/pod-garbage-collector-token-2txwf
/registry/secrets/kube-system/replicaset-controller-token-zh9xq
/registry/secrets/kube-system/replication-controller-token-q69jz
/registry/secrets/kube-system/resourcequota-controller-token-92hn4
/registry/secrets/kube-system/service-account-controller-token-vvw5d
/registry/secrets/kube-system/service-controller-token-lslnf
/registry/secrets/kube-system/statefulset-controller-token-wdqjt
/registry/secrets/kube-system/token-cleaner-token-9zzpv
/registry/secrets/kube-system/ttl-controller-token-tc7pl
/registry/serviceaccounts/default/default
/registry/serviceaccounts/kube-public/default
/registry/serviceaccounts/kube-system/attachdetach-controller
/registry/serviceaccounts/kube-system/bootstrap-signer
/registry/serviceaccounts/kube-system/certificate-controller
/registry/serviceaccounts/kube-system/clusterrole-aggregation-controller
/registry/serviceaccounts/kube-system/coredns
/registry/serviceaccounts/kube-system/cronjob-controller
/registry/serviceaccounts/kube-system/daemon-set-controller
/registry/serviceaccounts/kube-system/default
/registry/serviceaccounts/kube-system/deployment-controller
/registry/serviceaccounts/kube-system/disruption-controller
/registry/serviceaccounts/kube-system/endpoint-controller
/registry/serviceaccounts/kube-system/flannel
/registry/serviceaccounts/kube-system/generic-garbage-collector
/registry/serviceaccounts/kube-system/heapster
/registry/serviceaccounts/kube-system/horizontal-pod-autoscaler
/registry/serviceaccounts/kube-system/job-controller
/registry/serviceaccounts/kube-system/kube-proxy
/registry/serviceaccounts/kube-system/kubernetes-dashboard
/registry/serviceaccounts/kube-system/namespace-controller
/registry/serviceaccounts/kube-system/node-controller
/registry/serviceaccounts/kube-system/persistent-volume-binder
/registry/serviceaccounts/kube-system/pod-garbage-collector
/registry/serviceaccounts/kube-system/replicaset-controller
/registry/serviceaccounts/kube-system/replication-controller
/registry/serviceaccounts/kube-system/resourcequota-controller
/registry/serviceaccounts/kube-system/service-account-controller
/registry/serviceaccounts/kube-system/service-controller
/registry/serviceaccounts/kube-system/statefulset-controller
/registry/serviceaccounts/kube-system/token-cleaner
/registry/serviceaccounts/kube-system/ttl-controller
/registry/services/endpoints/default/flower
/registry/services/endpoints/default/kubernetes
/registry/services/endpoints/default/pc-saveapi
/registry/services/endpoints/default/pxxxm-django
/registry/services/endpoints/default/pxxxm-redis
/registry/services/endpoints/default/pxxxm-tengine-proxy
/registry/services/endpoints/default/pxxxm-tengine-static
/registry/services/endpoints/default/pxxxmlogapi-nj
/registry/services/endpoints/kube-system/heapster
/registry/services/endpoints/kube-system/kube-controller-manager
/registry/services/endpoints/kube-system/kube-dns
/registry/services/endpoints/kube-system/kube-scheduler
/registry/services/endpoints/kube-system/kubernetes-dashboard
/registry/services/endpoints/kube-system/monitoring-grafana
/registry/services/endpoints/kube-system/monitoring-influxdb
/registry/services/specs/default/flower
/registry/services/specs/default/kubernetes
/registry/services/specs/default/pc-saveapi
/registry/services/specs/default/pxxxm-django
/registry/services/specs/default/pxxxm-redis
/registry/services/specs/default/pxxxm-tengine-proxy
/registry/services/specs/default/pxxxm-tengine-static
/registry/services/specs/default/pxxxmlogapi-nj
/registry/services/specs/kube-system/heapster
/registry/services/specs/kube-system/kube-dns
/registry/services/specs/kube-system/kubernetes-dashboard
/registry/services/specs/kube-system/monitoring-grafana
/registry/services/specs/kube-system/monitoring-influxdb
```
## REF

https://qiankunli.github.io/2019/01/05/kubernetes_source_apiserver.html

https://mp.weixin.qq.com/s/L0DI_w-dVWxiHoSBnPUUtg