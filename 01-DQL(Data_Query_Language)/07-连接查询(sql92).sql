# 进阶6：连接查询
/*

含义：又称为多表查询，当查询的字段来自多个表时，就会用到连接查询

笛卡尔乘积现象：假设表1的数据有m行，表2的数据有n行，那么查询的结果为 n*m 行
发生原因：没有有效的连接条件
如何避免：添加有效的连接条件

连接查询的分类：
	按年代分类：
	sql92标准：仅仅支持内连接
	sql99标准【推荐】：支持内连接+外连接(左外和右外)+交叉连接
	
	按功能分类：
	内连接：
		等值连接：
		非等值连接：
		自连接：
	外连接：
		左外连接：
		右外连接：
		全外连接：
	交叉连接：

*/
SELECT * FROM beauty;
SELECT * FROM boys;

# 演示笛卡尔乘积现像
SELECT boyName, `name` FROM beauty,boys;

# 解决笛卡尔乘积现象：
SELECT boyName, `name` 
FROM beauty,boys 
WHERE boys.id = beauty.`boyfriend_id`;



# 一、sql92标准：仅仅支持内连接	
# 1. 等值连接
/*

①多表等值连接的结果为多表的交集部分
②n表连接，至少需要n-1个连接条件
③多表的顺序没有要求
④一般需要为表起别名
⑤可以搭配前面介绍的所有子句使用，比如排序、分组、筛选

*/

# 1.1 案例1：查询女神名与之对应的男神名：
SELECT boyName, `name` 
FROM beauty,boys 
WHERE boys.id = beauty.`boyfriend_id`;

# 1.2 案例2：查询员工名与之对应的部门名
SELECT last_name, department_name 
FROM employees emp , departments dep 
WHERE emp.department_id = dep.department_id;

# -------------------------------------------------------------------

# 2. 案例1：查询员工号、工种号、员工名 (为表起别名)
/*
为表起别名：
①提高语句的简洁度
②区分多个重名的字段
注意：如果为表起了别名，则查询的字段就不能使用原来的表名取限定
*/
SELECT e.last_name, e.job_id, j.job_title  
FROM employees e, jobs j 
WHERE e.job_id = j.job_id;

# --------------------------------------------------------------------

# 3、多个表的顺序是否可以调换
# 查询员工号、工种号、员工名 (为表起别名)
SELECT e.last_name, e.job_id, j.job_title  
FROM  jobs j,  employees e 
WHERE e.job_id = j.job_id;

# ---------------------------------------------------------------------

# 4. 可以筛选吗？
# 4.1 案例1：查询有奖金的员工名、部门名及奖金
SELECT e.last_name, d.department_name , e.commission_pct 
FROM employees e ,departments d 
WHERE e.department_id = d.department_id
AND e.commission_pct IS NOT NULL;



# 4.2 案例2：查询城市名中第二个字符为o的部门名和城市名
SELECT d.department_name, l.city 
FROM departments d, locations l 
WHERE d.location_id = l.location_id
AND l.city LIKE '_o%';

# ---------------------------------------------------------------------

# 5. 可以加分组

# 5.1 案例1：查询每个城市的部门个数
SELECT COUNT(*) 个数, l.city
FROM locations l, departments d 
WHERE l.location_id = d.location_id 
GROUP BY l.city;

# 5.2 案例2：查询有奖金的每个部门的部门名和部门的领导编号，以及该部门的最低工资
SELECT MIN(e.salary), d.department_name, d.manager_id 
FROM employees e, departments d 
WHERE e.department_id = d.department_id 
AND e.commission_pct IS NOT NULL 
GROUP BY d.department_name, d.manager_id;

# ---------------------------------------------------------------------

# 6. 可以加排序

# 案例：查询每个工种的工种名和员工个数，并且按员工个数降序
SELECT j.job_title, COUNT(*) 
FROM jobs j, employees e 
WHERE j.job_id = e.job_id 
GROUP BY j.job_title 
ORDER BY COUNT(*) DESC;

# ---------------------------------------------------------------------

# 7. 三表连接
# 7.1 案例1：查询员工名、部门名和所在城市
SELECT e.last_name, d.department_name, l.city 
FROM employees e, departments d, locations l 
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id;


# -----------------------------------------------------------------------

