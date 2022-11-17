---
title: Spring Boot 简单入门
date: 2018-08-30 02:25:48
en_title: Spring Boot Simple Tutorial
tags: [SpingBoot, Java]
---

<h1>SpringBoot</h1>

<h2>1. Hello World</h2>

<pre><code class="java">@RestController
public class HelloController {

    @RequestMapping(value = "/hello", method = RequestMethod.GET)
    public String hello_world() {
        return "Hello World";
    }
}
</code></pre>

<h2>2. 运行方式</h2>

<ol>
<li>直接运行Application</li>
<li>mvn spring-boot:run</li>
<li>mvn install
cd target
java -jar xxx-0.0.1-SNAPSHOT</li>
</ol>

<h2>3. 项目属性配置</h2>

在resources/application.properties中写入配置

<h1>端口</h1>

server.port=5000

<h1>网站访问前缀</h1>

server.servlet.context-path=/front

eg: http://127.0.0.1:5000/front/hello

配置文件还可以是application.yml

<pre><code class="yml">server:
  port: 5000
  servlet:
    context-path: /front
</code></pre>

<h3>获取配置文件内容</h3>

age: 18

<pre><code class="java">@Value("${age}")
private Integer age;
</code></pre>

<h3>配置进行分组</h3>

<pre><code class="yml">girl:
  gradeNum: B
  age: 18

  content: "gradeNum: ${girl.gradeNum}, age: ${girl.age}"
</code></pre>

这里再创建一个类GirlProperties

<pre><code class="java">@Component
@ConfigurationProperties(prefix = "girl")
public class GirlProperties {

    private String gradeNum;
    private Integer age;
    private String content;

    getter setter省略
}

@Autowired
private GirlProperties girlProperties;
</code></pre>

<h3>配置不同环境下使用的配置文件（开发环境/生产环境）</h3>

创建新的application-xxx.yml

application.yml的内容：
spring:
  profiles:
    active: xxx

当使用java -jar 运行时，可以添加参数选择配置文件
java -jar xxx-0.0.1-SNAPSHOT --spring.profiles.active=xxx

<h2>4. Controller的使用</h2>

@Controller     处理HTTP请求
@RestController     Spring4新增的注解，原来返回json，等同于@ResponseBody加上@Controller
@RequestMapping     配置URL映射

@Controller需要配合模板使用
使用Sring官方模板

<pre><code class="xml">&lt;dependency&gt;
    &lt;groupId&gt;org.springframe.boot&lt;/groupId&gt;
    &lt;artifactId&gt;sprint-boot-starter-thymeleaf&lt;/artifactId&gt;
&lt;/dependency&gt;
</code></pre>

然后在resources/templates下创建模板文件
假设创建一个名为index.html的文件
然后在映射函数中return "index"即可

由于一般开发为前后端分离，所以不推荐使用模板，模板对性能损耗也大。

@RequestMapping多URL映射
使用集合

<pre><code class="java">@RequestMapping(value = {"/hello", "/hi"}, method = RequestMethod.GET)
</code></pre>

还可以给整个类设置URL

<pre><code class="java">@RestController
@RequestMapping("/hello")
public class HelloController {


    @Autowired
    private GirlProperties girlProperties;

    @RequestMapping(value = "/say", method = RequestMethod.GET)
    public String say() {
        return girlProperties.getContent();
    }
}
</code></pre>

最后访问：http://127.0.0.1:5000/hello/say

如果@RequestMapping不加method，则所有方法均可访问，多方式访问使用集合

<h3>如何处理URL的参数</h3>

@PathVariable       获取URL中的数据
@RequestParam       获取请求参数的值
@GetMapping     组合注解

<pre><code class="java">@RequestMapping(value = "/say/{id}", method = {RequestMethod.POST, RequestMethod.GET})
public String say(@PathVariable("id") Integer id) {
    return "Hello "+ id;
}
http://127.0.0.1:5000/hello/say/1
这个方法不传id会显示404

