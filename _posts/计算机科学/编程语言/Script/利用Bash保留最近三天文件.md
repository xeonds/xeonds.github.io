---
title: 利用Bash保留最近三天文件
tags:
  - Linux
  - shell
excerpt: bashの花式用法
toc: true
author: xeonds
date: '2022.04.21 14:39:07'
categories:
  - 计算机科学
  - 编程语言
  - Script
---
这东西用来清log和冗余备份确实好用。

清文件夹记得把-f换成-rf。

```bash
find [target file in path] -mtime +2 |xargs rm -f
```
