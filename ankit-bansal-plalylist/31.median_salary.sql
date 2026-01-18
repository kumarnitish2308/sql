-- 31 Median salary
-- 🔗 https://youtu.be/fwPk1RXlorQ?si=55HEz2UEHrFHIkoc

-- table schema

create table employee 
(
emp_id int,
company varchar(10),
salary int
);

insert into employee (emp_id, company, salary) 
values 
(1, 'A', 2341),
(2, 'A', 341),
(3, 'A', 15),
(4, 'A', 15314),
(5, 'A', 451),
(6, 'A', 513),
(7, 'B', 15),
(8, 'B', 13),
(9, 'B', 1154),
(10, 'B', 1345),
(11, 'B', 1221),
(12, 'B', 234),
(13, 'C', 2345),
(14, 'C', 2645),
(15, 'C', 2645),
(16, 'C', 2652),
(17, 'C', 65);

-- Find median salary of employee without using any inbuilt function for median

-- Solution 1
with computed as(
select 
    *,
    dense_rank() over(partition by company order by salary) as rnk,
    count(*) over(partition by company) as total_employee
from employee
order by company)

select company, round(avg(salary)) as median_salary
from computed 
where rnk between total_employee/2 and total_employee/2 + 1
group by company;

-- Solution 2
with computed as (
select
    company,
    salary,
    row_number() over (partition by company order by salary) as rn,
    count(*) over (partition by company) as total_employee
from employee
)

select
    company,
    round(avg(salary)) as median_salary
from computed
where
    (total_employee % 2 = 1 and rn = (total_employee + 1) / 2) -- For odd number of employees 
    or (total_employee % 2 = 0 and (rn = total_employee / 2 or rn = total_employee / 2 + 1)) -- for even number of employees
group by company;