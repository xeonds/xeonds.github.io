---
title: GCC食用指北
tags:
  - C语言
  - 编译器
excerpt: GCC（GNU C Complier）是一个很强大的编译器。通过给它传递不同的参数，可以控制它完成不同的任务。
toc: true
author: xeonds
date: '2021.09.26 11:12:03'
categories:
  - 计算机科学
---

## 简介

GCC是源自GNU项目的一个开源[[C·C++|C/C++]]编译器。和它同样出自GNU的还有GNU/Linux。关于GCC的说明，如果你使用的是Linux，那么其实在安装的时候，它的使用手册也已经被释放到你的电脑上了。只需要键入

```bash
root@xeonds:~# man gcc
```

即可阅读它的使用手册（不过是全英文版的）。在文章最后，我会贴出我个人翻译的版本。

## 用法

一般用法很简单。只需输入：

```bash
root@xeonds:~# gcc hello.c
```

即可。如果没有报错，则不会有任何输出。此时会在当前目录生成`a.out`文件，即目标程序。

如果想更改目标文件的文件名，你还可以这么调用：

```bash
root@xeonds:~# gcc hello.c -o hello.exe
```

最终会生成`hello.exe`文件。

## 常见问题

### undefined reference to 'dlopen'

```bash
$ gcc DBSim.c
/tmp/ccEdvduQ.o: In function `main':

DBSim.c:(.text+0x38): undefined reference to 'dlopen'
DBSim.c:(.text+0x55): undefined reference to 'dlerror'
DBSim.c:(.text+0x9c): undefined reference to 'dlsym'
DBSim.c:(.text+0xb7): undefined reference to 'dlsym'
DBSim.c:(.text+0xd2): undefined reference to 'dlsym'
DBSim.c:(.text+0x15d7): undefined reference to 'dlclose'
collect2: error: ld returned 1 exit status
```

解决方案：

1. 头文件添加：`#include <dlfcn.h>`
2. 编译选项里加 `-ldl`  即：` gcc DBSim.c -o DBSim -ldl`

---

## 中文版文档（个人翻译）

**名称**

gcc - 源于GNU项目的C/C++编译器

**概要**

```
gcc [-c|-S|-E] [-std=standard]
    [-g] [-pg] [-Olevel]
    [-Wwarn...] [-Wpedantic]
    [-Idir...] [-Ldir...]
    [-Dmacro[=defn]...] [-Umacro]
    [-foption...] [-mmachine-option...]
    [-o outfile] [@file] infile...
```

只有最常用的选项被列出；其余选项请参阅后文。 **g++**接受和**gcc**几乎相同的选项。

**描述**

当你调用GCC时，它通常会进行预处理，编译，汇编和链接操作。这些“全部的”选项允许你将这个过程停止到中间阶段。例如，选项**`-c`**告诉编译器不要运行链接器。于是输出就由汇编器生成的object文件构成。

其他的选项被传递给一个或更多个编译阶段。一些选项控制预处理器，另一些选项控制编译器。然而其他的一些选项控制汇编器和链接器；它们中大多数未在此处列出，因为你极少会用到它们。

大多数你可以对GCC使用的命令行参数对于C程序而言都很有用；当一个参数只对一个语言（C++）有用时，说明文档会清楚地指出来。如果一个参数的描述没有提到源语言，那么你就可以在所有的支持语言中使用它。

运行GCC的一般方式是运行可执行程序`gcc`，或者当你运行交叉编译时是`machine-gcc`，又或者运行`machine-gcc-version`来执行某一特定版本的GCC。当你编译C++程序时，你应当使用`g++`来调用GCC。
