---
title: Python Web - Flask笔记2
date: 2018-07-20 12:28:19
en_title: Python Web - Flask Note 2
tags: [Python, Python Web, Flask]
permalink: /flask-notes/2
---

{% raw %}
<ul>
<li>快速定位错误</p></li>
<li><p>方便调试</p></li>
<li><p>保存python文件即重启服务器

<code>app.config['DEBUG'] = True</code> 或者 <code>app.run(debug=True)</code></p></li>
</ul>

<h3>配置Debug模式的四种方式</h3>

<ol>
<li><code>app.run(debug=True)</code></li>
<li><code>app.config['DEBUG'] = True</code></li>
<li><code>app.debug = True</code></li>
<li><code>app.config.update(DEBUG=True)</code></li>
</ol>

<p>还可以写在外部文件<code>config.py</code>中

导入<code>config.py</code>后<code>app.config.from_object(config)</code>

注：dict的<code>update</code>方法可以追加字典内容

如：

<pre><code class="python">a = {'a':1}
b = {'b': 2}
a.update(b)
结果:
a = {'a': 1, 'b': 2}
</code></pre>

调试模式还可以直接在网站上进行调试， 错误行的右侧有一个控制台的图标，点击，然后输入PIN码（程序开始运行时会写出），PIN码会自动记住8小时，存放到这个网站的cookies中。

<h2>6. 配置文件</h2>

用来存放项目的配置文件

<h3>6.1 使用<code>app.config.from_object(config)</code>来加载配置文件</h3>

<pre><code class="python">import config
app.config.from_object(config)
</code></pre>

<h3>6.2 使用<code>app.config.from_pyfile('config.py')</code>来加载配置文件</h3>

不需要导入配置文件，直接写配置文件的路径即可<strong>（记得加后缀）</strong>

<pre><code>app.config.from_pyfile('config.py', silent=False)
</code></pre>

这里也可以不是<code>py</code>文件，<code>txt</code>文件也可以

还有一个<code>silent</code>参数，默认为False，如果加载的配置文件不存在，则直接报错，如果改成True，则忽略，不报错。

<h2>7. URL与视图函数的映射：</h2>

<h3>传递参数：</h3>

传递参数的语法是：<code>/&lt;参数名&gt;/</code>。然后在视图函数中，也要定义同名的参数。

<h3>参数的数据类型：</h3>

<ol>
<li>如果没有指定具体的数据类型，那么默认就是使用<code>string</code>数据类型。</li>
<li><code>int</code>数据类型只能传递<code>int</code>类型。</li>
<li><code>float</code>数据类型只能传递<code>float</code>类型。</li>
<li><code>path</code>数据类型和<code>string</code>有点类似，都是可以接收任意的字符串，但是<code>path</code>可以接收路径，也就是说可以包含斜杠。</li>
<li><code>uuid</code>数据类型只能接收符合<code>uuid</code>的字符串。<code>uuid</code>是一个全宇宙都唯一的字符串，一般可以用来作为表的主键。（长度太长，不方便进行查找）</li>
<li><code>any</code>数据类型可以在一个<code>url</code>中指定多个路径。例如：
<code>python
@app.route('/&lt;any(blog, user):url_path&gt;/&lt;id&gt;/')
def detail(url_path, id):
    if url_path == 'blog':
        return "Blog %s" % id
    if url_path == 'user':
        return "User %s" % id</code></li>
</ol>

<h3>接收用户传递的参数：</h3>

<ol>
<li>第一种：使用path的形式（将参数嵌入到路径中），就是上面讲的。</p></li>
<li><p>第二种：使用查询字符串的方式，就是通过<code>?key=value</code>的形式传递的。

<pre><code class="python">@app.route('/d/')
def d():
    wd = request.args.get('wd')
    return '您通过查询字符串的方式传递的参数是：%s' % wd
</code></pre></li>
<li>如果你的这个页面的想要做<code>SEO</code>优化，就是被搜索引擎搜索到，那么推荐使用第一种形式（path的形式）。如果不在乎搜索引擎优化，那么就可以使用第二种（查询字符串的形式）。</p></li>
</ol>

<h2>8.<code>url_for()</code></h2>

<h3><code>url_for</code>的基本使用：</h3>

<p><code>url_for</code>第一个参数，应该是视图函数的名字的字符串。后面的参数就是传递给<code>url</code>。
如果传递的参数之前在<code>url</code>中已经定义了，那么这个参数就会被当成<code>path</code>的形式给
<code>url</code>。如果这个参数之前没有在<code>url</code>中定义，那么将变成查询字符串的形式放到<code>url</code>中。

