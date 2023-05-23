---
title: Go语言结构类型详解
date: '2022.11.22 19:36:06'
author: xeonds
toc: true
excerpt: ^_^
categories:
  - 计算机科学
  - 编程语言
  - Golang
---

Go允许用户自定义类型，当你需要用代码抽象描述一个事物或者对象的时候，可以声明一个 struct 类型来进行描述。

当然，Go语言中，用户还可以基于已有的类型来定义其他类型。

简单来说，Go语言中用户可以有两种方法定义类型，第一种是使用 struct 关键字来创造一个结构类型；第二种是基于已有的类型，将其作为新类型的类型说明。

## **01.** 自定义类型的基本使用

基于已有的类型的这种方式比较简单，但需要注意的是，虽然是基于已有类型来定义新类型，但是基础类型和新类型是完全不同的两种类型，不能相互赋值，因为Go语言中，编译器不会对不同类型的值做隐式转换。

当需要使用一个比较明确的名字类描述一种类型时，使用这种自定义类型就比较合适，比如定义一个表示年龄的类型可以基于整形来定义一个 Age 类型，特指年龄类型。

下面是基于已有类型的方式定义类型的示例

```go
// 基于 int64 声明一个 Duration 类型
// int 是 Duration 的基本类型
// 但是他们是两个完全不同的类型，在Go中是不能相互赋值的
type Duration int
// 声明一个 Duration 类型的变量 d
var d Duration
// 声明并初始化int类型的变量i 为 50
i := 50
// 尝试赋值会报错
d = i // Cannot use 'i' (type int) as type Duration
```

使用关键字 struct 来声明一个结构类型时，要求字段是固定并且唯一的，并且字段的类型也是已知的，但是字段类型可以是内置类型（比如 string, bool, int 等等），也可以是用户自定义的类型（比如，本文中介绍的 struct 类型）。

声明struct 结构体的公式：`type 结构体名称 struct {}` 。

在任何时候，创建一个变量并初始化其零值时，我们习惯是使用关键字 var，这种用法是为了更明确的表示变量被设置为零值。

而如果是变量被初始化为非零值时，则使用短变量操作符 `:=` 和结构字面量 结构类型{ 字段: 字段值, } 或者 结构类型{ 字段1值, 字段2值 } 来创建变量。

两种字面量初始化方式的差异与限制：

结构类型{ 字段1值, 字段2值 } 这种初始化方式时：

1. 在最后一个字段值的结尾可以不用加逗号 ,

2. 必须严格按照声明时的字段顺序来进行初始化，不然会得不到预期的结果；如果字段类型不一致，还会导致初始化失败

3. 必须要初始化所有的字段，不然会报错 Too few values

  

结构类型{ 字段: 字段值, } 这种初始化方式时：

1. 每一个字段值的结尾必须要加一个逗号 ,

2. 初始化时，不要考虑字段声明的顺序

3. 允许只初始化部分字段

```go
  package main
  import "log"
  
  // 声明无状态的空结构体 animal
  type animal struct {}
  
  // 声明一个结构体 cat
  // 内部有有 name, age 两个字段
  // 字段 name 类型为 string类型
  // 字段 age 类型为 int 类型
  type cat struct {
    name string
    age int
  }
  
func main() {
  // 初始化1
  var c1 cat
  log.Println(c1) // { 0}
​
  // 初始化2
  // c2 := cat{"kitten"} // 报错：Too few values
  c2 := cat{"kitten", 1}
  log.Println(c2) // {kitten 1}
​
  // 初始化3
  c3 := cat{age: 2}
  log.Println(c3, c3.age) //  { 2} 2
  
  // 变量字段赋值
  c3.name = "kk"
​
  // 字段访问
  // 变量.字段名称
  log.Println(c3.name) // kk
}
```

以上是 struct 结构类型的基本使用，但是在项目开发中会遇到其他的用法，比如解析 json 或者 xml 文件到结构体类型变量中。

  

