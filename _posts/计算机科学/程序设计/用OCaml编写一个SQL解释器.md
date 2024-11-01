---
title: 用OCaml编写一个SQL解释器
date: 2024-05-13 23:01:35
author: xeonds
toc: true
excerpt: 鸽了好久，补上。
tags:
  - SQL
  - OCaml
---

## 词法&语法分析

这两部分使用ocamllex和ocamlyacc就能完成。手写parser和lexer也可以，lexer没啥说的，~~parser写个递归下降的版本应付一下也够用~~。下面贴一下代码

>说实话，抛开编译原理，只是写语法的话，还是很简单的。先写好token识别器，确定好语言由哪些单词组成，再写好结构化的语法定义，然后丢给lex/yacc/bison之类的东西让它照着编译原理给你codegen出来一个能用的lexer和parser就行。

首先是`lexer.mll`，这部分感觉基本跟ocaml的语法没啥区别：

```ocaml
{
open Parser

exception Lexing_error of string
}

let whitespace = [' ' '\t' '\n' '\r']+
let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let alphanum = alpha | digit

rule token = parse
  | whitespace { token lexbuf } (* Ignore whitespace *)
  | digit+ as num { INT (int_of_string num) }
  | digit+ "." digit* as num { FLOAT (float_of_string num) }
  | (alpha | '_') (alphanum | '_')* as id { 
    match String.lowercase_ascii id with
    | "create" -> CREATE 
    | "use"   -> USE 
    | "show"  -> SHOW 
    | "insert" -> INSERT 
    | "into"  -> INTO 
    | "select" -> SELECT 
    | "update" -> UPDATE 
    | "set"   -> SET 
    | "drop"  -> DROP 
    | "delete" -> DELETE 
    | "from"   -> FROM 
    | "where"  -> WHERE 
    | "exit"   -> EXIT 
    | "database" -> DATABASE 
    | "databases" -> DATABASES 
    | "tables" -> TABLES 
    | "table" -> TABLE 
    | "values" -> VALUES 
    | "join"  -> JOIN
    | "on"    -> ON
    | "as"    -> AS
    | "order" -> ORDER
    | "begin" -> BEGIN
    | "transaction" -> TRANSACTION
    | "commit" -> COMMIT
    | "rollback" -> ROLLBACK
    | "lock" -> LOCK
    | "unlock" -> UNLOCK
    | "view" -> VIEW
    | "index" -> INDEX
    | "log" -> LOG
    | "int" -> INT_TYPE 
    | "string" -> STRING_TYPE 
    | "float" -> FLOAT_TYPE 
    | "bool" -> BOOL_TYPE 
    | "and" -> AND 
    | "or" -> OR 
    | "not" -> NOT 
    | "true" -> BOOL true 
    | "false" -> BOOL false 
    | _ -> IDENTIFIER id
  }
  | '"'[^'"']*'"' as str { STRING (String.sub str 1 (String.length str - 2)) }
  | "*"     { STAR }
  | ","     { COMMA }
  | ";"     { SEMICOLON }
  | "."     { DOT }
  | "="     { EQUALS }
  | "<"     { LESS }
  | ">"     { GREATER }
  | "<="    { LESS_EQUAL }
  | ">="    { GREATER_EQUAL }
  | "<>"    { NOT_EQUAL }
  | "+"     { PLUS }
  | "-"     { MINUS }
  | "/"     { DIVIDE }
  | "%"     { MOD }
  | "("     { LPAREN }
  | ")"     { RPAREN }
  | eof     { EOF }
  | _ as c  { raise (Lexing_error (Printf.sprintf "Unexpected character: %c" c)) }
```

注释用`(* 注释 *)`分割。标头和标尾是会远原样复制到输出的部分，使用一对大括号包围起来，是可选部分。

然后是正则表达式，使用let定义。

接着是入口点定义，每个入口点都w会是一个接受n+1个参数的ocaml函数。

然后是`parser.mly`，语法也很简单，就不说了。

