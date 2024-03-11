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

## 安装

```bash
sudo apt install git -y     # ubuntu, etc.
sudo pacman -S git          # arch linux
```

Windows从官网下载exe安装，一路下一步即可。或者如果是Win10/11的话可以打开PowerShell执行下面的指令：

```bash
winget install git.git
```

## 配置

Git的配置文件有两种，全局配置文件，和相对于单个仓库而言的局部配置文件。前者应用于该系统中所有仓库，而后者应用于某个仓库。二者存在冲突项时，以后者优先级为更高。

全局配置文件存在于Linux的`~/.gitconfig`，或者是Windows的用户目录下的`.gitconfig`。修改的配置都会储存在这个文件中。而局部配置文件存在于仓库的`.git/config`中，使用`git config`编辑，一般不推荐直接编辑。

在Linux中，输入`git config`后就可以用Tab补全来看到所有可选的选项了。此时修改的，是局部配置；加上`--global`参数后，修改的就是全局配置。

- 设置用户名和邮箱

配置第一步，先设置用户名和邮箱。这是创建提交的重要凭据，相当于你给作品的签名。

```bash
git config --global user.name   "your name"
git config --global user.email  "your email"
```

- 修改默认编辑器

惯用Vim，感觉默认的Nano用不习惯，所以果断换回Vim：

```bash
git config --global core.editor vim
```

或者：

```bash
vim ~/.gitconfig
# 修改为如下内容
[core]
    editor=vim
```

- 禁用Fast-Forward

关于这是什么和为什么禁用的问题请看后文。

```bash
git config --global merge.ff false
```

## 入门

>推荐去看《Pro Git》系统学习。

git是重要且强大的版本控制工具。版本控制就相当于Word的历史记录功能，不过远比那强大和可靠。你可以在任何时候，为你当前的修改创建一个`commit`，它会记录你的仓库中所有文件相对于上个时间点的所有更改记录。

当项目规格急剧增大时，使用版本控制系统(VCS)就是必然的选择：多分支并行开发，代码合并，进度追踪等等，都是保持开发流程井然有序的重要方法。

如果用剧本走向来比喻git，那么git能做到的就是让你能同时尝试所有世界线，并把你喜欢的结局组合到一起。

## 功能

基本上，只要掌握`add`, `commit`, `push`, `pull`, `merge`就可以应付日常使用了。对于一些常见问题，使用`git help`或者在网上寻找答案都是不错的选择。

在介绍功能之前，你可以先去看看Pro Git前几章对Git模型的介绍，包括各种状态的转换，几个空间等。这里简单的介绍下：

Git（大体上）有三个区：首先是工作区，它的范围是你文件夹里所有除了`.git`目录以外的所有文件；其次是暂存区，你更改后使用`git add`暂存的文件都存储在这里。最后一个区是长期存储区，它保存着你的每一个文件，以及对它的每一次修改历史的原始版本。后两个区都位于`.git`目录中。也就是说，只要`.git`目录还在，那么即使你删了仓库里边所有的东西，也能用git恢复所有删除的文件，甚至是你以前的任何一个状态上——就好比玩Gal的时候随时跳转到世界线上的任意一个历史节点。

文件在这三个区域里，也会有不同的状态：在工作区中的文件会呈现出“未跟踪”，或者“已修改”的状态，对它们使用`git add filename`就能把它们送到暂存区，转变为暂存状态。此时**对这些文件做出的任何修改都可以从暂存区恢复**，比如不小心删了一段代码又撤销不了，就可以从暂存区恢复这个文件。而暂存区的文件，一旦取消暂存状态，你的这些更改也会跟着消失。这时候，你要是不小心删除了什么还没法撤销的话，就是真丢了。而此时，如果你想把这次更改从暂存区长久保存，就可以使用`git commit`来“提交”你在暂存区存放的所有文件，它们会被放到长期存储区。而在这之前，git会要求你输入一个提交消息。这个消息是强制的，不能输入空白的消息。虽然有时候麻烦，但是对于以后的版本管理是很便利的：你可以想起来这次提交做了什么修改。输入提交信息后，你的修改就并入长期存储区了。这个时候，你的代码基本上就很安全了。使用`git log`就能看到你的每一个提交记录。

