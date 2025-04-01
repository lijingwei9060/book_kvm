

https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/resources.kubesphere.io/v1alpha3/persistentvolumeclaims?sortBy=createTime&limit=10

```json
{
 "items": [],
 "totalItems": 0
}
```



https://ks-console-oejwezfu.c.kubesphere.cloud:30443/clusters/host/kapis/storage.k8s.io/v1/storageclasses?sortBy=createTime&limit=10

```json
{
 "metadata": {
  "continue": "1",
  "remainingItemCount": 0
 },
 "items": [
  {
   "kind": "StorageClass",
   "apiVersion": "storage.k8s.io/v1",
   "metadata": {
    "name": "standard",
    "uid": "2c3cb552-68b0-4b8b-9f04-613b0cccba63",
    "resourceVersion": "2203",
    "creationTimestamp": "2024-07-08T02:04:08Z",
    "annotations": {
     "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"storage.k8s.io/v1\",\"kind\":\"StorageClass\",\"metadata\":{\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"true\"},\"name\":\"standard\"},\"provisioner\":\"rancher.io/local-path\",\"reclaimPolicy\":\"Delete\",\"volumeBindingMode\":\"WaitForFirstConsumer\"}\n",
     "kubesphere.io/pvc-count": "0",
     "storageclass.kubernetes.io/is-default-class": "true"
    },
    "managedFields": [
     {
      "manager": "kubectl-client-side-apply",
      "operation": "Update",
      "apiVersion": "storage.k8s.io/v1",
      "time": "2024-07-08T02:04:08Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:kubectl.kubernetes.io/last-applied-configuration": {},
         "f:storageclass.kubernetes.io/is-default-class": {}
        }
       },
       "f:provisioner": {},
       "f:reclaimPolicy": {},
       "f:volumeBindingMode": {}
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "storage.k8s.io/v1",
      "time": "2024-07-09T07:01:11Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:kubesphere.io/pvc-count": {}
        }
       }
      }
     }
    ]
   },
   "provisioner": "rancher.io/local-path",
   "reclaimPolicy": "Delete",
   "volumeBindingMode": "WaitForFirstConsumer"
  }
 ]
}
```