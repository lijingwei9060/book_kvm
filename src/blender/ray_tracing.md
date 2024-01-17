# intro

光栅化不能处理全局光效，global effects： 光线弹射多次，效率比较低，不能保证准确
    soft shadows软阴影、
    glossy reflection比较光滑的金属，模糊的反射，
    indirect illumination间接光照，光线照到地板漫反射


光栅化：快，质量低，real-time，30fps
光线追踪： 精确，慢，offline，10k cpu hour per frame

概念：
1. 光线直线传播
2. 光线不会发生碰撞，collide
3. 光从源到眼睛，光路可逆性

光路投射：ray casting


## 光线和三角形求交集

递归whitted-style的光线追踪  primary ray + secondary rays + shadow rays

光线等式： $r(t) = o + td$
隐式平面 implicit surface： $f(p) = 0$

=> $f(o+td) = 0$, 求t，real、positive，实数、正数

Trangle Mesh三角形网格和光线交集：
1. 法线N，点p' , $(p-p') \cdot N = 0$
2.  $(p-p') \cdot N = (o+td-p') \cdot N = 0$ => $t = \frac{(p'-o) \cdot N}{d \cdot N}$ 


三角形内 Moller trumbore 算法:
重心坐标系
claim 法则？ 成本 1 div， 27 mul， 17 add

## 加速

bounding volumes： 包围盒，包围复杂的结构体形成一个简单的volume
Axis-Aligned Bounding Box AABB，轴对齐包围盒

对面：求出入和出的时间，=> 将对面的入出时间进行交集

$t_{enter}=max\{t_{min}\}$  , $t_{exit} = min\{t_{max} \}$

=> ray and AABB intersect iff $t_{enter} < t_{exit} \quad \&\& \quad t_{exit} \ge 0$


Uniform Spatial Partitions(Grids)

Uniform Grid:
1. find bounding box
2. create grid
3. store each object in overlaping cells, 和物理表面相交
4. step  through grid in ray traversal order
5. for each grid cell, test intersection with all objects stored at that cell

统一格子稀疏问题，中间有大量的空气。

Spatial Partitions： 空间划分
1. oct-tree: 八叉树，三维空间八叉，三块不想交就不切了
2. kd-tree： 只有叶子结点有真实数据
3. bsp-tree

Object Partitions & Bounding Volume Hierarchy BVh？
1. choose a dimension to split
2. heuristic #1: always choose the longest axis in node
3. heuristic #2: split node at location of median object

## basic raidometry: 辐射度量学
Blinn-Phong Model
光源强度 1- 10

光照单位：
1. radiant flux， intensity ， irradiance， radiance

radiant intensity: the reaidant(luminous) intensity is the power per unit solid angle emitted by a point light source.

solid angles: radio of subtended area on sphere to raidus squared, 3维立体角，面积除以半径平方，4pi的立体角，steraians


## Prob

## 蒙特卡洛积分monte carlo intergration

渲染方程： 光纤传播方式， rendering equation
light transport： brbf

连续变量 contrinue variable
概率密度函数 probability Density Function
变量的期望： expected value of x E[x] = xp(x)的积分
蒙特卡洛积分monte carlo intergration，定积分 $\int_a^bf(x)dx$，在积分域内多次采样，平均值乘以长度。

黎曼积分： 长方形面积积分

蒙特卡洛积分monte carlo intergration： 
蒙特卡洛估算： monte carlo estimator 
统一蒙特卡洛管算子： uniform mento carlo estimator $F_N = \frac{b-a}{N} \sum_{i=1}^{N}f(X_i)$

=> monto carlo integration $\int f(x)dx = \frac{1}{N}\sum_{i=1}^{N}\frac{f(X_i)}{p(X_i)} \quad X_i ~ p(x)$ , 定积分采样多，误差少

## Path Tracing

color bleeding： 全局光照内的效果
The Cornell box： 康奈尔盒子，全局光照效果

渲染方程是正确的，自己发出+四面八方反射

$$L_o(p,w_o)=L_e(p,w_o)+\int_{\Omega+}L_i(p,w_i)f_r(p,w_i,w_o)(n \cdot w_i)dw_i$$

shade(p,wo):
1. randomly choose N directions wi ~ pdf
2. Lo = 0.0
3. for each wi
   1. trace a ray r(p, wi)
   2. if ray r hit the light
      1. Lo += (1/N) * L_i * f_r * cosine / pdf(wi)
   3. Else if ray hit an object at q
      1. Lo += (1/N) * shade(q, -wi) * f_r *consine / pdf(wi)
4. return Lo

如果光多次弹跳：算多次弹跳，简化为下一个嵌套; 嵌套如何结束？cuting bounces， 能力损失。Russian roulette RR，俄罗斯轮盘，一定的概率停止path tracing， => 带rr的渲染方程

N => one, 计算爆炸
N != 1 Distributed Ray tracing 


Ray Generation

效率问题： spp samples per pixel，存在浪费的光线，好的pdf，不要平均

直接光源： no rr
间接光源： rr

问题： 直接光源被阻挡blocked