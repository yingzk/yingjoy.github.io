---
title: 使用Python进行天气预测之获取数据
date: 2018-05-23 16:10:58
en_title: Weather Prediction With Python
tags: [Python, Machine Learning]
---

### 0. 前言

Python实战之天气预测

### 1. 爬取数据

这里使用`request`库和正则表达式进行数据的爬取

爬取网上的历史天气数据，这里我使用了成都的历史天气数据（2011-2018年）

之后的天气预测也将会使用成都的历史天气数据

目标网址： [http://tianqi.2345.com](http://tianqi.2345.com)

**这里说明：**

由于数据存在缺失，2016年以前的空气质量数据没有找到

通过分析网址我们得到最后的数据都是存在于js文件中的。

## 1.1 构造日期：

```python
for year in range(2011, 2019):
    for month in range(1, 13):
        if month == 12 and year > 2016:
            month = "%.2d".format() % month
            url = "http://tianqi.2345.com/t/wea_history/js/" + str(year) + str(month) + "/56294_" + str(year) + str(
                month) + ".js"
        else:
            url = "http://tianqi.2345.com/t/wea_history/js/56294_" + str(year) + str(month) + ".js"
        print(url)
        getData(url)
```

通过分析链接可以，在2016年以前，每个12月的链接和一般的链接是不一样的。

所以我们加上了判断语句，当然细心的小伙伴应该可以看到我们这里还会构造出2019年的链接，这个错误链接我们在后面获取数据的时候会进行处理，若链接是没用的，我们选择不处理，直接pass。

## 1.2 获取网页源码

```python
response = requests.get(url)
if response.status\_code == 200:
    html = response.text
    return html
else:
    return None
```

## 1.3 使用正则表达式提取数据

```python
results = re.findall("(\{ymd.*?\})", html)
for result in results:
    # 日期
    date = re.search("(\d{4}-\d{1,2}-\d{1,2})", result).group().strip()
    # 最高气温
    bWendu = re.search("bWendu:'(.*?)',yWendu", result).groups()[0].strip()
    # 最低气温
    yWendu = re.search("yWendu:'(.*?)',tianqi", result).groups()[0].strip()
    # 天气情况
    tianqi = re.search("tianqi:'(.*?)',fengxiang", result).groups()[0].strip()
    # 风向
    fengxiang = re.search("fengxiang:'(.*?)',fengli", result).groups()[0].strip()
    # 风力
    fengli = re.search("fengli:'(.*?)'", result).groups()[0].strip()
    try:
        # 空气指数
        aqi = re.search("aqi:'(.*?)',aqiInfo", result).groups()[0].strip()
    except:
        aqi = 'NULL'
    try:
        # 空气指数信息
        aqiInfo = re.search("aqiInfo:'(.*?)',aqiLevel", result).groups()[0].strip()
    except:
        aqiInfo = 'NULL'
    try:
        # 空气等级
        aqiLevel = re.search("aqiLevel:'(\d{1,2})'}", result).groups()[0].strip()
    except:
        aqiLevel = 'NULL'
```

使用正则表达式匹配出上面那些信息，由于空气指数系列数据2016年前不存在，所以我们设置它为NULL。

## 1.4 组合数据写入文件

```python
s = date + " " + bWendu + " " + yWendu + " " + tianqi + " " + fengxiang + " " + fengli + " " + aqi + " " + aqiInfo + " " + aqiLevel + "\n"
with open('cd_weather.txt', 'a', encoding='utf-8') as f:
    f.write(s)
```

得到[**成都历史天气数据（2011-2018年）**(点击可下载)](https://img.yingjoy.cn/attachment/2018/05/weather/cd_weather.txt)

## 1.5 分析数据

这里暂时简单分析数据，之后会有文章进行详细分析

![2011-2018年成都气温](https://img.yingjoy.cn/image/2018/05/cd_weather.png)

可见数据变化趋势是非常明显的。

本文代码下载地址：[https://img.yingjoy.cn/attachment/2018/05/weathergetData.py](https://img.yingjoy.cn/attachment/2018/05/weather/getData.py)

​