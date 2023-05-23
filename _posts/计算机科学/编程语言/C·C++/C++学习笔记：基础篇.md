---
title: C++学习笔记：基础篇
tags:
  - C++
excerpt: 和C语言一样的部分我就不详细写了。听学长说，C++主要是学STL（标准模板库）
toc: true
author: xeonds
date: '2021.10.26 17:14:26'
categories:
  - 计算机科学
  - 编程语言
  - C·C++
---

## 函数部分

### 内联函数

代码直接内嵌而无需跳转进入函数，**执行速度更快，但存储空间占用更大**。适用于函数体短且调用频繁的地方。

* 用法

在函数原型/定义前加上关键字`inline`即可。例如：

```cpp
inline int add(int a, int b){return a+b;}
```

注意：**内联函数不能递归**。

>C语言的寄存器变量：将值存储在处理器的寄存器中，能提高运行速度。声明前加上`register`即可。不过一般很少用，因为现在编译器优化都很强了。

### 引用变量：`&`的重载

主要用于函数的参数，以此实现传址调用，和`const指针`比较像。不过和指针又有区别：声明时就得初始化。

* 用法：和指针声明很像：

```cpp
#include <iostream>

using namespace std;

void swap(int &a, int &b){int temp=a;a=b,b=temp;}

int main(void)
{
    int rats;
    int &rodents = rats;

    int a = 5, b = 3;
    cout<<"a="<<a<<" b="<<b<<endl;
    swap(&a, &b);
    cout<<"a=:<<a<<" b="<<b<<endl;

    return 0;    //C++可以不加
}
```

### 默认参数

* 用法：从右往左添加：

```cpp
int chico(int n, int m, int c=0);
```

### 函数多态

允许声明同名但不同参的函数。这一般用来解决对不同类型参数应用同一种操作的情况，即“泛型编程”。典型的例子如下：

```cpp
int abs(int x){return x>0?x:-x;}
float abs(float x){return x>0?x:-x;}
double abs(double x){return x>0?x:-x;}
```

当然，也可以使用C++模板来完成。

## C++泛型编程

借助模板，可以实现与数据类型无关的编程。