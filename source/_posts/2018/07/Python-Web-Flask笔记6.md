---
title: Python Web - Flask笔记6
date: 2018-07-22 22:44:24
en_title: Python Web - Flask Note 6
tags: [Python, Python Web, Flask]
permalink: /flask-notes/6
---

<h2>38. ORM关系以及一对多：</h2>

mysql级别的外键，还不够ORM，必须拿到一个表的外键，然后通过这个外键再去另外一张表中查找，这样太麻烦了。SQLAlchemy提供了一个<code>relationship</code>，这个类可以定义属性，以后在访问相关联的表的时候就直接可以通过属性访问的方式就可以访问得到了。示例代码：

<pre><code class="python">class User(Base):
    __tablename__ = 'user'
    id = Column(Integer,primary_key=True,autoincrement=True)
    username = Column(String(50),nullable=False)

    # articles = relationship("Article")

    def __repr__(self):
        return "&lt;User(username:%s)&gt;" % self.username

class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    title = Column(String(50),nullable=False)
    content = Column(Text,nullable=False)
    uid = Column(Integer,ForeignKey("user.id"))

    author = relationship("User", backref='articles')

    def __repr__(self):
        return "&lt;Article(title:%s)&gt;" % self.title
</code></pre>

找到某个用户的所有文章：

<pre><code class="python">user = session.query(User).filter_by(username='ying').first()
print(user.articles)
</code></pre>

这里的<code>user.articles</code>是一个List的子类，可以使用<code>append(article)</code>添加绑定新的文章

<strong>relationship指定的是模型，之前的ForeignKey指定的是表</strong>

另外，可以通过<code>backref</code>进行反向引用，上面的例子中，在Article中，<code>author = relationship("User", backref='articles')</code>相当于在User中添加了<code>articles = relationship("Article")</code>

<ul>
<li>下面的方法也可以将文章与用户绑定在一起</li>
</ul>

<pre><code>user = User(username='ying')
article1.author = user
</code></pre>

<h2>39. 一对一的关系：</h2>

在sqlalchemy中，如果想要将两个模型映射成一对一的关系，那么应该在父模型中，指定引用的时候，要传递一个<code>uselist=False</code>这个参数进去。就是告诉父模型，以后引用这个从模型的时候，不再是一个列表了，而是一个对象了。示例代码如下：

<code>user.extend</code>是一个List的继承类，所以使用<code>uselist=False</code>

使用<code>sqlalchemy.orm.backref</code>来定义<code>relationship</code>的反向引用：

<pre><code class="python">class User(Base):
    __tablename__ = 'user'
    id = Column(Integer,primary_key=True,autoincrement=True)
    username = Column(String(50),nullable=False)

    # extend = relationship("UserExtend",uselist=False)

    def __repr__(self):
        return "&lt;User(username:%s)&gt;" % self.username

# 存放一些用户不常用的字段
class UserExtend(Base):
    __tablename__ = 'user_extend'
    id = Column(Integer, primary_key=True, autoincrement=True)
    school = Column(String(50))
    uid = Column(Integer,ForeignKey("user.id", ondelete='CASCADE'))

    user = relationship("User",backref=backref("extend",uselist=False))
</code></pre>

<h2>40. 多对多的关系：</h2>

<ol>
<li>多对多的关系需要通过一张中间表来绑定他们之间的关系。</p></li>
<li><p>先把两个需要做多对多的模型定义出来</p></li>
<li><p>使用Table定义一个中间表，中间表一般就是包含两个模型的外键字段就可以了，并且让他们两个来作为一个“复合主键”。</p></li>
<li><p>在两个需要做多对多的模型中随便选择一个模型，定义一个relationship属性，来绑定三者之间的关系，在使用relationship的时候，需要传入一个secondary=中间表。

多对多相当于是两个多对一，其中的一是中间表</p></li>
</ol>

