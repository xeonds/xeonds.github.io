---
title: GDB学习笔记
excerpt: 学会用bin utils总是好的。特别是编写程序遇到bug，或者偶尔搞搞简单的逆向都很有用。GDB一般调调C和C++，命令行界面对程序员比较友好？
toc: true
author: xeonds
date: '2023.03.16 23:12:16'
categories:
  - 计算机科学
---

GDB（GNU Debug Bridge）是一个二进制程序调试工具，适用于调试C和C++程序。这种二进制程序工具统称为bin-utils。类似的还有`strace`，一个跟踪程序系统调用的工具。

## 快速上手

在此之前，编译程序时记得加上`-g`参数来生成调试信息。

```bash
gcc main.c -g -o main
```

首先，使用`gdb <program>`启动gdb并加载程序。随后，使用`break main`在`main`函数入口设置断点，否则程序会直接执行完成。接着，使用`run [args]`执行程序并附加可选的参数。程序会在断点处停止，在这之后，就可以使用`next`（简写为`n`）或`step`单步执行，使用`print expr`打印表达式的值。完成后，用`quit`退出gdb。

### 解释说明

1. 只有编译时加上了`-g`，gdb才能进行调试
2. `next`表示执行下一条语句而不进入函数内部；`step`则会进入函数内部
3. `print expr`可以输出表达式的值，一次一个参数。例如查看数组arr的第i个元素可以用`print arr[i]`

## GDB的几种模式

GDB有多种模式，包括交互模式、批处理模式、远程调试模式等。交互模式是最常用的模式，用户可以在命令行界面中输入命令与GDB交互。批处理模式可以在不人工干预的情况下执行一系列GDB命令，通常用于自动化测试和调试。远程调试模式可以在远程主机上调试程序，通常用于嵌入式系统和分布式系统的调试。

- `交互模式` 是最常用的模式，用户可以在命令行界面中输入命令与GDB交互。进入交互模式的方法是在命令行中输入`gdb <program>`，其中`<program>`是要调试的程序的可执行文件。交互模式的作用是让用户能够在程序执行过程中控制程序的执行，查看程序的状态，以及调试程序的错误。基本使用方法包括设置断点、运行程序、单步执行、打印变量值、查看函数调用栈等。
- `批处理模式` 可以在不人工干预的情况下执行一系列GDB命令，通常用于自动化测试和调试。进入批处理模式的方法是在命令行中输入`gdb -batch -x <script> <program>`，其中`<script>`是包含GDB命令的脚本文件，`<program>`是要调试的程序的可执行文件。批处理模式的作用是让用户能够自动化执行一系列GDB命令，以便进行自动化测试和调试。基本使用方法包括设置断点、运行程序、单步执行、打印变量值、查看函数调用栈等。
- `远程调试模式` 可以在远程主机上调试程序，通常用于嵌入式系统和分布式系统的调试。进入远程调试模式的方法是在命令行中输入`gdb <program>`，然后使用`target remote <host>:<port>`命令连接到远程主机，其中`<host>`是远程主机的IP地址或主机名，`<port>`是远程主机上GDB服务器的端口号。

GDB的软件结构可以分为以下几个部分：

1. 前端：用户与GDB交互的界面，可以是命令行界面或者GUI界面。
2. 后端：GDB的核心部分，负责解析用户输入的命令，控制程序的执行，以及与目标程序进行通信。
3. 目标：被调试的程序，GDB通过与目标程序进行通信来控制其执行。

## 常用指令

以下是GDB常用的指令：

- `break`：设置断点
- `run`：运行程序
- `next`（简写为`n`）：执行下一条语句而不进入函数内部
- `step`（简写为`s`）：进入函数内部
- `print`（简写为`p`）：打印表达式的值
- `backtrace`（简写为`bt`）：打印函数调用栈
- `info`：显示各种信息，如变量、寄存器、线程等
- `watch`：设置观察点，当观察的变量被修改时停止程序执行
- `continue`（简写为`c`）：继续执行程序直到下一个断点或程序结束
- `finish`：执行完当前函数并返回到调用该函数的地方
- `set`：设置变量的值
- `display`：每次停在断点处时自动打印表达式的值
- `disable`：禁用断点或观察点
- `enable`：启用断点或观察点
- `delete`：删除断点或观察点