除了上面说的那些，还有一个最重要的功能没有提到：git分支。git的提交历史就像是一个复杂树状链表结构，每一个提交都指向它的父结点。当你创建提交时，其实你就指定了它的父结点：也就是你这次更改的状态，它就是你的父节点。因此，你可以选择一个节点，将它作为你的父结点，并将你的改动提交的父结点指向它。而如果你指向的父结点已经有了一个子结点，那么这就会创建一个分支（branch），这个分支一般以一个名字标识，范围是从分叉点到这个分支的最新的一次提交记录。这就好比玩Gal时，玩到一半时，回溯到前面的一个结点，选择了另一个选项，从而开启了另一条世界线一样。而与Galgame不同的是，你可以将两个结局“合二为一”，合并为一个新的结局，并开始一段新的可能。基于提交的Git，就能做到将另一个分支的最新提交结点，和当前所在的结点合并，从而产生一个新的结点。一般而言，这个结点会被看作是属于当前分支的：例如，把develop分支合并到当前所在的master分支，产生的用于merge的提交记录就属于master分支。这样的分支模型是git设计的最大魅力之一。

基于git的分支系统，就诞生了使用分支进行开发的最佳实践，也就是git工作流。具体而言就是约定了几个用来完成特定工作的git分支，并严格规定了分支之间的操作准则。

### Commit

这是git的基础操作之一，在使用之前，先使用`git add`将要提交的文件加入暂存区。最简单的用法就是：

```bash
git commit
```

然后等待git弹出提交消息编辑器，输入提交消息，完成提交。如果输入了空白消息，git就会取消提交。

### Push & Pull

推送代码到远程仓库/拉取远程仓库到本地。用于同步本地和云端的代码更改。运行时一般不加啥参数，就是如果目标已经有了更改，可能得加上`--merge`或者`--rebase`来处理冲突。

#### Pull --Rebase vs --Merge

假设A和B同时克隆了一个仓库，并各自完成了一些修改。此时A想要推送自己的提交，却发现B已经推送了自己的提交。此时应该怎么做呢？

两种方法，首先是merge。拉取的时候加上`--merge`选项，会自动合并你们的提交。如果有冲突，就会在你的合并编辑器里展示出来，待你修改完成后，以一个合并提交的方式提交上去。

其次是rebase。它大致相当于“移花接木“：把你本地做的提交拼接到拉取下来的更改后边。这样产生的提交记录更加简洁。用法就是拉取时加上`--rebase`参数。

两种方式的选择取决于你们项目的开发规范，以及你的喜好。如果偏爱简洁，你可能更喜欢rebase；如果你追求commit的尽可能详尽，那么merge可能更适合你。

#### Pull submodule

编译thtk的时候发现submodule没拉取，记录一下这玩意怎么拉）

```bash
git submodule update --init --recursive
```

### GitHub Pull Request(PR)

虽然不属于git的基本操作但还是提一嘴。这是GitHub的一个操作，用于将别的分支合并到一个特定的分支上。它的使用场景通常如下：你想贡献代码给一个开源项目，就先在GitHub上fork他们的仓库，随后在其中完成你的更改，创建提交。最后，发起一个Pull Request，请求目标仓库拉取你仓库的最新提交到它自身。这种合并是可以跨越仓库的，而前提是它们之间得是fork的关系：其他仓库都是这个仓库的`fork`。满足这个条件之后，就可以在GitHub上新建一个PR，来通过这样的方式贡献你的代码了。

