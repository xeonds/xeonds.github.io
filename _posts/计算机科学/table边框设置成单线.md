---
title: table边框设置成单线
tags:
  - HTML
  - CSS
  - table
excerpt: 记下，以后备用
toc: true
author: xeonds
date: '2021.09.25 21:36:23'
categories:
  - 计算机科学
---
有两种方法。

* 第一种方法：就是利用table标签`cellspacing=0`属性来实现。

`cellspacing`是内边框和外边框的距离，这种方法实现的**看起来**是单实线，其实是**内边框线和外边框线组合成的实线**。

例：

```html
<table cellspacing="0" border="1px">
    ...
</table>
```

* 第二种方法是利用css的表格`border-collapse`属性来实现。

```css
table{
    border-collapse: collapse;
}
```

>我更喜欢第二种方法。第一种方法适用于table较少，不考虑可维护的情况。否则，它会让HTML源文件变得混乱。
