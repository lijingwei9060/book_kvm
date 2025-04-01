
https://ks-console-oejwezfu.c.kubesphere.cloud:30443/kapis/tenant.kubesphere.io/v1beta1/clusters?labelSelector=cluster-role.kubesphere.io%2Fhost%3D%2C%21cluster-role.kubesphere.io%2Fedge&limit=-1&sortBy=createTime&page=1

```json
{
 "items": [
  {
   "kind": "Cluster",
   "apiVersion": "cluster.kubesphere.io/v1alpha1",
   "metadata": {
    "name": "host",
    "uid": "4c8133b0-2f18-46af-b47f-c236c976018b",
    "resourceVersion": "133955",
    "generation": 675,
    "creationTimestamp": "2024-07-09T07:01:10Z",
    "labels": {
     "cluster-role.kubesphere.io/host": "",
     "kubesphere.io/managed": "true"
    },
    "annotations": {
     "kubesphere.io/description": "The description was created by KubeSphere automatically. It is recommended that you use the Host Cluster to manage clusters only and deploy workloads on Member Clusters."
    },
    "finalizers": [
     "finalizer.cluster.kubesphere.io"
    ],
    "managedFields": [
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "cluster.kubesphere.io/v1alpha1",
      "time": "2024-07-09T07:01:10Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:kubesphere.io/description": {}
        },
        "f:finalizers": {
         ".": {},
         "v:\"finalizer.cluster.kubesphere.io\"": {}
        },
        "f:labels": {
         ".": {},
         "f:cluster-role.kubesphere.io/host": {},
         "f:kubesphere.io/managed": {}
        }
       },
       "f:spec": {
        ".": {},
        "f:connection": {
         ".": {},
         "f:kubeconfig": {},
         "f:kubernetesAPIEndpoint": {},
         "f:type": {}
        },
        "f:provider": {}
       },
       "f:status": {
        ".": {},
        "f:conditions": {},
        "f:kubeSphereVersion": {},
        "f:kubernetesVersion": {},
        "f:nodeCount": {},
        "f:uid": {}
       }
      }
     }
    ]
   },
   "spec": {
    "provider": "kubesphere",
    "connection": {
     "type": "direct",
     "kubernetesAPIEndpoint": "https://10.96.0.1:443"
    }
   },
   "status": {
    "conditions": [
     {
      "type": "Ready",
      "status": "True",
      "lastUpdateTime": "2025-03-02T05:11:49Z",
      "lastTransitionTime": "2025-03-02T05:11:49Z",
      "reason": "Ready",
      "message": "Cluster is available now"
     }
    ],
    "kubernetesVersion": "v1.23.12",
    "kubeSphereVersion": "v4.1.1",
    "nodeCount": 2,
    "uid": "23e828d8-3f16-415a-91ca-5f9fdb26a01d"
   }
  }
 ],
 "totalItems": 1
}
```