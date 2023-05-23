---
title: XDOJ-archive
tags:
  - C语言
excerpt: OJ里做过的题都记录在这吧
toc: true
author: xeonds
date: '2021.09.29 10:35:44'
categories:
  - 计算机科学
---
更新：这么翻着看太麻烦了，做了个小工具，这里就先不更新了。

[点击前往](http://www.jiujiuer.xyz/pages/xdoj-util/)

---

听说XDOJ上的题有200多道，刷的题在这记下，以后备用。

过于简单的就直接放代码了。

---

*不知道哪找的题，题解写这了*

### 1.数列分段

#### 问题描述

给定一个整数数列，数列中连续相同的最长整数序列算成一段，问数列中共有多少段？

#### 输入格式

输入的第一行包含一个整数n，表示数列中整数的个数。

第二行包含n个整数a1, a2, …, an，表示给定的数列，相邻的整数之间用一个空格分隔。

#### 输出格式

输出一个整数，表示给定的数列有多个段。

#### 样例输入

```bash
8
8 8 8 0 12 12 8 0
```

#### 样例输出

```bash
5
```

#### 题解

```c
/* array_count.c - by xeonds - 2021.10.15 23:00 */

#include <stdio.h>

int main(void)
{
    int i,j,num_curr,num_prev,count;

    scanf("%d",&i);
    for(j=0,count=1;j<i;j++)
    {
        if(j==0)
        {
            scanf("%d",&num_prev);
            continue;
        }
        scanf("%d",&num_curr);
        if(num_curr!=num_prev)
            count++;
        num_prev=num_curr;
    }
    printf("%d",count);

    return 0;
}
```

>没来得及提交，不知道能不能过（
>反正本地gcc运行是没问题的。但是OJ平台好像是VC6（叹
>更新：已经找到题了，过了（
---

*第一次上机的练习题。大多数都很简单，除了一个隐式转换的坑。*

### 2.A+B+C

```c
#include <stdio.h>

int main(void)
{
 int a,b,c;

 scanf("%d %d %d",&a,&b,&c);
 printf("%d",a+b+c);

 return 0;
}
```

### 3.求三角形面积

```c
/* calc triangle area - by xeonds */

#include <stdio.h>
#include <math.h>

int main(void)
{
 float a,b,c,p;

 scanf("%f %f %f",&a,&b,&c);
 p=(a+b+c)/2;
 printf("%.2f",sqrt(p*(p-a)*(p-b)*(p-c)));

 return 0;
}
```

### 4.整数简单运算

```c
#include <stdio.h>

int main(void)
{
 int a,b;
 
 scanf("%d %d",&a, &b);
 printf("%d\n%d\n%d\n%d\n",a+b,a-b,a*b,a/b);

 return 0;
}
```

### 5.字符输入输出

这里注意下，字母大小写转换可以用ascii码的方式进行，也可以用二进制格式按位操作的方式完成。

```c
#include <stdio.h>

int main(void)
{
 int ch;

 for(int i=0;i<9;i++)
 {
  ch=getchar();
  if(i%2==0)
   putchar(ch+32);
 }
 printf("!");

 return 0;
}
```

### 6.计算长方体体积

注意，转换说明要和数据类型匹配。

```c
#include <stdio.h>

int main(void)
{
 float a,b,c;

 scanf("%f %f %f",&a,&b,&c);
 printf("%.3f",a*b*c);

 return 0;
}
```

### 7.数字字符

这里不能用减的原因是，减有可能会产生负数，这在ascii码体系中是未定义的。

```c
/* int add char - by xeonds */

#include <stdio.h>

int main(void)
{
 int a,ch;

 scanf("%d,%d",&a,&ch);
 printf("%d,%d",a+ch+48,a+ch);

 return 0;
}
```

### 8.计算球体重量

```c
#include <stdio.h>

#define PI 3.1415926
#define FE 7.86
#define AG 19.3

float mass(int a,float p);

int main(void)
{
 int d_1,d_2;

 scanf("%d %d",&d_1,&d_2);
 printf("%.3f %.3f",mass(d_1,FE),mass(d_2,AG));

 return 0;
}

float mass(int a, float p)
{
 float m;
 
 m = 4*PI*a*a*a*p/3/1000/8;

 return m;
}
```

### 9.整除判断1

```c
#include <stdio.h>

int main(void)
{
 int a,b;

 scanf("%d %d",&a,&b);
 if(a%b==0)
  printf("yes");
 else
  printf("%d %d",a/b,a%b);

 return 0;
}
```

### 10.求三位整数各位之和

本来是想写得更通用一些，但是任务太简单，没必要。

```c
#include <stdio.h>

int main(void)
{
 int i;

 scanf("%d",&i);
 printf("%d",i%10+(i%100-i%10)/10+(i-i%100)/100);

 return 0;
}
```

更通用一点的算法：任意位（不超过int范围）各位求和：

```c
/* calc_bit_sum.c -by xeonds - 2021.10.16 15:11 */
#include <stdio.h>

int calc(int num);

int main(void)
{
    int num;

    scanf("%d", &num);
    printf("%d", calc(num));

    return 0;
}

int calc(int num)
{
    if (num >= 10)
        return num % 10 + calc((num - num % 10) / 10);
    else
        return num;
}
```

### 11.温度转换

这有个坑，好多人都掉进来了：数据的隐式转换。赋值表达式右值的数据类型会自动转换成其中容纳范围最大的项的数据类型。

比如，`c=1+3/2`的结果是2，而`c=1+3/2.0`的结果是`2.50`。

```c
/* temperature convert - by xeonds */

#include <stdio.h>

float f_to_c(int a);

int main(void)
{
 int f;
 
 scanf("%d",&f);
 printf("%.2f",f_to_c(f));

 return 0;
}

float f_to_c(int a)
{
 float c;
 
 c = (a-32.00)*5.00/9.00;

 return c;
}
```

---

*第二次上机练习的题，都很简单。注意下文档编码问题，包含中文的最好用`GB2312编码`*

### 12.四则运算

输入二元表达式，进行运算。初中写过一个计算器，比这个复杂些。

```c
#include <stdio.h>

int calc(int a, int b, char calc);

int main(void)
{
    int num_1, num_2;
    char ch;

    scanf("%d%c%d", &num_1, &ch, &num_2);
    printf("%d%c%d=%d", num_1, ch, num_2, calc(num_1, num_2, ch));

    return 0;
}

int calc(int a, int b, char calc)
{
    switch (calc)
    {
    case '+':
        return a + b;

    case '-':
        return a - b;

    case '*':
        return a * b;

    case '/':
        return a / b;
    case '%':
        return a % b;
    }
}
```

注意，C语言中整数的除法结果都是带余除法，取余运算是`%`，是二元运算符，**只接受整数作为运算对象**。

### 13.数位输出

输出数字的各位。相当于给各位间加了个空格。这里用的是数学办法。

```c
#include <stdio.h>

int main(void)
{
    int a, i;

    scanf("%d", &a);
    for (i = 1; a >= i; i *= 10)
        ;
    i /= 10;
    for (; a > 0;)
    {
        printf("%d ", a / i);
        a -= a / i * i;
        i /= 10;
    }

    return 0;
}
```

注意空语句。它只有一个符号`;`，但是是一个完整的语句。

### 14.冰箱温度预测

很简单。注意将数据类型隐式转换为浮点数即可。

```c
/*    2.3 温度计算 - by xeonds    */

#include <stdio.h>

int main(void)
{
    int h, m;

    scanf("%d %d", &h, &m);
    printf("%.2f\n", 4.0 * (h + m / 60.0) * (h + m / 60.0) / ((h + m / 60.0) + 2) - 20);

    return 0;
}
```

### 15.除法计算器

怎么又是小明（(╯‵□′)╯︵┻━┻）

```c
#include <stdio.h>

int main(void)
{
    int m, n, q, r;

    scanf("%d %d %d %d", &m, &n, &q, &r);
    if (m / n == q && m % n == r)
        printf("yes");
    else
        printf("%d %d", m / n, m % n);

    return 0;
}
```

### 16.简单程序

```c
#include <stdio.h>

int main(void)
{
    puts("C programming language is useful!");
    puts("I like it very much.");

    return 0;
}
```

### 17.求平均值

注意隐式转换。

```c
#include <stdio.h>

int main(void)
{
    int a, b, c;

    scanf("%d %d %d", &a, &b, &c);
    printf("%.2f", (a + b + c) / 3.0);

    return 0;
}
```

### 18.计算球的体积

```c
#include <stdio.h>

int main(void)
{
    float r;

    scanf("%f", &r);
    printf("%.2f", 4 * 3.14 * r * r * r / 3);

    return 0;
}
```

### 19.工资发放

下面的程序可以抽象成函数来简化。

待会写（咕

```c
#include <stdio.h>

int main(void)
{
    int salary, m100 = 0, m50 = 0, m20 = 0, m10 = 0, m5 = 0, m1 = 0;

    scanf("%d", &salary);
    if (salary >= 100)
        m100 = salary / 100, salary = salary % 100;
    if (salary >= 50)
        m50 = salary / 50, salary = salary % 50;
    if (salary >= 20)
        m20 = salary / 20, salary = salary % 20;
    if (salary >= 10)
        m10 = salary / 10, salary = salary % 10;
    if (salary >= 5)
        m5 = salary / 5, salary = salary % 5;
    if (salary >= 1)
        m1 = salary / 1;
    printf("%d %d %d %d %d %d", m100, m50, m20, m10, m5, m1);

    return 0;
}
```

写出来之后感觉完全没有简化（笑）

```c
#include <stdio.h>
#include <stdlib.h>

int *m_calc(int m_size, int salary);

int main(void)
{
    int salary;

    scanf("%d", &salary);
    printf("%d %d %d %d %d %d", m_calc(100, salary)[0],
           m_calc(50, m_calc(100, salary)[1])[0],
           m_calc(20, m_calc(50, m_calc(100, salary)[1])[1])[0],
           m_calc(10, m_calc(20, m_calc(50, m_calc(100, salary)[1])[1])[1])[0],
           m_calc(5, m_calc(10, m_calc(20, m_calc(50, m_calc(100, salary)[1])[1])[1])[1])[0],
           m_calc(1, m_calc(5, m_calc(10, m_calc(20, m_calc(50, m_calc(100, salary)[1])[1])[1])[1])[1])[0]);

    return 0;
}

int *m_calc(int m_size, int salary)
{
    int *res;

    res = (int *)malloc(sizeof(int) * 2);
    res[0] = salary / m_size; //number of money
    res[1] = salary % m_size; //rest of salary
    return res;
}
```

### 20.三角形判别

```c
#include <stdio.h>

int main(void)
{
    int a, b, c;

    scanf("%d %d %d", &a, &b, &c);
    if (a + b > c && a + c > b && b + c > a)
        printf("%d", a + b + c);
    else
        printf("No");

    return 0;
}
```

判断部分可以用三目运算符简化成这样：

```c
(a + b > c && a + c > b && b + c > a)?printf("%d", a + b + c):printf("No");
```

### 21.判断奇偶性

*utf-8大法好，gb2312太谔谔了（ψ(｀^´)ψ*

```c
//encoding: GB2312

#include <stdio.h>

int main(void)
{
    int a;

    scanf("%d", &a);
    if (a > 0)
        if (a % 2 == 1)
            printf("奇数");
        else
            printf("偶数");

    return 0;
}
```

### 22.整除判断2

```c
#include <stdio.h>

int main(void)
{
 int num;

 scanf("%d",&num);
 if(num%35==0)
  printf("yes");
 else
  printf("no");

 return 0;
}
```

### 23.出租车计价

注意四舍五入的技巧：

```c
float num=5.4;
(int)(num+0.5);    //四舍五入
```

```c
#include <stdio.h>

float calc(float s,int t);

int main(void)
{
 float s;
 int t;

 scanf("%f %d",&s,&t);
 printf("%d",(int)(calc(s,t)+0.5));

 return 0;
}

float calc(float s,int t)
{
 float res=0;

 res=t/5*2;
 if(s>10)
  res+=24+3*(s-10);
 else if(s>3)
  res+=10+2*(s-3);
 else if(s>0)
  res+=10;
 
 return res;
}
```

### 24.利率计算

```c
#include <stdio.h>

int main(void)
{
 float r,p=1;
 int n;

 scanf("%f %d",&r,&n);
 for(;n>0;n--)
  p*=1+r;
 printf("%.2f",p);

 return 0;
}
```

### 25.购房贷款计算

>纯粹拿来恶心人的（虽然确实有实际应用背景

```c
#include <stdio.h>
#include <math.h>

int main(void)
{
 float month=0,d,p,r;

 scanf("%f %f %f",&d,&p,&r);
 month=log10((double)(p/(p-d*r)))/log10(1+(double)r);
 printf("%.2f",month);

 return 0;
}
```

### 26.字符加密

正经解法：

```c
#include <stdio.h>

int main(void)
{
 int ch[5] = "China", i;

 for (i = 0; i < 5; i++)
  putchar(ch[i] + 4);

 return 0;
}
```

不正经解法（大家别学我）：

```c
#include <stdio.h>

int main(void)
{
 printf("Glmre");

 return 0;
}
```

其实这就是crypto（密码学）中的凯撒密码。

### 27.课堂练习题-沸水降温曲线

```c
#include <stdio.h>

int main(void)
{
 int m,s;
 float t;

 scanf("%d %d",&m,&s);
 t=m+s/60.0;
 if(t>50)
  printf("%.1f",20.0);
 else if(t>30)
  printf("%.1f",30-(t-30)/2);
 else if(t>10)
  printf("%.1f",50-(t-10));
 else if(t>=0)
  printf("%.1f",100-5*t);

 return 0;
}
```

---

*第三次上机的题（不过标的是2？）难度很简单，唯一的问题是我没睡醒*
*《关于我8:00-12:00上机，我11:30醒这件事》*

### 1.数列分段

这下我终于知道那个第一题是哪来的了（

还请跳到第一题（

*为了保持序号数值和xdoj题数一样，此处序号就用1了*

### 28.最小差值

因为任意两个数都得作差，所以偷了个懒，用`malloc`把输入存到一个数组里了。

其实`malloc`完后，和数组的用法就差不多了。

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
 int i, j, res, a, *arr;

 scanf("%d", &a);
 arr = (int *)malloc(sizeof(int) * a);
 for (i = 0; i < a; i++) {
  scanf("%d", &arr[i]);
 }
 for (i = 0; i < a - 1; i++)
  for (j = i + 1; j < a; j++)
   if (i == 0 && j == 1)
    res = arr[i] - arr[j] < 0 ? arr[j] - arr[i] : arr[i] - arr[j];
   else {
    if (res > (arr[i] - arr[j] < 0 ? arr[j] - arr[i] : arr[i] - arr[j]))
     res = (arr[i] - arr[j] < 0 ? arr[j] - arr[i] : arr[i] - arr[j]);
   }
 printf("%d", res);

 return 0;
}
```

### 29.车牌限行_分支结构

看到群里有人在`if`里套了`switch`。其实没必要，限行的号码都是很有规律的。

```c
#include <stdio.h>

