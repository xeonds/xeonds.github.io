---
title: 试试终端养鱼（Linux）！
date: 2023-05-31 21:17:06
author: xeonds
toc: true
excerpt: 说实话，当个屏保挺不错的
---

我在Ubuntu上得安装点依赖，主要是Cursor和Animation；剩下的很简单。

```bash
# 安装curse
sudo apt-get install libcurses-perl
# 安装Animation
wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz
tar -zxvf Term-Animation-2.4.tar.gz ; cd Term-Animation-2.4/
perl Makefile.PL && make
make install; cd ..
# 安装asciiquarium本体
wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
tar -zxvf asciiquarium.tar.gz
cd asciiquarium_1.1/
sudo cp asciiquarium /usr/local/bin
sudo chmod +x /usr/local/bin/asciiquarium
asciiquarium #如果不行的话，重启终端
```

效果这样：

![这不挺好](img/Pasted%20image%2020230531212306.png)
