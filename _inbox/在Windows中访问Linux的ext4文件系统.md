---
title: 在Windows中访问Linux的ext4文件系统
date: 2023.05.23 16:04:41
author: xeonds
toc: true
excerpt: NTFS倒是能直接在Linux里访问，ext4怎么就不能在win里访问了，怪
---

大概查了一下，一个办法是创建个Linux的虚拟机挂载系统，然后共享给主系统。还有一个办法是，用WSL2直接挂载分区，分享给主系统使用。

第二种方法的教程在这里：[Get started mounting a Linux disk in WSL 2 | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/wsl2-mount-disk)