int main(void) {
 int a, b, c;

 scanf("%d %d %d", &a, &b, &c);
 if (a > 5 || b < 200)
  printf("%d no", c % 10);
 else if (b < 400)
  if (c % 5 == a % 5)
   printf("%d yes", c % 10);
  else
   printf("%d no", c % 10);
 else if (b >= 400)
  if (c % 2 == a % 2)
   printf("%d yes", c % 10);
  else
   printf("%d no", c % 10);

 return 0;
}
```

另外可别学我`if`和`else`不加括号，初学的话很容易弄不清`else`是属于哪个`else`的。对于这个，知道`else`属于最近的`if`就行。

### 30.计算某月天数_分支结构

这里有个`switch`的小技巧：`case`语句可以通过不加`break`来合并。

```c
#include <stdio.h>

int calc(int y, int m) {
 switch (m) {
  case 1:
  case 3:
  case 5:
  case 7:
  case 8:
  case 10:
  case 12:
   return 31;

  case 4:
  case 6:
  case 9:
  case 11:
   return 30;

  case 2:
   return (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 ? 29 : 28;
 }
}

int main(void) {
 int a, b;

 scanf("%d %d", &a, &b);
 printf("%d", calc(a, b));

 return 0;
}
```

### 31.计算整数各位数字之和

正好就是上面写的通用方法（

请上翻到10的通用写法。

所以说嘛，多想一点总是没错的。

### 32.最大公约数

```c
#include <stdio.h>

int gcd(int a, int b) {
 int res = 0, i;

 if (a > b) {
  i = a;
  a = b;
  b = i;
 }
 if (a == 0)
  return b;
 for (i = 1; i <= a; i++)
  if (a % i == 0 && b % i == 0)
   res = i;

 return res;
}

int main(void) {
 int a, b;

 scanf("%d %d", &a, &b);
 if (a >= 0 && b < 10000)
  printf("%d", gcd(a, b));

 return 0;
}
```

本来是想用

```c
i=a,a=b,b=i;
```

来做a和b值的交换的，但是平台上那个hmp编译器好像不支持逗号运算符？

还是我搞错编译器了呢？（笑）

### 33.角谷定理

```c
#include <stdio.h>

int main(void) {
 int a, i;

 scanf("%d", &a);
 for (i = 0; a != 1; i++)
  if (a % 2 == 0)
   a /= 2;
  else
   a = (a *= 3) + 1;
 printf("%d", i);

 return 0;
}
```

### 34.PM2.5

```c
#include <stdio.h>

int main(void) {
 int res[6] = {0, 0, 0, 0, 0, 0}, data, a, i, sum;

 scanf("%d", &a);
 for (i = 0, sum = 0; i < a; i++) {
  scanf("%d", &data);
  if (data > 300)
   res[5]++;
  else if (data > 200)
   res[4]++;
  else if (data > 150)
   res[3]++;
  else if (data > 100)
   res[2]++;
  else if (data > 50)
   res[1]++;
  else if (data >= 0)
   res[0]++;
  sum += data;
 }
 printf("%.2f\n", (float)sum / a);
 for (i = 0; i < 6; i++)
  printf("%d ", res[i]);

 return 0;
}
```

### 35.气温波动

注意，是**相邻两天波动的绝对值最大值**，而不是所有天温度的最大值减去最小值。

这里的`prev`和`curr`表示上一个和当前的，是写链表的习惯。

```c
#include <stdio.h>
#include <math.h>

int main(void) {
 int curr, prev, res, a, i, tmp;

 scanf("%d", &a);
 if (a >= 2 && a <= 30) {
  for (i = 0, res = 0; i < a; i++) {
   if (i == 0) {
    scanf("%d", &prev);
    continue;
   }
   scanf("%d", &curr);
   if (abs(curr - prev) > res)
    res = abs(curr - prev);
   prev = curr;
  }
  printf("%d", res);
 }

 return 0;
}
```

### 36.完全平方数

前面有个同学问到过这个。需要注意，`==`的使用前提是两边的数据类型相同，所以可以这么写：

```c
if (sqrt(a) - (int)sqrt(a) == 0)
    statement;
```

而不能这么写：

```c
if (sqrt(a) == (int)sqrt(a))
    statement;
```

```c
#include <stdio.h>
#include <math.h>

int main(void) {
 int a;

 scanf("%d", &a);
 if (sqrt(a) - (int)sqrt(a) == 0)
  printf("%d", (int)sqrt(a));
 else
  printf("no");

 return 0;
}
```

### 37.选号程序

做这题的时候又犯迷糊了。。其实只需要相邻两数依次比较就行。第一回做的时候直接来了个`O(n!)`的比较，纯属没睡醒。

```c
#include <stdio.h>

int calc(int num);

int main(void) {
 int a, i, data, res;

 scanf("%d", &a);
 for (i = 0; i < a; i++) {
  if (i == 0) {
   scanf("%d", &res);
   continue;
  }
  scanf("%d", &data);
  if (calc(res) < calc(data))
   res = data;
  else if (calc(res) == calc(data))
   res = res > data ? res : data;
 }
 printf("%d", res);

 return 0;
}

int calc(int num) {
 if (num >= 10)
  return num % 10 + calc((num - num % 10) / 10);
 else
  return num;
}
```

### 38.自然数分解

其实好多时候都没有用函数的必要，除了必须递归的算法。

大多数时候，我这么用，只是用了自己总结的模板而已：大多数题都是输入数，经过处理再输出数。

重复的部分我是懒得再敲一遍的。

```c
#include <stdio.h>

int calc(int a, int i) {
 return 2 * i - (a + 1);
}

int main(void) {
 int a, i;

 scanf("%d", &a);
 if (a > 0 && a < 30)
  for (i = 1; i < a + 1; i++)
   printf("%d ", a * a + calc(a, i));

 return 0;
}
```

### 39.日期计算

怎么说呢，难度简单，就是做的有些晕。

果然下次还是得睡好啊（叹）。

```c
#include <stdio.h>

int main(void) {
 int y, m, d, n, n0, i, 
  arr_n[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}, 
  arr_o[12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

 scanf("%d %d", &y, &n);
 if (y % 4 == 0 && y % 100 != 0 || y % 400 == 0) {
  for (m = 1; m <= 12; m++) {
   for (i = 0, n0 = 0; i < m; i++)
    n0 += arr_o[i];
   if (n <= n0) {
    for (i = 0, n0 = 0; i < m - 1; i++)
     n0 += arr_o[i];
    d = n - n0;
    break;
   }
  }
 } else {
  for (m = 1; m <= 12; m++) {
   for (n0 = 0, i = 0; i < m; i++)
    n0 += arr_n[i];
   if (n <= n0) {
    for (n0 = 0, i = 0; i < m - 1; i++)
     n0 += arr_n[i];
    d = n - n0;
    break;
   }
  }
 }
 printf("%d %d", m, d);

 return 0;
}
```

### 40.跳一跳

有个坑：第一个值为2的话，如果没初始化`flag=0`的话就会出错。

给未初始化的值自增肯定有问题啊。

```c
#include <stdio.h>

int main(void) {
 int a, res = 0, flag=0;

 while (scanf("%d", &a) && a != 0)
  if (a == 1) {
   res++;
   flag = 0;
  } else if (a == 2) {
   flag++;
   res += 2 * flag;
  }
 printf("%d", res);

 return 0;
}
```

### 41.累加和校验

md，搞了半天，原来是输入得用`EOF`结束。我就说看错误列表里全是time out，原来oj上输入的终止符是`EOF`。刚开始用的`'\n'`，难怪过不了。

```c
#include <stdio.h>

int main(void)
{
 char ch;
 int res = 0;

 while ((ch = getchar()) != EOF)
  res += ch;
 printf("%d\n", res % 256);

 return 0;
}
```

---

*第四次上机题很简单，不用想，但是写起来挺费时间*
*待会再写分析*

### 42.阶梯电价1_分支结构

浪费时间。

```c
#include <stdio.h>

int main(void) {
 double a, res;

 scanf("%lf", &a);
 if (a > 210) {
  res = (a - 210) * 0.70 + 110;
 } else if (a > 110) {
  res = (a - 110) * 0.55 + 55;
 } else if (a >= 0) {
  res = a * 0.5;
 }
 printf("%.2lf", res);

 return 0;
}
```

### 43.完数

```c
#include <stdio.h>

int is_ok_num(int num);

int main(void) {
 int i, a, b;

 scanf("%d %d", &a, &b);
 for (i = a; i <= b; i++)
  if (is_ok_num(i))
   printf("%d\n", i);

 return 0;
}

int is_ok_num(int num) {
 int i, add;

 for (i = 1, add = 0; i < num; i++)
  add += (num % i == 0 ? i : 0);

 return num == add ? 1 : 0;
}
```

### 44.整数分析

```c
#include <stdio.h>

int main(void) {
 int a, max, min, bit;

 scanf("%d", &a);
 max = min = a % 10;
 bit = a == 0 ? 1 : 0;
 while (a != 0) {
  int c = a % 10;
  max = max >= c ? max : c;
  min = min <= c ? min : c;
  a = (a -= a % 10) / 10;
  bit++;
 }
 printf("%d %d %d\n", bit, max, min);

 return 0;
}
```

### 45.折点计数

```c
#include <stdio.h>

int main(void) {
 int a, i, curr, prev, next, count;

 scanf("%d", &a);
 for (i = 1, count = 0; i < a - 1; i++)
  if (i == 1) {
   scanf("%d %d %d", &prev, &curr, &next);
   if ((curr - prev) * (next - curr) < 0)
    count++;
   prev = curr, curr = next;
  } else {
   scanf("%d", &next);
   if ((curr - prev) * (next - curr) < 0)
    count++;
   prev = curr, curr = next;
  }
 printf("%d", count);

 return 0;
}
```

### 46.寻找最大整数_分支结构

```c
#include <stdio.h>

int main(void) {
 int num, i;

 for (i = 0; i < 4; i++)
  if (i == 1) {
   scanf("%d", &num);
   continue;
  } else {
   int curr;
   scanf("%d", &curr);
   num = curr > num ? curr : num;
  }
 printf("%d", num);

 return 0;
}
```

### 47.字符处理_分支结构

```c
#include <stdio.h>

int main(void) {
 int ch;

 ch = getchar();
 if (ch >= 65 && ch <= 90)
  putchar(ch + 32);
 else if (ch >= 97 && ch <= 122)
  putchar(ch - 32);
 else
  putchar(ch);

 return 0;
}
```

### 48.成绩分级1_分支结构

```c
#include <stdio.h>

int main(void) {
 int score;

 scanf("%d", &score);
 if (score >= 90 && score <= 100)
  putchar('A');
 else if (score >= 80)
  putchar('B');
 else if (score >= 70)
  putchar('C');
 else if (score >= 60)
  putchar('D');
 else if (score >= 0)
  putchar('E');

 return 0;
}
```

### 49.abc组合

```c
#include <stdio.h>

int main(void) {
 int num, a, b, c;

 scanf("%d", &num);
 for (a = 0; a <= 9; a++)
  for (b = 0; b <= 9; b++)
   for (c = 0; c <= 9; c++)
    if ((a + c) * 100 + b * 20 + (a + c) == num)
     printf("%d %d %d\n", a, b, c);

 return 0;
}
```

### 50.直角三角形判断_分支结构

```c
#include <stdio.h>

int main(void) {
 int a[3], i, j, tmp;

 scanf("%d %d %d", &a[0], &a[1], &a[2]);
 for (i = 0; i < 2; i++)
  for (j = i + 1; j < 3; j++)
   if (a[i] > a[j])
    tmp = a[i], a[i] = a[j], a[j] = tmp;
 if (a[0] + a[1] > a[2] && a[0] + a[2] > a[1] && a[1] + a[2] > a[0])
  if (a[0] * a[0] + a[1] * a[1] == a[2] * a[2])
   printf("%d", a[0]*a[1]);
  else
   printf("no");
 else
  printf("no");

 return 0;
}
```

### 51.工资计算_分支结构

```c
#include <stdio.h>

int main(void) {
 int num;
 double res;

 scanf("%d", &num);
 if (num > 3500) {
  num -= 3500;
  if (num > 35000)
   res = (num - 35000) * 0.7 + 26000 * 0.75 + 4500 * 0.8 +  3000 * 0.9 + 1500 * 0.97;
  else if (num > 9000)
   res = (num - 9000) * 0.75 + 4500 * 0.8 +  3000 * 0.9 + 1500 * 0.97;
  else if (num > 4500)
   res = (num - 4500) * 0.8 + 3000 * 0.9 + 1500 * 0.97;
  else if (num > 1500)
   res = (num - 1500) * 0.9 + 1500 * 0.97;
  else
   res = num * 0.97;
  res += 3500;
 } else
  res = num;
 printf("%d", (int)res);

 return 0;
}
```

### 52.平均数

```c
#include <stdio.h>

int main(void) {
 int a, i, num;
 double res;

 scanf("%d", &a);
 for (i = 0, res = 0; i < a; i++) {
  scanf("%d", &num);
  res += 1 / (double)a * (double)num;
 }
 printf("%.2lf", res);

 return 0;
}
```

---

*第五次上机练习题*

*难度简单，随便做就行*

*服务器卡的让人没心情做。。*

## 53.水仙花数

水仙花数指**大于等于三位**的数，如果**各位的位数次幂的和等于自身**，则称为水仙花数。

要求交一个函数。。就，稍微有点麻烦。本来想用函数中声明函数的奇淫技巧，但是这样就没意思了，所以还是算了。。

```c
int function(int a, int b)
{
    /*  tmp     ：临时变量，用于交换a，b的值 
        i       ：计数变量，用于表示a到b（含a，b）之间的所有数
        count   ：计数变量，用于存储水仙花数的个数
    */
    int tmp, i, count;

    /*  交换a，b的值来确保a<b */
    a > b ? tmp = a, a = b, b = tmp : 1;
    /*  循环，遍历含a，b的在a，b间的所有数 */
    for (i = a, count = 0; i <= b; i++)
    {
        /*  bit     ：存储数字i的位数
            bit_sum ：存储数字i的各位幂次和
            i_cpy   ：i的复制，用来参与求i位数的计算，防止i的值改变，影响循环
            j       ：循环变量，用来参与求i各位幂次和的运算
        */
        int bit, bit_sum, i_cpy = i, j;
        /*  计算i的位数，存储到变量bit中 */
        for (bit = 1; i_cpy / (int)pow(10, bit) != 0; bit++)
            ;
        /*  恢复i_cpy的值为i，以便于参与接下来求i各位幂次和的运算 */
        i_cpy = i;
        /*  计算i的各位幂次和 */
        for (j = 0, bit_sum = 0; j < bit; j++)
            bit_sum += (int)pow(i_cpy % 10, bit), i_cpy /= 10;
        /*  根据水仙花数的定义（大于等于三位，各位幂次和为其本身）判断i是否为水仙花数 */
        if (i == bit_sum && bit > 2)
            count++;
    }

    return count;
}
```

## 54.哥德巴赫猜想

先吐槽下XDOJ上的**歌德巴赫猜想**（xswl

思路就是`for`循环，逐组尝试。注意C语言的模块化思想，设计程序时从抽象到具体。

```c
#include <stdio.h>

int is_prime(int num) {
 int i, res;

 for (i = 1, res = 1; i < num; i++)
  if (num % i == 0 && i != 1)
   res = 0;

 return res;
}

int main(void) {
 int a, i, min, max;

 scanf("%d", &a);
 for (i = 2; i < a; i++)
  if (is_prime(i) && is_prime(a - i)) {
   printf("%d %d", i, a - i);
   break;
  }

 return 0;
}
```

## 55.斐波纳契数列素数判断

直接把上面写好的`is_prime`拿过来，再写个`fib`，就完成了。

```c
#include <stdio.h>

int is_prime(int num) {
 int i, res;

 for (i = 1, res = 1; i < num; i++)
  if (num % i == 0 && i != 1)
   res = 0;

 return res;
}

int fib(int i) {
 if (i > 2)
  return fib(i - 1) + fib(i - 2);
 else
  return 1;
}

int main(void) {
 int num;

 scanf("%d", &num);
 if (is_prime(fib(num)))
  printf("yes");
 else
  printf("%d", fib(num));

 return 0;
}
```

## 56.数列求和

一个关于斐波那契数列的数列，对其求和。

思路很清晰，就是先用斐波那契数列表示出来这个数列，然后再进行逐项求和运算。

```c
#include <stdio.h>

double fib(int i) {
 if (i > 2)
  return fib(i - 1) + fib(i - 2);
 else
  return 1.0;
}

int main(void) {
 int i, n;
 double res;

 scanf("%d", &n);
 for (i = 0, res = 0; i < n; i++)
  res += fib(i + 3) / fib(i + 2);
 printf("%.2f", res);

 return 0;
}
```

## 57.字符串元素统计

注意`ASCII码`的灵活运用。还有就是`ch=getchar()`的终止条件不要选错，不然就是死循环了。

```c
#include <stdio.h>

int main(void) 
{
 int ch, a = 0, b = 0;

 while ((ch = getchar()) != EOF && ch != '\n')
  if (ch >= '0' && ch <= '9')
   a++;
  else if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))
   b++;
 printf("%d,%d", b, a);

 return 0;
}
```

## 58.字符串查找

查找字母在字符串中的出现次数。把上面那个题删减一下就行。

```c
#include <stdio.h>