<pre><code class="python"># 定义中间表
article_tag = Table(
    "article_tag",  # 表名
    Base.metadata,
    Column("article_id", Integer, ForeignKey("article.id"), primary_key=True),
    Column("tag_id", Integer, ForeignKey("tag.id"), primary_key=True)
)

class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer, autoincrement=True, primary_key=True)
    title = Column(String(50), nullable=False)

    tag = relationship("Tag", backref="articles", secondary=article_tag)

class Tag(Base):
    __tablename__ = 'tag'
    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(50), nullable=False)
</code></pre>

<p><strong>注意：</strong>

<ul>
<li>中间表需要继承<code>sqlalchemy.Table</code></li>
<li>在使用绑定三张表的时候，要记得加上<code>secondary</code>参数，填写中间表的名称</li>
</ul>

<h2>41. ORM层面删除数据注意事项</h2>

ORM代码删除数据时会无视数据表之间的约束，直接删除数据。然后将外键的数据设置为NULL。就像约束<code>SET NULL</code>一样。但是，如果数据项被设置为<code>nullable=False</code>的时候，删除会报错。

ORM层面删除数据，会无视mysql级别的外键约束。直接会将对应的数据删除，然后将从表中的那个外键设置为NULL。如果想要避免这种行为，应该将从表中的外键的<code>nullable=False</code>。

<h2>42. <code>relationship</code>中的<code>cascade</code>参数</h2>

在SQLAlchemy，只要将一个数据添加到session中，和他相关联的数据都可以一起存入到数据库中了。这些是怎么设置的呢？其实是通过relationship的时候，有一个关键字参数cascade可以设置这些属性：

<ol>
<li>save-update：默认选项。在添加一条数据的时候，会把其他和他相关联的数据都添加到数据库中。这种行为就是save-update属性影响的。 </li>
<li>delete：表示当删除某一个模型中的数据的时候，是否也删掉使用relationship和他关联的数据。<strong>父删子删</strong></li>
<li>delete-orphan：表示当对一个ORM对象解除了父表中的关联对象的时候，自己便会被删除掉。当然如果父表中的数据被删除，自己也会被删除。<strong>这个选项只能用在一对多上，不能用在多对多以及多对一上。</strong>并且还需要在子模型中的relationship中，增加一个single_parent=True的参数。 </li>
<li>merge：默认选项。当在使用session.merge，合并一个对象的时候，会将使用了relationship相关联的对象也进行merge操作。 </li>
<li>expunge：移除操作的时候，会将相关联的对象也进行移除。这个操作只是从session中移除，并不会真正的从数据库中删除。 </li>
<li>all：是对save-update, merge, refresh-expire, expunge, delete几种的缩写。</li>
</ol>

<pre><code class="python">class User(Base):
    __tablename__ = 'user'
    id = Column(Integer,primary_key=True,autoincrement=True)
    username = Column(String(50),nullable=False)

    # articles = relationship("Article")

    def __repr__(self):
        return "&lt;User(username:%s)&gt;" % self.username

class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    title = Column(String(50),nullable=False)
    content = Column(Text,nullable=False)
    uid = Column(Integer,ForeignKey("user.id"))

    author = relationship("User", backref='articles', cascade='')

    def __repr__(self):
        return "&lt;Article(title:%s)&gt;" % self.title

user = User(username='ying')
article1 = Article(title='123', content='xxx')
article1.author = user
session.add(article1)
session.commit()
</code></pre>

这里Article的author中<code>relationship</code>的参数<code>cascade</code>设置为空字符串，下面添加数据的时候，只添加article是不会通过添加user的。程序运行的时候也会提出警告。<code>cascade</code>默认是同时添加。

当<code>cascade</code>有多个参数的时候，使用英文逗号分隔，如:<code>cascade='save-update, delete'</code>

<h2>43. 三种排序</h2>

<ol>
<li>order_by：可以指定根据这个表中的某个字段进行排序，如果在前面加了一个-，代表的是降序排序。</li>
</ol>

