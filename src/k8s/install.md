## preinstall
### 关闭swap
```shell
swapoff -a
sed -i '/ swap / s/^(.*)$/#1/g' /etc/fstab
```

### 转 发 IPv4 并让 iptables 看到桥接流量
```shell
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
```

### 设置所需的 sysctl 参数，参数在重新启动后保持不变
```shell
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
```

## 安装容器运行时

### containerd

```shell
apt -y install containerd

mkdir /etc/containerd/
containerd config default > /etc/containerd/config.toml
grep sandbox_image /etc/containerd/config.toml
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g" /etc/containerd/config.toml #替换成阿里云镜像
```

在“[plugins."io.containerd.grpc.v1.cri".registry]”行下面添加以下一行：

[plugins."io.containerd.grpc.v1.cri".registry]
          config_path = "/etc/containerd/certs.d"



确认“[plugins."io.containerd.grpc.v1.cri".registry.mirrors]”里面的配置项已经清空：

[plugins."io.containerd.grpc.v1.cri".registry.mirrors]


配置containerd cgroup驱动程序systemd

替换 sed -i 's#SystemdCgroup = false#SystemdCgroup = true#g' /etc/containerd/config.toml

查看SystemdCgroup参数 grep SystemdCgroup /etc/containerd/config.toml

重启containerd： systemctl restart containerd


阿里云镜像加速
[plugins."io.containerd.grpc.v1.cri".registry]
  config_path = "/etc/containerd/certs.d"

[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
    endpoint = ["https://registry-1.docker.io"]

```shell
mkdir /etc/containerd/certs.d/docker.io -p

cat > /etc/containerd/certs.d/docker.io/hosts.toml << EOF
server = "https://registry-1.docker.io"
[host."https://we8dvwud.mirror.aliyuncs.com"]
  capabilities = ["pull", "resolve"]
EOF
  
systemctl daemon-reload && systemctl restart containerd
```



## 安装k8s

apt-get update && apt-get install -y apt-transport-https
curl -fsSL https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.29/deb/Release.key |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.29/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl



10.16.161.64 i-4A2FE681
10.16.161.24 i-C96CA55E
10.16.161.21 i-CC100C27

## master安装

kubeadm init \
--kubernetes-version=v1.29.2 \
--pod-network-cidr 172.16.0.0/16 \
--apiserver-advertise-address=10.16.161.64 \
--image-repository registry.aliyuncs.com/google_containers


Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.16.161.64:6443 --token rw1zoi.qr36tj7wykvlrbby \
        --discovery-token-ca-cert-hash sha256:b34c9e4721367dbe8e73ef35e000101daba68ebfd71fc3ae0a488c49433d3e66 

## 节点加入

root@i-C96CA55E:~# kubeadm join 10.16.161.64:6443 --token rw1zoi.qr36tj7wykvlrbby \
        --discovery-token-ca-cert-hash sha256:b34c9e4721367dbe8e73ef35e000101daba68ebfd71fc3ae0a488c49433d3e66 
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

## cluster 状态

root@i-4A2FE681:~# kubectl get nodes
NAME         STATUS     ROLES           AGE     VERSION
i-4a2fe681   NotReady   control-plane   4m27s   v1.29.2
i-c96ca55e   NotReady   <none>          2m9s    v1.29.2
i-cc100c27   NotReady   <none>          85s     v1.29.2


## 安装网络
curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O

vi calico.yaml

缺省有#号，把#号去掉，修改CIDR，与初始化集群的--pod-network-cidr=172.16.0.0/16一致。

- name: CALICO_IPV4POOL_CIDR
  value: "172.16.0.0/16"

kubectl apply -f calico.yaml