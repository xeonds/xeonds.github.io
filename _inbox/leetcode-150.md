---
title: leetcode-150
date: 2025-03-12 22:53:07
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

## 88.合并两个有序数组

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

不过这题我看还有用两个指针+一个长度变量解决的，大致上差不多

## 189.轮转数组

>给定一个整数数组 nums，将数组中的元素向右轮转 k 个位置，其中 k 是非负数。

假设$k < len(nums)$，则最简单的方法即使用额外k的空间，将末尾k个元素存入其中，其余元素依次后移k位置，再将额外空间元素依次映射到$0 \to k-1$的空间中。

但存在O(1)方法，只需要一个额外空间：从arr[0]开始，依次将arr[i]移动到arr[i+k]处，直到遍历完所有元素。

但容易发现，如果$len%k=0$，则按k步长只会循环遍历len/k个元素。

此时需要分批处理，按照$0 \to k-1$分k批处理，每批遍历len/k的步数，步长为k。

> 事实上这样也有漏元素的问题。遍历结束按到达原位计算，则遍历元素数量是二者最小公倍数/k。例如6个元素，k=4，则会发现一遍会遍历12/4=3个元素。因此遍历一轮后需要从另一个起点开始遍历，共需要的圈数是6/3=2圈。

但是这样不太好想，可以从问题出发：有没有其他方原地将最后k个元素移动到开头？忽略顺序的话，数组作中心对称是一个可行的，易于实现的原地操作。

但是其副作用是：相比目标，**开头k个元素是逆序，之后n-k个元素也是逆序**。那么再逆序一下就好了。空间复杂度也是O(1)，时间复杂度是O(2n)=O(n)

```go
func flip(nums []int, k int){
    k%=len(nums)
    reverse(nums)
    reverse(nums[:k])
    reverse(nums[k:])
}

func reverse(nums []int){
    n := len(nums)
    for i:=0; i<n/2; i++{
        nums[i], nums[n-i-1] = nums[n-i-1], nums[i]
    }
}
```

## [121. 买卖股票的最佳时机 - 力扣（LeetCode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/description/?envType=study-plan-v2&envId=top-interview-150)

> 给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。
> 
> 你只能选择 某一天 买入这只股票，并选择在 未来的某一个不同的日子 卖出该股票。设计一个算法来计算你所能获取的最大利润。
> 
> 返回你可以从这笔交易中获取的最大利润。如果你不能获取任何利润，返回 0 。

使用前缀和解决。新建数组arr，定义为arr[i]:=max(arr[i], arr[i+1])，则该数组每个位置指示当前位置及右侧范围内最大元素的值。

从而，计算最大差价，只须计算`in.map((index, item)=>arr[i]-item).max()`即可。

```go
func maxProfit(prices []int) int {
    n:=len(prices)
    maxR, max := make([]int, n), prices[n-1]
    for i := n-1; i>=0;i--{
        max=Max(max, prices[i])
        maxR[i]=max
    }
    res := 0
    for i, price:=range prices {
        res=Max(res, maxR[i]-price)
    }
    return res
}

func Max(a,b int)int{
    if a>b {
        return a
    }
    return b
}
```

