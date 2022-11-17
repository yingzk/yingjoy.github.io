---
title: git相关
date: 2019-12-01 17:51:19
en_title:
tags:
---

### 删除中间的commit

```
git rebase -i  上一个版本的id
```

### 删除第一个commit
```
git update-ref -d HEAD
```