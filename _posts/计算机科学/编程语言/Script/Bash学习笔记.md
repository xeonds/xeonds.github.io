---
title: Bash学习笔记
date: 2023-06-03 21:43:09
author: xeonds
toc: true
excerpt: 积累起来的bash使用技巧，用来处理日常的一些问题
tags:
  - Bash
  - 数据统计
  - 技巧
---

Bash对于绝大多数任务来说够用。所以没必要太折腾，先试试Bash吧。

第一部分我会记录一些Linux自带（绝大多数情况）程序的用法，第二部分会把它们组合起来使用。

## 命令介绍

head命令用于显示文件的开头几行，sort命令用于对文件或标准输入进行排序，可以按照字母顺序、数字大小、日期等方式进行排序，uniq命令则用于去除重复的行，可以通过参数指定只保留重复行的数量或只显示重复行。

head命令的语法：`head [选项] [文件]`。例如，要查看文件file.txt的前10行，请使用以下命令：`head -n 10 file.txt`。¹\

sort命令的语法：`sort [选项] [文件]`。例如，要按字母顺序对文件file.txt进行排序，请使用以下命令：`sort file.txt`。要按数字大小对文件进行排序，请使用以下命令：`sort -n file.txt`。

uniq命令的语法：`uniq [选项] [输入文件] [输出文件]`。例如，要从文件file.txt中删除重复的行并将结果写入新文件newfile.txt，请使用以下命令：`uniq file.txt newfile.txt`。要显示重复行及其出现次数，请使用以下命令：`uniq -c file.txt`。

## 一些用法

黑魔法开始了（不是

### 统计输出情况

```bash
./a.out | head -n 100000 | sort | uniq -c
```

这样就能得到统计好的输出数据。

### 随机输出一行

看到同学发的抽奖现场用Python现写程序，节目效果拉满（）不过，都用Linux了，还不用Bash？

```bash
fname="lab6.c"; rand=$((RANDOM%$(cat "$fname" | wc -l))); sed -n "$rand"p "$fname"
```

上面的命令其实是3行命令，但是每行都比较短就合成一行了。第一个和第二个都是赋值命令，设置文件名，并根据文件行数生成随机数。第三行用`sed`从文件中读取指定的行。

对于第三行指令，其实不用`sed`也行，用`head -n "$rand" | tail -n 1"`也是能得到相同的结果。完整指令：

```bash
fname="lab6.c"; rand=$((RANDOM%$(cat "$fname" | wc -l))); cat $fname | head -n "$rand" | tail -n 1
```

总之能看出，对于操作数据，Linux自带的工具也很强大了。

### 保留最近三天的文件

这东西用来清log和冗余备份确实好用。

清文件夹记得把-f换成-rf。

```bash
find [target file in path] -mtime +2 |xargs rm -f
```

### Ubuntu内存释放 

>2020.12.18 11:05:00

下面的指令用来释放系统内存，只在Ubuntu上测试过。长期运行的服务器最好严密监督内存使用情况：

```
 echo 3 >/proc/sys/vm/drop_caches
```

啊对了注意指令里是vm不是mv。