<pre><code class="python">@app.route('/post/list/&lt;page&gt;/')
def my_list(page):
    return 'my list'

print(url_for('my_list',page=1,count=2))
# 构建出来的url：/my_list/1/?count=2
</code></pre>

如果一个视图函数上面定义了多个路由，则<code>url_for()</code>返回最后一个

<h3>为什么需要<code>url_for</code>：</h3>

<ol>
<li>将来如果修改了<code>URL</code>，但没有修改该URL对应的函数名，就不用到处去替换URL了。</li>
<li><code>url_for</code>会自动的处理那些特殊的字符，不需要手动去处理。
<code>python
url = url_for('login',next='/')
# 会自动的将/编码，不需要手动去处理。
# url=/login/?next=%2F</code></li>
</ol>

<h3>强烈建议以后在使用url的时候，使用<code>url_for</code>来反转url。</h3>

<h2>9. 自定义URL转换器</h2>

<pre><code class="python">from werkzeug.routing import BaseConverter

class TelConverter(BaseConverter):
    """手机号转换器"""
    regex = r'1[85734]\d{9}'

app.url_map.converters['tel'] = TelConverter

@app.route('/tel/&lt;tel:phone&gt;')
def tel(phone):
    return phone
</code></pre>

<h3>自定义URL转换器的方式：</h3>

<ol>
<li>实现一个类，继承自<code>BaseConverter</code>。</li>
<li>在自定义的类中，重写<code>regex</code>，也就是这个变量的正则表达式。</li>
<li>将自定义的类，映射到<code>app.url_map.converters</code>上。比如：
<code>python
app.url_map.converters['tel'] = TelephoneConverter</code></li>
</ol>

<h3><code>to_python</code>的作用：</h3>

这个方法的返回值，将会传递到view函数中作为参数。

<pre><code class="python">class PostConverter(BaseConverter):
    def to_python(self, value):
        return value.split('+')

app.url_map.converters['list'] = PostConverter

@app.route('/posts/&lt;list:boards&gt;')
def posts(boards):
    return "boards: %s" % boards
</code></pre>

<h3><code>to_url</code>的作用：</h3>

这个方法的返回值，将会在调用url_for函数的时候生成符合要求的URL形式。

<pre><code class="python">class PostConverter(BaseConverter):
    def to_python(self, value):
        return value.split('+')
    def to_url(self, value):
        return "+".join(value)

app.url_map.converters['list'] = PostConverter

@app.route('/')
@app.route('/index/')
def index():
    return url_for('posts', boards=['a', 'b'])

最终返回/posts/a+b
</code></pre>

<h2>10. 其它细节问题</h2>

<h3>在局域网中让其他电脑访问我的网站：</h3>

如果想在同一个局域网下的其他电脑访问自己电脑上的Flask网站，
设置<code>host='0.0.0.0'</code>才能访问得到。

<code>app.run(host='0.0.0.0')</code>

<h3>指定端口号：</h3>

Flask项目，默认使用<code>5000</code>端口。如果想更换端口，那么可以设置<code>port=9000</code>。

<h3>url唯一：</h3>

在定义url的时候，一定要记得在最后加一个斜杠。
1. 如果不加斜杠，那么在浏览器中访问这个url的时候，如果最后加了斜杠，那么就访问不到。这样用户体验不太好。
2. 搜索引擎会将不加斜杠的和加斜杠的视为两个不同的url。而其实加和不加斜杠的都是同一个url，那么就会给搜索引擎造成一个误解。加了斜杠，就不会出现没有斜杠的情况。

<h3><code>GET</code>请求和<code>POST</code>请求：</h3>

在网络请求中有许多请求方式，比如：GET、POST、DELETE、PUT请求等。那么最常用的就是<code>GET</code>和<code>POST</code>请求了。
1. <code>GET</code>请求：只会在服务器上获取资源，不会更改服务器的状态。这种请求方式推荐使用<code>GET</code>请求。
2. <code>POST</code>请求：会给服务器提交一些数据或者文件。一般POST请求是会对服务器的状态产生影响，那么这种请求推荐使用POST请求。
3. 关于参数传递：
    * <code>GET</code>请求：把参数放到<code>url</code>中，通过<code>?xx=xxx</code>的形式传递的。因为会把参数放到url中，所以如果视力好，一眼就能看到你传递给服务器的参数。这样不太安全。
    * <code>POST</code>请求：把参数放到<code>Form Data</code>中。会把参数放到<code>Form Data</code>中，避免了被偷瞄的风险，但是如果别人想要偷看你的密码，那么其实可以通过抓包的形式。因为POST请求可以提交一些数据给服务器，比如可以发送文件，那么这就增加了很大的风险。所以POST请求，对于那些有经验的黑客来讲，其实是更不安全的。
