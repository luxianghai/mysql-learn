# 进阶1：基础查询
/*

语法：
select 查询列表 from 表名; 
特点：
1.查询列表可以是：表中的字段、常量值、表达式、函数
2.查询的结果是一个虚拟的表格


*/

USE mysql_learn;

# 1. 查询表中的单个字段
SELECT last_name FROM employees;

# 2. 查询表中的多个字段
SELECT last_name,`salary`,email FROM employees;

# 3. 查询表中的所有字段
# 方式一：
SELECT 
  `first_name`,
  `last_name`,
  `email`,
  `phone_number`,
  `job_id`,
  `salary`,
  `commission_pct`,
  `manager_id`,
  `department_id`,
  `hiredate`
FROM
  employees ;

# 方式二
SELECT * FROM employees;


# 4. 查询常量值
SELECT 100;
SELECT 'john';

# 5. 查询表达式
SELECT 18*12 ;
SELECT 18%12 ;

# 6. 函数
SELECT VERSION();

# 7. 起别名
/*
①便于理解
②如果要查询的字段有重名的情况，使用别名可以区分开来
*/
# 方式一：使用 as
SELECT 100%98 AS 结果;
SELECT last_name AS '姓',email AS '电子邮箱' FROM employees;
# 方式二： 使用空格
SELECT 100%98 结果;
SELECT last_name '姓',email '电子邮箱' FROM employees;

# 8. 去重: 在查询字段前加 distinct 关键字
# 案例：查询员工表中涉及到的所有的部门的编号
SELECT DISTINCT department_id FROM employees;

# 9. + 号的作用
/*
java中的+号：
①运算符：两个操作数都为数值型
②连接符：只要有一个操作数为字符串

mysql中的+号仅仅只有一个功能：运算符

select 100+90; 两个操作数都为数值型，则做加法运算
select '123'+90; 其中一方为字符型，试图将字符型转为数值型
		 如果转换成功，则继续做加法运算;		 
 select 'john'+90; 如果转换失败，则将字符型数值转换为0
 select null+90; 只要有一方为null，则结果肯定为null
*/
# 案例：查询员工名和姓，并连接成一个字段，显示出完整的姓名
SELECT CONCAT('a','b','c');
SELECT CONCAT(last_name , first_name) FROM employees;

SELECT * FROM employees;

#ifnull(a,b); 如果a为null，则使用b将其替换
SELECT 
  IFNULL(commission_pct, 0) AS '奖金率1',
  commission_pct AS '奖金率2'
FROM
  employees ;

