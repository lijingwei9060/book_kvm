
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/deployments?sortBy=updateTime&limit=10

```json
{
 "items": [
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "ks-apiserver",
    "namespace": "kubesphere-system",
    "uid": "57cea92b-b963-4f5a-9d3e-2d3cccdceb0d",
    "resourceVersion": "3655",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-apiserver",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "backend",
     "version": "v4.1.1"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:meta.helm.sh/release-name": {},
         "f:meta.helm.sh/release-namespace": {}
        },
        "f:labels": {
         ".": {},
         "f:app": {},
         "f:app.kubernetes.io/managed-by": {},
         "f:tier": {},
         "f:version": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app": {},
           "f:tier": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"ks-apiserver\"}": {
            ".": {},
            "f:command": {},
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:livenessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:httpGet": {
              ".": {},
              "f:path": {},
              "f:port": {},
              "f:scheme": {}
             },
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:name": {},
            "f:ports": {
             ".": {},
             "k:{\"containerPort\":9090,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:protocol": {}
             }
            },
            "f:resources": {
             ".": {},
             "f:limits": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             },
             "f:requests": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             }
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/etc/kubesphere/\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {}
             },
             "k:{\"mountPath\":\"/etc/localtime\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:readOnly": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"host-time\"}": {
            ".": {},
            "f:hostPath": {
             ".": {},
             "f:path": {},
             "f:type": {}
            },
            "f:name": {}
           },
           "k:{\"name\":\"kubesphere-config\"}": {
            ".": {},
            "f:configMap": {
             ".": {},
             "f:defaultMode": {},
             "f:name": {}
            },
            "f:name": {}
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:09:22Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "app": "ks-apiserver",
      "tier": "backend"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "app": "ks-apiserver",
       "tier": "backend"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "kubesphere-config",
        "configMap": {
         "name": "kubesphere-config",
         "defaultMode": 420
        }
       },
       {
        "name": "host-time",
        "hostPath": {
         "path": "/etc/localtime",
         "type": ""
        }
       }
      ],
      "containers": [
       {
        "name": "ks-apiserver",
        "image": "registry.cn-beijing.aliyuncs.com/kse/ks-apiserver:v4.1.1",
        "command": [
         "ks-apiserver",
         "--logtostderr=true"
        ],
        "ports": [
         {
          "containerPort": 9090,
          "protocol": "TCP"
         }
        ],
        "resources": {
         "limits": {
          "cpu": "1",
          "memory": "1Gi"
         },
         "requests": {
          "cpu": "20m",
          "memory": "100Mi"
         }
        },
        "volumeMounts": [
         {
          "name": "kubesphere-config",
          "mountPath": "/etc/kubesphere/"
         },
         {
          "name": "host-time",
          "readOnly": true,
          "mountPath": "/etc/localtime"
         }
        ],
        "livenessProbe": {
         "httpGet": {
          "path": "/version",
          "port": 9090,
          "scheme": "HTTP"
         },
         "initialDelaySeconds": 15,
         "timeoutSeconds": 15,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 8
        },
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent"
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "serviceAccountName": "kubesphere",
      "serviceAccount": "kubesphere",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       },
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node.kubernetes.io/not-ready",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       },
       {
        "key": "node.kubernetes.io/unreachable",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       }
      ]
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 0,
      "maxSurge": 1
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-09T07:00:58Z",
      "lastTransitionTime": "2024-07-09T07:00:31Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"ks-apiserver-76b6dc5bf7\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:09:22Z",
      "lastTransitionTime": "2025-03-01T07:09:22Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "ingress-nginx-controller",
    "namespace": "ingress-nginx",
    "uid": "af6a5035-d0e2-4c37-aea9-ffa5560f2f5c",
    "resourceVersion": "3386",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-controller\",\"namespace\":\"ingress-nginx\"},\"spec\":{\"minReadySeconds\":0,\"revisionHistoryLimit\":10,\"selector\":{\"matchLabels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\"}},\"template\":{\"metadata\":{\"labels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\"}},\"spec\":{\"containers\":[{\"args\":[\"/nginx-ingress-controller\",\"--enable-ssl-passthrough\",\"--default-ssl-certificate=$(POD_NAMESPACE)/c\",\"--watch-ingress-without-class=true\",\"--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller\",\"--election-id=ingress-controller-leader\",\"--controller-class=k8s.io/ingress-nginx\",\"--ingress-class=nginx\",\"--configmap=$(POD_NAMESPACE)/ingress-nginx-controller\",\"--validating-webhook=:8443\",\"--validating-webhook-certificate=/usr/local/certificates/cert\",\"--validating-webhook-key=/usr/local/certificates/key\"],\"env\":[{\"name\":\"POD_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.name\"}}},{\"name\":\"POD_NAMESPACE\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}}},{\"name\":\"LD_PRELOAD\",\"value\":\"/usr/local/lib/libmimalloc.so\"}],\"image\":\"registry.k8s.io/ingress-nginx/controller:v1.1.3@sha256:31f47c1e202b39fadecf822a9b76370bd4baed199a005b3e7d4d1455f4fd3fe2\",\"imagePullPolicy\":\"IfNotPresent\",\"lifecycle\":{\"preStop\":{\"exec\":{\"command\":[\"/wait-shutdown\"]}}},\"livenessProbe\":{\"failureThreshold\":5,\"httpGet\":{\"path\":\"/healthz\",\"port\":10254,\"scheme\":\"HTTP\"},\"initialDelaySeconds\":10,\"periodSeconds\":10,\"successThreshold\":1,\"timeoutSeconds\":1},\"name\":\"controller\",\"ports\":[{\"containerPort\":80,\"name\":\"http\",\"protocol\":\"TCP\"},{\"containerPort\":443,\"name\":\"https\",\"protocol\":\"TCP\"},{\"containerPort\":8443,\"name\":\"webhook\",\"protocol\":\"TCP\"}],\"readinessProbe\":{\"failureThreshold\":3,\"httpGet\":{\"path\":\"/healthz\",\"port\":10254,\"scheme\":\"HTTP\"},\"initialDelaySeconds\":10,\"periodSeconds\":10,\"successThreshold\":1,\"timeoutSeconds\":1},\"resources\":{\"requests\":{\"cpu\":\"100m\",\"memory\":\"90Mi\"}},\"securityContext\":{\"allowPrivilegeEscalation\":true,\"capabilities\":{\"add\":[\"NET_BIND_SERVICE\"],\"drop\":[\"ALL\"]},\"runAsUser\":101},\"volumeMounts\":[{\"mountPath\":\"/usr/local/certificates/\",\"name\":\"webhook-cert\",\"readOnly\":true}]}],\"dnsPolicy\":\"ClusterFirst\",\"nodeSelector\":{\"kubernetes.io/os\":\"linux\",\"node-role.kubernetes.io/master\":\"\"},\"serviceAccountName\":\"ingress-nginx\",\"terminationGracePeriodSeconds\":300,\"tolerations\":[{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/master\"},{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"effect\":\"NoExecute\",\"key\":\"node.kubernetes.io/not-ready\",\"operator\":\"Exists\",\"tolerationSeconds\":60},{\"effect\":\"NoExecute\",\"key\":\"node.kubernetes.io/unreachable\",\"operator\":\"Exists\",\"tolerationSeconds\":60}],\"volumes\":[{\"name\":\"webhook-cert\",\"secret\":{\"secretName\":\"ingress-nginx-admission\"}}]}}}}\n"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "apps/v1",
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
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app.kubernetes.io/component": {},
           "f:app.kubernetes.io/instance": {},
           "f:app.kubernetes.io/name": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"controller\"}": {
            ".": {},
            "f:args": {},
            "f:env": {
             ".": {},
             "k:{\"name\":\"LD_PRELOAD\"}": {
              ".": {},
              "f:name": {},
              "f:value": {}
             },
             "k:{\"name\":\"POD_NAME\"}": {
              ".": {},
              "f:name": {},
              "f:valueFrom": {
               ".": {},
               "f:fieldRef": {}
              }
             },
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
            "f:lifecycle": {
             ".": {},
             "f:preStop": {
              ".": {},
              "f:exec": {
               ".": {},
               "f:command": {}
              }
             }
            },
            "f:livenessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:httpGet": {
              ".": {},
              "f:path": {},
              "f:port": {},
              "f:scheme": {}
             },
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:name": {},
            "f:ports": {
             ".": {},
             "k:{\"containerPort\":80,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             },
             "k:{\"containerPort\":443,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             },
             "k:{\"containerPort\":8443,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             }
            },
            "f:readinessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:httpGet": {
              ".": {},
              "f:path": {},
              "f:port": {},
              "f:scheme": {}
             },
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:resources": {
             ".": {},
             "f:requests": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             }
            },
            "f:securityContext": {
             ".": {},
             "f:allowPrivilegeEscalation": {},
             "f:capabilities": {
              ".": {},
              "f:add": {},
              "f:drop": {}
             },
             "f:runAsUser": {}
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/usr/local/certificates/\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:readOnly": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"webhook-cert\"}": {
            ".": {},
            "f:name": {},
            "f:secret": {
             ".": {},
             "f:defaultMode": {},
             "f:secretName": {}
            }
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:15Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "app.kubernetes.io/component": "controller",
      "app.kubernetes.io/instance": "ingress-nginx",
      "app.kubernetes.io/name": "ingress-nginx"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "app.kubernetes.io/component": "controller",
       "app.kubernetes.io/instance": "ingress-nginx",
       "app.kubernetes.io/name": "ingress-nginx"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "webhook-cert",
        "secret": {
         "secretName": "ingress-nginx-admission",
         "defaultMode": 420
        }
       }
      ],
      "containers": [
       {
        "name": "controller",
        "image": "registry.k8s.io/ingress-nginx/controller:v1.1.3@sha256:31f47c1e202b39fadecf822a9b76370bd4baed199a005b3e7d4d1455f4fd3fe2",
        "args": [
         "/nginx-ingress-controller",
         "--enable-ssl-passthrough",
         "--default-ssl-certificate=$(POD_NAMESPACE)/c",
         "--watch-ingress-without-class=true",
         "--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller",
         "--election-id=ingress-controller-leader",
         "--controller-class=k8s.io/ingress-nginx",
         "--ingress-class=nginx",
         "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller",
         "--validating-webhook=:8443",
         "--validating-webhook-certificate=/usr/local/certificates/cert",
         "--validating-webhook-key=/usr/local/certificates/key"
        ],
        "ports": [
         {
          "name": "http",
          "containerPort": 80,
          "protocol": "TCP"
         },
         {
          "name": "https",
          "containerPort": 443,
          "protocol": "TCP"
         },
         {
          "name": "webhook",
          "containerPort": 8443,
          "protocol": "TCP"
         }
        ],
        "env": [
         {
          "name": "POD_NAME",
          "valueFrom": {
           "fieldRef": {
            "apiVersion": "v1",
            "fieldPath": "metadata.name"
           }
          }
         },
         {
          "name": "POD_NAMESPACE",
          "valueFrom": {
           "fieldRef": {
            "apiVersion": "v1",
            "fieldPath": "metadata.namespace"
           }
          }
         },
         {
          "name": "LD_PRELOAD",
          "value": "/usr/local/lib/libmimalloc.so"
         }
        ],
        "resources": {
         "requests": {
          "cpu": "100m",
          "memory": "90Mi"
         }
        },
        "volumeMounts": [
         {
          "name": "webhook-cert",
          "readOnly": true,
          "mountPath": "/usr/local/certificates/"
         }
        ],
        "livenessProbe": {
         "httpGet": {
          "path": "/healthz",
          "port": 10254,
          "scheme": "HTTP"
         },
         "initialDelaySeconds": 10,
         "timeoutSeconds": 1,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 5
        },
        "readinessProbe": {
         "httpGet": {
          "path": "/healthz",
          "port": 10254,
          "scheme": "HTTP"
         },
         "initialDelaySeconds": 10,
         "timeoutSeconds": 1,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 3
        },
        "lifecycle": {
         "preStop": {
          "exec": {
           "command": [
            "/wait-shutdown"
           ]
          }
         }
        },
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent",
        "securityContext": {
         "capabilities": {
          "add": [
           "NET_BIND_SERVICE"
          ],
          "drop": [
           "ALL"
          ]
         },
         "runAsUser": 101,
         "allowPrivilegeEscalation": true
        }
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 300,
      "dnsPolicy": "ClusterFirst",
      "nodeSelector": {
       "kubernetes.io/os": "linux",
       "node-role.kubernetes.io/master": ""
      },
      "serviceAccountName": "ingress-nginx",
      "serviceAccount": "ingress-nginx",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       },
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node.kubernetes.io/not-ready",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       },
       {
        "key": "node.kubernetes.io/unreachable",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       }
      ]
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": "25%",
      "maxSurge": "25%"
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-08T02:06:22Z",
      "lastTransitionTime": "2024-07-08T02:04:43Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"ingress-nginx-controller-84cf5fc97b\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:15Z",
      "lastTransitionTime": "2025-03-01T07:08:15Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "calico-kube-controllers",
    "namespace": "kube-system",
    "uid": "6f8914c4-b01a-4271-a79d-cbb74069f46e",
    "resourceVersion": "3392",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "k8s-app": "calico-kube-controllers"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"labels\":{\"k8s-app\":\"calico-kube-controllers\"},\"name\":\"calico-kube-controllers\",\"namespace\":\"kube-system\"},\"spec\":{\"replicas\":1,\"selector\":{\"matchLabels\":{\"k8s-app\":\"calico-kube-controllers\"}},\"strategy\":{\"type\":\"Recreate\"},\"template\":{\"metadata\":{\"labels\":{\"k8s-app\":\"calico-kube-controllers\"},\"name\":\"calico-kube-controllers\",\"namespace\":\"kube-system\"},\"spec\":{\"containers\":[{\"env\":[{\"name\":\"ENABLED_CONTROLLERS\",\"value\":\"node\"},{\"name\":\"DATASTORE_TYPE\",\"value\":\"kubernetes\"}],\"image\":\"docker.io/calico/kube-controllers:v3.21.6\",\"livenessProbe\":{\"exec\":{\"command\":[\"/usr/bin/check-status\",\"-l\"]},\"failureThreshold\":6,\"initialDelaySeconds\":10,\"periodSeconds\":10,\"timeoutSeconds\":10},\"name\":\"calico-kube-controllers\",\"readinessProbe\":{\"exec\":{\"command\":[\"/usr/bin/check-status\",\"-r\"]},\"periodSeconds\":10}}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"},\"priorityClassName\":\"system-cluster-critical\",\"serviceAccountName\":\"calico-kube-controllers\",\"tolerations\":[{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/master\"}]}}}}\n"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "apps/v1",
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
         "f:k8s-app": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:k8s-app": {}
          },
          "f:name": {},
          "f:namespace": {}
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"calico-kube-controllers\"}": {
            ".": {},
            "f:env": {
             ".": {},
             "k:{\"name\":\"DATASTORE_TYPE\"}": {
              ".": {},
              "f:name": {},
              "f:value": {}
             },
             "k:{\"name\":\"ENABLED_CONTROLLERS\"}": {
              ".": {},
              "f:name": {},
              "f:value": {}
             }
            },
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:livenessProbe": {
             ".": {},
             "f:exec": {
              ".": {},
              "f:command": {}
             },
             "f:failureThreshold": {},
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:name": {},
            "f:readinessProbe": {
             ".": {},
             "f:exec": {
              ".": {},
              "f:command": {}
             },
             "f:failureThreshold": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:resources": {},
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {}
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:priorityClassName": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
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
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:15Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "k8s-app": "calico-kube-controllers"
     }
    },
    "template": {
     "metadata": {
      "name": "calico-kube-controllers",
      "namespace": "kube-system",
      "creationTimestamp": null,
      "labels": {
       "k8s-app": "calico-kube-controllers"
      }
     },
     "spec": {
      "containers": [
       {
        "name": "calico-kube-controllers",
        "image": "docker.io/calico/kube-controllers:v3.21.6",
        "env": [
         {
          "name": "ENABLED_CONTROLLERS",
          "value": "node"
         },
         {
          "name": "DATASTORE_TYPE",
          "value": "kubernetes"
         }
        ],
        "resources": {},
        "livenessProbe": {
         "exec": {
          "command": [
           "/usr/bin/check-status",
           "-l"
          ]
         },
         "initialDelaySeconds": 10,
         "timeoutSeconds": 10,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 6
        },
        "readinessProbe": {
         "exec": {
          "command": [
           "/usr/bin/check-status",
           "-r"
          ]
         },
         "timeoutSeconds": 1,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 3
        },
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent"
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "nodeSelector": {
       "kubernetes.io/os": "linux"
      },
      "serviceAccountName": "calico-kube-controllers",
      "serviceAccount": "calico-kube-controllers",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       }
      ],
      "priorityClassName": "system-cluster-critical"
     }
    },
    "strategy": {
     "type": "Recreate"
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-08T02:06:05Z",
      "lastTransitionTime": "2024-07-08T02:04:43Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"calico-kube-controllers-7f76d48f74\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:15Z",
      "lastTransitionTime": "2025-03-01T07:08:15Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "coredns",
    "namespace": "kube-system",
    "uid": "f2dbf7f2-66b6-47c5-84fc-7b2ff9db6920",
    "resourceVersion": "3402",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:07Z",
    "labels": {
     "k8s-app": "kube-dns"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1"
    },
    "managedFields": [
     {
      "manager": "kubeadm",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-08T02:04:07Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         ".": {},
         "f:k8s-app": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:k8s-app": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"coredns\"}": {
            ".": {},
            "f:args": {},
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:livenessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:httpGet": {
              ".": {},
              "f:path": {},
              "f:port": {},
              "f:scheme": {}
             },
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:name": {},
            "f:ports": {
             ".": {},
             "k:{\"containerPort\":53,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             },
             "k:{\"containerPort\":53,\"protocol\":\"UDP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             },
             "k:{\"containerPort\":9153,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:name": {},
              "f:protocol": {}
             }
            },
            "f:readinessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:httpGet": {
              ".": {},
              "f:path": {},
              "f:port": {},
              "f:scheme": {}
             },
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:timeoutSeconds": {}
            },
            "f:resources": {
             ".": {},
             "f:limits": {
              ".": {},
              "f:memory": {}
             },
             "f:requests": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             }
            },
            "f:securityContext": {
             ".": {},
             "f:allowPrivilegeEscalation": {},
             "f:capabilities": {
              ".": {},
              "f:add": {},
              "f:drop": {}
             },
             "f:readOnlyRootFilesystem": {}
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/etc/coredns\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:readOnly": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:priorityClassName": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"config-volume\"}": {
            ".": {},
            "f:configMap": {
             ".": {},
             "f:defaultMode": {},
             "f:items": {},
             "f:name": {}
            },
            "f:name": {}
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:15Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 2,
    "selector": {
     "matchLabels": {
      "k8s-app": "kube-dns"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "k8s-app": "kube-dns"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "config-volume",
        "configMap": {
         "name": "coredns",
         "items": [
          {
           "key": "Corefile",
           "path": "Corefile"
          }
         ],
         "defaultMode": 420
        }
       }
      ],
      "containers": [
       {
        "name": "coredns",
        "image": "k8s.gcr.io/coredns/coredns:v1.8.6",
        "args": [
         "-conf",
         "/etc/coredns/Corefile"
        ],
        "ports": [
         {
          "name": "dns",
          "containerPort": 53,
          "protocol": "UDP"
         },
         {
          "name": "dns-tcp",
          "containerPort": 53,
          "protocol": "TCP"
         },
         {
          "name": "metrics",
          "containerPort": 9153,
          "protocol": "TCP"
         }
        ],
        "resources": {
         "limits": {
          "memory": "170Mi"
         },
         "requests": {
          "cpu": "100m",
          "memory": "70Mi"
         }
        },
        "volumeMounts": [
         {
          "name": "config-volume",
          "readOnly": true,
          "mountPath": "/etc/coredns"
         }
        ],
        "livenessProbe": {
         "httpGet": {
          "path": "/health",
          "port": 8080,
          "scheme": "HTTP"
         },
         "initialDelaySeconds": 60,
         "timeoutSeconds": 5,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 5
        },
        "readinessProbe": {
         "httpGet": {
          "path": "/ready",
          "port": 8181,
          "scheme": "HTTP"
         },
         "timeoutSeconds": 1,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 3
        },
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent",
        "securityContext": {
         "capabilities": {
          "add": [
           "NET_BIND_SERVICE"
          ],
          "drop": [
           "all"
          ]
         },
         "readOnlyRootFilesystem": true,
         "allowPrivilegeEscalation": false
        }
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "Default",
      "nodeSelector": {
       "kubernetes.io/os": "linux"
      },
      "serviceAccountName": "coredns",
      "serviceAccount": "coredns",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       },
       {
        "key": "node-role.kubernetes.io/control-plane",
        "effect": "NoSchedule"
       }
      ],
      "priorityClassName": "system-cluster-critical"
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 1,
      "maxSurge": "25%"
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 2,
    "updatedReplicas": 2,
    "readyReplicas": 2,
    "availableReplicas": 2,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-08T02:05:48Z",
      "lastTransitionTime": "2024-07-08T02:04:22Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"coredns-64897985d\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:15Z",
      "lastTransitionTime": "2025-03-01T07:08:15Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "local-path-provisioner",
    "namespace": "local-path-storage",
    "uid": "546ced6d-eb12-4f72-975e-53c737c3f1a2",
    "resourceVersion": "3374",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:08Z",
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"name\":\"local-path-provisioner\",\"namespace\":\"local-path-storage\"},\"spec\":{\"replicas\":1,\"selector\":{\"matchLabels\":{\"app\":\"local-path-provisioner\"}},\"template\":{\"metadata\":{\"labels\":{\"app\":\"local-path-provisioner\"}},\"spec\":{\"containers\":[{\"command\":[\"local-path-provisioner\",\"--debug\",\"start\",\"--helper-image\",\"docker.io/kindest/local-path-helper:v20220607-9a4d8d2a\",\"--config\",\"/etc/config/config.json\"],\"env\":[{\"name\":\"POD_NAMESPACE\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"metadata.namespace\"}}}],\"image\":\"docker.io/kindest/local-path-provisioner:v0.0.22-kind.0\",\"imagePullPolicy\":\"IfNotPresent\",\"name\":\"local-path-provisioner\",\"volumeMounts\":[{\"mountPath\":\"/etc/config/\",\"name\":\"config-volume\"}]}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"},\"serviceAccountName\":\"local-path-provisioner-service-account\",\"tolerations\":[{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/control-plane\",\"operator\":\"Equal\"},{\"effect\":\"NoSchedule\",\"key\":\"node-role.kubernetes.io/master\",\"operator\":\"Equal\"}],\"volumes\":[{\"configMap\":{\"name\":\"local-path-config\"},\"name\":\"config-volume\"}]}}}}\n"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-08T02:04:08Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:kubectl.kubernetes.io/last-applied-configuration": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"local-path-provisioner\"}": {
            ".": {},
            "f:command": {},
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
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/etc/config/\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:nodeSelector": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"config-volume\"}": {
            ".": {},
            "f:configMap": {
             ".": {},
             "f:defaultMode": {},
             "f:name": {}
            },
            "f:name": {}
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:12Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "app": "local-path-provisioner"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "app": "local-path-provisioner"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "config-volume",
        "configMap": {
         "name": "local-path-config",
         "defaultMode": 420
        }
       }
      ],
      "containers": [
       {
        "name": "local-path-provisioner",
        "image": "docker.io/kindest/local-path-provisioner:v0.0.22-kind.0",
        "command": [
         "local-path-provisioner",
         "--debug",
         "start",
         "--helper-image",
         "docker.io/kindest/local-path-helper:v20220607-9a4d8d2a",
         "--config",
         "/etc/config/config.json"
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
        "volumeMounts": [
         {
          "name": "config-volume",
          "mountPath": "/etc/config/"
         }
        ],
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent"
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "nodeSelector": {
       "kubernetes.io/os": "linux"
      },
      "serviceAccountName": "local-path-provisioner-service-account",
      "serviceAccount": "local-path-provisioner-service-account",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/control-plane",
        "operator": "Equal",
        "effect": "NoSchedule"
       },
       {
        "key": "node-role.kubernetes.io/master",
        "operator": "Equal",
        "effect": "NoSchedule"
       }
      ]
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": "25%",
      "maxSurge": "25%"
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-08T02:05:44Z",
      "lastTransitionTime": "2024-07-08T02:04:22Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"local-path-provisioner-58dc9cd8d9\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:12Z",
      "lastTransitionTime": "2025-03-01T07:08:12Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "ks-controller-manager",
    "namespace": "kubesphere-system",
    "uid": "88a150df-a02d-4ad4-8e77-2074c6a29261",
    "resourceVersion": "3362",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-controller-manager",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "backend",
     "version": "v4.1.1"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:meta.helm.sh/release-name": {},
         "f:meta.helm.sh/release-namespace": {}
        },
        "f:labels": {
         ".": {},
         "f:app": {},
         "f:app.kubernetes.io/managed-by": {},
         "f:tier": {},
         "f:version": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:annotations": {
           ".": {},
           "f:kubesphere.io/update-time": {}
          },
          "f:labels": {
           ".": {},
           "f:app": {},
           "f:tier": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"ks-controller-manager\"}": {
            ".": {},
            "f:command": {},
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:name": {},
            "f:ports": {
             ".": {},
             "k:{\"containerPort\":8080,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:protocol": {}
             },
             "k:{\"containerPort\":8443,\"protocol\":\"TCP\"}": {
              ".": {},
              "f:containerPort": {},
              "f:protocol": {}
             }
            },
            "f:resources": {
             ".": {},
             "f:limits": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             },
             "f:requests": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             }
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/etc/kubesphere/\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {}
             },
             "k:{\"mountPath\":\"/etc/localtime\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:readOnly": {}
             },
             "k:{\"mountPath\":\"/tmp/k8s-webhook-server/serving-certs\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"host-time\"}": {
            ".": {},
            "f:hostPath": {
             ".": {},
             "f:path": {},
             "f:type": {}
            },
            "f:name": {}
           },
           "k:{\"name\":\"kubesphere-config\"}": {
            ".": {},
            "f:configMap": {
             ".": {},
             "f:defaultMode": {},
             "f:name": {}
            },
            "f:name": {}
           },
           "k:{\"name\":\"webhook-secret\"}": {
            ".": {},
            "f:name": {},
            "f:secret": {
             ".": {},
             "f:defaultMode": {},
             "f:secretName": {}
            }
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:11Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "app": "ks-controller-manager",
      "tier": "backend"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "app": "ks-controller-manager",
       "tier": "backend"
      },
      "annotations": {
       "kubesphere.io/update-time": "2024-07-09T07:28:28Z"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "kubesphere-config",
        "configMap": {
         "name": "kubesphere-config",
         "defaultMode": 420
        }
       },
       {
        "name": "webhook-secret",
        "secret": {
         "secretName": "ks-controller-manager-webhook-cert",
         "defaultMode": 420
        }
       },
       {
        "name": "host-time",
        "hostPath": {
         "path": "/etc/localtime",
         "type": ""
        }
       }
      ],
      "containers": [
       {
        "name": "ks-controller-manager",
        "image": "registry.cn-beijing.aliyuncs.com/kse/ks-controller-manager:v4.1.1",
        "command": [
         "controller-manager",
         "--logtostderr=true",
         "--leader-elect=true",
         "--controllers=*"
        ],
        "ports": [
         {
          "containerPort": 8080,
          "protocol": "TCP"
         },
         {
          "containerPort": 8443,
          "protocol": "TCP"
         }
        ],
        "resources": {
         "limits": {
          "cpu": "1",
          "memory": "1000Mi"
         },
         "requests": {
          "cpu": "30m",
          "memory": "50Mi"
         }
        },
        "volumeMounts": [
         {
          "name": "kubesphere-config",
          "mountPath": "/etc/kubesphere/"
         },
         {
          "name": "webhook-secret",
          "mountPath": "/tmp/k8s-webhook-server/serving-certs"
         },
         {
          "name": "host-time",
          "readOnly": true,
          "mountPath": "/etc/localtime"
         }
        ],
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent"
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "serviceAccountName": "kubesphere",
      "serviceAccount": "kubesphere",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       },
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node.kubernetes.io/not-ready",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       },
       {
        "key": "node.kubernetes.io/unreachable",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       }
      ]
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 0,
      "maxSurge": 1
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-09T07:01:10Z",
      "lastTransitionTime": "2024-07-09T07:00:31Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"ks-controller-manager-5745b8dcdb\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:11Z",
      "lastTransitionTime": "2025-03-01T07:08:11Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  },
  {
   "kind": "Deployment",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "ks-console",
    "namespace": "kubesphere-system",
    "uid": "b4e00316-311a-45d3-a268-4e238a1e8b77",
    "resourceVersion": "3286",
    "generation": 1,
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-console",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "frontend",
     "version": "v4.1.1"
    },
    "annotations": {
     "deployment.kubernetes.io/revision": "1",
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:meta.helm.sh/release-name": {},
         "f:meta.helm.sh/release-namespace": {}
        },
        "f:labels": {
         ".": {},
         "f:app": {},
         "f:app.kubernetes.io/managed-by": {},
         "f:tier": {},
         "f:version": {}
        }
       },
       "f:spec": {
        "f:progressDeadlineSeconds": {},
        "f:replicas": {},
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:strategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        },
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:app": {},
           "f:tier": {}
          }
         },
         "f:spec": {
          "f:containers": {
           "k:{\"name\":\"ks-console\"}": {
            ".": {},
            "f:image": {},
            "f:imagePullPolicy": {},
            "f:livenessProbe": {
             ".": {},
             "f:failureThreshold": {},
             "f:initialDelaySeconds": {},
             "f:periodSeconds": {},
             "f:successThreshold": {},
             "f:tcpSocket": {
              ".": {},
              "f:port": {}
             },
             "f:timeoutSeconds": {}
            },
            "f:name": {},
            "f:resources": {
             ".": {},
             "f:limits": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             },
             "f:requests": {
              ".": {},
              "f:cpu": {},
              "f:memory": {}
             }
            },
            "f:terminationMessagePath": {},
            "f:terminationMessagePolicy": {},
            "f:volumeMounts": {
             ".": {},
             "k:{\"mountPath\":\"/etc/localtime\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:readOnly": {}
             },
             "k:{\"mountPath\":\"/opt/kubesphere/console/configs/local_config.yaml\"}": {
              ".": {},
              "f:mountPath": {},
              "f:name": {},
              "f:subPath": {}
             }
            }
           }
          },
          "f:dnsPolicy": {},
          "f:restartPolicy": {},
          "f:schedulerName": {},
          "f:securityContext": {},
          "f:serviceAccount": {},
          "f:serviceAccountName": {},
          "f:terminationGracePeriodSeconds": {},
          "f:tolerations": {},
          "f:volumes": {
           ".": {},
           "k:{\"name\":\"host-time\"}": {
            ".": {},
            "f:hostPath": {
             ".": {},
             "f:path": {},
             "f:type": {}
            },
            "f:name": {}
           },
           "k:{\"name\":\"ks-console-config\"}": {
            ".": {},
            "f:configMap": {
             ".": {},
             "f:defaultMode": {},
             "f:items": {},
             "f:name": {}
            },
            "f:name": {}
           }
          }
         }
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:deployment.kubernetes.io/revision": {}
        }
       },
       "f:status": {
        "f:availableReplicas": {},
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"Available\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Progressing\"}": {
          ".": {},
          "f:lastTransitionTime": {},
          "f:lastUpdateTime": {},
          "f:message": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         }
        },
        "f:observedGeneration": {},
        "f:readyReplicas": {},
        "f:replicas": {},
        "f:updatedReplicas": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "replicas": 1,
    "selector": {
     "matchLabels": {
      "app": "ks-console",
      "tier": "frontend"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "app": "ks-console",
       "tier": "frontend"
      }
     },
     "spec": {
      "volumes": [
       {
        "name": "ks-console-config",
        "configMap": {
         "name": "ks-console-config",
         "items": [
          {
           "key": "local_config.yaml",
           "path": "local_config.yaml"
          }
         ],
         "defaultMode": 420
        }
       },
       {
        "name": "host-time",
        "hostPath": {
         "path": "/etc/localtime",
         "type": ""
        }
       }
      ],
      "containers": [
       {
        "name": "ks-console",
        "image": "registry.cn-beijing.aliyuncs.com/kse/ks-console:v4.1.1",
        "resources": {
         "limits": {
          "cpu": "1",
          "memory": "1Gi"
         },
         "requests": {
          "cpu": "20m",
          "memory": "100Mi"
         }
        },
        "volumeMounts": [
         {
          "name": "ks-console-config",
          "mountPath": "/opt/kubesphere/console/configs/local_config.yaml",
          "subPath": "local_config.yaml"
         },
         {
          "name": "host-time",
          "readOnly": true,
          "mountPath": "/etc/localtime"
         }
        ],
        "livenessProbe": {
         "tcpSocket": {
          "port": 8000
         },
         "initialDelaySeconds": 15,
         "timeoutSeconds": 15,
         "periodSeconds": 10,
         "successThreshold": 1,
         "failureThreshold": 8
        },
        "terminationMessagePath": "/dev/termination-log",
        "terminationMessagePolicy": "File",
        "imagePullPolicy": "IfNotPresent"
       }
      ],
      "restartPolicy": "Always",
      "terminationGracePeriodSeconds": 30,
      "dnsPolicy": "ClusterFirst",
      "serviceAccountName": "kubesphere",
      "serviceAccount": "kubesphere",
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
       },
       {
        "key": "CriticalAddonsOnly",
        "operator": "Exists"
       },
       {
        "key": "node.kubernetes.io/not-ready",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       },
       {
        "key": "node.kubernetes.io/unreachable",
        "operator": "Exists",
        "effect": "NoExecute",
        "tolerationSeconds": 60
       }
      ]
     }
    },
    "strategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 0,
      "maxSurge": 1
     }
    },
    "revisionHistoryLimit": 10,
    "progressDeadlineSeconds": 600
   },
   "status": {
    "observedGeneration": 1,
    "replicas": 1,
    "updatedReplicas": 1,
    "readyReplicas": 1,
    "availableReplicas": 1,
    "conditions": [
     {
      "type": "Progressing",
      "status": "True",
      "lastUpdateTime": "2024-07-09T07:00:45Z",
      "lastTransitionTime": "2024-07-09T07:00:31Z",
      "reason": "NewReplicaSetAvailable",
      "message": "ReplicaSet \"ks-console-6ff4d5d798\" has successfully progressed."
     },
     {
      "type": "Available",
      "status": "True",
      "lastUpdateTime": "2025-03-01T07:08:04Z",
      "lastTransitionTime": "2025-03-01T07:08:04Z",
      "reason": "MinimumReplicasAvailable",
      "message": "Deployment has minimum availability."
     }
    ]
   }
  }
 ],
 "totalItems": 7
}
```