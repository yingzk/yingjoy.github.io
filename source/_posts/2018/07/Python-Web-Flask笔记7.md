---
title: Python Web - Flask笔记7
date: 2018-07-23 21:28:04
en_title: Python Web - Flask Note 7
tags: [Python, Python Web, Flask]
permalink: /flask-notes/7
---

<h2>50. Flask-Script</h2>

Flask-Script的作用是可以通过命令行的形式来操作Flask。例如通过命令跑一个开发版本的服务器、设置数据库，定时任务等。要使用Flask-Script，可以通过<code>pip install flask-script</code>安装。

<h3>命令的添加方式：</h3>

<ol>
<li>使用<code>manage.commad</code>：这个方法是用来添加那些不需要传递参数的命令。示例代码如下：

<pre><code class="python">manager = Manager(app)
manager.add_command("db",db_manager)

@manager.command
def greet():
    print('你好')
</code></pre></li>
<li><code>使用manage.option</code>：这个方法是用来添加那些需要传递参数的命令。有几个参数就需要写几个<code>option</code>。示例代码如下：

<pre><code class="python">@manager.option("-u","--username",dest="username")
@manager.option("-e","--email",dest="email")
def add_user(username,email):
    user = BackendUser(username=username,email=email)
    db.session.add(user)
    db.session.commit()
</code></pre></li>
<li>如果有一些命令是针对某个功能的。比如有一堆命令是针对ORM与表映射的，那么可以将这些命令单独放在一个文件中方便管理。也是使用<code>Manager</code>的对象来添加。然后到主manage文件中，通过<code>manager.add_command</code>来添加。
实例，flasks-script初始化数据库和创建管理员用户</p></li>
</ol>

<pre><code class="python">from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = SQLAlchemy(app)

class Admin(db.Model):
    __tablename__ = 'admin'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    account = db.Column(db.String(50), nullable=False)
    pwd = db.Column(db.String(50), nullable=False)
</code></pre>

<p>manage.py

<pre><code class="python">from flask_script import Manager
from flask_script_demp import app, db, Admin

manger = Manager(app)

@manger.command
def init_db():
    db.drop_all()
    db.create_all()
    print('初始化数据库成功...')


@manger.option('-a', '--account', dest='account')
@manger.option('-p', '--pwd', dest='pwd')
def add_admin(account, pwd):
    admin = Admin(account=account, pwd=pwd)
    db.session.add(admin)
    db.session.commit()

if __name__ == '__main__':
    manger.run()
</code></pre>

<h2>51. 项目中的循环引用问题</h2>

<ul>
<li>注：项目中出现了循环引用（两个文件相互引用）会报错，如在<code>models.py</code>中引用<code>db</code>时，<code>app.py</code>又需要从<code>models.py</code>中引入模型，导致循环引用</li>
</ul>

解决方法： 引入第三个文件<code>exts.py</code>将<code>db</code>放入<code>exts.py</code>中

文件：app.py

<pre><code class="python">from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from models import Admin

app = Flask(__name__)
app.config.from_pyfile('config.py')
db = SQLAlchemy(app)

@app.route('/')
def index():
    return 'hello world'

@app.route('/admin/')
def admin():
    pass

if __name__ == '__main__':
    app.run()
</code></pre>

文件：models.py

<pre><code class="python">from flask_migrate_demo import db

class Admin(db.Model):
    __tablename__ = 'admin'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    account = db.Column(db.String(50), nullable=False)
    pwd = db.Column(db.String(50), nullable=False)
</code></pre>

报错：

<pre><code>ImportError: cannot import name 'Admin'
</code></pre>

所以，引入第三方文件<code>exts.py</code>

<pre><code>from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
</code></pre>

但这里没有初始化app，我们在<code>app.py</code>文件中需要进行绑定db的app

<pre><code class="python">from exts import db
db.init_app(app)
</code></pre>

然后就可以正常使用了。

<h2>52. Flask-Migrate</h2>

flask把<code>alembic</code>进行了封装

在实际的开发环境中，经常会发生数据库修改的行为。一般我们修改数据库不会直接手动的去修改，而是去修改ORM对应的模型，然后再把模型映射到数据库中。这时候如果有一个工具能专门做这种事情，就显得非常有用了，而flask-migrate就是做这个事情的。flask-migrate是基于Alembic进行的一个封装，并集成到Flask中，而所有的迁移操作其实都是Alembic做的，他能跟踪模型的变化，并将变化映射到数据库中。

<h3>安装：</h3>

<pre><code class="shell"><br /></code></pre>

<h3>在manage.py中的代码：</h3>

<pre><code class="python">from flask_script import Manager
from zhiliao import app
from exts import db
from flask_migrate import Migrate,MigrateCommand

manager = Manager(app)

