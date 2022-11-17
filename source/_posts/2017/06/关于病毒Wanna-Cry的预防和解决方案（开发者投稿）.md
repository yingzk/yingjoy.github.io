---
title: 关于病毒Wanna Cry的预防和解决方案（开发者投稿）
date: 2017-06-19 16:26:36
en_title: Wanna Cry
tags: [Virus]
---

## 前言

​

又到了周末:)，坐在电脑面前，看着"数码宝贝"---> 皮卡丘 ( ⊙o⊙ )，然后吃了一个柠檬(Lemon)   (^o^)/~，多么美好。

​

然后我就收到了一大堆QQ群消息，微信消息，各个地方都在说电脑中毒了或者病毒通知，这里盗用一张群友的图片@李郑

​

![](//blog-10039692.file.myqcloud.com/1494659754290_8187_1494659763229.jpg)

就像这样的

​

![](//blog-10039692.file.myqcloud.com/1494659846950_9467_1494659854677.jpg)

还有这样的通知

​

从通知里你看得到一些关于这个病毒的基本信息

​

​

下面是全球中招情况

![](//blog-10039692.file.myqcloud.com/1494662657715_1487_1494662665178.png)

看着还是蛮壮观的

​

在中国东部已经泛滥，想想信息在国内的传播速度，应该再过不久就到我这里来了，所以提前做打算。

​

中毒是什么样子？

诺，就是上面的和下面的样子

![](//blog-10039692.file.myqcloud.com/1494662160166_8969_1494662173030.png)

​

## 预防

​

如何预防它， 巧了， 国内各大网络安全组织都开始加班加点了，

![](//blog-10039692.file.myqcloud.com/1494661520751_2693_1494661528411.png)

![](//blog-10039692.file.myqcloud.com/1494662192316_8365_1494662201047.jpg)

​

微软已经对该病毒有了处理，若你使用的是Window10的话只需要打开Windows Defender 即可。

​

若是其他系统的话，微软的良心还在。微软决定对已经停止支持的 Windows XP 和 Windows 2003 发布特别版补丁 

​

所以大家也不用太怕这东西。

​

然而鄙人也给出一个预防的reg.

这是代码，你可以复制到你的记事本里，然后把文件拓展名改为.reg运行即可

## 此代码小编实验过，完美免疫病毒，希望没有中毒的小伙伴们都运行一下，以防万一

​

​

```
Windows Registry Editor Version 5.00
;By YingJoy
;2017/5/13

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskdl.exe]
"Debugger"="taskkill /F /IM taskdl.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskse.exe]
"Debugger"="taskkill /F /IM taskse.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wannacry.exe]
"Debugger"="taskkill.exe /F /IM wannacry.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mssecsvc.exe]
"Debugger"="taskkill.exe /F /IM mssecsvc.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\tasksche.exe]
"Debugger"="taskkill.exe /F /IM tasksche.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskhsvc.exe]
"Debugger"="taskkill.exe /F /IM taskhsvc.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wcry.exe]
"Debugger"="taskkill.exe /F /IM wcry.exe"
```

​

有这么东西保护，司机可以继续开车啦。

YingJoy

​

## 杀！杀！杀！

​

要是中招了怎么办？？？？

​

巧了，国内大神已经有了一个尝试性解决办法

​

关于高校比特币病毒 社工破解的可能性尝试：

​

1:打开自己的那个勒索软件界面，点击copy. （复制黑客的比特币地址）

2:把copy粘贴到btc.com （区块链查询器）

3:在区块链查询器中找到黑客收款地址的交易记录，然后随意选择一个txid（交易哈希值）

4:把txid 复制粘贴给 勒索软件界面按钮connect us.

5:等黑客看到后 你再点击勒索软件上的check payment. 

6:再点击decrypt 解密文件即可。

​

这是实现这个方法的代码,Python写的

​

```
# -*- coding: utf-8 -*-
"""
Created on Sat May 13 08:47:08 2017

@author: Quantum Liu
"""

import requests
import re
import win32api
import os
if win32api.GetSystemDefaultLangID()==2052:
    language=1#chinese
else:
    language=0#english
ver='0.01_beta'
btc_list=['https://btc.com/'+add for add in ['13AM4VW2dhxYgXeQepoHkHSQuy6NgaEb94','12t9YDPgwueZ9NyMgw519p7AA8isjr6SMw']]
reg=r'class="tx-item-summary-hash">(.*)</a>'
r_list=[requests.get(btc) for btc in btc_list]
print(u'请将在列出的比特币交易ID中选择一串，复制粘贴到勒索软件的Contact us,等待黑客验证后，点击check payment再点击Decypt即可恢复\n' if language else 'Please select one transaction ID，and paste it to the Contact us ,after the hacker confirmed,click Chek payment and then click Decrypt\n')
for r in r_list:
    for txid in re.findall(reg,r.text):
        print(txid)
        th=u'方法来自：https://www.zhihu.com/pin/846570592869183488#comment-280580859'
print(th)
os.system('pause')
```

​

向作者致敬，这是作者的GitHub地址[https://github.com/QuantumLiu/antiBTCHack](https://github.com/QuantumLiu/antiBTCHack)

​

原此处方法小编已经实践过，方法无效，小伙伴们不要试了。

​

另外国内已经有了一些解决该病毒的方法。

详情见

[WannaCry 勒索病毒用户处置指南](https://www.qcloud.com/community/article/590084)

​

具体是说该病毒把原文件删掉了，然后通过文件恢复找到的文件，

小编在此认为 这个方法太复杂，且无法100%找回，找回的文件文件名也无法恢复。

在此小编正继续深入研究，希望可以早日给大家提供更好的解决方法。

​

​

如果这些方法没有怎么办？

莫慌，还有最后一招终极解决办法

**重装系统**，建议迫不得已再用
