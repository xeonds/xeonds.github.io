---
title: 东方STG魔改日志-1-解包
tags:
  - 东方project
  - STG
  - 魔改
excerpt: 又开新坑了（）这次，是关于正作的魔改（modification）教程。说是教程，其实应该说是像笔记一样的东西吧（
toc: true
author: xeonds
date: '2021.07.20 09:26:53'
categories:
  - 游戏
  - 东方Project
---

## 序言

之前，我发过一篇详细注释过的ECL脚本。当时是在做绀珠传的符卡魔改来着......不过已经咕了太久了。这次，我打算从头开始，详细记录一下魔改的相关知识。

## 关于魔改

魔改（modification），也就是mod，指的就是通过技术手段对程序进行修改，从而达到一些目的（比如东方正作STG的魔改，一般都是为了整活XD）。对[[東方Project：同人界永远的奇迹|东方]]的魔改，一般就是玩法拓展，贴图更换，弹幕创新之类的。

## 能改什么

东方正作STG能改的，主要是这几个：

* 贴图：比如立绘，背景，UI贴图之类的

* 对话：人物对话，也包括对话时bgm的切换，角色的出现消失之类的

* 弹幕：也就是boss，道中的弹幕。不光是弹幕，其实整个敌人的行为，都可以修改

* 机体：包括自机的火力数据，移动速度以及贴图等等。我之前做的那个“强拆地灵殿”其实本质上就是火力数据修改

* 音乐：不光包括bgm，也包括各种音效（比如擦弹音效，biu~之类的）

大多数魔改都是指上面的内容。当然，有些技术力高的dalao（比如鶸，Priw8，yuke等）也会魔改一些其他的东西。比如把地灵殿的魔B移植到绀珠传里，让画面看起来像滚筒洗衣机一样，让移动对象从自机变成画面等等。不过这些一般难度都比较高，需要用到汇编等知识，门槛也相对比较高。其他的一些，比如换贴图，是最简单的一类魔改。

## 怎么改

说了这么多，到底怎么改呢？以东方地灵殿为例，我就介绍下魔改的大概流程。

### 魔改对象

首先，我们得了解下原作的文件目录结构。

![](/img/mg-1-1.png)

这是东方地灵殿的目录。主要文件只有这几个：

* custom/custom_c.exe：这是游戏的设置程序。各种高级设置（比如图像质量之类的）都在这里修改。不过并不是核心程序。也就是说，没了它，游戏还能运行。

* th11/th11c.dat：我们魔改的核心对象。存储了所有贴图，对话，弹幕脚本，火力数据，音效文件，音乐循环点等关键信息。

* th11/th11c.exe：游戏本体。600多K的大小。也是魔改的一个重要对象，不过因为门槛比较高，所以现阶段就不过多介绍了。

* thbgm/thbgmogg.dat：游戏音乐。也就是酒鬼写的曲包。这个ogg是因为我为了精简游戏体积（便于传教XD），所以用工具压缩了音乐包的体积（毕竟原体积300+MB，实在太大了）。同时，有了专门修改过的d3d9.dll，这个压缩过的曲包才能被正确识别。也就是说，对于原版游戏，是没有d3d9.dll,曲包也是叫thbgm.dat的。

### 魔改工具

这篇文章，我只介绍怎么解包原作的文件（比如这作就是th11/th11c.dat）。所以用到的工具只有一个：Touhou Toolkit（thtk）。顾名思义，thtk是东方的工具包。详情可以上[GitHub看看](https://github.com/thpatch/thtk)。

不过注意，这个工具是没有GUI（图形界面）的，只能在命令行里用指令进行操作。所以入门相对而言会麻烦一些。好在有julao写了图形化的re_thtk_gui，便于使用。详情请看[这里](https://github.com/RUEEE/re_thtk_gui/)。

## 开始

* 打开工具，左上角菜单里选择正确的版本。在thdat选项组里找到第二行：文件路径。

* 点击右侧三个点，找到你的游戏目录，打开目录中th11/th11c.dat。

![](file/img/mg-1-2.png)

* 点击解包、获取文件列表，等待执行完毕。

* 完成后，打开游戏目录。你会看到新增了data文件夹。打开data文件夹，你会看到游戏的大部分资源，包括音效、贴图、ECL弹幕脚本等。

到这里还没有结束。因为只有音效是可以直接用的，其他的还是压缩状态。怎么办？很简单，用工具解包它们！

* 以thanm（即贴图）为例。对于后缀为.anm的文件，我们在工具的thanm选项组里找到第二行

* 和thdat的解包方法一样，点击右侧三个点，进入刚生成的data文件夹中，选择要解包的anm文件

* 点击解包、获取描述文件，等待完成

完成后，去data目录里看一看，是不是生成了一个ANM文件夹？它就是我们的解包成果。点开里面的目录，就是我们想要的贴图！

我们可以对贴图进行修改，然后先点击thanm的打包，再点击thdat的打包，生成打包好的th11/th11c.dat。打开游戏，就能看到你的成果了。

比如我一个改贴图的屑作：[【魔改】东方虹龙传（？](【魔改】东方虹龙传（？.md)，试图把六面变成纯狐（

## 结尾

掌握了基本的解包打包技术后，你就能通过替换贴图来实现初等的魔改了。想想能做什么有意思的事吧（
