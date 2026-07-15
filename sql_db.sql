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