<pre><code class="python">books = session.query(Book).order_by(Book.price.desc()).all()
或者
books = session.query(Book).order_by(-Book.price).all()
或者
books = session.query(Book).order_by("-price").all()
</code></pre>

<ol>
<li>在模型定义的时候指定默认排序：有些时候，不想每次在查询的时候都指定排序的方式，可以在定义模型的时候就指定排序的方式。有以下两种方式：

<ul>
<li>relationship的order_by参数：在指定relationship的时候，传递order_by参数来指定排序的字段。</li>
<li>在模型定义中，添加以下代码：</li>
</ul>

<pre><code>__mapper_args__ = {
        "order_by" : price.desc()
}
</code></pre>

即可让文章使用标题来进行排序。</p></li>
</ol>

<pre><code class="python">class Book(Base):
    __tablename__ = 'book'

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(100), nullable=False)
    price = Column(Float, nullable=False)

    __mapper_args__ = {
        "order_by" : price.desc()
    }

    def __repr__(self):
        return "%s" % self.title

books = session.query(Book).all()
print(books)
</code></pre>

<ol>
<li>正序排序与倒序排序：默认是使用正序排序。如果需要使用倒序排序，那么可以使用这个字段的<code>desc()</code>方法，或者是在排序的时候使用这个字段的字符串名字，然后在前面加一个负号。</li>
</ol>

<h2>44. limit、offset及切片(slice)操作</h2>

<ol>
<li>limit：可以限制每次查询的时候只查询几条数据。</li>
</ol>

<pre><code class="python">books = session.query(Book).limit(5).all()
结果：[title0, title1, title2, title3, title4]
</code></pre>

<ol>
<li>offset：可以限制查找数据的时候过滤掉前面多少条。</li>
</ol>

<pre><code class="python">books = session.query(Book).offset(5).limit(3).all()
结果：[title5, title6, title7]
</code></pre>

<ol>
<li>切片：可以对Query对象使用切片操作，来获取想要的数据。可以使用<code>slice(start,stop)</code>方法来做切片操作。也可以使用<code>[start:stop]</code>的方式来进行切片操作。一般在实际开发中，中括号的形式是用得比较多的。希望大家一定要掌握。示例代码如下：</li>
</ol>

<pre><code class="python">books = session.query(Book).all()[5:9]
结果：[title5, title6, title7, title8]
</code></pre>

<p>实例： 分页， 数据分3页

<pre><code class="python">books = session.query(Book)#.all()
pages = 3
every_page = 3
for i in range(pages):
    print(books[every_page*i : every_page*(i + 1)])
</code></pre>

这里可以不用加<code>.all()</code>，使用切片会自动把结果转换成list。<strong>仅限切片可以不用加.all()</strong>

<h2>45. 数据库的懒加载技术</h2>

在一对多，或者多对多的时候，如果想要获取多的这一部分的数据的时候，往往能通过一个属性就可以全部获取了。比如有一个作者，想要或者这个作者的所有文章，那么可以通过user.articles就可以获取所有的。但有时候我们不想获取所有的数据，比如只想<strong>获取这个作者今天发表的文章</strong>，那么这时候我们可以给relationship传递一个<strong>lazy='dynamic'</strong>，以后通过user.articles获取到的就不是一个列表，而是一个AppenderQuery对象了。这样就可以对这个对象再进行一层过滤和排序等操作。
通过<code>lazy='dynamic'</code>，获取出来的多的那一部分的数据，就是一个<code>AppenderQuery</code>对象了。这种对象既可以添加新数据，也可以跟<code>Query</code>一样，可以再进行一层过滤。
<strong>总而言之一句话：如果你在获取数据的时候，想要对数据再进行一层过滤时，可以考虑使用<code>lazy='dynamic'</code>。</strong>
lazy可用的选项：

