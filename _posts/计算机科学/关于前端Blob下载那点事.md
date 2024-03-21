---
title: 关于前端Blob下载那点事
date: 2023-07-11 22:16:38
author: xeonds
toc: true
excerpt: 一个bug折腾了两三天，可算弄好了。成功成功，继续摸鱼(╹ڡ╹ )
tags:
  - HTTP
  - 前端
  - Blob
---

## 背景

最近做一个项目，后端返回一个Excel表格给前端下载，前端应该使用Blob将文件保存并下载下来。可是前端这里试了半天，数据大小没问题，就是一直下不下来。后来解决了好几个问题之后才成功解决了这个下载问题。

## 问题1-请求头

查找相关资料后，发现似乎错误的请求头是引发这个问题的一个原因。随后就改了请求部分的代码，加上了请求头的配置：

```js
      serviceAxios({
        method: 'POST',
        url: 'xxx',
        headers: {
          'Content-Type': 'application/vnd.ms-excel',
          Token: localStorage.getItem('token')
        },
        data: this.form_data
      })
        .then((res) => {
          this.isShow = false
          download(
            res,
            'application/vnd.ms-excel',
            this.form_data.name
          )
          ElMessage.success('下载成功')
        })
        .catch((err) => {
          ElMessage.error('下载失败：' + err)
        })
    }
```

但是这样不仅下载的内容打不开，而且下载本身还报错了：**HTTP 415：Unsupported Media Type**。它的简介如下：

>**`415 Unsupported Media Type`** 是一种 HTTP 协议的错误状态代码，表示服务器由于不支持其有效载荷的格式，从而拒绝接受客户端的请求。
>
>格式问题的出现有可能源于客户端在 [`Content-Type`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Type) 或 [`Content-Encoding`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Encoding) 首部中指定的格式，也可能源于直接对负载数据进行检测的结果。

因此很明显，我应该是设置错了HTTP请求标头。于是查阅了HTTP请求标头的几个字段，发现我应该是搞反了`Content-Type`和`Accept`的意思。

- **Content-Type**：自己发送给对方的内容的MIME类型
- **Accept**：自己能接受的内容的MIME类型

常见的MIME类型（ **Multipurpose Internet Mail Extensions，媒体类型**）如下：

