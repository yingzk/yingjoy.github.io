---
title: Python Web - Flask笔记10
date: 2018-08-10 17:42:36
en_title: Python Web - Flask Note 10
tags: [Python, Python Web, Flask]
permalink: /flask-notes/10
---

<h2>76. 部署</h2>

<h3>在开发机上做准备</h3>

<ol>
<li>确保项目没有BUG</p></li>
<li><p>用<code>pip freeze &gt; requirements.txt</code>将当前环境所需要的包写入到<code>requirements.txt</code>中</p></li>
<li><p>将项目上传到服务器的<code>/srv</code>目录下。这里以<code>git</code>为例

<pre><code>git init
git remote add origin xxx.git
git pull origin master --allow-unrelated-histories
git add .
git commit -m "xxx"
git push origin master
</code></pre></li>
</ol>

<h3>在服务器上的准备工作</h3>

<ol>
<li>安装<code>MySQL</code>服务器和客户端

<pre><code class="shell">yum install mysql-server mysql-client
yum install libmysqld-dev
</code></pre></li>
<li>安装好项目用到的Python版本

<pre><code>yum install python
yum install python-pip
pip install --upgrade pip
</code></pre></li>
<li>安装<code>virtualenv</code>以及<code>virutalenvwrapper</code>。并创建虚拟环境。</p></li>
</ol>

<ul>
<li>pip install virtualenv</li>
<li>pip install virtualenvwrapper</li>
<li>yum install vim</li>
<li>vim ~/.bashrc 进入文件中，填入以下两行代码：
 <code>python export WORKON_HOME=$HOME/.virtualenvs source /usr/local/bin/virtualenvwrapper.sh</code></li>
<li>source ~/.bashrc</li>
</ul>

<ol>
<li><p>安装<code>git</code>：

<ol>
<li><code>yum install git</code></li>
<li>为了方便XShell或者CRT连接服务器，建议安装<code>OpenSSH</code>：
<code>yum install openssh-server openssh-client service ssh restart</code></li>
<li>安装<code>MySQL</code>服务器和客户端：
<code>yum install mysql-server mysql-client sudo apt-get install libmysqld-dev</code></li>
<li>进入虚拟环境中，然后进入到项目所在目录，执行命令：<code>pip install -r requirements.txt</code>，安装好相应的包。</li>
<li>在<code>mysql</code>数据库中，创建相应的数据库。</li>
<li>执行<code>python manage.py migrate</code>命令，将迁移文件，映射到数据库中，创建相应的表。</li>
<li>执行<code>python manage.py runserver 0.0.0.0:8000</code>，然后在你自己电脑上，在浏览器中输入<code>http://你的服务器的ip地址:8000/</code>，访问下网站所有页 面，确保所有页面都没有错误。</li>
<li>设置<code>ALLOW_HOST</code>为你的域名，以及ip地址。</li>
<li>设置<code>DEBUG=False</code>，避免如果你的网站产生错误，而将错误信息暴漏给用户。</li>
<li>收集静态文件：<code>python manage.py collectstatic</code>。</li>
</ol>

<h3>安装uwsgi</h3>

<ol>
<li>uwsgi是一个应用服务器，非静态文件的网络请求就必须通过他完成，他也可以充当静态文件服务器，但不是他的强项。uwsgi是使用python编写的，因此通过<code>pip install uwsgi</code>就可以了。(uwsgi必须安装在系统级别的Python环境中，不要安装到虚拟环境中)。</li>
<li>使用命令<code>uwsgi --http :8000 --module yingjoy.wsgi --vritualenv=/root/.virtualenvs/django-env-py2</code>。用<code>uwsgi</code>启动项目，如果能够在浏览器中访问到这个页面，说明<code>uwsgi</code>可以加载项目了。</li>
</ol>

<h3>编写uwsgi配置文件：</h3>

在项目的路径下面，创建一个文件叫做<code>yingjoy_uwsgi.ini</code>的文件，然后填写以下代码：

<pre><code>[uwsgi]

