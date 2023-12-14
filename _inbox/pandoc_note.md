---
title: pandoc初窥
date: 2023-12-09 20:10:50
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---
pandoc 是一个使用 Haskell 语言编写的一款跨平台、自由开源及命令行界面的标记语言转换工具，可实现不同标记语言间的格式转换，堪称该领域中的“瑞士军刀。pandoc 支持的输入和输出格式范围广泛，包括但不限于 Markdown、HTML、DOCX、PDF、LaTeX、EPUB 等。

pandoc 不是 python 的库，但是有一个 python 的封装，叫做 pypandoc，可以在 python 代码中调用 pandoc 的功能。pypandoc 可以使用 pip 命令安装，例如：

```python
pip install pypandoc
```

pandoc 的日常用法主要是通过命令行来转换文档，例如：

```bash
pandoc input.md -o output.html
```

这个命令就是将 input.md 这个 Markdown 文件转换为 output.html 这个 HTML 文件。pandoc 还有很多其他的选项和参数，可以参考 pandoc 的文档。

pandoc 也可以在 python 代码中使用 pypandoc 来转换文档，例如：

```python
import pypandoc
output = pypandoc.convert_file('input.md', 'html')
print(output)
```

这段代码就是将 input.md 这个 Markdown 文件转换为 HTML 字符串，并打印出来。pypandoc 还有其他的方法和参数，可以参考 pypandoc 的[文档](https://blog.csdn.net/VN520/article/details/129120364)。

pandoc 是一个非常强大和灵活的文档转换工具，可以帮助你在不同的文档格式之间进行转换，特别是对于 Markdown 这种简洁易用的标记语言，可以轻松地生成 PDF、电子书、幻灯片等多种形式的文档。