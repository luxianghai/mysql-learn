 # DDL: Data Define Language 数据定义语言
 /*
数据库和数据表的管理：
一、数据库的管理
创建、删除、修改

二、表的管理
创建、删除、修改

创建：create
修改：alter
删除：drop 
 */
 
 
 # 数据库的管理：
 # 1. 库的创建
 /*
语法：
create database [if not exists] 库名; 
 */
 
 # 案例1：创建Books数据库
 CREATE DATABASE IF NOT EXISTS books;
 
# 2. 库的修改
RENAME DATABASE books TO 新库名; # 已废弃不能使用 
 
# 2.1 更改库的字符集
ALTER DATABASE books CHARACTER SET utf8;

# 3. 库的删除
DROP DATABASE IF EXISTS books;


# ========================================================

# 二、表的管理

# 1. 表的创建(★)
/*
语法：
create table if not exists 表名
(
	列名 列的类型【(长度) 约束】,
	列名 列的类型【(长度) 约束】,
	列名 列的类型【(长度) 约束】
	...
	列名 列的类型【(长度) 约束】
);
*/
USE books;
# 案例：创建book表
CREATE TABLE IF NOT EXISTS book
(
	id INT, # 编号
	bName VARCHAR(20), # 书名
	price DOUBLE , # 价格
	authorId INT, # 作者编号
	publishDate DATETIME # 出版日期
);

DESC book;

# 案例：创建表author
CREATE TABLE IF NOT EXISTS author
(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(10) # 国籍
);

# -------------------------------------------------------------

# 2. 表的修改
/*
①修改列名
②修改列的类型或约束
③添加新列
④删除列
⑤修改表名

语法：
alter table 表名 add|drop|modify|change column 列名 【数据类型 约束】;

*/

# ①修改列名
ALTER TABLE book CHANGE COLUMN publishDate pubDate DATETIME;

# ②修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP; # 修改列的数据类型

# ③添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE; # 添加新列

# ④删除列
ALTER TABLE author DROP COLUMN annual ;

# ⑤修改表名
ALTER TABLE author RENAME TO book_author;


# --------------------------------------------------------------


# 3. 表的删除
DROP TABLE IF EXISTS book_author;

SHOW TABLES;

# --------------------------------------------------------------

# 4. 表的复制
INSERT INTO author VALUES
(1,'村上春树','Japan'),
(2,'莫言','China'),
(3,'冯唐','China'),
(4,'金庸','China');

SELECT * FROM author;

# 4.1 仅仅复制表的结构
CREATE TABLE copy LIKE author;

SELECT * FROM copy;

# 4.2 仅仅复制某些字段，只复制表结构
CREATE TABLE cope4
SELECT id, au_name 
FROM author
WHERE 1 = 0 ;

SELECT * FROM cope4;

# 4.3 复制表的结构和数据
CREATE TABLE cope2 SELECT * FROM author;

SELECT * FROM cope2;

# 4.4 只复制部分数据
CREATE TABLE cope3 
SELECT id, au_name 
FROM author 
WHERE nation = 'China'; # 只复制author表中的id,au_name列，并且nation='China'的数据

SELECT * FROM cope3;

# ==========================================================

# 练习
# 1. 将cope2表中的字段au_name改为 auName;
ALTER TABLE cope2 CHANGE COLUMN au_name auName VARCHAR(20); 
 
# 2. 将cope2表中nation字段的长度改为20
ALTER TABLE cope2 MODIFY COLUMN nation VARCHAR(20);

# 3. 根据表cope2创建表demo
CREATE TABLE demo LIKE cope2;

# 4. 将表cope2重命名为demo_cope
ALTER TABLE cope2 RENAME TO demo_cope;

# 5. 在表demo_cope中添加新列test_column,类型为 int
ALTER TABLE demo_cope ADD COLUMN test_column INT;

# 6. 删除表demo_cope 中的 test_column 列
ALTER TABLE demo_cope DROP COLUMN test_column;








 