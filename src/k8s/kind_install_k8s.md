# index

## 不要使用大写的主机名

hostnamectl set-hostname master
hostnamectl set-hostname work2
hostnamectl set-hostname work3

```text
10.16.161.21 master
10.16.161.117 work2
10.16.161.35  work3
```

## ipv4 forward

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

modprobe br_netfilter
echo '1' | tee /proc/sys/net/bridge/bridge-nf-call-iptables
nano /etc/sysctl.conf
在文件的末尾添加以下两行配置
net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward = 1

sysctl -p

nano /etc/modules-load.d/br_netfilter.conf
在文件中添加以下内容：
br_netfilter


## containerd

wget https://mirrors.aliyun.com/docker-ce/linux/ubuntu/dists/jammy/pool/stable/amd64/containerd.io_1.7.25-1_amd64.deb
dpkg -i containerd.io_1.7.25-1_amd64.deb
#导出默认配置
containerd config default > /etc/containerd/config.toml

#修改containerd使用SystemdCgroup
SystemdCgroup = true

#配置containerd使用国内mirror站点上的pause镜像及指定版本
sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.9"

#启动containerd服务
systemctl enable containerd
systemctl restart containerd


## crictl

https://github.com/kubernetes-sigs/cri-tools/releases 下载

vim /etc/crictl.yaml
#输入
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: true

## kubuadm、kubelet、kubectl
apt update && apt install -y apt-transport-https curl

curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

apt update
apt install -y kubelet kubeadm kubectl
systemctl enable kubelet

## 初始化master节点
### 拉取下载镜像
kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers --kubernetes-version="v1.28.2"
运行如下命令完成初始化
kubeadm init --kubernetes-version=v1.28.2 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --image-repository=registry.aliyuncs.com/google_containers --upload-certs