---
title: Win10使用命令行启动WiFi热点
tags:
  - Windows
excerpt: 自作聪明的Win10认为没网就不需要开热点......拨号上网也算没网？
toc: true
author: xeonds
date: '2021.12.29 18:33:02'
categories:
  - 计算机科学
  - 操作系统
  - Windows
---
使用管理员权限运行`cmd`，然后键入以下指令：

```bat
netsh wlan set hostednetwork mode=allow
netsh wlan set hostednetwork ssid=您想要的无线网络的名称 key=您想要设置的密码
```

然后在网络和Internet界面对新增的东西共享网络，再启动承载网络：

```bat
netsh wlan start hostednetwork
```

下面是一些常用指令：

```bat
#停止
netsh wlan start hostednetwork
#查看详情
netsh wlan show hostednetwork
```