|扩展名|文档类型|MIME 类型|
|---|---|---|
|`.aac`|AAC audio|`audio/aac`|
|`.abw`|[AbiWord](https://en.wikipedia.org/wiki/AbiWord) document|`application/x-abiword`|
|`.arc`|Archive document (multiple files embedded)|`application/x-freearc`|
|`.avi`|AVI: Audio Video Interleave|`video/x-msvideo`|
|`.azw`|Amazon Kindle eBook format|`application/vnd.amazon.ebook`|
|`.bin`|Any kind of binary data|`application/octet-stream`|
|`.bmp`|Windows OS/2 Bitmap Graphics|`image/bmp`|
|`.bz`|BZip archive|`application/x-bzip`|
|`.bz2`|BZip2 archive|`application/x-bzip2`|
|`.csh`|C-Shell script|`application/x-csh`|
|`.css`|Cascading Style Sheets (CSS)|`text/css`|
|`.csv`|Comma-separated values (CSV)|`text/csv`|
|`.doc`|Microsoft Word|`application/msword`|
|`.docx`|Microsoft Word (OpenXML)|`application/vnd.openxmlformats-officedocument.wordprocessingml.document`|
|`.eot`|MS Embedded OpenType fonts|`application/vnd.ms-fontobject`|
|`.epub`|Electronic publication (EPUB)|`application/epub+zip`|
|`.gif`|Graphics Interchange Format (GIF)|`image/gif`|
|`.htm .html`|HyperText Markup Language (HTML)|`text/html`|
|`.ico`|Icon format|`image/vnd.microsoft.icon`|
|`.ics`|iCalendar format|`text/calendar`|
|`.jar`|Java Archive (JAR)|`application/java-archive`|
|`.jpeg` `.jpg`|JPEG images|`image/jpeg`|
|`.js`|JavaScript|`text/javascript`|
|`.json`|JSON format|`application/json`|
|`.jsonld`|JSON-LD format|`application/ld+json`|
|`.mid` `.midi`|Musical Instrument Digital Interface (MIDI)|`audio/midi` `audio/x-midi`|
|`.mjs`|JavaScript module|`text/javascript`|
|`.mp3`|MP3 audio|`audio/mpeg`|
|`.mpeg`|MPEG Video|`video/mpeg`|
|`.mpkg`|Apple Installer Package|`application/vnd.apple.installer+xml`|
|`.odp`|OpenDocument presentation document|`application/vnd.oasis.opendocument.presentation`|
|`.ods`|OpenDocument spreadsheet document|`application/vnd.oasis.opendocument.spreadsheet`|
|`.odt`|OpenDocument text document|`application/vnd.oasis.opendocument.text`|
|`.oga`|OGG audio|`audio/ogg`|
|`.ogv`|OGG video|`video/ogg`|
|`.ogx`|OGG|`application/ogg`|
|`.otf`|OpenType font|`font/otf`|
|`.png`|Portable Network Graphics|`image/png`|
|`.pdf`|Adobe [Portable Document Format](https://acrobat.adobe.com/us/en/why-adobe/about-adobe-pdf.html) (PDF)|`application/pdf`|
|`.ppt`|Microsoft PowerPoint|`application/vnd.ms-powerpoint`|
|`.pptx`|Microsoft PowerPoint (OpenXML)|`application/vnd.openxmlformats-officedocument.presentationml.presentation`|
|`.rar`|RAR archive|`application/x-rar-compressed`|
|`.rtf`|Rich Text Format (RTF)|`application/rtf`|
|`.sh`|Bourne shell script|`application/x-sh`|
|`.svg`|Scalable Vector Graphics (SVG)|`image/svg+xml`|
|`.swf`|[Small web format](https://en.wikipedia.org/wiki/SWF) (SWF) or Adobe Flash document|`application/x-shockwave-flash`|
|`.tar`|Tape Archive (TAR)|`application/x-tar`|
|`.tif .tiff`|Tagged Image File Format (TIFF)|`image/tiff`|
|`.ttf`|TrueType Font|`font/ttf`|
|`.txt`|Text, (generally ASCII or ISO 8859-_n_)|`text/plain`|
|`.vsd`|Microsoft Visio|`application/vnd.visio`|
|`.wav`|Waveform Audio Format|`audio/wav`|
|`.weba`|WEBM audio|`audio/webm`|
|`.webm`|WEBM video|`video/webm`|
|`.webp`|WEBP image|`image/webp`|
|`.woff`|Web Open Font Format (WOFF)|`font/woff`|
|`.woff2`|Web Open Font Format (WOFF)|`font/woff2`|
|`.xhtml`|XHTML|`application/xhtml+xml`|
|`.xls`|Microsoft Excel|`application/vnd.ms-excel`|
|`.xlsx`|Microsoft Excel (OpenXML)|`application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`|
|`.xml`|`XML`|`application/xml` 代码对普通用户来说不可读 ([RFC 3023](https://tools.ietf.org/html/rfc3023#section-3), section 3) `text/xml` 代码对普通用户来说可读 ([RFC 3023](https://tools.ietf.org/html/rfc3023#section-3), section 3)|
|`.xul`|XUL|`application/vnd.mozilla.xul+xml`|
|`.zip`|ZIP archive|`application/zip`|
|`.3gp`|[3GPP](https://en.wikipedia.org/wiki/3GP_and_3G2) audio/video container|`video/3gpp` `audio/3gpp`（若不含视频）|
|`.3g2`|[3GPP2](https://en.wikipedia.org/wiki/3GP_and_3G2) audio/video container|`video/3gpp2` `audio/3gpp2`（若不含视频）|
|`.7z`|[7-zip](https://en.wikipedia.org/wiki/7-Zip) archive|`application/x-7z-compressed`|

上面的MIME类型就是Content-Type和Accept两个字段的内容。因此，我们应该将请求头改为如下的形式：

```js
headers: {
  Accept: 'application/vnd.ms-excel',
  'Content-Type': 'application/json',
  Token: localStorage.getItem('token')
},
```

然后还是出现HTTP 415错误，不过是后端返回的数据的请求头。让后端排查了下，发现是Spring的代理把请求头改成`application/json`了，所以前端这才会出现415的错误。

但是，还有一个小问题没解决，所以下载还是用不了。

## 问题2-Blob

改了两边的请求头并确定都没问题后，发现虽然能正常下载了，但是下载的内容Execl还是不能打开。但是最奇怪的是，APIfox下载的Excel是可以打开的。遂对比了下APIfox和我的代码下载下来的Excel文件，发现我的好像大了一点。

于是在搜索后，又给axios加上了`responseType: 'blob'`的参数，并且给生成Blob的地方也加上了`application/vnd.ms-execl`的参数。再次尝试时，下载已经能正常工作了。

于是我猜测，可能是下载时没有将后端返回的数据转换成Blob数据而直接存入Blob对象，引发了数据错位的问题，导致文件大了一点，并且不能正常打开。

修改后的代码：

```js
serviceAxios({
	method: 'POST',
	url: `/template/export/${this.form_data.id}`,
	headers: {
	  Accept: 'application/vnd.ms-excel',
	  'Content-Type': 'application/json',
	  Token: localStorage.getItem('token')
	},
	data: this.form_data,
	responseType: 'blob'
})
.then((res) => {
  this.isShow = false
  download(
	res,
	'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
	this.form_data.name
  )
  ElMessage.success('下载成功')
})
.catch((err) => {
  ElMessage.error('下载失败：' + err)
})
```

这样就行了。里面的`download()`是随便封装的一个下载Blob文件的工具函数，参数分别是blob数据，MIME类型和文件名。

关于这个`download`函数的实现：

```javascript
export default (data: any, contentType: string, fileName: string) => {
  const downloadLink = window.document.createElement('a')
  downloadLink.href = window.URL.createObjectURL(
    new Blob([data], { type: contentType })
  )
  downloadLink.download = fileName
  document.body.appendChild(downloadLink)
  downloadLink.click()
  document.body.removeChild(downloadLink)
}
```

## 反思

这学期学计网的时候，重点学的部分是物理层，数据链路层，网络层以及传输层。唯一剩下的一层应用层则因为课时压缩直接压没了（但是期末大题还是考了SMTP协议）。但是恰恰是应用层这一部分在日常前端开发中使用最多。

这侧面反映出来了大学教育体系的一些问题，也提醒我们，书不能看一半，趁着大学有时间，尽量让自己的知识面更加全面一些，这是绝对值得的。
