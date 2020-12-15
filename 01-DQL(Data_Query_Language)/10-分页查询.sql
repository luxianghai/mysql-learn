# 进阶8：分页查询
/*
应用场景：当我们要显示的数据过多时，如果一次性将数据全部查询出来会耗费大量时间，
          用户体验较差，此时我们应该要考虑到分页显示。

语法：
	select 查询列表
	from 表
	【join type 表
	on 连接条件
	where 筛选条件
	group by 分组字段
	having 分组后的筛选
	order by 排序的字段】
	limit offset,pageSize;
	
	offset 要显示的条目的起始索引(起始索引从0开始)
	pageSize 表示要显示的条目个数

特点：
①limit语句放在查询语句的最后

page:当前页【用户自定义】  pageSize:页面大小(即每页要显示的条目数量)【用户自定义】
totalCount:总记录数【通过查询可知】  totalPage:总页数【通过计算】
开始索引 = (page-1)*pageSize
totalPage = (tatalCount%pageSize)==0?(tatalCount/pageSize):(tatalCount%pageSize+1)

select * from 表 limit (page-1)*pageSize,pageSize



假设 pageSize = 10
	page		开始索引
	1		0
	2		10
	3		20
	n		(n-1)*pageSize
*/

# 案例1：查询前五条员工信息
SELECT * FROM employees 
LIMIT 0,5;
# 或
SELECT * FROM employees 
LIMIT 5;

# 案例2：查询第11条到25条
SELECT * FROM employees
LIMIT 10,15;

# 案例3：查询有奖金的员工的信息，并且工资较高的前10名显示出来 
SELECT * FROM employees
WHERE commission_pct IS NOT NULL 
ORDER BY salary DESC 
LIMIT 0,10;



# ====================================================================

# 测试
/*
已知表 stuinfo
id 学号
email 邮箱
gradeId 年级编号
sex 性别 男或女
age 年龄

已知表 grade
id 年级编号
gradeName 年级名称

*/

# 1. 查询所有学员的邮箱的用户名(注：邮箱的格式为 用户名@...)
/*
解析： instr();函数用于查找指定的字符的位置
*/
SELECT SUBSTR(email, 1, INSTR(email,'@')-1 ) 用户名
FROM employees;

# 2. 查询男生和女生的人数
SELECT COUNT(*) 个数, sex
FROM stuinfo 
GROUP BY sex;

# 3. 查询年龄>18的所有学生的姓名和年级的名称
# ①查询年龄>18的所有学生的名字和年级编号
SELECT `name`,gradeName
FROM stuinfo s 
INNER JOIN grade g 
ON s.gradeId = g.id 
WHERE s.age > 18;

# 4. 查询哪些年级的学生最小年龄>20
# ①查询出每个年级的最小年龄
SELECT gradeId, MIN(age) 
FROM stuinfo 
GROUP BY gradeId;
# ②根据①的查询结果进行筛选
SELECT gradeId, MIN(age) 
FROM stuinfo 
GROUP BY gradeId 
HAVING MIN(age) > 20


# 5. 试说出查询语句中涉及到的所有关键字，以及执行顺序
SELECT 查询列表		⑦
FROM 表			①
连接类型 JOIN 表2	②
ON 连接条件 		③
WHERE 筛选条件		④
GROUP BY 分组列表	⑤
HAVING 分组后的筛选	⑥
ORDER BY 排序列表	⑧
LIMIT 偏移,条目数;	⑨


# ====================================================================================

# 测试2：
# 1. 查询工资最低的员工的last_name,salary
# 方式一：
SELECT last_name, salary 
FROM employees 
WHERE salary = 
(
	SELECT MIN(salary) 
	FROM employees
);

# 2. 查询平均工资最低的部门信息
# ①查询各个部门的最低工资和与之对应的部门id
SELECT AVG(salary), department_id 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id;
# ②查询①结果上的最低工资
SELECT MIN(ag)
FROM 
(
	SELECT AVG(salary) ag, department_id 
	FROM employees 
	WHERE department_id IS NOT NULL
	GROUP BY department_id
) ag_dep;
# ③根据①的结果查询哪个部门的平均工资=②
SELECT AVG(salary) , department_id 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
HAVING AVG(salary) = 
(
	SELECT MIN(ag)
	FROM 
	(
		SELECT AVG(salary) ag, department_id 
		FROM employees 
		WHERE department_id IS NOT NULL
		GROUP BY department_id
	) ag_dep
);
# ④查询部门的信息，条件为 department_id 等于 ③中的department_id
SELECT d.*
FROM departments d 
WHERE d.department_id = 
(
	SELECT department_id 
	FROM employees 
	WHERE department_id IS NOT NULL 
	GROUP BY department_id 
	HAVING AVG(salary) = 
	(
		SELECT MIN(ag)
		FROM 
		(
			SELECT AVG(salary) ag, department_id 
			FROM employees 
			WHERE department_id IS NOT NULL
			GROUP BY department_id
		) ag_dep
	)
);

