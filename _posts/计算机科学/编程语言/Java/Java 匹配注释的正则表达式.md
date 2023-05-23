---
title: Java 匹配注释的正则表达式
date: '2022.11.22 19:30:53'
author: xeonds
toc: true
excerpt: Java
categories:
  - 计算机科学
  - 编程语言
  - Java
tags:
---

参考[http://iregex.org/blog/uncomment-program-with-regex.html](http://iregex.org/blog/uncomment-program-with-regex.html)

通用注释有两种:

1. `//`

2. `/*......*/`

通常情况下，行级注释可以这样匹配

```java
\/\/[^\n]*
```

块级别这样

```java
\/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
```

或者还可以这样

```java
\/\*(\s|.)*?\*\/
```

不过在特殊情况中，行级别会跟协议前缀冲突，所以还需要特殊处理

```java
(?<!http:)\/\/.*
```

甚至于不限定于http协议

```
(?<!:)\/\/.*
```

最终处理注释为：

```groovy
/*** 处理注释 groovy代码  
* @param text  
* @return     
***/  
def removeComment(text) {
	return text.replaceAll("(?<!:)\\/\\/.*|\\/\\*(\\s|.)*?\\*\\/", "")  
}
```