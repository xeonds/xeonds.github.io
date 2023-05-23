---
title: Golang学习笔记-SQL与GORM实践
date: 2022.12.25 15:20:23
author: xeonds
toc: true
excerpt: 
---

## 理解database/sql

### Golang使用sql

Golang使用数据库的方式最开始是用`database/sql`和相应的数据库驱动包。不过后来人们发现这会使得我们不能同时使用两个同样数据库的驱动，以及其他的问题。因此后来又在`sql.Open()`的基础上增加了`sql.OpenDB(connector)`函数。数据库驱动包只提供相应的connector，而不需要先将这个驱动注册为全局数据库驱动。用例如下：

```golang
import "github.com/go-sql-driver/mysql"

func main(){
  connector, err := mysql.NewConnector(&mysql.Config{
    User: "gorm",
    Passwd: "gorm",
    Net: "tcp",
    Addr: "127.0.0.1:3306",
    DBName: "gorm",
    ParseTime: true,
  })
  db := sql.OpenDB(connector)
}
```

### ORM

>摘自阮一峰的网络日志

简单说，ORM 就是通过实例对象的语法，完成关系型数据库的操作的技术，是"对象-关系映射"（Object/Relational Mapping） 的缩写。

ORM 把数据库映射成对象。

- 数据库的表（table） --> 类（class）
- 记录（record，行数据）--> 对象（object）
- 字段（field）--> 对象的属性（attribute）

总结起来，ORM 有下面这些优点。

- 数据模型都在一个地方定义，更容易更新和维护，也利于重用代码。
- ORM 有现成的工具，很多功能都可以自动完成，比如数据消毒、预处理、事务等等。
- 它迫使你使用 MVC 架构，ORM 就是天然的 Model，最终使代码更清晰。
- 基于 ORM 的业务代码比较简单，代码量少，语义性好，容易理解。
- 你不必编写性能不佳的 SQL。

但是，ORM 也有很突出的缺点。

- ORM 库不是轻量级工具，需要花很多精力学习和设置。
- 对于复杂的查询，ORM 要么是无法表达，要么是性能不如原生的 SQL。
- ORM 抽象掉了数据库层，开发者无法了解底层的数据库操作，也无法定制一些特殊的 SQL。

## GORM使用简介

>一个强大的全功能ORM

![[Screenshot_20221225_154129.jpg]]

![[Screenshot_20221225_154420.jpg]]

![[Screenshot_20221225_154458.jpg]]

![[Screenshot_20221225_154714.jpg]]![[Screenshot_20221225_154847.jpg]]
![[Screenshot_20221225_163032.jpg]]![[Screenshot_20221225_163422.jpg]]

## GORM最佳实践

GORM是一个强大的全功能ORM，它有很多优点，比如数据模型都在一个地方定义，更容易更新和维护，也利于重用代码。ORM 有现成的工具，很多功能都可以自动完成，比如数据消毒、预处理、事务等等。它迫使你使用 MVC 架构，ORM 就是天然的 Model，最终使代码更清晰。基于 ORM 的业务代码比较简单，代码量少，语义性好，容易理解。你不必编写性能不佳的 SQL。

但是，ORM 也有很突出的缺点。ORM 库不是轻量级工具，需要花很多精力学习和设置。对于复杂的查询，ORM 要么是无法表达，要么是性能不如原生的 SQL。ORM 抽象掉了数据库层，开发者无法了解底层的数据库操作，也无法定制一些特殊的 SQL。

在GORM的使用中，我们需要注意以下几点：

- 数据序列化与SQL表达式
- 批量数据操作
- 代码复用、分库分表、Sharding
- 混沌工程/压测
- Logger/Trace
- Migrator
- Gen代码生成/Raw SQL
- 安全
 
在使用GORM时，我们需要继续学习和掌握其API和使用方法，以便更好地利用ORM的优点，同时避免其缺点。同时，我们也需要深入了解数据库的底层操作和SQL语句的表达方式，以便更好地使用GORM进行数据序列化和查询操作。除此之外，我们还需要注意数据安全和代码复用等方面的问题，以便更好地应对实际开发中的需求。

### 数据序列化与SQL表达式


在GORM中，数据序列化和SQL表达式是非常重要的概念。GORM提供了丰富的API和方法，以便我们更好地进行数据序列化和查询操作。其中，数据序列化是指将数据从内存中转换为SQL语句的过程，而SQL表达式则是指SQL语句的表达方式。在使用GORM时，我们需要深入了解这两个概念，以便更好地利用GORM进行数据操作。

具体来说，GORM中的数据序列化和SQL表达式包括以下几个方面：

- 数据类型映射
- 字段映射
- SQL表达式
- 预处理语句

其中，数据类型映射是指将Golang中的数据类型映射到SQL中的数据类型的过程。GORM提供了丰富的数据类型映射方法，以便我们更好地进行数据操作。字段映射则是指将Golang中的结构体字段映射到SQL中的表字段的过程。GORM提供了丰富的字段映射方法，以便我们更好地进行数据操作。SQL表达式则是指SQL语句的表达方式。GORM提供了丰富的SQL表达式方法，以便我们更好地进行数据操作。预处理语句则是指将SQL语句预处理后再执行的过程。GORM提供了丰富的预处理语句方法，以便我们更好地进行数据操作。