# 用来绑定app和db到flask_migrate的
Migrate(app,db)
# 添加Migrate的所有子命令到db下
manager.add_command("db",MigrateCommand)


if __name__ == '__main__':
    manager.run()
</code></pre>

<h3>flask_migrate常用命令：</h3>

<ol>
<li>初始化一个环境：python manage.py db init</li>
<li>自动检测模型，生成迁移脚本：python manage.py db migrate</li>
<li>将迁移脚本映射到数据库中：python manage.py db upgrade</li>
<li>更多命令：python manage.py db --help</li>
</ol>

<h4><strong>注：</strong>在manage.py中需要导入模型，否则db migrate不会创建映射文件，如果在manage.py引入的其它文件中引入了模型，那么在manage.py文件中可以不用引入</h4>

<h4>这里还是推荐在<code>manage.py</code>文件中进行引入</h4>

manage.py

<pre><code class="python">from flask_script import Manager
from flask_migrate_demo import app
from exts import db
from flask_migrate import Migrate, MigrateCommand
from models import Admin

manager = Manager(app)
Migrate(app, db)
manager.add_command("db", MigrateCommand)

if __name__ == '__main__':
    manager.run()
</code></pre>

app.py

<pre><code class="python">from flask import Flask
from exts import db

app = Flask(__name__)
app.config.from_pyfile('config.py')
db.init_app(app)

@app.route('/')
def index():
    return 'hello world'

if __name__ == '__main__':
    app.run()
</code></pre>

models.py

<pre><code class="python">from exts import db

class Admin(db.Model):
    __tablename__ = 'admin'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    account = db.Column(db.String(50), nullable=False)
    pwd = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(100))
</code></pre>

exts.py

<pre><code class="python">from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
</code></pre>

<h2>53. Flask-WTF</h2>

Flask-WTF时<code>WTForms</code>操作的一个第三方库。WTForms表单的两个主要功能是验证用户提交数据的合法性以及渲染模板。还有一些其他的功能，CSRF保护，文件上传等。安装Flask-WTF时会默认安装WTForms，使用以下命令安装

<pre><code class="shell">pip install flask-wtf
</code></pre>

这个库一般有两个作用。第一个就是做表单验证，把用户提交上来的数据进行验证是否合法。第二个就是做模版渲染。

<h3>做表单验证：</h3>

<ol>
<li>自定义一个表单类，继承自wtforms.Form类。</li>
<li>定义好需要验证的字段，字段的名字必须和模版中那些需要验证的input标签的name属性值保持一致。</li>
<li>在需要验证的字段上，需要指定好具体的数据类型。</li>
<li>在相关的字段上，指定验证器。</li>
<li>以后在视图中，就只需要使用这个表单类的对象，并且把需要验证的数据，也就是request.form传给这个表单类，以后调用form.validate()方法，如果返回True，那么代表用户输入的数据都是合法的，否则代表用户输入的数据是有问题的。如果验证失败了，那么可以通过form.errors来获取具体的错误信息。
示例代码如下：
ReistForm类的代码：</li>
</ol>

<pre><code class="python">class RegistForm(Form):
    username = StringField(validators=[Length(min=3,max=10,message='用户名长度必须在3到10位之间')])
    password = StringField(validators=[Length(min=6,max=10)])
    password_repeat = StringField(validators=[Length(min=6,max=10),EqualTo("password")])
</code></pre>

视图函数中的代码：

<pre><code class="python">form = RegistForm(request.form)
if form.validate():
    return "success"
else:
    print(form.errors)
    return "fail"
</code></pre>

<h3>常用的验证器：</h3>

数据发送过来，经过表单验证，因此需要验证器来进行验证，以下对一些常用的内置验证器进行讲解：
1. Email：验证上传的数据是否为邮箱。
2. EqualTo：验证上传的数据是否和另外一个字段相等，常用的就是密码和确认密码两个字段是否相等。
3. InputRequir：原始数据的需要验证。如果不是特殊情况，应该使用InputRequired。
4. Length：长度限制，有min和max两个值进行限制。
5. NumberRange：数字的区间，有min和max两个值限制，如果处在这两个数字之间则满足。
6. Regexp：自定义正则表达式。
7. URL：必须要是URL的形式。
8. UUID：验证UUID。

<h3>自定义验证器：</h3>

如果想要对表单中的某个字段进行更细化的验证，那么可以针对这个字段进行单独的验证。步骤如下：
1. 定义一个方法，方法的名字规则是：<code>validate_字段名(self,filed)</code>。<strong>(此方法不需要手动调用)</strong>
2. 在方法中，使用<code>field.data</code>可以获取到这个字段的具体的值。
3. 如果数据满足条件，那么可以什么都不做。如果验证失败，那么应该抛出一个<code>wtforms.validators.ValidationError</code>的异常，并且把验证失败的信息传到这个异常类中。
  示例代码：

