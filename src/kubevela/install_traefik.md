# 1) Generate a self‑signed certificate valid for *.docker.s80
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=*.docker.s80"

# 2) Create the TLS secret in the traefik namespace
kubectl create secret tls local-selfsigned-tls \
  --cert=tls.crt --key=tls.key \
  --namespace traefik


# Configure Network Ports and EntryPoints
# EntryPoints are the network listeners for incoming traffic.
ports:
  # Defines the HTTP entry point named 'web'
  web:
    port: 80
    nodePort: 30001
    # Instructs this entry point to redirect all traffic to the 'websecure' entry point
    redirections:
      entryPoint:
        to: websecure
        scheme: https
        permanent: true

  # Defines the HTTPS entry point named 'websecure'
  websecure:
    port: 443
    nodePort: 30002

# Enables the dashboard in Secure Mode
api:
  dashboard: true
  insecure: false

ingressRoute:
  dashboard:
    enabled: true
    matchRule: Host(`dashboard.docker.s80`)
    entryPoints:
      - websecure
    middlewares:
      - name: dashboard-auth

# Creates a BasiAuth Middleware and Secret for the Dashboard Security
extraObjects:
  - apiVersion: v1
    kind: Secret
    metadata:
      name: dashboard-auth-secret
    type: kubernetes.io/basic-auth
    stringData:
      username: admin
      password: "P@ssw0rd"      # Replace with an Actual Password
  - apiVersion: traefik.io/v1alpha1
    kind: Middleware
    metadata:
      name: dashboard-auth
    spec:
      basicAuth:
        secret: dashboard-auth-secret

# We will route with Gateway API instead.
ingressClass:
  enabled: false

# Enable Gateway API Provider & Disables the KubernetesIngress provider
# Providers tell Traefik where to find routing configuration.
providers:
  kubernetesIngress:
     enabled: false
  kubernetesGateway:
     enabled: true

## Gateway Listeners
gateway:
  listeners:
    web:           # HTTP listener that matches entryPoint `web`
      port: 80
      protocol: HTTP
      namespacePolicy:
        from: All

    websecure:         # HTTPS listener that matches entryPoint `websecure`
      port: 443
      protocol: HTTPS  # TLS terminates inside Traefik
      namespacePolicy:
        from: All
      mode: Terminate
      certificateRefs:    
        - kind: Secret
          name: local-selfsigned-tls  # the Secret we created before the installation
          group: ""

# Enable Observability
logs:
  general:
    level: INFO
  # This enables access logs, outputting them to Traefik's standard output by default. The [Access Logs Documentation](https://doc.traefik.io/traefik/observability/access-logs/) covers formatting, filtering, and output options.
  access:
    enabled: true

# Enables Prometheus for Metrics
metrics:
  prometheus:
    enabled: false



ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/traefik:v3.5.3

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/traefik:v3.5.3
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/traefik:v3.5.3  docker.io/library/traefik:v3.5.3

ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/rancher/klipper-lb:v0.4.3
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/rancher/klipper-lb:v0.4.3  docker.io/rancher/klipper-lb:v0.4.3