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

关于fcitx，系统给了一段报错：

```
Fcitx should be launched by KWin under KDE Wayland in order to use Wayland input method frontend. This can improve the experience when using Fcitx on Wayland. To configure this, you need to go to "System Settings" -> "Virtual keyboard" and select "Fcitx 5" from it. You may also need to disable tools that launches input method, such as imsettings on Fedora, or im-config on Debian/Ubuntu. For more details see https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma 
```

先重启下看看吧。

草了，重启回来变回x11 seession了。找找默认值在哪保存着吧。

找到了，在`/usr/lib/sddm/sddm.conf.d/default.conf`里边，有一个`DisplayServer=x11`的项，把`x11`改为`wayland`应该就行了。重启看看。

好像不太行，而且现在切不过去Wayland了，坏。

把设置都改回去了，现在好像能进去了。但是还是默认进入x11的plasma桌面。

哎，把用户空间的那个sddm configuration改了一下，删了里边的[Autologin]底下的session=的值，重启下试试。以及又得到了一段关于fcitx的建议：

```
Detect GTK_IM_MODULE and QT_IM_MODULE being set and Wayland Input method frontend is working. It is recommended to unset GTK_IM_MODULE and QT_IM_MODULE and use Wayland input method frontend instead. For more details see https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma
```

好好好搞定了。按照上面的设置先屏蔽了俩环境变量，然后删除了默认值，现在系统已经处于完全可用的状态。回头有时间了整理整理过程。

>Fri 22 Dec 2023 05:14:55 PM CST

## 又出问题了

小笔记本上的arch的kde以至于其中的所有程序突然都变得特别卡。最奇怪的是这会的系统资源专用状况完全没有多高，CPU%，MEM37.4%的占用率应该很健康了吧。

觉得的卡顿是因为我发现就连tmux里边开个vim写文档都卡得不行了才觉得不对劲。

```bash
systemd-+-NetworkManager
        |-bluetoothd
        |-clash
        |-dbus-daemon
        |-polkitd
        |-rtkit-daemon
        |-sddm-+-Xorg
        |      `-sddm-helper---startplasma-x11
        |-systemd-+-(sd-pam)
        |         |-adb
        |         |-agent
        |         |-at-spi-bus-laun---dbus-daemon
        |         |-at-spi2-registr
        |         |-chrome_crashpad
        |         |-dbus-daemon
        |         |-dconf-service
        |         |-fcitx5
        |         |-gmenudbusmenupr
        |         |-gvfs-udisks2-vo
        |         |-gvfsd-+-gvfsd-dnssd
        |         |       |-gvfsd-network
        |         |       `-gvfsd-trash
        |         |-gvfsd-fuse
        |         |-gvfsd-metadata
        |         |-kaccess
        |         |-kactivitymanage
        |         |-kded5
        |         |-kglobalaccel5
        |         |-konsole---bash---tmux: client
        |         |-krunner---qq-+-qq---qq
        |         |              |-qq---2*[qq]
        |         |              `-qq
        |         |-kscreen_backend
        |         |-ksmserver---DiscoverNotifie
        |         |-ksystemstats
        |         |-kwalletd5
        |         |-kwin_x11
        |         |-latte-dock
        |         |-linuxqq
        |         |-obexd
        |         |-org_kde_powerde
        |         |-pipewire
        |         |-pipewire-media-
        |         |-plasmashell---crow
        |         |-polkit-kde-auth
        |         |-pulseaudio---gsettings-helpe
        |         |-tmux: server-+-2*[bash---vim]
        |         |              `-bash---sudo---sudo---pstree
        |         |-2*[xdg-desktop-por]
        |         |-xdg-document-po---fusermount3
        |         |-xdg-permission-
        |         `-xembedsniproxy
        |-systemd-journal
        |-systemd-logind
        |-systemd-udevd
        |-udisksd
        |-upowerd
        `-wpa_supplicant
```

