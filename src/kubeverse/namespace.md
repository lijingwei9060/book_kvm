
集群命名空间列表
/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/baseResourceList?group=&version=v1&kind=Namespace&namespace=

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "apiVersion": "",
        "items": [
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-08-01T08:58:16Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "adp-system"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "adp",
                            "operation": "Update",
                            "time": "2025-08-01T08:58:16Z"
                        }
                    ],
                    "name": "adp-system",
                    "resourceVersion": "31040276",
                    "uid": "cc55ce85-0c61-484f-a436-f17c2bc78882"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-08-01T10:25:31Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "ai-chat",
                        "name": "ai-chat"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {},
                                        "f:name": {}
                                    }
                                }
                            },
                            "manager": "adp",
                            "operation": "Update",
                            "time": "2025-08-01T10:25:31Z"
                        }
                    ],
                    "name": "ai-chat",
                    "resourceVersion": "31080916",
                    "uid": "7d47524d-5d51-495f-9d9c-780b54f0ea3d"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-07-04T08:25:47Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "aiinfra"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-07-04T08:25:47Z"
                        }
                    ],
                    "name": "aiinfra",
                    "resourceVersion": "13144221",
                    "uid": "38a0285b-b5f2-4930-8b11-e190e0728647"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:25:28Z",
                    "labels": {
                        "environment": "system",
                        "kubernetes.io/metadata.name": "cert-manager"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubectl-create",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        "f:environment": {}
                                    }
                                }
                            },
                            "manager": "kubectl-label",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        }
                    ],
                    "name": "cert-manager",
                    "resourceVersion": "921",
                    "uid": "e55fd3d8-3da8-48c4-8cca-4de632ee4337"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-07-01T05:52:03Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "cmdb"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-07-01T05:52:03Z"
                        }
                    ],
                    "name": "cmdb",
                    "resourceVersion": "11302978",
                    "uid": "baa7bd40-e0fc-466d-abb5-35de19cfe3cd"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:23:18Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "default"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kube-apiserver",
                            "operation": "Update",
                            "time": "2025-06-09T07:23:18Z"
                        }
                    ],
                    "name": "default",
                    "resourceVersion": "190",
                    "uid": "dd54e539-cb17-41ea-81da-014e988e586e"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "annotations": {
                        "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Namespace\",\"metadata\":{\"annotations\":{},\"name\":\"dify\"}}\n"
                    },
                    "creationTimestamp": "2025-06-26T09:07:55Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "dify"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:kubectl.kubernetes.io/last-applied-configuration": {}
                                    },
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubectl-client-side-apply",
                            "operation": "Update",
                            "time": "2025-06-26T09:07:55Z"
                        }
                    ],
                    "name": "dify",
                    "resourceVersion": "8588468",
                    "uid": "da6d2a59-c794-482f-a308-f767ae6d200a"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-08-01T08:58:15Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "fuse-iam",
                        "name": "fuse-iam"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {},
                                        "f:name": {}
                                    }
                                }
                            },
                            "manager": "adp",
                            "operation": "Update",
                            "time": "2025-08-01T08:58:15Z"
                        }
                    ],
                    "name": "fuse-iam",
                    "resourceVersion": "31040261",
                    "uid": "52d74697-8dc7-4403-bbe2-c93b3f6f55cb"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "annotations": {
                        "meta.helm.sh/release-name": "karpor-dev",
                        "meta.helm.sh/release-namespace": "default"
                    },
                    "creationTimestamp": "2025-07-03T10:08:13Z",
                    "labels": {
                        "app.bingokube.io/release": "karpor-dev-default",
                        "app.kubernetes.io/managed-by": "Helm",
                        "kubernetes.io/metadata.name": "karpor"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
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
                                        "f:app.bingokube.io/release": {},
                                        "f:app.kubernetes.io/managed-by": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "helm",
                            "operation": "Update",
                            "time": "2025-07-03T10:08:13Z"
                        }
                    ],
                    "name": "karpor",
                    "resourceVersion": "12592993",
                    "uid": "9ae99fa1-a3de-4659-8504-68540d571db9"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:23:17Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "kube-node-lease"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kube-apiserver",
                            "operation": "Update",
                            "time": "2025-06-09T07:23:17Z"
                        }
                    ],
                    "name": "kube-node-lease",
                    "resourceVersion": "11",
                    "uid": "a05d8585-105a-4533-bbcd-237eb79a931b"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:23:17Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "kube-public"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kube-apiserver",
                            "operation": "Update",
                            "time": "2025-06-09T07:23:17Z"
                        }
                    ],
                    "name": "kube-public",
                    "resourceVersion": "9",
                    "uid": "9be70d3f-63f5-4f0d-a8c3-76e1dfc1cd70"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:23:17Z",
                    "labels": {
                        "environment": "system",
                        "kubernetes.io/metadata.name": "kube-system"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kube-apiserver",
                            "operation": "Update",
                            "time": "2025-06-09T07:23:17Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        "f:environment": {}
                                    }
                                }
                            },
                            "manager": "kubectl-label",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        }
                    ],
                    "name": "kube-system",
                    "resourceVersion": "915",
                    "uid": "846a34d1-6989-428f-9978-90782af9d421"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "annotations": {
                        "cluster.kubesphere.io/host-cluster": "host",
                        "cluster.kubesphere.io/name": "host"
                    },
                    "creationTimestamp": "2025-07-14T10:01:18Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "kubesphere-system",
                        "name": "kubesphere-system"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {},
                                        "f:name": {}
                                    }
                                }
                            },
                            "manager": "helm",
                            "operation": "Update",
                            "time": "2025-07-14T10:01:18Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:cluster.kubesphere.io/host-cluster": {},
                                        "f:cluster.kubesphere.io/name": {}
                                    }
                                }
                            },
                            "manager": "Go-http-client",
                            "operation": "Update",
                            "time": "2025-07-14T10:16:13Z"
                        }
                    ],
                    "name": "kubesphere-system",
                    "resourceVersion": "19106073",
                    "uid": "1b792ecf-646d-4c72-8be4-e0fe656fb497"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:25:28Z",
                    "labels": {
                        "environment": "system",
                        "kubernetes.io/metadata.name": "loki"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubectl-create",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        "f:environment": {}
                                    }
                                }
                            },
                            "manager": "kubectl-label",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        }
                    ],
                    "name": "loki",
                    "resourceVersion": "918",
                    "uid": "87639d39-e6a6-4790-ad21-5564989cb523"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-09-18T02:59:38Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "mcp-server"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-09-18T02:59:38Z"
                        }
                    ],
                    "name": "mcp-server",
                    "resourceVersion": "58477717",
                    "uid": "b1e95313-b438-462e-851b-ea1883c9212b"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-08-06T07:25:43Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "model"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-08-06T07:25:43Z"
                        }
                    ],
                    "name": "model",
                    "resourceVersion": "34305013",
                    "uid": "bb468e8c-e9cc-4f09-97c8-ecdbb9bb587b"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-09T07:25:28Z",
                    "labels": {
                        "environment": "system",
                        "kubernetes.io/metadata.name": "monitoring"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubectl-create",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        "f:environment": {}
                                    }
                                }
                            },
                            "manager": "kubectl-label",
                            "operation": "Update",
                            "time": "2025-06-09T07:25:28Z"
                        }
                    ],
                    "name": "monitoring",
                    "resourceVersion": "922",
                    "uid": "7aeb40c7-b287-41e9-95d8-e36271b1ca48"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-30T10:42:14Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "mysql"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-06-30T10:42:14Z"
                        }
                    ],
                    "name": "mysql",
                    "resourceVersion": "10830751",
                    "uid": "e994b01d-7292-4e00-8cc2-57ec1195cefe"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-09-15T04:15:09Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "n9n",
                        "name": "n9n"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {},
                                        "f:name": {}
                                    }
                                }
                            },
                            "manager": "helm",
                            "operation": "Update",
                            "time": "2025-09-15T04:15:09Z"
                        }
                    ],
                    "name": "n9n",
                    "resourceVersion": "56517909",
                    "uid": "98400c12-0a2a-4229-a3e1-c4f3d726ee84"
                },
                "spec": {
                    "finalizers": [
                        "kubernetes"
                    ]
                },
                "status": {
                    "phase": "Active"
                }
            },
            {
                "apiVersion": "v1",
                "kind": "Namespace",
                "metadata": {
                    "creationTimestamp": "2025-06-23T08:34:00Z",
                    "labels": {
                        "kubernetes.io/metadata.name": "ragflow"
                    },
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:kubernetes.io/metadata.name": {}
                                    }
                                }
                            },
                            "manager": "kubeverse",
                            "operation": "Update",
                            "time": "2025-06-23T08:34:00Z"
                        }
                    ],
                    "name": "ragflow",
                    "resourceVersion": "6924942",
                    "uid": "717edf92-c6a5-41d7-aaa0-7d981446e1a2"
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
        ],
        "kind": "",
        "metadata": {
            "resourceVersion": "58503522"
        }
    }
}
```

详情：
/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/namespaces?isGetResource=1&page=1&pageSize=10&keyword=&orderBy=creationTimestamp&ascending=false
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "mcp-server",
                        "namespace": "mcp-server",
                        "uid": "8b4aabe1-64d6-4d80-9f78-0c427680a4a7",
                        "resourceVersion": "58481176",
                        "generation": 11,
                        "creationTimestamp": "2025-09-18T02:59:38Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "mcp-server"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-09-18T03:04:07Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            },
                                            "f:storageClasses": {}
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "2",
                                    "requestMem": "2Gi"
                                }
                            ],
                            "storageClasses": [
                                {
                                    "name": "hps-nfs",
                                    "size": "50Gi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 1,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 1,
                                "Job": 0,
                                "LBService": 0,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 1,
                                "Pod": 1,
                                "Secret": 1,
                                "Service": 0,
                                "StatefulSet": 0
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "mcp-server",
                        "uid": "b1e95313-b438-462e-851b-ea1883c9212b",
                        "resourceVersion": "58477717",
                        "creationTimestamp": "2025-09-18T02:59:38Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "mcp-server"
                        },
                        "managedFields": [
                            {
                                "manager": "kubeverse",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-18T02:59:38Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "n9n",
                        "namespace": "n9n",
                        "uid": "e1031315-71f5-4c14-84fb-a89cc61ebda2",
                        "resourceVersion": "57992784",
                        "generation": 83,
                        "creationTimestamp": "2025-09-15T04:15:09Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "n9n"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-09-15T06:05:19Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            },
                                            "f:storageClasses": {}
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "28",
                                    "requestMem": "56Gi"
                                }
                            ],
                            "storageClasses": [
                                {
                                    "name": "sp-00c6452111",
                                    "size": "9Gi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 21,
                                "CronJob": 0,
                                "DaemonSet": 1,
                                "Deployment": 1,
                                "Job": 0,
                                "LBService": 2,
                                "NodePortService": 1,
                                "PersistentVolumeClaim": 3,
                                "Pod": 7,
                                "Secret": 4,
                                "Service": 7,
                                "StatefulSet": 3
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "n9n",
                        "uid": "98400c12-0a2a-4229-a3e1-c4f3d726ee84",
                        "resourceVersion": "56517909",
                        "creationTimestamp": "2025-09-15T04:15:09Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "n9n",
                            "name": "n9n"
                        },
                        "managedFields": [
                            {
                                "manager": "helm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T04:15:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {},
                                            "f:name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "model",
                        "namespace": "model",
                        "uid": "0e178eb4-b343-4206-a502-7e2fb1018551",
                        "resourceVersion": "34857887",
                        "generation": 66,
                        "creationTimestamp": "2025-08-06T07:25:43Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "model"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-08-06T09:43:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "49",
                                    "requestMem": "13Gi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 2,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 2,
                                "Job": 0,
                                "LBService": 0,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 0,
                                "Pod": 2,
                                "Secret": 1,
                                "Service": 1,
                                "StatefulSet": 0
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "model",
                        "uid": "bb468e8c-e9cc-4f09-97c8-ecdbb9bb587b",
                        "resourceVersion": "34305013",
                        "creationTimestamp": "2025-08-06T07:25:43Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "model"
                        },
                        "managedFields": [
                            {
                                "manager": "kubeverse",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-06T07:25:43Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "ai-chat",
                        "namespace": "ai-chat",
                        "uid": "958d3400-56c3-4720-81d1-32a33e319892",
                        "resourceVersion": "34356110",
                        "generation": 14,
                        "creationTimestamp": "2025-08-01T10:25:31Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "ai-chat"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-08-01T10:25:34Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "0",
                                    "requestMem": "0"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 2,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 2,
                                "Job": 0,
                                "LBService": 0,
                                "NodePortService": 2,
                                "PersistentVolumeClaim": 0,
                                "Pod": 3,
                                "Secret": 2,
                                "Service": 2,
                                "StatefulSet": 1
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "ai-chat",
                        "uid": "7d47524d-5d51-495f-9d9c-780b54f0ea3d",
                        "resourceVersion": "31080916",
                        "creationTimestamp": "2025-08-01T10:25:31Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "ai-chat",
                            "name": "ai-chat"
                        },
                        "managedFields": [
                            {
                                "manager": "adp",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-01T10:25:31Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {},
                                            "f:name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "adp-system",
                        "namespace": "adp-system",
                        "uid": "1b66216f-2d00-42b2-ac67-033c5f86a882",
                        "resourceVersion": "31040294",
                        "generation": 2,
                        "creationTimestamp": "2025-08-01T08:58:16Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "adp-system"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-08-01T08:58:17Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "resourceCount": {
                                "ConfigMap": 2,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 0,
                                "Job": 0,
                                "LBService": 0,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 0,
                                "Pod": 0,
                                "Secret": 1,
                                "Service": 0,
                                "StatefulSet": 0
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "adp-system",
                        "uid": "cc55ce85-0c61-484f-a436-f17c2bc78882",
                        "resourceVersion": "31040276",
                        "creationTimestamp": "2025-08-01T08:58:16Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "adp-system"
                        },
                        "managedFields": [
                            {
                                "manager": "adp",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-01T08:58:16Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "fuse-iam",
                        "namespace": "fuse-iam",
                        "uid": "ff3867f5-2602-4a8c-9a64-490dfbd59c55",
                        "resourceVersion": "56670792",
                        "generation": 14,
                        "creationTimestamp": "2025-08-01T08:58:16Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "fuse-iam"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-08-01T09:28:28Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "0",
                                    "requestMem": "0"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 3,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 5,
                                "Job": 0,
                                "LBService": 1,
                                "NodePortService": 7,
                                "PersistentVolumeClaim": 0,
                                "Pod": 9,
                                "Secret": 2,
                                "Service": 8,
                                "StatefulSet": 2
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "fuse-iam",
                        "uid": "52d74697-8dc7-4403-bbe2-c93b3f6f55cb",
                        "resourceVersion": "31040261",
                        "creationTimestamp": "2025-08-01T08:58:15Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "fuse-iam",
                            "name": "fuse-iam"
                        },
                        "managedFields": [
                            {
                                "manager": "adp",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-01T08:58:15Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {},
                                            "f:name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "kubesphere-system",
                        "namespace": "kubesphere-system",
                        "uid": "9fd0d3f2-4b5c-4bd5-a2d6-f069f4f02356",
                        "resourceVersion": "57315511",
                        "generation": 656,
                        "creationTimestamp": "2025-07-14T10:01:18Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "kubesphere-system"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-07-14T10:01:21Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "90m",
                                    "requestMem": "350Mi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 4,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 4,
                                "Job": 0,
                                "LBService": 0,
                                "NodePortService": 2,
                                "PersistentVolumeClaim": 0,
                                "Pod": 6,
                                "Secret": 12,
                                "Service": 5,
                                "StatefulSet": 0
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "kubesphere-system",
                        "uid": "1b792ecf-646d-4c72-8be4-e0fe656fb497",
                        "resourceVersion": "19106073",
                        "creationTimestamp": "2025-07-14T10:01:18Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "kubesphere-system",
                            "name": "kubesphere-system"
                        },
                        "annotations": {
                            "cluster.kubesphere.io/host-cluster": "host",
                            "cluster.kubesphere.io/name": "host"
                        },
                        "managedFields": [
                            {
                                "manager": "helm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-07-14T10:01:18Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {},
                                            "f:name": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "Go-http-client",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-07-14T10:16:13Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:cluster.kubesphere.io/host-cluster": {},
                                            "f:cluster.kubesphere.io/name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "aiinfra",
                        "namespace": "aiinfra",
                        "uid": "50e3073d-7240-4e2a-85f8-b6d7cde7b5e2",
                        "resourceVersion": "52602846",
                        "generation": 9,
                        "creationTimestamp": "2025-07-04T08:25:47Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "aiinfra"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-07-07T08:49:48Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            }
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "1100m",
                                    "requestMem": "1088Mi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 1,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 2,
                                "Job": 0,
                                "LBService": 1,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 0,
                                "Pod": 2,
                                "Secret": 1,
                                "Service": 1,
                                "StatefulSet": 0
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "aiinfra",
                        "uid": "38a0285b-b5f2-4930-8b11-e190e0728647",
                        "resourceVersion": "13144221",
                        "creationTimestamp": "2025-07-04T08:25:47Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "aiinfra"
                        },
                        "managedFields": [
                            {
                                "manager": "kubeverse",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-07-04T08:25:47Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "karpor",
                        "namespace": "karpor",
                        "uid": "97bcd3e9-7798-4209-b90a-e4f529e2b8da",
                        "resourceVersion": "12633059",
                        "generation": 52,
                        "creationTimestamp": "2025-07-03T10:08:13Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "karpor"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-07-03T10:08:16Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            },
                                            "f:storageClasses": {}
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "2750m",
                                    "requestMem": "4864Mi"
                                }
                            ],
                            "storageClasses": [
                                {
                                    "name": "sp-00c6452111",
                                    "size": "15Gi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 2,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 3,
                                "Job": 0,
                                "LBService": 1,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 2,
                                "Pod": 4,
                                "Secret": 2,
                                "Service": 4,
                                "StatefulSet": 1
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "karpor",
                        "uid": "9ae99fa1-a3de-4659-8504-68540d571db9",
                        "resourceVersion": "12592993",
                        "creationTimestamp": "2025-07-03T10:08:13Z",
                        "labels": {
                            "app.bingokube.io/release": "karpor-dev-default",
                            "app.kubernetes.io/managed-by": "Helm",
                            "kubernetes.io/metadata.name": "karpor"
                        },
                        "annotations": {
                            "meta.helm.sh/release-name": "karpor-dev",
                            "meta.helm.sh/release-namespace": "default"
                        },
                        "managedFields": [
                            {
                                "manager": "helm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-07-03T10:08:13Z",
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
                                            "f:app.bingokube.io/release": {},
                                            "f:app.kubernetes.io/managed-by": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            },
            {
                "alarmIndicator": {
                    "monitorIndex": 0,
                    "logEvent": 0
                },
                "namespaceQuota": {
                    "kind": "NamespaceResourceQuota",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "cmdb",
                        "namespace": "cmdb",
                        "uid": "f92d3979-87ee-4c8d-af7d-3255337e15e0",
                        "resourceVersion": "58054953",
                        "generation": 1357,
                        "creationTimestamp": "2025-07-01T05:52:03Z",
                        "labels": {
                            "bingokube.bingosoft.net/namespace": "cmdb"
                        },
                        "managedFields": [
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-07-01T05:59:48Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:spec": {
                                        ".": {},
                                        "f:hard": {}
                                    },
                                    "f:status": {
                                        ".": {},
                                        "f:hard": {},
                                        "f:temporary": {},
                                        "f:used": {
                                            ".": {},
                                            "f:pools": {},
                                            "f:resourceCount": {
                                                ".": {},
                                                "f:ConfigMap": {},
                                                "f:CronJob": {},
                                                "f:DaemonSet": {},
                                                "f:Deployment": {},
                                                "f:Job": {},
                                                "f:LBService": {},
                                                "f:NodePortService": {},
                                                "f:PersistentVolumeClaim": {},
                                                "f:Pod": {},
                                                "f:Secret": {},
                                                "f:Service": {},
                                                "f:StatefulSet": {}
                                            },
                                            "f:storageClasses": {}
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "hard": {}
                    },
                    "status": {
                        "hard": {},
                        "used": {
                            "pools": [
                                {
                                    "name": "master-pool",
                                    "priority": 1,
                                    "requestCpu": "9",
                                    "requestMem": "9Gi"
                                }
                            ],
                            "storageClasses": [
                                {
                                    "name": "hps-nfs",
                                    "size": "6Gi"
                                },
                                {
                                    "name": "sp-00c6452111",
                                    "size": "5Gi"
                                }
                            ],
                            "resourceCount": {
                                "ConfigMap": 2,
                                "CronJob": 0,
                                "DaemonSet": 0,
                                "Deployment": 2,
                                "Job": 0,
                                "LBService": 3,
                                "NodePortService": 0,
                                "PersistentVolumeClaim": 3,
                                "Pod": 4,
                                "Secret": 1,
                                "Service": 3,
                                "StatefulSet": 1
                            }
                        },
                        "temporary": {}
                    }
                },
                "namespace": {
                    "metadata": {
                        "name": "cmdb",
                        "uid": "baa7bd40-e0fc-466d-abb5-35de19cfe3cd",
                        "resourceVersion": "11302978",
                        "creationTimestamp": "2025-07-01T05:52:03Z",
                        "labels": {
                            "kubernetes.io/metadata.name": "cmdb"
                        },
                        "managedFields": [
                            {
                                "manager": "kubeverse",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-07-01T05:52:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:kubernetes.io/metadata.name": {}
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
            }
        ],
        "count": 20
    }
}
```



