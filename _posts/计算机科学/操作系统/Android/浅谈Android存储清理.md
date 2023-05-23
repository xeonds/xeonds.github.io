---
title: 浅谈Android存储清理
tags:
  - 存储清理
excerpt: 建议再买一个（直球
toc: true
author: xeonds
date: '2021.05.18 00:36:40'
categories:
  - 计算机科学
  - 操作系统
  - Android
---
前些天有个同学让我帮忙清理下她手机。二话不说，打开文件管理就是干。我一看，好家伙。那个根目录啊，不可描述一般的乱（反正我翻了半天才到底）。

现在大概总结下相关的基本常识。

```
/sdcard
├── Android
│   ├── data
│   ├── media
│   ├── obb
│   └── obj
├── BaiduMapSDKNew
│   └── crash
├── DCIM
│   ├── Camera
│   └── Screenshots
├── Download
│   └── woodbox
├── MIUI
│   ├── Gallery
│   ├── MiDrop
│   ├── debug_log
│   └── music
├── Movies
├── PerfectPiano
│   └── Soundbank
├── Pictures
│   ├── CoolMarket
│   ├── WeiXin
│   └── woodbox
├── amap
│   └── openamaplocationsdk
├── backups
├── baidu
├── bluetooth
├── browser
│   ├── MediaCache
│   └── dumps
├── com.miui.voiceassist
│   └── audio
├── documents
│   └── 1994036591
├── downloaded_rom
├── iFlyIME
│   ├── Download
│   ├── imagecache
│   ├── imageloadercache
│   └── puser
├── miad
│   └── cache
├── netease
│   └── cloudmusic
├── tencent
│   ├── MobileQQ
│   ├── QQLite
│   ├── QQ_Favorite
│   ├── QQ_Images
│   ├── QQfile_recv
│   ├── ams
│   ├── msflogs
│   ├── mta
│   ├── tbs
│   └── wtlogin
└── tv.danmaku.bili
    └── source
```

#### 第一重地狱：/sdcard下的一般目录

这就是我手机的根目录。可以很清楚地看到，根目录下的文件夹大致可以分成以下两类：

* 程序公用目录
例如/DCIM，/Download，/Music，/Pictures，/bluetooth，/Movies等等（这里比较多，就不全列出来了）。这类目录大部分是不能随意删除的。他们是各个程序的公用目录和程序的汽油，也就是说，它们里面会有各个程序保存的文件。  

比如打开/Pictures，你就会看到里面有系统的屏幕截图，~~基安~~酷安之类软件保存的图片之类的。  

再比如说/Download，这是系统创建的下载目录，浏览器之类的都会把文件下载到这里。  
/bluetooth顾名思义，通过蓝牙传输的文件保存的目录。如果有用蓝牙传过什么重要的文件，那么最好不要删。  

/DCIM是各个程序公用的相册目录，一般微信，QQ之类的都会在这里面读取照片（所以说下次微信QQ找不到图片的话就把图片扔到这里面随便哪个文件夹就好了×）。最重要的是，系统相机拍摄的图片、录制的视频也全都在这里面。所以这个目录千万千万别手滑删掉。要不然……后果会很惨烈（当然如果你不关心你的照片就另说了×）。  

其他文件夹（比如/Music，/Movies，/documents之类的）也都顾名思义，是存放相应类型文件的专用共享目录。不过因为国内畸形的安卓生态，它们大多都没有发挥应有的功能。  

* /Android目录  

这是系统最重要的目录，没有之一。可以说基本所有软件的数据都在它里面保存着，接下来我们就要着重分析下这个目录。  

``
Android
├── data
├── media
├── obb
└── obj

这四个目录中，属/data最重要。它是系统分配给每个软件的私有目录。软件可以把自己的各种数据保存在里面。比如猿辅导，就会把离线的网课保存在里面。再比如说，最新版的QQ和微信也都把自己的数据（接收的文件，保存的图片之类的）存储在里面了。里面的文件夹和软件的包名是一一对应的。（不知道这是个啥？百度下吧）。所以一般这里也不怎么经常清理。  

其他几个目录的话，obb是存储程序数据包的。比如说FL Mobile，还有MC:Story mode之类的。一般来说，这个目录里的文件夹也是和包名一致的。另外几个我还没怎么了解过，后面了解了再说说吧。

\*好了，还有什么人要提问\*(bushi

那么就是剩下的目录了。从这里开始，就是一些非标准但是占内存比较大的目录了。

#### 第二重地狱：/sdcard/tencent目录  

顾名思义，这个目录是腾讯系软件的主目录。  

这里得先提前说明一下，按照规范来说，根目录下是不应该允许程序写入文件的。  

但是隔着这么高的墙，谷歌哪里管得上啊（摊手

这里要注意一下，现在其实是有两个目录的。一个在`Android/data/`中，另一个就是下面这个了。

```
/sdcard/Tencent/
├── MobileQQ
├── QQLite
├── QQ_Favorite  //QQ收藏的表情
├── QQ_Images  //QQ保存的图片
├── QQfile_recv  //QQ接收的文件
├── ams
├── micromsg  //微信目录
├── msflogs
├── mta
├── tbs   //x5浏览器内核？
└── wtlogin
```

看起来挺乱的对吧？我也这么觉得。大概分析下构成，占地方大的主要是MobileQQ，里面包含了缓存和聊天记录等。还有就是micromsg，包含了微信接收的文件和聊天记录等。
