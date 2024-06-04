---
title: 关于我
date: 2022-10-12 00:58:46
---

## PROF1LE

[![CodeTime badge](https://img.shields.io/endpoint?style=social&url=https%3A%2F%2Fapi.codetime.dev%2Fshield%3Fid%3D17726%26project%3D%26in%3D0)](https://codetime.dev)

兴趣/习惯是写代码。~~闲了~~喜欢整点小玩意玩。

游戏玩的不多，一直断断续续在玩的只有mc。

Homepage (zh) (in maintaince) | [Blog](https://mxts.jiujiuer.xyz) | [Blog (Pure)](https://blog.iris.al/)

![xeonds's GitHub stats](https://github-readme-stats.vercel.app/api?username=xeonds)

![xeonds's Most used languages](https://github-readme-stats.vercel.app/api/top-langs/?username=xeonds&layout=donut-vertical&hide_border=true&langs_count=256&size_weight=0.5&count_weight=0.5)

## 咱的项目

[![XDU-Planet](https://github-readme-stats.vercel.app/api/pin/?username=xeonds&repo=xdu-planet&show_owner=true)](https://xeonds.github.io/xdu-planet)

Gin+Vue构建的RSS博客聚合站

[![NanoOJ](https://github-readme-stats.vercel.app/api/pin/?username=xeonds&repo=NanoOJ&show_owner=true)](https://github.com/xeonds/NanoOJ)

使用Go+Vue+Docker实现的分布式OJ系统

[![Bus-Admin](https://github-readme-stats.vercel.app/api/pin/?username=xeonds&repo=bus-admin&show_owner=true)](https://github.com/xeonds/bus-admin)

数据库大作业，公交调度管理系统

[![Xync-Backup](https://github-readme-stats.vercel.app/api/pin/?username=xeonds&repo=xync-backup&show_owner=true)](https://github.com/xeonds/xync-backup)

Flutter练手作，复刻AutoSync。另外还有个用Flutter填坑的MCSM Panel，但是这东西用的不多也就没咋积极更新了

[![sqlc](https://github-readme-stats.vercel.app/api/pin/?username=xeonds&repo=sqlc&show_owner=true)](https://github.com/xeonds/xync-backup)

借助`OCaml`编写的简单的SQL解释器，以及一个简单的数据库后端实现。非常喜欢这个语言的类型系统，`Type Deduction`+纯纯函数式爽飞了好吧

另外这个博客的发布也借助`GitHub Action`实现了自动化编译发布，详见[这里](https://xeonds.github.io/2022/11/25/%E8%AE%A1%E7%AE%97%E6%9C%BA%E7%A7%91%E5%AD%A6/GitHub%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA/)和[我的workflow配置文件](https://github.com/xeonds/xeonds.github.io/blob/master/.github/workflows/hexo-deploy.yml)。

~~极速~~纯文字版的博客使用了如下的指令实现：

```bash
gen:
	rm -rf dist && mkdir -p dist && cp -r img dist
	find ./_posts -type f -name "*.md" -exec sh -c 'pandoc "$$1" -s -o "./dist/$$(basename "$$1" .md).html" --mathjax' _ {} \;
	pandoc -s -f markdown -t html --mathjax --metadata title="xero's blog" -o ./dist/index.html \
		<(echo -e ">enj0y creating\n\n") \
		./links/index.md \
		<(echo -e "## toc\n") \
		<(find ./_posts -type f -name '*.md' -printf '- [%f](%f.html)\n' | sed -e "s/\.md//g") \
		./about/index.md \
		<(echo -e "2024 | xero's blog | powered by pandoc")
```

