


## api service： apiService，

```shell
root@i-f2c59da3:~# kubectl get apiservices.extensions.kubesphere.io
NAME                                 AGE
v1alpha1.gitops.kubesphere.io        32d
v1alpha2.devops.kubesphere.io        32d
v1alpha2.logging.kubesphere.io       32d
v1alpha3.devops.kubesphere.io        32d
v1beta1.monitoring.kubesphere.io     32d
v2alpha1.gateway.kubesphere.io       32d
v2beta2.notification.kubesphere.io   32d

root@i-f2c59da3:~# kubectl get apiservices.extensions.kubesphere.io v2beta2.notification.kubesphere.io  -o yaml
apiVersion: extensions.kubesphere.io/v1alpha1
kind: APIService
metadata:
  annotations:
    meta.helm.sh/release-name: whizard-telemetry
    meta.helm.sh/release-namespace: extension-whizard-telemetry
  creationTimestamp: "2025-03-20T07:14:14Z"
  generation: 1
  labels:
    app.kubernetes.io/managed-by: Helm
    kubesphere.io/extension-ref: whizard-telemetry
  name: v2beta2.notification.kubesphere.io
  resourceVersion: "11265"
  uid: 76e46de1-d382-4e02-ad8b-61a7b00a954a
spec:
  group: notification.kubesphere.io
  url: http://whizard-telemetry-apiserver.extension-whizard-telemetry.svc:9090
  version: v2beta2
status:
  state: Available
```

## kube_api 处理 /api访问k8s 服务


## reserve_proxy 代理 /proxy



## jsBundle 代理 /dist

1. jsbundles.extensions.kubesphere.io
2. "Content-Type", "application/javascript; charset=utf-8"
3. file.MIMEType 

