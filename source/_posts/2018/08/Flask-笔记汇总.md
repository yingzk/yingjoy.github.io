---
title: Flask 笔记汇总
date: 2018-08-10 20:54:39
en_title: Python Web - Flask Note Summary
tags: [Python, Python Web, Flask]
---

Github地址： <a href="https://github.com/yingzk/flask_notes">https://github.com/yingzk/flask_notes</a>

学习Flask的笔记
加上一个BBS论坛项目

博客： https://www.yingjoy.cn
里面有在线笔记~

笔记1(1-4)：  https://www.yingjoy.cn/flask-notes/1 <br>
笔记2(5-18)：  https://www.yingjoy.cn/flask-notes/2 <br>
笔记3(19-26)：  https://www.yingjoy.cn/flask-notes/3 <br>
笔记4(26-28)：  https://www.yingjoy.cn/flask-notes/4 <br>
笔记5(29-37)：  https://www.yingjoy.cn/flask-notes/5 <br>
笔记6(38-49)：  https://www.yingjoy.cn/flask-notes/6 <br>
笔记7(50-57)：  https://www.yingjoy.cn/flask-notes/7 <br>
笔记8(58-67)：  https://www.yingjoy.cn/flask-notes/8 <br>
笔记9(68-75)： (https://www.yingjoy.cn/flask-notes/9 <br>
笔记10(76)： https://www.yingjoy.cn/flask-notes/10 <br>

<h2>1. 课程准备</h2>

环境
安装虚拟环境
安装Flask

<h2>2. 认识Web</h2>

2.1 URL(Uniform Resource Locator) 统一资源定位符
2.2 Web服务器和应用服务器以及Web应用框架
web服务器：
应用服务器：
web应用框架：

<h2>3. Flask入门</h2>

Flask简介
Flask的特点

<h2>4. 第一个Flask程序</h2>

<h2>5. Debug模式</h2>

配置Debug模式的四种方式

<h2>6. 配置文件</h2>

6.1 使用app.config.from_object(config)来加载配置文件
6.2 使用app.config.from_pyfile('config.py')来加载配置文件

<h2>7. URL与视图函数的映射：</h2>

传递参数：
参数的数据类型：
接收用户传递的参数：

<h2>8.url_for()</h2>

url_for的基本使用：
为什么需要url_for：
强烈建议以后在使用url的时候，使用url_for来反转url

<h2>9. 自定义URL转换器</h2>

自定义URL转换器的方式：
to_python的作用：
to_url的作用：

<h2>10. 其它细节问题</h2>

在局域网中让其他电脑访问我的网站：
指定端口号：
url唯一：
GET请求和POST请求：

<h2>11. 重定向笔记：</h2>

flask中重定向：

<h2>12. response：</h2>

视图函数中可以返回哪些值：
实现一个自定义的Response对象：

<h2>13. Jinja2介绍及查找路径</h2>

使用其它目录作为模板文件目录
Jinja2简介
Jinja2的特点
引申： Marko

<h2>14. Jinja2模板传参及技巧</h2>

<h2>15. 模板中使用url_for()</h2>

<h2>16. 过滤器的基本使用</h2>

<h2>17. 自定义过滤器</h2>

<h2>18. 自定义时间过滤器</h2>

<h2>19. Jinja2模板中的if语句</h2>

<h2>20. Jinja2模板中的for循环语句</h2>

<h2>21. 案例 - Jinja2实现九九乘法表</h2>

<h2>22. 宏的概念和基本使用方法</h2>

导入宏：

<h2>23. include标签</h2>

<h2>24. set和with语句</h2>

<h2>25. 加载静态文件</h2>

<h2>26. 模板继承</h2>

为什么需要模版继承：
模版继承语法：
block语法：
调用父模版代码block中的代码：
调用另外一个block中的代码：
其他注意事项：

<h2>26. add_url_rule和approute原理解析</h2>

add_url_rule(rule,endpoint=None,view_func=None)
app.route(rule,**options)装饰器：

<h2>27. 类视图</h2>

标准类视图：
基于请求方法的类视图：
类视图中的装饰器：

<h2>28. 蓝图的基本使用</h2>

28.1 基本语法：
蓝图实现子域名：

<h2>29. MySQL数据库</h2>

安装：
MySQL Workbench

<h2>30. SQLAlchemy连接数据库</h2>

使用SQLAlchemy连接数据库：

<h2>31. ORM（Object Relationship Mapping）框架</h2>

将ORM模型映射到数据库中：

<h2>32. ORM中的增删改查</h2>

用session做数据的增删改查操作

<h2>33. SQLAlchemy中常用的数据类型</h2>

<h2>34. Column常用参数</h2>

<h2>35. query函数的参数</h2>

<h2>36. filter过滤条件</h2>

<h2>37. 外键和四种约束</h2>

<h2>38. ORM关系以及一对多：</h2>

<h2>39. 一对一的关系：</h2>

<h2>40. 多对多的关系：</h2>

<h2>41. ORM层面删除数据注意事项</h2>

<h2>42. relationship中的cascade参数</h2>

<h2>43. 三种排序</h2>

<h2>44. limit、offset及切片(slice)操作</h2>

<h2>45. 数据库的懒加载技术</h2>

<h2>46. 高级查询</h2>

group_by
having
join
subquery：

<h2>47. Flask-SQLAlchemy</h2>

安装：
数据库连接：
创建ORM模型：
将ORM模型映射到数据库：
使用session：
查询数据：

<h2>48. alembic数据库迁移工具</h2>

安装
常用命令：
经典错误：

<h2>49. flask-sqlalchemy中配置alembic</h2>

<h2>50. Flask-Script</h2>

命令的添加方式：

<h2>51. 项目中的循环引用问题</h2>

<h2>52. Flask-Migrate</h2>

安装：
在manage.py中的代码：
flask_migrate常用命令：

<h2>53. Flask-WTF</h2>

做表单验证：
常用的验证器：
自定义验证器：

<h2>54. 使用WTForms渲染模板</h2>

<h2>55. 文件上传</h2>

<h2>56. 使用flask_wtf对上传文件使用表单验证：</h2>

<h2>57. Cookie和Session</h2>

什么是cookie：
flask操作cookie：
session：
flask操作session：

<h2>58. CSRF攻击与防御</h2>

CSRF攻击原理
防御CSRF攻击
AJAX的CSRF保护

<h2>59. Local线程隔离对象</h2>

Thread Local对象

<h2>60. app上下文和request上下文</h2>

为什么上下文需要放在栈中：

<h2>62. 保存全局对象的g对象：</h2>

<h2>63. 常用的钩子函数：</h2>

<h2>64. 信号机制及使用场景</h2>

<h2>65. Flask内置的信号：</h2>

<h2>66. Restful API规范</h2>

协议
数据传输格式
url链接
HTTP请求的方法
状态码

<h2>67. Flask-Restful</h2>

安装：
基本使用：
参数验证：
重命名属性：
默认值：
复杂结构：
Flask-restful注意事项：

<h2>68. Memcached</h2>

<h2>69. Memcached的安装和启动</h2>

<h2>70. Memcached 的参数</h2>

<h2>71. 使用Telnet操作memcached</h2>

<ol>
<li>添加数据</li>
<li>获取数据</li>
<li>删除数据
其它</li>
</ol>

<h2>72. 使用Python操作Memcached</h2>

<ol>
<li>安装python-memcached</li>
<li>建立连接</li>
<li>设置数据</li>
<li>获取数据</li>
<li>删除数据</li>
<li>自增</li>
<li>自减</li>
</ol>

<h2>73. Memcached的安全机制</h2>

<h2>74. Redis</h2>

<ol>
<li>Redis的使用场景</li>
<li>Redis和Memcached的比较</li>
<li>Redis的安装</li>
<li>Redis的操作</li>
<li>操作列表</li>
<li>操作集合(set)</li>
<li>操作哈希(hash)</li>
<li>事务操作</li>
<li>发布/订阅操作</li>
<li>数据持久化</li>
<li>给redis指定密码</li>
<li>其他机器连接redis</li>
</ol>

<h2>75. Python操作Redis</h2>

安装
建立连接
对字符串进行操作
对列表进行操作
事务（管道）操作
发布与订阅

<h2>76. 部署</h2>

在开发机上做准备
在服务器上的准备工作
安装uwsgi
编写uwsgi配置文件：
安装nginx：
收集静态文件：
编写nginx配置文件：
使用supervisor配置： 
nginx+uwsgi+supervisor关系图