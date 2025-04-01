
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/serviceaccounts?sortBy=createTime&limit=10

```json
{
 "items": [
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "namespace": "kubesphere-controls-system",
    "uid": "85a51f21-935d-4b17-8ef7-c7f12efd6b86",
    "resourceVersion": "2599",
    "creationTimestamp": "2024-07-09T07:02:03Z"
   },
   "secrets": [
    {
     "name": "default-token-qwmcv"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "kubesphere",
    "namespace": "kubesphere-system",
    "uid": "7d16a70e-d83b-4db0-9a14-7da34a926a4b",
    "resourceVersion": "1871",
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app.kubernetes.io/instance": "ks-core",
     "app.kubernetes.io/managed-by": "Helm",
     "app.kubernetes.io/name": "ks-core",
     "app.kubernetes.io/version": "v4.1.1",
     "helm.sh/chart": "ks-core-1.0.8"
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
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/managed-by": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/version": {},
         "f:helm.sh/chart": {}
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:secrets": {
        ".": {},
        "k:{\"name\":\"kubesphere-token-hx8n6\"}": {}
       }
      }
     }
    ]
   },
   "secrets": [
    {
     "name": "kubesphere-token-hx8n6"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "namespace": "kubesphere-system",
    "uid": "b36cef2c-869f-41a2-b166-be37bb52e3f7",
    "resourceVersion": "1861",
    "creationTimestamp": "2024-07-09T07:00:31Z"
   },
   "secrets": [
    {
     "name": "default-token-qlh59"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-admission",
    "namespace": "ingress-nginx",
    "uid": "6d51646c-4f9a-4dc7-a7f2-a0cd1210e4a5",
    "resourceVersion": "614",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "admission-webhook",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"ServiceAccount\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"admission-webhook\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx-admission\",\"namespace\":\"ingress-nginx\"}}\n"
    },
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:secrets": {
        ".": {},
        "k:{\"name\":\"ingress-nginx-admission-token-hwpd9\"}": {}
       }
      }
     },
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
       }
      }
     }
    ]
   },
   "secrets": [
    {
     "name": "ingress-nginx-admission-token-hwpd9"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx",
    "namespace": "ingress-nginx",
    "uid": "7209068d-fa27-467a-9b92-e3856d1f9735",
    "resourceVersion": "611",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3"
    },
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"automountServiceAccountToken\":true,\"kind\":\"ServiceAccount\",\"metadata\":{\"annotations\":{},\"labels\":{\"app.kubernetes.io/component\":\"controller\",\"app.kubernetes.io/instance\":\"ingress-nginx\",\"app.kubernetes.io/name\":\"ingress-nginx\",\"app.kubernetes.io/part-of\":\"ingress-nginx\",\"app.kubernetes.io/version\":\"1.1.3\"},\"name\":\"ingress-nginx\",\"namespace\":\"ingress-nginx\"}}\n"
    },
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:secrets": {
        ".": {},
        "k:{\"name\":\"ingress-nginx-token-qq8lc\"}": {}
       }
      }
     },
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:automountServiceAccountToken": {},
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
       }
      }
     }
    ]
   },
   "secrets": [
    {
     "name": "ingress-nginx-token-qq8lc"
    }
   ],
   "automountServiceAccountToken": true
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "namespace": "ingress-nginx",
    "uid": "91f7ca74-369c-4b82-b290-f8c944ff730a",
    "resourceVersion": "608",
    "creationTimestamp": "2024-07-08T02:04:43Z"
   },
   "secrets": [
    {
     "name": "default-token-c6cmm"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "calico-node",
    "namespace": "kube-system",
    "uid": "75ae494f-3762-436f-b228-38c83787e8fb",
    "resourceVersion": "575",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"ServiceAccount\",\"metadata\":{\"annotations\":{},\"name\":\"calico-node\",\"namespace\":\"kube-system\"}}\n"
    },
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:secrets": {
        ".": {},
        "k:{\"name\":\"calico-node-token-9rtvv\"}": {}
       }
      }
     },
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
        }
       }
      }
     }
    ]
   },
   "secrets": [
    {
     "name": "calico-node-token-9rtvv"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "calico-kube-controllers",
    "namespace": "kube-system",
    "uid": "6ac43793-e0c8-4b50-832f-3115f6dfc2b4",
    "resourceVersion": "592",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"ServiceAccount\",\"metadata\":{\"annotations\":{},\"name\":\"calico-kube-controllers\",\"namespace\":\"kube-system\"}}\n"
    },
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:secrets": {
        ".": {},
        "k:{\"name\":\"calico-kube-controllers-token-zt4xr\"}": {}
       }
      }
     },
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
        }
       }
      }
     }
    ]
   },
   "secrets": [
    {
     "name": "calico-kube-controllers-token-zt4xr"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "namespace": "kube-node-lease",
    "uid": "75bd4bca-a592-47a1-a44d-aea6aa9e7f74",
    "resourceVersion": "431",
    "creationTimestamp": "2024-07-08T02:04:23Z"
   },
   "secrets": [
    {
     "name": "default-token-hmfpp"
    }
   ]
  },
  {
   "kind": "ServiceAccount",
   "apiVersion": "v1",
   "metadata": {
    "name": "default",
    "namespace": "local-path-storage",
    "uid": "ed001fd7-a793-4337-980c-b940fb8500de",
    "resourceVersion": "435",
    "creationTimestamp": "2024-07-08T02:04:23Z"
   },
   "secrets": [
    {
     "name": "default-token-8zm5k"
    }
   ]
  }
 ],
 "totalItems": 48
}
```

