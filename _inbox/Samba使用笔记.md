---
title: Samba使用笔记
date: 2023-10-09 20:19:12
author: xeonds
toc: true
excerpt: 纯粹为了Windows底下用着共享磁盘方便而配置的一个玩意。只能说Linux的兼容性确实可以的
tags:
  - Linux
  - Windows
  - 工具
---
- 安装samba软件包，如果您还没有安装的话。您可以使用以下命令来安装samba：`sudo apt-get install samba samba-common`¹²³。
- 创建一个samba用户，并设置一个密码。您可以使用以下命令来创建一个samba用户：`sudo smbpasswd -a [用户名]`¹²。这里的用户名应该和您的linux用户名一致，这样才能让它们的密码保持一致。
- 编辑smb.conf文件，添加两个共享段，分别对应/mnt/c和/mnt/d目录。您可以使用以下命令来编辑smb.conf文件：`sudo vi /etc/samba/smb.conf`¹²⁴。在文件的最后，您可以添加类似于以下的内容：

```
[mnt_c]
comment = share folder for /mnt/c
path = /mnt/c
valid users = [用户名]
force user = [用户名]
force group = [用户组]
writable = yes
browseable = yes

[mnt_d]
comment = share folder for /mnt/d
path = /mnt/d
valid users = [用户名]
force user = [用户名]
force group = [用户组]
writable = yes
browseable = yes
```

这里的用户名和用户组应该和您的linux用户名和用户组一致，您可以使用`id`命令来查看它们。
- 重启samba服务，使配置生效。您可以使用以下命令来重启samba服务：`sudo service smbd restart`¹²。
- 在Windows上访问共享目录，输入您的samba用户名和密码。您可以使用Windows资源管理器，输入类似于以下的地址来访问共享目录：`\\[linux的ip地址]\[共享段名]`¹²。例如，如果您的linux的ip地址是192.168.1.100，那么您可以输入`\\192.168.1.100\mnt_c`来访问/mnt/c目录。