```shell
root@i-f2c59da3:~# kubectl get jsbundle
NAME                                      AGE
devops-js-bundle                          32d
gateway-frontend-js-bundle                32d
openpitrix-apps-js-bundle                 32d
whizard-alerting-frontend-js-bundle       32d
whizard-monitoring-frontend-js-bundle     32d
whizard-notification-frontend-js-bundle   32d

root@i-f2c59da3:~# kubectl get jsbundle devops-js-bundle -o yaml
apiVersion: extensions.kubesphere.io/v1alpha1
kind: JSBundle
metadata:
  annotations:
    meta.helm.sh/release-name: devops
    meta.helm.sh/release-namespace: kubesphere-devops-system
  creationTimestamp: "2025-03-20T08:43:56Z"
  generation: 1
  labels:
    app.kubernetes.io/managed-by: Helm
    kubesphere.io/extension-ref: devops
  name: devops-js-bundle
  resourceVersion: "29775"
  uid: 78b4f7b4-8d5c-4ed1-98e6-94fadba1f843
spec:
  rawFrom:
    configMapKeyRef:
      key: index.js
      name: devops-frontend
      namespace: kubesphere-devops-system
status:
  link: /dist/devops-frontend/index.js
  state: Available

root@i-f2c59da3:~# kubectl get cm whizard-notification-frontend -n kubesphere-monitoring-system -o yaml
apiVersion: v1
data:
  index.js: 'System.register([],(function(t,e){return{execute:function(){t(function(){var
    t={386:function(t,e,n){var i=n(149).R;e.s=function(t){if(t||(t=1),!n.y.meta||!n.y.meta.url)throw
    console.error("__system_context__",n.y),Error("systemjs-webpack-interop was provided
    an unknown SystemJS context. Expected context.meta.url, but none was provided");n.p=i(n.y.meta.url,t)}},149:function(t,e,n){function
    i(t,e){var n=document.createElement("a");n.href=t;for(var i="/"===n.pathname[0]?n.pathname:"/"+n.pathname,o=0,a=i.length;o!==e&&a>=0;){"/"===i[--a]&&o++}if(o!==e)throw
    Error("systemjs-webpack-interop: rootDirectoryLevel ("+e+") is greater than the
    number of directories ("+o+") in the URL path "+t);var r=i.slice(0,a+1);return
    n.protocol+"//"+n.host+r}e.R=i;var o=Number.isInteger||function(t){return"number"==typeof
    t&&isFinite(t)&&Math.floor(t)===t}}},n={};function i(e){var o=n[e];if(void 0!==o)return
    o.exports;var a=n[e]={exports:{}};return t[e](a,a.exports,i),a.exports}i.y=e,i.g=function(){if("object"==typeof
    globalThis)return globalThis;try{return this||new Function("return this")()}catch(t){if("object"==typeof
    window)return window}}(),i.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},function(){var
    t;i.g.importScripts&&(t=i.g.location+"");var e=i.g.document;if(!t&&e&&(e.currentScript&&(t=e.currentScript.src),!t)){var
    n=e.getElementsByTagName("script");n.length&&(t=n[n.length-1].src)}if(!t)throw
    new Error("Automatic publicPath is not supported in this browser");t=t.replace(/#.*$/,"").replace(/\?.*$/,"").replace(/\/[^\/]+$/,"/"),i.p=t}();var
    o={};return(0,i(386).s)(1),function(){"use strict";i.r(o);const t={menus:[{parent:"platformSettings",name:"notification-management",title:"NOTIFICATION_MANAGEMENT",icon:"bell",order:1,ksModule:"whizard-notification"},{parent:"platformSettings.notification-management",name:"channel-configuration",title:"NOTIFICATION_CHANNELS",order:0,tabs:[{name:"mail",title:"Mail",authKey:"platform-settings"},{name:"feishu",title:"FEISHU",authKey:"platform-settings"},{name:"dingtalk",title:"DingTalk",authKey:"platform-settings"},{name:"wecom",title:"WeCom",authKey:"platform-settings"},{name:"slack",title:"Slack",authKey:"platform-settings"},{name:"webhook",title:"Webhook",authKey:"platform-settings"}]},{parent:"platformSettings.notification-management",name:"notification-subscription",title:"NOTIFICATION_SUBSCRIPTION",order:1,tabs:[{name:"subscription-mail",title:"Mail",authKey:"platform-settings"},{name:"subscription-feishu",title:"FEISHU",authKey:"platform-settings"},{name:"subscription-dingtalk",title:"DingTalk",authKey:"platform-settings"},{name:"subscription-wecom",title:"WeCom",authKey:"platform-settings"},{name:"subscription-slack",title:"Slack",authKey:"platform-settings"},{name:"subscription-webhook",title:"Webhook",authKey:"platform-settings"}]},{parent:"platformSettings.notification-management",name:"notification-configuration",title:"NOTIFICATION_SETTINGS",authKey:"platform-settings",order:3,tabs:[{name:"silent-policy",title:"SILENCE_POLICY_PL",authKey:"platform-settings"},{name:"notification-language",title:"NOTIFICATION_LANGUAGE",authKey:"platform-settings"}]},{parent:"platformSettings.notification-management",name:"notification-history",title:"NOTIFICATION_HISTORY",authKey:"platform-settings",ksModule:"whizard-notification",annotation:"logging.kubesphere.io/enable-notification-history"}],isCheckLicense:!0};o.default=t}(),o}())}}}));'
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: whizard-notification
    meta.helm.sh/release-namespace: kubesphere-monitoring-system
  creationTimestamp: "2025-03-20T07:23:45Z"
  labels:
    app.kubernetes.io/instance: whizard-notification
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: frontend
    app.kubernetes.io/version: 0.1.0
    helm.sh/chart: frontend-0.1.0
    kubesphere.io/extension-ref: whizard-notification
  name: whizard-notification-frontend
  namespace: kubesphere-monitoring-system
  resourceVersion: "14066"
  uid: d6e0bcd3-cdb8-4849-b2c7-5d069b50ba3a
```

## auditing

写入event

## authentication： 认证, 下面三个任一成功

