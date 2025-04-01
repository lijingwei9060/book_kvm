
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/pods?nodeName=ks-cloud-control-plane&limit=10&page=1

```json
{
 "items": [
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-apiserver-ks-cloud-control-plane",
    "namespace": "kube-system",
    "uid": "6048f473-88ae-43f1-9129-08b03d99da3a",
    "resourceVersion": "3292",
    "creationTimestamp": "2025-03-01T07:08:01Z",
    "labels": {
     "component": "kube-apiserver",
     "tier": "control-plane"
    },
    "annotations": {
     "kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint": "172.18.0.3:6443",
     "kubernetes.io/config.hash": "c3989e125ae09b5bc2ff8525c933b99a",
     "kubernetes.io/config.mirror": "c3989e125ae09b5bc2ff8525c933b99a",
     "kubernetes.io/config.seen": "2025-03-01T15:07:13.961618335+08:00",
     "kubernetes.io/config.source": "file",
     "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
    },
    "ownerReferences": [
     {
      "apiVersion": "v1",
      "kind": "Node",
      "name": "ks-cloud-control-plane",
      "uid": "92257b14-51ac-45b4-a328-e9183779c36c",
      "controller": true
     }
    ],
    "managedFields": [
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:08:00Z",
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
         "k:{\"uid\":\"92257b14-51ac-45b4-a328-e9183779c36c\"}": {}
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
           "k:{\"mountPath\":\"/etc/ca-certificates\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {},
            "f:readOnly": {}
           },
           "k:{\"mountPath\":\"/etc/kubernetes/pki\"}": {
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
           "k:{\"mountPath\":\"/usr/local/share/ca-certificates\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {},
            "f:readOnly": {}
           },
           "k:{\"mountPath\":\"/usr/share/ca-certificates\"}": {
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
         "k:{\"name\":\"ca-certs\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"etc-ca-certificates\"}": {
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
         "k:{\"name\":\"usr-local-share-ca-certificates\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"usr-share-ca-certificates\"}": {
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
      "time": "2025-03-01T07:08:04Z",
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
         "k:{\"ip\":\"172.18.0.3\"}": {
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
      "name": "ca-certs",
      "hostPath": {
       "path": "/etc/ssl/certs",
       "type": "DirectoryOrCreate"
      }
     },
     {
      "name": "etc-ca-certificates",
      "hostPath": {
       "path": "/etc/ca-certificates",
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
      "name": "usr-local-share-ca-certificates",
      "hostPath": {
       "path": "/usr/local/share/ca-certificates",
       "type": "DirectoryOrCreate"
      }
     },
     {
      "name": "usr-share-ca-certificates",
      "hostPath": {
       "path": "/usr/share/ca-certificates",
       "type": "DirectoryOrCreate"
      }
     }
    ],
    "containers": [
     {
      "name": "kube-apiserver",
      "image": "k8s.gcr.io/kube-apiserver:v1.23.12",
      "command": [
       "kube-apiserver",
       "--advertise-address=172.18.0.3",
       "--allow-privileged=true",
       "--authorization-mode=Node,RBAC",
       "--client-ca-file=/etc/kubernetes/pki/ca.crt",
       "--enable-admission-plugins=NodeRestriction",
       "--enable-bootstrap-token-auth=true",
       "--etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt",
       "--etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt",
       "--etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key",
       "--etcd-servers=https://127.0.0.1:2379",
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
       "--runtime-config=",
       "--secure-port=6443",
       "--service-account-issuer=https://kubernetes.default.svc.cluster.local",
       "--service-account-key-file=/etc/kubernetes/pki/sa.pub",
       "--service-account-signing-key-file=/etc/kubernetes/pki/sa.key",
       "--service-cluster-ip-range=10.96.0.0/16",
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
        "name": "ca-certs",
        "readOnly": true,
        "mountPath": "/etc/ssl/certs"
       },
       {
        "name": "etc-ca-certificates",
        "readOnly": true,
        "mountPath": "/etc/ca-certificates"
       },
       {
        "name": "k8s-certs",
        "readOnly": true,
        "mountPath": "/etc/kubernetes/pki"
       },
       {
        "name": "usr-local-share-ca-certificates",
        "readOnly": true,
        "mountPath": "/usr/local/share/ca-certificates"
       },
       {
        "name": "usr-share-ca-certificates",
        "readOnly": true,
        "mountPath": "/usr/share/ca-certificates"
       }
      ],
      "livenessProbe": {
       "httpGet": {
        "path": "/livez",
        "port": 6443,
        "host": "172.18.0.3",
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
        "host": "172.18.0.3",
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
        "host": "172.18.0.3",
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
    "nodeName": "ks-cloud-control-plane",
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
      "lastTransitionTime": "2025-03-01T07:07:14Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:33Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:33Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:14Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "172.18.0.3",
    "podIPs": [
     {
      "ip": "172.18.0.3"
     }
    ],
    "startTime": "2025-03-01T07:07:14Z",
    "containerStatuses": [
     {
      "name": "kube-apiserver",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:07:15Z"
       }
      },
      "lastState": {},
      "ready": true,
      "restartCount": 0,
      "image": "k8s.gcr.io/kube-apiserver:v1.23.12",
      "imageID": "docker.io/library/import-2022-09-22@sha256:700d90717cdfff7faaad1f4e268bb95b014009708e3a51c5f79591c6fd3be923",
      "containerID": "containerd://a29a53a840c631b3d43a18e7951b4b926003e8989f94c06ce461c53ecb35ab34",
      "started": true
     }
    ],
    "qosClass": "Burstable"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "etcd-ks-cloud-control-plane",
    "namespace": "kube-system",
    "uid": "c7179958-3cdf-45bd-bd9c-71200b9c2839",
    "resourceVersion": "3291",
    "creationTimestamp": "2025-03-01T07:08:00Z",
    "labels": {
     "component": "etcd",
     "tier": "control-plane"
    },
    "annotations": {
     "kubeadm.kubernetes.io/etcd.advertise-client-urls": "https://172.18.0.3:2379",
     "kubernetes.io/config.hash": "099cf57b39487279f1788434183ea3b8",
     "kubernetes.io/config.mirror": "099cf57b39487279f1788434183ea3b8",
     "kubernetes.io/config.seen": "2025-03-01T15:07:13.961600980+08:00",
     "kubernetes.io/config.source": "file",
     "seccomp.security.alpha.kubernetes.io/pod": "runtime/default"
    },
    "ownerReferences": [
     {
      "apiVersion": "v1",
      "kind": "Node",
      "name": "ks-cloud-control-plane",
      "uid": "92257b14-51ac-45b4-a328-e9183779c36c",
      "controller": true
     }
    ],
    "managedFields": [
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:07:59Z",
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
         "k:{\"uid\":\"92257b14-51ac-45b4-a328-e9183779c36c\"}": {}
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
      "time": "2025-03-01T07:08:04Z",
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
         "k:{\"ip\":\"172.18.0.3\"}": {
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
      "image": "k8s.gcr.io/etcd:3.5.1-0",
      "command": [
       "etcd",
       "--advertise-client-urls=https://172.18.0.3:2379",
       "--cert-file=/etc/kubernetes/pki/etcd/server.crt",
       "--client-cert-auth=true",
       "--data-dir=/var/lib/etcd",
       "--experimental-initial-corrupt-check=true",
       "--initial-advertise-peer-urls=https://172.18.0.3:2380",
       "--initial-cluster=ks-cloud-control-plane=https://172.18.0.3:2380",
       "--key-file=/etc/kubernetes/pki/etcd/server.key",
       "--listen-client-urls=https://127.0.0.1:2379,https://172.18.0.3:2379",
       "--listen-metrics-urls=http://127.0.0.1:2381",
       "--listen-peer-urls=https://172.18.0.3:2380",
       "--name=ks-cloud-control-plane",
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
        "host": "127.0.0.1",
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
        "host": "127.0.0.1",
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
    "nodeName": "ks-cloud-control-plane",
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
      "lastTransitionTime": "2025-03-01T07:07:14Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:59Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:59Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:14Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "172.18.0.3",
    "podIPs": [
     {
      "ip": "172.18.0.3"
     }
    ],
    "startTime": "2025-03-01T07:07:14Z",
    "containerStatuses": [
     {
      "name": "etcd",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:07:15Z"
       }
      },
      "lastState": {},
      "ready": true,
      "restartCount": 0,
      "image": "k8s.gcr.io/etcd:3.5.1-0",
      "imageID": "sha256:25f8c7f3da61c2a810effe5fa779cf80ca171afb0adf94c7cb51eb9a8546629d",
      "containerID": "containerd://9411f3761dc4a659f55366511504c233f6b1f3179b9fbbc4cfb2de4544031c73",
      "started": true
     }
    ],
    "qosClass": "Burstable"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-controller-84cf5fc97b-pb25f",
    "generateName": "ingress-nginx-controller-84cf5fc97b-",
    "namespace": "ingress-nginx",
    "uid": "11e3e381-e662-41c2-918f-6f9ae65a5e40",
    "resourceVersion": "3380",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "controller",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "pod-template-hash": "84cf5fc97b"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "061722c2f427731d7f9526b1291d4be66410f75e54f6f5a9c71cdb48e8a9cf33",
     "cni.projectcalico.org/podIP": "10.244.72.208/32",
     "cni.projectcalico.org/podIPs": "10.244.72.208/32"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "ReplicaSet",
      "name": "ingress-nginx-controller-84cf5fc97b",
      "uid": "00fcdd31-067a-4694-8a04-72767c9ff0ef",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:pod-template-hash": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"00fcdd31-067a-4694-8a04-72767c9ff0ef\"}": {}
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:06:03Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:08:15Z",
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
         "k:{\"ip\":\"10.244.72.208\"}": {
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
      "name": "webhook-cert",
      "secret": {
       "secretName": "ingress-nginx-admission",
       "defaultMode": 420
      }
     },
     {
      "name": "kube-api-access-tjx9w",
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
       },
       {
        "name": "kube-api-access-tjx9w",
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
    "serviceAccountName": "ingress-nginx",
    "serviceAccount": "ingress-nginx",
    "nodeName": "ks-cloud-control-plane",
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
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.208",
    "podIPs": [
     {
      "ip": "10.244.72.208"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "controller",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:08:04Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 255,
        "reason": "Unknown",
        "startedAt": "2024-07-09T06:57:20Z",
        "finishedAt": "2025-03-01T07:07:12Z",
        "containerID": "containerd://ec5efafa7640dd32b1f841ac23e63d081312f215040b3db99a681a223bda330a"
       }
      },
      "ready": true,
      "restartCount": 2,
      "image": "sha256:c1695499dda39b8ca2110fd8c371159187a9e388437a103c61bcfaf30c6d5658",
      "imageID": "registry.k8s.io/ingress-nginx/controller@sha256:31f47c1e202b39fadecf822a9b76370bd4baed199a005b3e7d4d1455f4fd3fe2",
      "containerID": "containerd://b4f60e4878616387abbde40999ab38e9ec46a79f8f4d93b4b8fcacfb24aebb81",
      "started": true
     }
    ],
    "qosClass": "Burstable"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-admission-patch-cxh6p",
    "generateName": "ingress-nginx-admission-patch-",
    "namespace": "ingress-nginx",
    "uid": "d8086d5c-a228-4cea-88b1-5b76e3dc4360",
    "resourceVersion": "963",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "admission-webhook",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3",
     "controller-uid": "e48b29ff-7b2c-4335-bea8-46910ab37328",
     "job-name": "ingress-nginx-admission-patch"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "800eb1a5cfc13670d56218dd4d2c636f2d11975c63729d1bca998a9ce19c48d9",
     "cni.projectcalico.org/podIP": "",
     "cni.projectcalico.org/podIPs": ""
    },
    "ownerReferences": [
     {
      "apiVersion": "batch/v1",
      "kind": "Job",
      "name": "ingress-nginx-admission-patch",
      "uid": "e48b29ff-7b2c-4335-bea8-46910ab37328",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {},
         "f:controller-uid": {},
         "f:job-name": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"e48b29ff-7b2c-4335-bea8-46910ab37328\"}": {}
        }
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:05:44Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:06:01Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         "k:{\"type\":\"ContainersReady\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Initialized\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Ready\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
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
         "k:{\"ip\":\"10.244.72.194\"}": {
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
      "name": "kube-api-access-nwp72",
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
      "volumeMounts": [
       {
        "name": "kube-api-access-nwp72",
        "readOnly": true,
        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
       }
      ],
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
    "nodeName": "ks-cloud-control-plane",
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
    "phase": "Completed",
    "conditions": [
     {
      "type": "Initialized",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z",
      "reason": "PodCompleted"
     },
     {
      "type": "Ready",
      "status": "False",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:06:00Z",
      "reason": "PodCompleted"
     },
     {
      "type": "ContainersReady",
      "status": "False",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:06:00Z",
      "reason": "PodCompleted"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.194",
    "podIPs": [
     {
      "ip": "10.244.72.194"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "patch",
      "state": {
       "terminated": {
        "exitCode": 0,
        "reason": "Completed",
        "startedAt": "2024-07-08T02:06:00Z",
        "finishedAt": "2024-07-08T02:06:00Z",
        "containerID": "containerd://a702a5f384c6a754538a7c352ec625573e967c893cfa15b94fef4d3236fb6666"
       }
      },
      "lastState": {},
      "ready": false,
      "restartCount": 1,
      "image": "sha256:c41e9fcadf5a291120de706b7dfa1af598b9f2ed5138b6dcb9f79a68aad0ef4c",
      "imageID": "registry.k8s.io/ingress-nginx/kube-webhook-certgen@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660",
      "containerID": "containerd://a702a5f384c6a754538a7c352ec625573e967c893cfa15b94fef4d3236fb6666",
      "started": false
     }
    ],
    "qosClass": "BestEffort"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "ingress-nginx-admission-create-cdkxl",
    "generateName": "ingress-nginx-admission-create-",
    "namespace": "ingress-nginx",
    "uid": "656d1eac-77d7-48d7-90b3-69bff5e46e3c",
    "resourceVersion": "943",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "app.kubernetes.io/component": "admission-webhook",
     "app.kubernetes.io/instance": "ingress-nginx",
     "app.kubernetes.io/name": "ingress-nginx",
     "app.kubernetes.io/part-of": "ingress-nginx",
     "app.kubernetes.io/version": "1.1.3",
     "controller-uid": "4503c0fe-f228-4642-9b59-7b31cb1c4e4d",
     "job-name": "ingress-nginx-admission-create"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "28e9e260afabe00bdaad9015b670bb4035621c9e08663e245a560f82623afe14",
     "cni.projectcalico.org/podIP": "",
     "cni.projectcalico.org/podIPs": ""
    },
    "ownerReferences": [
     {
      "apiVersion": "batch/v1",
      "kind": "Job",
      "name": "ingress-nginx-admission-create",
      "uid": "4503c0fe-f228-4642-9b59-7b31cb1c4e4d",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:app.kubernetes.io/component": {},
         "f:app.kubernetes.io/instance": {},
         "f:app.kubernetes.io/name": {},
         "f:app.kubernetes.io/part-of": {},
         "f:app.kubernetes.io/version": {},
         "f:controller-uid": {},
         "f:job-name": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"4503c0fe-f228-4642-9b59-7b31cb1c4e4d\"}": {}
        }
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:05:46Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:06:00Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         "k:{\"type\":\"ContainersReady\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Initialized\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
          "f:status": {},
          "f:type": {}
         },
         "k:{\"type\":\"Ready\"}": {
          ".": {},
          "f:lastProbeTime": {},
          "f:lastTransitionTime": {},
          "f:reason": {},
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
         "k:{\"ip\":\"10.244.72.197\"}": {
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
      "name": "kube-api-access-4rfb6",
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
      "volumeMounts": [
       {
        "name": "kube-api-access-4rfb6",
        "readOnly": true,
        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
       }
      ],
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
    "nodeName": "ks-cloud-control-plane",
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
    "phase": "Completed",
    "conditions": [
     {
      "type": "Initialized",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z",
      "reason": "PodCompleted"
     },
     {
      "type": "Ready",
      "status": "False",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:06:00Z",
      "reason": "PodCompleted"
     },
     {
      "type": "ContainersReady",
      "status": "False",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:06:00Z",
      "reason": "PodCompleted"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.197",
    "podIPs": [
     {
      "ip": "10.244.72.197"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "create",
      "state": {
       "terminated": {
        "exitCode": 0,
        "reason": "Completed",
        "startedAt": "2024-07-08T02:05:48Z",
        "finishedAt": "2024-07-08T02:05:56Z",
        "containerID": "containerd://cbf82c2c6b306ab415d1211921f6ccdab3c447290d178803ff7bd2d502b6029c"
       }
      },
      "lastState": {},
      "ready": false,
      "restartCount": 0,
      "image": "sha256:c41e9fcadf5a291120de706b7dfa1af598b9f2ed5138b6dcb9f79a68aad0ef4c",
      "imageID": "registry.k8s.io/ingress-nginx/kube-webhook-certgen@sha256:64d8c73dca984af206adf9d6d7e46aa550362b1d7a01f3a0a91b20cc67868660",
      "containerID": "containerd://cbf82c2c6b306ab415d1211921f6ccdab3c447290d178803ff7bd2d502b6029c",
      "started": false
     }
    ],
    "qosClass": "BestEffort"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "calico-node-4d6fd",
    "generateName": "calico-node-",
    "namespace": "kube-system",
    "uid": "819d6395-8448-467a-a63d-de50d78d69fb",
    "resourceVersion": "3403",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "controller-revision-hash": "5f9d4fcb",
     "k8s-app": "calico-node",
     "pod-template-generation": "1"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "DaemonSet",
      "name": "calico-node",
      "uid": "306a957b-66ae-4b48-a076-60633414f603",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:controller-revision-hash": {},
         "f:k8s-app": {},
         "f:pod-template-generation": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"306a957b-66ae-4b48-a076-60633414f603\"}": {}
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
         "k:{\"name\":\"calico-node\"}": {
          ".": {},
          "f:env": {
           ".": {},
           "k:{\"name\":\"CALICO_DISABLE_FILE_LOGGING\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"CALICO_IPV4POOL_IPIP\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"CALICO_IPV4POOL_VXLAN\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"CALICO_NETWORKING_BACKEND\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"CLUSTER_TYPE\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"DATASTORE_TYPE\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"FELIX_DEFAULTENDPOINTTOHOSTACTION\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"FELIX_HEALTHENABLED\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"FELIX_IPINIPMTU\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"FELIX_IPV6SUPPORT\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"FELIX_VXLANMTU\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"FELIX_WIREGUARDMTU\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"IP\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"IP_AUTODETECTION_METHOD\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"NODENAME\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:fieldRef": {}
            }
           },
           "k:{\"name\":\"WAIT_FOR_DATASTORE\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           }
          },
          "f:envFrom": {},
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
          "f:resources": {
           ".": {},
           "f:requests": {
            ".": {},
            "f:cpu": {}
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
           "k:{\"mountPath\":\"/host/etc/cni/net.d\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/lib/modules\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {},
            "f:readOnly": {}
           },
           "k:{\"mountPath\":\"/run/xtables.lock\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/sys/fs/\"}": {
            ".": {},
            "f:mountPath": {},
            "f:mountPropagation": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/var/lib/calico\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/var/log/calico/cni\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {},
            "f:readOnly": {}
           },
           "k:{\"mountPath\":\"/var/run/calico\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/var/run/nodeagent\"}": {
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
         "k:{\"name\":\"flexvol-driver\"}": {
          ".": {},
          "f:image": {},
          "f:imagePullPolicy": {},
          "f:name": {},
          "f:resources": {},
          "f:securityContext": {
           ".": {},
           "f:privileged": {}
          },
          "f:terminationMessagePath": {},
          "f:terminationMessagePolicy": {},
          "f:volumeMounts": {
           ".": {},
           "k:{\"mountPath\":\"/host/driver\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           }
          }
         },
         "k:{\"name\":\"install-cni\"}": {
          ".": {},
          "f:command": {},
          "f:env": {
           ".": {},
           "k:{\"name\":\"CNI_CONF_NAME\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           },
           "k:{\"name\":\"CNI_MTU\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"CNI_NETWORK_CONFIG\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"KUBERNETES_NODE_NAME\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:fieldRef": {}
            }
           },
           "k:{\"name\":\"SLEEP\"}": {
            ".": {},
            "f:name": {},
            "f:value": {}
           }
          },
          "f:envFrom": {},
          "f:image": {},
          "f:imagePullPolicy": {},
          "f:name": {},
          "f:resources": {},
          "f:securityContext": {
           ".": {},
           "f:privileged": {}
          },
          "f:terminationMessagePath": {},
          "f:terminationMessagePolicy": {},
          "f:volumeMounts": {
           ".": {},
           "k:{\"mountPath\":\"/host/etc/cni/net.d\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/host/opt/cni/bin\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           }
          }
         },
         "k:{\"name\":\"upgrade-ipam\"}": {
          ".": {},
          "f:command": {},
          "f:env": {
           ".": {},
           "k:{\"name\":\"CALICO_NETWORKING_BACKEND\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:configMapKeyRef": {}
            }
           },
           "k:{\"name\":\"KUBERNETES_NODE_NAME\"}": {
            ".": {},
            "f:name": {},
            "f:valueFrom": {
             ".": {},
             "f:fieldRef": {}
            }
           }
          },
          "f:envFrom": {},
          "f:image": {},
          "f:imagePullPolicy": {},
          "f:name": {},
          "f:resources": {},
          "f:securityContext": {
           ".": {},
           "f:privileged": {}
          },
          "f:terminationMessagePath": {},
          "f:terminationMessagePolicy": {},
          "f:volumeMounts": {
           ".": {},
           "k:{\"mountPath\":\"/host/opt/cni/bin\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/var/lib/cni/networks\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           }
          }
         }
        },
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
         "k:{\"name\":\"cni-bin-dir\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"cni-log-dir\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"cni-net-dir\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"flexvol-driver-host\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"host-local-net-dir\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"lib-modules\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"policysync\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"sysfs\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"var-lib-calico\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"var-run-calico\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"xtables-lock\"}": {
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
      "time": "2025-03-01T07:08:16Z",
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
         "k:{\"ip\":\"172.18.0.3\"}": {
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
      "name": "lib-modules",
      "hostPath": {
       "path": "/lib/modules",
       "type": ""
      }
     },
     {
      "name": "var-run-calico",
      "hostPath": {
       "path": "/var/run/calico",
       "type": ""
      }
     },
     {
      "name": "var-lib-calico",
      "hostPath": {
       "path": "/var/lib/calico",
       "type": ""
      }
     },
     {
      "name": "xtables-lock",
      "hostPath": {
       "path": "/run/xtables.lock",
       "type": "FileOrCreate"
      }
     },
     {
      "name": "sysfs",
      "hostPath": {
       "path": "/sys/fs/",
       "type": "DirectoryOrCreate"
      }
     },
     {
      "name": "cni-bin-dir",
      "hostPath": {
       "path": "/opt/cni/bin",
       "type": ""
      }
     },
     {
      "name": "cni-net-dir",
      "hostPath": {
       "path": "/etc/cni/net.d",
       "type": ""
      }
     },
     {
      "name": "cni-log-dir",
      "hostPath": {
       "path": "/var/log/calico/cni",
       "type": ""
      }
     },
     {
      "name": "host-local-net-dir",
      "hostPath": {
       "path": "/var/lib/cni/networks",
       "type": ""
      }
     },
     {
      "name": "policysync",
      "hostPath": {
       "path": "/var/run/nodeagent",
       "type": "DirectoryOrCreate"
      }
     },
     {
      "name": "flexvol-driver-host",
      "hostPath": {
       "path": "/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds",
       "type": "DirectoryOrCreate"
      }
     },
     {
      "name": "kube-api-access-j6lqg",
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
      "name": "upgrade-ipam",
      "image": "docker.io/calico/cni:v3.21.6",
      "command": [
       "/opt/cni/bin/calico-ipam",
       "-upgrade"
      ],
      "envFrom": [
       {
        "configMapRef": {
         "name": "kubernetes-services-endpoint",
         "optional": true
        }
       }
      ],
      "env": [
       {
        "name": "KUBERNETES_NODE_NAME",
        "valueFrom": {
         "fieldRef": {
          "apiVersion": "v1",
          "fieldPath": "spec.nodeName"
         }
        }
       },
       {
        "name": "CALICO_NETWORKING_BACKEND",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "calico_backend"
         }
        }
       }
      ],
      "resources": {},
      "volumeMounts": [
       {
        "name": "host-local-net-dir",
        "mountPath": "/var/lib/cni/networks"
       },
       {
        "name": "cni-bin-dir",
        "mountPath": "/host/opt/cni/bin"
       },
       {
        "name": "kube-api-access-j6lqg",
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
     },
     {
      "name": "install-cni",
      "image": "docker.io/calico/cni:v3.21.6",
      "command": [
       "/opt/cni/bin/install"
      ],
      "envFrom": [
       {
        "configMapRef": {
         "name": "kubernetes-services-endpoint",
         "optional": true
        }
       }
      ],
      "env": [
       {
        "name": "CNI_CONF_NAME",
        "value": "10-calico.conflist"
       },
       {
        "name": "CNI_NETWORK_CONFIG",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "cni_network_config"
         }
        }
       },
       {
        "name": "KUBERNETES_NODE_NAME",
        "valueFrom": {
         "fieldRef": {
          "apiVersion": "v1",
          "fieldPath": "spec.nodeName"
         }
        }
       },
       {
        "name": "CNI_MTU",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "veth_mtu"
         }
        }
       },
       {
        "name": "SLEEP",
        "value": "false"
       }
      ],
      "resources": {},
      "volumeMounts": [
       {
        "name": "cni-bin-dir",
        "mountPath": "/host/opt/cni/bin"
       },
       {
        "name": "cni-net-dir",
        "mountPath": "/host/etc/cni/net.d"
       },
       {
        "name": "kube-api-access-j6lqg",
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
     },
     {
      "name": "flexvol-driver",
      "image": "docker.io/calico/pod2daemon-flexvol:v3.21.6",
      "resources": {},
      "volumeMounts": [
       {
        "name": "flexvol-driver-host",
        "mountPath": "/host/driver"
       },
       {
        "name": "kube-api-access-j6lqg",
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
    "containers": [
     {
      "name": "calico-node",
      "image": "docker.io/calico/node:v3.21.6",
      "envFrom": [
       {
        "configMapRef": {
         "name": "kubernetes-services-endpoint",
         "optional": true
        }
       }
      ],
      "env": [
       {
        "name": "DATASTORE_TYPE",
        "value": "kubernetes"
       },
       {
        "name": "WAIT_FOR_DATASTORE",
        "value": "true"
       },
       {
        "name": "NODENAME",
        "valueFrom": {
         "fieldRef": {
          "apiVersion": "v1",
          "fieldPath": "spec.nodeName"
         }
        }
       },
       {
        "name": "CALICO_NETWORKING_BACKEND",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "calico_backend"
         }
        }
       },
       {
        "name": "CLUSTER_TYPE",
        "value": "k8s,bgp"
       },
       {
        "name": "IP",
        "value": "autodetect"
       },
       {
        "name": "CALICO_IPV4POOL_IPIP",
        "value": "Always"
       },
       {
        "name": "CALICO_IPV4POOL_VXLAN",
        "value": "Never"
       },
       {
        "name": "FELIX_IPINIPMTU",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "veth_mtu"
         }
        }
       },
       {
        "name": "FELIX_VXLANMTU",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "veth_mtu"
         }
        }
       },
       {
        "name": "FELIX_WIREGUARDMTU",
        "valueFrom": {
         "configMapKeyRef": {
          "name": "calico-config",
          "key": "veth_mtu"
         }
        }
       },
       {
        "name": "CALICO_DISABLE_FILE_LOGGING",
        "value": "true"
       },
       {
        "name": "FELIX_DEFAULTENDPOINTTOHOSTACTION",
        "value": "ACCEPT"
       },
       {
        "name": "FELIX_IPV6SUPPORT",
        "value": "false"
       },
       {
        "name": "FELIX_HEALTHENABLED",
        "value": "true"
       },
       {
        "name": "IP_AUTODETECTION_METHOD",
        "value": "interface=eth.*"
       }
      ],
      "resources": {
       "requests": {
        "cpu": "250m"
       }
      },
      "volumeMounts": [
       {
        "name": "cni-net-dir",
        "mountPath": "/host/etc/cni/net.d"
       },
       {
        "name": "lib-modules",
        "readOnly": true,
        "mountPath": "/lib/modules"
       },
       {
        "name": "xtables-lock",
        "mountPath": "/run/xtables.lock"
       },
       {
        "name": "var-run-calico",
        "mountPath": "/var/run/calico"
       },
       {
        "name": "var-lib-calico",
        "mountPath": "/var/lib/calico"
       },
       {
        "name": "policysync",
        "mountPath": "/var/run/nodeagent"
       },
       {
        "name": "sysfs",
        "mountPath": "/sys/fs/",
        "mountPropagation": "Bidirectional"
       },
       {
        "name": "cni-log-dir",
        "readOnly": true,
        "mountPath": "/var/log/calico/cni"
       },
       {
        "name": "kube-api-access-j6lqg",
        "readOnly": true,
        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
       }
      ],
      "livenessProbe": {
       "exec": {
        "command": [
         "/bin/calico-node",
         "-felix-live",
         "-bird-live"
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
         "/bin/calico-node",
         "-felix-ready",
         "-bird-ready"
        ]
       },
       "timeoutSeconds": 10,
       "periodSeconds": 10,
       "successThreshold": 1,
       "failureThreshold": 3
      },
      "lifecycle": {
       "preStop": {
        "exec": {
         "command": [
          "/bin/calico-node",
          "-shutdown"
         ]
        }
       }
      },
      "terminationMessagePath": "/dev/termination-log",
      "terminationMessagePolicy": "File",
      "imagePullPolicy": "IfNotPresent",
      "securityContext": {
       "privileged": true
      }
     }
    ],
    "restartPolicy": "Always",
    "terminationGracePeriodSeconds": 0,
    "dnsPolicy": "ClusterFirst",
    "nodeSelector": {
     "kubernetes.io/os": "linux"
    },
    "serviceAccountName": "calico-node",
    "serviceAccount": "calico-node",
    "nodeName": "ks-cloud-control-plane",
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
            "ks-cloud-control-plane"
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
      "key": "CriticalAddonsOnly",
      "operator": "Exists"
     },
     {
      "operator": "Exists",
      "effect": "NoExecute"
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
      "lastTransitionTime": "2025-03-01T07:07:46Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:16Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:16Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:04:43Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "172.18.0.3",
    "podIPs": [
     {
      "ip": "172.18.0.3"
     }
    ],
    "startTime": "2024-07-08T02:04:43Z",
    "initContainerStatuses": [
     {
      "name": "upgrade-ipam",
      "state": {
       "terminated": {
        "exitCode": 0,
        "reason": "Completed",
        "startedAt": "2025-03-01T07:07:26Z",
        "finishedAt": "2025-03-01T07:07:29Z",
        "containerID": "containerd://293afb69776d501018a038111a33b2a62c9b89492ec220dcc78cadee64f01679"
       }
      },
      "lastState": {},
      "ready": true,
      "restartCount": 0,
      "image": "docker.io/calico/cni:v3.21.6",
      "imageID": "docker.io/calico/cni@sha256:30dc6d5340c8094d4d6d3d8d47f454cb20dbc6a54a891dad19691ade0e19c55e",
      "containerID": "containerd://293afb69776d501018a038111a33b2a62c9b89492ec220dcc78cadee64f01679"
     },
     {
      "name": "install-cni",
      "state": {
       "terminated": {
        "exitCode": 0,
        "reason": "Completed",
        "startedAt": "2025-03-01T07:07:30Z",
        "finishedAt": "2025-03-01T07:07:45Z",
        "containerID": "containerd://debceb3eca898c9f79c66fd9fb6a43c8b950d1b7d6a389fd16f1f06fae3fc45d"
       }
      },
      "lastState": {},
      "ready": true,
      "restartCount": 0,
      "image": "docker.io/calico/cni:v3.21.6",
      "imageID": "docker.io/calico/cni@sha256:30dc6d5340c8094d4d6d3d8d47f454cb20dbc6a54a891dad19691ade0e19c55e",
      "containerID": "containerd://debceb3eca898c9f79c66fd9fb6a43c8b950d1b7d6a389fd16f1f06fae3fc45d"
     },
     {
      "name": "flexvol-driver",
      "state": {
       "terminated": {
        "exitCode": 0,
        "reason": "Completed",
        "startedAt": "2025-03-01T07:07:47Z",
        "finishedAt": "2025-03-01T07:07:47Z",
        "containerID": "containerd://088974fc308e0effe55769af8b74a0c89ce7e3aa04f0b583ea6cf331266f21b6"
       }
      },
      "lastState": {},
      "ready": true,
      "restartCount": 0,
      "image": "docker.io/calico/pod2daemon-flexvol:v3.21.6",
      "imageID": "docker.io/calico/pod2daemon-flexvol@sha256:a05e72b54f9909a1d1cd6e94e1176b06c844db710c639aa6a1f36462dc1a840c",
      "containerID": "containerd://088974fc308e0effe55769af8b74a0c89ce7e3aa04f0b583ea6cf331266f21b6"
     }
    ],
    "containerStatuses": [
     {
      "name": "calico-node",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:08:06Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 1,
        "reason": "Error",
        "startedAt": "2025-03-01T07:07:48Z",
        "finishedAt": "2025-03-01T07:07:52Z",
        "containerID": "containerd://573ef0dbec6837b0533e8f0c4bd119dda7601ebd792c5d22da11b900c3175f6b"
       }
      },
      "ready": true,
      "restartCount": 3,
      "image": "docker.io/calico/node:v3.21.6",
      "imageID": "docker.io/calico/node@sha256:89cc9adaca1d22b5aa34a0a824854c4f32b1d8db766af34a6a20c06d1f33606f",
      "containerID": "containerd://003de3ca8f08118f2ca9f810ffb8b7466f6df8783bae4c6e0e4a941d3558790b",
      "started": true
     }
    ],
    "qosClass": "Burstable"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "calico-kube-controllers-7f76d48f74-4qx4h",
    "generateName": "calico-kube-controllers-7f76d48f74-",
    "namespace": "kube-system",
    "uid": "6afe284f-deab-4ee3-87fe-dfdb8ae4fbf1",
    "resourceVersion": "3388",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "k8s-app": "calico-kube-controllers",
     "pod-template-hash": "7f76d48f74"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "e616d30160d44063a5e03552eb5abf1c742ab5863018fefe710071c25093b5c8",
     "cni.projectcalico.org/podIP": "10.244.72.205/32",
     "cni.projectcalico.org/podIPs": "10.244.72.205/32"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "ReplicaSet",
      "name": "calico-kube-controllers-7f76d48f74",
      "uid": "31bfc9e0-97be-4782-aa84-1d0c76113638",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:k8s-app": {},
         "f:pod-template-hash": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"31bfc9e0-97be-4782-aa84-1d0c76113638\"}": {}
        }
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:05:47Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:08:15Z",
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
         "k:{\"ip\":\"10.244.72.205\"}": {
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
      "name": "kube-api-access-flctb",
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
      "volumeMounts": [
       {
        "name": "kube-api-access-flctb",
        "readOnly": true,
        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
       }
      ],
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
    "nodeName": "ks-cloud-control-plane",
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
    "priorityClassName": "system-cluster-critical",
    "priority": 2000000000,
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
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.205",
    "podIPs": [
     {
      "ip": "10.244.72.205"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "calico-kube-controllers",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:08:04Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 255,
        "reason": "Unknown",
        "startedAt": "2024-07-09T06:57:21Z",
        "finishedAt": "2025-03-01T07:07:12Z",
        "containerID": "containerd://05fd359b5d59849ddd984c8f4f074ce06d788439c192363d0793a5693c3cf0a0"
       }
      },
      "ready": true,
      "restartCount": 2,
      "image": "docker.io/calico/kube-controllers:v3.21.6",
      "imageID": "docker.io/calico/kube-controllers@sha256:df3fc449c9ac90f7744bebc2c67a81904de27e7c938b845e317ff4ef00dd73f2",
      "containerID": "containerd://cdd265dac3b5c82608a13aaca293ccffb1b2fef29a1d40e109836b1c52f224d8",
      "started": true
     }
    ],
    "qosClass": "BestEffort"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "local-path-provisioner-58dc9cd8d9-5bkj7",
    "generateName": "local-path-provisioner-58dc9cd8d9-",
    "namespace": "local-path-storage",
    "uid": "d3b2c3d5-953f-4aaa-9f96-74200e9044ea",
    "resourceVersion": "3372",
    "creationTimestamp": "2024-07-08T02:04:23Z",
    "labels": {
     "app": "local-path-provisioner",
     "pod-template-hash": "58dc9cd8d9"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "3f89cc067709a9ed1f39c0b5b61e163d7a74096312f09b410fb5fa90f717ad16",
     "cni.projectcalico.org/podIP": "10.244.72.209/32",
     "cni.projectcalico.org/podIPs": "10.244.72.209/32"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "ReplicaSet",
      "name": "local-path-provisioner-58dc9cd8d9",
      "uid": "f293f5f3-097b-48fd-bda2-3fea355c3299",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:23Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:app": {},
         "f:pod-template-hash": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"f293f5f3-097b-48fd-bda2-3fea355c3299\"}": {}
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:23Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:05:43Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:08:12Z",
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
         "k:{\"ip\":\"10.244.72.209\"}": {
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
      "name": "config-volume",
      "configMap": {
       "name": "local-path-config",
       "defaultMode": 420
      }
     },
     {
      "name": "kube-api-access-92lq8",
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
       },
       {
        "name": "kube-api-access-92lq8",
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
     "kubernetes.io/os": "linux"
    },
    "serviceAccountName": "local-path-provisioner-service-account",
    "serviceAccount": "local-path-provisioner-service-account",
    "nodeName": "ks-cloud-control-plane",
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
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:12Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:12Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.209",
    "podIPs": [
     {
      "ip": "10.244.72.209"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "local-path-provisioner",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:08:12Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 255,
        "reason": "Unknown",
        "startedAt": "2024-07-09T06:57:31Z",
        "finishedAt": "2025-03-01T07:07:12Z",
        "containerID": "containerd://8dcd9dbdd90259f9b535dd209a26908b049bd4e27907fed28c74f3c321602aa5"
       }
      },
      "ready": true,
      "restartCount": 2,
      "image": "docker.io/kindest/local-path-provisioner:v0.0.22-kind.0",
      "imageID": "sha256:4c1e997385b8fb4ad4d1d3c7e5af7ff3f882e94d07cf5b78de9e889bc60830e6",
      "containerID": "containerd://bb4e7d69428f35487d0c241ad6b9a044703b20b10db45cd321c4063c32f6a857",
      "started": true
     }
    ],
    "qosClass": "BestEffort"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "kube-proxy-8mtbj",
    "generateName": "kube-proxy-",
    "namespace": "kube-system",
    "uid": "1fe3fee4-67e4-4438-b626-90f98e1ded79",
    "resourceVersion": "3113",
    "creationTimestamp": "2024-07-08T02:04:23Z",
    "labels": {
     "controller-revision-hash": "779d79d5d",
     "k8s-app": "kube-proxy",
     "pod-template-generation": "1"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "DaemonSet",
      "name": "kube-proxy",
      "uid": "b37dff54-e893-4152-937f-097a850df9ad",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:23Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:controller-revision-hash": {},
         "f:k8s-app": {},
         "f:pod-template-generation": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"b37dff54-e893-4152-937f-097a850df9ad\"}": {}
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
         "k:{\"name\":\"kube-proxy\"}": {
          ".": {},
          "f:command": {},
          "f:env": {
           ".": {},
           "k:{\"name\":\"NODE_NAME\"}": {
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
           "f:privileged": {}
          },
          "f:terminationMessagePath": {},
          "f:terminationMessagePolicy": {},
          "f:volumeMounts": {
           ".": {},
           "k:{\"mountPath\":\"/lib/modules\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {},
            "f:readOnly": {}
           },
           "k:{\"mountPath\":\"/run/xtables.lock\"}": {
            ".": {},
            "f:mountPath": {},
            "f:name": {}
           },
           "k:{\"mountPath\":\"/var/lib/kube-proxy\"}": {
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
         "k:{\"name\":\"kube-proxy\"}": {
          ".": {},
          "f:configMap": {
           ".": {},
           "f:defaultMode": {},
           "f:name": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"lib-modules\"}": {
          ".": {},
          "f:hostPath": {
           ".": {},
           "f:path": {},
           "f:type": {}
          },
          "f:name": {}
         },
         "k:{\"name\":\"xtables-lock\"}": {
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
      "time": "2025-03-01T07:07:43Z",
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
         "k:{\"ip\":\"172.18.0.3\"}": {
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
      "name": "kube-proxy",
      "configMap": {
       "name": "kube-proxy",
       "defaultMode": 420
      }
     },
     {
      "name": "xtables-lock",
      "hostPath": {
       "path": "/run/xtables.lock",
       "type": "FileOrCreate"
      }
     },
     {
      "name": "lib-modules",
      "hostPath": {
       "path": "/lib/modules",
       "type": ""
      }
     },
     {
      "name": "kube-api-access-5vzqj",
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
      "name": "kube-proxy",
      "image": "k8s.gcr.io/kube-proxy:v1.23.12",
      "command": [
       "/usr/local/bin/kube-proxy",
       "--config=/var/lib/kube-proxy/config.conf",
       "--hostname-override=$(NODE_NAME)"
      ],
      "env": [
       {
        "name": "NODE_NAME",
        "valueFrom": {
         "fieldRef": {
          "apiVersion": "v1",
          "fieldPath": "spec.nodeName"
         }
        }
       }
      ],
      "resources": {},
      "volumeMounts": [
       {
        "name": "kube-proxy",
        "mountPath": "/var/lib/kube-proxy"
       },
       {
        "name": "xtables-lock",
        "mountPath": "/run/xtables.lock"
       },
       {
        "name": "lib-modules",
        "readOnly": true,
        "mountPath": "/lib/modules"
       },
       {
        "name": "kube-api-access-5vzqj",
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
    "nodeSelector": {
     "kubernetes.io/os": "linux"
    },
    "serviceAccountName": "kube-proxy",
    "serviceAccount": "kube-proxy",
    "nodeName": "ks-cloud-control-plane",
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
            "ks-cloud-control-plane"
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
      "operator": "Exists"
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
      "lastTransitionTime": "2024-07-08T02:04:23Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:43Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:07:43Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:04:23Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "172.18.0.3",
    "podIPs": [
     {
      "ip": "172.18.0.3"
     }
    ],
    "startTime": "2024-07-08T02:04:23Z",
    "containerStatuses": [
     {
      "name": "kube-proxy",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:07:40Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 255,
        "reason": "Unknown",
        "startedAt": "2024-07-09T06:56:48Z",
        "finishedAt": "2025-03-01T07:07:12Z",
        "containerID": "containerd://970e1fe208f89809e35e7b1790fffcf6dddb717a38f031b99dfc0b59f2e67c84"
       }
      },
      "ready": true,
      "restartCount": 2,
      "image": "k8s.gcr.io/kube-proxy:v1.23.12",
      "imageID": "docker.io/library/import-2022-09-22@sha256:e88f1ac0ba0625e67466396b03d0798c3224ad0772e71457b1777e18d50e82fe",
      "containerID": "containerd://2ac672fee80db08acb8216e856a12a0894c1b2e072fab1036661ab4a3d218b0e",
      "started": true
     }
    ],
    "qosClass": "BestEffort"
   }
  },
  {
   "kind": "Pod",
   "apiVersion": "v1",
   "metadata": {
    "name": "coredns-64897985d-v4dx9",
    "generateName": "coredns-64897985d-",
    "namespace": "kube-system",
    "uid": "65ccf7e1-b757-41b8-b674-8d473de6edd0",
    "resourceVersion": "3398",
    "creationTimestamp": "2024-07-08T02:04:23Z",
    "labels": {
     "k8s-app": "kube-dns",
     "pod-template-hash": "64897985d"
    },
    "annotations": {
     "cni.projectcalico.org/containerID": "36977abdc87d8365d3dcd0be8980c1fc57580442c0d0e3a2d844b72f925e6c76",
     "cni.projectcalico.org/podIP": "10.244.72.206/32",
     "cni.projectcalico.org/podIPs": "10.244.72.206/32"
    },
    "ownerReferences": [
     {
      "apiVersion": "apps/v1",
      "kind": "ReplicaSet",
      "name": "coredns-64897985d",
      "uid": "415c00c2-7ab7-4404-9945-9a93f1af7e38",
      "controller": true,
      "blockOwnerDeletion": true
     }
    ],
    "managedFields": [
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:23Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:generateName": {},
        "f:labels": {
         ".": {},
         "f:k8s-app": {},
         "f:pod-template-hash": {}
        },
        "f:ownerReferences": {
         ".": {},
         "k:{\"uid\":\"415c00c2-7ab7-4404-9945-9a93f1af7e38\"}": {}
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
        "f:enableServiceLinks": {},
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
     },
     {
      "manager": "kube-scheduler",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:04:23Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:conditions": {
         ".": {},
         "k:{\"type\":\"PodScheduled\"}": {
          ".": {},
          "f:lastProbeTime": {},
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
     },
     {
      "manager": "calico",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2024-07-08T02:05:46Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:cni.projectcalico.org/containerID": {},
         "f:cni.projectcalico.org/podIP": {},
         "f:cni.projectcalico.org/podIPs": {}
        }
       }
      },
      "subresource": "status"
     },
     {
      "manager": "kubelet",
      "operation": "Update",
      "apiVersion": "v1",
      "time": "2025-03-01T07:08:15Z",
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
         "k:{\"ip\":\"10.244.72.206\"}": {
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
     },
     {
      "name": "kube-api-access-k7p6j",
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
       },
       {
        "name": "kube-api-access-k7p6j",
        "readOnly": true,
        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
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
    "nodeName": "ks-cloud-control-plane",
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
    "priorityClassName": "system-cluster-critical",
    "priority": 2000000000,
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
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     },
     {
      "type": "Ready",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "ContainersReady",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2025-03-01T07:08:15Z"
     },
     {
      "type": "PodScheduled",
      "status": "True",
      "lastProbeTime": null,
      "lastTransitionTime": "2024-07-08T02:05:30Z"
     }
    ],
    "hostIP": "172.18.0.3",
    "podIP": "10.244.72.206",
    "podIPs": [
     {
      "ip": "10.244.72.206"
     }
    ],
    "startTime": "2024-07-08T02:05:30Z",
    "containerStatuses": [
     {
      "name": "coredns",
      "state": {
       "running": {
        "startedAt": "2025-03-01T07:08:03Z"
       }
      },
      "lastState": {
       "terminated": {
        "exitCode": 255,
        "reason": "Unknown",
        "startedAt": "2024-07-09T06:57:21Z",
        "finishedAt": "2025-03-01T07:07:12Z",
        "containerID": "containerd://c988fe5e0f17632ba7c25105898cef00515f8074d8e5ebe2b663014b21c3f526"
       }
      },
      "ready": true,
      "restartCount": 2,
      "image": "k8s.gcr.io/coredns/coredns:v1.8.6",
      "imageID": "sha256:a4ca41631cc7ac19ce1be3ebf0314ac5f47af7c711f17066006db82ee3b75b03",
      "containerID": "containerd://36391b13c65b3f1e7087be51cccddc3caea030484bcf007f40c084a221c01c6f",
      "started": true
     }
    ],
    "qosClass": "Burstable"
   }
  }
 ],
 "totalItems": 13
}
```


