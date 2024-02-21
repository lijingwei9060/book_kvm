## preinstall

### ubuntu配置dns

```shell
root@i-CC100C27:~# vim /etc/netplan/99_config.yaml 
network:
        version: 2
        renderer: networkd
        ethernets:
            ens3:
                dhcp4: true
                dhcp6: true
                nameservers:
                  addresses: [10.201.33.181, 10.201.33.184]
root@i-CC100C27:~# netplan apply
root@i-CC100C27:~# ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```
### 关闭swap
```shell
swapoff -a
sed -i '/ swap / s/^/#/g' /etc/fstab
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

```shell
root@i-4A2FE681:~# kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-7ddc4f45bc-5nfk9   1/1     Running   0          16h
kube-system   calico-node-58d5m                          1/1     Running   0          16h
kube-system   calico-node-7sbbd                          1/1     Running   0          16h
kube-system   calico-node-wcn4x                          1/1     Running   0          43s
kube-system   coredns-857d9ff4c9-rmrpc                   1/1     Running   0          16h
kube-system   coredns-857d9ff4c9-v97wz                   1/1     Running   0          16h
kube-system   etcd-i-4a2fe681                            1/1     Running   0          16h
kube-system   kube-apiserver-i-4a2fe681                  1/1     Running   0          16h
kube-system   kube-controller-manager-i-4a2fe681         1/1     Running   0          16h
kube-system   kube-proxy-nw82k                           1/1     Running   0          16h
kube-system   kube-proxy-s849p                           1/1     Running   0          16h
kube-system   kube-proxy-v927z                           1/1     Running   0          8s
kube-system   kube-scheduler-i-4a2fe681                  1/1     Running   0          16h
```

```shell
root@i-4A2FE681:~# kubectl get nodes
NAME         STATUS   ROLES           AGE   VERSION
i-4a2fe681   Ready    control-plane   16h   v1.29.2
i-c96ca55e   Ready    <none>          16h   v1.29.2
i-cc100c27   Ready    <none>          16h   
```

## helm 和仓库设置

snap install helm --classic

## 安装ingress-nginx

添加 ingress-nginx 仓库
```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```
如果helm repo访问不了：
下载下面的文件，修改 regsitry.k8s.io -> k8s.mirror.nju.edu.cn
```shell
root@i-4A2FE681:~# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
serviceaccount/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
configmap/ingress-nginx-controller created
service/ingress-nginx-controller created
service/ingress-nginx-controller-admission created
deployment.apps/ingress-nginx-controller created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
ingressclass.networking.k8s.io/nginx created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
```

检查
```shell
root@i-4A2FE681:~# kubectl get pods -n ingress-nginx
NAMESPACE              NAME                                        READY   STATUS             RESTARTS         AGE
ingress-nginx          ingress-nginx-admission-create-tnnl8        0/1     Completed          0                6m23s
ingress-nginx          ingress-nginx-admission-patch-fdpgg         0/1     Completed          0                6m23s
ingress-nginx          ingress-nginx-controller-6ccc9bd7cb-fq7cm   1/1     Running            4 (106s ago)     6m23s

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

## 安装gateway

```shell
root@i-4A2FE681:~# kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
```

## 安装dashboard
```shell
root@i-4A2FE681:~# helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
"kubernetes-dashboard" has been added to your repositories
root@i-4A2FE681:~# helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
Release "kubernetes-dashboard" does not exist. Installing it now.
NAME: kubernetes-dashboard
LAST DEPLOYED: Tue Feb 20 02:25:23 2024
NAMESPACE: kubernetes-dashboard
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
*********************************************************************************
*** PLEASE BE PATIENT: kubernetes-dashboard may take a few minutes to install ***
*********************************************************************************

Get the Kubernetes Dashboard URL by running:
  export POD_NAME=$(kubectl get pods -n kubernetes-dashboard -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")
  echo https://127.0.0.1:8443/
  kubectl -n kubernetes-dashboard port-forward $POD_NAME 8443:8443
```

创建 dashboard-admin 用户: kubectl create serviceaccount dashboard-admin -n kubernetes-dashboard
绑定 clusterrolebinding: kubectl create clusterrolebinding dashboard-admin-rb --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard-admin
生成配置文件: 
cat > dashboard-admin-token.yaml<<EOF
apiVersion: v1 
kind: Secret 
metadata: 
  name: dashboard-admin-secret 
  namespace: kubernetes-dashboard 
  annotations: 
    kubernetes.io/service-account.name: dashboard-admin 
type: kubernetes.io/service-account-token
EOF

