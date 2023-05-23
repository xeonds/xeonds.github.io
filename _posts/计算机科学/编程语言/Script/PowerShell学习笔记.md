---
title: PowerShell学习笔记
tags:
  - PowerShell
toc: true
author: xeonds
date: '2022.06.05 20:31:58'
categories:
  - 计算机科学
  - 编程语言
  - Script
excerpt: ps怎么感觉有点用linux的感觉？
---

## 文件批量改后缀

```ps
dir * | foreach { Rename-Item $_ -NewName ($_.BaseName+”.mp4”)  }
```

## 解除端口占用


首先找到占用端口的进程，然后终止进程：

```ps
netstat -nao | findstr "5554" 	# 假设5554端口被占用
taskkill -pid 5076 -f  			# 结束占用进程
```

## 查找文件

如果不指定`Path`则默认查找当前目录。查找支持正则表达式。

```ps
Get-ChildItem -Path C:\Users\JohnDoe -Filter *.txt -Recurse
```

## 批量git push

```ps
Get-ChildItem -Directory | ForEach-Object {
    $gitDir = Join-Path $_.FullName ".git"
    if (Test-Path $gitDir) {
        Set-Location $_.FullName
        git push
    }
}
```