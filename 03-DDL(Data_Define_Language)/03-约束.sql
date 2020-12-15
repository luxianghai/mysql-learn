# 常见约束
/*

含义：一种限制，用于限制表中的数据，为了保证表中数据的可靠性和准确性

分类：六大约束
	not null：非空约束，用于保证该字段的值不能为空
	比如姓名、学号等;
	default：默认约束，用于保证该字段有默认值
	比如性别;
	primary key：主键约束，用于保证该字段的值具有唯一性，并且非空
	unique：唯一约束，用于保证该字段的值具有唯一性，可以为空(但也只有一个空)
	比如座位号;
	check：检查约束【mysql不支持】
	比如年龄、性别;
	foreign key：外键约束，用于建立多表的关系，用于保证该字段的值必须来自于主表的关联列的值
	在从表添加外将约束，用于引用主表中某列的值
	比如学生表的专业编号，员工表的部门编号，员工表的工种编号
	
添加约束的时机：
	1.创建表时
	2.表创建完成后

约束的添加分类:
	列级约束：
		六大约束在语法上都支持，但外键约束没有效果
	表级约束：
		除了非空、默认，其它的都支持

主键约束和唯一约束的对比：
		是否唯一    是否允许为空   一个表中可以有多少个	    是否允许组合
	主键	  √	          ×		至多一个	    √，但不推荐
	唯一	  √		  √		可以有多个	    √，但不推荐
	
外键约束特点:
	1、要求在从表设置外键
	2、从表的外键列的类型和主表关联列的类型要求一致或兼容，名称无要求
	3、主表的关联列必须是一个key(一般是主键约束或唯一约束)
	4、插入数据时，先插入主表，再插入从表
	   删除数据时，先删除从表，再删除主表
	   
一列可以使用多个约束，多个约束间用空格分隔：
如：stuname varchar(20) not null unique deafult 'test', 
	
	insert into major values(1,'java');
	insert into major values(2,'h5');`stuinfo`
	insert into stuinfo values(1,'john','男',19,null,1);
	insert into stuinfo values(1,'john','女',18,null,2);
	select * from stuinfo;
	truncate table stuinfo;

*/

CREATE DATABASE IF NOT EXISTS mysql_learn2;

# 一、创建表时添加约束
# 1.添加列级约束
/*
直接在字段名和类型后面追加约束类型即可
只支持：默认、非空、主键、唯一
语法：字段 数据类型【长度】 references 主表名(字段);

*/

USE mysql_learn2;

DESC stuinfo

CREATE TABLE stuinfo
(
	id INT PRIMARY KEY, # 主键
	stuName VARCHAR(20) NOT NULL, # 非空
	gender CHAR(1) CHECK(gender='男' OR gender='女'), # 检查约束
	seat INT UNIQUE, # 唯一约束
	age INT DEFAULT 18, # 默认约束
	majorId INT REFERENCES major(id)# 外键约束，该列的值来自于 major表的id, marjor为主表，stuinfo为从表
);

CREATE TABLE major # 专业表
(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)
);

DESC stuinfo;

# 查询索引，包括主键、外键和唯一
SHOW INDEX FROM stuinfo;


# 2. 添加表级约束
/*
在所有字段的最后添加
语法：【constraint 约束名】 约束类型(字段名)
*/
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo 
(
	id INT ,
	stuName VARCHAR(20) ,
	gender CHAR(1) ,
	seat INT , 
	age INT , 
	majorId INT,
	
	CONSTRAINT pk PRIMARY KEY(id), # 主键
	CONSTRAINT uq UNIQUE(seat), # 唯一
	CONSTRAINT ck CHECK(gender='男' OR gender='女'), # 检查
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)# 外键
);

SHOW INDEX FROM stuinfo;

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo 
(
	id INT ,
	stuName VARCHAR(20) ,
	gender CHAR(1) ,
	seat INT , 
	age INT , 
	majorId INT,
	
	PRIMARY KEY(id), # 主键
	UNIQUE(seat), # 唯一
	CHECK(gender='男' OR gender='女'), # 检查
	FOREIGN KEY(majorId) REFERENCES major(id)# 外键
);

SHOW INDEX FROM stuinfo;

# 通用的写法：
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo
(
	id INT PRIMARY KEY, 
	stuname VARCHAR(20) NOT NULL,
	sex CHAR(1),
	age INT DEFAULT 18,
	seat INT UNIQUE ,
	majorId INT ,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id)
);


DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo 
(
	id INT ,
	stuName VARCHAR(20) ,
	gender CHAR(1) ,
	seat INT , 
	age INT , 
	majorId INT,
	
	PRIMARY KEY(id,stuName), # 主键
	UNIQUE(seat), # 唯一
	CHECK(gender='男' OR gender='女'), # 检查
	FOREIGN KEY(majorId) REFERENCES major(id)# 外键
);

# ------------------------------------------------------------

# 二、 表创建完成后添加约束
/*
1.添加列级约束
alter table 表名 modify column 字段名 字段类型 新约束

2.添加表级约束
alter table 表名 add 【constraint 约束名】 约束类型(字段名) 【外键的引用】;
*/
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo 
(
	id INT ,
	stuName VARCHAR(20) ,
	gender CHAR(1) ,
	seat INT , 
	age INT , 
	majorId INT
);
DESC stuinfo;
# 1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NOT NULL;

# 2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;

# 3. 添加主键约束
# ①列级约束
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
# ②表级约束
ALTER TABLE ADD PRIMARY KEY(id);

# 4. 添加唯一约束
# ①列级约束
ALTER TABLE stuinfo MODIFY COLUMN seat INT UNIQUE;
# ②表级约束
ALTER TABLE ADD UNIQUE(id);

# 5. 添加外键约束
ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id);


# ----------------------------------------------------------------------

# 三、 删除表的约束
# 1. 删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NULL;

# 2. 删除默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT;

# 3. 删除主键约束
ALTER TABLE stuinfo DROP PRIMARY KEY;

# 4. 删除唯一约束
ALTER TABLE stuinfo DROP INDEX seat; # index 关键字后根的是唯一键的键名

# 5. 删除外键约束
ALTER TABLE stuinfo DROP FOREIGN KEY fk_stuinfo_major ; # foreign key 关键字后面跟的是 外键名

SHOW INDEX FROM stuinfo;

DESC stuinfo;

ALTER TABLE stuinfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorId) REFERENCES major(id);



# ==================================================================

# 练习：

# 1. 向emp2的id列中添加主键约束
#①列级约束
ALTER TABLE emp2 MODIFY COLUMN id INT PRIMARY KEY;
#②表级约束
ALTER TABLE emp2 ADD PRIMARY KEY(id);

# 2. 向表dept2的id列中添加主键约束


# 3. 向emp2中添加列dept_id,并在其中定义外键约束，与之相关联的列是dept2表中的id列。 
ALTER TABLE emp2 ADD COLUMN dept_id INT;
ALTER TABLE emp2 ADD CONSTRAINT fk_emp2_dept2 FOREIGN KEY REFERENCES dept2(id);


		位置		支持的约束类型			是否可以起约束名
列级约束	列的后面	语法上都支持，但外键没效果	可以
表级约束	所有列的下面	默认和非空都不支持，其它支持	可以(但主键没效果)












