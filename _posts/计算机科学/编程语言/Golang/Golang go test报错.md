---
title: Golang go test报错
date: '2022.11.22 19:41:08'
author: xeonds
toc: true
excerpt: ^_^
categories:
  - 计算机科学
  - 编程语言
  - Golang
---

报错内容：`call has possible formatting directive %v`

`go test` 中不能使用 `fmt.PrintLn("%v", v)`

## 方案

使用 `fmt.Printf("%+v", v)`