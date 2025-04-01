GET https://dbprovider.hzh.sealos.run/api/getEnv
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "domain": "dbconn.sealoshzh.site",
        "desktopDomain": "hzh.sealos.run",
        "env_storage_className": "openebs-backup",
        "migrate_file_image": "wallykk/migration:1.1",
        "minio_url": "objectstorageapi.hzh.sealos.run",
        "BACKUP_ENABLED": true,
        "SHOW_DOCUMENT": false,
        "CurrencySymbol": "shellCoin",
        "STORAGE_MAX_SIZE": 300
    }
}
```

GET https://dbprovider.hzh.sealos.run/api/platform/getQuota
```json
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "quota": [
            {
                "type": "cpu",
                "limit": 16,
                "used": 0
            },
            {
                "type": "memory",
                "limit": 64,
                "used": 0
            },
            {
                "type": "storage",
                "limit": 100,
                "used": 0
            }
        ]
    }
}
```

GET https://dbprovider.hzh.sealos.run/api/platform/resourcePrice
```json
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "cpu": 0.0276706,
        "memory": 0.0139558912,
        "storage": 0.0008458239999999999,
        "nodeports": 0.0139
    }
}
```


GET https://dbprovider.hzh.sealos.run/api/platform/getVersion
```json
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "postgresql": [
            {
                "id": "postgresql-14.8.0",
                "label": "postgresql-14.8.0"
            },
            {
                "id": "postgresql-14.7.2",
                "label": "postgresql-14.7.2"
            },
            {
                "id": "postgresql-12.15.0",
                "label": "postgresql-12.15.0"
            },
            {
                "id": "postgresql-12.14.1",
                "label": "postgresql-12.14.1"
            },
            {
                "id": "postgresql-12.14.0",
                "label": "postgresql-12.14.0"
            }
        ],
        "mongodb": [
            {
                "id": "mongodb-6.0",
                "label": "mongodb-6.0"
            },
            {
                "id": "mongodb-5.0.20",
                "label": "mongodb-5.0.20"
            },
            {
                "id": "mongodb-5.0",
                "label": "mongodb-5.0"
            },
            {
                "id": "mongodb-4.4",
                "label": "mongodb-4.4"
            },
            {
                "id": "mongodb-4.2",
                "label": "mongodb-4.2"
            }
        ],
        "apecloud-mysql": [
            {
                "id": "ac-mysql-8.0.31",
                "label": "ac-mysql-8.0.31"
            },
            {
                "id": "ac-mysql-8.0.30",
                "label": "ac-mysql-8.0.30"
            }
        ],
        "redis": [
            {
                "id": "redis-7.0.6",
                "label": "redis-7.0.6"
            }
        ],
        "kafka": [
            {
                "id": "kafka-3.3.2",
                "label": "kafka-3.3.2"
            }
        ],
        "qdrant": [],
        "nebula": [],
        "weaviate": [
            {
                "id": "weaviate-1.18.0",
                "label": "weaviate-1.18.0"
            }
        ],
        "milvus": [
            {
                "id": "milvus-2.4.5",
                "label": "milvus-2.4.5"
            },
            {
                "id": "milvus-2.3.2",
                "label": "milvus-2.3.2"
            },
            {
                "id": "milvus-2.2.4",
                "label": "milvus-2.2.4"
            }
        ]
    }
}
```


get https://dbprovider.hzh.sealos.run/api/getDBList
```json
{"code":200,"statusText":"","message":"","data":[]}
```


POST https://dbprovider.hzh.sealos.run/api/applyYamlList
-data {"yamlList":["\napiVersion: v1\nkind: LimitRange\nmetadata:\n  name: ns-p4v4vcc1\nspec:\n  limits:\n    - default:\n        cpu: 50m\n        memory: 64Mi\n      type: Container\n"],"type":"create"}
```json
{
    "code": 500,
    "statusText": "",
    "message": "limitranges \"ns-p4v4vcc1\" already exists",
    "data": {
        "response": {
            "statusCode": 409,
            "body": {
                "kind": "Status",
                "apiVersion": "v1",
                "metadata": {},
                "status": "Failure",
                "message": "limitranges \"ns-p4v4vcc1\" already exists",
                "reason": "AlreadyExists",
                "details": {
                    "name": "ns-p4v4vcc1",
                    "kind": "limitranges"
                },
                "code": 409
            },
            "headers": {
                "audit-id": "c3792acf-1fc5-4fe7-9435-73e72041f873",
                "cache-control": "no-cache, private",
                "content-type": "application/json",
                "warning": "299 - \"Use tokens from the TokenRequest API or manually created secret-based tokens instead of auto-generated secret-based tokens.\"",
                "x-kubernetes-pf-flowschema-uid": "d5ed0d70-22c4-4f86-bb8e-8c7cf9394b9e",
                "x-kubernetes-pf-prioritylevel-uid": "41410af8-b285-4f87-a2f3-6079861126f3",
                "date": "Mon, 24 Feb 2025 03:15:13 GMT",
                "content-length": "214",
                "connection": "close"
            },
            "request": {
                "uri": {
                    "protocol": "https:",
                    "slashes": true,
                    "auth": null,
                    "host": "10.96.0.1:443",
                    "port": "443",
                    "hostname": "10.96.0.1",
                    "hash": null,
                    "search": null,
                    "query": null,
                    "pathname": "/api/v1/namespaces/ns-p4v4vcc1/limitranges",
                    "path": "/api/v1/namespaces/ns-p4v4vcc1/limitranges",
                    "href": "https://10.96.0.1:443/api/v1/namespaces/ns-p4v4vcc1/limitranges"
                },
                "method": "POST",
                "headers": {
                    "accept": "application/json",
                    "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InlGc0g3a2JCNFo2R1BpczRDRlA1Ykhkb2VNSlVIMU1PZ1ktYUpyVDJrd28ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ1c2VyLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJzZWFsb3MtdG9rZW4tcDR2NHZjYzEtMTRlNyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJwNHY0dmNjMSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImY1NGY4OTdkLWUxNjktNDQ0YS1iNTgxLTY5NWY3YjdkY2Y0MyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDp1c2VyLXN5c3RlbTpwNHY0dmNjMSJ9.f1746ZzcSX1xzPV6TWFgKRnFDckO1jV6BEEOiOYF96e5DzoCpA4mAG6coQ1enUf9VQxfIDp86NZaI5X-5pVcTilV8RSC1j_lYxRjO70UCnL4zOVhmUA3WglCn2CB-PxWPxoY3GaFblf6ESAFR48olbEH_GNryUEXtFtEOZTw-RxB4cyUton7FQCz7QlK4CtSxEcrd4WnaDuxbAqa-rtX_it-SahHEQbgH25sfQvn3L_mDb8CscUhKrO_Xw1pI77rTyg86JKPzZo2SmloQ7XFKTuLlliJ6M1a65VmADwyd9iH_RTVYBkJuFylwSsyE_jY3h_5gHFWLvtwZEpzEoYTZA",
                    "content-type": "application/json",
                    "content-length": 485
                }
            }
        },
        "body": {
            "apiVersion": "v1",
            "code": 409,
            "details": {
                "kind": "limitranges",
                "name": "ns-p4v4vcc1"
            },
            "kind": "Status",
            "message": "limitranges \"ns-p4v4vcc1\" already exists",
            "metadata": {},
            "reason": "AlreadyExists",
            "status": "Failure"
        },
        "statusCode": 409,
        "name": "HttpError"
    }
}
```

POST https://dbprovider.hzh.sealos.run/api/createDB
-DATA {"dbForm":{"dbType":"postgresql","dbVersion":"postgresql-14.8.0","dbName":"test-db","replicas":2,"cpu":1000,"memory":1024,"storage":3,"labels":{},"autoBackup":{"start":true,"type":"day","week":[],"hour":"23","minute":"00","saveTime":7,"saveType":"d"},"terminationPolicy":"WipeOut"},"isEdit":false}
```JSON
{"code":200,"statusText":"","message":"","data":"success create db"}
```


GET https://dbprovider.hzh.sealos.run/_next/data/M-41eOo-q39YYgSRZN0UU/zh/db/detail.json?name=test-db&dbType=postgresql
```JSON
{
    "pageProps": {
        "_nextI18Next": {
            "initialI18nStore": {
                "zh": {
                    "common": {
                        "Auto": "自动",
                        "Backup": "备份",
                        "Cancel": "取消",
                        "Click on any shadow to skip": "点击任意阴影跳过",
                        "Containers": "容器",
                        "Continue": "继续",
                        "Creating": "创建中",
                        "CronExpression": "循环周期",
                        "DBList": "数据库列表",
                        "DataBase": "数据库",
                        "Day": "天",
                        "Delete": "删除",
                        "Deleting": "删除中",
                        "Disk": "磁盘空间",
                        "Export": "导出",
                        "Failed": "异常",
                        "Friday": "周五",
                        "Hour": "小时",
                        "Logs": "日志",
                        "Manual": "手动",
                        "Migrate": "迁移",
                        "Migrating": "正在迁移",
                        "Monday": "周一",
                        "Option": "选填",
                        "Page": "页",
                        "Password": "密码",
                        "Pause": "暂停",
                        "Paused": "已暂停",
                        "Pausing": "暂停中",
                        "Perday": "每日",
                        "Performance": "性能",
                        "Pod": "实例",
                        "Pod Name": "实例名",
                        "Port": "端口",
                        "Replicas": "实例数",
                        "Resources": "资源",
                        "Restart": "重启",
                        "Restarting": "重启中",
                        "Running": "运行中",
                        "Saturday": "周六",
                        "Save": "保存",
                        "SaveTime": "保留时间",
                        "Start": "开始",
                        "Starting": "启动中",
                        "Success": "成功",
                        "Sunday": "周日",
                        "Thursday": "周四",
                        "Total": "总数",
                        "Tuesday": "周二",
                        "Type": "类型",
                        "Unknown": "未知",
                        "Updating": "变更中",
                        "Username": "用户名",
                        "Wednesday": "周三",
                        "Week": "周",
                        "aborted_connections": "异常连接数",
                        "active_connections": "活跃连接数",
                        "advanced_configuration": "高级配置",
                        "age": "运行时长",
                        "anticipated_price": "预估价格",
                        "app": {
                            "cpu_exceeds_quota": "申请的 CPU 超出限制，请联系管理员",
                            "memory_exceeds_quota": "申请的 '内存' 超出限制，请联系管理员",
                            "resource_quota": "资源配额",
                            "storage_exceeds_quota": "申请的 '存储' 超出限制，请联系管理员"
                        },
                        "app_store": "应用商店",
                        "application_source": "来源",
                        "are_you_sure_to_perform_database_migration": "确定执行数据库迁移吗?",
                        "are_you_sure_you_want_to_turn_off_automatic_backup": "确定关闭自动备份吗",
                        "auto_backup": "自动备份",
                        "automatic_backup_is_turned_off": "已关闭自动备份",
                        "backup_center": "备份中心",
                        "backup_center_search_tip": "搜索备份名称、备注",
                        "backup_completed": "备份成功",
                        "backup_database": "备份数据库",
                        "backup_deleting": "删除中",
                        "backup_failed": "备份失败",
                        "backup_list": "数据备份",
                        "backup_name": "备份名",
                        "backup_name_cannot_empty": "备份名称不能为空",
                        "backup_processing": "备份中",
                        "backup_running": "备份中",
                        "backup_settings": "备份设置",
                        "backup_success_tip": "备份任务已经成功创建",
                        "backup_time": "备份时间",
                        "balance": "余额",
                        "basic": "基础信息",
                        "billing_standards": "计费标准",
                        "block_read_time": "读数据块时间",
                        "block_write_time": "写数据块时间",
                        "cannot_change_name": "不允许修改数据库名称",
                        "collection_name": "集合名称",
                        "command_latency": "命令延迟",
                        "commits_per_second": "事务数",
                        "common": {
                            "Surplus": "剩余",
                            "Total": "总共",
                            "Used": "已用",
                            "input": {
                                "No Elements to Delete": "没有要删除的元素",
                                "Repeat Value": "输入重复值"
                            }
                        },
                        "config_form": "配置表单",
                        "config_info": "配置信息",
                        "confirm": "确认",
                        "confirm_delete": "确认删除",
                        "confirm_delete_the_backup": "确认删除该备份？",
                        "confirm_delete_the_migrate": "确定删除迁移记录吗?",
                        "confirm_deploy_database": "确认部署数据库?",
                        "confirm_restart": "确认重启该应用?",
                        "confirm_restart_pod": "请确认重启 Pod？",
                        "confirm_to_go": "确认前往",
                        "confirm_update_database": "确认更新数据库?",
                        "connection_info": "连接信息",
                        "continuous_migration": "持续迁移",
                        "copy_failed": "复制失败",
                        "copy_success": "复制成功",
                        "covering_risks": "覆盖风险",
                        "cpu": "CPU",
                        "create_db": "新建",
                        "creation_time": "创建时间",
                        "current_connections": "当前连接数",
                        "data_import": "数据导入",
                        "data_migration_config": "数据迁移配置",
                        "database_config": "数据库参数",
                        "database_edit_config": "变更参数",
                        "database_empty": "您还没有数据库",
                        "database_host": "数据库主机名",
                        "database_host_empty": "缺少数据库主机名",
                        "database_name": "新数据库名",
                        "database_name_cannot_empty": "数据库名称不能为空",
                        "database_name_empty": "应用名称不能为空",
                        "database_name_max_length": "数据库名长度不能超过 {{length}} 个字符",
                        "database_name_regex": "字母开头，仅能包含小写字母、数字和 -",
                        "database_name_regex_error": "数据库名只能包含小写字母、数字和 -,并且字母开头。",
                        "database_password_empty": "缺少数据库密码",
                        "database_port_empty": "缺少数据库端口",
                        "database_type": "数据库类型",
                        "database_usage": "数据库用量",
                        "database_username_empty": "缺少数据库用户名",
                        "db_instances_tip": "{{db}} 实例数量建议为奇数",
                        "db_name": "数据库名字",
                        "db_table": "数据库表",
                        "dbconfig": {
                            "change_history": "变更历史",
                            "commit": "提交",
                            "confirm_updates": "请确认您修改的参数：",
                            "get_config_err": "获取配置文件失败",
                            "modified_value": "修改值",
                            "modify_time": "修改时间",
                            "no_changes": "暂无修改",
                            "original_value": "原始值",
                            "parameter": "参数配置",
                            "parameter_name": "参数名",
                            "parameter_value": "参数值",
                            "prompt": "变更须知",
                            "search": "搜索",
                            "updates": "修改的参数",
                            "updates_tip": "mongo数据库变更配置会导致数据库重启",
                            "updates_tip2": "参数值错误可能会导致数据库无法正常运行，请谨慎操作。"
                        },
                        "delete_anyway": "仍要删除",
                        "delete_backup": "删除备份",
                        "delete_backup_with_db": "保留备份",
                        "delete_backup_with_db_tip": "在删除数据库时，保留其备份",
                        "delete_failed": "删除出现意外",
                        "delete_hint": "如果确认要删除这个数据库吗？如果执行此操作，将删除该数据库的所有数据。",
                        "delete_sealaf_app_tip": "该数据库是通过云开发部署的。仅删除数据库无法清除应用的所有组件，这些组件可能仍会产生费用。要彻底卸载应用并清理所有相关组件，请在云开发中卸载整个应用。",
                        "delete_successful": "删除成功",
                        "delete_template_app_tip": "该数据库是通过应用商店部署的。仅删除数据库无法清除应用的所有组件，这些组件可能仍会产生费用。要彻底卸载数据库并清理所有相关组件，请在应用商店中卸载整个应用。",
                        "delete_warning": "删除警告",
                        "deploy": "部署",
                        "deploy_database": "部署数据库",
                        "deployment_failed": "部署失败",
                        "deployment_successful": "部署成功",
                        "details": "详情",
                        "direct_connection": "连接",
                        "document_operations": "文档操作数",
                        "duration_of_transaction": "事务持续时间",
                        "enable_external_network_access": "开启外网访问",
                        "enter_save": "回车保存 && All 代表导出整个库",
                        "error_log": {
                            "analysis": "日志分析",
                            "collection_time": "采集时间",
                            "content": "信息",
                            "error_log": "错误日志",
                            "runtime_log": "运行日志",
                            "search_content": "搜索日志内容",
                            "slow_query": "慢日志"
                        },
                        "event_analyze": "智能分析",
                        "event_analyze_error": "智能分析出错了~",
                        "external_address": "外网地址",
                        "external_network": "外网访问",
                        "failed_to_turn_off_automatic_backup": "关闭自动备份失败",
                        "file": {
                            "Upload Success": "文件上传成功",
                            "Uploading": "正在上传文件，进度: {{percent}}%"
                        },
                        "file_upload_failed": "文件上传失败",
                        "first_charge": "首充福利",
                        "gift": "赠",
                        "go_to_recharge": "去充值",
                        "guide_deploy_button": "完成创建",
                        "guide_terminal_button": "便捷的终端连接方式，提升数据处理效率",
                        "have_error": "出现异常",
                        "hits_ratio": "命中率",
                        "hour": "时",
                        "import_through_file": "文件导入",
                        "important_tips_for_migrating": "如果 source 数据库中 source_database 和 sink 数据库中 sink_database 的数据库有重叠，应该在sink 数据库中新建 database，以免出现数据重叠",
                        "innodb_buffer_pool": "InnoDB 缓冲池",
                        "intranet_address": "内网地址",
                        "items_per_db": "键值数",
                        "jump_prompt": "跳转提示",
                        "key_evictions": "键驱逐数",
                        "let_me_think_again": "稍后再说",
                        "limit_cpu": "最大 CPU",
                        "limit_memory": "最大内存",
                        "lost_file": "缺少文件",
                        "manage_all_resources": "管理所有资源",
                        "manual_backup": "手动备份",
                        "manual_backup_tip": "建议在业务低峰期备份实例。备份期间，请勿执行DDL操作，避免锁表导致备份失败。若数据量较大，花费的时问可能较长，请耐心等待。点击 [开始备份] 后，将在1分钟后开始备份。",
                        "max_replicas": "实例数最大为: ",
                        "memory": "内存",
                        "migrate": {
                            "Incremental migration prompt information": "如果需要数据库增量同步，可以开启\"持续迁移\"，默认是关闭。",
                            "mongo": {
                                "check": "source account: 待迁移仓库的读权限、admin、local\nsink account: 待迁移仓库的读写权限以及admin和local的读权限"
                            },
                            "mongodb": {
                                "stepOne": "# 复制集群实例: 无需伸缩。需要提供用于迁移的主地址的地址",
                                "stepTwo": "# Standalone实例：需要将Standalone扩展到一个节点的副本集才能使用CDC"
                            },
                            "mysql": {
                                "stepOne": "# 设置 'binlog_format' 配置为 'row'",
                                "stepTwo": "# 设置 'binlog_row_image' 配置为'full'"
                            },
                            "postgresql": {
                                "check": "source account：登录权限、源迁移对象的读权限、复制权限 \nsink account：登录权限、Sink的读/写权限",
                                "stepOne": "# 设置 'wal_level' 配置为 'logical'",
                                "stepTwo": "# 确保配置的\"max_replication_slots\"、\"max_wal_senders\"数量足够"
                            }
                        },
                        "migrate_config": "迁移配置",
                        "migrate_now": "立即迁移",
                        "migration_failed": "迁移失败",
                        "migration_permission_check": "迁移权限检查",
                        "migration_preparation": "迁移准备",
                        "migration_preparations": "我已阅读并完成迁移准备工作",
                        "migration_prompt_information": "迁移时请勿执行操作，以免因XXX导致迁移失败。如数据量较大，迁移时间可能较长，请耐心等待",
                        "migration_successful": "迁移成功",
                        "migration_task_created_successfully": "迁移任务创建成功",
                        "min_replicas": "实例数最小为: ",
                        "minute": "分",
                        "monitor_list": "实时监控",
                        "multi_replica_redis_tip": "Redis 多副本包含 HA 节点，请悉知，预估价格已包含 HA 节点费用",
                        "name": "名字",
                        "no_data_available": "暂无数据",
                        "no_logs_for_now": "暂无日志",
                        "not_allow_standalone_use": "该应用不允许单独使用，点击确认前往 Sealos Desktop 使用。",
                        "online_import": "在线导入",
                        "operation": "操作",
                        "overview": "概览",
                        "page_faults": "页错误",
                        "pause_error": "数据库暂停失败",
                        "pause_hint": "暂停服务将停止计算 CPU 和内存等费用，但存储和外网端口仍将产生费用。是否现在暂停？",
                        "pause_success": "数据库已暂停",
                        "please_enter": "请输入",
                        "prompt": "提示",
                        "query_operations": "查询操作数",
                        "receive": "收到",
                        "remark": "备注",
                        "remark_tip": "最多包含10个中文字符，30个英文字符。",
                        "remind": "提醒",
                        "replicas_cannot_empty": "实例数不能为空",
                        "replicas_list": "实例列表",
                        "restart_error": "重启出现了意外",
                        "restart_success": "重启成功，请等待",
                        "restarts": "重启次数",
                        "restore_backup": "恢复备份",
                        "restore_backup_tip": "恢复备份会创建一个新的数据库，你需要提供新的数据库名，并且不能与当前数据库重名。",
                        "restore_database": "恢复数据库备份",
                        "restore_success": "恢复备份成功",
                        "rollbacks_per_second": "回滚数",
                        "running_time": "运行时长",
                        "sealaf": "云开发",
                        "select_a_maximum_of_10_files": "最多选择 10 个文件",
                        "service_deletion_failed": "Service 删除失败",
                        "set_auto_backup_successful": "设置自动备份任务成功",
                        "single_node_tip": "单节点数据库仅适用开发测试",
                        "skip": "跳过",
                        "slow_queries": "慢查询",
                        "source_database": "源数据库",
                        "start_backup": "开始备份",
                        "start_error": "数据库启动出现意外",
                        "start_hour": "小时",
                        "start_minute": "分钟",
                        "start_success": "数据库启动成功，请等待",
                        "start_time": "开始时间",
                        "status": "状态",
                        "storage": "磁盘",
                        "storage_cannot_empty": "容量不能为空",
                        "storage_max": "最大存储",
                        "storage_min": "最小存储",
                        "storage_range": "容量范围: ",
                        "streaming_logs": "实时日志",
                        "submit_error": "提交表单错误",
                        "successfully_closed_external_network_access": "已关闭外网访问",
                        "table_locks": "表锁",
                        "terminated_logs": "中断前",
                        "termination_policy": "删除策略",
                        "termination_policy_tip": "删除数据库时是否保留备份",
                        "total_price": "总价",
                        "total_price_tip": "预估费用不包括端口费用和流量费用,以实际使用为准",
                        "turn_on": "开启",
                        "update": "变更",
                        "update_database": "变更数据库",
                        "update_failed": "更新失败",
                        "update_sealaf_app_tip": "该数据库是通过云开发部署的，变更该数据库请到云开发中进行。",
                        "update_successful": "更新成功",
                        "update_time": "更新时间",
                        "upload_dump_file": "点击上传 Dump 文件",
                        "use_docs": "使用文档",
                        "version": "版本",
                        "wipeout_backup_with_db": "随数据库删除",
                        "wipeout_backup_with_db_tip": "在删除数据库时，删除其备份",
                        "within_1_day": "一天内",
                        "within_1_hour": "一小时内",
                        "within_5_minutes": "五分钟内",
                        "yaml_file": "YAML 文件",
                        "you_have_successfully_deployed_database": "您已成功部署创建一个数据库！",
                        "change_log": "变更历史",
                        "VerticalScaling": "纵向扩展",
                        "VerticalScalingCPU": "纵向扩展（CPU）",
                        "VerticalScalingMemory": "纵向扩展（内存）",
                        "HorizontalScaling": "横向扩展（实例数）",
                        "VolumeExpansion": "卷扩展（磁盘）",
                        "Stop": "停止"
                    }
                },
                "en": {
                    "common": {
                        "Auto": "Automatic",
                        "Backup": "Backup",
                        "Cancel": "Discard",
                        "Click on any shadow to skip": "Click on any shadow to skip",
                        "Containers": "Containers",
                        "Continue": "Continue",
                        "Creating": "Creating",
                        "CronExpression": "Cycle Interval",
                        "DBList": "Database",
                        "DataBase": "Database",
                        "Day": "Day",
                        "Delete": "Delete",
                        "Deleting": "Deleting...",
                        "Disk": "Storage Size",
                        "Export": "Export",
                        "Failed": "Error",
                        "Friday": "Friday",
                        "Hour": "Hour",
                        "Logs": "Logs",
                        "Manual": "Manual",
                        "Migrate": "Migrate",
                        "Migrating": "Migrating",
                        "Monday": "Monday",
                        "Option": "Optional",
                        "Page": "Page",
                        "Password": "Password",
                        "Pause": "Pause",
                        "Paused": "Paused",
                        "Pausing": "Pausing",
                        "Perday": "Perday",
                        "Performance": "Performance",
                        "Pod": "Pod",
                        "Pod Name": "Pod Name",
                        "Port": "Port",
                        "Replicas": "Replicas",
                        "Resources": "Resources",
                        "Restart": "Restart",
                        "Restarting": "Restarting",
                        "Running": "Running",
                        "Saturday": "Sat",
                        "Save": "Save",
                        "SaveTime": "Retention",
                        "Start": "Start",
                        "Starting": "Starting",
                        "Success": "succeeded",
                        "Sunday": "Sun",
                        "Thursday": "Thu",
                        "Total": "total",
                        "Tuesday": "Tue",
                        "Type": "Type",
                        "Unknown": "Unknown",
                        "Updating": "Updating",
                        "Username": "Username",
                        "Wednesday": "Wed",
                        "Week": "Week",
                        "aborted_connections": "Dropped Connections",
                        "active_connections": "Active Connections",
                        "advanced_configuration": "Advanced Settings",
                        "age": "Runtime",
                        "anticipated_price": "Projected Cost",
                        "app": {
                            "cpu_exceeds_quota": "CPU requested exceeds quota. Contact admin.",
                            "memory_exceeds_quota": "Memory requested exceeds quota. Contact admin.",
                            "resource_quota": "Resource Limits",
                            "storage_exceeds_quota": "Storage requested exceeds quota. Contact admin."
                        },
                        "app_store": "App Store",
                        "application_source": "Source",
                        "are_you_sure_to_perform_database_migration": "Confirm database migration?",
                        "are_you_sure_you_want_to_turn_off_automatic_backup": "Confirm disabling auto backup?",
                        "auto_backup": "Automated Backup",
                        "automatic_backup_is_turned_off": "Auto backup disabled",
                        "backup_center": "Backup Center",
                        "backup_center_search_tip": "Search backup name, notes",
                        "backup_completed": "Backup completed",
                        "backup_database": "Backup Database",
                        "backup_deleting": "Purging Backup",
                        "backup_failed": "Backup Failed",
                        "backup_list": "Backups",
                        "backup_name": "Backup Name",
                        "backup_name_cannot_empty": "Must provide backup name",
                        "backup_processing": "Saving Backup",
                        "backup_running": "Saving Backup",
                        "backup_settings": "Backup",
                        "backup_success_tip": "The backup task has been successfully created",
                        "backup_time": "Backup Timestamp",
                        "balance": "balance",
                        "basic": "Basic",
                        "billing_standards": "Pricing Guidelines",
                        "block_read_time": "Block Read Duration",
                        "block_write_time": "Block Write Duration",
                        "cannot_change_name": "Database name cannot be changed",
                        "collection_name": "Collection Name",
                        "command_latency": "Command Latency",
                        "commits_per_second": "Transactions per Second",
                        "common": {
                            "Surplus": "Surplus",
                            "Total": "Total",
                            "Used": "Used",
                            "input": {
                                "No Elements to Delete": "No elements selected for deletion",
                                "Repeat Value": "Duplicate value entered"
                            }
                        },
                        "config_form": "Form",
                        "config_info": "Configuration Details",
                        "confirm": "Confirm",
                        "confirm_delete": "Confirm",
                        "confirm_delete_the_backup": "Confirm deleting this backup?",
                        "confirm_delete_the_migrate": "Confirm deleting the migration record?",
                        "confirm_deploy_database": "Confirm deploying the database?",
                        "confirm_restart": "Confirm restarting this application?",
                        "confirm_restart_pod": "Confirm restarting the pod?",
                        "confirm_to_go": "Confirm",
                        "confirm_update_database": "Confirm updating the database?",
                        "connection_info": "Connection Details",
                        "continuous_migration": "Continuous Migration",
                        "copy_failed": "Copy Failed",
                        "copy_success": "Copy succeeded",
                        "covering_risks": "Coverage Risks",
                        "cpu": "CPU",
                        "create_db": "Create Database",
                        "creation_time": "Creation Time",
                        "current_connections": "Current Connections",
                        "data_import": "Data Import",
                        "data_migration_config": "Data Migration Settings",
                        "database_config": "parameters",
                        "database_edit_config": "Update Parameters",
                        "database_empty": "You don't have any databases yet",
                        "database_host": "Database Hostname",
                        "database_host_empty": "Please enter the database hostname",
                        "database_name": "Database Name",
                        "database_name_cannot_empty": "Database name cannot be empty",
                        "database_name_empty": "Application name is required",
                        "database_name_max_length": "Database name length cannot exceed {{length}} characters",
                        "database_name_regex": "Start with a letter, only allow lowercase letters, numbers and -",
                        "database_name_regex_error": "Database name can only contain lowercase letters, numbers, -, and must start with a letter.",
                        "database_password_empty": "Please enter the database password",
                        "database_port_empty": "Please specify the database port",
                        "database_type": "DataBase Type",
                        "database_usage": "Database Usage",
                        "database_username_empty": "Please enter the database username",
                        "db_instances_tip": "For optimal performance, use an odd number of {{db}} instances",
                        "db_name": "DataBase Name",
                        "db_table": "DataBase Table",
                        "dbconfig": {
                            "change_history": "Operation History",
                            "commit": "submit",
                            "confirm_updates": "Please confirm the parameters you modified:",
                            "get_config_err": "Failed to obtain configuration file",
                            "modified_value": "Modify value",
                            "modify_time": "Modify Time",
                            "no_changes": "No modification yet",
                            "original_value": "Original value",
                            "parameter": "Parameters",
                            "parameter_name": "parameter name",
                            "parameter_value": "Parameter value",
                            "prompt": "Change notice",
                            "search": "search",
                            "updates": "Modified parameters",
                            "updates_tip": "Changing the configuration of the mongo database will cause the database to restart",
                            "updates_tip2": "Incorrect parameter values ​​may cause the database to fail to operate normally, so please operate with caution."
                        },
                        "delete_anyway": "Force Delete",
                        "delete_backup": "Delete Backup",
                        "delete_backup_with_db": "Keep Backups",
                        "delete_backup_with_db_tip": "Delete the databases but leave the backups as they are",
                        "delete_failed": "Failed to delete",
                        "delete_hint": "Warning: This will permanently delete all data in the database. Confirm to proceed.",
                        "delete_sealaf_app_tip": "The database is deployed via cloud development. \nSimply deleting the database does not clear out all components of your app, which may still incur charges. \nTo completely uninstall the app and clean all related components, uninstall the entire app in cloud development.",
                        "delete_successful": "Deleted successfully",
                        "delete_template_app_tip": "The database is deployed via the app store. \nSimply deleting the database does not clear out all components of your app, which may still incur charges. \nTo completely uninstall the database and clean all related components, uninstall the entire app in the App Store.",
                        "delete_warning": "Delete Warning",
                        "deploy": "Deploy",
                        "deploy_database": "Deploy DataBase",
                        "deployment_failed": "Deployment Failed",
                        "deployment_successful": "Deployed Successfully",
                        "details": "Details",
                        "direct_connection": "connect",
                        "document_operations": "Document Operations",
                        "duration_of_transaction": "Transaction Duration",
                        "enable_external_network_access": "Allow public network access",
                        "enter_save": "Press Enter to save. 'All' exports the entire database.",
                        "error_log": {
                            "analysis": "Logs",
                            "collection_time": "Collection Time",
                            "content": "Information",
                            "error_log": "Error Log",
                            "runtime_log": "Run Log",
                            "search_content": "Search Log Content",
                            "slow_query": "Slow Log"
                        },
                        "event_analyze": "Intelligent Analytics",
                        "event_analyze_error": "Intelligent analytics error",
                        "external_address": "Public Domain",
                        "external_network": "Internet Access",
                        "failed_to_turn_off_automatic_backup": "Auto Backup Disable Failed",
                        "file": {
                            "Upload Success": "File Uploaded",
                            "Uploading": "Uploading File ({{percent}}%)"
                        },
                        "file_upload_failed": "File upload failed",
                        "first_charge": "First deposit benefits",
                        "gift": "gift",
                        "go_to_recharge": "Go to recharge",
                        "guide_deploy_button": "Complete creation and get it now",
                        "guide_terminal_button": "Convenient terminal connection method improves data processing efficiency",
                        "have_error": "Failed",
                        "hits_ratio": "Hits Ratio",
                        "hour": "hour",
                        "import_through_file": "File Import",
                        "important_tips_for_migrating": "Tip: Create a new database in sink DB if source_database and sink_database have overlapping data, to avoid conflicts",
                        "innodb_buffer_pool": "InnoDB Buffer Pool",
                        "intranet_address": "Private Address",
                        "items_per_db": "Keys per DB",
                        "jump_prompt": "Jump Notification",
                        "key_evictions": "Keys Evicted",
                        "let_me_think_again": "Talk to you later",
                        "limit_cpu": "CPU Limit",
                        "limit_memory": "Memory Limit",
                        "lost_file": "File Missing",
                        "manage_all_resources": "Manage",
                        "manual_backup": "Manual Backup",
                        "manual_backup_tip": "Tip: Backup during off-peak hours. Avoid DDL operations to prevent locking. Be patient if data size is large. Backup starts 1 min after confirmation.",
                        "max_replicas": "Max Replicas: ",
                        "memory": "Memory",
                        "migrate": {
                            "Incremental migration prompt information": "Enable \\\"Continuous Migration\\\" for incremental DB sync (disabled by default).",
                            "mongo": {
                                "check": "Source Account: Read access to DB, admin, local\\nSink Account: Read/write access to DB, read access to admin, local"
                            },
                            "mongodb": {
                                "stepOne": "# Replication cluster instance: no scaling needed. Provide primary address for migration.",
                                "stepTwo": "# Standalone instance: Extend to single-node replica set for CDC"
                            },
                            "mysql": {
                                "stepOne": "# Set 'binlog_format' parameter to 'row'",
                                "stepTwo": "# Set 'binlog_row_image' parameter to 'full'"
                            },
                            "postgresql": {
                                "check": "Source Account: Login access, read access to source, replication privileges\\nSink Account: Login access, read/write access to sink",
                                "stepOne": "# Set 'wal_level' parameter to 'logical'",
                                "stepTwo": "# Ensure sufficient capacity for \\\"max_replication_slots\\\" and \\\"max_wal_senders\\\" parameters"
                            }
                        },
                        "migrate_config": "Migration Configuration",
                        "migrate_now": "Migrate Now",
                        "migration_failed": "Migration Failed",
                        "migration_permission_check": "Verifying Migration Permissions",
                        "migration_preparation": "Preparing for Migration",
                        "migration_preparations": "Migration Preparations Completed",
                        "migration_prompt_information": "To prevent migration failure caused by XXX, please refrain from any operations during the migration process. The migration may take a while for large datasets. Your patience is appreciated.",
                        "migration_successful": "Migration Completed Successfully",
                        "migration_task_created_successfully": "Migration task created",
                        "min_replicas": "Min Replicas: ",
                        "monitor_list": "Monitoring",
                        "multi_replica_redis_tip": "Note: The price for multi-replica Redis includes HA nodes",
                        "name": "Name",
                        "no_data_available": "No Data Available",
                        "no_logs_for_now": "No logs for now",
                        "not_allow_standalone_use": "This application is not allowed to be used alone. Click OK to go to Sealos Desktop for use.",
                        "online_import": "Online Import",
                        "operation": "Operation",
                        "overview": "Overview",
                        "page_faults": "Page Faults",
                        "pause_error": "Failed to pause the database",
                        "pause_hint": "Pausing the service will stop the calculation of charges for CPU and memory, but charges for storage and external network ports will still apply. Would you like to pause now?",
                        "pause_success": "Database paused",
                        "please_enter": "Please Enter",
                        "prompt": "Prompt",
                        "query_operations": "Query Operations",
                        "receive": "receive",
                        "remark": "Note",
                        "remark_tip": "Contains up to 10 Chinese characters and 30 English characters",
                        "remind": "remind",
                        "replicas_cannot_empty": "Replicas field is required",
                        "replicas_list": "Pod List",
                        "restart_error": "Failed to restart due to an error",
                        "restart_success": "Restarted successfully. Please wait...",
                        "restarts": "Restart Count",
                        "restore_backup": "Restore from Backup",
                        "restore_backup_tip": "Restoring a backup will create a new database. Please provide a unique name for the new DB.",
                        "restore_database": "Restore Database from Backup",
                        "restore_success": "Backup restored successfully",
                        "rollbacks_per_second": "Rollbacks/s",
                        "running_time": "Uptime",
                        "sealaf": "sealaf",
                        "select_a_maximum_of_10_files": "Select up to 10 files",
                        "service_deletion_failed": "Failed to delete the service",
                        "set_auto_backup_successful": "Automatic backup task set successfully",
                        "single_node_tip": "Single-node DB for development and testing only",
                        "skip": "jump over",
                        "slow_queries": "Slow Queries",
                        "source_database": "Source Database",
                        "start_backup": "Start Backup",
                        "start_error": "Failed to start the database due to an error",
                        "start_hour": "Hour",
                        "start_minute": "Minute",
                        "start_success": "Database started. Please wait...",
                        "start_time": "Start Time",
                        "status": "Status",
                        "storage": "Storage",
                        "storage_cannot_empty": "Please specify storage size",
                        "storage_max": "maximum storage",
                        "storage_min": "Minimum storage",
                        "storage_range": "Storage capacity:",
                        "streaming_logs": "Streaming logs",
                        "submit_error": "Error submitting form",
                        "successfully_closed_external_network_access": "Internet access disabled",
                        "table_locks": "Table-level locks",
                        "terminated_logs": "Terminated logs",
                        "termination_policy": "Delete Policy",
                        "termination_policy_tip": "Whether to keep a backup when deleting the database",
                        "total_price": "total_price",
                        "total_price_tip": "The estimated cost does not include port fees and traffic fees, and is subject to actual usage.",
                        "turn_on": "Enable",
                        "update": "Update",
                        "update_database": "Update DataBase",
                        "update_failed": "Update Failed",
                        "update_sealaf_app_tip": "The database is deployed through cloud development. To change the database, please go to cloud development.",
                        "update_successful": "Update succeeded",
                        "update_time": "Update Time",
                        "upload_dump_file": "Upload Dump File",
                        "use_docs": "Documentation",
                        "version": "Version",
                        "wipeout_backup_with_db": "Discard Backups",
                        "wipeout_backup_with_db_tip": "Delete the databases and the backups",
                        "within_1_day": "Within 1 day",
                        "within_1_hour": "Within 1 hour",
                        "within_5_minutes": "Within 5 minutes",
                        "yaml_file": "YAML",
                        "you_have_successfully_deployed_database": "You have successfully deployed and created a database!",
                        "change_log": "History",
                        "VerticalScaling": "Vertical Scaling",
                        "VerticalScalingCPU": "Vertical Scaling (CPU)",
                        "VerticalScalingMemory": "Vertical Scaling (Memory)",
                        "HorizontalScaling": "Horizontal Scaling (Instance)",
                        "VolumeExpansion": "Volume Expansion (Disk)",
                        "Stop": "Stop"
                    }
                }
            },
            "initialLocale": "zh",
            "ns": [
                "common"
            ],
            "userConfig": {
                "i18n": {
                    "defaultLocale": "zh",
                    "locales": [
                        "en",
                        "zh"
                    ],
                    "localeDetection": false
                },
                "reloadOnPrerender": false,
                "default": {
                    "i18n": {
                        "defaultLocale": "zh",
                        "locales": [
                            "en",
                            "zh"
                        ],
                        "localeDetection": false
                    },
                    "reloadOnPrerender": false
                }
            }
        },
        "dbName": "test-db",
        "listType": "overview",
        "dbType": "postgresql"
    },
    "__N_SSP": true
}
```

GET https://dbprovider.hzh.sealos.run/api/getStatefulSetByName?name=test-db&dbType=postgresql
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "apiVersion": "apps/v1",
        "kind": "StatefulSet",
        "metadata": {
            "annotations": {
                "config.kubeblocks.io/tpl-agamotto-configuration": "test-db-postgresql-agamotto-configuration",
                "config.kubeblocks.io/tpl-pgbouncer-configuration": "test-db-postgresql-pgbouncer-configuration",
                "config.kubeblocks.io/tpl-postgresql-configuration": "test-db-postgresql-postgresql-configuration",
                "config.kubeblocks.io/tpl-postgresql-custom-metrics": "test-db-postgresql-postgresql-custom-metrics",
                "config.kubeblocks.io/tpl-postgresql-scripts": "test-db-postgresql-postgresql-scripts",
                "kubeblocks.io/generation": "2"
            },
            "creationTimestamp": "2025-02-24T03:15:14.000Z",
            "finalizers": [
                "cluster.kubeblocks.io/finalizer"
            ],
            "generation": 1,
            "labels": {
                "app.kubernetes.io/component": "postgresql",
                "app.kubernetes.io/instance": "test-db",
                "app.kubernetes.io/managed-by": "kubeblocks",
                "app.kubernetes.io/name": "postgresql",
                "apps.kubeblocks.io/component-name": "postgresql",
                "rsm.workloads.kubeblocks.io/controller-generation": "1"
            },
            "managedFields": [
                {
                    "apiVersion": "apps/v1",
                    "fieldsType": "FieldsV1",
                    "fieldsV1": {
                        "f:status": {
                            "f:collisionCount": {},
                            "f:currentReplicas": {},
                            "f:currentRevision": {},
                            "f:observedGeneration": {},
                            "f:replicas": {},
                            "f:updateRevision": {},
                            "f:updatedReplicas": {}
                        }
                    },
                    "manager": "kube-controller-manager",
                    "operation": "Update",
                    "subresource": "status",
                    "time": "2025-02-24T03:15:14.000Z"
                },
                {
                    "apiVersion": "apps/v1",
                    "fieldsType": "FieldsV1",
                    "fieldsV1": {
                        "f:metadata": {
                            "f:annotations": {
                                ".": {},
                                "f:config.kubeblocks.io/tpl-agamotto-configuration": {},
                                "f:config.kubeblocks.io/tpl-pgbouncer-configuration": {},
                                "f:config.kubeblocks.io/tpl-postgresql-configuration": {},
                                "f:config.kubeblocks.io/tpl-postgresql-custom-metrics": {},
                                "f:config.kubeblocks.io/tpl-postgresql-scripts": {},
                                "f:kubeblocks.io/generation": {}
                            },
                            "f:finalizers": {
                                ".": {},
                                "v:\"cluster.kubeblocks.io/finalizer\"": {}
                            },
                            "f:labels": {
                                ".": {},
                                "f:app.kubernetes.io/component": {},
                                "f:app.kubernetes.io/instance": {},
                                "f:app.kubernetes.io/managed-by": {},
                                "f:app.kubernetes.io/name": {},
                                "f:apps.kubeblocks.io/component-name": {},
                                "f:rsm.workloads.kubeblocks.io/controller-generation": {}
                            },
                            "f:ownerReferences": {
                                ".": {},
                                "k:{\"uid\":\"43f928c2-2b82-40e9-bcab-cec2ee498096\"}": {}
                            }
                        },
                        "f:spec": {
                            "f:persistentVolumeClaimRetentionPolicy": {
                                ".": {},
                                "f:whenDeleted": {},
                                "f:whenScaled": {}
                            },
                            "f:podManagementPolicy": {},
                            "f:replicas": {},
                            "f:revisionHistoryLimit": {},
                            "f:selector": {},
                            "f:serviceName": {},
                            "f:template": {
                                "f:metadata": {
                                    "f:labels": {
                                        ".": {},
                                        "f:app.kubernetes.io/component": {},
                                        "f:app.kubernetes.io/instance": {},
                                        "f:app.kubernetes.io/managed-by": {},
                                        "f:app.kubernetes.io/name": {},
                                        "f:app.kubernetes.io/version": {},
                                        "f:apps.kubeblocks.io/component-name": {}
                                    }
                                },
                                "f:spec": {
                                    "f:affinity": {
                                        ".": {},
                                        "f:nodeAffinity": {
                                            ".": {},
                                            "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                        },
                                        "f:podAntiAffinity": {
                                            ".": {},
                                            "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                        }
                                    },
                                    "f:containers": {
                                        "k:{\"name\":\"config-manager\"}": {
                                            ".": {},
                                            "f:args": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"CONFIG_MANAGER_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"DB_TYPE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"TOOLS_PATH\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:name": {},
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/opt/config-manager\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/opt/kb-tools/reload/postgresql-configuration\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        },
                                        "k:{\"name\":\"lorry\"}": {
                                            ".": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"KB_BUILTIN_HANDLER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_CLUSTER_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_COMP_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_DATA_PATH\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_RSM_ACTION_SVC_LIST\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_RSM_ROLE_PROBE_TIMEOUT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_RSM_ROLE_UPDATE_MECHANISM\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SERVICE_CHARACTER_TYPE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_SERVICE_PASSWORD\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SERVICE_PORT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_SERVICE_USER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:name": {},
                                            "f:ports": {
                                                ".": {},
                                                "k:{\"containerPort\":3501,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                },
                                                "k:{\"containerPort\":50001,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                }
                                            },
                                            "f:readinessProbe": {
                                                ".": {},
                                                "f:failureThreshold": {},
                                                "f:httpGet": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:port": {},
                                                    "f:scheme": {}
                                                },
                                                "f:periodSeconds": {},
                                                "f:successThreshold": {},
                                                "f:timeoutSeconds": {}
                                            },
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:startupProbe": {
                                                ".": {},
                                                "f:failureThreshold": {},
                                                "f:periodSeconds": {},
                                                "f:successThreshold": {},
                                                "f:tcpSocket": {
                                                    ".": {},
                                                    "f:port": {}
                                                },
                                                "f:timeoutSeconds": {}
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        },
                                        "k:{\"name\":\"metrics\"}": {
                                            ".": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"DATA_SOURCE_PASS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"DATA_SOURCE_USER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"ENDPOINT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:name": {},
                                            "f:ports": {
                                                ".": {},
                                                "k:{\"containerPort\":9187,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                }
                                            },
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:securityContext": {
                                                ".": {},
                                                "f:runAsUser": {}
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/opt/agamotto\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/opt/conf\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        },
                                        "k:{\"name\":\"pgbouncer\"}": {
                                            ".": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGBOUNCER_AUTH_TYPE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGBOUNCER_BIND_ADDRESS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGBOUNCER_PORT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"POSTGRESQL_HOST\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"POSTGRESQL_PASSWORD\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"POSTGRESQL_PORT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"POSTGRESQL_USERNAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:livenessProbe": {
                                                ".": {},
                                                "f:failureThreshold": {},
                                                "f:initialDelaySeconds": {},
                                                "f:periodSeconds": {},
                                                "f:successThreshold": {},
                                                "f:tcpSocket": {
                                                    ".": {},
                                                    "f:port": {}
                                                },
                                                "f:timeoutSeconds": {}
                                            },
                                            "f:name": {},
                                            "f:ports": {
                                                ".": {},
                                                "k:{\"containerPort\":6432,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                }
                                            },
                                            "f:readinessProbe": {
                                                ".": {},
                                                "f:failureThreshold": {},
                                                "f:initialDelaySeconds": {},
                                                "f:periodSeconds": {},
                                                "f:successThreshold": {},
                                                "f:tcpSocket": {
                                                    ".": {},
                                                    "f:port": {}
                                                },
                                                "f:timeoutSeconds": {}
                                            },
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:securityContext": {
                                                ".": {},
                                                "f:runAsUser": {}
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/home/pgbouncer/conf\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        },
                                        "k:{\"name\":\"postgresql\"}": {
                                            ".": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"ALLOW_NOSSL\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"DCS_ENABLE_KUBERNETES_API\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PG_CONFIG_PATH\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KUBERNETES_LABELS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KUBERNETES_ROLE_LABEL\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KUBERNETES_SCOPE_LABEL\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KUBERNETES_USE_CONFIGMAPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGPASSWORD\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGPASSWORD_ADMIN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGPASSWORD_STANDBY\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGPASSWORD_SUPERUSER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGROOT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGUSER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"PGUSER_ADMIN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGUSER_STANDBY\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"PGUSER_SUPERUSER\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:secretKeyRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"POD_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"RESTORE_DATA_DIR\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"SCOPE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"SERVICE_PORT\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"SPILO_CONFIGURATION\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:name": {},
                                            "f:ports": {
                                                ".": {},
                                                "k:{\"containerPort\":5432,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                },
                                                "k:{\"containerPort\":8008,\"protocol\":\"TCP\"}": {
                                                    ".": {},
                                                    "f:containerPort": {},
                                                    "f:name": {},
                                                    "f:protocol": {}
                                                }
                                            },
                                            "f:readinessProbe": {
                                                ".": {},
                                                "f:exec": {
                                                    ".": {},
                                                    "f:command": {}
                                                },
                                                "f:failureThreshold": {},
                                                "f:initialDelaySeconds": {},
                                                "f:periodSeconds": {},
                                                "f:successThreshold": {},
                                                "f:timeoutSeconds": {}
                                            },
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                },
                                                "f:requests": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:securityContext": {
                                                ".": {},
                                                "f:runAsUser": {}
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/dev/shm\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        }
                                    },
                                    "f:dnsPolicy": {},
                                    "f:initContainers": {
                                        ".": {},
                                        "k:{\"name\":\"pg-init-container\"}": {
                                            ".": {},
                                            "f:command": {},
                                            "f:env": {
                                                ".": {},
                                                "k:{\"name\":\"KB_HOSTIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_HOST_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_NODENAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_PODIPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:value": {}
                                                },
                                                "k:{\"name\":\"KB_POD_IP\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_IPS\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_POD_UID\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                },
                                                "k:{\"name\":\"KB_SA_NAME\"}": {
                                                    ".": {},
                                                    "f:name": {},
                                                    "f:valueFrom": {
                                                        ".": {},
                                                        "f:fieldRef": {}
                                                    }
                                                }
                                            },
                                            "f:envFrom": {},
                                            "f:image": {},
                                            "f:imagePullPolicy": {},
                                            "f:name": {},
                                            "f:resources": {
                                                ".": {},
                                                "f:limits": {
                                                    ".": {},
                                                    "f:cpu": {},
                                                    "f:memory": {}
                                                }
                                            },
                                            "f:terminationMessagePath": {},
                                            "f:terminationMessagePolicy": {},
                                            "f:volumeMounts": {
                                                ".": {},
                                                "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                },
                                                "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                    ".": {},
                                                    "f:mountPath": {},
                                                    "f:name": {}
                                                }
                                            }
                                        }
                                    },
                                    "f:restartPolicy": {},
                                    "f:schedulerName": {},
                                    "f:securityContext": {
                                        ".": {},
                                        "f:fsGroup": {},
                                        "f:fsGroupChangePolicy": {},
                                        "f:runAsGroup": {},
                                        "f:runAsUser": {}
                                    },
                                    "f:serviceAccount": {},
                                    "f:serviceAccountName": {},
                                    "f:terminationGracePeriodSeconds": {},
                                    "f:tolerations": {},
                                    "f:topologySpreadConstraints": {
                                        ".": {},
                                        "k:{\"topologyKey\":\"kubernetes.io/hostname\",\"whenUnsatisfiable\":\"ScheduleAnyway\"}": {
                                            ".": {},
                                            "f:labelSelector": {},
                                            "f:maxSkew": {},
                                            "f:topologyKey": {},
                                            "f:whenUnsatisfiable": {}
                                        }
                                    },
                                    "f:volumes": {
                                        ".": {},
                                        "k:{\"name\":\"agamotto-configuration\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"cm-script-postgresql-configuration\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"config-manager-config\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"data\"}": {
                                            ".": {},
                                            "f:emptyDir": {},
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"dshm\"}": {
                                            ".": {},
                                            "f:emptyDir": {
                                                ".": {},
                                                "f:medium": {},
                                                "f:sizeLimit": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"pgbouncer-config\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"pod-info\"}": {
                                            ".": {},
                                            "f:downwardAPI": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:items": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"postgresql-config\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"postgresql-custom-metrics\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        },
                                        "k:{\"name\":\"scripts\"}": {
                                            ".": {},
                                            "f:configMap": {
                                                ".": {},
                                                "f:defaultMode": {},
                                                "f:name": {}
                                            },
                                            "f:name": {}
                                        }
                                    }
                                }
                            },
                            "f:updateStrategy": {
                                "f:type": {}
                            },
                            "f:volumeClaimTemplates": {}
                        }
                    },
                    "manager": "manager",
                    "operation": "Update",
                    "time": "2025-02-24T03:15:14.000Z"
                }
            ],
            "name": "test-db-postgresql",
            "namespace": "ns-p4v4vcc1",
            "ownerReferences": [
                {
                    "apiVersion": "workloads.kubeblocks.io/v1alpha1",
                    "blockOwnerDeletion": true,
                    "controller": true,
                    "kind": "ReplicatedStateMachine",
                    "name": "test-db-postgresql",
                    "uid": "43f928c2-2b82-40e9-bcab-cec2ee498096"
                }
            ],
            "resourceVersion": "2271009885",
            "uid": "6c0d72c7-db79-403d-8c92-8e61d7c6decc"
        },
        "spec": {
            "persistentVolumeClaimRetentionPolicy": {
                "whenDeleted": "Retain",
                "whenScaled": "Retain"
            },
            "podManagementPolicy": "Parallel",
            "replicas": 2,
            "revisionHistoryLimit": 10,
            "selector": {
                "matchLabels": {
                    "app.kubernetes.io/instance": "test-db",
                    "app.kubernetes.io/managed-by": "kubeblocks",
                    "app.kubernetes.io/name": "postgresql",
                    "apps.kubeblocks.io/component-name": "postgresql"
                }
            },
            "serviceName": "test-db-postgresql-headless",
            "template": {
                "metadata": {
                    "creationTimestamp": null,
                    "labels": {
                        "app.kubernetes.io/component": "postgresql",
                        "app.kubernetes.io/instance": "test-db",
                        "app.kubernetes.io/managed-by": "kubeblocks",
                        "app.kubernetes.io/name": "postgresql",
                        "app.kubernetes.io/version": "",
                        "apps.kubeblocks.io/component-name": "postgresql"
                    }
                },
                "spec": {
                    "affinity": {
                        "nodeAffinity": {
                            "preferredDuringSchedulingIgnoredDuringExecution": [
                                {
                                    "preference": {
                                        "matchExpressions": [
                                            {
                                                "key": "kb-data",
                                                "operator": "In",
                                                "values": [
                                                    "true"
                                                ]
                                            }
                                        ]
                                    },
                                    "weight": 100
                                }
                            ]
                        },
                        "podAntiAffinity": {
                            "preferredDuringSchedulingIgnoredDuringExecution": [
                                {
                                    "podAffinityTerm": {
                                        "labelSelector": {
                                            "matchLabels": {
                                                "app.kubernetes.io/instance": "test-db",
                                                "apps.kubeblocks.io/component-name": "postgresql"
                                            }
                                        },
                                        "topologyKey": "kubernetes.io/hostname"
                                    },
                                    "weight": 100
                                }
                            ]
                        }
                    },
                    "containers": [
                        {
                            "command": [
                                "/kb-scripts/setup.sh"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                },
                                {
                                    "name": "SERVICE_PORT",
                                    "value": "5432"
                                },
                                {
                                    "name": "DCS_ENABLE_KUBERNETES_API",
                                    "value": "true"
                                },
                                {
                                    "name": "KUBERNETES_USE_CONFIGMAPS",
                                    "value": "true"
                                },
                                {
                                    "name": "SCOPE",
                                    "value": "$(KB_CLUSTER_NAME)-$(KB_COMP_NAME)-patroni$(KB_CLUSTER_UID_POSTFIX_8)"
                                },
                                {
                                    "name": "KUBERNETES_SCOPE_LABEL",
                                    "value": "apps.kubeblocks.postgres.patroni/scope"
                                },
                                {
                                    "name": "KUBERNETES_ROLE_LABEL",
                                    "value": "apps.kubeblocks.postgres.patroni/role"
                                },
                                {
                                    "name": "KUBERNETES_LABELS",
                                    "value": "{\"app.kubernetes.io/instance\":\"$(KB_CLUSTER_NAME)\",\"apps.kubeblocks.io/component-name\":\"$(KB_COMP_NAME)\"}"
                                },
                                {
                                    "name": "RESTORE_DATA_DIR",
                                    "value": "/home/postgres/pgdata/kb_restore"
                                },
                                {
                                    "name": "KB_PG_CONFIG_PATH",
                                    "value": "/home/postgres/conf/postgresql.conf"
                                },
                                {
                                    "name": "SPILO_CONFIGURATION",
                                    "value": "bootstrap:\n  initdb:\n    - auth-host: md5\n    - auth-local: trust\n"
                                },
                                {
                                    "name": "ALLOW_NOSSL",
                                    "value": "true"
                                },
                                {
                                    "name": "PGROOT",
                                    "value": "/home/postgres/pgdata/pgroot"
                                },
                                {
                                    "name": "POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "POD_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "PGUSER_SUPERUSER",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "username",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "PGPASSWORD_SUPERUSER",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "PGUSER_ADMIN",
                                    "value": "superadmin"
                                },
                                {
                                    "name": "PGPASSWORD_ADMIN",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "PGUSER_STANDBY",
                                    "value": "standby"
                                },
                                {
                                    "name": "PGPASSWORD_STANDBY",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "PGUSER",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "username",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "PGPASSWORD",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                },
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-rsm-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                            "imagePullPolicy": "IfNotPresent",
                            "name": "postgresql",
                            "ports": [
                                {
                                    "containerPort": 5432,
                                    "name": "tcp-postgresql",
                                    "protocol": "TCP"
                                },
                                {
                                    "containerPort": 8008,
                                    "name": "patroni",
                                    "protocol": "TCP"
                                }
                            ],
                            "readinessProbe": {
                                "exec": {
                                    "command": [
                                        "/bin/sh",
                                        "-c",
                                        "-ee",
                                        "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /postgresql/tmp/.initialized ] || [ -f /postgresql/.initialized ]\n"
                                    ]
                                },
                                "failureThreshold": 3,
                                "initialDelaySeconds": 10,
                                "periodSeconds": 30,
                                "successThreshold": 1,
                                "timeoutSeconds": 5
                            },
                            "resources": {
                                "limits": {
                                    "cpu": "1",
                                    "memory": "1Gi"
                                },
                                "requests": {
                                    "cpu": "100m",
                                    "memory": "102Mi"
                                }
                            },
                            "securityContext": {
                                "runAsUser": 0
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/dev/shm",
                                    "name": "dshm"
                                },
                                {
                                    "mountPath": "/home/postgres/pgdata",
                                    "name": "data"
                                },
                                {
                                    "mountPath": "/home/postgres/conf",
                                    "name": "postgresql-config"
                                },
                                {
                                    "mountPath": "/kb-scripts",
                                    "name": "scripts"
                                },
                                {
                                    "mountPath": "/kb-podinfo",
                                    "name": "pod-info"
                                }
                            ]
                        },
                        {
                            "command": [
                                "/kb-scripts/pgbouncer_setup.sh"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                },
                                {
                                    "name": "PGBOUNCER_AUTH_TYPE",
                                    "value": "md5"
                                },
                                {
                                    "name": "POSTGRESQL_USERNAME",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "username",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "POSTGRESQL_PASSWORD",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "POSTGRESQL_PORT",
                                    "value": "5432"
                                },
                                {
                                    "name": "POSTGRESQL_HOST",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "PGBOUNCER_PORT",
                                    "value": "6432"
                                },
                                {
                                    "name": "PGBOUNCER_BIND_ADDRESS",
                                    "value": "0.0.0.0"
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                },
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-rsm-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/pgbouncer:1.19.0",
                            "imagePullPolicy": "IfNotPresent",
                            "livenessProbe": {
                                "failureThreshold": 3,
                                "initialDelaySeconds": 15,
                                "periodSeconds": 30,
                                "successThreshold": 1,
                                "tcpSocket": {
                                    "port": "tcp-pgbouncer"
                                },
                                "timeoutSeconds": 5
                            },
                            "name": "pgbouncer",
                            "ports": [
                                {
                                    "containerPort": 6432,
                                    "name": "tcp-pgbouncer",
                                    "protocol": "TCP"
                                }
                            ],
                            "readinessProbe": {
                                "failureThreshold": 3,
                                "initialDelaySeconds": 15,
                                "periodSeconds": 30,
                                "successThreshold": 1,
                                "tcpSocket": {
                                    "port": "tcp-pgbouncer"
                                },
                                "timeoutSeconds": 5
                            },
                            "resources": {
                                "limits": {
                                    "cpu": "0",
                                    "memory": "0"
                                }
                            },
                            "securityContext": {
                                "runAsUser": 0
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/home/pgbouncer/conf",
                                    "name": "pgbouncer-config"
                                },
                                {
                                    "mountPath": "/kb-scripts",
                                    "name": "scripts"
                                }
                            ]
                        },
                        {
                            "command": [
                                "/bin/agamotto",
                                "--config=/opt/agamotto/agamotto-config.yaml"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                },
                                {
                                    "name": "ENDPOINT",
                                    "value": "127.0.0.1:5432"
                                },
                                {
                                    "name": "DATA_SOURCE_PASS",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                },
                                {
                                    "name": "DATA_SOURCE_USER",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "username",
                                            "name": "test-db-conn-credential",
                                            "optional": false
                                        }
                                    }
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                },
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-rsm-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/agamotto:0.1.2-beta.1",
                            "imagePullPolicy": "IfNotPresent",
                            "name": "metrics",
                            "ports": [
                                {
                                    "containerPort": 9187,
                                    "name": "http-metrics",
                                    "protocol": "TCP"
                                }
                            ],
                            "resources": {
                                "limits": {
                                    "cpu": "0",
                                    "memory": "0"
                                }
                            },
                            "securityContext": {
                                "runAsUser": 0
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/opt/conf",
                                    "name": "postgresql-custom-metrics"
                                },
                                {
                                    "mountPath": "/opt/agamotto",
                                    "name": "agamotto-configuration"
                                }
                            ]
                        },
                        {
                            "command": [
                                "lorry",
                                "--port",
                                "3501",
                                "--grpcport",
                                "50001"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                },
                                {
                                    "name": "KB_BUILTIN_HANDLER",
                                    "value": "postgresql"
                                },
                                {
                                    "name": "KB_SERVICE_USER",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "username",
                                            "name": "test-db-conn-credential"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SERVICE_PASSWORD",
                                    "valueFrom": {
                                        "secretKeyRef": {
                                            "key": "password",
                                            "name": "test-db-conn-credential"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SERVICE_PORT",
                                    "value": "5432"
                                },
                                {
                                    "name": "KB_DATA_PATH",
                                    "value": "/home/postgres/pgdata"
                                },
                                {
                                    "name": "KB_RSM_ACTION_SVC_LIST",
                                    "value": "null"
                                },
                                {
                                    "name": "KB_RSM_ROLE_UPDATE_MECHANISM",
                                    "value": "DirectAPIServerEventUpdate"
                                },
                                {
                                    "name": "KB_RSM_ROLE_PROBE_TIMEOUT",
                                    "value": "1"
                                },
                                {
                                    "name": "KB_CLUSTER_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.labels['app.kubernetes.io/instance']"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_COMP_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.labels['apps.kubeblocks.io/component-name']"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SERVICE_CHARACTER_TYPE",
                                    "value": "postgresql"
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                },
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-rsm-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                            "imagePullPolicy": "IfNotPresent",
                            "name": "lorry",
                            "ports": [
                                {
                                    "containerPort": 3501,
                                    "name": "lorry-http-port",
                                    "protocol": "TCP"
                                },
                                {
                                    "containerPort": 50001,
                                    "name": "lorry-grpc-port",
                                    "protocol": "TCP"
                                }
                            ],
                            "readinessProbe": {
                                "failureThreshold": 3,
                                "httpGet": {
                                    "path": "/v1.0/checkrole",
                                    "port": 3501,
                                    "scheme": "HTTP"
                                },
                                "periodSeconds": 1,
                                "successThreshold": 1,
                                "timeoutSeconds": 1
                            },
                            "resources": {
                                "limits": {
                                    "cpu": "0",
                                    "memory": "0"
                                }
                            },
                            "startupProbe": {
                                "failureThreshold": 3,
                                "periodSeconds": 10,
                                "successThreshold": 1,
                                "tcpSocket": {
                                    "port": 3501
                                },
                                "timeoutSeconds": 1
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/home/postgres/pgdata",
                                    "name": "data"
                                }
                            ]
                        },
                        {
                            "args": [
                                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(TOOLS_PATH)",
                                "/bin/reloader",
                                "--log-level",
                                "info",
                                "--operator-update-enable",
                                "--tcp",
                                "9901",
                                "--config",
                                "/opt/config-manager/config-manager.yaml"
                            ],
                            "command": [
                                "env"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                },
                                {
                                    "name": "CONFIG_MANAGER_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "DB_TYPE",
                                    "value": "postgresql"
                                },
                                {
                                    "name": "TOOLS_PATH",
                                    "value": "/opt/kb-tools/reload/postgresql-configuration:/opt/config-manager"
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                },
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-rsm-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                            "imagePullPolicy": "IfNotPresent",
                            "name": "config-manager",
                            "resources": {
                                "limits": {
                                    "cpu": "0",
                                    "memory": "0"
                                }
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/home/postgres/conf",
                                    "name": "postgresql-config"
                                },
                                {
                                    "mountPath": "/opt/kb-tools/reload/postgresql-configuration",
                                    "name": "cm-script-postgresql-configuration"
                                },
                                {
                                    "mountPath": "/opt/config-manager",
                                    "name": "config-manager-config"
                                }
                            ]
                        }
                    ],
                    "dnsPolicy": "ClusterFirst",
                    "initContainers": [
                        {
                            "command": [
                                "/kb-scripts/init_container.sh"
                            ],
                            "env": [
                                {
                                    "name": "KB_POD_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.name"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_UID",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.uid"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NAMESPACE",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_SA_NAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.serviceAccountName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_NODENAME",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "spec.nodeName"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOST_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_IPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_HOSTIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.hostIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIP",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIP"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_PODIPS",
                                    "valueFrom": {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "status.podIPs"
                                        }
                                    }
                                },
                                {
                                    "name": "KB_POD_FQDN",
                                    "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                                }
                            ],
                            "envFrom": [
                                {
                                    "configMapRef": {
                                        "name": "test-db-postgresql-env",
                                        "optional": false
                                    }
                                }
                            ],
                            "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                            "imagePullPolicy": "IfNotPresent",
                            "name": "pg-init-container",
                            "resources": {
                                "limits": {
                                    "cpu": "0",
                                    "memory": "0"
                                }
                            },
                            "terminationMessagePath": "/dev/termination-log",
                            "terminationMessagePolicy": "File",
                            "volumeMounts": [
                                {
                                    "mountPath": "/home/postgres/pgdata",
                                    "name": "data"
                                },
                                {
                                    "mountPath": "/home/postgres/conf",
                                    "name": "postgresql-config"
                                },
                                {
                                    "mountPath": "/kb-scripts",
                                    "name": "scripts"
                                },
                                {
                                    "mountPath": "/kb-podinfo",
                                    "name": "pod-info"
                                }
                            ]
                        }
                    ],
                    "restartPolicy": "Always",
                    "schedulerName": "default-scheduler",
                    "securityContext": {
                        "fsGroup": 103,
                        "fsGroupChangePolicy": "OnRootMismatch",
                        "runAsGroup": 103,
                        "runAsUser": 0
                    },
                    "serviceAccount": "test-db",
                    "serviceAccountName": "test-db",
                    "terminationGracePeriodSeconds": 30,
                    "tolerations": [
                        {
                            "effect": "NoSchedule",
                            "key": "kb-data",
                            "operator": "Equal",
                            "value": "true"
                        }
                    ],
                    "topologySpreadConstraints": [
                        {
                            "labelSelector": {
                                "matchLabels": {
                                    "app.kubernetes.io/instance": "test-db",
                                    "apps.kubeblocks.io/component-name": "postgresql"
                                }
                            },
                            "maxSkew": 1,
                            "topologyKey": "kubernetes.io/hostname",
                            "whenUnsatisfiable": "ScheduleAnyway"
                        }
                    ],
                    "volumes": [
                        {
                            "emptyDir": {
                                "medium": "Memory",
                                "sizeLimit": "1Gi"
                            },
                            "name": "dshm"
                        },
                        {
                            "downwardAPI": {
                                "defaultMode": 420,
                                "items": [
                                    {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.labels['kubeblocks.io/role']"
                                        },
                                        "path": "pod-role"
                                    },
                                    {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.annotations['rs.apps.kubeblocks.io/primary']"
                                        },
                                        "path": "primary-pod"
                                    },
                                    {
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.annotations['apps.kubeblocks.io/component-replicas']"
                                        },
                                        "path": "component-replicas"
                                    }
                                ]
                            },
                            "name": "pod-info"
                        },
                        {
                            "configMap": {
                                "defaultMode": 292,
                                "name": "test-db-postgresql-agamotto-configuration"
                            },
                            "name": "agamotto-configuration"
                        },
                        {
                            "configMap": {
                                "defaultMode": 292,
                                "name": "test-db-postgresql-pgbouncer-configuration"
                            },
                            "name": "pgbouncer-config"
                        },
                        {
                            "configMap": {
                                "defaultMode": 292,
                                "name": "test-db-postgresql-postgresql-configuration"
                            },
                            "name": "postgresql-config"
                        },
                        {
                            "configMap": {
                                "defaultMode": 292,
                                "name": "test-db-postgresql-postgresql-custom-metrics"
                            },
                            "name": "postgresql-custom-metrics"
                        },
                        {
                            "configMap": {
                                "defaultMode": 365,
                                "name": "test-db-postgresql-postgresql-scripts"
                            },
                            "name": "scripts"
                        },
                        {
                            "configMap": {
                                "defaultMode": 493,
                                "name": "sidecar-patroni-reload-script-test-db"
                            },
                            "name": "cm-script-postgresql-configuration"
                        },
                        {
                            "configMap": {
                                "defaultMode": 493,
                                "name": "sidecar-test-db-postgresql-config-manager-config"
                            },
                            "name": "config-manager-config"
                        },
                        {
                            "emptyDir": {},
                            "name": "data"
                        }
                    ]
                }
            },
            "updateStrategy": {
                "type": "OnDelete"
            },
            "volumeClaimTemplates": [
                {
                    "apiVersion": "v1",
                    "kind": "PersistentVolumeClaim",
                    "metadata": {
                        "creationTimestamp": null,
                        "labels": {
                            "apps.kubeblocks.io/vct-name": "data",
                            "kubeblocks.io/volume-type": "data"
                        },
                        "name": "data"
                    },
                    "spec": {
                        "accessModes": [
                            "ReadWriteOnce"
                        ],
                        "resources": {
                            "requests": {
                                "storage": "3Gi"
                            }
                        },
                        "volumeMode": "Filesystem"
                    },
                    "status": {
                        "phase": "Pending"
                    }
                }
            ]
        },
        "status": {
            "availableReplicas": 0,
            "collisionCount": 0,
            "currentReplicas": 2,
            "currentRevision": "test-db-postgresql-789ff46c",
            "observedGeneration": 1,
            "replicas": 2,
            "updateRevision": "test-db-postgresql-789ff46c",
            "updatedReplicas": 2
        }
    }
}
```

