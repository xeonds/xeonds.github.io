---
title: CSDN复制解禁
date: 2023-10-12 14:18:34
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

省流不看：F12开发者工具终端执行`document.designMode='on'`。

原理嘛，就是利用浏览器的DOM启用设计模式来允许选择元素。关于DOM的详细介绍在下边：

## DOM简介

在浏览器中，`document`对象是一个非常重要的对象，它代表了当前页面的文档。`document.DesignMode`属性是`document`对象的一个属性，它用于指定页面的设计模式。

设计模式主要有两种：

1. 模式（常态）：页面在正常模式下运行，用户可以正常查看和操作页面元素。  
2. layouter 模式（布局模式）：页面在 layouter 模式下运行，用户无法正常查看和操作页面元素，只能查看页面的布局和结构。

这两种设计模式主要用于开发者调试和测试网页布局。通常，开发者会在开发过程中将页面切换到 layouter 模式，以便更好地查看和调整页面布局。当开发完成后，页面会自动切换回正常模式。

在页面加载时，浏览器会自动设置`document.DesignMode`属性的值。开发者也可以通过 JavaScript 代码来修改这个属性的值，从而实现在不同设计模式之间的切换。

除了`DesignMode`属性之外，`document`对象还有许多其他的属性和方法，它们可以用来完成各种网页开发任务。例如：

1. `document.body`：表示页面的主体部分，包含了所有的 HTML 元素。  
2. `document.title`：表示页面的标题，通常显示在浏览器的标签页上。  
3. `document.getElementById()`：通过元素的 ID 获取指定元素。  
4. `document.getElementsByClassName()`：通过元素的类名获取指定元素集合。  
5. `document.getElementsByTagName()`：通过元素的标签名获取指定元素集合。  
6. `document.querySelector()`：通过 CSS 选择器获取指定元素。  
7. `document.querySelectorAll()`：通过 CSS 选择器获取指定元素集合。

此外，`document`对象还提供了许多用于操作 DOM 的方法，如`createElement()`、`appendChild()`、`removeChild()`、`insertBefore()`等，以及用于处理事件的方法，如`addEventListener()`、`removeEventListener()`等。

总之，`document`对象是浏览器中最重要的对象之一，它为网页开发者提供了丰富的属性和方法，使得开发者可以更加方便地完成各种网页开发任务。

