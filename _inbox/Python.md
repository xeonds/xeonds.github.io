---
title: Python
date: 2022.12.13 17:24:55
author: xeonds
toc: true
excerpt: 一个脚本语言，作为辅助工具很香
tags:
  - 编程语言
---

缩进式，强类型，面向对象，包管理器，脚本语言，这都是Python。

## 简介

是一种脚本式[[编程语言]]。

## 起源

Python源自C语言，其语法十分简洁，自带强大的几种数据结构：列表，集合，元组，对于新手非常友好。

## 简洁

```python
# filename: wordcnt.py
f = open("a.txt", "r")
text = f.read()
words = f.split()
print("Word count: " + len(words))                 # 输出总词数
print([word for i in words if word == word[::-1]]) # 输出所有正反相同的单词
```

这是一个Python的示例，在同一目录准备好一份名为`a.txt`的英文文件，用idle打开并按`F5`执行，涉及流程控制，生成器表达式，切片，变量，文件IO。但是Python远不止如此，语法是基础，真正的核心与灵魂在于众多的优秀库——无论是官方的还是社区的。

## 包管理

Python使用pip进行包管理。例如，我要安装`requests`库，在终端键入

```bash
pip install requests
```

回车，即可安装。使用也很简单，用`import`导入即可：

```python
import requests

host = 'm.weibo.cn'
base_url = 'https://%s/api/container/getIndex?' % host
user_agent = 'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Mobile Safari/537.36'
headers = {
    'Host': host,
    'Referer': 'https://m.weibo.cn/search?containerid=231522type%3D1%26q%3D%23%E7%BE%8E%E5%9B%BD%E7%96%AB%E6%83%85%23',
    'User-Agent': user_agent
}

# 按页数抓取数据
def get_single_page(page):
    #请求参数
    params = {
        'containerid': '231522type=1&q=#美国疫情#',
        'page_type': 'searchall',
        'page': page
    }
    url = base_url + urlencode(params)
    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            return response.json()
    except requests.ConnectionError as e:
        print('抓取错误', e.args)

if __name__ == '__main__':
    for page in range(1, 200):  # 瀑布流下拉式，加载200次
        print(get_single_page(page))
```

上面是一个简单的微博爬虫，同时也展示了异常处理、函数、迭代的用法。

### 使用镜像站加速pip

```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

或者只想临时使用：

```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple 包名
```

## 疑难杂症

- [python - conda when running give RuntimeError: OpenSSL 3.0's legacy provider failed to load - Stack Overflow](https://stackoverflow.com/questions/76949979/conda-when-running-give-runtimeerror-openssl-3-0s-legacy-provider-failed-to-lo)

## 其他资料

- [[Crypto入门指北]]：在这个方面，Python也是很实用的工具
- [[Pwn从入门到入狱]]：同上
