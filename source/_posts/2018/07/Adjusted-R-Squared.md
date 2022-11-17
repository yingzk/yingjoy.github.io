---
title: Adjusted R-Squared
date: 2018-07-09 21:55:23
en_title: Adjusted R-Squared
tags: [Machine Learning, AI, Mainchine Learning Flash Card]
---

拟合度：调整R方

$\hat{R}^2=1-\frac{RSS/(n-d-1)}{TSS/(n-1)}$

其中：
* RSS为残差平方和
* TSS为总平方和
* n为观测值
* d为特征值
* 
ESS: 回归平方和回归方程中含有截距项时TSS=RSS+ESS
否则上述公式不成立。

直观的说，校正决定系数考虑了变量个数对决定系数的影响，当加入的变量没有意义时，校正决定系数会变小。

<img src="https://img.yingjoy.cn/image/2018/07/Adjusted_R-Squared_web.png" class="aligncenter size-full wp-image-637" />