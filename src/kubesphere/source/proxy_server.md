1. getClusterRole => host/member
2. getKSConfig => 
  config: => /kapis/config.kubesphere.io/v1alpha2/configs/configz
  version => /version
  enabledModule => 
3. getCurrentUser => User/Workspace/Cluster
  clusters => /kapis/tenant.kubesphere.io/v1beta1/clusters
  userDetail => /kapis/iam.kubesphere.io/v1beta1/users/${username}
  globalRoles => /kapis/iam.kubesphere.io/v1beta1/users/${username}/roletemplates?scope=global
  workspace => /kapis/tenant.kubesphere.io/v1beta1/workspaces
4. getK8sRuntime => docker/node.status.nodeInfo.containerRuntimeVersion