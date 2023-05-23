---
title: Ubuntu22.04设置旁路由
date: 2023-08-06 23:45:11
author: xeonds
toc: true
excerpt: (*/ω＼*)
---
## 通过手动配置网关完成

Ubuntu 22.04 server lts使用Netplan来管理网络配置，而不是/etc/network/interfaces文件。Netplan是一个基于YAML的配置系统，可以简化配置过程。你可以在/etc/netplan目录下找到Netplan的配置文件，通常是01-netcfg.yaml或者其他以.yaml结尾的文件。你可以编辑这个文件来设置你的网络接口的IP地址、网关、DNS等参数。具体的步骤如下：

- 首先，你需要确定你要配置的网络接口的名称，可以使用`ip a`命令查看。假设你的网络接口名称是`eth0`。
- 然后，你需要编辑Netplan的配置文件，可以使用`sudo nano /etc/netplan/*.yaml`命令打开。在文件中，找到你的网络接口对应的段落，例如：

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
```

复制

- 如果你想使用静态IP地址，你需要将`dhcp4: yes`改为`dhcp4: no`，然后添加你想要设置的参数，例如：

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.3.100/24] # 你的网络接口的IP地址和子网掩码
      gateway4: 192.168.3.1 # 你的网关地址
      nameservers:
        addresses: [8.8.8.8, 114.114.114.114] # 你想要使用的DNS服务器地址
```

复制

- 如果你想使用动态IP地址，你只需要将`dhcp4: yes`保留即可，不需要添加其他参数。
- 保存并退出文件，然后应用Netplan的配置，可以使用`sudo netplan apply`命令。
- 最后，你可以使用`ping`命令测试一下网络是否正常，例如`ping www.baidu.com`。

## 通过代理工具完成

原始需求是实现透明代理。后来发现这样有一些可用性方面的问题，遂决定暂不采用系统级别的操作，改而使用`proxychains`这样的工具。