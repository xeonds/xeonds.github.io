---
title: UWP安装包的获取
tags: Windows
excerpt: UWP是挺好，就是巨硬怎么又弃坑了（Macrohard老鸽子了
toc: true
author: xeonds
date: '2021.06.15 14:44:45'
categories:
  - 计算机科学
  - 操作系统
  - Windows
---

### UWP应用概述

>UWP即Windows 10中的Universal Windows Platform简称。即Windows通用应用平台，在Windows 10 Mobile/Surface/PC/Xbox/HoloLens等平台上运行，uwp不同于传统pc上的exe应用，也跟只适用于手机端的app有本质区别。它并不是为某一个终端而设计，而是可以在所有Windows10设备上运行。

UWP应用的安装文件后缀为`.appx`。

**所以这和只能在电脑上用......好像也没啥区别（？**

一般而言，`.appx`格式文件只能在Microsoft Store上下载。`.appx`**从正常途径**一般不能获取到。目前而言，我知道的获取途径有两个。

* Microsoft Store下载 + 工具抓包获取下载路径
* 用链接获取工具获取

这里先说下最简单的（也就是第二个）。

### 工具法获取链接

工具地址（在线页面，点开直接访问即可）：  
<https://store.rg-adguard.net/>

首先，我们进入[微软官网](https://microsoft.com)，点击搜索，输入要下载的应用，进入详情页。

![](file/img/uwp-down-1.png)

然后，复制详情页链接。

![](file/img/uwp-down-2.png)

接着，进入工具页，粘贴链接并点击对勾确认。默认选择RP就可以了。

![](file/img/uwp-down-3.png)

等待一会，出现链接后右键复制，完成后进入x雷下载即可。

![](file/img/uwp-down-4.png)

![](file/img/uwp-down-5.png)

接着，进入系统设置>更新和安全>开发者选项>打开开发人员模式。

![](file/img/uwp-down-6.png)

然后，打开下载目录。

![](file/img/uwp-down-7.png)

双击，直接安装。

![](file/img/uwp-down-8.png)

完事儿。

### 抓包法获取链接

懒得写了。刚好百度经验有人写了，就不多废话了。  

链接：[点击进入](https://jingyan.baidu.com/article/f71d6037df88c31ab641d139.html)

虽然百度很屑，不过还是离不开（摊
