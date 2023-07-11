---
title: Git学习笔记
tags:
  - Git
  - Linux
excerpt: 用Git管理源代码版本以及团队协作是一件非常舒适的事。看到一个个仓库不仅成就感满满，而且完全不担心混乱
toc: true
author: xeonds
date: '2022.04.22 23:18:41'
categories:
  - 计算机科学
---

## 配置

- 修改默认编辑器

惯用Vim，感觉默认的Nano用不习惯，所以果断换回Vim：

```bash
git config --global core.editor "vim"
```

或者：

```bash
vim ~/.gitconfig
# 修改为如下内容
[core]
    editor=vim
```

## 入门

>推荐去看《Pro Git》系统学习。

git是重要且强大的版本控制工具。

## 功能

### Commit

### Push & Pull

### GitHub Pull Request(PR)

### Merge

基本用法：假设当前是master分支，你想要将dev分支合并进来：

```bash
git merge dev
```

如果没有冲突的话，合并就会顺利完成；否则，你需要在合并编辑器里手动处理那些冲突，然后再提交，完成合并。

#### Fast-Forward

就和它的名字一样，它是用于快速跟进的合并功能。一般的merge会生车工一个merge提交，而fast-forward只是让主分支的HEAD指向被merge的分支的HEAD。这样做的好处显而易见：开发进度跟进非常容易，只需要移动一个指针即可，并且节省了git的空间占用开销。缺点却很是问题：当被合并的分支删除后，**git的树结构就会被“捋平”**——那些fast-forward的点上没有merge生成的commit节点，所有fast-forward之间的连线自然就相当于“断开”的。

因此，Merge时，尽量禁用fast-forward，否则一旦删除分支，就无法再看到那个分支上到底干了什么。这对于代码问题追踪是很不利的因素。因此在开发中，应当尽量禁用fast-forward。

全局禁用的指令如下：

```bash
git config --global --add merge.ff false
```

### Branch

### Log

### Tag

Git tag是一种用于在Git仓库中标记特定版本的方法。它通常被用来标记重要的里程碑版本或发布版本，以便于在后续的开发或维护过程中快速定位和回溯到这些版本。

Git tag可以被创建并附加到任何一个Git commit对象上，而且可以添加任意多个标签，每个标签都可以添加一个描述信息。

在Git中，有两种类型的tag: lightweight tag和annotated tag。

轻量级标签（Lightweight tag）只是一个指向某个commit的引用，相当于一个不带附加信息的快照。而附注标签（Annotated tag）则是一个独立的Git对象，它除了包含指向某个commit的引用外，还可以包含标签作者、标签日期、描述信息等元数据。附注标签更适合用于发布版本和重要的里程碑。

要创建一个tag，可以使用`git tag`命令，例如：

```bash
git tag v1.0.0     # 创建一个名为v1.0.0的轻量级标签
git tag -a v1.0.0 -m "Release version 1.0.0"    # 创建一个名为v1.0.0的附注标签，同时添加描述信息
```

要将标签推送到远程仓库，可以使用`git push`命令，例如：

```bash
git push origin v1.0.0   # 将名为v1.0.0的标签推送到远程仓库
```

要查看所有标签，可以使用`git tag`命令，例如：

```bash
git tag        # 列出所有标签
git tag -l "v1.*"    # 列出所有以v1开头的标签
```

## 常见问题

- Cannot do a soft reset in the middle of a merge

错误原因很显然，就是我们在合并分支时想要撤销上次提交。我通常是因为在一个设备上commit&push了一些代码，而在另一台设备上已经commit了一些代码，随后打算先pull同步一下再push上去。这时就会提示将pull下来的代码merge到本地仓库中，这时候我一般会merge&push，但是有时候发现不小心把另一个分支的给pull到当前分支了，这时候就需要取消错误的pull操作。然而此时已经进入了merge状态，所以只能先退出这状态再重新正确地同步仓库。

首先，用`git stash`保存当前的更改，然后`git reset --merge`退出合并状态。这时再重新正确拉取代码即可。

- Linux平台鉴权失败

这是因为GitHub现在已经禁用了Git Cli的登录方式。因此我们需要重新配置其他的凭据管理器。比如我使用了`git-credential-oauth`，这样我就可以跳转到浏览器里登录认证GitHub凭据。配置方法很简单：

```bash
git config --global --unset credential.helper
git-credential-oauth configure
```

完成后，再执行push时，就会弹出浏览器窗口提示授权GitHub帐号了。