/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/namespace/mcp-server
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "alarmIndicator": {
            "monitorIndex": 0,
            "logEvent": 0
        },
        "namespaceQuota": {
            "kind": "NamespaceResourceQuota",
            "apiVersion": "bingokube.bingosoft.net/v1",
            "metadata": {
                "name": "mcp-server",
                "namespace": "mcp-server",
                "uid": "8b4aabe1-64d6-4d80-9f78-0c427680a4a7",
                "resourceVersion": "58481176",
                "generation": 11,
                "creationTimestamp": "2025-09-18T02:59:38Z",
                "labels": {
                    "bingokube.bingosoft.net/namespace": "mcp-server"
                },
                "managedFields": [
                    {
                        "manager": "kubedupont-controller",
                        "operation": "Update",
                        "apiVersion": "bingokube.bingosoft.net/v1",
                        "time": "2025-09-18T03:04:07Z",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:spec": {
                                ".": {},
                                "f:hard": {}
                            },
                            "f:status": {
                                ".": {},
                                "f:hard": {},
                                "f:temporary": {},
                                "f:used": {
                                    ".": {},
                                    "f:pools": {},
                                    "f:resourceCount": {
                                        ".": {},
                                        "f:ConfigMap": {},
                                        "f:CronJob": {},
                                        "f:DaemonSet": {},
                                        "f:Deployment": {},
                                        "f:Job": {},
                                        "f:LBService": {},
                                        "f:NodePortService": {},
                                        "f:PersistentVolumeClaim": {},
                                        "f:Pod": {},
                                        "f:Secret": {},
                                        "f:Service": {},
                                        "f:StatefulSet": {}
                                    },
                                    "f:storageClasses": {}
                                }
                            }
                        }
                    }
                ]
            },
            "spec": {
                "hard": {}
            },
            "status": {
                "hard": {},
                "used": {
                    "pools": [
                        {
                            "name": "master-pool",
                            "priority": 1,
                            "requestCpu": "2",
                            "requestMem": "2Gi"
                        }
                    ],
                    "storageClasses": [
                        {
                            "name": "hps-nfs",
                            "size": "50Gi"
                        }
                    ],
                    "resourceCount": {
                        "ConfigMap": 1,
                        "CronJob": 0,
                        "DaemonSet": 0,
                        "Deployment": 1,
                        "Job": 0,
                        "LBService": 0,
                        "NodePortService": 0,
                        "PersistentVolumeClaim": 1,
                        "Pod": 1,
                        "Secret": 1,
                        "Service": 0,
                        "StatefulSet": 0
                    }
                },
                "temporary": {}
            }
        },
        "namespace": {
            "kind": "Namespace",
            "apiVersion": "v1",
            "metadata": {
                "name": "mcp-server",
                "uid": "b1e95313-b438-462e-851b-ea1883c9212b",
                "resourceVersion": "58477717",
                "creationTimestamp": "2025-09-18T02:59:38Z",
                "labels": {
                    "kubernetes.io/metadata.name": "mcp-server"
                },
                "managedFields": [
                    {
                        "manager": "kubeverse",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-09-18T02:59:38Z",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:labels": {
                                    ".": {},
                                    "f:kubernetes.io/metadata.name": {}
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
    }
}
```



/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/baseResourceList?group=bingokube.bingosoft.net&version=v1&kind=ResourcePool
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "apiVersion": "",
        "items": [
            {
                "apiVersion": "bingokube.bingosoft.net/v1",
                "kind": "ResourcePool",
                "metadata": {
                    "annotations": {
                        "meta.helm.sh/release-name": "kubedupont",
                        "meta.helm.sh/release-namespace": "kube-system"
                    },
                    "creationTimestamp": "2025-06-09T07:28:43Z",
                    "generation": 5650,
                    "labels": {
                        "app.bingokube.io/release": "kubedupont-kube-system",
                        "app.kubernetes.io/managed-by": "Helm",
                        "bingokube.bingosoft.net/pool": "master-pool",
                        "bingokube.bingosoft.net/tenant": ""
                    },
                    "managedFields": [
                        {
                            "apiVersion": "bingokube.bingosoft.net/v1",
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
                                        "f:app.bingokube.io/release": {},
                                        "f:app.kubernetes.io/managed-by": {}
                                    }
                                },
                                "f:spec": {
                                    ".": {},
                                    "f:description": {},
                                    "f:isShare": {},
                                    "f:poolName": {},
                                    "f:priority": {}
                                }
                            },
                            "manager": "helm",
                            "operation": "Update",
                            "time": "2025-06-09T07:28:43Z"
                        },
                        {
                            "apiVersion": "bingokube.bingosoft.net/v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:labels": {
                                        "f:bingokube.bingosoft.net/pool": {},
                                        "f:bingokube.bingosoft.net/tenant": {}
                                    }
                                },
                                "f:spec": {
                                    "f:nodes": {}
                                },
                                "f:status": {
                                    ".": {},
                                    "f:allocatableUsed": {
                                        ".": {},
                                        "f:requestCpu": {},
                                        "f:requestMem": {}
                                    },
                                    "f:hard": {
                                        ".": {},
                                        "f:otherResource": {
                                            ".": {},
                                            "f:huawei.com/npu": {},
                                            "f:nvidia.com/gpu": {}
                                        },
                                        "f:requestCpu": {},
                                        "f:requestMem": {}
                                    },
                                    "f:used": {
                                        ".": {},
                                        "f:otherResource": {
                                            ".": {},
                                            "f:huawei.com/npu": {},
                                            "f:nvidia.com/gpu": {}
                                        },
                                        "f:requestCpu": {},
                                        "f:requestMem": {}
                                    }
                                }
                            },
                            "manager": "kubedupont-controller",
                            "operation": "Update",
                            "time": "2025-06-09T07:28:50Z"
                        }
                    ],
                    "name": "master-pool",
                    "resourceVersion": "58481241",
                    "uid": "ec99a5f0-44aa-4e75-bbb1-02ac4e38d6ac"
                },
                "spec": {
                    "description": "the master in the cluster,Cannot delete.",
                    "isShare": true,
                    "nodes": [
                        {
                            "arch": "amd64",
                            "name": "10.203.52.103"
                        },
                        {
                            "arch": "amd64",
                            "name": "10.203.52.101"
                        },
                        {
                            "arch": "amd64",
                            "name": "10.203.52.102"
                        }
                    ],
                    "poolName": "master资源池",
                    "priority": 5
                },
                "status": {
                    "allocatableUsed": {
                        "requestCpu": "0",
                        "requestMem": "0"
                    },
                    "hard": {
                        "otherResource": {
                            "huawei.com/npu": "0",
                            "nvidia.com/gpu": "0"
                        },
                        "requestCpu": "470625m",
                        "requestMem": "341248896Ki"
                    },
                    "used": {
                        "otherResource": {
                            "huawei.com/npu": "0",
                            "nvidia.com/gpu": "0"
                        },
                        "requestCpu": "132180m",
                        "requestMem": "140078345093120m"
                    }
                }
            }
        ],
        "kind": "",
        "metadata": {
            "continue": "",
            "resourceVersion": "58510245"
        }
    }
}
```