```ocaml
%{
  open Ast
%}

%token <string> IDENTIFIER
%token <int> INT
%token <string> STRING
%token <float> FLOAT
%token <bool> BOOL
%token CREATE USE SHOW INSERT INTO SELECT UPDATE SET DROP DELETE FROM WHERE EXIT
%token DATABASES DATABASE TABLES TABLE VALUES JOIN ON AS
%token BEGIN TRANSACTION COMMIT ROLLBACK LOCK UNLOCK
%token VIEW INDEX LOG
%token LPAREN RPAREN COMMA SEMICOLON
%token STAR DOT MOD EQUALS LESS GREATER LESS_EQUAL GREATER_EQUAL NOT_EQUAL PLUS MINUS TIMES DIVIDE
%token EOF
%token INT_TYPE STRING_TYPE FLOAT_TYPE BOOL_TYPE
%token AND OR NOT ORDER BY LIMIT

%start main
%type <Ast.expr> main

%% /* Grammar rules and actions */

main:
  | statement SEMICOLON { $1 }
  | EOF { Exit }

statement:
  | SELECT columns FROM IDENTIFIER opt_where { Select($2, $4, $5) }
  | CREATE DATABASE IDENTIFIER { CreateDatabase $3 }
  | USE DATABASE IDENTIFIER { UseDatabase $3 }
  | CREATE TABLE IDENTIFIER LPAREN table_columns RPAREN { CreateTable($3, $5) }
  | SHOW TABLES { ShowTables }
  | SHOW DATABASES { ShowDatabases }
  | INSERT INTO IDENTIFIER LPAREN columns RPAREN VALUES values { InsertInto($3, $5, $8) }
  | UPDATE IDENTIFIER SET IDENTIFIER EQUALS value opt_where { Update($2, $4, $6, $7) }
  | DELETE FROM IDENTIFIER opt_where { Delete($3, $4) }
  | DROP TABLE IDENTIFIER { DropTable $3 }
  | DROP DATABASE IDENTIFIER { DropDatabase $3 }
  | EXIT { Exit }

table_columns:
  | column_def COMMA table_columns { $1 :: $3 }
  | column_def { [$1] }

column_def:
  | IDENTIFIER data_type { ($1, $2) }

columns:
  | STAR { [] }
  | IDENTIFIER COMMA columns { $1 :: $3 }
  | IDENTIFIER { [$1] }

values:
  | LPAREN values_def RPAREN values { $2 :: $4 }
  | LPAREN values_def RPAREN { [$2] }

values_def:
  | value COMMA values_def { $1 :: $3 }
  | value { [$1] }

value:
  | INT { IntValue $1 }
  | STRING { StringValue $1 }
  | FLOAT { FloatValue $1 }
  | BOOL { BoolValue $1 }

data_type:
  | INT_TYPE { IntType }
  | STRING_TYPE { StringType }
  | FLOAT_TYPE { FloatType }
  | BOOL_TYPE { BoolType }

opt_where:
  | WHERE condition { Some $2 }
  | { None }

condition:
  | LPAREN condition RPAREN { $2 }
  | NOT condition { Not $2 }
  | condition AND condition { And($1, $3) }
  | condition OR condition { Or($1, $3) }
  | IDENTIFIER LESS value { LessThan($1, $3) }
  | IDENTIFIER GREATER value { GreaterThan($1, $3) }
  | IDENTIFIER LESS_EQUAL value { LessEqual($1, $3) }
  | IDENTIFIER GREATER_EQUAL value { GreaterEqual($1, $3) }
  | IDENTIFIER NOT_EQUAL value { NotEqual($1, $3) }
  | IDENTIFIER EQUALS value { Equal($1, $3) }
```

可以看出来我就没支持多少功能，是的~~因为我懒~~。

然后是上面提到的`ast.ml`，里面是各种类型声明，包括存储引擎的函数原型，存储引擎支持的数据类型和表达式的类型等：

```ocaml
type data_type = IntType | StringType | FloatType | BoolType

type value =
  | IntValue of int
  | StringValue of string
  | FloatValue of float
  | BoolValue of bool

type expr =
  | CreateDatabase of string
  | UseDatabase of string
  | CreateTable of string * (string * data_type) list
  | ShowTables
  | ShowDatabases
  | InsertInto of string * string list * value list list
  | Select of string list * string * (condition option)
  | Update of string * string * value * (condition option)
  | Delete of string * (condition option)
  | DropTable of string
  | DropDatabase of string
  | Exit
and condition =
  | LessThan of string * value
  | GreaterThan of string * value
  | LessEqual of string * value
  | GreaterEqual of string * value
  | NotEqual of string * value
  | Equal of string * value
  | And of condition * condition
  | Or of condition * condition
  | Not of condition
```

这部分也是简单写了下，没打算整太复杂的。

## 存储引擎

语义分析这部分的目的是为了codegen，不过我写的版本比较简单，就不考虑优化了。直接让系统去用存储引擎执行解析好的AST就ok。

