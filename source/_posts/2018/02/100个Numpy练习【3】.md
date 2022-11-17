---
title: 100个Numpy练习【3】
date: 2018-02-26 15:49:32
en_title: 100 practices for Numpy -- 3
tags: [Python, Numpy, 数据分析]
permalink: /100numpy/3
---

<ul>
<li><strong>翻译：</strong><a href="https://www.yingjoy.cn/">YingJoy</a> </li>
<li><strong>网址：</strong> <a href="https://www.yingjoy.cn/">https://www.yingjoy.cn/</a></li>
<li><strong>来源：</strong> <a href="https://github.com/rougier/numpy-100">https://github.com/rougier/numpy-100</a></li>
<li><strong>全文：</strong> <a href="https://github.com/yingzk/100_numpy_exercises">https://github.com/yingzk/100_numpy_exercises</a></li>
</ul>

<hr />

<strong><a href="/100numpy/1">100个Numpy练习【1】</a></strong>
<strong><a href="/100numpy/2">100个Numpy练习【2】</a></strong>
<strong><a href="/100numpy/3">100个Numpy练习【3】</a></strong>
<strong><a href="/100numpy/4">100个Numpy练习【4】</a></strong>
<strong><a href="/100numpy/5">100个Numpy练习【5】</a></strong>

<hr />

Numpy是Python做数据分析必须掌握的基础库之一，非常适合刚学习完Numpy基础的同学，完成以下习题可以帮助你更好的掌握这个基础库。

Python版本：Python 3.6.2

Numpy版本：Numpy 1.13.1

<center><img src="http://www.numpy.org/_static/numpy_logo.png")></center>

<h4><strong>41. 对一个小数组进行求和有没有办法比np.sum更快?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.add.reduce)

<pre><code class="python"># Author: Evgeni Burovski

Z = np.arange(10)
np.add.reduce(Z)

# np.add.reduce 是numpy.add模块中的一个ufunc(universal function)函数,C语言实现
</code></pre>

<h4><strong>42. 如何判断两和随机数组相等</strong> (★★☆)</h4>

