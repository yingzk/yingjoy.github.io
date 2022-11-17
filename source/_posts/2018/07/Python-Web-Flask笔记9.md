---
title: Python Web - Flask笔记9
date: 2018-07-28 17:31:31
en_title: Python Web - Flask Note 9
tags: [Python, Python Web, Flask]
permalink: /flask-notes/9
---

<h2>68. Memcached</h2>

Memcached是一个高性能的<strong>分布式</strong>的<strong>内存对象</strong>缓存系统，用来分担数据库的压力。Memcached可以存储各种各样的数据，包括图像，视频，文件以及数据库检索的结果等等，简单来说就是<strong>将数据存储到内存中，然后再从内存中读取，从而大大提高读取速度。</strong>实际是不会将二进制文件直接存储到Memcached中的，只存储二进制文件的路径。

Memcached经常被用于以下情况：存储验证码、图形验证码、短信验证码、登录session等所有不是至关重要的数据。

<h2>69. Memcached的安装和启动</h2>

Windows: （尽量使用管理员模式来安装）

不在管理员下运行会报错：

<code>failed to install service or service already installed</code>

如果出现提示信息，缺失pthreadGC2.dll文件，将其拷贝到<code>C:\Windows\System32</code>下即可0

参考和文件下载：https://commaster.net/content/installing-memcached-windows

memcached没有提供windows下的安装包，需要自己编译

<ul>
<li>安装： <code>memcached.exe -d install</code></li>
<li>启动： <code>memcached.exe -d start</code></li>
</ul>

Linux(Ubuntu):

<ul>
<li>安装： <code>sudo apt-get install memcached</code></li>
<li>启动： <code>sudo service memcached start</code></li>
</ul>

Linux如果想要指定参数，就不能使用上面的方式启动，而应该使用下面的方法来运行

<pre><code class="shell">/usr/bin/memcached 参数(需要指定-u 用户)
如：
/usr/bin/memcached -u memcached -m 1024 -p 11212 -d start
</code></pre>

<h2>70. Memcached 的参数</h2>

<ul>
<li><code>-d</code> 这个参数是让memcached在后台运行</li>
<li><code>-m</code> 指定占用多少内存，以M为单位，默认64M</li>
<li><code>-p</code> 指定占用端口，默认使用11211端口</li>
<li><code>-l</code> 其它机器可以通过哪个ip地址连接本机的memcached，如果Linux使用service方式启动的话，那么只有本机可以访问，其他机器不行，如果需要其他机器访问，则设置参数<code>-l</code>为<code>0.0.0.0</code></li>
</ul>

<h2>71. 使用Telnet操作memcached</h2>

语法：

<pre><code class="shell">telnet ip port
如：
telnet 127.0.0.1 11211
------------------------------------
set username 0 60 3     # 60:过期时间  3:长度
abc
------------------------------------
get username
</code></pre>

<h3>1. 添加数据</h3>

参考：https://blog.csdn.net/codetomylaw/article/details/43015295

<ul>
<li>set

语法：

<pre><code class="shell">set key flas timeout value_length 
# flas 代表是否需要压缩， 一般设置为0，不需要压缩
# timeout 代表过期时间
# value_length 代表值长度， 长度必须要一致，否则无法存储
value
</code></pre>

如果key存在，则覆盖

示例：

<pre><code class="shell">set username 0 60 4
ying
</code></pre></li>
<li>add，只能添加 不存在的key，不想set可以覆盖

语法：

<pre><code class="shell">add key flas(0) timeout value_length
value
</code></pre>

示例：

<pre><code class="shell">add username 0 60 4
ying
</code></pre></li>
</ul>

<h3>2. 获取数据</h3>

<ul>
<li>get

语法：获取多个值空格隔开

<pre><code class="shell">get key
</code></pre>

示例：

<pre><code class="shell">get username
</code></pre></li>
</ul>