<ol>
<li><code>select</code>：这个是默认选项。还是拿<code>user.articles</code>的例子来讲。如果你没有访问<code>user.articles</code>这个属性，那么sqlalchemy就不会从数据库中查找文章。一旦你访问了这个属性，那么sqlalchemy就会立马从数据库中查找所有的文章，并把查找出来的数据组装成一个列表返回。这也是懒加载。</li>
<li><code>dynamic</code>：这个就是我们刚刚讲的。就是在访问<code>user.articles</code>的时候返回回来的不是一个列表，而是<code>AppenderQuery</code>对象。</li>
</ol>

使用<code>dynamic</code>后，使用<code>relationship</code>返回的对象就是一个query的结果对象，然后就可以使用filter进行数据过滤。

<pre><code class="python">class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50),nullable=False)


class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String(50), nullable=False)
    create_time = Column(DateTime,nullable=False,default=datetime.now)
    uid = Column(Integer,ForeignKey("user.id"))

    author = relationship("User",backref=backref("articles",lazy="dynamic"))

    def __repr__(self):
        return "&lt;Article(title: %s)&gt;" % self.title
</code></pre>

<pre><code class="python">user = session.query(User).first()
user.books.append(Book(title='title100', price=random.randint(50, 100)))
session.commit()
print(user.books.filter(Book.price&gt;86).all())
</code></pre>

此时也可以使用append进行添加对象操作

<h2>46. 高级查询</h2>

<h3>group_by</h3>

根据某个字段进行分组。比如想要根据性别进行分组，来统计每个分组分别有多少人，那么可以使用以下代码来完成：

<pre><code class="python">session.query(User.gender,func.count(User.id)).group_by(User.gender).all()
</code></pre>

<pre><code class="python">class GenderEnum(enum.Enum):
    male = "male"
    female = "female"

    def __repr__(self):
        return "%s" % self.value


class Person(Base):
    __tablename__ = 'person'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False)
    gender = Column(Enum(GenderEnum))
    age = Column(Integer, nullable=False)

    def __repr__(self):
        return '%s' % self.name


Base.metadata.drop_all()
Base.metadata.create_all()

for i in range(20):
    p = Person(name="小%s" % i, gender=random.choice([name for name, member in GenderEnum.__members__.items()]), age=random.randint(1, 30))
    session.add(p)

session.commit()
</code></pre>

<pre><code class="python">peoples = session.query(Person.gender, func.count(Person.id)).group_by(Person.gender).all()
</code></pre>

<h3>having</h3>

having是对查找结果进一步过滤。对分组进行having过滤。示例代码如下：

<pre><code class="python">peoples = session.query(Person.gender, func.count(Person.id)).group_by(Person.gender).having(Person.gender=='male').all()
</code></pre>

<h3>join</h3>

<img src="https://img.yingjoy.cn/image//2018/07/SQL-JOINS.png" />

<ol>
<li>join分为left join（左外连接）和right join（右外连接）以及内连接（等值连接）。</li>
<li>参考的网页：http://www.jb51.net/article/15386.htm</li>
<li>在sqlalchemy中，使用join来完成内连接。在写join的时候，如果不写join的条件，那么默认将使用外键来作为条件连接。</li>
<li>query查找出来什么值，不会取决于join后面的东西，而是取决于query方法中传了什么参数。就跟原生sql中的select 后面那一个一样。
比如现在要实现一个功能，要查找所有用户，按照发表文章的数量来进行排序。示例代码如下：</li>
</ol>

<pre><code class="python">result = session.query(User,func.count(Article.id)).join(Article).group_by(User.id).order_by(func.count(Article.id).desc()).all()
</code></pre>

<h3>subquery：</h3>

