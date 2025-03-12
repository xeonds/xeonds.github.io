---
title: leetcode-150
date: 2025-03-12 22:53:07
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

## [88. 合并两个有序数组 - 力扣（LeetCode）](https://leetcode.cn/problems/merge-sorted-array/?envType=study-plan-v2&envId=top-interview-150)

>给你两个按 **非递减顺序** 排列的整数数组 `nums1` 和 `nums2`，另有两个整数 `m` 和 `n` ，分别表示 `nums1` 和 `nums2` 中的元素数目。
>请你 **合并** `nums2` 到 `nums1` 中，使合并后的数组同样按 **非递减顺序** 排列。
> **注意：**最终，合并后数组不应由函数返回，而是存储在数组 `nums1` 中。为了应对这种情况，`nums1` 的初始长度为 `m + n`，其中前 `m` 个元素表示应合并的元素，后 `n` 个元素为 `0` ，应忽略。`nums2` 的长度为 `n` 。

如果是链表那好说很多，一个新头节点然后反复二选一**从小到大**排就行。但是这里是数组而且第一个数组有容纳第二个数组的额外空间。那就**从大到小**反向排列。

```go
func merge(nums1 []int, m int, nums2 []int, n int) {
    im, in,i:=m-1, n-1, m+n-1
    for in>=0{
        if im>=0&&nums1[im]>nums2[in]{
            nums1[i]=nums1[im]
            im--
        }else{
            nums1[i]=nums2[in]
            in--
        }
        i--
    }
}
```

