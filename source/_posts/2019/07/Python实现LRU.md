---
title: Python实现LRU
date: 2019-07-28 15:45:34
en_title: LRU With Python
tags: [Python, Data Structure]
---

![lru.png](https://img.yingjoy.cn/image/2019/07/lru.png)

# 数组版

```python
class LRU:
    def __init__(self):
        self.arr = []
        self.len = 3

    def append(self, num):
        if len(self.arr) == self.len:
            self.arr.pop(-1)
        self.arr.insert(0, num)

    def read(self, content):
        if content in self.arr:
            tmp = self.arr.pop(self.arr.index(content))
            self.arr.insert(0, tmp)
        else:
            self.append(content)

    def __repr__(self):
        return str(self.arr)


if __name__ == '__main__':
    # 1, 3, 0, 3, 5, 6
    l = LRU()
    l.append(1)
    l.append(2)
    l.append(3)
    print(l)
    l.read(2)
    print(l)
    l.read(4)
    print(l)
```


# 链表版
