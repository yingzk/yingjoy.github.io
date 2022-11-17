---
title: Python Web - Flask笔记5
date: 2018-07-21 21:49:14
en_title: Python Web - Flask Note 5
tags: [Python, Python Web, Flask]
permalink: /flask-notes/5
---

<h2>29. MySQL数据库</h2>

<h3>安装：</h3>

见当前目录下的<code>MySQL安装详解.doc</code>

<h3>MySQL Workbench</h3>

MySQL Workbench是一款专为MySQL设计的ER/数据库建模工具。它是著名的数据库设计工具DBDesigner4的继任者。你可以用MySQL Workbench设计和创建新的数据库图示，建立数据库文档，以及进行复杂的MySQL 迁移。

具体使用可以参考：https://blog.csdn.net/soulandswear/article/details/60966808

<h2>30. SQLAlchemy连接数据库</h2>

在Python3中直接安装<code>pymysql</code>， Python2中使用<code>MySQLdb</code>

<h3>使用SQLAlchemy连接数据库：</h3>

使用SQLALchemy去连接数据库，需要使用一些配置信息，然后将他们组合成满足条件的字符串：

<pre><code class="python">HOSTNAME = '127.0.0.1'
PORT = '3306'
DATABASE = 'test'
USERNAME = 'root'
PASSWORD = 'root'

# dialect+driver://username:password@host:port/database
DB_URI = "mysql+pymysql://{username}:{password}@{host}:{port}/{db}?charset=utf8".format(username=USERNAME,password=PASSWORD,host=HOSTNAME,port=PORT,db=DATABASE)
</code></pre>

然后使用<code>create_engine</code>创建一个引擎<code>engine</code>，然后再调用这个引擎的<code>connect</code>方法，就可以得到这个对象，然后就可以通过这个对象对数据库进行操作了：

<pre><code class="python">engine = create_engine(DB_URI)

with engine.connect() as con:
  rs = con.execute("SELECT 1")
  print(rs.fetchone())
</code></pre>

<h2>31. ORM（Object Relationship Mapping）框架</h2>

ORM是对象关系映射，也就是对象模型与数据库表之间的映射

<h3>将ORM模型映射到数据库中：</h3>

<ol>
<li>用<code>declarative_base</code>根据<code>engine</code>创建一个ORM基类。</p></li>
<li><p>用这个<code>Base</code>类作为基类来写自己的ORM类。要定义<code>__tablename__</code>类属性，来指定这个模型映射到数据库中的表名。</p></li>
<li><p>创建属性来映射到表中的字段，所有需要映射到表中的属性都应该为Column类型</p></li>
<li><p>使用<code>Base.metadata.create_all()</code>来将模型映射到数据库中。</p></li>
<li><p>一旦使用<code>Base.metadata.create_all()</code>将模型映射到数据库中后，即使改变了模型的字段，也不会重新映射了。

如果你想要让他重新映射，在前面加<code>Base.metadata.drop_all()</code>或者使用后面的<code>alembic</code>或<code>flask-migrate。</code></p></li>
</ol>

<p>在这个ORM模型中创建一些属性，来跟表中的字段进行一一映射。这些属性必须是sqlalchemy给我们提供好的数据类型。

<pre><code class="python">from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base

DB_URI = "mysql+pymysql://root:123456@127.0.0.1:3306/test?charset=utf8"

engine = create_engine(DB_URI)

# 这个函数返回元类(MetaClass)
Base = declarative_base(engine)

class Person(Base):
    __tablename__ = 'person'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50))
    age = Column(Integer)

Base.metadata.create_all()
</code></pre>

<h2>32. ORM中的增删改查</h2>

<h3>用session做数据的增删改查操作：</h3>

<ol>
<li>构建session对象：所有和数据库的ORM操作都必须通过一个叫做<code>session</code>的会话对象来实现，通过以下代码来获取会话对象：

<pre><code class="python">from sqlalchemy.orm import sessionmaker

engine = create_engine(DB_URI)
session = sessionmaker(engine)()
</code></pre>

注意<code>session = sessionmaker(engine)()</code>后面还有一对括号</p></li>
<li><p>添加对象：

<ul>
<li>创建对象，也即创建一条数据：
<code>python
p = Person(name='ying',age=18,country='china')</code></li>
<li>将这个对象添加到<code>session</code>会话对象中：
<code>python
session.add(p)</code></li>
<li>将session中的对象做commit操作（提交）：
<code>python
session.commit()</code></li>
<li>一次性添加多条数据：
<code>python
p1 = Person(name='ying1',age=19,country='china')
p2 = Person(name='ying2',age=20,country='usa')
session.add_all([p1,p2])
session.commit()</code></li>
</ul></li>
<li>查找对象：