<h3>3. 删除数据</h3>

<ul>
<li>delete

语法：

<pre><code class="shell">delete key
</code></pre>

示例：

<pre><code class="shell">delete username
</code></pre></li>
<li>flash_all

删除memcached中所有的数据

语法：

<pre><code class="shell">flash_all
</code></pre>

​</p></li>
</ul>

<h3>其它</h3>

<ul>
<li>replace</li>
</ul>

<p>替换

语法：

<pre><code class="shell">replace key flas timeout value_length
value
</code></pre>

示例：

<pre><code class="shell">replace username 0 80 7
yingjoy
</code></pre>

<ul>
<li>incr</li>
</ul>

给对应的值加上一定的值

语法

<pre><code class="shell">incr key add
</code></pre>

示例：

<pre><code class="shell">set age 0 120 2
18
----------------
incr age 2
----------------
get age
20
</code></pre>

对应decr，进行减操作

<ul>
<li>append往后追加：<code>append  key datablock  status</code></li>
<li>prepend往前追加：<code>prepend key datablock status</code></p></li>
<li><p>监察存储命令cas</p></li>
<li><p>stats

查看memcached当前的状态，可以计算出命中率，从而判断memcached中是否存在很多垃圾文件。

<ul>
<li><code>get_hists</code> 获取命中多少次</li>
<li><code>get_misses</code>获取get空的次数</li>
<li><code>curr_items</code>当前memcached中键值对的个数</li>
<li><code>total_connections</code> 从<code>memcached</code>开启到现在总共的连接数</li>
<li><code>curr_connections</code>当前连接数</li>
</ul></li>
<li>注： Memcached默认最大连接数为1024</p></li>
</ul>

<h2>72. 使用Python操作Memcached</h2>

<h3>1. 安装<code>python-memcached</code></h3>

<pre><code class="shell">pip install python-memcached
</code></pre>

<h3>2. 建立连接</h3>

<pre><code class="python">import memcache
mc = memcache.Client(['192.168.1.200', '11211'], debug=True)
# 这里可以分布式，在list后面再添加memcached服务器即可
</code></pre>

<h3>3. 设置数据</h3>

<pre><code class="python">mc.set('welcome', 'hello world', time=60*5)
mc.set_multi({'username':'ying', 'age':18}, time=60*5)
</code></pre>

<h3>4. 获取数据</h3>

<pre><code class="python">result = mc.get_multi(['welcome', 'username', 'age'])
print(result)
# 这里result是字典类型
</code></pre>

<h3>5. 删除数据</h3>

<pre><code class="python">mc.delete('welcome')
result = mc.get('welcome')
print(result)
</code></pre>

<h3>6. 自增</h3>

<pre><code class="python">mc.incr('age', delta=1)
result = mc.get('age')
print(result)
</code></pre>

<h3>7. 自减</h3>

<pre><code class="python">mc.decr('age', delta=10)
result = mc.get('age')
print(result)
</code></pre>

<p>分布式的时候，存的值是按照memcached的算法分配的，不同字段会在集群上不同的机器上存储。

<h2>73. Memcached的安全机制</h2>

由于Memcached登录的时候不需要输入用户名和密码，只需直到memcached服务器的ip和端口号即可，导致不安全，下面是解决方案：

<ol>
<li>开启服务器的时候<code>-l</code>参数不使用<code>0.0.0.0</code>设置仅允许本地可以连接</li>
<li>使用防火墙，关闭memcached端口，这样也可以防止其它服务器访问</li>
<li>编写防火墙规则</li>
</ol>

一般Memcached都在内网使用，不会在公网使用。

<h2>74. Redis</h2>

Redis是一种<code>NoSQL</code>数据库，他们的数据是保存在内存中，同时Redis也可以定时的把内存数据同步到磁盘中，即可以将数据持久化，并且他比Memcached支持更多的数据结构，(string, list[队列和栈], set[集合], sorted set[有序集合], hash(hash表))。参考文档：

