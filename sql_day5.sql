SELECT * FROM nab_practice.employees;

-- Q1 (Easy) Display each employee along with the number of employees working in the same department.

select name, department,
count(employee_id) over(partition by department) as total_employee_dep_wise
from employees;

-- Q2 (Easy) Find the highest-paid employee in every department.


with cte as (
select name, department, salary,
dense_rank() over (partition by department order by salary) as DR
from employees )
select * from cte
where DR=1 ;


-- Q3 (Easy) Display each employee along with the total salary paid in their department.

/* here the business problem is company want to see the each employee and total salary paid in a particular department 
by the company but here my question is why company wants to see the total paid salary along with each employee 
if they want to see the total paid salary by each department that makes sense but why the also want to see the employee along with it? */

/* ************ asnwer*************
let's say company have budget 50L/month for an AI department and let's say there are 15 employees, so now company wanna know How much each employee is
taking out of it- also this way they can decide the next increament cycle of increament adjustment for all 15 employees-*/ 



with cte as (
select name, salary, department,
sum(salary) over(partition by department) as total_dep_salary
from employees
)
select * from cte;

-- Question 5 List the departments whose average salary is greater than ₹150,000.

/* Business problem-- company wanna know what all are the department whose is getting more than 150,000 simple */

with cte as (
select department, salary,
avg(salary) over(partition by department) as avg_salary
from employees)
select * from cte
where avg_salary>=150000 ;


select avg(salary) as avg_salary, department from employees
group by department; -- here I am just qaing the avg salary in each department


 /*======Using GROUP BY + HAVING=======*/
 
SELECT avg(salary) as avg_salary, department 
from employees
group by department
having avg(salary)>=150000;

/*======Using CTEs=======*/

with dept_avg as(
select 
department,
avg(salary) as avg_salary
from employees 
group by department
)
select * from dept_avg
where avg_salary>150000;

-- Q5 (Easy) Display each employee's salary and show the difference between their salary and the highest salary in their department.

/* problem statement -  company wanna know how much we can increase the salary for all employees and we also need to 
see if we can match the salary of that highest paid employee */

-- with cte as (

select name, department, salary,

-- max(salary) over (partition by department) as max_sal,
abs(max(salary)  over(partition by department) - salary) as difference 

from employees;
--  select * from cte;

-- Q6 (Medium) Return the top 2 highest-paid employees from every department.

with cte as (
select name, department,
dense_rank() over(partition by department order by salary) as highest_paid_emp
from employees
)
select * from cte
where highest_paid_emp 
>= 2;

-- Q7 (Medium) Find all employees who earn more than the average salary of their own department.

with cte as (
select name, salary, department,
avg(salary) over (partition by department) as avg_sal
from employees)

select * from cte
where salary>=avg_sal;

-- Q8 (Medium) Assign a serial number to employees within each department based on their hire date.

with cte as (
select name, department, hire_date,
row_number() over(partition by department order by hire_date) as serial_number
from employees)
select * from cte;

-- Q9 (Medium) Find the second highest salary from every department.

with cte as( select
salary, department,
dense_rank() over(partition by department order by salary desc) as second_highest_sal
from employees)
select * from cte
where second_highest_sal =2;

-- Q10 (Medium) Display every employee along with the total number of employees in the company.

select name,
count(employee_id) over () as total_emp
from employees;


-- Q12 (Medium) Display employees whose salary is equal to the maximum salary in their department.

with cte as (
select name ,
salary, department,
max(salary) over (partition by department order by salary desc) as max_sal
from employees)
select * from cte
where salary =max_sal;

-- Q13 (Hard) For every department, calculate what percentage of the department's total salary each employee contributes.

