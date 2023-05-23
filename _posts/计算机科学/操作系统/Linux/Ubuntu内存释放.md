---
title: Ubuntu内存释放
tags:
  - Linux
excerpt: ……说实话，要不是我发现的早，我的服务器可能已经熟了（炸薯条×）
toc: true
author: xeonds
date: '2020.12.18 11:05:00'
categories:
  - 计算机科学
  - 操作系统
  - Linux
---
一日，在配置MCS Manager，忽觉服务器（运行）内存有些危。 于是打开百度，往询之。 答曰：“Ubuntu不会自动释放内存，需要手动释放。”余大惊，遂询其详。得一指令，曰：

```
 echo 3 >/proc/sys/vm/drop_caches
```

 待余输入而毕之，内存忽曾数倍有余。余直呼斯国矣（大雾）。

当然，还可以在crontab里添加自动任务，每隔5分钟运行一下，效果更持久（雾）

---

淦，手残把`vm`打成`mv`了
