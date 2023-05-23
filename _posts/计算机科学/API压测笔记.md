---
title: API压测笔记
date: 2024-03-18 22:41:07
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
    - 分布式计算
    - Benchmark
    - 工程化实践
---

API的压力测试是业务上线前的重要环节，也是对系统性能的一个量化测量，对实际业务诸方面都有重要的参考价值。

这里主要说说API压测的方法和常用手段。

## 压测方法

- go benchmark

如果是golang后端，可以直接手写测试用例，然后使用go工具链自带的benchmark进行压测。

- ApacheBench

ab命令会创建多个并发访问线程，模拟多个访问者同时对某一URL地址进行访问。

安装`apache2-utils`即可在系统上使用`ab`命令。

作为演示，使用ab测试一个GET接口：

```bash
ab -n 2000 -c 1200  "http://127.0.0.1:9999/get_result?a=10&b=20"
```
- n: 测试轮次
- c: 客户端数量
- T: 内容类型
- p: 包含post参数的文件
- 引号是必须的

- wrk

一个C编写的API压测工具

```bash
wrk -t10 -c100 -d10s http://localhost:8080/api/users    # 使用10个线程，100并发数，测试持续10s
```

## 开测

我最后还是选了`wrk`做压测~~因为ab装不上~~

测试接口是`POST http://localhost:8080/api/calc/mul`，payload是一个2*n的json格式的二维数组。

测试指令：

```bash
wrk -t 20 -c 10000 -d 180s -s bench.lua --latency "http://localhost:8080/api/calc/mul"

## bench.lua
wrk.method = "POST"
wrk.body = "[[1,2,3,1],[4,5,7,8]]"
wrk.headers['Content-Type'] = "application/json"
```

测试结果如下：

```bash
xeonds@ark-station:~/code/vec-calculator-server$ make bench 
cd build && ./vec-calc-web-linux-amd64-1.0.0 & sleep 1 && \
wrk -t 20 -c 10000 -d 180s -s bench.lua --latency "http://localhost:8080/api/calc/mul"
Running 3m test @ http://localhost:8080/api/calc/mul
  20 threads and 10000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    61.27ms   62.15ms   1.46s    93.06%
    Req/Sec     9.74k     1.33k   22.11k    71.75%
  Latency Distribution
     50%   48.47ms
     75%   66.32ms
     90%   90.10ms
     99%  364.05ms
  34884275 requests in 3.00m, 4.35GB read
Requests/sec: 193693.29
Transfer/sec:     24.75MB
```

测试平台是`Intel Core i7-12700H`，可以看到并发在`1,0000`的时候，Gin的性能还是不错的，TPS保持在了19万的水准。

## 碎碎念

该说不该说呢，以前我认为语言就是由语法和编译器/解释器构成，但是Golang这样从语法上支持一个feature的行为让我疑惑：语言的标准库该不该算是语言特性的一部分？

`go`这个关键字作为一个大大的语法糖，似乎在打破语言的库和语言本身的分界线。我也无从知晓这一方向的尽头是什么。

## Reference

- [API性能测试指标以及压测方式 - 最难不过二叉树 - 知乎](https://zhuanlan.zhihu.com/p/609348456)
- [golang压测](https://golang.cx/go/golang%E5%8E%8B%E6%B5%8B.html)
- [How To Benchmark HTTP Latency with wrk on Ubuntu 14.04 - DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-benchmark-http-latency-with-wrk-on-ubuntu-14-04)
- [POST request with wrk? - StackOverflow](https://stackoverflow.com/questions/15261612/post-request-with-wrk)
- [Can I disable gin's stdout? - GitHub Issue](https://github.com/gin-gonic/gin/issues/267)