http://redisdoc.com/index.html

<h3>1. Redis的使用场景</h3>

<ul>
<li>登录会话存储，存储在redis比memcached相比，数据不会丢失</li>
<li>排行榜/计数器：做排行耪用</li>
<li>作为消息队列：比如celery就是使用redis做中间件</li>
<li>当前在线人数</li>
<li>一些常用的数据缓存：比如bbs论坛，板块不会经常变换，但是每次访问首页都需要从mysql中获取，可以在redis中缓存起来，不用每次都请求mysql数据库。</li>
<li>把前200篇文章缓存或者评论缓存：一般用户浏览网站，只会浏览网站前面一部分文章或者评论，那么可以把前面200篇文章或者评论缓存起来，用户访问超过缓存数的文章，就访问数据库获取，并且把之前的缓存删除。</li>
<li>好友关系：如微博，QQ好友关系</li>
<li>发布和订阅功能，可以用来做聊天软件</li>
</ul>

<h3>2. Redis和Memcached的比较</h3>

<table>
<thead>
<tr>
  <th></th>
  <th>Memcached</th>
  <th>Redis</th>
</tr>
</thead>
<tbody>
<tr>
  <td>类型</td>
  <td>纯内存缓存系统（数据库）</td>
  <td>内存磁盘同步数据库</td>
</tr>
<tr>
  <td>数据类型</td>
  <td>在定义value时需要固定数据类型</td>
  <td>不需要</td>
</tr>
<tr>
  <td>虚拟内存</td>
  <td>不支持</td>
  <td>支持</td>
</tr>
<tr>
  <td>过期策略</td>
  <td>支持</td>
  <td>支持</td>
</tr>
<tr>
  <td>存储数据安全</td>
  <td>不支持</td>
  <td>可以将数据同步到dump.db</td>
</tr>
<tr>
  <td>灾难恢复</td>
  <td>不支持</td>
  <td>可以将磁盘中的数据恢复到内存中</td>
</tr>
<tr>
  <td>分布式</td>
  <td>支持</td>
  <td>主从同步</td>
</tr>
<tr>
  <td>发布与订阅</td>
  <td>不支持</td>
  <td>支持</td>
</tr>
</tbody>
</table>

<h3>3. Redis的安装</h3>

建议在Linux系统

<pre><code class="shell">yum install gcc
wget http://download.redis.io/releases/redis-4.0.2.tar.gz
tar xzf redis-4.0.2.tar.gz
cd redis-4.0.2
make
make install
</code></pre>

后台运行：

https://blog.csdn.net/ksdb0468473/article/details/52126009

添加环境遍历

<pre><code class="shell">vim /etc/profile
------------------------------
PATH=$PATH:/usr/local/bin
export PATH
------------------------------
source /etc/profile
</code></pre>

<h3>4. Redis的操作</h3>

<h4>启动redis:</h4>

<pre><code class="shell">redis-server /usr/local/bin/redis.conf
</code></pre>

<h4>连接redis</h4>

<pre><code class="python">redis-cli -h [ip] -p [port]
-----------------------------------
127.0.0.1:6379&gt;
</code></pre>

<h4>添加数据</h4>

<pre><code class="mysql">set key value
eg: 
set username ying
</code></pre>

当值为字符串且有空格时，使用单/双引号包裹<code>set welcome "hello world"</code>

<h4>获取数据</h4>

<pre><code class="mysql">get key
eg:
get username
</code></pre>

<h4>删除数据</h4>

<pre><code class="mysql">del key
eg:
del username
</code></pre>

<h4>设置过期时间</h4>

<pre><code>expire key timeout(秒)
eg:
set username 5
</code></pre>

<pre><code class="python">1. set key value EX timeout
2. setex key timeout value
eg:
set username ying EX 5
setex username 5 ying
</code></pre>

