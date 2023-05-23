---
title: 记一次npm和nodejs安装过程
tags:
  - node.js
  - Linux
excerpt: 有问题就去官网和StackOverflow找资料
toc: true
author: xeonds
date: '2022.03.26 20:05:42'
categories:
  - 计算机科学
  - 编程语言
  - JavaScript
---

## 背景

最近接触vue-cli，需要用到nodejs和npm。直接`apt-get`安装完成后发现版本过低，换源也不解决问题。最后必应解决了。

## 步骤

首先彻底卸载nodejs和npm：

```bash
sudo apt-get --purge npm
sudo apt-get --purge nodejs
sudo apt-get --purge nodejs-legacy
```

然后去NodeSource获取换源指令并安装nodejs和npm，如下：

```bash
# Using Ubuntu
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Using Debian, as root
curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -y nodejs
```

完成。

## 新的问题：npm not found

我安装完成后发现，npm指令执行报错：

```bash
-bash: /usr/local/bin/npm: No such file or directory
```

经过排查，发现是符号链接异常导致：npm会安装在`/usr/bin/`下，而在`/usr/local/bin/`下会创建软链接指向前者。所以只需要删掉原来的链接再手动创建就可以啦：

```bash
cd /usr/local/bin/
sudo rm npm && sudo ln -s /usr/bin/npm /usr/local/bin/npm
```

这时候再输入`npm -v`，就可以看到npm正常运行了。
