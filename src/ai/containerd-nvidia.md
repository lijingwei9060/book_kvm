
apt install -y linux-headers-generic-hwe-22.04 linux-image-generic-hwe-22.04 linux-tools-6.8.0-85-generic 
reboot

apt install -y gcc g++


apt-get install nvidia-utils-580
apt-get install nvidia-driver-580

nvidia-settings -q NvidiaDriverVersion
nvidia-smi

// 显卡监控
apt install nvtop 


vim /etc/modprobe.d/blacklist.conf

blacklist nouveau
options nouveau modeset=0

update-initramfs -u

ubuntu-drivers list
 ubuntu-drivers install --gpgpu nvidia:580-server


root@s08:~# ubuntu-drivers devices
ERROR:root:aplay command not found
== /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
modalias : pci:v000010DEd00002B85sv000010DEsd00002057bc03sc00i00
vendor   : NVIDIA Corporation
driver   : nvidia-driver-570-server-open - distro non-free
driver   : nvidia-driver-570-server - distro non-free
driver   : nvidia-driver-580-server-open - distro non-free
driver   : nvidia-driver-570 - distro non-free
driver   : nvidia-driver-580 - distro non-free recommended
driver   : nvidia-driver-580-open - distro non-free
driver   : nvidia-driver-580-server - distro non-free
driver   : nvidia-driver-570-open - distro non-free
driver   : xserver-xorg-video-nouveau - distro free builtin

root@s08:~# apt install nvidia-driver-580-open

切记要open

apt purge "*nvidia*"
apt-get remove --purge '^nvidia-.*'
apt autoremove
apt-get autoclean

```shell
// https://github.com/containerd/containerd
$ tar Cxzvf /usr/local containerd-2.1.4-linux-amd64.tar.gz
$ mkdir -p /etc/containerd
$ containerd config default > /etc/containerd/config.toml

$ vim /usr/lib/systemd/system/containerd.service
$ systemctl daemon-reload
$ systemctl enable --now containerd

// https://github.com/opencontainers/runc/releases
$ install -m 755 runc.amd64 /usr/local/sbin/runc
// https://github.com/containernetworking/plugins/releases
$ mkdir -p /opt/cni/bin
$ tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz 
```

```text /usr/lib/systemd/system/containerd.service
# Copyright The containerd Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target dbus.service

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd

Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not supports it.
# Only systemd 226 and above support this version.
TasksMax=infinity
OOMScoreAdjust=-999

[Install]
WantedBy=multi-user.target
```

curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update

```shell
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1
apt-get install -y \
      nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
      libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}
```
```shell
root@s08:~/containerd# nvidia-ctk runtime configure --runtime=containerd
INFO[0000] Using config version 3                       
INFO[0000] Using CRI runtime plugin name "io.containerd.cri.v1.runtime" 
INFO[0000] Wrote updated config to /etc/containerd/config.toml 
INFO[0000] It is recommended that containerd daemon be restarted. 

$ systemctl restart containerd
```

```text /etc/containerd/config.toml
[plugins.'io.containerd.cri.v1.runtime'.containerd]
      default_runtime_name = 'nvidia'
      ignore_blockio_not_enabled_errors = false
      ignore_rdt_not_enabled_errors = false

      [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes]
        [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.nvidia]
          runtime_type = 'io.containerd.runc.v2'
          privileged_without_host_devices = false
          runtime_engine = ""
          runtime_root = ""

          [plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.nvidia.options]
            runtime_type = "io.containerd.runtime.v1.linux"
            runtime_engine = "/usr/bin/nvidia-container-runtime"
```

验证
nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/ubuntu:24.04
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/ubuntu:24.04  docker.io/library/ubuntu:24.04

nerdctl run --rm --runtime=nvidia --gpus all ubuntu:24.04 nvidia-smi


## install ollama
nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ollama/ollama:0.12.5
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ollama/ollama:0.12.5  docker.io/ollama/ollama:0.12.5

mkdir /root/ollama

