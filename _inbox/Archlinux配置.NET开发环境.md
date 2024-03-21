---
title: Archlinux配置.NET开发环境
date: 2024-03-21 00:04:11
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

省流：安装如下三个包就行：

```bash
aspnet-runtime-bin
dotnet-sdk-bin
dotnet-runtime-bin
```

之前没装第一个包，导致运行的时候一直报错`You must install or update .NET to run this application.`还疑惑了半天我不是装了吗...

## 构建&运行

```bash
dotnet new [name]
dotnet build
dotnet run
```

