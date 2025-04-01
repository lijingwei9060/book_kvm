
GET https://hzh.sealos.run/api/auth/regionList
```json
{
    "code": 200,
    "message": "Successfully",
    "data": {
        "regionList": [
            {
                "uid": "0dba3d90-2bae-4fb6-83f7-89620656574f",
                "displayName": "Beijing",
                "location": "beijing",
                "domain": "bja.sealos.run",
                "description": {
                    "prices": [
                        {
                            "name": "CPU",
                            "unit_price": 150.01,
                            "unit": "1m"
                        }
                    ],
                    "serial": "A",
                    "provider": "volcano_engine",
                    "description": {
                        "zh": "可节省 73% 的算力成本",
                        "en": "Can save 73% of computing power costs"
                    }
                }
            },
            {
                "uid": "2e07bb48-e88c-4bb8-b2c8-03198b8fe66d",
                "displayName": "Singapore",
                "location": "singapore",
                "domain": "cloud.sealos.io",
                "description": {
                    "prices": [
                        {
                            "name": "CPU",
                            "unit_price": 582.92,
                            "unit": "1m"
                        }
                    ],
                    "serial": "B",
                    "provider": "google_cloud",
                    "description": {
                        "zh": "适合海外业务，可节省 40% 算力成本",
                        "en": "Can save 40% of computing power costs."
                    }
                }
            },
            {
                "uid": "6a216614-e658-4482-a244-e4311390715f",
                "displayName": "Guangzhou",
                "location": "guangzhou",
                "domain": "gzg.sealos.run",
                "description": {
                    "prices": [
                        {
                            "name": "CPU",
                            "unit_price": 152.6,
                            "unit": "1m"
                        }
                    ],
                    "serial": "G",
                    "provider": "tencent_cloud",
                    "description": {
                        "zh": "可节省 63% 的算力成本",
                        "en": "Can save 63% of computing power costs."
                    }
                }
            },
            {
                "uid": "f8fe0f97-4550-472f-aa9a-72ed34e60952",
                "displayName": "Hangzhou",
                "location": "hangzhou",
                "domain": "hzh.sealos.run",
                "description": {
                    "prices": [
                        {
                            "name": "CPU",
                            "unit_price": 242.39,
                            "unit": "1m"
                        }
                    ],
                    "serial": "H",
                    "provider": "alibaba_cloud",
                    "description": {
                        "zh": "可节省 33% 的算力成本",
                        "en": "Can save 33% of computing power costs."
                    }
                }
            }
        ]
    }
}
```

个人空间列表

GET https://hzh.sealos.run/api/auth/namespace/list
```json
{
    "code": 200,
    "message": "Successfully",
    "data": {
        "namespaces": [
            {
                "id": "ns-p4v4vcc1",
                "uid": "d6d2c782-85d0-44e2-a37b-b84d0b35af09",
                "createTime": "2025-02-19T07:06:34.678Z",
                "nstype": 1,
                "teamName": "private team",
                "role": 0
            }
        ]
    }
}
```
个人空间详情

POST https://hzh.sealos.run/api/auth/namespace/details
{"ns_uid":"d6d2c782-85d0-44e2-a37b-b84d0b35af09"}
```json
{
    "code": 200,
    "message": "Successfully",
    "data": {
        "users": [
            {
                "uid": "64e712e7-82b8-4596-8e64-67dbbd2a6f8f",
                "crUid": "45faf06b-c5f5-4470-9414-e45c5c27dcbd",
                "k8s_username": "p4v4vcc1",
                "avatarUrl": "",
                "nickname": "18926145127",
                "createdTime": "Wed Feb 19 2025 07:06:34 GMT+0000 (Coordinated Universal Time)",
                "joinTime": "2025-02-19T07:06:34.685Z",
                "role": 0,
                "status": 1
            }
        ],
        "namespace": {
            "uid": "d6d2c782-85d0-44e2-a37b-b84d0b35af09",
            "id": "ns-p4v4vcc1",
            "role": 0,
            "createTime": "2025-02-19T07:06:34.678Z",
            "teamName": "private team",
            "nstype": 1
        }
    }
}
```
创建个人空间
POST https://hzh.sealos.run/api/auth/namespace/create
{"teamName":"共享2"}
```json
{
    "code": 200,
    "message": "Successfully",
    "data": {
        "namespace": {
            "role": 0,
            "createTime": "2025-02-24T02:49:24.675Z",
            "uid": "fa751274-9d7c-46a5-88ab-b25bd7143281",
            "id": "ns-j5tfksr9",
            "nstype": 0,
            "teamName": "共享2"
        }
    }
}
```