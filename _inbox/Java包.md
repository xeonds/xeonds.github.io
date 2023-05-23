---
title: Java包
date: 2023.02.26 12:04:54
author: xeonds
toc: true
excerpt: NULL
---

## 包的声明

在源文件最开始作包声明：

```java
package com.test.testpackage

...
```

也可以不提供包声明，这就是使用默认包。通常不推荐。

源文件的路径必须匹配包名称，比如上面的源文件需要被存储在`com/test/testpackage`下。随后，在包的根目录下使用`javac [完整目录]/文件名.java`编译源代码，生成的`.class`文件会被放置在源代码的同级目录中。

运行程序需要使用完整包名+类名。

>使用`javac xxx -d xxx`可以将`class`文件放在独立目录，不会扰乱源码目录，且`class`文件也会有正确的目录结构

## 类路径

```java
jar cvf library.jar com/test/testapp/*.class
```

这样可以将类库打包，便于其他人使用。jar也可以用来打包程序

```java
jar cvfe program.jar com.test.testapp.MainClass com/test/testapp/*.class*
```

然后这样运行程序：

```java
java -jar program.jar
```

使用类库的jar文件时，需要指定class path告诉编译器和虚拟机这些jar文件在哪里。class path可以包含：

- 包含class文件的目录
- jar文件
- 包含jar文件的目录

javac和jar都有`-classpath`（简写为`-cp`）选项。例如：

```java
java -cp .:../libs/lib1.jar:../libs/lib2.jar com.test.MainClass
```

在Windows中，需要把上面的冒号换为分号。也可以使用通配符包含所有文件：

```java
java -cp .:../libs/\* com.test.MainClass
```
可以添加manifest文件，来防止其他代码被加入到包中

```
//filename: manifest.txt
Name: com/myapp/util/
Sealed: true
Name: com/myapp/misc/
Sealed: true
```

然后使用下面的jar命令添加manifest：

```
jar cvfm library.jar manifest.txt com/myapp/*/*.class
```

