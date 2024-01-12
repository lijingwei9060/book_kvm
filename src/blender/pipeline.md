# intro

## 渲染流程：

1. 绘制三角形： 便利判断像素点是否位于三角形内
2. 着色： 简单光源Bling-Phong 着色模型
3. 遮蔽和走样： z-buffer, super-sampling

渲染流程：
1. 输入带渲染模型： 三角形面片，光照属性，光源属性
2. 对所有三角形，计算顶点的投影坐标和深度，存储法向量等着色信息
3. 取一个三角形，遍历像素是否投影到三角形内部
4. 对三角形内的像素点，遍历所有光源，着色叠加得到像素点颜色
5. 计算三角形在此处的深度值，如果相对于z-bffer深度较浅，更新z-buffer，颜色写入framebuffer
6. 对所有三角形进行3-5操作
7. 将framebuffer同步到显示器，徐然结果显示到屏幕。

GPU渲染程序：
1. Application
2. 几何处理 Geometry Processing： 几何处理包括投影、计算顶点颜色等，简称T&L（Transform and Lighting）得到三角形。顶点着色Vertex Shading、曲面细分 Tessellation、几何着色 Geometry Shading、定点后处理 Vertex Post-Processing、图元组装 Primitive Assembly
3. Rasterization： 得到处于三角形投影内部的像素点，硬编码到GPu中，光栅化后的是像素，对像素的着色操作叫做片段着色 Fragment Shading，这个阶段完成光照和着色，可通过片段着色器Fragment Shading控制。着色结束后，输出颜色，根据深度、透明度进行裁剪和混合，同时根据指定的反走样算法执行反走样操作。
4. Pixel Processing： 像素点根据光源属性、光照模型以及后面我们要提到的纹理映射被着色，最后通过z-buffer、alpha-blending 等算法确定最后的颜色输出，显示到屏幕上



## GPU架构

1. 1个统管任务的Giga Thread Engine
2. 多个不同的GPC Graphics Processing Cluster
3. 每个GPC包含多个SM Streaming Multiprocessor和一个Raster Engine
4. 每个SM包含多个核心，每个核心可以并发执行计算。一个消费级显卡有3K到10K个处理器。

GPU访问内存速度明显慢于CPU

GPU 的特点是：高吞吐、高延迟

在GPU 中，数据加载和命令执行是可以同时进行的，这样数据一旦到达GPU 就可以参与计算．
此后，这些顶点数据通过Work Distribution Crossbar 被分配给各个包含三角形面片的GPC．
Raster Engine 接到数据后，执行光栅化计算，并完成数据插值等任务，将必要的着色的数据传给片段着色器．
所有的片段着色器也是并行执行的．片段着色器给出颜色后，经过ROP（Render Output Unit）处理一下遮挡、混合，就可以写入帧缓冲（Frame Buffer）等待屏幕显示了．

在图形管线中，计算量最大的部分往往是对所有三角形顶点循环的顶点着色运算，和对所有像素、所有三角形循环的片段着色运算．在GPU 上，这两个循环可以展开到不同的核心上进行计算，从而大大提高了计算效率


Deferred Rendering: 按需着色，传统着色为Forward Rendering。

Forward Rendering： 深度测试在着色之后
Deferred Rendering：着色推迟，先计算深度测试和着色所需的属性，再完成着色过程，减少了实际执行的着色计算，缺点是对透明物体的处理比较麻烦，只能提前财经爱你一部分着色，同时需要存储额外的G-buffer数据，现存开销较大，后续通过Deferred texuring 技术改善。