int main(void) {
 int ch, c = 0;

 while ((ch = getchar()) != EOF && ch != '\n')
  if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'))
   c++;
 printf("%d", c);

 return 0;
}
```

## 59.字符串筛选

隔一个输出。所以用一个计数器就行了。

```c
#include <stdio.h>

int fun(char *ch) {
 int i;
 for (i = 0; *ch != '\0'; i++)
  if (i % 2 == 0)
   putchar(*ch++);
  else
   ch++;
}

int main(void) {
 char ch[100];

 scanf("%s", &ch);
 fun(ch);

 return 0;
}
```

## 60.字符串连接

不正经解法。别学我（

正经解法是：读入两个字符串常量，然后存储在res数组中，最后返回它的指针即可。

*懒得写了*

```c
#include <stdio.h>

char *fun(char *a, char *b) {
 char res[200];

 printf("%s%s", a, b);

 return res;
}

int main(void) {
 int ch, a[100], b[100], *res, i;

 scanf("%s %s", a, b);
 fun(a, b);

 return 0;
}
```

## 61.整数转换为字符串

除了下面的解法，也可以严格按照题目要求来解：`gechar`读入字符，再输出就行。

```c
#include <stdio.h>

int main(void) {
 int a;

 scanf("%d", &a);
 printf("%d", a);

 return 0;
}
```

实在是不知道这题存在的意义。。

## 62.十六进制转换为十进制

如果是十三进制转十进制这样的，就有难度了。。

这个的解法可以参照我前面写的进制转换那篇，回头我也会再写一个更通用的。

```c
#include <stdio.h>

