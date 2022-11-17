---
title: QCloud_OCR 身份证识别 初探
date: 2017-06-19 16:25:03
en_title: QCloud OCR
tags: [OCR]
---

## 前言

​

![](//blog-10039692.file.myqcloud.com/1506494186892_3240_1506494186751.jpg)

很久没写文章了，额，因为最近自己整了一个网站

大部分精力投在了[我的个人网站 (www.yingjoy.cn)](https://www.yingjoy.cn)上，喜欢皮卡丘文章的朋友可以关注下哦

​

​

今天给大家带来的是腾讯云的[OCR文字识别](https://cloud.tencent.com/product/ocr?idx=1)

如何使用它来识别身份证

​

当然，它还可以识别名片，还有许多功能，喜欢研究的小伙伴可以深入深入

​

本教程采用了Python语言，需要其他编程语言的，可以参考[腾讯云的SDK文档](https://cloud.tencent.com/document/product/460/7991)

​

## 正文

好了，现在开始正文

​

### 第一步~下载

首先去SDK文档中下载我们所需要的SDK

![](//blog-10039692.file.myqcloud.com/1506492862856_3698_1506492862723.png)

​

点开这个连接你就会进入腾讯云这个项目的github，直接下载

你会得到

![](//blog-10039692.file.myqcloud.com/1506492933839_317_1506492933695.png)

​

接下来把它解压出来

​

### 第二步~安装(我这里展示python的方法)

打开`cmd`进入刚刚解压的路径

​

然后执行`python setup.py install` 

![](//blog-10039692.file.myqcloud.com/1506493081442_8968_1506493081692.png)

​

安装完毕

​

### 第三步~编码

在解压的目录下新建测试文件 `test.py`

然后根据文档提供的信息，进行编码（编码内容最后放出来）

​

### 第四步~创建万象优图的Bucket

地址: [https://console.cloud.tencent.com/ci/bucket](https://console.cloud.tencent.com/ci/bucket)

必须先登陆控制台

![](//blog-10039692.file.myqcloud.com/1506493410099_8183_1506493410310.png)

​

创建好Bucket后，查看我们的appid, secret\_id, secret\_key, bucket

​

进入[云API密钥](https://console.cloud.tencent.com/capi)进行查看

​

![](//blog-10039692.file.myqcloud.com/1506493578104_445_1506493578015.png)

​

### 第五步~完成编码并运行

代码如下：

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-


##从qcloud_image包导入相关
from qcloud_image import Client
from qcloud_image import CIUrl, CIFile, CIBuffer, CIUrls, CIFiles, CIBuffers


#设置你的appid, secret_id, secret_key, bucket
appid = '1252480325'
secret_id = 'AKIDiLQQGy9p253zpJOIIDiHj2Nh9cChmGWe'
secret_key = 'hEdqurOmz5lJfrrfRJyWt56vqdLvLadU'
bucket = 'imagetest'

client = Client(appid, secret_id, secret_key, bucket)
client.use_http()
client.set_timeout(30)

#身份证识别
#单个或多个图片file     0表示身份证正面
result = client.idcard_detect(CIFiles(['idcard.jpg']), 0)
```

​

##  **这里说明下** 

​

腾讯云识别身份证的算法可能有点过拟合了，导致许多身份证不能读取，程序最后运行出现错误代码: `-5107`

所以这里笔者提供了一张“身份证”供大家测试

![](//blog-10039692.file.myqcloud.com/1506493850415_2145_1506493850808.jpg)

​

哈哈，测试了很多张，最后这张最好了

其他的都`-5107`了

​

### 目录结构

![](//blog-10039692.file.myqcloud.com/1506493927560_8285_1506493927472.png)

### 运行结果

![](//blog-10039692.file.myqcloud.com/1506494023950_5406_1506494024510.png)

​

好了，最终附上代码github: [https://github.com/yingzk/qcloud\_ocr](https://github.com/yingzk/qcloud_ocr)

​

最后祝大家国庆加中秋快乐  :）
