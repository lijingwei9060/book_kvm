# 概念

适配器（Adapter）是特定操作系统的 API 与 WebGPU 之间的中介，它将 WebGPU 与特定操作系统的 API 进行交互。

GPUDevice 设备是一个适配器逻辑上实例化的过程，通过它创建了内部对象（internal objects）。它可以在多个 agent 中共享（例如专用 Worker）。利用设备你可以在显存中创建缓存（Buffer）、纹理（Texture）、渲染管线（Pipeline）、着色器模块（Shader Module）等，对显示适配器中的设备进行具体操作。

着色器（Shaders）： 顶点着色器和片元（片段）着色器。顶点缓冲的每个顶点数据描述了顶点的位置，当然还包括颜色、纹理坐标、法线等其它辅助内容。每个顶点都要经过顶点着色器处理，以完成平移、旋转、透视变形等操作。

管线（Pipeline）： 渲染管线， 计算管线。渲染管线绘制某些东西，它结果是 2D 图像，这个图像不一定要绘制到屏幕上，可以直接渲染到内存中（被称作帧缓冲）。计算管线则更加通用，它返回的是一个缓冲数据对象，意味着可以输出任意数据。倘若未来向 WebGPU 中添加更多类型的管线，例如“光追管线”，就显得理所当然了。

使用 WebGPU API，管线由一个或多个可编程阶段组成，每个阶段由一个着色器模块和一个入口函数定义。计算管线拥有一个计算着色阶段，渲染管线有一个顶点着色阶段和一个片段着色阶段。


工作组（Workgroup）： GPU中的EU调度

指令（Command）： 指令队列，是一块内存（显示内存），编码了 GPU 待执行的指令。编码与 GPU 本身紧密相关，由显卡驱动负责创建。WebGPU 暴露了一个“CommandEncoder”API 来对接这个术语。
GPUCommandEncoder 指令编码器，它的作用是把你需要让 GPU 执行的指令写入到 GPU 的指令缓冲区（Command Buffer）中，例如我们要在渲染通道中输入顶点数据、设置背景颜色、绘制（draw call）等等，这些都是需要 GPU 执行的指令，所以在创建渲染通道之前，我们必须先创建一个指令编码器。


GPURenderPipeline： 渲染管线， 
GPURenderPipelineDescriptor ： 渲染管线描述符， 
GPUComputePipeline： 计算管线， 
GPUComputePipelineDescriptor： 计算管线描述符， 
GPURenderBundleEncoder： 渲染捆绑编码器， 
GPURenderBundleEncoderDescriptor： 渲染捆绑编码器描述符， 
GPURenderBundle： 渲染捆绑， 


从目前已知的 WebGPU 标准来看，和 WebGL 类似，在顶点着色器处理完成之后，WebGPU 将会神奇般的将这些由顶点数据描述的 3D 图形转换为 2D 图片，这个过程被称为“光栅化（Rasterizer）
## index

1. wgsl
2. webgpu:
   1. GPUBindGroupLayout： 记录了绑定组里面的资源的数据类型、用途等元数据，使得 GPU 可以提前知道
   2. GPUBindGroup: 管线在 GPU 执行时各个资源的集合，资源即 Buffer、Texture、Sampler 三种
   3. 暂存缓冲区 Staging Buffer： 是介于显存和 GPU 之间的缓存，它可以映射到 CPU 端进行读写。为了读取 GPU 中的数据，要先把数据从 GPU 内的高速缓存先复制到暂存缓冲区，然后把暂存缓冲区映射到 CPU，这样才能读取回主内存。对于数据传递至 GPU 的过程则类似。数据类型为GPUBuffer
