---
title: 数据库复习笔记
date: 2024-01-15 19:17:19
author: xeonds
toc: true
excerpt: (*/ω＼*)
tags:
---

这学期学的数据库主要偏向应用，理论部分相对比较少，重点如下：

## 数据库系统概论 大纲
- 绪论
    - 特点，概念，发展
    - 数据模型：层次，网状，关系
    - 结构：三级模式，二级映像
    - 组成
- 关系数据库
    - 关系数据结构
    - 关系操作！
    - 关系完整性：实体完整性，参照完整性，用户定义的完整性
    - 关系代数！
- SQL
    - 定义{模式，表，索引，数据字典} 
    - 查询：单表，连接，嵌套，集合，派生表
    - 更新：插入，修改，删除
    - 空值，试图
- 安全性
    - 安全性控制：用户身份控制，存取控制，自主存取控制,授权/收回，抢注存取控制方法
    - 视图 - 审计 - 数据加密
- 数据库完整性
    - 实体完整性，参照完整性，用户定义的完整性
    - 完整性约束命名子句
    - 断言
    - 触发器
- 关系数据理论
    - 规范化
        - 函数依赖 - 码 - 范式 - 2NF - 3NF - BCNF - 多值依赖和4NF
    - 数据依赖的公理系统 - 模式分解
- 数据库设计
    - 数据字典
    - 概念模型
    - E-R模型及其扩充
- 数据库编程
    - 嵌入式SQL：处理过程，通信（游标，动态SQL）
    - 过程化SQL
    - 存储过程和函数
    - ODBC编程
- 关系查询处理和查询优化
    - 查询处理步骤，优化
    - 代数优化，物理优化
- 数据库恢复技术
    - 事务概念和特点 - 恢复概述 - 故障种类，恢复技术和策略
    - 并发控制

整理的不是特别全乎，不过也涵盖不少了。往年大题就那几道，题型相对固定，针对性做题，做会题就算复习完了。

上面的知识点里边特别重要的就那几个：**关系代数，关系完整性，SQL，关系数据理论和事务与并发，查询优化**这几个。其他零碎的小知识点有印象就行了。

复习方法一是做题，最好是看答案；二是看例子，例题，然后递归复习知识点，效率最高。三是下策，先看知识点，再做题，适合开始复习比较早，时间充裕的情况，也是最充分的复习，但是问题是容易动力不足。

## SQL
### CREATE,DROP,ALTER
```sql
CREATE SCHEMA <"name"> AUTHORIZATION "username";
DROP SCHEMA "name" [CASCADE/RESTRICT];
CREATE TABLE "name"
{   Col1 VARCHAR(10) PRIMARY KEY,
    Col2 NUMBER(10) NOT NULL UNIQUE,
    Col3 INT FOREIGN KEY(Sno) REFERENCES TABLE2(Sno),
    CHECK(Col1 > 1 AND Col1 < 10)
};
CREATE TABLE schema.tablename{
    // 同上
};
CREATE SCHEMA "name" AUTHORIZATION "user" CREATE TABLE "table1"
{
    // 同上
};
ALTER TABLE "name" [ADD COLUMN name VARCHAR(10) |
                    ADD UNIQUE(Cname) |
                    ADD FOREIGN KEY(Cno) REFERENCES Student(Cno) |
                    DROP Col1 CASCADE|RESTRICT
                    DROP CONSTRAINT “completeness” CASCADE|RESTRICT
                    ALTER COLUMN Col1 VARCHAR(114514)
];
DROP TABLE "name" CASCADE|RESTRICT;
```
### INDEX
```sql
CREATE UNIQUE|CLUSTER INDEX "index_name" ON tableName(Col1 DESC, Col2 ASC);
ALTER INDX "old_index" RENAME TO "new_index";
DROP INDEX "index_name";
```
### SELECT
```sql
SELECT [DISTINCT|ALL] 2022-table1.age,table2.Sname
FROM ["table1" | "view1"]
WHERE age>5 AND|OR age<7 AND Sdept='CS' AND age [NOT]  BETWEEN 20 AND 30 AND Sdept IN('CS','MA') AND name LIKE '张____' AND GRADE IS NULL
GROUP BY Col2 HAVING AVG(Grade)>=90
ORDER BY Col1 DESC;
```
连接查询时，列举全部属性列，去掉相同的列就是自然连接。

单表连接查询：
```sql
FROM Course.FIRST, Course.SECOND
SELECT FIRST.Cno, SECOND.Cpno
WHERE FIRST.Cpno=SECOND.Cno;
//外连接查询
FROM table1 LEFT|RIGHT OUTER JOIN table2 ON|USING(table1.sno=table2.sno) // USING去重
```

`%_`任意字符、一个字符，汉字**长两个字符**

子查询使用`IN`关键字，阅读/构造时从内部构造。下面的例子相当于是将子查询的结果作为父查询的语句的参数了。
```sql
SELECT Sno, Sname, Sdept
FROM Student
WHERE Sdept IN (
    SELECT Sdept
    FROM Student
    WHERE Sname='lex'
) AND xxx;
```

还有`EXISTS`子查询，跟上边`IN`差不多，不过意思是将”至少存在一个查询结果“作为查询选择器的条件。

多个查询可以用`UNION,, INTERSECT, EXCEPT`分别进行并，交，差三个集合运算，目标的数据结构必须相同。
### INSERT,UPDATE,DELETE
```sql
INSERT INTO table(Col1, Col2) [
    VALUES(1,2,3,'4') | 
    SELECT xxx FROM xxx WHERE xxx GROUP BY xxx
];

UPDATE table
SET Col1=xxx
WHERE cond;

DELETE
FROM table
WHERE cond;
```
### VIEW
```sql
CREATE VIEW vname(Col1,Coln)
AS 子查询
[WITH CHECK OPTION]
GROUP BY xxx;
```

```sql
DROP VIEW vname CASCADE
```
### 空值
```sql 
xxx IS [NOT] NULL
```
