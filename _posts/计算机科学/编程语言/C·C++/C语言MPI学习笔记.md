---
title: C语言MPI学习笔记
date: 2023.04.27 23:48:54
author: xeonds
toc: true
excerpt: 第一次接触这东西......并行计算的消息传递接口？
tags:
  - 并行计算
  - 消息传递
  - 分布式内存
  - 多进程
---
## 简介

>内容由New Bing自动生成，注意甄别

MPI是一种用于并行计算的消息传递接口，它可以让多个进程在不同的机器（节点）上协同工作，通过发送和接收数据来完成复杂的计算任务。

简单地说，这是一个位高性能并行计算提供的一个**基础通信规范**。依靠它，可以编写出在多个核心/CPU集群上并行运行的程序。

要使用C语言MPI，您需要安装一个MPI软件，如MPICH，OpenMPI或MVAPICH，并使用mpicc或mpic++命令来编译您的C程序。

您还需要使用一些MPI的API函数来初始化和结束MPI环境，获取进程数和进程编号（称为“rank”），以及进行数据交换。

数据交换的主要方式有两种：发送（send）和接收（recv）。发送可以分为阻塞（blocking）和非阻塞（non-blocking）两种，阻塞发送会等待数据被接收方确认，而非阻塞发送会继续执行后续的代码，但需要使用等待（wait）函数来同步数据的状态。

依靠MPI构建的数据计算程序有多种架构，MIMD和SIMD都是它支持的架构。不过一般使用后一种，也就是单程序多数据流。

对于这种架构，又有两种不同的设计模式：主从结构，以及对等结构。它们适用于大多数情况。

## 实例

下面是一个简单的C语言MPI程序的示例，它可以计算圆周率的近似值：

>作者：xiongw21@mails.tsinghua.edu.cn

```c
#include "mpi.h"
#include <stdio.h>
double f(double);
double f(double x)
{
    return (4.0/(1.0+x*x));
}
int main(int argc,char *argv[])
{
    int myid, numprocs;
    int n, i;
    double mypi, pi;
    double h, sum, x;
    MPI_Init(&argc,&argv);
    MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD,&myid);
    printf("Process %d of %d.\n", myid, numprocs);
    n = 100;
    h = 1.0 / (double) n;
    sum = 0.0;
    for (i = myid + 1; i <= n; i += numprocs)
    {
        x = h * ((double)i - 0.5);
        sum +=f(x);
    }
    mypi = h * sum;
    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    if (myid == 0)
    {
        printf("The result is %.10f.\n",pi);
    }    
    MPI_Finalize();
}
```

