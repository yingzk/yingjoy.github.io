---
title: Python-贝叶斯实战垃圾邮件过滤（大量数据）
date: 2018-03-26 14:08:10
en_title: Python Bayes In Action (Spam Filter)
tags: [Machine Learning, AI, Algorithms, Python]
---

- Github: **[https://github.com/yingzk/MyML](https://github.com/yingzk/MyML)**
  
- 博 客: **[https://www.yingjoy.cn/](https://www.yingjoy.cn/)**

### 环境

Python 3.6.2 jieba 0.39 

### 数据

8000封邮件数据 

- 正常邮件： 7063封
- 垃圾邮件： 7775封
- 测试邮件：392封（其中文件名低于1000的均为正常邮件）

### 流程图

![](https://img.yingjoy.cn/image/2018/03/1-3.png)此处将结果输出到result.txt文件中 各词概率保存到wordsProb.txt中 ### Code:

```python
def getProbWord(self, testDict, normalDict, spamDict, numNormal, numSpam):
        """
        计算对分类结果影响最大的15个词
        :param testDict: 测试数据字典
        :param normalDict: 正常邮件字典
        :param spamDict: 垃圾邮件字典
        :param numNormal: 正常邮件的数量
        :param numSpam: 垃圾邮件的数量
        :return wordProbList: 对分类结果影响最大的15个词
        """
        wordProbList = {}
        for word, num in testDict.items():
            # 当词不在垃圾邮件词表中，在正常邮件词表中，计算概率
            if word in spamDict.keys() and word in normalDict.keys():
                # 求类先验概率
                # 正常邮件
                pw_n = normalDict[word] / numNormal
                # 垃圾邮件
                pw_s = spamDict[word] / numSpam
                ps_w = pw_s / (pw_s + pw_n)
                wordProbList[word] = ps_w
            # 当词在垃圾邮件词表中，不在正常邮件词表中，计算概率
            if word in spamDict.keys() and word not in normalDict.keys():
                pw_s = spamDict[word] / numSpam
                pw_n = 0.01
                ps_w = pw_s / (pw_s + pw_n)
                wordProbList[word] = ps_w
            # 当词在垃圾邮件词表中，而且在正常邮件词表中，计算概率
            if word not in spamDict.keys() and word in normalDict.keys():
                pw_s = 0.01
                pw_n = normalDict[word] / numNormal
                ps_w = pw_s / (pw_s + pw_n)
                wordProbList[word] = ps_w
            # 当词不在垃圾邮件词表中，也不在正常邮件词表中，计算概率
            if word not in spamDict.keys() and word not in normalDict.keys():
                wordProbList[word] = 0.5  # 0.4
        sorted(wordProbList.items(), key=lambda d: d[1], reverse=True)[0:15]
        return wordProbList

    def calBayes(self, wordList, spamDict, normalDict):
        
        计算贝叶斯概率
        :param wordList: 词表
        :param spamDict: 垃圾邮件词语字典
        :param normalDict: 正常邮件词语字典
        :return: 概率
        
        ps_w = 1
        ps_n = 1

        with open('wordsProb.txt', 'a', encoding='utf-8') as f:
            for word, prob in wordList.items():
                f.write(word + : + str(prob) + \n)
                ps_w *= prob
                ps_n *= 1 - prob
            p = ps_w / (ps_w + ps_n)
        return p

    def calAccuracy(self, testResult):
        
        计算精度
        :return:
        
        rightCount = 0
        errorCount = 0
        for name, catagory in testResult.items():
            if (int(name) < 1000 and catagory == 0) or (int(name) > 1000 and catagory == 1):
                rightCount += 1
            else:
                errorCount += 1
        return rightCount / (rightCount + errorCount)

```

#### [Github: https://github.com/yingzk/MyML/](https://github.com/yingzk/MyML/tree/master/C-SpamClassifier)