生成secret: kubectl apply -f dashboard-admin-token.yaml
查看token: kubectl describe secret dashboard-admin-secret -n kubernetes-dashboard
```shell
root@i-4A2FE681:~# kubectl describe secret dashboard-admin-secret -n kubernetes-dashboard
Name:         dashboard-admin-secret
Namespace:    kubernetes-dashboard
Labels:       kubernetes.io/legacy-token-last-used=2024-02-20
Annotations:  kubernetes.io/service-account.name: dashboard-admin
              kubernetes.io/service-account.uid: 979e9feb-14e3-46fd-9889-68dbc86addfa

Type:  kubernetes.io/service-account-token

Data
====
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IjF5X1lDYkVQSGhIVGxTOGNpbDlsRzdlalAyYXVsU3JGb1VCTkhHWmtFODAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tc2VjcmV0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRhc2hib2FyZC1hZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6Ijk3OWU5ZmViLTE0ZTMtNDZmZC05ODg5LTY4ZGJjODZhZGRmYSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDpkYXNoYm9hcmQtYWRtaW4ifQ.QNSho60qE8WI70pd1xFz1GqfRS4oe79J9up0zaFvL1C7cSIESISJnkoTsHL45XmWXhJgQfnfflipc2cYuekg8uRm2qmP-aexNFDoYXq4szndDFh61naL6aERJAnOFDv9SVxSOBJ5ql7S97I6n0DAl3so5Em-lcuQ9azBmEnvzfFgoufqdVo-BCCaVjSx7DmF804FCc_nyeJnL9_6ZLM02IYgFRVG0D7iF-jEhuuJIQUl0xtFgvN1TH5xxkSSGwnPGUZxiHVG8Rc-OUFOeM0l098NeJO-4sjCK1aIm6-Sa3OjIMYqCmamswgz5zWmycLX14DJdwF5OYc2SIEUSk3QFA
ca.crt:     1107 bytes
namespace:  20 bytes
```

```text
# kubernetes-dashboard/values.yaml
metricsScraper:
  ## Wether to enable dashboard-metrics-scraper
  enabled: true
```
Dashboard Token 的默认有效时间是 15 分钟，到期后会自动退出登陆，不方便学习探索
```txt
# kubernetes-dashboard/values.yaml
extraArgs:
  - --token-ttl=43200 # 增加这一行，设置 token 过期时间为12小时
```

helm upgrade kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard -f values.yaml

创建自签证书，并创建tls类型Secrets: 

```shell
root@i-4A2FE681:~# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout kube-dashboard.key -out kube-dashboard.crt -subj "/CN=dashboard.kube.com/O=k8s.dashboard.local"
.............+....+........
-----writing new private key to 'kube-dashboard.key'
# 创建tls类型的Secret为ingress提供配置。
root@i-4A2FE681:~# kubectl create secret tls dashboard-tls --key kube-dashboard.key --cert kube-dashboard.crt -n kubernetes-dashboard
secret/dashboard-tls created

# 查看secrets，可以看见类型为tls类型
root@i-4A2FE681:~# kubectl get secret -n kubernetes-dashboard
NAME                                         TYPE                                  DATA   AGE
dashboard-admin-secret                       kubernetes.io/service-account-token   3      21h
dashboard-tls                                kubernetes.io/tls                     2      21s
kubernetes-dashboard-certs                   Opaque                                0      24h
kubernetes-dashboard-csrf                    Opaque                                1      24h
kubernetes-dashboard-key-holder              Opaque                                2      24h
sh.helm.release.v1.kubernetes-dashboard.v1   helm.sh/release.v1                    1      24h
sh.helm.release.v1.kubernetes-dashboard.v2   helm.sh/release.v1                    1      21h
```
配置Ingress规则: 
```shell
root@i-4A2FE681:~# cat ingress-dashboard.yaml 
apiVersion: networking.k8s.io/v1   类型为v1
kind: Ingress
metadata:
  name: dashboard-ingress
  namespace: kubernetes-dashboard
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"   #注意这里：必须指定后端服务为HTTPS服务。
spec:
  ingressClassName: "nginx"  控制器的类型为nginx
  tls:
  - hosts:    
    - k8s.dashboard.local   主机名
    secretName: dashboard-tls  这里引用创建的secrets
  rules:
  - host: k8s.dashboard.local   
    http:
      paths:
      - path: /
        pathType: Prefix   起始与根都进行代理。
        backend:   
          service:
            name: kubernetes-dashboard   service名称
            port:     后端端口
              number: 443
```

```shell
root@i-4A2FE681:~# kubectl apply -f ingress-dashboard.yaml 
ingress.networking.k8s.io/dashboard-ingress created

root@i-4A2FE681:~# kubectl get ingress -A
NAMESPACE              NAME                CLASS   HOSTS                 ADDRESS   PORTS     AGE
kubernetes-dashboard   dashboard-ingress   nginx   k8s.dashboard.local             80, 443   50s
```

## 安装metric Server 

## 安装存储插件


## 卸载node

```shell
## master
kubectl  delete nodes k8s-node1

root@i-4A2FE681:~# kubeadm token create --print-join-command
kubeadm join 10.16.161.64:6443 --token 24m1x0.po11fl3izrkfl6po --discovery-token-ca-cert-hash sha256:b34c9e4721367dbe8e73ef35e000101daba68ebfd71fc3ae0a488c49433d3e66 
### node
root@i-CC100C27:~# kubeadm join 10.16.161.64:6443 --token 24m1x0.po11fl3izrkfl6po --discovery-token-ca-cert-hash sha256:b34c9e4721367dbe8e73ef35e000101daba68ebfd71fc3ae0a488c49433d3e66
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
```