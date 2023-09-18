# 想法

存储选择： 
1. etcd
2. mongodb
3. 嵌入式的数据库包装一下复制和容灾能力

对外的连接模式：
1. 支持http

数据权限控制：


业务脚本：

## 数据模型结构

属性ID
属性名称
属性描述
搜索排序
数据类型： 
	datetime
	text(正则规则)
	ref: 引用选择(service),更新状态，确定状态，引用命名，引用类型（属于，依赖，实现，使用，关联），过滤规则： 表[字段] op(equal, in notequal ,null, notnull,empty, notempty,) 表达式类型 表达式（host_resource.resource_set>resource_set.network_subzone>network_subzone:[guid]）
	select： 枚举配置
	object
	password：
	multiText
正则规则
真实类型： 数据库类型，varchar
长度

编辑分组
编辑重置
显示在表
允许为空
允许编辑
界面为空
是否唯一
自动填充
	填充类型 suggest/force
	填充规则：可以固定，也可以根据表进行选择字段组装


## 服务列表

kms：加密服务