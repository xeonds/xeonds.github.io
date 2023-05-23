---
title: Makefile学习笔记
date: 2024-03-10 00:39:49
author: xeonds
toc: true
excerpt: 值得一学的好东西
tags:
---
## 介绍
本质是一个带有**依赖管理**的**任务编排**工具，生产上是用于**软件项目构建**的重要工具，比较著名的例子有GNU/Linux的Makefile，将复杂的项目中间文件依赖以Makefile组织了起来，不光大大简化了构建过程，也使它能享受到make提供的，基于依赖关系的并行能力和构建状态管理（比如源文件没有改动就会跳过目标文件的构建）。

并且，Makefile本身支持include，因此也就具有了模块化管理的功能。而且，基于依赖关系的构建描述也使得项目的构建具有了一定的可维护性。

## 语法
### `.PHONY`
伪目标，其后跟随的目标无论是否源文件有改动都会强制重新执行。例如：
```
.PHONY: all test clean
```
当执行这三个指令时，无论源文件是否更改/存在，它们都会被确保执行。
## 参数

`-B, --always-make` Unconditionally make all targets.