
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
inner join students as s on s.student_id = total_stats.student_id;
