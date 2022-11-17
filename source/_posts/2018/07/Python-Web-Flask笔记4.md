---
title: Python Web - Flask笔记4
date: 2018-07-20 18:01:32
en_title: Python Web - Flask Note 4
tags: [Python, Python Web, Flask]
permalink: /flask-notes/4
---

{% raw %}
<h2>26. <code>add_url_rule</code>和<code>approute</code>原理解析</h2>

<h3><code>add_url_rule(rule,endpoint=None,view_func=None)</code></h3>

这个方法用来添加url与视图函数的映射。如果没有填写<code>endpoint</code>，那么默认会使用<code>view_func</code>的名字作为<code>endpoint</code>。以后在使用<code>url_for</code>的时候，<strong>endpoint可以不写，如果不写，则默认使用视图函数的名字</strong>。

<pre><code>def my_list():
    return 'list'

app.add_url_rule('/list/', endpoint='xxx', view_func=my_list)
</code></pre>

此处的endpoint用于<code>url_for()</code>，当添加自定义规则后，必须使用endpoint定义的名称才可以访问。

<pre><code>@app.route('/', endpoint='index')
def index():
    return redirect(url_for('xxx'))
</code></pre>

否则报错：<code>werkzeug.routing.BuildError</code>

<h3><code>app.route(rule,**options)</code>装饰器：</h3>

这个装饰器底层，其实也是使用<code>add_url_rule</code>来实现url与视图函数映射的。

<h2>27. 类视图</h2>

<h3>标准类视图：</h3>

<ol>
<li>标准类视图，必须继承自<code>flask.views.View</code>.</li>
<li>必须实现<code>dipatch_request</code>方法，以后请求过来后，都会执行这个方法。这个方法的返回值就相当于是之前的函数视图一样。也必须返回<code>Response</code>或者子类的对象，或者是字符串，或者是元组。</li>
<li>必须通过<code>app.add_url_rule(rule,endpoint,view_func)</code>来做url与视图的映射。<code>view_func</code>这个参数，需要使用类视图下的<code>as_view</code>类方法类转换：<code>ListView.as_view('list')</code>。</li>
<li>如果指定了<code>endpoint</code>，那么在使用<code>url_for</code>反转的时候就必须使用<code>endpoint</code>指定的那个值。如果没有指定<code>endpoint</code>，那么就可以使用<code>as_view(视图名字)</code>中指定的视图名字来作为反转。</li>
<li>类视图有以下好处：可以继承，把一些共性的东西抽取出来放到父视图中，子视图直接拿来用就可以了。但是也不是说所有的视图都要使用类视图，这个要根据情况而定。</li>
</ol>

<pre><code>class ListView(View):
    def dispatch_request(self):
        return 'list view'

# ListView.as_view('list') 把类转为函数，并添加函数名
app.add_url_rule('/list/', endpoint='list', view_func=ListView.as_view('list'))

@app.route('/')
def index():
    return redirect(url_for('list'))
</code></pre>

<h3>基于请求方法的类视图：</h3>

<ol>
<li>基于方法的类视图，是根据请求的<code>method</code>来执行不同的方法的。如果用户是发送的<code>get</code>请求，那么将会执行这个类的<code>get</code>方法。如果用户发送的是<code>post</code>请求，那么将会执行这个类的<code>post</code>方法。其他的method类似，比如<code>delete</code>、<code>put</code>。</li>
<li>这种方式，可以让代码更加简洁。所有和<code>get</code>请求相关的代码都放在<code>get</code>方法中，所有和<code>post</code>请求相关的代码都放在<code>post</code>方法中。就不需要跟之前的函数一样，通过<code>request.method == 'GET'</code>。</li>
</ol>

<pre><code>class LoginView(MethodView):
    def get(self):
        return render_template('login.html')

    def post(self):
        username = request.form.get('username')
        pwd = request.form.get('pwd')
        return "%s, %s" % (username, pwd)

app.add_url_rule('/login/', view_func=LoginView.as_view('login'))
</code></pre>

<h3>类视图中的装饰器：</h3>

