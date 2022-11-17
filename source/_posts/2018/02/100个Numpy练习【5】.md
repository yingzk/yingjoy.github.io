---
title: 100个Numpy练习【5】
date: 2018-02-26 15:55:32
en_title: 100 practices for Numpy -- 5
tags: [Python, Numpy, 数据分析]
permalink: /100numpy/5
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

<h4><strong>81. 考虑一个数组<code>Z = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]</code>,如何生成一个数组<code>R = [[1,2,3,4], [2,3,4,5], [3,4,5,6], ...,[11,12,13,14]]</code>?</strong> (★★★)</h4>

(<strong>提示</strong>: stride&#95;tricks.as&#95;strided)

<pre><code class="python"># Author: Stefan van der Walt

Z = np.arange(1,15,dtype=np.uint32)
R = stride_tricks.as_strided(Z,(11,4),(4,4))
print(R)
</code></pre>

<h4><strong>82. 计算矩阵的秩</strong> (★★★)</h4>

(<strong>提示</strong>: np.linalg.svd)

<pre><code class="python"># Author: Stefan van der Walt

Z = np.random.uniform(0,1,(10,10))
U, S, V = np.linalg.svd(Z) # Singular Value Decomposition
rank = np.sum(S &gt; 1e-10)
print(rank)
</code></pre>

<h4><strong>83. 如何找出数组中出现频率最高的值?</strong>(★★★)</h4>

(<strong>提示</strong>: np.bincount, argmax)

<pre><code class="python">Z = np.random.randint(0,10,50)
print(np.bincount(Z).argmax())
</code></pre>

<h4><strong>84. 从一个<code>10x10</code>的矩阵中提取出连续的<code>3x3</code>区块</strong>(★★★)</h4>

(<strong>提示</strong>: stride&#95;tricks.as&#95;strided)

<pre><code class="python"># Author: Chris Barker

Z = np.random.randint(0,5,(10,10))
n = 3
i = 1 + (Z.shape[0]-3)
j = 1 + (Z.shape[1]-3)
C = stride_tricks.as_strided(Z, shape=(i, j, n, n), strides=Z.strides + Z.strides)
print(C)
</code></pre>

<h4><strong>85.创建一个满足 <code>Z[i,j] == Z[j,i]</code>的二维数组子类</strong> (★★★)</h4>

(<strong>提示</strong>: class method)

<pre><code class="python"># Author: Eric O. Lebigot
# Note: only works for 2d array and value setting using indices

class Symetric(np.ndarray):
    def __setitem__(self, index, value):
        i,j = index
        super(Symetric, self).__setitem__((i,j), value)
        super(Symetric, self).__setitem__((j,i), value)

def symetric(Z):
    return np.asarray(Z + Z.T - np.diag(Z.diagonal())).view(Symetric)

S = symetric(np.random.randint(0,10,(5,5)))
S[2,3] = 42
print(S)
</code></pre>

<h4><strong>86. 考虑p个 <code>nxn</code> 矩阵和一组形状为<code>(n,1)</code>的向量，如何直接计算p个矩阵的乘积<code>(n,1)</code>?</strong> (★★★)</h4>

(<strong>提示</strong>: np.tensordot)

<pre><code class="python"># Author: Stefan van der Walt

p, n = 10, 20
M = np.ones((p,n,n))
V = np.ones((p,n,1))
S = np.tensordot(M, V, axes=[[0, 2], [0, 1]])
print(S)

# It works, because:
# M is (p,n,n)
# V is (p,n,1)
# Thus, summing over the paired axes 0 and 0 (of M and V independently),
# and 2 and 1, to remain with a (n,1) vector.
</code></pre>

<h4><strong>87. 对于一个<code>16x16</code>的数组，如何得到一个区域的和(区域大小为<code>4x4</code>)?</strong> (★★★)</h4>

(<strong>提示</strong>: np.add.reduceat)

<pre><code class="python"># Author: Robert Kern

Z = np.ones((16,16))
k = 4
S = np.add.reduceat(np.add.reduceat(Z, np.arange(0, Z.shape[0], k), axis=0), np.arange(0, Z.shape[1], k), axis=1)
print(S)
</code></pre>

<h4><strong>88. 如何利用<code>numpy</code>数组实现Game of Life?</strong> (★★★)</h4>

(<strong>提示</strong>: <a href="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life">Game of Life</a>  ,  <a href="https://www.zhihu.com/question/30782166">Game of Life有哪些图形？</a>)

<pre><code class="python"># Author: Nicolas Rougier

def iterate(Z):
    # Count neighbours
    N = (Z[0:-2,0:-2] + Z[0:-2,1:-1] + Z[0:-2,2:] +
         Z[1:-1,0:-2]                + Z[1:-1,2:] +
         Z[2:  ,0:-2] + Z[2:  ,1:-1] + Z[2:  ,2:])

    # Apply rules
    birth = (N==3) &amp; (Z[1:-1,1:-1]==0)
    survive = ((N==2) | (N==3)) &amp; (Z[1:-1,1:-1]==1)
    Z[...] = 0
    Z[1:-1,1:-1][birth | survive] = 1
    return Z

Z = np.random.randint(0,2,(50,50))
for i in range(100): Z = iterate(Z)
print(Z)
</code></pre>

<h4><strong>89. 如何找到一个数组的第n个最大值?</strong>  (★★★)</h4>

(<strong>提示</strong>: np.argsort | np.argpartition)

<pre><code class="python">Z = np.arange(10000)
np.random.shuffle(Z)
n = 5

# Slow
print (Z[np.argsort(Z)[-n:]])

# Fast
print (Z[np.argpartition(-Z,n)[:n]])
</code></pre>

<h4><strong>90. 给定任意个数向量，创建笛卡尔积(每一个元素的每一种组合)</strong> (★★★)</h4>

(<strong>提示</strong>: np.indices)

<pre><code class="python"># Author: Stefan Van der Walt

def cartesian(arrays):
    arrays = [np.asarray(a) for a in arrays]
    shape = (len(x) for x in arrays)

    ix = np.indices(shape, dtype=int)
    ix = ix.reshape(len(arrays), -1).T

    for n, arr in enumerate(arrays):
        ix[:, n] = arrays[n][ix[:, n]]

    return ix

print (cartesian(([1, 2, 3], [4, 5], [6, 7])))
</code></pre>

<h4><strong>91. 如何从一个常规数组中创建记录数组(<code>record array</code>)?</strong> (★★★)</h4>

(<strong>提示</strong>: np.core.records.fromarrays)

<pre><code class="python">Z = np.array([("Hello", 2.5, 3),
              ("World", 3.6, 2)])
R = np.core.records.fromarrays(Z.T, 
                               names='col1, col2, col3',
                               formats = 'S8, f8, i8')
print(R)
</code></pre>

<h4><strong>92. 思考一个大向量<code>Z</code>, 用三种不同的方法计算它的立方</strong> (★★★)</h4>

(<strong>提示</strong>: np.power, &#42;, np.einsum)

<pre><code class="python"># Author: Ryan G.

x = np.random.rand(5e7)

%timeit np.power(x,3)
%timeit x*x*x
%timeit np.einsum('i,i,i-&gt;i',x,x,x)
</code></pre>

<h4><strong>93. 考虑两个形状分别为<code>(8,3)</code> 和<code>(2,2)</code>的数组<code>A</code>和<code>B</code>. 如何在数组<code>A</code>中找到满足包含<code>B</code>中元素的行？(不考虑<code>B</code>中每行元素顺序)？</strong> (★★★)</h4>

(<strong>提示</strong>: np.where)

<pre><code class="python"># Author: Gabe Schwartz

A = np.random.randint(0,5,(8,3))
B = np.random.randint(0,5,(2,2))

C = (A[..., np.newaxis, np.newaxis] == B)
rows = np.where(C.any((3,1)).all(1))[0]
print(rows)
</code></pre>

<h4><strong>94. 思考一个<code>10x3</code>的矩阵，如何分解出有不全相同值的行 (如 <code>[2,2,3]</code>)</strong>  (★★★)</h4>

<pre><code class="python"># Author: Robert Kern

Z = np.random.randint(0,5,(10,3))
print(Z)
# solution for arrays of all dtypes (including string arrays and record arrays)
E = np.all(Z[:,1:] == Z[:,:-1], axis=1)
U = Z[~E]
print(U)
# soluiton for numerical arrays only, will work for any number of columns in Z
U = Z[Z.max(axis=1) != Z.min(axis=1),:]
print(U)
</code></pre>

<h4><strong>95. 将一个整数向量转换为二进制矩阵</strong> (★★★)</h4>

(<strong>提示</strong>: np.unpackbits)

<pre><code class="python"># Author: Warren Weckesser

I = np.array([0, 1, 2, 3, 15, 16, 32, 64, 128])
B = ((I.reshape(-1,1) &amp; (2**np.arange(8))) != 0).astype(int)
print(B[:,::-1])

# Author: Daniel T. McDonald

I = np.array([0, 1, 2, 3, 15, 16, 32, 64, 128], dtype=np.uint8)
print(np.unpackbits(I[:, np.newaxis], axis=1))
</code></pre>

<h4><strong>96. 给定一个二维数组，如何提取出唯一的行?</strong>(★★★)</h4>

(<strong>提示</strong>: np.ascontiguousarray)

<pre><code class="python"># Author: Jaime Fernández del Río

Z = np.random.randint(0,2,(6,3))
T = np.ascontiguousarray(Z).view(np.dtype((np.void, Z.dtype.itemsize * Z.shape[1])))
_, idx = np.unique(T, return_index=True)
uZ = Z[idx]
print(uZ)
</code></pre>

<h4><strong>97. 考虑两个向量<code>A</code>和<code>B</code>，写出用<code>einsum</code>等式对应的<code>inner, outer, sum, mul</code>函数</strong> (★★★)</h4>

(<strong>提示</strong>: np.einsum)

<pre><code class="python"># Author: Alex Riley
# Make sure to read: http://ajcr.net/Basic-guide-to-einsum/

A = np.random.uniform(0,1,10)
B = np.random.uniform(0,1,10)

np.einsum('i-&gt;', A)       # np.sum(A)
np.einsum('i,i-&gt;i', A, B) # A * B
np.einsum('i,i', A, B)    # np.inner(A, B)
np.einsum('i,j-&gt;ij', A, B)    # np.outer(A, B)
</code></pre>

<h4><strong>98. 考虑一个由两个向量描述的路径<code>(X,Y)</code>，如何用等距样例(<code>equidistant samples</code>)对其进行采样(<code>sample</code>)</strong>(★★★)?</h4>

(<strong>提示</strong>: np.cumsum, np.interp)

<pre><code class="python"># Author: Bas Swinckels

phi = np.arange(0, 10*np.pi, 0.1)
a = 1
x = a*phi*np.cos(phi)
y = a*phi*np.sin(phi)

dr = (np.diff(x)**2 + np.diff(y)**2)**.5 # segment lengths
r = np.zeros_like(x)
r[1:] = np.cumsum(dr)                # integrate path
r_int = np.linspace(0, r.max(), 200) # regular spaced path
x_int = np.interp(r_int, r, x)       # integrate path
y_int = np.interp(r_int, r, y)
</code></pre>

<h4><strong>99. 给定一个整数n 和一个二维数组X，从X中选择可以被解释为从多n度的多项分布式的行，即这些行只包含整数对n的和.</strong> (★★★)</h4>

(<strong>提示</strong>: np.logical&#95;and.reduce, np.mod)

<pre><code class="python"># Author: Evgeni Burovski

X = np.asarray([[1.0, 0.0, 3.0, 8.0],
                [2.0, 0.0, 1.0, 1.0],
                [1.5, 2.5, 1.0, 0.0]])
n = 4
M = np.logical_and.reduce(np.mod(X, 1) == 0, axis=-1)
M &amp;= (X.sum(axis=-1) == n)
print(X[M])
</code></pre>

<h4><strong>100. 对于一个一维数组<code>X</code>，计算它boostrapped之后的95%置信区间的平均值.</strong> (★★★)</h4>

(<strong>提示</strong>: np.percentile)

<pre><code class="python"># Author: Jessica B. Hamrick

X = np.random.randn(100) # random 1D array
N = 1000 # number of bootstrap samples
idx = np.random.randint(0, X.size, (N, X.size))
means = X[idx].mean(axis=1)
confint = np.percentile(means, [2.5, 97.5])
print(confint)
</code></pre>