anonymous： 如果头部没有"Authorization",返回 Anonymous用户（system:anonymous）, 和未认证(system:unauthenticated)
basictoken： 用户名密码认证, 默认使用用户名密码认证，如果提供了provider(使用第三方认证)，返回user.DefaultInfo 。用户保存在user.iam.kubesphere.io中
bearertonken: jwt 认证， 从头部“Authorization”获取token，tokenOperator缓存token在内存或者redis中，key：kubesphere:user:*:token:%s，校验token有效期。token可以是User、ServiceAccount，检查User状态


```shell
root@i-f2c59da3:~# kubectl get user -A
NAME     EMAIL                 STATUS
admin    admin@kubesphere.io   Active
casoul   casoul@qq.com         Active
lijw     lijw@bingosoft.net    Active
root@i-f2c59da3:~# kubectl get user casoul -o yaml
apiVersion: iam.kubesphere.io/v1beta1
kind: User
metadata:
  annotations:
    iam.kubesphere.io/globalrole: platform-admin
  creationTimestamp: "2025-04-14T10:09:52Z"
  finalizers:
  - finalizers.kubesphere.io/users
  generation: 5
  labels:
    iam.kubesphere.io/identify-provider: topiam
    iam.kubesphere.io/origin-uid: ac120004-9633-192e-8196-33c61b710011
  name: casoul
  resourceVersion: "7571167"
  uid: a332a0b4-6277-45b7-9c1b-4fc307480f83
spec:
  email: casoul@qq.com
status:
  lastLoginTime: "2025-04-14T10:13:40Z"
  lastTransitionTime: "2025-04-14T10:09:52Z"
  state: Active

```


## multicluster


IsHostCluster => 直接把/clusters/%s, 删掉往下走

获取ClusterClient： 根据URL、query，转向到对应的cluster上（如果cluster的链接方式是Direct）：
1. 删除Authorization， 设置X-KubeSphere-Authorization
2. dryRun => dryrun
3. X-KubeSphere-Rawquery

如果是代理模式转向到ks-apiserver???


## authorization: 授权

AlwaysAllow
AlwaysDeny

Allow/Deny 是决策，
NoOpinion，留给下一个人决策，如果都没有决策就是拒绝

