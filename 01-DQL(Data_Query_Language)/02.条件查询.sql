# 进阶2：条件查询
/*

语法：
select 
	查询列表
	from
		表名
	where 
		筛选条件;

筛选条件
一、按条件表达式筛选
    条件运算符： < , > , =  , != , <> , >= , <=
二、按逻辑表达式筛选
    逻辑运算符： 
    作用：用于连接条件表达式
    && ， || ， |
    或 and , or , not
三、模糊查询
    like
    between and
    in
    is null
*/

# 一、按条件表达式筛选
# 案例1：查询工资大于12000的员工的信息
SELECT * FROM employees WHERE salary > 12000;

# 案例2：查询部门编号不等于90的员工名和b部门编号
SELECT last_name , department_id FROM employees WHERE department_id <> 90;


# 二、按逻辑表达式筛选
# 案例1：查询工资在 10000 到 20000 之间的员工名、工资以及奖金
SELECT last_name, salary, commission_pct FROM employees WHERE salary >= 10000 AND salary <= 20000;

# 案例2：查询部门编号不是在90到100之间的或者工资高于15000的员工信息
SELECT * FROM employees WHERE department_id < 90 OR department_id > 100 OR salary > 15000 ;

# 三、模糊查询
/*
like:
   通配符： %： 表示任意多个字符  _：表示任意一个字符
between and
in
is null/is not null
*/
# 3.1 like
# 案例一：查询员工名中包含 a 的员工的信息
SELECT * FROM employees WHERE last_name LIKE '%a%'; 
# 案例二：查询员工名中第二个字符为 _ 的员工
# 方式一：使用转义字符  \
SELECT * FROM employees WHERE last_name LIKE '_\_%';
# 方式二：使用 ESCAPE 关键字 ，该该关键字用于指定哪个字符是转义字符
SELECT * FROM employees WHERE last_name LIKE '_$_%' ESCAPE '$'; 

# 3.2 between and 
/*
①使用between and 可以提高语句的简洁度
②包含临界值
③两个临界值不要调换顺序
*/
# 案例1：查询员工编号在100--120之间的员工信息
SELECT * FROM employees WHERE department_id BETWEEN 100 AND 120 ;

# 3.3 in
/*
用于判断某列中的值是否包含指定的值
特点：
	①提高简洁度
	②in的列表中的值的类型必须统一或兼容
*/
# 案例：查询员工的工种编号是 IT_PROG、AD_VP、AD_PRES中的一个员工名和工种编号
SELECT last_name, job_id FROM employees WHERE job_id IN('IT_PROG','AD_VP','AD_PRES');

# 3.4 is null | is not null
/*
=或<>不能用于判断null值
要判断null值可以使用 is null 或 is not null 来进行判断
*/
# 案例1：查询没有奖金的员工名和奖金率
SELECT last_name, commission_pct FROM employees WHERE commission_pct IS NULL;
# 案例2：查询有奖金的员工名和奖金率
SELECT last_name, commission_pct FROM employees WHERE commission_pct IS NOT NULL;

# 安全等于：<=>
# 案例1：查询没有奖金的员工名和奖金率
SELECT last_name, commission_pct FROM employees WHERE commission_pct <=> NULL;
# 案例2：查询工资为12000的员工信息
SELECT * FROM employees WHERE salary <=> 12000;


/*
is null 和 <=>
is null 仅仅可以判断null值。可读性较高
<=> 既可以判断null值，还可以判断普通值类型。可读性较差
*/

# 查询员工号为176的姓名，部门号和年薪
SELECT 
	last_name,
	department_id,
	salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM 
	employees
WHERE
	employee_id = 176;


# -----------------------------------
# 练习：
# 1. 查询employees表中没有奖金，且工资小于18000的员工的salary，last_name
SELECT salary,last_name FROM employees WHERE commission_pct IS NULL OR salary < 18000;
# 2. 查询employees表中 job_id 不为 'IT' 或者工资为12000的员工信息
SELECT * FROM employees WHERE job_id <> 'IT' OR salary = 12000;
# 3. 查询employees表的结构
DESC employees;
# 4. 查询部门departments表中设计了哪些位置编号(location_id)
SELECT DISTINCT location_id FROM departments;
# 5. 经典面试题：
/*
问 select * from employee;
和select * from employees where commission_pct like '%%' and last_name like '%%'
的结构是否一样，并说明原因。
答：不一样。如果判断的字段有null值时就会不一样。 
*/








