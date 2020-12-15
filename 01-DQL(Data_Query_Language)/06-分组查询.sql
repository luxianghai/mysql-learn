# 进阶5：分组查询
/*

语法：
	select 分组函数, 列(要求出现在group by的后面)
	from 表
	【where 筛选条件】
	group by 分组的列表 
	【order by 子句】

注意：
	查询列表要求时分组函数和group by后出现的字段

特点：
	1、分组查询中的筛选条件分为两类
			数据源			位置				关键字
	分组前筛选	原始表			group by 子句的前面		where
	分组后筛选	分组后的结果集		group by 子句的后面		having
	
	①分组函数做条件必须要放在having子句中
	②能用分组函数筛选的，就优先考虑使用分组前筛选
	
	2. group by子句单个字段分组，多个字段分组(多个字段之间用逗号分隔，没有顺序要求)，
	   表达式和函数(用的较少)
	   
	3. 也可以排序，排序要放在整个分组查询的最后
*/


# 引入：查询每个部门的平均工资
SELECT AVG(salary) FROM employees;

# 1. 简单的分组查询

# 案例1：查询每个工种的最高工资
SELECT MAX(salary), job_id 
FROM employees 
GROUP BY job_id;

# 案例2：查询每个位置上的部门个数
	SELECT COUNT(*) , location_id 
	FROM departments 
	GROUP BY location_id;
	
# 2. 为分组查询前添加查询条件
# 2.1 案例1：查询邮箱中包含a字符的每个部门的平均工资
SELECT AVG(salary) 平均工资,  department_id 
FROM employees 
WHERE email LIKE '%a%' 
GROUP BY department_id;

# 2.2 案例2：查询有奖金的每个领导手下员工的最高工资
SELECT MAX(salary), manager_id 
FROM employees 
WHERE commission_pct IS NOT NULL 
GROUP BY manager_id;

# 3. 为分组查询之后添加复杂的查询条件
# 3.1 案例1：查询哪个部门的员工数 > 2
# ①先查询每个部门的员工个数
SELECT COUNT(*) , department_id 
FROM employees
GROUP BY department_id;
# ②根据①的结果进行筛选，查询哪个部门的员工数 > 2
SELECT COUNT(*) , department_id 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) > 2;

# 3.2 查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
# ①查询每个工种有奖金的员工的最高工资
SELECT MAX(salary), job_id 
FROM employees 
WHERE commission_pct IS NOT NULL 
GROUP BY job_id;

# ②根据①的查询结果继续筛选，最高工资>12000
SELECT MAX(salary), job_id 
FROM employees 
WHERE commission_pct IS NOT NULL 
GROUP BY job_id 
HAVING MAX(salary) > 12000;

# 3.3 查询领导编号>102 的每个领导手下最低工资>5000的领导编号是哪个，以及其的最低工资
# ①查询领导编号>102的领导手下工资最低的
SELECT MIN(salary) , manager_id 
FROM employees 
WHERE manager_id > 102 
GROUP BY manager_id ;

# ②根据①的结果继续筛选，最低工资大于5000
SELECT MIN(salary) , manager_id 
FROM employees 
WHERE manager_id > 102 
GROUP BY manager_id 
HAVING MIN(salary) > 5000;


# 4. 按表达式或函数分组
# 4.1 案例1：按员工姓名的长度分组，查询每一组的员工个数，筛选员工中名长度>5的 员工
# ①按员工姓名的长度分组
SELECT COUNT(*) , LENGTH(last_name) len_name
FROM employees 
GROUP BY LENGTH(last_name);

# ②添加筛选条件
SELECT COUNT(*) c , LENGTH(last_name) len_name
FROM employees 
GROUP BY len_name 
HAVING c > 5;


# 5. 按多个字段分组
# 5.1 查询每个部门每个工种的员工的平均工资
SELECT AVG(salary), department_id, job_id 
FROM employees 
GROUP BY department_id, job_id;


# 6. 添加排序
# 6.1 查询每个部门每个工种的员工的平均工资，部门号不为空且平均工资>10000的,并按平均工资从高到低显示出来
SELECT AVG(salary), department_id, job_id 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id, job_id 
HAVING AVG(salary) > 10000 
ORDER BY AVG(salary) DESC;




# -----------------------------------------------

# 练习：
# 1. 查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序排序
SELECT MAX(salary), MIN(salary), AVG(salary), SUM(salary),  job_id 
FROM employees 
GROUP BY job_id 
ORDER BY job_id ASC;


# 2. 查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT MIN(salary) , manager_id 
FROM employees 
WHERE manager_id IS NOT NULL 
GROUP BY manager_id 
HAVING MIN(salary) >= 6000;

# 3. 查询所有部门的编号，员工数量和工资平均值，并按平均工资降序
SELECT COUNT(*), AVG(salary), department_id 
FROM employees 
GROUP BY department_id 
ORDER BY AVG(salary) DESC;

# 4. 查询具有各个job_id的员工人数
SELECT COUNT(*), job_id 
FROM employees 
WHERE job_id IS NOT NULL 
GROUP BY job_id ;

# 5. 查询员工最高工资和最低工资的差距(DIFFRENCE)
SELECT MAX(salary) - MIN(salary) DIFFRENCE
FROM employees ;

