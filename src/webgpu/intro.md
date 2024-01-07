

# 概念

## 纹理(GPUTexture)与纹理视图(GPUTextureView)

GPUTexture 是比较原始的、用于存储纹理图像数据的类。GPUTexture 是通过 GPUDevice 实例的 .createTexture() 方法来创建的。

线性插值：线性插值是指插值函数为一次多项式的插值方式，其在插值节点上的插值误差为零。简单来说就是假设有一个三角形，知道这个三角形三个顶点的颜色，然后根据线性插值得到该三角形内任意位置的颜色，使得整个三角形颜色看上去平滑过渡。

双线性插值(Bilinear)：双线性插值又被称为 双线性内插，所谓双线性就是在两个方向分别进行一次线性插值。

锯齿感：小纹理渲染大面会遇到的问题，双线性插值在图形学中用来计算贴图点非整数情况下如何得到对应的纹理像素的一种算法，换句说就是如何让一张比较小的纹理去渲染一个比较大的面，希望减少像素颗粒感(锯齿)，让渲染结果更加平滑。Bicubic(双三次插值)：更加平滑，计算量也更大，它是取周围 16 个像素，第 1 次先以 4 个像素为一组分别做三次插值(是三次插值而非线性插值)，然后再将 4 个结果再做一次三次插值，最终得到一个像素的结果。Nearest(就近取值)：四舍五入取整，计算量最小，但渲染结果不平滑，像素感(锯齿)比较重。

摩尔纹：大纹理渲染小面会遇到的问题，假设纹理比较大，而需要渲染的面比较小，是否得到的渲染结果就会比较清晰？事情并不是想象的那个样子。如果使用点采样模型(Point sampled)最终结果恰恰是 “走样”：无论近处还是远处都会有很强烈的锯齿感。通常会采用 mipmap。



mipmap 核心思想为：近似的正方形范围查询。

1. 假设有一个纹理贴图宽高均为 256，我们将这个纹理贴图作为第 1 个层级
2. 我们将第 1 级纹理贴图的宽高都缩小一半，得到一个宽高为 128 的纹理贴图作为第 2 个层级
3. 然后再将第 2 级纹理的宽高再次缩小一半，得到一个宽高为 64 的纹理贴图作为第 3 个层级
4. ...
5. 当第 N 个层级时纹理宽高为 1
6. 至此我们的这个纹理贴图 一共有 N 个层级，尽管每个层级的贴图大小不同，但是他们的宽高比却完全相同
7. 假设有一个 3D 物体需要应用这个纹理，那么渲染器会根据实际情况进行匹配：
   1. 当这个被渲染的 3D 物体距离镜头足够近的时候，使用第 1 个层级的纹理贴图。
   2. 当被渲染的 3D 物体距离镜头稍远时，使用第 2 个层级的纹理贴图
   3. 当被渲染的 3D 物体距离镜头更远时，使用第 3 个层级的纹理贴图
   4. ...
8. 结论：根据实际渲染需要(先计算出渲染目标结果的大小)，来使用不同层级上、不同尺寸的纹理贴图，减少采样工作量，同时避免出现摩尔纹。
9. 补充：计算并存储 N 个层级上所有的数据会占用一定的存储空间(内存)，但是这种策略却可以带来渲染时的性能提升，实际上相当于用空间换时间。N 个层级上所有数据 = 1 + ( 1/4 + 1/8 + 1/16 ... ) ≈ 4/3，也就是说采用 mipmap 这种策略所需额外多存储的纹理数据仅为之前的 1/3。

在计算机视觉 或 图形学中会将这种策略称为：图像金字塔

## 采样器(GPUSampler)

采样器(GPUSampler)包含纹理寻址和纹理过滤，通过它们来决定以哪种缩放形式将纹理应用到模型表面渲染中。


简单来说：

GPUTexture：纹理，以某种格式存储具体的纹理数据
GPUTextureView：纹理视图，可访问纹理数据(GPUTexture)
GPUSampler：采样器，决定以哪种缩放形式来得到具体的纹素(texel)


采样器(Sampler)
采样器主要包含：纹理UV寻址、纹理过滤(分类与方式)

