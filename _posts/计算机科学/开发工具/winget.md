---
title: winget换源
date: 2023-12-09 20:35:48
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
[winget 是 Windows 的一个包管理器，可以用来安装、卸载、更新和搜索软件。winget 默认使用的是 Microsoft Store 的源，但是也可以换成其他的源，比如中科大的源。](https://unicom.mirrors.ustc.edu.cn/help/winget-source.html)[1](https://unicom.mirrors.ustc.edu.cn/help/winget-source.html)[2](https://www.zhihu.com/question/509903409)

如果您想换源，您需要以管理员身份运行终端，然后使用以下命令：

- 删除默认的源：

```bash
winget source remove winget
```

- 添加中科大的源：

```bash
winget source add winget https://mirrors.ustc.edu.cn/winget-source
```

- 重置为官方的源：

```bash
winget source reset winget
```

[](https://unicom.mirrors.ustc.edu.cn/help/winget-source.html)[1](https://unicom.mirrors.ustc.edu.cn/help/winget-source.html)[: WinGet 源使用帮助 — USTC Mirror Help 文档](https://unicom.mirrors.ustc.edu.cn/help/winget-source.html) [2](https://www.zhihu.com/question/509903409): winget是否可以用国内镜像？ - 知乎