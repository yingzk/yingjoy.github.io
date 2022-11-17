---
title: Flask React路由404问题
date: 2019-07-11 21:37:20
en_title: Flask backend and React frontend route 404
tags: [Flask, React, Trick, Python]
---

```python
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def index(path):
    return render_template('index.html')
```