像Linux这样的重量级开源自由软件，就是无数人通过PR之类的操作慢慢构建起来的。甚至现在打开[这个页面](https://github.com/torvalds/linux)还能看到Linus天天在Merge PR（笑死

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

查看分支信息。

### Log

查看历史提交记录。可以加一些参数来改变输出格式：

- `--oneline`:一个提交只在一行内显示
- `graph`:以提交树状图的形式展示提交记录

我在`~/.gitconfig`里面加了一个alias：

```ini
[alias]
	graph = log --oneline  --graph
```
这样就能在仓库里运行`git graph`在终端查看“图形”版的提交记录了。

### Archive

打包是个挺好用的功能，能直接把某个节点的文件树打包成压缩包，供分发使用。

```bash
git archive --format=zip --output=master.zip master
```

上面的指令将`master`分支最新的commit的目录树打包成`master.zip`。

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

### Clone

行为是拉取一个远端仓库，但是实际上它的后端是`git init`和`git config`——实际上`clone`命令的行为是创建url同名文件夹，进入其中，执行`git init`，再借助`config`设置remote的url为clone的url，最后执行git pull`。

#### depth

```bash
git clone --depth=1 <repo_url>
```

在clone一些大型仓库时，可以指定`depth`参数来控制`clone`的提交记录深度。像上面指定depth为1表示clone下来的仓库只包含最新一次的提交记录。

## 规范

### commit message
>ref:知乎-猎龙星火

`<type>(<scope>): <subject>`

提交消息大致描述了本次提交的改动范围，需要有明确的意义。上面的格式是一种比较好的实践。

- `type`：指明commit的类别
    - `feat`：新增功能
    - `fix`：修复bug
    - `docs`：文档修改，比如CONTRIBUTING, README等
    - `test`：增加/修改测试用例
    - `style`：代码格式化，引用包排序等
    - `perf`：体验优化，性能、体验、算法等
    - `refactor`：代码重构，没有新功能/bug修复
    - `chore`：改变构建流程，增加依赖、工具等
    - `revert`：版本回滚
    - `merge`：代码合并
- `scope`：指明影响范围，比如影响到哪个模块就写上这个模块的名字
- `subject`：关于提交的简短描述，可以附加issue地址，结尾不加标点符号

### Git Workflow

借助Git来做项目控制，适用于小中规模团队。

通俗来说，是借助Git的分支和合并功能来解决这个问题。每个分支负责特定的任务，通过合并分支来管理工作进度。

#### 分支

- `main`:正式分支，不可push。这个分支的每个版本都是正式可用的版本
- `develop`:团队日常开发的分支，也不能push。
- `feature/`:功能开发分支，在此分支进行功能开发，完成后pr到dev分支并删除该分支。一般一个人负责一个`feature/xxx`分支，可以push
- `bugfix/`:问题修复分支
- `release/`:正式版本分支，创建自`main`分支，创建后不能合并之后的版本
- `hotfix/`:紧急修复，创建自`main/develop`
- `support/`:版本支持分支

流程一般是开发者们先根据文档，从`develop`分支`fork`出来一个`feature/xxx`分支，随后完成自己的开发后，请求code reviewer来pull自己的分支，并在review之后将自己的分支合并到`develop`分支上。其中，开发者可以创建`bugfix`分支来修复问题。

一个版本的开发阶段完成后，就可以由负责人将develop分支merge到main分支，并使用tag打上版本标签来作为一个可供使用的正式版本使用。同时，可以借助GitHub Action等CI/CD工具来自动构建可分发的软件本体。

当遇到用户提出的Issue时，进行`bugfix`或`hotfix`，完成后将它merge到`main`和`develop`分支。

当出现来比较大的Breaking Changes，并且现在的版本已经足够稳定时，就可以根据版本号的通常语义约定跳到下一个大的版本号进行后续的开发，之前的版本可以创建一个`release/vA.B.C`分支作为一个稳定的大版本进行长期维护。

这一套工作流程基本上将软件开发细化到了`feature`的粒度，也细化团队角色到developer和code reviewer这几类。

#### 工具

Linux上比较推荐`gitflow-avh`插件，可以比较方便地按照Git Workflow的方式进行项目管理。具体使用可以去看它的帮助选项，或者看看[Tower提供的介绍文档](https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/git-flow)。截至目前，[仓库](https://github.com/petervanderdoes/gitflow-avh)已经Archive了，也不知道为什么。

#### 步骤

开发前使用`git flow init`创建符合Git Workflow的分支结构。

开发时，使用`git flow feature/hotfix/release/xxx start <name>`来从源分支创建一个新的分支。

开发完成后，先把当前分支merge到develop等分支，然后使用`git flow feature/hotfix/xxx finish`来完成过当前分支的开发工作，并将它从本地和云端删除。

至于如何删除远端的分支：

```bash
git push origin -d <branch-name>  # 删除远程分支
git branch -d feature/xxx         # 删除本地分支
```

## 常见问题

### 终止正在进行的合并

>具体报错：`Cannot do a soft reset in the middle of a merge`
>解决方案：`git reset --merge `

错误原因是我们在合并分支时想要取消。我通常是因为在一个设备上commit&push了一些代码，而在另一台设备上已经commit了一些代码，随后打算先pull同步一下再push上去。这时就会提示将pull下来的代码merge到本地仓库中，这时候我一般会merge&push，但是有时候发现不小心把另一个分支的给pull到当前分支了，这时候就需要取消错误的pull操作。然而此时已经进入了merge状态，所以只能先退出这状态再重新正确地同步仓库。

首先，用`git stash`保存当前的更改，然后`git reset --merge`退出合并状态。这时再重新正确拉取代码即可。

### Linux平台鉴权失败

这是因为GitHub现在已经禁用了Git Cli的登录方式。因此我们需要重新配置其他的凭据管理器。比如我使用了`git-credential-oauth`，这样我就可以跳转到浏览器里登录认证GitHub凭据。配置方法很简单：

```bash
git config --global --unset credential.helper
git-credential-oauth configure
```

完成后，再执行push时，就会弹出浏览器窗口提示授权GitHub帐号了。

### 文件上传和下载后，文件名大小写变化

git默认设置中，对于文件名的设置是**大小写不敏感**。因此如果有必要的话，还是把这个设为false来解决问题吧：

```bash
git config --get core.ignorecase    # 首先获取当前设置状态，为true则执行下一条指令
git config core.ignorecase false    # 设置不忽略大小写
```

- 拒绝合并无关的历史：？

今天做数据库大作业的时候，在develop分支写完了前端代码。遂打算merge到main分支，但是收到了这样的警告：

```bash
xeonds@ark-station-breeze:~/Desktop/db-lab$ git merge develop 
致命错误：拒绝合并无关的历史
```

然后就蒙圈了。主要是因为我明明记得我develop分支是从main分支checkout出来的啊......看看历史：

```bash
# main
xeonds@ark-station-breeze:~/Desktop/db-lab$ git graph 
* cbed40a (HEAD -> main, origin/main, github/main) initial commit
# develop
xeonds@ark-station-breeze:~/Desktop/db-lab$ git checkout develop 
切换到分支 'develop'
您的分支与上游分支 'origin/develop' 一致。
xeonds@ark-station-breeze:~/Desktop/db-lab$ git graph 
* 5f244db (HEAD -> develop, origin/develop, github/develop) Completed frontend
* 571a5f9 Complete most fetch
* a4a6799 Add company api Remove incidential binary file Fix commit box
* 22bb06f frontend: a lot
* 00d9963 Frontend
* 74d0b2e remove unused files
* 5da0243 add table for showing data
* 3d63881 fix router
* 02483ab add router for home & lint fix
*   00f4504 Merge branch 'develop' of http://192.168.3.143:3000/xeonds/bus-admin into develop
|\  
| * 9ef740e home page completed
| * 8073d22  change readme && add todo
| * ba09829 Backend: - api support static fs: for frontend part - config.go: use viper to manage config file - model: conn use config in viper - main: finish init&startup
|/  
* 57ef7c6 add backend
* 45aca82 initial commit
```

不是这啥情况？怎么都是initial commit结果hash不一样？大概进去看了一下两次提交，内容都是一样的，但是不知道为啥就成这样了。时间紧所以就不详细排查了。总之现在的策略是从develop分支完全merge过来，找了个[博客](https://www.cnblogs.com/xidianzxm/p/12965841.html)看到了这个问题的解决方法（虽然是拉取时候的，但是合并应该也行）：

```bash
git merge --allow-unrelated-histories develop
```

解决了。输完上面的指令之后，git就自动回溯了之前的每一次提交，并对每一次提交进行处理，合并initial commit不一致导致的冲突。反正完成之后有好几个main分支的历史提交都被重新修改了（我用的是no rebase策略）。

这应该算是比较罕见的情况了。
