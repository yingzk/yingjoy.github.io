---
title: Python Web - Flask笔记3
date: 2018-07-20 16:09:46
en_title: Python Web - Flask Note 3
tags: [Python, Python Web, Flask]
permalink: /flask-notes/3
---

{% raw %}

<h2>19. Jinja2模板中的<code>if</code>语句</h2>

<code>if</code>条件判断语句必须放在<code>{% if statement %}</code>中间，并且还必须有结束的标签<code>{% endif %}</code>。和<code>python</code>中的类似，可以使用<code>&gt;，&lt;，&lt;=，&gt;=，==，!=</code>来进行判断，也可以通过<code>and，or，not，()</code>来进行逻辑合并操作。

<pre><code class="jinja2">{% if statement %}
{% elif statement %}
{% else %}
{% endif %}
</code></pre>

<h2>20. Jinja2模板中的<code>for</code>循环语句</h2>

在<code>jinja2</code>中的<code>for</code>循环，跟<code>python</code>中的<code>for</code>循环基本上是一模一样的。也是<code>for...in...</code>的形式。并且也可以遍历所有的序列以及迭代器。但是唯一不同的是，<strong><code>jinja2</code>中的<code>for</code>循环没有<code>break</code>和<code>continue</code>语句。</strong>

<pre><code class="jinja2">{% for statement %}
{% else %}
{% endfor %}
</code></pre>

如果<code>for</code>语句里面不执行的时候，则运行else里面的语句

可以使用以下变量来获取当前遍历的状态：

<table>
<thead>
<tr>
  <th>变量</th>
  <th>描述</th>
</tr>
</thead>
<tbody>
<tr>
  <td>loop.index</td>
  <td>当前迭代的索引（从1开始）</td>
</tr>
<tr>
  <td>loop.index0</td>
  <td>当前迭代的索引（从0开始）</td>
</tr>
<tr>
  <td>loop.reindex</td>
  <td>反向 当前迭代的索引（从1开始）</td>
</tr>
<tr>
  <td>loop.reindex0</td>
  <td>反向 当前迭代的索引（从0开始）</td>
</tr>
<tr>
  <td>loop.first</td>
  <td>是否第一次迭代，返回True或False</td>
</tr>
<tr>
  <td>loop.last</td>
  <td>是否是最后一次迭代，返回True或False</td>
</tr>
<tr>
  <td>loop.length</td>
  <td>序列的长度</td>
</tr>
</tbody>
</table>

<h2>21. 案例 - Jinja2实现九九乘法表</h2>

<pre><code class="jinja2">&lt;table border="1"&gt;
    &lt;tbody&gt;
        {% for i in range(1, 10) %}
            &lt;tr&gt;
                {% for j in range(1, 10) if j &lt; i %}
                &lt;td&gt;{{ j }} * {{ i }} = {{ i*j }}&lt;/td&gt;
                {% endfor %}
            &lt;/tr&gt;
        {% endfor %}
    &lt;/tbody&gt;
&lt;/table&gt;
</code></pre>

<h2>22. 宏的概念和基本使用方法</h2>

类似Python中的函数,可以传递参数，但是不能有返回值，可以将一些经常用到的代码片段放到宏中，然后把一些不固定的值抽取出来当成一个变量。
使用宏的时候，参数可以为默认值。相关示例代码如下：

<ol>
<li>定义宏：
<code>html
{% macro input(name, value='', type='text') %}
&lt;input type="{{ type }}" name="{{ name }}" value="{{
value }}"&gt;
{% endmacro %}</code></li>
<li>使用宏：
<code>html
&lt;p&gt;{{ input('username') }}&lt;/p&gt;
&lt;p&gt;{{ input('password', type='password') }}&lt;/p&gt;</code></li>
</ol>

<h3>导入宏：</h3>

<ol>
<li><code>import "宏文件的路径" as xxx</code>。</li>
<li><code>from '宏文件的路径' import 宏的名字 [as xxx]</code>。</li>
<li>宏文件路径，不要以相对路径去寻找，都要以<code>templates</code>作为绝对路径去找。</li>
<li>如果想要在导入宏的时候，就把当前模版的一些参数传给宏所在的模版，那么就应该在导入的时候使用<code>with context</code>。示例：<code>from 'xxx.html' import input with context</code>。</li>
</ol>

单独使用import时必须使用as给宏文件重命名。

引入templates目录下的文件路径时，均是相对templates的绝对路径。

宏文件无法获取从视图函数中传递的变量，若需要获取这些变量，则导入的时候应该加上<code>with context</code>

