---
title: 西电操作系统课程设计-PintOS
date: 2023-12-13 23:07:57
author: xeonds
toc: true
excerpt: 是个好Lab，认真做能实打实理解系统/编译器的相关知识。只有一点：辣鸡头哥狗都不用
tags:
---
## pre
上学期想自己做着玩玩，可惜你电大二下课程安排懂得都懂。不过还好这学期还有做这个实验的机会，那自然是要好好做一下的。

久闻大名，耗时+难度高。首先就一个配置环境就能难倒一堆小镇做题家，这个实验对于`gcc`的版本有[硬性要求](https://github.com/ryanphuang/PintosM/issues/1)，过新的版本引入的breaking changes会改变结构体中字符数组的初始化行为导致系统编译出错。

完成这个lab最重要的是有读文档和读代码的能力，资料我这里参考的是JHU的网站：<https://www.cs.jhu.edu/~huang/cs318/fall22/project/guide.html>

## src
在实现具体module前，更吸引我的，是它作为一个足够小的可用的操作系统的结构。这对于理解操作系统有不小的帮助。

## env
环境配置是其中一个很劝退的部分。gcc的每个大版本都遵循版本语义通用约定，都有一些breaking changes，而它的源码因为关于结构体的大小上有一些ub，所以只能依赖某版本号以前的gcc。

另外就是仓库中提供的工具集脚本，也依赖于特定版本的perl，因此perl也得使用特定版本。

鉴于本人主力系统是linux系，不可能改变主力机环境，所以上docker解决依赖问题。这里真得夸下容器，复杂点的包括`glibc`这样的版本依赖地狱也能通过容器化解决。

## project1-thread
项目中的第一个任务，一共有20+个check point。根据每个测试用例的代码细分，又能分成大致4-5个模块的代码。西电操作系统的课程设计大致就是完成这整个project。

## project2-userprogram

## misc
遇到的报错，记录一下。

### 宏`list_entry()`展开失败

报错内容：`dereferencing pointer to incomplete type 'struct semaphore_elem' "pintos"`

在我做 priority-condvar 时困扰了我好久。原因是因为C编译器找不到这个名叫`struct semaphore_elem`的结构体定义。排查之后发现是`JHU-PintOS`给的这个结构体的默认实现位于`synch.c`中，而编译器只默认索引`synch.h`导致找不到宏具体定义，和报错相符。

解决方法就是将`struct semaphore_elem`定义移动到`synch.h`中。

>遇到问题先理解报错是啥，再查找常见出错场景，最后要结合代码理解报错

另外这个宏确实是一个设计很巧妙的宏，通过宏的字符串把戏实现了通用链表元素到其所在数据对象的指针引用的查找转换功能，值得把玩~~甚至报错也是那么独特~~。
