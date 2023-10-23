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

