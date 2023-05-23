---
title: 记一次ssh翻车
tags:
  - Linux
  - SSH
excerpt: 额......其实好久都没更文章就是这个原因qwq（阿里云背锅）
toc: true
author: xeonds
date: '2020.12.21 13:46:00'
categories:
  - 计算机科学
---

额......其实好久都没更文章就是这个原因qwq（阿里云背锅）  

大概是服务器[[SSH简介|ssh]]挂掉了，结果就一直不能进服务器。差一点都想直接重装了（

好在最后是修好了。下面记一下修复过程。

发现问题后，直接登阿里云控制台，发现提供了vnc可以用来应急救援。

登上，重装ssh。指令：

```
apt-get remove openssh-server openssh-client --purge

apt-get autoremove

apt-get autoclean

apt-get update

apt-get install openssh-server openssh-client
```

装完之后，切换到/etc/ssh/目录，用vim编辑配置文件sshd_config：

```
vim /etc/ssh/sshd_config
```

重启ssh服务：

```
service sshd restart
```

再次登录。成功，完美解决。~~拍照留念（~~
