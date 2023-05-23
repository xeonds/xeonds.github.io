---
title: Markdown语法练习
tags:
  - Markdown
  - 资料
excerpt: 关键内容基本都写了一遍，留供参考。
toc: true
author: xeonds
date: '2020.12.19 21:12:00'
categories:
  - 计算机科学
---

## 0.分割线

***

---

___

```
***
---
___
```

## 1.斜体，粗体和删除线

*斜体*

**粗体**

~~删除线~~

```
*斜体*

**粗体**

~~删除线~~
```

## 2.分级标题

### 最多6级

##### 由#的数量决定

```
### 最多6级
##### 由#的数量决定
```

## 3.外链

如下所示：

* 内联式：[百度](https://www.baidu.com)
* 参考式：[文字描述][链接标签名字]
* 链接本身： <https://www.zhihu.com>

```
* 内联式：[百度](https://www.baidu.com)
* 参考式：[文字描述][链接标签名字]
* 链接本身： <https://www.zhihu.com>
```

## 4.无序列表

* 1123123
* 2123123
* 3123123

```
* 1123123
* 2123123
* 3123123
```

## 5.文字引用

比如说
>苟利国家生死以，岂因祸福避趋之

```
>苟利国家生死以，岂因祸福避趋之
```

## 6.行内代码块

比如说，`#include <stdio.h>`就像这样，会亮起来

```
比如说，`#include <stdio.h>`就像这样，会亮起来
```

## 7.插入图像

 ![Google图片](https://cdn2.mhpbooks.com/2016/02/google.jpg)

```
 ![Google图片](https://cdn2.mhpbooks.com/2016/02/google.jpg)
```

## 8.代码引用

```
#include <stdio.h>
int main(void)
......
```

## 9.表格

|daze|daze|daze|
|:-|:-:|-:|
|daze|dazedazedaze|daze

```
|daze|daze|daze|
|:-|:-:|-:|
|daze|dazedazedaze|daze
```

## 10.数学：LaTex

这是行内公式，会像普通文本一样靠左对齐：$f(x)=x^2+2x+1=(x+1)^2$  

这是单行公式，会自动居中：
$$
f(x)=\int_{-\infty}^\infty
\hat f{\xi}\,e^{2\pi i\xi x}
\,d\xi
$$  
>咱也不知道写的啥东西（乱写的XD）

### 泰勒级数

$$
f(x)=f(x_0)+f'(x_0)(x-x_0)+...
$$

>顺便，关于LaTex，可以看这个视频了解更多：[LaTex中文教程](https://b23.tv/KNLL97)

```
$f(x)=x^2+2x+1=(x+1)^2$

$$
f(x)=\int_{-\infty}^\infty
\hat f{\xi}\,e^{2\pi i\xi x}
\,d\xi
$$

### 泰勒级数：
$$
f(x)=f(x_0)+f'(x_0)(x-x_0)+...
$$
```

源码：

```
关键内容基本都写了一遍，留供参考。

<!--more-->     //这里注意一下，这个标签是控制文章列表页预览内容多少的

## 0.分割线

***
---
___

## 1.斜体和粗体

*斜体*

**粗体**

## 2.分级标题
### 最多6级
##### 由#的数量决定

## 3.外链
如下所示：

* 内联式：[百度](https://www.baidu.com)
* 参考式：[文字描述][链接标签名字]
* 链接本身： <https://www.zhihu.com>

[链接标签名字]:https://www.google.com

## 4.无序列表
* 1123123
* 2123123
* 3123123

## 5.文字引用
比如说
>苟利国家生死以，岂因祸福避趋之

## 6.行内代码块
比如说，`#include <stdio.h>`就像这样，会亮起来

## 7.插入图像
 ![Google图片](https://cdn2.mhpbooks.com/2016/02/google.jpg)

## 8.代码引用
`` `
#include <stdio.h>
int main(void)
......
`` `
注：这三个撇是连着的，因为显示问题故以空格分割。

## 9.表格
|daze|daze|daze|
|:-|:-:|-:|
|daze|dazedazedaze|daze

## 10.数学：LaTex
$f(x)=x^2+2x+1=(x+1)^2$

$\gamma$
$$
f(x)=\int_{-\infty}^\infty
\hat f{\xi}\,e^{2\pi i\xi x}
\,d\xi
$$


```
