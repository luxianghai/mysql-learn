# 进阶7：子查询
/*

含义：出现在其它语句中的select语句，称为子查询或内查询
外部出现的查询语句称为主查询或外查询

分类：
按子查询出现的位置：
	select后面：仅仅支持标量子查询
	from后面：支持表子查询
	where或having后面⭐：支持标量子查询(⭐单行)和列子查询(⭐多行)，行子查询
	exists后面(相关子查询)：支持表子查询

按结果集和行数列数不同：
	标量子查询(结果集只有一行一列)
	列子查询(结果集只有一列多行)
	行子查询(结果集有一行多列或多行多列)
	表子查询(一般为多行多列)

*/

# 一、where或having后面
/*
特点：
①子查询放在小括号内
②子查询一般放在条件的右侧
③标量子查询：一般搭配单行操作符使用(>,<,>=,<=,<>)
 列子查询：一般搭配多行操作符使用(in,any/some,all)
④子查询优先于主查询先执行
*/
# 1、标量子查询(单行子查询)
# 1.1 案例1：谁的工资比 Abel 高
# ①查询 Abel 的工资
SELECT salary FROM employees WHERE last_name = 'Abel';
# ②查询员工的信息，满足 salary>①的结果
SELECT * 
FROM employees 
WHERE salary > 
(
	SELECT salary 
	FROM employees 
	WHERE last_name = 'Abel'
);

# 1.2 案例2：返回job_id于141号员工相同的，salaryb比143号员工高的员工的姓名，job_id和工资
# ①查询 141 员工的job_id 
SELECT job_id FROM employees WHERE employee_id = 141;
# ②查询 143 员工的工资
SELECT salary FROM employees WHERE employee_id = 143;
# ③查询 job_id=① 并且 salary> ② 的员工姓名，job_id和工资
SELECT last_name, job_id, salary 
FROM employees 
WHERE job_id = 
(
	SELECT job_id 
	FROM employees 
	WHERE employee_id = 141
)
AND salary > 
(
	SELECT salary 
	FROM employees 
	WHERE employee_id = 143
);

# 1.3 案例3：查询公司工资最低的员工的last_name,job_id和salary.
# ①查询出公司中工资最低工资
SELECT MIN(salary) 
FROM employees ;
# ②根据①中查询到的最低工资查询出该员工的last_name,job_id,salary
SELECT last_name,job_id,salary  
FROM employees 
WHERE salary = 
(
	SELECT MIN(salary) 
	FROM employees
);

# 1.4 案例4：查询最低工资大于50号部门最低工资的部门的id和其最低工资
# ①查询50号部门的最低工资
SELECT MIN(salary) 
FROM employees 
WHERE department_id = 50;
# ②查询每个部门的最低工资
SELECT MIN(salary), department_id 
FROM employees 
GROUP BY department_id;
# ③根据①和②查询结果筛选出最终结果
SELECT MIN(salary), department_id 
FROM employees 
GROUP BY department_id
HAVING MIN(salary) > 
(
	SELECT MIN(salary) 
	FROM employees 
	WHERE department_id = 50
);


# 2、列子查询(多行子查询)
# 2.1 案例1：返回location_id是1400或1700的部门的所有员工的last_name和department_id
# ①查询出location_id是1400或1700的部门的id
SELECT DISTINCT department_id
FROM departments 
WHERE location_id IN(1400,1700);
# ②查询出department_id为①的查询结果的所有员工的last_name和department_id
SELECT last_name, department_id 
FROM employees 
WHERE department_id IN
(
	SELECT DISTINCT department_id
	FROM departments 
	WHERE location_id IN(1400,1700)
);

# 2.2 案例2：查询其它工种中比job_id为'IT_PROG'工种任一工资低的员工的员工号、姓名、job_id以及salary
# ①查询出job_id为'IT_PROG'部门的员工的所有工资
SELECT DISTINCT salary
FROM employees
WHERE job_id = 'IT_PROG';
# ②员工的员工号、姓名、job_id以及salary,并且salary<①中的任意一个即可(即salary<①中的最大值)和 job_id 不等于 'IT_PROG'
SELECT employee_id, last_name, job_id, salary 
FROM employees 
WHERE salary < ANY
(
	SELECT DISTINCT salary
	FROM employees
	WHERE job_id = 'IT_PROG'
) AND job_id <> 'IT_PROG';