采样器可用于顶点着色器和片元着色器。

顶点着色器和片元着色器属于图形学中基础的知识点，如果你不理解可自己查阅相关资料。

用最简单的话来说(或许不精准)，顶点着色器负责渲染模型顶点的，而片元着色器负责渲染模型 面 。

模型的顶点位置和其他信息(例如颜色、透明度、法线等)决定了 “模型的面” 的最终的样子。


纹理UV寻址：

wrap：重复模式，当 UV 坐标超出 0-1 范围后，回到纹理的起始位置并重新开始计算
mirror：镜像模式，当 UV 坐标超出 0-1 范围后，沿纹理结束位置反方向回到起始位置
clamp：钳位模式，当 UV 坐标超出 0-1 范围后，将结束位置的最后一个纹素作为剩余的纹素
border：边框模式，当 UV 坐标超出 0-1 范围后，将某个固定颜色作为剩余的纹素

纹理过滤分类：

minFilter：缩小过滤器，当样本足迹小于或等于 1 纹素时的采样方式

magFilter：放大过滤器，当样本足迹大于 1 纹素时的采样方式

mipmap：图层金字塔过滤器，指定在两个 mipmap 级别之间进行的采样方式

纹理过滤方式：

nearest：邻近取值
linear：线性插值
bilinear：双线性插值
bicubic：双三次插值


## 着色器

顶点（Vertex）： 是三维（或二维）空间中的一个点，顶点经过光栅化（rasterization）后流转到片元着色阶段
片元（Fragment）： 片元着色器决定了片元的颜色，片元的输出是存储到 Color Attachment 的纹素上
计算（Compute）着色器


## 颜色附件（Color Attachment）

## 坐标系

裁剪坐标系

## 渲染管线 GPURenderPipeline

一个GPURenderPipeline是一种管线，用于控制顶点和片段着色器阶段： 

渲染 管线 输入包括：
1. 绑定(bindings)，根据给定的`GPUPipelineLayout`进行
2. 顶点和索引缓冲区，由`GPUVertexState`描述
3. 颜色附件，由`GPUColorTargetState`描述
4. 可选的深度模板附件，由`GPUDepthStencilState`描述

渲染 管线 输出包括：
1. 具有“storage”类型的buffer绑定
2. 具有“write-only”访问权限的storageTexture绑定
3. 颜色附件，由GPUColorTargetState描述
4. 可选的深度模板附件，由GPUDepthStencilState描述

渲染 管线 包括以下渲染阶段：
1. 顶点获取，由GPUVertexState.buffers控制
2. 顶点着色器，由GPUVertexState控制
3. 图元装配，由GPUPrimitiveState控制
4. 栅格化，由GPUPrimitiveState，GPUDepthStencilState和GPUMultisampleState控制
5. 片段着色器，由GPUFragmentState控制
6. 模板测试及操作，由GPUDepthStencilState控制
7. 深度测试及写操作，由GPUDepthStencilState控制
8. 输出合并，由GPUFragmentState.targets控制


### 图元状态 GPUPrimitiveState

```
dictionary GPUPrimitiveState {
    GPUPrimitiveTopology topology = "triangle-list";
    GPUIndexFormat stripIndexFormat;
    GPUFrontFace frontFace = "ccw";
    GPUCullMode cullMode = "none";

    // Requires "depth-clip-control" feature.
    boolean unclippedDepth = false;
};
```

GPUPrimitiveTopology: 原始类型绘制调用
- "point-list": 每个顶点定义一个点基元。
- "line-list": 每对连续的两个顶点定义一个线基元。
- "line-strip": 每对连续的两个顶点定义一个线图元。第一个顶点之后的每个顶点定义它和前一个顶点之间的线图元。
- "triangle-list": 三个顶点的每个连续三元组定义一个三角形基元。
- "triangle-strip": 前两个顶点之后的每个顶点在它和前两个顶点之间定义一个三角形基元。

GPUFrontFace 定义哪些多边形被 GPURenderPipeline 视为 front-facing。
- "ccw": 顶点的帧缓冲区坐标按逆时针顺序给出的多边形被认为是 front-facing，逆时针朝前，指向屏幕外。
- "cw": 顶点的帧缓冲区坐标按顺时针顺序给出的多边形被认为是 front-facing。

