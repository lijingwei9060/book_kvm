https://ks-console-oejwezfu.c.kubesphere.cloud:30443/kapis/iam.kubesphere.io/v1beta1/users

```json
{
 "items": [
  {
   "kind": "User",
   "apiVersion": "iam.kubesphere.io/v1beta1",
   "metadata": {
    "name": "admin",
    "uid": "719ab61b-a184-4530-8e40-e78439dcca69",
    "resourceVersion": "133901",
    "generation": 4,
    "creationTimestamp": "2024-07-09T07:00:31Z",
    "labels": {
     "app.kubernetes.io/managed-by": "Helm"
    },
    "annotations": {
     "iam.kubesphere.io/globalrole": "platform-admin",
     "iam.kubesphere.io/last-password-change-time": "2025-03-02T05:11:15Z",
     "kubesphere.io/creator": "system",
     "meta.helm.sh/release-name": "ks-core",
     "meta.helm.sh/release-namespace": "kubesphere-system"
    },
    "finalizers": [
     "finalizers.kubesphere.io/users"
    ],
    "managedFields": [
     {
      "manager": "helm",
      "operation": "Update",
      "apiVersion": "iam.kubesphere.io/v1beta1",
      "time": "2024-07-09T07:00:31Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         ".": {},
         "f:iam.kubesphere.io/globalrole": {},
         "f:kubesphere.io/creator": {},
         "f:meta.helm.sh/release-name": {},
         "f:meta.helm.sh/release-namespace": {}
        },
        "f:labels": {
         ".": {},
         "f:app.kubernetes.io/managed-by": {}
        }
       },
       "f:spec": {
        ".": {},
        "f:email": {}
       },
       "f:status": {
        ".": {},
        "f:state": {}
       }
      }
     },
     {
      "manager": "controller-manager",
      "operation": "Update",
      "apiVersion": "iam.kubesphere.io/v1beta1",
      "time": "2025-03-02T05:11:15Z",
      "fieldsType": "FieldsV1",
      "fieldsV1": {
       "f:metadata": {
        "f:annotations": {
         "f:iam.kubesphere.io/last-password-change-time": {}
        },
        "f:finalizers": {
         ".": {},
         "v:\"finalizers.kubesphere.io/users\"": {}
        }
       },
       "f:spec": {
        "f:password": {}
       },
       "f:status": {
        "f:lastLoginTime": {}
       }
      }
     }
    ]
   },
   "spec": {
    "email": "admin@kubesphere.io"
   },
   "status": {
    "state": "Active",
    "lastLoginTime": "2025-03-02T05:11:01Z"
   }
  }
 ],
 "totalItems": 1
}
```

