---
title: Pandas——高效的数据处理Python库
date: 2017-09-16 23:11:44
en_title: pandas -- efficient data process library
tags: [Python]
---

## Pandas教程

Pandas是高效的数据读取、处理与分析的Python库，下面将学习Pandas的基本用法


### 1. 创造对象

导入pandas , numpy, matplotlib库

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
```

Series是一个值的序列 ，它只有一个列，以及索引，下面的例子中，就是用默认的整数索引

![pandas-1](https://img.yingjoy.cn/image/2017/09/pandas-1.png)

DataFrame是有多个数据表，每个列拥有一个label，DataFrame也拥有索引

![pandas-2](https://img.yingjoy.cn/image/2017/09/pandas-2.png)

如果参数是一个dict（字典），每个dict的value会被转换成一个Series

可以这样理解，DataFrame是由Series组成


### 2. 查看数据

用head和tail查看顶端和底端的几行，head和tail的默认参数是5

![pandas-3](https://img.yingjoy.cn/image/2017/09/pandas-3.png)

实际上DataFrame内部用numpy 格式存储数据，可以单独查看index和columns

![pandas-4](https://img.yingjoy.cn/image/2017/09/pandas-4.png)

describe()显示数据概要

![pandas-5](https://img.yingjoy.cn/image/2017/09/pandas-5.png)

和numpy一样，可以方便的得到转置

![pandas-6](https://img.yingjoy.cn/image/2017/09/pandas-6.png)

对axis按照index排序（axis=1指第二个纬度，即 列）

![pandas-7](https://img.yingjoy.cn/image/2017/09/pandas-7.png)

按值排序

![pandas-8](https://img.yingjoy.cn/image/2017/09/pandas-8.png)


### 3. 选择行和列

从DataFrame选择一个列，就得到了一个Series

![pandas-9](https://img.yingjoy.cn/image/2017/09/pandas-9.png)

和numpy类似，这里可以使用 []

![pandas-10](https://img.yingjoy.cn/image/2017/09/pandas-10.png)


### 4. 通过label选择

刚刚的DataFrame可以通过时间戳的下标（dates[0]=Timestamp('20170917')）来访问

![pandas-11](https://img.yingjoy.cn/image/2017/09/pandas-11.png)

还可以多选

![pandas-12](https://img.yingjoy.cn/image/2017/09/pandas-12.png)

冒号和Matlab或Numpy里面的冒号用法是一样的，也可以加上行

![pandas-13](https://img.yingjoy.cn/image/2017/09/pandas-13.png)


### 5. 通过整数下标选择

和Matlab完全一样

![pandas-14](https://img.yingjoy.cn/image/2017/09/pandas-14.png)

选出3~4行， 0~1列

![pandas-15](https://img.yingjoy.cn/image/2017/09/pandas-15.png)

左闭右开

也可以用list选择

![pandas-16](https://img.yingjoy.cn/image/2017/09/pandas-16.png)

也可以用slice切片

![pandas-17](https://img.yingjoy.cn/image/2017/09/pandas-17.png)

对单个元素

![pandas-18](https://img.yingjoy.cn/image/2017/09/pandas-18.png)


### 6. 布尔值下标

基本用法

![pandas-19](https://img.yingjoy.cn/image/2017/09/pandas-19.png)

没有填充的值均为NaN

![pandas-20](https://img.yingjoy.cn/image/2017/09/pandas-20.png)

`copy()`函数：复制DataFrame

`isin()`函数：是否在集合中，并选出

![pandas-21](https://img.yingjoy.cn/image/2017/09/pandas-21.png)


### 7. Setting

为DataFrame增加新的列，按index对应

![pandas-22](https://img.yingjoy.cn/image/2017/09/pandas-22.png)

通过label 下标 numpy 布尔值作下标 设置

![pandas-23](https://img.yingjoy.cn/image/2017/09/pandas-23.png)


### 8. 缺失值

pandas用`np.nana`表示缺失值，不加入计算

`dropna()`丢弃有NaN的行
`fillna(value=5)`填充缺失值
`pd.isnull()`获取布尔值的mask，哪些是NaN


### 9. 统计

平均值 `mean()`
对另一个纬度做平均值只需加一个参数
`mean(1)` 这里的1是纬度， 0表示x , 1 表示y, 2表示z 以此类推


### 10. Apply函数

对行或列进行操作，可以用lambda表达式


### 11. 读取csv xls hdf5

```python
pd.read_csv('filename')
pd.read_excel('filename','Sheet1')
pd.read_hdf('filename')
```
