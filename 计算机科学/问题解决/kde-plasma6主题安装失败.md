---
title: kde-plasma6主题安装失败
date: 2025-03-05 20:36:35
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
  - 问题解决
---
折腾主题的时候下载主题安装失败：

```
The new package has a different type from the old version already installed.
```

遂搜到下面的文章：

> [can't install the new version of polonium on plasma 6 : r/kde](https://www.reddit.com/r/kde/comments/1b97eka/cant_install_the_new_version_of_polonium_on/)

详情如下：

>I faced the same issue. The error complains about already installed script even though it is not visible in the settings UI.
>
>I was able to list the script by executing `plasmapkg2 -t kwinscript -l`.
>
>Attempting to remove it using `plasmapkg2 -t kwinscript -r polonium` did not work though.
>
>I ended up removing the script manually with `rm -rf ~/.local/share/kwin/scripts/polonium` and then reinstalling through the UI.

然后顺着`~/.local/share/plasma`找到底下的`look-and-feel`目录，把里面所有文件全删掉之后就解决了。