上面是`sudo pstree -T`的输出，感觉这种卡顿可能就是de内存溢出了。理论上我感觉只要重启一下sddm马上就能变流畅。但是在这之前我想知道更详细的信息。

先把qq关了试试。不出所料还是很卡。上google搜一下吧。

草了，看到一个哥们系统偶尔卡顿最后发现是SSD挂掉的前兆。想起来这个本子用的是三星的老固态，系统盘的文件系统是btrfs；前几天还看群里某群u吐槽说btrfs在他那边对于固态寿命损伤挺严重的。也不知道是不是btrfs的问题。不过好在重要数据都有备份，丢了也不心疼，全从服务器上sync下来就行了。

不过应该这次不是固态的问题，应该还是sddm本身的问题，不然很难解释怎么所有gui里边的东西都开始卡顿了

```bash
TIME                           PID  UID  GID SIG     COREFILE EXE                           SIZE
Sun 2023-10-29 23:52:21 CST   2030 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Thu 2023-11-02 13:07:56 CST   3084    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Thu 2023-11-02 17:15:49 CST  36261 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Thu 2023-11-02 23:44:53 CST   1795 1000 1000 SIGTRAP missing  /tmp/.mount_linuxqFrCYKS/qq      -
Sat 2023-11-04 18:43:36 CST   1640 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Sat 2023-11-04 18:45:41 CST   2255    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Sat 2023-11-04 18:46:34 CST   2300    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Sun 2023-11-05 18:16:28 CST  19274 1000 1000 SIGABRT missing  /opt/vscodium-bin/codium         -
Sun 2023-11-05 18:16:30 CST  19330 1000 1000 SIGABRT missing  /opt/vscodium-bin/codium         -
Sun 2023-11-05 22:13:13 CST  14279 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Thu 2023-11-09 23:30:51 CST  14724 1000 1000 SIGTRAP missing  /qq                              -
Thu 2023-11-09 23:38:16 CST  15804 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Fri 2023-11-10 01:08:53 CST  14773 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Tue 2023-11-14 09:04:45 CST   5996 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Tue 2023-11-14 09:47:58 CST  10033 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Tue 2023-11-14 10:15:41 CST  75599 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Tue 2023-11-14 10:30:25 CST  13990 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Tue 2023-11-14 17:47:23 CST    575 1000 1000 SIGABRT missing  /usr/bin/plasmashell             -
Tue 2023-11-14 21:00:24 CST  18347 1000 1000 SIGABRT missing  /usr/bin/plasmashell             -
Wed 2023-11-15 00:34:08 CST  26489 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Wed 2023-11-15 01:14:11 CST  28479 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Wed 2023-11-15 11:34:37 CST  19955 1000 1000 SIGSEGV missing  /usr/bin/plasmashell             -
Wed 2023-11-15 23:54:02 CST  36282 1000 1000 SIGSEGV missing  /opt/visual-studio-code/code     -
Fri 2023-11-17 00:45:55 CST  16467 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Fri 2023-11-17 00:45:56 CST  40168 1000 1000 SIGTRAP missing  /qq                              -
Sat 2023-11-18 01:12:06 CST  17969 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:06 CST  15257 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:06 CST  17286 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:56 CST  19088 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:56 CST  19770 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:56 CST  18906 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:56 CST  19731 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:56 CST  19689 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:12:57 CST  19591 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:10 CST  25066 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:11 CST  25053 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:11 CST  20320 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:11 CST  24308 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:13 CST  25240 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:13 CST  25205 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 01:13:14 CST  25646 1000 1000 SIGABRT missing  /usr/bin/ccze                    -
Sat 2023-11-18 22:14:12 CST    576 1000 1000 SIGABRT missing  /usr/bin/plasmashell             -
Sat 2023-11-18 23:37:15 CST   2175 1000 1000 SIGABRT missing  /usr/bin/plasmashell             -
Sun 2023-11-19 12:59:47 CST   4430    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Sun 2023-11-19 13:00:33 CST   4459    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Sun 2023-11-19 13:00:34 CST   4469    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Sun 2023-11-19 13:06:05 CST   5821    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-11-20 20:53:13 CST    588 1000 1000 SIGSEGV missing  /usr/bin/plasmashell             -
Mon 2023-11-20 20:56:33 CST   6077 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Mon 2023-11-20 22:56:05 CST   5427 1000 1000 SIGABRT missing  /usr/bin/plasmashell             -
Mon 2023-11-20 22:59:54 CST  18385    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Tue 2023-11-21 23:30:23 CST  12137 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:25 CST  12093 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:26 CST  17572 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:26 CST  12015 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:26 CST  12016 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:27 CST  12459 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:27 CST  12003 1000 1000 SIGBUS  missing  /qq                              -
Tue 2023-11-21 23:30:28 CST  12043 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Fri 2023-11-24 00:01:53 CST  14600 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Sat 2023-11-25 02:40:58 CST  32138 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Tue 2023-11-28 23:33:11 CST  41077 1000 1000 SIGTRAP missing  /qq                              -
Wed 2023-11-29 11:43:44 CST  43973 1000 1000 SIGABRT missing  /usr/bin/adb                     -
Wed 2023-11-29 11:44:06 CST  45189 1000 1000 SIGABRT missing  /usr/bin/adb                     -
Wed 2023-11-29 23:29:56 CST  53151 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Wed 2023-11-29 23:45:58 CST  55228 1000 1000 SIGSEGV missing  /opt/visual-studio-code/code     -
Thu 2023-11-30 00:13:43 CST  42637 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Sat 2023-12-02 01:12:16 CST  56991 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Mon 2023-12-04 10:28:09 CST  77126 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Mon 2023-12-04 15:18:23 CST  99034    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-12-04 15:19:05 CST  99068    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-12-04 15:20:45 CST  99231    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-12-04 15:54:13 CST 104472 1000 1000 SIGSEGV missing  /home/xeonds/code/pizip/pi       -
Mon 2023-12-04 15:54:45 CST 104495 1000 1000 SIGSEGV missing  /home/xeonds/code/pizip/pi       -
Mon 2023-12-04 15:55:06 CST 104521 1000 1000 SIGSEGV missing  /home/xeonds/code/pizip/pi       -
Mon 2023-12-04 15:55:36 CST 104541 1000 1000 SIGSEGV missing  /home/xeonds/code/pizip/pi       -
Mon 2023-12-04 17:28:20 CST 104920 1000 1000 SIGBUS  missing  /chrome_crashpad_handler         -
Mon 2023-12-04 23:36:35 CST 119295 1000 1000 SIGSEGV missing  /opt/visual-studio-code/code     -
Wed 2023-12-06 11:18:53 CST  16426    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-12-11 19:56:40 CST  97572 1000 1000 SIGTRAP missing  /tmp/.mount_linuxqSV6RFp/qq      -
Tue 2023-12-12 01:01:33 CST 123670 1000 1000 SIGTRAP missing  /opt/visual-studio-code/code     -
Fri 2023-12-15 14:50:41 CST  17039 1000 1000 SIGTRAP missing  /tmp/.mount_linuxqkQn53G/qq      -
Sat 2023-12-16 23:55:13 CST  19892 1000 1000 SIGTRAP missing  /opt/visual-studio-code/code     -
Mon 2023-12-18 13:16:16 CST  28074    0    0 SIGABRT none     /usr/bin/fcitx5-remote           -
Mon 2023-12-18 15:08:22 CST  41701 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Tue 2023-12-19 21:37:06 CST  17530 1000 1000 SIGFPE  missing  /home/xeonds/code/c4/a.out       -
Tue 2023-12-19 23:39:47 CST  20684 1000 1000 SIGTRAP missing  /tmp/.mount_linuxqllS3Xz/qq      -
Wed 2023-12-20 12:31:27 CST  23806 1000 1000 SIGABRT missing  /usr/bin/clashctl                -
Sun 2023-12-24 19:26:26 CST   5873 1000 1000 SIGTRAP present  /qq                           1.6M
Mon 2023-12-25 01:59:52 CST   5951 1000 1000 SIGBUS  present  /chrome_crashpad_handler     42.5K
```

