
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/daemonsets?sortBy=createTime&limit=10

```json
{
 "items": [
  {
   "kind": "DaemonSet",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "calico-node",
    "namespace": "kube-system",
    "uid": "306a957b-66ae-4b48-a076-60633414f603",
    "resourceVersion": "3404",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
     "k8s-app": "calico-node"
    },
    "annotations": {
     "deprecated.daemonset.template.generation": "1",
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"DaemonSet\",\"metadata\":{\"annotations\":{},\"labels\":{\"k8s-app\":\"calico-node\"},\"name\":\"calico-node\",\"namespace\":\"kube-system\"},\"spec\":{\"selector\":{\"matchLabels\":{\"k8s-app\":\"calico-node\"}},\"template\":{\"metadata\":{\"labels\":{\"k8s-app\":\"calico-node\"}},\"spec\":{\"containers\":[{\"env\":[{\"name\":\"DATASTORE_TYPE\",\"value\":\"kubernetes\"},{\"name\":\"WAIT_FOR_DATASTORE\",\"value\":\"true\"},{\"name\":\"NODENAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}},{\"name\":\"CLUSTER_TYPE\",\"value\":\"k8s,bgp\"},{\"name\":\"IP\",\"value\":\"autodetect\"},{\"name\":\"CALICO_IPV4POOL_IPIP\",\"value\":\"Always\"},{\"name\":\"CALICO_IPV4POOL_VXLAN\",\"value\":\"Never\"},{\"name\":\"FELIX_IPINIPMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_VXLANMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_WIREGUARDMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"CALICO_DISABLE_FILE_LOGGING\",\"value\":\"true\"},{\"name\":\"FELIX_DEFAULTENDPOINTTOHOSTACTION\",\"value\":\"ACCEPT\"},{\"name\":\"FELIX_IPV6SUPPORT\",\"value\":\"false\"},{\"name\":\"FELIX_HEALTHENABLED\",\"value\":\"true\"},{\"name\":\"IP_AUTODETECTION_METHOD\",\"value\":\"interface=eth.*\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/node:v3.21.6\",\"lifecycle\":{\"preStop\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-shutdown\"]}}},\"livenessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-live\",\"-bird-live\"]},\"failureThreshold\":6,\"initialDelaySeconds\":10,\"periodSeconds\":10,\"timeoutSeconds\":10},\"name\":\"calico-node\",\"readinessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-ready\",\"-bird-ready\"]},\"periodSeconds\":10,\"timeoutSeconds\":10},\"resources\":{\"requests\":{\"cpu\":\"250m\"}},\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\",\"readOnly\":false},{\"mountPath\":\"/lib/modules\",\"name\":\"lib-modules\",\"readOnly\":true},{\"mountPath\":\"/run/xtables.lock\",\"name\":\"xtables-lock\",\"readOnly\":false},{\"mountPath\":\"/var/run/calico\",\"name\":\"var-run-calico\",\"readOnly\":false},{\"mountPath\":\"/var/lib/calico\",\"name\":\"var-lib-calico\",\"readOnly\":false},{\"mountPath\":\"/var/run/nodeagent\",\"name\":\"policysync\"},{\"mountPath\":\"/sys/fs/\",\"mountPropagation\":\"Bidirectional\",\"name\":\"sysfs\"},{\"mountPath\":\"/var/log/calico/cni\",\"name\":\"cni-log-dir\",\"readOnly\":true}]}],\"hostNetwork\":true,\"initContainers\":[{\"command\":[\"/opt/cni/bin/calico-ipam\",\"-upgrade\"],\"env\":[{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"upgrade-ipam\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/var/lib/cni/networks\",\"name\":\"host-local-net-dir\"},{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"}]},{\"command\":[\"/opt/cni/bin/install\"],\"env\":[{\"name\":\"CNI_CONF_NAME\",\"value\":\"10-calico.conflist\"},{\"name\":\"CNI_NETWORK_CONFIG\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"cni_network_config\",\"name\":\"calico-config\"}}},{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CNI_MTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"SLEEP\",\"value\":\"false\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"install-cni\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"},{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\"}]},{\"image\":\"docker.io/calico/pod2daemon-flexvol:v3.21.6\",\"name\":\"flexvol-driver\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/driver\",\"name\":\"flexvol-driver-host\"}]}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"},\"priorityClassName\":\"system-node-critical\",\"serviceAccountName\":\"calico-node\",\"terminationGracePeriodSeconds\":0,\"tolerations\":[{\"effect\":\"NoSchedule\",\"operator\":\"Exists\"},{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"effect\":\"NoExecute\",\"operator\":\"Exists\"}],\"volumes\":[{\"hostPath\":{\"path\":\"/lib/modules\"},\"name\":\"lib-modules\"},{\"hostPath\":{\"path\":\"/var/run/calico\"},\"name\":\"var-run-calico\"},{\"hostPath\":{\"path\":\"/var/lib/calico\"},\"name\":\"var-lib-calico\"},{\"hostPath\":{\"path\":\"/run/xtables.lock\",\"type\":\"FileOrCreate\"},\"name\":\"xtables-lock\"},{\"hostPath\":{\"path\":\"/sys/fs/\",\"type\":\"DirectoryOrCreate\"},\"name\":\"sysfs\"},{\"hostPath\":{\"path\":\"/opt/cni/bin\"},\"name\":\"cni-bin-dir\"},{\"hostPath\":{\"path\":\"/etc/cni/net.d\"},\"name\":\"cni-net-dir\"},{\"hostPath\":{\"path\":\"/var/log/calico/cni\"},\"name\":\"cni-log-dir\"},{\"hostPath\":{\"path\":\"/var/lib/cni/networks\"},\"name\":\"host-local-net-dir\"},{\"hostPath\":{\"path\":\"/var/run/nodeagent\",\"type\":\"DirectoryOrCreate\"},\"name\":\"policysync\"},{\"hostPath\":{\"path\":\"/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds\",\"type\":\"DirectoryOrCreate\"},\"name\":\"flexvol-driver-host\"}]}},\"updateStrategy\":{\"rollingUpdate\":{\"maxUnavailable\":1},\"type\":\"RollingUpdate\"}}}\n"
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
         "f:deprecated.daemonset.template.generation": {},
         "f:kubectl.kubernetes.io/last-applied-configuration": {}
        },
        "f:labels": {
         ".": {},
         "f:k8s-app": {}
        }
       },
       "f:spec": {
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:k8s-app": {}
          }
         },
         "f:spec": {
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
        },
        "f:updateStrategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2025-03-01T07:08:16Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:currentNumberScheduled": {},
        "f:desiredNumberScheduled": {},
        "f:numberAvailable": {},
        "f:numberReady": {},
        "f:observedGeneration": {},
        "f:updatedNumberScheduled": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "selector": {
     "matchLabels": {
      "k8s-app": "calico-node"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "k8s-app": "calico-node"
      }
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
      "hostNetwork": true,
      "securityContext": {},
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
       }
      ],
      "priorityClassName": "system-node-critical"
     }
    },
    "updateStrategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 1,
      "maxSurge": 0
     }
    },
    "revisionHistoryLimit": 10
   },
   "status": {
    "currentNumberScheduled": 2,
    "numberMisscheduled": 0,
    "desiredNumberScheduled": 2,
    "numberReady": 2,
    "observedGeneration": 1,
    "updatedNumberScheduled": 2,
    "numberAvailable": 2
   }
  },
  {
   "kind": "DaemonSet",
   "apiVersion": "apps/v1",
   "metadata": {
    "name": "kube-proxy",
    "namespace": "kube-system",
    "uid": "b37dff54-e893-4152-937f-097a850df9ad",
    "resourceVersion": "678",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:07Z",
    "labels": {
     "k8s-app": "kube-proxy"
    },
    "annotations": {
     "deprecated.daemonset.template.generation": "1"
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
        "f:annotations": {
         ".": {},
         "f:deprecated.daemonset.template.generation": {}
        },
        "f:labels": {
         ".": {},
         "f:k8s-app": {}
        }
       },
       "f:spec": {
        "f:revisionHistoryLimit": {},
        "f:selector": {},
        "f:template": {
         "f:metadata": {
          "f:labels": {
           ".": {},
           "f:k8s-app": {}
          }
         },
         "f:spec": {
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
        },
        "f:updateStrategy": {
         "f:rollingUpdate": {
          ".": {},
          "f:maxSurge": {},
          "f:maxUnavailable": {}
         },
         "f:type": {}
        }
       }
      }
     },
     {
      "manager": "kube-controller-manager",
      "operation": "Update",
      "apiVersion": "apps/v1",
      "time": "2024-07-08T02:04:49Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:status": {
        "f:currentNumberScheduled": {},
        "f:desiredNumberScheduled": {},
        "f:numberAvailable": {},
        "f:numberReady": {},
        "f:observedGeneration": {},
        "f:updatedNumberScheduled": {}
       }
      },
      "subresource": "status"
     }
    ]
   },
   "spec": {
    "selector": {
     "matchLabels": {
      "k8s-app": "kube-proxy"
     }
    },
    "template": {
     "metadata": {
      "creationTimestamp": null,
      "labels": {
       "k8s-app": "kube-proxy"
      }
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
      "hostNetwork": true,
      "securityContext": {},
      "schedulerName": "default-scheduler",
      "tolerations": [
       {
        "operator": "Exists"
       }
      ],
      "priorityClassName": "system-node-critical"
     }
    },
    "updateStrategy": {
     "type": "RollingUpdate",
     "rollingUpdate": {
      "maxUnavailable": 1,
      "maxSurge": 0
     }
    },
    "revisionHistoryLimit": 10
   },
   "status": {
    "currentNumberScheduled": 2,
    "numberMisscheduled": 0,
    "desiredNumberScheduled": 2,
    "numberReady": 2,
    "observedGeneration": 1,
    "updatedNumberScheduled": 2,
    "numberAvailable": 2
   }
  }
 ],
 "totalItems": 2
}
```

