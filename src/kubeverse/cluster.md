
资源池装配比Top5
/verse-apis/v1/portal/poolAssembleTop?clusterId=4a604bb5-aca5-41f4-be64-62042373c59d&kind=cpu
```json
{
    "code": 200,
    "message": "success",
    "data": [
        {
            "name": "master资源池(master-pool)",
            "hard": 470.62,
            "used": 132.18,
            "rate": 28.09
        }
    ]
}
```

企业空间装配比 TOP5
/verse-apis/v1/portal/workspaceAssembleTop?clusterId=4a604bb5-aca5-41f4-be64-62042373c59d&kind=cpu
```json
{"code":200,"message":"success","data":null}
```

集群列表
/verse-apis/v1/portal/clusters?keyword=&page=1&pageSize=100
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "items": [
            {
                "clusterId": "4a604bb5-aca5-41f4-be64-62042373c59d",
                "role": "manager",
                "clusterType": "kube",
                "k8sVersion": "v1.22.23",
                "deploymentArchitecture": "multiple",
                "kubeVersion": "v1.7.0",
                "state": "ready",
                "name": "管理集群",
                "createBy": "admin",
                "createAt": "2025-06-09T15:31:29.169489882+08:00",
                "statisticsAt": "2025-09-18T11:30:58.157160036+08:00",
                "userCount": 5,
                "workspaceCount": 0,
                "namespaceCount": 20,
                "resourcePoolCount": 1,
                "nodeCount": {
                    "total": 3,
                    "ready": 3
                },
                "podCount": {
                    "total": 186,
                    "running": 157,
                    "terminating": 4,
                    "other": 25
                },
                "alertCount": {
                    "total": 1,
                    "business": 1
                },
                "cpuUsed": 27.33,
                "cpuAllocated": 0,
                "cpuAssembled": 132.18,
                "cpuCapacity": 192,
                "cpuAllocatable": 470.62,
                "memUsed": 231.89,
                "memAllocated": 0,
                "memAssembled": 130.56,
                "memCapacity": 376.44,
                "memAllocatable": 325.44,
                "storageAllocated": 0,
                "storageAssembled": 1030,
                "storageAllocatable": -1,
                "conditions": [
                    {
                        "type": "Ready",
                        "status": "True",
                        "lastTransitionTime": "2025-09-08T13:59:45.687885174+08:00",
                        "reason": "ClusterReady",
                        "message": "cluster is ready status"
                    }
                ],
                "cniPlugin": "kube-nvs",
                "networkMode": "standard",
                "nodeNameType": "hostname"
            }
        ],
        "count": 1
    }
}
```

全局参数

/verse-apis/v1/portal/cluster/globalConfig/4a604bb5-aca5-41f4-be64-62042373c59d
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "disabledHostNetwork": false,  // 拦截配置
        "disabledHostPath": true, 
        "disabledNodePort": false,
        "defaultOverSoldRatio": 1,
        "downtime": 5,
        "nodeReserveCpu": 1,
        "nodeReserveMem": 2
    }
}
```