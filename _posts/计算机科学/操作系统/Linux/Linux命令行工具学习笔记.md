---
title: Linux命令行工具学习笔记
tags:
  - Linux
  - 工具
excerpt: 除了非常灵活的Shell，Linux中还有很多其他好用的工具，它们一般随各个发行版本附带。这些工具从文件处理，文本处理到网络工具一应俱全。配合Linux的pipe等机制，可以帮我们构建起高效的命令行工作流。
toc: true
author: xeonds
date: 2023-03-20 19:51:19
categories:
  - 计算机科学
  - 操作系统
  - Linux
---

## ln-强大的软链接工具

常用用法：

```bash
ln –s 源文件 软连接文件
```

这可以帮我们把一个文件链接到另一个地方，类似Windows的快捷方式。

我一般会用它把正在开发的项目链接到nginx的目录下，来实时预览效果。