int main(void) {
 int a;

 scanf("%x", &a);
 printf("%d", a);

 return 0;
}
```

## 63.递归数列

```c
double function(int n) {
 if (n == 1)
  return 1.000000;
 else
  return 1.000000 / (1.000000 + function(--n));
}
```

## 64.Fibonacci数列

```c
int fib(int n)
{
    if (n == 0)
        return 7;
    else if (n == 1)
        return 11;
    else
        return fib(n - 1) + fib(n - 2);
}
```

## 65.数字处理

```c
#include <stdio.h>

int bit_sum(int num)
{ 
 return num>=10?num%10+bit_sum(num/10):num;
}

int main(void)
{
 int num;

 scanf("%d",&num);
 while(num>=10)
  num=bit_sum(num);
 printf("%d",num);

 return 0;
}
```

## 66.阶乘计算

```c
#include <stdio.h>

double mul(int num)
{
 if(num>1)
  return 1.0*num * mul(num-1);
 else
  return 1.0;
}

int main(void)
{
 int m,n,tmp;

 scanf("%d %d",&m,&n);
 if(m<n)
  tmp=m,m=n,n=tmp;
 printf("%.2f",mul(m)/mul(n)/mul(m-n));

 return 0;
}
```

## 67.金字塔打印

```c
#include <stdio.h>