<pre><code class="python"># 查找某个模型对应的那个表中所有的数据：
all_person = session.query(Person).all()
# 使用filter_by来做条件查询
all_person = session.query(Person).filter_by(name='ying').all()
# 使用filter来做条件查询
all_person = session.query(Person).filter(Person.name=='ying').all()
# 使用get方法查找数据，get方法是根据id来查找的，只会返回一条数据或者None
person = session.query(Person).get(primary_key)
# 使用first方法获取结果集中的第一条数据
person = session.query(Person).first()
</code></pre></li>
<li>修改对象：首先从数据库中查找对象，然后将这条数据修改为你想要的数据，最后做commit操作就可以修改数据了。

<pre><code class="python">person = session.query(Person).first()
person.name = 'ying'
session.commit()
</code></pre></li>
<li>删除对象：将需要删除的数据从数据库中查找出来，然后使用<code>session.delete</code>方法将这条数据从session中删除，最后做commit操作就可以了。

<pre><code class="python">person = session.query(Person).first()
session.delete(person)
session.commit()
</code></pre></li>
</ol>

<h2>33. SQLAlchemy中常用的数据类型</h2>

<ol>
<li>Integer：整形，映射到数据库中是int类型。</p></li>
<li><p>Float：浮点类型，映射到数据库中是float类型。32位。</p></li>
<li><p>Double：双精度浮点类型，映射到数据库中是double类型，64位。</p></li>
<li><p>String：可变字符类型，映射到数据库中是varchar类型.</p></li>
<li><p>Boolean：布尔类型，映射到数据库中的是tinyint类型。</p></li>
<li><p>DECIMAL：定点类型。是专门为了解决浮点类型精度丢失的问题的。在存储钱相关的字段的时候建议大家都使用这个数据类型。并且这个类型使用的时候需要传递两个参数，第一个参数是用来标记这个字段总能能存储多少个数字，第二个参数表示小数点后有多少位。

例如，我要存，6位整数，4位小数：<code>Column(DECIMAL(10, 4))</code>，如果插入数据的时候数据不在改范围内，报错。</p></li>
<li><p>Enum：枚举类型。指定某个字段只能是枚举中指定的几个值，不能为其他值。在ORM模型中，使用Enum来作为枚举，示例代码如下：

<pre><code class="python">class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    tag = Column(Enum("python",'flask','django'))
</code></pre>

在Python3中，已经内置了enum这个枚举的模块，我们也可以使用这个模块去定义相关的字段。示例代码如下：

<pre><code class="python">class TagEnum(enum.Enum):
    python = "python"
    flask = "flask"
    django = "django"

class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    tag = Column(Enum(TagEnum))

article = Article(tag=TagEnum.flask)
</code></pre></li>
<li>Date：存储时间，只能存储年月日。映射到数据库中是date类型。在Python代码中，可以使用<code>datetime.date</code>来指定。示例代码如下：

<pre><code class="python">class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    create_time = Column(Date)

article = Article(create_time=date(2018,10,10))
</code></pre></li>
<li>DateTime：存储时间，可以存储年月日时分秒毫秒等。映射到数据库中也是datetime类型。在Python代码中，可以使用<code>datetime.datetime</code>来指定。示例代码如下：

<pre><code class="python">class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    create_time = Column(DateTime)

article = Article(create_time=datetime(2011,11,11,11,11,11))
</code></pre></li>
<li>Time：存储时间，可以存储时分秒。映射到数据库中也是time类型。在Python代码中，可以使用<code>datetime.time</code>来至此那个。示例代码如下：

<pre><code class="python">class Article(Base):
  __tablename__ = 'article'
  id = Column(Integer,primary_key=True,autoincrement=True)
  create_time = Column(Time)

article = Article(create_time=time(hour=11,minute=11,second=11))
</code></pre></li>
<li>Text：存储长字符串。一般可以存储6W多个字符。如果超出了这个范围，可以使用LONGTEXT类型。映射到数据库中就是text类型。</li>
<li>LONGTEXT：长文本类型，映射到数据库中是longtext类型。</li>
</ol>

<h2>34. Column常用参数</h2>

