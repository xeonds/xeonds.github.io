---
title: Linux解决端口占用
tags:
  - Linux
  - 网络
excerpt: 有时候一些网络应用会启动失败，提示端口被占用。那么一般怎么解决呢？
toc: true
author: xeonds
date: '2021.01.01 13:44:00'
categories:
  - 计算机科学
  - 操作系统
  - Linux
---

有时候一些网络应用会启动失败，提示端口被占用。那么一般怎么解决呢？

#### 系统环境  

我的系统是Ubuntu20.04，其他Linux应该也大同小异。

#### 解决步骤  

就两步。先找到进程：  

```
netstat -anlp| grep 端口号
```

然后结束进程：  

```
kill -9 进程pid
```

完事儿。