```go
// 解析 json 的示例
// 数据文件
// data.json
[
  {
    "site" : "npr",
    "link" : "http://www.npr.org/rss/rss.php?id=1001",
    "type" : "rss"
  },
  {
    "site" : "npr",
    "link" : "http://www.npr.org/rss/rss.php?id=1008",
    "type" : "rss"
  },
  {
    "site" : "npr",
    "link" : "http://www.npr.org/rss/rss.php?id=1006",
    "type" : "rss"
  }
]
​
// main.go
package main
​
import (
  "encoding/json"
  "log"
  "os"
)
​
type Feed struct {
  Site string `json:"site"`
  Link string `json:"link"`
  Type string `json:"type"`
}
​
// 解析 JSON 数据
func ParseJSON(path string) ([]*Feed, error) {
  file, err := os.Open(path)
  if err != nil {
    return nil, err
  }
​
  // 注意：打开文件之后，记得要关闭文件
  defer file.Close()
​
  // 注意：文件读取后，需要结构体来解析json数据
  var files []*Feed
  json.NewDecoder(file).Decode(&files)
  return files, nil
}
​
func main() {
  // 读取并解析 json 数据
  var path = "./data.json"
  feeds, err := ParseJSON(path)
  if err != nil {
    log.Println("error: ", err)
  }
  for i, val := range feeds {
    log.Printf("%d - site:%s, link:%s, type:%s", i, val.Site, val.Link, val.Type)
  }
}
```

  

```go
// 解析 xml 数据到结构体中示例
// data.xml
<?xml version="1.0" encoding="utf-8" ?>
<content>
    <item>
        <site>npr</site>
        <link>http://www.npr.org/rss/rss.php?id=1001</link>
        <type>rss</type>
    </item>
    <item>
        <site>npr</site>
        <link>http://www.npr.org/rss/rss.php?id=1002</link>
        <type>rss</type>
    </item>
    <item>
        <site>npr</site>
        <link>http://www.npr.org/rss/rss.php?id=1003</link>
        <type>rss</type>
    </item>
</content>
​
// main.go
package main
​
import (
  "encoding/xml"
  "io/ioutil"
  "log"
  "os"
)
​
type Content struct {
  XMLName xml.Name `xml:"content"` // 指定xml中的名称
  Item []item `xml:"item"`
}
type item struct {
  XMLName xml.Name `xml:"item"` // 指定xml中的名称
  Site string `xml:"site"`
  Link string `xml:"link"`
  Type string `xml:"type"`
}
​
// 解析 XML 数据
func ParseXML(path string) (*Content, error) {
  // 读取 xml
  data, err := ioutil.ReadFile(path)
  if err != nil {
    return nil, err
  }
​
  var con Content
  // 解析 xml
  xml.Unmarshal(data, &con)
  return &con, nil
}
​
func main() {
  // 读取并解析 xml 数据
  var xmlpath = "./data.xml"
  content, err := ParseXML(xmlpath)
  if err != nil {
    log.Println("error: ", err)
  }
  for i, val := range content.Item {
    log.Printf("%d - site:%s, link:%s, type:%s", i, val.Site, val.Link, val.Type)
  }
}
```

## **02.** 公开或未公开的标识符

在Go语言中，声明类型、函数、方法、变量等标识符时，使用大小写字母开头来区分该标识符是否公开（即是否能在包外访问）。

大写字母开头表示公开，小写字母开头表示非公开。所以如果某个结构类型以及结构类型的字段，函数，方法，变量等标识符，想要被外部访问到，那必须以大写字母开头。

```go
// user 包
package user
​
// 基于 int 类型声明一个 duration 类型
// 未公开的类型（以小写字母开头）
// 包外部，不能直接访问
type duration int
​
// 公开的类型（以大写字母开头）
// 包外部能直接访问
type Duration int
​
// 未公开的结构类型 user
type user struct {
  name string
}
​
// 公开的结构类型 User
type User struct {
  Name string
  phone string
  address
}
​
// 未公开的 address 类型
// 包含公开的字段 City
type address struct {
  City string
  position position
}
​
type position struct {
  Longitude string
  Latitude string
}
​
// 通过工厂函数，返回未公开的变量类型
func New(num int) duration {
  return duration(num)
}
```

  

