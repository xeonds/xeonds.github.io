---
title: Ubuntu下禁用Apache浏览
tags:
  - Linux
  - Apache
excerpt: 让别人知道你的网站目录结构直接查看你目录下的所有文件是很危险的一个事情。
toc: true
author: xeonds
date: '2020.12.20 17:28:00'
categories:
  - 计算机科学
  - 操作系统
  - Linux
---

## 禁止目录浏览

让别人知道你的网站目录结构直接查看你目录下的所有文件是很危险的一个事情。所以一般我们会关闭Apache的这项功能。  
下面是步骤（对于Ubuntu）。

1.打开apache2配置文件

```
vim /etc/apache2/apache2.conf
```

2.找到如下位置中的 Options Indexes FollowSymLinks 注释掉并在其下一行添加 Options None，如下图
![](http://mxts.jiujiuer.xyz/files/picture/apache-disable-ls.png)  
3.保存后重启apache2

```
/etc/init.d/apache2 restart
```

4.再次访问目录会出现禁止浏览目录的提示
![](http://mxts.jiujiuer.xyz/files/picture/apache-disable-ls-2.png)

## 禁止特定类型文件访问

打开apache2配置文件：

```bash
vim /etc/apache2/apache2.conf
```

在最后新增以下内容：

```bash
#禁止.inc扩展文件的访问
#可根据实际需要替换成其他文件类型
<Files ~ "\.inc$">
   Order allow,deny
   Deny from all
</Files>
```
