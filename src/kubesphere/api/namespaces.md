// 用户空间
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/namespaces?sortBy=createTime&limit=10&page=1&labelSelector=kubesphere.io%2Fworkspace!%3Dsystem-workspace

```json
{
 "items": [
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "local-path-storage",
    "uid": "c12d6723-7d7d-4ec6-b6e1-c0ceb3f75611",
    "resourceVersion": "2196",
    "creationTimestamp": "2024-07-08T02:04:08Z",
    "labels": {
     "kubernetes.io/metadata.name": "local-path-storage"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Namespace\",\"metadata\":{\"annotations\":{},\"name\":\"local-path-storage\"}}\n"
    },
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:08Z",
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
 ],
 "totalItems": 2
}
```

// 系统空间

https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/namespaces?sortBy=createTime&limit=10&page=1&labelSelector=kubesphere.io%2Fworkspace%3Dsystem-workspace

```json
{
 "items": [
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "kubesphere-controls-system",
    "uid": "551d65a4-fc52-415a-a498-4d642c0cb8b7",
    "resourceVersion": "2611",
    "creationTimestamp": "2024-07-09T07:02:03Z",
    "labels": {
     "kubernetes.io/metadata.name": "kubesphere-controls-system",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Namespace\",\"metadata\":{\"annotations\":{},\"creationTimestamp\":null,\"name\":\"kubesphere-controls-system\"},\"spec\":{},\"status\":{}}\n"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:03Z",
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
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "kubesphere-system",
    "uid": "d41241b7-e719-4ed1-a55a-33bf89f770c1",
    "resourceVersion": "2604",
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "kubernetes.io/metadata.name": "kubesphere-system",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace",
     "name": "kubesphere-system"
    },
    "annotations": {
     "cluster.kubesphere.io/host-cluster": "host",
     "cluster.kubesphere.io/name": "host"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:00:31Z",
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
      "time": "2024-07-09T07:01:11Z",
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
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "uid": "3294191d-bd9f-48cb-a676-72647f10ebd2",
    "resourceVersion": "2617",
    "creationTimestamp": "2024-07-08T02:04:05Z",
    "labels": {
     "kubernetes.io/metadata.name": "default",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:05Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         ".": {},
         "f:kubernetes.io/metadata.name": {}
        }
       }
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-system",
    "uid": "23e828d8-3f16-415a-91ca-5f9fdb26a01d",
    "resourceVersion": "2637",
    "creationTimestamp": "2024-07-08T02:04:04Z",
    "labels": {
     "kubernetes.io/metadata.name": "kube-system",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         ".": {},
         "f:kubernetes.io/metadata.name": {}
        }
       }
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:05Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:05Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-public",
    "uid": "7c90d2b2-d717-426e-b69d-85064fab7ec8",
    "resourceVersion": "2630",
    "creationTimestamp": "2024-07-08T02:04:04Z",
    "labels": {
     "kubernetes.io/metadata.name": "kube-public",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         ".": {},
         "f:kubernetes.io/metadata.name": {}
        }
       }
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:05Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:05Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
  },
  {
   "kind": "Namespace",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-node-lease",
    "uid": "42146ed4-e1f3-4772-bc3f-a306c46e9ea9",
    "resourceVersion": "2623",
    "creationTimestamp": "2024-07-08T02:04:04Z",
    "labels": {
     "kubernetes.io/metadata.name": "kube-node-lease",
     "kubesphere.io/managed": "true",
     "kubesphere.io/workspace": "system-workspace"
    },
    "ownerReferences": [
     {
      "apiVersion": "tenant.kubesphere.io/v1beta1",
      "kind": "Workspace",
      "name": "system-workspace",
      "uid": "37bffe33-e1bf-408e-8e5b-9f45755bda0e",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "finalizers": [
     "finalizers.kubesphere.io/namespaces"
    ],
    "managedFields": [
     {
      "manager": "kube-apiserver",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         ".": {},
         "f:kubernetes.io/metadata.name": {}
        }
       }
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/namespaces\"": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"37bffe33-e1bf-408e-8e5b-9f45755bda0e\"}": {}
        }
       }
      }
     },
     {
      "manager": "kubectl-label",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:02:04Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:labels": {
         "f:kubesphere.io/managed": {},
         "f:kubesphere.io/workspace": {}
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
 ],
 "totalItems": 6
}
```


