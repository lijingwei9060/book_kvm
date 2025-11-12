
列表

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/resourcePools?page=1&pageSize=10&orderBy=creationTimestamp&ascending=false
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "workspacesNum": 0,
                "nodeNumInfo": {
                    "sum": 3,
                    "ready": 3,
                    "unhealthy": 0,
                    "notReady": 0
                },
                "resourcePool": {
                    "kind": "ResourcePool",
                    "apiVersion": "bingokube.bingosoft.net/v1",
                    "metadata": {
                        "name": "master-pool",
                        "uid": "ec99a5f0-44aa-4e75-bbb1-02ac4e38d6ac",
                        "resourceVersion": "58481241",
                        "generation": 5650,
                        "creationTimestamp": "2025-06-09T07:28:43Z",
                        "labels": {
                            "app.bingokube.io/release": "kubedupont-kube-system",
                            "app.kubernetes.io/managed-by": "Helm",
                            "bingokube.bingosoft.net/pool": "master-pool",
                            "bingokube.bingosoft.net/tenant": ""
                        },
                        "annotations": {
                            "meta.helm.sh/release-name": "kubedupont",
                            "meta.helm.sh/release-namespace": "kube-system"
                        },
                        "managedFields": [
                            {
                                "manager": "helm",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-06-09T07:28:43Z",
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
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "bingokube.bingosoft.net/v1",
                                "time": "2025-06-09T07:28:50Z",
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
                                }
                            }
                        ]
                    },
                    "spec": {
                        "isShare": true,
                        "poolName": "master资源池",
                        "description": "the master in the cluster,Cannot delete.",
                        "priority": 5,
                        "nodes": [
                            {
                                "name": "10.203.52.103",
                                "arch": "amd64"
                            },
                            {
                                "name": "10.203.52.101",
                                "arch": "amd64"
                            },
                            {
                                "name": "10.203.52.102",
                                "arch": "amd64"
                            }
                        ]
                    },
                    "status": {
                        "hard": {
                            "requestCpu": "470625m",
                            "requestMem": "341248896Ki",
                            "otherResource": {
                                "huawei.com/npu": "0",
                                "nvidia.com/gpu": "0"
                            }
                        },
                        "used": {
                            "requestCpu": "132180m",
                            "requestMem": "140078345093120m",
                            "otherResource": {
                                "huawei.com/npu": "0",
                                "nvidia.com/gpu": "0"
                            }
                        },
                        "allocatableUsed": {
                            "requestCpu": "0",
                            "requestMem": "0"
                        }
                    }
                }
            }
        ],
        "count": 1
    }
}
```

资源池节点(重复)

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/nodes?page=1&pageSize=10&orderBy=creationTimestamp&ascending=false&labels=bingokube.bingosoft.net%2Fpool%3Dmaster-pool&isGetResource=1


资源池资源：
/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/resourcePool/resource/master-pool
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "name": "master-pool",
        "resourcePoolCapacity": {
            "cpu": 470.625,
            "usageCPU": 24.96,
            "memory": 325.4403076171875,
            "usageMemory": 231.16256713867188
        }
    }
}
```