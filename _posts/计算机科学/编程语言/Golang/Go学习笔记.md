---
title: Go学习笔记
tags:
  - 编程
  - Golang
excerpt: 希望以后能少踩点坑
toc: true
author: xeonds
date: '2022.05.06 18:46:36'
categories:
  - 计算机科学
  - 编程语言
  - Golang
---

# 安装

- 访问[这里](https://go.dev/) ，下载安装包进行安装即可。或者访问[这里](https://studygolang.com/dl/)下载也可。

- 配置`go mod proxy`，参考<https://goproxy.cn>即可。

- 安装VSCode+Go插件或者Goland等开发工具都可以。

---

最近得在Linux上编译个服务端程序，所以把配置方法记录一下。

源用的是USTC的。看了他们官网发现东西还真不少~~比隔壁tuna多多了而且域名还短（确信）~~。golang直接下载太慢所以走镜像站。链接在这，时效性应该不用太担心。

<https://mirrors.ustc.edu.cn/golang/go1.20.1.linux-amd64.tar.gz>

步骤很简单，就是`wget`然后`tar`解压到指定位置最后把目录加到系统环境变量里边：

```bash
VER="1.20.1"
SH="bash"
# 下载解压 & 移除旧版本
wget https://mirrors.ustc.edu.cn/golang/go"$VER".linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& tar -C /usr/local -zxf go$GO_STR.linux-amd64.tar.gz
# 如果是第一次安装且使用bash
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/."$SH"rc
```

注意：**执行上面的脚本之前请先自行验证安全性**。以及，上面的脚本得用root权限执行。

然后就是设置代理。我用<http://goproxy.cn>比较多。配置也很简单：

```bash
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
```

# 资料

- [《Go语言圣经》](https://books.studygolang.com/gopl-zh)