上面是`coredumpctl`的输出。好像sddm还没崩溃呢。再看看journal：

```bash
Dec 24 02:28:08 ark-station-breeze systemd[1]: Started Simple Desktop Display Manager.
░░ Subject: A start job for unit sddm.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
░░ 
░░ A start job for unit sddm.service has finished successfully.
░░ 
░░ The job identifier is 108.
Dec 24 02:28:08 ark-station-breeze sddm[407]: Initializing...
Dec 24 02:28:08 ark-station-breeze sddm[407]: Starting...
Dec 24 02:28:08 ark-station-breeze sddm[407]: Logind interface found
Dec 24 02:28:08 ark-station-breeze sddm[407]: Adding new display...
Dec 24 02:28:08 ark-station-breeze sddm[407]: Loaded empty theme configuration
Dec 24 02:28:08 ark-station-breeze sddm[407]: Xauthority path: "/run/sddm/xauth_bDCTVn"
Dec 24 02:28:08 ark-station-breeze sddm[407]: Using VT 2
Dec 24 02:28:08 ark-station-breeze sddm[407]: Display server starting...
Dec 24 02:28:08 ark-station-breeze sddm[407]: Writing cookie to "/run/sddm/xauth_bDCTVn"
Dec 24 02:28:08 ark-station-breeze sddm[407]: Running: /usr/bin/X -dpi 120 -background none -seat seat0 vt2 -auth /run/sddm/xauth_bDCTVn -noreset -displayfd 16
Dec 24 02:28:09 ark-station-breeze sddm[407]: Setting default cursor
Dec 24 02:28:09 ark-station-breeze sddm[407]: Running display setup script  "/usr/share/sddm/scripts/Xsetup"
Dec 24 02:28:09 ark-station-breeze sddm[407]: Display server started.
Dec 24 02:28:09 ark-station-breeze sddm[407]: Reading from "/usr/local/share/xsessions/plasma.desktop"
Dec 24 02:28:09 ark-station-breeze sddm[407]: Reading from "/usr/share/xsessions/plasma.desktop"
Dec 24 02:28:09 ark-station-breeze sddm[407]: Session "/usr/share/xsessions/plasma.desktop" selected, command: "/usr/bin/startplasma-x11" for VT 2
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: [PAM] Starting...
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: [PAM] Authenticating...
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:auth): pam_kwallet5: pam_sm_authenticate
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: [PAM] Preparing to converse...
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:auth): pam_kwallet5: Couldn't get password (it is empty)
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: [PAM] Conversation with 1 messages
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:auth): pam_kwallet5: Empty or missing password, doing nothing
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: [PAM] returning.
Dec 24 02:28:09 ark-station-breeze sddm[407]: Authentication for user  "xeonds"  successful
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:setcred): pam_kwallet5: pam_sm_setcred
Dec 24 02:28:09 ark-station-breeze sddm-helper[433]: pam_unix(sddm-autologin:session): session opened for user xeonds(uid=1000) by xeonds(uid=0)
Dec 24 02:28:10 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:session): pam_kwallet5: pam_sm_open_session
Dec 24 02:28:10 ark-station-breeze sddm-helper[433]: pam_kwallet5(sddm-autologin:session): pam_kwallet5: open_session called without kwallet5_key
Dec 24 02:28:10 ark-station-breeze sddm-helper[433]: Writing cookie to "/tmp/xauth_XpVcsc"
Dec 24 02:28:10 ark-station-breeze sddm-helper[433]: Starting X11 session: "" "/usr/share/sddm/scripts/Xsession \"/usr/bin/startplasma-x11\""
Dec 24 02:28:10 ark-station-breeze sddm[407]: Session started true
```

