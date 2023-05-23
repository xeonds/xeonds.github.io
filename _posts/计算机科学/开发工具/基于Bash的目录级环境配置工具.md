---
title: 基于Bash的目录级环境配置工具
date: 2023-09-26 23:46:55
author: xeonds
toc: true
excerpt: 这不比Windows爽
tags: 
cover: /img/Pasted%20image%2020230926234956.png
---
最近对于Bash愈发迷恋，几乎任何会花费我超过30秒时间的任务，我都会考虑~~打个脚先~~写个脚本搞定。再比如说写博客，这种纯输出流就很适合Vim啊，作为一个Vim~~批~~必然是原教旨主义最好啊：

![算了截图还是用Obsidian粘吧](img/Pasted%20image%2020230926235753.png)

但是除了截图粘贴不方便外，还有一些比较难受的地方。在Obsidian里边我是能直接用插件的各种功能快速编写博客的，虽然在Bash终端环境下编写脚本确实更方便了，但是脚本一多，目录就乱的不能看力：

```bash
# 强迫症是病，得治
.
├── about
├── _archive
├── deploy.sh
├── _draft
├── how-much-did-i-write.sh
├── img
├── img-uri-process.sh
├── _inbox
├── links
├── new-post.sh
├── _posts
└── _scaffolds

9 directories, 4 files
```

三个脚本，一个是统计字数的，一个是用`sed`处理图片链接的，还有一个是从模板新建博客的。每次打开目录看到这仨在中间总觉得很别扭。

除了这，还有就是用起来也不方便：前面要是不加`./`就能直接用就好了~~懒也是病得治~~

所以，需求大概就是这样：目录级别的环境变量配置，并且支持还得够完善，不能离开目录了配置还在生效，不然脚本在其他目录跑飞了想想就恐怖。

## Basic Implementation

首先定位清楚，这个对`cd`的Hook只是在指令完成后，加载或者取消配置局部环境变量。因此大概实现方式和结构都有合适的选择。

- 程序扔`~/.bashrc`里，或者`/etc/profile`里。不过我一般在GUI用konsole比较多，所以就放`.bashrc`里了，也方便dotfile管理。
- 把具体实现用`alias`赋别名为`cd`达到重载（或者说Hook)`cd`的目的。

基于上面这两条，这是我写一个粗略实现（没干掉bash基本使用就是能用

```bash
function cd_hook() {
    # The normal cd
    if [ $# == 0 ]; then
        cd
    else
        cd "$1" 
	fi
    # If the dir contains bashrc, launch the sub shell and load it
    if [ -f ".bashrc" ] && [ "$(pwd)" != "$(getent passwd $USER | awk -F ':' '{print $6}')" ]; then
        pushd .  > /dev/null
        bash --init-file <(cat /etc/profile ~/.bashrc .bashrc)
    fi
}

alias cd='cd_hook'
```

上面有依托用来检测是否是家目录的指令来避免套娃（虽然理论上充重复加载家目录配置应该没啥）,然后是检测当前目录下（因为是先`cd`过去的嘛，所以`pwd`已经变了）是否有`.bashrc`，有的话就把它作为子参数，和家目录下的bashrc一起传给子bash，然后启动它。

这样就能实现cd后自动加载目录下的配置了。赶紧试试：

```bash
# My blog's utiilties and aliases
set -e
TMPL=$(find ./_scaffolds | grep .md)

function deploy() {
    cd ..
    (
        rm -rf deploy && cp -r blog deploy
        cd deploy && git checkout deploy
        cp -r blog deploy/source
        cd deploy && pnpm i && pnpm run server
    )
}

function image_url_proc() {
    find . -type f -name "*.md" -exec sed -i 's/\!\[\[\(.*\)\/\(.*\)\]\]/\!\[\2\]\(\/img\/\2\)/gi' {}
}

function new_post() {
    sed -e "s/{{title}}/$1/" -e "s/{{date}} {{time}}/$(date '+%Y-%m-%d %H:%M:%S')/" $TMPL
}

function line_count() {
    echo "You have wrote $(find _* -name *.md | xargs cat 2>/dev/null | wc -l) lines in total!"
}
```

cd到目录里边试试`line_count`：

```bash
xeonds@ark-station-breeze:~/Documents/blog$ line_count
You have wrote 36570 lines in total!
xeonds@ark-station-breeze:~/Documents/blog$ 
```

好好好，再看看目录结构：

```bash
.
├── .bashrc
├── about
├── _archive
├── _draft
├── img
├── _inbox
├── links
├── _posts
└── _scaffolds

 9 directories, 1 files
```

爽死。

慢着，里边还有一行`pushd`呢。嗯，这是后面用来实现自动退出子Shell的关键。具体实现等到下一部分再说吧，先睡了。

后来感觉这样有点太麻烦了，于是就把脚本简化了一下：

```bash
function cd() {
    builtin cd "$@"
    if [[ -f "$PWD/.bashrc" ]]; then
        exec bash --rcfile <(cat ~/.bashrc "$PWD/.bashrc")
    else
        exec bash --rcfile <(cat ~/.bashrc)
    fi
}
```

逻辑很简单，先直通参数执行完内置`cd`，然后判断目的目录底下有没有`.bashrc`，有的话直接`exec`一个新的bash来加载这个配置文件和`~/`下的默认配置；如果没有的话，也`exec`一个新的bash替换当前进程。

之所以到一个新目录都要开一个新的进程替换当前进程，是为了使得只有在当前目录底下才可以使用当前文件夹的环境变量。不过这也带来了新的问题：那就是执行一些包含`cd`的脚本时，会因为`exec`用新的进程覆盖了当前进程的原因，导致脚本执行终止。

最后想了下，Makefile不也挺好用的（笑）。