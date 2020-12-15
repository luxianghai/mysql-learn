# 标识列(自增长列)
/*
含义：可以不用手动的插入列，系统会提供默认的序列值

特点：
1、标识列必须和主键搭配吗？不一定，但要求必须是一个key
2、一个表可以有多个标识列吗？至多一个
3、标识列的类型只能是数值型
4、 标识列可以通过 SET auto_increment_increment = 10; 设置起始值
*/

USE mysql_learn2;

# 一、 创建表时设置标识列
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE IF NOT EXISTS tab_identity
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	NAME VARCHAR(20)
);
TRUNCATE TABLE tab_identity;
INSERT INTO tab_identity VALUES(NULL,'john');
INSERT INTO tab_identity(id,NAME) VALUES(NULL,'jerry');
INSERT INTO tab_identity(NAME) VALUES('programer');

SELECT * FROM tab_identity;

# 显示自增长列的信息  increment=1(初始值,可以修改) offset=1(偏移量，修改无效)
SHOW VARIABLES LIKE '%auto_increment%';

# 修改起始值
SET auto_increment_increment = 10;
# 修改偏移量
SET auto_increment_offset = 10;

# -----------------------------------------------------------

DROP TABLE IF EXISTS tab_identity;
CREATE TABLE IF NOT EXISTS tab_identity
(
	id INT PRIMARY KEY ,
	NAME VARCHAR(20)
);

# 二、表创建完成后设置标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT AUTO_INCREMENT;


# --------------------------------------------------------

# 三、删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT;



















