use nab_practice;

select * from employees;


select department, sum(salary) as total_salary
 from employees 
 group by department;
 
 SELECT 
	department, 
	salary,
	hire_date,
row_number() over(partition by department order by salary asc) as rn
from employees;


 
