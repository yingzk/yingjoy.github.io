---
title: Hadoop伪分布式安装 Ubuntu 18.04
date: 2018-12-04 11:03:35
en_title: Hadoop Pseudo Distributed on Ubuntu 18.04
tags: [Hadoop, Big Data, Liunx]
---

<h2>1. 下载相关文件</h2>

<ul>
<li><a href="http://www.apache.org/dyn/closer.cgi/hadoop/common/">Hadoop</a></li>
<li><a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html">JDK</a> 这里我使用了JDK1.8</li>
</ul>

<h2>2. 安装</h2>

<h4>2.1 安装JDK</h4>

添加环境变量

<pre><code>export JAVA_HOME=/opt/jdk1.8.0_181
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
</code></pre>

<h4>2.2 安装ssh rsync</h4>

<pre><code> sudo apt-get install ssh
 sudo apt-get install rsync
</code></pre>

配置免密登录

<pre><code>ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub &gt;&gt; ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
</code></pre>

<h2>3. 运行</h2>

<h4>3.1 初始化Hadoop</h4>

<pre><code>bin/hdfs namenode -format
</code></pre>

这里可能会报错JAVA_HOME Not Found, 解决办法如下:

<pre><code>vim /opt/hadoop-2.9.2/etc/hadoop/hadoop-env.sh

修改
export JAVA_HOME = ${JAVA_HOME}
为
export JAVA_HOME=/opt/jdk1.8.0_181
</code></pre>

配置Hadoop文件

<pre><code>1. etc/hadoop/core-site.xml
&lt;configuration&gt;
    &lt;property&gt;
        &lt;name&gt;fs.defaultFS&lt;/name&gt;
        &lt;value&gt;hdfs://localhost:9000&lt;/value&gt;
    &lt;/property&gt;
&lt;/configuration&gt;

2. etc/hadoop/hdfs-site.xml
&lt;configuration&gt;
    &lt;property&gt;
        &lt;name&gt;dfs.replication&lt;/name&gt;
        &lt;value&gt;1&lt;/value&gt;
    &lt;/property&gt;
&lt;/configuration&gt;
</code></pre>

<h4>3.2 启动</h4>

<pre><code>sbin/start-dfs.sh
</code></pre>

打开浏览器: <a href="http://localhost:50070/">http://localhost:50070/</a>, 显示如下界面,成功
<img src="https://img.yingjoy.cn/image/2018/12/Screenshot-from-2018-12-04-11-00-45.png" />

<h2>4. 其他</h2>

<h4>4.1 创建HDFS目录</h4>

<pre><code>bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/ying
</code></pre>

<h4>4.2 测试文件上传</h4>

<pre><code>bin/hdfs dfs -put etc/hadoop/ input
# 查看文件
bin/hdfs dfs -ls /user/ying/input
</code></pre>

<img src="https://img.yingjoy.cn/image/2018/12/Screenshot-from-2018-12-04-11-12-01.png" />
当然,也可以通过它的可视化界面查看文件

<img src="https://img.yingjoy.cn/image/2018/12/Screenshot-from-2018-12-04-11-10-57.png" />

<h4>4.3 运行示例程序</h4>

<pre><code>bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.9.2.jar grep input output 'dfs[a-z.]+'

bin/hdfs dfs -get output output
cat output/*
</code></pre>

<h2>5. 配置yarn</h2>

<pre><code>1. etc/hadoop/mapred-site.xml
&lt;configuration&gt;
    &lt;property&gt;
        &lt;name&gt;mapreduce.framework.name&lt;/name&gt;
        &lt;value&gt;yarn&lt;/value&gt;
    &lt;/property&gt;
&lt;/configuration&gt;

1. etc/hadoop/yarn-site.xml(这里从template复制一份出来)
&lt;configuration&gt;
    &lt;property&gt;
        &lt;name&gt;yarn.nodemanager.aux-services&lt;/name&gt;
        &lt;value&gt;mapreduce_shuffle&lt;/value&gt;
    &lt;/property&gt;
&lt;/configuration&gt;
</code></pre>

<h4>5.1 启动yarn</h4>

<pre><code>sbin/start-yarn.sh
</code></pre>

打开本地网址: <a href="http://localhost:8088/">http://localhost:8088/</a>

显示如下则成功:
<img src="https://img.yingjoy.cn/image/2018/12/Screenshot-from-2018-12-04-11-33-46.png" />

<h2>停止</h2>

<pre><code>sbin/stop-dfs.sh
sbin/stop-yarn.sh
</code></pre>

<strong>这里补充一点</strong>
在配置core-site.xml时,我们最好指定hadoop.tmp.dir, 因为hadoop默认的文件夹在/tmp目录下,所有机器重启后会出现无法启动的情况(无法访问50070端口), 在配置文件core-site.xml中加入以下属性,并创建自定义的tmp目录(不要在/tmp目录下创建)

<pre><code>&lt;property&gt;
    &lt;name&gt;hadoop.tmp.dir&lt;/name&gt;
    &lt;value&gt;/opt/hadoop_tmp&lt;/value&gt;
&lt;/property&gt;
</code></pre>
