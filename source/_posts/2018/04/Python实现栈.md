---
title: Python实现栈
date: 2018-04-20 23:57:26
en_title: Stack With Python
tags: [Python, Data Structure]
---

堆栈（英语：stack）又称为栈或堆叠，是计算机科学中的一种抽象数据类型，只允许在有序的线性数据集合的一端（称为堆栈顶端，英语：top）进行加入数据（英语：push）和移除数据（英语：pop）的运算。因而按照后进先出（LIFO, Last In First Out）的原理运作。

常与另一种有序的线性数据集合队列相提并论。

堆栈常用一维数组或链表来实现。

```python
#!usr/bin/env python  
#-*- coding:utf-8 -*- 

 """
@author:yzk13 
@time: 2018/04/19
栈
"""

class Stack(object):
    """
    栈
    """
    def __init__(self):
        """
        初始化
        """
        self.items = []

    def is_empty(self):
        """
        栈是否为空
        :return:
        """
        return self.items == []

    def peek(self):
        """
        返回栈顶元素
        :return:
        """
        return self.items[-1]

    def size(self):
        """
        返回栈的大小
        :return:
        """
        return len(self.items)

    def push(self, item):
        """
        进栈
        :return:
        """
        self.items.append(item)

    def pop(self):
        """
        删除栈最顶层的元素，并返回这个元素  出栈
        :return:
        """
        return self.items.pop()

    def print(self):
        """
        打印
        :return:
        """
        print(self.items)

    def sort(self):
        """
        排序
        :return:
        """
        self.items.sort()

if __name__ == '__main__':
    s = Stack()
    # 入栈
    s.push(3)
    s.push(-2)
    s.push(7)
    s.push(6)
    s.push(1)
    s.print()

    # 测试大小
    print('栈大小为: ', s.size())

    # 出栈
    print('出栈元素为: ', s.pop())
    s.print()

    # 获取栈顶
    print('栈顶为: ', s.peek())

    # 测试排序
    s.sort()

    s.print()

```