---
title: systemd输出
date: 2024-03-20 00:39:02
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

>by konge@XDOSC

终端才是行缓冲，systemd那是往文件里写

所以在systemd里添加自己实现的脚本时，要即刻写入文件。

```python
print("xxx", flush=True)
```

