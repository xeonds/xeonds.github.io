---
title: SSH学习笔记
date: 2023-09-25 14:16:18
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
    - Linux
    - SSH
---

OpenSSH 是一种强大的远程登录和数据传输工具，它提供了许多安全功能，如数据加密、身份验证和会话完整性。在本文中，我们将详细介绍 OpenSSH 的基本用法和高级用法。

## 基本用法

### 1. 远程登录

OpenSSH 最基本的用法是远程登录。要使用 OpenSSH 进行远程登录，您需要使用以下命令：
```  
ssh [options] [username]@[hostname]  
```
其中，`[options]` 是可选的参数，例如 `-i` 指定要使用的私钥文件，`-L` 指定要使用的本地端口转发，`-R` 指定要使用的远程端口转发等。`[username]` 是远程主机的用户名，`[hostname]` 是远程主机的主机名或 IP 地址。
例如，如果您要使用密钥文件 `id_rsa` 登录远程主机 `example.com`，可以使用以下命令：
```  
ssh -i id_rsa example.com  
```
### 2. 传输文件
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
### 2. 配置 SSH 密钥
为了提高安全性，您可以配置 SSH 密钥，以便在进行远程登录时无需输入密码。要配置 SSH 密钥，您需要使用以下命令：
```  
ssh-keygen [options]  
```
其中，`[options]` 是可选的参数，例如 `-t` 指定密钥类型，`-C` 指定密钥注释等。
例如，如果您要生成一个 RSA 密钥对，可以使用以下命令：
```  
ssh-keygen -t rsa -C "your_email@example.com"  
```
配置完 SSH 密钥后，您需要将公钥添加到远程主机的 `authorized_keys` 文件中，以便在进行远程登录时无需输入密码。要将公钥添加到远程主机的 `authorized_keys` 文件中，您可以使用以下命令：
```  
ssh-copy-id [username]@[hostname]  
```
其中，`[username]` 是远程主机的用户名，`[hostname]` 是远程主机的主机名或 IP 地址。
例如，如果您要将公钥添加到远程主机 `example.com` 的 `authorized_keys` 文件中，可以使用以下命令：
```  
ssh-copy-id username@example.com  
```