每个语句对应的AST对存储引擎的调用方法都是在设计parser的时候设计好的。所以这部分没难度，最后产物的程序一定会按照你写的语法规则对应的结构去一个一个调用存储引擎的接口实现具体的存储功能。

虽然一次丢上来快300行的代码块比较谔谔，但是反正我注释也写的挺清楚的就这样吧（

```ocaml
open Ast

(* 当前使用的数据库路径 *)
let current_db = ref None

(* 创建数据库目录 *)
let create_database db_name =
  if Sys.file_exists db_name then
    Printf.printf "Database %s already exists.\n" db_name
  else
    Unix.mkdir db_name 0o755

(* 切换数据库 *)
let use_database db_name =
  if Sys.file_exists db_name && Sys.is_directory db_name then (
    current_db := Some db_name;
    Printf.printf "Switched to database %s.\n" db_name)
  else
    Printf.printf "Database %s does not exist.\n" db_name

(* 类型名转类型 *)
let type_of_name = function
  | "INT" -> IntType
  | "STRING" -> StringType
  | "FLOAT" -> FloatType
  | "BOOL" -> BoolType
  | _ -> raise (Invalid_argument "Invalid type")

(* 类型转类型名 *)
let name_of_type = function
  | IntType -> "INT"
  | StringType -> "STRING"
  | FloatType -> "FLOAT"
  | BoolType -> "BOOL"

(* 创建表（CSV文件） *)
let create_table table_name columns =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then
      Printf.printf "Table %s already exists.\n" table_name
    else
      let csv = Csv.to_channel (open_out table_path) in
      let col_names, col_types = List.split columns in
      Csv.output_record csv col_names;
      Csv.output_record csv (List.map(fun t -> match t with
        | IntType -> "INT"
        | StringType -> "STRING"
        | FloatType -> "FLOAT"
        | BoolType -> "BOOL") col_types);
      Csv.close_out csv
  | None -> Printf.printf "No database selected.\n"

(* 显示当前数据库中的表 *)
let show_tables () =
  match !current_db with
  | Some db_name -> let files = Sys.readdir db_name in Array.iter (fun f -> if Filename.check_suffix f ".csv" then Printf.printf "%s\n" (Filename.chop_suffix f ".csv")) files
  | None -> Printf.printf "No database selected.\n"

(* 显示所有数据库 *)
let show_databases () =
  match Sys.readdir "." with
  | files -> Array.iter (fun f -> if Sys.is_directory f then Printf.printf "%s\n" f) files
  | exception Sys_error msg -> Printf.printf "Error: %s\n" msg

(* 将value转换为字符串 *)
let string_of_value = function
  | IntValue v -> string_of_int v
  | StringValue v -> v
  | FloatValue v -> string_of_float v
  | BoolValue v -> string_of_bool v

(* 将字符串转换为value *)
let value_of_string = function
  | "true" -> BoolValue true
  | "false" -> BoolValue false
  | s -> match int_of_string_opt s with
    | Some i -> IntValue i
    | None -> match float_of_string_opt s with
      | Some f -> FloatValue f
      | None -> StringValue s
(* 获取字符串对应的数据的类型 *)
let type_of_string string = match value_of_string string with
  | IntValue _ -> IntType
  | StringValue _ -> StringType
  | FloatValue _ -> FloatType
  | BoolValue _ -> BoolType

(* 获取数据的类型 *)
let type_of_data data = match data with
  | IntValue _ -> IntType
  | StringValue _ -> StringType
  | FloatValue _ -> FloatType
  | BoolValue _ -> BoolType

(* 条件表达式求值，摆烂了 *)
let rec eval_cond cond row headers = match cond with
  | LessThan (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) < v
    | i, FloatValue v -> float_of_string (List.nth row i) < v
    | _, _ -> false)
  | GreaterThan (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) > v
    | i, FloatValue v -> float_of_string (List.nth row i) > v
    | _, _ -> false)
  | LessEqual (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) <= v
    | i, FloatValue v -> float_of_string (List.nth row i) <= v
    | _, _ -> false)
  | GreaterEqual (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) >= v
    | i, FloatValue v -> float_of_string (List.nth row i) >= v
    | _, _ -> false)
  | Equal (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) = v
    | i, FloatValue v -> float_of_string (List.nth row i) = v
    | i, StringValue v -> List.nth row i = v
    | i, BoolValue v -> bool_of_string (List.nth row i) = v)
  | NotEqual (col, value) -> (match List.assoc col (List.mapi (fun i h -> (h, i)) headers), value with
    | i, IntValue v -> int_of_string (List.nth row i) <> v
    | i, FloatValue v -> float_of_string (List.nth row i) <> v
    | i, StringValue v -> List.nth row i <> v
    | i, BoolValue v -> bool_of_string (List.nth row i) <> v)
  | And (cond1, cond2) -> (eval_cond cond1 row headers) && (eval_cond cond2 row headers)
  | Or (cond1, cond2) -> (eval_cond cond1 row headers) || (eval_cond cond2 row headers)
  | Not cond -> not (eval_cond cond row headers)

(* 插入数据到表中，校验了类型信息，支持默认填充空值 *)
let insert_into table_name columns values =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then
      let csvIn = Csv.of_channel (open_in table_path) in
      let csvOut = Csv.to_channel (open_out_gen [Open_append] 0o666 table_path) in
      let headers = Csv.next csvIn in
      let types = List.map2 (fun h t -> (h, type_of_name t)) headers (Csv.next csvIn) in
      List.iteri (fun row value -> Csv.output_record csvOut (List.map (fun header -> 
        match List.assoc_opt header (List.mapi (fun i h -> (h, i)) columns) with
        | Some index -> (
          let _,t = List.nth types index in
          let tt = type_of_data (List.nth value index) in 
          if t != tt then Printf.printf "Type mismatch for row %d, column %s\n; Replaced with default value" row header;
          if t == tt then string_of_value(List.nth value index)
            else string_of_value (match t with
              | IntType -> IntValue 0
              | FloatType -> FloatValue 0.0
              | StringType -> StringValue ""
              | BoolType -> BoolValue false))
        | None -> string_of_value (match List.assoc header types with
          | IntType -> IntValue 0
          | FloatType -> FloatValue 0.0
          | StringType -> StringValue ""
          | BoolType -> BoolValue false)) headers)) values;
      Csv.close_in csvIn;
      Csv.close_out csvOut;
    else Printf.printf "Table %s does not exist.\n" table_name
  | None -> Printf.printf "No database selected.\n"

(* 选择数据（简化实现，没做更细的校验了） *)
let select columns table_name condition =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then
      let csv = Csv.of_channel (open_in table_path) in
      (* Read header *)
      let headers = Csv.next csv in
      let _ = Csv.next csv in
      let col_indices = List.map (fun col -> List.assoc col (List.mapi (fun i h -> (h, i)) headers)) (match columns with 
        | [] -> headers
        | _ -> columns) in
      (* Filter and print rows *)
      Csv.iter ~f:(fun row ->
        let selected_values = List.map (fun i -> List.nth row i) col_indices in
        let row_match_cond = match condition with
          | None -> true
          | Some cond -> (eval_cond cond row headers) in
        if row_match_cond then Printf.printf "%s\n" (String.concat ", " selected_values)
        else ()) csv;
      Csv.close_in csv
    else Printf.printf "Table %s does not exist.\n" table_name
  | None -> Printf.printf "No database selected.\n"

(* 更新数据 *)
let update_table table_name column value condition =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then
      let data_origin = Csv.load table_path in
      let headers = List.hd data_origin in
      let types = List.hd (List.tl data_origin) in
      let records = List.tl (List.tl data_origin) in
      let col_index = List.assoc column (List.mapi (fun i h -> (h, i)) headers) in
      let data_updated = List.mapi (fun _ row -> 
        let row_match_cond = match condition with
          | None -> true
          | Some cond -> (eval_cond cond row headers) in
        if row_match_cond then List.mapi (fun j v -> if j == col_index then string_of_value value else v) row
        else row) records in
      let csv = Csv.to_channel (open_out table_path) in
      Csv.output_record csv headers;
      Csv.output_record csv types;
      List.iter (fun row -> Csv.output_record csv row) data_updated;
      Csv.close_out csv
    else Printf.printf "Table %s does not exist.\n" table_name
  | None -> Printf.printf "No database selected.\n"

(* 删除数据 *)
let delete_from table_name condition =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then
      let data_origin = Csv.load table_path in
      let headers = List.hd data_origin in
      let types = List.hd (List.tl data_origin) in
      let records = List.tl (List.tl data_origin) in
      let data_deleted = List.mapi (fun _ row -> if (
        match condition with
        | None -> true
        | Some cond -> (eval_cond cond row headers)
      ) then None else Some row) records in
      let csv = Csv.to_channel (open_out table_path) in
      Csv.output_record csv headers;
      Csv.output_record csv types;
      List.iter (fun row -> match row with
        | Some r -> Csv.output_record csv r
        | None -> ()) data_deleted;
      Csv.close_out csv
    else Printf.printf "Table %s does not exist.\n" table_name
  | None -> Printf.printf "No database selected.\n"

(* 删除数据库目录，慎用，路径注入利用会删不该删的东西 *)
let drop_database db_name =
  if Sys.file_exists db_name then
    Sys.command (Printf.sprintf "rm -rf %s" db_name) |> ignore
  else Printf.printf "Database %s does not exist.\n" db_name

(* 删除表（CSV文件）。同上 *)
let drop_table table_name =
  match !current_db with
  | Some db_name ->
    let table_path = Filename.concat db_name (table_name ^ ".csv") in
    if Sys.file_exists table_path then Sys.remove table_path
    else Printf.printf "Table %s does not exist.\n" table_name
  | None -> Printf.printf "No database selected.\n"

(* 退出程序 *)
let exit_program () =
  Printf.printf "Exiting...\n";
  exit 0

(* 表达式求值，根据表达式类型和表达式的参数列表调用相关的存储引擎实现 *)
let eval_expr = function
  | CreateDatabase name -> create_database name
  | UseDatabase name -> use_database name
  | CreateTable (name, cols) -> create_table name cols
  | ShowDatabases -> show_databases ()
  | ShowTables -> show_tables ()
  | InsertInto (table, cols, vals) -> insert_into table cols vals
  | Select (cols, table, cond) -> select cols table cond
  | Update (table, col, value, cond) -> update_table table col value cond
  | Delete (table, cond) -> delete_from table cond
  | DropTable name -> drop_table name
  | DropDatabase name -> drop_database name
  | Exit -> exit_program ()
```

