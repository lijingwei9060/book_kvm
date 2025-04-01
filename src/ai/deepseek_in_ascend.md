# 昇腾910b多机部署deepseek-r1全攻略


环境准备
## 硬件配置
节点信息：
node01: 10.197.61.1, 8 NPU
node02: 10.197.61.2, 8 NPU
内存：773GB

操作系统: 操作系统可以是openeuler或者ubuntu,安装包环境基本一致

CULinux Enterprise Edition release 3.0 (Telegram)
部署步骤
1. 基础环境配置
在所有节点上执行以下命令，确保系统环境一致：

dnf update -y
dnf install -y bzip2 xz tar p7zip rsync gcc gcc-c++ make kernel-devel elfutils-libelf-devel net-tools docker-ce docker-ce-cli containerd.io
2. 安装昇腾910B驱动
进入驱动目录并安装驱动：

cd Ascend-hdk-910b-npu_24.1.0_linux-aarch64/
./install.sh query
./Ascend-hdk-910b-npu-firmware_7.5.0.3.220.run --full
安装完成后，重启机器：

reboot
3. 创建数据目录
在所有节点上创建数据目录：

mkdir /data
4. 配置NPU网络
在每个节点上配置NPU的网络信息，确保所有节点的IP不重复。以下以node01为例：

hccn_tool -i 0 -ip -s address "10.197.90.1.10" netmask 255.255.255.0
hccn_tool -i 0 -gateway -s gateway 10.197.90.254
hccn_tool -i 0 -tls -s enable 0

hccn_tool -i 1 -ip -s address "10.197.90.1.11" netmask 255.255.255.0
hccn_tool -i 1 -gateway -s gateway 10.197.90.254
hccn_tool -i 1 -tls -s enable 0

# 重复上述命令，配置所有NPU的网络信息
5. 下载并启动Docker镜像
下载DeepSeek-R1的Docker镜像：

docker pull swr.cn-southwest-2.myhuaweicloud.com/ei-mindie/mindie:2.0.T3-800I-A2-py311-openeuler24.03-lts
启动Docker容器：

docker run -itd --privileged --name=deepseek-r1 --net=host \
   --shm-size 500g \
   --device=/dev/davinci0 \
   --device=/dev/davinci1 \
   --device=/dev/davinci2 \
   --device=/dev/davinci3 \
   --device=/dev/davinci4 \
   --device=/dev/davinci5 \
   --device=/dev/davinci6 \
   --device=/dev/davinci7 \
   --device=/dev/davinci_manager \
   --device=/dev/hisi_hdc \
   --device /dev/devmm_svm \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/bin/hccn_tool:/usr/bin/hccn_tool \
    -v /usr/local/sbin:/usr/local/sbin \
    -v /usr/local/sbin/npu-smi:/usr/local/sbin/npu-smi \
     -v /usr/local/Ascend/driver:/usr/local/Ascend/driver \
     -v /usr/local/Ascend/firmware:/usr/local/Ascend/firmware \
     -v /etc/hccn.conf:/etc/hccn.conf \
     -v /var/log/npu/:/usr/slog \
     -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
     -v /data:/workspace \
     swr.cn-southwest-2.myhuaweicloud.com/ei-mindie/mindie:2.0.T3-800I-A2-py311-openeuler24.03-lts \
     bash
进入容器：

docker exec -it <container_id> bash
6. 配置环境变量
在容器内配置环境变量，确保每个节点的MIES_CONTAINER_IP设置为当前节点的IP：

source /usr/local/Ascend/ascend-toolkit/set_env.sh
source /usr/local/Ascend/nnal/atb/set_env.sh 
source /usr/local/Ascend/atb-models/set_env.sh  
export ATB_LLM_HCCL_ENABLE=1
export ATB_LLM_COMM_BACKEND="hccl"
export HCCL_CONNECT_TIMEOUT=7200
export HCCL_EXEC_TIMEOUT=0
export PYTORCH_NPU_ALLOC_CONF=expandable_segments:True
export MIES_CONTAINER_IP=10.197.61.1  # 根据节点修改
export RANKTABLEFILE=/workspace/rank_table.json
export OMP_NUM_THREADS=1
export NPU_MEMORY_FRACTION=0.95
7. 创建集群配置文件
在/data目录下创建rank_table.json文件，配置多机多卡的集群信息：

