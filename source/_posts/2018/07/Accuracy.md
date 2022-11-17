---
title: Accuracy
date: 2018-07-08 22:05:28
en_title: Accuracy
tags: [Machine Learning, AI, Mainchine Learning Flash Card]
---

$A_{cc}=\frac{1}{n}\sum{I(\hat{y}_i=y_i)}$

分类任务中常用的指标，用于度量分类的准确度。
对于给定一组数据的一系列测量，当$y_i$的预测值于$y_i$相等时，指数函数取1，不相等取0。
在类别严重不均等的时候，使用F1值更好。

<h3>准确率Accuracy定义：</h3>

对于给定的测试数据集，分类器正确分类的样本数与总样本数之比反映了分类系统对样本的判断能力。

<img src="https://img.yingjoy.cn/image/2018/07/Accuracy_web.png" alt=""  class="aligncenter size-full wp-image-625" />