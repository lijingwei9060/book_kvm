/api/v1/applications/myapp/resource-tree?appNamespace=argocd

```json
{
    "nodes": [
        {
            "version": "v1",
            "kind": "Pod",
            "namespace": "devops",
            "name": "myapp-7dfb7d78d5-fbtpd",
            "uid": "cef75f4d-3419-42f5-88c3-fd755a8fdcc5",
            "parentRefs": [
                {
                    "group": "apps",
                    "kind": "ReplicaSet",
                    "namespace": "devops",
                    "name": "myapp-7dfb7d78d5",
                    "uid": "9f0aff09-e61e-4732-b79e-8b9b23b00896"
                }
            ],
            "info": [
                {
                    "name": "Status Reason",
                    "value": "Running"
                },
                {
                    "name": "Node",
                    "value": "bcs-ubuntu-02"
                },
                {
                    "name": "Containers",
                    "value": "1/1"
                }
            ],
            "networkingInfo": {
                "labels": {
                    "app": "myapp",
                    "pod-template-hash": "7dfb7d78d5"
                }
            },
            "resourceVersion": "162902",
            "images": [
                "registry.cn-shanghai.aliyuncs.com/public-namespace/myapp:v2"
            ],
            "health": {
                "status": "Healthy"
            },
            "createdAt": "2025-08-13T07:52:14Z"
        },
        {
            "version": "v1",
            "kind": "Service",
            "namespace": "devops",
            "name": "myapp",
            "uid": "cbd13c1d-6382-452e-8456-8e2d920c5ab1",
            "networkingInfo": {
                "targetLabels": {
                    "app": "myapp"
                }
            },
            "resourceVersion": "162526",
            "health": {
                "status": "Healthy"
            },
            "createdAt": "2025-08-13T07:52:14Z"
        },
        {
            "group": "apps",
            "version": "v1",
            "kind": "Deployment",
            "namespace": "devops",
            "name": "myapp",
            "uid": "352c917e-b1c0-460f-9fab-d32809987812",
            "info": [
                {
                    "name": "Revision",
                    "value": "Rev:1"
                }
            ],
            "resourceVersion": "162906",
            "health": {
                "status": "Healthy"
            },
            "createdAt": "2025-08-13T07:52:14Z"
        },
        {
            "group": "apps",
            "version": "v1",
            "kind": "ReplicaSet",
            "namespace": "devops",
            "name": "myapp-7dfb7d78d5",
            "uid": "9f0aff09-e61e-4732-b79e-8b9b23b00896",
            "parentRefs": [
                {
                    "group": "apps",
                    "kind": "Deployment",
                    "namespace": "devops",
                    "name": "myapp",
                    "uid": "352c917e-b1c0-460f-9fab-d32809987812"
                }
            ],
            "info": [
                {
                    "name": "Revision",
                    "value": "Rev:1"
                }
            ],
            "resourceVersion": "162904",
            "health": {
                "status": "Healthy"
            },
            "createdAt": "2025-08-13T07:52:14Z"
        }
    ],
    "hosts": [
        {
            "name": "bcs-ubuntu-02",
            "resourcesInfo": [
                {
                    "resourceName": "cpu",
                    "requestedByNeighbors": 550,
                    "capacity": 4000
                },
                {
                    "resourceName": "memory",
                    "requestedByNeighbors": 220200960000,
                    "capacity": 8285798400000
                }
            ],
            "systemInfo": {
                "machineID": "c3d8ea4612a04ee3889834c51bee423a",
                "systemUUID": "1969cfd1-f1a6-4226-a193-2e61674eaa31",
                "bootID": "4f4b9c2c-fa34-4323-b4df-fdd898dc8d8d",
                "kernelVersion": "5.15.0-119-generic",
                "osImage": "Ubuntu 22.04.5 LTS",
                "containerRuntimeVersion": "containerd://1.7.13",
                "kubeletVersion": "v1.32.0",
                "kubeProxyVersion": "v1.32.0",
                "operatingSystem": "linux",
                "architecture": "amd64"
            }
        }
    ]
}
```


/api/v1/applications/myapp/revisions/39313e1c4af397986a5e1bbb53bde6fef15d6a50/metadata?appNamespace=argocd&sourceIndex=0&versionId=0

