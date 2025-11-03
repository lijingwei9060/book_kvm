/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/nodes?isGetResource=1&page=1&pageSize=10&keyword=&labels=&orderBy=role&phase=&ascending=true&role=

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "role": "Master",
                "nodeStatus": "",
                "nodePhase": [
                    "Ready"
                ],
                "resourcePoolName": "master资源池",
                "nodeResource": {
                    "name": "10.203.52.101",
                    "allocatableResource": {
                        "cpu": 156.875,
                        "usageCPU": 25.12,
                        "memory": 118.48040008544922,
                        "usageMemory": 33.1203125,
                        "pod": 110,
                        "usagePod": 52
                    },
                    "physicalResource": {
                        "cpu": 64,
                        "usageCPU": 10.627,
                        "memory": 125.48040008544922,
                        "usageMemory": 97.78519821166992
                    },
                    "reservedResource": {
                        "systemReservedCPU": 1,
                        "systemReservedMemory": 6,
                        "kubeReservedCPU": "250m",
                        "kubeReservedMemory": "512Mi",
                        "evictionHardMemory": "512Mi",
                        "evictionHardNodeFs": "5Gi"
                    }
                },
                "node": {
                    "metadata": {
                        "name": "10.203.52.101",
                        "uid": "56b65f4e-a7f3-468d-81ff-b62eca9f3ae0",
                        "resourceVersion": "58499358",
                        "creationTimestamp": "2025-06-09T07:23:19Z",
                        "labels": {
                            "beta.kubernetes.io/arch": "amd64",
                            "beta.kubernetes.io/os": "linux",
                            "bingokube.bingosoft.net/EWIP": "",
                            "bingokube.bingosoft.net/businessIP": "",
                            "bingokube.bingosoft.net/ip": "10.203.52.101",
                            "bingokube.bingosoft.net/managed-by": "bcs",
                            "bingokube.bingosoft.net/oversoldratio-cpu": "2.5",
                            "bingokube.bingosoft.net/pool": "master-pool",
                            "kubernetes.io/arch": "amd64",
                            "kubernetes.io/hostname": "10.203.52.101",
                            "kubernetes.io/os": "linux",
                            "node-role.kubernetes.io/control-plane": "",
                            "node-role.kubernetes.io/master": "",
                            "node.kubernetes.io/exclude-from-external-load-balancers": ""
                        },
                        "annotations": {
                            "csi.volume.kubernetes.io/nodeid": "{\"bcs.csi.local.com\":\"10.203.52.101\",\"bcs.csi.share.com\":\"10.203.52.101\",\"com.nfs.csi.hps\":\"10.203.52.101|10.203.52.101\",\"iscsi.csi.bingo-hps.com\":\"host-8daccfc6-b1c7-4f5e-b4f9-97da09de3d78|iqn.2012-01.com.openeuler:90f55a8efb13d384\"}",
                            "kubeadm.alpha.kubernetes.io/cri-socket": "/run/containerd/containerd.sock",
                            "node.alpha.kubernetes.io/ttl": "0",
                            "pre-oversold-cpu-allocatable": "62750m",
                            "pre-oversold-memory-allocatable": "124235704Ki",
                            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
                        },
                        "managedFields": [
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:23:19Z",
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
                                    }
                                }
                            },
                            {
                                "manager": "kubeadm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:23:20Z",
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
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:28:57Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/pool": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bhci-kube-plugin",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-06T07:38:20Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/managed-by": {},
                                            "f:bingokube.bingosoft.net/oversoldratio-cpu": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-10T23:00:12Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:csi.volume.kubernetes.io/nodeid": {}
                                        }
                                    },
                                    "f:status": {
                                        "f:allocatable": {
                                            "f:cpu": {},
                                            "f:ephemeral-storage": {}
                                        },
                                        "f:conditions": {
                                            "k:{\"type\":\"DiskPressure\"}": {
                                                "f:lastHeartbeatTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:message": {},
                                                "f:reason": {},
                                                "f:status": {}
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
                                        "f:images": {}
                                    }
                                },
                                "subresource": "status"
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:35:55Z",
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
                                            "v:\"172.20.0.0/24\"": {}
                                        }
                                    }
                                }
                            }
                        ]
                    },
                    "spec": {
                        "podCIDR": "172.20.0.0/24",
                        "podCIDRs": [
                            "172.20.0.0/24"
                        ]
                    },
                    "status": {
                        "capacity": {
                            "cpu": "64",
                            "ephemeral-storage": "258882884Ki",
                            "hugepages-1Gi": "4Gi",
                            "hugepages-2Mi": "0",
                            "memory": "131575736Ki",
                            "pods": "110"
                        },
                        "allocatable": {
                            "cpu": "156875m",
                            "ephemeral-storage": "253640004Ki",
                            "hugepages-1Gi": "4Gi",
                            "hugepages-2Mi": "0",
                            "memory": "124235704Ki",
                            "pods": "110"
                        },
                        "conditions": [
                            {
                                "type": "MemoryPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:52Z",
                                "lastTransitionTime": "2025-06-09T07:23:19Z",
                                "reason": "KubeletHasSufficientMemory",
                                "message": "kubelet has sufficient memory available"
                            },
                            {
                                "type": "DiskPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:52Z",
                                "lastTransitionTime": "2025-09-15T09:42:50Z",
                                "reason": "KubeletHasNoDiskPressure",
                                "message": "kubelet has no disk pressure"
                            },
                            {
                                "type": "PIDPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:52Z",
                                "lastTransitionTime": "2025-06-09T07:23:19Z",
                                "reason": "KubeletHasSufficientPID",
                                "message": "kubelet has sufficient PID available"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastHeartbeatTime": "2025-09-18T03:45:52Z",
                                "lastTransitionTime": "2025-06-09T07:26:40Z",
                                "reason": "KubeletReady",
                                "message": "kubelet is posting ready status. AppArmor enabled"
                            }
                        ],
                        "addresses": [
                            {
                                "type": "InternalIP",
                                "address": "10.203.52.101"
                            },
                            {
                                "type": "Hostname",
                                "address": "10.203.52.101"
                            }
                        ],
                        "daemonEndpoints": {
                            "kubeletEndpoint": {
                                "Port": 10250
                            }
                        },
                        "nodeInfo": {
                            "machineID": "67beafed95424a92ba49d1f2a54448ae",
                            "systemUUID": "2cd15b45-24a5-a570-ea11-e6064a770a51",
                            "bootID": "1c0f668f-2eed-4ec7-936a-14fc8b5cb37e",
                            "kernelVersion": "5.10.0-136.12.0.86.oe2203sp1.x86_64",
                            "osImage": "Linux",
                            "containerRuntimeVersion": "containerd://1.7.19",
                            "kubeletVersion": "v1.22.26-tenant",
                            "kubeProxyVersion": "v1.22.26-tenant",
                            "operatingSystem": "linux",
                            "architecture": "amd64"
                        },
                        "images": [
                            {
                                "names": [
                                    "registry.bingosoft.net/library/litellm@sha256:e12246bc8432ea5d8f1348b168989a982e6263b0dcba5522f4352d43f81e44e2",
                                    "registry.bingosoft.net/library/litellm:main-latest"
                                ],
                                "sizeBytes": 716746162
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/lcdp-agent-market@sha256:8286c57b35b28330a83b790e484d1b3162aa242197a11a06279c72d2cc7d7e03",
                                    "registry.kube.io:5000/bingofuse/lcdp-agent-market:1.0.9"
                                ],
                                "sizeBytes": 489329459
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task@sha256:bc98db261748d22387d4be2a599d5a317a3a8d45b3d51afe30c103ca23051675",
                                    "registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task:1.0.9"
                                ],
                                "sizeBytes": 442739310
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/muban/openeuler@sha256:a4d1b1b0639cb75cfdabb340f83066af2c3532aa766c980e50c50418fc9ca9cd",
                                    "registry.bingosoft.net/muban/openeuler:22.03-lts-sp3"
                                ],
                                "sizeBytes": 432221764
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin@sha256:2993b2e6c6e2ff02693356f31c1af37438aa1337c063cfafc1e08f0bd7ba3047",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin:v10.3.0"
                                ],
                                "sizeBytes": 258471721
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi@sha256:13a71bcb1fcd59a2e367ed1af511db07d0678af7996ab1d559a54fe38bfc34ec",
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi:3.3.000.8"
                                ],
                                "sizeBytes": 216031909
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs@sha256:46c3e3c64ac4d92bf70af77812a7b33fb67a7d3da8ae455e1830fb6693b0b38f",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs:3.1.000.0"
                                ],
                                "sizeBytes": 201878729
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-web@sha256:90bfe00d908e5340d285dfa857c796d2b10a06584d9e10c71a823b63a9fff9d0",
                                    "registry.bingosoft.net/langgenius/dify-web:1.6.0"
                                ],
                                "sizeBytes": 176144026
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/mysql@sha256:db404edfdc51438cc11c0f29ba0f1d0cb509bb9110d00613ea8036588ec9a68d",
                                    "registry.kube.io:5000/bingofuse/mysql:8.0.36"
                                ],
                                "sizeBytes": 174757681
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                                    "registry.bingosoft.net/n9n/categraf:latest"
                                ],
                                "sizeBytes": 151804132
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/ubuntu@sha256:cc394c2cff7a3137774af9ad6fdcf562f729a180e0d6c10f664b27308878e5fd",
                                    "registry.bingosoft.net/library/ubuntu:24.04.aio"
                                ],
                                "sizeBytes": 112462275
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179",
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1"
                                ],
                                "sizeBytes": 109319279
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74",
                                    "registry.bingosoft.net/langgenius/postgres:15-alpine"
                                ],
                                "sizeBytes": 108679902
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-jobservice@sha256:6c898c099f417792f92042a9e34d2f5a865398e6c96154c4211aba0530b6d054",
                                    "registry.kube.io:5000/goharbor/harbor-jobservice:v2.7.2"
                                ],
                                "sizeBytes": 105525495
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-nvs@sha256:2b40e4db23a798ee875205f8e6c53c1810117806b519a35fa3d96ef23602dd5f",
                                    "registry.kube.io:5000/bingokube/kube-nvs:v1.7.0-master"
                                ],
                                "sizeBytes": 102116015
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.1-0"
                                ],
                                "sizeBytes": 98887658
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-db@sha256:3e18800420c322278bb6860bfa065a1403a569c1a612dbe1ea3b93162b4b7494",
                                    "registry.kube.io:5000/goharbor/harbor-db:v2.7.2"
                                ],
                                "sizeBytes": 82628331
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/prometheus/prometheus@sha256:c4819c653616d828ef7d86f96f35c5496b423935d4ee157a7f586ffbe8d7fc42",
                                    "registry.kube.io:5000/bingokube/prometheus/prometheus:v2.32.1"
                                ],
                                "sizeBytes": 76757792
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-core@sha256:9c06b0a80cf8f201ca9e57077e4116ccc466e90cca352eb9f17ccff89810fcae",
                                    "registry.kube.io:5000/goharbor/harbor-core:v2.7.2"
                                ],
                                "sizeBytes": 74619791
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/grafana/promtail@sha256:5283bb0a808a9250aad6506ba8aa923199f432c2f1bb66b707239c0977b2be0f",
                                    "registry.kube.io:5000/bingokube/grafana/promtail:2.8.3"
                                ],
                                "sizeBytes": 74438865
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/kubesphere/ks-controller-manager@sha256:eec405fb60a28d1db5d1dd9696173d4314344dc3a4f76606707f5627a3e77a3c",
                                    "registry.bingosoft.net/kubesphere/ks-controller-manager:v4.1.3"
                                ],
                                "sizeBytes": 60924656
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-portal@sha256:740c36eeef08de32bd4ee9c48ebb363833af7d619f9463b270af35c028aef4ce",
                                    "registry.kube.io:5000/goharbor/harbor-portal:v2.7.2"
                                ],
                                "sizeBytes": 51650184
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/redis-photon@sha256:e5c30ec7643cda92e305ec5adfc24d2aca9779ac682081559a0f2747da8d39e7",
                                    "registry.kube.io:5000/goharbor/redis-photon:v2.7.3"
                                ],
                                "sizeBytes": 50846179
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin@sha256:e5eedf07ec5c7717619d986a18fa426bec58f71de9aba245ab498a05c5658409",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin:v10.3.0"
                                ],
                                "sizeBytes": 50466677
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721",
                                    "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513"
                                ],
                                "sizeBytes": 50111640
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/notary-server-photon@sha256:08120d1ff7ffdd4745a54b3a0d43c98f8bad026481f0ed2caaec3dab8df0204c",
                                    "registry.kube.io:5000/goharbor/notary-server-photon:v2.7.2"
                                ],
                                "sizeBytes": 47635213
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/backup-kube@sha256:b532ae455193774054b63f62fc7a7511afa51ff908ad0fb9926a4e98d28d88cf",
                                    "registry.kube.io:5000/bingokube/backup-kube:v1.0.1"
                                ],
                                "sizeBytes": 44749134
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452",
                                    "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509"
                                ],
                                "sizeBytes": 40510378
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs3@sha256:81717ff7eaec682cc205eb68e2f51999ec1ed3997e2267cf162add947053fb0c",
                                    "registry.kube.io:5000/bingokube/bcs3:v1.0"
                                ],
                                "sizeBytes": 37005947
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler@sha256:72ea514aebbbf37c41b75decfa279c4f8fb3a97a3f0170df26f21eafd9d6b2d5",
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler:v1.22.26"
                                ],
                                "sizeBytes": 34537670
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/metrics-server@sha256:9d520b7152c89bdf1cdb01fe75ef7d7536a98b2af2055be1edc8a2397e1b6a3a",
                                    "registry.kube.io:5000/bingokube/metrics-server:v0.6.3"
                                ],
                                "sizeBytes": 31879654
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480",
                                    "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant"
                                ],
                                "sizeBytes": 31351143
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubedupont-webhook@sha256:0e8a4e2626af666bc70709b012ccdd562550526e92a4235dd0ba899733003fd0",
                                    "registry.kube.io:5000/bingokube/kubedupont-webhook:release-bcs-20250509"
                                ],
                                "sizeBytes": 30072682
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/registry-monitor@sha256:271f9ce3ed539a6ab235f9e5f54ccfc07da5a07822a14e8438ddb5556613a4a9",
                                    "registry.kube.io:5000/bingokube/registry-monitor:v0.2.2"
                                ],
                                "sizeBytes": 29959461
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-controller-manager@sha256:9cc7739052dae1389c2d4c75e51432659b9d990d631fd5d5391a64e2d7239c9c",
                                    "registry.kube.io:5000/bingokube/kube-controller-manager:v1.22.26-tenant"
                                ],
                                "sizeBytes": 29825285
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner@sha256:ec09720add0b83d9deec6b53bc56e74c6fd7130bedce81d0c0c03d6ea5092013",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner:v3.5.0"
                                ],
                                "sizeBytes": 28210010
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubealived@sha256:18c41189e79194561aa4ce9390617892727edc4abe94ac6014cfded2c4d5f5dc",
                                    "registry.kube.io:5000/bingokube/kubealived:v1.0.3"
                                ],
                                "sizeBytes": 27867730
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubeverse-front@sha256:db411c48c3e65dc9f323b056b2b373755e12aaedfe661a5a41d6089170d4f275",
                                    "registry.kube.io:5000/bingokube/kubeverse-front:release-v1.7.0-20250514"
                                ],
                                "sizeBytes": 26733665
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher@sha256:feaf439c5a6b410e9f68275c6ea4e147d94d696d6bf6f3c883817291ebcbbafa",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher:v4.3.0"
                                ],
                                "sizeBytes": 26211837
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/agent-side@sha256:92a1af076da73fc7b3efee3e5b609cb12e50c8b493d903e575079fac9f7ad172",
                                    "registry.kube.io:5000/bingokube/agent-side:1.1.1"
                                ],
                                "sizeBytes": 23454100
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/grafana/loki@sha256:404c49c7315c7973d5f4744bd5f515e9ef29eb3a4584d6c7c2895feeb73dc31f",
                                    "registry.kube.io:5000/bingokube/grafana/loki:v2.8.3"
                                ],
                                "sizeBytes": 22425176
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/weaviate@sha256:3cab0765b9cbea1692ab261febebcd987f63122720aa301f9c2b8ef3ed5087e3",
                                    "registry.bingosoft.net/langgenius/weaviate:1.19.0"
                                ],
                                "sizeBytes": 20095599
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher@sha256:b1d324a973a21d5c1ac2de009654bae8b9c320e57cd78450bdfc88f8a2a9d42b",
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher:v3.0.0"
                                ],
                                "sizeBytes": 19192181
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter@sha256:bce65196d5ee635b44f1abf75325d1b6a1bfc204dd8853e69a643e373dc3d827",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter:v3.0.3"
                                ],
                                "sizeBytes": 19139479
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer@sha256:6b7aa36a1aed873ec1e4f4e1622371a01f60d0c0ed109285004a2c45b48cdab7",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer:v1.0.0"
                                ],
                                "sizeBytes": 17753800
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/cert-manager-controller@sha256:e24bbe9dd6dce08bd55d8afffd0e29680d2dad8f7951e43c36aecfba730a1bd3",
                                    "registry.kube.io:5000/bingokube/cert-manager-controller:v1.10.1"
                                ],
                                "sizeBytes": 17739790
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller@sha256:d439eb7b37f0c50297a6defa5eb7b75e909078dcf63b42f2e9954002f9a627df",
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller:v3.0.3"
                                ],
                                "sizeBytes": 17145967
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/redis@sha256:915aa8d4cd87b7469f440afc4f74afa9535d07ebafee17fd1f9b76800d2c0640",
                                    "registry.bingosoft.net/langgenius/redis:6-alpine"
                                ],
                                "sizeBytes": 14651370
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/cert-manager-webhook@sha256:a4acfcf191b72159456c3a8a929fee662140b4139fc15dd6ed171b2a8ae3144e",
                                    "registry.kube.io:5000/bingokube/cert-manager-webhook:v1.10.1"
                                ],
                                "sizeBytes": 13726565
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/cert-manager-cainjector@sha256:66898628ce06f33989b95685148ab1c724f92b1efa32a7e7a08ceac217987252",
                                    "registry.kube.io:5000/bingokube/cert-manager-cainjector:v1.10.1"
                                ],
                                "sizeBytes": 12200644
                            }
                        ]
                    }
                }
            },
            {
                "role": "Master",
                "nodeStatus": "",
                "nodePhase": [
                    "Ready"
                ],
                "resourcePoolName": "master资源池",
                "nodeResource": {
                    "name": "10.203.52.102",
                    "allocatableResource": {
                        "cpu": 156.875,
                        "usageCPU": 33.11,
                        "memory": 103.48040008544922,
                        "usageMemory": 47.30265625,
                        "pod": 110,
                        "usagePod": 66
                    },
                    "physicalResource": {
                        "cpu": 64,
                        "usageCPU": 8.019,
                        "memory": 125.48040008544922,
                        "usageMemory": 81.60483169555664
                    },
                    "reservedResource": {
                        "systemReservedCPU": 1,
                        "systemReservedMemory": 21,
                        "kubeReservedCPU": "250m",
                        "kubeReservedMemory": "512Mi",
                        "evictionHardMemory": "512Mi",
                        "evictionHardNodeFs": "5Gi"
                    }
                },
                "node": {
                    "metadata": {
                        "name": "10.203.52.102",
                        "uid": "4be2e0db-9705-47b6-b142-fdef53b4b2f6",
                        "resourceVersion": "58499357",
                        "creationTimestamp": "2025-06-09T07:23:51Z",
                        "labels": {
                            "beta.kubernetes.io/arch": "amd64",
                            "beta.kubernetes.io/os": "linux",
                            "bingokube.bingosoft.net/EWIP": "",
                            "bingokube.bingosoft.net/businessIP": "",
                            "bingokube.bingosoft.net/ip": "10.203.52.102",
                            "bingokube.bingosoft.net/managed-by": "bcs",
                            "bingokube.bingosoft.net/oversoldratio-cpu": "2.5",
                            "bingokube.bingosoft.net/pool": "master-pool",
                            "kubernetes.io/arch": "amd64",
                            "kubernetes.io/hostname": "10.203.52.102",
                            "kubernetes.io/os": "linux",
                            "node-role.kubernetes.io/control-plane": "",
                            "node-role.kubernetes.io/master": "",
                            "node.kubernetes.io/exclude-from-external-load-balancers": ""
                        },
                        "annotations": {
                            "csi.volume.kubernetes.io/nodeid": "{\"bcs.csi.share.com\":\"10.203.52.102\",\"com.nfs.csi.hps\":\"10.203.52.102|10.203.52.102\",\"iscsi.csi.bingo-hps.com\":\"host-a226e9e9-85e5-4b6a-9c0a-d984a5a6b630|iqn.2012-01.com.openeuler:5488c91d069f283\"}",
                            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///run/containerd/containerd.sock",
                            "node.alpha.kubernetes.io/ttl": "0",
                            "pre-oversold-cpu-allocatable": "62750m",
                            "pre-oversold-memory-allocatable": "108507064Ki",
                            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
                        },
                        "managedFields": [
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:23:51Z",
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
                                    }
                                }
                            },
                            {
                                "manager": "kubeadm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:24:09Z",
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
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:28:58Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/pool": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bhci-kube-plugin",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-06T07:38:20Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/managed-by": {},
                                            "f:bingokube.bingosoft.net/oversoldratio-cpu": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-06T16:05:49Z",
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
                                            "v:\"172.20.1.0/24\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-06T16:07:21Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:csi.volume.kubernetes.io/nodeid": {}
                                        }
                                    },
                                    "f:status": {
                                        "f:allocatable": {
                                            "f:cpu": {},
                                            "f:ephemeral-storage": {}
                                        },
                                        "f:capacity": {
                                            "f:ephemeral-storage": {}
                                        },
                                        "f:conditions": {
                                            "k:{\"type\":\"DiskPressure\"}": {
                                                "f:lastHeartbeatTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:message": {},
                                                "f:reason": {},
                                                "f:status": {}
                                            },
                                            "k:{\"type\":\"MemoryPressure\"}": {
                                                "f:lastHeartbeatTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:message": {},
                                                "f:reason": {},
                                                "f:status": {}
                                            },
                                            "k:{\"type\":\"PIDPressure\"}": {
                                                "f:lastHeartbeatTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:message": {},
                                                "f:reason": {},
                                                "f:status": {}
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
                                            "f:containerRuntimeVersion": {}
                                        }
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "podCIDR": "172.20.1.0/24",
                        "podCIDRs": [
                            "172.20.1.0/24"
                        ]
                    },
                    "status": {
                        "capacity": {
                            "cpu": "64",
                            "ephemeral-storage": "258882884Ki",
                            "hugepages-1Gi": "19Gi",
                            "hugepages-2Mi": "0",
                            "memory": "131575736Ki",
                            "pods": "110"
                        },
                        "allocatable": {
                            "cpu": "156875m",
                            "ephemeral-storage": "253640004Ki",
                            "hugepages-1Gi": "19Gi",
                            "hugepages-2Mi": "0",
                            "memory": "108507064Ki",
                            "pods": "110"
                        },
                        "conditions": [
                            {
                                "type": "MemoryPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:51Z",
                                "lastTransitionTime": "2025-09-06T16:07:21Z",
                                "reason": "KubeletHasSufficientMemory",
                                "message": "kubelet has sufficient memory available"
                            },
                            {
                                "type": "DiskPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:51Z",
                                "lastTransitionTime": "2025-09-06T16:07:21Z",
                                "reason": "KubeletHasNoDiskPressure",
                                "message": "kubelet has no disk pressure"
                            },
                            {
                                "type": "PIDPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:51Z",
                                "lastTransitionTime": "2025-09-06T16:07:21Z",
                                "reason": "KubeletHasSufficientPID",
                                "message": "kubelet has sufficient PID available"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastHeartbeatTime": "2025-09-18T03:45:51Z",
                                "lastTransitionTime": "2025-09-06T16:07:31Z",
                                "reason": "KubeletReady",
                                "message": "kubelet is posting ready status. AppArmor enabled"
                            }
                        ],
                        "addresses": [
                            {
                                "type": "InternalIP",
                                "address": "10.203.52.102"
                            },
                            {
                                "type": "Hostname",
                                "address": "10.203.52.102"
                            }
                        ],
                        "daemonEndpoints": {
                            "kubeletEndpoint": {
                                "Port": 10250
                            }
                        },
                        "nodeInfo": {
                            "machineID": "76a93cfcc2e5459d8a2dcca00cbb4fcf",
                            "systemUUID": "91213d48-44a1-9d64-ea11-2e0b2cfc164b",
                            "bootID": "14dd2d6a-529a-463f-be4a-f1d20e44b488",
                            "kernelVersion": "5.10.0-136.12.0.86.oe2203sp1.x86_64",
                            "osImage": "Linux",
                            "containerRuntimeVersion": "containerd://1.7.19",
                            "kubeletVersion": "v1.22.26-tenant",
                            "kubeProxyVersion": "v1.22.26-tenant",
                            "operatingSystem": "linux",
                            "architecture": "amd64"
                        },
                        "images": [
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/ragflow@sha256:7dd0b7066c8ab40de9dede4c1fdc59e97807262cca3bf63c460a962d5a7947e3",
                                    "registry.bingosoft.net/ragflow/ragflow:v0.19.1"
                                ],
                                "sizeBytes": 7642895582
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/aiinfra/torch_try@sha256:5e5831ea2bfefb8898d2bff456f0b07ff45a559d9efcfd01d3900c911d5da957",
                                    "registry.bingosoft.net/aiinfra/torch_try:20250205"
                                ],
                                "sizeBytes": 4290573695
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/fuse-console@sha256:6f035658ad56212b0055a2ff0df9b4a2ab99428ac067da4a6c85d77b7e8aa24c",
                                    "registry.kube.io:5000/bingofuse/fuse-console:5.3.16-0801"
                                ],
                                "sizeBytes": 902188156
                            },
                            {
                                "names": [
                                    "docker.elastic.co/elasticsearch/elasticsearch@sha256:1c53c89d04f207beb99d56cc4a1cc23516bd9c386858843d5082a98257c04d1c",
                                    "registry.bingosoft.net/karpor/elasticsearch@sha256:58e27a304bdf15810e965acecbfb0bd455c33d86c85fe46d288495d095fb2cb8",
                                    "docker.elastic.co/elasticsearch/elasticsearch:8.6.2",
                                    "registry.bingosoft.net/karpor/elasticsearch:8.6.2"
                                ],
                                "sizeBytes": 685687021
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/milvus@sha256:3d315c8e1535443237011ce7f39b7cfd6bb5cbe9a3e8d2715c53f4b6b3d94452",
                                    "registry.kube.io:5000/bingofuse/milvus:v2.5.8.1"
                                ],
                                "sizeBytes": 607919963
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-api@sha256:d83b73066e892553f1bce9acd615329a5d5820829ae5d466eeebd4bdefd4fc69",
                                    "registry.bingosoft.net/langgenius/dify-api:1.6.0"
                                ],
                                "sizeBytes": 597756625
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-api@sha256:782c7b78f2df2d870ef15a8e86a92e50b079054b9e668c9003a44b9a2052e958",
                                    "registry.bingosoft.net/langgenius/dify-api:1.5.0"
                                ],
                                "sizeBytes": 585692516
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/fuse-api@sha256:8836b3303d496d459adeec54ff476ab6f23c63c55c548e99c9a58ba795d6855d",
                                    "registry.kube.io:5000/bingofuse/fuse-api:5.3.16-0801"
                                ],
                                "sizeBytes": 562635381
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-plugin-daemon@sha256:048fa900488a6a70b9ed59c4bde35a2685db52cf3240a701b4a951cd140e0ca0",
                                    "registry.bingosoft.net/langgenius/dify-plugin-daemon:0.1.2-local"
                                ],
                                "sizeBytes": 514433294
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/fuse-iam-sync@sha256:30897cf4b308ca0877e2f3bf6942bebfdd5d0b78a874cce596e570d33d8e482e",
                                    "registry.kube.io:5000/bingofuse/fuse-iam-sync:5.3.16-0801"
                                ],
                                "sizeBytes": 455003027
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/infinity@sha256:1fa28db0cc656aa78840e6f8c525fd4fcee167ba4a28f169f4c5cb353d9ccaf3",
                                    "registry.bingosoft.net/ragflow/infinity:v0.6.0-dev3"
                                ],
                                "sizeBytes": 283816518
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/jenkins@sha256:dbe1083ce2a06d9e2bb38e11b764bd69dc68c1d60d200cf3a59d0845dbba22eb",
                                    "registry.bingosoft.net/library/jenkins:lts-jdk17"
                                ],
                                "sizeBytes": 279631221
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin@sha256:2993b2e6c6e2ff02693356f31c1af37438aa1337c063cfafc1e08f0bd7ba3047",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin:v10.3.0"
                                ],
                                "sizeBytes": 258471721
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi@sha256:13a71bcb1fcd59a2e367ed1af511db07d0678af7996ab1d559a54fe38bfc34ec",
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi:3.3.000.8"
                                ],
                                "sizeBytes": 216031909
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs@sha256:46c3e3c64ac4d92bf70af77812a7b33fb67a7d3da8ae455e1830fb6693b0b38f",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs:3.1.000.0"
                                ],
                                "sizeBytes": 201878729
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-web@sha256:b42e64caf9af2dfa86f0d70517efbd8371c6dfe384f8b2b6431c853026fa5784",
                                    "registry.bingosoft.net/langgenius/dify-web:1.5.0"
                                ],
                                "sizeBytes": 175461235
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                                    "registry.bingosoft.net/n9n/categraf:latest"
                                ],
                                "sizeBytes": 151804132
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/mysql@sha256:4b6c4935195233bc10b617df3cc725a9ddd5a7f10351a7bf573bea0b5ded7649",
                                    "registry.bingosoft.net/library/mysql:5.7"
                                ],
                                "sizeBytes": 137908758
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179",
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1"
                                ],
                                "sizeBytes": 109319279
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74",
                                    "registry.bingosoft.net/langgenius/postgres:15-alpine"
                                ],
                                "sizeBytes": 108679902
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/prometheus@sha256:69961df6ffa67598048a31aa2822d61f3c93b91d7db24e44d9bb03f99d520da9",
                                    "registry.bingosoft.net/n9n/prometheus:v2.54.1"
                                ],
                                "sizeBytes": 108261050
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-jobservice@sha256:6c898c099f417792f92042a9e34d2f5a865398e6c96154c4211aba0530b6d054",
                                    "registry.kube.io:5000/goharbor/harbor-jobservice:v2.7.2"
                                ],
                                "sizeBytes": 105525495
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-nvs@sha256:2b40e4db23a798ee875205f8e6c53c1810117806b519a35fa3d96ef23602dd5f",
                                    "registry.kube.io:5000/bingokube/kube-nvs:v1.7.0-master"
                                ],
                                "sizeBytes": 102116015
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.1-0"
                                ],
                                "sizeBytes": 98887658
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/squid@sha256:5e38ddd70a852967dea05c5f1d9c21ee0fe37d05c05ebecf883945cfb6827514",
                                    "registry.bingosoft.net/langgenius/squid:latest"
                                ],
                                "sizeBytes": 86951558
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/karpor/karpor@sha256:e0185a50d4869f2290fa94749de335a9c7da66642674992787309467d2262a92",
                                    "registry.bingosoft.net/karpor/karpor:v0.6.4"
                                ],
                                "sizeBytes": 83004609
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-db@sha256:3e18800420c322278bb6860bfa065a1403a569c1a612dbe1ea3b93162b4b7494",
                                    "registry.kube.io:5000/goharbor/harbor-db:v2.7.2"
                                ],
                                "sizeBytes": 82628331
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/grafana/promtail@sha256:5283bb0a808a9250aad6506ba8aa923199f432c2f1bb66b707239c0977b2be0f",
                                    "registry.kube.io:5000/bingokube/grafana/promtail:2.8.3"
                                ],
                                "sizeBytes": 74438865
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/nginx@sha256:1fdc65e25b1aa5ec3774c6226f5cf2d537c83bf42cf8ed679554489bfda6c385",
                                    "registry.bingosoft.net/langgenius/nginx:latest"
                                ],
                                "sizeBytes": 73002548
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/nginxinc/nginx-unprivileged@sha256:66d8b2e0506ccc1c9da32990630e85d40f14640c8108641b60fb64ee6f71b985",
                                    "registry.kube.io:5000/bingokube/nginxinc/nginx-unprivileged:1.25.2"
                                ],
                                "sizeBytes": 70479952
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/searxng@sha256:eaf5346bb12ab279b5fd4b3240d7ba6d2079964412dead5b6e14dc99dbfe50ce",
                                    "registry.bingosoft.net/library/searxng:latest"
                                ],
                                "sizeBytes": 62375021
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-registryctl@sha256:8037471daa444679f20fd21f6cb1f4741cac6cdae2d9a657e69df90c07c7575b",
                                    "registry.kube.io:5000/goharbor/harbor-registryctl:v2.7.2"
                                ],
                                "sizeBytes": 59938900
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/kubesphere/ks-console@sha256:08586c13d50f8f77b6175e37c123e0f3c4c3676b8dea39bae79fbc4cdbb5eec2",
                                    "registry.bingosoft.net/kubesphere/ks-console:v4.1.3"
                                ],
                                "sizeBytes": 59827331
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/kubesphere/ks-apiserver@sha256:1de236bd1656e002c4d7575183b78bace25c2c379af22143ec79df6ffa980571",
                                    "registry.bingosoft.net/kubesphere/ks-apiserver:v4.1.3"
                                ],
                                "sizeBytes": 58785585
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin@sha256:e5eedf07ec5c7717619d986a18fa426bec58f71de9aba245ab498a05c5658409",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin:v10.3.0"
                                ],
                                "sizeBytes": 50466677
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721",
                                    "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513"
                                ],
                                "sizeBytes": 50111640
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/redis@sha256:de1ff34a7ae5ebf0e932e8d8bccc794b306edb1a4b63e0a258582b6f3c442577",
                                    "registry.kube.io:5000/bingofuse/redis:7.0.12"
                                ],
                                "sizeBytes": 48134625
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/notary-server-photon@sha256:08120d1ff7ffdd4745a54b3a0d43c98f8bad026481f0ed2caaec3dab8df0204c",
                                    "registry.kube.io:5000/goharbor/notary-server-photon:v2.7.2"
                                ],
                                "sizeBytes": 47635213
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/python@sha256:399848c5b302c1ec83348860d6adea6b890a781c83b7040a0e5606900b936a14",
                                    "registry.bingosoft.net/library/python:3.9-slim"
                                ],
                                "sizeBytes": 47605349
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/backup-kube@sha256:b532ae455193774054b63f62fc7a7511afa51ff908ad0fb9926a4e98d28d88cf",
                                    "registry.kube.io:5000/bingokube/backup-kube:v1.0.1"
                                ],
                                "sizeBytes": 44749134
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/valkey@sha256:9c68645ea5cc5300aea98dfe8a32e2bf000fb249c698917f9c8c23fe6a61c787",
                                    "registry.bingosoft.net/ragflow/valkey:8"
                                ],
                                "sizeBytes": 44598407
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/redis@sha256:918e637c0f1dd0532eb8591fd61487fff899a7f3e451a457c5b73c84ab5d9de4",
                                    "registry.bingosoft.net/library/redis:6.2"
                                ],
                                "sizeBytes": 41084977
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452",
                                    "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509"
                                ],
                                "sizeBytes": 40510378
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs3@sha256:81717ff7eaec682cc205eb68e2f51999ec1ed3997e2267cf162add947053fb0c",
                                    "registry.kube.io:5000/bingokube/bcs3:v1.0"
                                ],
                                "sizeBytes": 37005947
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-proxy@sha256:7a66ac5a34b4ce76da029148c8842e947c7f1c35530d6f7af5d21ba1b9ed8491",
                                    "registry.kube.io:5000/bingokube/kube-proxy:v1.22.26-tenant"
                                ],
                                "sizeBytes": 35953948
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/s3cmd@sha256:1d43b0218611cfeb586bf077c83b2dca7a0c23be5e7b50dbb3e65257bf81e74b",
                                    "registry.kube.io:5000/bingokube/s3cmd:v1.0"
                                ],
                                "sizeBytes": 35143359
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler@sha256:72ea514aebbbf37c41b75decfa279c4f8fb3a97a3f0170df26f21eafd9d6b2d5",
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler:v1.22.26"
                                ],
                                "sizeBytes": 34537670
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubernetes-event-exporter@sha256:e4ee1c84cbec6deea24ceeb44fb5f719f3cddd3ba87f66ee5117f0ad9058953f",
                                    "registry.kube.io:5000/bingokube/kubernetes-event-exporter:v0.12"
                                ],
                                "sizeBytes": 32903058
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480",
                                    "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant"
                                ],
                                "sizeBytes": 31351143
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/registry-photon@sha256:110a2c1d5397d3379f062893b73af0c9732ea0eba4b496d1c7285fa4129c9541",
                                    "registry.kube.io:5000/goharbor/registry-photon:v2.7.2"
                                ],
                                "sizeBytes": 31061148
                            }
                        ]
                    }
                }
            },
            {
                "role": "Master",
                "nodeStatus": "",
                "nodePhase": [
                    "Ready"
                ],
                "resourcePoolName": "master资源池",
                "nodeResource": {
                    "name": "10.203.52.103",
                    "allocatableResource": {
                        "cpu": 156.875,
                        "usageCPU": 73.95,
                        "memory": 103.47950744628906,
                        "usageMemory": 50.03515625,
                        "pod": 110,
                        "usagePod": 45
                    },
                    "physicalResource": {
                        "cpu": 64,
                        "usageCPU": 7.879,
                        "memory": 125.47950744628906,
                        "usageMemory": 51.7949333190918
                    },
                    "reservedResource": {
                        "systemReservedCPU": 1,
                        "systemReservedMemory": 21,
                        "kubeReservedCPU": "250m",
                        "kubeReservedMemory": "512Mi",
                        "evictionHardMemory": "512Mi",
                        "evictionHardNodeFs": "5Gi"
                    }
                },
                "node": {
                    "metadata": {
                        "name": "10.203.52.103",
                        "uid": "c952bce8-275e-4b92-b068-a995022811cc",
                        "resourceVersion": "58499367",
                        "creationTimestamp": "2025-06-09T07:24:42Z",
                        "labels": {
                            "beta.kubernetes.io/arch": "amd64",
                            "beta.kubernetes.io/os": "linux",
                            "bingokube.bingosoft.net/EWIP": "",
                            "bingokube.bingosoft.net/businessIP": "",
                            "bingokube.bingosoft.net/ip": "10.203.52.103",
                            "bingokube.bingosoft.net/managed-by": "bcs",
                            "bingokube.bingosoft.net/oversoldratio-cpu": "2.5",
                            "bingokube.bingosoft.net/pool": "master-pool",
                            "kubernetes.io/arch": "amd64",
                            "kubernetes.io/hostname": "10.203.52.103",
                            "kubernetes.io/os": "linux",
                            "node-role.kubernetes.io/control-plane": "",
                            "node-role.kubernetes.io/master": "",
                            "node.kubernetes.io/exclude-from-external-load-balancers": ""
                        },
                        "annotations": {
                            "csi.volume.kubernetes.io/nodeid": "{\"bcs.csi.local.com\":\"10.203.52.103\",\"bcs.csi.share.com\":\"10.203.52.103\",\"com.nfs.csi.hps\":\"10.203.52.103|10.203.52.103\",\"iscsi.csi.bingo-hps.com\":\"host-cde4b9ce-9f58-426d-861d-6995e7d3436d|iqn.2012-01.com.openeuler:7041625d186854c\"}",
                            "kubeadm.alpha.kubernetes.io/cri-socket": "unix:///run/containerd/containerd.sock",
                            "node.alpha.kubernetes.io/ttl": "0",
                            "pre-oversold-cpu-allocatable": "62750m",
                            "pre-oversold-memory-allocatable": "108506128Ki",
                            "volumes.kubernetes.io/controller-managed-attach-detach": "true"
                        },
                        "managedFields": [
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:24:42Z",
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
                                    }
                                }
                            },
                            {
                                "manager": "kubeadm",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:24:45Z",
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
                                "time": "2025-06-09T07:26:34Z",
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
                                            "v:\"172.20.2.0/24\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:28:56Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/pool": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bhci-kube-plugin",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-06T07:38:20Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:bingokube.bingosoft.net/managed-by": {},
                                            "f:bingokube.bingosoft.net/oversoldratio-cpu": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-06T07:38:34Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:csi.volume.kubernetes.io/nodeid": {}
                                        }
                                    },
                                    "f:status": {
                                        "f:allocatable": {
                                            "f:cpu": {},
                                            "f:ephemeral-storage": {}
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
                                        "f:images": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "podCIDR": "172.20.2.0/24",
                        "podCIDRs": [
                            "172.20.2.0/24"
                        ]
                    },
                    "status": {
                        "capacity": {
                            "cpu": "64",
                            "ephemeral-storage": "258882884Ki",
                            "hugepages-1Gi": "19Gi",
                            "hugepages-2Mi": "0",
                            "memory": "131574800Ki",
                            "pods": "110"
                        },
                        "allocatable": {
                            "cpu": "156875m",
                            "ephemeral-storage": "253640004Ki",
                            "hugepages-1Gi": "19Gi",
                            "hugepages-2Mi": "0",
                            "memory": "108506128Ki",
                            "pods": "110"
                        },
                        "conditions": [
                            {
                                "type": "MemoryPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:53Z",
                                "lastTransitionTime": "2025-06-09T07:24:41Z",
                                "reason": "KubeletHasSufficientMemory",
                                "message": "kubelet has sufficient memory available"
                            },
                            {
                                "type": "DiskPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:53Z",
                                "lastTransitionTime": "2025-06-09T07:24:41Z",
                                "reason": "KubeletHasNoDiskPressure",
                                "message": "kubelet has no disk pressure"
                            },
                            {
                                "type": "PIDPressure",
                                "status": "False",
                                "lastHeartbeatTime": "2025-09-18T03:45:53Z",
                                "lastTransitionTime": "2025-06-09T07:24:41Z",
                                "reason": "KubeletHasSufficientPID",
                                "message": "kubelet has sufficient PID available"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastHeartbeatTime": "2025-09-18T03:45:53Z",
                                "lastTransitionTime": "2025-06-09T07:26:34Z",
                                "reason": "KubeletReady",
                                "message": "kubelet is posting ready status. AppArmor enabled"
                            }
                        ],
                        "addresses": [
                            {
                                "type": "InternalIP",
                                "address": "10.203.52.103"
                            },
                            {
                                "type": "Hostname",
                                "address": "10.203.52.103"
                            }
                        ],
                        "daemonEndpoints": {
                            "kubeletEndpoint": {
                                "Port": 10250
                            }
                        },
                        "nodeInfo": {
                            "machineID": "48261beec8dd4725b11c42133b0a1206",
                            "systemUUID": "2cb6be56-24a5-8829-ea11-e90654afc429",
                            "bootID": "25583a67-913a-47b2-9d08-51e8689f5201",
                            "kernelVersion": "5.10.0-136.12.0.86.oe2203sp1.x86_64",
                            "osImage": "Linux",
                            "containerRuntimeVersion": "containerd://1.7.19",
                            "kubeletVersion": "v1.22.26-tenant",
                            "kubeProxyVersion": "v1.22.26-tenant",
                            "operatingSystem": "linux",
                            "architecture": "amd64"
                        },
                        "images": [
                            {
                                "names": [
                                    "registry.bingosoft.net/aiinfra/open-webui@sha256:3aee4a0c0ddfcbd944d3fcc56f8a206bcff48ae5c1f36e374858983a3ff624ce",
                                    "registry.bingosoft.net/aiinfra/open-webui:main"
                                ],
                                "sizeBytes": 1565733855
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/ollama@sha256:2724e50aa475cdc6002f5346df8597aef07b3537b36375b7f8296102fd239455",
                                    "registry.bingosoft.net/library/ollama:latest"
                                ],
                                "sizeBytes": 1169893042
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-api@sha256:782c7b78f2df2d870ef15a8e86a92e50b079054b9e668c9003a44b9a2052e958",
                                    "registry.bingosoft.net/langgenius/dify-api:1.5.0"
                                ],
                                "sizeBytes": 585692516
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/fuse-iam-sso@sha256:f28727d1bb3fec27307f59308ee9224a9177dfc57a68f16bb2dc0d5acd6ab136",
                                    "registry.kube.io:5000/bingofuse/fuse-iam-sso:5.3.16-0801"
                                ],
                                "sizeBytes": 480209974
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingofuse/services@sha256:4dba93f10c6f7ed8a8ee1b3e2179f4fbaf8bafcac10a6ecfece673d993a0251d",
                                    "registry.kube.io:5000/bingofuse/services:5.3.16-0801"
                                ],
                                "sizeBytes": 473384429
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin@sha256:2993b2e6c6e2ff02693356f31c1af37438aa1337c063cfafc1e08f0bd7ba3047",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin:v10.3.0"
                                ],
                                "sizeBytes": 258471721
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/mysql@sha256:9c5c5a9f944a44333dd22a819667351d6e904fdba03c48bf28bb775b9004410f",
                                    "registry.bingosoft.net/library/mysql:latest"
                                ],
                                "sizeBytes": 258115407
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi@sha256:13a71bcb1fcd59a2e367ed1af511db07d0678af7996ab1d559a54fe38bfc34ec",
                                    "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi:3.3.000.8"
                                ],
                                "sizeBytes": 216031909
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs@sha256:46c3e3c64ac4d92bf70af77812a7b33fb67a7d3da8ae455e1830fb6693b0b38f",
                                    "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs:3.1.000.0"
                                ],
                                "sizeBytes": 201878729
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-sandbox@sha256:a1f6212ca39754fcec0fecaba178412f331d1c09432de31976e9d21769947a59",
                                    "registry.bingosoft.net/langgenius/dify-sandbox:0.2.12"
                                ],
                                "sizeBytes": 189518007
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/dify-web@sha256:90bfe00d908e5340d285dfa857c796d2b10a06584d9e10c71a823b63a9fff9d0",
                                    "registry.bingosoft.net/langgenius/dify-web:1.6.0"
                                ],
                                "sizeBytes": 176144026
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/mysql@sha256:b9d83f264411d672901398cc3186975f51c189edcc10aa1fd36763d6ff6c0818",
                                    "registry.bingosoft.net/ragflow/mysql:8.0.39"
                                ],
                                "sizeBytes": 167086189
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                                    "registry.bingosoft.net/n9n/categraf:latest"
                                ],
                                "sizeBytes": 151804132
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/trivy-adapter-photon@sha256:e2051f7e78011b5a1fa70d17aba123506b9a79ec894d5f50563e3844035abfa6",
                                    "registry.kube.io:5000/goharbor/trivy-adapter-photon:v2.7.2"
                                ],
                                "sizeBytes": 134271644
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179",
                                    "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1"
                                ],
                                "sizeBytes": 109319279
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74",
                                    "registry.bingosoft.net/langgenius/postgres:15-alpine"
                                ],
                                "sizeBytes": 108679902
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/prometheus@sha256:69961df6ffa67598048a31aa2822d61f3c93b91d7db24e44d9bb03f99d520da9",
                                    "registry.bingosoft.net/n9n/prometheus:v2.54.1"
                                ],
                                "sizeBytes": 108261050
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-jobservice@sha256:6c898c099f417792f92042a9e34d2f5a865398e6c96154c4211aba0530b6d054",
                                    "registry.kube.io:5000/goharbor/harbor-jobservice:v2.7.2"
                                ],
                                "sizeBytes": 105525495
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-nvs@sha256:2b40e4db23a798ee875205f8e6c53c1810117806b519a35fa3d96ef23602dd5f",
                                    "registry.kube.io:5000/bingokube/kube-nvs:v1.7.0-master"
                                ],
                                "sizeBytes": 102116015
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                                    "registry.kube.io:5000/bingokube/etcd:3.5.1-0"
                                ],
                                "sizeBytes": 98887658
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/chartmuseum-photon@sha256:c11dcf689d57897bfeb4a26d91374d6768297ddd87ab1d4c43838f46574d4b31",
                                    "registry.kube.io:5000/goharbor/chartmuseum-photon:v2.7.2"
                                ],
                                "sizeBytes": 93796147
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/grafana/grafana@sha256:f36dc3966cb3a0771330b699b5fce7ab4e37caba6a5403558f9f77476a5cb0a2",
                                    "registry.kube.io:5000/bingokube/grafana/grafana:v10.0.3"
                                ],
                                "sizeBytes": 93700920
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/squid@sha256:5e38ddd70a852967dea05c5f1d9c21ee0fe37d05c05ebecf883945cfb6827514",
                                    "registry.bingosoft.net/langgenius/squid:latest"
                                ],
                                "sizeBytes": 86951558
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/n9n/nightingale@sha256:9a5e0e8793e213715e102e245d054f749be258878b3b37d22602dfd9f4fcea3e",
                                    "registry.bingosoft.net/n9n/nightingale:8.0.0"
                                ],
                                "sizeBytes": 86718660
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/percona-xtradb-cluster-operator@sha256:8305f55e485d6899ced1b640c9aeb84bc325d83019c841d68593085227617e05",
                                    "registry.bingosoft.net/library/percona-xtradb-cluster-operator:1.17.0"
                                ],
                                "sizeBytes": 86638448
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/karpor/karpor@sha256:e0185a50d4869f2290fa94749de335a9c7da66642674992787309467d2262a92",
                                    "registry.bingosoft.net/karpor/karpor:v0.6.4"
                                ],
                                "sizeBytes": 83004609
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/webkubectl@sha256:efb633d3af74a035b7fb73299e900d9d6dda808cb7879f909864953fb655ea09",
                                    "registry.kube.io:5000/bingokube/webkubectl:v2.10.4-simple"
                                ],
                                "sizeBytes": 82433507
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/harbor-core@sha256:9c06b0a80cf8f201ca9e57077e4116ccc466e90cca352eb9f17ccff89810fcae",
                                    "registry.kube.io:5000/goharbor/harbor-core:v2.7.2"
                                ],
                                "sizeBytes": 74619791
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/grafana/promtail@sha256:5283bb0a808a9250aad6506ba8aa923199f432c2f1bb66b707239c0977b2be0f",
                                    "registry.kube.io:5000/bingokube/grafana/promtail:2.8.3"
                                ],
                                "sizeBytes": 74438865
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/langgenius/nginx@sha256:1fdc65e25b1aa5ec3774c6226f5cf2d537c83bf42cf8ed679554489bfda6c385",
                                    "registry.bingosoft.net/langgenius/nginx:latest"
                                ],
                                "sizeBytes": 73002548
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/searxng@sha256:eaf5346bb12ab279b5fd4b3240d7ba6d2079964412dead5b6e14dc99dbfe50ce",
                                    "registry.bingosoft.net/library/searxng:latest"
                                ],
                                "sizeBytes": 62375021
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/kubesphere/ks-console@sha256:08586c13d50f8f77b6175e37c123e0f3c4c3676b8dea39bae79fbc4cdbb5eec2",
                                    "registry.bingosoft.net/kubesphere/ks-console:v4.1.3"
                                ],
                                "sizeBytes": 59827331
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/minio@sha256:da4eb11317533bf5578af2a3be9f111df3106adccd241b96fdd1d3331245fefc",
                                    "registry.bingosoft.net/ragflow/minio:RELEASE.2023-12-20T01-00-02Z"
                                ],
                                "sizeBytes": 52544929
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/redis-photon@sha256:e5c30ec7643cda92e305ec5adfc24d2aca9779ac682081559a0f2747da8d39e7",
                                    "registry.kube.io:5000/goharbor/redis-photon:v2.7.3"
                                ],
                                "sizeBytes": 50846179
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin@sha256:e5eedf07ec5c7717619d986a18fa426bec58f71de9aba245ab498a05c5658409",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin:v10.3.0"
                                ],
                                "sizeBytes": 50466677
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721",
                                    "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513"
                                ],
                                "sizeBytes": 50111640
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/notary-server-photon@sha256:08120d1ff7ffdd4745a54b3a0d43c98f8bad026481f0ed2caaec3dab8df0204c",
                                    "registry.kube.io:5000/goharbor/notary-server-photon:v2.7.2"
                                ],
                                "sizeBytes": 47635213
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/goharbor/notary-signer-photon@sha256:aa5b93dc1abb6803d07fe47305311f9707fd55226823d1362fb70fb89630cd09",
                                    "registry.kube.io:5000/goharbor/notary-signer-photon:v2.7.2"
                                ],
                                "sizeBytes": 46660723
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/library/backup-kube@sha256:7f6b48914a429fdd45a5b0d501f99306abcca027ef8ac8ce6069a0c5a3bfc24d",
                                    "registry.kube.io:5000/bingokube/backup-kube@sha256:b532ae455193774054b63f62fc7a7511afa51ff908ad0fb9926a4e98d28d88cf",
                                    "registry.bingosoft.net/library/backup-kube:v1.0.1",
                                    "registry.kube.io:5000/bingokube/backup-kube:v1.0.1"
                                ],
                                "sizeBytes": 44749134
                            },
                            {
                                "names": [
                                    "registry.bingosoft.net/ragflow/valkey@sha256:9c68645ea5cc5300aea98dfe8a32e2bf000fb249c698917f9c8c23fe6a61c787",
                                    "registry.bingosoft.net/ragflow/valkey:8"
                                ],
                                "sizeBytes": 44598407
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452",
                                    "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509"
                                ],
                                "sizeBytes": 40510378
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/opbox@sha256:ddf6b8e1ca80587c80a73cb10768712081d27b767aa6395964a82c558eb5fc50",
                                    "registry.kube.io:5000/bingokube/opbox:v1.2"
                                ],
                                "sizeBytes": 38151207
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-proxy@sha256:7a66ac5a34b4ce76da029148c8842e947c7f1c35530d6f7af5d21ba1b9ed8491",
                                    "registry.kube.io:5000/bingokube/kube-proxy:v1.22.26-tenant"
                                ],
                                "sizeBytes": 35953948
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler@sha256:72ea514aebbbf37c41b75decfa279c4f8fb3a97a3f0170df26f21eafd9d6b2d5",
                                    "registry.kube.io:5000/bingokube/bingokube-scheduler:v1.22.26"
                                ],
                                "sizeBytes": 34537670
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480",
                                    "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant"
                                ],
                                "sizeBytes": 31351143
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubedupont-webhook@sha256:0e8a4e2626af666bc70709b012ccdd562550526e92a4235dd0ba899733003fd0",
                                    "registry.kube.io:5000/bingokube/kubedupont-webhook:release-bcs-20250509"
                                ],
                                "sizeBytes": 30072682
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/registry-monitor@sha256:271f9ce3ed539a6ab235f9e5f54ccfc07da5a07822a14e8438ddb5556613a4a9",
                                    "registry.kube.io:5000/bingokube/registry-monitor:v0.2.2"
                                ],
                                "sizeBytes": 29959461
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kube-controller-manager@sha256:9cc7739052dae1389c2d4c75e51432659b9d990d631fd5d5391a64e2d7239c9c",
                                    "registry.kube.io:5000/bingokube/kube-controller-manager:v1.22.26-tenant"
                                ],
                                "sizeBytes": 29825285
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/kubealived@sha256:18c41189e79194561aa4ce9390617892727edc4abe94ac6014cfded2c4d5f5dc",
                                    "registry.kube.io:5000/bingokube/kubealived:v1.0.3"
                                ],
                                "sizeBytes": 27867730
                            },
                            {
                                "names": [
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/sig-storage/csi-attacher@sha256:e1a6ade6739022b966cef07ca6359f4cc25d44ee9136fbb36f8bc57053b3af1b",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/sig-storage/csi-attacher@sha256:e1a6ade6739022b966cef07ca6359f4cc25d44ee9136fbb36f8bc57053b3af1b",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/sig-storage/csi-attacher:v4.5.0",
                                    "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/sig-storage/csi-attacher:v4.5.0"
                                ],
                                "sizeBytes": 27211491
                            }
                        ]
                    }
                }
            }
        ],
        "count": 3
    }
}
```

节点-信息

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/node/10.203.52.101
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "role": "Master",
        "nodeStatus": "",
        "nodePhase": [
            "Ready"
        ],
        "resourcePoolName": "master资源池",
        "nodeResource": {
            "name": "10.203.52.101",
            "allocatableResource": {
                "cpu": 156.875,
                "usageCPU": 25.12,
                "memory": 118.48040008544922,
                "usageMemory": 33.1203125,
                "pod": 110,
                "usagePod": 52
            },
            "physicalResource": {
                "cpu": 64,
                "usageCPU": 11.073,
                "memory": 125.48040008544922,
                "usageMemory": 97.71476364135742
            },
            "reservedResource": {
                "systemReservedCPU": 1,
                "systemReservedMemory": 6,
                "kubeReservedCPU": "250m",
                "kubeReservedMemory": "512Mi",
                "evictionHardMemory": "512Mi",
                "evictionHardNodeFs": "5Gi"
            }
        },
        "node": {
            "kind": "Node",
            "apiVersion": "v1",
            "metadata": {
                "name": "10.203.52.101",
                "uid": "56b65f4e-a7f3-468d-81ff-b62eca9f3ae0",
                "resourceVersion": "58500617",
                "creationTimestamp": "2025-06-09T07:23:19Z",
                "labels": {
                    "beta.kubernetes.io/arch": "amd64",
                    "beta.kubernetes.io/os": "linux",
                    "bingokube.bingosoft.net/managed-by": "bcs",
                    "bingokube.bingosoft.net/oversoldratio-cpu": "2.5",
                    "bingokube.bingosoft.net/pool": "master-pool",
                    "kubernetes.io/arch": "amd64",
                    "kubernetes.io/hostname": "10.203.52.101",
                    "kubernetes.io/os": "linux",
                    "node-role.kubernetes.io/control-plane": "",
                    "node-role.kubernetes.io/master": "",
                    "node.kubernetes.io/exclude-from-external-load-balancers": ""
                },
                "annotations": {
                    "csi.volume.kubernetes.io/nodeid": "{\"bcs.csi.local.com\":\"10.203.52.101\",\"bcs.csi.share.com\":\"10.203.52.101\",\"com.nfs.csi.hps\":\"10.203.52.101|10.203.52.101\",\"iscsi.csi.bingo-hps.com\":\"host-8daccfc6-b1c7-4f5e-b4f9-97da09de3d78|iqn.2012-01.com.openeuler:90f55a8efb13d384\"}",
                    "kubeadm.alpha.kubernetes.io/cri-socket": "/run/containerd/containerd.sock",
                    "node.alpha.kubernetes.io/ttl": "0",
                    "pre-oversold-cpu-allocatable": "62750m",
                    "pre-oversold-memory-allocatable": "124235704Ki",
                    "volumes.kubernetes.io/controller-managed-attach-detach": "true"
                },
                "managedFields": [
                    {
                        "manager": "kubelet",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-06-09T07:23:19Z",
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
                            }
                        }
                    },
                    {
                        "manager": "kubeadm",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-06-09T07:23:20Z",
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
                        "manager": "kubedupont-controller",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-06-09T07:28:57Z",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:labels": {
                                    "f:bingokube.bingosoft.net/pool": {}
                                }
                            }
                        }
                    },
                    {
                        "manager": "bhci-kube-plugin",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-08-06T07:38:20Z",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:labels": {
                                    "f:bingokube.bingosoft.net/managed-by": {},
                                    "f:bingokube.bingosoft.net/oversoldratio-cpu": {}
                                }
                            }
                        }
                    },
                    {
                        "manager": "kubelet",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-08-10T23:00:12Z",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:annotations": {
                                    "f:csi.volume.kubernetes.io/nodeid": {}
                                }
                            },
                            "f:status": {
                                "f:allocatable": {
                                    "f:cpu": {},
                                    "f:ephemeral-storage": {}
                                },
                                "f:conditions": {
                                    "k:{\"type\":\"DiskPressure\"}": {
                                        "f:lastHeartbeatTime": {},
                                        "f:lastTransitionTime": {},
                                        "f:message": {},
                                        "f:reason": {},
                                        "f:status": {}
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
                                "f:images": {}
                            }
                        },
                        "subresource": "status"
                    },
                    {
                        "manager": "kube-controller-manager",
                        "operation": "Update",
                        "apiVersion": "v1",
                        "time": "2025-09-15T09:35:55Z",
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
                                    "v:\"172.20.0.0/24\"": {}
                                }
                            }
                        }
                    }
                ]
            },
            "spec": {
                "podCIDR": "172.20.0.0/24",
                "podCIDRs": [
                    "172.20.0.0/24"
                ]
            },
            "status": {
                "capacity": {
                    "cpu": "64",
                    "ephemeral-storage": "258882884Ki",
                    "hugepages-1Gi": "4Gi",
                    "hugepages-2Mi": "0",
                    "memory": "131575736Ki",
                    "pods": "110"
                },
                "allocatable": {
                    "cpu": "156875m",
                    "ephemeral-storage": "253640004Ki",
                    "hugepages-1Gi": "4Gi",
                    "hugepages-2Mi": "0",
                    "memory": "124235704Ki",
                    "pods": "110"
                },
                "conditions": [
                    {
                        "type": "MemoryPressure",
                        "status": "False",
                        "lastHeartbeatTime": "2025-09-18T03:48:34Z",
                        "lastTransitionTime": "2025-06-09T07:23:19Z",
                        "reason": "KubeletHasSufficientMemory",
                        "message": "kubelet has sufficient memory available"
                    },
                    {
                        "type": "DiskPressure",
                        "status": "False",
                        "lastHeartbeatTime": "2025-09-18T03:48:34Z",
                        "lastTransitionTime": "2025-09-15T09:42:50Z",
                        "reason": "KubeletHasNoDiskPressure",
                        "message": "kubelet has no disk pressure"
                    },
                    {
                        "type": "PIDPressure",
                        "status": "False",
                        "lastHeartbeatTime": "2025-09-18T03:48:34Z",
                        "lastTransitionTime": "2025-06-09T07:23:19Z",
                        "reason": "KubeletHasSufficientPID",
                        "message": "kubelet has sufficient PID available"
                    },
                    {
                        "type": "Ready",
                        "status": "True",
                        "lastHeartbeatTime": "2025-09-18T03:48:34Z",
                        "lastTransitionTime": "2025-06-09T07:26:40Z",
                        "reason": "KubeletReady",
                        "message": "kubelet is posting ready status. AppArmor enabled"
                    }
                ],
                "addresses": [
                    {
                        "type": "InternalIP",
                        "address": "10.203.52.101"
                    },
                    {
                        "type": "Hostname",
                        "address": "10.203.52.101"
                    }
                ],
                "daemonEndpoints": {
                    "kubeletEndpoint": {
                        "Port": 10250
                    }
                },
                "nodeInfo": {
                    "machineID": "67beafed95424a92ba49d1f2a54448ae",
                    "systemUUID": "2cd15b45-24a5-a570-ea11-e6064a770a51",
                    "bootID": "1c0f668f-2eed-4ec7-936a-14fc8b5cb37e",
                    "kernelVersion": "5.10.0-136.12.0.86.oe2203sp1.x86_64",
                    "osImage": "Linux",
                    "containerRuntimeVersion": "containerd://1.7.19",
                    "kubeletVersion": "v1.22.26-tenant",
                    "kubeProxyVersion": "v1.22.26-tenant",
                    "operatingSystem": "linux",
                    "architecture": "amd64"
                },
                "images": [
                    {
                        "names": [
                            "registry.bingosoft.net/library/litellm@sha256:e12246bc8432ea5d8f1348b168989a982e6263b0dcba5522f4352d43f81e44e2",
                            "registry.bingosoft.net/library/litellm:main-latest"
                        ],
                        "sizeBytes": 716746162
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingofuse/lcdp-agent-market@sha256:8286c57b35b28330a83b790e484d1b3162aa242197a11a06279c72d2cc7d7e03",
                            "registry.kube.io:5000/bingofuse/lcdp-agent-market:1.0.9"
                        ],
                        "sizeBytes": 489329459
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task@sha256:bc98db261748d22387d4be2a599d5a317a3a8d45b3d51afe30c103ca23051675",
                            "registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task:1.0.9"
                        ],
                        "sizeBytes": 442739310
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/muban/openeuler@sha256:a4d1b1b0639cb75cfdabb340f83066af2c3532aa766c980e50c50418fc9ca9cd",
                            "registry.bingosoft.net/muban/openeuler:22.03-lts-sp3"
                        ],
                        "sizeBytes": 432221764
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin@sha256:2993b2e6c6e2ff02693356f31c1af37438aa1337c063cfafc1e08f0bd7ba3047",
                            "registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin:v10.3.0"
                        ],
                        "sizeBytes": 258471721
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi@sha256:13a71bcb1fcd59a2e367ed1af511db07d0678af7996ab1d559a54fe38bfc34ec",
                            "registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi:3.3.000.8"
                        ],
                        "sizeBytes": 216031909
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs@sha256:46c3e3c64ac4d92bf70af77812a7b33fb67a7d3da8ae455e1830fb6693b0b38f",
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs:3.1.000.0"
                        ],
                        "sizeBytes": 201878729
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/langgenius/dify-web@sha256:90bfe00d908e5340d285dfa857c796d2b10a06584d9e10c71a823b63a9fff9d0",
                            "registry.bingosoft.net/langgenius/dify-web:1.6.0"
                        ],
                        "sizeBytes": 176144026
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingofuse/mysql@sha256:db404edfdc51438cc11c0f29ba0f1d0cb509bb9110d00613ea8036588ec9a68d",
                            "registry.kube.io:5000/bingofuse/mysql:8.0.36"
                        ],
                        "sizeBytes": 174757681
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                            "registry.bingosoft.net/n9n/categraf:latest"
                        ],
                        "sizeBytes": 151804132
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/library/ubuntu@sha256:cc394c2cff7a3137774af9ad6fdcf562f729a180e0d6c10f664b27308878e5fd",
                            "registry.bingosoft.net/library/ubuntu:24.04.aio"
                        ],
                        "sizeBytes": 112462275
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179",
                            "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1"
                        ],
                        "sizeBytes": 109319279
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74",
                            "registry.bingosoft.net/langgenius/postgres:15-alpine"
                        ],
                        "sizeBytes": 108679902
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/harbor-jobservice@sha256:6c898c099f417792f92042a9e34d2f5a865398e6c96154c4211aba0530b6d054",
                            "registry.kube.io:5000/goharbor/harbor-jobservice:v2.7.2"
                        ],
                        "sizeBytes": 105525495
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kube-nvs@sha256:2b40e4db23a798ee875205f8e6c53c1810117806b519a35fa3d96ef23602dd5f",
                            "registry.kube.io:5000/bingokube/kube-nvs:v1.7.0-master"
                        ],
                        "sizeBytes": 102116015
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970",
                            "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                            "registry.kube.io:5000/bingokube/etcd:3.5.1-0"
                        ],
                        "sizeBytes": 98887658
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/harbor-db@sha256:3e18800420c322278bb6860bfa065a1403a569c1a612dbe1ea3b93162b4b7494",
                            "registry.kube.io:5000/goharbor/harbor-db:v2.7.2"
                        ],
                        "sizeBytes": 82628331
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/prometheus/prometheus@sha256:c4819c653616d828ef7d86f96f35c5496b423935d4ee157a7f586ffbe8d7fc42",
                            "registry.kube.io:5000/bingokube/prometheus/prometheus:v2.32.1"
                        ],
                        "sizeBytes": 76757792
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/harbor-core@sha256:9c06b0a80cf8f201ca9e57077e4116ccc466e90cca352eb9f17ccff89810fcae",
                            "registry.kube.io:5000/goharbor/harbor-core:v2.7.2"
                        ],
                        "sizeBytes": 74619791
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/grafana/promtail@sha256:5283bb0a808a9250aad6506ba8aa923199f432c2f1bb66b707239c0977b2be0f",
                            "registry.kube.io:5000/bingokube/grafana/promtail:2.8.3"
                        ],
                        "sizeBytes": 74438865
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/kubesphere/ks-controller-manager@sha256:eec405fb60a28d1db5d1dd9696173d4314344dc3a4f76606707f5627a3e77a3c",
                            "registry.bingosoft.net/kubesphere/ks-controller-manager:v4.1.3"
                        ],
                        "sizeBytes": 60924656
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/harbor-portal@sha256:740c36eeef08de32bd4ee9c48ebb363833af7d619f9463b270af35c028aef4ce",
                            "registry.kube.io:5000/goharbor/harbor-portal:v2.7.2"
                        ],
                        "sizeBytes": 51650184
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/redis-photon@sha256:e5c30ec7643cda92e305ec5adfc24d2aca9779ac682081559a0f2747da8d39e7",
                            "registry.kube.io:5000/goharbor/redis-photon:v2.7.3"
                        ],
                        "sizeBytes": 50846179
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin@sha256:e5eedf07ec5c7717619d986a18fa426bec58f71de9aba245ab498a05c5658409",
                            "registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin:v10.3.0"
                        ],
                        "sizeBytes": 50466677
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721",
                            "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513"
                        ],
                        "sizeBytes": 50111640
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/goharbor/notary-server-photon@sha256:08120d1ff7ffdd4745a54b3a0d43c98f8bad026481f0ed2caaec3dab8df0204c",
                            "registry.kube.io:5000/goharbor/notary-server-photon:v2.7.2"
                        ],
                        "sizeBytes": 47635213
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/backup-kube@sha256:b532ae455193774054b63f62fc7a7511afa51ff908ad0fb9926a4e98d28d88cf",
                            "registry.kube.io:5000/bingokube/backup-kube:v1.0.1"
                        ],
                        "sizeBytes": 44749134
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452",
                            "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509"
                        ],
                        "sizeBytes": 40510378
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/bcs3@sha256:81717ff7eaec682cc205eb68e2f51999ec1ed3997e2267cf162add947053fb0c",
                            "registry.kube.io:5000/bingokube/bcs3:v1.0"
                        ],
                        "sizeBytes": 37005947
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/bingokube-scheduler@sha256:72ea514aebbbf37c41b75decfa279c4f8fb3a97a3f0170df26f21eafd9d6b2d5",
                            "registry.kube.io:5000/bingokube/bingokube-scheduler:v1.22.26"
                        ],
                        "sizeBytes": 34537670
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/metrics-server@sha256:9d520b7152c89bdf1cdb01fe75ef7d7536a98b2af2055be1edc8a2397e1b6a3a",
                            "registry.kube.io:5000/bingokube/metrics-server:v0.6.3"
                        ],
                        "sizeBytes": 31879654
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480",
                            "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant"
                        ],
                        "sizeBytes": 31351143
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kubedupont-webhook@sha256:0e8a4e2626af666bc70709b012ccdd562550526e92a4235dd0ba899733003fd0",
                            "registry.kube.io:5000/bingokube/kubedupont-webhook:release-bcs-20250509"
                        ],
                        "sizeBytes": 30072682
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/registry-monitor@sha256:271f9ce3ed539a6ab235f9e5f54ccfc07da5a07822a14e8438ddb5556613a4a9",
                            "registry.kube.io:5000/bingokube/registry-monitor:v0.2.2"
                        ],
                        "sizeBytes": 29959461
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kube-controller-manager@sha256:9cc7739052dae1389c2d4c75e51432659b9d990d631fd5d5391a64e2d7239c9c",
                            "registry.kube.io:5000/bingokube/kube-controller-manager:v1.22.26-tenant"
                        ],
                        "sizeBytes": 29825285
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner@sha256:ec09720add0b83d9deec6b53bc56e74c6fd7130bedce81d0c0c03d6ea5092013",
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner:v3.5.0"
                        ],
                        "sizeBytes": 28210010
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kubealived@sha256:18c41189e79194561aa4ce9390617892727edc4abe94ac6014cfded2c4d5f5dc",
                            "registry.kube.io:5000/bingokube/kubealived:v1.0.3"
                        ],
                        "sizeBytes": 27867730
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/kubeverse-front@sha256:db411c48c3e65dc9f323b056b2b373755e12aaedfe661a5a41d6089170d4f275",
                            "registry.kube.io:5000/bingokube/kubeverse-front:release-v1.7.0-20250514"
                        ],
                        "sizeBytes": 26733665
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher@sha256:feaf439c5a6b410e9f68275c6ea4e147d94d696d6bf6f3c883817291ebcbbafa",
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher:v4.3.0"
                        ],
                        "sizeBytes": 26211837
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/agent-side@sha256:92a1af076da73fc7b3efee3e5b609cb12e50c8b493d903e575079fac9f7ad172",
                            "registry.kube.io:5000/bingokube/agent-side:1.1.1"
                        ],
                        "sizeBytes": 23454100
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/grafana/loki@sha256:404c49c7315c7973d5f4744bd5f515e9ef29eb3a4584d6c7c2895feeb73dc31f",
                            "registry.kube.io:5000/bingokube/grafana/loki:v2.8.3"
                        ],
                        "sizeBytes": 22425176
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/langgenius/weaviate@sha256:3cab0765b9cbea1692ab261febebcd987f63122720aa301f9c2b8ef3ed5087e3",
                            "registry.bingosoft.net/langgenius/weaviate:1.19.0"
                        ],
                        "sizeBytes": 20095599
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher@sha256:b1d324a973a21d5c1ac2de009654bae8b9c320e57cd78450bdfc88f8a2a9d42b",
                            "registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher:v3.0.0"
                        ],
                        "sizeBytes": 19192181
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter@sha256:bce65196d5ee635b44f1abf75325d1b6a1bfc204dd8853e69a643e373dc3d827",
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter:v3.0.3"
                        ],
                        "sizeBytes": 19139479
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer@sha256:6b7aa36a1aed873ec1e4f4e1622371a01f60d0c0ed109285004a2c45b48cdab7",
                            "registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer:v1.0.0"
                        ],
                        "sizeBytes": 17753800
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/cert-manager-controller@sha256:e24bbe9dd6dce08bd55d8afffd0e29680d2dad8f7951e43c36aecfba730a1bd3",
                            "registry.kube.io:5000/bingokube/cert-manager-controller:v1.10.1"
                        ],
                        "sizeBytes": 17739790
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller@sha256:d439eb7b37f0c50297a6defa5eb7b75e909078dcf63b42f2e9954002f9a627df",
                            "registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller:v3.0.3"
                        ],
                        "sizeBytes": 17145967
                    },
                    {
                        "names": [
                            "registry.bingosoft.net/langgenius/redis@sha256:915aa8d4cd87b7469f440afc4f74afa9535d07ebafee17fd1f9b76800d2c0640",
                            "registry.bingosoft.net/langgenius/redis:6-alpine"
                        ],
                        "sizeBytes": 14651370
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/cert-manager-webhook@sha256:a4acfcf191b72159456c3a8a929fee662140b4139fc15dd6ed171b2a8ae3144e",
                            "registry.kube.io:5000/bingokube/cert-manager-webhook:v1.10.1"
                        ],
                        "sizeBytes": 13726565
                    },
                    {
                        "names": [
                            "registry.kube.io:5000/bingokube/cert-manager-cainjector@sha256:66898628ce06f33989b95685148ab1c724f92b1efa32a7e7a08ceac217987252",
                            "registry.kube.io:5000/bingokube/cert-manager-cainjector:v1.10.1"
                        ],
                        "sizeBytes": 12200644
                    }
                ]
            }
        }
    }
}
```

