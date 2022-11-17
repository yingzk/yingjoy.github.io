---
title: Python 实现单向链表
date: 2018-04-16 17:07:28
en_title: Singly Linked List With Python
tags: [Python, Data Structure]
---

## 单向链表

单向链表（又名单链表、线性链表）是链表的一种，其特点是链表的链接方向是单向的，对链表的访问要通过从头部开始，依序往下读取。

一个单向链表的节点被分成两个部分。第一个部分保存或者显示关于节点的信息，第二个部分存储下一个节点的地址。单向链表只可向一个方向遍历。

```python
#!usr/bin/env python  
# -*- coding:utf-8 -*-
 
@author:yzk13 
@time: 2018/04/15
"""单向链表"""

class Node(object):
    """
    节点类
    """

    def __init__(self, value, next):
        self.value = value
        # 下一个节点
        self.next = next

class LinkedList(object):
    """
    链表
    """

    def __init__(self):
        self.root = None

    def addNode(self, value):
        """
        添加Node
        :return:
        """
        if self.root == None:
            self.root = Node(value=value, next=None)
            return self.root
        else:
            # 有头节点，需要遍历到链表尾部，然后添加节点
            cursor = self.root
            while cursor.next != None:
                cursor = cursor.next
            cursor.next = Node(value=value, next=None)
            return self.root

    def append(self, value):
        """
        在尾部添加Node
        :return:
        """
        self.addNode(value)

    def prepend(self, value):
        """
        在表头添加Node
        :param value:
        :return:
        """
        if self.root == None:
            self.addNode(value)
        else:
            newNode = Node(value, self.root)
            self.root = newNode

    @property
    def length(self):
        """
        获取链表长度
        :return:
        """
        counter = 0
        if self.root == None:
            counter = 0
            return counter
        else:
            cursor = self.root
            while cursor != None:
                counter += 1
                cursor = cursor.next
            return counter

    def insert(self, index, value):
        """
        在index处插入Node
        :param index:
        :param value:
        :return:
        """
        if self.root == None:
            return None
        if index < 0 or index > self.length - 1:
            print('Index 非法，超出索引')
        elif index == 0:
            # 表头
            self.prepend(value)
        elif index == self.length - 1:
            # 表尾
            self.append(value)
        else:
            # 使用计数器来确定位置
            counter = 1
            pre = self.root
            cursor = self.root.next
            while cursor != None:
                if counter == index:
                    tmp = Node(value, Node)
                    pre.next = tmp
                    tmp.next = cursor
                    break
                else:
                    counter += 1
                    pre = cursor
                    cursor = cursor.next

    def delNode(self, index):
        """
        删除Node
        :param index:
        :return:
        """
        if self.root == Node:
            return None
        if index < 0 or index > self.length - 1:
            print('Index 非法，超出索引')
        elif index == 0:
            self.root = self.root.next
        else:
            pre = self.root
            cursor = pre.next
            counter = 1
            while cursor != None:
                if index == counter:
                    pre.next = cursor.next
                    break
                else:
                    pre = cursor
                    cursor = cursor.next
                    counter += 1

    def print(self):
        """
        打印链表
        :return:
        """
        if self.root == None:
            print('Nothing')
            return None
        else:
            cursor = self.root
            # 开头的[
            print('[', end='')
            while cursor != None:
                # 输出结尾的]
                if cursor.next == None:
                    print(cursor.value, end=']')
                    cursor = None
                else:
                    print(cursor.value, end=', ')
                    cursor = cursor.next
            print()

    def delValue(self, value):
        """
        删除值为value的Node
        :param value:
        :return:
        """
        if self.root == None:
            return None
        if self.root.value == value:
            self.root = self.root.next
        else:
            pre = self.root
            cursor = pre.next
            while cursor != None:
                if cursor.value == value:
                    pre.next = cursor.next
                    cursor = cursor.next
                    continue
                else:
                    pre = cursor
                    cursor = cursor.next

    def is_empty(self):
        """
        判断链表是否为空
        :return:
        """
        if self.root == None or self.length == 0:
            return True
        else:
            return False

    def getValue(self, index):
        """
        获取指定位置的节点值
        :param index:
        :return:
        """
        if self.root == None:
            return None
        if index < 0 or index > self.length - 1:
            print('Index 非法，超出索引')
        elif index == 0:
            return self.root.value
        else:
            counter = 0
            cursor = self.root
            while cursor != None:
                if counter == index:
                    return cursor.value
                else:
                    counter += 1
                    cursor = cursor.next

    def getValueIndex(self, value):
        """
        获取值为某个值的索引
        :return:
        """
        indexs = []
        if self.root == None:
            return None
        if self.root.value == value:
            self.root = self.root.next
            indexs.append(0)
        else:
            index = 1
            cursor = self.root
            while cursor != None:
                if cursor.value == value:
                    indexs.append(index)
                    index += 1
                cursor = cursor.next
        return indexs

    def peek(self):
        """
        获取尾部节点，且不删除该节点
        :return:
        """
        return self.getValue(self.length - 1)

    def pop(self):
        """
        获取表尾节点并删除
        :return:
        """
        if self.root == None or self.length == 0:
            print('空表')
            return None
        if self.length == 1:
            top = self.root.value
            self.root = None
            return top
        else:
            pre = self.root
            cursor = pre.next
            while cursor.next != None:
                pre = cursor
                cursor = cursor.next
            top = cursor.value
            cursor = None
            pre.next = None
            return top

    def updateNode(self, index, value):
        """
        修改指定位置的节点
        :param index:
        :return:
        """
        if self.root == None:
            return None
        if index < 0 or index > self.length - 1:
            print('Index 非法， 索引不在范围内')
        if index == 0:
            self.root.value = value
        else:
            cursor = self.root.next
            counter = 1
            while cursor != None:
                if counter == index:
                    cursor.value = value
                    break
                cursor = cursor.next
                counter += 1

    def delDuplecate(self):
        """
        删除重复的元素  ????????????
        :return:
        """
        # 使用一个map来存放即可，类似于变形的“桶排序”
        if self.root == None:
            return None
        if self.length == 1:
            return None
        pre = self.root
        cursor = pre.next
        dic = {}
        # 为字典赋值
        temp = self.root
        while temp != None:
            dic[str(temp.value)] = 0
            temp = temp.next
        temp = None
        # 开始实施删除重复元素的操作
        while cursor != None:
            if dic[str(cursor.value)] == 1:
                pre.next = cursor.next
                cursor = cursor.next
            else:
                dic[str(cursor.value)] += 1
                pre = cursor
                cursor = cursor.next

    def reverse(self):
        """
        逆序  ?????????????????????????????
        :return:
        """
        if self.root == None:
            return None
        if self.length == 1:
            return None
        else:
            post = None
            pre = None
            cursor = self.root
            while cursor != None:
                post = cursor.next
                cursor.next = pre
                pre = cursor
                cursor = post
            self.root = pre

    def delLinkedList(self):
        """
        删除链表
        :return:
        """
        if self.root == None:
            return None
        else:
            self.root = None

    def getNode(self, index):
        if self.root == None:
            return None
        if index == 0:
            return self.root
        if index < 0 or index > self.length:
            print('Index 非法， 索引不在范围内')
        else:
            counter = 0
            cursor = self.root
            while cursor != None:
                if counter == index:
                    return cursor
                cursor = cursor.next
                counter += 1


if __name__ == '__main__':
    # ------创建链表-------
    linkedlist = LinkedList()
    # ------添加节点-------
    linkedlist.addNode(1)
    linkedlist.prepend(0)
    linkedlist.insert(0, -1)
    linkedlist.insert(2, -3)
    linkedlist.print()

    # ------测试插入节点-------
    linkedlist.insert(1, 6)
    linkedlist.print()

    # ------测试删除节点-------
    linkedlist.delNode(3)
    linkedlist.print()

    linkedlist.addNode(0)
    linkedlist.print()

    # ------测试删除某值的节点-------
    linkedlist.delValue(0)
    linkedlist.print()

    # ------测试获取节点的值-------
    i = 1
    value = linkedlist.getValue(i)
    print(i, '处的值为: ', value)

    # ------测试查找某值的索引-------
    linkedlist.prepend(0)
    linkedlist.addNode(1)
    linkedlist.addNode(6)
    linkedlist.addNode(-3)
    linkedlist.print()
    print(linkedlist.getValueIndex(-3))

    # ------测试获取最后一个值-------
    linkedlist.print()
    value = linkedlist.peek()
    print('链表最后一个值为: ', value)

    # ------测试获取并删除最后一个值-------
    value = linkedlist.pop()
    print('链表最后一个值为: ', value)
    linkedlist.print()

    # ------测试反转-------
    linkedlist.reverse()
    print('反转后: ', end='')
    linkedlist.print()

    # ------测试修改-------
    linkedlist.print()
    linkedlist.updateNode(5, 7)
    print('修改后: ', end='')
    linkedlist.print()

    # ------测试删除重复-------
    # linkedlist.print()
    # linkedlist.delDuplecate()
    # linkedlist.print()

    # -----获取节点-------
    node1 = linkedlist.getNode(1)
    linkedlist.print()
    print(node1.next.value)

    # ------清空链表-------
    linkedlist.delLinkedList()
    linkedlist.print()

    # ------测试长度-------
    print('链表长度: ', linkedlist.length)
```