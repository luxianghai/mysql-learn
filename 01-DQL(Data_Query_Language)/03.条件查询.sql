# 进阶3：排序查询
/*

语法：
	select 查询列表
	from 表名
	【where 筛选条件】
	order by 排序列表 【asc|desc】 
特点：
	1.asc代表升序，desc表示降序，如果不写默认是升序
	2. order by 子句中可以支持单个字段、多个字段、表达式、函数、别名的排序
	3. order by 子句一般是放在查询语句的最后面，除limit子句外

*/
# 案例1：查询员工信息，要求按工资从高到低排序(即降序 desc)
SELECT * FROM employees ORDER BY salary DESC;
SELECT * FROM employees ORDER BY salary ASC;

# 案例2：查询部门编号>=90的员工信息，按入职时间的先后顺序进行排序
SELECT  * 
FROM employees 
WHERE department_id >= 90 
ORDER BY hiredate ASC ;

# 案例3：按年薪的高低显示员工的信息和年薪【按表达式排序】
SELECT * , salary*12*(1+ IFNULL(commission_pct,0) ) AS '年薪' 
FROM employees
ORDER BY salary*12*(1+ IFNULL(commission_pct,0) ) DESC;

# 案例4：按年薪的高低显示员工的信息和年薪【按表达式排序】
SELECT * , salary*12*(1+ IFNULL(commission_pct,0) ) AS '年薪' 
FROM employees
ORDER BY '年薪' DESC;

# 案例5：按姓名的长度显示员工的姓名和工资【按函数排序,可以使用 length() 函数计算字符的长度(使用别名会没有效果)】
SELECT LENGTH(last_name) AS '姓名长度', last_name, salary
FROM employees
ORDER BY LENGTH(last_name) DESC;

# 案例6：查询员工信息，要求先按工资排序，再按员工编号排序【按多个字段排序】
SELECT * 
FROM employees
ORDER BY salary ASC, employee_id DESC;

# ---------------------------------------
# 练习
# 1. 查询员工的姓名、部门编号和年薪，且按年薪降序排序，按姓名升序排序
SELECT 
  last_name,
  department_id,
  salary * 12 * (1+ IFNULL(commission_pct, 0)) AS '年薪' 
FROM
  employees 
ORDER BY '年薪' DESC,
  last_name ASC ;

# 2. 查询员工工资不在8000到17000的员工的姓名和工资，按工资降序排序
SELECT 
  last_name,
  salary 
FROM
  employees 
WHERE salary NOT BETWEEN 8000 
  AND 17000 
ORDER BY salary DESC ;

# 3. 查询邮箱中包含'e'的员工信息，并先按邮箱的长度降序排序，再按部门编号升序排序
SELECT * 
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC, department_id ASC;


