---
title: Flask闭关修炼（高级） 1
date: 2019-12-01 21:34:11
en_title: Flask advanced
tags: [Python, Python Web, Flask]
---

# 路由跳转问题

编写`route`时，如果末尾有`/`未匹配时会发生一次`308`重定向


# 注册路由的方法

1. 装饰器

```python
@app.route('/')
def index():
    return 'index'
```

2. add_url_rule

```python
app.add_url_rule('/', view_func=index)
```