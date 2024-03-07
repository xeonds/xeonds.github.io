---
title: leetcode刷题笔记
date: 2024-03-04 23:27:10
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
    - 算法
---

232. 双栈模拟队列

>要求支持`push, pop, peek, empty`四个操作

```cpp
class MyQueue {
public:
    deque<int> in, out;
    MyQueue() {}

    void push(int x) {
        unshift();
        in.push_back(x);
    }

    int pop() {
        shift();
        int res = out.back();
        out.pop_back();
        return res;
    }

    void shift() {
        for (int tmp; !in.empty(); in.pop_back())
            out.push_back(in.back());
    }

    void unshift() {
        for (int tmp; !out.empty(); out.pop_back())
            in.push_back(out.back());
    }

    int peek() {
        shift();
        return out.back();
    }

    bool empty() { return in.empty() && out.empty(); }
};
```

203. 移除链表元素

```cpp
class Solution {
public:
    ListNode* removeElements(ListNode* head, int val) {
        ListNode *res=head;
        while(res && res->val==val) res = res->next;
        for(ListNode *elem = res; elem && elem->next;) {
            if(elem->next->val == val) elem->next = elem->next->next;
            else elem=elem->next;
        }
        return res;
    }
};
```


315. 