总之，在使用GORM进行数据操作时，我们需要深入了解数据序列化和SQL表达式的相关概念和方法，以便更好地利用GORM进行数据操作。同时，我们也需要深入了解数据库的底层操作和SQL语句的表达方式，以便更好地使用GORM进行数据序列化和查询操作。除此之外，我们还需要注意数据安全和代码复用等方面的问题，以便更好地应对实际开发中的需求。

### 批量数据操作

GORM提供了批量数据操作的方法，以便我们更好地进行数据操作。其中，批量插入数据的方法如下：

```golang
func (db *DB) CreateInBatches(value interface{}, batchSize int) error
```

其中，`value`参数是要插入的数据，`batchSize`参数是每批次插入的数据量。例如，我们要批量插入1000条数据，每批次插入100条数据，可以使用如下代码：

```golang
var data []User
for i := 0; i < 1000; i++ {
  data = append(data, User{Name: fmt.Sprintf("user%d", i)})
}
if err := db.CreateInBatches(data, 100).Error; err != nil {
  // handle error
}
```

批量更新数据的方法如下：

```golang
func (db *DB) UpdatesInBatches(value interface{}, condition string, params ...interface{}) (sql.Result, error)
```

其中，`value`参数是要更新的数据，`condition`参数是更新条件，`params`参数是更新条件的参数。例如，我们要批量更新所有名字为"user"的用户的年龄为18岁，可以使用如下代码：

```golang
if result, err := db.UpdatesInBatches(User{Age: 18}, "name = ?", "user").Error; err != nil {
  // handle error
} else {
  // handle result
}
```

批量删除数据的方法如下：

```golang
func (db *DB) DeleteInBatches(value interface{}, batchSize int) error
```

其中，`value`参数是要删除的数据，`batchSize`参数是每批次删除的数据量。例如，我们要批量删除所有名字为"user"的用户，每批次删除100条数据，可以使用如下代码：

```golang
if err := db.Where("name = ?", "user").DeleteInBatches(User{}, 100).Error; err != nil {
  // handle error
}
```

### 代码复用、分库分表、Sharding

#### 代码复用-分页最佳实践

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

### 混沌工程/压测

### Logger/Trace

### Migrator

### Gen代码生成/Raw SQL

###  安全

GORM提供了一些安全相关的方法，以便我们更好地保护数据安全。其中，GORM提供了如下方法：

- `db.Set("gorm:save_associations", false)`：禁止保存关联数据。
- `db.Set("gorm:association_autoupdate", false)`：禁止自动更新关联数据。
- `db.Set("gorm:association_autocreate", false)`：禁止自动创建关联数据。
- `db.Set("gorm:association_save_reference", false)`：禁止保存关联数据的引用。
- `db.Set("gorm:association_save_before_association", false)`：禁止在保存关联数据之前保存主数据。
- `db.Set("gorm:association_autocreate_join_table", false)`：禁止自动创建关联表。

这些方法可以帮助我们更好地保护数据安全，避免意外的数据修改和删除。同时，我们也需要注意数据安全和代码复用等方面的问题，以便更好地应对实际开发中的需求。

### 多表查询

多表查询的时候记得字段名得首字母大写，和结构体名称保持一致：

```golang
//  model
// 公司
type Company struct {
	ID        uint `gorm:"primaryKey;autoIncrement"`
	Name      string
	CreatedAt time.Time
}

// 车队
type Team struct {
	ID          uint `gorm:"primaryKey;autoIncrement"`
	Name        string
	CompanyID   uint
	Company     Company `gorm:"foreignKey:CompanyID;onDelete:CASCADE"`
	ManagerName string
}

// 路线
type Route struct {
	ID     uint `gorm:"primaryKey;autoIncrement"`
	Name   string
	TeamID uint
	Team   Team `gorm:"foreignKey:TeamID;onDelete:CASCADE"`
}

// 司机
type Driver struct {
	ID      uint `gorm:"primaryKey;autoIncrement"`
	Name    string
	RouteID uint
	Route   Route `gorm:"foreignKey:RouteID;onDelete:CASCADE"`
}

// 队长
type RoadManager struct {
	ID      uint `gorm:"primaryKey"`
	Name    string
	RouteID uint
	Route   Route `gorm:"foreignKey:RouteID;onDelete:CASCADE"`
}

// 违章
type Violation struct {
	ID            uint `gorm:"primaryKey;autoIncrement"`
	DriverID      uint
	VehicleID     uint
	TeamID        uint
	RouteID       uint
	OccurredAt    time.Time
	ViolationType string

	Driver  Driver  `gorm:"foreignKey:DriverID;onDelete:CASCADE"`
	Vehicle Vehicle `gorm:"foreignKey:VehicleID;onDelete:CASCADE"`
	Team    Team    `gorm:"foreignKey:TeamID;onDelete:CASCADE"`
	Route   Route   `gorm:"foreignKey:RouteID;onDelete:CASCADE"`
}

// 车辆
type Vehicle struct {
	ID  uint `gorm:"primaryKey;autoIncrement"`
	VIN string
}

// handler
api.POST("query/violation/driver", func(c *gin.Context) {
    var data ReqeustQuery
    c.ShouldBindJSON(&data)
    query := db.Model(&Violation{}).Joins("Vehicle").Joins("Team").Joins("Route").Joins("Driver")
    start, _ := time.Parse(time.RFC3339, data.Time[0])
    end, _ := time.Parse(time.RFC3339, data.Time[1])
    query = query.Where("Driver.Name = ? AND occurred_at BETWEEN ? AND ?", data.Name, start, end)
    var violations []Violation
    query.Find(&violations)
    c.JSON(200, violations)
})
```