4. 在<code>Flask</code>中，<code>route</code>方法，默认将只能使用<code>GET</code>的方式请求这个url，如果想要设置自己的请求方式，那么应该传递一个<code>methods</code>参数。

<h2>11. 重定向笔记：</h2>

重定向分为永久性重定向和暂时性重定向，在页面上体现的操作就是浏览器会从一个页面自动跳转到另外一个页面。比如用户访问了一个需要权限的页面，但是该用户当前并没有登录，因此我们应该给他重定向到登录页面。

<ul>
<li>永久性重定向：<code>http</code>的状态码是<code>301</code>，多用于旧网址被废弃了要转到一个新的网址确保用户的访问，最经典的就是京东网站，你输入<code>www.jingdong.com</code>的时候，会被重定向到<code>www.jd.com</code>，因为<code>jingdong.com</code>这个网址已经被废弃了，被改成<code>jd.com</code>，所以这种情况下应该用永久重定向。</p></li>
<li><p>暂时性重定向：<code>http</code>的状态码是<code>302</code>，表示页面的暂时性跳转。比如访问一个需要权限的网址，如果当前用户没有登录，应该重定向到登录页面，这种情况下，应该用暂时性重定向。</p></li>
</ul>

<h3>flask中重定向：</h3>

<p><code>flask</code>中有一个函数叫做<code>redirect</code>，可以重定向到指定的页面。示例代码如下：

<pre><code class="python">from flask import Flask,request,redirect,url_for

app = Flask(__name__)

@app.route('/login/')
def login():
    return '这是登录页面'

@app.route('/profile/')
def profile():
    if request.args.get('name'):
        return '个人中心页面'
    else:
        # redirect 重定向
        return redirect(url_for('login'))
</code></pre>

<h2>12. response：</h2>

<h3>视图函数中可以返回哪些值：</h3>

<ol>
<li>可以返回字符串：返回的字符串其实底层将这个字符串包装成了一个<code>Response</code>对象。</li>
<li>可以返回元组：元组的形式是(响应体,状态码,头部信息)，也不一定三个都要写，写两个也是可以的。返回的元组，其实在底层也是包装成了一个<code>Response</code>对象。</li>
<li>可以返回<code>Response</code>及其子类。(这种情况你可以直接设置cookie)</li>
</ol>

<pre><code class="python">from flask import Response
@app.route('/')
def index():
    response = Response("Index")
    response.set_cookie('a', 1)
    return response
</code></pre>

<h3>实现一个自定义的<code>Response</code>对象：</h3>

<ol>
<li>继承自<code>Response</code>类。</li>
<li>实现方法<code>force_type(cls,rv,environ=None)</code>。</li>
<li>指定<code>app.response_class</code>为你自定义的<code>Response</code>对象。</li>
<li>如果视图函数返回的数据，不是字符串，也不是元组，也不是Response对象，那么就会将返回值传给<code>force_type</code>，然后再将<code>force_type</code>的返回值返回给前端。</li>
</ol>

<code>jsonify</code> 可以直接将<code>dict</code>转换为<code>json</code>格式，并且将其包装成一个Response对象

<h2>13. Jinja2介绍及查找路径</h2>

<code>render_template()</code>进行模板渲染， 默认从项目根目录下的<code>templates</code>文件夹下寻找模板

<h3>使用其它目录作为模板文件目录</h3>

可以查看<code>Flask(app = Flask(__name__))</code>的代码

<pre><code class="python">    def __init__(
        self,
        import_name,
        static_url_path=None,
        static_folder='static',
        static_host=None,
        host_matching=False,
        subdomain_matching=False,
        template_folder='templates',
        instance_path=None,
        instance_relative_config=False,
        root_path=None
    ):
</code></pre>

指定其它目录

<pre><code>app = Flask(__name__, template_folder='my_templates')
</code></pre>

<h3>Jinja2简介</h3>

Jinja是日本寺庙的意思，寺庙的英文是temple，和英文的template发音类似。Jinja2是默认的仿Django模板的一个模板引擎，由Flask作者开发。

<h3>Jinja2的特点</h3>

<ul>
<li>让开发前后端分离</li>
<li>减少Flask代码的耦合性，页面逻辑放在模板中，业务逻辑放在视图函数中，有利于代码的维护</li>
<li>提供了控制语句，继承等高级功能，减少开发的复杂度</li>
</ul>

<h3>引申： Marko</h3>

