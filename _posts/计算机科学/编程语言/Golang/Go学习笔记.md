---
title: Go学习笔记
tags:
  - 编程
  - Golang
excerpt: 希望以后能少踩点坑
toc: true
author: xeonds
date: '2022.05.06 18:46:36'
categories:
  - 计算机科学
  - 编程语言
  - Golang
---

## 安装

- 访问[这里](https://go.dev/) ，下载安装包进行安装即可。或者访问[这里](https://studygolang.com/dl/)下载也可。

- 配置`go mod proxy`，参考<https://goproxy.cn>即可。

- 安装VSCode+Go插件或者Goland等开发工具都可以。

---

最近得在Linux上编译个服务端程序，所以把配置方法记录一下。

源用的是USTC的。看了他们官网发现东西还真不少~~比隔壁tuna多多了而且域名还短（确信）~~。golang直接下载太慢所以走镜像站。链接在这，时效性应该不用太担心。

<https://mirrors.ustc.edu.cn/golang/go1.20.1.linux-amd64.tar.gz>

步骤很简单，就是`wget`然后`tar`解压到指定位置最后把目录加到系统环境变量里边：

```bash
VER="1.20.1"
SH="bash"
# 下载解压 & 移除旧版本
wget https://mirrors.ustc.edu.cn/golang/go"$VER".linux-amd64.tar.gz \
&& rm -rf /usr/local/go \
&& tar -C /usr/local -zxf go$GO_STR.linux-amd64.tar.gz
# 如果是第一次安装且使用bash
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/."$SH"rc
```

注意：**执行上面的脚本之前请先自行验证安全性**。以及，上面的脚本得用root权限执行。

然后就是设置代理。我用<http://goproxy.cn>比较多。配置也很简单：

```bash
export GO111MODULE=on
export GOPROXY=https://goproxy.cn
```

## 资料

- [《Go语言圣经》](https://books.studygolang.com/gopl-zh)

## 常见问题

- Go test报错

报错内容：`call has possible formatting directive %v`

原因：`go test` 中不能使用 `fmt.Println("%v", v)`

### 方案

使用 `fmt.Printf("%+v", v)`

## 工具链
现代语言最大的优势就是工具链。

```bash
go tool dist list
```

依赖：

```bash
ldd [bin-name]
```

静态编译：
```bash
CGO_ENABLED=0 go build xxx
# or this
go build xxx -ldflags '-linkmode "external" -extldflags "-static"'
```

如果glibc版本不对的话，直接使用指定`LD_LIBRARY_PATH=.`的方法是无效的。
>ref:[Glibc is hard-coded in the program](https://stackoverflow.com/questions/847179/multiple-glibc-libraries-on-a-single-host)

## 造轮子
采用组合的方式将常用的范式写成函数，同时不失灵活性和潜力。

### Gin

对于Gin的复用主要是添加路由的方式进行抽象和标准化，同时编写一些较为通用的API Handlers：
```golang
func APIBuilder(router gin.IRouter, handlers ...func(*gin.RouterGroup) *gin.RouterGroup) func(gin.IRouter, string) *gin.RouterGroup {
	return func(router gin.IRouter, path string) *gin.RouterGroup {
		group := router.Group(path)
		for _, handler := range handlers {
			group = handler(group)
		}
		return group
	}
}
```
上面的函数实现了为一个`gin.RouterGroup`自动添加参数传入的handler列表。这样的构造器构造出的函数能用于给一个接口添加几个固定的Handler。在复用层面实现了快速的为一个结构体添加CRUD的能力，同时允许你编写自己的handler代码，以及自己的构造器。

```golang
func AddCRUD[T any](router gin.IRouter, path string, db *gorm.DB) *gin.RouterGroup {
	return APIBuilder(router, func(group *gin.RouterGroup) *gin.RouterGroup {
		group.GET("", getAll[T](db))
		group.GET("/:id", get[T](db))
		group.POST("", create[T](db))
		group.PUT("/:id", update[T](db))
		group.DELETE("/:id", delete[T](db))
		return group
	})(router, path)
}
```
上面展示的就是构造器的一个用法，这个构造器构造的函数能用来快速给一个结构体添加CRUD接口。

其中的Handler可以自己实现，并把自己的Handler通过上面的APIBuilder打包成一个可以快速调用的函数：

```golang
// 简单的Handler示范
func create[T any](db *gorm.DB) func(c *gin.Context) {
	return func(c *gin.Context) {
		var d T
		if err := c.ShouldBindJSON(&d); err != nil {
			c.AbortWithStatus(404)
			log.Println("[gorm]parse creation data failed: ", err)
		} else {
			if err := db.Create(&d).Error; err != nil {
				c.AbortWithStatus(404)
				log.Println("[gorm]create data failed: ", err)
			} else {
				c.JSON(200, d)
			}
		}
	}
}
// 简单的调用示范
type Hello struct {
    Hello string
    World string
}
r := gin.Default
db, _ := gorm.Open(sqlite.Open("test"), &gorm.Config{})
AddCRUD[Hello](r, "/hello", db)
```

上面几行代码就添加了四个对于Hello的CRUD API。

而且你应该注意到了，上面crud的实现我传入了`gorm.DB`来完成实际的crud动作。主要是因为数据库查询的动作我不知道应该怎么传入，而且又不想自己搓个大而全的框架出来——简洁的函数更合我的胃口。

下一步就是尝试抽象以前自己编写的后端，试着用简洁又不失灵活度的方法创建一个渐进式辅助函数包。

>最近发现了go-zero这个脚手架，主打面向`k8s`整微服务开发。框架做的还行，甚至基于go语法搓了个DSL出来。里边包含的单体微服务的框架对我有比较大的启发作用，我打算把它变成一个更FP的工具包拿来用。
>以及Goland好像看着确实不错。
>
>更新，搓了一个crud的框架，以及一些零散的中间件类的工具，以及一些零散的工具。很难分类，有点陷入架构难题了（

## Golang-THE_BAD_THINGS

开个坑后面填

- 语法
	- 鸭子继承
	- defer
	- 类型系统
	- 泛型系统
	- 结构体注解系统
	- 基于大小写的可见域控制
	- 暂时没想起来但是我觉得还有
- 工具链
	- 这个好像没啥好喷的毕竟确实优秀（
	- 虽然绕开glibc的行为不好说但是从效果和架构上来看，我是支持这种设计方法的（
	- 唯一的问题是可能会和linux承诺的源码级兼容性有些许冲突（？