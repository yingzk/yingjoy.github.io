---
title: Python 实现单向循环链表
date: 2018-04-20 13:01:47
en_title: Singly Linked Circular List With Python
tags: [Python, Data Structure]
---

## 循环链表的概念

1.什么是循环链表 

所谓的循环链表就是让单向链表的首尾相连，组成一个环状。 

2.循环链表的典型应用 

约瑟夫环问题。 

3.实现循环链表的重点 

1，循环链表在插入第一个元素的时候，需要我们将第一元素的指针域指向其自身，也就构成了循环链表。

2，循环链表基于单向链表而生，单是比循环链表多了游标这个概念。要想实现循环链表的插入，删除的关键是考虑头结点问题，因为在头插法方式（往链表的头部插入数据）中，需要将末尾数据元素的指针域指向新插入的节点。将新插入的节点的指针域指向头结点的指针域的指针域，还需要将头结点指向新插入的结点。（插入相同）。 

```python
#!usr/bin/env python  
# -*- coding:utf-8 -*-

 
@author:yzk13 
@time: 2018/04/17

"""单向循环链表"""



class Node(object):
    """
    节点类
    """
    def __init__(self, value, next):
        self.value = value
        self.next = next

class SinCycLinkedList(object):
    def __init__(self):
        self.root = None

    def is_empty(self):
        """
        判断链表是否为空
        :return:
        """
        return self.root == None

    @property
    def length(self):
        """
        求链表长度
        :return:
        """
        if self.is_empty():
            return 0
        else:
            counter = 1
            cursor = self.root
            while cursor.next != self.root:
                counter += 1
                cursor = cursor.next
            return counter

    def print(self):
        """
        打印链表
        :return:
        """
        if self.is_empty():
            print('Nothing')
        else:
            cursor = self.root
            print('[%s' % str(cursor.value), end='')
            while cursor.next != self.root:
                cursor = cursor.next
                print(', ', cursor.value, end='')
            print(']')

    def prepend(self, value):
        """
        在表头添加Node
        :return:
        """
        node = Node(value, None)
        if self.is_empty():
            self.root = node
            node.next = self.root
        else:
            # 设置节点指向头
            node.next = self.root
            # 找到表尾
            cursor = self.root
            while cursor.next != self.root:
                cursor = cursor.next
            # 设置最后一个节点指向添加的节点
            cursor.next = node
            # 设置表头指向添加的节点
            self.root = node

    def append(self, value):
        """
        在表添加节点
        :return:
        """
        node = Node(value, None)
        if self.is_empty():
            self.root = node
            node.next = self.root
        else:
            cursor = self.root
            while cursor.next != self.root:
                cursor = cursor.next
            # 将尾节点指向新增节点
            cursor.next = node
            node.next = self.root

    def insert(self, index, value):
        """
        在指定位置添加节点
        :return:
        """
        if index < 0 or index > self.length:
            print('Index错误, 索引越界')
        elif index == 0:
            self.prepend(value)
        else:
            node = Node(value, None)
            cursor = self.root
            counter = 0
            # counter 小于索引时 继续往前搜索
            while counter < index-1:
                counter += 1
                cursor = cursor.next
            node.next = cursor.next
            cursor.next = node

    def remove(self, value):
        """
        删除某个值的所有
        :param index:
        :return:
        """
        # 若链表为空，则直接返回
        if self.is_empty():
            return
        # 将cur指向头节点
        cur = self.root
        pre = None
        # 若头节点的元素就是要查找的元素value
        if cur.value == value:
            # 如果链表不止一个节点
            if cur.next != self.root:
                # 先找到尾节点，将尾节点的next指向第二个节点
                while cur.next != self.root:
                    cur = cur.next
                # cur指向了尾节点
                cur.next = self.root.next
                self.root = self.root.next
            else:
                # 链表只有一个节点
                self.root = None
        else:
            pre = self.root
            # 第一个节点不是要删除的
            while cur.next != self.root:
                # 找到了要删除的元素
                if cur.value == value:
                    # 删除
                    pre.next = cur.next
                    return
                else:
                    pre = cur
                    cur = cur.next
            # cur 指向尾节点
            if cur.value == value:
                # 尾部删除
                pre.next = cur.next

    def search(self, value):
        """
        查找节点是否存在
        :param value:
        :return:
        """
        if self.is_empty():
            return False
        cur = self.root
        if cur.value == value:
            return True
        while cur.next != self.root:
            cur = cur.next
            if cur.value == value:
                return True
        return False

if __name__ == '__main__':
    l = SinCycLinkedList()
    l.print()

    # --------测试添加节点----------
    # 表头添加
    l.prepend(3)
    l.prepend(4)

    # 表尾添加
    l.append(5)
    l.append(1)

    l.print()

    # 在指定位置插入节点
    l.insert(0, 1)
    l.insert(3, 7)
    l.print()

    # 测试删除
    l.remove(2)
    l.print()

    # ------- 测试是否为空----------
    print('链表是否为空?: ', l.is_empty())

    # ------- 测试查询 -----------
    print('是否存在7?:', l.search(7))

    # ------- 测试长度----------
    print('链表长度为: ', l.length)
```