nerdctl run -d --network host --gpus=all -v /root/ollama:/root/.ollama -p 11434:11434 -e "OLLAMA_HOST=0.0.0.0" --name ollama ollama/ollama:0.12.5


## install opensearch

```
# Edit the sysctl config file
vi /etc/sysctl.conf

# Add a line to define the desired value
# or change the value if the key exists,
# and then save your changes.
vm.max_map_count=262144

# Reload the kernel parameters using sysctl
sysctl -p

# Verify that the change was applied by checking the value
cat /proc/sys/vm/max_map_count
```

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/opensearchproject/opensearch:3.3.0
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/opensearchproject/opensearch:3.3.0  docker.io/opensearchproject/opensearch:3.3.0

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/opensearchproject/opensearch-dashboards:3.3.0
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/opensearchproject/opensearch-dashboards:3.3.0  docker.io/opensearchproject/opensearch-dashboards:3.3.0

nerdctl run -d --network host -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" -e "OPENSEARCH_INITIAL_ADMIN_PASSWORD=Changeitlater@1" --name opensearch opensearchproject/opensearch:3.3.0 

curl https://XXXXXIP:9200 -ku admin:Changeitlater@1

```text
 server.name: opensearch_dashboards
 server.host: "0.0.0.0"
 server.customResponseHeaders : { "Access-Control-Allow-Credentials" : "true" }
    
 # Disabling HTTPS on OpenSearch Dashboards
 server.ssl.enabled: false
    
 opensearch.hosts: ["https://opensearch-node:9200"] # Using the opensearch container name
    
 opensearch.ssl.verificationMode: none
 opensearch.username: kibanaserver
 opensearch.password: kibanaserver
 opensearch.requestHeadersWhitelist: ["securitytenant","Authorization"]
    
 # Multitenancy
 opensearch_security.multitenancy.enabled: true
 opensearch_security.multitenancy.tenants.preferred: ["Private", "Global"]
 opensearch_security.readonly_mode.roles: ["kibana_read_only"]
```

docker run -d --name osd \
   --network os-net \
   -p 5601:5601 \
   -v ./opensearch_dashboards.yml:/usr/share/opensearch-dashboards/config/opensearch_dashboards.yml \
   opensearchproject/opensearch-dashboards:latest



## install dify

git clone --branch "1.9.1" https://github.com/langgenius/dify.git

cd dify/docker
cp .env.example .env

docker compose up -d


```
nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-web:1.9.1
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-web:1.9.1  docker.io/langgenius/dify-web:1.9.1

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-api:1.9.1
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-api:1.9.1  docker.io/langgenius/dify-api:1.9.1

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:15-alpine
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:15-alpine  docker.io/postgres:15-alpine

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/redis:6-alpine
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/redis:6-alpine  docker.io/redis:6-alpine

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-sandbox:0.2.12
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-sandbox:0.2.12  docker.io/langgenius/dify-sandbox:0.2.12

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-plugin-daemon:0.3.0-local
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/dify-plugin-daemon:0.3.0-local  docker.io/langgenius/dify-plugin-daemon:0.3.0-local

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ubuntu/squid:6.6-24.04_beta
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ubuntu/squid:6.6-24.04_beta  docker.io/ubuntu/squid:6.6-24.04_beta


image: certbot/certbot
nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/nginx:1.29.0-alpine
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/nginx:1.29.0-alpine  docker.io/library/nginx:1.29.0-alpine

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/qdrant:v1.7.3
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/langgenius/qdrant:v1.7.3  docker.io/langgenius/qdrant:v1.7.3

nerdctl pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/nginx:1.28.0
nerdctl tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/nginx:1.28.0  docker.io/library/nginx:1.28.0
```

## install maxkb

nerdctl pull registry.fit2cloud.com/maxkb/maxkb

nerdctl run -d --name=maxkb --network host --restart=always -p 8080:8080 -v ~/.maxkb:/opt/maxkb registry.fit2cloud.com/maxkb/maxkb
