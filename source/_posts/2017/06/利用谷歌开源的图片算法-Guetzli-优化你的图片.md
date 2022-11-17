---
title: 利用谷歌开源的图片算法 Guetzli 优化你的图片
date: 2017-06-19 16:25:03
en_title: Use Guetzli optimize you pictures
tags: [Software, Google]
---

## 前言

​

2017年3月16日谷歌新开源了一个图片压缩优化算法Guetzli。

​

[这是谷歌官方的博客](https://research.googleblog.com/2017/03/announcing-guetzli-new-open-source-jpeg.html)

​

这是一种JPEG的编码器，比目前其它压缩图片的方法大小大约减少了35%。

​

使用后质量不但没有损失，甚至还更加优化。

​

[这是鹅厂的体验报告](https://www.qcloud.com/community/article/803059001490081184?fromSource=gwzcw.59321.59321.59321)

​

你可以在GitHub上获取个人版本的源码，对其进行重建。

​

[这是地址](https://github.com/google/guetzli/)

​

本文就将指导读者如何利用这“新玩意”来优化你的JPEG图像。

​

## 情景假设

​

假设你的网站上有1000个JPEG图片，设每张图的大小为100KB，

​

如果Guetzli可以将文件大小减小30%，这样可以网站上的图片总存储容量将减少30MB。

​

这样用户端的下载速度会加快，减小了服务器的负担。

​

## 正文

​

FileOptimizer是一个通用文件优化器，它是Guetzli支持的程序之一。

​

[这是它的下载地址](http://nikkhokkho.sourceforge.net/static.php?page=FileOptimizer)（需要梯子）

​

这个程序很简单，我们只需要将要优化的图片拖放到软件中，然后从菜单中选择优化即可。

​

**但是要注意：**

​

Guetzli不是默认的解码器，因为它并不是无损的，所以要在FileOptimizer中启用Guetzli支持。所以你需要执行以下步骤：

​

1. 在安装路径下打开FileOptimizer你安装的位数.ini

​

小编的是

​

```
D:\FileOptimizer\FileOptimizer64.ini
```

​

![](//blog-10039692.file.myqcloud.com/1491064873494_7246_1491064873147.png)

​

2.找到JPEGAllowLossy参数，并将其设置为true。

​

在26行（Notepad++打开）

​

![](//blog-10039692.file.myqcloud.com/1491064908610_5758_1491064907747.jpg)

​

3.重启FileOptimizer软件

​

## 优化你的图片

​

![](//blog-10039692.file.myqcloud.com/1491063031742_4556_1491063032503.png)

​

小编随便使用了几张图片

​

**最后看见优化效果还是不错的**

​

![](//blog-10039692.file.myqcloud.com/1491066193888_156_1491066192357.png)

​

只不过最终具体值还是与官方放出来的数据有点偏差的。

​

## 不足

​

但是有一个缺点就是运行Guetzli时间较长。 具体需要多长时间取决于图像的大小，如果超过1MB，会很慢（一分钟或更长时间）。 不过，对于网站管理员来说，这是值得的。 

​

最好用一台备用电脑，24小时运行来运行压缩任务（[腾讯云](https://www.qcloud.com/product/cvm?fromSource=gwzcw.82794.82794.82794)可以的~哈哈）

​

**最后附上软件下载地址送给没有梯子的读者**

​

链接: [http://pan.baidu.com/s/1kV2YMyF](http://pan.baidu.com/s/1kV2YMyF) 密码: ying

​

![](//blog-10039692.file.myqcloud.com/1491066149480_6316_1491066147937.jpg)

​

​

​

**相关推荐：**

[Google Guetzli图片压缩算法预研报告](https://www.qcloud.com/community/article/42095001490669609?fromSource=gwzcw.82790.82790.82790)

[谷歌开源图片压缩算法Guetzli实测体验报告](https://www.qcloud.com/community/article/803059001490081184?fromSource=gwzcw.82791.82791.82791)

[Guetzli：谷歌家的东西可能也没有想像的辣么美](https://www.qcloud.com/community/article/648304001490664854?fromSource=gwzcw.82793.82793.82793)