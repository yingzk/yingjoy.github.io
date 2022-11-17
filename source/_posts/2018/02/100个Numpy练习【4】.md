---
title: 100个Numpy练习【4】
date: 2018-02-26 15:51:32
en_title: 100 practices for Numpy -- 4
tags: [Python, Numpy, 数据分析]
permalink: /100numpy/4
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

<h4><strong>61. 从数组中找出与给定值最接近的值</strong> (★★☆)</h4>

(<strong>提示</strong>: np.abs, argmin, flat)

<pre><code class="python">Z = np.random.uniform(0,1,10)
z = 0.5
m = Z.flat[np.abs(Z - z).argmin()]
print(m)
</code></pre>

<h4><strong>62. 思考形状为(1, 3)和(3, 1)的两个数组形状，如何使用迭代器计算它们的和?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.nditer)

<pre><code class="python">A = np.arange(3).reshape(3, 1)
B = np.arange(3).reshape(1, 3)
it = np.nditer([A, B, None])
for x, y, z in it:
    z[...] = x + y
print (it.operands[2])
</code></pre>

<h4><strong>63. 创建一个具有name属性的数组类</strong> (★★☆)</h4>

(<strong>提示</strong>: class method)

<pre><code class="python">class NameArray(np.ndarray):
    def __new__(cls, array, name="no name"):
        obj = np.asarray(array).view(cls)
        obj.name = name
        return obj
    def __array_finalize__(self, obj):
        if obj is None: return
        self.info = getattr(obj, 'name', "no name")

Z = NamedArray(np.arange(10), "range_10")
print (Z.name)
</code></pre>

<h4><strong>64. 给定一个向量，如何让在第二个向量索引的每个元素加1(注意重复索引)?</strong> (★★★)</h4>

(<strong>提示</strong>: np.bincount | np.add.at)

<pre><code class="python"># Author: Brett Olsen

Z = np.ones(10)
I = np.random.randint(0,len(Z),20)
Z += np.bincount(I, minlength=len(Z))
print(Z)

# Another solution
# Author: Bartosz Telenczuk
np.add.at(Z, I, 1)
print(Z)
</code></pre>

<h4><strong>65. 如何根据索引列表<code>I</code>将向量<code>X</code>的元素累加到数组<code>F</code>?</strong> (★★★)</h4>

(<strong>提示</strong>: np.bincount)

<pre><code class="python"># Author: Alan G Isaac

X = [1,2,3,4,5,6]
I = [1,3,9,3,4,1]
F = np.bincount(I,X)
print(F)
</code></pre>

<h4><strong>66. 思考(dtype = ubyte)的(w, h, 3)图像，计算唯一颜色的值</strong>(★★★)</h4>

(<strong>提示</strong>: np.unique)

<pre><code class="python"># Author: Nadav Horesh

w,h = 16,16
I = np.random.randint(0,2,(h,w,3)).astype(np.ubyte)
F = I[...,0]*256*256 + I[...,1]*256 +I[...,2]
n = len(np.unique(F))
print(np.unique(I))
</code></pre>

<h4><strong>67. 思考如何求一个四维数组最后两个轴的数据和</strong>(★★★)</h4>

(<strong>提示</strong>: sum(axis=(-2,-1)))

<pre><code class="python">A = np.random.randint(0,10,(3,4,3,4))
# 传递一个元组(numpy 1.7.0)
sum = A.sum(axis=(-2,-1))
print(sum)

# 将最后两个维度压缩为一个
# (适用于不接受轴元组参数的函数)
sum = A.reshape(A.shape[:-2] + (-1,)).sum(axis=-1)
print(sum)
</code></pre>

<h4>68. <strong>考虑一维向量D，如何使用相同大小的向量S来计算D的子集的均值，其描述子集索引？</strong>  (★★★)</h4>

(<strong>提示</strong>: np.bincount)

<pre><code class="python"># Author: Jaime Fernández del Río

