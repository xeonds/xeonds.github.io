---
title: ADB强制安装Debug安装包
date: '2022.11.22 19:13:19'
author: xeonds
toc: true
excerpt: 对于没有签名的程序使用该指令即可安装。
categories:
  - 计算机科学
tags:
---

```shell
adb install -t 
//规避（Failure [INSTALL_FAILED_TEST_ONLY: installPackageLI]）
```
