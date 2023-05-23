---
title: Java并发编程
date: 2023.02.26 12:04:54
author: xeonds
toc: true
excerpt: qaq
---

## 并发任务

Runnable接口描述想运行的任务。

```java
public interface Runnable{
    void run();
}
```

run中的代码会在一个**线程**中运行。

Exeucator执行任务，选择在哪个线程上执行任务。

```java
Runnable task = ()->{ ... };
Executor exec = ...;
exec.execute(task);
```

它有不同的工厂方法供不同情况调用

```java
exec = Executors.newCachedThreadPool();
```

上面的是一个有很多短暂任务或者任务会消耗很多时间等待的优化型executor

```java
exec = Executors.newFixedThreadPool(nThreads);
```

这会产生一个数目固定的线程池。提交任务时，进行排队直到有可用线程。适用于计算密集型任务。可以用下面的代码获取可用处理器数目

```java
int processors = Runtime.getRuntime().availableProcessors();
```

如果想将任务化整为零，并在最后汇总结果，那用Callable

```java
public interface Callable<V> {
    V call() throws Exception;
}
```

要执行它，需要

```java
ExecutorService exec = Executors.newFixedThreadPool();
Callable<V> task = ...;
Future<V> result = exec.submit(task);
```

上面的Future表示未来可用的计算结果，有如下方法

```java
V get() throws InterruptedException, ExecutionException;
V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
boolean cancel(boolean mayInterruptIfRunning);  //未运行则取消，在运行则根据参数真假决定是否取消
boolean isCancelled();
boolean isDone();
```

需要在线程中定时检查中断请求来让线程可中断

```java
while(...){
    if(Thread.currentThread().isInterrupted()) return null;
    other code
}

return result;
```

可以用invokeAll获取所有子任务结果集合

```java
String word = ...;
Set<Path> paths = ...;
List<Callable<Long>> tasks = new ArrayList<>();
for(Path p : paths) tasks.add(
    ()->{return p中word出现次数});
List<Future<Long>> results = executor.invokeAll(tasks);
long total = 0;
for(Future<Long> result : results) total += result.get();
```

还有类似的invokeAny方法。它只要一个子任务无异常返回就返回，并且取消其他任务。这可以用来查找是否存在目标。

## 线程安全

主程序中的变量对于线程不可见，这和缓存，指令重排序有关。

在这种问题中，只要给变量加上`volatile`前缀修饰就能让它对于其他任务都可见。

## 线程

也可以使用原生的Thread管理任务执行。不过通常还是使用Executor。

```java
Runnable task = ()->{...};
Thread thread = new Thread(task);
thread.start();
```

使用sleep让当前线程休眠一段时间，给其他线程执行机会

```java
Runnable task = ()->{
    ...
    Thread.sleep(millis);
}
```

如果想等待线程完成，可以用join

```java
thredad.join(millis): //millis等待时限
```