根据 GPUCullMode 进行绘制调用剔除cull, 这个三角形的顶点有效，对point和line无效：
- "none"： 所有多边形都通过此测试。
- "front"： front-facing 多边形被丢弃，并且不在渲染管线的后续阶段中处理。
- "back"： back-facing 多边形被丢弃。


unclippedDepth： depth clipping

### 深度/模板缓冲区

```
dictionary GPUDepthStencilState {
    required GPUTextureFormat format;

    required boolean depthWriteEnabled;
    required GPUCompareFunction depthCompare;

    GPUStencilFaceState stencilFront = {};
    GPUStencilFaceState stencilBack = {};

    GPUStencilValue stencilReadMask = 0xFFFFFFFF;
    GPUStencilValue stencilWriteMask = 0xFFFFFFFF;

    GPUDepthBias depthBias = 0;
    float depthBiasSlopeScale = 0;
    float depthBiasClamp = 0;
};
```

### 多样本状态

```
dictionary GPUMultisampleState {
    GPUSize32 count = 1;
    GPUSampleMask mask = 0xFFFFFFFF;
    boolean alphaToCoverageEnabled = false;
};
```

count 确定管线将使用多少个采样, 每像素的样本数量。
mask 指定哪些采样应处于活动状态。
alpha_to_coverage_enabled 与抗锯齿有关。

## 渲染编码器

### 颜色附件 GPURenderPassColorAttachment

```
dictionary GPURenderPassColorAttachment {
    required GPUTextureView view;
    GPUTextureView resolveTarget;
    GPUColor clearValue;
    required GPULoadOp loadOp;
    required GPUStoreOp storeOp;
};
```

- view, of type GPUTextureView:  描述将为此颜色附件输出到的纹理子资源的GPUTextureView 。
- resolveTarget, of type GPUTextureView: 描述纹理子资源的GPUTextureView ，如果view是多采样的，该纹理子资源将接收此颜色附件的解析输出。
- clearValue, of type GPUColor: 指示在执行渲染过程之前要清除view 的值。 如果未 provided，则默认为 {r: 0, g: 0, b: 0, a: 0}。如果 loadOp 未 "clear"，则忽略。clearValue的组成部分都是双值。 它们将转换为。 与渲染附件匹配的纹理格式的texel值 ， 如果转换失败，将生成验证错误。
- loadOp, of type GPULoadOp: 指示在执行渲染过程之前要对 view 执行的加载操作。注意：建议首选清除；有关详细信息，请参见 "clear" 。
- storeOp, of type GPUStoreOp: 在执行渲染过程之后要对 view 执行的存储操作。


## 缓冲区 GPUBuffer

GPUBuffer 表示可用于 GPU 操作的内存块。 数据以线性布局存储，这意味着分配的每个字节都可以通过它从 GPUBuffer 开始的偏移量来寻址，取决于操作的对齐限制。 一些 GPUBuffers 可以被映射，这使得内存块可以通过称为其映射的 ArrayBuffer 访问。

```
interface GPUBuffer {
    readonly attribute GPUSize64 size;
    readonly attribute GPUBufferUsageFlags usage;
    readonly attribute GPUBufferMapState mapState;
    Promise<undefined> mapAsync(GPUMapModeFlags mode, optional GPUSize64 offset = 0, optional GPUSize64 size);
    ArrayBuffer getMappedRange(optional GPUSize64 offset = 0, optional GPUSize64 size);
    undefined unmap();
    undefined destroy();
};
```

- size, of type GPUSize64： 缓冲大小，以字节为单位。
- usage, of type GPUBufferUsageFlags： 缓冲的可用用途。
- mappedAtCreation, of type boolean, defaulting to false： 如果 true 以已映射状态创建缓冲区，则允许立即调用 getMappedRange()。 即使 usage 不包含 MAP_READ 或 MAP_WRITE，将 mappedAtCreation 设置为“true”也是有效的。 这可用于设置缓冲区的初始数据。保证即使缓冲区创建最终失败，在取消映射之前，它仍然会显示为可以写入/读取映射范围。