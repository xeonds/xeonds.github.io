---
title: C语言命令行参数解析
date: '2022.11.22 20:28:42'
author: xeonds
toc: true
excerpt: 也是大一的大作业用过
categories:
  - 计算机科学
  - 编程语言
  - C·C++
---

在编写需要命令行参数的C程序的时候，往往我们需要先解析命令行参数，然后根据这些参数来启动我们的程序。

C的库函数中提供了两个函数可以用来帮助我们解析命令行参数:getopt、getopt_long。

getopt可以解析短参数，所谓短参数就是指选项前只有一个“-”(如-t)，而getopt_long则支持短参数跟长参数(如"--prefix")。

## getopt函数

```c
#include<unistd.h>
int getopt(int argc,char * const argv[],const char *optstring);
extern char *optarg;   //当前选项参数字串（如果有）
extern int optind;     //argv的当前索引值
```

各参数的意义:

- argc:通常为main函数中的argc
- argv:通常为main函数中的argv
- optstring:用来指定选项的内容(如:"ab:c")，它由多个部分组成，表示的意义分别为：

1. 单个字符，表示选项。

2. 单个字符后接一个冒号：表示该选项后必须跟一个参数。参数紧跟在选项后或者以空格隔开。该参数的指针赋给optarg。

3. 单个字符后跟两个冒号，表示该选项后可以跟一个参数，也可以不跟。如果跟一个参数，参数必须紧跟在选项后不能以空格隔开。该参数的指针赋给optarg。

调用该函数将返回解析到的当前选项，该选项的参数将赋给optarg，如果该选项没有参数，则optarg为NULL。下面将演示该函数的用法

```c
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(int argc,char *argv[])
{
    int opt=0;
    int a=0;
    int b=0;
    char s[50];
    while((opt=getopt(argc,argv,"ab:"))!=-1)
    {
        switch(opt)
        {
            case 'a':a=1;break;
            case 'b':b=1;strcpy(s,optarg);break; 
        }
    }
    if(a)
        printf("option a\n");
    if(b)
        printf("option b:%s\n",s);
    return 0;
}
```

编译之后可以如下调用该程序

![](https://images2015.cnblogs.com/blog/779368/201511/779368-20151106222621946-984318181.png)

## getopt_long函数

与getopt不同的是，getopt_long还支持长参数。

```c
#include <getopt.h>
int getopt_long(int argc, char * const argv[],const char *optstring,const struct option *longopts, int *longindex);
```

前面三个参数跟getopt函数一样(解析到短参数时返回值跟getopt一样)，而长参数的解析则与longopts参数相关，该参数使用如下的结构

```c
struct option {
　　//长参数名
　　const char *name;
　　/*
　　　　表示参数的个数
　　　　no_argument(或者0)，表示该选项后面不跟参数值
　　　　required_argument(或者1)，表示该选项后面一定跟一个参数
　　　　optional_argument(或者2)，表示该选项后面的参数可选
　　*/
　　int has_arg;
　　//如果flag为NULL，则函数会返回下面val参数的值，否则返回0，并将val值赋予赋予flag所指向的内存
　　int *flag;
　　//配合flag来决定返回值
　　int val;
};
```

参数longindex，表示当前长参数在longopts中的索引值，如果不需要可以置为NULL。

下面是使用该函数的一个例子

```c
#include <stdio.h>
#include <string.h>
#include <getopt.h>

int learn=0;
static const struct option long_option[]={
   {"name",required_argument,NULL,'n'},
   {"learn",no_argument,&learn,1},
   {NULL,0,NULL,0}
};

int main(int argc,char *argv[])
{
    int opt=0;
    while((opt=getopt_long(argc,argv,"n:l",long_option,NULL))!=-1)
    {
        switch(opt)
        {
            case 0:break;
            case 'n':printf("name:%s ",optarg);                             
        }
    }
    if(learn)
        printf("learning\n");
}
```

编译之后可以如下调用该程序

![](https://images2015.cnblogs.com/blog/779368/201511/779368-20151106225136680-1898825378.png)
