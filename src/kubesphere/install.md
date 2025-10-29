sudo apt install socat conntrack ebtables ipset -y
export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | sh -
chmod +x kk

./kk create config --with-kubernetes v1.32.0 

10.203.162.5 bcs-ubuntu-01
10.203.162.6 bcs-ubuntu-02
10.203.162.7 bcs-ubuntu-03 

- {name: bcs-ubuntu-01, address: 10.203.162.5, internalAddress: 10.203.162.5, user: root, password: "pass@word2"}
- {name: bcs-ubuntu-02, address: 10.203.162.6, internalAddress: 10.203.162.6, user: root, password: "pass@word2"}
- {name: bcs-ubuntu-03, address: 10.203.162.7, internalAddress: 10.203.162.7, user: root, password: "pass@word2"}

```yaml
apiVersion: kubekey.kubesphere.io/v1alpha2
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: bcs-ubuntu-01, address: 10.203.162.5, internalAddress: 10.203.162.5, user: root, password: "pass@kube02"}
  - {name: bcs-ubuntu-02, address: 10.203.162.6, internalAddress: 10.203.162.6, user: root, password: "pass@kube02"}
  - {name: bcs-ubuntu-03, address: 10.203.162.7, internalAddress: 10.203.162.7, user: root, password: "pass@kube02"}
  roleGroups:
    etcd:
    - bcs-ubuntu-01
    control-plane:
    - bcs-ubuntu-01
    worker:
    - bcs-ubuntu-01
    - bcs-ubuntu-02
    - bcs-ubuntu-03
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