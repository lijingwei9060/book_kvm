

## 安装cert-manager


crictl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-controller:v1.17.0
crictl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-acmesolver:v1.17.1
crictl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-cainjector:v1.17.0
crictl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-webhook:v1.17.0

ctr --namespace k8s.io image tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-controller:v1.17.0 quay.io/jetstack/cert-manager-controller:v1.17.0
ctr --namespace k8s.io image tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-acmesolver:v1.17.1 quay.io/jetstack/cert-manager-acmesolver:v1.17.0
ctr --namespace k8s.io image tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-cainjector:v1.17.0 quay.io/jetstack/cert-manager-cainjector:v1.17.0
ctr --namespace k8s.io image tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/jetstack/cert-manager-webhook:v1.17.0 quay.io/jetstack/cert-manager-webhook:v1.17.0


kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml



## kserve

ctr --namespace k8s.io images pull docker.io/kserve/kserve-controller:v0.15.0
ctr --namespace k8s.io images pull docker.io/kserve/art-explainer:v0.15.0
ctr --namespace k8s.io images pull docker.io/kserve/qpext:v0.15.0
ctr --namespace k8s.io images pull docker.io/kserve/lgbserver:v0.15.0
ctr --namespace k8s.io images pull docker.io/kserve/sklearnserver:v0.15.0
ctr --namespace k8s.io images pull docker.io/kserve/xgbserver:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/agent:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/router:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/kserve-localmodel-controller:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/huggingfaceserver:v0.15.0-gpu
ctr -n k8s.io images pull docker.io/kserve/paddleserver:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/pmmlserver:v0.15.0
ctr -n k8s.io images pull docker.io/kserve/storage-initializer:v0.15.0

ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/agent:v0.15.0   docker.io/kserve/agent:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/router:v0.15.0   docker.io/kserve/router:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/art-explainer:0.15.0   docker.io/kserve/art-explainer:0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-controller:v0.15.0   docker.io/kserve/kserve-controller:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/kserve-localmodel-controller:v0.15.0   docker.io/kserve/kserve-localmodel-controller:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/qpext:v0.15.0   docker.io/kserve/qpext:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/huggingfaceserver:v0.15.0-gpu   docker.io/kserve/huggingfaceserver:v0.15.0-gpu
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/lgbserver:v0.15.0   docker.io/kserve/lgbserver:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/paddleserver:v0.15.0   docker.io/kserve/paddleserver:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/pmmlserver:v0.15.0   docker.io/kserve/pmmlserver:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/sklearnserver:v0.15.0   docker.io/kserve/sklearnserver:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/xgbserver:v0.15.0   docker.io/kserve/xgbserver:v0.15.0
ctr --namespace k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/kserve/storage-initializer:v0.15.0   docker.io/kserve/storage-initializer:v0.15.0




[Service]
Environment="HTTP_PROXY=http://10.98.12.116:51000"
Environment="HTTPS_PROXY=http://10.98.12.116:51000"
Environment="NO_PROXY=localhost"
EOF



ctr --namespace k8s.io --debug images pull kserve/agent:v0.15.0