GET https://dbprovider.hzh.sealos.run/api/getSecretByName?dbName=test-db&dbType=postgresql
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "username": "postgres",
        "password": "5kxc24fg",
        "host": "test-db-postgresql.ns-p4v4vcc1.svc",
        "port": "5432",
        "connection": "postgresql://postgres:5kxc24fg@test-db-postgresql.ns-p4v4vcc1.svc:5432"
    }
}
```


GET https://dbprovider.hzh.sealos.run/api/getServiceByName?name=test-db-export
```JSON
{"code":200,"statusText":"","message":"","data":null}
```

GET https://dbprovider.hzh.sealos.run/api/pod/getPodsByDBName?name=test-db
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": [
        {
            "metadata": {
                "annotations": {
                    "apps.kubeblocks.io/component-replicas": "2",
                    "kubernetes.io/limit-ranger": "LimitRanger plugin set: ephemeral-storage request for container postgresql; ephemeral-storage limit for container postgresql; ephemeral-storage request for container pgbouncer; ephemeral-storage limit for container pgbouncer; ephemeral-storage request for container metrics; ephemeral-storage limit for container metrics; ephemeral-storage request for container lorry; ephemeral-storage limit for container lorry; ephemeral-storage request for container config-manager; ephemeral-storage limit for container config-manager; ephemeral-storage request for init container pg-init-container; ephemeral-storage limit for init container pg-init-container"
                },
                "creationTimestamp": "2025-02-24T03:15:14.000Z",
                "generateName": "test-db-postgresql-",
                "labels": {
                    "app.kubernetes.io/component": "postgresql",
                    "app.kubernetes.io/instance": "test-db",
                    "app.kubernetes.io/managed-by": "kubeblocks",
                    "app.kubernetes.io/name": "postgresql",
                    "app.kubernetes.io/version": "",
                    "apps.kubeblocks.io/cluster-uid": "0242385d-746d-4e40-a2ca-5ae319c9bc7d",
                    "apps.kubeblocks.io/component-name": "postgresql",
                    "apps.kubeblocks.postgres.patroni/scope": "test-db-postgresql-patroni19c9bc7d",
                    "apps.kubernetes.io/pod-index": "0",
                    "clusterdefinition.kubeblocks.io/name": "postgresql",
                    "clusterversion.kubeblocks.io/name": "postgresql-14.8.0",
                    "controller-revision-hash": "test-db-postgresql-789ff46c",
                    "sealos-db-provider-cr": "test-db",
                    "statefulset.kubernetes.io/pod-name": "test-db-postgresql-0"
                },
                "managedFields": [
                    {
                        "apiVersion": "v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:generateName": {},
                                "f:labels": {
                                    ".": {},
                                    "f:app.kubernetes.io/component": {},
                                    "f:app.kubernetes.io/instance": {},
                                    "f:app.kubernetes.io/managed-by": {},
                                    "f:app.kubernetes.io/name": {},
                                    "f:app.kubernetes.io/version": {},
                                    "f:apps.kubeblocks.io/component-name": {},
                                    "f:apps.kubernetes.io/pod-index": {},
                                    "f:controller-revision-hash": {},
                                    "f:statefulset.kubernetes.io/pod-name": {}
                                },
                                "f:ownerReferences": {
                                    ".": {},
                                    "k:{\"uid\":\"6c0d72c7-db79-403d-8c92-8e61d7c6decc\"}": {}
                                }
                            },
                            "f:spec": {
                                "f:affinity": {
                                    ".": {},
                                    "f:nodeAffinity": {
                                        ".": {},
                                        "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                    },
                                    "f:podAntiAffinity": {
                                        ".": {},
                                        "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                    }
                                },
                                "f:containers": {
                                    "k:{\"name\":\"config-manager\"}": {
                                        ".": {},
                                        "f:args": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"CONFIG_MANAGER_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"DB_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"TOOLS_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/config-manager\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/kb-tools/reload/postgresql-configuration\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"lorry\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_BUILTIN_HANDLER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_CLUSTER_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_COMP_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_DATA_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_RSM_ACTION_SVC_LIST\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_RSM_ROLE_PROBE_TIMEOUT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_RSM_ROLE_UPDATE_MECHANISM\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SERVICE_CHARACTER_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SERVICE_PASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SERVICE_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SERVICE_USER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":3501,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            },
                                            "k:{\"containerPort\":50001,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:httpGet": {
                                                ".": {},
                                                "f:path": {},
                                                "f:port": {},
                                                "f:scheme": {}
                                            },
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:startupProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"metrics\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"DATA_SOURCE_PASS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"DATA_SOURCE_USER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"ENDPOINT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":9187,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/opt/agamotto\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"pgbouncer\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGBOUNCER_AUTH_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGBOUNCER_BIND_ADDRESS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGBOUNCER_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"POSTGRESQL_HOST\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POSTGRESQL_PASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POSTGRESQL_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"POSTGRESQL_USERNAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:livenessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":6432,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/pgbouncer/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"postgresql\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"ALLOW_NOSSL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"DCS_ENABLE_KUBERNETES_API\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PG_CONFIG_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KUBERNETES_LABELS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_ROLE_LABEL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_SCOPE_LABEL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_USE_CONFIGMAPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGPASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_ADMIN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_STANDBY\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_SUPERUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGROOT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGUSER_ADMIN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER_STANDBY\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER_SUPERUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POD_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"RESTORE_DATA_DIR\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SCOPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SERVICE_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SPILO_CONFIGURATION\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":5432,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            },
                                            "k:{\"containerPort\":8008,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:exec": {
                                                ".": {},
                                                "f:command": {}
                                            },
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/dev/shm\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    }
                                },
                                "f:dnsPolicy": {},
                                "f:enableServiceLinks": {},
                                "f:hostname": {},
                                "f:initContainers": {
                                    ".": {},
                                    "k:{\"name\":\"pg-init-container\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    }
                                },
                                "f:restartPolicy": {},
                                "f:schedulerName": {},
                                "f:securityContext": {
                                    ".": {},
                                    "f:fsGroup": {},
                                    "f:fsGroupChangePolicy": {},
                                    "f:runAsGroup": {},
                                    "f:runAsUser": {}
                                },
                                "f:serviceAccount": {},
                                "f:serviceAccountName": {},
                                "f:subdomain": {},
                                "f:terminationGracePeriodSeconds": {},
                                "f:tolerations": {},
                                "f:topologySpreadConstraints": {
                                    ".": {},
                                    "k:{\"topologyKey\":\"kubernetes.io/hostname\",\"whenUnsatisfiable\":\"ScheduleAnyway\"}": {
                                        ".": {},
                                        "f:labelSelector": {},
                                        "f:maxSkew": {},
                                        "f:topologyKey": {},
                                        "f:whenUnsatisfiable": {}
                                    }
                                },
                                "f:volumes": {
                                    ".": {},
                                    "k:{\"name\":\"agamotto-configuration\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"cm-script-postgresql-configuration\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"config-manager-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"data\"}": {
                                        ".": {},
                                        "f:name": {},
                                        "f:persistentVolumeClaim": {
                                            ".": {},
                                            "f:claimName": {}
                                        }
                                    },
                                    "k:{\"name\":\"dshm\"}": {
                                        ".": {},
                                        "f:emptyDir": {
                                            ".": {},
                                            "f:medium": {},
                                            "f:sizeLimit": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"pgbouncer-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"pod-info\"}": {
                                        ".": {},
                                        "f:downwardAPI": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:items": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"postgresql-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"postgresql-custom-metrics\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"scripts\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    }
                                }
                            }
                        },
                        "manager": "kube-controller-manager",
                        "operation": "Update",
                        "time": "2025-02-24T03:15:14.000Z"
                    },
                    {
                        "apiVersion": "v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:annotations": {
                                    "f:apps.kubeblocks.io/component-replicas": {}
                                },
                                "f:labels": {
                                    "f:apps.kubeblocks.io/cluster-uid": {},
                                    "f:apps.kubeblocks.postgres.patroni/scope": {},
                                    "f:clusterdefinition.kubeblocks.io/name": {},
                                    "f:clusterversion.kubeblocks.io/name": {},
                                    "f:sealos-db-provider-cr": {}
                                }
                            }
                        },
                        "manager": "manager",
                        "operation": "Update",
                        "time": "2025-02-24T03:15:14.000Z"
                    }
                ],
                "name": "test-db-postgresql-0",
                "namespace": "ns-p4v4vcc1",
                "ownerReferences": [
                    {
                        "apiVersion": "apps/v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "StatefulSet",
                        "name": "test-db-postgresql",
                        "uid": "6c0d72c7-db79-403d-8c92-8e61d7c6decc"
                    }
                ],
                "resourceVersion": "2271009890",
                "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [
                            {
                                "preference": {
                                    "matchExpressions": [
                                        {
                                            "key": "kb-data",
                                            "operator": "In",
                                            "values": [
                                                "true"
                                            ]
                                        }
                                    ]
                                },
                                "weight": 100
                            }
                        ]
                    },
                    "podAntiAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [
                            {
                                "podAffinityTerm": {
                                    "labelSelector": {
                                        "matchLabels": {
                                            "app.kubernetes.io/instance": "test-db",
                                            "apps.kubeblocks.io/component-name": "postgresql"
                                        }
                                    },
                                    "topologyKey": "kubernetes.io/hostname"
                                },
                                "weight": 100
                            }
                        ]
                    }
                },
                "containers": [
                    {
                        "command": [
                            "/kb-scripts/setup.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "SERVICE_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "DCS_ENABLE_KUBERNETES_API",
                                "value": "true"
                            },
                            {
                                "name": "KUBERNETES_USE_CONFIGMAPS",
                                "value": "true"
                            },
                            {
                                "name": "SCOPE",
                                "value": "$(KB_CLUSTER_NAME)-$(KB_COMP_NAME)-patroni$(KB_CLUSTER_UID_POSTFIX_8)"
                            },
                            {
                                "name": "KUBERNETES_SCOPE_LABEL",
                                "value": "apps.kubeblocks.postgres.patroni/scope"
                            },
                            {
                                "name": "KUBERNETES_ROLE_LABEL",
                                "value": "apps.kubeblocks.postgres.patroni/role"
                            },
                            {
                                "name": "KUBERNETES_LABELS",
                                "value": "{\"app.kubernetes.io/instance\":\"$(KB_CLUSTER_NAME)\",\"apps.kubeblocks.io/component-name\":\"$(KB_COMP_NAME)\"}"
                            },
                            {
                                "name": "RESTORE_DATA_DIR",
                                "value": "/home/postgres/pgdata/kb_restore"
                            },
                            {
                                "name": "KB_PG_CONFIG_PATH",
                                "value": "/home/postgres/conf/postgresql.conf"
                            },
                            {
                                "name": "SPILO_CONFIGURATION",
                                "value": "bootstrap:\n  initdb:\n    - auth-host: md5\n    - auth-local: trust\n"
                            },
                            {
                                "name": "ALLOW_NOSSL",
                                "value": "true"
                            },
                            {
                                "name": "PGROOT",
                                "value": "/home/postgres/pgdata/pgroot"
                            },
                            {
                                "name": "POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "POD_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_SUPERUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGPASSWORD_SUPERUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_ADMIN",
                                "value": "superadmin"
                            },
                            {
                                "name": "PGPASSWORD_ADMIN",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_STANDBY",
                                "value": "standby"
                            },
                            {
                                "name": "PGPASSWORD_STANDBY",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGPASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "postgresql",
                        "ports": [
                            {
                                "containerPort": 5432,
                                "name": "tcp-postgresql",
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 8008,
                                "name": "patroni",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "exec": {
                                "command": [
                                    "/bin/sh",
                                    "-c",
                                    "-ee",
                                    "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /postgresql/tmp/.initialized ] || [ -f /postgresql/.initialized ]\n"
                                ]
                            },
                            "failureThreshold": 3,
                            "initialDelaySeconds": 10,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "timeoutSeconds": 5
                        },
                        "resources": {
                            "limits": {
                                "cpu": "1",
                                "ephemeral-storage": "100Mi",
                                "memory": "1Gi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "ephemeral-storage": "100Mi",
                                "memory": "102Mi"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/dev/shm",
                                "name": "dshm"
                            },
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/kb-podinfo",
                                "name": "pod-info"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "/kb-scripts/pgbouncer_setup.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "PGBOUNCER_AUTH_TYPE",
                                "value": "md5"
                            },
                            {
                                "name": "POSTGRESQL_USERNAME",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "POSTGRESQL_PASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "POSTGRESQL_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "POSTGRESQL_HOST",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "PGBOUNCER_PORT",
                                "value": "6432"
                            },
                            {
                                "name": "PGBOUNCER_BIND_ADDRESS",
                                "value": "0.0.0.0"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/pgbouncer:1.19.0",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 3,
                            "initialDelaySeconds": 15,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": "tcp-pgbouncer"
                            },
                            "timeoutSeconds": 5
                        },
                        "name": "pgbouncer",
                        "ports": [
                            {
                                "containerPort": 6432,
                                "name": "tcp-pgbouncer",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "initialDelaySeconds": 15,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": "tcp-pgbouncer"
                            },
                            "timeoutSeconds": 5
                        },
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/pgbouncer/conf",
                                "name": "pgbouncer-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "/bin/agamotto",
                            "--config=/opt/agamotto/agamotto-config.yaml"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "ENDPOINT",
                                "value": "127.0.0.1:5432"
                            },
                            {
                                "name": "DATA_SOURCE_PASS",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "DATA_SOURCE_USER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/agamotto:0.1.2-beta.1",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "metrics",
                        "ports": [
                            {
                                "containerPort": 9187,
                                "name": "http-metrics",
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/opt/conf",
                                "name": "postgresql-custom-metrics"
                            },
                            {
                                "mountPath": "/opt/agamotto",
                                "name": "agamotto-configuration"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "lorry",
                            "--port",
                            "3501",
                            "--grpcport",
                            "50001"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "KB_BUILTIN_HANDLER",
                                "value": "postgresql"
                            },
                            {
                                "name": "KB_SERVICE_USER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_PASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "KB_DATA_PATH",
                                "value": "/home/postgres/pgdata"
                            },
                            {
                                "name": "KB_RSM_ACTION_SVC_LIST",
                                "value": "null"
                            },
                            {
                                "name": "KB_RSM_ROLE_UPDATE_MECHANISM",
                                "value": "DirectAPIServerEventUpdate"
                            },
                            {
                                "name": "KB_RSM_ROLE_PROBE_TIMEOUT",
                                "value": "1"
                            },
                            {
                                "name": "KB_CLUSTER_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['app.kubernetes.io/instance']"
                                    }
                                }
                            },
                            {
                                "name": "KB_COMP_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['apps.kubeblocks.io/component-name']"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_CHARACTER_TYPE",
                                "value": "postgresql"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "lorry",
                        "ports": [
                            {
                                "containerPort": 3501,
                                "name": "lorry-http-port",
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 50001,
                                "name": "lorry-grpc-port",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "httpGet": {
                                "path": "/v1.0/checkrole",
                                "port": 3501,
                                "scheme": "HTTP"
                            },
                            "periodSeconds": 1,
                            "successThreshold": 1,
                            "timeoutSeconds": 1
                        },
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 3,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": 3501
                            },
                            "timeoutSeconds": 1
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "args": [
                            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(TOOLS_PATH)",
                            "/bin/reloader",
                            "--log-level",
                            "info",
                            "--operator-update-enable",
                            "--tcp",
                            "9901",
                            "--config",
                            "/opt/config-manager/config-manager.yaml"
                        ],
                        "command": [
                            "env"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "CONFIG_MANAGER_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "DB_TYPE",
                                "value": "postgresql"
                            },
                            {
                                "name": "TOOLS_PATH",
                                "value": "/opt/kb-tools/reload/postgresql-configuration:/opt/config-manager"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "config-manager",
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/opt/kb-tools/reload/postgresql-configuration",
                                "name": "cm-script-postgresql-configuration"
                            },
                            {
                                "mountPath": "/opt/config-manager",
                                "name": "config-manager-config"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostname": "test-db-postgresql-0",
                "initContainers": [
                    {
                        "command": [
                            "/kb-scripts/init_container.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "pg-init-container",
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/kb-podinfo",
                                "name": "pod-info"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-97bhs",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 0,
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "fsGroup": 103,
                    "fsGroupChangePolicy": "OnRootMismatch",
                    "runAsGroup": 103,
                    "runAsUser": 0
                },
                "serviceAccount": "test-db",
                "serviceAccountName": "test-db",
                "subdomain": "test-db-postgresql-headless",
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoSchedule",
                        "key": "kb-data",
                        "operator": "Equal",
                        "value": "true"
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/not-ready",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/unreachable",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    }
                ],
                "topologySpreadConstraints": [
                    {
                        "labelSelector": {
                            "matchLabels": {
                                "app.kubernetes.io/instance": "test-db",
                                "apps.kubeblocks.io/component-name": "postgresql"
                            }
                        },
                        "maxSkew": 1,
                        "topologyKey": "kubernetes.io/hostname",
                        "whenUnsatisfiable": "ScheduleAnyway"
                    }
                ],
                "volumes": [
                    {
                        "name": "data",
                        "persistentVolumeClaim": {
                            "claimName": "data-test-db-postgresql-0"
                        }
                    },
                    {
                        "emptyDir": {
                            "medium": "Memory",
                            "sizeLimit": "1Gi"
                        },
                        "name": "dshm"
                    },
                    {
                        "downwardAPI": {
                            "defaultMode": 420,
                            "items": [
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['kubeblocks.io/role']"
                                    },
                                    "path": "pod-role"
                                },
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.annotations['rs.apps.kubeblocks.io/primary']"
                                    },
                                    "path": "primary-pod"
                                },
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.annotations['apps.kubeblocks.io/component-replicas']"
                                    },
                                    "path": "component-replicas"
                                }
                            ]
                        },
                        "name": "pod-info"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-agamotto-configuration"
                        },
                        "name": "agamotto-configuration"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-pgbouncer-configuration"
                        },
                        "name": "pgbouncer-config"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-postgresql-configuration"
                        },
                        "name": "postgresql-config"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-postgresql-custom-metrics"
                        },
                        "name": "postgresql-custom-metrics"
                    },
                    {
                        "configMap": {
                            "defaultMode": 365,
                            "name": "test-db-postgresql-postgresql-scripts"
                        },
                        "name": "scripts"
                    },
                    {
                        "configMap": {
                            "defaultMode": 493,
                            "name": "sidecar-patroni-reload-script-test-db"
                        },
                        "name": "cm-script-postgresql-configuration"
                    },
                    {
                        "configMap": {
                            "defaultMode": 493,
                            "name": "sidecar-test-db-postgresql-config-manager-config"
                        },
                        "name": "config-manager-config"
                    },
                    {
                        "name": "kube-api-access-97bhs",
                        "projected": {
                            "defaultMode": 420,
                            "sources": [
                                {
                                    "serviceAccountToken": {
                                        "expirationSeconds": 3607,
                                        "path": "token"
                                    }
                                },
                                {
                                    "configMap": {
                                        "items": [
                                            {
                                                "key": "ca.crt",
                                                "path": "ca.crt"
                                            }
                                        ],
                                        "name": "kube-root-ca.crt"
                                    }
                                },
                                {
                                    "downwardAPI": {
                                        "items": [
                                            {
                                                "fieldRef": {
                                                    "apiVersion": "v1",
                                                    "fieldPath": "metadata.namespace"
                                                },
                                                "path": "namespace"
                                            }
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                ]
            },
            "status": [],
            "podName": "test-db-postgresql-0",
            "nodeName": "node name",
            "hostIp": "host ip",
            "ip": "pod ip",
            "restarts": 0,
            "age": "0s",
            "cpu": 1000,
            "memory": 1024
        },
        {
            "metadata": {
                "annotations": {
                    "apps.kubeblocks.io/component-replicas": "2",
                    "kubernetes.io/limit-ranger": "LimitRanger plugin set: ephemeral-storage request for container postgresql; ephemeral-storage limit for container postgresql; ephemeral-storage request for container pgbouncer; ephemeral-storage limit for container pgbouncer; ephemeral-storage request for container metrics; ephemeral-storage limit for container metrics; ephemeral-storage request for container lorry; ephemeral-storage limit for container lorry; ephemeral-storage request for container config-manager; ephemeral-storage limit for container config-manager; ephemeral-storage request for init container pg-init-container; ephemeral-storage limit for init container pg-init-container"
                },
                "creationTimestamp": "2025-02-24T03:15:14.000Z",
                "generateName": "test-db-postgresql-",
                "labels": {
                    "app.kubernetes.io/component": "postgresql",
                    "app.kubernetes.io/instance": "test-db",
                    "app.kubernetes.io/managed-by": "kubeblocks",
                    "app.kubernetes.io/name": "postgresql",
                    "app.kubernetes.io/version": "",
                    "apps.kubeblocks.io/cluster-uid": "0242385d-746d-4e40-a2ca-5ae319c9bc7d",
                    "apps.kubeblocks.io/component-name": "postgresql",
                    "apps.kubeblocks.postgres.patroni/scope": "test-db-postgresql-patroni19c9bc7d",
                    "apps.kubernetes.io/pod-index": "1",
                    "clusterdefinition.kubeblocks.io/name": "postgresql",
                    "clusterversion.kubeblocks.io/name": "postgresql-14.8.0",
                    "controller-revision-hash": "test-db-postgresql-789ff46c",
                    "sealos-db-provider-cr": "test-db",
                    "statefulset.kubernetes.io/pod-name": "test-db-postgresql-1"
                },
                "managedFields": [
                    {
                        "apiVersion": "v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:generateName": {},
                                "f:labels": {
                                    ".": {},
                                    "f:app.kubernetes.io/component": {},
                                    "f:app.kubernetes.io/instance": {},
                                    "f:app.kubernetes.io/managed-by": {},
                                    "f:app.kubernetes.io/name": {},
                                    "f:app.kubernetes.io/version": {},
                                    "f:apps.kubeblocks.io/component-name": {},
                                    "f:apps.kubernetes.io/pod-index": {},
                                    "f:controller-revision-hash": {},
                                    "f:statefulset.kubernetes.io/pod-name": {}
                                },
                                "f:ownerReferences": {
                                    ".": {},
                                    "k:{\"uid\":\"6c0d72c7-db79-403d-8c92-8e61d7c6decc\"}": {}
                                }
                            },
                            "f:spec": {
                                "f:affinity": {
                                    ".": {},
                                    "f:nodeAffinity": {
                                        ".": {},
                                        "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                    },
                                    "f:podAntiAffinity": {
                                        ".": {},
                                        "f:preferredDuringSchedulingIgnoredDuringExecution": {}
                                    }
                                },
                                "f:containers": {
                                    "k:{\"name\":\"config-manager\"}": {
                                        ".": {},
                                        "f:args": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"CONFIG_MANAGER_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"DB_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"TOOLS_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/config-manager\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/kb-tools/reload/postgresql-configuration\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"lorry\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_BUILTIN_HANDLER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_CLUSTER_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_COMP_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_DATA_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_RSM_ACTION_SVC_LIST\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_RSM_ROLE_PROBE_TIMEOUT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_RSM_ROLE_UPDATE_MECHANISM\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SERVICE_CHARACTER_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SERVICE_PASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SERVICE_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_SERVICE_USER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":3501,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            },
                                            "k:{\"containerPort\":50001,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:httpGet": {
                                                ".": {},
                                                "f:path": {},
                                                "f:port": {},
                                                "f:scheme": {}
                                            },
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:startupProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"metrics\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"DATA_SOURCE_PASS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"DATA_SOURCE_USER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"ENDPOINT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":9187,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/opt/agamotto\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/opt/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"pgbouncer\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGBOUNCER_AUTH_TYPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGBOUNCER_BIND_ADDRESS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGBOUNCER_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"POSTGRESQL_HOST\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POSTGRESQL_PASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POSTGRESQL_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"POSTGRESQL_USERNAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:livenessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":6432,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:tcpSocket": {
                                                ".": {},
                                                "f:port": {}
                                            },
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/pgbouncer/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    },
                                    "k:{\"name\":\"postgresql\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"ALLOW_NOSSL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"DCS_ENABLE_KUBERNETES_API\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PG_CONFIG_PATH\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KUBERNETES_LABELS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_ROLE_LABEL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_SCOPE_LABEL\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KUBERNETES_USE_CONFIGMAPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGPASSWORD\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_ADMIN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_STANDBY\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGPASSWORD_SUPERUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGROOT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"PGUSER_ADMIN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER_STANDBY\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"PGUSER_SUPERUSER\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:secretKeyRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"POD_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"RESTORE_DATA_DIR\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SCOPE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SERVICE_PORT\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"SPILO_CONFIGURATION\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":5432,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            },
                                            "k:{\"containerPort\":8008,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:readinessProbe": {
                                            ".": {},
                                            "f:exec": {
                                                ".": {},
                                                "f:command": {}
                                            },
                                            "f:failureThreshold": {},
                                            "f:initialDelaySeconds": {},
                                            "f:periodSeconds": {},
                                            "f:successThreshold": {},
                                            "f:timeoutSeconds": {}
                                        },
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:securityContext": {
                                            ".": {},
                                            "f:runAsUser": {}
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/dev/shm\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    }
                                },
                                "f:dnsPolicy": {},
                                "f:enableServiceLinks": {},
                                "f:hostname": {},
                                "f:initContainers": {
                                    ".": {},
                                    "k:{\"name\":\"pg-init-container\"}": {
                                        ".": {},
                                        "f:command": {},
                                        "f:env": {
                                            ".": {},
                                            "k:{\"name\":\"KB_HOSTIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_HOST_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NAMESPACE\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_NODENAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_PODIPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_FQDN\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:value": {}
                                            },
                                            "k:{\"name\":\"KB_POD_IP\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_IPS\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_POD_UID\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            },
                                            "k:{\"name\":\"KB_SA_NAME\"}": {
                                                ".": {},
                                                "f:name": {},
                                                "f:valueFrom": {
                                                    ".": {},
                                                    "f:fieldRef": {}
                                                }
                                            }
                                        },
                                        "f:envFrom": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:resources": {
                                            ".": {},
                                            "f:limits": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            },
                                            "f:requests": {
                                                ".": {},
                                                "f:cpu": {},
                                                "f:memory": {}
                                            }
                                        },
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/home/postgres/conf\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/home/postgres/pgdata\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-podinfo\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            },
                                            "k:{\"mountPath\":\"/kb-scripts\"}": {
                                                ".": {},
                                                "f:mountPath": {},
                                                "f:name": {}
                                            }
                                        }
                                    }
                                },
                                "f:restartPolicy": {},
                                "f:schedulerName": {},
                                "f:securityContext": {
                                    ".": {},
                                    "f:fsGroup": {},
                                    "f:fsGroupChangePolicy": {},
                                    "f:runAsGroup": {},
                                    "f:runAsUser": {}
                                },
                                "f:serviceAccount": {},
                                "f:serviceAccountName": {},
                                "f:subdomain": {},
                                "f:terminationGracePeriodSeconds": {},
                                "f:tolerations": {},
                                "f:topologySpreadConstraints": {
                                    ".": {},
                                    "k:{\"topologyKey\":\"kubernetes.io/hostname\",\"whenUnsatisfiable\":\"ScheduleAnyway\"}": {
                                        ".": {},
                                        "f:labelSelector": {},
                                        "f:maxSkew": {},
                                        "f:topologyKey": {},
                                        "f:whenUnsatisfiable": {}
                                    }
                                },
                                "f:volumes": {
                                    ".": {},
                                    "k:{\"name\":\"agamotto-configuration\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"cm-script-postgresql-configuration\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"config-manager-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"data\"}": {
                                        ".": {},
                                        "f:name": {},
                                        "f:persistentVolumeClaim": {
                                            ".": {},
                                            "f:claimName": {}
                                        }
                                    },
                                    "k:{\"name\":\"dshm\"}": {
                                        ".": {},
                                        "f:emptyDir": {
                                            ".": {},
                                            "f:medium": {},
                                            "f:sizeLimit": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"pgbouncer-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"pod-info\"}": {
                                        ".": {},
                                        "f:downwardAPI": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:items": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"postgresql-config\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"postgresql-custom-metrics\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    },
                                    "k:{\"name\":\"scripts\"}": {
                                        ".": {},
                                        "f:configMap": {
                                            ".": {},
                                            "f:defaultMode": {},
                                            "f:name": {}
                                        },
                                        "f:name": {}
                                    }
                                }
                            }
                        },
                        "manager": "kube-controller-manager",
                        "operation": "Update",
                        "time": "2025-02-24T03:15:14.000Z"
                    },
                    {
                        "apiVersion": "v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:annotations": {
                                    "f:apps.kubeblocks.io/component-replicas": {}
                                },
                                "f:labels": {
                                    "f:apps.kubeblocks.io/cluster-uid": {},
                                    "f:apps.kubeblocks.postgres.patroni/scope": {},
                                    "f:clusterdefinition.kubeblocks.io/name": {},
                                    "f:clusterversion.kubeblocks.io/name": {},
                                    "f:sealos-db-provider-cr": {}
                                }
                            }
                        },
                        "manager": "manager",
                        "operation": "Update",
                        "time": "2025-02-24T03:15:14.000Z"
                    }
                ],
                "name": "test-db-postgresql-1",
                "namespace": "ns-p4v4vcc1",
                "ownerReferences": [
                    {
                        "apiVersion": "apps/v1",
                        "blockOwnerDeletion": true,
                        "controller": true,
                        "kind": "StatefulSet",
                        "name": "test-db-postgresql",
                        "uid": "6c0d72c7-db79-403d-8c92-8e61d7c6decc"
                    }
                ],
                "resourceVersion": "2271009900",
                "uid": "ea2b4775-3e56-490c-9794-45ba5bf3421c"
            },
            "spec": {
                "affinity": {
                    "nodeAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [
                            {
                                "preference": {
                                    "matchExpressions": [
                                        {
                                            "key": "kb-data",
                                            "operator": "In",
                                            "values": [
                                                "true"
                                            ]
                                        }
                                    ]
                                },
                                "weight": 100
                            }
                        ]
                    },
                    "podAntiAffinity": {
                        "preferredDuringSchedulingIgnoredDuringExecution": [
                            {
                                "podAffinityTerm": {
                                    "labelSelector": {
                                        "matchLabels": {
                                            "app.kubernetes.io/instance": "test-db",
                                            "apps.kubeblocks.io/component-name": "postgresql"
                                        }
                                    },
                                    "topologyKey": "kubernetes.io/hostname"
                                },
                                "weight": 100
                            }
                        ]
                    }
                },
                "containers": [
                    {
                        "command": [
                            "/kb-scripts/setup.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "SERVICE_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "DCS_ENABLE_KUBERNETES_API",
                                "value": "true"
                            },
                            {
                                "name": "KUBERNETES_USE_CONFIGMAPS",
                                "value": "true"
                            },
                            {
                                "name": "SCOPE",
                                "value": "$(KB_CLUSTER_NAME)-$(KB_COMP_NAME)-patroni$(KB_CLUSTER_UID_POSTFIX_8)"
                            },
                            {
                                "name": "KUBERNETES_SCOPE_LABEL",
                                "value": "apps.kubeblocks.postgres.patroni/scope"
                            },
                            {
                                "name": "KUBERNETES_ROLE_LABEL",
                                "value": "apps.kubeblocks.postgres.patroni/role"
                            },
                            {
                                "name": "KUBERNETES_LABELS",
                                "value": "{\"app.kubernetes.io/instance\":\"$(KB_CLUSTER_NAME)\",\"apps.kubeblocks.io/component-name\":\"$(KB_COMP_NAME)\"}"
                            },
                            {
                                "name": "RESTORE_DATA_DIR",
                                "value": "/home/postgres/pgdata/kb_restore"
                            },
                            {
                                "name": "KB_PG_CONFIG_PATH",
                                "value": "/home/postgres/conf/postgresql.conf"
                            },
                            {
                                "name": "SPILO_CONFIGURATION",
                                "value": "bootstrap:\n  initdb:\n    - auth-host: md5\n    - auth-local: trust\n"
                            },
                            {
                                "name": "ALLOW_NOSSL",
                                "value": "true"
                            },
                            {
                                "name": "PGROOT",
                                "value": "/home/postgres/pgdata/pgroot"
                            },
                            {
                                "name": "POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "POD_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_SUPERUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGPASSWORD_SUPERUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_ADMIN",
                                "value": "superadmin"
                            },
                            {
                                "name": "PGPASSWORD_ADMIN",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER_STANDBY",
                                "value": "standby"
                            },
                            {
                                "name": "PGPASSWORD_STANDBY",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGUSER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "PGPASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "postgresql",
                        "ports": [
                            {
                                "containerPort": 5432,
                                "name": "tcp-postgresql",
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 8008,
                                "name": "patroni",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "exec": {
                                "command": [
                                    "/bin/sh",
                                    "-c",
                                    "-ee",
                                    "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /postgresql/tmp/.initialized ] || [ -f /postgresql/.initialized ]\n"
                                ]
                            },
                            "failureThreshold": 3,
                            "initialDelaySeconds": 10,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "timeoutSeconds": 5
                        },
                        "resources": {
                            "limits": {
                                "cpu": "1",
                                "ephemeral-storage": "100Mi",
                                "memory": "1Gi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "ephemeral-storage": "100Mi",
                                "memory": "102Mi"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/dev/shm",
                                "name": "dshm"
                            },
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/kb-podinfo",
                                "name": "pod-info"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "/kb-scripts/pgbouncer_setup.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "PGBOUNCER_AUTH_TYPE",
                                "value": "md5"
                            },
                            {
                                "name": "POSTGRESQL_USERNAME",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "POSTGRESQL_PASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "POSTGRESQL_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "POSTGRESQL_HOST",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "PGBOUNCER_PORT",
                                "value": "6432"
                            },
                            {
                                "name": "PGBOUNCER_BIND_ADDRESS",
                                "value": "0.0.0.0"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/pgbouncer:1.19.0",
                        "imagePullPolicy": "IfNotPresent",
                        "livenessProbe": {
                            "failureThreshold": 3,
                            "initialDelaySeconds": 15,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": "tcp-pgbouncer"
                            },
                            "timeoutSeconds": 5
                        },
                        "name": "pgbouncer",
                        "ports": [
                            {
                                "containerPort": 6432,
                                "name": "tcp-pgbouncer",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "initialDelaySeconds": 15,
                            "periodSeconds": 30,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": "tcp-pgbouncer"
                            },
                            "timeoutSeconds": 5
                        },
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/pgbouncer/conf",
                                "name": "pgbouncer-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "/bin/agamotto",
                            "--config=/opt/agamotto/agamotto-config.yaml"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "ENDPOINT",
                                "value": "127.0.0.1:5432"
                            },
                            {
                                "name": "DATA_SOURCE_PASS",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            },
                            {
                                "name": "DATA_SOURCE_USER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential",
                                        "optional": false
                                    }
                                }
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/agamotto:0.1.2-beta.1",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "metrics",
                        "ports": [
                            {
                                "containerPort": 9187,
                                "name": "http-metrics",
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "securityContext": {
                            "runAsUser": 0
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/opt/conf",
                                "name": "postgresql-custom-metrics"
                            },
                            {
                                "mountPath": "/opt/agamotto",
                                "name": "agamotto-configuration"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "command": [
                            "lorry",
                            "--port",
                            "3501",
                            "--grpcport",
                            "50001"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "KB_BUILTIN_HANDLER",
                                "value": "postgresql"
                            },
                            {
                                "name": "KB_SERVICE_USER",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "username",
                                        "name": "test-db-conn-credential"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_PASSWORD",
                                "valueFrom": {
                                    "secretKeyRef": {
                                        "key": "password",
                                        "name": "test-db-conn-credential"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_PORT",
                                "value": "5432"
                            },
                            {
                                "name": "KB_DATA_PATH",
                                "value": "/home/postgres/pgdata"
                            },
                            {
                                "name": "KB_RSM_ACTION_SVC_LIST",
                                "value": "null"
                            },
                            {
                                "name": "KB_RSM_ROLE_UPDATE_MECHANISM",
                                "value": "DirectAPIServerEventUpdate"
                            },
                            {
                                "name": "KB_RSM_ROLE_PROBE_TIMEOUT",
                                "value": "1"
                            },
                            {
                                "name": "KB_CLUSTER_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['app.kubernetes.io/instance']"
                                    }
                                }
                            },
                            {
                                "name": "KB_COMP_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['apps.kubeblocks.io/component-name']"
                                    }
                                }
                            },
                            {
                                "name": "KB_SERVICE_CHARACTER_TYPE",
                                "value": "postgresql"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "lorry",
                        "ports": [
                            {
                                "containerPort": 3501,
                                "name": "lorry-http-port",
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 50001,
                                "name": "lorry-grpc-port",
                                "protocol": "TCP"
                            }
                        ],
                        "readinessProbe": {
                            "failureThreshold": 3,
                            "httpGet": {
                                "path": "/v1.0/checkrole",
                                "port": 3501,
                                "scheme": "HTTP"
                            },
                            "periodSeconds": 1,
                            "successThreshold": 1,
                            "timeoutSeconds": 1
                        },
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "startupProbe": {
                            "failureThreshold": 3,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "tcpSocket": {
                                "port": 3501
                            },
                            "timeoutSeconds": 1
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    },
                    {
                        "args": [
                            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$(TOOLS_PATH)",
                            "/bin/reloader",
                            "--log-level",
                            "info",
                            "--operator-update-enable",
                            "--tcp",
                            "9901",
                            "--config",
                            "/opt/config-manager/config-manager.yaml"
                        ],
                        "command": [
                            "env"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            },
                            {
                                "name": "CONFIG_MANAGER_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "DB_TYPE",
                                "value": "postgresql"
                            },
                            {
                                "name": "TOOLS_PATH",
                                "value": "/opt/kb-tools/reload/postgresql-configuration:/opt/config-manager"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            },
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-rsm-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "config-manager",
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/opt/kb-tools/reload/postgresql-configuration",
                                "name": "cm-script-postgresql-configuration"
                            },
                            {
                                "mountPath": "/opt/config-manager",
                                "name": "config-manager-config"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "enableServiceLinks": true,
                "hostname": "test-db-postgresql-1",
                "initContainers": [
                    {
                        "command": [
                            "/kb-scripts/init_container.sh"
                        ],
                        "env": [
                            {
                                "name": "KB_POD_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.name"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_UID",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.uid"
                                    }
                                }
                            },
                            {
                                "name": "KB_NAMESPACE",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.namespace"
                                    }
                                }
                            },
                            {
                                "name": "KB_SA_NAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.serviceAccountName"
                                    }
                                }
                            },
                            {
                                "name": "KB_NODENAME",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "spec.nodeName"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOST_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_IPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_HOSTIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.hostIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIP",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIP"
                                    }
                                }
                            },
                            {
                                "name": "KB_PODIPS",
                                "valueFrom": {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "status.podIPs"
                                    }
                                }
                            },
                            {
                                "name": "KB_POD_FQDN",
                                "value": "$(KB_POD_NAME).test-db-postgresql-headless.$(KB_NAMESPACE).svc"
                            }
                        ],
                        "envFrom": [
                            {
                                "configMapRef": {
                                    "name": "test-db-postgresql-env",
                                    "optional": false
                                }
                            }
                        ],
                        "image": "docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "pg-init-container",
                        "resources": {
                            "limits": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            },
                            "requests": {
                                "cpu": "0",
                                "ephemeral-storage": "100Mi",
                                "memory": "0"
                            }
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/home/postgres/pgdata",
                                "name": "data"
                            },
                            {
                                "mountPath": "/home/postgres/conf",
                                "name": "postgresql-config"
                            },
                            {
                                "mountPath": "/kb-scripts",
                                "name": "scripts"
                            },
                            {
                                "mountPath": "/kb-podinfo",
                                "name": "pod-info"
                            },
                            {
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                                "name": "kube-api-access-cpg7r",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "preemptionPolicy": "PreemptLowerPriority",
                "priority": 0,
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {
                    "fsGroup": 103,
                    "fsGroupChangePolicy": "OnRootMismatch",
                    "runAsGroup": 103,
                    "runAsUser": 0
                },
                "serviceAccount": "test-db",
                "serviceAccountName": "test-db",
                "subdomain": "test-db-postgresql-headless",
                "terminationGracePeriodSeconds": 30,
                "tolerations": [
                    {
                        "effect": "NoSchedule",
                        "key": "kb-data",
                        "operator": "Equal",
                        "value": "true"
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/not-ready",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/unreachable",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    }
                ],
                "topologySpreadConstraints": [
                    {
                        "labelSelector": {
                            "matchLabels": {
                                "app.kubernetes.io/instance": "test-db",
                                "apps.kubeblocks.io/component-name": "postgresql"
                            }
                        },
                        "maxSkew": 1,
                        "topologyKey": "kubernetes.io/hostname",
                        "whenUnsatisfiable": "ScheduleAnyway"
                    }
                ],
                "volumes": [
                    {
                        "name": "data",
                        "persistentVolumeClaim": {
                            "claimName": "data-test-db-postgresql-1"
                        }
                    },
                    {
                        "emptyDir": {
                            "medium": "Memory",
                            "sizeLimit": "1Gi"
                        },
                        "name": "dshm"
                    },
                    {
                        "downwardAPI": {
                            "defaultMode": 420,
                            "items": [
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.labels['kubeblocks.io/role']"
                                    },
                                    "path": "pod-role"
                                },
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.annotations['rs.apps.kubeblocks.io/primary']"
                                    },
                                    "path": "primary-pod"
                                },
                                {
                                    "fieldRef": {
                                        "apiVersion": "v1",
                                        "fieldPath": "metadata.annotations['apps.kubeblocks.io/component-replicas']"
                                    },
                                    "path": "component-replicas"
                                }
                            ]
                        },
                        "name": "pod-info"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-agamotto-configuration"
                        },
                        "name": "agamotto-configuration"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-pgbouncer-configuration"
                        },
                        "name": "pgbouncer-config"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-postgresql-configuration"
                        },
                        "name": "postgresql-config"
                    },
                    {
                        "configMap": {
                            "defaultMode": 292,
                            "name": "test-db-postgresql-postgresql-custom-metrics"
                        },
                        "name": "postgresql-custom-metrics"
                    },
                    {
                        "configMap": {
                            "defaultMode": 365,
                            "name": "test-db-postgresql-postgresql-scripts"
                        },
                        "name": "scripts"
                    },
                    {
                        "configMap": {
                            "defaultMode": 493,
                            "name": "sidecar-patroni-reload-script-test-db"
                        },
                        "name": "cm-script-postgresql-configuration"
                    },
                    {
                        "configMap": {
                            "defaultMode": 493,
                            "name": "sidecar-test-db-postgresql-config-manager-config"
                        },
                        "name": "config-manager-config"
                    },
                    {
                        "name": "kube-api-access-cpg7r",
                        "projected": {
                            "defaultMode": 420,
                            "sources": [
                                {
                                    "serviceAccountToken": {
                                        "expirationSeconds": 3607,
                                        "path": "token"
                                    }
                                },
                                {
                                    "configMap": {
                                        "items": [
                                            {
                                                "key": "ca.crt",
                                                "path": "ca.crt"
                                            }
                                        ],
                                        "name": "kube-root-ca.crt"
                                    }
                                },
                                {
                                    "downwardAPI": {
                                        "items": [
                                            {
                                                "fieldRef": {
                                                    "apiVersion": "v1",
                                                    "fieldPath": "metadata.namespace"
                                                },
                                                "path": "namespace"
                                            }
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                ]
            },
            "status": [],
            "podName": "test-db-postgresql-1",
            "nodeName": "node name",
            "hostIp": "host ip",
            "ip": "pod ip",
            "restarts": 0,
            "age": "0s",
            "cpu": 1000,
            "memory": 1024
        }
    ]
}
```