子查询可以让多个查询变成一个查询，只要查找一次数据库，性能相对来讲更加高效一点。不用写多个sql语句就可以实现一些复杂的查询。那么在sqlalchemy中，要实现一个子查询，应该使用以下几个步骤：
1. 将子查询按照传统的方式写好查询代码，然后在<code>query</code>对象后面执行<code>subquery</code>方法，将这个查询变成一个子查询。
2. 在子查询中，将以后需要用到的字段通过<code>label</code>方法，取个别名。
3. 在父查询中，如果想要使用子查询的字段，那么可以通过子查询的返回值上的<code>c</code>属性拿到。
  整体的示例代码如下：

<pre><code class="python">stmt = session.query(User.city.label("city"),User.age.label("age")).filter(User.username=='李A').subquery()
result = session.query(User).filter(User.city==stmt.c.city,User.age==stmt.c.age).all()
</code></pre>

<strong><code>stmt.c.city</code>这里的c是Column的简写</strong>

<ul>
<li>注： SQL练习题：https://blog.csdn.net/laoduan_78/article/details/44259245           和当前目录下的<code>SQL练习</code></li>
</ul>

<h2>47. Flask-SQLAlchemy</h2>

<h3>安装：</h3>

<pre><code class="shell">pip install flask-sqlalchemy
</code></pre>

<h3>数据库连接：</h3>

<ol>
<li>跟sqlalchemy一样，定义好数据库连接字符串DB_URI。</li>
<li>将这个定义好的数据库连接字符串DB_URI，通过<code>SQLALCHEMY_DATABASE_URI</code>这个键放到<code>app.config</code>中。示例代码：<code>app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI</code>.</li>
<li>使用<code>flask_sqlalchemy.SQLAlchemy</code>这个类定义一个对象，并将<code>app</code>传入进去。示例代码：<code>db = SQLAlchemy(app)</code>。</li>
</ol>

<h3>创建ORM模型：</h3>

<ol>
<li>还是跟使用sqlalchemy一样，定义模型。现在不再是需要使用<code>delarative_base</code>来创建一个基类。而是使用<code>db.Model</code>来作为基类。</li>
<li>在模型类中，<code>Column</code>、<code>String</code>、<code>Integer</code>以及<code>relationship</code>等，都不需要导入了，直接使用<code>db</code>下面相应的属性名就可以了。</li>
<li>在定义模型的时候，可以不写<code>__tablename__</code>，那么<code>flask_sqlalchemy</code>会默认使用当前的模型的名字转换成小写来作为表的名字，并且如果这个模型的名字使用了多个单词并且使用了驼峰命名法，那么会在多个单词之间使用下划线来进行连接。<strong>虽然flask_sqlalchemy给我们提供了这个特性，但是不推荐使用。</strong></li>
</ol>

<h3>将ORM模型映射到数据库：</h3>

<ol>
<li>db.drop_all()</li>
<li>db.create_all()</li>
</ol>

<h3>使用session：</h3>

以后session也不需要使用<code>sessionmaker</code>来创建了。直接使用<code>db.session</code>就可以了。操作这个session的时候就跟之前的<code>sqlalchemy</code>的<code>session</code>是iyimoyiyang的。

<h3>查询数据：</h3>

如果查找数据只是查找一个模型上的数据，那么可以通过<code>模型.query</code>的方式进行查找。<code>query</code>就跟之前的sqlalchemy中的query方法是一样用的。示例代码如下：

<pre><code class="python">users = User.query.order_by(User.id.desc()).all()
print(users)
</code></pre>

<h2>48. alembic数据库迁移工具</h2>

<code>alembic</code>是由<code>SQLAlchemy</code>的作者(Michael Bayer)开发。用来做ORM模型与数据库的迁移与映射。<code>alembic</code>的方式类似git，表现在：

<ol>
<li><code>alembic</code>所有的命令都以<code>alembic</code>开头；</li>
<li><code>alembic</code>的迁移文件也是通过版本进行控制的</li>
</ol>

<h3>安装</h3>

<pre><code class="shell">pip install alembic
</code></pre>

使用alembic的步骤：

