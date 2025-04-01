https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/api/v1/nodes/ks-cloud-control-plane

```json
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "ks-cloud-control-plane",
    "uid": "92257b14-51ac-45b4-a328-e9183779c36c",
    "resourceVersion": "135211",
    "creationTimestamp": "2024-07-08T02:04:04Z",
    "labels": {
      "beta.kubernetes.io/arch": "amd64",
      "beta.kubernetes.io/os": "linux",
      "kubernetes.io/arch": "amd64",
      "kubernetes.io/hostname": "ks-cloud-control-plane",
      "kubernetes.io/os": "linux",
      "node-role.kubernetes.io/control-plane": "",
      "node-role.kubernetes.io/master": "",
      "node.kubernetes.io/exclude-from-external-load-balancers": ""
    },
    "annotations": {
      "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///run/containerd/containerd.sock",
      "node.alpha.kubernetes.io/ttl": "0",
      "projectcalico.org/IPv4Address": "172.18.0.3/16",
      "projectcalico.org/IPv4IPIPTunnelAddr": "10.244.72.192",
      "volumes.kubernetes.io/controller-managed-attach-detach": "true"
    },
    "managedFields": [
      {
        "manager": "kubelet",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-08T02:04:04Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              ".": {},
              "f:volumes.kubernetes.io/controller-managed-attach-detach": {}
            },
            "f:labels": {
              ".": {},
              "f:beta.kubernetes.io/arch": {},
              "f:beta.kubernetes.io/os": {},
              "f:kubernetes.io/arch": {},
              "f:kubernetes.io/hostname": {},
              "f:kubernetes.io/os": {}
            }
          },
          "f:spec": {
            "f:providerID": {}
          }
        }
      },
      {
        "manager": "kubeadm",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-08T02:04:07Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              "f:kubeadm.alpha.kubernetes.io/cri-socket": {}
            },
            "f:labels": {
              "f:node-role.kubernetes.io/control-plane": {},
              "f:node-role.kubernetes.io/master": {},
              "f:node.kubernetes.io/exclude-from-external-load-balancers": {}
            }
          }
        }
      },
      {
        "manager": "kube-controller-manager",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-08T02:05:30Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              "f:node.alpha.kubernetes.io/ttl": {}
            }
          },
          "f:spec": {
            "f:podCIDR": {},
            "f:podCIDRs": {
              ".": {},
              "v:\"10.244.0.0/24\"": {}
            },
            "f:taints": {}
          }
        }
      },
      {
        "manager": "kubelet",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2025-03-01T07:07:22Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:status": {
            "f:addresses": {
              "k:{\"type\":\"InternalIP\"}": {
                "f:address": {}
              }
            },
            "f:allocatable": {
              "f:cpu": {},
              "f:memory": {}
            },
            "f:capacity": {
              "f:cpu": {},
              "f:memory": {}
            },
            "f:conditions": {
              "k:{\"type\":\"DiskPressure\"}": {
                "f:lastHeartbeatTime": {}
              },
              "k:{\"type\":\"MemoryPressure\"}": {
                "f:lastHeartbeatTime": {}
              },
              "k:{\"type\":\"PIDPressure\"}": {
                "f:lastHeartbeatTime": {}
              },
              "k:{\"type\":\"Ready\"}": {
                "f:lastHeartbeatTime": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {}
              }
            },
            "f:images": {},
            "f:nodeInfo": {
              "f:bootID": {},
              "f:machineID": {}
            }
          }
        },
        "subresource": "status"
      },
      {
        "manager": "calico-node",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2025-03-01T07:08:07Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              "f:projectcalico.org/IPv4Address": {},
              "f:projectcalico.org/IPv4IPIPTunnelAddr": {}
            }
          },
          "f:status": {
            "f:conditions": {
              "k:{\"type\":\"NetworkUnavailable\"}": {
                ".": {},
                "f:lastHeartbeatTime": {},
                "f:lastTransitionTime": {},
                "f:message": {},
                "f:reason": {},
                "f:status": {},
                "f:type": {}
              }
            }
          }
        },
        "subresource": "status"
      }
    ]
  },
  "spec": {
    "podCIDR": "10.244.0.0/24",
    "podCIDRs": [
      "10.244.0.0/24"
    ],
    "providerID": "kind://docker/ks-cloud/ks-cloud-control-plane",
    "taints": [
      {
        "key": "node-role.kubernetes.io/master",
        "effect": "NoSchedule"
      }
    ]
  },
  "status": {
    "capacity": {
      "cpu": "2",
      "ephemeral-storage": "101444584Ki",
      "hugepages-2Mi": "0",
      "memory": "4026024Ki",
      "pods": "110"
    },
    "allocatable": {
      "cpu": "2",
      "ephemeral-storage": "101444584Ki",
      "hugepages-2Mi": "0",
      "memory": "4026024Ki",
      "pods": "110"
    },
    "conditions": [
      {
        "type": "NetworkUnavailable",
        "status": "False",
        "lastHeartbeatTime": "2025-03-01T07:08:07Z",
        "lastTransitionTime": "2025-03-01T07:08:07Z",
        "reason": "CalicoIsUp",
        "message": "Calico is running on this node"
      },
      {
        "type": "MemoryPressure",
        "status": "False",
        "lastHeartbeatTime": "2025-03-02T05:24:31Z",
        "lastTransitionTime": "2024-07-08T02:03:58Z",
        "reason": "KubeletHasSufficientMemory",
        "message": "kubelet has sufficient memory available"
      },
      {
        "type": "DiskPressure",
        "status": "False",
        "lastHeartbeatTime": "2025-03-02T05:24:31Z",
        "lastTransitionTime": "2024-07-08T02:03:58Z",
        "reason": "KubeletHasNoDiskPressure",
        "message": "kubelet has no disk pressure"
      },
      {
        "type": "PIDPressure",
        "status": "False",
        "lastHeartbeatTime": "2025-03-02T05:24:31Z",
        "lastTransitionTime": "2024-07-08T02:03:58Z",
        "reason": "KubeletHasSufficientPID",
        "message": "kubelet has sufficient PID available"
      },
      {
        "type": "Ready",
        "status": "True",
        "lastHeartbeatTime": "2025-03-02T05:24:31Z",
        "lastTransitionTime": "2024-07-08T02:05:30Z",
        "reason": "KubeletReady",
        "message": "kubelet is posting ready status"
      }
    ],
    "addresses": [
      {
        "type": "InternalIP",
        "address": "172.18.0.3"
      },
      {
        "type": "Hostname",
        "address": "ks-cloud-control-plane"
      }
    ],
    "daemonEndpoints": {
      "kubeletEndpoint": {
        "Port": 10250
      }
    },
    "nodeInfo": {
      "machineID": "48a5bc468984498d84b105155781bbc0",
      "systemUUID": "2748c6c3-db35-45de-a81d-b7508900eecd",
      "bootID": "9510bad1-af54-499c-a648-8faec20add79",
      "kernelVersion": "5.4.0-104-generic",
      "osImage": "Ubuntu 22.04.1 LTS",
      "containerRuntimeVersion": "containerd://1.6.8",
      "kubeletVersion": "v1.23.12",
      "kubeProxyVersion": "v1.23.12",
      "operatingSystem": "linux",
      "architecture": "amd64"
    },
    "images": [
      {
        "names": [
          "docker.io/library/import-2022-09-22@sha256:e88f1ac0ba0625e67466396b03d0798c3224ad0772e71457b1777e18d50e82fe",
          "k8s.gcr.io/kube-proxy:v1.23.12"
        ],
        "sizeBytes": 114218860
      },
      {
        "names": [
          "registry.k8s.io/ingress-nginx/controller@sha256:31f47c1e202b39fadecf822a9b76370bd4baed199a005b3e7d4d1455f4fd3fe2"
        ],
        "sizeBytes": 103823446
      },
      {
        "names": [
          "k8s.gcr.io/etcd:3.5.1-0"
        ],
        "sizeBytes": 98888614
      },
      {
        "names": [
          "docker.io/library/import-2022-09-22@sha256:700d90717cdfff7faaad1f4e268bb95b014009708e3a51c5f79591c6fd3be923",
          "k8s.gcr.io/kube-apiserver:v1.23.12"
        ],
        "sizeBytes": 79624669
      },
      {
        "names": [
          "docker.io/calico/cni@sha256:30dc6d5340c8094d4d6d3d8d47f454cb20dbc6a54a891dad19691ade0e19c55e",
          "docker.io/calico/cni:v3.21.6"
        ],
        "sizeBytes": 77838951
      },
      {
        "names": [
          "docker.io/calico/node@sha256:89cc9adaca1d22b5aa34a0a824854c4f32b1d8db766af34a6a20c06d1f33606f",
          "docker.io/calico/node:v3.21.6"
        ],
        "sizeBytes": 74182131
      },
      {
        "names": [
          "docker.io/library/import-2022-09-22@sha256:af002d59e091e9255c2518bd8bd8c74d530505a77e478a7a4273df66b048886e",
          "k8s.gcr.io/kube-controller-manager:v1.23.12"
        ],
        "sizeBytes": 68167791
      },
      {
        "names": [
          "docker.io/library/import-2022-09-22@sha256:c118635543a3b0ee14a639fe2734ed3314a9cb37e7664839d48b3661120ae32f",
          "k8s.gcr.io/kube-scheduler:v1.23.12"
        ],
        "sizeBytes": 54835311
      },
      {
        "names": [
          "docker.io/calico/kube-controllers@sha256:df3fc449c9ac90f7744bebc2c67a81904de27e7c938b845e317ff4ef00dd73f2",
          "docker.io/calico/kube-controllers:v3.21.6"
        ],
        "sizeBytes": 51991366
      },
      {
        "names": [
          "docker.io/kindest/kindnetd:v20220726-ed811e41"
        ],
        "sizeBytes": 25818452
      },
      {
        "names": [
          "registry.k8s.io/ingress-nginx/kube-webhook-certgen@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660"
        ],
        "sizeBytes": 18899182
      },
      {
        "names": [
          "docker.io/kindest/local-path-provisioner:v0.0.22-kind.0"
        ],
        "sizeBytes": 17375346
      },
      {
        "names": [
          "k8s.gcr.io/coredns/coredns:v1.8.6"
        ],
        "sizeBytes": 13585107
      },
      {
        "names": [
          "docker.io/calico/pod2daemon-flexvol@sha256:a05e72b54f9909a1d1cd6e94e1176b06c844db710c639aa6a1f36462dc1a840c",
          "docker.io/calico/pod2daemon-flexvol:v3.21.6"
        ],
        "sizeBytes": 8686991
      },
      {
        "names": [
          "docker.io/kindest/local-path-helper:v20220607-9a4d8d2a"
        ],
        "sizeBytes": 2859509
      },
      {
        "names": [
          "registry.k8s.io/pause:3.7"
        ],
        "sizeBytes": 311278
      }
    ]
  }
}
```

