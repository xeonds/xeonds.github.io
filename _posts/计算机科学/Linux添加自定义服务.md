---
title: Linux添加自定义服务
author: xeonds
toc: true
excerpt: 使用服务来开机自动启动服务器上的程序吧！免去每次开机都要手动启动各种服务，还省下了用tmux/screen的开销
categories:
  - 计算机科学
date: 2023-03-13 21:06:51
---

>本文由chatGPT生成，看了下没啥问题
>别问为啥不自己写，问就是懒（

在Linux中，您可以通过添加自定义服务文件来将自定义脚本作为服务启动。下面是添加自定义服务文件的一般步骤：

1. 创建一个新的服务文件
在/etc/systemd/system目录中创建一个新的服务文件，文件名以.service结尾。例如，如果您想创建一个名为my-service的服务文件，可以使用以下命令：

```bash
sudo vi /etc/systemd/system/my-service.service
```

2. 编写服务文件

在创建的服务文件中，至少需要包含以下三个部分：

```bash
[Unit]
Description=My Custom Service
After=network.target

[Service]
User=root
Type=simple
ExecStart=/path/to/my-script

[Install]
WantedBy=multi-user.target
```

其中，[Unit]部分包含服务的描述和启动顺序，[Service]部分包含服务的用户、类型和执行命令，[Install]部分包含服务的安装目标。

3. 重新加载systemd配置

在编辑完服务文件后，需要重新加载systemd配置，以便它能够识别新的服务文件。可以使用以下命令重新加载systemd配置：

```bash
sudo systemctl daemon-reload
```

4. 启动服务

您可以使用以下命令启动新创建的服务：

```bash
sudo systemctl start my-service
```

5. 将服务设置为开机启动

如果您希望系统在启动时自动启动新创建的服务，可以使用以下命令将其设置为开机启动：

```bash
sudo systemctl enable my-service
```

现在，您已经成功添加了一个新的自定义服务，并且可以随时使用systemd管理该服务。
