# 数据结构

每个smmu都有一个结构体struct arm_smmu_device来管理
acpi_iort_node 
acpi_iort_smmu 

## 管理过程

初始化：

drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c


static int arm_smmu_device_probe(struct platform_device *pdev)
    arm_smmu_device_dt_probe 和 arm_smmu_device_acpi_probe 从dts中的smmu节点和acpi的smmu配置表中读取一些smmu中断等等属性
    
    #iommu-cells
    ARM_SMMU_FEAT_COHERENCY
    ARM_SMMU_FEAT_COHERENT_WALK

    platform_get_resource 来从dts或者apci表中读取smmu的寄存器的基地址
    要读取smmu的几个中断号，smmu 硬件给软件消息有队列buffer，smmu硬件通过中断的方式让smmu驱动从队列buffer中取消息

    - 第一个eventq中断，smmu的一个队列叫event队列，这个队列是给挂在smmu上的platform设备用的，当platform设备使用smmu翻译dma 的iova的时候，如果发生了一场smmu会首先将异常的消息填到event队列中，随后上报一个eventq的中断给 smmu 驱动，smmu驱动接到这个中断后，开始执行中断处理程序，从event队列中将异常的消息读出来，显示异常；

    - 另外一个priq中断时给pri队列用的，这个队列是专门给挂在smmu上的pcie类型的设备用的，具体的流程其实是和event队列是一样的，这里不多解释了；

    - 最后一个是gerror中断，如果smmu 在执行过程中，发生了不可恢复的严重错误，smmu会报告一个gerror中断给smmu驱动，就不需要队列了，因为本身严重错误了，直接中断上来处理了

    arm_smmu_init_structures