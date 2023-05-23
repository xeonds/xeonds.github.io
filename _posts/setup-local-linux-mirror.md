---
title: 如何搭建一个本地镜像源
date: 2023-10-16 23:23:51
author: xeonds
toc: true
excerpt: 来玩pocketchip(OWO)
tags:
---

最近好哥们沉迷pocketchip，但是苦于架构比较古老（ARM-V7a但是能跑Linux Mainline），所以镜像站特别稀少，只有个国外的站点还开着。所以嘛，闲着也是闲着，就打算自己搭建一个镜像站咯。

顺便还能好好玩玩那个ESXi服务器。毕竟现在就只跑了一个OpenWRT和一个Ubuntu Server，实在没利用起来（

或许回头整个本地镜像源还能试试刷新一下Arch安装速度记录（逃

## 准备

首先需要足够的硬盘空间和一个Linux计算机，以及差不多的网络环境。

然后是一些~~神秘妙妙~~工具：`apache2, debmirror, gnupg, xz-utils, rsync(recommend)`

## 开始

首先，因为同步的数据量会比较大，所以建议使用一块单独的硬盘或者看具体情况分个区都行。硬盘处理好后，可以将它挂载到`/mount/`下，随后创建我们的镜像站仓库目录们。

```bash
mkdir -p /mirror/debmirror/{amd64,keyring}
mkdir -p /mirror/scripts        # 各种镜像站工具脚本
```

随后安装GPG keyrnig：

```bash
gpg --no-default-keyring --keyring /mirror/debmirror/mirrorkeyring/trustedkeys.gpg --import /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

安装完成后，在Web服务器站点根目录创建符号链接：

```bash
cd /var/www/html
ln -s /mirror/debmirror/amd64 ubuntu
```

在这之后，我们还需要配置debmirror才能实现自动同步upstream等功能。

```bash
cd /mirror/scripts
wget https://louwrentius.com/files/debmirroramd64.sh.txt -O debmirroramd64.sh 
chmod +x debmirroramd64.sh
```

接着修改脚本设置：

```bash
export GNUPGHOME=/mirror/debmirror/mirrorkeyring
release=focal,focal-security,focal-updates,focal-backports,jammy,jammy-security,jammy-updates,jammy-backports
server=nl.archive.ubuntu.com
proto=rsync
outPath=/mirror/debmirror/amd64
#bwlimit=1000               # 设置rsync的带宽限速为1000KB/s，如果要启用这个限制，还需要取消注释下面的行：
--rsync-options "-aIL --partial --bwlimit=$bwlimit" \
```

完成后，你可以先运行一次脚本来完成第一次同步。**同步完成后**，再在crontab里边加上自动任务（不然你的同步进程时间过长，可能会干扰cron任务）：

```bash
0 1 * * * /mirror/scripts/debmirroramd64.sh
```

## References

>[Louwrentius - How to Setup a Local or Private Ubuntu Mirror](https://louwrentius.com/how-to-setup-a-local-or-private-ubuntu-mirror.html)
>[Debian - Setting up a Debian archive mirror](https://www.debian.org/mirror/ftpmirror)

