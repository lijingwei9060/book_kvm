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