# Django相关的配置
# 必须全部为绝对路径
# 项目的路径
chdir           = /srv/yingjoy
# Django的wsgi文件
module          = yingjoy.wsgi
# Python虚拟环境的路径
home            = /root/.virtualenvs/django-env-py2

# 进程相关的设置
# 主进程
master          = true
# 最大数量的工作进程
processes       = 10
# socket文件路径，绝对路径
socket          = /srv/yingjoy/yingjoy.sock
# 设置socket的权限
chmod-socket    = 666
# 退出的时候是否清理环境
vacuum          = true
</code></pre>

然后使用命令<code>uwsgi --ini yingjoy.ini</code>，看下是否还能启动这个项目。

<h3>安装nginx：</h3>

<ol>
<li>nginx是一个web服务器。用来加载静态文件和接收http请求的。通过命令<code>sudo apt install nginx</code>即可安装。</p></li>
<li><pre><code>nginx
</code></pre>

<p>常用命令：</p></li>
</ol>

<ul>
<li>启动nginx：service nginx start</li>
<li>关闭nginx：service nginx stop</li>
<li>重启nginx：service nginx restart</li>
</ul>

<h3>收集静态文件：</h3>

<p>静态文件应该让nginx来服务，而不是让django来做。首先确保你的<code>settings.py</code>文件中有一个<code>STATIC_ROOT</code>配置，这个配置应该指定你的静态文件要放在哪个目录下。那么我们可以执行以下命令：<code>python manage.py collectstatic</code>来收集所有静态文件，将这些静态文件放在指定的目录下。

<h3>编写nginx配置文件：</h3>

在<code>/etc/nginx/conf.d</code>目录下，新建一个文件，叫做<code>yingjoy.conf</code>，然后将以下代码粘贴进去：

<pre><code>upstream yingjoy {
   server unix:///srv/yingjoy/yingjoy.sock; 
}

# 配置服务器
server {
   # 监听的端口号
   listen      80;
   # 域名
   server_name 192.168.0.101; 
   charset     utf-8;

   # 最大的文件上传尺寸
   client_max_body_size 75M;  

   # 静态文件访问的url
   location /static {
       # 静态文件地址
       alias /srv/yingjoy/static_dist; 
   }

   # 最后，发送所有非静态文件请求到django服务器
   location / {
       uwsgi_pass  yingjoy;
       # uwsgi_params文件地址
       include     /etc/nginx/uwsgi_params; 
   }
}
</code></pre>

写完配置文件后，为了测试配置文件是否设置成功，运行命令：<code>service nginx configtest</code>，如果不报错，说明成功。
每次修改完了配置文件，都要记得运行<code>service nginx restart</code>。

<h3>使用supervisor配置：</h3>

让supervisor管理uwsgi，可以在uwsgi发生意外的情况下，会自动的重启。

<ol>
<li><code>supervisor</code>的安装：在系统级别的python环境下<code>pip install supervisor</code>。</p></li>
<li><p>[supervisord]
# log的级别
loglevel=info

# 使用supervisorctl的配置
[supervisorctl]
# 使用supervisorctl登录的地址和端口号
serverurl = <a href="http://127.0.0.1:9001/">http://127.0.0.1:9001</a>

# 登录supervisorctl的用户名和密码
username = admin
password = 123

[inet_http_server]
# supervisor的服务器
port = :9001
# 用户名和密码
username = admin
password = 123

[rpcinterface:supervisor]
​

supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

然后使用命令

<pre><code>supervisord -c ying_supervisor.conf
</code></pre>

运行就可以了。 以后如果想要启动uwsgi，就可以通过命令
```
supervisorctl -c supervisor.conf`进入到管理控制台，然后可以执行相关的命令进行管理：</p></li>
</ol>

<ul>
<li>status # 查看状态</li>
<li>start program_name #启动程序</li>
<li>restart program_name #重新启动程序</li>
<li>stop program_name # 关闭程序</li>
<li>reload # 重新加载配置文件</li>
<li>quit # 退出控制台
```</li>
</ul>

<h3>nginx+uwsgi+supervisor关系图</h3>

<p><img src="https://img.yingjoy.cn/image/2018/08/1.png" alt="" />

<p>​</p></li>
</ol>