<ol>
<li>定义好自己的模型。</li>
</ol>

<pre><code class="python">class User(Base):
    __tablename__ = 'user'

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(50), nullable=False)

    def __repr__(self):
        return "%s" % self.username
</code></pre>

<ol>
<li>使用alembic创建一个仓库：<code>alembic init [仓库的名字，推荐使用alembic]</code>。</p></li>
<li><p>修改配置文件：

<ul>
<li>在<code>alembic.ini</code>中，给<code>sqlalchemy.url</code>设置数据库的连接方式。这个连接方式跟sqlalchemy的方式一样的。</li>
<li>在<code>alembic/env.py</code>中的<code>target_metadata</code>设置模型的<code>Base.metadata</code>。但是要导入<code>models</code>，需要将models所在的路径添加到这个文件中。示例代码如下：
<code>python
import sys,os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from alembic_demo import Base
target_metadata = Base.metadata</code></li>
</ul>

<code>os.path.dirname(__file__)</code>可以获取当前文件的目录</p></li>
<li><p><strong>将ORM模型生成迁移脚本：<code>alembic revision --autogenerate -m 'message'</code>。</strong></p></li>
<li><p><strong>将生成的脚本映射到数据库中：<code>alembic upgrade head</code>。</strong></p></li>
<li><p>以后如果修改了模型，重复4、5步骤。</p></li>
<li><p>注意事项：在终端中，如果想要使用alembic，则需要首先进入到安装了alembic的虚拟环境中，不然就找不到这个命令。</p></li>
</ol>

<h3>常用命令：</h3>

<ol>
<li>init：创建一个alembic仓库。</li>
<li>revision：创建一个新的版本文件。</li>
<li>--autogenerate：自动将当前模型的修改，生成迁移脚本。</li>
<li>-m：本次迁移做了哪些修改，用户可以指定这个参数，方便回顾。</li>
<li>upgrade：将指定版本的迁移文件映射到数据库中，会执行版本文件中的upgrade函数。如果有多个迁移脚本没有被映射到数据库中，那么会执行多个迁移脚本。</li>
<li>[head]：代表最新的迁移脚本的版本号。</li>
<li>downgrade：会执行指定版本的迁移文件中的downgrade函数。</li>
<li>heads：展示head指向的脚本文件版本号。</li>
<li>history：列出所有的迁移版本及其信息。</li>
<li>current：展示当前数据库中的版本号。</li>
</ol>

<h3>经典错误：</h3>

<ol>
<li>FAILED: Target database is not up to date.

<ul>
<li>原因：主要是heads和current不相同。current落后于heads的版本。</li>
<li>解决办法：将current移动到head上。<code>alembic upgrade head</code></li>
</ul></li>
<li>FAILED: Can't locate revision identified by '77525ee61b5b'

<ul>
<li>原因：数据库中存的版本号不在迁移脚本文件中</li>
<li>解决办法：删除数据库的alembic_version表中的数据，重新执行alembic upgrade head</li>
</ul></li>
<li>执行<code>upgrade head</code>时报某个表已经存在的错误：

<ul>
<li>原因：执行这个命令的时候，会执行所有的迁移脚本，因为数据库中已经存在了这个表。然后迁移脚本中又包含了创建表的代码。</li>
<li>解决办法：（1）删除versions中所有的迁移文件。（2）修改迁移脚本中创建表的代码。(先把upgrade方法内容改成pass，然后再改回来)</li>
</ul></li>
</ol>

<h2>49. flask-sqlalchemy中配置alembic</h2>

<p>创建flask项目，创建好模型

<pre><code>alembic init alembic
修改配置文件
        import sys, os
        sys.path.append(os.path.dirname(os.path.dirname(__file__)))
        from app import db
        target_metadata = db.Model.metadata
这里和之前不同， 这里还要注意加入路径和导入db的顺序

alembic revision --autogenerate -m "first commit"
alembic upgrade head
</code></pre>