实现看源码就行，OCaml编程体验确实一绝，一个强大的类型系统+不可变数据类型+纯函数可以解决很多状态变化导致的神必bug。

时间-精力原因，大概就做了上面那么一点。更多什么视图，锁之类的东西本身我也不太熟，也就没做。

## 分析

所以说，从实现上来说没什么难点，比较困难的部分就是工程难度：sql语句太多了，可能的组合也很多。而且sql本身也是上下文相关语法，对于存储引擎的调用也会存在需要记录复杂状态的情况，要把这依托东西完整实现出来需要不少时间。能看出来我现在的实现并不支持那些长的一批的sql语句，它现在基本就是个只能一句一句执行的简单而且不灵活的解释器，不过这些都是努努力就能解决的。

另外就是存储引擎。这部分提供具体功能实现，先不说性能，就实现上的准确无误就较难做到，因为涉及存储这种复杂状态过程，出问题不是概率问题，是频率问题。具体实现要规范数据表文件的结构，而且还要考虑到基于现代fs实现时面对的各种操作的时间复杂度问题来衡量和决定表文件结构的设计，挺麻烦的。

这两部分做完之后肯定不得劲，毕竟能用，但是性能不一定会好，甚至大概率会很差，特别是真实世界的数据库用法很多，当数据量足够大之后，基本就先是技术上追求各种算法，再抽象一层就是追求各种工程领域和实践的结合，在时间/空间/硬件技术之间做各种的trade off了。

