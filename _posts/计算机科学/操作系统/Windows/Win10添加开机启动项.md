---
title: Win10添加开机启动项
tags:
  - Windows
excerpt: 用来解决Clash之类的软件的自启动再好不过了。再无聊点，还可以写一个开机自动化处理脚本（
toc: true
author: xeonds
date: '2021.07.25 23:36:00'
categories:
  - 计算机科学
  - 操作系统
  - Windows
---

### 方法一：开机启动文件夹

1、我们打开文件夹：C:\Users（用户）\Administrator（当前用户名）\AppData\Roaming\Microsoft\Windows\Start Menu\Programs（「开始」菜单）\Programs（程序）\Startup（启动 ）即可找到启动文件夹

PS：也可以在运行中粘贴以下路径回车打开

>%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

2、然后我们把软件的快捷方式，或是文件放到该启动文件夹中，Win10开机后就可以自动运行了。

### 方法二：注册表添加启动项

1、打开运行，输入“regedit”，打开注册表。

2、在注册表中找到如下位置HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run，右键“Run”新建一个字符串类型的键值。

3、右键新建的键值，选择“修改”，将数值名称改为 你要启动的程序名称如：ctfmon.exe，数值数据改为 程序所在位置的路径 如：C:\windows\system32\ctfmon.exe (直接不能修改名字的，可以先点击重命名，改好名字，再点击修改，修改数值数据)

4、最后，再重新启动win10你设置的程序就可以在Win10开机后自己启动了！

### 方法三：任务计划程序

1、在“我的电脑”-》“右键”-》“管理” ；

2、这时会打开任务计划程序，右边有一个创建基本任务和一个创建任务，我们先点开创建基本任务。

3、这个时候就需要你写一些名字啊，描述啊什么的，可以随便填一填，然后下一步。

4、这个时候要选择什么时候触发，可以选择什么时候开始执行。小编选择的是用户登录时，就是开机，输入密码登录后就执行，然后下一步。

5、选择一个操作，小编选择启动程序，然后选择一个批处理，因为我们的批处理不用传参，可选参数就不管了，直接下一步。

6、然后就完成啦，可以试试，开机的时候，会不会自启动。
