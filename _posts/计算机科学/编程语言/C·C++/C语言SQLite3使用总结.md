---
title: C语言SQLite3使用总结
date: '2022.11.22 20:14:44'
author: xeonds
toc: true
excerpt: 大一大作业那会用了一次
categories:
  - 计算机科学
  - 编程语言
  - C·C++
---

转载网址：[查看](http://blog.chinaunix.net/uid-8447633-id-3321394.html)

前序：

Sqlite3 的确很好用。小巧、速度快。但是因为非微软的产品，帮助文档总觉得不够。这些天再次研究它，又有一些收获，这里把我对 sqlite3 的研究列出来，以备忘记。

这里要注明，我是一个跨平台专注者，并不喜欢只用 windows 平台。我以前的工作就是为 unix 平台写代码。下面我所写的东西，虽然没有验证，但是我已尽量不使用任何 windows 的东西，只使用标准 C 或标准C++。但是，我没有尝试过在别的系统、别的编译器下编译，因此下面的叙述如果不正确，则留待以后修改。

下面我的代码仍然用 VC 编写，因为我觉得VC是一个很不错的IDE，可以加快代码编写速度（例如配合 Vassist ）。下面我所说的编译环境，是VC2003。如果读者觉得自己习惯于 unix 下用 vi 编写代码速度较快，可以不用管我的说明，只需要符合自己习惯即可，因为我用的是标准 C 或 C++ 。不会给任何人带来不便。

## 一、版本

从 [www.sqlite.org](http://www.sqlite.org/) 网站可下载到最新的 sqlite 代码和编译版本。我写此文章时，最新代码是 3.3.17 版本。

很久没有去下载 sqlite 新代码，因此也不知道 sqlite 变化这么大。以前很多文件，现在全部合并成一个 sqlite3.c 文件。如果单独用此文件，是挺好的，省去拷贝一堆文件还担心有没有遗漏。但是也带来一个问题：此文件太大，快接近7万行代码，VC开它整个机器都慢下来了。如果不需要改它代码，也就不需要打开 sqlite3.c 文件，机器不会慢。但是，下面我要写通过修改 sqlite 代码完成加密功能，那时候就比较痛苦了。如果个人水平较高，建议用些简单的编辑器来编辑，例如UltraEdit 或 Notepad 。速度会快很多。

## 二、基本编译

这个不想多说了，在 VC 里新建 dos 控制台空白工程，把 sqlite3.c 和 sqlite3.h 添加到工程，再新建一个 main.cpp文件。在里面写:

```c
extern "C"

{

#include "./sqlite3.h"

};

int main( int , char** )

{

return 0;

}
```

为什么要 extern “C” ？如果问这个问题，我不想说太多，这是C++的基础。要在 C++ 里使用一段 C 的代码，必须要用 extern “C” 括起来。C++跟 C虽然语法上有重叠，但是它们是两个不同的东西，内存里的布局是完全不同的，在C++编译器里不用extern “C”括起C代码，会导致编译器不知道该如何为 C 代码描述内存布局。

可能在 sqlite3.c 里人家已经把整段代码都 extern “C” 括起来了，但是你遇到一个 .c 文件就自觉的再括一次，也没什么不好。

基本工程就这样建立起来了。编译，可以通过。但是有一堆的 warning。可以不管它。

## 三、SQLITE操作入门

sqlite提供的是一些C函数接口，你可以用这些函数操作数据库。通过使用这些接口，传递一些标准 sql 语句（以 char * 类型）给 sqlite 函数，sqlite 就会为你操作数据库。

sqlite 跟MS的access一样是文件型数据库，就是说，一个数据库就是一个文件，此数据库里可以建立很多的表，可以建立索引、触发器等等，但是，它实际上得到的就是一个文件。备份这个文件就备份了整个数据库。

sqlite 不需要任何数据库引擎，这意味着如果你需要 sqlite 来保存一些用户数据，甚至都不需要安装数据库(如果你做个小软件还要求人家必须装了sqlserver 才能运行，那也太黑心了)。

下面开始介绍数据库基本操作。

1 基本流程（1）关键数据结构

sqlite 里最常用到的是 sqlite3 * 类型。从数据库打开开始，sqlite就要为这个类型准备好内存，直到数据库关闭，整个过程都需要用到这个类型。当数据库打开时开始，这个类型的变量就代表了你要操作的数据库。下面再详细介绍。

（2）打开数据库

int sqlite3_open( 文件名, sqlite3 ** );

用这个函数开始数据库操作。

需要传入两个参数，一是数据库文件名，比如：c://DongChunGuang_Database.db。

文件名不需要一定存在，如果此文件不存在，sqlite 会自动建立它。如果它存在，就尝试把它当数据库文件来打开。

sqlite3 ** 参数即前面提到的关键数据结构。这个结构底层细节如何，你不要关它。

函数返回值表示操作是否正确，如果是 SQLITE_OK 则表示操作正常。相关的返回值sqlite定义了一些宏。具体这些宏的含义可以参考 sqlite3.h 文件。里面有详细定义（顺便说一下，sqlite3 的代码注释率自称是非常高的，实际上也的确很高。只要你会看英文，sqlite 可以让你学到不少东西）。

下面介绍关闭数据库后，再给一段参考代码。

（3）关闭数据库

```c
int sqlite3_close(sqlite3 *);
```

前面如果用 sqlite3_open 开启了一个数据库，结尾时不要忘了用这个函数关闭数据库。

下面给段简单的代码：

```c
extern "C"

{

#include "./sqlite3.h"

};

int main( int , char** )

{

   sqlite3 * db = NULL; //声明sqlite关键结构指针

   int result;

//打开数据库

//需要传入 db 这个指针的指针，因为 sqlite3_open 函数要为这个指针分配内存，还要让db指针指向这个内存区

   result = sqlite3_open( “c://Dcg_database.db”, &db );

   if( result != SQLITE_OK )

   {

    //数据库打开失败

return -1;

}

//数据库操作代码

//…

//数据库打开成功

//关闭数据库

sqlite3_close( db );

return 0;

}
```

这就是一次数据库操作过程。

2 SQL语句操作

本节介绍如何用sqlite 执行标准 sql 语法。

（1）执行sql语句

```c
int sqlite3_exec(sqlite3*, const char *sql, sqlite3_callback, void *,  char **errmsg );
```

这就是执行一条 sql 语句的函数。

第1个参数不再说了，是前面open函数得到的指针。说了是关键数据结构。

第2个参数const char *sql 是一条 sql 语句，以/0结尾。

第3个参数sqlite3_callback 是回调，当这条语句执行之后，sqlite3会去调用你提供的这个函数。（什么是回调函数，自己找别的资料学习）

第4个参数void * 是你所提供的指针，你可以传递任何一个指针参数到这里，这个参数最终会传到回调函数里面，如果不需要传递指针给回调函数，可以填NULL。等下我们再看回调函数的写法，以及这个参数的使用。

第5个参数char ** errmsg 是错误信息。注意是指针的指针。sqlite3里面有很多固定的错误信息。执行 sqlite3_exec 之后，执行失败时可以查阅这个指针（直接 printf(“%s/n”,errmsg)）得到一串字符串信息，这串信息告诉你错在什么地方。sqlite3_exec函数通过修改你传入的指针的指针，把你提供的指针指向错误提示信息，这样sqlite3_exec函数外面就可以通过这个 char*得到具体错误提示。

说明：通常，sqlite3_callback 和它后面的 void * 这两个位置都可以填 NULL。填NULL表示你不需要回调。比如你做insert 操作，做 delete 操作，就没有必要使用回调。而当你做 select 时，就要使用回调，因为 sqlite3 把数据查出来，得通过回调告诉你查出了什么数据。

（2）exec 的回调

```c
typedef int (*sqlite3_callback)(void*,int,char**, char**);
```

你的回调函数必须定义成上面这个函数的类型。下面给个简单的例子：

```c
//sqlite3的回调函数      

// sqlite 每查到一条记录，就调用一次这个回调

int LoadMyInfo( void * para, int n_column, char ** column_value, char ** column_name )

{

   //para是你在 sqlite3_exec 里传入的 void * 参数

   //通过para参数，你可以传入一些特殊的指针（比如类指针、结构指针），然后在这里面强制转换成对应的类型（这里面是void*类型，必须强制转换成你的类型才可用）。然后操作这些数据

   //n_column是这一条记录有多少个字段 (即这条记录有多少列)

   // char ** column_value 是个关键值，查出来的数据都保存在这里，它实际上是个1维数组（不要以为是2维数组），每一个元素都是一个 char * 值，是一个字段内容（用字符串来表示，以/0结尾）

   //char ** column_name 跟 column_value是对应的，表示这个字段的字段名称

    //这里，我不使用 para 参数。忽略它的存在.

    int i;

printf( “记录包含 %d 个字段/n”, n_column );

for( i = 0 ; i < n_column; i ++ )

{

    printf( “字段名:%s  ß> 字段值:%s/n”,  column_name[i], column_value[i] );

}

printf( “------------------/n“ );        

return 0;

}

int main( int , char ** )

{

    sqlite3 * db;

    int result;

    char * errmsg = NULL;

    result = sqlite3_open( “c://Dcg_database.db”, &db );

    if( result != SQLITE_OK )

    {

        //数据库打开失败

return -1;

}

//数据库操作代码

//创建一个测试表，表名叫 MyTable_1，有2个字段： ID 和 name。其中ID是一个自动增加的类型，以后insert时可以不去指定这个字段，它会自己从0开始增加

result = sqlite3_exec( db, “create table MyTable_1( ID integer primary key autoincrement, name nvarchar(32) )”, NULL, NULL, errmsg );

if(result != SQLITE_OK )

{

    printf( “创建表失败，错误码:%d，错误原因:%s/n”, result, errmsg );

}

//插入一些记录

result = sqlite3_exec( db, “insert into MyTable_1( name ) values ( ‘走路’ )”, 0, 0, errmsg );

if(result != SQLITE_OK )

{

    printf( “插入记录失败，错误码:%d，错误原因:%s/n”, result, errmsg );

}

result = sqlite3_exec( db, “insert into MyTable_1( name ) values ( ‘骑单车’ )”, 0, 0, errmsg );

if(result != SQLITE_OK )

{

    printf( “插入记录失败，错误码:%d，错误原因:%s/n”, result, errmsg );

}

result = sqlite3_exec( db, “insert into MyTable_1( name ) values ( ‘坐汽车’ )”, 0, 0, errmsg );

if(result != SQLITE_OK )

{

    printf( “插入记录失败，错误码:%d，错误原因:%s/n”, result, errmsg );

}

//开始查询数据库

result = sqlite3_exec( db, “select * from MyTable_1”, LoadMyInfo, NULL, errmsg );

//关闭数据库

sqlite3_close( db );

return 0;

}
```

通过上面的例子，应该可以知道如何打开一个数据库，如何做数据库基本操作。

有这些知识，基本上可以应付很多数据库操作了。

（3）不使用回调查询数据库

上面介绍的 sqlite3_exec 是使用回调来执行 select 操作。还有一个方法可以直接查询而不需要回调。但是，我个人感觉还是回调好，因为代码可以更加整齐，只不过用回调很麻烦，你得声明一个函数，如果这个函数是类成员函数，你还不得不把它声明成 static 的（要问为什么？这又是C++基础了。C++成员函数实际上隐藏了一个参数：this，C++调用类的成员函数的时候，隐含把类指针当成函数的第一个参数传递进去。结果，这造成跟前面说的 sqlite 回调函数的参数不相符。只有当把成员函数声明成 static 时，它才没有多余的隐含的this参数）。

虽然回调显得代码整齐，但有时候你还是想要非回调的 select 查询。这可以通过 sqlite3_get_table 函数做到。

```c
int sqlite3_get_table(sqlite3*, const char *sql, char ***resultp, int *nrow, int *ncolumn, char **errmsg );
```

第1个参数不再多说，看前面的例子。

第2个参数是 sql 语句，跟 sqlite3_exec 里的 sql 是一样的。是一个很普通的以/0结尾的char *字符串。

第3个参数是查询结果，它依然一维数组（不要以为是二维数组，更不要以为是三维数组）。它内存布局是：第一行是字段名称，后面是紧接着是每个字段的值。下面用例子来说事。

第4个参数是查询出多少条记录（即查出多少行）。

第5个参数是多少个字段（多少列）。

第6个参数是错误信息，跟前面一样，这里不多说了。

下面给个简单例子:

```c
int main( int , char ** )

{

   sqlite3 * db;

   int result;

   char * errmsg = NULL;

   char **dbResult; //是 char ** 类型，两个*号

   int nRow, nColumn;

   int i , j;

   int index;

   result = sqlite3_open( “c://Dcg_database.db”, &db );

   if( result != SQLITE_OK )

   {

        //数据库打开失败

        return -1;

   }

   //数据库操作代码

   //假设前面已经创建了 MyTable_1 表

   //开始查询，传入的 dbResult 已经是 char **，这里又加了一个 & 取地址符，传递进去的就成了 char ***

   result = sqlite3_get_table( db, “select * from MyTable_1”, &dbResult, &nRow, &nColumn, &errmsg );

   if( SQLITE_OK == result )

   {

        //查询成功

        index = nColumn; //前面说过 dbResult 前面第一行数据是字段名称，从 nColumn 索引开始才是真正的数据

        printf( “查到%d条记录/n”, nRow );

        for(  i = 0; i < nRow ; i++ )

        {

             printf( “第 %d 条记录/n”, i+1 );

             for( j = 0 ; j < nColumn; j++ )

             {

                  printf( “字段名:%s  ß> 字段值:%s/n”,  dbResult[j], dbResult [index] );

                  ++index; // dbResult 的字段值是连续的，从第0索引到第 nColumn - 1索引都是字段名称，从第 nColumn 索引开始，后面都是字段值，它把一个二维的表（传统的行列表示法）用一个扁平的形式来表示

             }

             printf( “-------/n” );

        }

   }

   //到这里，不论数据库查询是否成功，都释放 char** 查询结果，使用 sqlite 提供的功能来释放

   sqlite3_free_table( dbResult );

   //关闭数据库

   sqlite3_close( db );

   return 0;

}
```

到这个例子为止，sqlite3 的常用用法都介绍完了。

用以上的方法，再配上 sql 语句，完全可以应付绝大多数数据库需求。

但有一种情况，用上面方法是无法实现的：需要insert、select 二进制。当需要处理二进制数据时，上面的方法就没办法做到。下面这一节说明如何插入二进制数据

3 操作二进制

sqlite 操作二进制数据需要用一个辅助的数据类型：sqlite3_stmt * 。

这个数据类型记录了一个“sql语句”。为什么我把 “sql语句” 用双引号引起来？因为你可以把 sqlite3_stmt * 所表示的内容看成是 sql语句，但是实际上它不是我们所熟知的sql语句。它是一个已经把sql语句解析了的、用sqlite自己标记记录的内部数据结构。

正因为这个结构已经被解析了，所以你可以往这个语句里插入二进制数据。当然，把二进制数据插到 sqlite3_stmt 结构里可不能直接 memcpy ，也不能像 std::string 那样用 + 号。必须用 sqlite 提供的函数来插入。

（1）写入二进制

下面说写二进制的步骤。

要插入二进制，前提是这个表的字段的类型是 blob 类型。我假设有这么一张表：

```c
create table Tbl_2( ID integer, file_content  blob )
```

首先声明

```c
sqlite3_stmt * stat;
```

然后，把一个 sql 语句解析到 stat 结构里去：

```c
sqlite3_prepare( db, “insert into Tbl_2( ID, file_content) values( 10, ? )”, -1, &stat, 0 );
```

上面的函数完成 sql 语句的解析。第一个参数跟前面一样，是个 sqlite3 * 类型变量，第二个参数是一个 sql 语句。

这个 sql 语句特别之处在于 values 里面有个 ? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。

第三个参数我写的是-1，这个参数含义是前面 sql 语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以/0结尾的字符串）。

第四个参数是 sqlite3_stmt 的指针的指针。解析以后的sql语句就放在这个结构里。

第五个参数我也不知道是干什么的。为0就可以了。

如果这个函数执行成功（返回值是 SQLITE_OK 且 stat 不为NULL ），那么下面就可以开始插入二进制数据。

```c
sqlite3_bind_blob( stat, 1, pdata, (int)(length_of_data_in_bytes), NULL ); // pdata为数据缓冲区，length_of_data_in_bytes为数据大小，以字节为单位
```

这个函数一共有5个参数。

第1个参数：是前面prepare得到的 sqlite3_stmt * 类型变量。

第2个参数：?号的索引。前面prepare的sql语句里有一个?号，假如有多个?号怎么插入？方法就是改变 bind_blob 函数第2个参数。这个参数我写1，表示这里插入的值要替换 stat 的第一个?号（这里的索引从1开始计数，而非从0开始）。如果你有多个?号，就写多个 bind_blob 语句，并改变它们的第2个参数就替换到不同的?号。如果有?号没有替换，sqlite为它取值null。

第3个参数：二进制数据起始指针。

第4个参数：二进制数据的长度，以字节为单位。

第5个参数：是个析够回调函数，告诉sqlite当把数据处理完后调用此函数来析够你的数据。这个参数我还没有使用过，因此理解也不深刻。但是一般都填NULL，需要释放的内存自己用代码来释放。

bind完了之后，二进制数据就进入了你的“sql语句”里了。你现在可以把它保存到数据库里：

```c
int result = sqlite3_step( stat );
```

通过这个语句，stat 表示的sql语句就被写到了数据库里。

最后，要把 sqlite3_stmt 结构给释放：

```c
sqlite3_finalize( stat ); //把刚才分配的内容析构掉
```

（2）读出二进制

下面说读二进制的步骤。

跟前面一样，先声明 sqlite3_stmt * 类型变量：

```c
sqlite3_stmt * stat;
```

然后，把一个 sql 语句解析到 stat 结构里去：

```c
sqlite3_prepare( db, “select * from Tbl_2”, -1, &stat, 0 );
```

当 prepare 成功之后（返回值是 SQLITE_OK ），开始查询数据。

```c
int result = sqlite3_step( stat );
```

这一句的返回值是SQLITE_ROW 时表示成功（不是 SQLITE_OK ）。

你可以循环执行sqlite3_step 函数，一次step查询出一条记录。直到返回值不为 SQLITE_ROW 时表示查询结束。

然后开始获取第一个字段：ID 的值。ID是个整数，用下面这个语句获取它的值：

```c
int id = sqlite3_column_int( stat, 0 ); //第2个参数表示获取第几个字段内容，从0开始计算，因为我的表的ID字段是第一个字段，因此这里我填0
```

下面开始获取 file_content 的值，因为 file_content 是二进制，因此我需要得到它的指针，还有它的长度：

```c
const void * pFileContent = sqlite3_column_blob( stat, 1 );

int len = sqlite3_column_bytes( stat, 1 );
```

这样就得到了二进制的值。

把 pFileContent 的内容保存出来之后，不要忘了释放 sqlite3_stmt 结构：

```c
sqlite3_finalize( stat ); //把刚才分配的内容析构掉
```

（3）重复使用 sqlite3_stmt 结构

如果你需要重复使用 sqlite3_prepare 解析好的 sqlite3_stmt 结构，需要用函数： sqlite3_reset。

```c
result = sqlite3_reset(stat);
```

这样， stat 结构又成为 sqlite3_prepare 完成时的状态，你可以重新为它 bind 内容。

4 事务处理

sqlite 是支持事务处理的。如果你知道你要同步删除很多数据，不仿把它们做成一个统一的事务。

通常一次 sqlite3_exec 就是一次事务，如果你要删除1万条数据，sqlite就做了1万次：开始新事务->删除一条数据->提交事务->开始新事务->… 的过程。这个操作是很慢的。因为时间都花在了开始事务、提交事务上。

你可以把这些同类操作做成一个事务，这样如果操作错误，还能够回滚事务。

事务的操作没有特别的接口函数，它就是一个普通的 sql 语句而已：

分别如下：

```c
int result; 

result = sqlite3_exec( db, "begin transaction", 0, 0, &zErrorMsg ); //开始一个事务

result = sqlite3_exec( db, "commit transaction", 0, 0, &zErrorMsg ); //提交事务

result = sqlite3_exec( db, "rollback transaction", 0, 0, &zErrorMsg ); //回滚事务
```

## 四、C/C++开发接口简介1 总览

SQLite3是SQLite一个全新的版本,它虽然是在SQLite 2.8.13的代码基础之上开发的,但是使用了和之前的版本不兼容的数据库格式和API. SQLite3是为了满足以下的需求而开发的:

- 支持UTF-16编码.
- 用户自定义的文本排序方法.
- 可以对BLOBs字段建立索引.

因此为了支持这些特性我改变了数据库的格式,建立了一个与之前版本不兼容的3.0版. 至于其他的兼容性的改变,例如全新的API等等,都将在理论介绍之后向你说明,这样可以使你最快的一次性摆脱兼容性问题.

3.0版的和2.X版的API非常相似,但是有一些重要的改变需要注意. 所有API接口函数和数据结构的前缀都由"sqlite_"改为了"sqlite3_". 这是为了避免同时使用SQLite 2.X和SQLite 3.0这两个版本的时候发生链接冲突.

由于对于C语言应该用什么数据类型来存放UTF-16编码的字符串并没有一致的规范. 因此SQLite使用了普通的void*类型来指向UTF-16编码的字符串. 客户端使用过程中可以把void*映射成适合他们的系统的任何数据类型.

2 C/C++接口

SQLite 3.0一共有83个API函数,此外还有一些数据结构和预定义(#defines). (完整的API介绍请参看另一份文档.) 不过你们可以放心,这些接口使用起来不会像它的数量所暗示的那么复杂. 最简单的程序仍然使用三个函数就可以完成: sqlite3_open(), sqlite3_exec(), 和 sqlite3_close(). 要是想更好的控制数据库引擎的执行,可以使用提供的sqlite3_prepare()函数把SQL语句编译成字节码,然后在使用sqlite3_step()函数来执行编译后的字节码. 以sqlite3_column_开头的一组API函数用来获取查询结果集中的信息. 许多接口函数都是成对出现的,同时有UTF-8和UTF-16两个版本. 并且提供了一组函数用来执行用户自定义的SQL函数和文本排序函数.

（1）如何打开关闭数据库

```c
   typedef struct sqlite3 sqlite3;

   int sqlite3_open(const char*, sqlite3**);

   int sqlite3_open16(const void*, sqlite3**);

   int sqlite3_close(sqlite3*);

   const char *sqlite3_errmsg(sqlite3*);

   const void *sqlite3_errmsg16(sqlite3*);

   int sqlite3_errcode(sqlite3*);
```

sqlite3_open() 函数返回一个整数错误代码,而不是像第二版中一样返回一个指向sqlite3结构体的指针. sqlite3_open() 和sqlite3_open16() 的不同之处在于sqlite3_open16() 使用UTF-16编码(使用本地主机字节顺序)传递数据库文件名. 如果要创建新数据库, sqlite3_open16() 将内部文本转换为UTF-16编码, 反之sqlite3_open() 将文本转换为UTF-8编码.

打开或者创建数据库的命令会被缓存,直到这个数据库真正被调用的时候才会被执行. 而且允许使用PRAGMA声明来设置如本地文本编码或默认内存页面大小等选项和参数.

sqlite3_errcode() 通常用来获取最近调用的API接口返回的错误代码. sqlite3_errmsg() 则用来得到这些错误代码所对应的文字说明. 这些错误信息将以 UTF-8 的编码返回,并且在下一次调用任何SQLite API函数的时候被清除. sqlite3_errmsg16() 和sqlite3_errmsg() 大体上相同,除了返回的错误信息将以 UTF-16 本机字节顺序编码.

SQLite3的错误代码相比SQLite2没有任何的改变,它们分别是:

```c
#define SQLITE_OK           0   /* Successful result */

#define SQLITE_ERROR        1   /* SQL error or missing database */

#define SQLITE_INTERNAL     2   /* An internal logic error in SQLite */

#define SQLITE_PERM         3   /* Access permission denied */

#define SQLITE_ABORT        4   /* Callback routine requested an abort */

#define SQLITE_BUSY         5   /* The database file is locked */

#define SQLITE_LOCKED       6   /* A table in the database is locked */

#define SQLITE_NOMEM        7   /* A malloc() failed */

#define SQLITE_READONLY     8   /* Attempt to write a readonly database */

#define SQLITE_INTERRUPT    9   /* Operation terminated by sqlite_interrupt() */

#define SQLITE_IOERR       10   /* Some kind of disk I/O error occurred */

#define SQLITE_CORRUPT     11   /* The database disk image is malformed */

#define SQLITE_NOTFOUND    12   /* (Internal Only) Table or record not found */

#define SQLITE_FULL        13   /* Insertion failed because database is full */

#define SQLITE_CANTOPEN    14   /* Unable to open the database file */

#define SQLITE_PROTOCOL    15   /* Database lock protocol error */

#define SQLITE_EMPTY       16   /* (Internal Only) Database table is empty */

#define SQLITE_SCHEMA      17   /* The database schema changed */

#define SQLITE_TOOBIG      18   /* Too much data for one row of a table */

#define SQLITE_CONSTRAINT  19   /* Abort due to contraint violation */

#define SQLITE_MISMATCH    20   /* Data type mismatch */

#define SQLITE_MISUSE      21   /* Library used incorrectly */

#define SQLITE_NOLFS       22   /* Uses OS features not supported on host */

#define SQLITE_AUTH        23   /* Authorization denied */

#define SQLITE_ROW         100  /* sqlite_step() has another row ready */

#define SQLITE_DONE        101  /* sqlite_step() has finished executing */
```

（2）执行 SQL 语句

```c
typedef int (*sqlite_callback)(void*,int,char**, char**);

int sqlite3_exec(sqlite3*, const char *sql, sqlite_callback, void*, char**);
```

sqlite3_exec 函数依然像它在SQLite2中一样承担着很多的工作. 该函数的第二个参数中可以编译和执行零个或多个SQL语句. 查询的结果返回给回调函数. 更多地信息可以查看API 参考.

在SQLite3里,sqlite3_exec一般是被准备SQL语句接口封装起来使用的.

```c
typedef struct sqlite3_stmt sqlite3_stmt;

int sqlite3_prepare(sqlite3*, const char*, int, sqlite3_stmt**, const char**);

int sqlite3_prepare16(sqlite3*, const void*, int, sqlite3_stmt**, const void**);

int sqlite3_finalize(sqlite3_stmt*);

int sqlite3_reset(sqlite3_stmt*);
```

sqlite3_prepare 接口把一条SQL语句编译成字节码留给后面的执行函数. 使用该接口访问数据库是当前比较好的的一种方法.

sqlite3_prepare() 处理的SQL语句应该是UTF-8编码的. 而sqlite3_prepare16() 则要求是UTF-16编码的. 输入的参数中只有第一个SQL语句会被编译. 第四个参数则用来指向输入参数中下一个需要编译的SQL语句存放的SQLite statement对象的指针,任何时候如果调用 sqlite3_finalize() 将销毁一个准备好的SQL声明. 在数据库关闭之前，所有准备好的声明都必须被释放销毁. sqlite3_reset() 函数用来重置一个SQL声明的状态，使得它可以被再次执行.

SQL声明可以包含一些型如"?" 或 "?nnn" 或 ":aaa"的标记， 其中"nnn" 是一个整数，"aaa" 是一个字符串. 这些标记代表一些不确定的字符值（或者说是通配符），可以在后面用sqlite3_bind 接口来填充这些值. 每一个通配符都被分配了一个编号（由它在SQL声明中的位置决定，从1开始），此外也可以用 "nnn" 来表示 "?nnn" 这种情况. 允许相同的通配符在同一个SQL声明中出现多次, 在这种情况下所有相同的通配符都会被替换成相同的值. 没有被绑定的通配符将自动取NULL值.

```c
int sqlite3_bind_blob(sqlite3_stmt*, int, const void*, int n, void(*)(void*));

int sqlite3_bind_double(sqlite3_stmt*, int, double);

int sqlite3_bind_int(sqlite3_stmt*, int, int);

int sqlite3_bind_int64(sqlite3_stmt*, int, long long int);

int sqlite3_bind_null(sqlite3_stmt*, int);

int sqlite3_bind_text(sqlite3_stmt*, int, const char*, int n, void(*)(void*));

int sqlite3_bind_text16(sqlite3_stmt*, int, const void*, int n, void(*)(void*));

int sqlite3_bind_value(sqlite3_stmt*, int, const sqlite3_value*);
```

以上是 sqlite3_bind 所包含的全部接口，它们是用来给SQL声明中的通配符赋值的. 没有绑定的通配符则被认为是空值.绑定上的值不会被sqlite3_reset()函数重置. 但是在调用了sqlite3_reset()之后所有的通配符都可以被重新赋值.

在SQL声明准备好之后(其中绑定的步骤是可选的), 需要调用以下的方法来执行:

```c
int sqlite3_step(sqlite3_stmt*);
```

如果SQL返回了一个单行结果集，sqlite3_step() 函数将返回 SQLITE_ROW , 如果SQL语句执行成功或者正常将返回SQLITE_DONE , 否则将返回错误代码. 如果不能打开数据库文件则会返回 SQLITE_BUSY . 如果函数的返回值是SQLITE_ROW, 那么下边的这些方法可以用来获得记录集行中的数据:

```c
const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);

int sqlite3_column_bytes(sqlite3_stmt*, int iCol);

int sqlite3_column_bytes16(sqlite3_stmt*, int iCol);

int sqlite3_column_count(sqlite3_stmt*);

const char *sqlite3_column_decltype(sqlite3_stmt *, int iCol);

const void *sqlite3_column_decltype16(sqlite3_stmt *, int iCol);

double sqlite3_column_double(sqlite3_stmt*, int iCol);

int sqlite3_column_int(sqlite3_stmt*, int iCol);

long long int sqlite3_column_int64(sqlite3_stmt*, int iCol);

const char *sqlite3_column_name(sqlite3_stmt*, int iCol);

const void *sqlite3_column_name16(sqlite3_stmt*, int iCol);

const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);

const void *sqlite3_column_text16(sqlite3_stmt*, int iCol);

int sqlite3_column_type(sqlite3_stmt*, int iCol);
```

sqlite3_column_count()函数返回结果集中包含的列数. sqlite3_column_count() 可以在执行了 sqlite3_prepare()之后的任何时刻调用. sqlite3_data_count()除了必需要在sqlite3_step()之后调用之外，其他跟sqlite3_column_count() 大同小异. 如果调用sqlite3_step() 返回值是 SQLITE_DONE 或者一个错误代码, 则此时调用sqlite3_data_count() 将返回 0 ，然而sqlite3_column_count() 仍然会返回结果集中包含的列数.

返回的记录集通过使用其它的几个 sqlite3_column_***() 函数来提取, 所有的这些函数都把列的编号作为第二个参数. 列编号从左到右以零起始. 请注意它和之前那些从1起始的参数的不同.

sqlite3_column_type()函数返回第N列的值的数据类型. 具体的返回值如下:

```c
#define SQLITE_INTEGER  1

#define SQLITE_FLOAT    2

#define SQLITE_TEXT     3

#define SQLITE_BLOB     4

#define SQLITE_NULL     5
```

sqlite3_column_decltype() 则用来返回该列在 CREATE TABLE 语句中声明的类型. 它可以用在当返回类型是空字符串的时候. sqlite3_column_name() 返回第N列的字段名. sqlite3_column_bytes() 用来返回 UTF-8 编码的BLOBs列的字节数或者TEXT字符串的字节数. sqlite3_column_bytes16() 对于BLOBs列返回同样的结果，但是对于TEXT字符串则按 UTF-16 的编码来计算字节数. sqlite3_column_blob() 返回 BLOB 数据. sqlite3_column_text() 返回 UTF-8 编码的 TEXT 数据. sqlite3_column_text16() 返回 UTF-16 编码的 TEXT 数据. sqlite3_column_int() 以本地主机的整数格式返回一个整数值. sqlite3_column_int64() 返回一个64位的整数. 最后, sqlite3_column_double() 返回浮点数.

不一定非要按照sqlite3_column_type()接口返回的数据类型来获取数据. 数据类型不同时软件将自动转换.

（3）用户自定义函数

可以使用以下的方法来创建用户自定义的SQL函数:

```c
typedef struct sqlite3_value sqlite3_value;

int sqlite3_create_function(

     sqlite3 *,

     const char *zFunctionName,

     int nArg,

     int eTextRep,

     void*,

     void (*xFunc)(sqlite3_context*,int,sqlite3_value**),

     void (*xStep)(sqlite3_context*,int,sqlite3_value**),

     void (*xFinal)(sqlite3_context*)

   );

   int sqlite3_create_function16(

     sqlite3*,

     const void *zFunctionName,

     int nArg,

     int eTextRep,

     void*,

     void (*xFunc)(sqlite3_context*,int,sqlite3_value**),

     void (*xStep)(sqlite3_context*,int,sqlite3_value**),

     void (*xFinal)(sqlite3_context*)

   );

   #define SQLITE_UTF8     1

   #define SQLITE_UTF16    2

   #define SQLITE_UTF16BE  3

   #define SQLITE_UTF16LE  4

   #define SQLITE_ANY      5
```

nArg 参数用来表明自定义函数的参数个数. 如果参数值为0，则表示接受任意个数的参数. 用 eTextRep 参数来表明传入参数的编码形式. 参数值可以是上面的五种预定义值. SQLite3 允许同一个自定义函数有多种不同的编码参数的版本. 数据库引擎会自动选择转换参数编码个数最少的版本使用.

普通的函数只需要设置 xFunc 参数，而把 xStep 和 xFinal 设为NULL. 聚合函数则需要设置 xStep 和 xFinal 参数，然后把 xFunc 设为NULL. 该方法和使用sqlite3_create_aggregate() API一样.

sqlite3_create_function16()和sqlite_create_function()的不同就在于自定义的函数名一个要求是 UTF-16 编码，而另一个则要求是 UTF-8.

请注意自定函数的参数目前使用了sqlite3_value结构体指针替代了SQLite version 2.X中的字符串指针. 下面的函数用来从sqlite3_value结构体中提取数据:

```c
   const void *sqlite3_value_blob(sqlite3_value*);

   int sqlite3_value_bytes(sqlite3_value*);

   int sqlite3_value_bytes16(sqlite3_value*);

   double sqlite3_value_double(sqlite3_value*);

   int sqlite3_value_int(sqlite3_value*);

   long long int sqlite3_value_int64(sqlite3_value*);

   const unsigned char *sqlite3_value_text(sqlite3_value*);

   const void *sqlite3_value_text16(sqlite3_value*);

   int sqlite3_value_type(sqlite3_value*);
```

上面的函数调用以下的API来获得上下文内容和返回结果:

```c
   void *sqlite3_aggregate_context(sqlite3_context*, int nbyte);

   void *sqlite3_user_data(sqlite3_context*);

   void sqlite3_result_blob(sqlite3_context*, const void*, int n, void(*)(void*));

   void qlite3_result_double(sqlite3_context*, double);

   void sqlite3_result_error(sqlite3_context*, const char*, int);

   void sqlite3_result_error16(sqlite3_context*, const void*, int);

   void sqlite3_result_int(sqlite3_context*, int);

   void sqlite3_result_int64(sqlite3_context*, long long int);

   void sqlite3_result_null(sqlite3_context*);

   void sqlite3_result_text(sqlite3_context*, const char*, int n, void(*)(void*)); 

  void sqlite3_result_text16(sqlite3_context*, const void*, int n, void(*)(void*));

   void sqlite3_result_value(sqlite3_context*, sqlite3_value*);

   void *sqlite3_get_auxdata(sqlite3_context*, int);

   void sqlite3_set_auxdata(sqlite3_context*, int, void*, void (*)(void*));
```

（4）用户自定义排序规则

下面的函数用来实现用户自定义的排序规则:

```c
sqlite3_create_collation(sqlite3*, const char *zName, int eTextRep, void*,

int(*xCompare)(void*,int,const void*,int,const void*));

sqlite3_create_collation16(sqlite3*, const void *zName, int eTextRep, void*,

int(*xCompare)(void*,int,const void*,int,const void*));

sqlite3_collation_needed(sqlite3*, void*,

void(*)(void*,sqlite3*,int eTextRep,const char*));

sqlite3_collation_needed16(sqlite3*, void*,

void(*)(void*,sqlite3*,int eTextRep,const void*));
```

sqlite3_create_collation() 函数用来声明一个排序序列和实现它的比较函数. 比较函数只能用来做文本的比较. eTextRep 参数可以取如下的预定义值 SQLITE_UTF8, SQLITE_UTF16LE, SQLITE_UTF16BE, SQLITE_ANY，用来表示比较函数所处理的文本的编码方式. 同一个自定义的排序规则的同一个比较函数可以有 UTF-8, UTF-16LE 和 UTF-16BE 等多个编码的版本. sqlite3_create_collation16()和sqlite3_create_collation() 的区别也仅仅在于排序名称的编码是 UTF-16 还是 UTF-8.

可以使用 sqlite3_collation_needed() 函数来注册一个回调函数，当数据库引擎遇到未知的排序规则时会自动调用该函数. 在回调函数中可以查找一个相似的比较函数，并激活相应的sqlite_3_create_collation()函数. 回调函数的第四个参数是排序规则的名称，同样sqlite3_collation_needed采用 UTF-8 编码. sqlite3_collation_need16() 采用 UTF-16 编码.

## 五、给数据库加密

前面所说的内容网上已经有很多资料，虽然比较零散，但是花点时间也还是可以找到的。现在要说的这个——数据库加密，资料就很难找。也可能是我操作水平不够，找不到对应资料。但不管这样，我还是通过网上能找到的很有限的资料，探索出了给sqlite数据库加密的完整步骤。

这里要提一下，虽然 sqlite 很好用，速度快、体积小巧。但是它保存的文件却是明文的。若不信可以用 NotePad 打开数据库文件瞧瞧，里面 insert 的内容几乎一览无余。这样赤裸裸的展现自己，可不是我们的初衷。当然，如果你在嵌入式系统、智能手机上使用 sqlite，最好是不加密，因为这些系统运算能力有限，你做为一个新功能提供者，不能把用户有限的运算能力全部花掉。

Sqlite为了速度而诞生。因此Sqlite本身不对数据库加密，要知道，如果你选择标准AES算法加密，那么一定有接近50%的时间消耗在加解密算法上，甚至更多（性能主要取决于你算法编写水平以及你是否能使用cpu提供的底层运算能力，比如MMX或sse系列指令可以大幅度提升运算速度）。

Sqlite免费版本是不提供加密功能的，当然你也可以选择他们的收费版本，那你得支付2000块钱，而且是USD。我这里也不是说支付钱不好，如果只为了数据库加密就去支付2000块，我觉得划不来。因为下面我将要告诉你如何为免费的Sqlite扩展出加密模块——自己动手扩展，这是Sqlite允许，也是它提倡的。

那么，就让我们一起开始为 sqlite3.c 文件扩展出加密模块。

1 必要的宏

通过阅读 Sqlite 代码（当然没有全部阅读完，6万多行代码，没有一行是我习惯的风格，我可没那么多眼神去看），我搞清楚了两件事：

Sqlite是支持加密扩展的；

需要 #define 一个宏才能使用加密扩展。

这个宏就是  SQLITE_HAS_CODEC。

你在代码最前面（也可以在 sqlite3.h 文件第一行）定义：

```c
#ifndef SQLITE_HAS_CODEC

#define SQLITE_HAS_CODEC

#endif
```

如果你在代码里定义了此宏，但是还能够正常编译，那么应该是操作没有成功。因为你应该会被编译器提示有一些函数无法链接才对。如果你用的是 VC 2003，你可以在“解决方案”里右键点击你的工程，然后选“属性”，找到“C/C++”，再找到“命令行”，在里面手工添加“/D "SQLITE_HAS_CODEC"”。

定义了这个宏，一些被 Sqlite 故意屏蔽掉的代码就被使用了。这些代码就是加解密的接口。

尝试编译，vc会提示你有一些函数无法链接，因为找不到他们的实现。

如果你也用的是VC2003，那么会得到下面的提示：

```c
error LNK2019: 无法解析的外部符号 _sqlite3CodecGetKey ，该符号在函数 _attachFunc 中被引用

error LNK2019: 无法解析的外部符号 _sqlite3CodecAttach ，该符号在函数 _attachFunc 中被引用

error LNK2019: 无法解析的外部符号 _sqlite3_activate_see ，该符号在函数 _sqlite3Pragma 中被引用

error LNK2019: 无法解析的外部符号 _sqlite3_key ，该符号在函数 _sqlite3Pragma 中被引用

fatal error LNK1120: 4 个无法解析的外部命令
```

这是正常的，因为Sqlite只留了接口而已，并没有给出实现。

下面就让我来实现这些接口。

2自己实现加解密接口函数

如果真要我从一份 [www.sqlite.org](http://www.sqlite.org/) 网上down下来的 sqlite3.c 文件，直接摸索出这些接口的实现，我认为我还没有这个能力。

好在网上还有一些代码已经实现了这个功能。通过参照他们的代码以及不断编译中vc给出的错误提示，最终我把整个接口整理出来。

实现这些预留接口不是那么容易，要重头说一次怎么回事很困难。我把代码都写好了，直接把他们按我下面的说明拷贝到 sqlite3.c 文件对应地方即可。我在下面也提供了sqlite3.c 文件，可以直接参考或取下来使用。

这里要说一点的是，我另外新建了两个文件：crypt.c和crypt.h。

其中crypt.h如此定义：

```c
#ifndef  DCG_SQLITE_CRYPT_FUNC_

#define  DCG_SQLITE_CRYPT_FUNC_

/***********

董淳光写的 SQLITE 加密关键函数库

***********/

/***********

关键加密函数

***********/

int My_Encrypt_Func( unsigned char * pData, unsigned int data_len, const char * key, unsigned int len_of_key );

/***********

关键解密函数

***********/

int My_DeEncrypt_Func( unsigned char * pData, unsigned int data_len, const char * key, unsigned intlen_of_key );

#endif
```

其中的 crypt.c 如此定义：

```c
#include "./crypt.h"

#include "memory.h"

/***********

关键加密函数

***********/

int My_Encrypt_Func( unsigned char * pData, unsigned int data_len, const char * key, unsigned int len_of_key )

{

return 0;

}

/***********

关键解密函数

***********/

int My_DeEncrypt_Func( unsigned char * pData, unsigned int data_len, const char * key, unsigned intlen_of_key )

{

return 0;

}
```

这个文件很容易看，就两函数，一个加密一个解密。传进来的参数分别是待处理的数据、数据长度、密钥、密钥长度。

处理时直接把结果作用于 pData 指针指向的内容。

你需要定义自己的加解密过程，就改动这两个函数，其它部分不用动。扩展起来很简单。

这里有个特点，data_len 一般总是 1024 字节。正因为如此，你可以在你的算法里使用一些特定长度的加密算法，比如AES要求被加密数据一定是128位（16字节）长。这个1024不是碰巧，而是 Sqlite 的页定义是1024字节，在sqlite3.c文件里有定义:

```c
# define SQLITE_DEFAULT_PAGE_SIZE 1024
```

你可以改动这个值，不过还是建议没有必要不要去改它。

上面写了两个扩展函数，如何把扩展函数跟 Sqlite 挂接起来，这个过程说起来比较麻烦。我直接贴代码。

分3个步骤。

首先，在 sqlite3.c 文件顶部，添加下面内容：

```c
#ifdef SQLITE_HAS_CODEC

#include "./crypt.h"

/***********

用于在 sqlite3 最后关闭时释放一些内存

***********/

void sqlite3pager_free_codecarg(void *pArg);

#endif
```

这个函数之所以要在 sqlite3.c 开头声明，是因为下面在 sqlite3.c 里面某些函数里要插入这个函数调用。所以要提前声明。

其次，在sqlite3.c文件里搜索“sqlite3PagerClose”函数，要找到它的实现代码（而不是声明代码）。

实现代码里一开始是：

```c
#ifdef SQLITE_ENABLE_MEMORY_MANAGEMENT

  /* A malloc() cannot fail in sqlite3ThreadData() as one or more calls to

  ** malloc() must have already been made by this thread before it gets

  ** to this point. This means the ThreadData must have been allocated already

  ** so that ThreadData.nAlloc can be set.

  */

  ThreadData *pTsd = sqlite3ThreadData();

  assert( pPager );

  assert( pTsd && pTsd->nAlloc );

#endif
```

需要在这部分后面紧接着插入：

```c
#ifdef SQLITE_HAS_CODEC

  sqlite3pager_free_codecarg(pPager->pCodecArg);

#endif
```

这里要注意，sqlite3PagerClose 函数大概也是 3.3.17版本左右才改名的，以前版本里是叫 “sqlite3pager_close”。因此你在老版本sqlite代码里搜索“sqlite3PagerClose”是搜不到的。

类似的还有“sqlite3pager_get”、“sqlite3pager_unref”、“sqlite3pager_write”、“sqlite3pager_pagecount”等都是老版本函数，它们在 pager.h 文件里定义。新版本对应函数是在 sqlite3.h 里定义（因为都合并到 sqlite3.c和sqlite3.h两文件了）。所以，如果你在使用老版本的sqlite，先看看 pager.h 文件，这些函数不是消失了，也不是新蹦出来的，而是老版本函数改名得到的。

最后，往sqlite3.c 文件下找。找到最后一行：

```c
/************** End of main.c ************************************************/
```

在这一行后面，接上本文最下面的代码段。

这些代码很长，我不再解释，直接接上去就得了。

唯一要提的是 DeriveKey 函数。这个函数是对密钥的扩展。比如，你要求密钥是128位，即是16字节，但是如果用户只输入 1个字节呢？2个字节呢？或输入50个字节呢？你得对密钥进行扩展，使之符合16字节的要求。

DeriveKey 函数就是做这个扩展的。有人把接收到的密钥求md5，这也是一个办法，因为md5运算结果固定16字节，不论你有多少字符，最后就是16字节。这是md5算法的特点。但是我不想用md5，因为还得为它添加包含一些 md5 的.c或.cpp文件。我不想这么做。我自己写了一个算法来扩展密钥，很简单的算法。当然，你也可以使用你的扩展方法，也而可以使用md5 算法。只要修改 DeriveKey 函数就可以了。

在 DeriveKey 函数里，只管申请空间构造所需要的密钥，不需要释放，因为在另一个函数里有释放过程，而那个函数会在数据库关闭时被调用。参考我的 DeriveKey 函数来申请内存。

这里我给出我已经修改好的 sqlite3.c 和 sqlite3.h 文件。

如果太懒，就直接使用这两个文件，编译肯定能通过，运行也正常。当然，你必须按我前面提的，新建 crypt.h 和crypt.c 文件，而且函数要按我前面定义的要求来做。

3 加密使用方法

现在，你代码已经有了加密功能。

你要把加密功能给用上，除了改 sqlite3.c 文件、给你工程添加 SQLITE_HAS_CODEC 宏，还得修改你的数据库调用函数。

前面提到过，要开始一个数据库操作，必须先 sqlite3_open 。

加解密过程就在 sqlite3_open 后面操作。

假设你已经 sqlite3_open 成功了，紧接着写下面的代码：

```c
     int i;

//添加、使用密码       

     i =  sqlite3_key( db, "dcg", 3 );

     //修改密码

     i =  sqlite3_rekey( db, "dcg", 0 );
```

用 sqlite3_key 函数来提交密码。

第1个参数是 sqlite3 * 类型变量，代表着用 sqlite3_open 打开的数据库（或新建数据库）。

第2个参数是密钥。

第3个参数是密钥长度。

用 sqlite3_rekey 来修改密码。参数含义同 sqlite3_key。

实际上，你可以在sqlite3_open函数之后，到 sqlite3_close 函数之前任意位置调用 sqlite3_key 来设置密码。

但是如果你没有设置密码，而数据库之前是有密码的，那么你做任何操作都会得到一个返回值：SQLITE_NOTADB，并且得到错误提示：“file is encrypted or is not a database”。

只有当你用 sqlite3_key 设置了正确的密码，数据库才会正常工作。

如果你要修改密码，前提是你必须先 sqlite3_open 打开数据库成功，然后 sqlite3_key 设置密钥成功，之后才能用sqlite3_rekey 来修改密码。

如果数据库有密码，但你没有用 sqlite3_key 设置密码，那么当你尝试用 sqlite3_rekey 来修改密码时会得到SQLITE_NOTADB 返回值。

如果你需要清空密码，可以使用：

```c
//修改密码

i =  sqlite3_rekey( db, NULL, 0 );
```

来完成密码清空功能。

4 sqlite3.c 最后添加代码段

```c
/***

董淳光定义的加密函数

***/

#ifdef SQLITE_HAS_CODEC

/***

加密结构

***/

#define CRYPT_OFFSET 8

typedef struct _CryptBlock

{

BYTE*     ReadKey;     // 读数据库和写入事务的密钥

BYTE*     WriteKey;    // 写入数据库的密钥

int       PageSize;    // 页的大小

BYTE*     Data;

} CryptBlock, *LPCryptBlock;

#ifndef  DB_KEY_LENGTH_BYTE         /*密钥长度*/

#define  DB_KEY_LENGTH_BYTE   16   /*密钥长度*/

#endif

#ifndef  DB_KEY_PADDING             /*密钥位数不足时补充的字符*/

#define  DB_KEY_PADDING       0x33  /*密钥位数不足时补充的字符*/

#endif

/*** 下面是编译时提示缺少的函数 ***/

/** 这个函数不需要做任何处理，获取密钥的部分在下面 DeriveKey 函数里实现 **/

void sqlite3CodecGetKey(sqlite3* db, int nDB, void** Key, int* nKey)

{

return ;

}

/*被sqlite 和 sqlite3_key_interop 调用, 附加密钥到数据库.*/

int sqlite3CodecAttach(sqlite3 *db, int nDb, const void *pKey, int nKeyLen);

/**

这个函数好像是 sqlite 3.3.17前不久才加的，以前版本的sqlite里没有看到这个函数

这个函数我还没有搞清楚是做什么的，它里面什么都不做直接返回，对加解密没有影响

**/

void sqlite3_activate_see(const char* right )

{   

return;

}

int sqlite3_key(sqlite3 *db, const void *pKey, int nKey);

int sqlite3_rekey(sqlite3 *db, const void *pKey, int nKey);

/***

下面是上面的函数的辅助处理函数

***/

// 从用户提供的缓冲区中得到一个加密密钥

// 用户提供的密钥可能位数上满足不了要求，使用这个函数来完成密钥扩展

static unsigned char * DeriveKey(const void *pKey, int nKeyLen);

//创建或更新一个页的加密算法索引.此函数会申请缓冲区.

static LPCryptBlock CreateCryptBlock(unsigned char* hKey, Pager *pager, LPCryptBlock pExisting);

//加密/解密函数, 被pager调用

void * sqlite3Codec(void *pArg, unsigned char *data, Pgno nPageNum, int nMode);

//设置密码函数

int __stdcall sqlite3_key_interop(sqlite3 *db, const void *pKey, int nKeySize);

// 修改密码函数

int __stdcall sqlite3_rekey_interop(sqlite3 *db, const void *pKey, int nKeySize);

//销毁一个加密块及相关的缓冲区,密钥.

static void DestroyCryptBlock(LPCryptBlock pBlock);

static void * sqlite3pager_get_codecarg(Pager *pPager);

void sqlite3pager_set_codec(Pager *pPager,void *(*xCodec)(void*,void*,Pgno,int),void *pCodecArg    );

//加密/解密函数, 被pager调用

void * sqlite3Codec(void *pArg, unsigned char *data, Pgno nPageNum, int nMode)

{

LPCryptBlock pBlock = (LPCryptBlock)pArg;

unsigned int dwPageSize = 0;

if (!pBlock) return data;

// 确保pager的页长度和加密块的页长度相等.如果改变,就需要调整.

if (nMode != 2)

{

     PgHdr *pageHeader;

     pageHeader = DATA_TO_PGHDR(data);

     if (pageHeader->pPager->pageSize != pBlock->PageSize)

     {

          CreateCryptBlock(0, pageHeader->pPager, pBlock);

     }

}

switch(nMode)

{

case 0: // Undo a "case 7" journal file encryption

case 2: //重载一个页

case 3: //载入一个页

     if (!pBlock->ReadKey) break;

     dwPageSize = pBlock->PageSize;

     My_DeEncrypt_Func(data, dwPageSize, pBlock->ReadKey, DB_KEY_LENGTH_BYTE );  /*调用我的解密函数*/

     break;

case 6: //加密一个主数据库文件的页

     if (!pBlock->WriteKey) break;

     memcpy(pBlock->Data + CRYPT_OFFSET, data, pBlock->PageSize);

     data = pBlock->Data + CRYPT_OFFSET;

     dwPageSize = pBlock->PageSize;

     My_Encrypt_Func(data , dwPageSize, pBlock->WriteKey, DB_KEY_LENGTH_BYTE ); /*调用我的加密函数*/

     break;

case 7: //加密事务文件的页

     /*在正常环境下, 读密钥和写密钥相同. 当数据库是被重新加密的,读密钥和写密钥未必相同.

     回滚事务必要用数据库文件的原始密钥写入.因此,当一次回滚被写入,总是用数据库的读密钥,

     这是为了保证与读取原始数据的密钥相同.

     */

     if (!pBlock->ReadKey) break;

     memcpy(pBlock->Data + CRYPT_OFFSET, data, pBlock->PageSize);

     data = pBlock->Data + CRYPT_OFFSET;

     dwPageSize = pBlock->PageSize;

     My_Encrypt_Func( data, dwPageSize, pBlock->ReadKey, DB_KEY_LENGTH_BYTE ); /*调用我的加密函数*/

     break;

}

return data;

}

//销毁一个加密块及相关的缓冲区,密钥.

static void DestroyCryptBlock(LPCryptBlock pBlock)

{

//销毁读密钥.

if (pBlock->ReadKey){

     sqliteFree(pBlock->ReadKey);

}

//如果写密钥存在并且不等于读密钥,也销毁.

if (pBlock->WriteKey && pBlock->WriteKey != pBlock->ReadKey){

     sqliteFree(pBlock->WriteKey);

}

if(pBlock->Data){

     sqliteFree(pBlock->Data);

}

//释放加密块.

sqliteFree(pBlock);

}

static void * sqlite3pager_get_codecarg(Pager *pPager)

{

return (pPager->xCodec) ? pPager->pCodecArg: NULL;

}

// 从用户提供的缓冲区中得到一个加密密钥

static unsigned char * DeriveKey(const void *pKey, int nKeyLen)

{

unsigned char *  hKey = NULL;

int j;

if( pKey == NULL || nKeyLen == 0 )

{

     return NULL;

}

hKey = sqliteMalloc( DB_KEY_LENGTH_BYTE + 1 );

if( hKey == NULL )

{

     return NULL;

}

hKey[ DB_KEY_LENGTH_BYTE ] = 0;

if( nKeyLen < DB_KEY_LENGTH_BYTE )

{

     memcpy( hKey, pKey, nKeyLen ); //先拷贝得到密钥前面的部分

     j = DB_KEY_LENGTH_BYTE - nKeyLen;

     //补充密钥后面的部分

     memset(  hKey + nKeyLen,  DB_KEY_PADDING, j  );

}

else

{ //密钥位数已经足够,直接把密钥取过来

     memcpy(  hKey, pKey, DB_KEY_LENGTH_BYTE );

}

return hKey;

}

//创建或更新一个页的加密算法索引.此函数会申请缓冲区.

static LPCryptBlock CreateCryptBlock(unsigned char* hKey, Pager *pager, LPCryptBlock pExisting)

{

LPCryptBlock pBlock;

if (!pExisting) //创建新加密块

{

     pBlock = sqliteMalloc(sizeof(CryptBlock));

     memset(pBlock, 0, sizeof(CryptBlock));

     pBlock->ReadKey = hKey;

     pBlock->WriteKey = hKey;

     pBlock->PageSize = pager->pageSize;

     pBlock->Data = (unsigned char*)sqliteMalloc(pBlock->PageSize + CRYPT_OFFSET);

}

else //更新存在的加密块

{

     pBlock = pExisting;

     if ( pBlock->PageSize != pager->pageSize && !pBlock->Data){

          sqliteFree(pBlock->Data);

          pBlock->PageSize = pager->pageSize;

          pBlock->Data = (unsigned char*)sqliteMalloc(pBlock->PageSize + CRYPT_OFFSET);

     }

}

memset(pBlock->Data, 0, pBlock->PageSize + CRYPT_OFFSET);

return pBlock;

}

/*

** Set the codec for this pager

*/

void sqlite3pager_set_codec(

                             Pager *pPager,

                             void *(*xCodec)(void*,void*,Pgno,int),

                             void *pCodecArg

                             )

{

pPager->xCodec = xCodec;

pPager->pCodecArg = pCodecArg;

}

int sqlite3_key(sqlite3 *db, const void *pKey, int nKey)

{

return sqlite3_key_interop(db, pKey, nKey);

}

int sqlite3_rekey(sqlite3 *db, const void *pKey, int nKey)

{

return sqlite3_rekey_interop(db, pKey, nKey);

}

/*被sqlite 和 sqlite3_key_interop 调用, 附加密钥到数据库.*/

int sqlite3CodecAttach(sqlite3 *db, int nDb, const void *pKey, int nKeyLen)

{

    int rc = SQLITE_ERROR;

    unsigned char* hKey = 0;

    //如果没有指定密匙,可能标识用了主数据库的加密或没加密.

    if (!pKey || !nKeyLen)

    {

        if (!nDb)

        {

            return SQLITE_OK; //主数据库, 没有指定密钥所以没有加密.

        }

        else //附加数据库,使用主数据库的密钥.

        {

            //获取主数据库的加密块并复制密钥给附加数据库使用

            LPCryptBlock pBlock = (LPCryptBlock)sqlite3pager_get_codecarg(sqlite3BtreePager(db->aDb[0].pBt));

            if (!pBlock) return SQLITE_OK; //主数据库没有加密

            if (!pBlock->ReadKey) return SQLITE_OK; //没有加密

            memcpy(pBlock->ReadKey, &hKey, 16);

        }

    }

    else //用户提供了密码,从中创建密钥.

    {

        hKey = DeriveKey(pKey, nKeyLen);

    }

    //创建一个新的加密块,并将解码器指向新的附加数据库.

    if (hKey)

    {

        LPCryptBlock pBlock = CreateCryptBlock(hKey, sqlite3BtreePager(db->aDb[nDb].pBt), NULL);

        sqlite3pager_set_codec(sqlite3BtreePager(db->aDb[nDb].pBt), sqlite3Codec, pBlock);

        rc = SQLITE_OK;

    }

    return rc;

}

// Changes the encryption key for an existing database.

int __stdcall sqlite3_rekey_interop(sqlite3 *db, const void *pKey, int nKeySize)

{

Btree *pbt = db->aDb[0].pBt;

Pager *p = sqlite3BtreePager(pbt);

LPCryptBlock pBlock = (LPCryptBlock)sqlite3pager_get_codecarg(p);

unsigned char * hKey = DeriveKey(pKey, nKeySize);

int rc = SQLITE_ERROR;

if (!pBlock && !hKey) return SQLITE_OK;

//重新加密一个数据库,改变pager的写密钥, 读密钥依旧保留.

if (!pBlock) //加密一个未加密的数据库

{

     pBlock = CreateCryptBlock(hKey, p, NULL);

     pBlock->ReadKey = 0; // 原始数据库未加密

     sqlite3pager_set_codec(sqlite3BtreePager(pbt), sqlite3Codec, pBlock);

}

else // 改变已加密数据库的写密钥

{

     pBlock->WriteKey = hKey;

}

// 开始一个事务

rc = sqlite3BtreeBeginTrans(pbt, 1);

if (!rc)

{

     // 用新密钥重写所有的页到数据库。

     Pgno nPage = sqlite3PagerPagecount(p);

     Pgno nSkip = PAGER_MJ_PGNO(p);

     void *pPage;

     Pgno n;

     for(n = 1; rc == SQLITE_OK && n <= nPage; n ++)

     {

          if (n == nSkip) continue;

          rc = sqlite3PagerGet(p, n, &pPage);

          if(!rc)

          {

               rc = sqlite3PagerWrite(pPage);

               sqlite3PagerUnref(pPage);

          }

     }

}

// 如果成功，提交事务。

if (!rc)

{

     rc = sqlite3BtreeCommit(pbt);

}

// 如果失败，回滚。

if (rc)

{

     sqlite3BtreeRollback(pbt);

}

// 如果成功，销毁先前的读密钥。并使读密钥等于当前的写密钥。

if (!rc)

{

     if (pBlock->ReadKey)

     {

          sqliteFree(pBlock->ReadKey);

     }

     pBlock->ReadKey = pBlock->WriteKey;

}

else// 如果失败，销毁当前的写密钥，并恢复为当前的读密钥。

{

     if (pBlock->WriteKey)

     {

          sqliteFree(pBlock->WriteKey);

     }

     pBlock->WriteKey = pBlock->ReadKey;

}

// 如果读密钥和写密钥皆为空，就不需要再对页进行编解码。

// 销毁加密块并移除页的编解码器

if (!pBlock->ReadKey && !pBlock->WriteKey)

{

     sqlite3pager_set_codec(p, NULL, NULL);

     DestroyCryptBlock(pBlock);

}

return rc;

}

/***

下面是加密函数的主体

***/

int __stdcall sqlite3_key_interop(sqlite3 *db, const void *pKey, int nKeySize)

{

  return sqlite3CodecAttach(db, 0, pKey, nKeySize);

}

// 释放与一个页相关的加密块

void sqlite3pager_free_codecarg(void *pArg)

{

if (pArg)

     DestroyCryptBlock((LPCryptBlock)pArg);

}

#endif //#ifdef SQLITE_HAS_CODEC
```

## 五、性能优化

很多人直接就使用了，并未注意到SQLite也有配置参数，可以对性能进行调整。有时候，产生的结果会有很大影响。

主要通过pragma指令来实现。

比如： 空间释放、磁盘同步、Cache大小等。

不要打开。前文提高了，Vacuum的效率非常低！

1 auto_vacuum

```c
PRAGMA auto_vacuum;   
PRAGMA auto_vacuum = 0 | 1;
```

查询或设置数据库的auto-vacuum标记。

正常情况下，当提交一个从数据库中删除数据的事务时，数据库文件不改变大小。未使用的文件页被标记并在以后的添加操作中再次使用。这种情况下使用VACUUM命令释放删除得到的空间。

当开启auto-vacuum，当提交一个从数据库中删除数据的事务时，数据库文件自动收缩， (VACUUM命令在auto-vacuum开启的数据库中不起作用)。数据库会在内部存储一些信息以便支持这一功能，这使得数据库文件比不开启该选项时稍微大一些。

只有在数据库中未建任何表时才能改变auto-vacuum标记。试图在已有表的情况下修改不会导致报错。

2 cache_size

建议改为8000

```c
PRAGMA cache_size;   
PRAGMA cache_size = Number-of-pages;
```

查询或修改SQLite一次存储在内存中的数据库文件页数。每页使用约1.5K内存，缺省的缓存大小是2000. 若需要使用改变大量多行的UPDATE或DELETE命令，并且不介意SQLite使用更多的内存的话，可以增大缓存以提高性能。

当使用cache_size pragma改变缓存大小时，改变仅对当前对话有效，当数据库关闭重新打开时缓存大小恢复到缺省大小。 要想永久改变缓存大小，使用[default_cache_size](http://www.jimmydong.com/blog/) pragma.

3 case_sensitive_like

打开。不然搜索中文字串会出错。

```c
PRAGMA case_sensitive_like;   
PRAGMA case_sensitive_like = 0 | 1;
```

LIKE运算符的缺省行为是忽略latin1字符的大小写。因此在缺省情况下'a' LIKE 'A'的值为真。可以通过打开case_sensitive_like pragma来改变这一缺省行为。当启用case_sensitive_like，'a' LIKE 'A'为假而 'a' LIKE 'a'依然为真。

4 count_changes

打开。便于调试

```c
PRAGMA count_changes;   
PRAGMA count_changes = 0 | 1;
```

查询或更改count-changes标记。正常情况下INSERT, UPDATE和DELETE语句不返回数据。 当开启count-changes，以上语句返回一行含一个整数值的数据——该语句插入，修改或删除的行数。 返回的行数不包括由触发器产生的插入，修改或删除等改变的行数。

5 page_size

```c
PRAGMA page_size;   
PRAGMA page_size = bytes;
```

查询或设置page-size值。只有在未创建数据库时才能设置page-size。页面大小必须是2的整数倍且大于等于512小于等于8192。 上限可以通过在编译时修改宏定义SQLITE_MAX_PAGE_SIZE的值来改变。上限的上限是32768.

6 synchronous

如果有定期备份的机制，而且少量数据丢失可接受，用OFF

```c
PRAGMA synchronous;   
PRAGMA synchronous = FULL; (2)   
PRAGMA synchronous = NORMAL; (1)   
PRAGMA synchronous = OFF; (0)
```

查询或更改"synchronous"标记的设定。第一种形式(查询)返回整数值。 当synchronous设置为FULL (2), SQLite数据库引擎在紧急时刻会暂停以确定数据已经写入磁盘。 这使系统崩溃或电源出问题时能确保数据库在重起后不会损坏。FULL synchronous很安全但很慢。 当synchronous设置为NORMAL, SQLite数据库引擎在大部分紧急时刻会暂停，但不像FULL模式下那么频繁。 NORMAL模式下有很小的几率(但不是不存在)发生电源故障导致数据库损坏的情况。但实际上，在这种情况下很可能你的硬盘已经不能使用，或者发生了其他的不可恢复的硬件错误。 设置为synchronous OFF (0)时，SQLite在传递数据给系统以后直接继续而不暂停。若运行SQLite的应用程序崩溃， 数据不会损伤，但在系统崩溃或写入数据时意外断电的情况下数据库可能会损坏。另一方面，在synchronous OFF时 一些操作可能会快50倍甚至更多。

在SQLite 2中，缺省值为NORMAL.而在3中修改为FULL.

7 temp_store

使用2，内存模式。

```c
PRAGMA temp_store;   
PRAGMA temp_store = DEFAULT; (0)   
PRAGMA temp_store = FILE; (1)   
PRAGMA temp_store = MEMORY; (2)
```

查询或更改"temp_store"参数的设置。当temp_store设置为DEFAULT (0),使用编译时的C预处理宏 TEMP_STORE来定义储存临时表和临时索引的位置。当设置为MEMORY (2)临时表和索引存放于内存中。 当设置为FILE (1)则存放于文件中。temp_store_directorypragma 可用于指定存放该文件的目录。当改变temp_store设置，所有已存在的临时表，索引，触发器及视图将被立即删除。

经测试，在类BBS应用上，通过以上调整，效率可以提高2倍以上。

## 六、后记

**（原文后记）**

写此教程，可不是一个累字能解释。

但是我还是觉得欣慰的，因为我很久以前就想写 sqlite 的教程，一来自己备忘，二而已造福大众，大家不用再走弯路。

本人第一次写教程，不足的地方请大家指出。

本文可随意转载、修改、引用。但无论是转载、修改、引用，都请附带我的名字：董淳光。以示对我劳动的肯定。
