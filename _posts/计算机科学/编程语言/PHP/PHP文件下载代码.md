---
title: PHP文件下载代码
tags:
  - PHP
excerpt: 写储物间的备份功能时候新学习的部分。记录一下
toc: true
author: xeonds
date: '2021.07.18 22:56:13'
categories:
  - 计算机科学
  - 编程语言
  - PHP
---

## 其一

```
<?php
 
$filename = $_GET['filename'];
 
// 修改这一行设置你的文件下载目录
$download_path = "ficheros/";
 
// 不能下载上一层目录的文件
if(eregi("\.\.", $filename)) die("抱歉，你不能下载该文件！");
$file = str_replace("..", "", $filename);
 
// 包含 .ht 的文件不能下载
if(eregi("\.ht.+", $filename)) die("抱歉，你不能下载该文件！");
 
// 创建文件下载路径
$file = "$download_path$file";
 
// 判断文件是否存在
if(!file_exists($file)) die("抱歉，文件不存在！");
 
//  文件类型，作为头部发送给浏览器
$type = filetype($file);
 
// 获取时间和日期
$today = date("F j, Y, g:i a");
$time = time();
 
// 发送文件头部
header("Content-type: $type");
header("Content-Disposition: attachment;filename=$filename");
header("Content-Transfer-Encoding: binary");
header('Pragma: no-cache');
header('Expires: 0');
// 发送文件内容
set_time_limit(0);
readfile($file);
 
?>
```

## 其二

* 其实这算html常规方式（

```
<button>
    <a href = "http://localhost/down.zip">
    下载文件
</button>
```

## 其三

传递参数：

```html
<button>
    <a href = "http://localhost?f='down'">
    下载文件
</button>
```

查找文件并挑战到下载链接：

```php
<?php

$down = $_GET['f'];   //获取文件参数
$filename = $down.'.zip'; //获取文件名称
$dir ="down/";  //相对于网站根目录的下载目录路径
$down_host = $_SERVER['HTTP_HOST'].'/'; //当前域名


//判断如果文件存在,则跳转到下载路径
if(file_exists(__DIR__.'/'.$dir.$filename)){
    header('location:http://'.$down_host.$dir.$filename);
}else{
    header('HTTP/1.1 404 Not Found');
}
```