```go
// main 包
package main
​
import (
  "go-demo/user"
  "log"
)
​
func main() {
  // ------
​
  // 在 main 包中，试图使用 user 包中的为公开的 duration 类型
  //var d1 user.duration = 10 // 报错：Unexported type 'duration' usage
​
  // ------
​
  // 在 main 包中，访问一个 user 包中公开的 Duration 类型
  var d2 user.Duration = 10
  log.Println(d2) // 结果：10
​
  // ------
​
  // 还可以以工厂函数的方式使用，user 包中未公开的类型
  d3 := user.New(100)
  log.Printf("type: %T, value:%d", d3, d3) // 结果：type: user.duration, value:100
​
  // ------
​
  // main包中尝试访问 user 包中未公开的结构类型 user
  //var u user.user // 报错：Unexported type 'user' usage
​
  // ------
​
  // main包中尝试访问 user 包中公开的结构类型 User
  var u user.User
  log.Printf("%#v", u) // 结果：user.User{name:""}
​
  // 访问公开 User 类型的未公开的字段 phone
  //log.Println(u.phone) // 报错：Unexported field 'phone' usage
​
  // 初始化未公开的字段 phone
  //u2 := user.User{phone: "176888888888"} // 报错：Unexported field 'phone' usage in struct literal
​
  // 访问公开 User 类型的公开的字段 Name
  // 给字段赋值
  //u.Name = "Jack"
  //log.Println(u.Name) // 结果：Jack
​
  // 初始化公开字段
  u3 := user.User{
    Name: "Jack",
  }
  log.Println(u3.Name) // 结果：Jack
​
  // ------
​
  // main 包中初始化 user 包中公开的 User 类型中嵌套的未公开的 address 类型
  // 报错：Unexported field 'address' usage in struct literal
  //u4 := user.User{
  //  address: address{
  //    City: "Beijing",
  //  },
  //}
​
​
  var u5 user.User
  // 嵌套的结构类型会提升到上级结构中
  u5.City = "Beijing"
  log.Println(u5.City) // Beijing
​
  // 尝试访问子孙级别的嵌套结构的公开的字段
  // 无法访问
  //u5.Longitude = "xx" //报错：u5.Longitude undefined (type user.User has no field or method Longitude)
}
```

  

## **03.** 给自定义类型增加方法

在Go语言中，编译器只允许为命名的用户定义的类型声明方法。方法跟函数类似，只是方法不会单独存在，一般是绑定到某个结构类型中，给类型增加方法的方式很简单，就是在方法名和 func 之间增加一个参数即可, 这个参数称为方法的接收者。

```go
type User struct {
  Name string
}
​
// 给 User 类型增加方法 Read
func (u User) Read() {
  log.Println(u.Name, "is Reading...")
}
​
// User 类型变量使用 Read 方法
func main() {
  u := User{
    Name: "Jack",
  }
  u.Read() // 结果 Jack is Reading...
}
```

方法的接收者，可以是值接收者，也可以是指针接收者。

而应该使用值接收者还是指针接收者，那要看给这个类型增加或删除某个值时，是创建一个新值，还是要更改当前值？如果是要创建一个新值，该类型的方法就使用值接收者；如果是要修改当前值，就使用指针接收者。

