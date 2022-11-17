---
title: 遇见 Kotlin 先导篇：Kotlin 相比 Java 好在哪里？
date: 2017-06-19 16:19:18
en_title: Kotlin vs Java
tags: [Java, Kotlin]
---

## 前言

​

Kotlin ——一种为现代多平台应用而诞生的静态编程语言

<img src="https://img.yingjoy.cn/image/2017/06/1496728910375_620_1496728933748.jpg" />

​

Kotlin 是由 JetBrains 开发的一个基于 JVM（Java虚拟机） 的新的编程语言。

​

Kotlin文件可以编译成Java的字节码，也可以编译成JavaScript，这样就很方便那些没有安装JVM的设备运行。

​

Kotlin兼容Java，相比于Java而言，它有很多优点，待会笔者会就几个写一下，并给出实际例子。

​

Kotlin文件以".kt"作为拓展名，[这是](https://kotlinlang.org/docs/reference/)Kotlin的官方参考文档。

​

在这笔者顺便打个**广告**

​

## 广告内容

​

腾讯课堂《跟鹅厂老司机学新技术》系列课程第一课 “遇见Kotlin” 将于**今晚8点半**开始啦

​

本期的主题为如何学习Kotlin和分享一些学习Kotlin过程的小技巧 ，欢迎各位开发者和小伙伴们前来围观哦

​

笔者是已经准备好凳子了的:) YingJoy

​

