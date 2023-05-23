---
title: 读书笔记-CoPL
date: 2024-02-24 11:27:40
author: xeonds
toc: true
excerpt: 你说的对，但是......
tags:
  - PLT
---
## 基本概念

语言设计的影响因素和语言的评估标准，以及语言分类，实现方法，程序设计应用领域

## 主要程序设计语言发展

plankalkui, fortran，lisp, algol60, cobol, basic, pl/i，apl,snobol, simula67, algol68, prolog, ada, smalltalk, c++，java, javascript, php, python,ruby,c#。当然还有其他的，比如delphi, erlang,haskell，scheme，clojure, scala, racket等语言

## 描述语法和语义

表达式文法的BNF和EBNF版本。

语法是一个四元组，文法的集合是一个元组，语义则是语法的“增强版”，对于语言的类型检查等都有重要作用。

## 词法分析和语法分析

首先这俩分开编写主要是为了保证分析器的模块化，从而提高复用能力。词法分析比较简单，就是针对语言的语素设计几个有限状态机，让它自己去识别这个token是啥语素就行。语法分析就是读入源码的token输入流，然后构建出来中间表示，通常是AST。

## 名字，绑定，类型检测和作用域

## 数据类型

## 表达式与赋值语句

## 语句层次的控制结构

## 子程序及其实现

## 抽象数据类型和封装结构

## 支持面向对象的程序设计

## 并发

## 异常处理和事件处理

## 函数式程序设计语言

## 逻辑程序设计语言
谓词演算，prolog