GET https://dbprovider.hzh.sealos.run/api/getDBByName?name=test-db
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "apiVersion": "apps.kubeblocks.io/v1alpha1",
        "kind": "Cluster",
        "metadata": {
            "annotations": {
                "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"apps.kubeblocks.io/v1alpha1\",\"kind\":\"Cluster\",\"metadata\":{\"finalizers\":[\"cluster.kubeblocks.io/finalizer\"],\"labels\":{\"clusterdefinition.kubeblocks.io/name\":\"postgresql\",\"clusterversion.kubeblocks.io/name\":\"postgresql-14.8.0\",\"sealos-db-provider-cr\":\"test-db\"},\"annotations\":{},\"name\":\"test-db\",\"namespace\":\"ns-p4v4vcc1\"},\"spec\":{\"affinity\":{\"nodeLabels\":{},\"podAntiAffinity\":\"Preferred\",\"tenancy\":\"SharedNode\",\"topologyKeys\":[\"kubernetes.io/hostname\"]},\"clusterDefinitionRef\":\"postgresql\",\"clusterVersionRef\":\"postgresql-14.8.0\",\"componentSpecs\":[{\"componentDefRef\":\"postgresql\",\"monitor\":true,\"name\":\"postgresql\",\"replicas\":2,\"resources\":{\"limits\":{\"cpu\":\"1000m\",\"memory\":\"1024Mi\"},\"requests\":{\"cpu\":\"100m\",\"memory\":\"102Mi\"}},\"serviceAccountName\":\"test-db\",\"switchPolicy\":{\"type\":\"Noop\"},\"volumeClaimTemplates\":[{\"name\":\"data\",\"spec\":{\"accessModes\":[\"ReadWriteOnce\"],\"resources\":{\"requests\":{\"storage\":\"3Gi\"}}}}]}],\"terminationPolicy\":\"WipeOut\",\"tolerations\":[]}}"
            },
            "creationTimestamp": "2025-02-24T03:15:14Z",
            "finalizers": [
                "cluster.kubeblocks.io/finalizer"
            ],
            "generation": 2,
            "labels": {
                "clusterdefinition.kubeblocks.io/name": "postgresql",
                "clusterversion.kubeblocks.io/name": "postgresql-14.8.0",
                "sealos-db-provider-cr": "test-db"
            },
            "managedFields": [
                {
                    "apiVersion": "apps.kubeblocks.io/v1alpha1",
                    "fieldsType": "FieldsV1",
                    "fieldsV1": {
                        "f:status": {
                            ".": {},
                            "f:clusterDefGeneration": {},
                            "f:components": {
                                ".": {},
                                "f:postgresql": {
                                    ".": {},
                                    "f:phase": {},
                                    "f:podsReady": {}
                                }
                            },
                            "f:conditions": {},
                            "f:observedGeneration": {},
                            "f:phase": {}
                        }
                    },
                    "manager": "manager",
                    "operation": "Update",
                    "subresource": "status",
                    "time": "2025-02-24T03:15:14Z"
                },
                {
                    "apiVersion": "apps.kubeblocks.io/v1alpha1",
                    "fieldsType": "FieldsV1",
                    "fieldsV1": {
                        "f:metadata": {
                            "f:annotations": {
                                ".": {},
                                "f:kubectl.kubernetes.io/last-applied-configuration": {}
                            },
                            "f:finalizers": {
                                ".": {},
                                "v:\"cluster.kubeblocks.io/finalizer\"": {}
                            },
                            "f:labels": {
                                ".": {},
                                "f:clusterdefinition.kubeblocks.io/name": {},
                                "f:clusterversion.kubeblocks.io/name": {},
                                "f:sealos-db-provider-cr": {}
                            }
                        },
                        "f:spec": {
                            ".": {},
                            "f:affinity": {
                                ".": {},
                                "f:nodeLabels": {},
                                "f:podAntiAffinity": {},
                                "f:tenancy": {},
                                "f:topologyKeys": {
                                    ".": {},
                                    "v:\"kubernetes.io/hostname\"": {}
                                }
                            },
                            "f:backup": {
                                ".": {},
                                "f:cronExpression": {},
                                "f:enabled": {},
                                "f:method": {},
                                "f:pitrEnabled": {},
                                "f:repoName": {},
                                "f:retentionPeriod": {}
                            },
                            "f:clusterDefinitionRef": {},
                            "f:clusterVersionRef": {},
                            "f:componentSpecs": {},
                            "f:terminationPolicy": {},
                            "f:tolerations": {}
                        }
                    },
                    "manager": "unknown",
                    "operation": "Update",
                    "time": "2025-02-24T03:15:14Z"
                }
            ],
            "name": "test-db",
            "namespace": "ns-p4v4vcc1",
            "resourceVersion": "2271009916",
            "uid": "0242385d-746d-4e40-a2ca-5ae319c9bc7d"
        },
        "spec": {
            "affinity": {
                "nodeLabels": {},
                "podAntiAffinity": "Preferred",
                "tenancy": "SharedNode",
                "topologyKeys": [
                    "kubernetes.io/hostname"
                ]
            },
            "backup": {
                "cronExpression": "00 15 * * *",
                "enabled": true,
                "method": "pg-basebackup",
                "pitrEnabled": false,
                "repoName": "backup-hzh-oss",
                "retentionPeriod": "7d"
            },
            "clusterDefinitionRef": "postgresql",
            "clusterVersionRef": "postgresql-14.8.0",
            "componentSpecs": [
                {
                    "componentDefRef": "postgresql",
                    "monitor": true,
                    "name": "postgresql",
                    "noCreatePDB": false,
                    "replicas": 2,
                    "resources": {
                        "limits": {
                            "cpu": "1000m",
                            "memory": "1024Mi"
                        },
                        "requests": {
                            "cpu": "100m",
                            "memory": "102Mi"
                        }
                    },
                    "rsmTransformPolicy": "ToSts",
                    "serviceAccountName": "test-db",
                    "switchPolicy": {
                        "type": "Noop"
                    },
                    "volumeClaimTemplates": [
                        {
                            "name": "data",
                            "spec": {
                                "accessModes": [
                                    "ReadWriteOnce"
                                ],
                                "resources": {
                                    "requests": {
                                        "storage": "3Gi"
                                    }
                                }
                            }
                        }
                    ]
                }
            ],
            "terminationPolicy": "WipeOut",
            "tolerations": []
        },
        "status": {
            "clusterDefGeneration": 4,
            "components": {
                "postgresql": {
                    "phase": "Creating",
                    "podsReady": false
                }
            },
            "conditions": [
                {
                    "lastTransitionTime": "2025-02-24T03:15:14Z",
                    "message": "The operator has started the provisioning of Cluster: test-db",
                    "observedGeneration": 2,
                    "reason": "PreCheckSucceed",
                    "status": "True",
                    "type": "ProvisioningStarted"
                },
                {
                    "lastTransitionTime": "2025-02-24T03:15:14Z",
                    "message": "Successfully applied for resources",
                    "observedGeneration": 2,
                    "reason": "ApplyResourcesSucceed",
                    "status": "True",
                    "type": "ApplyResources"
                },
                {
                    "lastTransitionTime": "2025-02-24T03:15:14Z",
                    "message": "pods are not ready in Components: [postgresql], refer to related component message in Cluster.status.components",
                    "reason": "ReplicasNotReady",
                    "status": "False",
                    "type": "ReplicasReady"
                },
                {
                    "lastTransitionTime": "2025-02-24T03:15:14Z",
                    "message": "pods are unavailable in Components: [postgresql], refer to related component message in Cluster.status.components",
                    "reason": "ComponentsNotReady",
                    "status": "False",
                    "type": "Ready"
                }
            ],
            "observedGeneration": 2,
            "phase": "Creating"
        }
    }
}
```
// pod详情-事件
GET https://dbprovider.hzh.sealos.run/api/pod/getPodEvents?podName=test-db-postgresql-0
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "apiVersion": "v1",
        "items": [
            {
                "action": "Binding",
                "eventTime": "2025-02-24T03:15:16.415221Z",
                "firstTimestamp": null,
                "involvedObject": {
                    "apiVersion": "v1",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271009852",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": null,
                "message": "Successfully assigned ns-p4v4vcc1/test-db-postgresql-0 to sealos-run-node0033",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:16.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "events.k8s.io/v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:action": {},
                                "f:eventTime": {},
                                "f:note": {},
                                "f:reason": {},
                                "f:regarding": {},
                                "f:reportingController": {},
                                "f:reportingInstance": {},
                                "f:type": {}
                            },
                            "manager": "kube-scheduler",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:16.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.1827067d57c58ed7",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072246",
                    "uid": "cfb17c41-6ab8-4e0f-b489-dfb517b5e48e"
                },
                "reason": "Scheduled",
                "reportingComponent": "default-scheduler",
                "reportingInstance": "default-scheduler-sealos-run-master0001",
                "source": {},
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:16.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:16.000Z",
                "message": "Unable to attach or mount volumes: unmounted volumes=[agamotto-configuration cm-script-postgresql-configuration config-manager-config data dshm kube-api-access-97bhs pgbouncer-config pod-info postgresql-config postgresql-custom-metrics scripts], unattached volumes=[], failed to process volumes=[data]: error processing PVC ns-p4v4vcc1/data-test-db-postgresql-0: PVC is not bound",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:16.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:16.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.1827067d5cc65a3d",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072249",
                    "uid": "ac585fa4-4eec-44a6-a6e8-23557ab07350"
                },
                "reason": "FailedMount",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Warning"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:28.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.initContainers{pg-init-container}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:28.000Z",
                "message": "Container image \"docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0\" already present on machine",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:28.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:28.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.182706803548da69",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072413",
                    "uid": "eaccc00c-5c9a-411d-a23c-fafc013c42db"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:28.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.initContainers{pg-init-container}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:28.000Z",
                "message": "Created container pg-init-container",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:28.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:28.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.1827068037d30c7a",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072414",
                    "uid": "79111665-d886-40ad-886d-69871f793fd9"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:28.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.initContainers{pg-init-container}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:28.000Z",
                "message": "Started container pg-init-container",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:28.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:28.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.182706803fc7963d",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072415",
                    "uid": "e24298b4-bf99-4be5-ba80-ea4060597aea"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:29.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{postgresql}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:29.000Z",
                "message": "Container image \"docker.io/wallykk/spilo:14.8.0-pgvector-v0.8.0\" already present on machine",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:29.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:29.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.1827068079200110",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072417",
                    "uid": "26142616-e9db-4bff-a95b-da73d09eed37"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:29.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{postgresql}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:29.000Z",
                "message": "Created container postgresql",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:29.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:29.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.182706807baf543b",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072418",
                    "uid": "3860ae77-1a83-4f64-bae5-57ac00b7ecc8"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{postgresql}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Started container postgresql",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.182706808aa666aa",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072419",
                    "uid": "05af60ba-0dcb-4a54-8f0d-f046f6692ec2"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{pgbouncer}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Container image \"apecloud-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/pgbouncer:1.19.0\" already present on machine",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.182706808f42fc0b",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072420",
                    "uid": "3257f39c-afc2-44a8-a24f-184289cfd6fe"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{pgbouncer}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Created container pgbouncer",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680950320b3",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072421",
                    "uid": "cf048f32-b559-46fb-8b88-ba09b8afa9fd"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{pgbouncer}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Started container pgbouncer",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680a47467ba",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072423",
                    "uid": "1cbe524e-4df1-464e-9f95-04bd42ead318"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{metrics}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Container image \"infracreate-registry.cn-zhangjiakou.cr.aliyuncs.com/apecloud/agamotto:0.1.2-beta.1\" already present on machine",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680a8d55bd2",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072424",
                    "uid": "9522b6e1-88fc-4d57-9283-368c6a4e9350"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{metrics}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Created container metrics",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680af58345b",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072425",
                    "uid": "4d5f6b1d-7c91-4dc6-b7f3-04564b89675d"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{metrics}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Started container metrics",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680bafa0520",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072426",
                    "uid": "caf54cef-a03d-4775-aa90-8dd42c8bf962"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{lorry}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Container image \"registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2\" already present on machine",
                "metadata": {
                    "annotations": {
                        "role.kubeblocks.io/event-handled": "count-1"
                    },
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:role.kubeblocks.io/event-handled": {}
                                    }
                                }
                            },
                            "manager": "manager",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680bb132f3a",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072428",
                    "uid": "12d44d66-3c34-4f69-ae34-0f74d0626611"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:30.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{lorry}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:30.000Z",
                "message": "Created container lorry",
                "metadata": {
                    "annotations": {
                        "role.kubeblocks.io/event-handled": "count-1"
                    },
                    "creationTimestamp": "2025-02-24T03:15:30.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:30.000Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:role.kubeblocks.io/event-handled": {}
                                    }
                                }
                            },
                            "manager": "manager",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680bcb997fa",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072430",
                    "uid": "46cf2c8b-aa6c-4f88-893e-c32cf8eee662"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:31.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{lorry}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:31.000Z",
                "message": "Started container lorry",
                "metadata": {
                    "annotations": {
                        "role.kubeblocks.io/event-handled": "count-1"
                    },
                    "creationTimestamp": "2025-02-24T03:15:31.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:role.kubeblocks.io/event-handled": {}
                                    }
                                }
                            },
                            "manager": "manager",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680ca7e6de4",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072434",
                    "uid": "731fae2d-0bfd-41ec-b343-58c80a41e19b"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:31.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{config-manager}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:31.000Z",
                "message": "Container image \"registry.cn-hangzhou.aliyuncs.com/apecloud/kubeblocks-tools:0.8.2\" already present on machine",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:31.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680ca942f53",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072433",
                    "uid": "8f99bc28-4756-4f6f-84e0-1066d640fcc1"
                },
                "reason": "Pulled",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:31.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{config-manager}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:31.000Z",
                "message": "Created container config-manager",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:31.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680cdba7cac",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072435",
                    "uid": "4ab55d84-f3e6-4e04-a206-6946e938a169"
                },
                "reason": "Created",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 1,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:31.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{config-manager}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:15:31.000Z",
                "message": "Started container config-manager",
                "metadata": {
                    "creationTimestamp": "2025-02-24T03:15:31.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:31.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270680df425182",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072437",
                    "uid": "d9a5c5b8-4680-4d3f-81dd-f8784a8dd152"
                },
                "reason": "Started",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            },
            {
                "count": 5,
                "eventTime": null,
                "firstTimestamp": "2025-02-24T03:15:57.000Z",
                "involvedObject": {
                    "apiVersion": "v1",
                    "fieldPath": "spec.containers{postgresql}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "2271010250",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:16:27.000Z",
                "message": "Readiness probe failed: 127.0.0.1:5432 - no response\n",
                "metadata": {
                    "annotations": {
                        "datamigration.apecloud.io/event-handler": "true"
                    },
                    "creationTimestamp": "2025-02-24T03:15:57.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:datamigration.apecloud.io/event-handler": {}
                                    }
                                }
                            },
                            "manager": "manager",
                            "operation": "Update",
                            "time": "2025-02-24T03:15:57.000Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:count": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "kubelet",
                            "operation": "Update",
                            "time": "2025-02-24T03:16:27.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.18270686fced4905",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072773",
                    "uid": "f6b4d04f-907d-45e1-af63-878e11a82196"
                },
                "reason": "Unhealthy",
                "reportingComponent": "kubelet",
                "reportingInstance": "sealos-run-node0033",
                "source": {
                    "component": "kubelet",
                    "host": "sealos-run-node0033"
                },
                "type": "Warning"
            },
            {
                "action": "checkRole",
                "eventTime": "2025-02-24T03:16:44.809502Z",
                "firstTimestamp": "2025-02-24T03:16:44.000Z",
                "involvedObject": {
                    "fieldPath": "spec.containers{lorry}",
                    "kind": "Pod",
                    "name": "test-db-postgresql-0",
                    "namespace": "ns-p4v4vcc1",
                    "uid": "a0ee88ff-fe05-4b27-98ba-2323290ee15c"
                },
                "lastTimestamp": "2025-02-24T03:16:44.000Z",
                "message": "{\"event\":\"Success\",\"operation\":\"checkRole\",\"originalRole\":\"\",\"role\":\"secondary\"}",
                "metadata": {
                    "annotations": {
                        "role.kubeblocks.io/event-handled": "count-0"
                    },
                    "creationTimestamp": "2025-02-24T03:16:44.000Z",
                    "managedFields": [
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:action": {},
                                "f:eventTime": {},
                                "f:firstTimestamp": {},
                                "f:involvedObject": {},
                                "f:lastTimestamp": {},
                                "f:message": {},
                                "f:reason": {},
                                "f:reportingComponent": {},
                                "f:reportingInstance": {},
                                "f:source": {
                                    "f:component": {},
                                    "f:host": {}
                                },
                                "f:type": {}
                            },
                            "manager": "lorry",
                            "operation": "Update",
                            "time": "2025-02-24T03:16:44.000Z"
                        },
                        {
                            "apiVersion": "v1",
                            "fieldsType": "FieldsV1",
                            "fieldsV1": {
                                "f:metadata": {
                                    "f:annotations": {
                                        ".": {},
                                        "f:role.kubeblocks.io/event-handled": {}
                                    }
                                }
                            },
                            "manager": "manager",
                            "operation": "Update",
                            "time": "2025-02-24T03:16:44.000Z"
                        }
                    ],
                    "name": "test-db-postgresql-0.tzz2l8ptq74pxhv2",
                    "namespace": "ns-p4v4vcc1",
                    "resourceVersion": "105072809",
                    "uid": "df4fd685-3d52-4817-a0b4-4dc6dde5d52d"
                },
                "reason": "checkRole",
                "reportingComponent": "lorry",
                "reportingInstance": "test-db-postgresql-0",
                "source": {
                    "component": "lorry",
                    "host": "sealos-run-node0033"
                },
                "type": "Normal"
            }
        ],
        "kind": "EventList",
        "metadata": {
            "resourceVersion": "105074823"
        }
    }
}
```

