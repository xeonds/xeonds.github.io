---
title: Linux虚拟文件系统笔记
date: 2025-02-24 17:55:10
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
这部分之前修电脑的时候接触过，说是linux内核会把一些内核的状态以vfs的形式映射出来，便于外部查看/更改。这个内部状态包括硬件的状态，进程的状态和更多的其他信息。

## reference

- [从 lsof 开始，深入理解 Linux 虚拟文件系统！-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1707084)
- [1. Sysfs — [野火]嵌入式Linux驱动开发实战指南——基于LubanCat-RK系列板卡 文档](https://doc.embedfire.com/linux/rk356x/driver/zh/latest/linux_driver/others_sysfs.html)