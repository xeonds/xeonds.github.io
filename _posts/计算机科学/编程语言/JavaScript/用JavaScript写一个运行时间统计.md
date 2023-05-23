---
title: 用JavaScript写一个运行时间统计
tags:
  - JavaScript
  - 前端
excerpt: 以前：js（）都不用  现在：js真香（
toc: true
author: xeonds
date: '2021.10.27 23:00:46'
categories:
  - 计算机科学
  - 编程语言
  - JavaScript
---
直接上代码。

js部分：

```javascript
/* filename:run_time.js */

function time_calc(Y, M, D, h, m, s) {
    var seconds = 1000;
    var minutes = seconds * 60;
    var hours = minutes * 60;
    var days = hours * 24;
    var years = days * 365;

    var today = new Date();
    var time = Date.UTC(today.getFullYear(), today.getMonth() + 1, today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds()) - Date.UTC(Y, M, D, h, m, s);
    var year = Math.floor(time / years)
    var day = Math.floor((time / days) - year * 365);
    var hour = Math.floor((time - (year * 365 + day) * days) / hours);
    var minute = Math.floor((time - (year * 365 + day) * days - hour * hours) / minutes);
    var second = Math.floor((time - (year * 365 + day) * days - hour * hours - minute * minutes) / seconds);

    return { "year": year, "day": day, "hour": hour, "minute": minute, "second": second };
}

function site_run_time(Y,M,D,h,m,s)
{
    window.setInterval(function() {
        var time = time_calc(Y,M,D,h,m,s);

        document.getElementById('time_year').innerText = time.year;
        document.getElementById('time_day').innerText = time.day;
        document.getElementById('time_hour').innerText = time.hour;
        document.getElementById('time_minute').innerText = time.minute;
        document.getElementById('time_second').innerText = time.second;
    }, 1000);
}
```

HTML部分：

```html
<!-- filename:index.html -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo</title>
</head>
<body>
    <div id="footer">
        <p>系统已稳定运行：
            <span id="time_year"></span>年
            <span id="time_day"></span>日
            <span id="time_hour"></span>时
            <span id="time_minute"></span>分
            <span id="time_second"></span>秒
        </p>
    </div>
    <script src="run_time.js"></script>
    <script>
        site_run_time(2021,1,1,0,0,0);
    </script>
</body>
</html>
```

### 解析

主要利用`window.setInterval(func_name,time)`来实现反复执行。时间计算利用UNIX时间戳完成。

这里说一下UNIX时间戳：它表示自1970.1.1 00:00:00开始，过了多少**毫秒**。
