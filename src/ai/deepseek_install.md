
# 规划

- 集群节点：8 个节点
- 模型：DeepSeek r1 671B
- 网络：低延迟、高带宽网络，网络带宽 400G 以上（建议购买专业的网络设备）
- GPU 资源：每个节点配置至少 8 张 A100 40GB GPU（或根据实际需求使用其他适合大模型的 GPU）
- 存储：SSD 存储，用于存放模型文件和缓存

## 需求

DeepSeek模型对显存（VRAM）的需求

DeepSeek模型的规模越大，显存需求就越高。从1.5B到671B，显存需求增长是指数级的。以下是各版本的参数规模与显存需求：

模型名称	参数量（B）	最低显存需求（GB）
DeepSeek-R1-Distill-Qwen-1.5B	1.5B	~3.9GB
DeepSeek-R1-Distill-Qwen-7B	7B	~18GB
DeepSeek-R1-Distill-Llama-8B	8B	~21GB
DeepSeek-R1-Distill-Qwen-14B	14B	~36GB
DeepSeek-R1-Distill-Qwen-32B	32B	~82GB
DeepSeek-R1-Distill-Llama-70B	70B	~181GB
DeepSeek-R1	671B	~1,543GB
对于小型AI推理，DeepSeek-R1-Distill-Qwen-1.5B 仅需几GB显存即可运行，但如果想驾驭DeepSeek-R1 671B，则至少需要超大算力支持，显存需求高达 1,543GB！

### ​计算资源
- ​GPU：至少8张NVIDIA A100 80GB或H100显卡（需支持多卡并行），显存总量需≥640GB。若使用消费级显卡，需16张RTX 4090 24GB（显存总量384GB）。
​- CPU：64核以上服务器级处理器（如Intel Xeon Gold 6430或AMD EPYC）。
​- 内存：512GB以上DDR5内存，推荐ECC校验。
​- 存储：1TB NVMe SSD用于模型加载，300GB以上硬盘空间存放模型文件。
​- 网络：2000W冗余电源，200Gbps InfiniBand网络支持分布式计算。

​能耗与散热
- 满血版推理功耗约3000W，需专业机房散热系统（液冷或风冷）。

### 操作系统与软件环境

操作系统

- ​推荐：Ubuntu 22.04 LTS（对CUDA和分布式计算支持最佳）。
- ​备选：CentOS 8或Rocky Linux 9（需手动配置驱动）。

​核心软件依赖

- ​CUDA：12.4以上版本，需匹配NVIDIA显卡驱动。
​- cuDNN：8.9.x及以上，用于深度学习加速。
​- Python：3.10或3.11，推荐使用Conda管理虚拟环境。

​推理框架：
- ​vLLM：支持分布式推理，吞吐量比Ollama高50%。
​- ktransformers：需源码编译，配合Flash Attention优化显存。
​
部署工具链

- ​Ollama：开源模型管理工具，支持一键加载量化模型。
​- Docker：用于容器化部署，推荐使用Open-WebUI交互界面。
​- TensorRT：将模型转换为FP8/INT8量化格式，显存占用降低30-50%。

### 概念介绍

vLLM是一个高效易用的大语言模型推理服务框架，vLLM支持包括通义千问在内的多种常见大语言模型。vLLM通过PagedAttention优化、动态批量推理（continuous batching）、模型量化等优化技术，可以取得较好的大语言模型推理效率。

管道并行（PP=2）将模型切分为两个阶段，每个阶段运行在一个GPU节点上。例如有一个模型M，我们可以将其切分为M1和 M2，M1在第一个GPU上处理输入，完成后将中间结果传递给 M2，M2在第二个GPU上进行后续操作。

张量并行（TP=8）在模型的每个阶段内（例如M1和 M2），将计算操作分配到8个GPU上进行。如在M1阶段，当输入数据传入时，这些数据将被分割为8份，并分别在8个GPU上同时处理。每个GPU处理一小部分数据，计算获取的结果然后合并。

BladeLLM加速部署（推荐）：BladeLLM是阿里云 PAI 自研的高性能推理框架。

SGLang加速部署（推荐）：SGLang是一个适用于大型语言模型和视觉语言模型的快速服务框架。

vLLM加速部署：vLLM是一个业界流行的用于LLM推理加速的库。

Transformers标准部署：不使用任何推理加速的标准部署。

## 拓扑结构

每个节点负责加载和运行模型的一部分，利用 模型并行性 和 数据并行性 以提高效率。

通信层：利用高速网络连接各个节点，确保模型和数据的同步。

1. 组件
- 主节点：协调所有节点工作，负责接收请求、分发任务，并返回推理结果。
- 工作节点：负责模型的实际推理计算，每个工作节点可以负载多个 tensor parallel 或 pipeline parallel 切分的模型部分。
- 负载均衡器：确保请求均匀地分配到各个节点。
- KV 缓存层：共享缓存存储，减少重复计算，提高响应速度。
- 监控系统：用于监控集群性能，可能包含 Prometheus 和 Grafana。

## 硬件差异

### 昇腾

驱动安装
```shell
cd Ascend-hdk-910b-npu_24.1.0_linux-aarch64/
./install.sh query
./Ascend-hdk-910b-npu-firmware_7.5.0.3.220.run --full
```

NPU网络：

在每个节点上配置NPU的网络信息，确保所有节点的IP不重复。以下以node01为例：
```shell
hccn_tool -i 0 -ip -s address "10.197.90.1.10" netmask 255.255.255.0
hccn_tool -i 0 -gateway -s gateway 10.197.90.254
hccn_tool -i 0 -tls -s enable 0

hccn_tool -i 1 -ip -s address "10.197.90.1.11" netmask 255.255.255.0
hccn_tool -i 1 -gateway -s gateway 10.197.90.254
hccn_tool -i 1 -tls -s enable 0

# 重复上述命令，配置所有NPU的网络信息
```
昇腾的镜像：
docker pull swr.cn-southwest-2.myhuaweicloud.com/ei-mindie/mindie:2.0.T3-800I-A2-py311-openeuler24.03-lts

昇腾的容器启动指令：

```shell
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
```

## vllm集群部署

### 安装

- 安装vllm `pip install vllm`
- 配置 vLLM 集群，编辑 vllm_config.yaml 文件，配置集群节点信息、模型路径、数据路径等参数。vllm_config.yaml 是用于配置 vLLM 引擎的 YAML 文件，它允许用户通过配置文件的方式灵活地设置 vLLM 的各项参数，从而优化大模型的推理性能和资源利用率。
- 启动 vLLM 集群：vllm start --config vllm_config.yaml

model: deepseek-r1-671b``tokenizer: deepseek-r1-671b``host: 0.0.0.0``port: 8000``api_keys: []``   ``# GPU 资源管理``gpu_memory_utilization: 0.85``max_num_seqs: 128``max_model_len: 4096``dtype: fp16``quantization: awq``   ``# 分布式设置``tensor_parallel_size: 8  # 在每个节点之间分配模型``worker_use_ray: true     # 使用 Ray 进行分布式任务调度``   ``# 缓存设置``enable_chunked_prefill: true``block_size: 32``   ``# 日志和监控``log_level: INFO``enable_prometheus: true


wget https://github.com/vllm-project/vllm/blob/main/examples/online_serving/run_cluster.sh

### 主节点
```shell
bash run_cluster.sh \
    vllm/vllm-openai:latest \
    172.16.0.102 \
    --head \
    /root/deepseekr1_32b/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B \
    -e VLLM_HOST_IP=172.16.0.102 \
    -e GLOO_SOCKET_IFNAME=eth0 \
    -e TP_SOCKET_IFNAME=eth0 &
```
- 172.16.0.102 监听的ip
- eth0 监听的网卡
简单来理解就是启动一个主节点(--head参数就是主节点)，然后把本地的模型挂载到了容器，并指定vLLM的监听的IP和IP对应的网卡名字。

### 从节点(*2)
```
bash run_cluster.sh \
    vllm/vllm-openai:latest \
    172.16.0.102 \
    --worker \
    /root/deepseekr1_32b/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B \
    -e VLLM_HOST_IP=172.16.0.43 \
    -e GLOO_SOCKET_IFNAME=eth0 \
    -e TP_SOCKET_IFNAME=eth0 &
```
这里就是启动了一个从节点(--worker),并指定主节点的ip地址是172.16.0.102。

### 状态检查

这里显示3个节点，总共6个GPU，显示以后就ray集群启动成功。

```text
(base) root@deepseek01 :~ # docker exec -it 9b9 bash 
root@deepseek01: /vllm-workspace# ray status 
============Autoscaler status: 2025-03-03 00:37: 43. 889101=========
Node status
Active: 
1 node_4379c450adba3cf4a41b7cf2ceea76966ad47410d6e90e7dd81c3ca6 
1 node_49ba62d1f324cf834526f27cd5f61f5bfa3d35303d487c61f2514354 
1 node_175d476d0cd7d16ac807cdac89032fc5c010b47529377704280d83948 
Pending : 
(no pending nodes) 
Recent failures : 
(no failures)
Resources
Usage : 
  0. 0/40.0 CPU 
  0. 0/5.0 GPU 
  0B/124. 65GiB memory 
  0B/28. 79GiB object_store_memory
Demands : 
  (no resource demands ) 
root@deepseek01: /vllm-workspace#

```

### 启动服务

在主节点的容器中
```shell
vllm serve \
  --model-path /root/.cache/huggingface/ \
  --tensor-parallel-size 2 \
  --pipeline-parallel-size 3 \
  --served-model-name "DeepSeek" \
  --host 0.0.0.0 \
  --gpumemoryutilization 0.95 \
  --trust-remote-code \
  --max-num-batched-tokens 8192 \
  --max-mode
  --port 8000 \l-len 16384 \
  --enable-reasoning \
  --reasoning-parser deepseekr1 \
  --enable-prefix-caching \
  --enable-chunked-prefill \
  --dtyp=half 
```

- /root/.cache/huggingface/：指定模型存储路径，其实就是我们启动容器的挂载进去的目录
- --tensor-parallel-size 2 设置张量并行度为2，这意味着模型将在两个GPU上分割运行。简单理解就是每个机器有几张卡就选多少。
- --pipeline-parallel-size 3 设置流水线并行度为3，模型将被分为三个阶段来执行。简单理解就是有几个机器都选多少。
- --served-model-name "DeepSeek"：设置服务暴露的模型名称为 “DeepSeek”。
- --host 0.0.0.0：设置服务监听所有的网络接口。
- --port 8000：设置服务端口为8000。
- --gpu_memory_utilization 0.95：设置GPU显存利用率阈值为95%。
- --trust-remote-code：允许执行模型自定义代码，这可能会带来安全风险。
- --max-num-batched-tokens 8192：设置单批次最大token数为8192。
- --max-model-len 16384：设置模型最大上下文长度为16384。
- --enable-reasoning：启用推理增强模式。
- --reasoning-parser deepseek_r1：指定推理解析器为 “deepseek_r1”。
- --enable-prefix-caching：激活前缀缓存优化。
- --enable-chunked-prefill：启用分块预填充。
- --dtype=half：使用半精度浮点数（FP16），这有助于减少显存使用并可能提高推理速度。


## 使用kuberay管理(在k8s上)

1. 安装KubeRay-Opertor

helm install kuberay-operator -n deepseek  --version 1.2.2  .

1.kubectl exec -it $( kubectl get pod -n deepseek | awk ' NR>1 {print $1}' | grep kuberay-head ) bash -n deepseek
2.vllm serve /model/deepseek-ai/DeepSeek-R1 \
        --tensor-parallel-size 16 \
        --gpu-memory-utilization 0.95 \
        --num-scheduler-steps 20 \
        --max-model-len 8192 \
        --trust-remote-code

模型加载时间至少40-50分钟。

## 管理工具

### OpenWebUI

部署： `docker run -d --name openwebui -p 3000:3000 -v openwebui-data:/app/data ghcr.io/open-webui/openwebui:main`

配置：

- 配置 OpenWebUI 连接 vLLM
- 打开 OpenWebUI 界面（默认 http://localhost:3000）。
- 进入 Settings（设置） → LLM Providers。
- 添加新的 API 端点：
- 名称（Name）： vLLM
- API 地址（Base URL）： http://127.0.0.1:8000/v1/
- 模型（Model）： deepseek-r1-671b



## 模型访问

### api

```python
from openai import OpenAI

openai_api_key = "EMPTY"
openai_api_base = "https://raycluster-kuberay-head-svc-x-deepseek-x-vcw2y2htee7r.sproxy.hd-01.alayanew.com:22443/v1"

client = OpenAI(
    api_key=openai_api_key,
    base_url=openai_api_base,
)

chat_response = client.chat.completions.create(
    model="/model/deepseek-ai/DeepSeek-R1",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "讲个笑话."},
    ],
    stream=True 
)
```

## SGLang 安装