如果没有指定过期时间，则默认不过期

<h4>查看过期时间</h4>

<pre><code>ttl key
eg:
ttl username
</code></pre>

可以查看<code>key</code>距离过期还有多少秒

<h4>查看当前redis中所有的key</h4>

<pre><code>keys pattern
eg:
keys *
</code></pre>

pattern：正则匹配

<h3>5. 操作列表</h3>

Redis的列表分左右表头

<h4>在列表的左边添加元素</h4>

<pre><code>lpush key value
eg:
lpush user ying
</code></pre>

将值列表key的<strong>表头</strong>。如果列表key不存在，一个空列表会被创建，然后再执行lpush操作，当key存在的时候，会报错。

可以添加多个值，多个值使用空格隔开

<pre><code>lpush user user1 user2
</code></pre>

<h4>在列表右边添加元素</h4>

<pre><code>rpush key value
eg:
rpush user ying
</code></pre>

将值插列表key的<strong>表尾</strong>。如果列表key不存在，一个空列表会被创建，然后再执行rpush操作，当key存在的时候，会报错。

<h4>查看列表中的元素</h4>

<pre><code>lrange key start stop
</code></pre>

返回列表中指定的区域，区间的偏移量是start和stop，如果要从左边的第一个到最后一个<code>lrange key 0 -1</code>

<h4>移除列表中的值</h4>

<pre><code>lpop key
rpop key
eg:
lpop user
rpop user
</code></pre>

#### 移除并返回列表key的中间元素

<pre><code>lrem key count value
eg:
lrem user 3 ying
</code></pre>

从左将删除key列表中，count个值为value的元素

如果要删除所有，则设置count为0

<ul>
<li>count为正，则从表头到表尾删除</p></li>
<li><p>count为负，则从表尾到表头删除</p></li>
</ul>

<h4>指定返回第几个元素</h4>

<pre><code>lindex key index
eg:
lindex user 4
</code></pre>

<p>这个索引是从0开始的

<h4>获取列表中元素的个数</h4>

<pre><code>llen key
eg:
llen user
</code></pre>

<h3>6. 操作集合(set)</h3>

<strong>集合元素不能重复</strong>

<h4>添加元素</h4>

添加元素的位置是<strong>随机</strong>的

<pre><code>sadd set value1 value2 ...
eg:
sadd user user1 user2
</code></pre>

<h4>查看元素</h4>

<pre><code>smembers set
eg:
smembers user
</code></pre>

<h4>移除元素</h4>

<pre><code>srem set member
eg:
srem user user1
</code></pre>

<h4>查看集合中元素的个数</h4>

<pre><code>scard set
eg:
scard user
</code></pre>

<h4>获取多个集合的交集</h4>

<pre><code>sinter set1 set2
eg:
sinter user username
</code></pre>

<h4>获取多个集合的并集</h4>

<pre><code>sunion set1 set2
eg:
sunion user username
</code></pre>

<h4>获取多个集合的差集</h4>

<pre><code>sdiff set1 set2
eg:
sdiff user username
</code></pre>

<h3>7. 操作哈希(hash)</h3>

<h4>添加一个新值</h4>

<pre><code>hset key field value
eg:
hset user username ying age 18
</code></pre>

如果key不存在，则创建一个新的hash表，如果存在，则覆盖。

也可以使用<code>hmset</code>

<h4>获取hash中对应的field值</h4>

<pre><code>hget key field
eg:
hget user username
</code></pre>

<h4>删除hash中某个field</h4>

<pre><code>hdel key field
eg:
hdel user age
</code></pre>

<h4>获取hash中所有的field和value</h4>

<pre><code>hgetall key
eg:
hgetall user
</code></pre>

<h4>获取hash中所有的field</h4>

<pre><code>hkeys key
eg:
hkeys user
</code></pre>

<h4>获取hash中所有的value</h4>

<pre><code>hvals key
eg:
hvals user
</code></pre>