<pre><code class="python">captcha = StringField(validators=[Length(4,4)])
    # 1234
    def validate_captcha(self,field):
        if field.data != '1234':
            raise ValidationError('验证码错误！')
</code></pre>

<h2>54. 使用WTForms渲染模板</h2>

在request-method为get时，不需要进行表单验证，直接传入

<pre><code class="python">form = LoginForm()
return render_template("login.html", form=form)
</code></pre>

使用jinja2语法渲染模板

<pre><code class="jinja2">&lt;style&gt;
.username-input {
    background: red;
}
&lt;/style&gt;

{{ form.username.label }}
{{ form.username(class='username-input') }}
</code></pre>

label可以在定义验证表单的时候设置

<pre><code class="python">username = StringField(
        label="用户名：",
        validators=[Length(min=3, max=18, message='用户名长度不够')],
        render_kw={
            'placeholder':'请输入用户名'
        }
    )
</code></pre>

如果没有自定义label，英文，默认使用首字母大写，其他字母小写。

<h2>55. 文件上传</h2>

<ol>
<li>在模版中，form表单中，需要指定<code>encotype='multipart/form-data'</code>才能上传文件。</li>
<li>在后台如果想要获取上传的文件，那么应该使用<code>request.files.get('avatar')</code>来获取。</li>
<li>保存文件之前，先要使用<code>werkzeug.utils.secure_filename</code>来对上传上来的文件名进行一个过滤。这样才能保证不会有安全问题。 </li>
<li>获取到上传上来的文件后，使用<code>avatar.save(路径)</code>方法来保存文件。、</li>
<li>从服务器上读取文件，应该定义一个url与视图函数，来获取指定的文件。在这个视图函数中，使用<code>send_from_directory(文件的目录,文件名)</code>来获取。
示例代码如下：</li>
</ol>

<pre><code class="python">@app.route('/uploads/', methods=['GET', 'POST'])
def upload():
    if request.method == 'GET':
        form = UploadForm()
        return render_template('upload.html', form=form)
    else:
        if not os.path.exists(UPLOAD_DIR):
            os.makedirs(UPLOAD_DIR)

        avatar = request.files.get('avatar')
        filename = secure_filename(avatar.filename)
        avatar.save(os.path.join(UPLOAD_DIR, filename))
        return redirect(url_for('images', filename=filename))

@app.route('/images/&lt;filename&gt;')
def images(filename):
    return send_from_directory(UPLOAD_DIR, filename)
</code></pre>

<h2>56. 使用flask_wtf对上传文件使用表单验证：</h2>

<ol>
<li>定义表单的时候，对文件的字段，需要采用<code>FileField</code>这个类型。</li>
<li>验证器应该从<code>flask_wtf.file</code>中导入。<code>flask_wtf.file.FileRequired</code>是用来验证文件上传是否为空。<code>flask_wtf.file.FileAllowed</code>用来验证上传的文件的后缀名。</li>
<li>在视图文件中，使用<code>from werkzeug.datastructures import CombinedMultiDict</code>来把<code>request.form</code>与<code>request.files</code>来进行合并。再传给表单来验证。
示例代码如下：</li>
</ol>

<pre><code class="python">from werkzeug.datastructures import CombinedMultiDict
form = UploadForm(CombinedMultiDict([request.form,request.files]))
</code></pre>

<h2>57. Cookie和Session</h2>

<h3>什么是cookie：</h3>

在网站中，http请求是无状态的。也就是说即使第一次和服务器连接后并且登录成功后，第二次请求服务器依然不能知道当前请求是哪个用户。cookie的出现就是为了解决这个问题，第一次登录后服务器返回一些数据（cookie）给浏览器，然后浏览器保存在本地，当该用户发送第二次请求的时候，就会自动的把上次请求存储的cookie数据自动的携带给服务器，服务器通过浏览器携带的数据就能判断当前用户是哪个了。cookie存储的数据量有限，不同的浏览器有不同的存储大小，但一般不超过4KB。因此使用cookie只能存储一些小量的数据。
1. cookie有有效期：服务器可以设置cookie的有效期，以后浏览器会自动的清除过期的cookie。
2. cookie有域名的概念：只有访问同一个域名，才会把之前相同域名返回的cookie携带给服务器。也就是说，访问谷歌的时候，不会把百度的cookie发送给谷歌。

<h3>flask操作cookie：</h3>

<ol>
<li>设置cookie：设置cookie是应该在Response的对象上设置。<code>flask.Response</code>对象有一个<code>set_cookie</code>方法，可以通过这个方法来设置<code>cookie</code>信息。
在Chrome浏览器中查看cookie的方式：

