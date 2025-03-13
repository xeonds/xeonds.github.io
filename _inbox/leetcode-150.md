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

## 27.移除元素

>也就是将所有值等于k的元素上浮到数组末尾，并返回值非k的元素数量

双指针，尾指针指向最末非val元素不断前移；首指针后移，并在值为val时和尾指针交换

最后返回**尾指针+1**表示非val元素数量

```go
func removeElement(nums []int, val int) int {
    i, j := 0, len(nums)-1
    for j>=0 && nums[j] == val {
        j--
    }
    if j < 0 {
        return 0    // 没有非val的元素
    }
    // 此时的j一定不是val

    for i < j {
        if nums[i] == val {
            nums[i]=nums[j]
            nums[j]=val
            for j>= i && nums[j] == val {
                j--
            }
        }
        i++
    }
    return j+1
}
```

## 26.删除有序数组重复元素

> 1 2 2 3 3 -> 1 2 3 _ _ ，同时返回len(123)

双指针，一个指向排序后队列，一个正序遍历队列，当二者元素不同时排序后队列新增元素。

```go
func removeDuplicates(nums []int) int {
    i, j, l:= 0, 0, len(nums)
    for j<l {
        if nums[i]!=nums[j]{
            i++
            nums[i]=nums[j]
        }
        j++
    }
    return i+1
}
```

## 80.删除有序数组重复元素2

> 1 2 2 2 3 3 -> 1 2 2 3 3, 并返回len(1 2 2 3 3)=5

三指针法，i作为输出，j和k探测答案区间长度，进入新区间则按照长度输出答案到i处。最后循环外处理最后一个区间

```go
func removeDuplicates(nums []int) int {
    i, j, k, l, m:= 0,0,0,len(nums), 2
    for k<l{
        if nums[j]!= nums[k]{
            for range(min(k-j, m)){
                nums[i]=nums[j]
                i++
            }
            j=k
        }
        k++
    }
    for range(min(m,k-j)){
        nums[i]=nums[j]
        i++
    }
    return i
}

func min(a,b int)int{
    if a<b{return a}
    return b
}
```