<h4>获取hash中总共有多少键值对</h4>

<pre><code>hlen key
eg:
hlen user
</code></pre>

<h3>8. 事务操作</h3>

Redis可以一次性执行多个命令，事务具有以下特点：

<ul>
<li>隔离操作：事务中所有的命令会被序列化，按顺序执行，不会被其他命令打扰</li>
<li>原子操作：事务中的命令要不全部执行，要不全部都不执行</li>
</ul>

<h4>开启一个事务</h4>

<pre><code>multi
</code></pre>

以后执行的所有命令都会在这个事务中执行。

<h4>执行事务</h4>

<pre><code>exec
</code></pre>

<h4>退出事务</h4>

<pre><code>discard
</code></pre>

<h4>监视一个或多个key</h4>

<pre><code>watch key
</code></pre>

先进行监视，再进入事务，如果监听的值与事务中有误，则不会执行事务。如，在另一个窗口中重新修改事务中key的值。

<h4>取消所有key的监视</h4>

<pre><code>uwatech
</code></pre>

<h3>9. 发布/订阅操作</h3>

<h4>给某个频道发消息</h4>

<pre><code>publish channel message
</code></pre>

<h4>订阅某个频道的消息</h4>

<pre><code>subscribe channel
</code></pre>

<h3>10. 数据持久化</h3>

Redis提供了两种数据备份的方式，一种是RDB，另一种是AOF。

<h4>RDB同步机制：</h4>

<ol>
<li>开启和关闭：默认情况下是开启了。如果想关闭，那么注释掉<code>redis.conf</code>文件中的所有<code>save</code>选项就可以了。</li>
<li>同步机制：

<ul>
<li>save 900 1：如果在900s以内发生了1次数据更新操作，那么就会做一次同步操作。</li>
<li>save 300 10：如果在300s以内发生了10数据更新操作，那么就会做一次同步操作。</li>
<li>save 60 10000：如果在60s以内发生了10000数据更新操作，那么就会做一次同步操作。</li>
</ul></li>
<li>存储内容：具体的值，而是命令。并且是经过压缩后存储进去的。</li>
<li>存储路径：根据<code>redis.conf</code>下的<code>dir</code>以及<code>rdbfilename</code>来指定的。默认是<code>/var/lib/redis/dump.rdb</code>。</li>
<li>优点：

<ul>
<li>存储数据到文件中会进行压缩，文件体积比aof小。</li>
<li>因为存储的是redis具体的值，并且会经过压缩，因此在恢复的时候速度比AOF快。</li>
<li>非常适用于备份。</li>
</ul></li>
<li>缺点：

<ul>
<li>RDB在多少时间内发生了多少写操作的时候就会出发同步机制，因为采用压缩机制，RDB在同步的时候都重新保存整个Redis中的数据，因此你一般会设置在最少5分钟才保存一次数据。在这种情况下，一旦服务器故障，会造成5分钟的数据丢失。</li>
<li>在数据保存进RDB的时候，Redis会fork出一个子进程用来同步，在数据量比较大的时候，可能会非常耗时。</li>
</ul></li>
</ol>

<h4>AOF同步机制：</h4>

<ol>
<li>开启和关闭：默认是关闭的。如果想要开启，那么修改redis.conf中的<code>appendonly yes</code>就可以了</li>
<li>同步机制：

<ul>
<li>appendfsync always：每次有数据更新操作，都会同步到文件中。</li>
<li>appendfsync everysec：每秒进行一次更新。</li>
<li>appendfsync no：使用操作系统的方式进行更新。普遍是30s更新一次。</li>
</ul></li>
<li>存储内容：存储的是具体的命令。不会进行压缩。</li>
<li>存储路径：根据<code>redis.conf</code>下的<code>dir</code>以及<code>appendfilename</code>来指定的。默认是<code>/var/lib/redis/appendonly.aof</code>。</li>
<li>优点：

