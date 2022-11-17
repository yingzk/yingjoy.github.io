---
title: Python 机器学习库 --- sklearn --- 线性模型
date: 2017-06-19 16:25:03
en_title: Sklearn Linear Model
tags: [Python, Machine Learning, Sklearn]
---

## 前言

额，这里不支持latex语法。就截图了。。。

下面介绍的方法均是用于求解回归问题，其目标值预计是输入一个变量的一个线性组合，用数学语言表示的: \hat{y}是预测值，则有

```javascript
                            \hat{y}(\omega + x) = \omega_{0} + \omega_{1}x_{1} + ...+\omega_{p}x_{p}

```

在这里称向量\omega=(\omega_{1}, ... ,\omega_{p})为 coef _\omega_{0}称为intercept\_

![](https://blog-10039692.file.myqcloud.com/1508751058969_787_1508751057329.png)

普通最小二乘法

线性回归中使用系数\omega=(\omega_{1}, ..., \omega_{p})拟合一个线性模型，拟合的目标是要将线性逼近预测值X\_{\omega} 和数据集中观察到的值y两者之差的平方和尽量降到最小，写成数学表达式为:

```javascript

\underset{\omega}{min}||X_{\omega}-y||_{2}^{2}

```

![](https://blog-10039692.file.myqcloud.com/1508751159371_8810_1508751157745.png)

线性回归中的fit方法接受数组X和y作为输入，将线性模型的系数\omega存在成员变量coef\_中:

```javascript
>>> from sklearn import linear_model                        #导入线性模型
>>> reg = linear_model.LinearRegression()                    #reg为线性回归
>>> print reg.fit ([[0, 0], [1, 1], [2, 2]], [0, 1, 2])        #对输入输出进行拟合
LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False)
#copy_X: 是否备份     fit_intercept: 是否保存截距      n_jobs: 任务数量   normalize: 是否标准化
>>> print reg.coef_                                            #系数矩阵(模型的权重)
array([0.5, 0.5])
>>> print reg.intercept_                                    #训练后模型截距
1.1102230246251565e-16
>>> print reg.predict([[2, 5]])                                #训练后模型预测
array([3.5])
>>> print reg.normalize                                        #训练是否标准化
False
>>> print reg.get_params                                    #获取模型训练前设置的参数
<bound method LinearRegression.get_params of LinearRegression(copy_X=True, fit_intercept=True, n_jobs=1, normalize=False)>

```

普通二乘法的系数预测取决于模型中各个项的独立性，假设各项相关，矩阵X的列总体呈现出线性相关，那么X就会很接近奇异矩阵，其结果就是经过最小二乘得到的预测值会对原始数据中的随机误差高度敏感，从而每次预测都会产生比较大的方差，这种情况称为重共线性，例如，在数据未经实验设计就进行收集时就会发生重共线性。

还有一个线性回归的例子

```javascript
import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, linear_model

# 读取自带的diabete数据集
diabetes = datasets.load_diabetes()


# 使用其中的一个feature
diabetes_X = diabetes.data[:, np.newaxis, 2]

# 将数据集分割成training set和test set
diabetes_X_train = diabetes_X[:-20]
diabetes_X_test = diabetes_X[-20:]

# 将目标（y值）分割成training set和test set
diabetes_y_train = diabetes.target[:-20]
diabetes_y_test = diabetes.target[-20:]

# 使用线性回归
regr = linear_model.LinearRegression()

# 进行training set和test set的fit，即是训练的过程
regr.fit(diabetes_X_train, diabetes_y_train)

# 打印出相关系数和截距等信息
print('Coefficients: \n', regr.coef_)
# The mean square error
print("Residual sum of squares: %.2f"
      % np.mean((regr.predict(diabetes_X_test) - diabetes_y_test) ** 2))
# Explained variance score: 1 is perfect prediction
print('Variance score: %.2f' % regr.score(diabetes_X_test, diabetes_y_test))

# 使用pyplot画图
plt.scatter(diabetes_X_test, diabetes_y_test,  color='black')
plt.plot(diabetes_X_test, regr.predict(diabetes_X_test), color='blue',
         linewidth=3)

plt.xticks(())
plt.yticks(())

plt.show()

```

## 普通最小二乘法的复杂度

此方法使用的X的奇异值分解来求解最小二乘
如X是n\*p矩阵，则算法复杂度为O(np^{2}){\ge}p，假设n .