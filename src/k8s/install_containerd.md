# install

## os config

设置所需的 sysctl 参数，参数在重新启动后保持不变
```shell
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
```
## install

安装containerd：
```shell
wget https://github.com/containerd/containerd/releases/download/v2.2.0/containerd-2.2.0-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-2.2.0-linux-amd64.tar.gz

mkdir /etc/containerd/
containerd config default > /etc/containerd/config.toml
grep sandbox_image /etc/containerd/config.toml
sed -i "s#registry.k8s.io/pause#registry.aliyuncs.com/google_containers/pause#g" /etc/containerd/config.toml
sed -i 's#SystemdCgroup = false#SystemdCgroup = true#g' /etc/containerd/config.toml
```
安装cni:
```shell
wget https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.8.0.tgz
```

安装runc：
```shell
wget https://github.com/opencontainers/runc/releases/download/v1.4.0-rc.3/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
```

安装nerdctl
```shell
wget https://github.com/containerd/nerdctl/releases/download/v2.2.0/nerdctl-2.2.0-linux-amd64.tar.gz
tar Cxzvf /usr/local/bin nerdctl-2.2.0-linux-amd64.tar.gz
```

## systemd
添加配置文件：`/usr/lib/systemd/system/containerd.service`
```text
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

```shell
systemctl daemon-reload
systemctl enable --now containerd
```

## nvidia-gpu runtime

## moorethread runtime