{
  "version": "1.0",
  "server_count": "2",
  "server_list": [
    {
      "server_id": "10.197.61.1",
      "container_ip": "10.197.61.1",
      "device": [
        {"device_id": "0","device_ip": "10.197.90.10","rank_id": "0"},
        {"device_id": "1","device_ip": "10.197.90.11","rank_id": "1"},
        {"device_id": "2","device_ip": "10.197.90.12","rank_id": "2"},
        {"device_id": "3","device_ip": "10.197.90.13","rank_id": "3"},
        {"device_id": "4","device_ip": "10.197.90.14","rank_id": "4"},
        {"device_id": "5","device_ip": "10.197.90.15","rank_id": "5"},
        {"device_id": "6","device_ip": "10.197.90.16","rank_id": "6"},
        {"device_id": "7","device_ip": "10.197.90.17","rank_id": "7"}
      ]
    },
    {
      "server_id": "10.197.61.2",
      "container_ip": "10.197.61.2",
      "device": [
        {"device_id": "0","device_ip": "10.197.90.20","rank_id": "8"},
        {"device_id": "1","device_ip": "10.197.90.21","rank_id": "9"},
        {"device_id": "2","device_ip": "10.197.90.22","rank_id": "10"},
        {"device_id": "3","device_ip": "10.197.90.23","rank_id": "11"},
        {"device_id": "4","device_ip": "10.197.90.24","rank_id": "12"},
        {"device_id": "5","device_ip": "10.197.90.25","rank_id": "13"},
        {"device_id": "6","device_ip": "10.197.90.26","rank_id": "14"},
        {"device_id": "7","device_ip": "10.197.90.27","rank_id": "15"}
      ]
    }
  ],
  "status": "completed"
}
8. 配置推理框架
在/data目录下创建config.json文件，配置推理框架的相关参数：

