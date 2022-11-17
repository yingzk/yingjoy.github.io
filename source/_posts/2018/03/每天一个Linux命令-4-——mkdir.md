---
title: 每天一个Linux命令(4)——mkdir
date: 2018-03-29 00:20:01
en_title: linux command -- mkdir
tags: [Linux]
---

<strong>mkdir命令</strong>用来创建目录。该命令创建由<em>dirname</em>命名的目录。如果在目录名的前面没有加任何路径名，则在当前目录下创建<em>dirname</em>指定的目录，如果给出了一个已经存在的路径。则会在该路径下创建指定的目录。<strong>需保证目录名没有与其它目录名重复。</strong>

<strong>注意：</strong> 在创建文件时，不要把所有的文集爱你都存放在主目录中， 可以创建子目录，通过它们来有效的组织文件，最好采用前后一致的命名方式来区分文件和目录。例如，目录名可以以大写字母开头，这样目录列表中目录名就会出现在前面。

在一个子目录中应包含类型相似或用途相近的文件。例如，应建立一个子目录，它包含所有的数据库文件，另有一个子目录应包含电子表格文件，还有一个子目录应包含文字处理文档，等等。目录也是文件，它们和普通文件一样遵循相同的命名规则，并且利用全路径可以唯一地指定一个目录。

<h4>语法</h4>

<blockquote>
  mkdir (选项) (参数)
</blockquote>

<h4>选项</h4>

<blockquote>
  -Z 设置安全上下文，当使用SELinux时有效；
  
  -m&lt;目标属性>或--mode&lt;目标属性>建立目录的同时设置目录的权限；
  
  -p或--parents 若所要建立目录的上层目录目前尚未建立，则会一并建立上层目录；
  --version 显示版本信息。
</blockquote>

<h4>参数</h4>

目录：指定要创建的目录列表，多个目录之间用空格隔开。

<h4>实例</h4>

<h5>1. 在目录<code>/root</code>下创建hello文件夹，且只有文件主有读、写和执行权限，其他人无权访问</h5>

<pre><code class="shell">mkdir -m 700 /root/hello
</code></pre>

<h5>2. 在当前目录下创建hello/hello1目录  hello 和 hello1均不存在，权限设置为文件主可读、写、执行，同组用户可读和执行，其他用户无权访问</h5>

<pre><code class="shell">mkdir -p -m 750 hello/hello1
</code></pre>