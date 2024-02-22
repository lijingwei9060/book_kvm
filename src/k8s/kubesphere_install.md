# intro

apt install socat conntrack ipset -y

export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.13 sh -
export KKZONE=cn
VERSION=v3.0.13 sh downloadKubekey.sh 


10.16.161.64 i-4a2fe681
10.16.161.24 i-c96ca55e
10.16.161.21 i-cc100c27

hostname小写


./kk create config --with-kubesphere  -f ./config.yaml


mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://we8dvwud.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker