# 过程

1. 确定数据集 medical-o1-reasoning-SFT
2. 微调库： unsloth /LoRA监督微调
3. 基座模型： DeepSeek-R1-Distill-Llama-8B
4. colab在线： https://colab.research.google.com/drive/1wGenVWmCk-4if9cDtdkCSqZk-RqXs5SA#scrollTo=4icJQiOiFrYH&uniqifier=1

## 数据集准备

数据集来源，魔搭社区的 [medical-o1-reasoning-SFT](https://www.modelscope.cn/datasets/FreedomIntelligence/medical-o1-reasoning-SFT/summary)。

在 DeepSeek 的蒸馏模型微调过程中，数据集中引入 Complex_CoT（复杂思维链）是关键设计差异。若仅使用基础问答对进行训练，模型将难以充分习得深度推理能力，导致最终性能显著低于预期水平。这一特性与常规大模型微调的数据要求存在本质区别。

维度                               传统QA微调                   DeepSeek蒸馏微调
数据要素                           答案准确性                    推理可追溯性
梯度更新目标                        输出匹配度                   决策路径拟合度
有效训练阈值                        10^4 QA pairs               5x10^3 COT traces
性能衰减曲线                        线性下降                     指数级崩塌
失败表现                           精度降低                      逻辑混乱+事实矛盾










## referrence

[手把手教学，DeepSeek-R1微调全流程拆解](https://www.cnblogs.com/shanren/p/18707513)