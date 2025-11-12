

kubectl apply --server-side=true -f ./kubeblocks_crds.yaml
helm install kubeblocks ./kubeblocks-1.0.1.tgz --namespace kb-system --create-namespace \
--set image.registry=apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com \
--set dataProtection.image.registry=apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com \
--set addonChartsImage.registry=apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com


install snapshot crd:
```shell
kubectl get crd volumesnapshotclasses.snapshot.storage.k8s.io
kubectl get crd volumesnapshots.snapshot.storage.k8s.io
kubectl get crd volumesnapshotcontents.snapshot.storage.k8s.io
```

```shell
# v8.2.0 is the latest version of the external-snapshotter, you can replace it with the version you need.
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v8.2.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
```



crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysql_audit_log:8.0.33
crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysql:8.0.35
crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/syncer:0.5.0
crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/jemalloc:5.3.0
crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/xtrabackup:8.0
crictl pull apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysqld-exporter:0.15.1


ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysql_audit_log:8.0.33 docker.io/apecloud/mysql_audit_log:8.0.33
ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysql:8.0.35         docker.io/apecloud/mysql:8.0.35
ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/syncer:0.5.0         docker.io/apecloud/syncer:0.5.0
ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/jemalloc:5.3.0         docker.io/apecloud/jemalloc:5.3.0
ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/xtrabackup:8.0         docker.io/apecloud/xtrabackup:8.0
ctr -n k8s.io images tag apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/mysqld-exporter:0.15.1         docker.io/apecloud/mysqld-exporter:0.15.1