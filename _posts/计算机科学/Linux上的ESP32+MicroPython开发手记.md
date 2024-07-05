---
title: Linux上的ESP32+MicroPython开发手记
date: 2024-07-05 14:03:13
author: xeonds
toc: true
excerpt: 非常好ESP32+EC800M，使我系统兼容
tags:
---

>Ref:[ESP32-MicroPython 开发环境 - orangeQWJ - 博客园](https://www.cnblogs.com/orangeQWJ/p/17762992.html)

之前一直想在Linux上玩玩手头的ESP32板子，但是奈何开发工具（好像叫Thonny）兼容Win，也懒得在Linux上再装一个。最近有空了才研究了一下，发现把板子插上，系统里是会出现一个字符设备的。不过大前提是**ESP32的板子是MicroPython固件**应该才行。

## 连接终端

>[[转载]各种终端 /dev/tty - 苏小北1024 - 博客园](https://www.cnblogs.com/muahao/articles/5673282.html)

既然设备在`/dev`底下显示了，那肯定就能连上。在Win上的时候IDE会自动连接上设备的MicroPython的repl解释器。Linux底下根据参考资料应该是可以借助`screen`连接。我的设备显示为`/dev/ttyUSB0`，那么就使用下面的指令以115200的波特率连接：

```bash
screen /dev/ttyUSB0 115200
```

连接后能看到确实是MicroPython的repl。

这里补充一下screen的使用，这里的`C-x`指的是`Ctrl+x`这样的组合键：

- `C-a d`：断开当前screen的连接
- `C-a k`：终止当前screen的连接。完成repl交互的时候务必终止，不然会阻碍ampy的连接
- `screen -R`：恢复screen的连接

## 文件传输

虽然能用repl的`os.listdir()`和文件操作查看源码和其他文件的内容，但是还是不太方便。搜了一下发现Adafruit提供了一个用于在MicroPythhon兼容设备上文件管理的工具。我这里直接从AUR安装了：

```bash
yay -S ampy
```

装好之后，可以先设置一下环境变量，省得每次都要指定端口号：

```bash
echo "export AMPY_PORT=/dev/ttyUSB0" >> $HOME/.bashrc
```

之后就不用指定下面所有的`--port /dev/ttyUSB0`参数了。

- `ampy --port <PORT> ls [REMOTE_DIR]`：列出文件
- `ampy --port <PORT> get <REMOTE_FILE> [LOCAL_FILE]`：下载文件，输出到stdout/本地文件
- `ampy --port <PORT> put <FILE>`：上传文件
- `ampy --port <PORT> rm <REMOTE_FILE>`：删除文件
- `ampy --port <PORT> mkdir <DIR>`：创建文件夹
- `ampy --port <PORT> run <REMOTE_SCRIPT>`：执行远程脚本

## 特殊文件

MicroPython固件会在开机时先执行`/boot.py`，再执行`/main.py`主程序。如何编写就看程序的设计了。

---

>PS：为了快速复制引用的网页还抽了半个小时做了个插件：[xeonds/tab-clip: Extension for clip the site info in markdown url format](https://github.com/xeonds/tab-clip?tab=readme-ov-file)
>虽然感觉有点傻就是了）