## 高级功能

除了常用指令外，GDB还有一些高级功能：

### 多线程调试

GDB支持多线程调试。可以使用`info threads`命令查看当前线程列表，使用`thread <id>`命令切换到指定线程，使用`break <func> thread <id>`命令在指定线程中设置断点。

例如，我们有一个多线程程序`test`，其中有两个线程`thread1`和`thread2`，我们想在`thread2`中设置断点。首先，使用`gdb test`命令启动gdb并加载程序。接着，使用`run`命令运行程序。程序会在主线程中停止，使用`info threads`命令查看当前线程列表，找到`thread2`的ID。假设`thread2`的ID为2，使用`thread 2`命令切换到`thread2`，使用`break <func> thread 2`命令在`thread2`中设置断点。完成后，使用`continue`命令继续执行程序，程序会在断点处停止。

### 远程调试

GDB支持远程调试，可以使用`target remote <host>:<port>`连接到远程主机，使用`file <path>`加载可执行文件，使用`run`运行程序。

### 调试核心转储文件

当程序崩溃时，可以使用GDB调试核心转储文件。可以使用`core <file>`命令加载核心转储文件，使用`bt`命令查看函数调用栈。

### 调试动态链接库

GDB可以调试动态链接库，可以使用`set solib-search-path <path>`设置动态链接库搜索路径，使用`info sharedlibrary`查看已加载的动态链接库，使用`break <func>`在动态链接库中设置断点。

### 调试汇编代码

GDB可以调试汇编代码，可以使用`layout asm`查看汇编代码窗口，使用`stepi`单步执行汇编指令，使用`disassemble <func>`查看函数的汇编代码。

### 调试嵌入式系统

GDB可以调试嵌入式系统，可以使用`target remote <host>:<port>`连接到嵌入式系统，使用`set remotebaud <baud>`设置串口波特率，使用`monitor reset`复位嵌入式系统，使用`load`加载可执行文件，使用`run`运行程序。

### 调试内核

GDB可以调试内核，可以使用`target remote <host>:<port>`连接到内核，使用`set architecture <arch>`设置架构，使用`set osabi <osabi>`设置操作系统ABI，使用`set solib-absolute-prefix <path>`设置动态链接库路径，使用`add-symbol-file <file> <addr>`加载符号文件，使用`break <func>`在内核中设置断点。

### 调试追踪系统调用

GDB可以调试追踪系统调用，可以使用`catch syscall <syscall>`设置系统调用断点，使用`info catch`查看系统调用断点，使用`stepi`单步执行系统调用。

### 调试追踪信号

GDB可以调试追踪信号，可以使用`catch signal <signal>`设置信号断点，使用`info catch`查看信号断点，使用`stepi`单步执行信号处理函数。

### 调试追踪fork和exec

GDB可以调试追踪fork和exec，可以使用`set follow-fork-mode <mode>`设置fork和exec的跟踪模式，使用`catch fork`设置fork断点，使用`catch exec`设置exec断点，使用`info catch`查看fork和exec断点。

### 调试追踪动态内存分配

GDB可以调试追踪动态内存分配，可以使用`catch syscall brk`设置brk系统调用断点，使用`catch syscall sbrk`设置sbrk系统调用断点，使用`info catch`查看brk和sbrk断点。

### 调试追踪文件操作

GDB可以调试追踪文件操作，可以使用`catch syscall open`设置open系统调用断点，使用`catch syscall close`设置close系统调用断点，使用`catch syscall read`设置read系统调用断点，使用`catch syscall write`设置write系统调用断点，使用`info catch`查看文件操作断点。

### 调试追踪网络操作

GDB可以调试追踪网络操作，可以使用`catch syscall socket`设置socket系统调用断点，使用`catch syscall connect`设置connect系统调用断点，使用`catch syscall accept`设置accept系统调用断点，使用`catch syscall send`设置send系统调用断点，使用`catch syscall recv`设置recv系统调用断点，使用`info catch`查看网络操作断点。