GET https://dbprovider.hzh.sealos.run/api/pod/getPodLogs
{"podName":"test-db-postgresql-0","dbType":"postgresql","stream":true,"sinceTime":0,"previous":false}
content-type: text/event-stream;charset-utf-8

```TEXT
2025-02-24 03:16:00,490 - bootstrapping - INFO - Figuring out my environment (Google? AWS? Openstack? Local?)
2025-02-24 03:16:02,495 - bootstrapping - INFO - Could not connect to 169.254.169.254, assuming local Docker setup
2025-02-24 03:16:02,496 - bootstrapping - INFO - No meta-data available for this provider
2025-02-24 03:16:02,496 - bootstrapping - INFO - Looks like you are running local
2025-02-24 03:16:02,526 - bootstrapping - INFO - kubeblocks generate local configuration: 
bootstrap:
  dcs:
    check_timeline: true
```

https://dbprovider.hzh.sealos.run/api/monitor/getMonitorData?dbName=test-db&dbType=postgresql&queryKey=disk
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "result": {
            "xData": [
                1740367020,
                1740367080,
                1740367140,
                1740367200,
                1740367260,
                1740367320,
                1740367380,
                1740367440,
                1740367500,
                1740367560,
                1740367620,
                1740367680,
                1740367740,
                1740367800,
                1740367860,
                1740367920,
                1740367980,
                1740368040,
                1740368100,
                1740368160,
                1740368220,
                1740368280,
                1740368340,
                1740368400,
                1740368460,
                1740368520,
                1740368580,
                1740368640,
                1740368700,
                1740368760
            ],
            "yData": [
                {
                    "name": "data-test-db-postgresql-0",
                    "data": [
                        0.03,
                        1.47,
                        1.47,
                        1.47,
                        1.47,
                        1.47,
                        1.47,
                        1.48,
                        1.48,
                        1.48,
                        1.48,
                        1.48,
                        1.48,
                        1.49,
                        1.49,
                        1.49,
                        1.49,
                        1.49,
                        1.49,
                        1.49,
                        1.5,
                        1.5,
                        1.5,
                        1.5,
                        1.5,
                        1.5,
                        1.5,
                        1.51,
                        1.51,
                        1.51
                    ]
                },
                {
                    "name": "data-test-db-postgresql-1",
                    "data": [
                        1.47,
                        1.47,
                        2.02,
                        2.02,
                        2.02,
                        2.02,
                        2.03,
                        2.03,
                        2.03,
                        2.03,
                        2.03,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.04,
                        2.06,
                        2.06,
                        2.06
                    ]
                }
            ]
        }
    }
}
```

数据库用量监控
GET https://dbprovider.hzh.sealos.run/api/monitor/getDataBaseSize?dbName=test-db&dbType=postgresql
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "result": {
            "xData": [
                1740367080,
                1740367140,
                1740367200,
                1740367260,
                1740367320,
                1740367380,
                1740367440,
                1740367500,
                1740367560,
                1740367620,
                1740367680,
                1740367740,
                1740367800,
                1740367860,
                1740367920,
                1740367980,
                1740368040,
                1740368100,
                1740368160,
                1740368220,
                1740368280,
                1740368340,
                1740368460,
                1740368520,
                1740368580,
                1740368640,
                1740368700,
                1740368760
            ],
            "yData": [
                {
                    "name": "test-db-postgresql-1 | postgres",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | postgres",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | template0",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template0",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | template1",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template1",
                    "data": [
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01",
                        "0.01"
                    ]
                }
            ]
        }
    }
}
```
GET https://dbprovider.hzh.sealos.run/api/monitor/getRunningTime?dbName=test-db&dbType=postgresql
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "currentTime": "2/24/2025, 3:48:37 AM",
        "maxRunningTime": "1932.8980000019073"
    }
}

