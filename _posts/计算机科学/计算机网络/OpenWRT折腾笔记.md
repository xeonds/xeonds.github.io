---
title: OpenWRT折腾笔记
date: 2024-07-01 03:54:58
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

## 疑难杂症

### OpenWRT拨号失败

今天换了OpenWRT，在WAN端口设置拨号后发现拨号失败，报错为`USER_REQUEST`。试了下[这个](https://jkboy.com/archives/44971.html)解决方案：强制给端口指定MAC地址之后，发现拨号成功了。。

具体操作：网络管理端启用ssh，通过ssh连接路由器后，执行下面的指令：

```bash
vi /etc/config/network
```

然后，在`config interface 'wan'`块的下面添加一行指派MAC地址：

```bash
    option macaddr 'a0:23:36:a8:8d:9e'
```

然后重启WAN端口，发现拨号成功。
