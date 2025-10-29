



## install kubevela

ctrctl pull docker.1ms.run/harness/harness:3.3.0

pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/velaux:v1.9.4 

pdsh -g ks -l root ctr -n k8s.io images pull docker.1ms.run/oamdev/velaux:v1.9.4 
pdsh -g ks -l root ctr -n k8s.io images tag docker.1ms.run/oamdev/velaux:v1.9.4 docker.io/oamdev/velaux:v1.9.4

pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/kube-webhook-certgen:v2.4.1
pdsh -g ks -l root ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/kube-webhook-certgen:v2.4.1 docker.io/oamdev/kube-webhook-certgen:v2.4.1

pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cluster-gateway:v1.9.0-alpha.2
pdsh -g ks -l root ctr -n k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cluster-gateway:v1.9.0-alpha.2 docker.io/oamdev/cluster-gateway:v1.9.0-alpha.2
pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-core:v1.10.4
pdsh -g ks -l root ctr -n k8s.io images tag swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-core:v1.10.4 docker.io/oamdev/vela-core:v1.10.4
pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-prism:v1.7.0
pdsh -g ks -l root ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/vela-prism:v1.7.0  docker.io/oamdev/vela-prism:v1.7.0
pdsh -g ks -l root ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/openssl-curl:v0.1.0
pdsh -g ks -l root ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/openssl-curl:v0.1.0  docker.io/oamdev/openssl-curl:v0.1.0


pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/prometheus:v3.5.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/prometheus:v3.5.0  quay.io/prometheus/prometheus:v3.5.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/node-exporter:v1.9.1
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/quay.io/prometheus/node-exporter:v1.9.1 quay.io/prometheus/node-exporter:v1.9.1
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/curlimages/curl:latest
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/curlimages/curl:latest  docker.io/curlimages/curl:latest
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/helm-controller:v0.36.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/helm-controller:v0.36.0  docker.io/fluxcd/helm-controller:v0.36.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/kustomize-controller:v1.1.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/kustomize-controller:v1.1.0  docker.io/fluxcd/kustomize-controller:v1.1.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-automation-controller:v0.36.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-automation-controller:v0.36.0  docker.io/fluxcd/image-automation-controller:v0.36.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-reflector-controller:v0.30.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/image-reflector-controller:v0.30.0  docker.io/fluxcd/image-reflector-controller:v0.30.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/source-controller:v1.1.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/fluxcd/source-controller:v1.1.0  docker.io/fluxcd/source-controller:v1.1.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell-operator:v0.3.0
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell-operator:v0.3.0  docker.io/oamdev/cloudshell-operator:v0.3.0
pdsh -g ks ctr -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell:v1.7.2
pdsh -g ks ctr -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/oamdev/cloudshell:v1.7.2  docker.io/oamdev/cloudshell:v1.7.2

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



## velad install


