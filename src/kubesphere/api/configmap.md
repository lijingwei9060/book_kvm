
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/api/v1/namespaces/kube-system/configmaps/calico-config

```json
{
  "kind": "ConfigMap",
  "apiVersion": "v1",
  "metadata": {
    "name": "calico-config",
    "namespace": "kube-system",
    "uid": "c6b38f2d-f24c-4c8b-9595-df74a7e2c75c",
    "resourceVersion": "510",
    "creationTimestamp": "2024-07-08T02:04:43Z",
    "annotations": {
      "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"data\":{\"calico_backend\":\"bird\",\"cni_network_config\":\"{\\n  \\\"name\\\": \\\"k8s-pod-network\\\",\\n  \\\"cniVersion\\\": \\\"0.3.1\\\",\\n  \\\"plugins\\\": [\\n    {\\n      \\\"type\\\": \\\"calico\\\",\\n      \\\"log_level\\\": \\\"info\\\",\\n      \\\"log_file_path\\\": \\\"/var/log/calico/cni/cni.log\\\",\\n      \\\"datastore_type\\\": \\\"kubernetes\\\",\\n      \\\"nodename\\\": \\\"__KUBERNETES_NODE_NAME__\\\",\\n      \\\"mtu\\\": __CNI_MTU__,\\n      \\\"ipam\\\": {\\n          \\\"type\\\": \\\"calico-ipam\\\"\\n      },\\n      \\\"policy\\\": {\\n          \\\"type\\\": \\\"k8s\\\"\\n      },\\n      \\\"kubernetes\\\": {\\n          \\\"kubeconfig\\\": \\\"__KUBECONFIG_FILEPATH__\\\"\\n      }\\n    },\\n    {\\n      \\\"type\\\": \\\"portmap\\\",\\n      \\\"snat\\\": true,\\n      \\\"capabilities\\\": {\\\"portMappings\\\": true}\\n    },\\n    {\\n      \\\"type\\\": \\\"bandwidth\\\",\\n      \\\"capabilities\\\": {\\\"bandwidth\\\": true}\\n    }\\n  ]\\n}\",\"typha_service_name\":\"none\",\"veth_mtu\":\"0\"},\"kind\":\"ConfigMap\",\"metadata\":{\"annotations\":{},\"name\":\"calico-config\",\"namespace\":\"kube-system\"}}\n"
    },
    "managedFields": [
      {
        "manager": "kubectl-client-side-apply",
        "operation": "Update",
        "apiVersion": "v1",
        "time": "2024-07-08T02:04:43Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:data": {
            ".": {},
            "f:calico_backend": {},
            "f:cni_network_config": {},
            "f:typha_service_name": {},
            "f:veth_mtu": {}
          },
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
  "data": {
    "calico_backend": "bird",
    "cni_network_config": "{\n  \"name\": \"k8s-pod-network\",\n  \"cniVersion\": \"0.3.1\",\n  \"plugins\": [\n    {\n      \"type\": \"calico\",\n      \"log_level\": \"info\",\n      \"log_file_path\": \"/var/log/calico/cni/cni.log\",\n      \"datastore_type\": \"kubernetes\",\n      \"nodename\": \"__KUBERNETES_NODE_NAME__\",\n      \"mtu\": __CNI_MTU__,\n      \"ipam\": {\n          \"type\": \"calico-ipam\"\n      },\n      \"policy\": {\n          \"type\": \"k8s\"\n      },\n      \"kubernetes\": {\n          \"kubeconfig\": \"__KUBECONFIG_FILEPATH__\"\n      }\n    },\n    {\n      \"type\": \"portmap\",\n      \"snat\": true,\n      \"capabilities\": {\"portMappings\": true}\n    },\n    {\n      \"type\": \"bandwidth\",\n      \"capabilities\": {\"bandwidth\": true}\n    }\n  ]\n}",
    "typha_service_name": "none",
    "veth_mtu": "0"
  }
}
```

