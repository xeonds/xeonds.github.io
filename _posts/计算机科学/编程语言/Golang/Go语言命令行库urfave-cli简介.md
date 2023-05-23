---
title: Go语言命令行库urfave-cli简介
date: '2022.11.22 19:44:01'
author: xeonds
toc: true
excerpt: ^_^
categories:
  - 计算机科学
  - 编程语言
  - Golang
---

很多用Go写的命令行程序都用了urfave/cli这个库，包括geth，有必要简单了解一下。

用C写过命令行程序的人应该都不陌生，我们需要根据argc/argv一个个地解析命令行参数，调用不同的函数，最后还要写一个usage()函数用于打印帮助信息。urfave/cli把这个过程做了一下封装，抽象出flag/command/subcommand这些模块，用户只需要提供一些模块的配置，参数的解析和关联在库内部完成，帮助信息也可以自动生成。

举个例子，我们想要实现下面这个命令行程序：

```bash
NAME:   GoTest - hello world

USAGE:   GoTest [global options] command [command options] [arguments...]

VERSION:   1.2.3

COMMANDS:     help, h  Shows a list of commands or help for one command
			arithmetic:     
			  add, a  calc 1+1     
			  sub, s  calc 5-3   
			database:     
			  db  database operations 
			  
GLOBAL OPTIONS:   
	--lang FILE, -l FILE    read from FILE (default: "english")   
	--port value, -p value  listening port (default: 8000)   
	--help, -h              Help!Help!   
	--print-version, -v     print version
```

  
1. 基本结构  
导入包以后，通过cli.NewApp()创建一个实例，然后调用Run()方法就实现了一个最基本的命令行程序了。

当然，为了让我们的程序干点事情，可以指定一下入口函数app.Action，具体写法如下：

```Go
import (
         "fmt"
         "gopkg.in/urfave/cli.v1"
) 
         
func main() {    
	app := cli.NewApp()    
	app.Action = func(c *cli.Context) error {        
		fmt.Println("BOOM!")        
		return nil    
	} 
	    
	err := app.Run(os.Args)    
	if err != nil {        
		log.Fatal(err)    
	}
}
```

  
2. 公共配置  
就是帮助里需要显示的一些基本信息：

```Go
  app.Name = "GoTest"  
  app.Usage = "hello world"  
  app.Version = "1.2.3"
```

  
3. Flag配置  
具体对应于帮助中的以下信息：

```bash
--lang FILE, -l FILE    read from FILE (default: "english")
--port value, -p value  listening port (default: 8000)
```

  
对应代码：

```Go
var language string     
app.Flags = []cli.Flag {        
	cli.IntFlag {            
		Name: "port, p",            
		Value: 8000,            
		Usage: "listening port",        
	},        
	cli.StringFlag {            
		Name: "lang, l",            
		Value: "english",            
		Usage: "read from `FILE`",            
		Destination: &language,        
	},    
}
```

  
可以看到，每一个flag都对应一个cli.Flag接口的实例。

Name字段中逗号后面的字符表示flag的简写，也就是说"--port"和"-p"是等价的。

Value字段可以指定flag的默认值。

Usage字段是flag的描述信息。

Destination字段可以为该flag指定一个接收者，比如上面的language变量。解析完"--lang"这个flag后会自动存储到这个变量里，后面的代码就可以直接使用这个变量的值了。

另外，如果你想给用户增加一些属性值类型的提示，可以通过占位符（placeholder）来实现，比如上面的"--lang FILE"。占位符通过``符号来标识。

我们可以在app.Action中测试一下打印这些flag的值：

```Go
app.Action = func(c *cli.Context) error {        
	fmt.Println("BOOM!")        
	fmt.Println(c.String("lang"), c.Int("port"))        
	fmt.Println(language)        
	return nil    
}
```

  
另外，正常来说帮助信息里的flag是按照代码里的声明顺序排列的，如果你想让它们按照字典序排列的话，可以借助于sort：

```Go
import "sort"
sort.Sort(cli.FlagsByName(app.Flags))
```

最后，help和version这两个flag有默认实现，也可以自己改：

```Go
cli.HelpFlag = cli.BoolFlag {        
	Name: "help, h",        
	Usage: "Help!Help!",    
}        
cli.VersionFlag = cli.BoolFlag {        
	Name: "print-version, v",        
	Usage: "print version",    
}
```

  
4. Command配置  
命令行程序除了有flag，还有command（比如git log, git commit等等）。

另外每个command可能还有subcommand，也就必须要通过添加两个命令行参数才能完成相应的操作。比如我们的db命令包含2个子命令，如果输入GoTest db -h会显示下面的信息：

