---
title: 在Wayland中使用无线副屏
date: 2024-05-04 11:58:02
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
  - Linux
  - Wayland
cover: /img/__frieren_fern_stark_himmel_eisen_and_1_more_sousou_no_frieren_drawn_by_gejiandenghuo__c621db12aa21b1d8723bd2938643025c.jpg
---

## 废话
之前在Windows上用过米全家桶，体验一般。这回回家带了电脑和板子，写分布式作业的时候突然想把板子当副屏用，但是让我切回Windows写代码还是饶了我吧QAQ

不过切成Wayland以后，基于xrdp的方法也没法用，还好有新的替代：krfb

> KDE: Krfb 桌面共享是一个可以让您与另一个在其他机器上的用户共享当前会话的服务器程序，他可以使用VNC 客户端来查看甚至控制桌面。

## 使用

截止2024.05.04，aur中的最新版在RVNC Viewer客户端连接时会崩溃，故本文使用`krfb-22.12.3-1-x86_64`。

首先将系统的PulseAudio切换为PipeWire：在Arch下运行
```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber
```
随后pacman会询问是否卸载PulseAudio，输入y回车即可。安装完成后，重启一次。

接着安装Krfb，因为我使用了历史的pkg包，所以
```bash
sudo pacman -U krfb-22.12.3-1-x86_64.pkg.tar.zst
```

现在就可以正常使用了。你可以使用这个配置试试：

```bash
krfb-virtualmonitor --name Pad --resolution 1920x1080 --password password --port 5900
```
现在打开板子上的VNC，连接电脑的IP试试吧。

![](img/Pasted%20image%2020240504123041.png)
## Ref
- [Android tablet as a second monitor - Manjaro Forum](https://forum.manjaro.org/t/android-tablet-as-second-monitor/114841/2)
- [Arch Linux 音频服务器从PulseAudio 切换到 Pipewire](https://tatsumin.dev/posts/switch-from-pulseaudio-to-pipwire/)
