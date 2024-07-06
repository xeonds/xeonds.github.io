---
title: Docker使用笔记
date: 2023-10-01 17:36:32
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
## 安装

各种发行版都不一样，Arch直接`sudo pacman -S docker`就行。

安装完毕后，输入`sudo systemctl enable --now docker.service`启动Docker服务。

### 权限配置

想不用`sudo`就用Docker，那就得配置用户组权限：

```bash
sudo groupadd docker  # ensure the usergroup docker exists
sudo usermod -aG docker $USER  # add curr user to docker group
```

### 镜像加速[#](https://www.cnblogs.com/qianyuzz/p/18016205#镜像加速)

我使用的是[阿里云镜像](https://cr.console.aliyun.com/cn-shenzhen/instances/mirrors)

1. 安装／升级Docker客户端  
    推荐安装1.10.0以上版本的Docker客户端，参考文档docker-ce
    
2. 配置镜像加速器
    

```bash
root@Ubuntu:~# vim /etc/docker/daemon.json
root@Ubuntu:~# sudo systemctl daemon-reload
root@Ubuntu:~# sudo systemctl restart docker
root@Ubuntu:~# cat /etc/docker/daemon.json
{
          "registry-mirrors": ["https://xxxxxx.mirror.aliyuncs.com"]
}

```

最后使用`docker info` 就可以查看是否更换镜像成功。

## 疑难杂症

### `tls: failed to verify certificate: x509: certificate signed by unknown authority`

现象是，在容器内会发现https连接不可用，都会报上面的错误。但是容器的宿主机连接正常。

报错内容是证书由未知机构签署。原因是基于https的web连接基于tls机制来认证连接双方可信，并且不会存在中间人攻击（即，在你到服务器的通信中，第三方几乎不可能解密你们加密后的通信内容）。但是因为基于tls可信原理的条件进行推导，最终会得出必须存在一个可信根证书预先分发给客户端的结论。

>x509是一个标准，它定义了公钥证书的格式，这些证书用于TLS和其他加密通信。

所以，上面的错误表示证书部分出现错误。未知证书表示客户端没有信任签发服务器证书的证书颁发机构（CA）。客户端的信任存储中没有包含该CA的证书，因此无法验证服务器证书的有效性。

因此鉴定为容器镜像里边缺tls证书了。

#### 解决方案

- 在容器中执行`apt-get install ca-certificates`
- 在映射中添加如下映射：`/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt`
- 在映射中添加如下映射：`/usr/share/zoneinfo/Asia/Shanghai:/etc/localtime:ro`

如果是`ubuntu:latest`的话，那大概率已经安装`ca-certificates`，执行2，3尝试即可。