# 非等值连接

# 案例1：查询员工名、工资和工资级别(job_graders表),并按工资降序排序
SELECT e.last_name,e.salary,jg.grade_level 
FROM employees e, job_grades jg 
WHERE e.salary BETWEEN jg.lowest_sal AND jg.highest_sal 
ORDER BY e.salary DESC;



# -----------------------------------------------------------------------

# 自连接
# 案例：查询员工名和其上级的名字
SELECT emp.employee_id '员工编号', emp.last_name '员工名', mag.employee_id '领导编号', mag.last_name '领导名'
FROM employees emp, employees mag
WHERE emp.manager_id = mag.employee_id;


# -----------------------------------------------------------------------

# 练习：
# 1. 显示员工表的最大工资和平均工资
SELECT MAX(salary), AVG(salary);

# 2. 查询员工表的employee_id, job_id,last_name, 按department_id降序，salary升序
SELECT employee_id, job_id, last_name 
FROM employees 
ORDER BY department_id DESC, salary ASC;

# 3. 查询员工表的job_id包含a和e的，并且a在e的前面
SELECT * FROM employees 
WHERE job_id LIKE '%a%e%';

# 4. 已知表student，里面有id(学号),name,gradeId(年级编号)
     已知表grade，里面有id(年级编号)，name(年级名)
     已知表result，里面有id,score(成绩),studentNo(学号)
     
     要求查询姓名，年纪名和成绩
     
SELECT s.name, g.name, r.score 
FROM student s,grade g,result r 
WHERE s.gradeId = g.id 
AND r.studentNo = s.id;


# 5. 显示当前日期，以及去除前后空格，截取子字符串的函数
SELECT NOW(); # 显示当前日期

SELECT CONCAT('【',TRIM('  fsfa  '),'】');# 去除前后空格
SELECT CONCAT('【',TRIM('a' FROM 'aa fsfa aa'),'】'); # 去除前后指定字符

SELECT SUBSTR('value',startIndex);
SELECT SUBSTR('value',startIndex, _length);

SELECT SUBSTR('hello world', 5); # o world
SELECT SUBSTR('hello world', 5, 3); # o w


# ----------------------------------------------------------------------------

# 测试

# 1. 显示所有员工的姓名，部门号和部门名称
SELECT e.last_name, e.department_id, d.department_name 
FROM employees e, departments d 
WHERE e.department_id = d.department_id;

# 2. 查询90号部门员工的job_id和90号部门的location_id
SELECT e.job_id , e.department_id , d.location_id 
FROM employees e, departments d
WHERE e.department_id = 90 
AND e.department_id = d.department_id ;


# 3. 查询所有有奖金的员工的last_name,department_name,location_id,city
SELECT e.last_name,d.department_name,l.location_id,l.city 
FROM employees e, departments d , locations l 
WHERE e.commission_pct IS NOT NULL 
AND e.department_id = d.department_id 
AND d.location_id = l.location_id;


# 4. 选择城市在Toronto工作的员工的last_name,job_id,department_id,department_name,city
SELECT e.last_name,job_id,d.department_id,d.department_name, l.city
FROM employees e, departments d, locations l 
WHERE l.city = 'Toronto' 
AND e.department_id = d.department_id 
AND d.location_id = l.location_id;

# 5. 查询每个工种，每个部门的部门名、工种名和最低工资
SELECT department_name, job_title, MIN(salary)  
FROM departments d, jobs j, employees e
WHERE d.department_id = e.department_id 
AND e.job_id = j.job_id 
GROUP BY department_name, job_title;

# 6. 查询每个国家下的部门个数大于2的国家编号
SELECT COUNT(*), country_id 
FROM departments d, locations l 
WHERE d.location_id = l.location_id 
 GROUP BY l.country_id  
 HAVING COUNT(*) > 2;


# 7. 查询指定员工的姓名，员工号以及它的管理者的姓名和员工号，结果类似于下面的格式
employees  	emp 	manager		manager_id
kochhar 	101	king		100

SELECT e.last_name, e.employee_id, m.last_name 'manager' , e.manager_id 'manager_id' 
FROM employees e, employees m 
WHERE e.manager_id = m.employee_id 
AND e.last_name = 'kochhar' ;
















 