---
title: GitHub博客搭建
date: '2022.11.25 11:35:50'
author: xeonds
toc: true
cover: img/Pasted image 20230201134619.png
excerpt: ψ(｀∇´)ψ
categories:
  - 计算机科学
---

>编辑 打算加一部分讲怎么更简洁地部署博客的教程。现在GitHub Actions已经很好用了，完全可以用它进一步简化博客部署步骤

博客站点是一种个人日志记录站点，也是Web1.0-2.0时代撑起互联网主体的重要部分之一。如今虽然它被各大APP不断挤占生存空间，但是它依旧重要：一篇高质量的博文，往往能够成为无数后人解决一个问题的宝贵参考资料。

对于个人而言，如何去写它，利用它由你决定。你可以用它宣传自己，可以把它当作自己的读书笔记甚至课程笔记，也可以用它去记录生活中的时时刻刻。你写出的内容，永远属于你，也可为你所用。

>为了防止现场网速太拉，建议大家提前完成下面的准备工作

## 准备工作

### 软件安装

首先需要在电脑上准备好用来写博客&生成静态站点的工具。需要在电脑上安装这些软件：

- [node.js（点击下载）](https://npmmirror.com/mirrors/node/v18.12.1/node-v18.12.1-x64.msi)   它是我们安装hexo的工具
- [git（点击下载）](https://registry.npmmirror.com/-/binary/git-for-windows/v2.39.0.windows.2/Git-2.39.0.2-64-bit.exe)       我们用它向GitHub推送我们生成的静态站

上面的链接如果下不了，也可以看群文件or自己搜

注意：**安装node.js的时候，一定保证下图的`Add to PATH`是确认的。**

![(*/ω＼*)](img/20221125-112418.png)

装好node.js之后，我们需要在电脑上安装**hexo**，这是生成博客站点的核心工具。

用`Win+R`键打开运行，输入`cmd`并回车，在随后弹出来的黑框框中输入下面的指令：

```bash
npm install hexo-cli -g
```

如果网速太慢，可以用下面的指令：

```bash
npm --registry https://registry.npm.taobao.org install hexo-cli -g
```

![我装过了所以没有提示](img/20221125-112056.png)

如果输出内容没有红底的`ERR`，就说明装好了。

### GitHub账号注册

之后，我们还需要在GitHub上注册一个账号。[点击此处前往](https://github.com/)

在主页上找到Sign Up按钮，点击之后按照注册流程即可。**用户名和邮箱是重要信息，后面会用到**。

![或者中间那个也行](img/20221125-111839.png)

随后我们还需要安装一个MarkDown编辑器，或者装了VS Code也可以用VS Code代替。

推荐几个 MarkDown 编辑器：Typora、Obsidian

## 开始搭建(ver.1)

### 初始化博客目录

>*如何用cmd切换到对应文件夹*：你可以在文件管理器里打开你的博客目录，然后在地址栏里输入`cmd`并回车，就像下面这样：
>![QAQ](img/20221127-182556.png)

首先，**新建一个存放博文的文件夹**，例如我是放在`C:/Users/[我的用户名]/blog/`下的，你们也可以放在其他目录，比如`D:/blog`。创建对应的文件夹，并在那个目录打开`cmd`（参考上面的说明）（**这个cmd别关，别关，别关，后面大多数操作都会用它**）

然后，在`cmd`中，运行`hexo init`初始化博客仓库。这个过程可能比较缓慢，失败或者卡住不动的话可以按`Ctrl+C`停止多试几次

>像这样就完成了
>![Warning什么的无视就好了](img/20221127-184326.png)

此外，还需要安装下面的工具。在同一个框里继续输入就好了：

```bash
npm i hexo-deployer-git     # git推送插件
npm i hexo-server           # 本地预览插件
npm i hexo-generator-feed   # RSS文件生成插件
```

![这样就没有问题了，嗯](img/20221127-184500.png)

### 建立仓库

在GitHub上建立仓库，**名称必须是`username.github.io`**，其中，`username`是你的用户名，其余选项默认即可，如下图所示（我已经创建过了所以会标红）。

![](img/Pasted%20image%2020221127193522.png)

接着，还是在上面的命令行窗口中，输入下面的指令：

```bash
git config --global user.name "[username]"
git config --global user.email "[email]"
```

把上面的`[username]`和`[email]`换成你的GitHub用户名和注册邮箱即可。

### 配置远程推送

完成后，打开博客文件夹，打开`_config.yml`并翻到最底下：

![就是框选的部分](img/20221127-184838.png)

把这部分用下面的部分覆盖：

```yaml
deploy:
  type: git
  repo: https://github.com/[username]/[username].github.io.git
  branch: main
```

其中，把`[username]`替换为你的GitHub用户名即可。

最后，还是在上面的命令行窗口中，执行`hexo clean && hexo d`，等待完成即可。

这个过程中，会让你输入GitHub账号密码，跟随提示输入即可。

### 验证

完成之后，在浏览器里访问`https://[username].github.io`，能看见下面的界面就代表推送配置成功了：

![(*/ω＼*)](img/20221127-190658.png)

>如果没有成功，可以等待2分钟再打开看看。

由于网络问题，上面涉及GitHub和npm的部分，可能会遇到很慢甚至卡死的情况。这种情况只能试几次或者搭梯子解决。

或者，也可以先在本地验证博客是否正确配置。还是在上面的命令行窗口中，输入`hexo s`，完成后在浏览器里粘贴并打开网址：`127.0.0.1:4000`，我们就能看到博客是否正确配置。

---


## 开始搭建(ver.2)

第二版的教程会借助`GitHub Action`来让博客搭建变得更简单，而且让你的文章目录更加简洁，可维护。

在搭建完成后，我们会得到一个只包含原来的`source`目录下所有文件的新的目录。并且在编写完成后，只需要使用`git push`将我们写好的博文推送到GitHub就完成了所有的步骤。

>注意：这个版本的教程可能需要一些常用开发工具的使用经验，建议小白先试试上面那个版本的

### 准备？

由于我们将大部分的复杂度都转移到了GitHub上，所以初次配置会更加繁琐。不过别急，~~让我先急~~只要跟着步骤做下来基本都没啥问题的。实在不行大不了fork一份仓库然后直接用（不

这次的步骤需要使用到`git`和`hexo`两个工具，并且我们需要创建三个分支用来实现自动化博客部署。

>	啊对了，如果不想自己搭建直接用的话，也不是不可以。只需要打开我的[仓库页面](https://github.com/xeonds/xeonds.github.io)，然后点击那个fork，接着到你的仓库下继续操作：首先把`.github/workflows/hexo-deploy.yml`最后的`REPOSITORY_NAME`改成你自己博客的名字（xxx.github.io)，然后把仓库名字改成刚才设置的名字，再检查仓库设置的Pages页面和Actions->General页面的设置项是否和底下的一样。完成后，clone到本地，把我的博文换成你的，再到deploy分支配置好你的博客发布设置，最后push到GitHub检查一下有没有问题即可。

### 开始！

首先，在GitHub上创建你的博客仓库：

>特别注意，这里我建这个名字只是作为示范，你们建立仓库的时候直接用`用户名.github.io`当仓库名就ok

![](/img/Pasted%20image%2020230521011305.png)

并克隆到本地：

![](/img/Pasted%20image%2020230521011417.png)

完成后打开：

![](/img/Pasted%20image%2020230521005753.png)

上面我已经用VSCode打开了。创建好之后，在当前目录下打开命令行工具，再使用下面的命令创建两个分支：`deploy`和`html`。

```bash
git branch deploy
git branch html
```

三个分支（`main`是默认分支）分别用来存储博客文章，保存博客构建工具以及存储生成的博客静态页面。

至此，三个分支就准备好了。下面就是重头戏了。

### 初始化博客构建工具

先用`git checkout deploy`切换到构建分支，**并删除LICENSE和README.md**。随后创建一个临时目录`tmp`，并在其中运行`hexo init`来初始化博客构建工具hexo。

![](/img/Pasted%20image%2020230521012200.png)

随后将`tmp`下除了`.git`的所有文件移动到文件夹根目录下，并删除`tmp`目录。然后运行一下`npm i`再安装下依赖。

![](/img/Pasted%20image%2020230521012421.png)

然后和上面一样，在根目录下安装必要的依赖：

```bash
npm i hexo-deployer-git hexo-server hexo-generator-feed --save
```

并更改`_config.yml`中的最底下的部分如下：

```yaml
deploy:
  type: git
  repo: https://github.com/[username]/[username].github.io.git
  branch: html
```

这时候应该就可以试着推送一下。没有问题的话会看到这个结果：

![](/img/Pasted%20image%2020230521013346.png)

这证明我们的推送已经配置好了。如果之前没设置git的用户名和邮箱的话会出问题，设置一下就好了。

然后就随便你怎么定制你的博客了，方法和上面那个版本的教程一样。

最后记得把`source`下的所有文件移动到文件夹外边，待会会再用到的。这里不移动出去，到时候可能会出现merge合并问题，比较麻烦。

### 配置主分支

这一步是实现自动化的关键。因为其实做到现在这一步，我们其实已经可以用上面第一版的教程部署博客了。这里多增加的，就是一点点git技巧和GitHub技巧啦。

首先，在上面的部署工具配置完成后，使用`git add .`和`git commit -m "deploy branch configure"`来将deploy分支的改动保存到这个分支中。

完成这一步后，我们用`git checkout main`切换到main分支，开始我们最后的工作。不过在这之前，先在根目录添加一个`.gitignore`，把这几个文件添加进去：

![](/img/Pasted%20image%2020230521015420.png)

完成之后，我们就可以把之前移出去的source目录下的所有东西移动进来了。

下面是一份GitHub Actions配置清单，先把最底下的`REPOSITORY_NAME`替换为你的博客仓库地址，随后，把它保存到`.github/workflows/hexo-deploy.yml`中。

```yml
name: Hexo Deploy
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout deploy branch
        uses: actions/checkout@v2
        with:
          ref: deploy
          path: ./

      - name: Checkout blog repo
        uses: actions/checkout@v2
        with:
          ref: main
          path: ./source

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: 14

      - name: Install dependencies
        run: |
          npm install && npm run build

      - name: Deploy
        uses: JamesIves/github-pages-deploy-action@releases/v3
        with:
          REPOSITORY_NAME: xeonds/hexo-actions
          BRANCH: html
          FOLDER: public

```

保存更改并推送到GitHub：

```bash
git add .
git commit -m "main workflow configure"
git push -u origin deploy
```

这次推送会触发GitHub Action，并且会失败。完成接下来的配置之后，我们的配置才能算彻底完成。

### GitHub仓库配置

现在可以关掉其他东西，打开浏览器了。找到我们的仓库，点开设置并找到**Pages**选项卡：

![](/img/Pasted%20image%2020230523215123.png)

按照上图的设置进行配置：首先在Source选项中，选择**Deploy from a branch**，然后在Branch选项中，选择`html`分支的`/(root)`目录作为部署的源路径。

保存之后，在左侧找到**Actions > General**选项卡：

![](/img/Pasted%20image%2020230523215832.png)

翻到最底下，把**Workflow Permossions**的选项改成**Read and write permissions**，然后保存。

到这里，我们的配置工作就基本结束了。

### 验证部署结果

打开我们的博客目录，在`_posts`目录下写一篇新的博客，并标注`frontmatter`信息后，在git中提交并推送它到GitHub。

随后，等待大概1分钟左右，打开你的仓库首页，查看GitHub Action运行情况：

![](/img/Pasted%20image%2020230523220538.png)

一切顺利的话，就会看到成功的对勾和右下角的Environments为Active。此时打开你的GitHub Pages链接（通常是`https://[用户名].github.io/`），应该就能正常看到你的博客首页了。

如果出现异常，你可以去GitHub Action页面中查看你的Workflow详情，并根据报错信息在网上找解决方案（实在不行也可以问问New Bing之类的）。

总之是结束了，可喜可贺，可喜可贺。

>写这篇教程的时候，看到了不少和我思路一样的，不过不少都因为时效性问题无法部署，而且我的部署方式比较特别，是一个仓库实现hexo配置存储、博客文章存储以及静态页面预览，所以操作方法也不太一样。
>总之想了下还是写了这篇教程。
>以及中间关于Actions权限设置的问题，我翻了好久才在一个Issue里看到解决方案，之前真的是一头雾水。如果去翻翻官方文档的话，应该能更早解决吧
>~~不管了反正终于结束了删库跑路删库跑路~~

## 开始写作！

一篇博客的写作流程大概是这样：

1. 在博客目录打开命令行，输入 `hexo new "文章标题"` 来创建一篇新文章
2. 用写作软件打开上面创建的文件，开始写作
3. 完成之后，在命令行中输入 `hexo clean && hexo d` 发布文章到GitHub

熟悉写作流程之后，就可以对博客进行进一步定制了，比如安装主题，安装其他插件等。后续我会列出来一些参考资料（*＾-＾*）

### Obsidian+Hexo=?

Obsidian（黑曜石）是一个很好用的专业Markdown写作和管理工具。下面我简单介绍下用Obsidian结合hexo进行博客写作的流程。

首先，安装[Obsidian](https://github.com/obsidianmd/obsidian-releases/releases/download/v1.1.9/Obsidian.1.1.9.exe)，下不下来就用梯子。安装完成后打开你的博客文件夹：

![就中间那个打开本地仓库](/img/Pasted%20image%2020230210143902.png)

打开之后进入设置，在文件与链接最底下的忽略文件中添加`node_modules`、`scaffolds`、`public`和`themes`四个文件夹。随后往上拉，存放新建笔记的文件夹改为`source/_posts`。

还是在设置中，点击左侧`模板`，模板文件夹位置选择`scaffolds`。然后关闭设置，点开`scaffolds`目录：

![=。=](img/Pasted%20image%2020230520234621.png)

改为下面的格式即可（author后面改成你自己的名字）。简单介绍下，title标题，date文章创建日期，author作者，toc目录（table of contents），excerpt文章简介，tags文章标签。

如果是使用部署方案2，那么只需要用obsidian打开仓库根目录，然后把scaffolds目录复制到博客目录里，然后改名成_scaffolds，然后把你要添加的模板添加到目录里，再在设置里改好，就能愉快地使用了。另外，不要忘了忽略node_modules之类的目录。

---

到这里就配置完了。接下来讲讲写作流程：

打开Obsidian，新建文章并确定好标题。随后点击左侧模板图标，选择post模板，它会根据模板格式自动生成文章标题、作者、时间等文章元信息，随后就是写作了。

完成后，在博客目录打开命令行，运行`hexo s`预览博客发布后的效果，确认无误后使用`hexo g && hexo d`来生成并发布博客到GitHub Pages。当然，如果还能折腾的动，还可以使用Obsidin的Git插件+Git命令在Obsidian中一键发布博客。

如果是使用方案2部署，那么就更简单了。直接把博客目录作为Markdown仓库打开，并设置好Obsidian Git插件，配置好模板目录。写作完成后，直接`Ctrl+P`来commit+push就行，直接推送到远程仓库，让GitHub Actions帮你发布到html分支上。

这应该就是折腾的尽头了。如果你还想再折腾的话，那可以试试更改之前的workflow，来添加你的自定义操作，比如一键部署到你的服务器上，或者邮件通知发布结果之类的。
