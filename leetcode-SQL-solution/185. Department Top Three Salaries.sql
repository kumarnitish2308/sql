-- 185. Department Top Three Salaries

-- ranking salary within each department and finding their department name
with dept_salary_ranked as(
select e.name as employee, e.salary, d.name as department,
dense_rank() over(partition by d.name order by e.salary desc) as rnk
from employee e
join department d on d.id = e.departmentId)

-- selecting only those who are top 3 earner in each department
select department, employee, salary 
from dept_salary_ranked where rnk <= 3;
