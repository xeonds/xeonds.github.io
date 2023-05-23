---
title: Java 分割出字符串中的字母或数字
date: '2022.11.22 19:04:01'
author: xeonds
toc: true
excerpt: Java practice note. 以及这其实应该算到正则里。不过各种语言的正则都不太一样。
categories:
  - 计算机科学
  - 编程语言
  - Java
tags:
---

```
String name = "test001";
String zm = name.replaceAll("[^(a-zA-Z)]","" );  // 取出字母
String number = name.replaceAll("[^(0-9)]", "")   // 取出数字
```
