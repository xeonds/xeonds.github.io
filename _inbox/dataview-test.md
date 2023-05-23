---
title: dataview-test
date: 2023-06-08 21:04:38
author: xeonds
toc: true
excerpt: Test for summary page
---

```dataview
list
where file.cday.weekyear = this.file.cday.weekyear or 
	file.mday.weekyear = this.file.cday.weekyear
```