@RequestMapping(value = "/say", method = {RequestMethod.POST, RequestMethod.GET})
public String say(@RequestParam("id") Integer id) {
    return "Hello "+ id;
}
http://127.0.0.1:5000/hello/say?id=1
//这个方法如果不传id会显示null

@RequestMapping(value = "/say", method = {RequestMethod.POST, RequestMethod.GET})
public String say(@RequestParam(name = "id", required = false, defaultValue = "0") Integer id) {
    return "Hello "+ id;
}
//这个方法可以设置默认值(defaultValue)，是否必须传这个值(required)
</code></pre>

@GetMapping
@PostMapping
@PutMapping
@DeleteMapping
这些组合注解可以指定Mapping的方法

<h2>数据库的操作</h2>

<h3>Spring-Data-Jpa</h3>

JPA(Java Persistence API)定义了一系列对象持久化的标准，目前实现这一规范的产品有Hibernate、TopLink等。

RESTful API设计
GET /girls      获取女生列表
POST    /girls      创建一个女生
GET /girls/id   通过id查找一个女生
PUT /girls/id   通过id更新一个女生
DELETE  /girls/id   通过id删除一个女生

添加依赖

<pre><code class="java">&lt;!--jpa--&gt;
&lt;dependency&gt;
    &lt;groupId&gt;org.springframework.boot&lt;/groupId&gt;
    &lt;artifactId&gt;spring-boot-starter-data-jpa&lt;/artifactId&gt;
&lt;/dependency&gt;

&lt;!--mysql-connector--&gt;
&lt;dependency&gt;
    &lt;groupId&gt;mysql&lt;/groupId&gt;
    &lt;artifactId&gt;mysql-connector-java&lt;/artifactId&gt;
&lt;/dependency&gt;
</code></pre>

配置jpa和mysql

编写接口继承JpaRepository

<pre><code class="java">public interface GirlRepository extends JpaRepository&lt;Girl, Integer&gt; {

    // 通过年龄查询
    public List&lt;Girl&gt; findByAge(Integer age);
}
</code></pre>

进行CRUD

<pre><code class="java">package com.yingjoy.demo.controller;

import com.yingjoy.demo.Girl;
import com.yingjoy.demo.GirlRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class GirlController {

    @Autowired
    private GirlRepository girlRepository;

    /**
     * 查询女生列表
     */
    @GetMapping(value = "/girls")
    public List&lt;Girl&gt; girlList() {
        return girlRepository.findAll();
    }

    /**
     * 新增女生
     */
    @PostMapping(value = "/girls")
    public Girl girlAdd(@RequestParam("gradeNum") String gradeNum,
                        @RequestParam("age") Integer age) {
        Girl girl = new Girl();
        girl.setgradeNum(gradeNum);
        girl.setAge(age);

        return girlRepository.save(girl);
    }

    /**
     * 查询女生
     */
    @GetMapping(value = "/girls/{id}")
    public Girl girlFindOne(@PathVariable("id") Integer id) {
        return girlRepository.findById(id).get();
    }

    /**
     * 更新女生
     */
    @PutMapping(value = "/girls/{id}")
    public Girl girlUpdate(@PathVariable("id") Integer id,
                           @RequestParam("gradeNum") String gradeNum,
                           @RequestParam("age") Integer age) {
        Girl girl = girlRepository.findById(id).get();
        girl.setId(id);
        girl.setgradeNum(gradeNum);
        girl.setAge(age);
        return girlRepository.save(girl);
    }

    /**
     * 删除女生
     */
    @DeleteMapping(value = "/girls/{id}")
    public void girlDelete(@PathVariable("id") Integer id) {
        Girl girl = girlRepository.findById(id).get();
        girlRepository.delete(girl);
    }

    /**
     * 按照年龄查询
     */
    @GetMapping("/girls/a/{age}")
    public List&lt;Girl&gt; girlFindByAge(@PathVariable("age") Integer age) {
        return girlRepository.findByAge(age);
    }

}
</code></pre>

注：put方法需要使用x-www-form-urlencoded传递数据，不能使用form-data

<h2>事务管理</h2>

@Transactional 注释可以把方法变成事务