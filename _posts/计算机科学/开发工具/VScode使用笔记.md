---
title: VScode使用笔记
tags: IDE
excerpt: IDE就是程序员的老婆，必须收拾得赏心悦目才是啊（确信
toc: true
author: xeonds
date: 2021.07.18 22:42:25
categories:
  - 计算机科学
---

## 毛玻璃效果：Vibrnancy

### 安装Vibrnancy

直接在VScode插件市场里搜，安装图里这个就好了。

![就这个](/img/vf-1.png)

### 配置

安装完后别急着关。点击卸载旁边的小齿轮，进入扩展设置。

![](img/vf-2.png)

设置里搜vibrancy，回车。按照图片里的设置即可。

![](img/vf-3.png)

完成后，右下角会弹出确认。一路确认即可。

![](img/vf-4.png)

完事儿。

### 后记

* 需要注意的一点是，这个插件每次更新VSCode就要重新运行Reload Vibrancy。
* 如果不起作用，重新启动一下VSCode，应该就好了。
* ~~咱现在已经不用这个插件了（返璞归真×还是原皮好看√~~

## 文档比对

* 打开VSCODE，点击【File】--》【Add Folder to Workspace...】浏览打开要对比文件所在的文件夹。

![](https://exp-picture.cdn.bcebos.com/3d002dbad341037da04ae1c2a9bc7dc5ce672dd1.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fformat%2Cf_jpg%2Fquality%2Cq_80)

* 导入成功后就能看在VSCODE的左侧看到已经将文件导入到工作空间。

![](https://exp-picture.cdn.bcebos.com/23fd63c5cf672b5f923b2d223314f4d0b40327d1.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fformat%2Cf_jpg%2Fquality%2Cq_80)

* 按CTRL键选中要对比的两个文件，并右击选择【Compare Selected】开始对比文件。

![](https://exp-picture.cdn.bcebos.com/b955ead0b503c8d20b836ffa498333bf3aef21d1.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fformat%2Cf_jpg%2Fquality%2Cq_80)

* VSCODE会将两个文件按左右分隔，不一样的地方会红色高亮显示，右侧的状态柱标红色的地方就表示为不同，可以直接点击红色的地方快速查看。

![](https://exp-picture.cdn.bcebos.com/32fe25ef354f50b8e043806fdc4afa32929c18d1.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fformat%2Cf_jpg%2Fquality%2Cq_80)

## 格式化风格配置

1.  ctrl + p 打开 setting.json
2.  输入以下内容保存即可

```json
"C_Cpp.clang_format_style": "{ BasedOnStyle: Chromium, IndentWidth: 4}",
```

## 快捷键集锦

1. 折叠/展开当前行 `Ctrl+Shift+[/]`
2. 文本自动换行 `Alt+Z`
command + p 搜索文件  
command + shift + o 搜索当前文件里的 symbol  
command + t 全局搜索 symbol  
command + f 当前文件文本搜索  
command + shift + f 全局文本搜索  
Windows 上把 command 替换成 ctrl 应该就可以。

## 移动

我喜欢用`Vim`的一个重要原因就是能完全使用键盘就到处移动，没有切换负担。不过因为写前端又开始经常用VSCode了。以前没发现的快捷键现在也偶尔不小心按出来了。别说，加上`Vim`插件之后还真挺丝滑。

VSCode里边移动的主要问题是各个区域之间的移动。比如主编辑区域，底部终端，左侧快捷栏这几个。左侧的移动可以把鼠标放按钮上边直接看到，比如目录树是`ctrl+shift+E`，Git是`ctrl+shift+G`之类的。不过现在侧边提供的功能除了看个文件列表之外我很少用其他的（哎对还有CodeGeeX）。

所以重点是咋在主编辑区域和底栏的终端之间移动。其实很简单，编辑区域使用`ctrl+1234...`在编辑器的各个分栏之间移动。比如左右分栏的话，使用`ctrl+1`定位到左边的编辑区域，`ctrl+2`定位到右边的编辑区域。在一个编辑器选项组中，用`alt+1234...`切换到对应的待编辑文件。比如左边的分屏里边开了仨文件，就可以用`alt+123`在这三个里边移动。

移动到下边的编辑器窗口也是用`ctrl`，不过是`ctrl+\``（就是1左边那个键）。新建终端是`ctrl+shift+\``。不过和上边比较割裂的是，终端里边不能用`alt+1234...`的组合键来切换终端。不过，倒是可以用`ctrl+shift+5`来给终端分屏，然后用`alt+左右`来在左边和右边的终端里边切换。

哦刚查了下快捷键，发现其实可以用`ctrl+pgup/pgdown`切换上一个/下一个终端。这个快捷键也在上面的编辑器组里边可以用。这下操作也算是统一了一点。

然后就是在各个文件里边的移动。第一个方式是借助左侧文件导航栏，第二个方式是在终端里边直接`code path/to/filename`，这会在当前的编辑器组里边打开这个文件。第三个方式是用`ctrl+p`打开文件搜索，就跟JetBrains那个按两下`shift`就跳转到任意文件用法一样，但是速度比前者快一些。

另外就是查找符号定义的方法。这个在阅读源码的时候特别有用，我一般在左边打开那个文件树底下的**大纲**，然后右边遇到一个想看的函数就`f12`跳转到定义，或者`ctrl+t`全局查找符号。或者还饿可以`ctrl+shift+f`用左边的全局搜索替换来全局搜索，就是记得如果要批量替换什么东西的话，建议先提前做个备份，推荐git。

## 行尾

Windows整烂活非要用那xx的CRLF当行尾标记，所以每次在Windows上GIt commit的时候都会看到Git自己给我们转换行尾格式。不过还好VSCode有默认行尾标记的功能。

在设置里边搜索`eol`，把它改成`\n`就行了（Windows默认是`\r\n`）。这样，文件的默认换行就是`\n`了。

或者，在`settings.json`里边附加这个设置项：

```
"files.eol": "\n"
```