# 或写为
SELECT employee_id, last_name, job_id, salary 
FROM employees 
WHERE salary < 
(
	SELECT DISTINCT MAX(salary)
	FROM employees
	WHERE job_id = 'IT_PROG'
) AND job_id <> 'IT_PROG';

# 2.3 案例3：查询其它工种中比job_id为'IT_PROG'工种的所有工资都低的员工的员工号，姓名，job_id和salary
# ①查询 job_id 为 'IT_PROG' 的所有工资
SELECT DISTINCT salary 
FROM employees 
WHERE job_id = 'IT_PROG';
# ②查询员工的员工号，姓名，job_id和salary，条件为salary<①中的所有值(即salary<①中的最小值)，并且job_id不等于'IT_PROG'
SELECT employee_id, last_name, job_id, salary 
FROM employees 
WHERE salary < ALL
(
	SELECT DISTINCT salary 
	FROM employees 
	WHERE job_id = 'IT_PROG'
) AND job_id <> 'IT_PROG';

# 或写为
SELECT employee_id, last_name, job_id, salary 
FROM employees 
WHERE salary < 
(
	SELECT DISTINCT MIN(salary) 
	FROM employees 
	WHERE job_id = 'IT_PROG'
) AND job_id <> 'IT_PROG';


# 3、行子查询(结果集为一行多列或多行多列)
# 查询员工编号最小且工资最高的员工的信息
# 法一：
SELECT * 
FROM employees 
WHERE (employee_id,salary) = 
(
	SELECT MIN(employee_id), MAX(salary)
	FROM employees
);

# 法二：
# ①查询出最小编号
SELECT MIN(employee_id) 
FROM employees;
# ②查询最最高工资
SELECT MAX(salary) 
FROM employees;
# ③查询最终结果
SELECT * 
FROM employees 
WHERE employee_id = 
(
	SELECT MIN(employee_id) 
	FROM employees
) AND salary = 
(
	SELECT MAX(salary) 
	FROM employees
);

# =====================================================================

# 二、select 后面
/*
仅仅支持标量子查询
*/

# 案例1：查询每个部门的员工个数
# 法一：子查询
SELECT d.*, 
(
	SELECT COUNT(*) 
	FROM employees e
	WHERE e.department_id = d.department_id
) 个数 
FROM departments d;
  
# 法二：内连接查询
SELECT d.*,COUNT(*) 
FROM departments d 
INNER JOIN employees e
ON d.department_id = e.department_id 
GROUP BY department_id;

# 案例2：查询员工号=102的部门名
SELECT e.* ,
(
	SELECT department_name 
	FROM departments d 
	WHERE e.department_id = d.department_id 
	
) 部门 
FROM employees e
WHERE e.employee_id = 102;

# =======================================================================

# 三、from后面
/*
将子查询充当一张表，要求必须起别名
*/
# 案例1：查询每个部门的平均工资的工资等级
# ①查询每个部门的平均工资
SELECT AVG(salary), department_id  
FROM employees 
GROUP BY department_id;
# ②把①的查询结果和job_grades表连接起来，筛选条件为平均工资 between lowest_sal and highest_sal
SELECT jd.grade_level, n.department_id, n.avg_sal 
FROM 
(
	SELECT AVG(salary) avg_sal, e.department_id  
	FROM employees e
	GROUP BY e.department_id
) n INNER JOIN job_grades jd
ON  n.avg_sal BETWEEN jd.lowest_sal AND jd.highest_sal;


# ==================================================================

# 四、 放在exists后面(相关子查询)
/*
exists(完整的查询语句):判断是否存在,存在返回1，否则返回0
*/
SELECT EXISTS(SELECT employee_id FROM employees WHERE salary = 30000);
# 案例1：查询有员工的部门名
# exists
SELECT department_name 
FROM departments d
WHERE EXISTS
(
	SELECT * 
	FROM employees e
	WHERE d.department_id = e.department_id
);