```json
{
    "author": "Finley \u003cmafei7@126.com\u003e",
    "date": "2022-05-06T11:53:41Z",
    "message": "update demo/myapp-deployment.yaml."
}
```

EventStream
/api/v1/stream/applications?name=myapp&appNamespace=argocd
```json
[
    {"result":{"type":"ADDED","application":{"metadata":{"name":"myapp","namespace":"argocd","uid":"c93acd62-4305-42fc-bfe3-593e8478d8f2","resourceVersion":"3927200","generation":9928,"creationTimestamp":"2025-08-13T07:49:04Z","managedFields":[{"manager":"argocd-server","operation":"Update","apiVersion":"argoproj.io/v1alpha1","time":"2025-09-04T02:13:28Z","fieldsType":"FieldsV1","fieldsV1":{"f:spec":{".":{},"f:destination":{".":{},"f:namespace":{},"f:server":{}},"f:project":{},"f:source":{".":{},"f:path":{},"f:repoURL":{},"f:targetRevision":{}}},"f:status":{".":{},"f:health":{},"f:sourceHydrator":{},"f:summary":{},"f:sync":{".":{},"f:comparedTo":{".":{},"f:destination":{},"f:source":{}}}}}},{"manager":"argocd-application-controller","operation":"Update","apiVersion":"argoproj.io/v1alpha1","time":"2025-09-04T02:38:55Z","fieldsType":"FieldsV1","fieldsV1":{"f:status":{"f:controllerNamespace":{},"f:health":{"f:lastTransitionTime":{},"f:status":{}},"f:history":{},"f:operationState":{".":{},"f:finishedAt":{},"f:message":{},"f:operation":{".":{},"f:initiatedBy":{".":{},"f:username":{}},"f:retry":{},"f:sync":{".":{},"f:revision":{},"f:syncStrategy":{".":{},"f:hook":{}}}},"f:phase":{},"f:startedAt":{},"f:syncResult":{".":{},"f:resources":{},"f:revision":{},"f:source":{".":{},"f:path":{},"f:repoURL":{},"f:targetRevision":{}}}},"f:reconciledAt":{},"f:resourceHealthSource":{},"f:resources":{},"f:sourceType":{},"f:summary":{"f:images":{}},"f:sync":{"f:comparedTo":{"f:destination":{"f:namespace":{},"f:server":{}},"f:source":{"f:path":{},"f:repoURL":{},"f:targetRevision":{}}},"f:revision":{},"f:status":{}}}}}]},"spec":{"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"destination":{"server":"https://kubernetes.default.svc","namespace":"devops"},"project":"default"},"status":{"resources":[{"version":"v1","kind":"Service","namespace":"devops","name":"myapp","status":"Synced","health":{"status":"Healthy"}},{"group":"apps","version":"v1","kind":"Deployment","namespace":"devops","name":"myapp","status":"Synced","health":{"status":"Healthy"}}],"sync":{"status":"Synced","comparedTo":{"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"destination":{"server":"https://kubernetes.default.svc","namespace":"devops"}},"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50"},"health":{"status":"Healthy","lastTransitionTime":"2025-08-13T07:55:07Z"},"history":[{"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","deployedAt":"2025-08-13T07:52:14Z","id":0,"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"deployStartedAt":"2025-08-13T07:52:13Z","initiatedBy":{"username":"admin"}}],"reconciledAt":"2025-09-04T02:38:55Z","operationState":{"operation":{"sync":{"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","syncStrategy":{"hook":{}}},"initiatedBy":{"username":"admin"},"retry":{}},"phase":"Succeeded","message":"successfully synced (all tasks run)","syncResult":{"resources":[{"group":"","version":"v1","kind":"Service","namespace":"devops","name":"myapp","status":"Synced","message":"service/myapp created","hookPhase":"Running","syncPhase":"Sync"},{"group":"apps","version":"v1","kind":"Deployment","namespace":"devops","name":"myapp","status":"Synced","message":"deployment.apps/myapp created","hookPhase":"Running","syncPhase":"Sync"}],"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"}},"startedAt":"2025-08-13T07:52:13Z","finishedAt":"2025-08-13T07:52:14Z"},"sourceType":"Directory","summary":{"images":["registry.cn-shanghai.aliyuncs.com/public-namespace/myapp:v2"]},"resourceHealthSource":"appTree","controllerNamespace":"argocd","sourceHydrator":{}}}}},
    {"result":{"type":"MODIFIED","application":{"metadata":{"name":"myapp","namespace":"argocd","uid":"c93acd62-4305-42fc-bfe3-593e8478d8f2","resourceVersion":"3927701","generation":9929,"creationTimestamp":"2025-08-13T07:49:04Z","managedFields":[{"manager":"argocd-server","operation":"Update","apiVersion":"argoproj.io/v1alpha1","time":"2025-09-04T02:13:28Z","fieldsType":"FieldsV1","fieldsV1":{"f:spec":{".":{},"f:destination":{".":{},"f:namespace":{},"f:server":{}},"f:project":{},"f:source":{".":{},"f:path":{},"f:repoURL":{},"f:targetRevision":{}}},"f:status":{".":{},"f:health":{},"f:sourceHydrator":{},"f:summary":{},"f:sync":{".":{},"f:comparedTo":{".":{},"f:destination":{},"f:source":{}}}}}},{"manager":"argocd-application-controller","operation":"Update","apiVersion":"argoproj.io/v1alpha1","time":"2025-09-04T02:43:05Z","fieldsType":"FieldsV1","fieldsV1":{"f:status":{"f:controllerNamespace":{},"f:health":{"f:lastTransitionTime":{},"f:status":{}},"f:history":{},"f:operationState":{".":{},"f:finishedAt":{},"f:message":{},"f:operation":{".":{},"f:initiatedBy":{".":{},"f:username":{}},"f:retry":{},"f:sync":{".":{},"f:revision":{},"f:syncStrategy":{".":{},"f:hook":{}}}},"f:phase":{},"f:startedAt":{},"f:syncResult":{".":{},"f:resources":{},"f:revision":{},"f:source":{".":{},"f:path":{},"f:repoURL":{},"f:targetRevision":{}}}},"f:reconciledAt":{},"f:resourceHealthSource":{},"f:resources":{},"f:sourceType":{},"f:summary":{"f:images":{}},"f:sync":{"f:comparedTo":{"f:destination":{"f:namespace":{},"f:server":{}},"f:source":{"f:path":{},"f:repoURL":{},"f:targetRevision":{}}},"f:revision":{},"f:status":{}}}}}]},"spec":{"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"destination":{"server":"https://kubernetes.default.svc","namespace":"devops"},"project":"default"},"status":{"resources":[{"version":"v1","kind":"Service","namespace":"devops","name":"myapp","status":"Synced","health":{"status":"Healthy"}},{"group":"apps","version":"v1","kind":"Deployment","namespace":"devops","name":"myapp","status":"Synced","health":{"status":"Healthy"}}],"sync":{"status":"Synced","comparedTo":{"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"destination":{"server":"https://kubernetes.default.svc","namespace":"devops"}},"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50"},"health":{"status":"Healthy","lastTransitionTime":"2025-08-13T07:55:07Z"},"history":[{"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","deployedAt":"2025-08-13T07:52:14Z","id":0,"source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"},"deployStartedAt":"2025-08-13T07:52:13Z","initiatedBy":{"username":"admin"}}],"reconciledAt":"2025-09-04T02:43:05Z","operationState":{"operation":{"sync":{"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","syncStrategy":{"hook":{}}},"initiatedBy":{"username":"admin"},"retry":{}},"phase":"Succeeded","message":"successfully synced (all tasks run)","syncResult":{"resources":[{"group":"","version":"v1","kind":"Service","namespace":"devops","name":"myapp","status":"Synced","message":"service/myapp created","hookPhase":"Running","syncPhase":"Sync"},{"group":"apps","version":"v1","kind":"Deployment","namespace":"devops","name":"myapp","status":"Synced","message":"deployment.apps/myapp created","hookPhase":"Running","syncPhase":"Sync"}],"revision":"39313e1c4af397986a5e1bbb53bde6fef15d6a50","source":{"repoURL":"https://gitee.com/finley/argocd-demo.git","path":"demo","targetRevision":"HEAD"}},"startedAt":"2025-08-13T07:52:13Z","finishedAt":"2025-08-13T07:52:14Z"},"sourceType":"Directory","summary":{"images":["registry.cn-shanghai.aliyuncs.com/public-namespace/myapp:v2"]},"resourceHealthSource":"appTree","controllerNamespace":"argocd","sourceHydrator":{}}}}} 
]
```