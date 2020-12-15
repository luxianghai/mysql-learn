# 进阶9：联合查询
/*
union 联合合并：将多条查询语句的结果合并为员工结果

语法：
查询语句1
union
查询语句2
union 
. . .

应用场景：
要查询的结果来自多个表，且多个表之间没有直接的连接关系，但查询的信息一致时

特点：
1、要求多条件查询语句的查询列数时一致的
2、要求多条查询语句查询的每一列的类型和顺序是一样的
3、union关键字默认去重，如果使用union all可以包含重复项
*/

# 引入案例：查询部门编号大于90或者邮箱中包含'a'的员工信息
SELECT * FROM employees WHERE department_id > 90 OR email LIKE '%a%'; 
# 或
SELECT * FROM employees WHERE department_id > 90 
UNION
SELECT * FROM employees WHERE email LIKE '%a%'

# 案例：查询中国用户中男性的信息以及外国用户中男性的用户信息
SELECT id,cname FROM t_ca WHERE csex = '男'
UNION ALL
SELECT id,tName FROM t_ua WHERE tGender = 'male';

SELECT id,cname FROM t_ca WHERE csex = '男'
UNION 
SELECT id,tName FROM t_ua WHERE tGender = 'male';
# 大家自己对比一下union和union all 的区别

