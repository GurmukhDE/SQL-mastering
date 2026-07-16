-- ==========================================
-- CREATE DATABASE
-- ==========================================

CREATE DATABASE sql_practice;

USE sql_practice;

-- ==========================================
-- TABLE 1 : STUDENTS
-- ==========================================

CREATE TABLE students (
    student_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    branch VARCHAR(10)
);

INSERT INTO students (student_id, name, branch) VALUES
('S101','Amit','CS'),
('S102','Rahul','IT'),
('S103','Priya','EE'),
('S104','Neha','ME'),
('S105','Karan','CE'),
('S106','Sneha','AI'),
('S107','Vikas','CS'),
('S108','Pooja','IT'),
('S109','Rohit','AI'),
('S110','Anjali','EE');



-- ==========================================
-- TABLE 2 : EXAM SCORES
-- ==========================================

CREATE TABLE exam_scores (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10),
    subject VARCHAR(50),
    score INT,
    exam_month VARCHAR(20),

    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
);

INSERT INTO exam_scores(student_id,subject,score,exam_month) VALUES

('S101','Math',92,'January'),
('S101','Physics',88,'January'),
('S101','SQL',95,'February'),

('S102','Math',70,'January'),
('S102','Physics',75,'January'),
('S102','SQL',80,'February'),

('S103','Math',84,'January'),
('S103','Physics',82,'January'),
('S103','SQL',86,'February'),

('S104','Math',60,'January'),
('S104','Physics',67,'January'),
('S104','SQL',72,'February'),

('S105','Math',91,'January'),
('S105','Physics',89,'January'),
('S105','SQL',94,'February'),

('S106','Math',98,'January'),
('S106','Physics',96,'January'),
('S106','SQL',99,'February'),

('S107','Math',77,'January'),
('S107','Physics',79,'January'),
('S107','SQL',83,'February'),

('S108','Math',81,'January'),
('S108','Physics',85,'January'),
('S108','SQL',87,'February'),

('S109','Math',94,'January'),
('S109','Physics',93,'January'),
('S109','SQL',97,'February'),

('S110','Math',69,'January'),
('S110','Physics',72,'January'),
('S110','SQL',75,'February');



-- ==========================================
-- TABLE 3 : PROJECTS
-- ==========================================

CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10),
    title VARCHAR(100),
    marks INT,

    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
);

INSERT INTO projects(student_id,title,marks) VALUES

('S101','Library Management',88),
('S102','Online Shopping',70),
('S103','Smart Attendance',80),
('S104','Hospital System',68),
('S105','Bank Management',91),
('S106','AI Chatbot',99),
('S107','Movie Recommendation',84),
('S108','Food Delivery',82),
('S109','Fraud Detection',96),
('S110','Student Portal',73);



-- ==========================================
-- VERIFY DATA
-- ==========================================

	SELECT * FROM students;

	SELECT * FROM exam_scores;

	SELECT * FROM projects;

	-- Write a query to find out the student name who are eligible for placement, 
	-- the placement criteria is- 
	-- 1 - at least 1 exam should attempted and scored >=90
	-- 2 - any one project score should be >=85

	SELECT s.student_id, s.name, s.branch
	from students as s
	where s.student_id IN (
	SELECT s.student_id from exam_scores where score >=90)
	AND
	s.student_id IN (
	SELECT s.student_id from projects where marks >=85);

	SELECT * FROM students;
	select * from exam_scores;
	select * from projects;

	SELECT s.student_id, s.name as student_name,
	e.score,
	e.subject
	from students as s
	inner join exam_scores as e on 
	s.student_id = e.student_id
	where e.score>( select avg(score) as class_avg_marks
	from exam_scores);

	select avg(score) as class_avg_marks
	from exam_scores;


	-- Write a query to find out the student name who are eligible for placement, 
	-- the placement criteria is- 
	-- 1 - at least 1 exam should attempted and scored >=90
	-- 2 - any one project score should be >=85
	-- solve it using join and subquery

	select * from projects;
	select * from students;
	select * from exam_scores;

	SELECT 
	s.name,
	e.score,
	p.marks
	from students  s
	inner join exam_scores e on
	s.student_id = e.student_id
	inner join projects p on
	s.student_id = p.student_id
	where e.score>=90 and p.marks>=85;

	--  write a query to have total score student has earned and number of exams student has attempted, we also need student name and branch.



	select s.name,
	s.branch,
	total_stats.total_score,
	total_stats.no_of_attempts
	 from 
	(select student_id,
	sum(score) as total_score,
	count(*) as no_of_attempts
	from exam_scores
	group by student_id) as total_stats
	inner join students as s on s.student_id = total_stats.student_id
    order by total_stats.total_score desc;
    
    -- for each project get the student's name, branch, project marks, and their avg exam makrs on the same row.
    
    select 
    s.name,
    s.branch,
    p.marks as avg_marks,
    avg(marks)
    from students as s
    inner join projects as p
    on
    s.student_id = p.student_id
  group by s.student_id, avg_marks ;
    
    
    
select * from projects;
	select * from students;
	select * from exam_scores;


#  select s.student_id, s.name, s.branch, p.project_id
 -- from student s
-- where exists project_id  in 

-- (p.student_id = s.student_id);


select s.name, 
s.branch ,
s.student_id
from students s

where s.name is not null and  exists (
select * from projects p 
where p.student_id = s.student_id);


-- Find the name and branch of students who have scored 95 or more in any exam.


select s.name, s.branch
from students s 
where student_id in 
(select student_id 
from exam_scores e where e.score>=90);

select s.name, s.branch
from students s 
where score in 
(select e.score 
from exam_scores e where e.score>=90);

-- Find the students who have never attempted any project.

Select s.student_id,
s.name,
s.branch
from students s 
where (
select * from projects p 
where p.student_id = s.student_id);


