---
title: OpenWRT折腾笔记
date: 2024-07-01 03:54:58
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

## 多拨

> ref: [单线多拨在OpenWrt系统中的实现方法 - 路由智态](https://www.red-yellow.net/%E5%8D%95%E7%BA%BF%E5%A4%9A%E6%8B%A8%E5%9C%A8openwrt%E7%B3%BB%E7%BB%9F%E4%B8%AD%E7%9A%84%E5%AE%9E%E7%8E%B0%E6%96%B9%E6%B3%95.html)

- 在openwrt网页删除原来的wan网口，记住网口对应的接口
- ssh到路由器，用命令创建接口的vlan（想拨几个创建几个接口）并启动
- 到openwrt网页从那几个vlan创建对应的wan_n，并给这几个vlan设备设置不同的metric（我这边不知道怎么会是翻译成“跃点“了）
- 完事，设置负载均衡

## 负载均衡

- [openwrt 单线多拨及IPV6策略路由/分流/负载均衡 - 网络资源 - 宅...orz](https://zorz.cc/post/openwrt-macvlan.html)
- [OpenWrt的负载均衡及多线多拨控制应用mwan3 - 路由智态](https://www.red-yellow.net/openwrt%E7%9A%84%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8F%8A%E5%A4%9A%E7%BA%BF%E5%A4%9A%E6%8B%A8%E6%8E%A7%E5%88%B6%E5%BA%94%E7%94%A8mwan3.html)
- [多拨和负载均衡配置教程 | All about X-Wrt](https://blog.x-wrt.com/docs/xwan/)
- [如何设置OpenWrt多拨的负载均衡策略-xiaowei-极全网](https://www.jiqw.com/gj/31897.jhtml)
- [OpenWrt 路由器 MacVLAN+MWAN3 校园网多拨超详细指南](https://myth.cx/p/openwrt-macvlan-mwan3/)
- [OpenWrt 多拨负载均衡不起作用_openwrt负载均衡-CSDN博客](https://blog.csdn.net/qq_29997037/article/details/137808291)

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
