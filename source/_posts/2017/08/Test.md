---
title: Test
date: 2017-07-12 00:00:01
tags:
---

## This is my first article.

### Test Python Code

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello Hexo"

if __name__ == '__main__':
    app.run()
```