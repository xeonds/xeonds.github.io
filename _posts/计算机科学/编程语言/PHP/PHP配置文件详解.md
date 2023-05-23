---
title: PHP配置文件详解
tags:
  - PHP
excerpt: 东西不大，里面的坑还不少
toc: true
author: xeonds
date: '2021.09.08 13:09:44'
categories:
  - 计算机科学
  - 编程语言
  - PHP
---

## data.timezone

顾名思义，时区。

一般设置为`"Asia/Shanghai"`，这样时间相关的函数就正确了。

>我用ksweb的时候遇到过这个问题，当时竟然没想着改一下php.ini试试
