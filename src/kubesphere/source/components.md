

## iam
1. User
2. Group
3. GroupBinding: 一个Group有哪些User

Role
RoleBinding
ClusterRole
ClusterRoleBinding
GlobalRole
GlobalRoleBinding
RoleTemplate
BuiltinRole
WorkspaceRole

Category

LoginRecord： 

## Tenant

1. workspaces： 1个workspace可以使用多个cluster
  resourcequotas： worksapce资源配合限制
  metrics： 平台指标
2. clusters
3. namespaces： 可以关联到workspace，只能关联一个workspace
4. workspacetemplates