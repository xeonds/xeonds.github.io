---
title: Arch Linux折腾笔记
date: 2023-09-05 21:39:57
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
  - Linux
cover: /img/89596288_p0_master1200.jpg
---

## 安装

参考 Arch Wiki 或者参考这个简化版教程：<https://arch.icekylin.online/>。过程按照教程一步步折腾就ok，只要注意区分清楚各个分区，别不小心把数据分区给格式化了就行。联网是安装Arch的必须项，所以请保持网络畅通。另外，建议**安装镜像最好在安装完成后继续保留着**，应急情况下（比如滚挂了）可以用`arch-chroot`来应急重装内核之类的。

>至于Arch经常被吐槽滚挂了的原因，主要是源自Arch的更新策略比较激进，更新完成后，会直接删除老内核，比起一般的更新策略更容易出现依赖问题造成“滚挂了“。

桌面环境、cn源、透明代理之类的配置，也可以参考上面的教程。关于透明代理，也可以参考[这篇文章](https://blog.linioi.com/posts/clash-on-arch/)。

## 美化

这点上因人而异。我装了layan主题之后，再换个壁纸，装个latte就差不多了。我的原则是，美化差不多就行，但是前提是别影响到系统性能。

## 显示适配

单显示器的配置很简单，改下dpi缩放就基本ok。如果是多显示器的话，就会复杂一些。参考下面的公式：

```bash
# 假设HiDPI显示器的分辨率是AxB，普通分辨率显示器的分辨率是CxD 
# 并且外置显示器的缩放比率是ExF
xrandr --output eDP-1 --auto --output HDMI-1 --auto --panning [C*E]x[D*F]+[A]+0 --scale [E]x[F] --right-of eDP-1
```

根据上面的公式来设置，基本上能搞定。当然，如果想调整的是内置HiDPI显示器分辨率，就得调整最后`panning`的A为Ax[A的缩放比率]。

## 参考链接

- [1] [Barry的笔记](https://nmgit.net/2020/139/)
- [2] [X11 多显示器配置：玩转 XRandR](https://harttle.land/2019/12/24/auto-xrandr.html)

## 启用外部ssh连接

如果想从外部连接到Arch的电脑上，只要安装了openssh就行。Arch默认不会启动`sshd`，所以我们得手动开启：

```bash
systemctl start sshd
```
## 在命令行连接Wi-Fi

在完成安装后，启动NetworkManager：

```bash
sudo systemctl enable --now NetworkManager
```

然后使用`nmcli`来连接Wi-Fi：

```bash
nmcli dev wifi list
# 后面的password部分不指定的话，会自动要求输入
nmcli dev wifi connect "SSID" password "password"
```

## 使用TimeShift备份系统

TimeShift是一个很好用的系统备份软件，特别是结合了btrfs之后，备份的体积比借助`rsync`时更小。

折腾系统时不时可能滚挂，这种时候有个定期创建的映像就很有用了。

```bash
sudo timeshift --list # 获取快照列表
sudo timeshift --restore --snapshot '20XX-XX-XX_XX-XX-XX' --skip-grub # 选择一个快照进行还原，并跳过 GRUB 安装，一般来说 GRUB 不需要重新安装
```

如果恢复后无法使用，用安装盘通过`arch-chroot`进去系统，然后手动更改`subvolid`来手动修复，或者直接删除`subvolid`：

```bash
# 获取subvolid
sudo btrfs sub list -u /
# 编辑,根据自己情况，修复
vim /etc/fstab
```

## 重启显示管理器（Xorg/Wayland）

```bash
sudo systemctl restart display-manager
```

## Vim

装上Arch之后我很快就把Vim装上了。结果发现没法和系统剪贴板联动。在Vim里边检查`has(clipboard)`之后发现，好像这个Vim不支持剪贴板。

解决方法：装`gvim`：`sudo pacman -S gvim`。会提示你是否卸载Vim，选是，配置不会删除所以放心删。安装完了之后你就会发现Vim还能用，而且剪贴板功能好了：

![](img/Pasted%20image%2020230926210217.png)

## 桌面目录映射

今天看到群里一个老哥家目录下的文件都堆到桌面了，顺便了解了一下关于桌面目录映射的问题。因为有时候中文模式创建的家目录下的文件夹都是中文，那个老哥就是改成英文目录的时候遇到了这个问题。

`XDG_DESKTOP_DIR`这个环境变量的介绍，在archWiki上也能翻到。

>[XDG_DESKTOP_DIR是一个环境变量，用于指定用户的桌面文件夹的位置。它是XDG Base Directory规范](https://wiki.archlinux.org/title/XDG_Base_Directory)[1](https://wiki.archlinux.org/title/XDG_Base_Directory)[的一部分，该规范定义了一些标准的用户目录，如音乐、图片、下载等，以及一些用于存储配置、缓存、数据和状态的目录。XDG_DESKTOP_DIR的默认值是$HOME/Desktop，但用户可以通过编辑~/.config/user-dirs.dirs文件或使用xdg-user-dirs-update命令来修改它](https://wiki.archlinux.org/title/XDG_user_directories)[2](https://wiki.archlinux.org/title/XDG_user_directories)。
>
>[KDE桌面环境遵循XDG Base Directory规范，并使用XDG_DESKTOP_DIR变量来确定桌面文件夹的位置。如果用户更改了XDG_DESKTOP_DIR的值，KDE会自动更新桌面设置，并将桌面文件夹更改为新的位置。这样，用户可以灵活地管理自己的桌面文件夹，而不影响其他应用程序或桌面环境](https://wiki.archlinux.org/title/Desktop_entries)[3](https://wiki.archlinux.org/title/Desktop_entries)。

所以出问题的话看看`.config`底下配置炸没炸就行。

## 添加多系统启动项

在安装Arch的时候，会发现中间有一步是`sudo vim /etc/default/grub`然后`grub-mkconfig -o /boot/grub/grub.cfg`。这一步就是先编辑grub的配置，然后生成grub文件到`/boot/grub/`下的配置文件中。因此，我们如果突然心血来潮想装个Windows玩玩~~谁装啊~~，就可以改改grub配置让它为我们添加启动项。

因为最终的配置项是由`grub-mkconfig`生成的，所以并不推荐直接修改这个文件。更好的做法是安装`os-prober`，然后挂载其他系统的分区，并编辑grub配置文件启用os探测，最后再用`grub-mkconfig`生成新的grub启动项文件。

>至于为啥grub现在默认禁用掉了os-prober，注释里边说的是因为安全问题所以禁用掉了。

## 代理配置

既然都上Arch了，那代理软件不得整个自由点的？直接扔了cfw，拥抱clash-core。具体配置教程参考[这篇](https://blog.linioi.com/posts/clash-on-arch/)，我给个简洁版的：

```bash
# 实在懒得sudo了
# 不过记得看清命令再回车
sudo su
pacman -S clash
mkdir -p /etc/clash

# 然后从provider那里下载yaml配置文件
# 假设文件名为config.yaml
mv ./config.yaml /etc/clash/
# 设置控制面板路径
# 我这里的控制面板路径在/etc/clash/clash-dashboard
echo 'external-ui: clash-dashboard' >> /etc/clash/config.yaml

# 配置环境变量，配完了记得重启/重新登陆一下
cat << EOF >> /etc/environment
https_proxy=http://127.0.0.1:7890
http_proxy=http://127.0.0.1:7890
all_proxy=http://127.0.0.1:7890
EOF

# 配置systemd服务项
# 配完了就能开机自启动了哦
cat << EOF > /etc/systemd/system/clash.service
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/clash -d /etc/clash # /usr/bin/clash 为绝对路径，请根据你实际情况修改

[Install]
WantedBy=multi-user.target
EOF

###############
# clash，启动！
###############
systemctl enable --now clash.service
```

里边比较重要的一步是配置环境变量env，上回配置的时候忘了加`http`前缀，结果系统里边啥玩意都不认我的代理设置。

哦对，配置完成之后还得在系统里边设置好代理：

![](img/Pasted%20image%2020231023164736.png)

>悲：cfw跑路之后clash-core也跑路了
>然后所有client都跑路了
>为clash家族 + 1s
>以及我的评价是：
>![](img/Pasted%20image%2020231103203831.png)
>以及某作者的睿频：
>最适合这个民族的其实是一群小
白围着大大转，大大通过小白的夸奖获得自我满足，然后小白的吃喝拉撒都包给大大解决的模式。通过这个项目我感觉我已经彻底认识到这个民族的前面为什么会有一堵墙了。没有墙哪来的大大。所以到处都是什么附件回帖可见，等级多少用户组可见，一个论坛一个大大供小白跪舔，不需要政府造墙，网民也会自发造墙。这尼玛连做个翻墙软件都要造墙，真是令人叹为观止。这是一个造了几干年墙的保守的农耕民族，缺乏对别人的基本尊重，不愿意分享，喜欢遮遮掩掩，喜欢小圈子抱团，大概这些传统是改不掉了吧。

另外还有一个，就是切换节点必须得使用clash的控制端口（在`config.yaml`中给出，一般是`9090`），所以还必须得有个控制面板。一般Windows平台都是用~~已经似了的~~Clash For Windows作为控制面板的，而Linux这边使用<https://clash.razord.top/>也就是~~也已经似了的~~[Clash的官方控制面板](https://github.com/Dreamacro/clash-dashboard/)作为控制面板的。实在不行了可以用命令行下的TUI工具`clashctl`来手动切换节点，应该也能用。

## RDP连接Windows

用Arch多了，有时候得偶尔远程一下Windows。配置了半天`Remmina`+`freerdp`，可能这玩意和我风水不合吧，半天跑不起来。遂尝试了下`rdesktop`，秒连（也不知道为啥）：

```bash
sudo pacman -S rdesktop
rdesktop 114.5.1.4
```

然后输账号密码登陆就行了。因为暂时这样就够用所以就没咋折腾。

## X11迁移Wayland
主要动机：支持一下双屏不同缩放的功能，不然一个高分屏+一个普通1080p的组合太痛苦了。

```bash
pacman -Qi wayland  # 已安装则继续，否则安装
sudo pacman -S --needed wayland
yay -S sddm-git     # 必须得是sddm-git，其他版本好像没完善的Wayland支持
pacman -S --needed xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
pacman -S --needed plasma kde-applications
pacman -S --needed plasma-wayland-session
```
按照[这里](https://linux.cn/article-16171-1.html)给出的流程，装完上面的包之后，Logout之后应该就能在左下角看到登陆`Plasma(Wayland)`的提示了。

>你还能通过查看 `$XDG_SESSION_TYPE` 变量来 核实你是否在运行 `Wayland`。

先去装了，一会回来记录。

装完了，兼容性没啥大问题，我甚至没重启，只是重新登陆了下。就是`latte-dock`的图标缩放看着怪怪的，而且桌面小组件也乱飞了。以及，输入法好像不太对劲，在firefox以外的地方皮肤会丢失。

刚重新设置了下屏幕排列，现在能单独设置两块屏幕的缩放了，爽。就是高分屏看着有点糊，以及字体缩放问题，还有这个fcitx也不太对劲。

先重启下看看吧。

草了，重启回来变回x11 seession了。找找默认值在哪保存着吧。

找到了，在`/usr/lib/sddm/sddm.conf.d/default.conf`里边，有一个`DisplayServer=x11`的项，把`x11`改为`wayland`应该就行了。重启看看。
