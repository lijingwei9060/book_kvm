/api/v1/applications/myapp?appNamespace=argocd

```json
{
    "metadata": {
        "name": "myapp",
        "namespace": "argocd",
        "uid": "c93acd62-4305-42fc-bfe3-593e8478d8f2",
        "resourceVersion": "3924540",
        "generation": 9921,
        "creationTimestamp": "2025-08-13T07:49:04Z",
        "managedFields": [
            {
                "manager": "argocd-server",
                "operation": "Update",
                "apiVersion": "argoproj.io/v1alpha1",
                "time": "2025-09-04T02:13:28Z",
                "fieldsType": "FieldsV1",
                "fieldsV1": {
                    "f:spec": {
                        ".": {},
                        "f:destination": {
                            ".": {},
                            "f:namespace": {},
                            "f:server": {}
                        },
                        "f:project": {},
                        "f:source": {
                            ".": {},
                            "f:path": {},
                            "f:repoURL": {},
                            "f:targetRevision": {}
                        }
                    },
                    "f:status": {
                        ".": {},
                        "f:health": {},
                        "f:sourceHydrator": {},
                        "f:summary": {},
                        "f:sync": {
                            ".": {},
                            "f:comparedTo": {
                                ".": {},
                                "f:destination": {},
                                "f:source": {}
                            }
                        }
                    }
                }
            },
            {
                "manager": "argocd-application-controller",
                "operation": "Update",
                "apiVersion": "argoproj.io/v1alpha1",
                "time": "2025-09-04T02:16:46Z",
                "fieldsType": "FieldsV1",
                "fieldsV1": {
                    "f:status": {
                        "f:controllerNamespace": {},
                        "f:health": {
                            "f:lastTransitionTime": {},
                            "f:status": {}
                        },
                        "f:history": {},
                        "f:operationState": {
                            ".": {},
                            "f:finishedAt": {},
                            "f:message": {},
                            "f:operation": {
                                ".": {},
                                "f:initiatedBy": {
                                    ".": {},
                                    "f:username": {}
                                },
                                "f:retry": {},
                                "f:sync": {
                                    ".": {},
                                    "f:revision": {},
                                    "f:syncStrategy": {
                                        ".": {},
                                        "f:hook": {}
                                    }
                                }
                            },
                            "f:phase": {},
                            "f:startedAt": {},
                            "f:syncResult": {
                                ".": {},
                                "f:resources": {},
                                "f:revision": {},
                                "f:source": {
                                    ".": {},
                                    "f:path": {},
                                    "f:repoURL": {},
                                    "f:targetRevision": {}
                                }
                            }
                        },
                        "f:reconciledAt": {},
                        "f:resourceHealthSource": {},
                        "f:resources": {},
                        "f:sourceType": {},
                        "f:summary": {
                            "f:images": {}
                        },
                        "f:sync": {
                            "f:comparedTo": {
                                "f:destination": {
                                    "f:namespace": {},
                                    "f:server": {}
                                },
                                "f:source": {
                                    "f:path": {},
                                    "f:repoURL": {},
                                    "f:targetRevision": {}
                                }
                            },
                            "f:revision": {},
                            "f:status": {}
                        }
                    }
                }
            }
        ]
    },
    "spec": {
        "source": {
            "repoURL": "https://gitee.com/finley/argocd-demo.git",
            "path": "demo",
            "targetRevision": "HEAD"
        },
        "destination": {
            "server": "https://kubernetes.default.svc",
            "namespace": "devops"
        },
        "project": "default"
    },
    "status": {
        "resources": [
            {
                "version": "v1",
                "kind": "Service",
                "namespace": "devops",
                "name": "myapp",
                "status": "Synced",
                "health": {
                    "status": "Healthy"
                }
            },
            {
                "group": "apps",
                "version": "v1",
                "kind": "Deployment",
                "namespace": "devops",
                "name": "myapp",
                "status": "Synced",
                "health": {
                    "status": "Healthy"
                }
            }
        ],
        "sync": {
            "status": "Synced",
            "comparedTo": {
                "source": {
                    "repoURL": "https://gitee.com/finley/argocd-demo.git",
                    "path": "demo",
                    "targetRevision": "HEAD"
                },
                "destination": {
                    "server": "https://kubernetes.default.svc",
                    "namespace": "devops"
                }
            },
            "revision": "39313e1c4af397986a5e1bbb53bde6fef15d6a50"
        },
        "health": {
            "status": "Healthy",
            "lastTransitionTime": "2025-08-13T07:55:07Z"
        },
        "history": [
            {
                "revision": "39313e1c4af397986a5e1bbb53bde6fef15d6a50",
                "deployedAt": "2025-08-13T07:52:14Z",
                "id": 0,
                "source": {
                    "repoURL": "https://gitee.com/finley/argocd-demo.git",
                    "path": "demo",
                    "targetRevision": "HEAD"
                },
                "deployStartedAt": "2025-08-13T07:52:13Z",
                "initiatedBy": {
                    "username": "admin"
                }
            }
        ],
        "reconciledAt": "2025-09-04T02:16:46Z",
        "operationState": {
            "operation": {
                "sync": {
                    "revision": "39313e1c4af397986a5e1bbb53bde6fef15d6a50",
                    "syncStrategy": {
                        "hook": {}
                    }
                },
                "initiatedBy": {
                    "username": "admin"
                },
                "retry": {}
            },
            "phase": "Succeeded",
            "message": "successfully synced (all tasks run)",
            "syncResult": {
                "resources": [
                    {
                        "group": "",
                        "version": "v1",
                        "kind": "Service",
                        "namespace": "devops",
                        "name": "myapp",
                        "status": "Synced",
                        "message": "service/myapp created",
                        "hookPhase": "Running",
                        "syncPhase": "Sync"
                    },
                    {
                        "group": "apps",
                        "version": "v1",
                        "kind": "Deployment",
                        "namespace": "devops",
                        "name": "myapp",
                        "status": "Synced",
                        "message": "deployment.apps/myapp created",
                        "hookPhase": "Running",
                        "syncPhase": "Sync"
                    }
                ],
                "revision": "39313e1c4af397986a5e1bbb53bde6fef15d6a50",
                "source": {
                    "repoURL": "https://gitee.com/finley/argocd-demo.git",
                    "path": "demo",
                    "targetRevision": "HEAD"
                }
            },
            "startedAt": "2025-08-13T07:52:13Z",
            "finishedAt": "2025-08-13T07:52:14Z"
        },
        "sourceType": "Directory",
        "summary": {
            "images": [
                "registry.cn-shanghai.aliyuncs.com/public-namespace/myapp:v2"
            ]
        },
        "resourceHealthSource": "appTree",
        "controllerNamespace": "argocd",
        "sourceHydrator": {}
    }
}
```