# 进阶4：常见函数
/*

功能：类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
好处：1、隐藏了实现细节  2、提高代码的重用性
调用：select 函数名(参数列表) 【from 表名】;
分类：
	①单行函数 如concat()、length()、ifnull()等待
	②分组函数
	   功能：做统计使用，又称为统计函数或聚合函数或组函数
	   
常见函数：
	字符函数：
	length()
	concat()
	substr()
	instr()
	trim()
	upper()
	lower()
	lpad()
	rpad()
	replace()
	
	数学函数：
	round()
	ceil()
	floor()
	truncate()
	mod()
	
	日期函数：
	now()
	curdate()
	curtime()
	year()
	month()
	monthname()
	day()
	hour()
	miunte()
	second()
	str_to_date()
	date_format()
	
	其它函数：
	version()
	database()
	user()
	
	控制函数：
	if
	case

*/

# 一、字符函数
# 1.1 length()函数:用于获取参数值的字节个数
SELECT LENGTH('john');
SELECT LENGTH('大海');

# 1.2 concat() 函数：拼接字符串
SELECT CONCAT(last_name, '_',first_name) '姓名' FROM employees;

# 1.3 upper()、lower()：大小写相互转换
SELECT UPPER('john');
SELECT LOWER('JohN');

# 示例：将姓变为大写，名变为小写，然后拼接为一个完整的姓名显示出来
SELECT CONCAT(UPPER(last_name),'_',LOWER(first_name)) FROM employees;

# 1.4 substr()、substring():字符串截取
# 注意：在SQL中索引从1开始
# 截取从指定索引处后后的所有字符，包含临界值
SELECT SUBSTR('李莫愁爱上了陆展元',7) out_put ; # 表示从第七个字符截取到最后一个字符
# 从指定索引处截取指定长度的字符
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) out_put; # 表示从第一个字符开始截取，共截取3个字符

# 案例：姓名中首字符大写，其它字符小写，并用'_'连接姓和名
SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)), LOWER(SUBSTR(last_name,2)),'_',LOWER(first_name) ) out_put
FROM employees;

# 1.5 instr()函数：返回子串第一次出现的索引，如果找不到返回0
SELECT INSTR('世界那么大，我想去看看','么大') out_put;

# 1.6 trim() 函数：去除前后空格或指定的字符
SELECT LENGTH(TRIM('  张无忌  ')) out_put; # 去除前后的空格
SELECT TRIM('a' FROM 'aaaaaaa金aaa毛狮王aaaaa') out_put; # 去除前后多余无用的'a'


# 1.7 lpad()函数：用指定的字符实现左填充指定长度
SELECT LPAD('刘佳欣',5,'*');
SELECT LPAD('刘佳欣',2,'*');

# 1.8 rpad()函数：用指定的字符实现右填充指定长度
SELECT RPAD('刘佳欣',5,'*');
SELECT RPAD('刘佳欣',2,'*');


# 1.9 replace():字符替换
SELECT REPLACE('张无忌爱上了周芷若','周芷若','赵敏');



# --------------------------------------------------------------------------

# 二、数学函数

# 2.1 round()函数：四舍五入
SELECT ROUND(1.65); # 四舍五入为整数
SELECT ROUND(1.456,2); # 保留两位小数四舍五入

# 2.2 ceil() 函数：向上取整
SELECT CEIL(1.3);

# 2.3 floor():向下取整
SELECT FLOOR(2.3);

# truncate()函数：从小数点后开始截断
SELECT TRUNCATE(3.22,1);

# mod()函数：取余数
# mod(a,b) = a - a/b*b ;
SELECT MOD(10,3); # 等同于 10%3



#  -------------------------------------------------

# 三、日期函数
# 3.1 now() 函数：返回当前系统日期+时间
SELECT NOW();

# 3.2 curdate()函数：返回当前系统日期
SELECT CURDATE();

# 3.3 curtime()函数：返回当前系统时间
SELECT CURTIME();

# 3.4 可以根据指定的 日期时间信息 获取年月日时分秒
SELECT YEAR(NOW()) 年;
SELECT YEAR(hiredate) '年' FROM employees;
SELECT MONTH(hiredate) '月' FROM employees;
SELECT MONTHNAME(hiredate) '月' FROM employees;
SELECT DAY(hiredate) '月' FROM employees;
SELECT HOUR(hiredate) '时' FROM employees;

