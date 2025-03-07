---
title: OpenWRT折腾笔记
date: 2024-07-01 03:54:58
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

## 多播

> ref: [单线多拨在OpenWrt系统中的实现方法 - 路由智态](https://www.red-yellow.net/%E5%8D%95%E7%BA%BF%E5%A4%9A%E6%8B%A8%E5%9C%A8openwrt%E7%B3%BB%E7%BB%9F%E4%B8%AD%E7%9A%84%E5%AE%9E%E7%8E%B0%E6%96%B9%E6%B3%95.html)

- 在openwrt网页删除原来的wan网口，记住网口对应的接口
- ssh到路由器，用命令创建接口的vlan（想拨几个创建几个接口）并启动
- 到openwrt网页从那几个vlan创建对应的wan_n，并给这几个vlan设备设置不同的metric（我这边不知道怎么会是翻译成“跃点“了）
- 完事，设置负载均衡

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
