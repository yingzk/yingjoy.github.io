---
title: 深入理解RESTful API设计
date: 2018-11-22 12:00:00
en_title: Thorough learning the RESTful API
tags: [RESTful, Web, Design]
---

RESTful API 全称 <strong>RE</strong>presentational <strong>S</strong>tate <strong>T</strong>ransfer (表现层状态转化)
服务器上的文本,图片,网页,视频等都是资源(Resources), 通常使用一个唯一的URI(统一资源定位符)来表示.
<strong>"资源"具体呈现出来的形式，叫做它的"表现层"（Representation）</strong>

<h2>状态转换</h2>

访问一个网站，就代表了客户端和服务器的一个互动过程。在这个过程中，势必涉及到数据和状态的变化。

互联网通信协议HTTP协议，是一个无状态协议。这意味着，<strong>所有的状态都保存在服务器端</strong>。因此，如果客户端想要操作服务器，必须通过某种手段，让服务器端发生"状态转化"（State Transfer）。而这种转化是建立在表现层之上的，所以就是"表现层状态转化"。

一般网址后面会有".html"后缀,这不是必要的, 这属于"表现层"范畴, URI应该只代表"资源"的位置。它的具体表现形式，应该在HTTP请求的头信息中用<strong>Accept</strong>和<strong>Content-Type</strong>字段指定，这两个字段才是对"表现层"的描述.

客户端用到的手段，只能是HTTP协议。具体来说，就是HTTP协议里面操作方式的动词：<strong>GET、POST、PUT、PATCH、DELETE</strong> 当然还有一些不经常使用的
<img src="https://img.yingjoy.cn/image/2018/11/QQ20181122111210.png" alt="" class="aligncenter size-full wp-image-719" />

<div align=center>截取自Postman</div>

<hr>

<pre><code>* GET: 获取某个资源，GET操作应该是幂等（idempotence）的，且无副作用。
* POST: 创建一个新的资源。
* PUT: 替换某个已有的资源。PUT操作虽然有副作用，但其应该是幂等的。
* PATCH（RFC5789）: 修改某个已有的资源。
* DELETE：删除某个资源。DELETE操作有副作用，但也是幂等的。

这里说明一下PUT和PATCH的区别:
    假设修改一个用户信息(name, age, height, weight)
    1. 使用PUT:
         只传入了name, age(不完全信息)的话, 则height和weight会被替换为空, 是一个完全覆盖的思想
    2. 使用PATCH:
         可以传入部分参数或全部参数, 但没有传入的参数是不会被修改的.
</code></pre>

<h2>REST四个基本原则：</h2>

1.使用HTTP动词：GET POST PUT PATCH DELETE等；
2.无状态连接，服务器端不应保存过多上下文状态，即每个请求都是独立的；
3.为每个资源设置唯一的URI；
4.通过XML或JSON进行数据传递；

实现上述原则的架构即可称为RESTful架构。

1.互联网环境下，任何应用的架构和API可以被快速理解；
2.分布式环境下，任何请求都可以被发送到任意服务器；
3.异构环境下，任何资源的访问和使用方式都统一；

<h2>状态码</h2>

关于状态码推荐阅读: http://clojure-liberator.github.io/liberator/doc/decisions.html
<img src="http://clojure-liberator.github.io/liberator/assets/img/decision-graph.svg" alt="" />

<h2>请求数据验证(反爬虫)</h2>

<ol>
<li><p>Request headers是否合法：如果出现了某些不该有的头，或者某些必须包含的头没有出现或者内容不合法，根据其错误类型一律返回4xx。比如说你的API需要某个特殊的私有头（e.g. X-Request-ID），那么凡是没有这个头的请求一律拒绝。这可以防止各类漫无目的的webot或crawler的请求，节省服务器的开销。</p></li>
<li><p>Request URI和Request body是否合法：如果请求带有了不该有的数据，或者某些必须包含的数据没有出现或内容不合法，一律返回4xx。比如说，API只允许querystring中含有query，那么"?sort=desc"这样的请求需要直接被拒绝。有不少攻击会在querystring和request body里做文章，最好的对应策略是，过滤所有含有不该出现的数据的请求。</p></li>
</ol>

<h2>参考</h2>

<ul>
<li><a href="https://zhuanlan.zhihu.com/p/20034107">撰写安全合格的REST API</a></li>
<li><a href="http://www.ruanyifeng.com/blog/2011/09/restful.html">理解RESTful架构</a></li>
</ul>

<h2>推荐阅读</h2>

<ul>
<li><a href="http://codeplanet.io/principles-good-restful-api-design/">Principles of good RESTful API Design</a></li>
<li><a href="http://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api">Best Practices for Designing a Pragmatic RESTful API</a></li>
</ul>