// 链接数
GET https://dbprovider.hzh.sealos.run/api/monitor/getCurrentConnections?dbName=test-db&dbType=postgresql
```JSON
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "result": {
            "xData": [
                1740367080,
                1740367140,
                1740367200,
                1740367260,
                1740367320,
                1740367380,
                1740367440,
                1740367500,
                1740367560,
                1740367620,
                1740367680,
                1740367740,
                1740367800,
                1740367860,
                1740367920,
                1740367980,
                1740368040,
                1740368100,
                1740368160,
                1740368220,
                1740368280,
                1740368340,
                1740368460,
                1740368520,
                1740368580,
                1740368640,
                1740368700,
                1740368760,
                1740368820,
                1740368880
            ],
            "yData": [
                {
                    "name": "test-db-postgresql-1 | template1",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template1",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | template0",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template0",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | postgres",
                    "data": [
                        "6",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7",
                        "7"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | postgres",
                    "data": [
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6",
                        "6"
                    ]
                }
            ]
        }
    }
}
```

活跃连接数

GET https://dbprovider.hzh.sealos.run/api/monitor/getActiveConnections?dbName=test-db&dbType=postgresql
```json
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": {
        "result": {
            "xData": [
                1740367080,
                1740367140,
                1740367200,
                1740367260,
                1740367320,
                1740367380,
                1740367440,
                1740367500,
                1740367560,
                1740367620,
                1740367680,
                1740367740,
                1740367800,
                1740367860,
                1740367920,
                1740367980,
                1740368040,
                1740368100,
                1740368160,
                1740368220,
                1740368280,
                1740368340,
                1740368460,
                1740368520,
                1740368580,
                1740368640,
                1740368700,
                1740368760,
                1740368820,
                1740368880
            ],
            "yData": [
                {
                    "name": "test-db-postgresql-1 | postgres",
                    "type": "line",
                    "data": [
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "2",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | postgres",
                    "type": "line",
                    "data": [
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1",
                        "1"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | template0",
                    "type": "line",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template0",
                    "type": "line",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-1 | template1",
                    "type": "line",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                },
                {
                    "name": "test-db-postgresql-0 | template1",
                    "type": "line",
                    "data": [
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0",
                        "0"
                    ]
                }
            ]
        }
    }
}
```