[这是](https://ke.qq.com/course/212919#tuin=5778dd4e)课程地址，还没报名的小伙伴们赶紧了！

​

广告结束。好了，现在开始正文

​

### 优点1. 与Java语言的互通性

​

Kotlin与Java100%互通，不通你打死我

​

你可以用Kotlin继续你的Java项目

​

所有你熟悉的Java框架仍可用。

​

任何框架，不管是 Kotlin 写的，还是你Java写的都可以。

​

### Demo:

​

#### Kotlin调用Java

```
Java文件：
public class KotlinDemo {

    private String string;

    public KotlinDemo(String string) {
        this.string = string;
    }

    public void hello() {
        System.out.println("The string is " + string);
    }

    public String getString() {
        return string;
    }

    public void setString(String string) {
        this.string = string;
    }
		
		public boolean is(String string){
        return this.string.equals(string);
    }
}

Kotlin文件:
val kotlinDemo = KotlinDemo("Ying")
javaBean.hello()

javaBean.`is`("Joy")    //说明： is在Kotlin里是关键字，所以用``符号括起来
```

​

### Java调用Kotlin

```
Kotlin文件:
class KotlinBeanDemo(val string: String) {
    fun hello() {
        println("The string is " + string)
    }
}

Java文件：
KotlinBeanDemo kdemo = new KotlinBeanDemo("Ying");
bean.hello();
```

​

## 优点2. 与Java语言的相似

​

[这里](https://kotlinlang.org/docs/reference/basic-syntax.html)可以看官方的文档

​

### Demo

​

```
class Foo {

    val b: String = "a"
    var i: Int = 0

    fun hello() {
        val str = "Hello"
        print("$str World")
    }

    fun sum(x: Int, y: Int): Int {
        return x + y
    }

    fun maxOf(a: Float, b: Float) = if (a > b) a else b

}
```

​

在这里可以看到，Kotlin的每行代码结尾是可以不加“；”的，加了也没问题

​

## 优点2. 对字符串的操作

​

这里拿对字符串的插值来说

​

### Demo

```
val x = 1
val y = 2
print("sum of $x and $y is ${x + y}")  //输出结果：sum of 1 and 2 is 3
```

在这里来说，Kotlin相当于有一个比Java中的字符串格式化函数(String.format())更加优秀的字符串函数

​

## 优点3. 类型判断与自动转换

​

Kotlin会根据代码逻辑对变量的类型进行推断

还会进行自动的类型转换

自动类型转换提高了代码的可读性，因为没有自动转换的话，需要人工进行转换，还会有很多instanceof进行检查

​

[这里](https://kotlinlang.org/docs/reference/properties.html)是官方文档

​

### Demo

​

```
val a = "abc"                         // String
val b = 4                             // Int

val c: Double = 0.7                  //明确声明c为Double型
val d: List<String> = ArrayList()    //明确声明d为字符串型List

if (obj is String) {
    print(obj.toUpperCase())     // obj 不确定是否为String型
}
```

​

## 优点4. 直观的相等比较

​

在Kotlin中不像Java调用equals()函数那么麻烦。

它可以直接对字符串进行比较

​

### Demo

```
val y1 = Person("Ying")
val y2 = Person("Ying")
y1 == y2     // true  (结构相等)
y1 === y2    // false (参照相等)
```

​

参照相等: ===： 就是判断a, b是否为同一对象。也可以使用内联函数identityEquals() 判断参照相等。

​

结构相等: ==：  判断的。a, b的值是不是一样的，相当于y1.equals(y2)。

​

## 优点5. 默认参数 和 命名参数

​

不再使用不同的参数来定义类似的构造器：

​

结合默认参数值，命名参数可以消除 builders 的使用: 

​

### Demo

```
fun build(title: String, width: Int = 800, height: Int = 600) {
    Frame(title, width, height)
}

build("Ying", 400, 300)
build(title = "Ying", width = 400, height = 300)  
build(width = 400, height = 300, title = "Ying")
```

​

## 优点6. switch->When

switch 替换成了 when ，代码更具可读性：

​

### Demo

```
when (x) {
    1 -> print("x is 1")
    2 -> print("x is 2")
    3, 4 -> print("x is 3 or 4")
    in 5..10 -> print("x is 5, 6, 7, 8, 9, or 10")
    else -> print("x is out of range")
}
```

​

下面的case既可为表达式，也可用作语句，也可作用于null：

```
val res: Boolean = when {
    obj == null -> false
    obj is String -> true
    else -> throw IllegalStateException()
}
```

​

## 优点7. 属性的getter和setter

直接在属性后面就可以生成getter和setter

​

### Demo

```
class Frame {
    var width: Int = 800
    var height: Int = 600

    val pixels: Int
        get() = width * height      //geter
}
```

​

## 优点8. Data类

Data类这是一个POJO(Plain Ordinary Java Object)简单的Java对象，其中包含toString()，equals()，hashCode()和copy()等方法，与Java不同，它占用的代码量少了很多

​

### Demo

```
data class Person(val name: String,
                  var email: String,
                  var age: Int)

val john = Person("Ying", "yzk.1314@outlook.com", 19)
```

​

## 优点9. 操作符重载

重载操作符提高代码可读性

​

### Demo

```
data class Vec(val x: Float, val y: Float) {
    operator fun plus(v: Vec) = Vec(x + v.x, y + v.y)
}

val v = Vec(2f, 3f) + Vec(4f, 1f)
```

​

## 优点10. 解构

一些对象可以被解构，如对Map进行迭代

​

### Demo

```
for ((key, value) in map) {
    print("Key: $key")
    print("Value: $value")
}
```

​

## 优点11. 变量范围

为了程序可读性而诞生

​

### Demo

```
for (i in 1..100) { ... } 
for (i in 0 until 100) { ... }
for (i in 2..10 step 2) { ... } 
for (i in 10 downTo 1) { ... } 
if (x in 1..10) { ... }
```

​

## 优点12. 扩展函数

向已有的类里添加新的函数

[这是](https://kotlinlang.org/docs/reference/extensions.html)官方文档

​

### Demo

```
fun String.replaceSpaces(): String {
    return this.replace(' ', '_')
}

val formatted = str.replaceSpaces()
```

这样就拓展了原来的String类

```
str.removeSuffix(".txt")
str.capitalize()
str.substringAfterLast("/")
str.replaceAfter(":", "classified")
```

​

## 优点13. null安全机制

Java是一个几乎静态类型的编程语言。Java的String变量类型在一些情况下会等于null，导致程序猿总是要担心NullPointerException。

​

Kotlin的类型默认是不允许为空的，但是可以通过在后面加一个(?)问号来表示允许为空，例如：

```
var a: String = "abc"
a = null                // 编译报错

var b: String? = "xyz"
b = null                // 编译通过
```

​

当你访问一个可能为空类型的时候，Kotlin会编译报错，除非加上一个检查机制

如：

```
val x = b.length        // 编译报错： b可能为null
---------------------------------
if (b == null) return
val y = b.length        //编译通过
```

​

也可以使用安全调用(?)，这样该表达式在 b 为空时返回null，而不是抛出空指针异常：

```
val x = b?.length       // x为可空的Int型
```

​

安全调用(?)问号可以进行套用，以避免像其他语言一样存在大量嵌套的if-not-null检查。

如果我们想要一个非null外的默认值，可以用 “?:”操作符

```
val name = ship?.captain?.name ?: "unknown"
```

​

如果上面你不想用的话，你刚刚又有不明确的要求，那只有抛出异常

```
val x = b?.length ?: throw NullPointerException()
val x = b!!.length              //和上面一样
```

​

## 优点14. 更好的 Lambdas

语法简单直接，如：

```
val sum = { x: Int, y: Int -> x + y }   // 相当于 sum = {(Int, Int) -> Int}
val res = sum(4,7)                      // 相当于：res == 11
```

​

Kotlin的Lambdas表达式优点体现在：

如果lambda表达式是方法的最后一个参数或者是唯一参数的话，那么该方法的括号可以移动或者省略.

如果我们选择不去声明单参数的lambda表达式的参数，那么Kotlin会隐式的将其命名为it.

所以说，下面的代码效果是一样的：

```
numbers.filter({ x -> x.isPrime() })
numbers.filter { x -> x.isPrime() }
numbers.filter { it.isPrime() }
```

​

还可以让你的代码更漂亮

如：

```
persons
    .filter { it.age >= 19 }
    .sortedBy { it.name }
    .map { it.email }
    .forEach { print(it) }
```



好了，上述就是笔者要说的一些优点，当然还有很多优点或一些确定是没说的，这就等着我们明晚和鹅厂的dalao们一起探讨吧！