<ol>
<li>primary_key：设置某个字段为主键。</li>
<li>autoincrement：设置这个字段为自动增长的。</li>
<li>default：设置某个字段的默认值。在发表时间这些字段上面经常用。</li>
<li>nullable：指定某个字段是否为空。默认值是True，就是可以为空。</li>
<li>unique：指定某个字段的值是否唯一。默认是False。</li>
<li>onupdate：更新数据的时候调用，常用案例：修改文章时间，修改了文章，就默认把当前时间设置为now，update_time`（每次更新数据的时候都要更新的值）， <strong>第一次插入数据的时候不会被调用。</strong>可以使用default设置初始默认值</li>
<li>name：指定ORM模型中某个属性映射到表中的字段名。如果不指定，那么会使用这个属性的名字来作为字段名。如果指定了，就会使用指定的这个值作为参数。这个参数也可以当作位置参数，在第1个参数来指定。
<code>python
title = Column(String(50),name='title',nullable=False)
title = Column('my_title',String(50),nullable=False)</code></li>
</ol>

<h2>35. <code>query</code>函数的参数</h2>

<ol>
<li>模型对象。指定查找这个模型中所有的对象。</p></li>
<li><p>模型中的属性。可以指定只查找某个模型的其中几个属性。</p></li>
<li><p>聚合函数。

<ul>
<li><code>func.count</code>：统计行的数量。

<pre><code class="python">session.query(func.count(Article.price)).first()
</code></pre></li>
<li><code>func.avg</code>：求平均值。

<pre><code class="python">session.query(func.avg(Article.price)).first()
</code></pre></li>
<li><code>func.max</code>：求最大值。</p></li>
<li><p><code>func.min</code>：求最小值。</p></li>
<li><p><code>func.sum</code>：求和。
<code>func</code>上，其实没有任何聚合函数。但是因为他底层做了一些魔术，<strong>只要mysql中有的聚合函数，都可以通过<code>func</code>调用。</strong></p></li>
</ul></li>
</ol>

<ul>
<li><strong>注： 重写类的<code>__repr__</code>函数可以自定义类的返回</strong></li>
</ul>

<pre><code class="python">def __repr__(self):
  return 'Title: %s' % self.title
返回： Title: xxx
</code></pre>

<h2>36. filter过滤条件</h2>

<p>过滤是数据提取的一个很重要的功能，以下对一些常用的过滤条件进行解释，并且这些过滤条件都是只能通过filter方法实现的：

<ol>
<li>equals：
<code>python
article = session.query(Article).filter(Article.title == "title0").first()
print(article)</code></li>
<li>not equals:
<code>python
query.filter(User.name != 'ed')</code></li>
<li>like：  （ilike：不区分大小写）

<pre><code class="python">query.filter(User.name.like('%ed%'))
</code></pre></li>
<li>in：

<pre><code class="python">query.filter(User.name.in_(['ed','wendy','jack']))
# 同时，in也可以作用于一个Query
query.filter(User.name.in_(session.query(User.name).filter(User.name.like('%ed%'))))
</code></pre></li>
<li>not in：

<pre><code class="python">query.filter(~User.name.in_(['ed','wendy','jack']))
query().filter(User.name.notin_(['ed','wendy','jack']))
</code></pre></li>
<li>is null：

<pre><code class="python">query.filter(User.name==None)
# 或者是
query.filter(User.name.is_(None))
</code></pre></li>
<li>is not null:

<pre><code class="python">query.filter(User.name != None)
# 或者是
query.filter(User.name.isnot(None))
</code></pre></li>
<li>and：

<pre><code class="python">from sqlalchemy import and_
query.filter(and_(User.name=='ed',User.fullname=='Ed Jones'))
# 或者是传递多个参数
query.filter(User.name=='ed',User.fullname=='Ed Jones')
# 或者是通过多次filter操作
query.filter(User.name=='ed').filter(User.fullname=='Ed Jones')
</code></pre></li>
<li>or：

<pre><code class="python">from sqlalchemy import or_ query.filter(or_(User.name=='ed',User.name=='wendy'))
</code></pre></li>
</ol>

如果想要查看<code>ORM</code>底层转换的<code>SQL</code>语句，可以在filter方法后面不要再执行任何方法直接打印就可以看到了。比如：

<pre><code class="python">articles = session.query(Article).filter(or_(Article.title=='abc',
                                             Article.content=='abc'))
    print(articles)
</code></pre>

<ul>
<li><strong>注： 如果想得到查找的SQL语句，直接返回<code>filter</code>即可，不需要在后面加<code>first()</code>或<code>all()</code></strong></li>
</ul>

<h2>37. 外键和四种约束</h2>

使用SQLAlchemy创建外键非常简单。在从表中增加一个字段，指定这个字段外键的是哪个表的哪个字段就可以了。<strong>从表中外键的字段，必须和父表的主键字段类型保持一致。</strong>
示例：

<pre><code class="python">class User(Base):
    __tablename__ = 'user'
    id = Column(Integer,primary_key=True,autoincrement=True)
    username = Column(String(50),nullable=False)

class Article(Base):
    __tablename__ = 'article'
    id = Column(Integer,primary_key=True,autoincrement=True)
    title = Column(String(50),nullable=False)
    content = Column(Text,nullable=False)

    uid = Column(Integer,ForeignKey("user.id"))
</code></pre>

外键约束有以下几项： 
1. RESTRICT：父表数据被删除，会阻止删除。默认就是这一项。 
2. NO ACTION：在MySQL中，同RESTRICT。 
3. CASCADE：级联删除。 父删子删
4. SET NULL：父表数据被删除，子表数据会设置为NULL。<strong>注意：字段属性不能有nullable=False</strong>

<pre><code class="python">id = Column(Integer, ForeignKey("user.id", ondelete="RESTRICT"))
</code></pre>

<ul>
<li><strong>注：如果要使用外键，则数据库的引擎必须为： <code>InnoDB</code></strong></li>
</ul>