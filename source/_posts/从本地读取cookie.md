---
title: 从本地读取cookie
date: 2020-01-03 10:16:42
en_title: read cookie from local sqlite
tags:
---

从本地读取对应的cookie，用来应付像钉钉这种应用

可以使用Navicat来查看Cookie文件

```python
import os
import sqlite3


def get_cookie_from_dingtalk(host='.baidu.com'):
    """host筛选网址"""
    # cookiepath = os.environ['LOCALAPPDATA'] + r"\Google\Chrome\User Data\Default\Cookies"
    cookiepath = os.environ['LOCALAPPDATA'] + r"\DingTalk\Cookies"
    sql = "select host_key,name,encrypted_value from cookies where host_key='%s'" % host
    with sqlite3.connect(cookiepath) as conn:
        cu = conn.cursor()
        cu.execute('select * from cookies;')
        # cookies = {name: CryptUnprotectData(encrypted_value)[1].decode() for host_key, name, encrypted_value in
        #            cu.execute(sql).fetchall()}
        # print(cookies)
        # return cookies
        print(cu.fetchall())

if __name__ == '__main__':
    get_cookie_from_dingtalk()
```