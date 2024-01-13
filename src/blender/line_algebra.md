# vector

magnite $\hat{a} = \frac{ \vec{a}} { \lVert \vec{a} \rVert }$
cartesian coordinate: 笛卡尔坐标系

orthogonal： 直角的、正交的

dot product 点乘： $\vec{a} \cdot \vec{b} = \lVert \vec{a} \rVert \lVert \vec{b} \rVert \cos \theta$, 点乘满足 分配率、交换律 和结合律
=> projection 投影
=> 夹角： 

投影： $\vec{b}_\perp \quad \text{projection of} \quad \vec{b} \quad \text{onto} \quad \vec{a}$

cross production 叉乘： 正交与 a、b向量，右手定则， $a \times b = -b \times a$ 
右手坐标系： 满足右手定则, 三角形内的判断
$$\vec{x} \times \vec{y} = + \vec{z}$$
$$\vec{y} \times \vec{x} = - \vec{z}$$
$$\vec{a} \times \vec{a} = 0$$
$$\vec{a} \times (\vec{b} + \vec{c}) = \vec{a}\times\vec{b} + \vec{a}\times\vec{c}$$

$$\vec{a}\times\vec{b} = A*b \\
= \begin{pmatrix} 0 & -z_a & y_a  \\ z_a & 0 & -x_a \\ -y_a & x_a & 0 \\ \end{pmatrix} \begin{pmatrix} x_b  \\ y_b \\ z_b \\ \end{pmatrix} \\
= \begin{pmatrix} y_az_b-y_bz_a  \\ z_ax_b-x_az_b \\ x_ay_b-y_ax_b \\ \end{pmatrix}$$

## matrix

rotation旋转
scale缩放
shear剪切
homogeneous coordinate 齐次坐标系