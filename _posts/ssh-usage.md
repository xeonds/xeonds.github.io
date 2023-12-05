---
title: SSH学习笔记
date: 2023-09-25 14:16:18
author: xeonds
toc: true
excerpt: 节省生命从小事做起
tags:
    - Linux
    - SSH
---

>文章是我和GPT一块写的，回头再慢慢丰富润色。

OpenSSH是一种强大的远程登录和数据传输工具，也是SSH协议目前最流行的实现。它提供了许多安全功能，如数据加密、身份验证和会话完整性。安全性上，SSH能吊着明文传输的Telnet打。并且SSH的配置也相对容易，目前基本所有主流Linux发行版都默认安装了OpenSSH，Win10/11也自带了OpenSSH Cilent。

追求效率提升，首先需要看看日常重复次数最多的操作，然后试着优化——比如SSH，虽然每次只有1,2秒，但累积起来节省的时间也不少。配置好了基本能实现无感登陆那种程度，让你几乎忘掉这个环节，还是挺爽的。除了效率，提升点安全性也是挺好的：公网服务器改用密钥登陆，又无感又安全——只要密钥别丢。

## 基本用法
### 远程登录
基本格式：
```  
ssh [options] [username]@[hostname]  
```
`[username]` 是远程主机的用户名，`[hostname]` 是远程主机的主机名或 IP 地址。

`[options]` 是可选的参数，例如 `-i` 指定要使用的私钥文件，`-L` 指定要使用的本地端口转发，`-R` 指定要使用的远程端口转发等。

一般用的最多的是默认端口密码登陆：
```bash
ssh username@hostname <-p 22>
```
后面的`-p 22`是缺省参数，可以不加。

不过密码登陆安全性并不太高，建议重要场合上密钥登陆。例如，用密钥文件 `id_rsa` 以用户 `username` 登录远程主机 `example.com`：
```  
ssh -i id-rsa username@example.com
```
密钥和公钥就像锁和钥匙一一对应，你可以用同一对公钥密钥登陆多个主机，不过显然不太安全。建议一对公密钥只用于一个服务器的登陆。

它们的创建很简单，使用 `OpenSSH` 自带的 `ssh-keygen` 命令即可：
```bash
xeonds@ark-station:~$ ssh-keygen 
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/xeonds/.ssh/id_ed25519): example-key     # 指定公钥私钥保存在哪
Enter passphrase (empty for no passphrase):                                         # 指定私钥使用密码
Enter same passphrase again: 
Your identification has been saved in example-key
Your public key has been saved in example-key.pub
The key fingerprint is:
SHA256:tFoZLdZFg3HDMqGG6rC5jq+zysxClfBCUvffMYgS5GY xeonds@ark-station
The key's randomart image is:
+--[ED25519 256]--+
| ...+     o**    |
|.o o o o =+o.o   |
|o o E + O =o     |
| . * o = * o     |
|  + .   S .      |
| . =   o         |
|. o . .          |
|*. .             |
|BX+              |
+----[SHA256]-----+
xeonds@ark-station:~$ ls | grep example
example-key
example-key.pub
```
上面带`.pub`后缀的就是公钥，私钥是不带后缀的那个。创建完成之后，可以用 `ssh-copy-id` 把公钥传给你要登陆的服务器，把私钥妥善保管好：
```bash
ssh-copy-id -i example-key.pub username@example.com
```
还可以用`-p xxxx`指定端口。传完之后就能用前面的指令登陆服务器了。但是这样也挺麻烦的对吧。你别急，还有办法：把下面的内容保存到你的`~/.ssh/config`文件中：
```config
Host my-server
    HostName example.com
    User username
    Port 22                             # 端口默认22的话可以不写
    IdentityFile ~/.ssh/example-key     # 指向你的密钥路径
    PreferredAuthentications publickey  # 指定优先使用公钥
```
现在就可以直接用下面的指令登陆了：
```bash
ssh my-server
```
直接登陆，几乎无感。当然要是你给私钥设置密码了就得在登陆的时候再输入一遍密码。

>不过跟现代计算机系统比起来，还是人参与的环节更加脆弱，最终还是得小心社工手段。

### 传输文件
OpenSSH 还提供了一种安全传输文件的方法，称为 SFTP（SSH 文件传输协议）。要使用 SFTP 传输文件，您需要使用以下命令：
```  
sftp [options] [username]@[hostname]  
```
其中，`[options]` 是可选的参数，例如 `-i` 指定要使用的私钥文件，`-L` 指定要使用的本地端口转发，`-R` 指定要使用的远程端口转发等。`[username]` 是远程主机的用户名，`[hostname]` 是远程主机的主机名或 IP 地址。
例如，如果您要使用密钥文件 `id_rsa` 将本地文件 `file.txt` 传输到远程主机 `example.com`，可以使用以下命令：
```  
sftp -i id_rsa example.com  
```
## 高级用法
### 1. 端口转发
OpenSSH 提供了一种称为端口转发的功能，允许您将本地端口与远程端口进行映射。这使得您可以在本地网络上使用远程服务，而无需将服务暴露给外部网络。要使用端口转发，您需要使用以下命令：
```  
ssh -L [local_port:]local_host [username]@[hostname]  
```
其中，`[local_port]` 是本地端口的名称，`local_host` 是本地主机的名称或 IP 地址，`[username]` 是远程主机的用户名，`[hostname]` 是远程主机的主机名或 IP 地址。
例如，如果您要将本地端口 8080 映射到远程主机的 SSH 服务（端口 22），可以使用以下命令：
```  
ssh -L 8080:localhost username@example.com  
```

上面的指令就能很轻易实现基于`xxx over SSH`的内网穿透。举个例子，前面我配置好了我的服务器的`ssh config`，假设我的服务器配置项名为`server`，在局域网中有一台地址为`1.14.5.14`的Windows服务器，那么我就可以使用一行指令通过SSH跳转连接到这台Windows服务器的远程桌面：
```bash
ssh -L 3389:1.14.5.14:3389 server -N & rdesktop localhost
```
假设我的这台服务器`server`在层层内网中，需要经过多重跳板才能从公网进行访问，一般的远程桌面面对这种网络环境可能比较困难，但是对于上面的`RDP over SSH`，这种方法既能享受`SSH`的安全性，又能相对便利地进行访问——只要配置好这台`server`服务器的`ProxyJump`路径和登陆就行。
