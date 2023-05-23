---
title: 用Python写一个字典生成器
tags:
  - Python
  - Crypto
excerpt: 写起来很简单，就是运行速度。。稍微短一点的密码还行，长一些的。。那还是别输出了，别把硬盘炸了(
toc: true
author: xeonds
date: '2021.09.06 23:07:15'
categories:
  - 计算机科学
  - 编程语言
  - Python
---

## 序言

>你知道52的7次方有多大吗？我算过，如果存储这么多个7位密码，大概需要13TiB的存储空间。

这就是我写了两个版本字典生成方法的原因：如果真的要全部生成完再去跑字典，那几乎是不可能的事。

## 算法1：for循环递归

这是一个相当简单粗暴的算法。

```python
def gen_with_for(length, letters, result = ''):
       length = int(length)
       letters = str(letters)
       if length == 1:
           ls = []
          for i in letters:
              ls.append(result+i)
          return ls
      else:
          ls = []
          for i in letters:
              ls += gen_with_for(length-1,letters,result+i)
          return ls
```

这个算法优点就是简单。只需要知道密码长度，密码包含的所有字符就可以穷举出所有组合。

不过缺点也很明显。随着循环层数的增加，最内层循环次数指数级增加。如果密码稍长一点，电脑内存可能就炸了。

## 算法2：进制转换

穷举密码的本质，其实也就是将对应的十进制数转换成用一些符号表达的p进制数。

```python
def gen_with_convert(number, letters):
    length = len(letters)
    result = ''
    while number:
        number, rest = divmod(number-1, length)
        result = letters[rest] + result
    return result
```

相比前一个算法，这个算法虽然慢一些，但是内存占用不会像前一个那么嚣张（

不过，我要生成所有7位含52个符号的密码，需要从第几个密码开始生成呢？

我也不知道。所以，我又写了这个函数。

```python
def loop_time_calc(length, l_length):
    if length == 0:
        return 1
    return pow(l_length, length) + loop_time_calc(length -1, l_length)
```

这样，就大大简化了调用过程。同时因为密码是逐个返回的，所以完全可以把它和破解指令丢在同一个for里，破解和生成同步进行，可以减少破解耗时。

完整版是这样：

```python
#!/usr/bin/python
import optparse

def gen(number, letters):
    length = len(letters)
    result = ''
    while number:
        number, rest = divmod(number-1, length)
        result = letters[rest] + result
    return result

def loop_time_calc(length, l_length):
    if length == 0:
        return 1
    return pow(l_length, length) + loop_time_calc(length -1, l_length)

def main():
    parse = optparse.OptionParser("Param: -l <Length> -c <Characters>")
    parse.add_option("-l", dest="length", help="get password length")
    parse.add_option("-c", dest="characters", help="get characters in password")
    (options, args) = parse.parse_args()
    if (options.length == None) | (options.characters == None):
        print(parse.usage)
    else:
        length = options.length
        characters = options.characters
        _s, _e = loop_time_calc(int(length)-1,len(characters)), loop_time_calc(int(length),len(characters))
        for i in range(_s, _e):
            print(gen(i, characters))

main()
```

调用格式：

```bash
root@xeonds:~# ./pass_gen.py -l 4 -c 0123456789 > pass.txt
```

上面的指令生成所有四位纯数字密码。

>所以说纯数字密码不安全嘛.jpg（

## 小结

用[[Python|Python]]做这种东西很方便。不过在解密压缩包上，已经有很好用的HashCat了。

就算法方面来说，说到底，还是要数学好嘛（摊）。进制转换好像小学奥数就有讲？无所谓，反正我已经忘了（逃
