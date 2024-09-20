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

## 交叉编译

>[在x86设备上跨架构构建龙芯的Arch Linux软件包 - 星外之神的博客 | wszqkzqk Blog](https://wszqkzqk.github.io/2024/08/08/devtools-loong64/)
>[pacman/提示和技巧 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/Pacman/%E6%8F%90%E7%A4%BA%E5%92%8C%E6%8A%80%E5%B7%A7#%E4%BB%8E_CD/DVD_%E6%88%96_U_%E7%9B%98%E5%AE%89%E8%A3%85%E8%BD%AF%E4%BB%B6%E5%8C%85)
>[离线安装 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E7%A6%BB%E7%BA%BF%E5%AE%89%E8%A3%85)
>[从现有 Linux 发行版安装 Arch Linux - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/%E4%BB%8E%E7%8E%B0%E6%9C%89_Linux_%E5%8F%91%E8%A1%8C%E7%89%88%E5%AE%89%E8%A3%85_Arch_Linux#%E5%9C%A8%E5%AE%BF%E4%B8%BB%E7%B3%BB%E7%BB%9F%E4%B8%8A%E8%BF%90%E8%A1%8C_pacman)

### OpenSSH

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

### Vim

- ncurses: <https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz>
- vim: <https://github.com/vim/vim>

```bash
tar -zxvf ncurses-6.5.tar.gz && rm ncurses-6.5.tar.gz
cd ncurses-6.5/
./configure --prefix=$HOME/2k300/vim/nc_install --host=loongarch64-unknown-linux-gnu --without-cxx-binding --without-ada --without-progs --without-tests --with-shared
make -j && make install
```


```bash
export TARGET=loongarch64-unknown-linux-gnu

```

### Linux

#### 准备工作
把linux6.9源码里的

- `arch/loongarch/boot/dts`
- `include/dts-bindings`

复制到新的内核源码的对应位置，然后

```bash
make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- ls2k0300_99_pai_wifi_defconfig
make ARCH=loongarch CROSS_COMPILE=loongarch64-unknown-linux-gnu- -j8
```

## 安装Arch Linux

主要原因是aur比较香，而且软件分发也相对简单，反正pacman作为包管理够用。

### 大概思路

北大的LCPU整了个LA64的AUR镜像源：

[Arch Linux for Loongarch64](https://loongarchlinux.lcpu.dev/)

arch安装的核心就是准备一个能跑起来pacstrap的环境，然后就能用pacstrap去准备arch的rootfs了。

> 意外发现原来有LA64的arch安装iso，这下不用自己准备rootfs了，好耶
> 居然忘了3A6000已经能用Arch了

解压发现其中的`airootfs.sfs`，arch下安装`squashfs-tools`后，使用`sudo unsquashfs airootfs.sfs`解压rootfs。完成后编译一个`uImage`，丢到rootfs的`/boot`下。

准备一个ext4的U盘，将rootfs复制到其中。

U盘插入99pi，启动并进入uboot cli，输入：

```bash
ext4load usb 0 ${loadaddr} boot/uImage
bootm ${loadaddr}
```

手动启动系统。

不过启动失败了，查报错感觉问题可能出在指令集不兼容上了，似乎是LA64的SIMD指令在2k300上用不了。

下一步应该就是手动编译一个arch rootfs再安装了。

## 刷uboot

可以借助tftp刷入，也可以usb刷入。我用了后一种方法：

```bash
# 主系统
mkfs.ext2 /dev/sdb    # 格式化U盘
mount /dev/sdb ./tmp
cp u-boot-spl-gz.bin ./tmp/
umount ./tmp
```

```bash
# 99pi
# 插入U盘
# 启动时多次按c进入PMON控制台
fload /dev/fs/ext2@usb0/u-boot-spl-gz.bin
```

下面是输出：

```bash
PMON> fload /dev/fs/ext2@usb0/u-boot-spl-gz.bin                                                            /  
Loading file: /dev/fs/ext2@usb0/u-boot-spl-gz.bin dl_offset 900000000f800000 addr 900000000f800000  
(bin)                                                                                                      |  
Loaded 580432 bytes  
  
Programming flash 900000000f800000:8db50 into 800000001c000000  
Erase end!                                                                                                 /  
Programming end!  
Verifying FLASH. No Errors found.  
PMON>
```

此时就完成了，可以重启了。

## 编译busybox最小系统

流程很简单：

```bash
	mkdir -p ./{src,}
```

### 问题

- 编译失败

不知道为啥，换`musl-gcc`就可以了。

- `make menuconfig`总是会失败

刚开始以为确实是依赖问题，把能想到的玩意都装了一圈之后觉得不对劲上Arch Wiki搜了一下：

[[已解决] make menuconfig 和 ncurses 库的问题 / 新手 / Arch Linux 论坛](https://bbs.archlinux.org/viewtopic.php?id=295859)
[esp8266-rtos-sdk-aur-ncurses-fix.patch - aur.git - AUR Package Repositories](https://aur.archlinux.org/cgit/aur.git/tree/esp8266-rtos-sdk-aur-ncurses-fix.patch?h=esp8266-rtos-sdk)

最后发现是`./scripts/kconfig/lxdialog/check-lxdialog.sh`的锅。里边的`check()`函数对main的写法有问题：应该在下图的main()前面加上int才能正常check到是否安装了ncurses库。

![](img/Pasted%20image%2020240920214920.png)

- 启动失败

我这里是因为menuconfig总是失败所以没法开**Build static binary**，开开就能跑了。