<ol>
<li>如果使用的是函数视图，那么自己定义的装饰器必须放在<code>app.route</code>下面。否则这个装饰器就起不到任何作用。</li>
<li>类视图的装饰器，需要重写类视图的一个类属性<code>decorators</code>，这个类属性是一个列表或者元组都可以，里面装的就是所有的装饰器。</li>
</ol>

<pre><code>class ListView(View):
    decorators = [xxx, xxx]
    def dispatch_request(self):
        return 'list view'
app.add_url_rule('/list/', view_func=ListView.as_view('list'))
</code></pre>

<ol>
<li>蓝图的基本使用</li>
</ol>

蓝图的作用就是让我们的Flask项目更加模块化，结构更加清晰。可以将相同模块的视图函数放在同一个蓝图下，同一个文件中，方便管理。

<h3>28.1 基本语法：</h3>

在蓝图文件中导入Blueprint：

<pre><code>from flask import Blueprint
user_bp = Blueprint('user', __name__, url_prefix='/user')
</code></pre>

<code>url_predix</code>后面不要加<code>/</code>如果加了，之后的视图路由名称之前不要加<code>/</code>

在主app文件中注册蓝图：

<pre><code>from blueprints.user import user_bp
app.regist_blueprint(user_bp)
</code></pre>

如果想要某个蓝图下的所有url都有一个url前缀，那么可以在定义蓝图的时候，指定url_prefix参数：

<pre><code>user_bp = Blueprint('user',name,url_prefix='/user/')
</code></pre>

在定义url_prefix的时候，要注意后面的斜杠，如果给了，那么以后在定义url与视图函数的时候，就不要再在url前面加斜杠了。

之后访问域名： <code>127.0.0.1:5000/user/xxx</code>

<ol>
<li>蓝图模版文件的查找：
如果项目中的templates文件夹中有相应的模版文件，就直接使用了。
如果项目中的templates文件夹中没有相应的模版文件，那么就到在定义蓝图的时候指定的路径中寻找。并且蓝图中指定的路径可以为相对路径，相对的是当前这个蓝图文件所在的目录。比如：

<pre><code>news_bp = Blueprint('news',__name__,url_prefix='/news',template_folder='bp_templates')
</code></pre>

<strong>这里模板文件的相对路径是相对蓝图文件的路径，这里蓝图文件路径在blueprints中所以，最终该蓝图模板文件在项目目录下的blueprints目录下的bp_templates中</strong>

<p>因为这个蓝图文件是在blueprints/news.py，那么就会到blueprints这个文件夹下的bp_templates文件夹中寻找模版文件。</p></li>
<li><p>蓝图中静态文件的查找规则：
在模版文件中，加载静态文件，如果使用url_for('static')，那么就只会在app指定的静态文件夹目录下查找静态文件。
如果在加载静态文件的时候，指定的蓝图的名字，比如<code>news.static</code>，那么就会到这个蓝图指定的static_folder下查找静态文件。</p></li>
<li><p>url_for反转蓝图中的视图函数为url：
如果使用蓝图，那么以后想要反转蓝图中的视图函数为url，那么就应该在使用url_for的时候指定这个蓝图。比如<code>news.news_list</code>。否则就找不到这个endpoint。在模版中的url_for同样也是要满足这个条件，就是指定蓝图的名字。
即使在同一个蓝图中反转视图函数，也要指定蓝图的名字。</p></li>
</ol>

<h3>蓝图实现子域名：</h3>

<ol>
<li>使用蓝图技术。</li>
<li>在创建蓝图对象的时候，需要传递一个<code>subdomain</code>参数，来指定这个子域名的前缀。例如：<code>cms_bp = Blueprint('cms',__name__,subdomain='cms')</code>。</li>
<li><strong>必需要在主app文件中，需要配置app.config的SERVER_NAME参数。</strong>例如：
<code>app.config['SERVER_NAME'] = 'test.com:5000'</code>

<ul>
<li>ip地址不能有子域名。</li>
<li>localhost也不能有子域名。</li>
</ul></li>
<li>在<code>C:\Windows\System32\drivers\etc</code>下，找到hosts文件，然后添加域名与本机的映射。例如：
<code>127.0.0.1   test.com
127.0.0.1   test.jd.com</code>
域名和子域名都需要做映射。</li>
</ol>
{% endraw %}