```go
package main
​
import "log"
​
// 基于基本类型创建类型
type Age int
​
// 值接收者
func (age Age) ChangeAge() {
  age = 18
}
// 指针接收者
func (age *Age) ChangeAgeByPointer() {
  *age = 18
}
​
// 基于引用类型创建类型
type IP []byte
​
// 值接收者
func (ip IP) ChangeIP() {
  ip = []byte("456")
}
​
// 指针接收者
func (ip *IP) ChangeIPByPointer() {
  *ip = []byte("456")
}
​
type Pet struct {
  Name string
  Hobby []string
}
​
// 值接收者
func (pet Pet) ChangePetValue(name string, hobby []string) {
  pet.Name = name
  pet.Hobby = hobby
}
​
// 指针接收者
func (pet *Pet) ChangePetValueByPointer(name string, hobby []string) {
  pet.Name = name
  pet.Hobby = hobby
}
​
func main() {
  // -----基于基本类型来定义类型的示例-----
  // 值接收者，不会改变原来的值
  var age Age = 38
  log.Println("前age=", age) // 前age= 38
  // 值调用方法
  age.ChangeAge()
  // 指针调用方法
  //(&age).ChangeAge()
​
  log.Println("后age=", age) // 后age= 38
​
  // 指针接收者，会改变原来的值
  var age2 Age = 38
  log.Println("前age2=", age2) // 前age= 38
  // 值调用方法
  age2.ChangeAgeByPointer()
  // 指针调用方法
  //(&age2).ChangeAgeByPointer()
​
  log.Println("后age2=", age2) // 后age= 18
​
​
  // -----基于引用类型来定义类型的示例-----
  // 值接收者，不会改变原来的值
  var ip IP = []byte("123")
  log.Printf("前ip=%s", ip) // 前ip=123
  // 值调用方法
  ip.ChangeIP()
  // 指针调用方法
  //(&ip).ChangeIP()
  log.Printf("后ip=%s", ip) // 后ip=123
​
  // 指针接收者，会改变原来的值
  var ip2 IP = []byte("123")
  log.Printf("前ip2=%s", ip2) // 前ip2=123
  // 值调用方法
  ip2.ChangeIPByPointer()
  // 指针调用方法
  //(&ip2).ChangeIPByPointer()
  log.Printf("后ip2=%s", ip2) // 后ip2=456
​
​
  // ----- struct 类型 -----
  // 值接收者，不会改变原来的值
  cat := Pet{
    Name: "kk",
    Hobby: []string{"cookies", "fishes"},
  }
  log.Printf("前：%#v", cat) // 前：method.Pet{Name:"kk", Hobby:[]string{"cookies", "fishes"}}
  // 值调用方法
  cat.ChangePetValue("kitten", []string{"meat"})
  // 指针调用方法
  //(&cat).ChangePetValue("kitten", []string{"meat"})
  log.Printf("后：%#v", cat) // 后：method.Pet{Name:"kk", Hobby:[]string{"cookies", "fishes"}}
​
  // 指针接收者，会改变原来的值
  log.Printf("指针前：%#v", cat) // 指针前：method.Pet{Name:"kk", Hobby:[]string{"cookies", "fishes"}}
  // 值调用方法
  cat.ChangePetValueByPointer("kitten", []string{"meat"}) 
  // 指针调用方法
  //(&cat).ChangePetValueByPointer("kitten", []string{"meat"})
  log.Printf("指针后：%#v", cat) // 指针后：method.Pet{Name:"kitten", Hobby:[]string{"meat"}}
}
```

## **04.** 嵌入类型

Go语言通过类型嵌套的方式来复用代码，当多个结构类型相互嵌套时，外部类型会复用内部类型的代码。

由于内部类型的标识符会提升到外部类型中，所以内部类型实现的字段，方法和接口在外部类型中也能直接访问到。

当外部类型需要实现一个和内部类型一样的方法或接口时，只需要给外部类型重新绑定方法或实现接口即可。

