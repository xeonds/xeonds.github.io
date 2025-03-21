---
title: IoT-go开发手记
date: 2024-10-19 12:26:22
author: xeonds
toc: true
excerpt: 创造即我之生命
tags:
---

## 介绍

有一回感冒发烧懒得下床关灯，最后还是舍友帮忙关了。甚至电脑都能用ssh借助局域网关机，但是灯就是不行。没办法，那会想起来了老早之前咕咕的物联网系统evs，这回打算把这玩意整完。

## 设计

本来一开始是打算做基于http/mqtt的方案的，但是一方面mqtt不太好和服务端集成，另一方面http在公网环境完成双向通信不太容易，所以最后就选定了全量weboscket+http restful api的方案作为系统的通信架构。

## 日志

另外很头疼的一点是局域网下的设备自动发现。本来是想用mDNS完成这个功能的，但是不知道为什么，esp8266作为客户端始终无法发现局域网中作为局域网服务器的mDNS服务端，明明无论是用flutter开发的安卓app还是用go开发的esp8266的原型验证模拟器都没有任何问题。

更新：发现原来ESP8266甚至没有发mDNS查询包的原因了，居然是得先`MDNS.begin()`一下。这一点我倒是怀疑过，但是跟ChatGPT确定之后告诉我这个对于mDNS查找来说不是必要的，坑的我去看了一下这玩意的源码，发现每次执行基本都是秒返回，但是函数说明里说明了是阻塞的调用。最后发现有个flag，函数调用开始会先检查这个flag，如果flag==0的话函数就会直接返回。所以试着加上了`MDNS.begin()`，果然就好了。

话虽如此，也只是有了mDNS查询包而已。实际上如果去Wireshark里抓包看的话确实能看到请求包，但是ESP8266这边依然是发现不了服务端网关的。下面是抓包电脑网卡用的过滤条件：`ip.dst == 224.0.0.251 && udp.port == 5353`。同等情况下，使用mDNS发现网关的手机app还是能秒发现网关，所以问题应该还是出在ESP8266上。

>顺便抓包的时候发现我的pad一直在定期发送mDNS广播，看包的内容是Spotify发送的，就猜测应该是实现了什么协同服务。
>直到今天在手机上也装上Spotify，打开之后发现这玩意借助mDNS实现了局域网中设备的播放联动控制：在pad上放歌时可以在手机的Spotify中控制，同时可以切换播放输出设备。也是被小小震撼了一把，对比同行来说使用体验确实简洁干净又会有这么些小惊喜。

对于这个问题，感觉问题可能一方面出在服务端的mDNS广播是否标准，另一方面可能是ESP8266的mDNS广播库调用方式还是有点不太对。不管怎么说，只要解决了自动发现局域网服务端的问题之后，这个iot灯的项目应该就基本完成了。剩下的，就算不能自动控制亮度，能自动开关也够了。另一个问题就算对于手头这个灯，需要的可能不是一个pwm驱动板，而是一个dac驱动电路。如果要实现这个模块，那可能还得重新设计一个驱动器电路。

>之前搁油管看的那个模块化的板子挺不错的，拿来做原型验证应该挺爽的。

问题还是没有解决，感觉主要问题还是在ESP8266的库使用方法上。这玩意文档依托就挺难受的。
