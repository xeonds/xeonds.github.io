---
title: Termux入坑指北
tags:
  - Linux
  - 工具
  - Android
excerpt: 一个安卓平台的linux模拟器。ssh，vim都没问题。
toc: true
author: xeonds
date: '2021.06.05 17:26:23'
categories:
  - 计算机科学
---

[Termux 0.101(内含数据包)](https://dreamweb.lanzoui.com/iFuq7jbi8ef)：点击下载。  
Termux，yyds

### 换源

系装好termux之后，第一步就是这个了。比较推荐的是清华源，稳定且快。  

可以使用`termux-change-repo`指令来在可视化界面手动换源。tuna推荐这种规避风险的方法。  

但是我还是习惯第二种。只要复制的时候没漏字符就基本没问题。下面是官方给出的指令。

```
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list
sed -i 's@^\(deb.*games stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/game-packages-24 games stable@' $PREFIX/etc/apt/sources.list.d/game.list
sed -i 's@^\(deb.*science stable\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/science-packages-24 science stable@' $PREFIX/etc/apt/sources.list.d/science.list
apt update && apt upgrade
```

复制完，直接丢到termux里，回车，完事。

这里是[tuna的termux帮助页面](https://mirrors.tuna.tsinghua.edu.cn/help/termux/)。

### 配置快捷键和安装常用软件

常用软件的话，openssh vim zip tree screen基本就全了？快捷键的话配好了一个，后面丢上来。

这里。

```
bell-character=ignore  
extra-keys = [ \
['ESC','/','-','HOME','UP','END','PGUP'], \
['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','exit\r'] \]
```
