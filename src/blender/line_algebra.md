# vector

向量的稚 magnite $\hat{a} = \frac{ \vec{a}} { \lVert \vec{a} \rVert }$
cartesian coordinate: 笛卡尔坐标系

orthogonal unit vector： 直角的、正交的单元向量

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

向量a的对偶矩阵： dual matrix of vector a

## matrix


scale缩放因子`Vector4f`, 每个方向的缩放为$s_x \quad s_y \quad s_z$：
$$\begin{pmatrix}
    s_x & 0 & 0 & 0 \\
    0 & s_y & 0 & 0 \\
    0 & 0 & s_z & 0 \\
    0 & 0 & 0   & 1
\end{pmatrix}$$ 
translation变化矩阵`Vector4f`, 每个方向的移动量$t_x \quad t_y \quad t_z$, 转换矩阵：
$$T(t_x,t_y,t_z) = \begin{pmatrix}
    1 & 0 & 0 & t_x \\
    0 & 1 & 0 & t_y \\
    0 & 0 & 1 & t_z \\
    0 & 0 & 0 & 1
\end{pmatrix}$$
rotation旋转， 绕轴旋转角度$R_x(\alpha), R_y(\alpha), R_z(\alpha)$,绕轴转动矩阵： 
$$
R_x(\alpha) = \begin{pmatrix}
    1 & 0 & 0 & 0 \\
    0 & \cos\alpha & -\sin\alpha & 0 \\
    0 & \sin\alpha & \cos\alpha  & 0 \\
    0 & 0 & 0 & 1
\end{pmatrix}  \\

R_x(\alpha) \cdot (x,y,z,1)^T =  \begin{pmatrix}
    1 & 0 & 0 & 0 \\
    0 & \cos\alpha & -\sin\alpha & 0 \\
    0 & \sin\alpha & \cos\alpha  & 0 \\
    0 & 0 & 0 & 1
\end{pmatrix} \cdot \begin{pmatrix}
    x \\
    y \\
    z \\
    1
\end{pmatrix} = \begin{pmatrix}
    x \\
    y*\cos\alpha - z*\sin\alpha \\
    y*\sin\alpha + z*\cos\alpha \\
    1 
\end{pmatrix}\\

R_y(\alpha) = \begin{pmatrix}
    \cos\alpha & 0 & \sin\alpha & 0 \\
    0 & 1 & 0 & 0 \\
    -\sin\alpha & 0 & \cos\alpha  & 0 \\
    0 & 0 & 0 & 1
\end{pmatrix} \\

R_z(\alpha) = \begin{pmatrix}
    \cos\alpha & -\sin\alpha & 0 & 0 \\
    \sin\alpha & \cos\alpha & 0 & 0 \\
    0 & 0 & 1  & 0 \\
    0 & 0 & 0 & 1
\end{pmatrix}
$$

1. 旋转轴正方向面对观察者时，逆时针方向的旋转是正、顺时针方向的旋转是负。
2. x是车头绕X轴旋转得到的是roll，绕Y轴旋转得到的是pitch，绕Z轴得到的是yaw。
3. 车体坐标系（x-前，y-左，z-上），那么roll和pitch应该定义在（-90°，+90°），yaw应该定义在（-180°，+180°）。假如是飞机坐标系，那么roll、pitch和yaw都应该定义在（-180°，+180°）。
4. 每次旋转是绕固定轴（一个固定参考系，比如世界坐标系）旋转，称为外旋。每次旋转是绕自身旋转之后的轴旋转，称为内旋。

rodrigues' Rotation Formula, 罗德里戈旋转公式，如果${\displaystyle v}$是在${\displaystyle \mathbb {R} ^{3}}$中的向量，${\displaystyle k}$是与转轴同向的单位向量，${\displaystyle \theta }$是${\displaystyle v}$绕${\displaystyle k}$的右手方向旋转经过的角度，那罗德里格旋转公式表达为
$${\displaystyle \mathbf {v} _{\mathrm {rot} }=\mathbf {v} \cos \theta +(\mathbf {k} \times \mathbf {v} )\sin \theta +\mathbf {k} (\mathbf {k} \cdot \mathbf {v} )(1-\cos \theta ).}$$
shear剪切
homogeneous coordinate 齐次坐标系

相机转换,相机转移到原点，Y为上方向，看向-Z： 
1. position： $\vec{e}$
2. look at $\hat{g}$
3. up direction $\hat{t}$ perp to look-att

需要相机做的运动$M_{view}$：
1. 移到原点
2. 旋转$\hat{g}$ 到 -Z
3. 旋转t到Y
4. 旋转$g \times t$ to X

$$M_{view} = R_{view} \cdot T_{view}$$