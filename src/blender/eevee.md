# 介绍
实时渲染引擎
OpenGL 技术
渲染PBR材质
着色器节点
光栅化渲染，没有采用光追
## 特点

采样： 时间性抗锯齿（TAA）的过程来减少 锯齿 ，样本越多，以性能为代价就会减少锯齿
蜡笔
环境光遮蔽: 一种基于范围真实环境光遮蔽 GTAO 的程序计算，并应用于间接光照。扭曲法线选项会使得漫射光照仅来自最少的遮挡方向。环境光遮蔽可以在渲染层中作为独立的通道被渲染。
辉光Bloom： 是一种后处理效果，可以扩散非常明亮的像素。 模仿真实相机的镜头伪像,这样可以更好地了解像素的实际强度。
景深Depth of Field: 后期处理方法是分两次计算的。第一遍是使用模糊法，对高光部分不能产生高质量的虚化，但对一般情况是有效的。紧接着是第二遍，这是基于精灵的，只改善了非常明亮的高光部分的质量。这是因为它太慢了，无法应用于图像的每一部分。所以它只包括图像中非常明亮的孤立部分，如与周围环境不同的部分。哪些像素会被二次处理，可以用 "像素阈值 "和 "相邻拒绝 "选项来控制。其次，基于样本的方法通过随机化每个样本的相机位置来工作。它更准确，但需要许多样本来实现平滑的结果。因此，后处理的模糊半径被缩减以消除欠采样。然而，一些场景可能仍然需要更多的后处理模糊，以消除明显的采样模式。这正是 Overblur 选项的作用，但它也会降低虚化形状的清晰度。
次表面散射subsurface-scattering: 在屏幕空间内用模糊漫射光照的方式来模拟真实的次表面散射,用于实现光线透过物体表面的效果（类似模拟人耳背面透光）,仅在附有阴影的光照环境中生效，且无法作用于间接光照。
屏幕空间反射screen space reflection: 材质将利用深度缓存器和前一帧的颜色，来创建比反射探针更精准的反射。如果 反射平面 和反光物体足够近，将有利于追踪反射源，和处理某些反射视觉错误的问题。反射的颜色不包含以下效果：次表面散射、体积、屏幕空间反射、屏幕空间折射。
运动模糊
体积volumetrics： 评估视锥体内的所有体积对象来模拟体积散射
性能
曲线
阴影shadow: EEVEE使用一种叫做阴影映射的技术来计算这些阴影。阴影图的计算方法是：从每个灯的位置向四周看，找到离灯最近的物体。这些物体被称为最近的遮挡物。所有在最近的遮挡物后面（或者你可以说，被遮挡）的东西都会有阴影。阴影地图是一个立方体（因此称为 "立方体地图"），灯光位于这个立方体的中间。这个立方体有六个面，每个面都被划分为一个网格。你可以通过下面的 立方体大小 设置来设置网格的分辨率（例如，512×512像素）。在阴影计算过程中，只在网格点上搜索最近的遮挡物，而不是在网格点之间搜索。正因为如此，在低的Cube Size设置下，计算出的阴影的边缘会出现像素化。
间接光照明: 在EEVEE中，所有不是从灯光物体直接出来的光照被视为间接照明。 包括 HDRI 照明（或世界照明）被视为间接光照明。 同样，使用Emission节点的网格对象也被视为间接光照明。在EEVEE中，间接照明分为两个部分：漫反射和高光反射。两者都有不同的需求和代表性。为了提高效率，间接照明数据根据需要预先计算到静态照明缓存中。到目前为止，光缓存是静态的，需要在渲染之前计算。它不能被每帧更新（除非通过脚本）。这个限制正在解决中，并会在将来的版本中移除。只能查看独立照明。这就是为什么Reflection Planes（反光板）不存储在光缓存中的原因。烘焙过程中使用的是当前活动视图层中的可见物体和集合。需要多次烘焙来完成光线在场景中的反弹计算，并将上次烘焙结果合成。整体烘焙时间受反弹次数影响而倍增。光线反弹只限于漫反射照明。
胶片

## 节点

- Shader --> RGB： EEVEE支持使用 Shader to RGB节点 将BSDF输出转换为颜色输入，以进行任何类型的自定义着色。
- 高光 BSDF：高光节点 能实现在其他渲染引擎中找到的高光工作流。
- 漫射 BSDF：不支持粗糙度。 仅支持Lambertian 扩散。
- 自发光（发射）：它将被作为间接照明处理，在 屏幕空间反射SSR 和探头中可见。
- 玻璃/折射BSDF：不能折射光线。不支持贝克曼分布。参见 折射限制 。
- 光泽 BSDF：不支持贝克曼和阿什赫明-雪莉分布。
- 次表面散射 (SSS)：不支持随机游取采样。每个颜色通道半径由默认接口值指定。连入此接口的任何连线都将被忽略。纹理模糊对于 0.0 和 1.0 以外的任何值都不准确。
- 透明 BSDF：透明仅在材质的混合模式不是不透明的情况下才起作用。上色与累加透明仅兼容 Alpha混合 模式。
- 半透 BSDF： 不扩散物体内部的光。它只用反向法线照亮物体。
- 原理化BSDF： Cumulative limitations from Diffuse BSDF, Glossy BSDF, Refraction BSDF and Subsurface Scattering. Anisotropy is not supported. The Sheen layer is acrude approximation.
- 体积吸收： 参阅 体积限制。
- 体积散射： 各向异性参数将对所有重叠的体积对象进行混合和平均，Cycles不同，这不符合物理规律。请参阅 体积限制.
- 原理化体积： 和体积散射一样。参见 体积限制。
- 阻隔： 部分支持，使用 混合模式 除 Alpha 之外可能会给出不正确的结果。

## 输入节点： 
- 环境光遮蔽： 不使用样本计数。
- 相机数据： 夏娃海尔信息是兼容的。
- 几何数据： 不支持尖锐度。
- 每个岛屿随机： 不支持每个岛屿的随机数。
- 曲线信息：随机输出使用不同的 RNG（随机数生成器） 算法。 值的范围和统计分布应该相同，但是值是不同的。
- 光程： EEVEE没有射线的真正概念。但是为了简化Cycles和EEVEE之间的工作流，有些输出在特定情况下是支持的。此节点可以调整着色器中的间接光照明。