



Storage Buffers

var<storage> s: T
var<storage, read> s: T
var<storage, read_write> s: T
var<storage> arr: array<f32>

@location(0) 属性标记了该函数返回的 vec4 值将存储在第一个颜色附件（Color Attachment）中。仅应用于入口点函数参数、入口点返回类型或结构（structure）类型的成员。只能应用于数值标量（numeric scalar）或数值向量（numeric vector）类型的声明。不得与计算（compute）着色器阶段一起使用。指定入口点的用户定义IO的一部分。见§ 9.3.1.3 输入输出位置。


## 内置值 built-in

| 名称        |      阶段 |   输入或输出 | 类型 |         描述 |
| ------------ | ------- | ----------- | ---- | ----------- |
| vertex_index | vertex  | input       | u32  | 当前 API 级绘制命令中当前顶点的索引，与绘制实例无关。对于非索引绘制，第一个顶点的索引等于绘制的 firstVertex 参数，无论是直接提供还是间接提供。 绘制实例中每增加一个顶点，索引就会增加 1。对于索引绘制，索引等于顶点的索引缓冲区条目，加上绘制的 baseVertex 参数，无论是直接提供还是间接提供。| 
