---
title: Ubuntu 18.04 安装Hive
date: 2018-12-06 16:42:13
en_title: Hive installation on Ubuntu 18.04
tags: [Hadoop, Hive, Big Data, Liunx]
---

<h2>前言</h2>

Hive是一个基于Hadoop的数据仓库, 可以将结构化的数据映射为一张数据表, 并提供简单的SQL查询功能, 他会将SQL转化为MapReduce的方式运行, 因为它支持原生的SQL语句,并能够将它转变为MapReduce任务, 所以特别的方便, 十分适合统计任务.

<h2>安装</h2>

<h3>1. 下载HIVE</h3>

假设你的电脑已经安装了MySQL

我的Hadoop版本是2.9.2, 我下载的对应HIVE版本是1.2.2
之前下载了 2.3.4 结果版本太新不匹配

https://hive.apache.org/downloads.html

<pre><code>tar xvzf apache-hive-1.2.2-bin.tar.gz
sudo mv apache-hive-1.2.2-bin /opt/hive-1.2.2
</code></pre>

<h3>2. 配置HIVE</h3>

<h4>2.1 配置环境变量</h4>

<pre><code>    vim ~/.bashrc

# Hive
export HIVE_HOME=/opt/hive-1.2.2
export PATH=${HIVE_HOME}/bin:$PATH

    source ~/.bashrc
</code></pre>

<h4>2.2 修改HIVE配置文件</h4>

<pre><code>    cd $HIVE_HOME/conf
    vim hive-site.xml
    # 添加如下内容

    &lt;?xml version="1.0" encoding="UTF-8" standalone="no"?&gt;
    &lt;?xml-stylesheet type="text/xsl" href="configuration.xsl"?&gt;
    &lt;configuration&gt;
        &lt;property&gt;
            &lt;name&gt;javax.jdo.option.ConnectionURL&lt;/name&gt;
            &lt;value&gt;jdbc:mysql://localhost:3306/hive?useSSL=false&lt;/value&gt;
            &lt;description&gt;JDBC connect string for a JDBC metastore&lt;/description&gt;
        &lt;/property&gt;
        &lt;property&gt;
            &lt;name&gt;javax.jdo.option.ConnectionDriverName&lt;/name&gt;
            &lt;value&gt;com.mysql.jdbc.Driver&lt;/value&gt;
            &lt;description&gt;Driver class name for a JDBC metastore&lt;/description&gt;
        &lt;/property&gt;
        &lt;property&gt;
            &lt;name&gt;javax.jdo.option.ConnectionUserName&lt;/name&gt;
            &lt;!--MySQL账号--&gt;
            &lt;value&gt;root&lt;/value&gt;
            &lt;description&gt;username to use against metastore database&lt;/description&gt;
        &lt;/property&gt;
        &lt;property&gt;
            &lt;name&gt;javax.jdo.option.ConnectionPassword&lt;/name&gt;
            &lt;!--MySQL密码--&gt;
            &lt;value&gt;123456&lt;/value&gt;
            &lt;description&gt;password to use against metastore database&lt;/description&gt;
        &lt;/property&gt;
    &lt;/configuration&gt;
</code></pre>

<h3>3. 下载MySQL连接器</h3>

https://dev.mysql.com/downloads/connector/j/

选择对应的版本下载:

<pre><code>tar xvzf mysql-connector-java-5.1.47.tar.gz
mv mysql-connector-java-5.1.47-bin.jar /opt/hive-1.2.2/lib/
</code></pre>

<h2>测试</h2>

输入命令<code>hive</code>进入命令交互界面
创建测试表:

<pre><code>create table employee (name String, age int);

desc employee;

insert into employee values ("Ying", 18);
</code></pre>

然后你就可以看到一个MapReduce任务正在运行, 在本地端口8088上也可以看得到任务
<img src="https://img.yingjoy.cn/image/2018/12/Screenshot-from-2018-12-06-16-39-44.png" />