void tow(int ch,int line)
{
 int i;

 for(i=0;i<line;i++)
 {
  /* 1.print space */
  for(int j=i;j<line-1;j++)
   putchar(' ');
  /* 2.print char */
  for(int k=0;k<2*i+1;k++)
   putchar(k%2==0?ch:' ');
  /* 3.start a new line */
  if(i!=line-1)
   puts("");
 }
}

int main(void)
{
 int ch,n;

 scanf("%c %d",&ch,&n);
 tow(ch,n);

 return 0;
}
```

## 68.字符逆序排放

```c
#include <stdio.h>

int main(void)
{
 int ch[100],i=0;

 while(ch[i]=getchar(),ch[i]!=EOF&&ch[i]!='\n')
  i++;
 while(i--)
  putchar(ch[i]);

 return 0;
}
```

## 69.素数判断

```c
#include <stdio.h>

int is_prime(int num)
{
 for(int i=2;i<num;i++)
  if(num%i==0&&num!=2)
   return 0;

 return 1;
}

int main(void)
{
 int num;

 scanf("%d",&num);
 printf("%s",is_prime(num)?"YES":"NO");

 return 0;
}
```

## 70.调用函数求素数

```c
#include <stdio.h>

int fun(int num, int* arr);

int main(void)
{
 int num,i,j=0,arr[64];

 scanf("%d",&num);
 printf("%d\n",i=fun(num,arr));
 while(i-j)
  printf("%d ",arr[j]),j++;

 return 0;
}

