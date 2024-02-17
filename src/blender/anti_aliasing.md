# intro

抗锯齿（英语：anti-aliasing，简称AA），也译为边缘柔化、消除混叠、抗图像折叠有损等。它是一种消除显示器输出的画面中图物边缘出现凹凸锯齿的技术，那些凹凸的锯齿通常因为高分辨率的信号以低分辨率表示或无法准确运算出3D图形坐标定位时所导致的图形混叠（aliasing）而产生的，反锯齿技术能有效地解决这些问题。它通常被用在在数字信号处理、数字摄影、电脑绘图与数码音效及电子游戏等方面，柔化被混叠的数字信号。

多重采样抗锯齿（MSAA）：多重采样抗锯齿（MultiSampling Anti-Aliasing，简称MSAA）是一种特殊的超级采样抗锯齿（SSAA）。MSAA首先于OpenGl。具体是MSAA只对Z缓存（Z-Buffer）和模板缓存（Stencil Buffer）中的数据进行超级采样抗锯齿的处理。可以简单理解为只对多边形的边缘进行抗锯齿处理。这样的话，相比SSAA对画面中所有数据进行处理，MSAA对资源的消耗需求大大减弱，不过在画质上可能稍有不如SSAA。

快速近似抗锯齿（FXAA）：FXAA的中文全称为“快速近似抗锯齿”，是一种典型的边缘检查取样操作。FXAA的基本原理与MSAA相同，都是通过提取像素界面周围的颜色信息并完成混合来消除高对比度界面所产生的锯齿。但是FXAA将像素的提取和混合过程交由GPU内的ALU来执行，因此其所占用的显存带宽要大大低于传统的MSAA。消耗最低，低配置开这种抗锯齿不卡，实际上是一种粗糙的模糊化处理。

