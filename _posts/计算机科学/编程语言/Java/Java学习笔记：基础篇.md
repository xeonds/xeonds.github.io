---
title: Java学习笔记：基础篇
tags:
  - Java
excerpt: 《Java核心技术》的读书笔记。虽然现在用的是Kotlin，不过Java也是很有学习必要的
toc: true
author: xeonds
date: '2022.01.11 18:34:40'
categories:
  - 计算机科学
  - 编程语言
  - Java
---

# 序言

说起来，自从学完了C语言，很久都没有成系统地学完一门编程语言了。

Python和PHP比较简单，基本都是边用边查学完的；Kotlin则是最近学Android开发顺便学的；C++倒是系统看过一遍书，不过最近基本没咋写过，忘的也差不多了；C#好久之前学的了，也就是写UWP的时候学了一点；JS？好像会，又好像不会（

快寒假了，也该摸点鱼了。梳理一下：Android学了大半，ML/DL没碰，Unity还在新建文件夹，算法就看了一点点。仔细想了想，还是先学点Java吧，一来下学期要学，二来和Android开发联系也紧密。最重要的是，这次得认真学学面向对象了。虽然在Python和PHP里都在用，但是终归还是系统学习一遍为上。

我用的是《Java核心技术》卷一/二。很多人在推荐，试读了一下，感觉不错，不像黑皮系列那么难读，废话也比较少。

# Java简介

官方白皮书给出了如下关键字：简单性（接近C++）、面向对象（支持多重继承）、分布式、健壮性（优秀的指针模型）、安全性（复杂的安全模型）、体系结构中立（Java虚拟机）、可移植性（众多平台独立的Java库）、**解释型**（轻量的编译过程）、高性能（即时编译器）、多线程、动态性。

>虽然关键字里有“解释型”，然而Java是真正的编译型语言。

虽然说Java是纯粹的面向对象语言，不过它并没有做到完全的面向对象：int，double等基本数据类型仍然不是对象。不过同样基于JVM（Java虚拟机）的Kotlin做到了完全的面向对象。

# Java环境配置

