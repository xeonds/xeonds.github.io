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