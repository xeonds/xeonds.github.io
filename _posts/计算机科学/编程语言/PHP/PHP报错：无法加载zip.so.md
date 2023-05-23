---
title: PHP报错：无法加载zip.so
tags:
  - PHP
excerpt: 所以是为甚么呢（
toc: true
author: xeonds
date: '2022.04.22 22:46:01'
categories:
  - 计算机科学
  - 编程语言
  - PHP
---
解决方法很简单：将`/etc/php/7.4/mods-available/`目录下的`.ini`文件全部重命名为`.so`文件, 或删除对应的`*.ini`文件，如下：

```bash
cd /etc/php/7.4/mods-available/
sudo mv zip.ini zip.so
```

具体咋回事还不太清楚。网上还有另一种解决方法，是`sudo vim /etc/ld.so.conf`并增加一些内容，不过我这里似乎无效：

```
# 将/etc/ld.so.conf替换为如下内容
include /etc/ld.so.conf.d/*.conf
/usr/lib64
/usr/lib
/usr/local/lib
/usr/local/lib64
```