子像素增强抗锯齿（SMAA）：SMAA是性耗比最佳的模式，用适量的资源得到比较满意的抗锯齿效果。FXAA和SMAA一样性能损失小，效果都一般，毕竟后处理抗锯齿，清晰度上都有所损失，SMAA较FXAA清晰些。致命的弱点在于锯齿抖动方面，别看它们的效果截图看着都不错，甚至比肩MSAA，但是一旦是实际玩，也就是动态画面，锯齿抖动就非常明显时间和空间两方面交替使用抗锯齿采样格式，4xMFAA 的性能代价仅相当于 2xMSAA，但是抗锯齿效果却与 4xMSAA相当。[SMAA算法详解](https://blog.csdn.net/qezcwx11/article/details/78426052?depth_1-utm_source=distribute.pc_relevant.none-task&utm_source=distribute.pc_relevant.none-task)

CSAA（Coerage Sampling Antialiasing，覆盖取样抗锯齿）：CSAA生成比得上8x或16x MSAA质量的抗锯齿图像，但只产生比标准（通常是4x）MSAA多一点的性能损失。它通过引入一个新的采样类型概念来工作：一种表示覆盖的取样。这不同于先前总是把覆盖固定地绑定到另一个取样类型的抗锯齿技术。例如在超级取样中，每个取样表示了着色颜色、储存的颜色/Z/模板、和覆盖，这样本质上增加了渲染到一个过大的缓存并向下取样。MSAA通过从储存的颜色和覆盖中分离出着色取样，减少了这项操作的着色器开销；这允许应用程序使用抗锯齿来处理更少的着色取样同时维持同样质量的颜色/Z/模板和覆盖取样。CSAA通过从颜色/Z/模板分离出覆盖进一步优化了这个过程，从而减少带宽和存储开销。


时间性抗锯齿（TXAA Temporal Anti-Aliasing）：让电影画质的游戏体验达到逼真水平。TXAA 抗锯齿比 MSAA和FXAA 以及 CSAA 的画质更高，制作CG电影的电影制片厂会在抗锯齿方面花费大量的计算资源，从而可确保观众不会因不逼真的锯齿状线条而分心。如果想要让游戏接近这种级别的保真度，那么开发商需要全新的抗锯齿技术，不但要减少锯齿状的线条，而且要减少锯齿状闪烁情形，同时还不降低性能。为了便于开发商实现这种保真度的提升，英伟达设计了画质更高的抗锯齿模式，名为TXAA.该模式专为直接集成到游戏引擎中而设计。与CG电影中所采用的技术类似，TXAA集MSAA的强大功能与复杂的解析滤镜于一身，可呈现出更加平滑的图像效果，远远超越了所有同类技术。此外，TXAA还能够对帧之间的整个场景进行抖动采样，以减少闪烁情形，闪烁情形在技术上又称作时间性锯齿。目前，TXAA有两种模式：TXAA 2X和TXAA 4X。TXAA 2X可提供堪比8X MSAA的视觉保真度，然而所需性能却与2X MSAA相类似；TXAA 4X的图像保真度胜过8XMSAA，所需性能仅仅与4X MSAA相当。


可编程过滤抗锯齿（CFAA）：可编程过滤抗锯齿（Custom Filter Anti-Aliasing）技术起源于AMD的R600家庭。简单地说CFAA就是扩大取样面积的MSAA，比方说之前的MSAA是严格选取物体边缘像素进行缩放的，而CFAA则可以通过驱动和谐灵活地选择对影响锯齿效果较大的像素进行缩放，以较少的性能牺牲换取平滑效果。显卡资源占用也比较小。


多帧采样抗锯齿（MFAA）：MFAA全称为“Multi-Frame Sampled Anti-Aliasing”，与MSAA基于像素采样有所不同，MFAA是基于帧采样的，我们大致可以这么理解，MFAA是在相邻的两帧上各执行一次抗锯齿采样，然后通过NIA自行开发的图像合成处理技术来整合采样结果，最后输出完成抗锯齿运算的图像。它的运行原理实际上与MSAA是接近的，基本上可以视为MSAA的精简版。MFAA和MSAA都是把一个像素点放大至原来的数倍，让渲染图像的采样点也增加至原来的数倍，不过MSAA是每一帧图像都会对全部采样点进行采样，而MFAA则是把采样点分为两份，奇数帧和偶数帧各占一半，然后每一帧进行采样后再通过临时合成滤波器把结果整合到一起。这样MFAA的每一帧图像的采样运算数据都只有MSAA的一半，但是数据整合起来后却有着与MSAA相同的效果。按照NIA的描述，MFAA在提供等同于MSAA抗锯齿效果的同时，性能可以比后者提升30%。这对于认为帧数与画质同样重要的游戏玩家来说，无疑是一个极好的抗锯齿技术。


## TAA、TXAA

TAA（Temporal Anti-Aliasing）是时间性抗锯齿，是最常用的图像增强算法之一，这是一种基于着色器的算法，使用运动矢量组合两帧，以确定在何处对前一帧进行采样。在每一帧对屏幕区域内的像素进行一个抖动操作，这样当连续的多个帧的数据混合起来以后，就相当于对每个像素进行了多次采样，他将采样点从单帧分布到多个帧上，使得每一帧并不需要多次采样增加计算量，但TAA往往会盲目地跟随移动物体的运动矢量，从而造成屏幕上的细节模糊不清。

后来NVIDIA提供了一种称作TXAA的抗锯齿技术，实际上就是TAA+MSAA（多重采样抗锯齿Multi-Sample Anti-Aliasing）的组合，通过引入额外的深度信息来实现在延迟渲染上使用MSAA，TXAA专门用来直接集成在游戏引擎里，TXAA综合了MSAA的强大能力与类似于CG电影中所采用的复杂的高画质过滤器。还可以抖动帧与帧之间的采样位置来获得更高画质。

NVIDIA在Turing架构的时候推出了DLSS深度学习超级采样技术，DLSS利用深度神经网络来提取渲染场景的多维特征，并能以智能方式结合多帧细节，从而构建高质量的最终图像。与传统技术（如 TAA）相比，DLSS 使用更少的输入样本，同时还能避免此类技术在透明度和其他复杂场景元素方面遭遇的算法难题。DLSS 可以自行学习生成接近 64xSS 质量的图像，同时还避免出现影响 TAA 等传统方法的模糊、不清晰和透明问题。其实DLSS第一代的时候效果并不是特别好，虽然帧数上升，但画面还是有点糊，到了现在的DLSS2.0，NVIDIA升级了算法，使得整个处理效果非常出色，画面特别精细。