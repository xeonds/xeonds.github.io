---
title: STC51单片机学习记录
tags:
  - 单片机
excerpt: 入了新的大坑（
toc: true
author: xeonds
date: '2021.06.17 18:54:41'
categories:
  - 物理
  - 微电子技术
---

## 准备工作

### 软件&资料下载

实验板到手，第一步当然是下载资料啦。自然要去官网下载：

* stc官网：<http://www.stcmcu.com>

>顺便，这官网挺瞎眼的（

由于官网过于瞎眼，故将下载链接直接贴出来。

* [STC-ISP软件V6.88F版](http://www.stcmcudata.com/STCISP/stc-isp-15xx-v6.88F.zip)

这个是烧录用的工具。

* [Keil uVision5](https://www.zdfans.com/html/29618.html)

直接放上下载站的链接。直链在此：[点击下载](http://zd1.wzhszm.com/KeiluVision_29618.zip?md5=NGfNpsLPv_KDgWk_1TCe3A&expires=1624016762)（不一定稳定）。下载站上有注册教程。

* [STC89C51RC用户手册](https://www.stcmcudata.com/datasheet/stc/STC-AD-PDF/STC89C51RC-RD.pdf)

### 大致流程

初步练习后，大致梳理如下。

* **构思&设计电路**。没啥好说的，咱也不会，就......边做边查呗（

* **写好程序**。个人习惯vim/vs code，比较方便。只要引入头文件 reg52.h ，后续开发照着C语言通常的流程即可。

* **编译程序**。使用上文提供的 Keil 编译程序，生成.hex文件（其实我挺好奇能不能用gcc......虽然估计不行）。这个.hex文件（看后缀，即十六进制文件）就是目标程序了。

* **烧录程序**。使用上面提到的 STC-ISP 工具进行烧录即可。烧录操作后面写，可先参考[这篇文章](https://blog.csdn.net/zhouyingge1104/article/details/88085350?depth_1-utm_source=distribute.pc_relevant.none-task-blog-OPENSEARCH-1&utm_source=distribute.pc_relevant.none-task-blog-OPENSEARCH-1)。

好了，到这里就是测试程序了（回想起被wer支配的恐惧）。

### FAQ（Frequently asked questions）

>Q：打开Keil新建工程，找不到stc51单片机怎么办？  
A：[看这儿](https://blog.csdn.net/zhuoqingjoking97298/article/details/105517884)。用stc-isp导入一下数据库到keil安装目录就好了。  

>Q:Keil要激活才能用？  
A:别担心，网上激活教程一大把。[看这儿](https://blog.csdn.net/qq_36306781/article/details/80555704)。文章里提到的注册机，已经包含在了我提供的Keil安装包里，下好之后照着文章操作就好。

>Q:烧录程序失败？  
A:stc51通病（貌似）。烧录按钮点了之后断一下开发板的电，然后重新上电即可。

>开发板到了。所以储物间又上了一本资料。还挺全的，初期入门用吧。

## 第一课：LED闪烁

代码其实很简单。MCU的编程方式和传统C语言程序相比挺怪的。代码如下：

```
/*Example-1_switch-led*/

#include "reg52.h"

typedef unsigned int u16;
sbit LED=P2^0;   
sbit LED_1=P2^1;

void delay(u16 i)
{
 while(i--);
}

void main()
{
 LED_1=0; 

 while(1)
 {
  LED=0;
  delay(50000);
  LED=1;
  delay(50000);
 }
}
```

写完之后，keil编译生成.hex文件，丢到stc-isp里一下载，完事儿。目测成功。不过这里面还有一点坑：

* 编译之后，如果没有生成.hex文件，那多半是没设置output生成.hex文件，照着底下几张图设置一下就能解决了。

点击下图这个魔术棒标志。

![](https://exp-picture.cdn.bcebos.com/fab31cb375d7997be1ae39ecf9dade49600fd9f2.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fquality%2Cq_80)

如下图，勾选Create hex file即可。

![](https://exp-picture.cdn.bcebos.com/a31e1214c27bd282fdd342f23cb1eef97ebd36f3.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fquality%2Cq_80)

然后编译。输出的信息里有下图这样的creating hex file from XXX就说明应该没啥问题。

![](https://exp-picture.cdn.bcebos.com/7c84d1672b5fd54688cc5ba07fd0b503c9d224f3.jpg?x-bce-process=image%2Fresize%2Cm_lfit%2Cw_500%2Climit_1%2Fquality%2Cq_80)

### 概览

回头看看这个程序。它和传统C语言程序的区别主要是这几点：

* 多了个头文件reg51.h/reg52.h。这个头文件对于单片机编译很重要
* 使用循环来达到延时的目的。上面的程序就使用了while循环来延时
* 通过设置sbit类型变量的值为1/0实现对应引脚高低电平的转换

其他的，基本和常规C语言没什么区别。所以，后面主要学习的，应该就是引脚的相关内容了。

## 第二课：用ESP8266实现通信

*《关于我报名比赛后才开始学MCU编程这件事》*

ESP8266因为便宜和足够强大，所以在物联网上有着很广泛的应用。它的使用也比较简单，指令较少。

```c
#include "reg52.h"
#include <stdio.h>
#include <string.h>

#define uchar unsigned char
#define uint unsigned int

uchar ReceiveData[5]; //回传的数组
uchar countnumber;

void uart_init() //串口的初始化
{
    //9600bps@11.0592MHz
    PCON &= 0x7F; //波特率不倍速
    SCON = 0x50;  //8位数据,可变波特率
    AUXR |= 0x40; //定时器1时钟为Fosc,即1T
    AUXR &= 0xFE; //串口1选择定时器1为波特率发生器
    TMOD &= 0x0F; //清除定时器1模式位
    TMOD |= 0x20; //设定定时器1为8位自动重装方式
    TL1 = 0xDC;   //设定定时初值
    TH1 = 0xDC;   //设定定时器重装值
    ET1 = 0;      //禁止定时器1中断
    TR1 = 1;      //启动定时器1
    EA = 1;
    ES = 1;
}

void delayms(uint xms) //延时
{
    uint i, j;
    for (i = xms; i > 0; i--)
        for (j = 110; j > 0; j--)
            ;
}

void Sent_ZF(uchar dat) //发送一个字节
{
    ES = 0;
    TI = 0;
    SBUF = dat;
    while (!TI)
        ;
    TI = 0;
    ES = 1;
}

void send(uchar *string) //发送字符串
{
    while (*string)
    {
        Sent_ZF(*string++);
    }
}

void Uart1() interrupt 4 //串口1 接收数据4wei（收到8266回传的OK，其实是\r\nOK）
{                        //当然是因为目前8266里面刷的AT固件是出厂默认固件
    uchar a;
    if (RI == 1)
    {

        //RI=0;       //复位中断请求标志,接收数据后置1
        a = SBUF; //接收数据
        RI = 0;   //复位中断请求标志,接收数据后置1

        *(ReceiveData + countnumber) = a;
        countnumber++;

        if (countnumber > 4)
        {
            countnumber = 0;
        }
    }
}

uchar data_compare(uchar *p) //比较字符串
{
    if (strstr(ReceiveData, p) != NULL)
        return 1;
    else
        return 0;
}

void wifi_init() //初始化wifi模块
{
    while (1)
    {
        send("AT+RST\r\n"); //往串口发重启指令
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);

    while (1)
    {
        send("AT+CWMODE=1\r\n"); //选择STA模式
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);

    while (1)
    {
        send("AT+CIPMUX=0\r\n"); //单通道模式
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);

    while (1)
    {
        send("AT+CIPSTART=\"TCP\",\"192.168.1.100\",8080\r\n"); //往串口发重启指令
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);

    while (1)
    {
        send("AT+CIPMODE=1\r\n"); //选择透传
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);

    while (1)
    {
        send("AT+CIPSEND\r\n"); //发送数据命令
        if (data_compare("OK"))
            break;

        delayms(600); //适当延时，给wifi模块一点反应时间
    }
    memset(ReceiveData, 0, 5);
}

void main()
{

    P27 = 0; //蜂鸣器
    uart_init();
    delayms(2000);
    wifi_init(); //就可连上服务端了

    while (1)
    {
        //do something
        ;
    }
}
```