# in 
SELECT department_name 
FROM departments d 
WHERE d.department_id IN 
(
	SELECT e.department_id 
	FROM employees e
);

# 案例2：查询没有女朋友的男神信息
# in
SELECT bo.* 
FROM boys bo 
WHERE bo.id NOT IN
(
	SELECT b.boyfriend_id  
	FROM beauty b
);

# exists
SELECT bo.*
FROM boys bo 
WHERE NOT EXISTS
(
	SELECT boyfriend_id 
	FROM beauty b 
	WHERE bo.id = b.boyfriend_id
)


# --------------------------------------------------

# 练习：
# 1. 查询和Zlotkey相同部门的员工姓名、工资和部门号
# ①查询Zlotkey的部门
SELECT department_id 
FROM employees 
WHERE last_name = 'Zlotkey';
# ②查询员工姓名和工资，条件为 department_id = ①的查询结果
SELECT last_name, salary , department_id
FROM employees 
WHERE department_id = 
(
	SELECT department_id 
	FROM employees 
	WHERE last_name = 'Zlotkey'
)

# 2. 查询工资比公司平均工资高的员工的员工号、姓名和工资
# ①查询公司的平均工资
SELECT AVG(salary) 
FROM employees;
# ②查询员工的员工号、姓名和工资，条件为 salary>①的查询结果
SELECT employee_id,last_name, salary 
FROM employees 
WHERE salary > 
(
	SELECT AVG(salary) 
	FROM employees
);

# 3. 查询各部门中工资比本部门平均工资高的员工的员工号、姓名、工资、部门id，部门平均工资
# ①查询每个部门的平均工资
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id;
# ②查询员工的员工号、姓名和工资，条件为 salary>本部门平均工资
SELECT employee_id, last_name, salary , e.department_id,avg_sal 平均工资
FROM employees e 
INNER JOIN 
(
	SELECT department_id, AVG(salary) avg_sal 
	FROM employees
	WHERE department_id IS NOT NULL
	GROUP BY department_id
) avg_tb 
ON e.department_id = avg_tb.department_id
WHERE e.salary > avg_tb.avg_sal;


# 4. 查询姓名中包含字母u的员工在相同部门的员工的员工号和姓名
# ①查询姓名中包含u的员工的部门id
SELECT DISTINCT department_id 
FROM employees 
WHERE last_name LIKE '%u%';
# ②查询员工号和姓名，条件为 department_id 为 ① 的查询结果中的某一个
SELECT employee_id, last_name, department_id 
FROM employees 
WHERE department_id IN 
(
	SELECT DISTINCT department_id 
	FROM employees 
	WHERE last_name LIKE '%u%'
) ;

SELECT COUNT(*) FROM employees WHERE department_id = 60; # 用于验证

# 5. 查询在部门的location_id为1700的部门工作的员工的员工号和姓名
# ①查询location_id=17000的部门id
SELECT DISTINCT department_id 
FROM departments 
WHERE location_id = 1700;
# ②查询员工的员工号和姓名，条件为 department_id 为 ①的查询结果中的某一个
SELECT employee_id,last_name,department_id 
FROM employees 
WHERE department_id IN
(
	SELECT DISTINCT department_id 
	FROM departments 
	WHERE location_id = 1700
) ;

SELECT COUNT(*) FROM employees WHERE department_id = 100; # 用于验证

# 6. 查询管理者是King的员工姓名和工资
# ①查询K_ing的员工号
SELECT employee_id 
FROM employees 
WHERE last_name = 'K_ing';
# 查询员工姓名和工资，条件为 manager_id 为 ①查询结果的任意一个
SELECT last_name , salary , manager_id 
FROM employees 
WHERE manager_id IN 
(
	SELECT employee_id 
	FROM employees 
	WHERE last_name = 'K_ing'
);


SELECT * FROM employees WHERE manager_id IN (100,156);  # 用于验证

# 7. 查询工资最高的员工姓名，要求first_name和last_name显示为一列，列名为 姓.名
SELECT CONCAT(last_name, ' ', first_name) "姓.名" ,MAX(salary) 
FROM employees ;


SELECT * 
FROM employees WHERE manager_id IN (100,156); 















