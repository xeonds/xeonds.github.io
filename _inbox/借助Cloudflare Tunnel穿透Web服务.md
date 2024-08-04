---
title: 借助Cloudflare Tunnel穿透Web服务
date: 2024-08-04 15:54:18
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

>感谢Cloudflare免费提供了这样的免费服务，真的好用qaq

我的服务器进化史从最早的低配云服务器学生机，到之后的电脑+公网便宜服务器内网穿透，终于到了现在的本地服务器+白嫖的公网穿透。

然后算了算电费域名费发现~~其实还是公网服务器最便宜~~。

## 注册域名

随便整一个。刚需，隧道穿透必须，最好是能把解析交给Cloudflare的域名。整了之后准备好备用。

## 注册Cloudflare账户

注册，完成之后绑定域名到你的Cloudflare账号下。

## 创建隧道

找到Cloudflare Dashboard最左侧的Zero Trust，点开后会跳转到另一个Dashboard中。

之后，找到右侧的Network并点击，找到Tunnel后，创建一个新的。

完成后，你应该能找到里边的Docker启动指令，我对此稍微改写了一下：

```yaml
version: '3.8'

services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    restart: always
    command: tunnel --no-autoupdate run --token [REPLACE_WITH_YOUR_TOKEN]
    network_mode: host
```

保存到`./cf-tunnel/docker-compose.yml`中，并将上面的Token换为你在上面的启动指令中找到的。完成后，使用`docker-compose up -d`来启动服务即可。

现在来到`Public Hostname`部分，开始添加你想转发的端口。每个端口我们都可以给它指定一个要匹配的子域名，并指定它要转发到的端口和地址。

>注意，因为`docker-compose`中写了`network_mode: true`，因此`cloudflared`的localhost就是你主机所在网络的localhost。所以说，如果当前机器上在`localhost:8000`部署了一个HTTP的Web服务，那么我们只需要添加`http://localhost:8000/即可。

完成后保存，现在访问试试，应该就能从公网通过你的域名访问你的服务了。

