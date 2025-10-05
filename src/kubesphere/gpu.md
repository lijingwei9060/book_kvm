


## 安装gpu-operator
helm install gpu-operator nvidia/gpu-operator -n gpu-operator-resources\
   --set operator.defaultRuntime=containerd
   
Furthermore, when setting containerd as the defaultRuntime the following options are also available:
toolkit:
  env:
  - name: CONTAINERD_CONFIG
    value: /etc/containerd/config.toml
  - name: CONTAINERD_SOCKET
    value: /run/containerd/containerd.sock
  - name: CONTAINERD_RUNTIME_CLASS
    value: nvidia
  - name: CONTAINERD_SET_AS_DEFAULT
    value: true

## juniper环境

ctr --namespace k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/tensorflow/tensorflow:2.5.0-gpu-jupyter
ctr --namespace k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/tensorflow/tensorflow:2.5.0-gpu-jupyter  docker.io/tensorflow/tensorflow:2.5.0-gpu-jupyter