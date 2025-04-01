
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/services?sortBy=createTime&limit=10

```json
{
 "items": [
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "ks-controller-manager",
    "namespace": "kubesphere-system",
    "uid": "e654f19b-178e-4cb4-9280-70117c9fe549",
    "resourceVersion": "1882",
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-controller-manager",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "backend",
     "version": "v4.1.1"
    },
    "annotations": {
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "v1",
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
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":443,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "protocol": "TCP",
      "port": 443,
      "targetPort": 8443
     }
    ],
    "selector": {
     "app": "ks-controller-manager",
     "tier": "backend"
    },
    "clusterIP": "10.96.82.51",
    "clusterIPs": [
     "10.96.82.51"
    ],
    "type": "ClusterIP",
    "sessionAffinity": "None",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "ks-console",
    "namespace": "kubesphere-system",
    "uid": "83e72ccb-29bc-41f8-a06a-8a0d4baa6ec8",
    "resourceVersion": "1883",
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-console",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "frontend",
     "version": "v4.1.1"
    },
    "annotations": {
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "v1",
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
        "f:externalTrafficPolicy": {},
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":80,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:name": {},
          "f:nodePort": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "name": "nginx",
      "protocol": "TCP",
      "port": 80,
      "targetPort": 8000,
      "nodePort": 30880
     }
    ],
    "selector": {
     "app": "ks-console",
     "tier": "frontend"
    },
    "clusterIP": "10.96.179.135",
    "clusterIPs": [
     "10.96.179.135"
    ],
    "type": "NodePort",
    "sessionAffinity": "None",
    "externalTrafficPolicy": "Cluster",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "ks-apiserver",
    "namespace": "kubesphere-system",
    "uid": "34ec7196-b8b3-45d9-a647-94c544c0a1e8",
    "resourceVersion": "1876",
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app": "ks-apiserver",
     "app.kubernetes.io/managed-by": "Helm",
     "tier": "backend",
     "version": "v4.1.1"
    },
    "annotations": {
     "kubernetes.io/created-by": "kubesphere.io/ks-apiserver",
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:kubernetes.io/created-by": {},
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
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":80,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "protocol": "TCP",
      "port": 80,
      "targetPort": 9090
     }
    ],
    "selector": {
     "app": "ks-apiserver",
     "tier": "backend"
    },
    "clusterIP": "10.96.57.253",
    "clusterIPs": [
     "10.96.57.253"
    ],
    "type": "ClusterIP",
    "sessionAffinity": "None",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-controller-admission",
    "namespace": "ingress-nginx",
    "uid": "70ad3eea-f26d-49ea-beb1-f739d1cefb46",
    "resourceVersion": "631",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Service\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-controller-admission\",\"namespace\":\"ingress-nginx\"},\"spec\":{\"ports\":[{\"appProtocol\":\"https\",\"name\":\"https-webhook\",\"port\":443,\"targetPort\":\"webhook\"}],\"selector\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\"},\"type\":\"ClusterIP\"}}\n"
    },
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
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {}
        }
       },
       "f:spec": {
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":443,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:appProtocol": {},
          "f:name": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "name": "https-webhook",
      "protocol": "TCP",
      "appProtocol": "https",
      "port": 443,
      "targetPort": "webhook"
     }
    ],
    "selector": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx"
    },
    "clusterIP": "10.96.9.249",
    "clusterIPs": [
     "10.96.9.249"
    ],
    "type": "ClusterIP",
    "sessionAffinity": "None",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-controller",
    "namespace": "ingress-nginx",
    "uid": "a0745ca4-5abc-4aec-929d-be0d5b99cafb",
    "resourceVersion": "626",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Service\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-controller\",\"namespace\":\"ingress-nginx\"},\"spec\":{\"externalTrafficPolicy\":\"Cluster\",\"ports\":[{\"appProtocol\":\"http\",\"name\":\"http\",\"nodePort\":30080,\"port\":80,\"protocol\":\"TCP\",\"targetPort\":\"http\"},{\"appProtocol\":\"https\",\"name\":\"https\",\"nodePort\":30443,\"port\":443,\"protocol\":\"TCP\",\"targetPort\":\"https\"}],\"selector\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\"},\"type\":\"NodePort\"}}\n"
    },
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
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {}
        }
       },
       "f:spec": {
        "f:externalTrafficPolicy": {},
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":80,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:appProtocol": {},
          "f:name": {},
          "f:nodePort": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         },
         "k:{\"port\":443,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:appProtocol": {},
          "f:name": {},
          "f:nodePort": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "name": "http",
      "protocol": "TCP",
      "appProtocol": "http",
      "port": 80,
      "targetPort": "http",
      "nodePort": 30080
     },
     {
      "name": "https",
      "protocol": "TCP",
      "appProtocol": "https",
      "port": 443,
      "targetPort": "https",
      "nodePort": 30443
     }
    ],
    "selector": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx"
    },
    "clusterIP": "10.96.11.26",
    "clusterIPs": [
     "10.96.11.26"
    ],
    "type": "NodePort",
    "sessionAffinity": "None",
    "externalTrafficPolicy": "Cluster",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-dns",
    "namespace": "kube-system",
    "uid": "0e5fc8c5-d647-44e1-b647-f35ef2152143",
    "resourceVersion": "230",
    "creationTimestamp": "2024-07-08T02:04:07Z",
    "labels": {
     "k8s-app": "kube-dns",
     "kubernetes.io/cluster-service": "true",
     "kubernetes.io/name": "CoreDNS"
    },
    "annotations": {
     "prometheus.io/port": "9153",
     "prometheus.io/scrape": "true"
    },
    "managedFields": [
     {
      "manager": "kubeadm",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:07Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:prometheus.io/port": {},
         "f:prometheus.io/scrape": {}
        },
        "f:labels": {
         ".": {},
         "f:k8s-app": {},
         "f:kubernetes.io/cluster-service": {},
         "f:kubernetes.io/name": {}
        }
       },
       "f:spec": {
        "f:clusterIP": {},
        "f:internalTrafficPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":53,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:name": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         },
         "k:{\"port\":53,\"protocol\":\"UDP\"}": {
          ".": {},
          "f:name": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         },
         "k:{\"port\":9153,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:name": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:selector": {},
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "name": "dns",
      "protocol": "UDP",
      "port": 53,
      "targetPort": 53
     },
     {
      "name": "dns-tcp",
      "protocol": "TCP",
      "port": 53,
      "targetPort": 53
     },
     {
      "name": "metrics",
      "protocol": "TCP",
      "port": 9153,
      "targetPort": 9153
     }
    ],
    "selector": {
     "k8s-app": "kube-dns"
    },
    "clusterIP": "10.96.0.10",
    "clusterIPs": [
     "10.96.0.10"
    ],
    "type": "ClusterIP",
    "sessionAffinity": "None",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  },
  {
   "kind": "Service",
   "apiVersion": "v1",
   "metadata": {
    "name": "kubernetes",
    "namespace": "default",
    "uid": "548ee44f-b481-460b-aea4-6b060df7b0c8",
    "resourceVersion": "198",
    "creationTimestamp": "2024-07-08T02:04:05Z",
    "labels": {
     "component": "apiserver",
     "provider": "kubernetes"
    },
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
         "f:component": {},
         "f:provider": {}
        }
       },
       "f:spec": {
        "f:clusterIP": {},
        "f:internalTrafficPolicy": {},
        "f:ipFamilyPolicy": {},
        "f:ports": {
         ".": {},
         "k:{\"port\":443,\"protocol\":\"TCP\"}": {
          ".": {},
          "f:name": {},
          "f:port": {},
          "f:protocol": {},
          "f:targetPort": {}
         }
        },
        "f:sessionAffinity": {},
        "f:type": {}
       }
      }
     }
    ]
   },
   "spec": {
    "ports": [
     {
      "name": "https",
      "protocol": "TCP",
      "port": 443,
      "targetPort": 6443
     }
    ],
    "clusterIP": "10.96.0.1",
    "clusterIPs": [
     "10.96.0.1"
    ],
    "type": "ClusterIP",
    "sessionAffinity": "None",
    "ipFamilies": [
     "IPv4"
    ],
    "ipFamilyPolicy": "SingleStack",
    "internalTrafficPolicy": "Cluster"
   },
   "status": {
    "loadBalancer": {}
   }
  }
 ],
 "totalItems": 7
}

```