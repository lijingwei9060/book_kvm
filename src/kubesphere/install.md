export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v3.0.13 sh -

./kk create config --with-kubernetes  --with-kubesphere   [(-f | --file) path]