优化是一个能一直做下去的玩意，完成上面的毛坯房之后，先给存储引擎的实现换成B+树，再针对前端parse出来的AST结果做各种变换来优化查询过程，还得确保优化前后的无歧义。再说具体的数据处理部分，又能用各种ISA的专有指令进行平台特异的并行化加速。还没完，数据库系统前后端分离降低了开发领域的耦合度，相应的导致了前后端优化的空间限制在自己的区域，那就可以把前端parse出来的AST传给后端，让后端根据指令上下文再做点优化，尽量把IO和处理器性能吃满，把idle压到最小。实现方法有传统的tcs方法，还有现在的典中典各种ai，比如什么根据各种场景搞具体性能分析，再得到优化经验，再丢给ai让ai当AST/后端指令序列优化器，上限也就到这了（？）。

关系数据库理论的内核是关系代数，sql是用户友好版本。所以实在闲得没事，可以再从前端语言的角度设计个新语法，提升提升用户体验，顺便可以搞搞架构上的设计，把那些应用层经常造的东西顺便给它集成进来，优化优化架构和开发效率之类的。

再闲得没事可以改造改造存储引擎，充分利用利用现有的(btr)fs整点新活。数据库的trade off还做不爽了可以再做做分布式数据库，又是更大的依托trade off。

## EOF

项目本身是编译原理大作业。也满足了我写一个编译器的目标，顺便写了个存储引擎，也算有意思吧。OCaml的类型系统和语法实在是印象深刻，已经喜欢上了。
