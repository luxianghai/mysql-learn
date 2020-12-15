# 常见的数据类型：
/*

1.数值型
	整形
	小数：
		定点数：
		浮点数：
2.字符型：
	较短的文本：char,varchar
	较长的文本：text、blob(较长的二进制数据)
3. 日期型

*/

# 一、整型
/*
分类：tinyint、smalliint、mediumint、int/integer、bigint
	1	2	  3	     4	          8

特点：
①默认为是有符号的；如果想设置为无符号，需要在int 或添加关键字 unsigned;
②插入的数据超出整形的范围则会插入失败,并且报错误代码 out of range;
③如果不设置长度会有默认长度;
 长度代表了显示的最大宽度，如果不够可以用0来填充，但必须搭配zerofill关键字使用
*/
USE mysql_learn;
# 1. 如何设置无符号(unsigned)和有符号
DROP TABLE IF EXISTS tab_int;
CREATE TABLE tab_int
(
	t1 INT,
	t2 INT UNSIGNED, # 无符号整型
	t3 INT(7) ZEROFILL # 设置零填充，当数值不足指定长度时，用零来填充，使用了zerofill关键字以后就是无符号的了
);

DESC tab_int;

INSERT INTO tab_int VALUES(-123456);
INSERT INTO tab_int VALUES(-123456,-123456); # 插入失败， t2字段只能为正整数(超出范围 out of range)
INSERT INTO tab_int VALUES(-123456,432432432);
INSERT INTO tab_int VALUES(-123456,432432432,23);

SELECT * FROM tab_int;



# ----------------------------------------------------------------------

# 2. 小数
/*
1. 浮点型
float(M,D)
double(M,D)
2. 定点型
dec(M,D)
decimal(M,D)

特点：
①M和D 
  M：整数部位+小数部位
  D：小数部位
  如果超出范围，则插入失败， out of range
②M和D都可以省略
 如果是decimal的话，则M默认为10，D默认为0
 如果是float或double，则会根据插入的数值的精度来决定精度	
③定点型的精度较高，如果插入数值的精度较高如货币运算则考虑使用decimal


*/

# 测试M和D
DROP TABLE IF EXISTS tab_float;
CREATE TABLE tab_float
(
	f1 FLOAT(5,2),
	f2 DOUBLE(5,2),
	f3 DECIMAL(5,2) # 表示 总共五位，小数占两位
);
INSERT INTO tab_float VALUES(123.45,123.45,123.45);
INSERT INTO tab_float VALUES(123.456,123.456,123.456);
INSERT INTO tab_float VALUES(123.4,123.4,123.4);
INSERT INTO tab_float VALUES(1543.4,1543.4,1543.4); # 插入失败，out of range

DROP TABLE IF EXISTS tab_float;
CREATE TABLE tab_float
(
	f1 FLOAT,
	f2 DOUBLE,
	f3 DECIMAL
);

INSERT INTO tab_float VALUES(123.45,123.45,123.45);
DESC tab_float;
SELECT * FROM tab_float;

# 原则：
/*
所选择的类型越简单越好，能保存的数值越小越好
*/


# -------------------------------------------------------------------

# 三、字符型
/*
较短的文本：
char
varchar
其它：
binary和varbinary用于保存较短的二进制
enumy用于保存枚举
set用于保存集合
较长的文本
text
blob(较大的二进制)

特点：
	     写法	  	M的意思    				特点		空间耗费	效率
char	    char(M)	最大的字符数，可以省略，默认为1		固定长度的字符		比较消耗	较高
varchar	   varchar(M)	最大的字符数，不可以省略		可变长度的字符		比较节省	较低 
*/ 

CREATE 	TABLE tab_char
(
	c1 ENUM('a','b','c','d') # 演示枚举类型
);

INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('b');
INSERT INTO tab_char VALUES('c');
INSERT INTO tab_char VALUES('d');
INSERT INTO tab_char VALUES('e'); # 插入失败
INSERT INTO tab_char VALUES('A');

SELECT * FROM tab_char;

CREATE TABLE tab_set
(
	s1 SET('a','b','c','d')
);

INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('a,b');
INSERT INTO tab_set VALUES('a,c,d');
INSERT INTO tab_set VALUES('a,c,e'); # 插入失败

SELECT * FROM tab_set;

# ----------------------------------------------------

# 四、日期型
/*
date：只保存日期
time：只保存时间
year：只保存年

datetime：保存日期+时间
timestamp：保存日期+时间

特点：
		字节		范围		是否受时区影响
datetime：	8		1000-9999	否
timestamp：	4		1970-2038	是
*/

CREATE TABLE tab_date
(
	t1 DATETIME,
	t2 TIMESTAMP
);

INSERT INTO tab_date VALUES(NOW(), NOW());

SELECT * FROM tab_date;

SHOW VARIABLES LIKE 'time_zone'; # 查看当前所用的时区
SET time_zone = '+9:00';














