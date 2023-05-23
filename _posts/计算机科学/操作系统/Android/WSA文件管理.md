---
title: WSA文件管理
tags:
  - WSA
  - Linux
  - ADB
excerpt: ADB真不戳
toc: true
author: xeonds
date: '2022.05.02 00:54:29'
categories:
  - 计算机科学
  - 操作系统
  - Android
---

## ADB传输文件

在电脑装Phigros的时候（别问，问就是闲的）发现obb是分离的，于是尝试用ADB直接push到`Android/data/com.PigeonGames.Phigros/`目录下，报错，提示权限不足。后来传到`/sdcard/`下再移动进去才成功了。

```bash
# 连接到wsa
adb connect 127.0.0.1:58526
# 传文件到wsa
adb push D:\download\main.43.com.PigeonGames.Phigros.obb /storage/emulated/0/Android/
# 进入shell
adb shell
# 创建目标目录
cd /storage/emulated/0/Android/obb/
mkdir com.PigeonGames.Phigros
# 将文件移到目标位置
mv ../main.43.com.PigeonGames.Phigros.obb ./com.PigeonGames.Phigros
# 退出
exit
```

到此完成。

## 给WSA安装程序

记下你的安装包的路径，打开终端，按照上面的步骤连接设备后，输入：

```cmd
adb install /path/to/app.apk
```

随后等待安装完成即可。
