# 子查询经典案例

# 一、 查询每个专业的学生人数
SELECT majorid, COUNT(*) 
FROM student 
GROUP BY majorid;

# 二、查询参加开考试学生中，每个学生的平均分、最高分
SELECT AVG(score), MAX(score), studentno
FROM result 
GROUP BY studentno;

# 三、查询姓张的每个学生的最低分数大于60的学生的学号和姓名
SELECT studentno, studentname, MIN(score)
FROM student s
INNER JOIN result r
ON s.studentno = r.studentno 
HAVING MIN(score)>60

# 四、查询生日在“1988-1-1”后的学生的姓名和专业名称
SELECT sutdentname, majorname
FROM student s 
INNER JOIN major m 
ON s.majorid = m.majorid 
WHERE DATEDIFF(borndate, '1988-1-1')>0;

# 五、查询每个专业的男生人数和女生人数
# 方式一：
SELECT sex, COUNT(*) 个数, majorid
FROM student 
GROUP BY sex, majorid;

# 方式二：
SELECT majorid, 
(SELECT COUNT(*) FROM student WHERE sex='男' AND majorid=s.majorid) 男, 
(SELECT COUNT(*) FROM student WHERE sex='女' AND majorid=s.majorid) 女 
FROM student s
GROUP BY majorid;

# 六、查询专业和张翠山一样的学生的最低分
# ①查询张翠山的专业编号
SELECT majorid 
FROM student 
WHERE studentname = '张翠山';
# ②查询专业编号=①的学生编号
SELECT studentno 
FROM student 
WHERE majorid = 
(
	SELECT majorid 
	FROM student 
	WHERE studentname = '张翠山'
);
# ③查询最低分，条件：学号为②的结果集
SELECT MIN(score)
FROM result 
WHERE studentno IN 
(
	SELECT studentno 
	FROM student 
	WHERE majorid = 
	(
		SELECT majorid 
		FROM student 
		WHERE studentname = '张翠山'
	)
);


# 七、查询分数大于60的学生的姓名、密码和专业名
# 三表连接
SELECT studentname, loginpwd, majorname 
FROM major m 
INNER JOIN student s 
ON m.majorid = s.majorid 
INNER JOIN result r 
ON r.studentno = s.studentno
WHERE r.score > 60;

# 八、按邮箱位数分组，查询每组的学生个数
SELECT COUNT(*), LENGTH(email)
FROM student 
GROUP BY LENGTH(email);

# 九、查询学生名、专业名和分数
SELECT studentname, majorname, score
FROM student s
INNER JOIN major m ON s.majorid = m.majorid 
LEFT OUTER JOIN result r ON r.studentno = s.studentno

# 十、 查询哪个专业没有学生，分别用左连接和右连接实现
# 左
SELECT m.majorid, m.majorname, s.studentno
FROM major m 
LEFT OUTER JOIN student s ON m.majorid = s.majorid 
WHERE s.studentno IS NULL;
# 右
SELECT m.majorid, m.majorname, s.studentno
FROM student s 
RIGHT OUTER JOIN major m ON m.majorid = s.majorid 
WHERE s.studentno IS NULL;

# 十一、查询没有成绩的学生人数
SELECT COUNT(*)
FROM student s
LEFT JOIN result r ON s.studentno = r.studentno 
WHERE r.id IS NULL;































