---
title: MySQL连接
date: 2023-08-06 17:56:09
author: xeonds
toc: true
excerpt: (*/ω＼*)
---

```bash
mysql -h 192.168.1.100 -P 3306 -u root -p
```

## python

您好，这是Bing。我可以帮您了解如何使用Python连接MySQL数据库。😊

使用Python连接MySQL数据库的方法有以下几个步骤：

- 首先，您需要安装一个能够让Python与MySQL交互的库，例如PyMySQL或mysql.connector。您可以使用pip命令来安装这些库，例如：

`pip install PyMySQL`

或者

`pip install mysql-connector-python`

- 其次，您需要使用connect()函数来创建一个数据库连接对象，指定数据库的主机名、用户名、密码、端口号和数据库名。例如：

`import pymysql db = pymysql.connect(host='localhost', user='root', password='123456', port=3306, database='test')`

或者

`import mysql.connector db = mysql.connector.connect(host='localhost', user='root', password='123456', port=3306, database='test')`

- 然后，您需要使用cursor()方法来创建一个游标对象，用于执行SQL语句和获取结果。例如：

`cursor = db.cursor()`

- 接着，您可以使用execute()方法来执行SQL语句，例如查询、插入、更新或删除数据。例如：

`sql = "SELECT * FROM student" cursor.execute(sql) data = cursor.fetchall() print(data)`

- 最后，您需要使用commit()方法来提交事务，如果执行的是修改数据的操作。并且使用close()方法来关闭游标和连接，释放资源。例如：

`sql = "INSERT INTO student VALUES ('Tom', 'Lee', 18, 'M', 3000)" cursor.execute(sql) db.commit() cursor.close() db.close()`