1. PathAuthorizer， 排除路径，总是允许： /oauth/*", "/dist/*", "/.well-known/openid-configuration", "/version", "/metrics", "/livez", "/healthz", "/openapi/v2", "/openapi/v3"
2. RBACAuthorizer: 
    1. GlobalRole： 如果请求GlobalScope资源，到此为止
    2. NamespaceScope? => 获取Worksapce ||  WorkspaceScope => 已经有workspace 
    3. 校验WorkspaceRole， 如果是WorkscpaceScope，到此为止
    4. NamespaceScope: 校验Role
    5. ClusterScope： 校验ClusterScope


## KubesphereAPI

### config

config.kubesphere.io/v1alpha2/configs/{configz, oauth, theme}
config.kubesphere.io/v1alpha2/platformconfigs/{config}

### resource

resources.kubesphere.io/v1alpha3/resources
resources.kubesphere.io/v1alpha3/resources/name
resources.kubesphere.io/v1alpha3/namespaces/namespace/resources
resources.kubesphere.io/v1alpha3/namespaces/namespace/resources/name

resources.kubesphere.io/v1alpha3/namespaces/namespace/images
resources.kubesphere.io/v1alpha3/namespaces/namespace/imageconfig

resources.kubesphere.io/v1alpha3/components
resources.kubesphere.io/v1alpha3/components/component
resources.kubesphere.io/v1alpha3/componenthealth

resources.kubesphere.io/v1alpha3/namespaces/namespace/registrysecrets/secret/verify
resources.kubesphere.io/v1alpha3/namespaces/namespace/registrytags

resources.kubesphere.io/v1alpha3/metrics
resources.kubesphere.io/v1alpha3/namespaces/namespace/metrics

### operation

operations.kubesphere.io/v1alpha2/namespaces/namespace/jobs/job

### tenant

tenant.kubesphere.io/v1beta1/workspacetemplates
tenant.kubesphere.io/v1beta1/workspacetemplates/workspace

tenant.kubesphere.io/v1beta1/workspaces
tenant.kubesphere.io/v1beta1/workspaces/workspace
tenant.kubesphere.io/v1beta1/workspaces/workspace/clusters
tenant.kubesphere.io/v1beta1/workspaces/workspace/namespaces
tenant.kubesphere.io/v1beta1/workspaces/workspace/namespaces/namespace

tenant.kubesphere.io/v1beta1/workspaces/{workspace}/workspacemembers/{workspacemember}/namespaces

tenant.kubesphere.io/v1beta1/workspaces/{workspace}/resourcequotas
tenant.kubesphere.io/v1beta1/workspaces/{workspace}/resourcequotas/{resourcequota}

tenant.kubesphere.io/v1beta1/clusters
tenant.kubesphere.io/v1beta1/namespaces

tenant.kubesphere.io/v1beta1/workspaces/{workspace}/metrics
tenant.kubesphere.io/v1beta1/metrics


### terminal

terminal.kubesphere.io/v1alpha2/namespaces/{namespace}/pods/{pod}/exec
terminal.kubesphere.io/v1alpha2/namespaces/{namespace}/pods/{pod}/file
terminal.kubesphere.io/v1alpha2/users/{user}/kubectl
terminal.kubesphere.io/v1alpha2/nodes/{nodename}/exec

### cluster Kapi

cluster.kubesphere.io/v1alpha1/clusters/validation
cluster.kubesphere.io/v1alpha1/clusters/{cluster}/kubeconfig
cluster.kubesphere.io/v1alpha1/clusters/{cluster}/grantrequests
cluster.kubesphere.io/v1alpha1/labels
cluster.kubesphere.io/v1alpha1/labels/{label}
cluster.kubesphere.io/v1alpha1/labelbindings


### Iam api
iam.kubesphere.io/v1beta1

/users
/users/{user}
/users/{user}/password
/users/{user}/loginrecords

/clustermembers
/clustermembers/{clustermember}

/workspaces/{workspace}/workspacemembers
/workspaces/{workspace}/workspacemembers/{workspacemember}

/namespaces/{namespace}/namespacemembers
/namespaces/{namespace}/namespacemembers/{namespacemember}

/users/{username}/roletemplates

/subjectaccessreviews


### oauth

/.well-known/openid-configuration
/oauth/keys
/oauth/userinfo
/oauth/authenticate
/oauth/authorize
/oauth/token
/oauth/callback/{callback}
/oauth/logout

### version api

/version

### package api
package.kubesphere.io/v1alpha1/extensionversions/{version}/files

### gateway 

gateway.kubesphere.io/v1alpha2/namespaces/{namespace}/availableingressclassscopes

```shell
root@i-f2c59da3:~# kubectl get gateway -n kubesphere-controls-system  kubesphere-router-cluster -o yaml
apiVersion: gateway.kubesphere.io/v2alpha1
kind: Gateway
metadata:
  annotations:
    kubesphere.io/creator: admin
  creationTimestamp: "2025-03-20T06:58:40Z"
  finalizers:
  - gateway.finalizers.kubesphere.io
  generation: 1
  labels:
    kubesphere.io/gateway-type: cluster
  name: kubesphere-router-cluster
  namespace: kubesphere-controls-system
  resourceVersion: "8621"
  uid: afb6f827-c4b0-4373-a65b-cc65dd633437
spec:
  appVersion: kubesphere-nginx-ingress-4.3.0
  values:
    commonLabels: {}
    controller:
      addHeaders: {}
      admissionWebhooks:
        annotations: {}
        certificate: /usr/local/certificates/cert
        createSecretJob:
          resources: {}
        enabled: false
        existingPsp: ""
        extraEnvs: []
        failurePolicy: Fail
        key: /usr/local/certificates/key
        labels: {}
        namespaceSelector: {}
        networkPolicyEnabled: false
        objectSelector: {}
        patch:
          enabled: true
          image:
            digest: sha256:39c5b2e3310dc4264d638ad28d9d1d96c4cbb2b2dcfb52368fe4e3c63f61e10f
            image: ingress-nginx/kube-webhook-certgen
            pullPolicy: IfNotPresent
            registry: registry.k8s.io
            tag: v20220916-gd32f8c343
          labels: {}
          nodeSelector:
            kubernetes.io/os: linux
          podAnnotations: {}
          priorityClassName: ""
          securityContext:
            fsGroup: 2000
            runAsNonRoot: true
            runAsUser: 2000
          tolerations: []
        patchWebhookJob:
          resources: {}
        port: 8443
        service:
          annotations: {}
          externalIPs: []
          loadBalancerSourceRanges: []
          servicePort: 443
          type: ClusterIP
      affinity: {}
      allowSnippetAnnotations: true
      annotations: {}
      autoscaling:
        behavior: {}
        enabled: false
        maxReplicas: 11
        minReplicas: 1
        targetCPUUtilizationPercentage: 50
        targetMemoryUtilizationPercentage: 50
      autoscalingTemplate: []
      config:
        worker-processes: "4"
      configAnnotations: {}
      configMapNamespace: ""
      containerName: controller
      containerPort:
        http: 80
        https: 443
      customTemplate:
        configMapKey: ""
        configMapName: ""
      dnsConfig: {}
      dnsPolicy: ClusterFirst
      electionID: kubesphere-router-cluster
      enableMimalloc: true
      existingPsp: ""
      extraArgs: {}
      extraContainers: []
      extraEnvs: []
      extraInitContainers: []
      extraModules: []
      extraVolumeMounts: []
      extraVolumes: []
      healthCheckHost: ""
      healthCheckPath: /healthz
      hostNetwork: false
      hostPort:
        enabled: false
        ports:
          http: 80
          https: 443
      hostname: {}
      image:
        allowPrivilegeEscalation: true
        chroot: false
        digest: ""
        digestChroot: sha256:b67e889f1db8692de7e41d4d9aef8de56645bf048261f31fa7f8bfc6ea2222a0
        image: kubesphere/nginx-ingress-controller
        pullPolicy: IfNotPresent
        pullpolicy: IfNotPresent
        registry: swr.cn-southwest-2.myhuaweicloud.com/ks
        runAsUser: 101
        tag: v1.4.0
      ingressClass: nginx
      ingressClassByName: false
      ingressClassResource:
        controllerValue: k8s.io/ingress-nginx
        default: false
        enabled: true
        name: kubesphere-router-cluster
        parameters: {}
      integrateKubeSphere:
        tracing: false
      keda:
        apiVersion: keda.sh/v1alpha1
        behavior: {}
        cooldownPeriod: 300
        enabled: false
        maxReplicas: 11
        minReplicas: 1
        pollingInterval: 30
        restoreToOriginalReplicaCount: false
        scaledObject:
          annotations: {}
        triggers: []
      kind: Deployment
      labels: {}
      lifecycle:
        preStop:
          exec:
            command:
            - /wait-shutdown
      livenessProbe:
        failureThreshold: 5
        httpGet:
          path: /healthz
          port: 10254
          scheme: HTTP
        initialDelaySeconds: 10
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
      maxmindLicenseKey: ""
      metrics:
        enabled: false
        port: 10254
        portName: metrics
        prometheusRule:
          additionalLabels: {}
          enabled: false
          rules: []
        service:
          annotations: {}
          externalIPs: []
          loadBalancerSourceRanges: []
          servicePort: 10254
          type: ClusterIP
        serviceMonitor:
          additionalLabels: {}
          enabled: false
          metricRelabelings: []
          namespace: ""
          namespaceSelector: {}
          relabelings: []
          scrapeInterval: 30s
          targetLabels: []
      minAvailable: 1
      minReadySeconds: 0
      name: ""
      nodeSelector:
        kubernetes.io/os: linux
      podAnnotations: {}
      podLabels: {}
      podSecurityContext: {}
      priorityClassName: ""
      proxySetHeaders: {}
      publishService:
        enabled: false
        pathOverride: ""
      readinessProbe:
        failureThreshold: 3
        httpGet:
          path: /healthz
          port: 10254
          scheme: HTTP
        initialDelaySeconds: 10
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
      replicaCount: 2
      reportNodeInternalIp: false
      resources:
        requests:
          cpu: 100m
          memory: 90Mi
      scope:
        enabled: false
        namespace: ""
        namespaceSelector: ""
      service:
        annotations: {}
        appProtocol: true
        enableHttp: true
        enableHttps: true
        enabled: true
        external:
          enabled: true
        externalIPs: []
        internal:
          annotations: {}
          enabled: false
          loadBalancerSourceRanges: []
        ipFamilies:
        - IPv4
        ipFamilyPolicy: SingleStack
        labels: {}
        loadBalancerIP: ""
        loadBalancerSourceRanges: []
        nodePorts:
          http: ""
          https: ""
          tcp: {}
          udp: {}
        ports:
          http: 80
          https: 443
        targetPorts:
          http: http
          https: https
        type: NodePort
      shareProcessNamespace: false
      sysctls: {}
      tcp:
        annotations: {}
        configMapNamespace: ""
      terminationGracePeriodSeconds: 300
      tolerations: []
      topologySpreadConstraints: []
      udp:
        annotations: {}
        configMapNamespace: ""
      updateStrategy: {}
      watchIngressWithoutClass: false
    defaultBackend:
      affinity: {}
      autoscaling:
        annotations: {}
        enabled: false
        maxReplicas: 2
        minReplicas: 1
        targetCPUUtilizationPercentage: 50
        targetMemoryUtilizationPercentage: 50
      containerSecurityContext: {}
      enabled: false
      existingPsp: ""
      extraArgs: {}
      extraEnvs: []
      extraVolumeMounts: []
      extraVolumes: []
      image:
        allowPrivilegeEscalation: false
        image: defaultbackend-amd64
        pullPolicy: IfNotPresent
        readOnlyRootFilesystem: true
        registry: registry.k8s.io
        runAsNonRoot: true
        runAsUser: 65534
        tag: "1.5"
      labels: {}
      livenessProbe:
        failureThreshold: 3
        initialDelaySeconds: 30
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 5
      minAvailable: 1
      name: defaultbackend
      nodeSelector:
        kubernetes.io/os: linux
      podAnnotations: {}
      podLabels: {}
      podSecurityContext: {}
      port: 8080
      priorityClassName: ""
      readinessProbe:
        failureThreshold: 6
        initialDelaySeconds: 0
        periodSeconds: 5
        successThreshold: 1
        timeoutSeconds: 5
      replicaCount: 1
      resources: {}
      service:
        annotations: {}
        externalIPs: []
        loadBalancerSourceRanges: []
        servicePort: 80
        type: ClusterIP
      serviceAccount:
        automountServiceAccountToken: true
        create: true
        name: ""
      tolerations: []
    dhParam: null
    fullnameOverride: kubesphere-router-cluster
    imagePullSecrets: []
    podSecurityPolicy:
      enabled: false
    portNamePrefix: ""
    rbac:
      create: true
      scope: false
    revisionHistoryLimit: 10
    serviceAccount:
      annotations: {}
      automountServiceAccountToken: true
      create: true
      name: ""
    tcp: {}
    udp: {}
```


### app api

application.kubesphere.io/v2

/repos
/apps
/applications
/categories
/reviews
/attachments


## MetricsAPI： /metrics

ks_server_request_total: Counter
ks_server_request_duration_seconds: Histogram
