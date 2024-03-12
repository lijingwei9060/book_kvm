# intro

apt install socat conntrack ipset -y
apt install linux-tools-common linux-tools-5.15.0-100-generic -y

export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.13 sh -
export KKZONE=cn
VERSION=v3.0.13 sh downloadKubekey.sh 


10.16.161.64 i-4a2fe681
10.16.161.24 i-c96ca55e
10.16.161.21 i-cc100c27

hostname小写


```
network:
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 10.16.161.24/24
      nameservers:
        addresses: [10.201.33.181, 10.201.33.189]
      routes:
        - to: default
          via: 10.16.161.254
  version: 2
```

ln -fs /run/systemd/resolve/resolv.conf /etc/resolv.conf

./kk create config --with-kubesphere  -f ./config.yaml


mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://we8dvwud.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker


## ks_installer过程

preInstallTasks包含preInstall、metrics-server、common、ks-core：
1. preInstall
   1. 检查kubesphere是否安装，ks-console
   2. precheck： 
      1. kubernetes版本大于1.19.0
      2. storage class根据设置是否有设置，如果设置了就要检查是否存在，如果没有设置就要检查是否有默认的。
      3. 验证密码强度
   3. 如果安装了是否要升级： helm 2to3 convert ，这些都是从2升级到3，包含
    - "ks-openldap"
    - "ks-redis"
    - "ks-minio"
    - "ks-openpitrix"
    - "elasticsearch-logging"
    - "elasticsearch-logging-curator"
    - "istio"
    - "istio-init"
    - "jaeger-operator"
    - "ks-jenkins"
    - "ks-sonarqube"
    - "logging-fluentbit-operator"
    - "uc"
    - "metrics-server"
2. Common： 
   1. 如果多master => 是否 enableHA => 
   2. snapshot-controller chart
   3. 检查openpitrix，升级pv
   4. 直接部署etcd和mysql
   5. minio
   6. redis
   7. openldap
   8. 设置pvc回收策略
3. ks-core： 
   1. 修改admin用户、生成初始密码
   2. 导入crd
   3. helm 导入ks-core
   4. 创建users 和workspace 管理器
   5. 检查upgrade
   6. 修改cc的status.core状态
   7. 检查告警管理器