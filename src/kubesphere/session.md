cookie中包含‘token’， 确保登录了
服务器端：
1. clusterRole： host/member
2. oauthinfo: 从/kapis/config.kubesphere.io/v1alpha2/configs/oauth
3. theme： /kapis/config.kubesphere.io/v1alpha2/configs/theme
4. k8sruntime: /api/v1/nodes => nodeList.items[0].status.nodeInfo.containerRuntimeVersion, 
5. 从token获取username： /kapis/iam.kubesphere.io/v1beta1/users/${username}
glboalrole =>  metadata.annotations["iam.kubesphere.io/globalrole"]
grantedClusters: metadata.annotations["iam.kubesphere.io/granted-clusters"]
uninitialized: metadata.annotations["iam.kubesphere.io/uninitialized"]
lastLoginTime: status.lastLoginTime
otpEnabled: metadata.annotations.["iam.kubesphere.io/totp-auth-key-ref"]
globalRules = /kapis/iam.kubesphere.io/v1beta1/users/${username}/roletemplates?scope=global
            将所有的聚合：metadata.annotations['iam.kubesphere.io/role-template-rules']
后端 => ListRoleTemplateOfUser




user管理：
1. /kapis/iam.kubesphere.io/v1beta1/users