# intro

- 奇函数： f(-x) = -f(x), sin(-x) = -sin(x), 原点堆成，标记为$f_{odd}$
- 偶函数: f(x) = f(-x), cos(x) = cos(-x), y轴堆成，标记为$f_{even}$
- 周期函数: f(x) = f(x + nT)
- 任意函数f(x) 都可以分解为奇函数和偶函数之和 $f(x)=\frac{f(x)+f(-x)}{2} + \frac{f(x)-f(-x)}{2} = f_{odd} + f_{even}$

傅里叶变换： 周期函数可以表示成三角函数的组合。
$$f(x)=C+\sum_{n=1}^\infin (a_n\cos(\frac{2\pi n}{T}x)+b_n\sin(\frac{2\pi n}{T}x)), C \in \Bbb{R}$$

- cos(x)、sin(x) 周期为$2\pi$
- $cos(\frac{2\pi n}{T}x)、sin(\frac{2\pi n}{T}x)$周期为T， $n\in \Bbb{N}$

求解=> 
1. 周期为T
2. 调整$C \quad a_n \quad b_n$逼近曲线

三角函数转换到复平面$e^{iwt}$向量, t代表时间，通过复平面的旋转表达时域和频域， y轴投影就是sin(x)，x轴投影就是cos(x), 得到$e^{it} = \cos(t) + i\sin(t)$
