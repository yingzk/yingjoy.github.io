---
title: 100个Numpy练习【1】
date: 2018-02-26 15:42:51
en_title: 100 practices for Numpy -- 1
tags: [Python, Numpy, 数据分析]
permalink: /100numpy/1
---

<ul>
 	<li><strong>翻译：</strong><a href="https://www.yingjoy.cn/">YingJoy</a></li>
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

<center><img src="http://www.numpy.org/_static/numpy_logo.png" /></center>
<h4><strong>1. 导入numpy库并取别名为np</strong> (★☆☆)</h4>
(<strong>提示</strong>: import … as …)
<pre><code class="python">import numpy as np
</code></pre>
<h4><strong>2. 打印输出numpy的版本和配置信息</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.__verison__, np.show_config)
<pre><code class="python">print (np.__version__)
np.show_config()
</code></pre>
<h4><strong>3. 创建长度为10的零向量</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.zeros)
<pre><code class="python">Z = np.zeros(10)
print (Z)
</code></pre>
<h4><strong>4. 获取数组所占内存大小</strong> (★☆☆)</h4>
(<strong>提示</strong>: size, itemsize)
<pre><code class="python">Z = np.zeros((10, 10))
print (Z.size * Z.itemsize)
</code></pre>
<h4><strong>5. 怎么用命令行获取numpy add函数的文档说明？</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.info)
<pre><code class="python">np.info(np.add)
</code></pre>
<h4><strong>6. 创建一个长度为10的零向量，并把第五个值赋值为1</strong> (★☆☆)</h4>
(<strong>提示</strong>: array[4])
<pre><code class="python">Z = np.zeros(10)
Z[4] = 1
print (Z)
</code></pre>
<h4><strong>7. 创建一个值域为10到49的向量</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.arange)
<pre><code class="python">Z = np.arange(10, 50)
print (Z)
</code></pre>
<h4>8**. 将一个向量进行反转（第一个元素变为最后一个元素）** (★☆☆)</h4>
(<strong>提示</strong>: array[::-1])
<pre><code class="python">Z = np.arange(50)
Z = Z[::-1]
print (Z)
</code></pre>
<h4><strong>9. 创建一个3x3的矩阵，值域为0到8</strong>(★☆☆)</h4>
(<strong>提示</strong>: reshape)
<pre><code class="python">Z = np.arange(9).reshape(3, 3)
print (Z)
</code></pre>
<h4><strong>10. 从数组[1, 2, 0, 0, 4, 0]中找出非0元素的位置索引</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.nonzero)
<pre><code class="python">nz = np.nonzero([1, 2, 0, 0, 4, 0])
print (NZ)
</code></pre>
<h4><strong>11. 创建一个3x3的单位矩阵</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.eye)
<pre><code class="python">Z = np.eye(3)
print (Z)
</code></pre>
<h4><strong>12. 创建一个3x3x3的随机数组</strong>(★☆☆)</h4>
(<strong>提示</strong>: np.random.random)
<pre><code class="python">Z = np.random.random((3, 3, 3))
print (Z)
</code></pre>
<h4><strong>13. 创建一个10x10的随机数组，并找出该数组中的最大值与最小值</strong>(★☆☆)</h4>
(<strong>提示</strong>: max, min)
<pre><code class="python">Z = np.random.random((10, 10))
Zmax, Zmin = Z.max(), Z.min()
print (Z.max, Z.min)
</code></pre>
<h4><strong>14. 创建一个长度为30的随机向量，并求它的平均值</strong> (★☆☆)</h4>
(<strong>提示</strong>: mean)
<pre><code class="python">Z = np.random.random(30)
mean = Z.mean()
print (mean)
</code></pre>
<h4><strong>15. 创建一个2维数组，该数组边界值为1，内部的值为0</strong> (★☆☆)</h4>
(<strong>提示</strong>: array[1:-1, 1:-1])
<pre><code class="python">Z = np.ones((10, 10))
Z[1:-1, 1:-1] = 0
print (Z)
</code></pre>
<h4><strong>16. 如何用0来填充一个数组的边界？</strong> (★☆☆)</h4>
(<strong>提示</strong>: np.pad)
<pre><code class="python">Z = np.ones((10, 10))
Z = np.pad(Z, pad_width=1, mode='constant', constant_values=0)
print (Z)
</code></pre>
<h4><strong>17. 下面表达式运行的结果是什么？</strong>(★☆☆)</h4>
(<strong>提示</strong>: NaN = not a number, inf = infinity)

(<strong>提示</strong>：NaN : 不是一个数，inf : 无穷)
<pre><code class="python"># 表达式                           # 结果
0 * np.nan                        nan
np.nan == np.nan                  False
np.inf &gt; np.nan                   False
np.nan - np.nan                   nan
0.3 == 3 * 0.1                    False
</code></pre>
<h4><strong>18. 创建一个5x5的矩阵，且设置值1, 2, 3, 4在其对角线下面一行</strong>(★☆☆)</h4>
(<strong>提示</strong>: np.diag)
<pre><code class="python">Z = np.diag([1, 2, 3, 4], k=-1)
print (Z)
</code></pre>
<h4><strong>19. 创建一个8x8的棋盘矩阵（填充为棋盘样式）</strong> (★☆☆)</h4>
(<strong>提示</strong>: array[::2])
<pre><code class="python">Z = np.zeros((8, 8), dtype=int)
Z[1::2, ::2] = 1
Z[::2, 1::2] = 1
print (Z)
</code></pre>
<h4><strong>20. 思考一下形状为(6, 7, 8)的数组的形状，且第100个元素的索引(x, y, z)分别是什么？</strong>(★☆☆)</h4>
(<strong>提示</strong>: np.unravel_index)
<pre><code class="python">print (np.unravel_index(100, (6, 7, 8)))
</code></pre>