<ul>
<li>AOF的策略是每秒钟或者每次发生写操作的时候都会同步，因此即使服务器故障，最多只会丢失1秒的数据。 </li>
<li>AOF存储的是Redis命令，并且是直接追加到aof文件后面，因此每次备份的时候只要添加新的数据进去就可以了。</li>
<li>如果AOF文件比较大了，那么Redis会进行重写，只保留最小的命令集合。</li>
</ul></li>
<li>缺点：

<ul>
<li>AOF文件因为没有压缩，因此体积比RDB大。 </li>
<li>AOF是在每秒或者每次写操作都进行备份，因此如果并发量比较大，效率可能有点慢。</li>
<li>AOF文件因为存储的是命令，因此在灾难恢复的时候Redis会重新运行AOF中的命令，速度不及RDB。</li>
</ul></li>
</ol>

<h3>11. 给redis指定密码</h3>

<ol>
<li>设置密码：在<code>reids.conf</code>配置文件中，将<code>requirepass pasword</code>取消注释，并且指定你想设置的密码。</li>
<li>使用密码连接reids：

<ul>
<li>先登录上去，然后再使用<code>auth password</code>命令进行授权。</li>
<li>在连接的时候，通过<code>-a</code>参数指定密码进行连接。</li>
</ul></li>
</ol>

<h3>12. 其他机器连接redis</h3>

如果想要让其他机器连接本机的redis服务器，那么应该在<code>redis.conf</code>配置文件中，指定bind <strong>本机的ip地址</strong>。这样别的机器就能连接成功。不像是网上说的，要指定对方的ip地址。

<h2>75. Python操作Redis</h2>

<h3>安装</h3>

<pre><code class="shell">pip insatll redis
</code></pre>

<h3>建立连接</h3>

<pre><code class="python">from redis import Redis
xtredis = Redis('192.168.1.200', port='6379', password='123456')
</code></pre>

<h3>对字符串进行操作</h3>

<pre><code class="python">xtredis.set('username', 'ying')
result = xtredis.get('username')
print(result)

xtredis.delete('username')
result = xtredis.get('username')
print(result)

xtredis.set('username', 'ying')
xtredis.set('username', 'yingjoy')
result = xtredis.get('username')
print(result)
</code></pre>

<h3>对列表进行操作</h3>

<pre><code class="python">xtredis.lpush('user', 'user1')
xtredis.lpush('user', 'user2')
xtredis.rpush('user', 'user3')
result = xtredis.lrange('user', 0, -1)
print(result)
</code></pre>

和控制台操作是一样一样的~

<h3>事务（管道）操作</h3>

redis支持事务操作，也就是一些操作只有统一完成，否则失败

<pre><code class="python">pipeline = xtredis.pipeline()
pipeline.set('username', 'ying')
pipeline.set('age', 18)
pipeline.incr('age', 2)
pipeline.execute()

result = xtredis.keys('*')
print(result)
result = xtredis.get('age')
print(result)
----------------------------------
[b'user', b'username', b'age']
b'20'
</code></pre>

<h3>发布与订阅</h3>

模拟异步发送邮件功能

<h4>发送者：</h4>

<pre><code class="python">from redis import Redis

xtredis = Redis('192.168.1.200', port='6379', password='123456')

# 发布3条消息
for i in range(3):
    xtredis.publish('email', '{}xxx@qq.com'.format(i))
</code></pre>

<h4>订阅者：</h4>

<pre><code class="python">from redis import Redis

xtredis = Redis('192.168.1.200', port='6379', password='123456')

# 订阅
ps = xtredis.pubsub()
ps.subscribe('email')
# 监听
while True:
    # ps.listen() 返回一个生成器
    for item in ps.listen():
        if item['type'] == 'message':
            # 获取邮箱
            data = item['data']
            # bytes 转 str
            print(data.decode())
</code></pre>