{
    "Version" : "1.0.0",
    "LogConfig" : {
        "logLevel" : "Info",
        "logFileSize" : 20,
        "logFileNum" : 20,
        "logPath" : "logs/mindie-server.log"
    },
    "ServerConfig" : {
        "ipAddress" : "10.197.61.1",
        "managementIpAddress" : "10.197.61.1",
        "port" : 1025,
        "managementPort" : 1026,
        "metricsPort" : 1027,
        "allowAllZeroIpListening" : false,
        "maxLinkNum" : 500,
        "httpsEnabled" : false,
        "fullTextEnabled" : false,
        "tlsCaPath" : "security/ca/",
        "tlsCaFile" : ["ca.pem"],
        "tlsCert" : "security/certs/server.pem",
        "tlsPk" : "security/keys/server.key.pem",
        "tlsPkPwd" : "security/pass/key_pwd.txt",
        "tlsCrlPath" : "security/certs/",
        "tlsCrlFiles" : ["server_crl.pem"],
        "managementTlsCaFile" : ["management_ca.pem"],
        "managementTlsCert" : "security/certs/management/server.pem",
        "managementTlsPk" : "security/keys/management/server.key.pem",
        "managementTlsPkPwd" : "security/pass/management/key_pwd.txt",
        "managementTlsCrlPath" : "security/management/certs/",
        "managementTlsCrlFiles" : ["server_crl.pem"],
        "kmcKsfMaster" : "tools/pmt/master/ksfa",
        "kmcKsfStandby" : "tools/pmt/standby/ksfb",
        "inferMode" : "standard",
        "interCommTLSEnabled" : false,
        "interCommPort" : 1121,
        "interCommTlsCaPath" : "security/grpc/ca/",
        "interCommTlsCaFiles" : ["ca.pem"],
        "interCommTlsCert" : "security/grpc/certs/server.pem",
        "interCommPk" : "security/grpc/keys/server.key.pem",
        "interCommPkPwd" : "security/grpc/pass/key_pwd.txt",
        "interCommTlsCrlPath" : "security/grpc/certs/",
        "interCommTlsCrlFiles" : ["server_crl.pem"],
        "openAiSupport" : "vllm"
    },
    "BackendConfig" : {
        "backendName" : "mindieservice_llm_engine",
        "modelInstanceNumber" : 1,
        "npuDeviceIds" : [[0,1,2,3,4,5,6,7]],
        "tokenizerProcessNumber" : 8,
        "multiNodesInferEnabled" : true,
        "multiNodesInferPort" : 1120,
        "interNodeTLSEnabled" : false,
        "interNodeTlsCaPath" : "security/grpc/ca/",
        "interNodeTlsCaFiles" : ["ca.pem"],
        "interNodeTlsCert" : "security/grpc/certs/server.pem",
        "interNodeTlsPk" : "security/grpc/keys/server.key.pem",
        "interNodeTlsPkPwd" : "security/grpc/pass/mindie_server_key_pwd.txt",
        "interNodeTlsCrlPath" : "security/grpc/certs/",
        "interNodeTlsCrlFiles" : ["server_crl.pem"],
        "interNodeKmcKsfMaster" : "tools/pmt/master/ksfa",
        "interNodeKmcKsfStandby" : "tools/pmt/standby/ksfb",
        "ModelDeployConfig" : {
            "maxSeqLen" : 32768,
            "maxInputTokenLen" : 32768,
            "truncation" : true,
            "ModelConfig" : [
                {
                    "modelInstanceType" : "Standard",
                    "modelName" : "deepseekr1",
                    "modelWeightPath" : "/workspace/deepseek-ai-r1-w8a8-mindie/",
                    "worldSize" : 8,
                    "cpuMemSize" : 5,
                    "npuMemSize" : -1,
                    "backendType" : "atb",
                    "trustRemoteCode" : false
                }
            ]
        },
        "ScheduleConfig" : {
            "templateType" : "Standard",
            "templateName" : "Standard_LLM",
            "cacheBlockSize" : 128,
            "maxPrefillBatchSize" : 8,
            "maxPrefillTokens" : 2048,
            "prefillTimeMsPerReq" : 150,
            "prefillPolicyType" : 0,
            "decodeTimeMsPerReq" : 50,
            "decodePolicyType" : 0,
            "maxBatchSize" : 8,
            "maxIterTimes" : 1024,
            "maxPreemptCount" : 0,
            "supportSelectBatch" : false,
            "maxQueueDelayMicroseconds" : 5000
        }
    }
}
将config.json文件覆盖到MindIE服务的配置目录：

cp /workspace/config.json /usr/local/Ascend/mindie/latest/mindie-service/conf/
9. 修复Tokenizer Bug
在启动服务之前，我们需要修复mies_tokenizer包中的一个Bug。以下是修复步骤：

查看mies_tokenizer包的位置：

pip show mies_tokenizer
输出示例：

Name: mies_tokenizer
Version: 0.0.1
Summary: ibis tokenizer
Location: /usr/local/lib/python3.11/site-packages
修改tokenizer.py文件：

使用vim编辑tokenizer.py文件：

vim /usr/local/lib/python3.11/site-packages/mies_tokenizer/tokenizer.py
找到以下代码并进行修改：

修改__del__方法：

def __del__(self):
    cache_path = getattr(self, 'cache_path', None)
    if cache_path is None:
        return
    dir_path = file_utils.standardize_path(cache_path)
    file_utils.check_path_permission(dir_path)
    all_request = os.listdir(dir_path)
修改_get_cache_base_path方法：