### 调试追踪信号量和共享内存

GDB可以调试追踪信号量和共享内存，可以使用`catch syscall semop`设置semop系统调用断点，使用`catch syscall semget`设置semget系统调用断点，使用`catch syscall semctl`设置semctl系统调用断点，使用`catch syscall shmget`设置shmget系统调用断点，使用`catch syscall shmat`设置shmat系统调用断点，使用`catch syscall shmdt`设置shmdt系统调用断点，使用`catch syscall shmctl`设置shmctl系统调用断点，使用`info catch`查看信号量和共享内存断点。

### 调试追踪进程间通信

GDB可以调试追踪进程间通信，可以使用`catch syscall msgget`设置msgget系统调用断点，使用`catch syscall msgsnd`设置msgsnd系统调用断点，使用`catch syscall msgrcv`设置msgrcv系统调用断点，使用`catch syscall semget`设置semget系统调用断点，使用`catch syscall semop`设置semop系统调用断点，使用`catch syscall semctl`设置semctl系统调用断点，使用`catch syscall shmget`设置shmget系统调用断点，使用`catch syscall shmat`设置shmat系统调用断点，使用`catch syscall shmdt`设置shmdt系统调用断点，使用`catch syscall shmctl`设置shmctl系统调用断点，使用`info catch`查看进程间通信断点。

### 调试追踪信号处理

GDB可以调试追踪信号处理，可以使用`catch syscall sigaction`设置sigaction系统调用断点，使用`catch syscall sigprocmask`设置sigprocmask系统调用断点，使用`catch syscall sigsuspend`设置sigsuspend系统调用断点，使用`catch syscall sigreturn`设置sigreturn系统调用断点，使用`info catch`查看信号处理断点。

### 调试追踪定时器

GDB可以调试追踪定时器，可以使用`catch syscall timer_create`设置timer_create系统调用断点，使用`catch syscall timer_settime`设置timer_settime系统调用断点，使用`catch syscall timer_gettime`设置timer_gettime系统调用断点，使用`catch syscall timer_delete`设置timer_delete系统调用断点，使用`info catch`查看定时器断点。

### 调试追踪进程状态

GDB可以调试追踪进程状态，可以使用`catch syscall wait4`设置wait4系统调用断点，使用`catch syscall waitpid`设置waitpid系统调用断点，使用`catch syscall waitid`设置waitid系统调用断点，使用`catch syscall exit`设置exit系统调用断点，使用`catch syscall _exit`设置_exit系统调用断点，使用`catch syscall kill`设置kill系统调用断点，使用`info catch`查看进程状态断点。

### 调试追踪信号量和共享内存

GDB可以调试追踪信号量和共享内存，可以使用`catch syscall semop`设置semop系统调用断点，使用`catch syscall semget`设置semget系统调用断点，使用`catch syscall semctl`设置semctl系统调用断点，使用`catch syscall shmget`设置shmget系统调用断点，使用`catch syscall shmat`设置shmat系统调用断点，使用`catch syscall shmdt`设置shmdt系统调用断点，使用`catch syscall shmctl`设置shmctl系统调用断点，使用`info catch`查看信号量和共享内存断点。

### 调试追踪进程间通信

GDB可以调试追踪进程间通信，可以使用`catch syscall msgget`设置msgget系统调用断点，使用`catch syscall msgsnd`设置msgsnd系统调用断点，使用`catch syscall msgrcv`设置msgrcv系统调用断点，使用`catch syscall semget`设置semget系统调用断点，使用`catch syscall semop`设置semop系统调用断点，使用`catch syscall semctl`设置semctl系统调用断点，使用`catch syscall shmget`设置shmget系统调用断点，使用`catch syscall shmat`设置shmat系统调用断点，使用`catch syscall shmdt`设置shmdt系统调用断点，使用`catch syscall shmctl`设置shmctl系统调用断点，使用`info catch`查看进程间通信断点。
