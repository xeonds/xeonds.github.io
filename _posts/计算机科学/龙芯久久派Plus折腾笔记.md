---
title: 龙芯久久派Plus折腾笔记
date: 2024-09-12 15:41:18
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

> 感谢尚宇学长送的开发板，希望龙芯以后发展越来越好<(=w=)>

这回折腾用到的主要有：

- 本体：2k0300 久久派_Plus_V1.0
- 开发设备：Linux环境笔记本电脑
- 串口转接器：用一个老51开发板糊弄过去了（
- 路由器：提供稳定网络连接和局域网

## 开箱

![](img/Pasted%20image%2020240912154924.png)

![](img/Pasted%20image%2020240912155406.png)

尊贵的总裁签名版（虽然看不太清）↑

![](img/Pasted%20image%2020240912154938.png)

接口丰富度没得说，两个RJ45，两个USB2.0，一个3.5mm音频接口，UART，ADC，JTAG和Type-C供电，还有个MicroSD卡插槽。

这规格，只要三位数出头的价格，~~它就是炸了我都夸它炸得好听~~。稳定性跟功耗也没得说，ABI2.0的龙架构让它能拥有开源社区的支持，基本所有开源软件都可以通过交叉编译在这个板子上使用，未来可期属于是。

## 上电

手头刚好没USB转串口，想到个幽默办法。掏出以前的51单片机开发板HC6800MS，给ST89C52RC薅下来，TX，RX，GND分别接到开发板的RXD0，TXD0，GND上：

![](img/Pasted%20image%2020240912161052.png)

然后给那个老板子插电脑上：

![](img/Pasted%20image%2020240912160313.png)

诶，这不就有了吗。

现在就能用`screen`从串口连接上开发板了：

```bash
sudo screen /dev/ttyUSB0 115200
```

效果如下：

![](img/Pasted%20image%2020240912161227.png)

板子上电之后会默认启动WiFi热点，配置文件如下：

```bash
#/etc/hostapd.conf
interface=wlan0  
driver=nl80211  
ssid=LoongsonWIFI  
hw_mode=g  
channel=6  
macaddr_acl=0  
auth_algs=1  
ignore_broadcast_ssid=0  
wpa=2  
wpa_passphrase=loongson123456  
wpa_key_mgmt=WPA-PSK  
wpa_pairwise=TKIP  
rsn_pairwise=CCMP
```

虽然可以连上WiFi，但是它的`sshd`进程好像是默认不开启的。


哦它没有openssh啊。

## 交叉编译OpenSSH

准备目录./openssh并进入，下载源码：

```bash
wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.8p  
1.tar.gz
wget http://www.zlib.net/zlib-1.3.1.tar.gz
wget https://github.com/openssl/openssl/releases/download/openssl-3.3.  
2/openssl-3.3.2.tar.gz
for item in $(ls ./);do tar -zxvf $item; done
```

创建目录./openssh/install
创建脚本env.sh：

```bash
#!/bin/bash
export PATH="$PATH:/path/to/cross-tools/bin"
```

上面指向的是交叉编译工具链的路径，提前准备。

准备环境：`source ~/env.sh`

编译zlib：

```bash
cd zlib-1.3.1/
prefix=$HOME/2k300/openssh/zlib CC=loongarch64-unknown-linux-gnu-gcc AR=loongarch64-unknown-linux-gnu-ar ./configure
make
make install
```

编译`openssl`：

```bash
cd openssl-3.3.2/
./Configure linux64-loongarch64 --cross-compile-prefix=loongarch64-unknown-linux-gnu- --prefix=$HOME/2k300/openssh/install/openssl shared no-asm
make
make install
```

编译openssh：

```bash
./configure --host=loongarch64-unknown-linux-gnu --prefix=$HOME/2k300/openssh/install/openssh --with-ssl-dir=$HOME/2k300/openssh/install/openssl --with-zlib=$HOME  
/2k300/openssh/install/zlib LDFLAGS="-static -pthread" --sysconfdir=/etc/ssh --disable-strip
make
make install-files
```

> 注意 此处使用`~`概率会导致编译异常，使用`$HOME`代替

这里因为没找到在哪指定strip工具的位置而禁用了strip，所以产物会稍微有丶大。

编译结束之后，产物可以在`$HOME/2k300/openssh/install/openssh`中找到。直接把文件传输到99pi对应的目录里即可。

传输方法可以使用tty串口传输，不过速度太慢：

```bash
# server-side
uuencode [filename-in-99pi] < [file] > /dev/ttyUSB0
# 99pi-side
uudecode < /dev/ttyS0 
```

也可以使用tftp传输：

```bash
# server-side:
sudo uftpd -n -o ftp=0,tftp=69 ./
# 99pi-side
tftp -g -l ssh-xxx -r openssh/bin/ssh-xxx [114.5.1.4]
```

剩下的后面说。