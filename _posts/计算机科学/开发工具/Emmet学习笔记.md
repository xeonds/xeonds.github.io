---
title: Emmet学习笔记
date: 2024-04-19 11:42:50
author: xeonds
toc: true
excerpt: 用了好久才知道div.class1#id>button这种写法是Emmet的语法...
tags:
---

> 大半夜刷到的...老早就想学学这玩意了，奈何不知道名字是啥一直没法搜。

参考资料：[Abbreviations Syntax | Emmet Doc](https://docs.emmet.io/abbreviations/syntax/)

Abbreviations are the heart of the Emmet toolkit: these special expressions are parsed in runtime and transformed into structured code block, HTML for example. The abbreviation’s syntax looks like CSS selectors with a few extensions specific to code generation. So every web-developer already knows how to use it. 

## 语法

### 元素
html定义的所有标签均可以直接由标签名称补全：比如`div`->`<div></div>`

### 子元素

二元运算符`>`标记标注前一元素的子元素，例如`div>ul`->`<div><ul></ul></div>`

### 同级元素

二元运算符`+`标识元素的同级元素，例如`div+p`->`<div></div><p></p>`

### 返回上一级

`^`标识指引当前缩进层次往上一级，例如`div>p^span`-><div><p></p></div><span></span>`

### 数量算符

二元运算符`*`指示左侧元素数量为右侧整数个，例如`div*5`->`<div></div><div></div><div></div><div></div><div></div>`

### 分组

可以使用`()`对符号进行分组：`div>(header>ul>li*2>a)+footer>p`->

```html
<div>
    <header>
        <ul>
            <li><a href=""></a></li>
            <li><a href=""></a></li>
        </ul>
    </header>
    <footer>
        <p></p>
    </footer>
</div>
```

注意，括号可以嵌套：`(div>dl>(dt+dd)*3)+footer>p`->

```html
<div>
    <dl>
        <dt></dt>
        <dd></dd>
        <dt></dt>
        <dd></dd>
        <dt></dt>
        <dd></dd>
    </dl>
</div>
<footer>
    <p></p>
</footer>
```

理论上你可以用一个缩写来编写一整页，但是实际最好不要这么做。

### 属性选项

对于标签，可以使用`.`标记添加class，`#`添加id，`[a="xxx" b="3"]`添加自定义标签。

### 编号

使用`*`操作符时，可以在元素名称，属性名称，属性值插入`$`来加入从1开始的序号。连续的`$`出现时，高位默认填0。比如：`ul>li.item$*5`->

```html
<ul>
    <li class="item1"></li>
    <li class="item2"></li>
    <li class="item3"></li>
    <li class="item4"></li>
    <li class="item5"></li>
</ul>
```

另外在`$`操作符后，可以用`@`修改起始值，递增/递减。语法为：`$@-3`，`$@-`，`$@3`。得到的结果分别为序号递减到3，序号递减到1,序号从3递增。

### 文本

用`{}`包裹文本，可以将文本包含在元素标签对中：`a{click me}`==`a>{click me}`->`<a href="">click me</a>`

但是注意，第一种写法的优先级最高，第二种写法中，`{}`和一般标签等价。

### 终结符

空格是Emmet的默认终结符，因此，不能用空格提升可读性。此外，Emmet可以在任何位置使用，不一定是空行开头。

## 工具

1. `snippets.json`中包含Emmet的数据，也可以在这里定义自己的别名
2. 部分标签（例如`div.content`）可省略标签名，Emmet可直接推导出
3. Lorem lpsum生成工具：`lorem`可直接扩展为占位文本，也可以使用`lorem10`等控制占位文字数量

## 注

Emmet还有CSS的snippets，不过我用的不多就没去看。