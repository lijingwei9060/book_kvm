# install

## install cert-manager

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull quay.io/jetstack/cert-manager-cainjector:v1.19.1
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull quay.io/jetstack/cert-manager-controller:v1.19.1
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull quay.io/jetstack/cert-manager-acmesolver:v1.19.1
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull quay.io/jetstack/cert-manager-webhook:v1.19.1
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.19.1/cert-manager.yaml


## install gateway api

kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

## install envoy 

gateway端口：
1. xds 服务 18000
2. 限流服务： 18001
3. 管理接口： 19000
4. 指标接口： 19001
5. proxy管理接口： 19000
6. 健康检查： 19001
kubectl apply --server-side -f https://github.com/envoyproxy/gateway/releases/download/v1.6.0/install.yaml

```
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/ratelimit:30a4ce1a
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/ratelimit:30a4ce1a  docker.io/envoyproxy/ratelimit:30a4ce1a
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images  pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/gateway:v1.6.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images  tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/gateway:v1.6.0  docker.io/envoyproxy/gateway:v1.6.0
```

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: envoy
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
  parametersRef:
    group: gateway.envoyproxy.io
    kind: EnvoyProxy
    name: config
    namespace: envoy-gateway-system
---
apiVersion: gateway.envoyproxy.io/v1alpha1
kind: EnvoyProxy
metadata:
  name: config
  namespace: envoy-gateway-system
spec:
  provider:
    type: Kubernetes
    kubernetes:
      envoyService:
        type: NodePort
EOF
```

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: kserve-ingress-gateway
  namespace: kserve
spec:
  gatewayClassName: envoy
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: my-secret
            namespace: kserve
      allowedRoutes:
        namespaces:
          from: All
  infrastructure:
    labels:
      serving.kserve.io/gateway: kserve-ingress-gateway
EOF
```

export ENVOY_SERVICE=$(kubectl get svc -n envoy-gateway-system --selector=gateway.envoyproxy.io/owning-gateway-namespace=default,gateway.envoyproxy.io/owning-gateway-name=eg -o jsonpath='{.items[0].metadata.name}')
kubectl -n envoy-gateway-system port-forward service/${ENVOY_SERVICE} 8888:80 &


## install kserve



image: kserve/kserve-controller:v0.15.0
image: quay.io/brancz/kube-rbac-proxy:v0.18.0
image: kserve/kserve-localmodel-controller:v0.15.0
image: kserve/kserve-localmodelnode-agent:v0.15.0

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull quay.io/brancz/kube-rbac-proxy:v0.18.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-controller:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-controller:v0.15.0  docker.io/kserve/kserve-controller:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-localmodelnode-agent:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-localmodelnode-agent:v0.15.0  docker.io/kserve/kserve-localmodelnode-agent:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-localmodel-controller:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-localmodel-controller:v0.15.0  docker.io/kserve/kserve-localmodel-controller:v0.15.0
```

```shell
kubectl apply --server-side -f https://github.com/kserve/kserve/releases/download/v0.15.0/kserve.yaml
kubectl apply --server-side -f https://github.com/kserve/kserve/releases/download/v0.15.0/kserve-cluster-resources.yaml
```

image: kserve/huggingfaceserver:v0.15.0
image: kserve/huggingfaceserver:v0.15.0-gpu
image: kserve/lgbserver:v0.15.0
image: docker.io/seldonio/mlserver:1.5.0
image: kserve/paddleserver:v0.15.0
image: kserve/pmmlserver:v0.15.0
image: kserve/sklearnserver:v0.15.0
image: tensorflow/serving:2.6.2
image: pytorch/torchserve-kfs:0.9.0
image: nvcr.io/nvidia/tritonserver:23.05-py3
image: kserve/xgbserver:v0.15.0
image: kserve/storage-initializer:v0.15.0

```shell
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/huggingfaceserver:v0.15.0-gpu
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/huggingfaceserver:v0.15.0-gpu  docker.io/kserve/huggingfaceserver:v0.15.0-gpu

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/huggingfaceserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/huggingfaceserver:v0.15.0  docker.io/kserve/huggingfaceserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/lgbserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/lgbserver:v0.15.0  docker.io/kserve/lgbserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/seldonio/mlserver:1.5.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/seldonio/mlserver:1.5.0  docker.io/seldonio/mlserver:1.5.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/paddleserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/paddleserver:v0.15.0  docker.io/kserve/paddleserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/pmmlserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/pmmlserver:v0.15.0  docker.io/kserve/pmmlserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/sklearnserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/sklearnserver:v0.15.0  docker.io/kserve/sklearnserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/pytorch/torchserve-kfs:0.9.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/pytorch/torchserve-kfs:0.9.0  docker.io/pytorch/torchserve-kfs:0.9.0


ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/xgbserver:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/xgbserver:v0.15.0  docker.io/kserve/xgbserver:v0.15.0

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/storage-initializer:v0.15.0
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/storage-initializer:v0.15.0  docker.io/kserve/storage-initializer:v0.15.0


ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images  pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/envoy:distroless-v1.36.2
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images  tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/envoyproxy/envoy:distroless-v1.36.2  docker.io/envoyproxy/envoy:distroless-v1.36.2
```

```shell
kubectl patch configmap/inferenceservice-config -n kserve --type=strategic -p '{"data": {"deploy": "{\"defaultDeploymentMode\": \"Standard\"}"}}'


kubectl patch configmap/inferenceservice-config -n kserve --type=strategic -p '{"data": {"deploy": "{\"defaultDeploymentMode\": \"RawDeployment\"}"}}'


kubectl patch configmap/inferenceservice-config -n kserve --type=strategic -p '{"data": {"ingress": "{\"enableGatewayApi\": true, \"ingressGateway\" : \"knative-serving/knative-ingress-gateway\", \"kserveIngressGateway\": \"kserve/kserve-ingress-gateway\"}"}}'
```


## demo

```shell
kubectl create namespace kserve-test

kubectl apply -n kserve-test -f - <<EOF
apiVersion: "serving.kserve.io/v1beta1"
kind: "InferenceService"
metadata:
  name: "qwen-llm"
  namespace: kserve-test
spec:
  predictor:
    model:
      modelFormat:
        name: huggingface
      args:
        - --model_name=qwen
      storageUri: "hf://Qwen/Qwen2.5-0.5B-Instruct"
      resources:
        limits:
          cpu: "2"
          memory: 6Gi
          nvidia.com/gpu: "1"
        requests:
          cpu: "1"
          memory: 4Gi
          nvidia.com/gpu: "1"
    initContainers:
      - name: storage-initializer
        env:
          - name: HF_ENDPOINT
            value: "https://hf-mirror.com"
        image: "kserve/storage-initializer:v0.15.0"
EOF
```