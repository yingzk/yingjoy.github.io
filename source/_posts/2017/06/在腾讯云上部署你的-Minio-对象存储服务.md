---
title: 在腾讯云上部署你的 Minio 对象存储服务
date: 2017-06-19 16:25:03
en_title: Install Minio on QCloud
tags: [Database, Minio]
---

# 前言

皮卡丘回来啦！

​

![](//blog-10039692.file.myqcloud.com/1499874050768_4214_1499874112862.jpg)

​

经历了痛苦的练车时光，我终于黑了。。。哈哈

​

本次皮卡丘将会给大家介绍一个新玩意——Minio

​

[这是Minio的官网](https://minio.io/)

​

![](//blog-10039692.file.myqcloud.com/1503564766464_2212_1503564768897.png)

# 正文

​

Minio是AWS S3存储的开源实现。Minio提供对象存储服务（非结构化的数据）。

什么是非结构化数据呢？

听名字就能理解：非结构化：数据结构不完整或者不规则

如： 图像、音频、视频、所有格式的办公文档、文本、XML, HTML、各类报表等等。

​

这些数据保存起来不是很方便，所有渐渐出现了网盘这种东西，但由于网盘的一些xx问题，国内很多网盘均已下架。

非结构化的数据类型多，变化大，再加上平时与云端的结合，导致对其进行处理会变得更加复杂，Minio可以很好的适应非结构化的数据，支持AWS的S3

​

好了，下面开始在我们的腾讯云服务器上部署它吧！

YingJoy

# 购买服务器

在这里我的配置:

- 			已选配置
- 			计费模式	按量计费
- 			地域	华南地区（广州）
- 			可用区	广州二区
- 			机型	系列1、标准型S1、1核CPU、1G内存
- 			镜像	CentOS 7.3 64位
- 			安全组   默认全部开放

​

# 开始安装

​

## 第一步老规矩，更新

> yum update -y

## 下载Minio

>   wget [https://dl.minio.io/server/minio/release/linux-amd64/minio](https://dl.minio.io/server/minio/release/linux-amd64/minio)
>   下载地址可以从MInio的官网获取

## 给文件加执行权限

>   chmod +x minio

## 执行

>   ./minio server ~/Photos
>   这里的Photos自定义，这是到时候上传文件存储在机器的什么地方

![](//blog-10039692.file.myqcloud.com/1503566260392_4346_1503566262958.png)

来一张总图

## 打开Minio自带的Minio Browser查看是否安装成功

在浏览器中打开:    外网ip:9000

如我的是： 119.29.129.48:9000

![](//blog-10039692.file.myqcloud.com/1503566500804_2775_1503566503420.png)

之后用上面的AccessKey和SecretKey进行登陆

​

登陆后创建bucket(bucket的名字不能包含大写字母)

![](//blog-10039692.file.myqcloud.com/1503566542458_693_1503566544697.png)

​

创建好后即可点击上面的上传文件

![](//blog-10039692.file.myqcloud.com/1503566755558_8250_1503566758206.png)

​

就可以开始你的云存储了

​

​

Minio还提供了API

![](//blog-10039692.file.myqcloud.com/1503566857487_6120_1503566860073.png)

感兴趣的读者可以深入研究

（经验证官方提供的例子是 “不完美” 的，所以，建议大家去看它的[官方文档](http://docs.minio.io/)）

：）