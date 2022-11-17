---
title: Python 实现双向链表
date: 2018-04-20 13:05:35
en_title: Double Linked List With Python
tags: [Python, Data Structure]
---

双向链表，又称为双链表，是链表的一种，它的每个数据结点中都有两个指针，分别指向直接后继和直接前驱。所以，从双向链表中的任意一个结点开始，都可以很方便地访问它的前驱结点和后继结点。一般我们都构造双向循环链表。


```python
#!usr/bin/env python  
#-*- coding:utf-8 -*- 

"""
@author:yzk13 
@time: 2018/04/18
双向链表
https://blog.csdn.net/qq490691606/article/details/49948263
"""

class Node(object):
    """
    节点类
    """
    def __init__(self, value):
        self.pre = None
        self.value = value
        self.next = None

class DoublyLinkedList(object):
    """
    双向链表类
    """
    def __init__(self):
        """
        初始化链表
        """
        head = Node(None)
        tail = Node(None)
        self.head = head
        self.tail = tail
        self.head.next = self.tail
        self.tail.pre = self.head

    @property
    def length(self):
        """
        获取链表长度
        :return:
        """
        length = 0
        node = self.head
        while node.next != self.tail:
            length += 1
            node = node.next
        return length

    def print(self):
        """
        打印
        :return:
        """
        if self.length == 0:
            print('Nothing')
        else:
            node = self.head.next
            print('[', end='')
            while node.next != self.tail:
                print(node.value, ', ', end='')
                node = node.next
            print('%s]' % node.value)

    def append(self, value):
        """
        表尾添加节点
        :return:
        """
        node = Node(value)
        pre = self.tail.pre
        # 两点之间进行双双链接
        pre.next = node
        node.pre = pre
        node.next = self.tail
        self.tail.pre = node
        return node

    def get(self, index):
        """
        获取节点
        :param index:
        :return:
        """
        if index < 0 or index > self.length:
            print('Index错误，索引越界')
            return None
        else:
            node = self.head.next
            while index:
                node = node.next
                index -= 1
            return node

    def insert(self, index, value):
        """
        插入
        :param index:
        :param value:
        :return:
        """
        if index < 0 or index > self.length:
            print('Index 错误, 索引越界')
        next_node = self.get(index)
        # 开始插入
        node = Node(value)
        pre_node = next_node.pre

        pre_node.next = node
        node.pre = pre_node
        node.next = next_node
        next_node.pre = node
        return node

    def delete(self, index):
        """
        删除节点
        :param index:
        :return:
        """
        node = self.get(index)
        if node:
            node.pre.next = node.next
            node.next.pre = node.pre
            return True
        else:
            return False

    def reverse(self):
        """
        反转链表
        :return:
        1.node.next --> node.pre
          node.pre --> node.next
        2.head.next --> None
          tail.pre --> None
        3.head-->tail
        tail-->head
        """
        pre_head = self.head
        tail = self.tail

        # 调用递归，对每个节点进行交换位置
        def reverse(pre_node, node):
            if node:
                next_node = node.next
                node.next = pre_node
                pre_node.pre = node

                if pre_node is self.head:
                    pre_node.next = None
                if node is self.tail:
                    node.pre = None
                return reverse(node, next_node)

            else:
                self.head = tail
                self.tail = pre_head
        return reverse(self.head, self.head.next)

    def clear(self):
        """
        清空链表
        :return:
        """
        self.head.next = self.tail
        self.tail.pre = self.head


if __name__ == '__main__':
    l = DoublyLinkedList()

    # 测试在表尾添加节点
    l.append(3)
    l.append(4)
    l.append(5)
    l.print()

    # 测试get
    i = 0
    print('第', i, '个元素为: ', l.get(i).value)

    # 测试索引插入
    print('索引插入...')
    l.insert(1, 7)
    l.insert(0, 8)
    l.print()

    # 测试删除节点
    print('删除节点...')
    l.delete(0)
    l.delete(3)
    l.print()

    # 测试反转
    print('反转...')
    l.reverse()
    l.print()

    # 测试清空
    print('清空...')
    l.clear()
    l.print()

    # 测试长度
    print('链表长度为: ', l.length)
```