Marko是一个知名的模板，他从Django和Jinja2等模板中借鉴了很多语法，它的特点：

<ul>
<li>性能和Jinja2相近</li>
<li>大型网站在用，如Reddit和豆瓣</li>
<li>知名的Web框架支持，Pylons和Pyramid，这两个框架的内置模板就是Marko</li>
<li>支持在模板文件中写近乎原生的Python语法代码，对Pythoner比较友好，开发效率高</li>
<li>自带完整的缓存系统，也提供了非常好的拓展接口，很容易切换成其他的缓存系统。</li>
</ul>

<h2>14. Jinja2模板传参及技巧</h2>

<pre><code class="python">@app.route('/index/')
def index():
    dic = {
        'name':'ying',
        'age': 18
    }
    return render_template('index.html', dic=dic)
    # 或者return render_template('index.html', **dic)
    # 用了**传，则渲染时不需要加dic.name 直接使用name即可
</code></pre>

<h2>15. 模板中使用<code>url_for()</code></h2>

<pre><code class="html">&lt;a href="{% url_for('login', ref='/') %}"&gt;Login&lt;/a&gt;
</code></pre>

<pre><code class="python">@app.route('/')
@app.route('/index/')
def index():
    dic = {
        'name':'ying',
        'age': 18
    }
    return render_template('index.html', dic=dic)

@app.route('/login/')
def login():
    return 'login'
</code></pre>

<code>url_for('视图函数名称')</code>

