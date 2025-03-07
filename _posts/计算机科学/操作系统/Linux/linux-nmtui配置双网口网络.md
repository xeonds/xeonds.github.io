---
title: linux-nmtui配置双网口网络
date: 2025-03-07 15:11:12
author: xeonds
toc: true
excerpt: (*/ω＼*)感谢d指导
tags:
---

服务器有两个网口，一个拨号一个局域网，想着两个网络应该都能从各自的内网ip访问，但是一直出现了只能从eno0访问而无法从ppp0访问的异常。遂查看路由表如下：

```bash
xeonds@ark-station-server:~$ ip route show    
default via 10.19.19.81 dev eno0 proto dhcp metric 103  # 优先级高（metric=103）
default via 10.194.255.254 dev ppp0 proto static metric 104  # 优先级低（metric=104）
...
```

能看出来什么问题吗？是的，服务器同时连接了两个网口，但是系统的出流量会优先选择优先级（也就是Metrics）高的出口，这会导致系统出现**非对称路由**：来自ppp0的请求被服务器接收后，会从eno0发出（因为 eno0 的默认路由优先级更高）。这种情况下，两个网络如果不互通的话，响应包就会被丢弃。

所以一个简单的解决方案就是，

```bash
nmcli connection modify eno0 ipv4.never-default yes
```

去掉eno0的默认网关，这样出流量都会走ppp0，从而消除了非对称路由的问题。eno0也仅保留本地子网的路由，因此仍然能通过子网的其他设备访问服务器。

## 另一种解法

- **出站流量负载均衡**：随机选择 eno0 或 ppp0 访问互联网。
- **入站流量双向可达**：通过 eno0 或 ppp0 的 IP 均能访问服务器。
    
**解决方案：策略路由（Policy-Based Routing）**

需手动配置路由表和规则，根据源 IP 或其它条件选择出口。以下是具体步骤：

---

### **步骤 1：为每个接口创建独立路由表**

编辑 `/etc/iproute2/rt_tables`，添加两个自定义路由表：

```bash
echo "100 eno0_route" >> /etc/iproute2/rt_tables
echo "200 ppp0_route" >> /etc/iproute2/rt_tables
```

---

### **步骤 2：为每个接口配置路由和规则**

#### **eno0 配置**

```bash
# 添加 eno0 的路由表
ip route add 10.19.19.0/24 dev eno0 table eno0_route
ip route add default via 10.19.19.81 dev eno0 table eno0_route

# 添加规则：来自 eno0 IP 的流量使用 eno0_route 表
ip rule add from 10.19.19.8/24 table eno0_route
```

#### **ppp0 配置**

```bash
# 添加 ppp0 的路由表
ip route add default via 10.194.255.254 dev ppp0 table ppp0_route

# 添加规则：来自 ppp0 IP 的流量使用 ppp0_route 表
ip rule add from 1.2.3.4 table ppp0_route
```

---

### **步骤 3：启用负载均衡（可选）**

如果希望出站流量完全随机选择接口（不依赖源 IP），需配置 `multipath` 路由：

```bash
ip route add default \
    nexthop via 10.19.19.81 dev eno0 weight 1 \
    nexthop via 10.194.255.254 dev ppp0 weight 1
```

---

### **步骤 4：配置 NetworkManager 持久化**

上述命令重启后会失效，需通过 NetworkManager 持久化配置。

#### **eno0 连接配置（/etc/NetworkManager/system-connections/eno0.nmconnection）**

```ini
[ipv4]
method=manual
address1=10.19.19.8/24
route-table=100  # 指向自定义路由表
routing-rule1=priority 100 from 10.19.19.8 table 100
```

#### **ppp0 连接配置（/etc/NetworkManager/system-connections/ppp0.nmconnection）**

```bash
[ipv4]
method=auto
route-table=200  # 指向自定义路由表
routing-rule1=priority 200 from 1.2.3.4 table 200
```

---

### **最终验证**

1. **入站访问测试：**

- 从 eno0 的子网 ping `10.19.19.8`。
- 从 ppp0 的子网 ping `1.2.3.4`。
	
1. **出站负载均衡测试：**

```bash
# 追踪外网访问路径（如 8.8.8.8）
traceroute 8.8.8.8
```    

- 观察出口是否交替使用 eno0 和 ppp0。

---

### **故障排查**

- **检查路由表和规则：**

```bash
ip route show table eno0_route
ip route show table ppp0_route
ip rule list
```

- **检查连接跟踪：**

```bash
conntrack -L -d 8.8.8.8  # 查看 NAT 会话状态
```

通过以上配置，你的服务器将实现双网口负载均衡和双向可达。