https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/api/v1/namespaces/kubesphere-system/secrets/kubesphere-token-hx8n6
```json
{
    "kind": "Secret",
    "apiVersion": "v1",
    "metadata": {
        "name": "kubesphere-token-hx8n6",
        "namespace": "kubesphere-system",
        "uid": "205461cc-536f-4fb3-8f49-3b20b2e180be",
        "resourceVersion": "1868",
        "creationTimestamp": "2024-07-09T07:00:31Z",
        "annotations": {
            "kubernetes.io/service-account.name": "kubesphere",
            "kubernetes.io/service-account.uid": "7d16a70e-d83b-4db0-9a14-7da34a926a4b"
        },
        "managedFields": [
            {
                "manager": "kube-controller-manager",
                "operation": "Update",
                "apiVersion": "v1",
                "time": "2024-07-09T07:00:31Z",
                "fieldsType": "FieldsV1",
                "fieldsV1": {
                    "f:data": {
                        ".": {},
                        "f:ca.crt": {},
                        "f:namespace": {},
                        "f:token": {}
                    },
                    "f:metadata": {
                        "f:annotations": {
                            ".": {},
                            "f:kubernetes.io/service-account.name": {},
                            "f:kubernetes.io/service-account.uid": {}
                        }
                    },
                    "f:type": {}
                }
            }
        ]
    },
    "data": {
        "ca.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJME1EY3dPREF5TURNMU1sb1hEVE0wTURjd05qQXlNRE0xTWxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTkwzCkViVDVHUjR2bDRoMG9Xdm13akNieFpINGk1ZHBRaGozY1BaL3pabEY0Rjk0MzA3dVdlQnB0UlNLd1hlendoR1QKL0VFQ2duTWFidTZMWTQ4MVV6R0ppMVdOY0VkSmc4aVNIRUJHRjAzMmRxNnIyQjdGbVk1YWlncjk5bDZ3OEsxcQpYV0hjN091ekhHTVkxMFo1bHZBL1F1VkY2eGgycnAvQ21oSjdIU0JJWjZwUGRLVmYrcWsyRzFtL2ZaQm1icEZOCk1Ea1FnSkI0eGFnM3d6ZEFFdzdBcHQxRUZ3WVVzMHpHNXM5bUM0RExLWERsMDExTkN0bWpSYklPeUlzODRJekUKZUY0dFlWS2tGOUxCOGdrbmpKRTFTdEdDWnNKN0FlUHRvYVh4TmpyczF1aysrRGJjTlU3V2xvbDE2TFVZUUFPMQp0Nk5XbU5CMGxiN3M5YmM2R0xzQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZER0kxbDdSY21WYlhpb0xPQ2hYSTI1QlJIQUdNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBTVRKOW1RTEhacE40Q0diRDhLYQpMVHpHOTd6WDZNK1NBK05zVkVkWENhN1JWVXlOVXk1TitHV2paRmZoRCtRMmIxZ1NMOGJ2RmVGUzl2WkdBVFYzClNqV0hTdlYrSXd6d1A3YTJEYlU1SVcycVJLeis5SFEzQkYyRVd6UG91dHk0eGViRGcxUG82N3V1QzJlMEN0c2IKQmVZeDhrWXplWXhrVFhCWTJscW00S1RZVmwxM1ozQndqL1p4dkRvNlJjUCtIcFY2MU13QVkvSENBTUxvdVM3MApqSXlTd1Y1NVpWMkg3N29zSFJUMDQxOVoyRU9lZEhYZ09rYlltMUdmK0dkbHZKTU5HN09QQkJlbjBkMFdDZGs1CmpyOThzZXQvM1N5ZzJCWTcrSUNjMmxwNjY1Nk5JV09nUmxsckVoc24wQnJ0ZG0yRU5QNEVnZFlFMHk4NTZYVWMKL1pnPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==",
        "namespace": "a3ViZXNwaGVyZS1zeXN0ZW0=",
        "token": "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklsSnpXVzVMTFc5emVuUTBkR1JZVldvNU9FUklPRWgzT0VkVk1HMWxhalZFTTNsSVRUTlRORVUxVVZraWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUpyZFdKbGMzQm9aWEpsTFhONWMzUmxiU0lzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVmpjbVYwTG01aGJXVWlPaUpyZFdKbGMzQm9aWEpsTFhSdmEyVnVMV2g0T0c0Mklpd2lhM1ZpWlhKdVpYUmxjeTVwYnk5elpYSjJhV05sWVdOamIzVnVkQzl6WlhKMmFXTmxMV0ZqWTI5MWJuUXVibUZ0WlNJNkltdDFZbVZ6Y0dobGNtVWlMQ0pyZFdKbGNtNWxkR1Z6TG1sdkwzTmxjblpwWTJWaFkyTnZkVzUwTDNObGNuWnBZMlV0WVdOamIzVnVkQzUxYVdRaU9pSTNaREUyWVRjd1pTMWtPRE5pTFRSa1lqQXRPV0V4TkMwM1pHRXpOR0U1TWpaaE5HSWlMQ0p6ZFdJaU9pSnplWE4wWlcwNmMyVnlkbWxqWldGalkyOTFiblE2YTNWaVpYTndhR1Z5WlMxemVYTjBaVzA2YTNWaVpYTndhR1Z5WlNKOS5wSUVsWGhvUnZ5dFRXNWIwVkZLT2VzakNZVnBWLVh0dWlWZHo1Tnl1LXdLQm4zd0VZMjBhbGRPaDdBclV6VTNtcDFHT0M5ZG5PSHpNMkdpNkROcDlGYnZvZHlwZ3FvQkgxQUFYT1ZkQzZNcWlWZmJTS1ZpM3IwR3pxX09Rc05aYmVBSzFEN21zdHJZM3kzdU5fOXotYUE3dWpiUG9EOXplbjZDMlc3ckZvSzZFZE14aWZBbmFSdjRDbWo3YVlBV1BpWC16d05pZ3M3TENEbmtYNjUxZkIzeVNTc2xSdzQyRHl2T3QxUl9JeWdVU2U1dzB6UElEWWdyQTFpWnU5a0dVY25HMWtFY3dfNGtKTzhBS0ZUOG5RdnB5RU1nbUN4bW81Wko3eW1wWWF3dzFsWlNRbVZ3ZGU3NDNiWEo2czFIel92U1g1WUxLMktVOXhfQldyaDQ5TkE="
    },
    "type": "kubernetes.io/service-account-token"
}
```


