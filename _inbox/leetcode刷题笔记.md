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


315. 计算右侧小于当前元素的个数

>给你一个整数数组 nums ，按要求返回一个新数组 counts 。数组 counts 有该性质： counts[i] 的值是  nums[i] 右侧小于 nums[i] 的元素的数量。

```cpp
class Solution {
public:
    vector<int> countSmaller(vector<int>& nums) {
        map<int, int> table;
        vector<int> res;
        for(int i=nums.length(); i>=0; i--){
            
        }
    }
};
```

335. 路径交叉

>二维坐标系，顺序上左下右，每次最少走1单位，给定路径，判断路径是否相交

感觉是个能分情况讨论的简单题

```golang
package main

func isOver(direction []int) bool {
        calcPos := func(x, y int) int {
                switch {
                case x == 0 && y == 0: return 0
                case x > 0 && y > 0: return 1
                case x == 0 && y > 0: return 2
                case x < 0 && y > 0: return 3
                case x < 0 && y == 0: return 4
                case x < 0 && y < 0: return 5
                case x == 0 && y < 0: return 6
                case x > 0 && y < 0: return 7
                case x > 0 && y == 0: return 8
                }
        return 0
        }
        x, y, pos, pcurr := 0, 0, 0, 0
        wayX, wayY := []int{0, -1, 0, 1}, []int{1, 0, -1, 0}
        for i, v := range direction {
                x, y = x+wayX[i]*v, wayY[i]*v
                pcurr = calcPos(x, y)
        // TODO: 分析情况转移序列，分析是否超出范围
                if pcurr == pos || pos == 0  {
                        return false
                }
                pos = pcurr
        }
        return false
}

func isOver(distance []int) bool {


```