# 3.5 str_to_date()函数：通过指定的格式将字符转为日期
/*
mysql中的日期时间格式符：
%Y:四位年份  %y:两位年份  %m:月份(01,02,...,12) %c:月份(1,2,...,12)  %d:日(01,02,...)
%H:小时(24小时制) %h:小时(12小时制) %i:分钟(01,02,...) %s:秒(01,02,...)
*/
SELECT STR_TO_DATE('2019-2-5','%Y-%c-%d') out_put;

# 查询入职日期为 1992-4-3 的员工信息
SELECT * FROM employees WHERE hiredate = '1992-4-3';
SELECT * FROM employees WHERE hiredate = STR_TO_DATE('04-03-1992','%c-%d-%Y');

SELECT STR_TO_DATE('4-3-1999','%c-%d-%Y') out_put;

# 3.5 date_format()函数：将日期转为指定格式的字符串
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日');

# 案例：查询有奖金的员工名和入职日期(xx月/xx日 xx年) , 并按入职日期升序排序
SELECT last_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS  '入职时间'
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY '入职时间' DESC;


# -----------------------------------------------------------

# 四、其它函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

# --------------------------------------------------------------

# 五、流程控制函数
# 1. if() 函数:相当于java中的三元运算符
SELECT IF(10>5,'大于','小于') out_put;

SELECT last_name, commission_pct , IF(commission_pct IS NULL,'没有奖金','有奖金') FROM employees;


# 2. case()函数：
# 2.1 case()函数的使用方式一：相当于java中的 switch case 的效果
/*

语法：
case 要判断的字段或表达式
when 常量1 then 要显示的值1或语句1
when 常量2 then 要显示的值2或语句2
...
else 以上情况不满足时要显示的值n或语句n;
end

*/

/*
案例：查询员工的工资，要求：
部门号=30，显示的工资为原工资的1.1倍
部门号=40，显示的工资为原工资的1.2倍
部门号=50，显示的工资为原工资的1.3倍
其它部门则显示原工资
*/
SELECT salary '原始工资', department_id, 
CASE department_id 
WHEN 30 THEN salary*1.1 
WHEN 40 THEN salary*1.2 
WHEN 50 THEN salary*1.3 
ELSE salary  
END AS '新工资'  
FROM employees; 

# 2.2 case() 函数的使用方式二：相当于多重if
/*
case 
when 条件1 then 要显示的值1或语句1
when 条件2 then 要显示的值2或语句2
when 条件3 then 要显示的值2或语句2
. . . . . .
else 以上条件不满足时要显示的值n或语句n
end
*/
/*
案例：查询员工的工资情况
如果工资>20000,显示A级别
如果工资>15000,显示B级别
如果工资>10000,显示C级别
否则显示D级别
*/
SELECT last_name, salary,
CASE 
WHEN salary>20000 THEN 'A'  
WHEN salary>15000 THEN 'B'  
WHEN salary>10000 THEN 'C' 
ELSE 'D' 
END AS '工资级别' 
FROM employees;


# ------------------------------------------------------------------------
# ------------------------------------------------------------------------

# 练习
# 1. 显示系统时间(注：日期+时间)
SELECT NOW();
# 2. 查询员工号，姓名，工资，以及工资高20%后的结果(new salary)
SELECT employee_id, last_name, salary, salary*1.2 'new salary' 
FROM employees;
# 3. 将员工的姓名按首字母排序，并显示姓名的长度(length)
SELECT LENGTH(last_name) '名字长度', SUBSTR(last_name,1,1) '首字符', last_name 
FROM employees
ORDER BY 首字符 ASC;
# 4. 做一个查询，产生下面的结果
<last_name> earns(赚了) <salary> monthly wants <salary*3>
Dream Salary
Kind earns 240000 monthly but wants 72000

SELECT CONCAT(last_name, ' earns ', salary, ' monthly wants ', salary*3) AS 'Dream Salary' 
FROM employees WHERE salary = 24000;

# 5. 使用 case-when 按照下面的条件输出
job 		grad
AD_PRES		A
ST_MAN		B
IT_PROG		C
SA_PRE		D
ST_CLERK	E

SELECT DISTINCT job_id AS 'job' , 
CASE job_id 
WHEN 'AD_PRES' THEN 'A' 
WHEN 'ST_MAN' THEN 'B' 
WHEN 'IT_PROG' THEN 'C' 
WHEN 'SA_PRE' THEN 'D' 
WHEN 'ST_CLERK' THEN 'E' 
END AS 'grad'  
FROM employees 
WHERE 'grad' IS NOT NULL;





