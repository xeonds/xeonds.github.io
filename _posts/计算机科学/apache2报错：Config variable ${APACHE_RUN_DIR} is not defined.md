---
title: 'apache2报错：Config variable ${APACHE_RUN_DIR} is not defined'
date: '2022.11.22 19:18:26'
author: xeonds
toc: true
excerpt: 这导入指令实际上就是Linux的环境变量修改方式
categories:
  - 计算机科学
tags:
---

报错信息：

```bash
[Sat Jan 21 21:01:16.273933 2017] [core:warn] [pid 3248] AH00111: Config variable ${APACHE_RUN_DIR} is not defined
apache2: Syntax error on line 80 of /etc/apache2/apache2.conf: DefaultRuntimeDir must be a valid directory, absolute or relative to ServerRoot
```

原因：升级后没有导入环境变量`envvars`文件，手动导入即可：

```bash
. /etc/apache2/envvars
# 或者下面这条也行
source  /etc/apache2/envvars
```