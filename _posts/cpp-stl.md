---
title: C++-STL速通
date: 2023-09-14 22:09:12
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
    - C++
    - STL
---

C++用的比较少，最近准备试试CSP。于是就得赶紧学学STL。以前是用过，但是没咋记下来。

想查看所有std实体的话，使用下面的指令：

```bash
apropos -r '^std' | vim -
```

关于`apropos`，它是LINUX系统中的一个命令，用来通过关键字查找定位手册页的名字和描述。 它相当于使用带有-k选项的man命令。 每个手册页里都有一个简短的描述。 apropos在这个描述中查找keyword。这是使用`man` 帮助文档的一个好工具。

## 分类

- 顺序式：`vector, list, deque`

```cpp
begin()
end()
rbegin()
rend()
front()
back()
erase()
clear()
push_back()
pop_back()
insert()
```

### Vector

```cpp
#include <vector>
```

简而言之就是数组，但是优化过，缝合了诸如队列、栈一类的特性。

```cpp
vector<int> vec; // 声明一个空的vector
vector<int> vec(5);
vector<int> vec(10, 1); // 大小为10, 初始值为1
vector<int> vec(oldVec);
vector<int> vec(oldVec.begin(), dolVec.begin()+3);
int arr[5] = {1, 2, 3, 4, 5};
vector<int> vec(arr, arr+5); // 用数组初始化vec
vector<int> vec(&arr[0], &arr[5]); // 用数组初始化vec, 注意这里是超尾, 与end相对应
```


那么如果我希望直接在下标为5的位置直接放入这个3呢，那不是需要先往里塞入5个0才可以么？这种情况，我们就可以定义一下vector的长度，然后就可以当做数组一样用了

```cpp
vector<int> a(10);
a[5] = 3;
```

### List

```cpp
#include <list>
```

双向链表。因此并不支持随机访问。尾部插入元素效率很高。

```cpp
list<int> l;
list<int> l(5); // 含有5个元素的list, 初始值为0
list<int> l(10, 1); // 含有10个元素的list, 初始值为1
list<int> l(oldL); // 复制构造
list<int> l(oldL.begin(), oldL.end());
int arr[5] = {1, 2, 3, 4, 5};
list<int> l(arr, arr+5); // 用数组初始化list
list<int> l(&arr[1], &arr[5]); // 用数组初始化list

list.merge() // 合并两个list
list.remove()
list.remove_if() // 按指定条件删除元素
list.reverse() // 逆置list元素
list.sort() // 排序
list.unique() // 删除重复元素
list.splice() // 从另一个 list 中移动元素

// Most used functions

push_front() // vector 没有该函数
pop_front() // vector 没有该函数
```

### Deque

```cpp
#include <deque>
```

双端队列。每个元素在内存上是连续的，类似vector，是它的升级版。它有高效的首尾插入/删除操作。实现方法相当于list和vector的折衷。

它支持随机访问和`at()`。

```cpp
push_back()
pop_back()
push_front() // vector 没有该函数
pop_front() // vector 没有该函数
```
- 关联式容器： `map, unordered_map, multimap, unordered_multimap, set, unordered_set, multiset, unordered_multiset`

### Map

```cpp
#include <map>
```

一种基于红黑树的键值对数据结构。

```cpp
// 数据插入, 复杂度为 logn
map.insert({key, value});
map[key] = value;
// 移除, 复杂度为 logn
map.erase(key)
// 搜索, 复杂度为 logn
map.find()
map[key]

map.count() // 返回匹配特定键的元素数量, 对数复杂度
map.contains()
map.equal_range()
map.lower_bound()
map.upper_bound()
```

### Unordered-Map

```cpp
#include <unordered_map>
```

区别于前者使用红黑树实现，它使用哈希函数实现，因此元素无序。

注意，默认情况下，它只支持使用`int`作为键，其他类型是不合法的。

```cpp
// 数据插入, 复杂度为 logn
map.insert({key, value});
map[key] = value;
// 移除, 复杂度为 logn
map.erase(key)
// 搜索, 复杂度为 logn
map.find()
map[key]

map.count() // 返回匹配特定键的元素数量, 对数复杂度
map.contains()
map.equal_range()
map.lower_bound()
map.upper_bound()
```

### Set

```cpp
#include <set>
```

set 是一个关键字集合, 其中的关键字 不可重复, 其底层采用红黑树实现, 因此集合中的元素是 有序 的, 在 set 容器上进行的搜索, 插入和移除等操作都是**对数复杂度**的.

特有操作：

```cpp
lower_bound() // 返回指向首个不小于给定键的元素的迭代器
upper_bound() // 返回指向首个大于给定键的元素的迭代器
erase_if()
```

### Stack

```cpp
#include <stack>
stack<int> s;
s.push(data);
s.pop();
s.top();    // get value of top
s.empty()   // judge whether stack is empty
```

## Reference

- [StackOverflow - Where are the man pages for C++? [closed]](https://stackoverflow.com/questions/5293737/where-are-the-man-pages-for-c)
- [forever97](https://forever97.top/2020/10/21/Re0-2/)
- [百度百科 - apropos](https://baike.baidu.com/item/apropos/15852795)