int fun(int num, int* arr)
{
 int res=0;

 for(int i=2;i<=num;i++)
 {
  int flag=1;
  if(i==2);
  else if(i>2)
   for(int j=2;j<i;j++)
    if(i%j==0)
     flag=0;
  if(flag)
   *arr++=i,res++;
 }

 return res;
}
```

## 71.函数与数组

*这题啥也没有，直接提交就行*

*估计是忘放题了*

---

*已经忘了是多少次练习了。。*

## 72.消除类游戏

*之前写2048的时候写过类似算法*

```c
#include <stdio.h>

int main(void)
{
    int arr[30][30], arr_new[30][30];
    int m, n, i, j;

    scanf("%d %d", &m, &n);
    for (i = 0; i < m; i++)
        for (j = 0; j < n; j++)
            scanf("%d", &arr[i][j]), arr_new[i][j] = arr[i][j];
    for (i = 0; i < m; i++)
    {
        int flag = 0;
        for (j = 0; j < n - 1; j++)
        {
            if (arr[i][j] == arr[i][j + 1])
                flag++;
            else
                flag = 0;
            if (flag >= 2)
                arr_new[i][j - 1] = arr_new[i][j] = arr_new[i][j + 1] = 0;
        }
    }
    for (j = 0; j < n; j++)
    {
        int flag = 0;
        for (i = 0; i < m - 1; i++)
        {
            if (arr[i][j] == arr[i + 1][j])
                flag++;
            else
                flag = 0;
            if (flag >= 2)
                arr_new[i - 1][j] = arr_new[i][j] = arr_new[i + 1][j] = 0;
        }
    }
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < n; j++)
            printf("%d ", arr_new[i][j]);
        puts("");
    }

    return 0;
}
```

稍微解释下吧。一共四个`for`循环，首尾两个负责输入输出，中间两个分别用于处理每一行和每一列。

处理思路很简单，参考第一题。

代码很丑，本想重构一下，抽个函数出来，结果让指针绊住了。。还是学艺不精.jpg

## 73.数字排序

```c
#include <stdio.h>
#include <stdlib.h>

