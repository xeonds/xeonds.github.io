---
title: 用OCaml编写一个SQL解释器
date: 2024-05-13 23:01:35
author: xeonds
toc: true
excerpt: 这语言真的好适合写编译器
tags:
  - SQL
  - OCaml
---

## 词法&语法分析
这两部分使用ocamllex和ocamlyacc就能完成。下面简单介绍下语法

首先是ocamllex，这部分感觉基本跟ocaml的语法没啥区别：

```ocaml
{ header }
let ident = regexp …
[refill { refill-handler }]
rule entrypoint [arg1… argn] =
  parse regexp { action }
      | …
      | regexp { action }
and entrypoint [arg1… argn] =
  parse …
and …
{ trailer }
```

注释用`(* 注释 *)`分割。标头和标尾是会远原样复制到输出的部分，使用一对大括号包围起来，是可选部分。

然后是正则表达式，使用let定义。

接着是入口点定义，每个入口点都会是一个接受n+1个参数的ocaml函数。

然后是ocamlyacc，语法也很简单，固定的几块：

