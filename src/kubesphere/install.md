sudo apt install socat conntrack ebtables ipset -y
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | sh -
chmod +x kk

./kk create config --with-kubernetes v1.32.0 

10.16.161.21 i-A30BD74E 
10.16.161.35 i-339CEC54 
10.16.161.117 i-7FB86232 
10.16.161.21  i-a30bd74e 
10.16.161.35  i-339cec54 
10.16.161.117 i-7fb86232 


i-a30bd74e 10.16.161.21  iT%6,F7cR}w
i-339cec54 10.16.161.35  wF?3.Pq|3^C
i-7fb86232 10.16.161.117 bT;2B[UxL.m

- {name: i-a30bd74e, address: 10.16.161.21 , internalAddress: 10.16.161.21 , user: root, password: "iT%6,F7cR}w"}
- {name: i-339cec54, address: 10.16.161.35 , internalAddress: 10.16.161.35 , user: root, password: "wF?3.Pq|3^C"}
- {name: i-7fb86232, address: 10.16.161.117, internalAddress: 10.16.161.117, user: root, password: "bT;2B[UxL.m"}

```yaml
apiVersion: kubekey.kubesphere.io/v1alpha2
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: i-a30bd74e, address: 10.16.161.21 , internalAddress: 10.16.161.21 , user: root, password: "iT%6,F7cR}w"}
  - {name: i-339cec54, address: 10.16.161.35 , internalAddress: 10.16.161.35 , user: root, password: "wF?3.Pq|3^C"}
  - {name: i-7fb86232, address: 10.16.161.117, internalAddress: 10.16.161.117, user: root, password: "bT;2B[UxL.m"}
  roleGroups:
    etcd:
    - i-a30bd74e
    control-plane:
    - i-a30bd74e
    worker:
    - i-a30bd74e
    - i-339cec54
    - i-7fb86232
  controlPlaneEndpoint:
    ## Internal loadbalancer for apiservers 
    # internalLoadbalancer: haproxy

    domain: lb.kubesphere.local
    address: ""
    port: 6443
  kubernetes:
    version: v1.32.0
    clusterName: cluster.local
    autoRenewCerts: true
    containerManager: containerd
  etcd:
    type: kubekey
  network:
    plugin: calico
    kubePodsCIDR: 10.233.64.0/18
    kubeServiceCIDR: 10.233.0.0/18
    ## multus support. https://github.com/k8snetworkplumbingwg/multus-cni
    multusCNI:
      enabled: false
  registry:
    privateRegistry: ""
    namespaceOverride: ""
    registryMirrors: []
    insecureRegistries: []
  addons: []
```

./kk create cluster -f config-sample.yaml --with-local-storage
如需使用 openebs localpv，可在命令后添加参数 --with-local-storage


wget https://get.helm.sh/helm-v3.18.2-linux-amd64.tar.g

# 如果无法访问 charts.kubesphere.io, 可将 charts.kubesphere.io 替换为 charts.kubesphere.com.cn
helm upgrade --install -n kubesphere-system --create-namespace ks-core https://charts.kubesphere.com.cn/main/ks-core-1.1.4.tgz --set global.imageRegistry=swr.cn-southwest-2.myhuaweicloud.com/ks --set extension.imageRegistry=swr.cn-southwest-2.myhuaweicloud.com/ks --debug --wait