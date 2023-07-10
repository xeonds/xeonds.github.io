---
title: sed学习笔记
date: 2023-07-10 16:17:33
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
  - IDE
---

## 前言

之前学了Vim，不过Vim不太容易和其他命令行工具结合实现一些自动化任务。随后我将目光投向了sed和awk，它们二者都满足这个条件：**可以将一个源的数据经过一些预定义的变换，输出到另一个源中**。这其中，我对`sed`相对更加熟悉一些，awk我感觉可能更复杂一些，而sed只需要正则表达式就行。比如我之前接触到的第一个sed表达式：

```bash
sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
```

上面那段是termux的换源指令。单就命令格式上来看，我觉得和Vim的`%s`替换表达式比较接近。

那么就开始正篇吧：sed的快速入门。

## 基本介绍

sed是一个流编辑器，它可以对文本文件或标准输入进行处理和编辑。sed的基本用法是：

```bash
sed [options] 'script' file
```

其中，options是一些可选的参数，script是一些sed命令，file是要处理的文本文件。下面是一些常用的options：

- `-n`：只打印匹配到的行，不打印所有行。
- `-e`：可以指定多个script，按顺序执行。
- `-f`：可以从一个文件中读取script。
- `-i`：可以直接修改原文件，而不是输出到标准输出。
- `-r`：可以使用扩展正则表达式。

sed的script由一些地址和命令组成，地址可以指定要处理的行，命令可以指定要执行的操作。下面是一些常用的地址和命令：

- 地址可以是一个数字，表示行号，如`3`表示第三行。
- 地址可以是一个范围，表示行号之间的区间，如`3,5`表示第三行到第五行。
- 地址可以是一个正则表达式，表示匹配该模式的行，如`/^abc/`表示以abc开头的行。
- 地址可以是`$`，表示最后一行。
- 如果不指定地址，默认对所有行进行处理。

- 命令可以是`a`，表示在当前行后面添加一些内容，如`a\newline`表示在当前行后面添加一行newline。
- 命令可以是`c`，表示用新的内容替换当前行，如`c\newtext`表示用newtext替换当前行。
- 命令可以是`d`，表示删除当前行，如`d`表示删除当前行。
- 命令可以是`p`，表示打印当前行，如`p`表示打印当前行。
- 命令可以是`s`，表示用新的内容替换匹配到的内容，如`s/old/new/g`表示将old替换为new，g表示全局替换。

## 示例：

- 打印1-3行：

```bash
sed -n '1,3p' file.txt
```

- 删除1-3行：

```bash
sed '1,3d' file.txt
```

- 在所有行前加#：

```bash
sed 's/^/#/g' file.txt
```

- 将所有字母大写：

```bash
sed 's/.*/\U&/g' file.txt
```

## 参考资料

¹: [Linux sed 命令 | 菜鸟教程](https://www.runoob.com/linux/linux-comm-sed.html)
²: [sed 命令快速入门 - 知乎](https://zhuanlan.zhihu.com/p/181734158)
³: [sed完全教程 - 知乎](https://zhuanlan.zhihu.com/p/145661854)