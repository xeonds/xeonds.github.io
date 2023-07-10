---
title: MCSManager开服小记
tags:
  - Minecraft
  - Linux
excerpt: MCSM整挺好，但是依赖，权限这些修起来也麻烦（
toc: true
author: xeonds
date: '2021.06.20 23:48:15'
categories:
  - 游戏
  - Minecraft
cover: /img/79c2fe8bd08250e6505ed783980d3739.jpeg
---

![!](file/img/4d17bffecbbb55feb79b3d20c2ec2519.png)
这边先放上来Ubuntu基岩版服务端：<https://minecraft.azureedge.net/bin-linux/bedrock-server-1.14.60.5.zip>（点击下载，也可以复制链接在服务器上wget下载）

>上面那个链接可以直接改后面的版本号下载对应版本。

那先让我们看看mcsm官方的教程。

>在 Linux 启动 bedrock 服务端就兼用用 sh 脚本启动的方法，否则很有可能启动失败。

* 首先下载Linux系统的服务端，其中会有一个叫做 bedrock_server 的文件。
* 在面板中的 服务端管理 点击 创建新实例 再选择 自定义启动命令 方案。
* 取好 名字，项目位置推荐默认，下一步。
* 使用 选择文件上传 上传你的压缩包（必须用zip格式，建议自己下载解压打包成zip），下一步。
* 启动命令写成 sh start.sh，稍后我们上传这个文件。
* 在自己的本地电脑创建一个脚本文件叫做 start.sh，写入开服指令:
`LD_LIBRARY_PATH=. ./bedrock_server`
* 在服务端管理界面中点击 管理，进入文件在线管理，上传这个start.sh的脚本文件。
* 在文件在线管理界面中，解压你刚刚上传的zip压缩包，稍作休息，耐心等待。
开服。

操作过程中，我遇到了这么几个问题。

### 其一：bedrock_server: Permission denied

这个好办。虽然只有面板，但是我还可以自定义启动脚本啊。

直接编辑启动脚本`start.sh`，在启动指令前面再加一行：

`chmod 777 -R *`

再运行。好！不报错了。

### 其二：依赖库缺失问题

别人已经说得很清楚了，我就直接复制一下作为参考（。）

启动一下试试 LD_LIBRARY_PATH=. ./bedrock_server，发现没有启动成功，查看错误信息

./bedrock_server: error while loading shared libraries: libcurl.so.4: cannot open shared object file: No such file or directory
原来是没有安装libcurl.so.4，百度插一下这个文件属于哪个包，直接安装然后再次启动

apt install libcurl4-openssl-dev
LD_LIBRARY_PATH=. ./bedrock_server
依旧报错，继续查看错误信息，然后查

./bedrock_server: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
原来是需要安装openssl，安装后再次启动，

apt install openssl
依旧报错

./bedrock_server: /lib/x86_64-linux-gnu/libm.so.6: version `GLIBC_2.27' not found (required by ./bedrock_server)
安装libc6

echo 'deb <http://ftp.debian.org/debian/> buster main' >> /etc/apt/sources.list
apt update
apt -t buster install libc6
再次启动

LD_LIBRARY_PATH=. ./bedrock_server
终于可以正常启动了

---

差不多就是这样了吧。后面就看某鸽子啥时候处理依赖问题吧（咕