# 方式二
# ①查询每个部门的平均工资
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id;
# ②根据①求出平均工资最低的部门的id---使用排序和limit子句
SELECT department_id 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
ORDER BY AVG(salary)
LIMIT 0,1;
# ③查询部门信息，条件为department_id=②的查询结果
SELECT * 
FROM departments 
WHERE department_id = 
(
	SELECT department_id 
	FROM employees 
	WHERE department_id IS NOT NULL 
	GROUP BY department_id 
	ORDER BY AVG(salary)
	LIMIT 0,1
);


# 3. 查询平均工资最低的部门信息和该部门的平均工资
# ① 查询出各个部门的平均工资
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id;
# ② 根据①的结果查询出平均工资最低的部门的id和平均工资
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
ORDER BY AVG(salary) 
LIMIT 0,1;
# ③使用连接查询查出平均工资最低部门信息和平均工资，连接条件为 department_id 相同
SELECT d.* , ROUND(ags,2)  平均工资  # 使用around保留两位小数
FROM departments d
INNER JOIN 
(
	SELECT department_id did, AVG(salary) ags
	FROM employees 
	WHERE department_id IS NOT NULL 
	GROUP BY department_id 
	ORDER BY AVG(salary) 
	LIMIT 0,1
) ag_dep 
ON d.department_id = ag_dep.did;



# 4. 查询平均工资最高的工种的 job(工种) 信息
# ① 查询各个部门的最高工资和工种id(job_id)
SELECT job_id, AVG(salary) 
FROM employees 
GROUP BY job_id;
# ②根据①的查询结果使用order by 和 limit 子句查询出平均工资最高的工种id
SELECT job_id 
FROM employees 
GROUP BY job_id
ORDER BY AVG(salary) DESC
LIMIT 0,1;
# ③查询工种信息，条件为 job_id = ②的查询结果
SELECT * 
FROM jobs 
WHERE job_id = 
(
	SELECT job_id 
	FROM employees 
	GROUP BY job_id
	ORDER BY AVG(salary) DESC
	LIMIT 0,1
);

# 5. 查询平均工资高于公司平均工资的部门信息
# ①查询各个部门的平均工资
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id;
# ②查询公司的平均工资
SELECT AVG(salary) 
FROM employees;
# ③筛选①的结果集，满足平均工资>②的结果
SELECT department_id 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > 
(
	SELECT AVG(salary) 
	FROM employees
);
# 查询部门信息，条件为department_id 为 ③中的每一个
SELECT * 
FROM departments 
WHERE department_id IN 
(
	SELECT department_id 
	FROM employees 
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	HAVING AVG(salary) > 
	(
		SELECT AVG(salary) 
		FROM employees
	)
);

# 6. 查询出公司中所有 manager 的详细信息
# ①查询出所有 manager 的 id
SELECT DISTINCT manager_id 
FROM employees
WHERE manager_id IS NOT NULL ;
# ②查询manager的信息，条件为 employee_id 为 ①的查询结果集
SELECT * 
FROM employees
WHERE employee_id IN
(
	SELECT DISTINCT manager_id 
	FROM employees
	WHERE manager_id IS NOT NULL
);
# 或
SELECT * 
FROM employees
WHERE employee_id = ANY
(
	SELECT DISTINCT manager_id 
	FROM employees
	WHERE manager_id IS NOT NULL
);

# 7. 查询各个部门中最高工资中的最低的那个部门的最低工资是多少？
# ①查询各个部门的最高工资
SELECT department_id, MAX(salary) 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id;
# ②根据①的结果集筛选最最高工资最低的那个部门id
SELECT department_id, MAX(salary) 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY MAX(salary)
LIMIT 0,1;
# ③查询部门id为②中的部门id的部门的最低工资
SELECT MIN(salary) 最低工资
FROM employees 
WHERE department_id =
(
	SELECT department_id 
	FROM employees 
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	ORDER BY MAX(salary)
	LIMIT 0,1
);

# 8. 查询平均工资最高的部门的 manager 的详细信息：last_name,department_id,email,salary
# 法一：
# ①查询 各个部门的平均工资,并且平均工资为最高的部门id
SELECT department_id, AVG(salary) 
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY AVG(salary) DESC
LIMIT 0,1;
# ② 查询出部门id为①的manager的id
SELECT DISTINCT manager_id 
FROM employees 
WHERE department_id = 
(
	SELECT department_id
	FROM employees 
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	ORDER BY AVG(salary) DESC
	LIMIT 0,1
) AND manager_id IS NOT NULL;
# ③查询manager的信息：last_name,department_id,email,salary， 条件为 id=①的查询结果
SELECT last_name,department_id,email,salary 
FROM employees 
WHERE employee_id = 
(
	SELECT DISTINCT manager_id 
	FROM employees 
	WHERE department_id = 
	(
		SELECT department_id
		FROM employees 
		WHERE department_id IS NOT NULL
		GROUP BY department_id
		ORDER BY AVG(salary) DESC
		LIMIT 0,1
	) AND manager_id IS NOT NULL
);





