GET https://dbprovider.hzh.sealos.run/api/monitor/getTransactions?dbName=test-db&dbType=postgresql
```json

```


GET https://dbprovider.hzh.sealos.run/api/opsrequest/operationlog?name=test-db&dbType=postgresql

// 参数配置
GET https://dbprovider.hzh.sealos.run/api/getConfigByName?name=test-db&dbType=postgresql
```json
{
    "code": 200,
    "statusText": "",
    "message": "",
    "data": "\n\nlisten_addresses = '*'\nport = '5432'\narchive_command = '/bin/true'\narchive_mode = 'on'\nauto_explain.log_analyze = 'False'\nauto_explain.log_buffers = 'False'\nauto_explain.log_format = 'text'\nauto_explain.log_min_duration = '-1'\nauto_explain.log_nested_statements = 'False'\nauto_explain.log_timing = 'True'\nauto_explain.log_triggers = 'False'\nauto_explain.log_verbose = 'False'\nauto_explain.sample_rate = '1'\nautovacuum_analyze_scale_factor = '0.1'\nautovacuum_analyze_threshold = '50'\nautovacuum_freeze_max_age = '200000000'\nautovacuum_max_workers = '3'\nautovacuum_multixact_freeze_max_age = '400000000'\nautovacuum_naptime = '15s'\nautovacuum_vacuum_cost_delay = '2'\nautovacuum_vacuum_cost_limit = '200'\nautovacuum_vacuum_scale_factor = '0.05'\nautovacuum_vacuum_threshold = '50'\nautovacuum_work_mem = '131072kB'\nbackend_flush_after = '0'\nbackslash_quote = 'safe_encoding'\nbgwriter_delay = '200ms'\nbgwriter_flush_after = '64'\nbgwriter_lru_maxpages = '1000'\nbgwriter_lru_multiplier = '10.0'\nbytea_output = 'hex'\ncheck_function_bodies = 'True'\ncheckpoint_completion_target = '0.9'\ncheckpoint_flush_after = '32'\ncheckpoint_timeout = '15min'\ncheckpoint_warning = '30s'\nclient_min_messages = 'notice'\ncommit_siblings = '5'\nconstraint_exclusion = 'partition'\ncron.database_name = 'postgres'\ncron.log_statement = 'on'\ncron.max_running_jobs = '32'\ncursor_tuple_fraction = '0.1'\ndatestyle = 'ISO,YMD'\ndeadlock_timeout = '1000ms'\ndebug_pretty_print = 'True'\ndebug_print_parse = 'False'\ndebug_print_plan = 'False'\ndebug_print_rewritten = 'False'\ndefault_statistics_target = '100'\ndefault_transaction_deferrable = 'False'\ndefault_transaction_isolation = 'read committed'\neffective_cache_size = '512MB'\neffective_io_concurrency = '1'\nenable_bitmapscan = 'True'\nenable_gathermerge = 'True'\nenable_hashagg = 'True'\nenable_hashjoin = 'True'\nenable_indexonlyscan = 'True'\nenable_indexscan = 'True'\nenable_material = 'True'\nenable_mergejoin = 'True'\nenable_nestloop = 'True'\nenable_parallel_append = 'True'\nenable_parallel_hash = 'True'\nenable_partition_pruning = 'True'\nenable_partitionwise_aggregate = 'True'\nenable_partitionwise_join = 'True'\nenable_seqscan = 'True'\nenable_sort = 'True'\nenable_tidscan = 'True'\nescape_string_warning = 'True'\nextra_float_digits = '1'\nforce_parallel_mode = '0'\nfrom_collapse_limit = '8'\ngeqo = 'True'\ngeqo_effort = '5'\ngeqo_generations = '0'\ngeqo_pool_size = '0'\ngeqo_seed = '0'\nmaintenance_work_mem = '128MB'\ngeqo_selection_bias = '2'\ngeqo_threshold = '12'\ngin_fuzzy_search_limit = '0'\ngin_pending_list_limit = '4096kB'\nhot_standby_feedback = 'False'\nhuge_pages = 'try'\nidle_in_transaction_session_timeout = '3600000ms'\nindex_adviser.enable_log = 'on'\nindex_adviser.max_aggregation_column_count = '10'\nindex_adviser.max_candidate_index_count = '500'\nintervalstyle = 'postgres'\njoin_collapse_limit = '8'\nlc_monetary = 'C'\nlc_numeric = 'C'\nlc_time = 'C'\nlock_timeout = '0'\nlog_autovacuum_min_duration = '10000'\nlog_checkpoints = 'True'\nlog_connections = 'False'\nlog_disconnections = 'False'\nlog_duration = 'False'\nlog_executor_stats = 'False'\nlog_timezone = 'Asia/Shanghai'\nlog_rotation_age = '1d'\nlog_rotation_size = '100MB'\nlog_truncate_on_rotation = true\nlog_destination = 'csvlog'\nlog_filename = 'postgresql-%Y-%m-%d-%H-%M-%S'\nlog_min_duration_statement = '1000'\nlog_parser_stats = 'False'\nlog_planner_stats = 'False'\nlog_replication_commands = 'False'\nlog_statement = 'ddl'\nlog_statement_stats = 'False'\nlog_temp_files = '128kB'\nlog_transaction_sample_rate = '0'\nmax_connections = '112'\nmax_files_per_process = '1000'\nmax_logical_replication_workers = '32'\nmax_locks_per_transaction = '64'\nmax_parallel_maintenance_workers = '2'\nmax_parallel_workers = '8'\nmax_parallel_workers_per_gather = '2'\nmax_pred_locks_per_page = '2'\nmax_pred_locks_per_relation = '-2'\nmax_pred_locks_per_transaction = '64'\nmax_prepared_transactions = '100'\nmax_replication_slots = '16'\nmax_stack_depth = '2MB'\nmax_standby_archive_delay = '300000ms'\nmax_standby_streaming_delay = '300000ms'\nmax_sync_workers_per_subscription = '2'\nmax_wal_senders = '64'\nmax_worker_processes = '8'\nmin_parallel_index_scan_size = '512kB'\nmin_parallel_table_scan_size = '8MB'\n\nmax_wal_size = '256MB'\nmin_wal_size = '64MB'\n\nold_snapshot_threshold = '-1'\nparallel_leader_participation = 'True'\npassword_encryption = 'md5'\npg_stat_statements.max = '5000'\npg_stat_statements.save = 'False'\npg_stat_statements.track = 'top'\npg_stat_statements.track_utility = 'False'\npgaudit.log_catalog = 'False'\npgaudit.log_level = 'warning'\npgaudit.log_client = 'False'\npgaudit.log_parameter = 'False'\npgaudit.log_relation = 'False'\npgaudit.log_statement_once = 'False'\npgaudit.log = 'ddl,read,write'\npglogical.batch_inserts = 'True'\npglogical.conflict_log_level = 'log'\npglogical.conflict_resolution = 'apply_remote'\npglogical.synchronous_commit = 'False'\npglogical.use_spi = 'False'\nplan_cache_mode = 'auto'\nquote_all_identifiers = 'False'\nrandom_page_cost = '1.1'\nrow_security = 'True'\nsession_replication_role = 'origin'\nsql_firewall.firewall = 'disable'\nshared_buffers = '256MB'\nshared_preload_libraries = 'pg_stat_statements,auto_explain,bg_mon,pgextwlist,pg_auth_mon,set_user,pg_cron,pg_stat_kcache,timescaledb,pgaudit'\nssl_min_protocol_version = 'TLSv1'\nstandard_conforming_strings = 'True'\nstatement_timeout = '0'\nsuperuser_reserved_connections = '20'\nsynchronize_seqscans = 'True'\nsynchronous_commit = 'on'\ntcp_keepalives_count = '10'\ntcp_keepalives_idle = '45s'\ntcp_keepalives_interval = '10s'\ntemp_buffers = '8MB'\ntemp_file_limit = '1048576kB'\ntrack_activity_query_size = '4096'\ntrack_commit_timestamp = 'False'\ntrack_functions = 'pl'\ntrack_io_timing = 'True'\ntransform_null_equals = 'False'\nvacuum_cost_delay = '0'\nvacuum_cost_limit = '10000'\nvacuum_cost_page_dirty = '20'\nvacuum_cost_page_hit = '1'\nvacuum_cost_page_miss = '2'\nvacuum_defer_cleanup_age = '0'\nvacuum_freeze_min_age = '50000000'\nvacuum_freeze_table_age = '200000000'\nvacuum_multixact_freeze_min_age = '5000000'\nvacuum_multixact_freeze_table_age = '200000000'\nwal_buffers = '16MB'\nwal_compression = 'True'\nwal_init_zero = off\nwal_level = 'replica'\nwal_log_hints = 'False'\nwal_receiver_status_interval = '1s'\nwal_receiver_timeout = '60000'\nwal_sender_timeout = '60000'\nwal_writer_delay = '200ms'\nwal_writer_flush_after = '1MB'\nwork_mem = '4096kB'\nxmlbinary = 'base64'\nxmloption = 'content'\n\n\nautovacuum_vacuum_insert_scale_factor = '0.2'\nautovacuum_vacuum_insert_threshold = '1000'\nclient_connection_check_interval = '0'\ncompute_query_id = 'auto'\ndefault_toast_compression = 'pglz'\nenable_async_append = 'True'\nenable_incremental_sort = 'True'\nenable_memoize = 'True'\nhash_mem_multiplier = '1'\nidle_session_timeout = '0'\nlog_min_duration_sample = '-1'\nlog_parameter_max_length = '-1'\nlog_parameter_max_length_on_error = '0'\nlog_recovery_conflict_waits = 'False'\nlog_statement_sample_rate = '1.0'\nlogical_decoding_work_mem = '65536'\nmaintenance_io_concurrency = '0'\nmax_slot_wal_keep_size = '-1'\nmin_dynamic_shared_memory = '0'\nremove_temp_files_after_crash = 'on'\ntrack_wal_io_timing = 'False'\nvacuum_failsafe_age = '1600000000'\nvacuum_multixact_failsafe_age = '1600000000'\nwal_keep_size = '0'\nwal_skip_threshold = '2048'"
}
```