int bit_sum(int num);
int compare(int a, int b);

int main(void)
{
    int i, j, n, *arr, tmp;

    scanf("%d", &n);
    arr = (int *)malloc(sizeof(int) * n);
    for (i = 0; i < n; i++)
        scanf("%d", &arr[i]);
    for (i = 0; i < n - 1; i++)
        for (j = i + 1; j < n; j++)
            if (compare(arr[i], arr[j]) < 0||(compare(arr[i], arr[j]) == 0&&arr[i] > arr[j]))
                tmp = arr[i], arr[i] = arr[j], arr[j] = tmp;
    for (i = 0; i < n; i++)
        printf("%d %d\n", arr[i], bit_sum(arr[i]));

    return 0;
}

int bit_sum(int num)
{
    int res = 0;

    while (num)
        res += num % 10, num /= 10;

    return res;
}

int compare(int a, int b)
{
    return bit_sum(a) > bit_sum(b)?1:bit_sum(a) == bit_sum(b)?0:-1;
}
```

`bit_sum`是计算各位和的函数，`compare`是比较两个数各位和大小的函数。逻辑在主程序中完成。

## 74.矩阵

```c
#include <stdio.h>
#include <stdlib.h>

void sort(int *arr, int len);

int main(void)
{
    int n, *arr, *res, i, j;

    scanf("%d", &n);
    res = (int *)malloc(sizeof(int) * n * 2 + 2);
    arr = (int *)malloc(sizeof(int) * n * n);
    for (i = 0; i < n * n; i++)
        scanf("%d", &arr[i]);
    for (i = 0; i < n; i++)
        for (res[i] = 0, j = 0; j < n; j++)
            res[i] += arr[i * n + j];
    for (; i < n * 2; i++)
        for (res[i] = 0, j = 0; j < n; j++)
            res[i] += arr[i - n + j * n];
    for (j = res[i] = res[i + 1] = 0; j < n; j++)
    {
        res[i] += arr[j + j * n];
        res[i + 1] += arr[n - 1 - j + j * n];
    }
    sort(res, n * 2 + 2);
    for (i = 0; i < n * 2 + 2; i++)
        printf("%d ", res[i]);

    return 0;
}

