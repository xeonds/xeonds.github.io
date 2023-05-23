---
title: code-server：一个完美的WebIDE
tags:
  - Linux
  - IDE
toc: true
author: xeonds
date: '2021.01.01 21:30:00'
categories:
  - 计算机科学
---
趁着放假想着配置个在线开发环境。于是顺手搜了下。好家伙还真有。  

大概挑了下这个应该是最方便的了吧。

#### 下载

[项目Github地址](https://github.com/cdr/code-server) 这个是开源项目可以直接下最新Release~~或者自己clone后编译~~。  

如果下载慢的话可以试试[git加速下载](https://toolwa.com/github/)。

#### 配置

我的系统是Ubuntu 20.04 LTS其他Linux应该一样。  
输入指令`./code-server --help`即可查看相关指令：

```bash
Usage: code-server [options]

Run VS Code on a remote server.

Options:
  -V, --version                         output the version number
  --cert <value>
  --cert-key <value>
  -e, --extensions-dir <dir>            Override the main default path for user extensions.
  --extra-extensions-dir [dir]          Path to an extra user extension directory (repeatable). (default: [])
  --extra-builtin-extensions-dir [dir]  Path to an extra built-in extension directory (repeatable). (default: [])
  -d --user-data-dir <dir>              Specifies the directory that user data is kept in, useful when running as root.
  --data-dir <value>                    DEPRECATED: Use '--user-data-dir' instead. Customize where user-data is stored.
  -h, --host <value>                    Customize the hostname. (default: "0.0.0.0")
  -o, --open                            Open in the browser on startup.
  -p, --port <number>                   Port to bind on. (default: 8443)
  -N, --no-auth                         Start without requiring authentication.
  -H, --allow-http                      Allow http connections.
  -P, --password <value>                DEPRECATED: Use the PASSWORD environment variable instead. Specify a password for authentication.
  --disable-telemetry                   Disables ALL telemetry.
  --socket <value>                      Listen on a UNIX socket. Host and port will be ignored when set.
  --install-extension <value>           Install an extension by its ID.
  --bootstrap-fork <name>               Used for development. Never set.
  --extra-args <args>                   Used for development. Never set.
  -h, --help                            output usage information
```

直接输入指令`./code-server`即可启动codeserver。  
打开浏览器输入`http://localhost:8443`即可进入。密码会在终端显示。输入后即可进入。

![登录界面](http://mxts.jiujiuer.xyz/files/picture/login-to-ide.png)

![VSCode同款UI](http://mxts.jiujiuer.xyz/files/picture/web-vscode.png)

#### 修改密码

修改密码的指令是  

```
export PASSWORD=你的密码
```

然后再启动codeserver就可以使用自定义密码登录了。

#### 后台运行  

如果没有安装screen程序就先安装一下：

```bash
apt-get install screen -y
```

用cd切换到code-server然后输入以下指令：

```bash
screen -dmS code-server ./code-server
```

这里的第一个code-server是screen的名称第二个就是code-server程序了。  
如果要关闭这个程序只需要进入这个screen再用Ctrl+C退出即可：

```
screen -r code-server
[Ctrl+C]
```

好了 ~~这下就可以扔掉本地IDE了~~ 到这里就可以愉快地在线coding了。不过注意**所有文件都是储存在服务器上**的哦。
