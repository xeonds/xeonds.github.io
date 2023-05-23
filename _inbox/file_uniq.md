---
title: 文件去重小记
date: 2023-09-03 20:20:21
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

服务器搭建好也有两个来月了，期间数据量最大的操作就是用WebDAV备份文件了。这段时间，也在硬盘上累积了不少数据。不过由于磁盘上本来就有一些数据，又因为导入文件把网盘的数据目录整乱了，所以打算抽个时间好好地把所有文件整理一下。

这中间就遇上一个问题，很多文件都重复了不少次数。之前也尝试过用hash函数对文件去重，但是有时两个完全一样的文件的hash也不一样，推测应该是inode不一样造成的。刚好，两块机械硬盘都挂到Linux下了，于是就趁机找找Linux下的文件去重工具，试着用它加上其他工具来整理一下服务器上的数据。

## 安装

```bash
sudo apt-get install rdfind -y  # ubuntu
sudo pacman -S rdfind           # arch
```

## 使用

一旦安装完成，仅带上目录路径运行 Rdfind 命令就可以扫描重复文件。

```text
$ rdfind ~/Downloads
```

Rdfind 命令将扫描 `~/Downloads` 目录，并将结果存储到当前工作目录下一个名为 `results.txt` 的文件中。你可以在 `results.txt` 文件中看到可能是重复文件的名字。

通过检查 `results.txt` 文件，你可以很容易的找到那些重复文件。如果愿意你可以手动的删除它们。

此外，你可在不修改其他事情情况下使用 `-dryrun` 选项找出所有重复文件，并在终端上输出汇总信息。

```text
$ rdfind -dryrun true ~/Downloads
```

一旦找到重复文件，你可以使用硬链接或符号链接代替他们。

使用硬链接代替所有重复文件，运行：

```text
$ rdfind -makehardlinks true ~/Downloads
```

使用符号链接/软链接代替所有重复文件，运行：

```text
$ rdfind -makesymlinks true ~/Downloads
```

目录中有一些空文件，也许你想忽略他们，你可以像下面一样使用 `-ignoreempty` 选项：

```text
$ rdfind -ignoreempty true ~/Downloads
```

如果你不再想要这些旧文件，删除重复文件，而不是使用硬链接或软链接代替它们。

删除重复文件，就运行：

```text
$ rdfind -deleteduplicates true ~/Downloads
```

如果你不想忽略空文件，并且和所哟重复文件一起删除。运行：

```text
$ rdfind -deleteduplicates true -ignoreempty false ~/Downloads
```

更多细节，参照帮助部分：

```text
$ rdfind --help
```

手册页：

```text
$ man rdfind
```