Pod资源使用Top5, 通过排序和分页实现

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/pods?page=1&pageSize=5&orderBy=UsageCPU&ascending=false&isGetResource=1&fields=metadata.namespace%21%3Dkube-backup,spec.nodeName%3D10.203.52.101
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "928154969n",
                "quantityUsageMemory": "974304Ki",
                "usageCPU": 0.929,
                "usageMemory": 0.929168701171875,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0.25,
                    "memory": 0,
                    "quantityCPU": "250m",
                    "quantityMemory": "0"
                },
                "Name": "kube-apiserver-10.203.52.101",
                "CreationTimestamp": "2025-06-09T07:23:23Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "kube-apiserver-10.203.52.101",
                        "namespace": "kube-system",
                        "uid": "685b5bb9-42cb-4136-9f04-2dc19cd76ee7",
                        "resourceVersion": "51899563",
                        "creationTimestamp": "2025-06-09T07:23:23Z",
                        "labels": {
                            "component": "kube-apiserver",
                            "tier": "control-plane"
                        },
                        "annotations": {
                            "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint": "10.203.52.101:6443",
                            "kubernetes.io/config.hash": "d273d95d486c90b4ac26e3b6bbbab5ff",
                            "kubernetes.io/config.mirror": "d273d95d486c90b4ac26e3b6bbbab5ff",
                            "kubernetes.io/config.seen": "2025-06-09T15:23:22.307656976+08:00",
                            "kubernetes.io/config.source": "file",
                            "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "v1",
                                "kind": "Node",
                                "name": "10.203.52.101",
                                "uid": "56b65f4e-a7f3-468d-81ff-b62eca9f3ae0",
                                "controller": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-09T07:23:23Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint": {},
                                            "f:kubernetes.io/config.hash": {},
                                            "f:kubernetes.io/config.mirror": {},
                                            "f:kubernetes.io/config.seen": {},
                                            "f:kubernetes.io/config.source": {}
                                        },
                                        "f:labels": {
                                            ".": {},
                                            "f:component": {},
                                            "f:tier": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"56b65f4e-a7f3-468d-81ff-b62eca9f3ae0\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"kube-apiserver\"}": {
                                                ".": {},
                                                "f:command": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:livenessProbe": {
                                                    ".": {},
                                                    "f:failureThreshold": {},
                                                    "f:httpGet": {
                                                        ".": {},
                                                        "f:host": {},
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
                                                "f:readinessProbe": {
                                                    ".": {},
                                                    "f:failureThreshold": {},
                                                    "f:httpGet": {
                                                        ".": {},
                                                        "f:host": {},
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
                                                    "f:requests": {
                                                        ".": {},
                                                        "f:cpu": {}
                                                    }
                                                },
                                                "f:startupProbe": {
                                                    ".": {},
                                                    "f:failureThreshold": {},
                                                    "f:httpGet": {
                                                        ".": {},
                                                        "f:host": {},
                                                        "f:path": {},
                                                        "f:port": {},
                                                        "f:scheme": {}
                                                    },
                                                    "f:initialDelaySeconds": {},
                                                    "f:periodSeconds": {},
                                                    "f:successThreshold": {},
                                                    "f:timeoutSeconds": {}
                                                },
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/etc/kubernetes/admin.conf\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/kubernetes/audit-policy.yml\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/kubernetes/pki\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/pki\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/ssl/certs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/log/kube/audit\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:nodeName": {},
                                        "f:priorityClassName": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {
                                            ".": {},
                                            "f:seccompProfile": {
                                                ".": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"audit-log\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"audit-policy\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"ca-certs\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"etc-pki\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"k8s-certs\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"kubeconfig\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T05:55:32Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            ".": {},
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"PodScheduled\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "audit-log",
                                "hostPath": {
                                    "path": "/var/log/kube/audit",
                                    "type": ""
                                }
                            },
                            {
                                "name": "audit-policy",
                                "hostPath": {
                                    "path": "/etc/kubernetes/audit-policy.yml",
                                    "type": ""
                                }
                            },
                            {
                                "name": "ca-certs",
                                "hostPath": {
                                    "path": "/etc/ssl/certs",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "etc-pki",
                                "hostPath": {
                                    "path": "/etc/pki",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "k8s-certs",
                                "hostPath": {
                                    "path": "/etc/kubernetes/pki",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "kubeconfig",
                                "hostPath": {
                                    "path": "/etc/kubernetes/admin.conf",
                                    "type": ""
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "kube-apiserver",
                                "image": "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant",
                                "command": [
                                    "kube-apiserver",
                                    "--advertise-address=10.203.52.101",
                                    "--allow-privileged=true",
                                    "--audit-log-format=json",
                                    "--audit-log-maxage=3",
                                    "--audit-log-maxbackup=1",
                                    "--audit-log-maxsize=1024",
                                    "--audit-log-path=/var/log/kube/audit/audit.log",
                                    "--audit-policy-file=/etc/kubernetes/audit-policy.yml",
                                    "--authorization-mode=Node,RBAC",
                                    "--client-ca-file=/etc/kubernetes/pki/ca.crt",
                                    "--enable-admission-plugins=NodeRestriction",
                                    "--enable-aggregator-routing=true",
                                    "--enable-bootstrap-token-auth=true",
                                    "--etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt",
                                    "--etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt",
                                    "--etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key",
                                    "--etcd-servers=https://10.203.52.101:2379,https://10.203.52.102:2379,https://10.203.52.103:2379",
                                    "--feature-gates=TTLAfterFinished=true,EphemeralContainers=true",
                                    "--kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt",
                                    "--kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key",
                                    "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
                                    "--proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt",
                                    "--proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key",
                                    "--requestheader-allowed-names=front-proxy-client",
                                    "--requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt",
                                    "--requestheader-extra-headers-prefix=X-Remote-Extra-",
                                    "--requestheader-group-headers=X-Remote-Group",
                                    "--requestheader-username-headers=X-Remote-User",
                                    "--secure-port=6443",
                                    "--service-account-issuer=https://kubernetes.default.svc.cluster.local",
                                    "--service-account-key-file=/etc/kubernetes/pki/sa.pub",
                                    "--service-account-signing-key-file=/etc/kubernetes/pki/sa.key",
                                    "--service-cluster-ip-range=10.96.0.0/16",
                                    "--service-node-port-range=29950-32767",
                                    "--tls-cert-file=/etc/kubernetes/pki/apiserver.crt",
                                    "--tls-private-key-file=/etc/kubernetes/pki/apiserver.key"
                                ],
                                "resources": {
                                    "requests": {
                                        "cpu": "250m"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "audit-log",
                                        "mountPath": "/var/log/kube/audit"
                                    },
                                    {
                                        "name": "audit-policy",
                                        "mountPath": "/etc/kubernetes/audit-policy.yml"
                                    },
                                    {
                                        "name": "ca-certs",
                                        "readOnly": true,
                                        "mountPath": "/etc/ssl/certs"
                                    },
                                    {
                                        "name": "etc-pki",
                                        "readOnly": true,
                                        "mountPath": "/etc/pki"
                                    },
                                    {
                                        "name": "k8s-certs",
                                        "readOnly": true,
                                        "mountPath": "/etc/kubernetes/pki"
                                    },
                                    {
                                        "name": "kubeconfig",
                                        "mountPath": "/etc/kubernetes/admin.conf"
                                    }
                                ],
                                "livenessProbe": {
                                    "httpGet": {
                                        "path": "/livez",
                                        "port": 6443,
                                        "host": "10.203.52.101",
                                        "scheme": "HTTPS"
                                    },
                                    "initialDelaySeconds": 10,
                                    "timeoutSeconds": 15,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 8
                                },
                                "readinessProbe": {
                                    "httpGet": {
                                        "path": "/readyz",
                                        "port": 6443,
                                        "host": "10.203.52.101",
                                        "scheme": "HTTPS"
                                    },
                                    "timeoutSeconds": 15,
                                    "periodSeconds": 1,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "startupProbe": {
                                    "httpGet": {
                                        "path": "/livez",
                                        "port": 6443,
                                        "host": "10.203.52.101",
                                        "scheme": "HTTPS"
                                    },
                                    "initialDelaySeconds": 10,
                                    "timeoutSeconds": 15,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 24
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {
                            "seccompProfile": {
                                "type": "RuntimeDefault"
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "operator": "Exists",
                                "effect": "NoExecute"
                            }
                        ],
                        "priorityClassName": "system-node-critical",
                        "priority": 2000001000,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-09T07:25:30Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T05:55:31Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T05:55:31Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-09T07:25:30Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-06-09T07:25:30Z",
                        "containerStatuses": [
                            {
                                "name": "kube-apiserver",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T05:55:17Z"
                                    }
                                },
                                "lastState": {
                                    "terminated": {
                                        "exitCode": 255,
                                        "reason": "Error",
                                        "startedAt": "2025-09-08T05:52:59Z",
                                        "finishedAt": "2025-09-08T05:55:07Z",
                                        "containerID": "containerd://b72474eb4c2fa84de5aa6134c9a6e252160ffe0bceb007f7c824a1c85b41475d"
                                    }
                                },
                                "ready": true,
                                "restartCount": 121,
                                "image": "registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant",
                                "imageID": "registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480",
                                "containerID": "containerd://5b68e25aa77250677ad80afbff0aa67cc81d80be594c3565c46d48462e41187a",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "197615911n",
                "quantityUsageMemory": "182224Ki",
                "usageCPU": 0.198,
                "usageMemory": 0.1737823486328125,
                "limitResource": {
                    "cpu": 4,
                    "memory": 8,
                    "quantityCPU": "4",
                    "quantityMemory": "8Gi"
                },
                "RequestResource": {
                    "cpu": 4,
                    "memory": 8,
                    "quantityCPU": "4",
                    "quantityMemory": "8Gi"
                },
                "Name": "nightingale8-categraf-v6-5l8cn",
                "CreationTimestamp": "2025-09-15T09:45:09Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "nightingale8-categraf-v6-5l8cn",
                        "generateName": "nightingale8-categraf-v6-",
                        "namespace": "n9n",
                        "uid": "afb45e37-913c-4e2f-9e06-02d5bab1f9ca",
                        "resourceVersion": "56675101",
                        "creationTimestamp": "2025-09-15T09:45:09Z",
                        "labels": {
                            "app": "n9e",
                            "chart": "nightingale",
                            "component": "categraf",
                            "controller-revision-hash": "65479b6d48",
                            "heritage": "Helm",
                            "pod-template-generation": "3",
                            "preemptNodeResource": "10.203.52.101",
                            "release": "nightingale8"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"staticIp\":\"\",\"isDefaultGateway\":true,\"oldStaticIp\":\"\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "nightingale8-categraf-v6",
                                "uid": "75f8a99b-4e99-45c0-9cbc-c0822b212bae",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:45:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:45:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        },
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:chart": {},
                                            "f:component": {},
                                            "f:controller-revision-hash": {},
                                            "f:heritage": {},
                                            "f:pod-template-generation": {},
                                            "f:release": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"75f8a99b-4e99-45c0-9cbc-c0822b212bae\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"HOSTIP\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"HOSTNAME\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"HOST_MOUNT_PREFIX\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"HOST_PROC\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"HOST_SYS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"TZ\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
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
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/config.toml\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:subPath": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.cadvisor\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.cpu\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.disk\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.diskio\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kernel\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kernel_vmstat\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kubernetes\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.linux_sysctl_fs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.mem\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.net\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.netstat\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.processes\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.prometheus\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.system\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/logs.toml\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:subPath": {}
                                                    },
                                                    "k:{\"mountPath\":\"/hostfs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/run/utmp\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"configmap-7sblk8\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-7wmneg\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-aesalv\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-bfjntz\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-ccneut\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-diqkym\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-fc6th1\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-iowlu0\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-jg1s2j\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-lkkewd\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-lqxipw\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-nhf0yt\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-nlath0\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-ps14pj\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-zq3zhc\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"hostpath-i923an\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"hostpath-ts17m3\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:46:52Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "configmap-ccneut",
                                "configMap": {
                                    "name": "categraf-config",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-aesalv",
                                "configMap": {
                                    "name": "input-cpu",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-7wmneg",
                                "configMap": {
                                    "name": "input-mem",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-jg1s2j",
                                "configMap": {
                                    "name": "input-disk",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-7sblk8",
                                "configMap": {
                                    "name": "input-diskio",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-ps14pj",
                                "configMap": {
                                    "name": "input-net",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-diqkym",
                                "configMap": {
                                    "name": "input-netstat",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-fc6th1",
                                "configMap": {
                                    "name": "input-kubernetes",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-zq3zhc",
                                "configMap": {
                                    "name": "input-kubelet-metrics",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-bfjntz",
                                "configMap": {
                                    "name": "input-cadvisor",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-nlath0",
                                "configMap": {
                                    "name": "input-kernel",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-lkkewd",
                                "configMap": {
                                    "name": "input-kernel-vmstat",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-lqxipw",
                                "configMap": {
                                    "name": "input-sysctl-fs",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-iowlu0",
                                "configMap": {
                                    "name": "input-processes",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-nhf0yt",
                                "configMap": {
                                    "name": "input-system",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "hostpath-ts17m3",
                                "hostPath": {
                                    "path": "/var/run/utmp",
                                    "type": ""
                                }
                            },
                            {
                                "name": "hostpath-i923an",
                                "hostPath": {
                                    "path": "/",
                                    "type": ""
                                }
                            },
                            {
                                "name": "kube-api-access-97tgn",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/n9n/categraf:latest",
                                "env": [
                                    {
                                        "name": "TZ",
                                        "value": "Asia/Shanghai"
                                    },
                                    {
                                        "name": "HOSTNAME",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "spec.nodeName"
                                            }
                                        }
                                    },
                                    {
                                        "name": "HOSTIP",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "status.hostIP"
                                            }
                                        }
                                    },
                                    {
                                        "name": "HOST_PROC",
                                        "value": "/hostfs/proc"
                                    },
                                    {
                                        "name": "HOST_SYS",
                                        "value": "/hostfs/sys"
                                    },
                                    {
                                        "name": "HOST_MOUNT_PREFIX",
                                        "value": "/hostfs"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "4",
                                        "memory": "8Gi"
                                    },
                                    "requests": {
                                        "cpu": "4",
                                        "memory": "8Gi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "configmap-ccneut",
                                        "mountPath": "/etc/categraf/conf/config.toml",
                                        "subPath": "config.toml"
                                    },
                                    {
                                        "name": "configmap-ccneut",
                                        "mountPath": "/etc/categraf/conf/logs.toml",
                                        "subPath": "logs.toml"
                                    },
                                    {
                                        "name": "configmap-aesalv",
                                        "mountPath": "/etc/categraf/conf/input.cpu"
                                    },
                                    {
                                        "name": "configmap-7wmneg",
                                        "mountPath": "/etc/categraf/conf/input.mem"
                                    },
                                    {
                                        "name": "configmap-jg1s2j",
                                        "mountPath": "/etc/categraf/conf/input.disk"
                                    },
                                    {
                                        "name": "configmap-7sblk8",
                                        "mountPath": "/etc/categraf/conf/input.diskio"
                                    },
                                    {
                                        "name": "configmap-ps14pj",
                                        "mountPath": "/etc/categraf/conf/input.net"
                                    },
                                    {
                                        "name": "configmap-diqkym",
                                        "mountPath": "/etc/categraf/conf/input.netstat"
                                    },
                                    {
                                        "name": "configmap-fc6th1",
                                        "mountPath": "/etc/categraf/conf/input.kubernetes"
                                    },
                                    {
                                        "name": "configmap-zq3zhc",
                                        "mountPath": "/etc/categraf/conf/input.prometheus"
                                    },
                                    {
                                        "name": "configmap-bfjntz",
                                        "mountPath": "/etc/categraf/conf/input.cadvisor"
                                    },
                                    {
                                        "name": "configmap-nlath0",
                                        "mountPath": "/etc/categraf/conf/input.kernel"
                                    },
                                    {
                                        "name": "configmap-lkkewd",
                                        "mountPath": "/etc/categraf/conf/input.kernel_vmstat"
                                    },
                                    {
                                        "name": "configmap-lqxipw",
                                        "mountPath": "/etc/categraf/conf/input.linux_sysctl_fs"
                                    },
                                    {
                                        "name": "configmap-iowlu0",
                                        "mountPath": "/etc/categraf/conf/input.processes"
                                    },
                                    {
                                        "name": "configmap-nhf0yt",
                                        "mountPath": "/etc/categraf/conf/input.system"
                                    },
                                    {
                                        "name": "hostpath-ts17m3",
                                        "readOnly": true,
                                        "mountPath": "/var/run/utmp"
                                    },
                                    {
                                        "name": "hostpath-i923an",
                                        "readOnly": true,
                                        "mountPath": "/hostfs"
                                    },
                                    {
                                        "name": "kube-api-access-97tgn",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "Always"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirstWithHostNet",
                        "serviceAccountName": "nightingale8-categraf-v6",
                        "serviceAccount": "nightingale8-categraf-v6",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:45:09Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:46:52Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:46:52Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:45:09Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-09-15T09:45:09Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-15T09:46:52Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/n9n/categraf:latest",
                                "imageID": "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                                "containerID": "containerd://885ef7fa3db77b77531f7ea5a2849d0e59486abaa375ed804491d81c0a6767c3",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "121510972n",
                "quantityUsageMemory": "49872Ki",
                "usageCPU": 0.122,
                "usageMemory": 0.0475616455078125,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0.15,
                    "memory": 0.18,
                    "quantityCPU": "150m",
                    "quantityMemory": "180Mi"
                },
                "Name": "node-exporter-cmt5r",
                "CreationTimestamp": "2025-06-13T09:09:59Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "node-exporter-cmt5r",
                        "generateName": "node-exporter-",
                        "namespace": "monitoring",
                        "uid": "6e9b002b-c6a3-44d7-96d5-db2eda137792",
                        "resourceVersion": "1448470",
                        "creationTimestamp": "2025-06-13T09:09:59Z",
                        "labels": {
                            "controller-revision-hash": "5c64fc77f",
                            "name": "node-exporter",
                            "pod-template-generation": "1",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "node-exporter",
                                "uid": "66e5259c-4945-4e45-958e-5ac0d34c6ade",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-13T09:09:59Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:controller-revision-hash": {},
                                            "f:name": {},
                                            "f:pod-template-generation": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"66e5259c-4945-4e45-958e-5ac0d34c6ade\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"node-exporter\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:name": {},
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":9100,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:hostPort": {},
                                                        "f:protocol": {}
                                                    }
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
                                                    "f:privileged": {}
                                                },
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/host/dev\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/host/sys\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/rootfs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostIPC": {},
                                        "f:hostNetwork": {},
                                        "f:hostPID": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"dev\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"rootfs\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"sys\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-13T09:10:08Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-06-13T09:10:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "dev",
                                "hostPath": {
                                    "path": "/dev",
                                    "type": ""
                                }
                            },
                            {
                                "name": "sys",
                                "hostPath": {
                                    "path": "/sys",
                                    "type": ""
                                }
                            },
                            {
                                "name": "rootfs",
                                "hostPath": {
                                    "path": "/",
                                    "type": ""
                                }
                            },
                            {
                                "name": "kube-api-access-nzsgz",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "node-exporter",
                                "image": "registry.kube.io:5000/bingokube/prometheus/node-exporter:v1.3.1",
                                "args": [
                                    "--path.sysfs",
                                    "/host/sys",
                                    "--collector.filesystem.ignored-mount-points=^/(dev|proc|sys|var/lib/docker/.+|var/lib/kubelet/pods/.+)($|/)",
                                    "--collector.netclass.ignored-devices=^(veth.*)$"
                                ],
                                "ports": [
                                    {
                                        "hostPort": 9100,
                                        "containerPort": 9100,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {
                                    "requests": {
                                        "cpu": "150m",
                                        "memory": "180Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "dev",
                                        "mountPath": "/host/dev"
                                    },
                                    {
                                        "name": "sys",
                                        "mountPath": "/host/sys"
                                    },
                                    {
                                        "name": "rootfs",
                                        "mountPath": "/rootfs"
                                    },
                                    {
                                        "name": "kube-api-access-nzsgz",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent",
                                "securityContext": {
                                    "privileged": true
                                }
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "serviceAccountName": "default",
                        "serviceAccount": "default",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "hostPID": true,
                        "hostIPC": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-13T09:10:08Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-13T09:10:09Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-13T09:10:09Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-06-13T09:10:08Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-06-13T09:10:08Z",
                        "containerStatuses": [
                            {
                                "name": "node-exporter",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-06-13T09:10:08Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/prometheus/node-exporter:v1.3.1",
                                "imageID": "registry.kube.io:5000/bingokube/prometheus/node-exporter@sha256:e54dec036f98faa01f8044ccc06d80c92478687633e6a1aeaa27fd88a52fcf04",
                                "containerID": "containerd://6f03f79061452e8d1fcd1931c8ddce890795983f2e59fa53b41efe33a037dcaf",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "107370574n",
                "quantityUsageMemory": "214668Ki",
                "usageCPU": 0.108,
                "usageMemory": 0.20472335815429688,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0.1,
                    "memory": 0.1,
                    "quantityCPU": "100m",
                    "quantityMemory": "100Mi"
                },
                "Name": "etcd-10.203.52.101",
                "CreationTimestamp": "2025-08-29T08:45:15Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "etcd-10.203.52.101",
                        "namespace": "kube-system",
                        "uid": "6a31b47f-d7f0-4083-ac2a-aa73c02e5cec",
                        "resourceVersion": "45395574",
                        "creationTimestamp": "2025-08-29T08:45:15Z",
                        "labels": {
                            "component": "etcd",
                            "tier": "control-plane"
                        },
                        "annotations": {
                            "kubeadm.kubernetes.io/etcd.advertise-client-urls": "https://10.203.52.101:2379",
                            "kubernetes.io/config.hash": "19042861220f062eab98bbffe553498d",
                            "kubernetes.io/config.mirror": "19042861220f062eab98bbffe553498d",
                            "kubernetes.io/config.seen": "2025-08-29T16:45:15.151670576+08:00",
                            "kubernetes.io/config.source": "file",
                            "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "v1",
                                "kind": "Node",
                                "name": "10.203.52.101",
                                "uid": "56b65f4e-a7f3-468d-81ff-b62eca9f3ae0",
                                "controller": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-29T08:45:15Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:kubeadm.kubernetes.io/etcd.advertise-client-urls": {},
                                            "f:kubernetes.io/config.hash": {},
                                            "f:kubernetes.io/config.mirror": {},
                                            "f:kubernetes.io/config.seen": {},
                                            "f:kubernetes.io/config.source": {}
                                        },
                                        "f:labels": {
                                            ".": {},
                                            "f:component": {},
                                            "f:tier": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"56b65f4e-a7f3-468d-81ff-b62eca9f3ae0\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"etcd\"}": {
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
                                                "f:resources": {
                                                    ".": {},
                                                    "f:requests": {
                                                        ".": {},
                                                        "f:cpu": {},
                                                        "f:memory": {}
                                                    }
                                                },
                                                "f:startupProbe": {
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
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/etc/kubernetes/pki/etcd\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/lib/etcd\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:nodeName": {},
                                        "f:priorityClassName": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {
                                            ".": {},
                                            "f:seccompProfile": {
                                                ".": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"etcd-certs\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"etcd-data\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-08-29T08:45:26Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            ".": {},
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"PodScheduled\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "etcd-certs",
                                "hostPath": {
                                    "path": "/etc/kubernetes/pki/etcd",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "etcd-data",
                                "hostPath": {
                                    "path": "/var/lib/etcd",
                                    "type": "DirectoryOrCreate"
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "etcd",
                                "image": "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                                "command": [
                                    "etcd",
                                    "--initial-cluster-state=existing",
                                    "--advertise-client-urls=https://10.203.52.101:2379",
                                    "--cert-file=/etc/kubernetes/pki/etcd/server.crt",
                                    "--client-cert-auth=true",
                                    "--data-dir=/var/lib/etcd",
                                    "--experimental-initial-corrupt-check=true",
                                    "--initial-advertise-peer-urls=https://10.203.52.101:2380",
                                    "--initial-cluster=10.203.52.101=https://10.203.52.101:2380,10.203.52.102=https://10.203.52.102:2380,10.203.52.103=https://10.203.52.103:2380",
                                    "--key-file=/etc/kubernetes/pki/etcd/server.key",
                                    "--listen-client-urls=https://0.0.0.0:2379",
                                    "--listen-metrics-urls=http://0.0.0.0:2381",
                                    "--listen-peer-urls=https://10.203.52.101:2380",
                                    "--name=10.203.52.101",
                                    "--peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt",
                                    "--peer-client-cert-auth=true",
                                    "--peer-key-file=/etc/kubernetes/pki/etcd/peer.key",
                                    "--peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt",
                                    "--snapshot-count=10000",
                                    "--trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt"
                                ],
                                "resources": {
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "100Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "etcd-data",
                                        "mountPath": "/var/lib/etcd"
                                    },
                                    {
                                        "name": "etcd-certs",
                                        "mountPath": "/etc/kubernetes/pki/etcd"
                                    }
                                ],
                                "livenessProbe": {
                                    "httpGet": {
                                        "path": "/health",
                                        "port": 2381,
                                        "scheme": "HTTP"
                                    },
                                    "initialDelaySeconds": 10,
                                    "timeoutSeconds": 15,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 8
                                },
                                "startupProbe": {
                                    "httpGet": {
                                        "path": "/health",
                                        "port": 2381,
                                        "scheme": "HTTP"
                                    },
                                    "initialDelaySeconds": 10,
                                    "timeoutSeconds": 15,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 24
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {
                            "seccompProfile": {
                                "type": "RuntimeDefault"
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "operator": "Exists",
                                "effect": "NoExecute"
                            }
                        ],
                        "priorityClassName": "system-node-critical",
                        "priority": 2000001000,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-08-29T08:45:15Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-08-29T08:45:26Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-08-29T08:45:26Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-08-29T08:45:15Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-08-29T08:45:15Z",
                        "containerStatuses": [
                            {
                                "name": "etcd",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-08-29T08:45:15Z"
                                    }
                                },
                                "lastState": {
                                    "terminated": {
                                        "exitCode": 1,
                                        "reason": "Error",
                                        "startedAt": "2025-08-29T08:44:29Z",
                                        "finishedAt": "2025-08-29T08:44:29Z",
                                        "containerID": "containerd://117a7607b0f42fcaf3877a2878e69705a71f889771d539c544ea83e320a855eb"
                                    }
                                },
                                "ready": true,
                                "restartCount": 2,
                                "image": "registry.kube.io:5000/bingokube/etcd:3.5.0-0",
                                "imageID": "registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970",
                                "containerID": "containerd://682e1a04fd74527c55d83365ae911d32e9ffc94a9eb0b58b452ad704c9b07862",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "99808060n",
                "quantityUsageMemory": "151056Ki",
                "usageCPU": 0.1,
                "usageMemory": 0.1440582275390625,
                "limitResource": {
                    "cpu": 0.1,
                    "memory": 0.15,
                    "quantityCPU": "100m",
                    "quantityMemory": "150Mi"
                },
                "RequestResource": {
                    "cpu": 0.1,
                    "memory": 0.15,
                    "quantityCPU": "100m",
                    "quantityMemory": "150Mi"
                },
                "Name": "kubedupont-controller-manager-t6tpn",
                "CreationTimestamp": "2025-09-08T03:44:29Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "kubedupont-controller-manager-t6tpn",
                        "generateName": "kubedupont-controller-manager-",
                        "namespace": "kube-system",
                        "uid": "4311fb97-cdae-4853-b33e-503a12517ac1",
                        "resourceVersion": "52164935",
                        "creationTimestamp": "2025-09-08T03:44:29Z",
                        "labels": {
                            "control-plane": "kubedupont-controller-manager",
                            "controller-revision-hash": "5fcb6976c6",
                            "pod-template-generation": "3",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "kubedupont-controller-manager",
                                "uid": "75d47e55-950b-483b-a405-16e888f37c2c",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T03:44:29Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T03:44:29Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:control-plane": {},
                                            "f:controller-revision-hash": {},
                                            "f:pod-template-generation": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"75d47e55-950b-483b-a405-16e888f37c2c\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"kubedupont\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:command": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"DeviceType\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"NETWORK_MODEL\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"controllers\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"deployMode\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"leaderelection\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"leaseAnnotations\"}": {
                                                        ".": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"name\":\"leaseduration\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"leasename\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"loglevel\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"namespace\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"nodeName\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"podName\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"port\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"renewdeadline\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"retryperiod\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
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
                                                    "k:{\"mountPath\":\"/etc/kubernetes/pki\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
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
                                            "k:{\"name\":\"etcd-certs\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:25:00Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "etcd-certs",
                                "hostPath": {
                                    "path": "/etc/kubernetes/pki",
                                    "type": "Directory"
                                }
                            },
                            {
                                "name": "kube-api-access-4xhtl",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "kubedupont",
                                "image": "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509",
                                "command": [
                                    "/app/kubedupont-controller"
                                ],
                                "args": [
                                    "--debug=false"
                                ],
                                "env": [
                                    {
                                        "name": "deployMode",
                                        "value": "1"
                                    },
                                    {
                                        "name": "leaderelection",
                                        "value": "true"
                                    },
                                    {
                                        "name": "leasename",
                                        "value": "kubedupont-leader-election"
                                    },
                                    {
                                        "name": "leaseduration",
                                        "value": "15"
                                    },
                                    {
                                        "name": "renewdeadline",
                                        "value": "10"
                                    },
                                    {
                                        "name": "retryperiod",
                                        "value": "2"
                                    },
                                    {
                                        "name": "namespace",
                                        "value": "kube-system"
                                    },
                                    {
                                        "name": "leaseAnnotations"
                                    },
                                    {
                                        "name": "controllers",
                                        "value": "tenant-controller,user-controller,resourcePool-controller,namespaceResourceQuota-controller,service-controller,pod-controller,scaler-controller"
                                    },
                                    {
                                        "name": "port",
                                        "value": "8088"
                                    },
                                    {
                                        "name": "loglevel",
                                        "value": "3"
                                    },
                                    {
                                        "name": "nodeName",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "spec.nodeName"
                                            }
                                        }
                                    },
                                    {
                                        "name": "NETWORK_MODEL",
                                        "value": "kube-nvs"
                                    },
                                    {
                                        "name": "podName",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "metadata.name"
                                            }
                                        }
                                    },
                                    {
                                        "name": "DeviceType",
                                        "value": "BMC"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "100m",
                                        "memory": "150Mi"
                                    },
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "150Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "etcd-certs",
                                        "readOnly": true,
                                        "mountPath": "/etc/kubernetes/pki"
                                    },
                                    {
                                        "name": "kube-api-access-4xhtl",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
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
                            "node-role.kubernetes.io/master": ""
                        },
                        "serviceAccountName": "kubedupont-serviceaccount",
                        "serviceAccount": "kubedupont-serviceaccount",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T03:44:29Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:25:00Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:25:00Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T03:44:29Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-09-08T03:44:29Z",
                        "containerStatuses": [
                            {
                                "name": "kubedupont",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T15:24:59Z"
                                    }
                                },
                                "lastState": {
                                    "terminated": {
                                        "exitCode": 137,
                                        "reason": "OOMKilled",
                                        "startedAt": "2025-09-08T14:31:47Z",
                                        "finishedAt": "2025-09-08T15:24:58Z",
                                        "containerID": "containerd://1d8de718bb22fffaa794c0505e57e658cc4a2210fef5aab0f36731ee425dae67"
                                    }
                                },
                                "ready": true,
                                "restartCount": 8,
                                "image": "registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509",
                                "imageID": "registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452",
                                "containerID": "containerd://594302c1c5c49cade43b2b52d38cd01d6c5c9b80d4954ad1b9b49bfe60c103c2",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            }
        ],
        "count": 71
    }
}
```


查看yaml

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/yaml?kind=Node&name=10.203.52.101

```json
{
    "code": 200,
    "message": "success",
    "data": "apiVersion: v1\nkind: Node\nmetadata:\n  annotations:\n    csi.volume.kubernetes.io/nodeid: '{\"bcs.csi.local.com\":\"10.203.52.101\",\"bcs.csi.share.com\":\"10.203.52.101\",\"com.nfs.csi.hps\":\"10.203.52.101|10.203.52.101\",\"iscsi.csi.bingo-hps.com\":\"host-8daccfc6-b1c7-4f5e-b4f9-97da09de3d78|iqn.2012-01.com.openeuler:90f55a8efb13d384\"}'\n    kubeadm.alpha.kubernetes.io/cri-socket: /run/containerd/containerd.sock\n    node.alpha.kubernetes.io/ttl: \"0\"\n    pre-oversold-cpu-allocatable: 62750m\n    pre-oversold-memory-allocatable: 124235704Ki\n    volumes.kubernetes.io/controller-managed-attach-detach: \"true\"\n  creationTimestamp: \"2025-06-09T07:23:19Z\"\n  labels:\n    beta.kubernetes.io/arch: amd64\n    beta.kubernetes.io/os: linux\n    bingokube.bingosoft.net/managed-by: bcs\n    bingokube.bingosoft.net/oversoldratio-cpu: \"2.5\"\n    bingokube.bingosoft.net/pool: master-pool\n    kubernetes.io/arch: amd64\n    kubernetes.io/hostname: 10.203.52.101\n    kubernetes.io/os: linux\n    node-role.kubernetes.io/control-plane: \"\"\n    node-role.kubernetes.io/master: \"\"\n    node.kubernetes.io/exclude-from-external-load-balancers: \"\"\n  name: 10.203.52.101\n  resourceVersion: \"58503107\"\n  uid: 56b65f4e-a7f3-468d-81ff-b62eca9f3ae0\nspec:\n  podCIDR: 172.20.0.0/24\n  podCIDRs:\n  - 172.20.0.0/24\nstatus:\n  addresses:\n  - address: 10.203.52.101\n    type: InternalIP\n  - address: 10.203.52.101\n    type: Hostname\n  allocatable:\n    cpu: 156875m\n    ephemeral-storage: 253640004Ki\n    hugepages-1Gi: 4Gi\n    hugepages-2Mi: \"0\"\n    memory: 124235704Ki\n    pods: \"110\"\n  capacity:\n    cpu: \"64\"\n    ephemeral-storage: 258882884Ki\n    hugepages-1Gi: 4Gi\n    hugepages-2Mi: \"0\"\n    memory: 131575736Ki\n    pods: \"110\"\n  conditions:\n  - lastHeartbeatTime: \"2025-09-18T03:53:57Z\"\n    lastTransitionTime: \"2025-06-09T07:23:19Z\"\n    message: kubelet has sufficient memory available\n    reason: KubeletHasSufficientMemory\n    status: \"False\"\n    type: MemoryPressure\n  - lastHeartbeatTime: \"2025-09-18T03:53:57Z\"\n    lastTransitionTime: \"2025-09-15T09:42:50Z\"\n    message: kubelet has no disk pressure\n    reason: KubeletHasNoDiskPressure\n    status: \"False\"\n    type: DiskPressure\n  - lastHeartbeatTime: \"2025-09-18T03:53:57Z\"\n    lastTransitionTime: \"2025-06-09T07:23:19Z\"\n    message: kubelet has sufficient PID available\n    reason: KubeletHasSufficientPID\n    status: \"False\"\n    type: PIDPressure\n  - lastHeartbeatTime: \"2025-09-18T03:53:57Z\"\n    lastTransitionTime: \"2025-06-09T07:26:40Z\"\n    message: kubelet is posting ready status. AppArmor enabled\n    reason: KubeletReady\n    status: \"True\"\n    type: Ready\n  daemonEndpoints:\n    kubeletEndpoint:\n      Port: 10250\n  images:\n  - names:\n    - registry.bingosoft.net/library/litellm@sha256:e12246bc8432ea5d8f1348b168989a982e6263b0dcba5522f4352d43f81e44e2\n    - registry.bingosoft.net/library/litellm:main-latest\n    sizeBytes: 716746162\n  - names:\n    - registry.kube.io:5000/bingofuse/lcdp-agent-market@sha256:8286c57b35b28330a83b790e484d1b3162aa242197a11a06279c72d2cc7d7e03\n    - registry.kube.io:5000/bingofuse/lcdp-agent-market:1.0.9\n    sizeBytes: 489329459\n  - names:\n    - registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task@sha256:bc98db261748d22387d4be2a599d5a317a3a8d45b3d51afe30c103ca23051675\n    - registry.kube.io:5000/bingofuse/lcdp-agent-knowledge-task:1.0.9\n    sizeBytes: 442739310\n  - names:\n    - registry.bingosoft.net/muban/openeuler@sha256:a4d1b1b0639cb75cfdabb340f83066af2c3532aa766c980e50c50418fc9ca9cd\n    - registry.bingosoft.net/muban/openeuler:22.03-lts-sp3\n    sizeBytes: 432221764\n  - names:\n    - registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin@sha256:2993b2e6c6e2ff02693356f31c1af37438aa1337c063cfafc1e08f0bd7ba3047\n    - registry.kube.io:5000/bingokube/bcs/csi-bcs-share/hci-share-plugin:v10.3.0\n    sizeBytes: 258471721\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi@sha256:13a71bcb1fcd59a2e367ed1af511db07d0678af7996ab1d559a54fe38bfc34ec\n    - registry.kube.io:5000/bingokube/xsky/iscsi/csi-iscsi:3.3.000.8\n    sizeBytes: 216031909\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs@sha256:46c3e3c64ac4d92bf70af77812a7b33fb67a7d3da8ae455e1830fb6693b0b38f\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-nfs:3.1.000.0\n    sizeBytes: 201878729\n  - names:\n    - registry.bingosoft.net/langgenius/dify-web@sha256:90bfe00d908e5340d285dfa857c796d2b10a06584d9e10c71a823b63a9fff9d0\n    - registry.bingosoft.net/langgenius/dify-web:1.6.0\n    sizeBytes: 176144026\n  - names:\n    - registry.kube.io:5000/bingofuse/mysql@sha256:db404edfdc51438cc11c0f29ba0f1d0cb509bb9110d00613ea8036588ec9a68d\n    - registry.kube.io:5000/bingofuse/mysql:8.0.36\n    sizeBytes: 174757681\n  - names:\n    - registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1\n    - registry.bingosoft.net/n9n/categraf:latest\n    sizeBytes: 151804132\n  - names:\n    - registry.bingosoft.net/library/ubuntu@sha256:cc394c2cff7a3137774af9ad6fdcf562f729a180e0d6c10f664b27308878e5fd\n    - registry.bingosoft.net/library/ubuntu:24.04.aio\n    sizeBytes: 112462275\n  - names:\n    - registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179\n    - registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1\n    sizeBytes: 109319279\n  - names:\n    - registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74\n    - registry.bingosoft.net/langgenius/postgres:15-alpine\n    sizeBytes: 108679902\n  - names:\n    - registry.kube.io:5000/goharbor/harbor-jobservice@sha256:6c898c099f417792f92042a9e34d2f5a865398e6c96154c4211aba0530b6d054\n    - registry.kube.io:5000/goharbor/harbor-jobservice:v2.7.2\n    sizeBytes: 105525495\n  - names:\n    - registry.kube.io:5000/bingokube/kube-nvs@sha256:2b40e4db23a798ee875205f8e6c53c1810117806b519a35fa3d96ef23602dd5f\n    - registry.kube.io:5000/bingokube/kube-nvs:v1.7.0-master\n    sizeBytes: 102116015\n  - names:\n    - registry.kube.io:5000/bingokube/etcd@sha256:7e071bd9e922b73d06233ac16e4589a4565872d21e75c2e5a9486ed0512fb970\n    - registry.kube.io:5000/bingokube/etcd:3.5.0-0\n    - registry.kube.io:5000/bingokube/etcd:3.5.1-0\n    sizeBytes: 98887658\n  - names:\n    - registry.kube.io:5000/goharbor/harbor-db@sha256:3e18800420c322278bb6860bfa065a1403a569c1a612dbe1ea3b93162b4b7494\n    - registry.kube.io:5000/goharbor/harbor-db:v2.7.2\n    sizeBytes: 82628331\n  - names:\n    - registry.kube.io:5000/bingokube/prometheus/prometheus@sha256:c4819c653616d828ef7d86f96f35c5496b423935d4ee157a7f586ffbe8d7fc42\n    - registry.kube.io:5000/bingokube/prometheus/prometheus:v2.32.1\n    sizeBytes: 76757792\n  - names:\n    - registry.kube.io:5000/goharbor/harbor-core@sha256:9c06b0a80cf8f201ca9e57077e4116ccc466e90cca352eb9f17ccff89810fcae\n    - registry.kube.io:5000/goharbor/harbor-core:v2.7.2\n    sizeBytes: 74619791\n  - names:\n    - registry.kube.io:5000/bingokube/grafana/promtail@sha256:5283bb0a808a9250aad6506ba8aa923199f432c2f1bb66b707239c0977b2be0f\n    - registry.kube.io:5000/bingokube/grafana/promtail:2.8.3\n    sizeBytes: 74438865\n  - names:\n    - registry.bingosoft.net/kubesphere/ks-controller-manager@sha256:eec405fb60a28d1db5d1dd9696173d4314344dc3a4f76606707f5627a3e77a3c\n    - registry.bingosoft.net/kubesphere/ks-controller-manager:v4.1.3\n    sizeBytes: 60924656\n  - names:\n    - registry.kube.io:5000/goharbor/harbor-portal@sha256:740c36eeef08de32bd4ee9c48ebb363833af7d619f9463b270af35c028aef4ce\n    - registry.kube.io:5000/goharbor/harbor-portal:v2.7.2\n    sizeBytes: 51650184\n  - names:\n    - registry.kube.io:5000/goharbor/redis-photon@sha256:e5c30ec7643cda92e305ec5adfc24d2aca9779ac682081559a0f2747da8d39e7\n    - registry.kube.io:5000/goharbor/redis-photon:v2.7.3\n    sizeBytes: 50846179\n  - names:\n    - registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin@sha256:e5eedf07ec5c7717619d986a18fa426bec58f71de9aba245ab498a05c5658409\n    - registry.kube.io:5000/bingokube/bcs/csi-bcs-local/hci-local-plugin:v10.3.0\n    sizeBytes: 50466677\n  - names:\n    - registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721\n    - registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513\n    sizeBytes: 50111640\n  - names:\n    - registry.kube.io:5000/goharbor/notary-server-photon@sha256:08120d1ff7ffdd4745a54b3a0d43c98f8bad026481f0ed2caaec3dab8df0204c\n    - registry.kube.io:5000/goharbor/notary-server-photon:v2.7.2\n    sizeBytes: 47635213\n  - names:\n    - registry.kube.io:5000/bingokube/backup-kube@sha256:b532ae455193774054b63f62fc7a7511afa51ff908ad0fb9926a4e98d28d88cf\n    - registry.kube.io:5000/bingokube/backup-kube:v1.0.1\n    sizeBytes: 44749134\n  - names:\n    - registry.kube.io:5000/bingokube/kubedupont-controller@sha256:18b5a91245410df01822bb57d323f25dd870dabab02ae51aa1de214ae7720452\n    - registry.kube.io:5000/bingokube/kubedupont-controller:release-bcs-20250509\n    sizeBytes: 40510378\n  - names:\n    - registry.kube.io:5000/bingokube/bcs3@sha256:81717ff7eaec682cc205eb68e2f51999ec1ed3997e2267cf162add947053fb0c\n    - registry.kube.io:5000/bingokube/bcs3:v1.0\n    sizeBytes: 37005947\n  - names:\n    - registry.kube.io:5000/bingokube/bingokube-scheduler@sha256:72ea514aebbbf37c41b75decfa279c4f8fb3a97a3f0170df26f21eafd9d6b2d5\n    - registry.kube.io:5000/bingokube/bingokube-scheduler:v1.22.26\n    sizeBytes: 34537670\n  - names:\n    - registry.kube.io:5000/bingokube/metrics-server@sha256:9d520b7152c89bdf1cdb01fe75ef7d7536a98b2af2055be1edc8a2397e1b6a3a\n    - registry.kube.io:5000/bingokube/metrics-server:v0.6.3\n    sizeBytes: 31879654\n  - names:\n    - registry.kube.io:5000/bingokube/kube-apiserver@sha256:ff7ddbdd2f97de20fa2585fa86945f67b250719e87f0a7206557f0c7d9177480\n    - registry.kube.io:5000/bingokube/kube-apiserver:v1.22.26-tenant\n    sizeBytes: 31351143\n  - names:\n    - registry.kube.io:5000/bingokube/kubedupont-webhook@sha256:0e8a4e2626af666bc70709b012ccdd562550526e92a4235dd0ba899733003fd0\n    - registry.kube.io:5000/bingokube/kubedupont-webhook:release-bcs-20250509\n    sizeBytes: 30072682\n  - names:\n    - registry.kube.io:5000/bingokube/registry-monitor@sha256:271f9ce3ed539a6ab235f9e5f54ccfc07da5a07822a14e8438ddb5556613a4a9\n    - registry.kube.io:5000/bingokube/registry-monitor:v0.2.2\n    sizeBytes: 29959461\n  - names:\n    - registry.kube.io:5000/bingokube/kube-controller-manager@sha256:9cc7739052dae1389c2d4c75e51432659b9d990d631fd5d5391a64e2d7239c9c\n    - registry.kube.io:5000/bingokube/kube-controller-manager:v1.22.26-tenant\n    sizeBytes: 29825285\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner@sha256:ec09720add0b83d9deec6b53bc56e74c6fd7130bedce81d0c0c03d6ea5092013\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-provisioner:v3.5.0\n    sizeBytes: 28210010\n  - names:\n    - registry.kube.io:5000/bingokube/kubealived@sha256:18c41189e79194561aa4ce9390617892727edc4abe94ac6014cfded2c4d5f5dc\n    - registry.kube.io:5000/bingokube/kubealived:v1.0.3\n    sizeBytes: 27867730\n  - names:\n    - registry.kube.io:5000/bingokube/kubeverse-front@sha256:db411c48c3e65dc9f323b056b2b373755e12aaedfe661a5a41d6089170d4f275\n    - registry.kube.io:5000/bingokube/kubeverse-front:release-v1.7.0-20250514\n    sizeBytes: 26733665\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher@sha256:feaf439c5a6b410e9f68275c6ea4e147d94d696d6bf6f3c883817291ebcbbafa\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-attacher:v4.3.0\n    sizeBytes: 26211837\n  - names:\n    - registry.kube.io:5000/bingokube/agent-side@sha256:92a1af076da73fc7b3efee3e5b609cb12e50c8b493d903e575079fac9f7ad172\n    - registry.kube.io:5000/bingokube/agent-side:1.1.1\n    sizeBytes: 23454100\n  - names:\n    - registry.kube.io:5000/bingokube/grafana/loki@sha256:404c49c7315c7973d5f4744bd5f515e9ef29eb3a4584d6c7c2895feeb73dc31f\n    - registry.kube.io:5000/bingokube/grafana/loki:v2.8.3\n    sizeBytes: 22425176\n  - names:\n    - registry.bingosoft.net/langgenius/weaviate@sha256:3cab0765b9cbea1692ab261febebcd987f63122720aa301f9c2b8ef3ed5087e3\n    - registry.bingosoft.net/langgenius/weaviate:1.19.0\n    sizeBytes: 20095599\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher@sha256:b1d324a973a21d5c1ac2de009654bae8b9c320e57cd78450bdfc88f8a2a9d42b\n    - registry.kube.io:5000/bingokube/xsky/iscsi/csi-attacher:v3.0.0\n    sizeBytes: 19192181\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter@sha256:bce65196d5ee635b44f1abf75325d1b6a1bfc204dd8853e69a643e373dc3d827\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-snapshotter:v3.0.3\n    sizeBytes: 19139479\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer@sha256:6b7aa36a1aed873ec1e4f4e1622371a01f60d0c0ed109285004a2c45b48cdab7\n    - registry.kube.io:5000/bingokube/xsky/nfs/csi-resizer:v1.0.0\n    sizeBytes: 17753800\n  - names:\n    - registry.kube.io:5000/bingokube/cert-manager-controller@sha256:e24bbe9dd6dce08bd55d8afffd0e29680d2dad8f7951e43c36aecfba730a1bd3\n    - registry.kube.io:5000/bingokube/cert-manager-controller:v1.10.1\n    sizeBytes: 17739790\n  - names:\n    - registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller@sha256:d439eb7b37f0c50297a6defa5eb7b75e909078dcf63b42f2e9954002f9a627df\n    - registry.kube.io:5000/bingokube/xsky/iscsi/snapshot-controller:v3.0.3\n    sizeBytes: 17145967\n  - names:\n    - registry.bingosoft.net/langgenius/redis@sha256:915aa8d4cd87b7469f440afc4f74afa9535d07ebafee17fd1f9b76800d2c0640\n    - registry.bingosoft.net/langgenius/redis:6-alpine\n    sizeBytes: 14651370\n  - names:\n    - registry.kube.io:5000/bingokube/cert-manager-webhook@sha256:a4acfcf191b72159456c3a8a929fee662140b4139fc15dd6ed171b2a8ae3144e\n    - registry.kube.io:5000/bingokube/cert-manager-webhook:v1.10.1\n    sizeBytes: 13726565\n  - names:\n    - registry.kube.io:5000/bingokube/cert-manager-cainjector@sha256:66898628ce06f33989b95685148ab1c724f92b1efa32a7e7a08ceac217987252\n    - registry.kube.io:5000/bingokube/cert-manager-cainjector:v1.10.1\n    sizeBytes: 12200644\n  nodeInfo:\n    architecture: amd64\n    bootID: 1c0f668f-2eed-4ec7-936a-14fc8b5cb37e\n    containerRuntimeVersion: containerd://1.7.19\n    kernelVersion: 5.10.0-136.12.0.86.oe2203sp1.x86_64\n    kubeProxyVersion: v1.22.26-tenant\n    kubeletVersion: v1.22.26-tenant\n    machineID: 67beafed95424a92ba49d1f2a54448ae\n    operatingSystem: linux\n    osImage: Linux\n    systemUUID: 2cd15b45-24a5-a570-ea11-e6064a770a51\n"
}
```

node-pod

列表
/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/pods?isGetResource=1&page=1&pageSize=10&fields=metadata.namespace%21%3Dkube-backup,spec.nodeName%3D10.203.52.101,status.phase%21%3DFailed,status.phase%21%3DSucceeded&keyword=&orderBy=creationTimestamp&ascending=false
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "224256025n",
                "quantityUsageMemory": "49676Ki",
                "usageCPU": 0.225,
                "usageMemory": 0.047374725341796875,
                "limitResource": {
                    "cpu": 4,
                    "memory": 8,
                    "quantityCPU": "4",
                    "quantityMemory": "8Gi"
                },
                "RequestResource": {
                    "cpu": 4,
                    "memory": 8,
                    "quantityCPU": "4",
                    "quantityMemory": "8Gi"
                },
                "Name": "nightingale8-categraf-v6-5l8cn",
                "CreationTimestamp": "2025-09-15T09:45:09Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "nightingale8-categraf-v6-5l8cn",
                        "generateName": "nightingale8-categraf-v6-",
                        "namespace": "n9n",
                        "uid": "afb45e37-913c-4e2f-9e06-02d5bab1f9ca",
                        "resourceVersion": "56675101",
                        "creationTimestamp": "2025-09-15T09:45:09Z",
                        "labels": {
                            "app": "n9e",
                            "chart": "nightingale",
                            "component": "categraf",
                            "controller-revision-hash": "65479b6d48",
                            "heritage": "Helm",
                            "pod-template-generation": "3",
                            "preemptNodeResource": "10.203.52.101",
                            "release": "nightingale8"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"staticIp\":\"\",\"isDefaultGateway\":true,\"oldStaticIp\":\"\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "nightingale8-categraf-v6",
                                "uid": "75f8a99b-4e99-45c0-9cbc-c0822b212bae",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:45:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:45:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        },
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:chart": {},
                                            "f:component": {},
                                            "f:controller-revision-hash": {},
                                            "f:heritage": {},
                                            "f:pod-template-generation": {},
                                            "f:release": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"75f8a99b-4e99-45c0-9cbc-c0822b212bae\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"HOSTIP\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"HOSTNAME\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:fieldRef": {}
                                                        }
                                                    },
                                                    "k:{\"name\":\"HOST_MOUNT_PREFIX\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"HOST_PROC\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"HOST_SYS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"TZ\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
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
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/config.toml\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:subPath": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.cadvisor\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.cpu\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.disk\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.diskio\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kernel\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kernel_vmstat\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.kubernetes\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.linux_sysctl_fs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.mem\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.net\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.netstat\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.processes\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.prometheus\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/input.system\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/categraf/conf/logs.toml\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:subPath": {}
                                                    },
                                                    "k:{\"mountPath\":\"/hostfs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/run/utmp\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"configmap-7sblk8\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-7wmneg\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-aesalv\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-bfjntz\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-ccneut\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-diqkym\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-fc6th1\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-iowlu0\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-jg1s2j\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-lkkewd\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-lqxipw\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-nhf0yt\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-nlath0\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-ps14pj\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"configmap-zq3zhc\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"hostpath-i923an\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"hostpath-ts17m3\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:46:52Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "configmap-ccneut",
                                "configMap": {
                                    "name": "categraf-config",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-aesalv",
                                "configMap": {
                                    "name": "input-cpu",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-7wmneg",
                                "configMap": {
                                    "name": "input-mem",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-jg1s2j",
                                "configMap": {
                                    "name": "input-disk",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-7sblk8",
                                "configMap": {
                                    "name": "input-diskio",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-ps14pj",
                                "configMap": {
                                    "name": "input-net",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-diqkym",
                                "configMap": {
                                    "name": "input-netstat",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-fc6th1",
                                "configMap": {
                                    "name": "input-kubernetes",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-zq3zhc",
                                "configMap": {
                                    "name": "input-kubelet-metrics",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-bfjntz",
                                "configMap": {
                                    "name": "input-cadvisor",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-nlath0",
                                "configMap": {
                                    "name": "input-kernel",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-lkkewd",
                                "configMap": {
                                    "name": "input-kernel-vmstat",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-lqxipw",
                                "configMap": {
                                    "name": "input-sysctl-fs",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-iowlu0",
                                "configMap": {
                                    "name": "input-processes",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "configmap-nhf0yt",
                                "configMap": {
                                    "name": "input-system",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "hostpath-ts17m3",
                                "hostPath": {
                                    "path": "/var/run/utmp",
                                    "type": ""
                                }
                            },
                            {
                                "name": "hostpath-i923an",
                                "hostPath": {
                                    "path": "/",
                                    "type": ""
                                }
                            },
                            {
                                "name": "kube-api-access-97tgn",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/n9n/categraf:latest",
                                "env": [
                                    {
                                        "name": "TZ",
                                        "value": "Asia/Shanghai"
                                    },
                                    {
                                        "name": "HOSTNAME",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "spec.nodeName"
                                            }
                                        }
                                    },
                                    {
                                        "name": "HOSTIP",
                                        "valueFrom": {
                                            "fieldRef": {
                                                "apiVersion": "v1",
                                                "fieldPath": "status.hostIP"
                                            }
                                        }
                                    },
                                    {
                                        "name": "HOST_PROC",
                                        "value": "/hostfs/proc"
                                    },
                                    {
                                        "name": "HOST_SYS",
                                        "value": "/hostfs/sys"
                                    },
                                    {
                                        "name": "HOST_MOUNT_PREFIX",
                                        "value": "/hostfs"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "4",
                                        "memory": "8Gi"
                                    },
                                    "requests": {
                                        "cpu": "4",
                                        "memory": "8Gi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "configmap-ccneut",
                                        "mountPath": "/etc/categraf/conf/config.toml",
                                        "subPath": "config.toml"
                                    },
                                    {
                                        "name": "configmap-ccneut",
                                        "mountPath": "/etc/categraf/conf/logs.toml",
                                        "subPath": "logs.toml"
                                    },
                                    {
                                        "name": "configmap-aesalv",
                                        "mountPath": "/etc/categraf/conf/input.cpu"
                                    },
                                    {
                                        "name": "configmap-7wmneg",
                                        "mountPath": "/etc/categraf/conf/input.mem"
                                    },
                                    {
                                        "name": "configmap-jg1s2j",
                                        "mountPath": "/etc/categraf/conf/input.disk"
                                    },
                                    {
                                        "name": "configmap-7sblk8",
                                        "mountPath": "/etc/categraf/conf/input.diskio"
                                    },
                                    {
                                        "name": "configmap-ps14pj",
                                        "mountPath": "/etc/categraf/conf/input.net"
                                    },
                                    {
                                        "name": "configmap-diqkym",
                                        "mountPath": "/etc/categraf/conf/input.netstat"
                                    },
                                    {
                                        "name": "configmap-fc6th1",
                                        "mountPath": "/etc/categraf/conf/input.kubernetes"
                                    },
                                    {
                                        "name": "configmap-zq3zhc",
                                        "mountPath": "/etc/categraf/conf/input.prometheus"
                                    },
                                    {
                                        "name": "configmap-bfjntz",
                                        "mountPath": "/etc/categraf/conf/input.cadvisor"
                                    },
                                    {
                                        "name": "configmap-nlath0",
                                        "mountPath": "/etc/categraf/conf/input.kernel"
                                    },
                                    {
                                        "name": "configmap-lkkewd",
                                        "mountPath": "/etc/categraf/conf/input.kernel_vmstat"
                                    },
                                    {
                                        "name": "configmap-lqxipw",
                                        "mountPath": "/etc/categraf/conf/input.linux_sysctl_fs"
                                    },
                                    {
                                        "name": "configmap-iowlu0",
                                        "mountPath": "/etc/categraf/conf/input.processes"
                                    },
                                    {
                                        "name": "configmap-nhf0yt",
                                        "mountPath": "/etc/categraf/conf/input.system"
                                    },
                                    {
                                        "name": "hostpath-ts17m3",
                                        "readOnly": true,
                                        "mountPath": "/var/run/utmp"
                                    },
                                    {
                                        "name": "hostpath-i923an",
                                        "readOnly": true,
                                        "mountPath": "/hostfs"
                                    },
                                    {
                                        "name": "kube-api-access-97tgn",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "Always"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirstWithHostNet",
                        "serviceAccountName": "nightingale8-categraf-v6",
                        "serviceAccount": "nightingale8-categraf-v6",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:45:09Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:46:52Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:46:52Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:45:09Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-09-15T09:45:09Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-15T09:46:52Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/n9n/categraf:latest",
                                "imageID": "registry.bingosoft.net/n9n/categraf@sha256:e51727c74b59865c27554c0086a8026347d3a6aee48c98c5bb1e0137faa9aef1",
                                "containerID": "containerd://885ef7fa3db77b77531f7ea5a2849d0e59486abaa375ed804491d81c0a6767c3",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "2403269n",
                "quantityUsageMemory": "63088Ki",
                "usageCPU": 0.003,
                "usageMemory": 0.0601654052734375,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "Name": "kubeverse-gtpmj",
                "CreationTimestamp": "2025-09-15T09:44:23Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "kubeverse-gtpmj",
                        "generateName": "kubeverse-",
                        "namespace": "kube-system",
                        "uid": "543a7442-0090-4858-b198-7f453a0cece4",
                        "resourceVersion": "56674018",
                        "creationTimestamp": "2025-09-15T09:44:23Z",
                        "labels": {
                            "app": "kubeverse-console",
                            "controller-revision-hash": "5965748fbb",
                            "pod-template-generation": "1",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "kubeverse",
                                "uid": "7e387760-0030-425e-9ff0-f70f180d15a4",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:44:23Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:controller-revision-hash": {},
                                            "f:pod-template-generation": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"7e387760-0030-425e-9ff0-f70f180d15a4\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"console\"}": {
                                                ".": {},
                                                "f:args": {},
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
                                                    "f:periodSeconds": {},
                                                    "f:successThreshold": {},
                                                    "f:timeoutSeconds": {}
                                                },
                                                "f:name": {},
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":8989,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:hostPort": {},
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
                                                "f:resources": {},
                                                "f:securityContext": {},
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/app/config/default\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/app/workspace/install\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/app/workspace/upload\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/front-shared\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:initContainers": {
                                            ".": {},
                                            "k:{\"name\":\"kubeverse-front\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:command": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:name": {},
                                                "f:resources": {},
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/shared\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
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
                                            "k:{\"name\":\"config\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"front-shared\"}": {
                                                ".": {},
                                                "f:emptyDir": {},
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"upload\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"verse-suite\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:44:24Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:44:34Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:initContainerStatuses": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "verse-suite",
                                "hostPath": {
                                    "path": "/kube/install",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "upload",
                                "hostPath": {
                                    "path": "/kube/upload",
                                    "type": "DirectoryOrCreate"
                                }
                            },
                            {
                                "name": "config",
                                "configMap": {
                                    "name": "kubeverse-console",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "front-shared",
                                "emptyDir": {}
                            },
                            {
                                "name": "kube-api-access-bfz2v",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "initContainers": [
                            {
                                "name": "kubeverse-front",
                                "image": "registry.kube.io:5000/bingokube/kubeverse-front:release-v1.7.0-20250514",
                                "command": [
                                    "sh",
                                    "-c"
                                ],
                                "args": [
                                    "cp -r /app/template /shared"
                                ],
                                "resources": {},
                                "volumeMounts": [
                                    {
                                        "name": "front-shared",
                                        "mountPath": "/shared"
                                    },
                                    {
                                        "name": "kube-api-access-bfz2v",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "containers": [
                            {
                                "name": "console",
                                "image": "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513",
                                "command": [
                                    "sh",
                                    "-c"
                                ],
                                "args": [
                                    "sleep 5s; cp -r /front-shared/template /app/; cp /app/template/static/images/* /app/workspace/upload/; ln -s /app/workspace/upload /app/template/; /app/kubeverse;"
                                ],
                                "ports": [
                                    {
                                        "name": "http",
                                        "hostPort": 8989,
                                        "containerPort": 8989,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {},
                                "volumeMounts": [
                                    {
                                        "name": "front-shared",
                                        "mountPath": "/front-shared"
                                    },
                                    {
                                        "name": "config",
                                        "mountPath": "/app/config/default"
                                    },
                                    {
                                        "name": "verse-suite",
                                        "mountPath": "/app/workspace/install"
                                    },
                                    {
                                        "name": "upload",
                                        "mountPath": "/app/workspace/upload"
                                    },
                                    {
                                        "name": "kube-api-access-bfz2v",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "livenessProbe": {
                                    "httpGet": {
                                        "path": "/health",
                                        "port": 8989,
                                        "scheme": "HTTPS"
                                    },
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "readinessProbe": {
                                    "httpGet": {
                                        "path": "/health",
                                        "port": 8989,
                                        "scheme": "HTTPS"
                                    },
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent",
                                "securityContext": {}
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirstWithHostNet",
                        "nodeSelector": {
                            "node-role.kubernetes.io/master": ""
                        },
                        "serviceAccountName": "kubeverse",
                        "serviceAccount": "kubeverse",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:44:27Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:44:34Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:44:34Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:44:24Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-09-15T09:44:24Z",
                        "initContainerStatuses": [
                            {
                                "name": "kubeverse-front",
                                "state": {
                                    "terminated": {
                                        "exitCode": 0,
                                        "reason": "Completed",
                                        "startedAt": "2025-09-15T09:44:25Z",
                                        "finishedAt": "2025-09-15T09:44:25Z",
                                        "containerID": "containerd://b7454606d611e105c770c1a4529f8df74deab22a75820f87099f200cc7ec9464"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/kubeverse-front:release-v1.7.0-20250514",
                                "imageID": "registry.kube.io:5000/bingokube/kubeverse-front@sha256:db411c48c3e65dc9f323b056b2b373755e12aaedfe661a5a41d6089170d4f275",
                                "containerID": "containerd://b7454606d611e105c770c1a4529f8df74deab22a75820f87099f200cc7ec9464"
                            }
                        ],
                        "containerStatuses": [
                            {
                                "name": "console",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-15T09:44:28Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/kubeverse:release-v1.7.0-20250513",
                                "imageID": "registry.kube.io:5000/bingokube/kubeverse@sha256:be404eaaa26143c19a9f2e3ba0049cf6ffd5cb7745edb2cffbbc89c9845b4721",
                                "containerID": "containerd://f89544a1afda12ae359e9dfa8b4989671cb3013c13a88b74909693ca548841f1",
                                "started": true
                            }
                        ],
                        "qosClass": "BestEffort"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "6622850n",
                "quantityUsageMemory": "767804Ki",
                "usageCPU": 0.007,
                "usageMemory": 0.7322349548339844,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0.1,
                    "memory": 0.09,
                    "quantityCPU": "100m",
                    "quantityMemory": "90Mi"
                },
                "Name": "nicoutlet-0011967528-ingress-nginx-controller-cx8dl",
                "CreationTimestamp": "2025-09-15T09:33:03Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "nicoutlet-0011967528-ingress-nginx-controller-cx8dl",
                        "generateName": "nicoutlet-0011967528-ingress-nginx-controller-",
                        "namespace": "kube-system",
                        "uid": "08e66038-7f91-4b30-b60a-10f6e445dc5e",
                        "resourceVersion": "56668695",
                        "creationTimestamp": "2025-09-15T09:33:03Z",
                        "labels": {
                            "app.kubernetes.io/component": "controller",
                            "app.kubernetes.io/instance": "nicoutlet-0011967528",
                            "app.kubernetes.io/name": "ingress-nginx",
                            "controller-revision-hash": "c58d98897",
                            "pod-template-generation": "1",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "annotations": {
                            "name": "ingress-nginx"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "DaemonSet",
                                "name": "nicoutlet-0011967528-ingress-nginx-controller",
                                "uid": "2c179236-9a9c-4846-90ee-b2c3d468fa2e",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:33:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:33:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:name": {}
                                        },
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app.kubernetes.io/component": {},
                                            "f:app.kubernetes.io/instance": {},
                                            "f:app.kubernetes.io/name": {},
                                            "f:controller-revision-hash": {},
                                            "f:pod-template-generation": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"2c179236-9a9c-4846-90ee-b2c3d468fa2e\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:nodeAffinity": {
                                                ".": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
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
                                                    "k:{\"containerPort\":180,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:hostPort": {},
                                                        "f:name": {},
                                                        "f:protocol": {}
                                                    },
                                                    "k:{\"containerPort\":1443,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:hostPort": {},
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
                                                "f:terminationMessagePolicy": {}
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostNetwork": {},
                                        "f:nodeSelector": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {}
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-15T09:33:24Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"10.203.52.101\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "kube-api-access-g4jtj",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "controller",
                                "image": "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1",
                                "args": [
                                    "/nginx-ingress-controller",
                                    "--http-port=180",
                                    "--https-port=1443",
                                    "--election-id=nicoutlet-0011967528-ingress-nginx-leader",
                                    "--controller-class=k8s.io/ingress-nginx",
                                    "--ingress-class=system-nginx",
                                    "--configmap=$(POD_NAMESPACE)/nicoutlet-0011967528-ingress-nginx-controller"
                                ],
                                "ports": [
                                    {
                                        "name": "http",
                                        "hostPort": 180,
                                        "containerPort": 180,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "https",
                                        "hostPort": 1443,
                                        "containerPort": 1443,
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
                                        "name": "kube-api-access-g4jtj",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
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
                        "serviceAccountName": "nicoutlet-0011967528-ingress-nginx",
                        "serviceAccount": "nicoutlet-0011967528-ingress-nginx",
                        "nodeName": "10.203.52.101",
                        "hostNetwork": true,
                        "securityContext": {},
                        "affinity": {
                            "nodeAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": {
                                    "nodeSelectorTerms": [
                                        {
                                            "matchFields": [
                                                {
                                                    "key": "metadata.name",
                                                    "operator": "In",
                                                    "values": [
                                                        "10.203.52.101"
                                                    ]
                                                }
                                            ]
                                        }
                                    ]
                                }
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute"
                            },
                            {
                                "key": "node.kubernetes.io/disk-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/memory-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/pid-pressure",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/unschedulable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/network-unavailable",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:33:03Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:33:24Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:33:24Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-15T09:33:03Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "10.203.52.101",
                        "podIPs": [
                            {
                                "ip": "10.203.52.101"
                            }
                        ],
                        "startTime": "2025-09-15T09:33:03Z",
                        "containerStatuses": [
                            {
                                "name": "controller",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-15T09:33:09Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/ingress-nginx/controller:v1.5.1",
                                "imageID": "registry.kube.io:5000/bingokube/ingress-nginx/controller@sha256:b55b804a32ac362cfc05ebb1ee1d937c0c084cff5b51931900e1ad97008fb179",
                                "containerID": "containerd://b94ec4d7954d7f16a0a1c1c8cd61cb5fb62d4f0af24eecbf27e588b21ca4be41",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "49409n",
                "quantityUsageMemory": "53112Ki",
                "usageCPU": 0.001,
                "usageMemory": 0.05065155029296875,
                "limitResource": {
                    "cpu": 0.1,
                    "memory": 0.13,
                    "quantityCPU": "100m",
                    "quantityMemory": "128Mi"
                },
                "RequestResource": {
                    "cpu": 0.1,
                    "memory": 0.13,
                    "quantityCPU": "100m",
                    "quantityMemory": "128Mi"
                },
                "Name": "bcs3-68b85d8c4b-tv4sc",
                "CreationTimestamp": "2025-09-12T06:22:58Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "bcs3-68b85d8c4b-tv4sc",
                        "generateName": "bcs3-68b85d8c4b-",
                        "namespace": "kube-system",
                        "uid": "9d04153f-1510-41b2-b3b6-983613c3b2eb",
                        "resourceVersion": "54588425",
                        "creationTimestamp": "2025-09-12T06:22:58Z",
                        "labels": {
                            "app.kubernetes.io/instance": "bcs3",
                            "app.kubernetes.io/name": "bcs3",
                            "pod-template-hash": "68b85d8c4b",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.0.9\",\"isDefaultGateway\":true,\"hostNicName\":\"if00197a3c9439f\"}]}",
                            "name": "bcs3"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "ReplicaSet",
                                "name": "bcs3-68b85d8c4b",
                                "uid": "539e0157-3f3a-4b04-8f4f-a7f51ff4758e",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T06:22:58Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T06:22:58Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:name": {}
                                        },
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app.kubernetes.io/instance": {},
                                            "f:app.kubernetes.io/name": {},
                                            "f:pod-template-hash": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"539e0157-3f3a-4b04-8f4f-a7f51ff4758e\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"bcs3\"}": {
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
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":80,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
                                                        "f:protocol": {}
                                                    }
                                                },
                                                "f:readinessProbe": {
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
                                                "f:securityContext": {},
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/bcshare/cloud\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"data\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:persistentVolumeClaim": {
                                                    ".": {},
                                                    "f:claimName": {}
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T06:22:59Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T06:23:05Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T06:23:15Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.0.9\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "data",
                                "persistentVolumeClaim": {
                                    "claimName": "bcs3"
                                }
                            },
                            {
                                "name": "kube-api-access-ttgk6",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "bcs3",
                                "image": "registry.kube.io:5000/bingokube/bcs3:v1.0",
                                "ports": [
                                    {
                                        "name": "http",
                                        "containerPort": 80,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "100m",
                                        "memory": "128Mi"
                                    },
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "128Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "data",
                                        "mountPath": "/bcshare/cloud"
                                    },
                                    {
                                        "name": "kube-api-access-ttgk6",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "livenessProbe": {
                                    "tcpSocket": {
                                        "port": 80
                                    },
                                    "initialDelaySeconds": 15,
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 20,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "readinessProbe": {
                                    "tcpSocket": {
                                        "port": 80
                                    },
                                    "initialDelaySeconds": 5,
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent",
                                "securityContext": {}
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "serviceAccountName": "bcs3",
                        "serviceAccount": "bcs3",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T06:22:58Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T06:23:15Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T06:23:15Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T06:22:58Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.0.9",
                        "podIPs": [
                            {
                                "ip": "172.21.0.9"
                            }
                        ],
                        "startTime": "2025-09-12T06:22:58Z",
                        "containerStatuses": [
                            {
                                "name": "bcs3",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-12T06:23:08Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/bcs3:v1.0",
                                "imageID": "registry.kube.io:5000/bingokube/bcs3@sha256:81717ff7eaec682cc205eb68e2f51999ec1ed3997e2267cf162add947053fb0c",
                                "containerID": "containerd://23b4cc160a2beaa0c2cffe1fb129aa96f82d24b72fc1defd01290b759987b39e",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "2464336n",
                "quantityUsageMemory": "54796Ki",
                "usageCPU": 0.003,
                "usageMemory": 0.052257537841796875,
                "limitResource": {
                    "cpu": 4,
                    "memory": 4,
                    "quantityCPU": "4",
                    "quantityMemory": "4Gi"
                },
                "RequestResource": {
                    "cpu": 4,
                    "memory": 4,
                    "quantityCPU": "4",
                    "quantityMemory": "4Gi"
                },
                "Name": "dify-weaviate-0",
                "CreationTimestamp": "2025-09-12T02:13:03Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "dify-weaviate-0",
                        "generateName": "dify-weaviate-",
                        "namespace": "dify",
                        "uid": "a3964d24-3419-486a-bdfe-da13ef487e67",
                        "resourceVersion": "54473097",
                        "creationTimestamp": "2025-09-12T02:13:03Z",
                        "labels": {
                            "app": "dify-weaviate",
                            "controller-revision-hash": "dify-weaviate-6db8b8b7f4",
                            "preemptNodeResource": "10.203.52.101",
                            "statefulset.kubernetes.io/pod-name": "dify-weaviate-0"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.0.8\",\"isDefaultGateway\":true,\"hostNicName\":\"if00122d11a7551\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "StatefulSet",
                                "name": "dify-weaviate",
                                "uid": "a89ebdbb-2f9e-4805-9814-7bcc037664cb",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T02:13:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T02:13:03Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {},
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:controller-revision-hash": {},
                                            "f:statefulset.kubernetes.io/pod-name": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"a89ebdbb-2f9e-4805-9814-7bcc037664cb\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"AUTHENTICATION_APIKEY_ALLOWED_KEYS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"AUTHENTICATION_APIKEY_ENABLED\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"AUTHENTICATION_APIKEY_USERS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"AUTHORIZATION_ADMINLIST_ENABLED\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"AUTHORIZATION_ADMINLIST_USERS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"CLUSTER_HOSTNAME\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"DEFAULT_VECTORIZER_MODULE\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"PERSISTENCE_DATA_PATH\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"QUERY_DEFAULTS_LIMIT\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
                                                "f:name": {},
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":8080,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
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
                                                    "k:{\"mountPath\":\"/var/lib/weaviate\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostname": {},
                                        "f:nodeSelector": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:subdomain": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"pvc-ozqtqu\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:persistentVolumeClaim": {
                                                    ".": {},
                                                    "f:claimName": {}
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T02:13:05Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T02:13:08Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-12T02:13:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.0.8\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "pvc-ozqtqu",
                                "persistentVolumeClaim": {
                                    "claimName": "weaviate-data"
                                }
                            },
                            {
                                "name": "kube-api-access-lnqsz",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/langgenius/weaviate:1.19.0",
                                "ports": [
                                    {
                                        "name": "weaviate-p",
                                        "containerPort": 8080,
                                        "protocol": "TCP"
                                    }
                                ],
                                "env": [
                                    {
                                        "name": "PERSISTENCE_DATA_PATH",
                                        "value": "/var/lib/weaviate"
                                    },
                                    {
                                        "name": "QUERY_DEFAULTS_LIMIT",
                                        "value": "25"
                                    },
                                    {
                                        "name": "AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED",
                                        "value": "false"
                                    },
                                    {
                                        "name": "DEFAULT_VECTORIZER_MODULE",
                                        "value": "none"
                                    },
                                    {
                                        "name": "CLUSTER_HOSTNAME",
                                        "value": "node1"
                                    },
                                    {
                                        "name": "AUTHENTICATION_APIKEY_ENABLED",
                                        "value": "true"
                                    },
                                    {
                                        "name": "AUTHENTICATION_APIKEY_ALLOWED_KEYS",
                                        "value": "WVF5YThaHlkYwhGUSmCRgsX3tD5ngdN8pkih"
                                    },
                                    {
                                        "name": "AUTHENTICATION_APIKEY_USERS",
                                        "value": "hello@dify.ai"
                                    },
                                    {
                                        "name": "AUTHORIZATION_ADMINLIST_ENABLED",
                                        "value": "true"
                                    },
                                    {
                                        "name": "AUTHORIZATION_ADMINLIST_USERS",
                                        "value": "hello@dify.ai"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "4",
                                        "memory": "4Gi"
                                    },
                                    "requests": {
                                        "cpu": "4",
                                        "memory": "4Gi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "pvc-ozqtqu",
                                        "mountPath": "/var/lib/weaviate"
                                    },
                                    {
                                        "name": "kube-api-access-lnqsz",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 10,
                        "dnsPolicy": "ClusterFirst",
                        "nodeSelector": {
                            "kubernetes.io/os": "linux"
                        },
                        "serviceAccountName": "dify-weaviate",
                        "serviceAccount": "dify-weaviate",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "hostname": "dify-weaviate-0",
                        "subdomain": "dify-weaviate",
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T02:13:03Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T02:13:09Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T02:13:09Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-12T02:13:03Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.0.8",
                        "podIPs": [
                            {
                                "ip": "172.21.0.8"
                            }
                        ],
                        "startTime": "2025-09-12T02:13:03Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-12T02:13:08Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/langgenius/weaviate:1.19.0",
                                "imageID": "registry.bingosoft.net/langgenius/weaviate@sha256:3cab0765b9cbea1692ab261febebcd987f63122720aa301f9c2b8ef3ed5087e3",
                                "containerID": "containerd://a043b85bf99505164f63326c216d0ac384e2526ffc9a6ac1bbf78c55c8d67714",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "6808680n",
                "quantityUsageMemory": "346668Ki",
                "usageCPU": 0.007,
                "usageMemory": 0.3306083679199219,
                "limitResource": {
                    "cpu": 4,
                    "memory": 4,
                    "quantityCPU": "4",
                    "quantityMemory": "4Gi"
                },
                "RequestResource": {
                    "cpu": 4,
                    "memory": 4,
                    "quantityCPU": "4",
                    "quantityMemory": "4Gi"
                },
                "Name": "dify-web-f468c6d78-wxxsk",
                "CreationTimestamp": "2025-09-08T15:51:25Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "dify-web-f468c6d78-wxxsk",
                        "generateName": "dify-web-f468c6d78-",
                        "namespace": "dify",
                        "uid": "0a40e565-c5d3-4b8a-95a4-e1841d728f88",
                        "resourceVersion": "52178384",
                        "creationTimestamp": "2025-09-08T15:51:25Z",
                        "labels": {
                            "app": "dify-web",
                            "pod-template-hash": "f468c6d78",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.0.76\",\"isDefaultGateway\":true,\"hostNicName\":\"if00748b86f5073\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "ReplicaSet",
                                "name": "dify-web-f468c6d78",
                                "uid": "5cfeb618-da66-442e-b295-8cb495af4716",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:51:25Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {},
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:pod-template-hash": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"5cfeb618-da66-442e-b295-8cb495af4716\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"ALLOW_EMBED\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"APP_API_URL\"}": {
                                                        ".": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"name\":\"CONSOLE_API_URL\"}": {
                                                        ".": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"name\":\"CSP_WHITELIST\"}": {
                                                        ".": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"name\":\"ENABLE_WEBSITE_FIRECRAWL\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"ENABLE_WEBSITE_JINAREADER\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"ENABLE_WEBSITE_WATERCRAWL\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"LOOP_NODE_MAX_COUNT\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"MARKETPLACE_API_URL\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"MARKETPLACE_URL\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"MAX_ITERATIONS_NUM\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"MAX_PARALLEL_LIMIT\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"MAX_TOOLS_NUM\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"NEXT_TELEMETRY_DISABLED\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"PM2_INSTANCES\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"SENTRY_DSN\"}": {
                                                        ".": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"name\":\"TEXT_GENERATION_TIMEOUT_MS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"TOP_K_MAX_VALUE\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
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
                                                "f:terminationMessagePolicy": {}
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:terminationGracePeriodSeconds": {}
                                    }
                                }
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:51:27Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:53:07Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:53:07Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:53:22Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.0.76\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "kube-api-access-dzjtw",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/langgenius/dify-web:1.6.0",
                                "env": [
                                    {
                                        "name": "ALLOW_EMBED",
                                        "value": "false"
                                    },
                                    {
                                        "name": "APP_API_URL"
                                    },
                                    {
                                        "name": "CONSOLE_API_URL"
                                    },
                                    {
                                        "name": "CSP_WHITELIST"
                                    },
                                    {
                                        "name": "ENABLE_WEBSITE_FIRECRAWL",
                                        "value": "true"
                                    },
                                    {
                                        "name": "ENABLE_WEBSITE_JINAREADER",
                                        "value": "true"
                                    },
                                    {
                                        "name": "ENABLE_WEBSITE_WATERCRAWL",
                                        "value": "true"
                                    },
                                    {
                                        "name": "INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH",
                                        "value": "4000"
                                    },
                                    {
                                        "name": "LOOP_NODE_MAX_COUNT",
                                        "value": "100"
                                    },
                                    {
                                        "name": "MARKETPLACE_API_URL",
                                        "value": "https://marketplace.dify.ai"
                                    },
                                    {
                                        "name": "MARKETPLACE_URL",
                                        "value": "https://marketplace.dify.ai"
                                    },
                                    {
                                        "name": "MAX_ITERATIONS_NUM",
                                        "value": "99"
                                    },
                                    {
                                        "name": "MAX_PARALLEL_LIMIT",
                                        "value": "10"
                                    },
                                    {
                                        "name": "MAX_TOOLS_NUM",
                                        "value": "10"
                                    },
                                    {
                                        "name": "NEXT_TELEMETRY_DISABLED",
                                        "value": "0"
                                    },
                                    {
                                        "name": "PM2_INSTANCES",
                                        "value": "2"
                                    },
                                    {
                                        "name": "SENTRY_DSN"
                                    },
                                    {
                                        "name": "TEXT_GENERATION_TIMEOUT_MS",
                                        "value": "60000"
                                    },
                                    {
                                        "name": "TOP_K_MAX_VALUE",
                                        "value": "10"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "4",
                                        "memory": "4Gi"
                                    },
                                    "requests": {
                                        "cpu": "4",
                                        "memory": "4Gi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "kube-api-access-dzjtw",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "serviceAccountName": "default",
                        "serviceAccount": "default",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:51:27Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:53:22Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:53:22Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:51:27Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.0.76",
                        "podIPs": [
                            {
                                "ip": "172.21.0.76"
                            }
                        ],
                        "startTime": "2025-09-08T15:51:27Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T15:53:21Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/langgenius/dify-web:1.6.0",
                                "imageID": "registry.bingosoft.net/langgenius/dify-web@sha256:90bfe00d908e5340d285dfa857c796d2b10a06584d9e10c71a823b63a9fff9d0",
                                "containerID": "containerd://291cba177a24e8902e09e2973dfe363ac6aa0ab21553803cbed7ea6e5d552678",
                                "started": true
                            }
                        ],
                        "qosClass": "Guaranteed"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "2994698n",
                "quantityUsageMemory": "8860Ki",
                "usageCPU": 0.003,
                "usageMemory": 0.008449554443359375,
                "limitResource": {
                    "cpu": 0.5,
                    "memory": 1,
                    "quantityCPU": "500m",
                    "quantityMemory": "1Gi"
                },
                "RequestResource": {
                    "cpu": 0.1,
                    "memory": 0.1,
                    "quantityCPU": "100m",
                    "quantityMemory": "107374182400m"
                },
                "Name": "dify-redis-0",
                "CreationTimestamp": "2025-09-08T15:44:02Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "dify-redis-0",
                        "generateName": "dify-redis-",
                        "namespace": "dify",
                        "uid": "0c9455fd-17eb-410a-a462-6e5dc779e504",
                        "resourceVersion": "52174640",
                        "creationTimestamp": "2025-09-08T15:44:02Z",
                        "labels": {
                            "app": "dify-redis",
                            "controller-revision-hash": "dify-redis-76944b4f98",
                            "preemptNodeResource": "10.203.52.101",
                            "statefulset.kubernetes.io/pod-name": "dify-redis-0"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.57.4\",\"isDefaultGateway\":true,\"hostNicName\":\"if008dbdec26d0b\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "StatefulSet",
                                "name": "dify-redis",
                                "uid": "01327eba-d6b0-4ce9-96ff-24215a1b4d18",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:44:02Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {},
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:controller-revision-hash": {},
                                            "f:statefulset.kubernetes.io/pod-name": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"01327eba-d6b0-4ce9-96ff-24215a1b4d18\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"REDIS_PASSWORD\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:valueFrom": {
                                                            ".": {},
                                                            "f:secretKeyRef": {}
                                                        }
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
                                                "f:livenessProbe": {
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
                                                "f:name": {},
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":6379,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
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
                                                    "k:{\"mountPath\":\"/data\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostname": {},
                                        "f:nodeSelector": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:subdomain": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"pvc-g9te9f\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:persistentVolumeClaim": {
                                                    ".": {},
                                                    "f:claimName": {}
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:44:04Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:45:26Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:45:28Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:45:31Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.57.4\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "pvc-g9te9f",
                                "persistentVolumeClaim": {
                                    "claimName": "redis-data"
                                }
                            },
                            {
                                "name": "kube-api-access-75fkt",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/langgenius/redis:6-alpine",
                                "args": [
                                    "redis-server",
                                    "--requirepass",
                                    "difyai123456"
                                ],
                                "ports": [
                                    {
                                        "name": "redis-p",
                                        "containerPort": 6379,
                                        "protocol": "TCP"
                                    }
                                ],
                                "env": [
                                    {
                                        "name": "REDIS_PASSWORD",
                                        "valueFrom": {
                                            "secretKeyRef": {
                                                "name": "dify-credentials",
                                                "key": "redis-password"
                                            }
                                        }
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "500m",
                                        "memory": "1Gi"
                                    },
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "107374182400m"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "pvc-g9te9f",
                                        "mountPath": "/data"
                                    },
                                    {
                                        "name": "kube-api-access-75fkt",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "livenessProbe": {
                                    "exec": {
                                        "command": [
                                            "redis-cli",
                                            "ping"
                                        ]
                                    },
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 10,
                        "dnsPolicy": "ClusterFirst",
                        "nodeSelector": {
                            "kubernetes.io/os": "linux"
                        },
                        "serviceAccountName": "dify-redis",
                        "serviceAccount": "dify-redis",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "hostname": "dify-redis-0",
                        "subdomain": "dify-redis",
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:44:04Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:45:31Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:45:31Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:44:04Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.57.4",
                        "podIPs": [
                            {
                                "ip": "172.21.57.4"
                            }
                        ],
                        "startTime": "2025-09-08T15:44:04Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T15:45:30Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/langgenius/redis:6-alpine",
                                "imageID": "registry.bingosoft.net/langgenius/redis@sha256:915aa8d4cd87b7469f440afc4f74afa9535d07ebafee17fd1f9b76800d2c0640",
                                "containerID": "containerd://7d4cc29f581752f0512ef599186c60dead2b7ec2c5d5da23f57d97818e20b07b",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "24487880n",
                "quantityUsageMemory": "85552Ki",
                "usageCPU": 0.025,
                "usageMemory": 0.0815887451171875,
                "limitResource": {
                    "cpu": 8,
                    "memory": 8,
                    "quantityCPU": "8",
                    "quantityMemory": "8Gi"
                },
                "RequestResource": {
                    "cpu": 4,
                    "memory": 8,
                    "quantityCPU": "4",
                    "quantityMemory": "8Gi"
                },
                "Name": "dify-pg-0",
                "CreationTimestamp": "2025-09-08T15:39:04Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "dify-pg-0",
                        "generateName": "dify-pg-",
                        "namespace": "dify",
                        "uid": "f4694f99-d40c-4f34-a3ea-346ace03f0bb",
                        "resourceVersion": "52172318",
                        "creationTimestamp": "2025-09-08T15:39:04Z",
                        "labels": {
                            "app": "dify-pg",
                            "controller-revision-hash": "dify-pg-66687c4fb8",
                            "preemptNodeResource": "10.203.52.101",
                            "statefulset.kubernetes.io/pod-name": "dify-pg-0"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.56.254\",\"isDefaultGateway\":true,\"hostNicName\":\"if00cfe9b7dbd07\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "StatefulSet",
                                "name": "dify-pg",
                                "uid": "3b75e8d3-dec6-47c0-a4a8-11791a6054c9",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:39:04Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {},
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:controller-revision-hash": {},
                                            "f:statefulset.kubernetes.io/pod-name": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"3b75e8d3-dec6-47c0-a4a8-11791a6054c9\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"container0\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"PGDATA\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"POSTGRES_DB\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"POSTGRES_PASSWORD\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    },
                                                    "k:{\"name\":\"POSTGRES_USER\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
                                                    }
                                                },
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:lifecycle": {},
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
                                                "f:ports": {
                                                    ".": {},
                                                    "k:{\"containerPort\":5432,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
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
                                                    "k:{\"mountPath\":\"/var/lib/postgresql/data\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostname": {},
                                        "f:nodeSelector": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:subdomain": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"pvc-odanxr\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:persistentVolumeClaim": {
                                                    ".": {},
                                                    "f:claimName": {}
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:39:06Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:40:31Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:40:31Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T15:40:37Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.56.254\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "pvc-odanxr",
                                "persistentVolumeClaim": {
                                    "claimName": "postgres-data"
                                }
                            },
                            {
                                "name": "kube-api-access-g2v7w",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "container0",
                                "image": "registry.bingosoft.net/langgenius/postgres:15-alpine",
                                "args": [
                                    "postgres",
                                    "-c",
                                    "max_connections=100",
                                    "-c",
                                    "shared_buffers=128MB",
                                    "-c",
                                    "work_mem=4MB",
                                    "-c",
                                    "maintenance_work_mem=64MB",
                                    "-c",
                                    "effective_cache_size=4096MB"
                                ],
                                "ports": [
                                    {
                                        "name": "pg-port",
                                        "containerPort": 5432,
                                        "protocol": "TCP"
                                    }
                                ],
                                "env": [
                                    {
                                        "name": "PGDATA",
                                        "value": "/var/lib/postgresql/data/pgdata"
                                    },
                                    {
                                        "name": "POSTGRES_DB",
                                        "value": "dify"
                                    },
                                    {
                                        "name": "POSTGRES_PASSWORD",
                                        "value": "difyai123456"
                                    },
                                    {
                                        "name": "POSTGRES_USER",
                                        "value": "postgres"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "8",
                                        "memory": "8Gi"
                                    },
                                    "requests": {
                                        "cpu": "4",
                                        "memory": "8Gi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "pvc-odanxr",
                                        "mountPath": "/var/lib/postgresql/data"
                                    },
                                    {
                                        "name": "kube-api-access-g2v7w",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "livenessProbe": {
                                    "exec": {
                                        "command": [
                                            "pg_isready",
                                            "-h",
                                            "dify-pg",
                                            "-U",
                                            "postgres",
                                            "-d",
                                            "dify"
                                        ]
                                    },
                                    "initialDelaySeconds": 5,
                                    "timeoutSeconds": 2,
                                    "periodSeconds": 5,
                                    "successThreshold": 1,
                                    "failureThreshold": 10
                                },
                                "lifecycle": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 10,
                        "dnsPolicy": "ClusterFirst",
                        "nodeSelector": {
                            "kubernetes.io/os": "linux"
                        },
                        "serviceAccountName": "dify-pg",
                        "serviceAccount": "dify-pg",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "hostname": "dify-pg-0",
                        "subdomain": "dify-pg",
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:39:06Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:40:37Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:40:37Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T15:39:06Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.56.254",
                        "podIPs": [
                            {
                                "ip": "172.21.56.254"
                            }
                        ],
                        "startTime": "2025-09-08T15:39:06Z",
                        "containerStatuses": [
                            {
                                "name": "container0",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T15:40:37Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.bingosoft.net/langgenius/postgres:15-alpine",
                                "imageID": "registry.bingosoft.net/langgenius/postgres@sha256:f4f4ec6cae3c252f4e2d313f17433b0bb64caf1d6aafbac0ea61c25269e6bf74",
                                "containerID": "containerd://6ccf0dac91d2297d3d8ffc824e8886222aec242d78914518697d59a408e7592a",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "8502355n",
                "quantityUsageMemory": "55124Ki",
                "usageCPU": 0.009,
                "usageMemory": 0.052570343017578125,
                "limitResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "RequestResource": {
                    "cpu": 0,
                    "memory": 0,
                    "quantityCPU": "0",
                    "quantityMemory": "0"
                },
                "Name": "loki-distributed-querier-0",
                "CreationTimestamp": "2025-09-08T06:00:34Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "loki-distributed-querier-0",
                        "generateName": "loki-distributed-querier-",
                        "namespace": "loki",
                        "uid": "2ca894aa-c2fa-4e33-8581-471bd178db0d",
                        "resourceVersion": "57320604",
                        "creationTimestamp": "2025-09-08T06:00:34Z",
                        "labels": {
                            "app.kubernetes.io/component": "querier",
                            "app.kubernetes.io/instance": "loki-distributed",
                            "app.kubernetes.io/name": "loki-distributed",
                            "app.kubernetes.io/part-of": "memberlist",
                            "controller-revision-hash": "loki-distributed-querier-5d5bf787c4",
                            "preemptNodeResource": "10.203.52.101",
                            "statefulset.kubernetes.io/pod-name": "loki-distributed-querier-0"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.0.85\",\"isDefaultGateway\":true,\"hostNicName\":\"if00d8164bb468a\"}]}",
                            "checksum/config": "0c4a5c995491739fbdecf36d9de5d7620781ef9c22b6bf850a05f0fe9a86a73f"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "StatefulSet",
                                "name": "loki-distributed-querier",
                                "uid": "f779a1a4-f23b-4c1b-b49f-0dde22e9bb54",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:00:34Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            ".": {},
                                            "f:checksum/config": {}
                                        },
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app.kubernetes.io/component": {},
                                            "f:app.kubernetes.io/instance": {},
                                            "f:app.kubernetes.io/name": {},
                                            "f:app.kubernetes.io/part-of": {},
                                            "f:controller-revision-hash": {},
                                            "f:statefulset.kubernetes.io/pod-name": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"f779a1a4-f23b-4c1b-b49f-0dde22e9bb54\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:affinity": {
                                            ".": {},
                                            "f:podAntiAffinity": {
                                                ".": {},
                                                "f:preferredDuringSchedulingIgnoredDuringExecution": {},
                                                "f:requiredDuringSchedulingIgnoredDuringExecution": {}
                                            }
                                        },
                                        "f:containers": {
                                            "k:{\"name\":\"querier\"}": {
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
                                                    "k:{\"containerPort\":3100,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
                                                        "f:protocol": {}
                                                    },
                                                    "k:{\"containerPort\":7946,\"protocol\":\"TCP\"}": {
                                                        ".": {},
                                                        "f:containerPort": {},
                                                        "f:name": {},
                                                        "f:protocol": {}
                                                    },
                                                    "k:{\"containerPort\":9095,\"protocol\":\"TCP\"}": {
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
                                                "f:resources": {},
                                                "f:securityContext": {
                                                    ".": {},
                                                    "f:allowPrivilegeEscalation": {},
                                                    "f:readOnlyRootFilesystem": {}
                                                },
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/etc/loki/config\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/loki\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/loki-distributed-runtime\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:hostname": {},
                                        "f:nodeSelector": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {
                                            ".": {},
                                            "f:fsGroup": {},
                                            "f:runAsGroup": {},
                                            "f:runAsNonRoot": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:serviceAccount": {},
                                        "f:serviceAccountName": {},
                                        "f:subdomain": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:topologySpreadConstraints": {
                                            ".": {},
                                            "k:{\"topologyKey\":\"kubernetes.io/hostname\",\"whenUnsatisfiable\":\"ScheduleAnyway\"}": {
                                                ".": {},
                                                "f:labelSelector": {},
                                                "f:maxSkew": {},
                                                "f:topologyKey": {},
                                                "f:whenUnsatisfiable": {}
                                            }
                                        },
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"config\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"data\"}": {
                                                ".": {},
                                                "f:emptyDir": {},
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"runtime-config\"}": {
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
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:00:35Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:04:29Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:04:30Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-16T09:09:16Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.0.85\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "config",
                                "configMap": {
                                    "name": "loki-distributed",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "runtime-config",
                                "configMap": {
                                    "name": "loki-distributed-runtime",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "data",
                                "emptyDir": {}
                            },
                            {
                                "name": "kube-api-access-mzxcl",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "querier",
                                "image": "registry.kube.io:5000/bingokube/grafana/loki:v2.8.3",
                                "args": [
                                    "-config.file=/etc/loki/config/config.yaml",
                                    "-target=querier",
                                    "--config.expand-env=true"
                                ],
                                "ports": [
                                    {
                                        "name": "http",
                                        "containerPort": 3100,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "grpc",
                                        "containerPort": 9095,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "http-memberlist",
                                        "containerPort": 7946,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {},
                                "volumeMounts": [
                                    {
                                        "name": "config",
                                        "mountPath": "/etc/loki/config"
                                    },
                                    {
                                        "name": "runtime-config",
                                        "mountPath": "/var/loki-distributed-runtime"
                                    },
                                    {
                                        "name": "data",
                                        "mountPath": "/var/loki"
                                    },
                                    {
                                        "name": "kube-api-access-mzxcl",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "livenessProbe": {
                                    "httpGet": {
                                        "path": "/ready",
                                        "port": "http",
                                        "scheme": "HTTP"
                                    },
                                    "initialDelaySeconds": 300,
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "readinessProbe": {
                                    "httpGet": {
                                        "path": "/ready",
                                        "port": "http",
                                        "scheme": "HTTP"
                                    },
                                    "initialDelaySeconds": 30,
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent",
                                "securityContext": {
                                    "readOnlyRootFilesystem": false,
                                    "allowPrivilegeEscalation": false
                                }
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "ClusterFirst",
                        "nodeSelector": {
                            "node-role.kubernetes.io/master": ""
                        },
                        "serviceAccountName": "loki-distributed",
                        "serviceAccount": "loki-distributed",
                        "nodeName": "10.203.52.101",
                        "securityContext": {
                            "runAsUser": 10001,
                            "runAsGroup": 10001,
                            "runAsNonRoot": true,
                            "fsGroup": 10001
                        },
                        "hostname": "loki-distributed-querier-0",
                        "subdomain": "loki-distributed-querier-headless",
                        "affinity": {
                            "podAntiAffinity": {
                                "requiredDuringSchedulingIgnoredDuringExecution": [
                                    {
                                        "labelSelector": {
                                            "matchLabels": {
                                                "app.kubernetes.io/component": "querier",
                                                "app.kubernetes.io/instance": "loki-distributed",
                                                "app.kubernetes.io/name": "loki-distributed"
                                            }
                                        },
                                        "topologyKey": "kubernetes.io/hostname"
                                    }
                                ],
                                "preferredDuringSchedulingIgnoredDuringExecution": [
                                    {
                                        "weight": 100,
                                        "podAffinityTerm": {
                                            "labelSelector": {
                                                "matchLabels": {
                                                    "app.kubernetes.io/component": "querier",
                                                    "app.kubernetes.io/instance": "loki-distributed",
                                                    "app.kubernetes.io/name": "loki-distributed"
                                                }
                                            },
                                            "topologyKey": "failure-domain.beta.kubernetes.io/zone"
                                        }
                                    }
                                ]
                            }
                        },
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "operator": "Exists",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority",
                        "topologySpreadConstraints": [
                            {
                                "maxSkew": 1,
                                "topologyKey": "kubernetes.io/hostname",
                                "whenUnsatisfiable": "ScheduleAnyway",
                                "labelSelector": {
                                    "matchLabels": {
                                        "app.kubernetes.io/component": "querier",
                                        "app.kubernetes.io/instance": "loki-distributed",
                                        "app.kubernetes.io/name": "loki-distributed"
                                    }
                                }
                            }
                        ]
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T06:00:35Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-16T09:09:16Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-16T09:09:16Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T06:00:35Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.0.85",
                        "podIPs": [
                            {
                                "ip": "172.21.0.85"
                            }
                        ],
                        "startTime": "2025-09-08T06:00:35Z",
                        "containerStatuses": [
                            {
                                "name": "querier",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-16T09:08:44Z"
                                    }
                                },
                                "lastState": {
                                    "terminated": {
                                        "exitCode": 1,
                                        "reason": "Error",
                                        "startedAt": "2025-09-16T09:03:31Z",
                                        "finishedAt": "2025-09-16T09:03:38Z",
                                        "containerID": "containerd://828b9040ce6e8a8ffb1762b2871459c589d46c4bef76e800a79ea6ce1e238b5a"
                                    }
                                },
                                "ready": true,
                                "restartCount": 8,
                                "image": "registry.kube.io:5000/bingokube/grafana/loki:v2.8.3",
                                "imageID": "registry.kube.io:5000/bingokube/grafana/loki@sha256:404c49c7315c7973d5f4744bd5f515e9ef29eb3a4584d6c7c2895feeb73dc31f",
                                "containerID": "containerd://3ff7f6edc0e86905285e8c2e4265f7c92eb927f85c481cb74221e444decf5d83",
                                "started": true
                            }
                        ],
                        "qosClass": "BestEffort"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            },
            {
                "resourceStatus": "Running",
                "quantityUsageCPU": "33135592n",
                "quantityUsageMemory": "765648Ki",
                "usageCPU": 0.034,
                "usageMemory": 0.7301788330078125,
                "limitResource": {
                    "cpu": 5,
                    "memory": 9.77,
                    "quantityCPU": "5",
                    "quantityMemory": "10000Mi"
                },
                "RequestResource": {
                    "cpu": 5,
                    "memory": 4.88,
                    "quantityCPU": "5",
                    "quantityMemory": "5000Mi"
                },
                "Name": "prometheus-5cdc75f4-72tkb",
                "CreationTimestamp": "2025-09-08T05:59:24Z",
                "phase": "Running",
                "Object": {
                    "metadata": {
                        "name": "prometheus-5cdc75f4-72tkb",
                        "generateName": "prometheus-5cdc75f4-",
                        "namespace": "monitoring",
                        "uid": "ec3fa838-a59b-48a7-9793-d4448b73b71c",
                        "resourceVersion": "51901500",
                        "creationTimestamp": "2025-09-08T05:59:24Z",
                        "labels": {
                            "app": "prometheus",
                            "pod-template-hash": "5cdc75f4",
                            "preemptNodeResource": "10.203.52.101"
                        },
                        "annotations": {
                            "bingokube-nvs.bingosoft.net/ipAllocated": "true",
                            "bingokube-nvs.bingosoft.net/ipAllocatedReason": "success",
                            "bingokube-nvs.bingosoft.net/networkInterfaces": "{\"networkInterface\":[{\"virtualNetworkId\":\"dvs-00dca6184b\",\"networkInterfaceIp\":\"172.21.55.48\",\"isDefaultGateway\":true,\"hostNicName\":\"if00b3ee9944d3d\"}]}"
                        },
                        "ownerReferences": [
                            {
                                "apiVersion": "apps/v1",
                                "kind": "ReplicaSet",
                                "name": "prometheus-5cdc75f4",
                                "uid": "59d0fa4c-7145-4bc6-a21a-b97fc683758d",
                                "controller": true,
                                "blockOwnerDeletion": true
                            }
                        ],
                        "finalizers": [
                            "bingokube-nvs.bingosoft.net/finalizer"
                        ],
                        "managedFields": [
                            {
                                "manager": "kube-controller-manager",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T05:59:24Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {},
                                        "f:generateName": {},
                                        "f:labels": {
                                            ".": {},
                                            "f:app": {},
                                            "f:pod-template-hash": {}
                                        },
                                        "f:ownerReferences": {
                                            ".": {},
                                            "k:{\"uid\":\"59d0fa4c-7145-4bc6-a21a-b97fc683758d\"}": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"agent-side\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:command": {},
                                                "f:env": {
                                                    ".": {},
                                                    "k:{\"name\":\"CHECK_PROMETHEUS\"}": {
                                                        ".": {},
                                                        "f:name": {},
                                                        "f:value": {}
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
                                                    "k:{\"mountPath\":\"/prometheus\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            },
                                            "k:{\"name\":\"prometheus\"}": {
                                                ".": {},
                                                "f:args": {},
                                                "f:command": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
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
                                                    "k:{\"mountPath\":\"/etc/prometheus/config\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/prometheus/rule\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/prometheus/secrets/etcd-certs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/prometheus\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:enableServiceLinks": {},
                                        "f:initContainers": {
                                            ".": {},
                                            "k:{\"name\":\"volume-mount-hack\"}": {
                                                ".": {},
                                                "f:command": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:name": {},
                                                "f:resources": {},
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/etc/prometheus/config\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/prometheus/rule\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    },
                                                    "k:{\"mountPath\":\"/etc/prometheus/secrets/etcd-certs\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/prometheus\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
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
                                            "k:{\"name\":\"prometheus-config\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"prometheus-db-volume\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:persistentVolumeClaim": {
                                                    ".": {},
                                                    "f:claimName": {}
                                                }
                                            },
                                            "k:{\"name\":\"prometheus-rule\"}": {
                                                ".": {},
                                                "f:configMap": {
                                                    ".": {},
                                                    "f:defaultMode": {},
                                                    "f:name": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"secret-etcd-certs\"}": {
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
                            },
                            {
                                "manager": "bingokube-scheduler",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T05:59:26Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:labels": {
                                            "f:preemptNodeResource": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubedupont-controller",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:00:08Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/ipAllocated": {},
                                            "f:bingokube-nvs.bingosoft.net/ipAllocatedReason": {}
                                        },
                                        "f:finalizers": {
                                            ".": {},
                                            "v:\"bingokube-nvs.bingosoft.net/finalizer\"": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kube-nvs",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:00:09Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:metadata": {
                                        "f:annotations": {
                                            "f:bingokube-nvs.bingosoft.net/networkInterfaces": {}
                                        }
                                    }
                                }
                            },
                            {
                                "manager": "kubelet",
                                "operation": "Update",
                                "apiVersion": "v1",
                                "time": "2025-09-08T06:00:15Z",
                                "fieldsType": "FieldsV1",
                                "fieldsV1": {
                                    "f:status": {
                                        "f:conditions": {
                                            "k:{\"type\":\"ContainersReady\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Initialized\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            },
                                            "k:{\"type\":\"Ready\"}": {
                                                ".": {},
                                                "f:lastProbeTime": {},
                                                "f:lastTransitionTime": {},
                                                "f:status": {},
                                                "f:type": {}
                                            }
                                        },
                                        "f:containerStatuses": {},
                                        "f:hostIP": {},
                                        "f:initContainerStatuses": {},
                                        "f:phase": {},
                                        "f:podIP": {},
                                        "f:podIPs": {
                                            ".": {},
                                            "k:{\"ip\":\"172.21.55.48\"}": {
                                                ".": {},
                                                "f:ip": {}
                                            }
                                        },
                                        "f:startTime": {}
                                    }
                                },
                                "subresource": "status"
                            }
                        ]
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "prometheus-config",
                                "configMap": {
                                    "name": "prometheus-config",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "prometheus-rule",
                                "configMap": {
                                    "name": "prometheus-rule",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "prometheus-db-volume",
                                "persistentVolumeClaim": {
                                    "claimName": "prometheus-db-volume"
                                }
                            },
                            {
                                "name": "secret-etcd-certs",
                                "secret": {
                                    "secretName": "etcd-certs",
                                    "defaultMode": 420
                                }
                            },
                            {
                                "name": "kube-api-access-88745",
                                "projected": {
                                    "sources": [
                                        {
                                            "serviceAccountToken": {
                                                "expirationSeconds": 3607,
                                                "path": "token"
                                            }
                                        },
                                        {
                                            "configMap": {
                                                "name": "kube-root-ca.crt",
                                                "items": [
                                                    {
                                                        "key": "ca.crt",
                                                        "path": "ca.crt"
                                                    }
                                                ]
                                            }
                                        },
                                        {
                                            "downwardAPI": {
                                                "items": [
                                                    {
                                                        "path": "namespace",
                                                        "fieldRef": {
                                                            "apiVersion": "v1",
                                                            "fieldPath": "metadata.namespace"
                                                        }
                                                    }
                                                ]
                                            }
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "initContainers": [
                            {
                                "name": "volume-mount-hack",
                                "image": "registry.kube.io:5000/bingokube/opbox:1.0",
                                "command": [
                                    "sh",
                                    "/etc/prometheus/config/init.sh"
                                ],
                                "resources": {},
                                "volumeMounts": [
                                    {
                                        "name": "prometheus-db-volume",
                                        "mountPath": "/prometheus"
                                    },
                                    {
                                        "name": "prometheus-config",
                                        "mountPath": "/etc/prometheus/config"
                                    },
                                    {
                                        "name": "prometheus-rule",
                                        "mountPath": "/etc/prometheus/rule"
                                    },
                                    {
                                        "name": "secret-etcd-certs",
                                        "readOnly": true,
                                        "mountPath": "/etc/prometheus/secrets/etcd-certs"
                                    },
                                    {
                                        "name": "kube-api-access-88745",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            }
                        ],
                        "containers": [
                            {
                                "name": "prometheus",
                                "image": "registry.kube.io:5000/bingokube/prometheus/prometheus:v2.32.1",
                                "command": [
                                    "/bin/prometheus"
                                ],
                                "args": [
                                    "--config.file=/prometheus/config/prometheus.yml",
                                    "--storage.tsdb.path=/prometheus/data",
                                    "--web.enable-lifecycle",
                                    "--log.level=info",
                                    "--storage.tsdb.retention.time=7d",
                                    "--storage.tsdb.max-block-duration=10m"
                                ],
                                "ports": [
                                    {
                                        "containerPort": 9090,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "cpu": "5",
                                        "memory": "10000Mi"
                                    },
                                    "requests": {
                                        "cpu": "5",
                                        "memory": "5000Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "prometheus-config",
                                        "mountPath": "/etc/prometheus/config"
                                    },
                                    {
                                        "name": "prometheus-db-volume",
                                        "mountPath": "/prometheus"
                                    },
                                    {
                                        "name": "prometheus-rule",
                                        "mountPath": "/etc/prometheus/rule"
                                    },
                                    {
                                        "name": "secret-etcd-certs",
                                        "readOnly": true,
                                        "mountPath": "/etc/prometheus/secrets/etcd-certs"
                                    },
                                    {
                                        "name": "kube-api-access-88745",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                                    }
                                ],
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent"
                            },
                            {
                                "name": "agent-side",
                                "image": "registry.kube.io:5000/bingokube/agent-side:1.1.1",
                                "command": [
                                    "/apps/agent-side"
                                ],
                                "args": [
                                    "-p=/prometheus"
                                ],
                                "env": [
                                    {
                                        "name": "CHECK_PROMETHEUS",
                                        "value": "true"
                                    }
                                ],
                                "resources": {},
                                "volumeMounts": [
                                    {
                                        "name": "prometheus-db-volume",
                                        "mountPath": "/prometheus"
                                    },
                                    {
                                        "name": "kube-api-access-88745",
                                        "readOnly": true,
                                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
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
                            "node-role.kubernetes.io/master": ""
                        },
                        "serviceAccountName": "prometheus",
                        "serviceAccount": "prometheus",
                        "nodeName": "10.203.52.101",
                        "securityContext": {},
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node.kubernetes.io/not-ready",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            },
                            {
                                "key": "node.kubernetes.io/unreachable",
                                "operator": "Exists",
                                "effect": "NoExecute",
                                "tolerationSeconds": 300
                            }
                        ],
                        "priority": 0,
                        "enableServiceLinks": true,
                        "preemptionPolicy": "PreemptLowerPriority"
                    },
                    "status": {
                        "phase": "Running",
                        "conditions": [
                            {
                                "type": "Initialized",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T06:00:11Z"
                            },
                            {
                                "type": "Ready",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T06:00:15Z"
                            },
                            {
                                "type": "ContainersReady",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T06:00:15Z"
                            },
                            {
                                "type": "PodScheduled",
                                "status": "True",
                                "lastProbeTime": null,
                                "lastTransitionTime": "2025-09-08T05:59:26Z"
                            }
                        ],
                        "hostIP": "10.203.52.101",
                        "podIP": "172.21.55.48",
                        "podIPs": [
                            {
                                "ip": "172.21.55.48"
                            }
                        ],
                        "startTime": "2025-09-08T05:59:26Z",
                        "initContainerStatuses": [
                            {
                                "name": "volume-mount-hack",
                                "state": {
                                    "terminated": {
                                        "exitCode": 0,
                                        "reason": "Completed",
                                        "startedAt": "2025-09-08T06:00:10Z",
                                        "finishedAt": "2025-09-08T06:00:11Z",
                                        "containerID": "containerd://da9675251bceba306e931a334d8a2ec196f365f63c0915eadb13df3cec4e940e"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/opbox:1.0",
                                "imageID": "registry.kube.io:5000/bingokube/opbox@sha256:7fedf40d08614214aeb18ebe887d0fd710a5f9f6f4c56d9f6cfe2bbd7bbf9a28",
                                "containerID": "containerd://da9675251bceba306e931a334d8a2ec196f365f63c0915eadb13df3cec4e940e"
                            }
                        ],
                        "containerStatuses": [
                            {
                                "name": "agent-side",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T06:00:15Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/agent-side:1.1.1",
                                "imageID": "registry.kube.io:5000/bingokube/agent-side@sha256:92a1af076da73fc7b3efee3e5b609cb12e50c8b493d903e575079fac9f7ad172",
                                "containerID": "containerd://4d4e9b3f68df1d9d7726dfab167ad2fe1d301a6cf4e4df46c2ff756828959248",
                                "started": true
                            },
                            {
                                "name": "prometheus",
                                "state": {
                                    "running": {
                                        "startedAt": "2025-09-08T06:00:14Z"
                                    }
                                },
                                "lastState": {},
                                "ready": true,
                                "restartCount": 0,
                                "image": "registry.kube.io:5000/bingokube/prometheus/prometheus:v2.32.1",
                                "imageID": "registry.kube.io:5000/bingokube/prometheus/prometheus@sha256:c4819c653616d828ef7d86f96f35c5496b423935d4ee157a7f586ffbe8d7fc42",
                                "containerID": "containerd://1c52312f2c862e524e849fbf911edd0d35baa3a07a815675be339ee85c313faa",
                                "started": true
                            }
                        ],
                        "qosClass": "Burstable"
                    }
                },
                "releaseName": "",
                "otherFilterFields": {
                    "nodeName": "10.203.52.101"
                }
            }
        ],
        "count": 52
    }
}
```
节点1小时内事件, 10秒刷新一次

/verse-apis/v1/k8s/4a604bb5-aca5-41f4-be64-62042373c59d/-/events?page=1&pageSize=10&name=10.203.52.101&namespace=&kind=Node&keyword=&orderBy=lastTimestamp&ascending=false&creationTimestamp=2025-06-09T07%3A23%3A19Z
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "metadata": {
                    "name": "10.203.52.101.18596213aa3e5fb9",
                    "namespace": "default",
                    "uid": "716632c6-c52b-4f05-b4bc-4b9b613459ba",
                    "resourceVersion": "58503175",
                    "creationTimestamp": "2025-09-18T03:04:05Z",
                    "managedFields": [
                        {
                            "manager": "kubelet",
                            "operation": "Update",
                            "apiVersion": "v1",
                            "time": "2025-09-18T03:04:05Z",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            }
                        }
                    ]
                },
                "involvedObject": {
                    "kind": "Node",
                    "name": "10.203.52.101",
                    "uid": "10.203.52.101"
                },
                "reason": "FreeDiskSpaceFailed",
                "message": "(combined from similar events): failed to garbage collect required amount of images. Wanted to free 10759619379 bytes, but freed 0 bytes",
                "source": {
                    "component": "kubelet",
                    "host": "10.203.52.101"
                },
                "firstTimestamp": "2025-08-07T04:36:06Z",
                "lastTimestamp": "2025-09-18T03:54:05Z",
                "count": 8822,
                "type": "Warning",
                "eventTime": null,
                "reportingComponent": "",
                "reportingInstance": ""
            },
            {
                "metadata": {
                    "name": "10.203.52.101.1866412847a6f38c",
                    "namespace": "default",
                    "uid": "f64384c2-3ca1-467d-97cc-e96d1e07576a",
                    "resourceVersion": "58477464",
                    "creationTimestamp": "2025-09-18T02:59:05Z",
                    "managedFields": [
                        {
                            "manager": "kubelet",
                            "operation": "Update",
                            "apiVersion": "v1",
                            "time": "2025-09-18T02:59:05Z",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            }
                        }
                    ]
                },
                "involvedObject": {
                    "kind": "Node",
                    "name": "10.203.52.101",
                    "uid": "10.203.52.101"
                },
                "reason": "FreeDiskSpaceFailed",
                "message": "failed to garbage collect required amount of images. Wanted to free 10690286387 bytes, but freed 0 bytes",
                "source": {
                    "component": "kubelet",
                    "host": "10.203.52.101"
                },
                "firstTimestamp": "2025-09-18T02:59:05Z",
                "lastTimestamp": "2025-09-18T02:59:05Z",
                "count": 1,
                "type": "Warning",
                "eventTime": null,
                "reportingComponent": "",
                "reportingInstance": ""
            }
        ],
        "count": 2
    }
}
```


node-networkinterface， 网口


/verse-apis/v1/network/4a604bb5-aca5-41f4-be64-62042373c59d/node/networkInterfaces?nodeNic=%7B%22IsBindNic%22%3A1,%22nodes%22%3A%5B%7B%22name%22%3A%2210.203.52.101%22,%22ip%22%3A%2210.203.52.101%22%7D%5D,%22networkGroupId%22%3A%22%22%7D
```json
{
    "code": 200,
    "message": "success",
    "data": [
        {
            "nodeName": "10.203.52.101",
            "nodeIP": "10.203.52.101",
            "networkGroupId": "nicoutlet-00cf9476a0",
            "networkGroupName": "默认东西向业务口",
            "errorMsg": "",
            "ip": "10.203.52.101",
            "netDevice": "bond0",
            "status": "UP",
            "gateway": "10.203.52.254"
        }
    ]
}
```

节点设置标签：

污点
/verse-apis/v1/system/dictionary/items?total=true&dictionaryCode=node_taints_action
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "id": "ac78a0d7-848b-671a-33da-afaa2e5cad40",
                "code": "NoSchedule",
                "name": "阻止调度",
                "dictionaryCode": "node_taints_action",
                "dictionaryName": "污点-动作",
                "enable": 1,
                "order": 1,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-09-21T13:59:28.898825748+08:00"
            },
            {
                "id": "fd233294-f5c9-b214-ed4a-91c1ad85666a",
                "code": "PreferNoSchedule",
                "name": "尽可能阻止调度",
                "dictionaryCode": "node_taints_action",
                "dictionaryName": "污点-动作",
                "enable": 1,
                "order": 2,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-09-21T14:00:03.488460469+08:00"
            },
            {
                "id": "cd2681fe-ef7b-4b42-0b8d-1ccad453165f",
                "code": "NoExecute",
                "name": "阻止调度并驱逐现有容器组",
                "dictionaryCode": "node_taints_action",
                "dictionaryName": "污点-动作",
                "enable": 1,
                "order": 3,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-09-21T14:00:19.8561122+08:00"
            }
        ],
        "count": 3
    }
}
```

数量对不上，不知道从哪里来的
/verse-apis/v1/system/dictionary/items?total=true&dictionaryCode=node_labels
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "id": "028b618d-ab45-5bc8-2128-ba9161ad5f88",
                "code": "failure-domain.beta.kubernetes.io/zone",
                "name": "failure-domain.beta.kubernetes.io-zone",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:23:18.756672668+08:00"
            },
            {
                "id": "02aafd40-0e29-1be5-3e13-882269ba23fd",
                "code": "bingokube.bingosoft.net/oversoldratio",
                "name": "bingokube.bingosoft.net-oversoldratio",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:21:42.186593572+08:00"
            },
            {
                "id": "1acdbfc9-8682-2762-666c-149d3bc415f4",
                "code": "beta.kubernetes.io/arch",
                "name": "beta.kubernetes.io-arch",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T16:46:05.468154702+08:00"
            },
            {
                "id": "31b4b938-3a99-ce2e-ac82-b311edb328e4",
                "code": "kubernetes.io/os",
                "name": "kubernetes.io-os",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:22:02.494477419+08:00"
            },
            {
                "id": "53fd08a4-eef3-1f51-1903-2d59efdc46dd",
                "code": "beta.kubernetes.io/os",
                "name": "beta.kubernetes.io-os",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:19:36.967371795+08:00"
            },
            {
                "id": "83ce17f4-c010-c98d-891b-a40fad6a8e5d",
                "code": "bingokube.bingosoft.net/pool",
                "name": "bingokube.bingosoft.net-pool",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:20:03.092996716+08:00"
            },
            {
                "id": "855e0184-6ba0-0298-0c49-cbb2bd9d39ae",
                "code": "kubernetes.io/arch",
                "name": "kubernetes.io-arch",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:22:45.062036787+08:00"
            },
            {
                "id": "c7833c5a-63a1-3dcb-ba76-ab4dc4b29a0e",
                "code": "node-role.kubernetes.io/master",
                "name": "node-role.kubernetes.io-master",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:20:35.511305944+08:00"
            },
            {
                "id": "ebad8353-9ea9-bf58-6906-7940443219f4",
                "code": "kubernetes.io/hostname",
                "name": "kubernetes.io-hostname",
                "dictionaryCode": "node_labels",
                "dictionaryName": "标签",
                "enable": 1,
                "order": 99,
                "description": "",
                "createBy": "",
                "createByName": "",
                "createAt": "2023-10-18T18:22:25.636926846+08:00"
            }
        ],
        "count": 9
    }
}
```


