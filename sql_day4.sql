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

-- Get the highest-paid employee from each department--
 
 with highest_salary as
 ( select
 name, 
 salary, 
 department,
 row_number() over (partition by department order by salary desc)as rn
 from employees)
 select * from 
 highest_salary
 where rn =1;
 
 -- Top 3 highest-paid employees from each department
 
 
  with top_3_highest_salary as
 ( select
 name, 
 salary, 
 department,
 row_number() over (partition by department order by salary desc)as Rn
 from employees)
 select * from 
 top_3_highest_salary
 where Rn <=3;
 
 -- window aggregate fucntion--
 
WITH manager_details AS
(
    SELECT
        employee_id,
        name,
        hire_date,
        manager_id,
        COUNT(*) OVER (PARTITION BY manager_id) AS total_employee
    FROM employees
)
SELECT *
FROM manager_details;


 select * from employees;
 
 -- Show only those managers who have more than 3 employees.
 
 with cte as (
 
 select manager_id, employee_id,name,
 count(*) over(partition by manager_id) as reportee_count
 from employees
 )
 select * from cte
 where reportee_count>=3;