```bash
NAME:   GoTest db - database operations 

USAGE:   GoTest db command [command options] [arguments...] 

COMMANDS:   insert  insert data     
			delete  delete data 
	
OPTIONS:   --help, -h  Help!Help!
```

  
每个command都对应于一个cli.Command接口的实例，入口函数通过Action指定。如果你想像在帮助信息里实现分组显示，可以为每个command指定一个Category。具体代码如下：

```Go
app.Commands = []cli.Command {        
	{            
		Name: "add",            
		Aliases: []string{"a"},            
		Usage: "calc 1+1",            
		Category: "arithmetic",            
		Action: func(c *cli.Context) error {                
			fmt.Println("1 + 1 = ", 1 + 1)                
			return nil            
		},        
	},        
	{            
		Name: "sub",            
		Aliases: []string{"s"},            
		Usage: "calc 5-3",            
		Category: "arithmetic",            
		Action: func(c *cli.Context) error {                
			fmt.Println("5 - 3 = ", 5 - 3)                
			return nil            
		},        
	},        
	{            
		Name: "db",            
		Usage: "database operations",            
		Category: "database",            
		Subcommands: []cli.Command {                
			{                    
				Name: "insert",                    
				Usage: "insert data",                    
				Action: func(c *cli.Context) error {                       
					fmt.Println("insert subcommand")                        
					return nil                    
				},                
			},                
			{                    
				Name: "delete",                    
				Usage: "delete data",                    
				Action: func(c *cli.Context) error {                       
					fmt.Println("delete subcommand")                        
				return nil                    
				},                
			},            
		},        
	},    
}
```

如果你想在command执行前后执行后完成一些操作，可以指定app.Before/app.After这两个字段：

```Go
app.Before = func(c *cli.Context) error {        
	fmt.Println("app Before")        
	return nil    
}    
app.After = func(c *cli.Context) error {        
	fmt.Println("app After")        
	return nil    
}
```

  
具体测试一下：

```bash
$ GoTest add
$ GoTest db insert
```

  
5. 小结  
总体来说，urfave/cli这个库还是很好用的，完成了很多routine的工作，程序员只需要专注于具体业务逻辑的实现。

附完整demo代码：

```Go
package cli

import (
	"fmt"
	"log"
	"os"
	"sort"

	"gopkg.in/urfave/cli.v1"
)

func Run() {
	var language string
	app := cli.NewApp()
	app.Name = "GoTest"
	app.Usage = "hello world"
	app.Version = "1.2.3"
	app.Flags = []cli.Flag{
		cli.IntFlag{
			Name:  "port, p",
			Value: 8000,
			Usage: "listening port",
		},
		cli.StringFlag{
			Name:        "lang, l",
			Value:       "english",
			Usage:       "read from `FILE`",
			Destination: &language,
		},
	}
	app.Commands = []cli.Command{
		{
			Name:     "add",
			Aliases:  []string{"a"},
			Usage:    "calc 1+1",
			Category: "arithmetic",
			Action: func(c *cli.Context) error {
				fmt.Println("1 + 1 = ", 1+1)
				return nil
			},
		},
		{
			Name:     "sub",
			Aliases:  []string{"s"},
			Usage:    "calc 5-3",
			Category: "arithmetic",
			Action: func(c *cli.Context) error {
				fmt.Println("5 - 3 = ", 5-3)
				return nil
			},
		},
		{
			Name:     "db",
			Usage:    "database operations",
			Category: "database",
			Subcommands: []cli.Command{
				{
					Name:  "insert",
					Usage: "insert data",
					Action: func(c *cli.Context) error {
						fmt.Println("insert subcommand")
						return nil
					},
				},
				{
					Name:  "delete",
					Usage: "delete data",
					Action: func(c *cli.Context) error {
						fmt.Println("delete subcommand")
						return nil
					},
				},
			},
		},
	}
	app.Action = func(c *cli.Context) error {
		fmt.Println("BOOM!")
		fmt.Println(c.String("lang"), c.Int("port"))
		fmt.Println(language)
		if c.Int("port") == 8000 {
			return cli.NewExitError("invalid port", 88)
		}
		return nil
	}
	app.Before = func(c *cli.Context) error {
		fmt.Println("app Before")
		return nil
	}
	app.After = func(c *cli.Context) error {
		fmt.Println("app After")
		return nil
	}
	sort.Sort(cli.FlagsByName(app.Flags))
	cli.HelpFlag = cli.BoolFlag{
		Name:  "help, h",
		Usage: "Help!Help!",
	}
	cli.VersionFlag = cli.BoolFlag{
		Name:  "print-version, v",
		Usage: "print version",
	}
	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
```