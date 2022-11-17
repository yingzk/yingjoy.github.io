---
title: 每天一个Linux命令 -- cd
date: 2017-12-19 19:42:26
en_title: linux command -- cd
tags: [Linux]
---

Linux cd 命令是最基本的命令语句，其他的命令语句要进行操作，都是建立在使用 cd 命令上的。所以，学习Linux 常用命令，首先就要学好 cd 命令的使用方法技巧。用cd 打开进入其它目录

## 1. 命令格式

`cd [目录名]`

## 2.命令功能

切换到当前目录到目标目录

## 3. 常用范例

### 3.1. 进入系统根目录

```shell
cd /
```

### 3.2. 前往上一级目录

```shell
cd ..
```

### 3.3. 前往环境变量配置的目录

```shell
cd $JAVA_HOME
```

### 3.4. 进入当前用户的主目录

```shell
cd ~
```

### 3.5. 返回之前的目录（比如目录直接进行绝对路径跳转）

```shell
cd -
```

![linux-cd-1](https://img.yingjoy.cn/image/2017/12/linux-cd-1.png)

### 3.6. 把上个命令作为cd的参数使用

```shell
cd !$
```

![linux-cd-2](https://img.yingjoy.cn/image/2017/12/linux-cd-2.png)
