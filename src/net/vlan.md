# 概述

802.1Q Tag包含4个字段, 4个字节：

- TPID(tag protocol identifier 标签协议标识符，2bytes)： 表示数据帧类型，0x8100为vlan包。
- PRI(priority 3bits): 0-7，数据包的优先级，数字越大级别越高。
- CFI(Cannocial Format Indicator, 标准格式指示位， 1bit)： 用于兼容以太网和令牌网， 表示MAC地址在不同的传输介质中是否以标准格式封装，0为标准格式，1为非标准格式。以太网中为0.
- VID(Vlan ID, 12bit): 0-4095,0和4095保留。