---
title: Arch Linux折腾笔记
date: 2023-09-05 21:39:57
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
  - Linux
cover: /img/89596288_p0_master1200.jpg
---

## 安装

参考 Arch Wiki 或者参考这个简化版教程：<https://arch.icekylin.online/>。过程按照教程一步步折腾就ok，只要注意区分清楚各个分区，别不小心把数据分区给格式化了就行。联网是安装Arch的必须项，所以请保持网络畅通。另外，建议**安装镜像最好在安装完成后继续保留着**，应急情况下（比如滚挂了）可以用`arch-chroot`来应急重装内核之类的。

>至于Arch经常被吐槽滚挂了的原因，主要是源自Arch的更新策略比较激进，更新完成后，会直接删除老内核，比起一般的更新策略更容易出现依赖问题造成“滚挂了“。

桌面环境、cn源、透明代理之类的配置，也可以参考上面的教程。关于透明代理，也可以参考[这篇文章](https://blog.linioi.com/posts/clash-on-arch/)。

## 美化

这点上因人而异。我装了layan主题之后，再换个壁纸，装个latte就差不多了。我的原则是，美化差不多就行，但是前提是别影响到系统性能。

## 显示适配

单显示器的配置很简单，改下dpi缩放就基本ok。如果是多显示器的话，就会复杂一些。参考下面的公式：

```bash
# 假设HiDPI显示器的分辨率是AxB，普通分辨率显示器的分辨率是CxD 
# 并且外置显示器的缩放比率是ExF
xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning [C*E]x[D*F]+[A]+0 --scale [E]x[F] --right-of eDP-1
```

根据上面的公式来设置，基本上能搞定。当然，如果想调整的是内置HiDPI显示器分辨率，就得调整最后`panning`的A为Ax[A的缩放比率]。

## 参考链接

- [1] [Barry的笔记](https://nmgit.net/2020/139/)
- [2] [X11 多显示器配置：玩转 XRandR](https://harttle.land/2019/12/24/auto-xrandr.html)

## 启用外部ssh连接

如果想从外部连接到Arch的电脑上，只要安装了openssh就行。Arch默认不会启动`sshd`，所以我们得手动开启：

```bash
systemctl start sshd
```
## 在命令行连接Wi-Fi

在完成安装后，启动NetworkManager：

```bash
sudo systemctl enable --now NetworkManager
```

然后使用`nmcli`来连接Wi-Fi：

```bash
nmcli dev wifi list
# 后面的password部分不指定的话，会自动要求输入
nmcli dev wifi connect "SSID" password "password"
```

## 使用TimeShift备份系统

TimeShift是一个很好用的系统备份软件，特别是结合了btrfs之后，备份的体积比借助`rsync`时更小。

折腾系统时不时可能滚挂，这种时候有个定期创建的映像就很有用了。

```bash
sudo timeshift --list # 获取快照列表
sudo timeshift --restore --snapshot '20XX-XX-XX_XX-XX-XX' --skip-grub # 选择一个快照进行还原，并跳过 GRUB 安装，一般来说 GRUB 不需要重新安装
```

如果恢复后无法使用，用安装盘通过`arch-chroot`进去系统，然后手动更改`subvolid`来手动修复，或者直接删除`subvolid`：

```bash
# 获取subvolid
sudo btrfs sub list -u /
# 编辑,根据自己情况，修复
vim /etc/fstab
```

## 重启显示管理器（Xorg/Wayland）

```bash
sudo systemctl restart display-manager
```
