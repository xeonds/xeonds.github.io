---
title: Bash使用之输出内容统计
date: 2023.05.04 16:01:46
author: xeonds
toc: true
excerpt: 来自jyy的bash使用技巧
tags:
  - Bash
  - 数据统计
  - 技巧
---

## 命令介绍

head命令用于显示文件的开头几行，sort命令用于对文件或标准输入进行排序，可以按照字母顺序、数字大小、日期等方式进行排序，uniq命令则用于去除重复的行，可以通过参数指定只保留重复行的数量或只显示重复行。

head命令的语法：`head [选项] [文件]`。例如，要查看文件file.txt的前10行，请使用以下命令：`head -n 10 file.txt`。¹\

sort命令的语法：`sort [选项] [文件]`。例如，要按字母顺序对文件file.txt进行排序，请使用以下命令：`sort file.txt`。要按数字大小对文件进行排序，请使用以下命令：`sort -n file.txt`。

uniq命令的语法：`uniq [选项] [输入文件] [输出文件]`。例如，要从文件file.txt中删除重复的行并将结果写入新文件newfile.txt，请使用以下命令：`uniq file.txt newfile.txt`。要显示重复行及其出现次数，请使用以下命令：`uniq -c file.txt`。

## 组合技

```bash
./a.out | head -n 100000 | sort | uniq -c
```

这样就能得到统计好的输出数据。