D = np.random.uniform(0,1,100)
S = np.random.randint(0,10,100)
D_sums = np.bincount(S, weights=D)
D_counts = np.bincount(S)
D_means = D_sums / D_counts
print(D_means)

# Pandas solution as a reference due to more intuitive code
import pandas as pd
print(pd.Series(D).groupby(S).mean())
</code></pre>

<h4>69. <strong>如何获得点积的对角线？</strong> (★★★)</h4>

(<strong>提示</strong>: np.diag)

<pre><code class="python"># Author: Mathieu Blondel

A = np.random.uniform(0,1,(5,5))
B = np.random.uniform(0,1,(5,5))

# Slow version  
np.diag(np.dot(A, B))

# Fast version
np.sum(A * B.T, axis=1)

# Faster version
np.einsum("ij,ji-&gt;i", A, B)
</code></pre>

<h4><strong>70.考虑向量[1,2,3,4,5]，如何建立一个新的向量，在每个值之间交错有3个连续的零？</strong> (★★★)</h4>

(<strong>提示</strong>: array&#91;::4&#93;)

<pre><code class="python"># Author: Warren Weckesser

Z = np.array([1,2,3,4,5])
nz = 3
Z0 = np.zeros(len(Z) + (len(Z)-1)*(nz))
Z0[::nz+1] = Z
print(Z0)
</code></pre>

<h4><strong>71. 考虑一个维度(5,5,3)的数组，如何将其与一个(5,5)的数组相乘？</strong> (★★★)</h4>

(<strong>提示</strong>: array&#91;:, :, None&#93;)

<pre><code class="python">A = np.ones((5,5,3))
B = 2*np.ones((5,5))
print(A * B[:,:,None])
</code></pre>

<h4><strong>72. 如何对一个数组中任意两行做交换?</strong> (★★★)</h4>

(<strong>提示</strong>: array&#91;&#91;&#93;&#93; = array&#91;&#91;&#93;&#93;)

<pre><code class="python"># Author: Eelco Hoogendoorn

A = np.arange(25).reshape(5,5)
A[[0,1]] = A[[1,0]]
print(A)
</code></pre>

<h4><strong>73. 思考描述10个三角形（共享顶点）的一组10个三元组，找到组成所有三角形的唯一线段集</strong> (★★★)</h4>

(<strong>提示</strong>: repeat, np.roll, np.sort, view, np.unique)

<pre><code class="python"># Author: Nicolas P. Rougier

faces = np.random.randint(0,100,(10,3))
F = np.roll(faces.repeat(2,axis=1),-1,axis=1)
F = F.reshape(len(F)*3,2)
F = np.sort(F,axis=1)
G = F.view( dtype=[('p0',F.dtype),('p1',F.dtype)] )
G = np.unique(G)
print(G)
</code></pre>

<h4><strong>74. 给定一个二进制的数组<code>C</code>，如何生成一个数组<code>A</code>满足<code>np.bincount(A)==C</code>?</strong> (★★★)</h4>

(<strong>提示</strong>: np.repeat)

<pre><code class="python"># Author: Jaime Fernández del Río

C = np.bincount([1,1,2,3,4,4,6])
A = np.repeat(np.arange(len(C)), C)
print(A)
</code></pre>

<h4><strong>75. 如何通过滑动窗口计算一个数组的平均数?</strong> (★★★)</h4>

(<strong>提示</strong>: np.cumsum)

<pre><code class="python"># Author: Jaime Fernández del Río

def moving_average(a, n=3) :
    ret = np.cumsum(a, dtype=float)
    ret[n:] = ret[n:] - ret[:-n]
    return ret[n - 1:] / n
Z = np.arange(20)
print(moving_average(Z, n=3))
</code></pre>

<h4><strong>76. 思考以为数组Z，构建一个二维数组，其第一行是(Z&#91;0&#93;,Z&#91;1&#93;,Z&#91;2&#93;)， 然后每一行移动一位，最后一行为 (Z&#91;-3&#93;,Z&#91;-2&#93;,Z&#91;-1&#93;)</strong> (★★★)</h4>

(<strong>提示</strong>: from numpy.lib import stride&#95;tricks)

<pre><code class="python"># Author: Joe Kington / Erik Rigtorp
from numpy.lib import stride_tricks

def rolling(a, window):
    shape = (a.size - window + 1, window)
    strides = (a.itemsize, a.itemsize)
    return stride_tricks.as_strided(a, shape=shape, strides=strides)
Z = rolling(np.arange(10), 3)
print(Z)
</code></pre>

<h4><strong>77. 如何对布尔值取反，或改变浮点数的符号(<code>sign</code>)?</strong> (★★★)</h4>

(<strong>提示</strong>: np.logical_not, np.negative)

<pre><code class="python"># Author: Nathaniel J. Smith

Z = np.random.randint(0,2,100)
np.logical_not(Z, out=Z)

Z = np.random.uniform(-1.0,1.0,100)
np.negative(Z, out=Z)
</code></pre>

<h4><strong>78. 思考两组点集<code>P0</code>和<code>P1</code>去描述一组线(二维)和一个点<code>p</code>,如何计算点<code>p</code>到每一条线 i <code>(P0[i],P1[i])</code>的距离？</strong> (★★★)</h4>

<pre><code class="python">def distance(P0, P1, p):
    T = P1 - P0
    L = (T**2).sum(axis=1)
    U = -((P0[:,0]-p[...,0])*T[:,0] + (P0[:,1]-p[...,1])*T[:,1]) / L
    U = U.reshape(len(U),1)
    D = P0 + U*T - p
    return np.sqrt((D**2).sum(axis=1))

P0 = np.random.uniform(-10,10,(10,2))
P1 = np.random.uniform(-10,10,(10,2))
p  = np.random.uniform(-10,10,( 1,2))
print(distance(P0, P1, p))
</code></pre>

<h4><strong>79. 考虑两组点集<code>P0</code>和<code>P1</code>去描述一组线(二维)和一组点集<code>P</code>，如何计算每一个点 <code>j(P[j])</code> 到每一条线 i <code>(P0[i],P1[i])</code>的距离?</strong> (★★★)</h4>

<pre><code class="python"># Author: Italmassov Kuanysh

# based on distance function from previous question
P0 = np.random.uniform(-10, 10, (10,2))
P1 = np.random.uniform(-10,10,(10,2))
p = np.random.uniform(-10, 10, (10,2))
print(np.array([distance(P0,P1,p_i) for p_i in p]))
</code></pre>

<h4><strong>80. 思考一个任意的数组，编写一个函数，该函数提取一个具有固定形状的子部分，并以一个给定的元素为中心(在该部分填充值)</strong> (★★★)</h4>

(<strong>提示</strong>: minimum, maximum)

<pre><code class="python"># Author: Nicolas Rougier

Z = np.random.randint(0,10,(10,10))
shape = (5,5)
fill  = 0
position = (1,1)

R = np.ones(shape, dtype=Z.dtype)*fill
P  = np.array(list(position)).astype(int)
Rs = np.array(list(R.shape)).astype(int)
Zs = np.array(list(Z.shape)).astype(int)

R_start = np.zeros((len(shape),)).astype(int)
R_stop  = np.array(list(shape)).astype(int)
Z_start = (P-Rs//2)
Z_stop  = (P+Rs//2)+Rs%2

R_start = (R_start - np.minimum(Z_start,0)).tolist()
Z_start = (np.maximum(Z_start,0)).tolist()
R_stop = np.maximum(R_start, (R_stop - np.maximum(Z_stop-Zs,0))).tolist()
Z_stop = (np.minimum(Z_stop,Zs)).tolist()

r = [slice(start,stop) for start,stop in zip(R_start,R_stop)]
z = [slice(start,stop) for start,stop in zip(Z_start,Z_stop)]
R[r] = Z[z]
print(Z)
print(R)
</code></pre>