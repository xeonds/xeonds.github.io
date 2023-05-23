---
title: Win10删除此电脑中多余图标
tags:
  - Windows
excerpt: 转载。
toc: true
author: xeonds
date: '2021.07.20 12:16:24'
categories:
  - 计算机科学
  - 操作系统
  - Windows
---

>原文地址：<http://mip.xitongcheng.com/jiaocheng/win10_article_11699.html>

具体方法

　　1、按WIN+R调出运行，然后输入 regedit 回车，打开注册表编辑器。

　　2、在注册表中定位到：HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace项。

　　3、选中“NameSpace”后，在右键窗口中删除所有值。

　　4、退出注册表后，此电脑中多余图标消失。