void sort(int *arr, int len)
{
    int i, j, tmp;

    for (i = 0; i < len - 1; i++)
        for (j = i + 1; j < len; j++)
            if (arr[i] < arr[j])
                tmp = arr[i], arr[i] = arr[j], arr[j] = tmp;
}
```

大概算了一下规律，然后用一维数组解决了。

比较有意思的一个是，我们可以把这个`sort`函数改进一下，变成一个更通用的排序函数。这样，上一个题也能用它解决了。

上代码：

```c
void sort(int *arr, int len,int (*cmp)(int a,int b))
{
    int exchange(int *a,int *b){int i;i=*a,*a=*b,*b=i;}
    int i, j, tmp;

    for (i = 0; i < len - 1; i++)
        for (j = i + 1; j < len; j++)
            if (arr[i] < arr[j])
                exchange(&arr[i], &arr[j]);
}
```

这里的函数嵌套是C语言支持但不推荐的特性。我用`gcc`可以编译。

用它来解决上一题：

```c
#include <stdio.h>
#include <stdlib.h>

int compare(int a, int b);
void sort(int *arr, int len,int (*cmp)(int a,int b));
int bit_sum(int num){return res>0?res%10+bit_sum(res/10):0;}

int main(void)
{
    int i, j, n, *arr, tmp;

    scanf("%d", &n);
    arr = (int *)malloc(sizeof(int) * n);
    for (i = 0; i < n; i++)
        scanf("%d", &arr[i]);
    sort(arr, n, cmp_bit_sum);
    for (i = 0; i < n; i++)
        printf("%d %d\n", arr[i], bit_sum(arr[i]));

    return 0;
}

int cmp_bit_sum(int a, int b)
{
    return bit_sum(a) > bit_sum(b)?1:bit_sum(a) == bit_sum(b)?0:-1;
}

void sort(int *arr, int len,int (*cmp)(int a,int b))
{
    int exchange(int *a,int *b){int i;i=*a,*a=*b,*b=i;}
    int i, j;

    for (i = 0; i < len - 1; i++)
        for (j = i + 1; j < len; j++)
            if (arr[i] < arr[j])
                exchange(&arr[i], &arr[j]);
}
```

## 75.回文数

```c
#include <stdio.h>
int is_rev(int num);
int bit_sum(int num);
int get_bit(int num, int bit)
{
    int xpow(int a, int b) { return b > 0 ? a * xpow(a, b - 1) : 1; }
    return (num % (xpow(10, bit)) - num % (xpow(10, bit - 2))) / xpow(10, bit - 1);
}

int main(void)
{
    int num;

    scanf("%d", &num);
    if (is_rev(num))
        printf("%d", bit_sum(num));
    else
        printf("no");

    return 0;
}

int is_rev(int num)
{
    int origin = num, bit = 0, i, end = 0;
    if (num == 0)
        return 1;
    else
        while (bit++, num /= 10);
    num = origin;
    for (i = 1, end = bit % 2 == 0 ? bit / 2 : (bit - 1) / 2; i <= end; i++)
        if (get_bit(num, i) != get_bit(num, bit - i + 1))
            return 0;
    return 1;
}

int bit_sum(int num)
{
    int res = 0;
    while (res += num % 10, num /= 10);
    return res;
}
```

这题思路很多，愿意的话也可以用字符串处理来完成。

总是自己写`pow`是因为我这边本地环境里`pow`好像是坏的。。
