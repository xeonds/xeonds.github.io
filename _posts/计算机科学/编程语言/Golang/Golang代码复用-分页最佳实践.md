---
title: Golang代码复用-分页最佳实践
date: 2023-10-07 21:59:46
author: xeonds
toc: true
excerpt: 简简单单，一行分页。回头甚至能水个库？
tags:
  - Golang
  - 开发
  - Web
---
分页是查询的一个基本要求之一。这部分代码大多重复，适合复用。下面是一种最佳实践：

这是一个传有分页数据的Gin Handler，它需要对数据库进行分页查询：

```go
func (p propertyRepository) GetPagedAndFiltered (limit, page int){
}
```

随后我们定义一个`gorm`中间件去对数据库进行分页：

```go
import "gorm.io/gorm"  
  
type paginate struct {  
limit int  
page int  
}  
  
func newPaginate(limit int, page int) *paginate {  
return &paginate{limit: limit,page: page}  
}  
  
func (p *paginate) paginatedResult(db *gorm.DB) *gorm.DB {  
offset := (p.page - 1) * p.limit  
  
return db.Offset(offset).  
Limit(p.limit)  
}
```

随后，就可以在数据库中使用分页了：

```go
func (p propertyRepository) GetPagedAndFiltered(limit, page int) ([]Property, error) {  
var properties []Property  
  
err := p.db.Scopes(newPaginate(limit,page).paginatedResult).Find(&properties).Error  
  
return properties, err  
}
```

当然，我对上面的代码进行了进一步的集成。虽然损失了低耦合性质，但是只是在Gin使用的话体验拉满：

```go
type Pagination struct {
	PageSize int
	PageNum  int
}

// GetPagination Get pagination info
func GetPagination(c *gin.Context) Pagination {
	var data Pagination
	pageSize, _ := strconv.Atoi(c.Query("pagesize"))
	pageNum, _ := strconv.Atoi(c.Query("pagenum"))
	switch {
	case pageSize >= 100:
		data.PageSize = 100
	case pageSize <= 0:
		data.PageSize = 10
	}
	if pageNum <= 0 {
		data.PageNum = 1
	}
	return data
}

func (p *Pagination) PaginatedResults(db *gorm.DB) *gorm.DB {
	offset := (p.PageNum - 1) * p.PageSize
	return db.Offset(offset).Limit(p.PageSize)
}
```

使用方法就是在Gin Handler中用`GetPagination`获取分页参数，然后在`model`的具体数据库实现操作中使用`db.Scopes(page.PaginatedResult).xxx`直接分页。

应该是一种最佳实践。
