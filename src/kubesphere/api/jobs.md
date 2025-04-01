
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/jobs?sortBy=updateTime&limit=10
```json
{
 "items": [
  {
   "kind": "Job",
   "apiVersion": "batch/v1",
   "metadata": {
    "name": "ingress-nginx-admission-patch",
    "namespace": "ingress-nginx",
    "uid": "e48b29ff-7b2c-4335-bea8-46910ab37328",
    "resourceVersion": "2171",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "admission-webhook",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"batch/v1\",\"kind\":\"Job\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"admission-webhook\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-admission-patch\",\"namespace\":\"ingress-nginx\"},\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"app.kubernetes.io/component\":\"admission-webhook\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-admission-patch\"},\"spec\":{\"containers\":[{\"args\":[\"patch\",\"--webhook-name=ingress-nginx-admission\",\"--namespace=$(POD_NAMESPACE)\",\"--patch-mutating=false\",\"--secret-name=ingress-nginx-admission\",\"--patch-failure-policy=Fail\"],\"env\":[{\"name\":\"POD_NAMESPACE\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}}}],\"image\":\"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"patch\",\"securityContext\":{\"allowPrivilegeEscalation\":false}}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\",\"node-role.kubernetes.io/master\":\"\"},\"restartPolicy\":\"OnFailure\",\"securityContext\":{\"fsGroup\":2000,\"runAsNonRoot\":true,\"runAsUser\":2000},\"serviceAccountName\":\"ingress-nginx-admission\",\"tolerations\":[{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/master\"}]}}}}\n",
     "revisions": "{\"1\":{\"status\":\"completed\",\"succeed\":1,\"desire\":1,\"uid\":\"e48b29ff-7b2c-4335-bea8-46910ab37328\",\"start-time\":\"2024-07-08T10:04:43+08:00\",\"completion-time\":\"2024-07-08T10:06:04+08:00\"}}"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "batch/v1",
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
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {}
        }
       },
       "f:spec": {
        "f:backoffLimit": {},
        "f:completionMode": {},
        "f:completions": {},
        "f:parallelism": {},
        "f:suspend": {},
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app.kubernetes.io/component": {},
           "f:app.kubernetes.io/instance": {},
           "f:app.kubernetes.io/name": {},
           "f:app.kubernetes.io/part-of": {},
           "f:app.kubernetes.io/version": {}
          },
          "f:name": {}
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"patch\"}": {
            ".": {},
            "f:args": {},
            "f:env": {
             ".": {},
             "k:{\"name\":\"POD_NAMESPACE\"}": {
              ".": {},
              "f:name": {},
              "f:valueFrom": {
               ".": {},
               "f:fieldRef": {}
              }
             }
            },
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:name": {},
            "f:resources": {},
            "f:securityContext": {
             ".": {},
             "f:allowPrivilegeEscalation": {}
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {}
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {
           ".": {},
           "f:fsGroup": {},
           "f:runAsNonRoot": {},
           "f:runAsUser": {}
          },
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {}
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "batch/v1",
      "time": "2024-07-08T02:06:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:completionTime": {},
        "f:conditions": {},
        "f:startTime": {},
        "f:succeeded": {}
       }
      },
      "subresource": "status"
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "batch/v1",
      "time": "2024-07-09T07:01:10Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:revisions": {}
        }
       }
      }
     }
    ]
   },
   "spec": {
    "parallelism": 1,
    "completions": 1,
    "backoffLimit": 6,
    "selector": {
     "matchLabels": {
      "controller-uid": "e48b29ff-7b2c-4335-bea8-46910ab37328"
     }
    },
    "template": {
     "metadata": {
      "name": "ingress-nginx-admission-patch",
      "creationTimestamp": null,
      "labels": {
       "app.kubernetes.io/component": "admission-webhook",
       "app.kubernetes.io/instance": "ingress-nginx",
       "app.kubernetes.io/name": "ingress-nginx",
       "app.kubernetes.io/part-of": "ingress-nginx",
       "app.kubernetes.io/version": "1.1.3",
       "controller-uid": "e48b29ff-7b2c-4335-bea8-46910ab37328",
       "job-name": "ingress-nginx-admission-patch"
      }
     },
     "spec": {
      "containers": [
       {
        "name": "patch",
        "image": "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660",
        "args": [
         "patch",
         "--webhook-name=ingress-nginx-admission",
         "--namespace=$(POD_NAMESPACE)",
         "--patch-mutating=false",
         "--secret-name=ingress-nginx-admission",
         "--patch-failure-policy=Fail"
        ],
        "env": [
         {
          "name": "POD_NAMESPACE",
          "valueFrom": {
           "fieldRef": {
            "apiVersion": "v1",
            "fieldPath": "metadata.namespace"
           }
          }
         }
        ],
        "resources": {},
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent",
        "securityContext": {
         "allowPrivilegeEscalation": false
        }
       }
      ],
      "restartPolicy": "OnFailure",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "nodeSelector": {
       "kubernetes.io/os": "linux",
       "node-role.kubernetes.io/master": ""
      },
      "serviceAccountName": "ingress-nginx-admission",
      "serviceAccount": "ingress-nginx-admission",
      "securityContext": {
       "runAsUser": 2000,
       "runAsNonRoot": true,
       "fsGroup": 2000
      },
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       }
      ]
     }
    },
    "completionMode": "NonIndexed",
    "suspend": false
   },
   "status": {
    "conditions": [
     {
      "type": "Complete",
      "status": "True",
      "lastProbeTime": "2024-07-08T02:06:04Z",
      "lastTransitionTime": "2024-07-08T02:06:04Z"
     }
    ],
    "startTime": "2024-07-08T02:04:43Z",
    "completionTime": "2024-07-08T02:06:04Z",
    "succeeded": 1
   }
  },
  {
   "kind": "Job",
   "apiVersion": "batch/v1",
   "metadata": {
    "name": "ingress-nginx-admission-create",
    "namespace": "ingress-nginx",
    "uid": "4503c0fe-f228-4642-9b59-7b31cb1c4e4d",
    "resourceVersion": "2170",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "admission-webhook",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"batch/v1\",\"kind\":\"Job\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"admission-webhook\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-admission-create\",\"namespace\":\"ingress-nginx\"},\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"app.kubernetes.io/component\":\"admission-webhook\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-admission-create\"},\"spec\":{\"containers\":[{\"args\":[\"create\",\"--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc\",\"--namespace=$(POD_NAMESPACE)\",\"--secret-name=ingress-nginx-admission\"],\"env\":[{\"name\":\"POD_NAMESPACE\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}}}],\"image\":\"registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"create\",\"securityContext\":{\"allowPrivilegeEscalation\":false}}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\",\"node-role.kubernetes.io/master\":\"\"},\"restartPolicy\":\"OnFailure\",\"securityContext\":{\"fsGroup\":2000,\"runAsNonRoot\":true,\"runAsUser\":2000},\"serviceAccountName\":\"ingress-nginx-admission\",\"tolerations\":[{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/master\"}]}}}}\n",
     "revisions": "{\"1\":{\"status\":\"completed\",\"succeed\":1,\"desire\":1,\"uid\":\"4503c0fe-f228-4642-9b59-7b31cb1c4e4d\",\"start-time\":\"2024-07-08T10:04:43+08:00\",\"completion-time\":\"2024-07-08T10:06:02+08:00\"}}"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "batch/v1",
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
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {}
        }
       },
       "f:spec": {
        "f:backoffLimit": {},
        "f:completionMode": {},
        "f:completions": {},
        "f:parallelism": {},
        "f:suspend": {},
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app.kubernetes.io/component": {},
           "f:app.kubernetes.io/instance": {},
           "f:app.kubernetes.io/name": {},
           "f:app.kubernetes.io/part-of": {},
           "f:app.kubernetes.io/version": {}
          },
          "f:name": {}
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"create\"}": {
            ".": {},
            "f:args": {},
            "f:env": {
             ".": {},
             "k:{\"name\":\"POD_NAMESPACE\"}": {
              ".": {},
              "f:name": {},
              "f:valueFrom": {
               ".": {},
               "f:fieldRef": {}
              }
             }
            },
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:name": {},
            "f:resources": {},
            "f:securityContext": {
             ".": {},
             "f:allowPrivilegeEscalation": {}
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {}
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {
           ".": {},
           "f:fsGroup": {},
           "f:runAsNonRoot": {},
           "f:runAsUser": {}
          },
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {}
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "batch/v1",
      "time": "2024-07-08T02:06:02Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:completionTime": {},
        "f:conditions": {},
        "f:startTime": {},
        "f:succeeded": {}
       }
      },
      "subresource": "status"
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "batch/v1",
      "time": "2024-07-09T07:01:10Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:revisions": {}
        }
       }
      }
     }
    ]
   },
   "spec": {
    "parallelism": 1,
    "completions": 1,
    "backoffLimit": 6,
    "selector": {
     "matchLabels": {
      "controller-uid": "4503c0fe-f228-4642-9b59-7b31cb1c4e4d"
     }
    },
    "template": {
     "metadata": {
      "name": "ingress-nginx-admission-create",
      "creationTimestamp": null,
      "labels": {
       "app.kubernetes.io/component": "admission-webhook",
       "app.kubernetes.io/instance": "ingress-nginx",
       "app.kubernetes.io/name": "ingress-nginx",
       "app.kubernetes.io/part-of": "ingress-nginx",
       "app.kubernetes.io/version": "1.1.3",
       "controller-uid": "4503c0fe-f228-4642-9b59-7b31cb1c4e4d",
       "job-name": "ingress-nginx-admission-create"
      }
     },
     "spec": {
      "containers": [
       {
        "name": "create",
        "image": "registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.1.1@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660",
        "args": [
         "create",
         "--host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc",
         "--namespace=$(POD_NAMESPACE)",
         "--secret-name=ingress-nginx-admission"
        ],
        "env": [
         {
          "name": "POD_NAMESPACE",
          "valueFrom": {
           "fieldRef": {
            "apiVersion": "v1",
            "fieldPath": "metadata.namespace"
           }
          }
         }
        ],
        "resources": {},
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent",
        "securityContext": {
         "allowPrivilegeEscalation": false
        }
       }
      ],
      "restartPolicy": "OnFailure",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "nodeSelector": {
       "kubernetes.io/os": "linux",
       "node-role.kubernetes.io/master": ""
      },
      "serviceAccountName": "ingress-nginx-admission",
      "serviceAccount": "ingress-nginx-admission",
      "securityContext": {
       "runAsUser": 2000,
       "runAsNonRoot": true,
       "fsGroup": 2000
      },
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       }
      ]
     }
    },
    "completionMode": "NonIndexed",
    "suspend": false
   },
   "status": {
    "conditions": [
     {
      "type": "Complete",
      "status": "True",
      "lastProbeTime": "2024-07-08T02:06:02Z",
      "lastTransitionTime": "2024-07-08T02:06:02Z"
     }
    ],
    "startTime": "2024-07-08T02:04:43Z",
    "completionTime": "2024-07-08T02:06:02Z",
    "succeeded": 1
   }
  }
 ],
 "totalItems": 2
}
```

// 定时任务
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/cronjobs?sortBy=createTime&limit=10
```json
{
 "items": [],
 "totalItems": 0
}
```

