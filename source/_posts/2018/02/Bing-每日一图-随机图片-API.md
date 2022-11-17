---
title: Bing 每日一图 & 随机图片 API
date: 2018-02-21 17:53:20
en_title: Bing daily picture API
tags: [API]
---

![bing](https://img.yingjoy.cn/image/2018/02/bing.jpg)

大家都知道微软的 Bing 搜索引擎首页每天都会提供了一些有趣的图片，而这些图片很多都是有故事含义的，很多网友每天去访问 Bing 首页都是为了这些图片而去的。

## 本站提供 Bing 每日一图接口：

右键另存为可下载 Bing 高清图片

![https://api.yingjoy.cn/pic/?t=bing](https://api.yingjoy.cn/pic/?t=bing)

## 使用方法：

### 1366*768 分辨率图片地址

```
https://api.yingjoy.cn/pic/?t=bing&w=1366
```

### 1920*1080 分辨率图片地址

```
http://bing.yingjoy.cn/?t=bing&w=1920
```

## 这两个 API 接口可以直接把它当做一个链接来用，插入如下代码：

```html
<img src="http://bing.yingjoy.cn/?t=bing&w=1366" alt="Bing每日图片" />
<img src="http://bing.yingjoy.cn/?t=bing&w=1920" alt="Bing每日图片超高清" />
```

## 此接口还可随机展示精美图片：

```
# 本接口图片来自国外，速度较慢
http://bing.yingjoy.cn/?t=random&w=1920
```

## 接口示例：

![http://bing.yingjoy.cn/?t=random&w=1920](http://bing.yingjoy.cn/?t=random&w=1920)

## 说明

接口参数：

| 参数 | 说明 |
| ---- | ---- |
| t    | 类型 |
| w    | 宽度 |
| h    | 高度 |


t 有两种类型: bing 和 random

bing： 获取Bing每日图片

random: 获取随机图片

## 目前支持的分辨率：

```jsonp
[
    '1920x1200',   #bing有水印
    '1920x1080',
    '1366x768',
    '1280x768',
    '1024x768',
    '800x600',
    '800x480',
    '768x1280',
    '720x1280',
    '640x480',
    '480x800',
    '400x240',
    '320x240',
    '240x320'
]
```