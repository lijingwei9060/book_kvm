

1. 已用资源

get https://hzh.sealos.run/api/desktop/getResource
{
    "code": 200,
    "message": "",
    "data": {
        "totalCpu": "0.00", // 已经使用CPU
        "totalMemory": "0.00", // 已经使用内存，GB
        "totalStorage": "0.00", //已用存储 GB
        "runningPodCount": 0,   // 运行中的POD
        "totalPodCount": 0,     // 总共POD
        "totalGpuCount": 0      // 总共GPU
    }
}
应该是账单
GET https://hzh.sealos.run/api/account/getAmount
{"code":200,"message":"","data":{"balance":10000000,"deductionBalance":28563}}


GET https://hzh.sealos.run/api/desktop/getBilling
{"code":200,"message":"","data":{"prevMonthTime":28563,"prevDayTime":0}}

GET https://hzh.sealos.run/api/desktop/getInstalledApps
```json
{
    "code": 200,
    "message": "",
    "data": [
        {
            "key": "system-aiproxy",
            "data": {
                "desc": "Sealos AI Proxy",
                "url": "https://aiproxy-web.hzh.sealos.run"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "AI Proxy"
                },
                "zh-Hans": {
                    "name": "AI Proxy"
                }
            },
            "icon": "https://aiproxy-web.hzh.sealos.run/favicon.svg",
            "name": "AI Proxy",
            "type": "iframe"
        },
        {
            "key": "system-applaunchpad",
            "data": {
                "desc": "App Launchpad",
                "url": "https://applaunchpad.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "应用管理"
                },
                "zh-Hans": {
                    "name": "应用管理"
                }
            },
            "icon": "https://applaunchpad.hzh.sealos.run:443/logo.svg",
            "name": "App Launchpad",
            "type": "iframe"
        },
        {
            "key": "system-costcenter",
            "data": {
                "desc": "sealos CLoud costcenter",
                "url": "https://costcenter.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "费用中心"
                },
                "zh-Hans": {
                    "name": "费用中心"
                }
            },
            "icon": "https://costcenter.hzh.sealos.run:443/logo.svg",
            "name": "Cost Center",
            "type": "iframe"
        },
        {
            "key": "system-cronjob",
            "data": {
                "desc": "CronJob",
                "url": "https://cronjob.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "定时任务"
                },
                "zh-Hans": {
                    "name": "定时任务"
                }
            },
            "icon": "https://cronjob.hzh.sealos.run:443/logo.svg",
            "name": "CronJob",
            "type": "iframe"
        },
        {
            "key": "system-dbprovider",
            "data": {
                "desc": "Database",
                "url": "https://dbprovider.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "数据库"
                },
                "zh-Hans": {
                    "name": "数据库"
                }
            },
            "icon": "https://dbprovider.hzh.sealos.run:443/logo.svg",
            "name": "Database",
            "type": "iframe"
        },
        {
            "key": "system-devbox",
            "data": {
                "desc": "Devbox",
                "url": "https://devbox.hzh.sealos.run"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "Devbox"
                },
                "zh-Hans": {
                    "name": "Devbox"
                }
            },
            "icon": "https://devbox.hzh.sealos.run/logo.svg",
            "name": "Devbox",
            "type": "iframe"
        },
        {
            "key": "system-kubepanel",
            "data": {
                "desc": "Kube Panel",
                "url": "https://kubepanel.hzh.sealos.run"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "KubePanel"
                },
                "zh-Hans": {
                    "name": "KubePanel"
                }
            },
            "icon": "https://objectstorageapi.cloud.sealos.top/resources/kubepanel.svg",
            "name": "Kube Panel",
            "type": "iframe"
        },
        {
            "key": "system-objectstorage",
            "data": {
                "desc": "object storage",
                "url": "https://objectstorage.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "对象存储"
                },
                "zh-Hans": {
                    "name": "对象存储"
                }
            },
            "icon": "https://objectstorage.hzh.sealos.run:443/logo.svg",
            "name": "Object Storage",
            "type": "iframe"
        },
        {
            "key": "system-sealaf",
            "data": {
                "desc": "Cloud development",
                "url": "https://sealaf.hzh.sealos.run"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "云开发"
                },
                "zh-Hans": {
                    "name": "云开发"
                }
            },
            "icon": "https://sealaf.hzh.sealos.run/favicon.ico",
            "name": "Function Service",
            "type": "iframe"
        },
        {
            "key": "system-sealos-document",
            "data": {
                "desc": "Sealos Documents",
                "url": "https://sealos.run/docs/5.0.0/Intro/"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "文档中心"
                },
                "zh-Hans": {
                    "name": "文档中心"
                }
            },
            "icon": "https://objectstorageapi.cloud.sealos.top/resources/document.svg",
            "name": "Sealos Document",
            "type": "iframe"
        },
        {
            "key": "system-template",
            "data": {
                "url": "https://template.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "应用商店"
                },
                "zh-Hans": {
                    "name": "应用商店"
                }
            },
            "icon": "https://template.hzh.sealos.run:443/logo.svg",
            "name": "App Store",
            "type": "iframe"
        },
        {
            "key": "system-terminal",
            "data": {
                "desc": "sealos CLoud Terminal",
                "url": "https://terminal.hzh.sealos.run:443"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "终端"
                },
                "zh-Hans": {
                    "name": "终端"
                }
            },
            "icon": "https://terminal.hzh.sealos.run:443/logo.svg",
            "name": "Terminal",
            "type": "iframe"
        },
        {
            "key": "system-workorder",
            "data": {
                "desc": "workorder",
                "url": "https://workorder.hzh.sealos.run"
            },
            "displayType": "normal",
            "i18n": {
                "zh": {
                    "name": "工单"
                },
                "zh-Hans": {
                    "name": "工单"
                }
            },
            "icon": "https://workorder.hzh.sealos.run/logo.svg",
            "name": "workorder",
            "type": "iframe"
        },
        {
            "key": "system-fastgpt",
            "data": {
                "url": "https://cloud.fastgpt.in"
            },
            "displayType": "more",
            "icon": "https://objectstorageapi.cloud.sealos.top/resources/fastgpt.svg",
            "name": "FastGPT",
            "type": "link"
        },
        {
            "key": "system-invite",
            "data": {
                "desc": "invite",
                "url": "https://invite.hzh.sealos.run"
            },
            "displayType": "more",
            "i18n": {
                "zh": {
                    "name": "邀请注册"
                }
            },
            "icon": "https://invite.hzh.sealos.run/logo.svg",
            "name": "invite",
            "type": "iframe"
        },
        {
            "key": "system-private-cloud",
            "data": {
                "desc": "Private Cloud",
                "url": "https://fael3z0zfze.feishu.cn/share/base/form/shrcnesSfEK65JZaAf2W6Fwz6Ad"
            },
            "displayType": "more",
            "i18n": {
                "zh": {
                    "name": "私有云"
                },
                "zh-Hans": {
                    "name": "私有云"
                }
            },
            "icon": "https://objectstorageapi.cloud.sealos.top/resources/private_cloud.svg",
            "name": "Private Cloud",
            "type": "link"
        }
    ]
}
```