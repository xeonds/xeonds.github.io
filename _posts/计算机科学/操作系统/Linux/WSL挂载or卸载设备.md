---
title: wsl挂载or卸载设备
tags:
  - Windows
  - Linux
excerpt: wsl爽归爽，出了问题还得看文档。
toc: true
author: xeonds
date: '2021.06.05 16:38:26'
categories:
  - 计算机科学
  - 操作系统
  - Linux
---
转载自博客园。原链接:<https://www.cnblogs.com/marklove/p/11905833.html>

Windows Subsystem for Linux （WSL）挂载移动硬盘U盘 卸载 c d 盘
wsl命令行电子手册

<https://docs.microsoft.com/zh-cn/windows/wsl/reference>

<https://docs.microsoft.com/zh-cn/windows/wsl/reference?redirectedfrom=MSDN>

重装某系统

<https://www.cnblogs.com/wswind/p/9879539.html>

<https://www.bbsmax.com/A/rV57bgVEJP/>

WSL想通过移动硬盘处理一些数据，结果进去了无法发现移动硬盘，于是搜了好久也没有一个正确的解决办法，终于找到一个，现在贡献出来与大家共享。

WSL比起linux挂载硬盘简单一些。而且windows本身自己的硬盘位ntfs格式，所以移动硬盘感觉挂载要比单纯的linu下ntfs挂载更加稳定一些。个人感觉而已....无法验证。

假设你的移动硬盘在windows下显示为 G:\

1. 新建文件夹g

sudo mkdir /mnt/g

2. 挂载盘符g

sudo mount -t drvfs G: /mnt/g

3.大功告成。进入/mnt/g即可与windows下一摸一样。

4.弹出移动硬盘，这样才能在windows下正常弹出，否则是会一直占用的。

sudo umount /mnt/g
