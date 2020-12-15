# 分组函数
/*

功能：
功能：用作统计使用，又称为聚合函数或统计函数或组函数

分类：
sum()求和  avg()平均值  max()最大值  
min()最小值  count()计算个数

特点：
1、sum()、avg()一般用于处理数值型数据
   max()、min()、count()可以处理任何类型的数据
2、以上分组函数都忽略null值
3、可以和distinct关键字搭配实现去重运算
4. 一般使用count(*)或count(1)来统计行数
5. 和分组函数一同查询的字段要求时group by 后的字段
*/
# 1. 简单使用
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT ROUND(AVG(salary),2)  FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT COUNT(salary) FROM employees;

SELECT SUM(salary) 和, ROUND(AVG(salary),2) 平均值, MAX(salary) 最大值,
MIN(salary) 最小值, COUNT(salary) 个数 
FROM employees;

# 2. 参数支持哪些类型	

# 3. 是否忽略null值

# 4. 和distinct搭配使用
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary),COUNT(salary) FROM employees;

# 5. count()函数的详细介绍
SELECT COUNT(salary) FROM employees;
SELECT COUNT(*) FROM employees;
SELECT COUNT(1) FROM employees;

效率问题：
MYISAM存储引擎下，count(*)的效率高
INNODB存储引擎下，count(*)和count(1)的效率差不多，都比count(字段)的效率高


# 6. 和分组函数一同查询的字段有限制
SELECT AVG(salary) , employee_id FROM employees;


# --------------------------------------------------

# 练习：
# 1. 查询公司员工工资的最大值，最小值，平均值，总和
SELECT MAX(salary) mx_sal, MIN(salary) min_sal, AVG(salary) avg_sal, SUM(salary) sum_sal FROM employees;

# 2. 查询员工表中的最大入职时间和最小入职时间的相差天数(diffrence)
SELECT DATEDIFF(MAX(hiredate),MIN(hiredate)) diffdate FROM employees;

# 3. 查询部门编号为90的员工的人数
SELECT COUNT(*) FROM employees WHERE department_id = 90;


# datediff()函数; 计算两个日期相差的天数
SELECT DATEDIFF('2020-10-2', '1999-5-13') diff;