```shell
root@casoul-ubuntu:~# velad install --set admissionWebhooks.enabled=false --set replicaCount=0
Preparing cluster setup script...
Saving temporary file: k3s-setup-*.sh
Preparing k3s binary...
Saving k3s binary to /usr/local/bin/k3s
Successfully place k3s binary to /usr/local/bin/k3s
Preparing k3s images
Making directory /var/lib/rancher/k3s/agent/images/
Saving K3s air-gap install images to /var/lib/rancher/k3s/agent/images/k3s-airgap-images.tar.gz
Successfully prepare k3s image
Setting up cluster
/bin/bash /root/.vela/tmp/k3s-setup-3445078937.sh --node-name=default
[INFO]  Skipping k3s download and verify
[INFO]  Skipping installation of SELinux RPM
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, already exists
[INFO]  Skipping /usr/local/bin/crictl symlink to k3s, command exists in PATH at /usr/bin/crictl
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, command exists in PATH at /usr/bin/ctr
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
Successfully setup cluster
Checking and installing vela CLI...
vela CLI is not installed, installing...
Installing vela CLI at:  /usr/local/bin/vela
Successfully install vela CLI
Saving and temporary image file: vela-image-cluster-gateway-*.tar
Importing image to cluster using temporary file: vela-image-cluster-gateway-*.tar
unpacking docker.io/oamdev/cluster-gateway:v1.9.0-alpha.2 (sha256:a9baa41c62762dea9cccefeed0ef1a479b695f7af847ecf7df0ab6b6ecf4e8c5)...done
Successfully import image /root/.vela/tmp/vela-image-cluster-gateway-82128387.tar
Saving and temporary image file: vela-image-kube-webhook-certgen-*.tar
Importing image to cluster using temporary file: vela-image-kube-webhook-certgen-*.tar
unpacking docker.io/oamdev/kube-webhook-certgen:v2.4.1 (sha256:089374ef23e1d268f138d742b8af056ee1af51bb4863f6a19cde0634068eaa91)...done
Successfully import image /root/.vela/tmp/vela-image-kube-webhook-certgen-1275598674.tar
Saving and temporary image file: vela-image-vela-core-*.tar
Importing image to cluster using temporary file: vela-image-vela-core-*.tar
unpacking docker.io/oamdev/vela-core:v1.9.5 (sha256:fbff76625847c1183dd371f5fc9acbbd3c33c348faf12984eaae433b1244f454)...done
Successfully import image /root/.vela/tmp/vela-image-vela-core-1473230276.tar
Saving and temporary image file: vela-image-velaux-*.tar
Importing image to cluster using temporary file: vela-image-velaux-*.tar
unpacking docker.io/oamdev/velaux:v1.9.2 (sha256:9e1a8810c429fb651807efde0542778143fb5428732d9c9839310eb949d5d97d)...done
Successfully import image /root/.vela/tmp/vela-image-velaux-2077089320.tar
Saving and temporary helm chart file: vela-core-*.tgz
open the tar to tmpDir /root/.vela/tmp
Copy velaux-v1.9.2.tgz file to /root/.vela/addons/velaux-v1.9.2.tgz
Extracting /root/.vela/addons/velaux-v1.9.2.tgz to /root/.vela/addons/velaux
Installing vela-core Helm chart...
Executing "vela install --file /root/.vela/tmp/vela-core --detail=false --version v1.9.5 --set=admissionWebhooks.enabled=false,replicaCount=0 --namespace=vela-system "

Check Requirements ...
Installing KubeVela Core ...
Helm Chart used for KubeVela control plane installation: /root/.vela/tmp/vela-core 
I1017 05:20:33.109935   24020 apply.go:126] "creating object" name="applicationrevisions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.128615   24020 apply.go:126] "creating object" name="applications.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.148717   24020 apply.go:126] "creating object" name="componentdefinitions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.160909   24020 apply.go:126] "creating object" name="definitionrevisions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.168726   24020 apply.go:126] "creating object" name="policies.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.173712   24020 apply.go:126] "creating object" name="policydefinitions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.177886   24020 apply.go:126] "creating object" name="resourcetrackers.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.182633   24020 apply.go:126] "creating object" name="traitdefinitions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.187034   24020 apply.go:126] "creating object" name="workflows.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.192658   24020 apply.go:126] "creating object" name="workflowstepdefinitions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
I1017 05:20:33.213351   24020 apply.go:126] "creating object" name="workloaddefinitions.core.oam.dev" resource="apiextensions.k8s.io/v1, Kind=CustomResourceDefinition"
Start upgrading Helm Chart kubevela in namespace vela-system

KubeVela control plane has been successfully set up on your cluster.
If you want to enable dashboard, please run "vela addon enable /root/.vela/addons/velaux"
Modifying the built-in gateway definition...

Keep the token below if you want to restart the control plane
K100e80fb2f38d28b8be838e0e714d56ad9df9a20cb2329b6d3a51ad03459d8469c::server:b7ca668ca7199ff3a9c217b8ecae84b2

🚀 Successfully install KubeVela control plane
💻 When using gateway trait, you can access with 127.0.0.1
🔭 See available commands with `vela help`
💡 To enable dashboard, run `vela addon enable /root/.vela/addons/velaux`
🔑 To access the cluster, set KUBECONFIG:
    export KUBECONFIG=$(velad kubeconfig --name default --host)
```