<pre><code>{{ 用于存放变量 }}
{% 用于执行函数和逻辑代码 %}
{# 注释 #}
</code></pre>

<h2>16. 过滤器的基本使用</h2>

过滤器是通过管道符号（|）进行使用的，例如：<code>{{ name|length }}</code>，将返回name的长度。过滤器相当于是一个函数，把当前的变量传入过滤器中，然后根据过滤器自己的功能，在返回相应的值，之后在将结果渲染到页面中。Jinja2内置了很多过滤器

<pre><code class="json">FILTERS = {
    'abs':                  abs,
    'attr':                 do_attr,
    'batch':                do_batch,
    'capitalize':           do_capitalize,
    'center':               do_center,
    'count':                len,
    'd':                    do_default,
    'default':              do_default,
    'dictsort':             do_dictsort,
    'e':                    escape,
    'escape':               escape,
    'filesizeformat':       do_filesizeformat,
    'first':                do_first,
    'float':                do_float,
    'forceescape':          do_forceescape,
    'format':               do_format,
    'groupby':              do_groupby,
    'indent':               do_indent,
    'int':                  do_int,
    'join':                 do_join,
    'last':                 do_last,
    'length':               len,
    'list':                 do_list,
    'lower':                do_lower,
    'map':                  do_map,
    'pprint':               do_pprint,
    'random':               do_random,
    'reject':               do_reject,
    'rejectattr':           do_rejectattr,
    'replace':              do_replace,
    'reverse':              do_reverse,
    'round':                do_round,
    'safe':                 do_mark_safe,
    'select':               do_select,
    'selectattr':           do_selectattr,
    'slice':                do_slice,
    'sort':                 do_sort,
    'string':               soft_unicode,
    'striptags':            do_striptags,
    'sum':                  do_sum,
    'title':                do_title,
    'trim':                 do_trim,
    'truncate':             do_truncate,
    'upper':                do_upper,
    'urlencode':            do_urlencode,
    'urlize':               do_urlize,
    'wordcount':            do_wordcount,
    'wordwrap':             do_wordwrap,
    'xmlattr':              do_xmlattr,
    'tojson':               do_tojson,
}
</code></pre>

例如

<pre><code class="python">render_template("index.html", position=-9)
</code></pre>

<pre><code class="jinja2">{{ position | abs }}
{{ sign | default('此人很懒...', boolean=True) }}
</code></pre>

这里添加<code>boolean=True</code>后，即使传进去的参数为None或者空字符串、列表等，也会显示默认值，否则显示None

使用下面的方法也可以替代<code>{{ default ,boolean=True }}</code>

<pre><code class="jinja2">{{ sign or "此人很懒..." }}
</code></pre>

<h4>转义过滤器 escape</h4>

Jinja2模板会自动转义，把需要渲染的变量中的html符号进行转义

<pre><code class="python">render_template("index.html", sign='&lt;script&gt;alert("hello")&lt;/script&gt;')
</code></pre>

<pre><code class="jinja2">结果为： &lt;script&gt;alert("hello")&lt;/script&gt;
</code></pre>

使用下面语句可以关闭自动转义

<pre><code class="jinja2">{% autoescape off %}
    {{ sign or '此人很懒...' }}
{% endautoescape %}
</code></pre>

也可以使用<code>safe</code>过滤器取消自动转义

<pre><code class="jinja2">{{ sign | safe }}
</code></pre>

使用多个过滤器直接使用<code>|</code>隔开

<pre><code class="jinja2">{{ ['hello', '2'] | first | length }}
</code></pre>

<h4>first过滤器</h4>

获取到<code>list</code>第一条数据

<h4>last过滤器</h4>

获取到<code>list</code>最后一条数据

<h4>format过滤器</h4>

格式化字符串

<pre><code class="jinja2">{{ "%s, %s" | format('hello', 'world') }}
</code></pre>

<h4>join过滤器</h4>

和Python一样，指定分隔符组装<code>list</code>

<pre><code class="jinja2">{{ ['1', '2'] | join("+") }}
</code></pre>

<h4>int    float    string    lower   upper过滤器</h4>

转换整形，浮点型，小写，大写

<h4>replace过滤器</h4>

替换字符串

<pre><code class="jinja2">{{ "abc" | replace('ab', 'a') }}
</code></pre>

<h4>wordcount过滤器</h4>

计算一个长字符串单词的个数

<pre><code class="jinja2">{{ "This is a very meaningful thing." | wordcount }}    结果是: 6
</code></pre>

<h4>truncate过滤器</h4>

截取指定长度的字符串

<pre><code class="jinja2">{{ "This is a very meaningful thing." | truncate(10, killwords=True) }}
</code></pre>

这里如果没有开启killwords，则默认直接到下一个单词接下来的空格的长度才有效。并且，结尾的三个点也要算进去

上面的例子：

截取This：<code>{{ "This is a very meaningful thing." | truncate(7) }}</code>后面还存在3个点

截取is: <code>{{ "This is a very meaningful thing." | truncate(11) }}</code>

截取a: <code>{{ "This is a very meaningful thing." | truncate(13) }}</code>

<h4>striptags过滤器</h4>

删除字符串中所有的<code>HTML</code>标签，如果发现多个空格，则替换为1个

<pre><code class="jinja2">{{ "&lt;p&gt;Good       Job!&lt;/p&gt;" | striptags }}
</code></pre>

结果为: <code>Good Job!</code>中间只有一个空格

<h4>trim过滤器</h4>

去除字符串前面和后面的空白字符，如果发现多个空格，则替换为1个

<pre><code class="jinja2">{{ "    Good \t&lt;br&gt;   Job!\t&lt;br&gt;" | striptags }}
</code></pre>

这里返回: <code>Good Job!</code>

<h2>17. 自定义过滤器</h2>

定义过滤器就是定义函数

例如：需求： 删除字符串中所有的hello

<pre><code class="python">@app.template_filter('my_cut')
def cut(value):
    value = value.replace('hello', '')
    return value
</code></pre>

<pre><code class="jinja2">{{ "hello my hello lady" | my_cut }}
</code></pre>

设置模板自动重新载入：

<pre><code class="python">app.config['TEMPLATES_AUTO_RELOAD'] = True
</code></pre>

<h2>18. 自定义时间过滤器</h2>

类似<code>flask-momment</code>的功能

<pre><code class="python">@app.template_filter('handle_time')
def handle_time(time):
    """
    1. 距离现在的时间
    2. 如果时间小于1分钟显示刚刚
    3. 如果大于1分钟，小于1小时，显示xx分钟前
    4. 如果大于1小时，小于24小时，显示xx小时前
    5. 如果大于24小时，小于30天，显示xx天之前
    6. 否则显示具体时间
    """
    if isinstance(time, datetime):
        now = datetime.now()
        # 获取两个时间之间相差的秒数
        timestamps = (now - time).total_seconds()
        if timestamps &lt; 60:
            return "刚刚"
        elif timestamps &gt;= 60 and timestamps &lt; 60*60:
            minutes = timestamps / 60
            return "%s分钟前" % int(minutes)
        elif timestamps &gt;= 60*60 and timestamps &lt; 60*60*24:
            hours = timestamps / (60*60)
            return '%s小时前' % int(hours)
        elif timestamps &gt;= 60*60*24 and timestamps &lt; 60*60*24*30:
            days = timestamps / (60*60*24)
            return "%s天以前" % days
        else:
            # return "%s年%s月%s日" % (time.year, time.month, time.day)
            return time.strftime("%Y-%m-%d %H:%M")
    else:
        return time
</code></pre>

<pre><code class="jinja2">{{ addtime | handle_time }}
</code></pre>

{% endraw %}