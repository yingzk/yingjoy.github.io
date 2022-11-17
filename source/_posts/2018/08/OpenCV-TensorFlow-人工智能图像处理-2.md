---
title: OpenCV+TensorFlow 人工智能图像处理  (2)
date: 2018-08-19 22:18:35
en_title: OpenCV+TensorFlow artificial intelligence image processing 2
tags: [OpenCV, Python, Tensorflow, AI, Deep Learning]
---

<h1>1. 图片缩放</h1>

<pre><code class="python"># 1. 加载图片
# 2. 获取图片信息（宽度，高度）
# 3. 调用OpenCV的resize方法，进行图片的缩放
# 4. 检查最终的结果
import cv2
</code></pre>

<pre><code class="python">img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
print (imgInfo)
height = imgInfo[0]
width = imgInfo[1]
mode = imgInfo[2] # 颜色的储存方式，由3种颜色(bgr)组成
# 放大， 缩小， 等比缩放 非等比缩放
dstHeight = int(height*0.5) # 目标高度
dstWidth = int(width*0.5)
# 四种resize: 最近邻域插值 双线性插值 像素关系重采样 立方插值
dst = cv2.resize(img, (dstWidth, dstHeight))
cv2.imshow("image", dst)
cv2.waitKey(0)
</code></pre>

<pre><code>(547, 730, 3)

-1
</code></pre>

<h1>2. 最近邻域插值、双线性插值原理</h1>

<ul>
<li>最近邻域插值  <br>
原图像：10&#42;20 <br>
目标图像： 5&#42;10 <br>
目标图像的像素来源于原图像 <br>
<strong>举例：</strong> <br>
目标图像（1, 2）来源于原图像（2, 4）<br>
如何计算： <br>
newX = 原图x&#42;(原图像的行/目标图像的行) <br>
newY = 原图y&#42;(原图像的列/目标图像的列) <br>
比如目标图像的第一列的第一个点，来源于原图像的第一列的二个点（1&#42; (10/5) = 2） <br>
目标图像(2, 3)点，来源于(4, 6)</p></li>
<li><p>双线性插值 <br>
A1 = 20%上 + 80%下 A2 <br>
B1 = 30%上 + 70%下 B2 <br>
<img src="https://img.yingjoy.cn/image/2018/08/1-2.png" alt="" /></p></li>
</ul>

<pre><code class="python"># 最近邻域插值
# 1. 获取图片信息
# 2. 创建一个空白模板，与预期目标大小一样
# 3. 计算对应的像素
import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
height = imgInfo[0]
width = imgInfo[1]
dstHeight = int(height/2)
dstWidth = int(width/2)
dstImage = np.zeros((dstHeight, dstWidth, 3), np.uint8) # 0-255
for i in range(0, dstHeight): # 行
    for j in range(0, dstWidth): # 列
        iNew = int(i*(height*1.0/dstHeight))
        jNew = int(j*(width*1.0/dstWidth))
        dstImage[i, j] = img[iNew, jNew]

cv2.imshow('dstImage', dstImage)
cv2.waitKey(0)
</code></pre>

<pre><code>1114089
</code></pre>

<h1>2. 图片剪切</h1>

<pre><code class="python"># 剪切(100, 100) -&gt; (200, 300)
import cv2
img = cv2.imread('images/image0.jpg', 1)
dst = img[100:200, 100:300]
# 将蓝红通道设为0
dst[:, :, [0, 2]] = 0
cv2.imshow("image", dst)
cv2.waitKey(0)
</code></pre>

<pre><code>-1
</code></pre>

<h1>3. 图片移位</h1>

<pre><code class="python">import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
cv2.imshow('src', img)
imgInfo = img.shape
height, width = imgInfo[0], imgInfo[1]
# 进行矩阵的移位
matShift = np.float32([[1, 0, 100], [0, 1, 200]]) # 2*3
dst = cv2.warpAffine(img, matShift, (height, width)) # 矩阵映射，原图， 移位矩阵， 图片的高度和宽度
cv2.imshow('dst', dst)
cv2.waitKey(0)
</code></pre>

<pre><code>1048603
</code></pre>

<p>[[1, 0, 100], [0, 1, 200]] <br>
转变为2个矩阵： <br>
[[1, 0], [0, 1]] 和 [[100], [200]]  <br>
分别对应A和B矩阵，原图像为C[x, y] <br>
A &#42; C + B = [[1<em>x+0</em>y], [0<em>x+1</em>y]] + [[100], [200]]

<pre><code class="python"># 算法原理实现图片移位
import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
cv2.imshow('src', img)
imgInfo = img.shape
dst = np.zeros(img.shape, np.uint8)
height, width = imgInfo[0], imgInfo[1]
for i in range(0, height):
    for j in range(0, width-100):
        dst[i, j+100] = img[i, j]
cv2.imshow('dst', dst)
cv2.waitKey(0)
</code></pre>

<pre><code>-1
</code></pre>

<h1>4. 图片镜像</h1>

<pre><code class="python"># 1. 创建一个足够大的画板
# 2. 将一副图像从前向后，从后向前绘制
# 3. 绘制中心分割线
import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
height, width, deep = imgInfo[0], imgInfo[1], imgInfo[2]
newImgInfo = (height*2, width, deep)
dst = np.zeros(newImgInfo, np.uint8)
for i in range(height):
    for j in range(width):
        dst[i, j] = img[i, j]
        # 绘制镜像部分， x轴不变， y = 2*h - y - 1
        dst[height*2-i-1, j] = img[i, j]
for i in range(width):
    dst[height, i] = (0, 0, 255)
cv2.imshow('image', dst)
cv2.waitKey(0)
</code></pre>

<pre><code>-1
</code></pre>

<h1>5. 图片缩放</h1>

<pre><code class="python"># 缩放1倍
import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
height, width = imgInfo[0], imgInfo[1]
matScale = np.float32([[0.5, 0, 0], [0, 0.5, 0]])
dst = cv2.warpAffine(img, matScale, (int(width/2), int(height/2)))
cv2.imshow('dst', dst)
cv2.waitKey(0)
</code></pre>

<pre><code>-1
</code></pre>

<h1>6. 仿射变换</h1>

<pre><code class="python">import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
height, width = imgInfo[0], imgInfo[1]
# 3点确定一个平面，分别是左上角， 左下角， 右上角
matSrc = np.float32([[0, 0], [0, height], [width, 0]])
matDst = np.float32([[50, 50], [300, height-200], [width-300, 100]])
# 组合
matAffine = cv2.getAffineTransform(matSrc, matDst) # 获取矩阵组合, 1: 描述原矩阵的三点， 2： 目标矩阵的三点
dst = cv2.warpAffine(img, matAffine, (width, height))
cv2.imshow('image', dst)
cv2.waitKey(0)
</code></pre>

<h1>7. 旋转图片</h1>

<pre><code class="python">import cv2
import numpy as np
img = cv2.imread('images/image0.jpg', 1)
imgInfo = img.shape
height, width = imgInfo[0], imgInfo[1]
# 定义旋转矩阵
matRotate = cv2.getRotationMatrix2D((height*0.5, width*0.5), 45, 1) # 得到旋转矩阵， 1 旋转中心店， 2 旋转角度， 3 缩放系数
dst = cv2.warpAffine(img, matRotate, (width, height))
cv2.imshow('image', dst)
cv2.waitKey(0)
</code></pre>

<pre><code>-1
</code></pre>