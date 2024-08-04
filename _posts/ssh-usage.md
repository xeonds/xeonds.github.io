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

### 断开连接
因为忘了断开另一个开发机的ssh连接导致我有几个端口一直被占用着，所以得想办法断开另一台机器的连接：

```bash
w # 查看所有连接
pkill -kill -t pts/x # 断开编号为x的连接
pkill -9 -t pts/x # 和上边一样，不过是强制断联
```
不过不知道为啥好像远程shell的服务还活着，只能手动杀掉了。下次建议用tmux，省事省心。
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
>ref:[SSH命令的三种代理功能 - 韦易笑](https://zhuanlan.zhihu.com/p/57630633)

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

端口转发有三种方式，上边的`-L`是正向代理，也就是在本地启动端口，把本地的数据转发到远端。上面转发桌面的例子就是这样，把本地3389端口的RDP请求转发到了远端的3389端口，从而实现了从本地访问远程服务器所在局域网的计算机的需求。另外两种分别是反向代理`-R`和socks5代理`-D`。这个一般可以作为兜底方案，长期需求建议上服务器。

按照正向代理的思路，反向代理就是把远端端口的访问请求转发到本地的计算机上。比如访问一个公网计算机的1234端口，就可以通过`-R`启动反向代理将这个端口的请求转发到本地的任意端口（比如4514）从而将内网的某个服务映射到公网中。这一点特别适合临时给某个服务搭建一个预览平台。

另外就是socks5转发，可以直接点上边链接看原文，这种我还没用过就不做阐述了。

下面用指令总结下这几种代理方式：

```bash
# 转发本地请求到远端，例如访问远程局域网的远程桌面
ssh -L [本地主机所在局域网任意主机:端口]:[目标主机所在局域网任意主机:端口] 要连接的主机
# 转发远端请求到本地，例如穿透本机某端口的服务到公网
ssh -R [远端主机:端口]:[本地主机局域网任意主机:端口] 远端主机
# 本地socks5代理，效果大概就是让远端主机成为自己1080端口的上网代理？
# 完成之后，在浏览器代理设置里边设置代理为socks5，地址为localhost:1080就行
ssh -D localhost:1080 远端主机
```

2. 连接后执行一条指令后断开

直接在连接命令后边跟上要执行的指令就行。

3. 在远程主机运行X程序

连接命令加上`-X`参数，然后主机就会开启X转发。用`-x`则是关闭X转发。没用过，不过看起来像是服务器上跑进程，本地跑GUI的做法？

### 2. SSHFS
安装`sshfs`之后，就可以用ssh的方式将远程的文件系统挂载到本地了。

```bash
sudo sshfs -o allow_other,default_permissions xeonds@10.0.0.154:/home/xeonds /mnt/ark-station-breeze/
```

例如上面的指令，我将局域网中一个机器的用户目录挂载到了当前目录下。