def _get_cache_base_path(child_dir_name):
    dir_path = os.getenv("LOCAL_CACHE_DIR", None)
    if dir_path is None:
        dir_path = os.path.expanduser("~/mindie/cache")
        os.makedirs(dir_path, exist_ok=True)
        os.chmod(dir_path, 0o750)
保存并退出编辑器。

10. 复制模型文件
将DeepSeek-R1模型文件复制到/data目录下，并确保目录名为deepseek-ai-r1-w8a8-mindie。

11. 启动服务
在所有节点上按照顺序启动服务：

nohup /usr/local/Ascend/mindie/latest/mindie-service/bin/mindieservice_daemon > /workspace/output.log 2>&1 &
最终资源消耗

[root@ebn0001 ~]# npu-smi info
+------------------------------------------------------------------------------------------------+
| npu-smi 24.1.0                   Version: 24.1.0                                               |
+---------------------------+---------------+----------------------------------------------------+
| NPU   Name                | Health        | Power(W)    Temp(C)           Hugepages-Usage(page)|
| Chip                      | Bus-Id        | AICore(%)   Memory-Usage(MB)  HBM-Usage(MB)        |
+===========================+===============+====================================================+
| 0     910B2               | OK            | 95.0        37                0    / 0             |
| 0                         | 0000:C1:00.0  | 0           0    / 0          62877/ 65536         |
+===========================+===============+====================================================+
| 1     910B2               | OK            | 88.4        36                0    / 0             |
| 0                         | 0000:C2:00.0  | 0           0    / 0          62879/ 65536         |
+===========================+===============+====================================================+
| 2     910B2               | OK            | 89.1        34                0    / 0             |
| 0                         | 0000:81:00.0  | 0           0    / 0          62876/ 65536         |
+===========================+===============+====================================================+
| 3     910B2               | OK            | 87.8        36                0    / 0             |
| 0                         | 0000:82:00.0  | 0           0    / 0          62878/ 65536         |
+===========================+===============+====================================================+
| 4     910B2               | OK            | 99.8        42                0    / 0             |
| 0                         | 0000:01:00.0  | 0           0    / 0          62876/ 65536         |
+===========================+===============+====================================================+
| 5     910B2               | OK            | 90.6        40                0    / 0             |
| 0                         | 0000:02:00.0  | 0           0    / 0          62878/ 65536         |
+===========================+===============+====================================================+
| 6     910B2               | OK            | 97.5        40                0    / 0             |
| 0                         | 0000:41:00.0  | 0           0    / 0          62877/ 65536         |
+===========================+===============+====================================================+
| 7     910B2               | OK            | 92.8        40                0    / 0             |
| 0                         | 0000:42:00.0  | 0           0    / 0          62878/ 65536         |
+===========================+===============+====================================================+
+---------------------------+---------------+----------------------------------------------------+
| NPU     Chip              | Process id    | Process name             | Process memory(MB)      |
+===========================+===============+====================================================+
| 0       0                 | 412122        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 1       0                 | 412124        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 2       0                 | 412126        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 3       0                 | 412128        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 4       0                 | 412140        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 5       0                 | 412147        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 6       0                 | 412154        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+
| 7       0                 | 412161        | mindie_llm_back          | 59539                   |
+===========================+===============+====================================================+


[root@ebn0001 ~]# free -m
               total        used        free      shared  buff/cache   available
Mem:          773683      359973       54194         457      359515      409456
Swap:              0           0           0
12. 测试接口
通过以下命令测试接口是否正常工作：

curl -X POST http://10.197.61.1:1025/v1/chat/completions \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{
  "model": "deepseekr1",
  "messages": [{
    "role": "user",
    "content": "你好"
  }],
  "max_tokens": 20,
  "top_p": 0.95
}'
总结
网上关于昇腾910B部署DeepSeek-R1的文档大多不够详细，导致很多同学在实际操作中踩坑。本文对细节做了补充，希望能帮助大家顺利完成部署，如果遇到问题，欢迎留言讨论~