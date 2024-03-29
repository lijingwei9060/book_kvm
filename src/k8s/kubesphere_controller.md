# intro

1. kubernetes原生的对象，由ks-apiserver连接api-server，直接获取更改etcd中kubernetes的原始数据(origin data)即可，操作的对象即kubernetes原生的configmap. deployment等对象。
2. KS的CRD对象，ks-controller-manager的封装功能逻辑以crd对象的方式表现在etcd中，ks-apiserver通过连接k8s-apiserver操作etcd中的crd数据(crd data)即可，操作 ks-controller-manager 扩展的逻辑功能。
3. 第三方的operator对象，如prometheus-operator等第三方完成的模块以operator的方式运行在系统中，其功能对应的对象也以crd的形式存放载etcd中，ks-apiserver也是通过和k8s-apiserver交互操作对应的crd完成。
4. 普通的服务对象，如kenkins，sonarqube等以普通服务的方式运行在系统中，ks-apiserver直接通过网络调用和此类对象交互
5. 多集群模式的API对象，通过tower分发到Member集群处理，如阿里云，腾讯云K8S集群。 以上，ks-apiserver通过内部API(inner API aggregate)聚合内部功能 ，并对外提供统一的API，即外部API(out API aggregate)。

创建：
1. ks-apiserver： Deploy+service
2. User： admin
3. ks-console： Deployment+ serviceaccount+service
4. ks-controller-manager： deplyment + service
5. ks-router-config： configmap
6. ks-router： ingress controller
7. kubesphere-config： configmap


controller manager：
controllers - crd - image： 
- accessors.storage.kubesphere.io
- applications.gitops.kubesphere.io
- clusterconfigurations.installer.kubesphere.io
- clusterdashboards.monitoring.kubesphere.io
- clusterrulegroups.alerting.kubesphere.io
- clusters.cluster.kubesphere.io
- clustersteptemplates.devops.kubesphere.io
- clustertemplates.devops.kubesphere.io
- configs.notification.kubesphere.io
- dashboards.monitoring.kubesphere.io
- devopsprojects.devops.kubesphere.io
- exporters.events.kubesphere.io
- federatedrolebindings.iam.kubesphere.io
- federatedroles.iam.kubesphere.io
- federatedusers.iam.kubesphere.io
- filters.logging.kubesphere.io
- fluentbitconfigs.logging.kubesphere.io
- fluentbits.logging.kubesphere.io
- gateways.gateway.kubesphere.io
- gitrepositories.devops.kubesphere.io
- globalrolebindings.iam.kubesphere.io
- globalroles.iam.kubesphere.io
- globalrulegroups.alerting.kubesphere.io
- groupbindings.iam.kubesphere.io
- groups.iam.kubesphere.io
- helmapplications.application.kubesphere.io
- helmapplicationversions.application.kubesphere.io
- helmcategories.application.kubesphere.io
- helmreleases.application.kubesphere.io
- helmrepos.application.kubesphere.io
- inputs.logging.kubesphere.io
- ipamblocks.network.kubesphere.io
- ipamhandles.network.kubesphere.io
- ippools.network.kubesphere.io
- loginrecords.iam.kubesphere.io
- namespacenetworkpolicies.network.kubesphere.io
- nginxes.gateway.kubesphere.io
- notificationmanagers.notification.kubesphere.io
- outputs.logging.kubesphere.io
- parsers.logging.kubesphere.io
- pipelineruns.devops.kubesphere.io
- pipelines.devops.kubesphere.io
- receivers.notification.kubesphere.io
- resourcequotas.quota.kubesphere.io
- rolebases.iam.kubesphere.io
- routers.notification.kubesphere.io
- rulegroups.alerting.kubesphere.io
- rulers.events.kubesphere.io
- rules.auditing.kubesphere.io
- rules.events.kubesphere.io
- s2ibinaries.devops.kubesphere.io
- s2ibuilders.devops.kubesphere.io
- s2ibuildertemplates.devops.kubesphere.io
- s2iruns.devops.kubesphere.io
- servicepolicies.servicemesh.kubesphere.io
- silences.notification.kubesphere.io
- strategies.servicemesh.kubesphere.io
- templates.devops.kubesphere.io
- users.iam.kubesphere.io: 
- webhooks.auditing.kubesphere.io
- workspacerolebindings.iam.kubesphere.io
- workspaceroles.iam.kubesphere.io
- workspaces.tenant.kubesphere.io
- workspacetemplates.tenant.kubesphere.io
