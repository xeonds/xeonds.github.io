---
title: 一个奇怪的Base64浏览器记事本
date: 2023-06-10 20:31:17
author: xeonds
toc: true
excerpt: (*/ω＼*)刷V站给我看的虎躯一震。。
---

>source: [开源一个无后端也无前端彻底无服务的网页版记事本 - V2EX](https://www.v2ex.com/t/944717#reply144)

## 本体

```
data:text/html;base64,PGh0bWwgY29udGVudGVkaXRhYmxlPmVkaXQgbWU8L2h0bWw+
```
没了。对，没了。直接复制粘贴到浏览器（Chromium系的）地址栏里边打开，然后随便写什么都行。

写完了甚至可以直接`Ctrl+S`保存网页，再打开甚至 还  能  编  辑 。

大 受 震 撼 . j p g

## 解析

整体而言，这是个利用浏览器解码base64能力实现的编辑器，程序本体就是逗号后边的部分。解码能够得到：

```html
<html contenteditable>edit me</html>
```

所以同理还可以玩更多花活（。

首先可以升级一下：

小加强版：

```html
data:text/html,<body contenteditable style=line-height:1.5;margin-left:20%;margin-right:20%;font-family:system-ui>
```

再加强：支持将编辑内容一键复制成 url 分享给其他人  

```html
data:text/html;base64,PGh0bWw+PGhlYWQ+CiAgICA8bWV0YSBjaGFyc2V0PSJVVEYtOCI+CiAgICA8bWV0YSBodHRwLWVxdWl2PSJYLVVBLUNvbXBhdGlibGUiIGNvbnRlbnQ9IklFPWVkZ2UiPgogICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwgaW5pdGlhbC1zY2FsZT0xLjAiPgogICAgPHRpdGxlPkRvY3VtZW50PC90aXRsZT4KICA8L2hlYWQ+CiAgPGJvZHk+CiAgICA8YnV0dG9uIGlkPSJidG4iPuWwhue8lui+keWGheWuueWkjeWItuS4ukRhdGFVcmw8L2J1dHRvbj4KICAgIDxkaXYgaWQ9ImVkaXRvci1hcmVhIiBjb250ZW50ZWRpdGFibGU9IiI+PC9kaXY+CiAgCiAgPHN0eWxlPgogICAgI2VkaXRvci1hcmVhIHsKICAgICAgd2lkdGg6IDEwMCU7CiAgICAgIGhlaWdodDogY2FsYygxMDB2aCAtIDgwcHgpOwogICAgICBtYXJnaW4tdG9wOiAyMHB4OwogICAgICBvdmVyZmxvdzogc2Nyb2xsOwogICAgICBvdXRsaW5lOiAxcHggc29saWQgZ3JheTsKICAgIH0KICA8L3N0eWxlPgogIDxzY3JpcHQ+CiAgICBmdW5jdGlvbiB1dGY4X3RvX2I2NChzdHIpIHsKICAgICAgcmV0dXJuIHdpbmRvdy5idG9hKHVuZXNjYXBlKGVuY29kZVVSSUNvbXBvbmVudChzdHIpKSk7CiAgICB9CgogICAgLy8gZnVuY3Rpb24gYjY0X3RvX3V0Zjgoc3RyKSB7CiAgICAvLyAgIHJldHVybiBkZWNvZGVVUklDb21wb25lbnQoZXNjYXBlKHdpbmRvdy5hdG9iKHN0cikpKTsKICAgIC8vIH0KCiAgICBjb25zdCBidG4gPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCIjYnRuIik7CiAgICBidG4uYWRkRXZlbnRMaXN0ZW5lcigiY2xpY2siLCAoKSA9PiB7CiAgICAgIGNvbnN0IGh0bWxDb250ZW50ID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcigiaHRtbCIpOwogICAgICBjb25zb2xlLmxvZyhodG1sQ29udGVudC5pbm5lckhUTUwpOwogICAgICBjb25zdCBkYXRhVXJsID0gIjxodG1sPiIgKyBodG1sQ29udGVudC5pbm5lckhUTUwgKyAiPC9odG1sPiI7CiAgICAgIGNvbnN0IGJhc2U2NCA9IHV0ZjhfdG9fYjY0KGRhdGFVcmwpOwogICAgICAvLyBjb25zb2xlLmxvZyhiYXNlNjQpOwoKICAgICAgY29uc3QgaW5wdXRWYWx1ZSA9IGBkYXRhOnRleHQvaHRtbDtiYXNlNjQsJHtiYXNlNjR9YAogICAgICBjb25zdCBpbnB1dCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoImlucHV0Iik7CiAgICAgIGlucHV0LnNldEF0dHJpYnV0ZSgicmVhZG9ubHkiLCAicmVhZG9ubHkiKTsKICAgICAgaW5wdXQuc2V0QXR0cmlidXRlKCJ2YWx1ZSIsIGlucHV0VmFsdWUpOwogICAgICBkb2N1bWVudC5ib2R5LmFwcGVuZENoaWxkKGlucHV0KTsKICAgICAgaW5wdXQuc2V0U2VsZWN0aW9uUmFuZ2UoMCwgOTk5OSk7CiAgICAgIGlucHV0LnNlbGVjdCgpOwogICAgICBkb2N1bWVudC5leGVjQ29tbWFuZCgiY29weSIpOwogICAgICBkb2N1bWVudC5ib2R5LnJlbW92ZUNoaWxkKGlucHV0KTsKICAgIH0pOwogIDwvc2NyaXB0PgoKPC9ib2R5PjwvaHRtbD4=
```

再加强：VSCode版（不过这个因为用了外置js得联网）：

```html
data:text/html;charset=utf-8,<!DOCTYPE html> <html> <head> <meta http-equiv="Content-Type" content="text/html;charset=utf-8" /> </head> <body style="margin: 0; height: 100vh"> <div id="container" style="width: 100%; height: 100%"></div> <script type="text/javascript" src="[https://unpkg.com/monaco-editor@latest/min/vs/loader.js](https://unpkg.com/monaco-editor@latest/min/vs/loader.js)"></script> <script> require.config({ paths: { vs: "[https://unpkg.com/monaco-editor@latest/min/vs](https://unpkg.com/monaco-editor@latest/min/vs)" } }); require(["vs/editor/editor.main"], function () { monaco.editor.create(document.getElementById("container"), { language: "json", theme: "vs-dark", }); }); </script> </body> </html>
```

## 花活1：升级版前端IDE

```html
data:text/html,<body oninput="i.srcdoc=h.value+'<style>'+c.value+'</style><script>'+j.value+'</script>'"><style>textarea,iframe{width:100%;height:50%}body{margin:0}textarea{width:33.33%;font-size:18}</style><textarea placeholder=HTML id=h></textarea><textarea placeholder=CSS id=c></textarea><textarea placeholder=JS id=j></textarea><iframe id=i>
```

加强版：

```html
data:text/html,<body oninput="i.srcdoc=h.value+'<style>'+c.value+'</style><script>'+j.value+'</script>'"><style> textarea, iframe { width: 100%; height: 50%; background-color: rgb(245, 245, 245); } body { margin: 0; background-color: rgb(245, 245, 245); } textarea, iframe { width: 33.3%; height: 100%; flex: 1; font-size: 18; resize: none; } textarea:focus { background-color: white; } .menu { text-align: center; overflow: hidden; width: 100%; padding: 5px 0; } .panels { display: flex; justify-content: center; height: calc(100% - 40px); }</style><script> function switchDisplay(id) { var dom = document.getElementById(id); if (!dom) return; if (dom.style.display !== '') { dom.style.display = ''; return; } if (dom.style.display === '') { dom.style.display = 'none'; return; } }</script><div class="menu"><button onclick="switchDisplay('h')">HTML</button><button onclick="switchDisplay('c')">CSS</button><button onclick="switchDisplay('j')">JavaScript</button><button onclick="switchDisplay('i')">Output</button></div><div class="panels"><textarea placeholder=HTML id=h></textarea><textarea placeholder=CSS id=c></textarea><textarea placeholder=JS id=j></textarea><iframe id=i></div>
```

评价：好活。

## 花活2：一键清理浏览器垃圾  

>并不（
```html
data:text/html;charset=utf-8,<script>while(1){Math.random()*Math.random()/Math.random()}alert('清理完成');</script>
```

## 花活3：视频播放器  
 
```html
data:text/html;base64,PCFET0NUWVBFIGh0bWw+DQo8aW5wdXQgdHlwZT0iZmlsZSIgaWQ9ImlucHV0IiBhY2NlcHQ9InZpZGVvLyoiPg0KPGJyPg0KPHZpZGVvIHNyYz0iIiBpZD0idmlkZW8iIGNvbnRyb2xzIGF1dG9wbGF5PjwvdmlkZW8+DQo8c2NyaXB0Pg0KICBpbnB1dC5vbmNoYW5nZSA9ICgpID0+IHsNCiAgICBjb25zdCBmaWxlID0gaW5wdXQuZmlsZXM/LlswXTsNCiAgICBpZiAoZmlsZSkgew0KICAgICAgdmlkZW8uc3JjID0gVVJMLmNyZWF0ZU9iamVjdFVSTChmaWxlKTsNCiAgICB9DQogIH07DQo8L3NjcmlwdD4=
```

## 花活4：画板  
  
```html
data:text/html;base64,PGNhbnZhcyBpZD12PjxzY3JpcHQ+ZD1kb2N1bWVudCxkLmJvZHkuc3R5bGUubWFyZ2luPTAsUD0ib25wb2ludGVyIixjPXYuZ2V0Q29udGV4dGAyZGAsdi53aWR0aD1pbm5lcldpZHRoLHYuaGVpZ2h0PWlubmVySGVpZ2h0LGMubGluZVdpZHRoPTIsZj0wLGRbUCsiZG93biJdPWU9PntmPWUucG9pbnRlcklkKzE7ZS5wcmV2ZW50RGVmYXVsdCgpO2MuYmVnaW5QYXRoKCk7Yy5tb3ZlVG8oZS54LGUueSl9O2RbUCsibW92ZSJdPWU9PntmPT1lLnBvaW50ZXJJZCsxJiZjLmxpbmVUbyhlLngsZS55KTtjLnN0cm9rZSgpfSxkW1ArInVwIl09Xz0+Zj0wPC9zY3JpcHQ+PC9jYW52YXM+
```

## 花活：一键存档网页

这个注意，前缀`javascript:`是不会自动粘贴上的（由于浏览器安全策略的原因），必须手动输入前缀才能运行。

```html
javascript:location.href="https://web.archive.org/save/"+location.href;
```

>以及之前的URL因为Obsidian的原因，粘贴的时候错误格式化了