# DML语言
/*
数据库操作语言：
插入：insert
修改：update
删除：delete
*/

# 一、插入语句方式一：
/*
语法：
inert into 表名(列名1,列名2, ...) values(值1, 值2, ...);

*/

SELECT * FROM beauty;

# 1.插入的值的类型要与列的类型一致或兼容
INSERT INTO beauty(id,`name`,sex,borndate,phone,photo,boyfriend_id) 
VALUES(13,'唐艺昕','女','1990-4-23','18988888888',NULL,2);

# 2. 不可以为null的列必须插入值。可以为null的列如何插入值？
# 方式一：
INSERT INTO beauty(id,`name`,sex,borndate,phone,photo,boyfriend_id) 
VALUES(14,'金星','女','1990-4-23','18988888888',NULL,2);
# 方式二：
INSERT INTO beauty(id,`name`,sex,phone) 
VALUES(15,'娜扎','女','18988888888');

# 3. 列的顺序是否可以调换
INSERT INTO beauty(`name`,id,phone,sex) 
VALUES('蒋欣',16,'18988888888','女');

# 4. 列和值的个数b必须一致
INSERT INTO beauty(`name`,id,phone,sex) 
VALUES('关晓彤',17,'18988888888');

# 5. 可以省略列名，默认所有列而且列的顺序和表中列的顺序一致
INSERT INTO beauty 
VALUES(18,'张飞', '男',NULL,'119',NULL,NULL);


# 插入语句方式二：
/*
语法：
insert into 表名 
set 列名1=值1, 列名2=值2,... ;
*/

INSERT INTO beauty 
SET id = 19, `name` = '刘涛', phone = '999';

# 两种插入方式比较
/*
1.方式一支持插入多行，方式二不支持
2.方式一支持子查询，方式二不支持
*/

# 1.插入多行数据
INSERT INTO beauty 
VALUES(23,'李嘉欣','女','1990-4-23','18988888888',NULL,2),
(24,'女神李嘉欣','女','1990-4-23','18988888888',NULL,2),
(25,'李嘉欣1','女','1990-4-23','18988888888',NULL,2);

# 2. 插入语句的子查询
INSERT INTO beauty(id,`name`,phone)
SELECT 26,'宋茜','118902'; # 将 select 查询的三个值分别赋予id,name,phone三个字段

INSERT INTO beauty(id,`name`,phone) 
SELECT 28,`name`,phone 
FROM beauty
WHERE id = 24;  # 将id等于24的name,phone赋予我们要插入的id为28的name和phone


SELECT * FROM beauty;



# ===============================================================================

# 二、修改语句
/*
1.修改单表的记录
语法：
update 表名
set 列名1=值1, 列名2=字段2, ...
where 筛选条件 ;

2.修改多表的记录(级联更新)
sql92语法：
update 表1 别名, 表2 别名 
set 列名1=值1,...
where 连接条件 
and 筛选条件;

sql99语法：
update 表1 别名 
inner|left|right join 表2 别名 
on 连接条件 
set 列名1=值1, ...
where 筛选条件 ;

*/

# 1. 修改单表的记录
# 案例1：修改beauty表中姓唐的电话为 1389983212
UPDATE beauty 
SET phone = '1389983212' 
WHERE `name` LIKE '唐%';

# 案例2：修改boys表中id为2的boyName为张飞，userCP为10
UPDATE boys 
SET boyName = '张飞', userCp = 10 
WHERE id = 2;


# 2.修改多表的记录
# 案例1：修改张无忌的女朋友的手机号为 114
UPDATE boys bo
INNER JOIN beauty b 
ON bo.id = b.boyfriend_id 
SET phone = '114' 
WHERE bo.boyName = '张无忌';

SELECT * FROM beauty;

# 案例2：修改没有男朋友的女神的男朋友的编号都为张飞的编号
UPDATE beauty b
LEFT JOIN boys bo 
ON b.boyfriend_id = bo.id 
SET b.boyfriend_id = 
(
	SELECT id 
	FROM boys 
	WHERE boyName = '张飞'
)
WHERE b.boyfriend_id IS NULL ;

SELECT * FROM beauty;


# ==================================================================

# 三、删除语句
/*
语法：
方式一：
1. 单表删除
delete from 表名 where 筛选条件; 
2. 多表删除
sql92语法：
delete 表1的别名, 表2的别名
from 表1 别名, 表2 别名
where 连接条件 
and 筛选条件;

sql99语法：
delete 表1的别名, 表2的别名 
from 表1 别名
inner|left|right join 表2 别名 on 连接条件
where 筛选条件;

方式二：truncate 语句
语法：truncate table 表名 ;

*/

# 方式一：
# 1. 单表删除
# 案例1：删除beauty表中手机号以9结尾的女神的信息
DELETE FROM beauty WHERE phone LIKE '%9';

# 2. 多表的删除
# 案例1:删除张无忌的女朋友的信息
DELETE b
FROM boys bo
INNER JOIN beauty b ON bo.id = b.boyfriend_id 
WHERE bo.boyName = '张无忌';

# 案例2：删除黄晓明的信息以及他女朋友的信息
DELETE b, bo 
FROM boys bo 
INNER JOIN beauty b ON bo.id = b.boyfriend_id 
WHERE bo.boyName = '黄晓明';

SELECT * FROM beauty;
SELECT * FROM boys;

# 方式二：truncate 语句
# 案例：将 boys 表中 userCP 大于100的男神信息删除 ---- truncate 语句无法做到
TRUNCATE TABLE boys WHERE userCP > 100;

# delete 和 truncate 的区别【面试题】
/*
1.delete 可以添加where条件， truncate 不能加
2.truncate的效率要高些
3.如果要删除的表有自增长列，如果使用delete删除后在插入数据，自增长列的自从断点开始;
  如果使用truncate删除后再插入数据，自增长列的值从1开始
4.truncate删除没有返回值，delete删除有返回值
5.truncate删除不能事务回滚，delete删除可以回滚
*/

SELECT * FROM boys;

DELETE FROM boys;
TRUNCATE TABLE boys;
INSERT INTO boys(boyName,userCP) 
VALUES('张飞',100), ('赵云',150), ('刘备',160);


# 案例1：向boys表中插入以下数据
id	boyName	      userCP
5	关羽		200
6	诸葛亮		200
7	许褚		190

# 方式一：
INSERT INTO boys(id,boyName,userCP) 
VALUES(5,'关羽',200),
(6,'诸葛亮',200),
(7,'许褚',190);

# delete from boys where id in(5,6,7);

# 方式二：
INSERT INTO boys
SELECT 5,'关羽',200 UNION 
SELECT 6,'诸葛亮',200 UNION
SELECT 7,'许褚',190 ;

# 案例2：删除boys表中id为3的记录
DELETE FROM boys WHERE id = 3 ;

# 案例3：将boys表中userCP < 200 的userCP改为 250；
UPDATE boys SET userCP = 250 
WHERE userCP < 200;


