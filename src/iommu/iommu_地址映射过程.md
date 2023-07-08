# 工作原理

# 工作过程

RTADDR_REG指向空间为基地址，然后利用Bus、Device、Func在Context Table中找到对应的Context Entry，即页表首地址，然后利用页表即可将设备请求的虚拟地址翻译成物理地址。