---
title: Selenium放弃PhantomJS改用Chrome headless
date: 2018-11-23 08:47:44
en_title: Use Chrome headless replace PhantomJS
tags: [Python, Spider, Trick]
---

目前新版本的<code>selenium</code>调用PhantomJS会报如下警告：

<pre><code>UserWarning: Selenium support for PhantomJS has been deprecated, please use headless versions of Chrome or Firefox instead warnings.warn('Selenium support for PhantomJS has been deprecated, please use headless
</code></pre>

你可以通过给<strong>selenium降级</strong>的方法来解决这个警告。

现在还可以通过使用Chrome或Firefox的headless方式来进行无界面的浏览器模拟。

<pre><code>from selenium import webdriver
from selenium.webdriver.chrome.options import Options

options = Options()
options.add_argument('--headless')
options.add_argument('--disable-gpu')
browser = webdriver.Chrome(chrome_options=options)
</code></pre>