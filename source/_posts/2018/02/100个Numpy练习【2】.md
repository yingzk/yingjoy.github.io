---
title: 100个Numpy练习【2】
date: 2018-02-26 15:46:53
en_title: 100 practices for Numpy -- 2
tags: [Python, Numpy, 数据分析]
permalink: /100numpy/2
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

<h4><strong>21. 用tile函数创建一个8x8的棋盘矩阵</strong>(★☆☆)</h4>

(<strong>提示</strong>: np.tile)

<pre><code class="python">Z = np.tile(np.array([[1, 0], [0, 1]]), (4, 4))
print (Z)
</code></pre>

<h4><strong>22. 对5x5的随机矩阵进行归一化</strong> (★☆☆)</h4>

(<strong>提示</strong>: (x - min) / (max - min))

<pre><code class="python">Z = np.random.random((5, 5))
Zmax, Zmin = Z.max(), Z.min()
Z = (Z-Zmin)/(Zmax-Zmin)
print (Z)
</code></pre>

<h4><strong>23. 创建一个dtype来表示颜色(RGBA)</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.dtype)

<pre><code class="python">color = np.dtype([("r", np.ubyte, 1),
                  ("g", np.ubyte, 1),
                  ("b", np.ubyte, 1),
                  ("a", np.ubyte, 1)])
c = np.array((255, 255, 255, 1), dtype=color)
print (c)

Out[80]:
array((255, 255, 255, 1),
      dtype=[('r', 'u1'), ('g', 'u1'), ('b', 'u1'), ('a', 'u1')])
</code></pre>

<h4><strong>24. 一个5x3的矩阵和一个3x2的矩阵相乘，结果是什么？</strong>(★☆☆)</h4>

(<strong>提示</strong>: np.dot | @)

<pre><code class="python">Z = np.dot(np.zeros((5, 3)), np.zeros((3, 2)))
# 或者
Z = np.zeros((5, 3))@ np.zeros((3, 2))
print (Z)
</code></pre>

<h4><strong>25. 给定一个一维数组把它索引从3到8的元素进行取反</strong> (★☆☆)</h4>

(<strong>提示</strong>: >, &lt;=)

<pre><code class="python">Z = np.arange(11)
Z[(3 &lt;= Z) &amp; (Z &lt; 8)] *= -1
print (Z)
</code></pre>

<h4><strong>26. 下面的脚本的结果是什么？</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.sum)

<pre><code class="python"># Author: Jake VanderPlas               # 结果

print(sum(range(5),-1))                 9
from numpy import *                     
print(sum(range(5),-1))                 10    #numpy.sum(a, axis=None)
</code></pre>

<h4><strong>27. 关于整形的向量Z下面哪些表达式正确？</strong> (★☆☆)</h4>

<pre><code class="python">Z**Z                        True
2 &lt;&lt; Z &gt;&gt; 2                 False
Z &lt;- Z                      True
1j*Z                        True  #复数           
Z/1/1                       True
Z&lt;Z&gt;Z                       False
</code></pre>

<h4><strong>28. 下面表达式的结果分别是什么？</strong> (★☆☆)</h4>

<pre><code class="python">np.array(0) / np.array(0)                           nan
np.array(0) // np.array(0)                          0
np.array([np.nan]).astype(int).astype(float)        -2.14748365e+09
</code></pre>

<h4><strong>29. 如何从零位开始舍入浮点数组？</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.uniform, np.copysign, np.ceil, np.abs)

<pre><code class="python"># Author: Charles R Harris

Z = np.random.uniform(-10,+10,10)
print (np.copysign(np.ceil(np.abs(Z)), Z))
</code></pre>

<h4><strong>30. 如何找出两个数组公共的元素?</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.intersect1d)

<pre><code class="python">Z1 = np.random.randint(0, 10, 10)
Z2 = np.random.randint(0, 10, 10)
print (np.intersect1d(Z1, Z2))
</code></pre>

<h4><strong>31. 如何忽略numpy的警告信息（不推荐）?</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.seterr, np.errstate)

<pre><code class="python"># Suicide mode on
defaults = np.seterr(all="ignore")
Z = np.ones(1) / 0

# Back to sanity
_ = np.seterr(**defaults)

# 另一个等价的方式， 使用上下文管理器（context manager）
with np.errstate(divide='ignore'):
    Z = np.ones(1) / 0
</code></pre>

<h4><strong>32. 下面的表达式是否为真?</strong> (★☆☆)</h4>

(<strong>提示</strong>: 虚数)

<pre><code class="python">np.sqrt(-1) == np.emath.sqrt(-1)     Faslse
</code></pre>

<h4><strong>33. 如何获得昨天，今天和明天的日期?</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.datetime64, np.timedelta64)

<pre><code class="python">yesterday = np.datetime64('today', 'D') - np.timedelta64(1, 'D')
today = np.datetime64('today', 'D')
tomorrow = np.datetime64('today', 'D') + np.timedelta64(1, 'D')
</code></pre>

<h4><strong>34. 怎么获得所有与2016年7月的所有日期?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.arange(dtype=datetime64&#91;'D'&#93;))

<pre><code class="python">Z = np.arange('2016-07', '2016-08', dtype='datetime64[D]')
print (Z)
</code></pre>

<h4><strong>35. 如何计算 ((A+B)&#42;(-A/2)) (不使用中间变量)?</strong> (★★☆)</h4>

(<strong>提示</strong>: np.add(out=), np.negative(out=), np.multiply(out=), np.divide(out=))

<pre><code class="python">A = np.ones(3) * 1
B = np.ones(3) * 1
C = np.ones(3) * 1
np.add(A, B, out=B)
np.divide(A, 2, out=A)
np.negative(A, out=A)
np.multiply(A, B, out=A)
</code></pre>

<h4><strong>36. 用5种不同的方法提取随机数组中的整数部分</strong> (★★☆)</h4>

(<strong>提示</strong>: %, np.floor, np.ceil, astype, np.trunc)

<pre><code class="python">Z = np.random.uniform(0, 10, 10)
print (Z - Z % 1)
print (np.floor(Z))
print (np.cell(Z)-1)
print (Z.astype(int))
print (np.trunc(Z))
</code></pre>

<h4><strong>37. 创建一个5x5的矩阵且每一行的值范围为从0到4</strong> (★★☆)</h4>

(<strong>提示</strong>: np.arange)

<pre><code class="python">Z = np.zeros((5, 5))
Z += np.arange(5)
print (Z)
</code></pre>

<h4><strong>38. 如何用一个生成10个整数的函数来构建数组</strong> (★☆☆)</h4>

(<strong>提示</strong>: np.fromiter)

<pre><code class="python">def generate():
    for x in range(10):
      yield x
Z = np.fromiter(generate(), dtype=float, count=-1)
print (Z)
</code></pre>

<h4><strong>39. 创建一个大小为10的向量， 值域为0到1，不包括0和1</strong> (★★☆)</h4>

(<strong>提示</strong>: np.linspace)

<pre><code class="python">Z = np.linspace(0, 1, 12, endpoint=True)[1: -1]
print (Z)
</code></pre>

<h4><strong>40. 创建一个大小为10的随机向量，并把它排序</strong> (★★☆)</h4>

(<strong>提示</strong>: sort)

<pre><code class="python">Z = np.random.random(10)
Z.sort()
print (Z)
</code></pre>