哦还有xorg的：

```bash
-- No entries --
```

好吧空的。那看看top

```bash

[?1h=[?25l[H[J[mtop - 15:10:25 up 1 day, 12:42,  1 user,  load average: 1.40, 1.33, 1.29[m[39;49m[m[39;49m[K
任务:[m[39;49m[1m 204 [m[39;49mtotal,[m[39;49m[1m   3 [m[39;49mrunning,[m[39;49m[1m 201 [m[39;49msleeping,[m[39;49m[1m   0 [m[39;49mstopped,[m[39;49m[1m   0 [m[39;49mzombie[m[39;49m[m[39;49m[K
%Cpu(s):[m[39;49m[1m 28.6 [m[39;49mus,[m[39;49m[1m  0.0 [m[39;49msy,[m[39;49m[1m  0.0 [m[39;49mni,[m[39;49m[1m 71.4 [m[39;49mid,[m[39;49m[1m  0.0 [m[39;49mwa,[m[39;49m[1m  0.0 [m[39;49mhi,[m[39;49m[1m  0.0 [m[39;49msi,[m[39;49m[1m  0.0 [m[39;49mst[m[39;49m[m [m[39;49m[m[39;49m[K
MiB Mem :[m[39;49m[1m   7835.3 [m[39;49mtotal,[m[39;49m[1m    584.1 [m[39;49mfree,[m[39;49m[1m   3807.3 [m[39;49mused,[m[39;49m[1m   4760.9 [m[39;49mbuff/cache[m[39;49m[m [m[39;49m[m    [m[39;49m[m[39;49m[K
MiB Swap:[m[39;49m[1m      0.0 [m[39;49mtotal,[m[39;49m[1m      0.0 [m[39;49mfree,[m[39;49m[1m      0.0 [m[39;49mused.[m[39;49m[1m   4028.0 [m[39;49mavail Mem [m[39;49m[m[39;49m[K
[K
[7m 进程号 USER      PR  NI    VIRT    RES    SHR    %CPU  %MEM     TIME+ COMMAND  [m[39;49m[K
[m[1m    411 root      20   0  859280  87628  30916 R  90.9   1.1 248:56.68 Xorg     [m[39;49m[K
[m[1m  19316 xeonds    20   0 4028616 892492 271492 R  72.7  11.1   0:17.50 firefox  [m[39;49m[K
[m  19461 xeonds    20   0 2713128 171852  88252 S  18.2   2.1   0:06.27 WebExte+ [m[39;49m[K
[m[1m  19901 xeonds    20   0   15440   5760   3584 R   9.1   0.1   0:00.01 top      [m[39;49m[K
[m      1 root      20   0   22220  10228   7028 S   0.0   0.1   0:02.61 systemd  [m[39;49m[K
[m      2 root      20   0       0      0      0 S   0.0   0.0   0:00.04 kthreadd [m[39;49m[K
[m      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00 pool_wo+ [m[39;49m[K
[m      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m      7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m      9 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m     12 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker+ [m[39;49m[K
[m     14 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tas+ [m[39;49m[K
[m     15 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tas+ [m[39;49m[K
[m     16 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tas+ [m[39;49m[K
[m     17 root      20   0       0      0      0 S   0.0   0.0   0:30.95 ksoftir+ [m[39;49m[K[?1l>[25;1H
[34h[?25h[K
```

抽象是抽象了点，但是能看出来好像是Xorg在发电，试试去tty重启xorg看看。

最后发现Xorg是sddm启动的，没办法直接重启了下sddm，问题解决，但是最不爽的是不知道问题到底是咋解决的。
