
常见的表结构
1. NAME 名字 TYPE 备注
2. Part_no 母件代号 Char(24) 不能为空、重复，最大字符长度为24 位
3. Part_no1 子件代号 Char(24) 不能为空，最大字符长度为24 位
4. Yl_qty 用量 Numeric(8,4) 最长为8 位，小数点4 位，默认值为0
5. Bad_r 不良率 Numeric(7,4) 最长为7 位、小数点4 位，默认值为0
6. Stop 暂停 Char(1)
7. Locator 工序号 Char(2) 不能为空、默认值为‘N’，最大字符长度为2 位
8. No_pur1 暂停 Char(1) 默认值为‘N’
9. No_pur2 不发料 Char(1) 默认值为‘N’
10. Rem 位号 Varchar(250) 最长字符长度为250 位
11. Gg_person 更改人 Chan(20) 最大字符长度为20 位
12. Ecn_no ECN 单号 Char(12) 最大字符长度12

1. 物料管理
   1. 细致记录服务器所有组成部件，如CPU、内存、主板、硬盘、电源、散热设备、网络接口卡、机箱等，包括每种部件的品牌、型号、规格、数量等详细信息。
   2. 实现对部件库存量、采购周期、成本等数据的实时跟踪。
2. 结构化BOM结构
   1. 设计多层次的BOM结构，反映各部件之间的装配关系，如主板上安装哪些CPU，机箱内如何布局硬盘和电源等。
   2. 支持变型BOM，针对不同配置要求生成相应的服务器配置清单。
3. 集成性：系统应与ERP（企业资源规划）、MRP（物料需求计划）等其他内部系统无缝对接，确保从订单到生产、出库、采购的全流程协同。
4. 动态更新与版本控制：随着技术升级和产品迭代，允许BOM灵活变更，并且支持版本追踪，以便追溯历史配置和成本变化。
5. 自动化校验与优化：
   1. 在组装过程中，系统能够自动检查兼容性和完整性，比如避免不兼容的硬件组合或遗漏必要的配件。
   2. 根据库存、成本及性能要求等因素，进行最优配置建议或成本估算。
6. 工作流管理：包括组装流程定义、组装过程记录、质量检测报告的录入与审核等环节的管理工作流。
7. 报表与分析：提供丰富的报表工具，用于生成各类统计分析报告，帮助管理层决策，如成本分析、供应商绩效评估等。



结构化的物料清单（BOM）结构包含了以下核心信息：
1. 部件层次关系：每个部件在产品结构中的层级位置，通常表现为父子关系，顶层为成品，下级为各个子部件直至最小的基本零件。明确指示了部件间是如何组合起来形成最终产品的，例如，主板包含CPU、内存条等，而服务器整体则包含主板、电源供应器等多个子系统。
2. 部件编码： 各个部件都有唯一的标识符，如物料编码、零件号等，用于精确区分和检索。
3. 部件描述： 部件的具体信息，包括名称、品牌、型号、规格尺寸、材质、颜色等特征描述。
4. 用量信息： 对于每个部件，在最终产品中所需的数量，包括基本单位数和组装时可能需要的额外备品备件数量。 
5. 替代件信息：可能存在的替代部件列表，以及在何种情况下可以使用这些替代部件。
6. 成本信息： 部件的成本单价，以及在特定用量下的总成本。 
7. 供应商信息：提供该部件的供应商名称、联系方式以及交货周期等供应链相关信息。 
8. 工程更改通知（ECN）和版本控制：如果部件有过修改或升级，则记录其版本历史和对应的工程更改通知。
9. 生命周期状态：记录部件的生命周期状态，如是否处于有效、停产、替换状态等。
10. 工艺路线和装配顺序：描述部件在生产过程中的装配顺序和所需的操作步骤。

结构化BOM的设计有助于企业实现精准的物料需求计算、生产计划编制、成本核算以及产品质量追溯等功能。在L6级别服务器组装这类复杂项目中，BOM结构会更为细致和严谨，以满足高端定制化的需求和高效的生产线管理。

模型：
- 服务器（Server）
  |- 主板（Motherboard）
     |- 处理器（Processor/CPU）
     |- 内存模块（Memory Modules/RAM）
     |- 扩展槽（Expansion Slots）
        |- GPU（Graphics Processing Unit）
        |- RAID控制器（RAID Controller）
        |- 网络接口卡（NIC, Network Interface Card）
  |- 存储设备（Storage Devices）
     |- 硬盘驱动器（Hard Disk Drive, HDD）
     |- 固态硬盘（Solid State Drive, SSD）
     |- 光驱（Optical Drive）
  |- 电源供应单元（Power Supply Unit, PSU）
  |- 散热系统（Cooling System）
     |- 风扇（Fans）
     |- 散热片/热管（Heat Sink/Heat Pipes）
     |- 液冷系统（Liquid Cooling System，如果适用的话）
  |- 机箱（Chassis）
     |- 前面板接口（Front Panel Connectors）
     |- 机架固定装置（Rack Mount Kit）
  |- 附件（Accessories）
     |- 配线（Cables and Wires）
     |- 安装螺丝和其他紧固件（Screws and Other Fasteners）




    Component表（部件表）
        ComponentID (主键): 部件唯一标识
        Name: 部件名称
        Model: 部件型号
        Brand: 部件品牌
        Specification: 特性或规格描述
        Cost: 成本价格
        QuantityPerUnit: 单位用量
        SupplierID: 关联供应商表的外键
        LifecycleStatus: 生命周期状态（如：在产、停产、待淘汰）
        IsAlternativePart: 是否为替代部件

    Supplier表（供应商表）
        SupplierID (主键): 供应商唯一标识
        SupplierName: 供应商名称
        ContactInfo: 联系方式
        LeadTime: 交货周期

    Hierarchy表（层级关系表）
        ParentComponentID (外键): 父部件ID
        ChildComponentID (外键): 子部件ID
        Quantity: 子部件对应父部件的数量

    Inventory表（库存表）
        ComponentID (外键): 部件ID
        StockQuantity: 当前库存数量
        ReorderPoint: 安全库存点
        ReorderLevel: 补货点

    Compatibility表（兼容性表）
        MainComponentID: 主要部件ID
        CompatibleComponentID: 兼容部件ID
        CompatibilityDescription: 兼容性描述

    EngineeringChangeNotice表（工程变更通知表）
        ECNID: 工程变更通知唯一标识
        ComponentID: 受影响的部件ID
        ChangeDescription: 变更描述
        EffectiveDate: 生效日期

    QualityControl表（质量控制表）
        InspectionID: 检验记录ID
        ComponentID: 部件ID
        TestResult: 检测结果
        InspectionDate: 检验日期
