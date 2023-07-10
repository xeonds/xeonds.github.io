---
title: frp内网穿透搭建Minecraft服务器
tags:
  - Minecraft
  - Linux
excerpt: 我真傻，真的.mp4
toc: true
author: xeonds
date: '2022.06.29 01:05:34'
categories:
  - 游戏
  - Minecraft
cover: /img/79c2fe8bd08250e6505ed783980d3739.jpeg
---

## ~~原料~~

- [frp](https://github.com/fatedier/frp/releases/)：这次搭建服务器的核心工具
- 一台公网服务器：我用的是腾讯云。性能无所谓
- 一台跑mc服务端的电脑：我用的自己的台式机
- 一个公网域名：没有的话用服务器IP也行

## 准备

1.开放端口

Minecraft服务端需要开放`25565`端口，frp需要开放`7000`端口作为绑定端口，`8080`（或者其他闲置端口）作为http端口。如果需要监控面板的话还需要开放`7500`端口。

开放时，都选择`tcp`即可。

>上述端口都可以根据实际情况改变

2.下载文件

从上述frp链接到的GitHub release页面中下载你需要的版本。服务端和客户端是在同一个`tar.gz`文件中的，所以只需要下载你公网服务器和本地服务器对应的版本即可。

>后缀简介：i386:32位系统；amd64：64位系统；linux：Ubuntu等Linux系统；windows：Windows；arm32/64：arm版系统。按需下载即可。速度慢可以搜搜`GitHub加速`

## 配置

1.公网服务器：随便创建个目录，用`tar -zxvf [文件名]`解压文件。不会上传到服务器的自行百度`scp`。解压完成后保留`frps`和`frps.ini`即可。使用`vim frps.ini`编辑配置文件如下：

```bash
[common]
bind_port = 7000
vhost_http_port = 8080
token=114514     #客户端连接密码
#下面是监控面板的配置，不需要可以忽略
dashboard_addr=0.0.0.0
dashboard_port=7500     #监控面板端口。用[你服务器地址]:7500即可访问
dashboard_user=114514 #监控面板用户名
dashboard_pwd=114514 #监控面板密码
```

按`Esc`，输入`:wq`保存并退出。随后输入`screen -dmS frp-server ./frps -c ./frps.ini`并回车，创建一个名为`frps-server`的后台窗口并在其中开启`frps`服务端。

OK，`exit`退出连接即可。

2.内网服务器：按照其他的教程开启Minecraft服务器即可，具体搜索`Minecraft Java开服`。确保端口为`25565`，随后解压`frp`并保留`frpc`和`frpc.ini`并打开`frpc.ini`，编辑为：

```bat
[common]
server_addr = [你服务器的地址]
server_port = 7000
token=114514

[mcs]
type = tcp
local_ip = 127.0.0.1
local_port = 25565
remote_port=25565
```

保存退出。双击运行`frpc.exe`即可。

## 尾声

配好之后按理来说就能玩了。如果有报错的话请Google一下`frp+你的报错信息`，会有解决办法的。

啊不对重点不是这个......我们上面用了`screen`来做中转，这样每次重启服务器都需要手动开启服务很麻烦。可以用service一劳永逸解决这个问题：[查看本文，教你配置frp为service](https://juejin.cn/post/7042486792011907086)