* 在Windows下，访问[Oracle官网](https://www.oracle.com/java/technologies/downloads/)，下载JDK（Java Development Kit）后安装，并将`jdk/bin/`目录加入环境变量（详情百度）即可。

* Linux使用相应的包管理器（apt，yum等）直接安装即可。

安装完成后，可以安装库源文件：找到`jdk/lib`目录，将`src.zip`解压到`jdk/javasrc/`目录下即可。同时也可下载官方文档，在官网上能找到。

# JDK基本使用

打开记事本（或其他文本编辑器），写入以下内容：

```java
public class Hello
{
    public static void main(String[] args)
    {
        String greeting = "Hello, world!";
        System.out.println(greeting);
        for(int i=0;i<greeting.length();i++)
            System.out.print("=");
        System.out.println();
    }
}
```

另存为`Hello.java`并打开`cmd`并切换到当前目录。在`cmd`中输入以下内容以编译并运行：

```bat
javac Hello.java
java Hello
```

这是我们的第一个程序。掌握基础操作后，你可以使用你喜欢的IDE进行开发。我偏向使用VSCode（理论上Android Studio应该也可以）。

# Java基本内容

## 程序结构

Java程序是以类为单位的，类则是一种自定义数据结构（类似于C中的结构体struct）。上面的程序包含了一个public类型的class（类），Hello是这个类的类名，这名称需和文件名同名。和C语言一样，Java也是大小写敏感的。习惯上将类名的每个单词首字母大写。

这个类中包含了一个main方法（也就是函数），作为这个Java程序的运行起点。这个方法中包含了该程序的所有逻辑，和C非常相似。

## 注释

Java注释和C/C++基本一样，支持`//`和`/*`、`*/`，同时也支持另一种：

```java
/**
*这是一个注释
*它可以自动生成文档
*/
```

后两种都不能嵌套。这和C/C++一致。

## 数据类型

Java是强类型语言。它共有8种基本数据类型：

* 整型：int（4字节）、short（2字节）、long（8字节）、byte（1字节）
* 浮点类型：float（4字节）、double（8字节）
* char类型
* boolean（布尔）类型

这些都是关键字，用于声明对应类型的变量。

关于整型，和C差不多，有几点要注意：Java没有无符号类型整数。在整数后加L或l表示long类型整数，前缀0X或0x表示16进制整数，前缀0B或0b表示2进制整数，前缀0表示8进制数。为了可读性，还可以用下划线`_`分割整数：例如`0b1111_0100`这样的形式都是合法的。

关于浮点类型，double的使用相较于float更精确。浮点数后缀有两种：F或f表示float类型，而D或d表示double类型。不加后缀默认为double类型。也可以用16进制表示浮点数值：由于0.125=2的-3次幂，故可表示成0x1.0p-3。同时，还有三个特殊的浮点数值：正无穷大，负无穷大，NaN（Not a Number，不是一个数字）。例如0/0的结果就是NaN。可用Double.isNaN()可以检测一个变量是否为数值。另外，浮点数值采用二进制系统表示，因而不能精确表示1/10。此时可以使用BigDecimal类作为替代。

关于char类型：char原本表示单个字符。不过如今部分Unicode字符需要两个char来表示。和C一样，单引号表示字符，双引号表示字符串，反斜杠表示转义符。另外，可以直接用诸如`\u2122`而不加引号的方式表示字符，比如：

```java
public static void main(String\u005B\u005D args)
```

也就是说，这种Unicode转义字符会在编译前被处理。因此**使用反斜杠时一定注意**。

关于boolean类型：C中没有布尔类型，而是使用int类型替代。Java中boolean类型只有true和false两个值。它和整数不能相互转换。这可以预防很多潜在的编程错误（例如`if(x=0)`在C语言中永远为假）。

Java的变量声明和C/C++基本一样，都是`关键字 变量名`的形式。同样可以在声明时对变量进行初始化（例如`int a=5`）。和C++一样，Java的声明可以在代码中的任何地方。用关键字final可以声明常量，这种变量只能被赋值一次。final就相当于C中的const关键字（const也是Java的关键字，不过Java并没有用它）。常量名一般习惯全部大写。常量也可以声明在main外部，类内部，使用关键字static final即可：

```java
public class Example
{
    public static final int DAY_OF_WEEK = 7;
    ...
}
```

## 运算符

这和C/C++基本一致：`+ - * /`表示四则运算，`%`表示**整数求模运算**。对于除法，整数被0除会产生异常，而浮点数被0除则会得到无穷大或者NaN结果。

Java中有一个很有用的Math库，用来进行各种数学运算，并且还有一些数学常量。

* `Math.sqrt(x)`：返回一个*数值*的平方根
* `Math.pow(x,a)`：返回x的a次幂。参数x和a以及返回值都是double类型
* `Math.floorMod(x,a)`：返回x对a取余的结果。它的存在是为了修补%运算不能正确处理负数的问题：负数的模显然应该是正数
* `Math.sin/cos/tan/atan/atan2`：常用三角函数
* `Math.exp/log/log10`：指数函数和它的反函数，以及以10为底的对数
* `Math.PI/E`：两个近似表示π和e的常量

在源文件顶部加上这行代码，就可以省略这些方法/常量的Math.前缀了：

```java
import static java.lang.Math.*;
```

数据类型转换和强制类型转换，和C/C++基本相同。此外，Java还有`Math.round`方法，可以对浮点数进行四舍五入：

```java
double x = 9.997;
int nx = (int)Math.round(x);
```

由于`Math.round`返回的是long类型，所以需要用`(int)`显式转换，避免数据丢失。

和C/C++一样，Java也有`+=`,`-=`,`*=`,`/=`和`%=`这几个结合赋值和运算符的运算符。左右数据类型不同时会发生强制类型转换，将运算结果转换成左值的类型。自增，自减运算符和C/C++完全一样，不需要说明。

Java中的逻辑运算符和C/C++一致，且支持短路特性。Java也支持三目运算符`?:`。下面的表达式``

```java
x>y?x:y;
```

返回`x`和`y`中较大的值。

位运算符有`& | ^ ~`四个，分别表示与，或，异或，非。利用位运算我们可以获得一个整数的各个位，也就是掩码技术。另外它的运算对象如果是布尔类型，则返回值也是布尔类型，但这种方式不使用路求值。

`<<`和`>>`是移位运算符，用法和C/C++一样：将左值左移/右移右值相应的位数。`>>>`会用0填充高位，而`>>`会用符号位填充高位。没有`<<<`运算符。

枚举类型包括有限个命名的值，例如

```java
enum Size{SMALL, LARGE};
Size s = Size.LARGE;
```

## 字符串

Java字符串就是Unicode字符序列。Java没有内置字符串类型，而是在标准Java类库中提供了一个String预定义类。每个用双引号括起来的字符串都是String类的一个实例：

```java
String e = "";
String greeting = "hello";
```

* `substring`方法可以从一个较大的字符串提取出一个子串：

```java
String greeting = "hello";
String s = greeting.substring(0,3);
```

`s`是一个由"hel"组成的字符串。这方法表示从第0个字符开始，复制到第三个（不包括）为止。

* `+`用来连接字符串。非字符串值被应用于这个操作符时，会被转换成字符串类型。**任何一个Java对象都可以转换成字符串。**如果需要用定界符分隔并连接，只需要用`String.join`静态方法：

```java
String s = String.join(",","a","b","c");
```

上面的`s`为`a,b,c`。

Java的String类对象被称为**不可变字符串**，也就是说一旦创建String对象，就不能对其进行修改。

利用`String.equals`方法检测两个字符串是否相等。例如`s.equals(t)`，返回`s`和`t`的比较结果。这里的`s`和`t`可以是字符串实例，也可以是字符串字面量。

`char`类型在Java中并不是很常用，因为现在很多字符需要两个char类型存储单元才能表示。因此尽量不要用`char`类型。

下面是常用的String类的方法：

* `boolean equals(Object other)` 字符串比较
* `boolean equalsIgnoreCase(String other)`  字符串比较，忽略大小写
* `boolean startsWith(String str)` 判断字符串是否以`str`开头
* `boolean endsWith(String str)` 判断字符串是否以`str`结束
* `int length()` 返回字符串的长度
* `String substring(int begin)`
* `String substring(int begin, int end)`
* `String toLowerCase()`
* `String toUpperCase()`
* `String trim()` 返回删除左右空格的字符串
* `String join(CharSequence delimiter, CharSequence... elements)` 就是上面的`String.join`方法

构建字符串时，可以用`StringBuilder`类避免每次都新建一个String对象，节省空间：

```java
StringBuilder sb = new StringBuilder();
sb.append(ch);　　//添加一个字符ch
sb.append(str);　　//添加一个字符串str
String completedString = sb.toString();　　//完成后的字符串
```

下面是`StringBuilder`类的方法：

* `StringBuilder()` 构造器
* `int length()`
* `StringBuilder append(String str/char c)` 追加字符串/字符并返回`this`
* `StringBuilder insert(String str/char c)` 插入字符并返回`this`
* `StringBuilder delete(int start, int end)` 删除`start`到`end`（不包括end）的代码单元并返回`this`
* `String toString()` 返回一个内容相同的字符串

## 输入输出

输入基于`Scanner`类。首先得声明Scanner对象，并与标准输入流System.in关联：

```java
Scanner in = new Scanner(System.in);
```

随后就可以使用`Scanner`类的各种方法实现输入操作了。比如：

```java
System.out.print("input your name:");
String name = in.nextLine();
```

要使用`Scanner`类，需要在**源码开头**导入`java.util.*`

```java
import java.util.*;
```

下面是Scanner类的方法：

* `Scanner(InputStream in)` 用给定的输入流创建一个Scanner对象
* `String nextLine()` 读取下一行输入的内容
* `int nextInt()` 读取下一个整数
* `int nextDouble()` 读取下一个整数或浮点数
* `boolean hasNex()` 检测输入中是否还有其他单词
* `boolean hasNextInt()`
* `boolean hasNextDouble()`

用Scanner类进行格式化输出非常简单。使用`System.out.print()`方法可以直接输出`x`，用`System.out.printf()`可以格式化输出字符串。它的用法和C中的`printf()`完全一致。同时还新增了一些标志。详见*用于printf的标志*。同时，printf支持输出格式化日期与时间，但它已经被废弃（Deprecated），应当使用`java.time`包的方法。

此外，也可以使用`String.format()`静态方法创建一个 格式化的字符串而不输出：

```java
String message = String.format("Hllo, %s. Next year, you'll be %d", name, age);
```

Scanner类也支持文件输入输出：

```java
Scanner in = new Scanner(Paths.get("myfile.exe"), "UTF-8");
```

文件名中包含反斜杠的话，则需要再多添加一个反斜杠转义。另外，其中的`UTF-8`可省略，缺省值为运行  该程序的机器的默认编码。不过为了兼容性尽量不要这么做。还有，路径支持相对路径，不过位置是相对于Java虚拟机的启动路径而言的：即命令解释器的当前路径。也可以用下面的方式得到路径位置：

```java
String dir = System.getProperty("user.dir");
```

## 流程控制

Java中也有块（block）的概念。大多数内容都和C一致，除了嵌套的块中不能声明重名变量。下面说一下流程控制语句：

* `if-else if-else` 和C一样
* `while/do-while` 和C一样
* `for` 和C一样。不过添加了一种for each循环
* `switch` 和C一样。不过从Java SE 7 开始，case标签可以是字符串字面量
* `break` 后面可以带标签，用法和C中的goto一样。不过只能跳出语句块而不能跳入
* `continue` 和C一样

## 大数值

java.math包中有BigInterger和BigDecimal两个类，分别表示任意精度的整数和浮点数。使用静态方法valueOf()将普通数值转换成大数值：

```java
BigInterger a = BigInterger.valueOf(100);
```

然而因为Java没有提供运算符重载，所以不能用`+-*/`来进行大数的四则运算，只能使用它们的`add subtract mulyiply divide mod compareTo`方法进行加减乘除以及求模、比较运算。

## 数组

和C差不多。不过`[]`得写在数据类型后而非变量名后：

```java
int[] a;
a = new int[100];
int[] b = {1,2,3,5,7}
a = {4,5,6,7}
int[] d = new int[0]; //允许数组长度为0
```

可以用`a.length`获取数组a的长度，其余的用法和C无异：数组长度也是不可变的。如果需要长度可变则应该考虑使用`array list`。

数组除了可以用for循环遍历，也可以用for each循环遍历：

```java
for(value : collection) statement
//例如，对于int数组a而言：
for(int num: a){
    System.out.println(num);
}
```

不过，打印数组还可以用`System.out.println(Arrays.toString(a));`来完成。

和上面类似，用`Arrays.copyOf(array, length)`可以复制数组。

现在可以说说main()函数的参数`String[] args`了。这是一个参数数组，和C的argv参数基本一样。不过这里的args[0]指示的不是程序名，而是第一个参数。

使用Arrays.sort(a)可以对数组进行排序。Arrays还有很多方法：

* `Arrays.binarySearch(type[] a, type v)` 二分搜索值v，返回下标或负数值（若为未查找到）
* `Arrays.fill(typr[] a, type v)` 用v填充数组
* `Arrays.equals(type[] a, type[] b)` 数组比较，长度和对应位置的值都相等则返回true

多位数组使用这样的方式声明：`int[][] a = new int[100][100];` 赋值和迭代等都和C差不多，按照java中一维数组的情况类推即可。

---

好了，这些就是Java的基本内容了。下一节是关于Java的面向对象体系的介绍。
