# Kube Proxy 的用途
Kube Proxy 的负责以下几个方面的流量路由:
1. ClusterIP: 集群内通过 ClusterIP 的访问
2. NodePort: 集群内外通过 NodePort 的访问
3. ExternalIP: 集群外通过 external IP 的访问
4. LoadBalancer: 集群外通过 LoadBalancer 的访问

有3个方案： ipvs、bpf、iptables。


## cilium proxy

### 配置

### 验证

```shell
$ kubectl -n kube-system exec ds/cilium -- cilium status --verbose
...
KubeProxyReplacement Details:
  Status:                 Strict
  Socket LB:              Enabled
  Socket LB Tracing:      Enabled
  Socket LB Coverage:     Full
  Devices:                eth0 192.168.2.3 (Direct Routing)
  Mode:                   SNAT
  Backend Selection:      Random
  Session Affinity:       Enabled
  Graceful Termination:   Enabled
  NAT46/64 Support:       Disabled
  XDP Acceleration:       Disabled
  Services:
  - ClusterIP:      Enabled
  - NodePort:       Enabled (Range: 30000-32767)
  - LoadBalancer:   Enabled
  - externalIPs:    Enabled
  - HostPort:       Enabled
```