(<strong>提示</strong>: np.allclose, np.array&#95;equal)

<pre><code class="python">A = np.random.randint(0, 2, 5)
B = np.random.randint(0, 2, 5)

# 假设array的形状(shape)相同和一个误差容限（tolerance）
equal = np.allclose(A,B)
print(equal)

# 检查形状和元素值，没有误差容限（值必须完全相等）
equal = np.array_equal(A,B)
print(equal)
</code></pre>

<h4><strong>43. 把数组变为只读</strong> (★★☆)</h4>

(<strong>提示</strong>: flags.writeable)

<pre><code class="python">Z = np.zeros(5)
Z.flags.writeable = False
Z[0] = 1
</code></pre>

<h4><strong>44. 将一个10x2的笛卡尔坐标矩阵转换为极坐标</strong> (★★☆)</h4>

(<strong>提示</strong>: np.sqrt, np.arctan2)

<pre><code class="python">Z = np.random.random((10, 2))
X, Y = Z[:, 0], Z[:, 1]
R = np.sqrt(X**2 + Y**2)
T = np.arctan2(Y, X)
print (R)
print (T)
</code></pre>

<h4><strong>45. 创建一个大小为10的随机向量并且将该向量中最大的值替换为0</strong>(★★☆)</h4>

(<strong>提示</strong>: argmax)

<pre><code class="python">Z = np.random.random(10)
Z[Z.argmax()] = 0
print (Z)
</code></pre>

<h4><strong>46. 创建一个结构化数组，其中<code>x</code>和<code>y</code>坐标覆盖<code>[0, 1]x[1, 0]</code>区域</strong> (★★☆)</h4>

(<strong>提示</strong>: np.meshgrid)

<pre><code class="python">Z = np.zeros((5, 5), [('x', float), ('y', float)])
Z['x'], Z['y'] = np.meshgrid(np.linspace(0, 1, 5), np.linspace(0, 1, 5))
print (Z)
</code></pre>

<h4>4<strong>7. 给定两个数组<code>X</code>和<code>Y</code>，构造柯西(Cauchy)矩阵C ($C_{ij}=\frac{1}{x_i-y_j}$)</strong> (★★☆)</h4>

<h5>(提示: np.subtract.outer)</h5>

<pre><code class="python"># Author: Evgeni Burovski

X = np.arange(8)
Y = X + 0.5
C = 1.0 / np.subtract.outer(X, Y)
print (C)
print(np.linalg.det(C)) # 计算行列式
</code></pre>

<h4><strong>48. 打印每个numpy 类型的最小和最大可表示值</strong> (★★☆)</h4>

(<strong>提示</strong>: np.iinfo, np.finfo, eps)

<pre><code class="python">for dtype in [np.int8, np.int32, np.int64]:
   print(np.iinfo(dtype).min)
   print(np.iinfo(dtype).max)
for dtype in [np.float32, np.float64]:
   print(np.finfo(dtype).min)
   print(np.finfo(dtype).max)
   print(np.finfo(dtype).eps)
</code></pre>

<h4><strong>49. 如何打印数组中所有的值？</strong>(★★☆)</h4>

(<strong>提示</strong>: np.set&#95;printoptions)

<pre><code class="python">np.set_printoptions(threshold=np.nan)
Z = np.zeros((16,16))
print(Z)
</code></pre>

<h4><strong>50. 如何在数组中找到与给定标量接近的值?</strong> (★★☆)</h4>

(<strong>提示</strong>: argmin)

<pre><code class="python">Z = np.arange(100)
v = np.random.uniform(0, 100)
index = (np.abs(Z-v)).argmin()
print(Z[index])
</code></pre>

<h4><strong>51. 创建表示位置(x, y)和颜色(r, g, b, a)的结构化数组</strong> (★★☆)</h4>

(<strong>提示</strong>: dtype)

<pre><code class="python">Z = np.zeros(10, [('position', [('x', float, 1), 
                                ('y', float, 1)]),
                  ('color',    [('r', float, 1), 
                                ('g', float, 1), 
                                ('b', float, 1)])])
print (Z)
</code></pre>

<h4><strong>52. 思考形状为(100, 2)的随机向量，求出点与点之间的距离</strong> (★★☆)</h4>

(<strong>提示</strong>: np.atleast&#95;2d, T, np.sqrt)

<pre><code class="python">Z = np.random.random((100, 2))
X, Y = np.atleast_2d(Z[:, 0], Z[:, 1])
D = np.sqrt((X-X.T)**2 + (Y-Y.T)**2)
print (D)

# 使用scipy库可以更快
import scipy.spatial

Z = np.random.random((100,2))
D = scipy.spatial.distance.cdist(Z,Z)
print(D)
</code></pre>

<h4><strong>53. 如何将类型为float(32位)的数组类型转换位integer(32位)?</strong> (★★☆)</h4>

(<strong>提示</strong>: astype(copy=False))

<pre><code class="python">Z = np.arange(10, dtype=np.int32)
Z = Z.astype(np.float32, copy=False)
print(Z)
</code></pre>

<h4><strong>54. 如何读取下面的文件?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.genfromtxt)

<pre><code class="python">1, 2, 3, 4, 5
6,  ,  , 7, 8
 ,  , 9,10,11

# 先把上面保存到文件example.txt中
# 这里不使用StringIO， 因为Python2 和Python3 在这个地方有兼容性问题
Z = np.genfromtxt("example.txt", delimiter=",")  
print(Z)
</code></pre>

<h4><strong>55. numpy数组枚举(enumerate)的等价操作?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.ndenumerate, np.ndindex)

<pre><code class="python">Z = np.arange(9).reshape(3,3)
for index, value in np.ndenumerate(Z):
    print(index, value)
for index in np.ndindex(Z.shape):
    print(index, Z[index])
</code></pre>

<h4><strong>56. 构造一个二维高斯矩阵</strong>(★★☆)</h4>

(<strong>提示</strong>: np.meshgrid, np.exp)

<pre><code class="python">X, Y = np.meshgrid(np.linspace(-1, 1, 10), np.linspace(-1, 1, 10))
D = np.sqrt(X**2 + Y**2)
sigma, mu = 1.0, 0.0
G = np.exp(-( (D-mu)**2 / (2.0*sigma**2) ))
print (G)
</code></pre>

<h4><strong>57. 如何在二维数组的随机位置放置p个元素?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.put, np.random.choice)

<pre><code class="python"># Author: Divakar

n = 10
p = 3
Z = np.zeros((n,n))
np.put(Z, np.random.choice(range(n*n), p, replace=False),1)
print(Z)
</code></pre>

<h4><strong>58. 减去矩阵每一行的平均值</strong> (★★☆)</h4>

(<strong>提示</strong>: mean(axis=,keepdims=))

<pre><code class="python"># Author: Warren Weckesser

X = np.random.rand(5, 10)

# 新
Y = X - X.mean(axis=1, keepdims=True)

# 旧
Y = X - X.mean(axis=1).reshape(-1, 1)

print(Y)
</code></pre>

<h4><strong>59. 如何对数组通过第n列进行排序?</strong> (★★☆)</h4>

(<strong>提示</strong>: argsort)

<pre><code class="python"># Author: Steve Tjoa

Z = np.random.randint(0,10,(3,3))
print(Z)
print(Z[ Z[:,1].argsort() ])
</code></pre>

<h4><strong>60. 如何判断一个给定的二维数组存在空列?</strong> (★★☆)</h4>

(<strong>提示</strong>: any, ~)

<pre><code class="python"># Author: Warren Weckesser

Z = np.random.randint(0,3,(3,10))
print((~Z.any(axis=0)).any())
</code></pre>