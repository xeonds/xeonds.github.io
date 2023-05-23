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