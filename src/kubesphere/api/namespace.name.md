
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/api/v1/namespaces/ingress-nginx

```json
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "ingress-nginx",
    "uid": "92e0e5a4-202f-4186-b9e0-5dae5211fe0d",
    "resourceVersion": "2187",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
      "app.kubernetes.io/instance": "ingress-nginx",
      "app.kubernetes.io/name": "ingress-nginx",
      "kubernetes.io/metadata.name": "ingress-nginx"
    },
    "annotations": {
      "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Namespace\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\"},\"name\":\"ingress-nginx\"}}\n"
    },
    "finalizers": [
      "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
      {
        "manager": "kubectl-client-side-apply",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-08T02:04:43Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              ".": {},
              "f:kubectl.kubernetes.io/last-applied-configuration": {}
            },
            "f:labels": {
              ".": {},
              "f:app.kubernetes.io/instance": {},
              "f:app.kubernetes.io/name": {},
              "f:kubernetes.io/metadata.name": {}
            }
          }
        }
      },
      {
        "manager": "controller-manager",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-09T07:01:10Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:finalizers": {
              ".": {},
              "v:\"finalizers.kubesphere.io/namespaces\"": {}
            }
          }
        }
      }
    ]
  },
  "spec": {
    "finalizers": [
      "kubernetes"
    ]
  },
  "status": {
    "phase": "Active"
  }
}
```


// 项目配额
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/api/v1/namespaces/ingress-nginx/limitranges

```json
{
  "kind": "LimitRangeList",
  "apiVersion": "v1",
  "metadata": {
    "resourceVersion": "136501"
  },
  "items": []
}
```


https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha2/namespaces/ingress-nginx/quotas
```json
{
 "namespace": "ingress-nginx",
 "data": {
  "used": {
   "count/cronjobs.batch": "0",
   "count/daemonsets.apps": "0",
   "count/deployments.apps": "1",
   "count/ingresses.extensions": "0",
   "count/jobs.batch": "2",
   "count/pods": "3",
   "count/services": "2",
   "count/statefulsets.apps": "0",
   "persistentvolumeclaims": "0"
  }
 }
}
```


https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha2/namespaces/ingress-nginx/abnormalworkloads

```json
{
 "namespace": "ingress-nginx",
 "data": {
  "daemonsets": 0,
  "deployments": 0,
  "jobs": 0,
  "persistentvolumeclaims": 0,
  "statefulsets": 0
 }
}
```

/// 项目内的pod
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/namespaces/ingress-nginx/pods?page=1