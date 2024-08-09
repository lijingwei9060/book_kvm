
## Install
curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.29.7+k3s1/k3s
chmod a+x /usr/local/bin/k3s
k3s server --write-kubeconfig-mode=644
k3s agent --server https://k3s.example.com --token mypassword

curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh - 
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - --flannel-backend none --token 12345

curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

K10c9b38551973b256291529b8cf3f34677a66ff4910f3be63c55cf153e2dcac4d3::server:642dd5cf0e30a86948e9bf4fd1f6eb08
K3S_TOKEN 使用的值存储在 Server 节点上的 /var/lib/rancher/k3s/server/node-token 中


/usr/local/bin/k3s-uninstall.sh // 卸载
## 禁用所有k3s组件

包括coredns，metrics-server，local-path，traefik和service-lb。此外，我们应该将flannel-backend设置为none，不能是vxlan，host-gw。
Write the below config to /etc/rancher/k3s/config.yaml
```yaml
flannel-backend: none
disable: [traefik, servicelb, coredns, metrics-server, local-storage]
```

## Set Loopback CNI

So we should set our local cni, Write the cni config to /etc/cni/net.d/99-loopback.conf
```json
{
  "cniVersion": "0.4.0",
  "name": "loopback",
  "type": "loopback",
  "plugins": [
    {
      "type": "loopback"
    }
  ]
}
```

It means the loopback type cni, should has binary in /opt/cni/bin. We should download from [cni-release](https://github.com/containernetworking/plugins/releases)

```shell
mkdir -p /opt/cni/bin
mv loopback /opt/cni/bin
chmod +x /opt/cni/bin/loopback
```

## 删除网卡
```shell
ip link set cni0 down
ip link set flannel.1 down
ip link delete cni0
ip link delete flannel.1
```


https://taozhi.medium.com/how-to-disable-k3s-cni-e5f9a87f2ae6


## pod 设置
```yaml
spec:
  spec:
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet

dnsPolicy: ClusterFirstWithHostNet 设置，该设置是使POD使用的k8s的dn
如果不加上dnsPolicy: ClusterFirstWithHostNet ，pod默认使用所在宿主主机使用的DNS，这样也会导致容器内不能通过service name 访问k8s集群中其他POD：
$ kubectl exec -it nginx-3035625259-vrj13 -- cat /etc/resolv.conf
nameserver 202.96.134.133

$ kubectl exec -it nginx-3035625259-vrj13 -- nslookup busybox
nslookup: can't resolve '(null)': Name does not resolve
nslookup: can't resolve 'busybox': Name does not resolve