---
title: Flutter速通指南
date: 2023-09-16 16:34:35
author: xeonds
toc: true
excerpt: Presented by BenderBlog/SuperBart，感谢学长带咱入坑(OwO)
tags:
    - Flutter
---

2023 XDU-OSC Community - Presented with love by BenderBlog/SuperBart

借助Flutter，他重新实现了校内十分流行的工具软件电表，使得用iOS的同学也有了自己的电表可用。开源和Flutter带来的，对于开发工作的简化~~以及SuperBart的超级肝力~~都成为了它能迅速上架iOS并迅速迭代的原因。

原生的电表iOS版本使用了iOS Native开发，在开发效率上略低于先天统一了不同平台实现的Flutter。在运行效率上的提升在业务都相对比较简单的情况下并没有很显著的优势。

其实上面这点也是现在原生客户端开发面对的问题。原生带来了更细致入微的操作粒度，带来更极致的原生性能利用率的同时，对于开发者心智的负担要求很高，也对开发者的能力深入性和熟练度提出了很高的要求；应对这一点的解决方案，有使用Web技术统一全端（就是性能问题和资源利用率一直饱受诟病），也有使用像Flutter这样的混合跨平台框架。后者性能损失相对没那么严重，跨平台能力也相对不错，但是动态程序的本质让它对于低性能设备的友好度较低（比如现在的百度贴吧客户端就是Flutter客户端，面对长列表的加载等场景偶尔会出现崩溃等问题）。

开发效率和程序运行表现基本是一对负相关的参数，其中的取舍就是开发者需要考虑的问题。在程序开发领域，没有银弹。

## SuperBart的讲座

### Flutter概要

一套代码 (`./lib`), 多平台运行.

>android, windows, linux, ios等.

- 面向客户端
- 平台无关
- 上手简单

Flutter的开发语言是Dart，初见印象：Dart= JS/C++(语言友好度和性能上) + Java(代码风格上) + Dart VM

### Basic code format

tldr

- Empty safety: `type?` means var is nullable

This will trigger empty check, avoid npe

- late init

Just like Kotlin

- Async

### Basic layouts

- Widget
- Text
- Warp
- Row-Column
- Container

### Basic scaffolds

- AppBar
- Action
- TItle
- TabBar
- Body
- BottomBar

### Network

Mainly using `Dio`

## 使用笔记

### 关于WebViewWidget

这玩意比较坑的一点是它只支持Android和iOS平台，对于Windows/Linux/Web平台，这玩意都是不支持的。。

所以review同学的代码的时候，发现在我用Linux平台跑的时候报错了。搜了下才发现这问题。

不过也无所谓了，反正这玩意本来就只是在Android/iOS上跑的。