https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/apis/apps/v1/namespaces/kube-system/daemonsets/calico-node

```json
{
  "kind": "DaemonSet",
  "apiVersion": "apps/v1",
  "metadata": {
    "name": "calico-node",
    "namespace": "kube-system",
    "uid": "306a957b-66ae-4b48-a076-60633414f603",
    "resourceVersion": "3404",
    "generation": 1,
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "labels": {
      "k8s-app": "calico-node"
    },
    "annotations": {
      "deprecated.daemonset.template.generation": "1",
      "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"DaemonSet\",\"metadata\":{\"annotations\":{},\"labels\":{\"k8s-app\":\"calico-node\"},\"name\":\"calico-node\",\"namespace\":\"kube-system\"},\"spec\":{\"selector\":{\"matchLabels\":{\"k8s-app\":\"calico-node\"}},\"template\":{\"metadata\":{\"labels\":{\"k8s-app\":\"calico-node\"}},\"spec\":{\"containers\":[{\"env\":[{\"name\":\"DATASTORE_TYPE\",\"value\":\"kubernetes\"},{\"name\":\"WAIT_FOR_DATASTORE\",\"value\":\"true\"},{\"name\":\"NODENAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}},{\"name\":\"CLUSTER_TYPE\",\"value\":\"k8s,bgp\"},{\"name\":\"IP\",\"value\":\"autodetect\"},{\"name\":\"CALICO_IPV4POOL_IPIP\",\"value\":\"Always\"},{\"name\":\"CALICO_IPV4POOL_VXLAN\",\"value\":\"Never\"},{\"name\":\"FELIX_IPINIPMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_VXLANMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_WIREGUARDMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"CALICO_DISABLE_FILE_LOGGING\",\"value\":\"true\"},{\"name\":\"FELIX_DEFAULTENDPOINTTOHOSTACTION\",\"value\":\"ACCEPT\"},{\"name\":\"FELIX_IPV6SUPPORT\",\"value\":\"false\"},{\"name\":\"FELIX_HEALTHENABLED\",\"value\":\"true\"},{\"name\":\"IP_AUTODETECTION_METHOD\",\"value\":\"interface=eth.*\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/node:v3.21.6\",\"lifecycle\":{\"preStop\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-shutdown\"]}}},\"livenessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-live\",\"-bird-live\"]},\"failureThreshold\":6,\"initialDelaySeconds\":10,\"periodSeconds\":10,\"timeoutSeconds\":10},\"name\":\"calico-node\",\"readinessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-ready\",\"-bird-ready\"]},\"periodSeconds\":10,\"timeoutSeconds\":10},\"resources\":{\"requests\":{\"cpu\":\"250m\"}},\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\",\"readOnly\":false},{\"mountPath\":\"/lib/modules\",\"name\":\"lib-modules\",\"readOnly\":true},{\"mountPath\":\"/run/xtables.lock\",\"name\":\"xtables-lock\",\"readOnly\":false},{\"mountPath\":\"/var/run/calico\",\"name\":\"var-run-calico\",\"readOnly\":false},{\"mountPath\":\"/var/lib/calico\",\"name\":\"var-lib-calico\",\"readOnly\":false},{\"mountPath\":\"/var/run/nodeagent\",\"name\":\"policysync\"},{\"mountPath\":\"/sys/fs/\",\"mountPropagation\":\"Bidirectional\",\"name\":\"sysfs\"},{\"mountPath\":\"/var/log/calico/cni\",\"name\":\"cni-log-dir\",\"readOnly\":true}]}],\"hostNetwork\":true,\"initContainers\":[{\"command\":[\"/opt/cni/bin/calico-ipam\",\"-upgrade\"],\"env\":[{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"upgrade-ipam\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/var/lib/cni/networks\",\"name\":\"host-local-net-dir\"},{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"}]},{\"command\":[\"/opt/cni/bin/install\"],\"env\":[{\"name\":\"CNI_CONF_NAME\",\"value\":\"10-calico.conflist\"},{\"name\":\"CNI_NETWORK_CONFIG\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"cni_network_config\",\"name\":\"calico-config\"}}},{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CNI_MTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"SLEEP\",\"value\":\"false\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"install-cni\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"},{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\"}]},{\"image\":\"docker.io/calico/pod2daemon-flexvol:v3.21.6\",\"name\":\"flexvol-driver\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/driver\",\"name\":\"flexvol-driver-host\"}]}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"},\"priorityClassName\":\"system-node-critical\",\"serviceAccountName\":\"calico-node\",\"terminationGracePeriodSeconds\":0,\"tolerations\":[{\"effect\":\"NoSchedule\",\"operator\":\"Exists\"},{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"effect\":\"NoExecute\",\"operator\":\"Exists\"}],\"volumes\":[{\"hostPath\":{\"path\":\"/lib/modules\"},\"name\":\"lib-modules\"},{\"hostPath\":{\"path\":\"/var/run/calico\"},\"name\":\"var-run-calico\"},{\"hostPath\":{\"path\":\"/var/lib/calico\"},\"name\":\"var-lib-calico\"},{\"hostPath\":{\"path\":\"/run/xtables.lock\",\"type\":\"FileOrCreate\"},\"name\":\"xtables-lock\"},{\"hostPath\":{\"path\":\"/sys/fs/\",\"type\":\"DirectoryOrCreate\"},\"name\":\"sysfs\"},{\"hostPath\":{\"path\":\"/opt/cni/bin\"},\"name\":\"cni-bin-dir\"},{\"hostPath\":{\"path\":\"/etc/cni/net.d\"},\"name\":\"cni-net-dir\"},{\"hostPath\":{\"path\":\"/var/log/calico/cni\"},\"name\":\"cni-log-dir\"},{\"hostPath\":{\"path\":\"/var/lib/cni/networks\"},\"name\":\"host-local-net-dir\"},{\"hostPath\":{\"path\":\"/var/run/nodeagent\",\"type\":\"DirectoryOrCreate\"},\"name\":\"policysync\"},{\"hostPath\":{\"path\":\"/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds\",\"type\":\"DirectoryOrCreate\"},\"name\":\"flexvol-driver-host\"}]}},\"updateStrategy\":{\"rollingUpdate\":{\"maxUnavailable\":1},\"type\":\"RollingUpdate\"}}}\n"
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
              "f:deprecated.daemonset.template.generation": {},
              "f:kubectl.kubernetes.io/last-applied-configuration": {}
            },
            "f:labels": {
              ".": {},
              "f:k8s-app": {}
            }
          },
          "f:spec": {
            "f:revisionHistoryLimit": {},
            "f:selector": {},
            "f:template": {
              "f:metadata": {
                "f:labels": {
                  ".": {},
                  "f:k8s-app": {}
                }
              },
              "f:spec": {
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
            },
            "f:updateStrategy": {
              "f:rollingUpdate": {
                ".": {},
                "f:maxSurge": {},
                "f:maxUnavailable": {}
              },
              "f:type": {}
            }
          }
        }
      },
      {
        "manager": "kube-controller-manager",
        "operation": "Update",
        "apiVersion": "apps/v1",
        "time": "2025-03-01T07:08:16Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:status": {
            "f:currentNumberScheduled": {},
            "f:desiredNumberScheduled": {},
            "f:numberAvailable": {},
            "f:numberReady": {},
            "f:observedGeneration": {},
            "f:updatedNumberScheduled": {}
          }
        },
        "subresource": "status"
      }
    ]
  },
  "spec": {
    "selector": {
      "matchLabels": {
        "k8s-app": "calico-node"
      }
    },
    "template": {
      "metadata": {
        "creationTimestamp": null,
        "labels": {
          "k8s-app": "calico-node"
        }
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
        "hostNetwork": true,
        "securityContext": {},
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
          }
        ],
        "priorityClassName": "system-node-critical"
      }
    },
    "updateStrategy": {
      "type": "RollingUpdate",
      "rollingUpdate": {
        "maxUnavailable": 1,
        "maxSurge": 0
      }
    },
    "revisionHistoryLimit": 10
  },
  "status": {
    "currentNumberScheduled": 2,
    "numberMisscheduled": 0,
    "desiredNumberScheduled": 2,
    "numberReady": 2,
    "observedGeneration": 1,
    "updatedNumberScheduled": 2,
    "numberAvailable": 2
  }
}
```

