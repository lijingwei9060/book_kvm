## install kubevela

```shell

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-prism:v1.7.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-prism:v1.7.0  docker.io/oamdev/vela-prism:v1.7.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/openssl-curl:v0.1.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/openssl-curl:v0.1.0  docker.io/oamdev/openssl-curl:v0.1.0

```

## install prometheus

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/prometheus:v3.5.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/prometheus:v3.5.0  quay.io/prometheus/prometheus:v3.5.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/node-exporter:v1.9.1
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/node-exporter:v1.9.1 quay.io/prometheus/node-exporter:v1.9.1

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/curlimages/curl:latest
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/curlimages/curl:latest  docker.io/curlimages/curl:latest
``` 

## install fluxcd

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/helm-controller:v0.36.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/helm-controller:v0.36.0  docker.io/fluxcd/helm-controller:v0.36.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/kustomize-controller:v1.1.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/kustomize-controller:v1.1.0  docker.io/fluxcd/kustomize-controller:v1.1.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-automation-controller:v0.36.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-automation-controller:v0.36.0  docker.io/fluxcd/image-automation-controller:v0.36.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-reflector-controller:v0.30.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-reflector-controller:v0.30.0  docker.io/fluxcd/image-reflector-controller:v0.30.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/source-controller:v1.1.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/source-controller:v1.1.0  docker.io/fluxcd/source-controller:v1.1.0
```


## install mysql

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/bitpoke/mysql-operator-orchestrator:v0.6.2
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/bitpoke/mysql-operator-orchestrator:v0.6.2  docker.io/bitpoke/mysql-operator-orchestrator:v0.6.2

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/bitpoke/mysql-operator:v0.6.2
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/bitpoke/mysql-operator:v0.6.2  docker.io/bitpoke/mysql-operator:v0.6.2

```


## install cloudshell

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell-operator:v0.3.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell-operator:v0.3.0  docker.io/oamdev/cloudshell-operator:v0.3.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell:v1.7.2
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell:v1.7.2  docker.io/oamdev/cloudshell:v1.7.2
```

## install redis

```shell

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/spotahome/redis-operator:latest
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/spotahome/redis-operator:latest  quay.io/spotahome/redis-operator:latest

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/redis:6.2.6-alpine
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/redis:6.2.6-alpine  docker.io/library/redis:6.2.6-alpine
```

kubectl patch statefulset rfr-redis-001 \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"sentinel","imagePullPolicy":"IfNotPresent"}]}}}}'


kubectl patch ReplicaSet rfs-redis-001-5d96b8f877 \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"sentinel","imagePullPolicy":"IfNotPresent"}]}}}}'

kubectl patch ReplicaSet rfs-redis-001-5d96b8f877 \
  -p '{"spec":{"template":{"spec":{"initContainers":[{"name":"sentinel-config-copy","imagePullPolicy":"IfNotPresent"}]}}}}'