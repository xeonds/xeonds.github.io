---
title: 用Docker开个MC服务器
date: 2023-06-07 21:26:19
author: xeonds
toc: true
excerpt: Docker真香.jpg
tags:
  - Docker
  - Minecraft
---

前段时间好好学了下Docker，于是想试着用它去部署一些比较麻烦的服务端。所以首先就是试试MC了，毕竟能实现服务端跟地图数据分离以及服务端自动化部署，便于迁移确实很爽。

虽然MC服务端的性能敏感性比较高，但是Docker+MC的性能问题比较小，因为基于KVM，虚拟化由内核支持，所以Docker性能开销相当小，日用基本可以忽略。

## 目标

部署好之后，目录下应该只有一个地图文件夹，一个服务端程序，以及一个明确指示了地图文件夹和服务端程序路径的dockerfile。如果使用docker-compose去实现包括mc服务端的外围功能（比如bluemap等地图功能，以及geyser这样的be兼容转换服务端），那也可以，不过得保证数据程序的分离，以及可维护、易于修改的特质。