<ul>
<li>右键->检查->Network->重新加载页面->找到请求，然后查看Response Headers中的cookie</li>
<li>点击url输入框左边的信息icon，然后找到相应的域名，再展开查看cookie。</li>
<li>在Chrome的设置界面->高级设置->内容设置->所有cookie->找到当前域名下的cookie。 </li>
</ul></li>
<li>删除cookie：通过<code>Response.delete_cookie</code>，指定cookie的key，就可以删除cookie了。</li>
<li>设置cookie的有效期：

<ul>
<li>max_age：以秒为单位，距离现在多少秒后cookie会过期。</li>
<li><strong>expires：为datetime类型。这个时间需要设置为格林尼治时间，也就是要距离北京少8个小时的时间。</strong></li>
<li>如果max_age和expires都设置了，那么这时候以max_age为标准。</li>
<li>max_age在IE8以下的浏览器是不支持的。expires虽然在新版的HTTP协议中是被废弃了，但是到目前为止，所有的浏览器都还是能够支持，所以如果想要兼容IE8以下的浏览器，那么应该使用expires，否则可以使用max_age。</li>
<li>默认的过期时间：如果没有显示的指定过期时间，那么这个cookie将会在浏览器关闭后过期。
示例代码：</li>
</ul></li>
</ol>

<pre><code class="python">@app.route('/')
def hello_world():
    resp = Response("Ying")
    expires = datetime(year=2017,month=12,day=11,hour=16,minute=0,second=0)
    # 使用expires参数，就必须使用格林尼治时间
    # 要相对北京时间少8个小时
    expires = datetime.now() + timedelta(days=30,hours=16)
    # 在新版本的http协议中，expires参数视为被废弃
    # max_age，在IE8一下的浏览器中是不支持的
    # resp.set_cookie('username','ying',expires=expires,max_age=60)
    resp.set_cookie('username','ying')
    return resp
</code></pre>

<ol>
<li>设置cookie的有效域名：cookie默认是只能在主域名下使用。如果想要在子域名下使用，那么应该给<code>set_cookie</code>传递一个<code>domain='.hy.com'</code>，这样其他子域名才能访问到这个cookie信息。</li>
</ol>

<h3>session：</h3>

<ol>
<li>session的基本概念：session和cookie的作用有点类似，都是为了存储用户相关的信息。不同的是，cookie是存储在本地浏览器，session是一个思路、一个概念、一个服务器存储授权信息的解决方案，不同的服务器，不同的框架，不同的语言有不同的实现。虽然实现不一样，但是他们的目的都是服务器为了方便存储数据的。session的出现，是为了解决cookie存储数据不安全的问题的。</li>
<li>session与cookie的结合使用：

<ul>
<li>session存储在服务器端：服务器端可以采用mysql、redis、memcached等来存储session信息。原理是，客户端发送验证信息过来（比如用户名和密码），服务器验证成功后，把用户的相关信息存储到session中，然后随机生成一个唯一的session_id，再把这个session_id存储cookie中返回给浏览器。浏览器以后再请求我们服务器的时候，就会把这个session_id自动的发送给服务器，服务器再从cookie中提取session_id，然后从服务器的session容器中找到这个用户的相关信息。这样就可以达到安全识别用户的需求了。</li>
<li>cookie存储到客户端：原理是，客户端发送验证信息过来（比如用户名和密码）。服务器把相关的验证信息进行一个非常严格和安全的加密方式进行加密，然后再把这个加密后的信息存储到cookie，返回给浏览器。以后浏览器再请求服务器的时候，就会自动的把cookie发送给服务器，服务器拿到cookie后，就从cookie找到加密的那个session信息，然后也可以实现安全识别用户的需求了。</li>
</ul></li>
</ol>

<h3>flask操作session：</h3>

<ol>
<li>设置session：通过<code>flask.session</code>就可以操作session了。操作<code>session</code>就跟操作字典是一样的。<code>session['username']='zhiliao'</code>。</li>
<li>获取session：也是类似字典，<code>session.get(key)</code>。</li>
<li>删除session中的值：也是类似字典。可以有三种方式删除session中的值。

<ul>
<li><code>session.pop(key)</code>。</li>
<li><code>del session[key]</code>。</li>
<li><code>session.clear()</code>：删除session中所有的值。</li>
</ul></li>
<li>设置session的有效期：如果没有设置session的有效期。那么默认就是浏览器关闭后过期。如果设置session.permanent=True，那么就会默认在31天后过期。如果不想在31天后过期，那么可以设置<code>app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hour=2)</code>在两个小时后过期。</li>
</ol>

<ul>
<li>注： 这个session是可以解密的。

import base64
print(base64.standard_b64decode('eyJ1c2VybmFtZSI6InlpbmcifQ.Djismw.2Ls9eWTpObcfelGf3mfIsE3GDhQ==='))</p></li>
</ul>

<p>所以session中最好不要存放密码，存放存储到服务器上的session_id，再通过session_id获取用户信息