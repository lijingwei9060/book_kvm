# intro
Kube Proxy 的负责以下几个方面的流量路由:

1. ClusterIP: 集群内通过 ClusterIP 的访问
2. NodePort: 集群内外通过 NodePort 的访问
3. ExternalIP: 集群外通过 external IP 的访问
4. LoadBalancer: 集群外通过 LoadBalancer 的访问.