// 所包含的pods
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/namespaces/kube-system/pods?ownerKind=DaemonSet&labelSelector=k8s-app%3Dcalico-node&page=1

// 修改记录
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/apis/apps/v1/namespaces/kube-system/controllerrevisions?labelSelector=k8s-app=calico-node
```json
{
  "kind": "ControllerRevisionList",
  "apiVersion": "apps/v1",
  "metadata": {
    "resourceVersion": "137541"
  },
  "items": [
    {
      "metadata": {
        "name": "calico-node-5f9d4fcb",
        "namespace": "kube-system",
        "uid": "9e52b13a-5c63-408a-971d-90a665f53a65",
        "resourceVersion": "568",
        "creationTimestamp": "2024-07-08T02:04:43Z",
        "labels": {
          "controller-revision-hash": "5f9d4fcb",
          "k8s-app": "calico-node"
        },
        "annotations": {
          "deprecated.daemonset.template.generation": "1",
          "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps/v1\",\"kind\":\"DaemonSet\",\"metadata\":{\"annotations\":{},\"labels\":{\"k8s-app\":\"calico-node\"},\"name\":\"calico-node\",\"namespace\":\"kube-system\"},\"spec\":{\"selector\":{\"matchLabels\":{\"k8s-app\":\"calico-node\"}},\"template\":{\"metadata\":{\"labels\":{\"k8s-app\":\"calico-node\"}},\"spec\":{\"containers\":[{\"env\":[{\"name\":\"DATASTORE_TYPE\",\"value\":\"kubernetes\"},{\"name\":\"WAIT_FOR_DATASTORE\",\"value\":\"true\"},{\"name\":\"NODENAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}},{\"name\":\"CLUSTER_TYPE\",\"value\":\"k8s,bgp\"},{\"name\":\"IP\",\"value\":\"autodetect\"},{\"name\":\"CALICO_IPV4POOL_IPIP\",\"value\":\"Always\"},{\"name\":\"CALICO_IPV4POOL_VXLAN\",\"value\":\"Never\"},{\"name\":\"FELIX_IPINIPMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_VXLANMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"FELIX_WIREGUARDMTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"CALICO_DISABLE_FILE_LOGGING\",\"value\":\"true\"},{\"name\":\"FELIX_DEFAULTENDPOINTTOHOSTACTION\",\"value\":\"ACCEPT\"},{\"name\":\"FELIX_IPV6SUPPORT\",\"value\":\"false\"},{\"name\":\"FELIX_HEALTHENABLED\",\"value\":\"true\"},{\"name\":\"IP_AUTODETECTION_METHOD\",\"value\":\"interface=eth.*\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/node:v3.21.6\",\"lifecycle\":{\"preStop\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-shutdown\"]}}},\"livenessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-live\",\"-bird-live\"]},\"failureThreshold\":6,\"initialDelaySeconds\":10,\"periodSeconds\":10,\"timeoutSeconds\":10},\"name\":\"calico-node\",\"readinessProbe\":{\"exec\":{\"command\":[\"/bin/calico-node\",\"-felix-ready\",\"-bird-ready\"]},\"periodSeconds\":10,\"timeoutSeconds\":10},\"resources\":{\"requests\":{\"cpu\":\"250m\"}},\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\",\"readOnly\":false},{\"mountPath\":\"/lib/modules\",\"name\":\"lib-modules\",\"readOnly\":true},{\"mountPath\":\"/run/xtables.lock\",\"name\":\"xtables-lock\",\"readOnly\":false},{\"mountPath\":\"/var/run/calico\",\"name\":\"var-run-calico\",\"readOnly\":false},{\"mountPath\":\"/var/lib/calico\",\"name\":\"var-lib-calico\",\"readOnly\":false},{\"mountPath\":\"/var/run/nodeagent\",\"name\":\"policysync\"},{\"mountPath\":\"/sys/fs/\",\"mountPropagation\":\"Bidirectional\",\"name\":\"sysfs\"},{\"mountPath\":\"/var/log/calico/cni\",\"name\":\"cni-log-dir\",\"readOnly\":true}]}],\"hostNetwork\":true,\"initContainers\":[{\"command\":[\"/opt/cni/bin/calico-ipam\",\"-upgrade\"],\"env\":[{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CALICO_NETWORKING_BACKEND\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"calico_backend\",\"name\":\"calico-config\"}}}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"upgrade-ipam\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/var/lib/cni/networks\",\"name\":\"host-local-net-dir\"},{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"}]},{\"command\":[\"/opt/cni/bin/install\"],\"env\":[{\"name\":\"CNI_CONF_NAME\",\"value\":\"10-calico.conflist\"},{\"name\":\"CNI_NETWORK_CONFIG\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"cni_network_config\",\"name\":\"calico-config\"}}},{\"name\":\"KUBERNETES_NODE_NAME\",\"valueFrom\":{\"fieldRef\":{\"fieldPath\":\"spec.nodeName\"}}},{\"name\":\"CNI_MTU\",\"valueFrom\":{\"configMapKeyRef\":{\"key\":\"veth_mtu\",\"name\":\"calico-config\"}}},{\"name\":\"SLEEP\",\"value\":\"false\"}],\"envFrom\":[{\"configMapRef\":{\"name\":\"kubernetes-services-endpoint\",\"optional\":true}}],\"image\":\"docker.io/calico/cni:v3.21.6\",\"name\":\"install-cni\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/opt/cni/bin\",\"name\":\"cni-bin-dir\"},{\"mountPath\":\"/host/etc/cni/net.d\",\"name\":\"cni-net-dir\"}]},{\"image\":\"docker.io/calico/pod2daemon-flexvol:v3.21.6\",\"name\":\"flexvol-driver\",\"securityContext\":{\"privileged\":true},\"volumeMounts\":[{\"mountPath\":\"/host/driver\",\"name\":\"flexvol-driver-host\"}]}],\"nodeSelector\":{\"kubernetes.io/os\":\"linux\"},\"priorityClassName\":\"system-node-critical\",\"serviceAccountName\":\"calico-node\",\"terminationGracePeriodSeconds\":0,\"tolerations\":[{\"effect\":\"NoSchedule\",\"operator\":\"Exists\"},{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"effect\":\"NoExecute\",\"operator\":\"Exists\"}],\"volumes\":[{\"hostPath\":{\"path\":\"/lib/modules\"},\"name\":\"lib-modules\"},{\"hostPath\":{\"path\":\"/var/run/calico\"},\"name\":\"var-run-calico\"},{\"hostPath\":{\"path\":\"/var/lib/calico\"},\"name\":\"var-lib-calico\"},{\"hostPath\":{\"path\":\"/run/xtables.lock\",\"type\":\"FileOrCreate\"},\"name\":\"xtables-lock\"},{\"hostPath\":{\"path\":\"/sys/fs/\",\"type\":\"DirectoryOrCreate\"},\"name\":\"sysfs\"},{\"hostPath\":{\"path\":\"/opt/cni/bin\"},\"name\":\"cni-bin-dir\"},{\"hostPath\":{\"path\":\"/etc/cni/net.d\"},\"name\":\"cni-net-dir\"},{\"hostPath\":{\"path\":\"/var/log/calico/cni\"},\"name\":\"cni-log-dir\"},{\"hostPath\":{\"path\":\"/var/lib/cni/networks\"},\"name\":\"host-local-net-dir\"},{\"hostPath\":{\"path\":\"/var/run/nodeagent\",\"type\":\"DirectoryOrCreate\"},\"name\":\"policysync\"},{\"hostPath\":{\"path\":\"/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds\",\"type\":\"DirectoryOrCreate\"},\"name\":\"flexvol-driver-host\"}]}},\"updateStrategy\":{\"rollingUpdate\":{\"maxUnavailable\":1},\"type\":\"RollingUpdate\"}}}\n"
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
            "apiVersion": "apps/v1",
            "time": "2024-07-08T02:04:43Z",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:data": {},
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:deprecated.daemonset.template.generation": {},
                  "f:kubectl.kubernetes.io/last-applied-configuration": {}
                },
                "f:labels": {
                  ".": {},
                  "f:controller-revision-hash": {},
                  "f:k8s-app": {}
                },
                "f:ownerReferences": {
                  ".": {},
                  "k:{\"uid\":\"306a957b-66ae-4b48-a076-60633414f603\"}": {}
                }
              },
              "f:revision": {}
            }
          }
        ]
      },
      "data": {
        "spec": {
          "template": {
            "$patch": "replace",
            "metadata": {
              "creationTimestamp": null,
              "labels": {
                "k8s-app": "calico-node"
              }
            },
            "spec": {
              "containers": [
                {
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
                          "key": "calico_backend",
                          "name": "calico-config"
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
                          "key": "veth_mtu",
                          "name": "calico-config"
                        }
                      }
                    },
                    {
                      "name": "FELIX_VXLANMTU",
                      "valueFrom": {
                        "configMapKeyRef": {
                          "key": "veth_mtu",
                          "name": "calico-config"
                        }
                      }
                    },
                    {
                      "name": "FELIX_WIREGUARDMTU",
                      "valueFrom": {
                        "configMapKeyRef": {
                          "key": "veth_mtu",
                          "name": "calico-config"
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
                  "envFrom": [
                    {
                      "configMapRef": {
                        "name": "kubernetes-services-endpoint",
                        "optional": true
                      }
                    }
                  ],
                  "image": "docker.io/calico/node:v3.21.6",
                  "imagePullPolicy": "IfNotPresent",
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
                  "livenessProbe": {
                    "exec": {
                      "command": [
                        "/bin/calico-node",
                        "-felix-live",
                        "-bird-live"
                      ]
                    },
                    "failureThreshold": 6,
                    "initialDelaySeconds": 10,
                    "periodSeconds": 10,
                    "successThreshold": 1,
                    "timeoutSeconds": 10
                  },
                  "name": "calico-node",
                  "readinessProbe": {
                    "exec": {
                      "command": [
                        "/bin/calico-node",
                        "-felix-ready",
                        "-bird-ready"
                      ]
                    },
                    "failureThreshold": 3,
                    "periodSeconds": 10,
                    "successThreshold": 1,
                    "timeoutSeconds": 10
                  },
                  "resources": {
                    "requests": {
                      "cpu": "250m"
                    }
                  },
                  "securityContext": {
                    "privileged": true
                  },
                  "terminationMessagePath": "/dev/termination-log",
                  "terminationMessagePolicy": "File",
                  "volumeMounts": [
                    {
                      "mountPath": "/host/etc/cni/net.d",
                      "name": "cni-net-dir"
                    },
                    {
                      "mountPath": "/lib/modules",
                      "name": "lib-modules",
                      "readOnly": true
                    },
                    {
                      "mountPath": "/run/xtables.lock",
                      "name": "xtables-lock"
                    },
                    {
                      "mountPath": "/var/run/calico",
                      "name": "var-run-calico"
                    },
                    {
                      "mountPath": "/var/lib/calico",
                      "name": "var-lib-calico"
                    },
                    {
                      "mountPath": "/var/run/nodeagent",
                      "name": "policysync"
                    },
                    {
                      "mountPath": "/sys/fs/",
                      "mountPropagation": "Bidirectional",
                      "name": "sysfs"
                    },
                    {
                      "mountPath": "/var/log/calico/cni",
                      "name": "cni-log-dir",
                      "readOnly": true
                    }
                  ]
                }
              ],
              "dnsPolicy": "ClusterFirst",
              "hostNetwork": true,
              "initContainers": [
                {
                  "command": [
                    "/opt/cni/bin/calico-ipam",
                    "-upgrade"
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
                          "key": "calico_backend",
                          "name": "calico-config"
                        }
                      }
                    }
                  ],
                  "envFrom": [
                    {
                      "configMapRef": {
                        "name": "kubernetes-services-endpoint",
                        "optional": true
                      }
                    }
                  ],
                  "image": "docker.io/calico/cni:v3.21.6",
                  "imagePullPolicy": "IfNotPresent",
                  "name": "upgrade-ipam",
                  "resources": {},
                  "securityContext": {
                    "privileged": true
                  },
                  "terminationMessagePath": "/dev/termination-log",
                  "terminationMessagePolicy": "File",
                  "volumeMounts": [
                    {
                      "mountPath": "/var/lib/cni/networks",
                      "name": "host-local-net-dir"
                    },
                    {
                      "mountPath": "/host/opt/cni/bin",
                      "name": "cni-bin-dir"
                    }
                  ]
                },
                {
                  "command": [
                    "/opt/cni/bin/install"
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
                          "key": "cni_network_config",
                          "name": "calico-config"
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
                          "key": "veth_mtu",
                          "name": "calico-config"
                        }
                      }
                    },
                    {
                      "name": "SLEEP",
                      "value": "false"
                    }
                  ],
                  "envFrom": [
                    {
                      "configMapRef": {
                        "name": "kubernetes-services-endpoint",
                        "optional": true
                      }
                    }
                  ],
                  "image": "docker.io/calico/cni:v3.21.6",
                  "imagePullPolicy": "IfNotPresent",
                  "name": "install-cni",
                  "resources": {},
                  "securityContext": {
                    "privileged": true
                  },
                  "terminationMessagePath": "/dev/termination-log",
                  "terminationMessagePolicy": "File",
                  "volumeMounts": [
                    {
                      "mountPath": "/host/opt/cni/bin",
                      "name": "cni-bin-dir"
                    },
                    {
                      "mountPath": "/host/etc/cni/net.d",
                      "name": "cni-net-dir"
                    }
                  ]
                },
                {
                  "image": "docker.io/calico/pod2daemon-flexvol:v3.21.6",
                  "imagePullPolicy": "IfNotPresent",
                  "name": "flexvol-driver",
                  "resources": {},
                  "securityContext": {
                    "privileged": true
                  },
                  "terminationMessagePath": "/dev/termination-log",
                  "terminationMessagePolicy": "File",
                  "volumeMounts": [
                    {
                      "mountPath": "/host/driver",
                      "name": "flexvol-driver-host"
                    }
                  ]
                }
              ],
              "nodeSelector": {
                "kubernetes.io/os": "linux"
              },
              "priorityClassName": "system-node-critical",
              "restartPolicy": "Always",
              "schedulerName": "default-scheduler",
              "securityContext": {},
              "serviceAccount": "calico-node",
              "serviceAccountName": "calico-node",
              "terminationGracePeriodSeconds": 0,
              "tolerations": [
                {
                  "effect": "NoSchedule",
                  "operator": "Exists"
                },
                {
                  "key": "CriticalAddonsOnly",
                  "operator": "Exists"
                },
                {
                  "effect": "NoExecute",
                  "operator": "Exists"
                }
              ],
              "volumes": [
                {
                  "hostPath": {
                    "path": "/lib/modules",
                    "type": ""
                  },
                  "name": "lib-modules"
                },
                {
                  "hostPath": {
                    "path": "/var/run/calico",
                    "type": ""
                  },
                  "name": "var-run-calico"
                },
                {
                  "hostPath": {
                    "path": "/var/lib/calico",
                    "type": ""
                  },
                  "name": "var-lib-calico"
                },
                {
                  "hostPath": {
                    "path": "/run/xtables.lock",
                    "type": "FileOrCreate"
                  },
                  "name": "xtables-lock"
                },
                {
                  "hostPath": {
                    "path": "/sys/fs/",
                    "type": "DirectoryOrCreate"
                  },
                  "name": "sysfs"
                },
                {
                  "hostPath": {
                    "path": "/opt/cni/bin",
                    "type": ""
                  },
                  "name": "cni-bin-dir"
                },
                {
                  "hostPath": {
                    "path": "/etc/cni/net.d",
                    "type": ""
                  },
                  "name": "cni-net-dir"
                },
                {
                  "hostPath": {
                    "path": "/var/log/calico/cni",
                    "type": ""
                  },
                  "name": "cni-log-dir"
                },
                {
                  "hostPath": {
                    "path": "/var/lib/cni/networks",
                    "type": ""
                  },
                  "name": "host-local-net-dir"
                },
                {
                  "hostPath": {
                    "path": "/var/run/nodeagent",
                    "type": "DirectoryOrCreate"
                  },
                  "name": "policysync"
                },
                {
                  "hostPath": {
                    "path": "/usr/libexec/kubernetes/kubelet-plugins/volume/exec/nodeagent~uds",
                    "type": "DirectoryOrCreate"
                  },
                  "name": "flexvol-driver-host"
                }
              ]
            }
          }
        }
      },
      "revision": 1
    }
  ]
}
```


