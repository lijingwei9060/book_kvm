


## 功能设计

- 用户管理功能
  - 用户注册： 用户密码使用Salted Hash保存，每个Salt随机且唯一，bcrypt hash后的字符串是包含salt信息不需要单独保存
  - 用户登录
  - 获取用户信息
  - 更新用户信息
  - 删除用户
- 认证功能
  - JWT token 认证
  - Token 刷新
  - 登出（token 失效）
- 授权功能
  - 基于角色的访问控制(RBAC)
  - 权限管理
  - 角色管理


## Token

refresh token
auth token


## 参考

amazon cogito
amazon sts