<pre><code class="jinja2">from 'macros/macros.html' import input with context
</code></pre>

<h2>23. <code>include</code>标签</h2>

相当于把另外一个模板文件的内容复制粘贴过来。

1.html

<pre><code class="jinja2">&lt;p&gt;1. Hello World!&lt;/p&gt;

{% include '2.html' %}
</code></pre>

2.html

<pre><code class="jinja2">&lt;p&gt;2. Hello World!&lt;/p&gt;
</code></pre>

结果：

<pre><code class="jinja2">1. Hello World!
2. Hello World!
</code></pre>

<ol>
<li>这个标签相当于是直接将指定的模版中的代码复制粘贴到当前位置。</li>
<li><code>include</code>标签，如果想要使用父模版中的变量，直接用就可以了，不需要使用<code>with context</code>。</li>
<li><code>include</code>的路径，也是跟<code>import</code>一样，直接从<code>templates</code>根目录下去找，不要以相对路径去找。</li>
</ol>

<h2>24. <code>set</code>和<code>with</code>语句</h2>

<code>set</code>设置全局变量，include调用的模板中也可以使用

<pre><code class="jinja2">{% set 变量=xxx %}
调用： {{ 变量 }}
</code></pre>

with设置局部变量，变量生存周期仅局限于with代码块

<pre><code class="jinja2">{% with %}
    {% set b= 5 %}
    {{ b }}
{% endwith %}
</code></pre>

超过变量生存区域就无法调用，jinja2最终渲染空白

<h2>25. 加载静态文件</h2>

静态文件： css  js   图片  视频  字体等等。

加载静态文件使用的是<code>url_for</code>函数。然后第一个参数需要为<code>static</code>，第二个参数需要为一个关键字参数<code>filename='路径'</code>。示例：

<pre><code class="jinja2">​```html
{{ url_for("static",filename='xxx') }}
​```
</code></pre>

路径查找，要以当前项目的<code>static</code>目录作为根目录。

如果要更改路径，可以参考之前修改templates文件夹

<h2>26. 模板继承</h2>

<h3>为什么需要模版继承：</h3>

模版继承可以把一些公用的代码单独抽取出来放到一个父模板中。以后子模板直接继承就可以使用了。这样可以重复性的代码，并且以后修改起来也比较方便。

<h3>模版继承语法：</h3>

使用<code>extends</code>语句，来指明继承的父模板。父模板的路径，也是相对于<code>templates</code>文件夹下的绝对路径。示例代码如下：
<code>{% extends "base.html" %}</code>。

<h3>block语法：</h3>

一般在父模版中，定义一些公共的代码。子模板可能要根据具体的需求实现不同的代码。这时候父模版就应该有能力提供一个接口，让父模板来实现。从而实现具体业务需求的功能。
在父模板中：

<pre><code class="html">{% block block的名字 %}
{% endblock %}
</code></pre>

在子模板中：

<pre><code class="html">{% block block的名字 %}
子模板中的代码
{% endblock %}
</code></pre>

<h3>调用父模版代码block中的代码：</h3>

默认情况下，子模板如果实现了父模版定义的block。那么子模板block中的代码就会覆盖掉父模板中的代码。如果想要在子模板中仍然保持父模板中的代码，那么可以使用<code>{{ super() }}</code>来实现。示例如下：
父模板：

<pre><code class="html">{% block body_block %}
        &lt;p style="background: red;"&gt;这是父模板中的代码&lt;/p&gt;
    {% endblock %}
</code></pre>

子模板：

<pre><code class="html">{% block body_block %}
    {{ super() }}
    &lt;p style="background: green;"&gt;我是子模板中的代码&lt;/p&gt;
{% endblock %}
</code></pre>

可以使用<code>{{ super() }}</code>来继承父模板中的代码

<h3>调用另外一个block中的代码：</h3>

如果想要在另外一个模版中使用其他模版中的代码。那么可以通过<code>{{ self.其他block名字() }}</code>就可以了。示例代码如下：

<pre><code class="html">{% block title %}
    课堂首页
{% endblock %}

{% block body_block %}
    {{ self.title() }}
    &lt;p style="background: green;"&gt;我是子模板中的代码&lt;/p&gt;
{% endblock %}
</code></pre>

<h3>其他注意事项：</h3>

<ol>
<li>子模板中的代码，第一行，应该是<code>extends</code>。</li>
<li>子模板中，如果要实现自己的代码，应该放到block中。如果放到其他地方，那么就不会被渲染。</li>
</ol>

{% endraw %}