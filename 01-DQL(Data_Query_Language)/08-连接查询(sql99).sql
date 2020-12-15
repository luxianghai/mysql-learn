# 二、sql99语法(推荐使用，不推荐使用sql92)
/*

语法：
	select 查询列表 
	form 表1 【别名】
	【连接类型】 join 
	表2 【别名】
	on 连接条件 
	【where 筛选条件】 
	【group by 分组】
	【having 分组筛选条件】
	【order by 排序列表】

分类：
内连接⭐：inner
外连接：
	左外连接⭐：left 【outer】
	右外连接⭐：right 【outer】
	全外连接：full 【outer】mysql不支持
交叉连接：aross


特点：
①添加排序、分组、筛选
②inner 可以省略
③筛选条件放在where后面，连接条件放在on后面，提高了sql语句的分离性，便于阅读
④inner join连接和sql92语法中的等值连接的效果是一样的，都是查询多表的交集部分
⑤全外连接=内连接的结果+表1中有但表2中没有的+表2中有但表1中没有的
*/

# 一)、内连接
/*

语法：
select 查询列表 
from 表1 【别名】
inner join 表2【别名】 
on 连接条件
【where 筛选条件】
【group by 分组】
【having 分组筛选条件】
【order by 排序列表】

分类：
等值连接
非等值连接
自连接


*/

# 1、等值连接

# 案例1：查询员工名对应的部门名
SELECT last_name, department_name 
FROM employees e 
INNER JOIN departments d 
ON e.department_id = d.department_id ;	

# 案例2：查询名字中包含e的员工名和工种名(添加筛选)
SELECT last_name , job_title 
FROM employees e 
INNER JOIN jobs j 
ON e.job_id = j.job_id 
WHERE last_name LIKE '%e%';

# 案例3：查询部门个数>3的城市名和部门个数(添加分组+筛选)
①先查询出每个城市的部门的个数
②根据①的结果进行筛选
SELECT city, COUNT(*) 部门个数
FROM locations l 
INNER JOIN departments d 
ON l.location_id = d.location_id 
GROUP BY city 
HAVING COUNT(*) > 3;


# 案例4： 查询部门员工数量>3的部门名和员工数量，并按降序排序(添加排序)
①先查询出每个部门的员工的数量和部门名
②根据①的查询结果进行筛选
SELECT department_name, COUNT(*)
FROM departments d 
INNER JOIN employees e 
ON d.department_id = e.department_id 
GROUP BY department_name 
HAVING COUNT(*)>3 
ORDER BY COUNT(*) DESC;

# 案例5：查询员工名、部门名、工种名并按部门名降序排序(三表连接)
SELECT last_name, department_name, job_title 
FROM employees e 
INNER JOIN departments d 
ON e.department_id = d.department_id 
INNER JOIN jobs j 
ON e.job_id = j.job_id 
ORDER BY department_name DESC;


# -------------------------------------------------------------------------

# 二) 非等值连接
# 案例1：查询员工的工资等级、员工名、工资
SELECT last_name, grade_level, salary 
FROM employees e 
INNER JOIN job_grades jg 
ON salary BETWEEN lowest_sal AND highest_sal ;
 
# 案例2：查询每个工资级别的个数>20的工资级别及个数，并且按照工资级别降序排序
SELECT grade_level , COUNT(*) 
FROM employees e 
INNER JOIN job_grades jg 
ON salary BETWEEN jg.lowest_sal AND jg.highest_sal 
GROUP BY grade_level 
HAVING COUNT(*) > 20 
ORDER BY grade_level DESC;


# -------------------------------------------------------------------------------

# 三) 自连接
# 案例：查询员工的名字以及上的名字
SELECT e.last_name "员工", m.last_name "上级" 
FROM employees e 
INNER JOIN employees m 
ON e.manager_id = m.employee_id;


# 案例：查询员工名中包含k的员工的名字以及上的名字
SELECT e.last_name "员工", m.last_name "上级" 
FROM employees e 
INNER JOIN employees m 
ON e.manager_id = m.employee_id 
WHERE e.last_name LIKE '%k%';


# ============================================================

# 外连接
/*

应用场景：用于查询一个表中有，另一个表中没有的记录

特点：
1、外连接的查询结果为主表中的所有记录
   如果从表中有与之匹配的，则显示匹配的值
   如果从表中没有与之匹配的，则显示null
   外连接查询的结果=内连接结果+主表中有而从表中没有的记录
   
2、左外连接，left join 左边的表是主表
   右外连接，right join 右便的表是主表
   
3、左外和右外交换两个表的顺序可以实现同样的效果
*/

# 引入：查询没有男朋友的女神名
# 使用左外连接实现
SELECT b.name, bo.* 
FROM beauty b 
LEFT OUTER JOIN  boys bo 
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;
# 使用右外连接实现
SELECT b.name, bo.* 
FROM  boys bo
RIGHT OUTER JOIN  beauty b 
ON b.boyfriend_id = bo.id
WHERE bo.id IS NULL;

SELECT * FROM beauty;
SELECT * FROM boys;

# 案例1：查询没有员工的部门名
# 使用左外连接实现
SELECT d.*,employee_id 
FROM departments d 
LEFT OUTER JOIN employees e 
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;
# 使用右外连接实现
SELECT d.*,employee_id 
FROM employees e 
RIGHT OUTER JOIN departments d  
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;


# 全外连接
SELECT b.*, bo.* 
FROM beauty b 
FULL OUTER JOIN boys b 
ON b.boyfriend_id = bo.id;


# 交叉连接（查询结果为笛卡尔乘积）
SELECT b.*, bo.* 
FROM beauty b 
CROSS JOIN boys bo ;


# ============================================================

# 练习：
# 1. 查询编号>3的女神的男朋友的信息，如果有则列出详细信息，如果没有则用null填充
SELECT b.*, bo.* 
FROM beauty b 
LEFT OUTER JOIN boys bo 
ON b.boyfriend_id = bo.id 
WHERE b.id > 3 ;

# 2. 查询哪个城市没有部门
SELECT city ,department_name
FROM locations l 
LEFT OUTER JOIN departments d
ON l.location_id = d.location_id 
WHERE department_id IS NULL;

# 查询部门名为SAL或IT的员工的信息
SELECT e.* ,department_name
FROM departments d 
LEFT OUTER JOIN employees e 
ON e.department_id = d.department_id 
WHERE d.department_name IN('SAL','IT');





















