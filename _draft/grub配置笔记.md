---
title: grub配置笔记
excerpt: 最近在本子上装上了Linux，于是就使用了grub作为引导管理程序。这程序能够引导多种系统，也有强大的自定义选项。
toc: true
author: xeonds
date: 2023-03-19 18:56:47
---

## 准备

`/etc/grub.d/`下面的`40_custom`是我们的编辑目标。

## 开始

1. 编辑自定义启动项菜单`sudo vim /etc/grub.d/40_custom`，并输入下面的内容：

```grub
menuentry 'Microsoft Windows 11' {
	insmod part_gpt
	insmod fat
	insmod chain
	search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1 B6E8-3C7D
	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

上面是我Win11的自定义项目，后面再补充应该如何编写。

2. 更新引导菜单：`grub2-mkconfig -o /etc/grub2.cfg`

这样应该就能看到新的启动项了。

## UI配置

要修改Grub的界面，我们需要编辑/etc/default/grub文件。该文件包含了Grub的默认配置，我们可以在其中添加自定义配置，例如修改背景图片、添加自定义菜单等。

以下是一些常用的Grub界面配置选项：

1. 修改背景图片

要修改Grub的背景图片，我们需要将自己的图片文件复制到/boot/grub/目录下，并在/etc/default/grub文件中添加以下配置：

GRUB_BACKGROUND="/boot/grub/mybackground.png"

其中，mybackground.png是我们自己的图片文件名。

2. 添加自定义菜单

要添加自定义菜单，我们需要编辑/etc/grub.d/40_custom文件，并在其中添加menuentry命令，例如：

menuentry 'My Custom OS' {
    set root=(hd0,1)
    linux /boot/vmlinuz-custom root=/dev/sda1
    initrd /boot/initrd-custom
}

上面的代码中，我们添加了一个名为“My Custom OS”的启动项，它的内核文件是/boot/vmlinuz-custom，根文件系统是/dev/sda1，initrd文件是/boot/initrd-custom。

添加完自定义启动项后，我们需要使用grub2-mkconfig命令生成新的配置文件，例如：

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

这样就可以在Grub菜单中看到我们添加的自定义启动项了。

3. 修改菜单颜色

要修改Grub菜单的颜色，我们需要在/etc/default/grub文件中添加以下配置：

GRUB_COLOR_NORMAL="light-blue/black"
GRUB_COLOR_HIGHLIGHT="light-cyan/blue"

其中，GRUB_COLOR_NORMAL是菜单项的默认颜色，GRUB_COLOR_HIGHLIGHT是菜单项被选中时的颜色。