```go
package main
​
import "log"
​
// user 类型
type user struct {
  name string
  phone string
}
​
// 给 user 实现 Call 方法
func (u *user) Call() {
  log.Printf("Call user %s<%s>", u.name, u.phone)
}
​
// Admin 类型 （外部类型）
// 嵌套 user （内部类型）
type Admin struct {
  user
  level string
}
​
// 重新实现 Admin 类型的 Call 方法
func (ad *Admin) Call() {
  log.Printf("Call admin %s<%s>", ad.name, ad.phone)
}
​
// 定义一个接口 notifier,
// 接口需要实现一个 notify 方法
type notifier interface {
  notify()
}
​
// 给 user 实现 notify 方法
func (u *user) notify() {
  log.Printf("Sending a message to user %s<%s>", u.name, u.phone)
}
​
// 定义一个函数 sendNotification
// 函数接收一个实现了 notifier 接口的值
// 然后调用参数的 notify 方法
func sendNotification(n notifier) {
  n.notify()
}
​
// 给 Admin 实现 notify 方法
func (ad *Admin) notify() {
  log.Printf("Sending a message to ADMIN %s<%s>", ad.name, ad.phone)
}
​
func main() {
  // 声明并初始化 Admin 类型的变量 ad
  ad := Admin{
    user: user{
      name: "Jack",
      phone: "17688888888",
    },
    level: "super",
  }
  // ad 调用 user 内部的 Call 方法
  ad.user.Call() // Call user Jack<17688888888>
​
  // 由于内部类型的标识符提升，所以外部类型值 ad 也可以直接调用其内部类型的标识符(字段，方法，接口等)
  ad.Call() // Call user Jack<17688888888>
  log.Println(ad.name, ad.phone) // Jack 17688888888
​
  // ad 重新实现一个和内部类型 user 一样的 Call 方法
  // 覆盖内部类型 user 提升的 Call 方法
  ad.Call() // Call admin Jack<17688888888>
​
  // user 内部的 Call 方法没有变化
  ad.user.Call() // Call user Jack<17688888888>
​
​
  // 外部类型和内部类型调用接口方法
  sendNotification(&ad) // Sending a message to user Jack<17688888888>
  ad.notify() // Sending a message to user Jack<17688888888>
  ad.user.notify() // Sending a message to user Jack<17688888888>
​
  // 外部类型重新实现接口方法后
  sendNotification(&ad) // Sending a message to ADMIN Jack<17688888888>
  ad.notify() // Sending a message to ADMIN Jack<17688888888>
  ad.user.notify() // Sending a message to user Jack<17688888888>
}
```

## **05.**类型实现接口

Go语言中，接口是用来定义行为的类型，这些被定义的行为不由接口直接实现，而是通过方法由用户定义的类型实现。

如果用户定义的类型实现了某个接口里的一组方法，那么用户定义的这个类型值，就可以赋值给该接口值，此时用户定义的类型称为实体类型。

而用户定义的类型想要实现一个接口，需要遵循一些规则，这些规则使用方法集来进行定义。

从类型实现方法的接收者角度来看，可以描述为以下表格。

|方法接收者|类型值或类型值的指针|
|:--:|:--|
|(t T)|T and \*T|
|(t \*T)|\*T|

表示当类型的方法为指针接收者时，只有类型值的指针，才能实现接口。

如果类型的方法为值接收者，那么类型值还是类型值的指针都能够实现对应的接口。

```go
package main

import "log"

// 定义一个接口 notifier
// 要实现 notifier 接口必须实现 notify 方法
type notifier interface {
  notify()
}

type user struct {
  name string
  phone string
}

// 指针接收者
func (u *user) notify() {
  log.Println("Send user a text")
}

type Admin struct {
  user
  level string
}

// 值接收者
func (ad Admin) notify() {
  log.Println("Send admin a message")
}
// 多态函数
func sendNotification(n notifier) {
  n.notify()
}

func main() {
  // ---指针接收者方法的类型实现接口示例---
  u := user{
    name: "Jack",
    phone: "17688888888",
  }
  // 尝试将类型值实现接口 notifier
  // 因为类型的方法是指针接收者
  // 使用类型值实现接口时，会编译不通过
  //var n notifier = u // Cannot use 'u' (type user) as type notifier Type does not implement 'notifier' as 'notify' method has a pointer receiver

  // 使用类型值得指针，可以正常实现接口
  var n notifier = &u
  n.notify() // Send user a text


  // ---值接收者方法的类型实现接口示例---

  // 实现值接收者方法的类型实现接口
  ad := Admin{
    user: user{"Jack", "17688888888"},
    level: "super",
  }
  // 使用类型值实现接口，成功
  var n2 notifier = ad
  n2.notify() // Send admin a message

  // 使用类型值的指针实现接口, 成功
  var n3 notifier = &ad
  n3.notify() // Send admin a message
  
  
  // -------多态示例--------

  // 接口值多态
  // 因为 Admin 和 user 两个类型都实现了接口
  // 而 sendNotification 函数接收一个 notifier 接口值
  // 然后调用接口值对应的 notify 方法
  // 从而实现了接口值的多态
  sendNotification(n) // Send user a text
  sendNotification(n3) // Send admin a message
}
```
