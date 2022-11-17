---
title: AdaBoost
date: 2018-07-08 22:34:00
en_title: AdaBoost
tags: [Machine Learning, AI, Mainchine Learning Flash Card]
---

<ol>
<li>分配给每个观测样本$X_i$一个初始权重$W_i$。$W_i=\frac{1}{n}$，其中$n$为样本总数</li>
<li>训练一个“弱模型”（常用决策树）</li>
<li>对于每一个测试样本
3.1 如果预测错误， $W_i$上涨（给一个较大的惩罚力度）
3.2 如果预测正确， $W_i$下降</li>
<li>训练一个新的“弱模型”，其中权重较大的样本优先级越高</li>
<li>重复步骤3， 4 直至所有样本被完美进行预测。或决策树的分支和样本规模一样</li>
</ol>

<img src="https://img.yingjoy.cn/image/2018/07/AdaBoost_web.png" alt="" class="aligncenter size-full wp-image-632" />