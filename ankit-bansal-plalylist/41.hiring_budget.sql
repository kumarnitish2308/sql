-- 41 Hiring under budget
-- 🔗 https://youtu.be/KLqRHJ-Eg2s?si=F9z5cU-GGM4lQWbe

-- table schema

create table candidates (
emp_id int,
experience varchar(20),
salary int
);

insert into candidates values
(1,'Junior',10000),
(2,'Junior',15000),
(3,'Junior',40000),
(4,'Senior',16000),
(5,'Senior',20000),
(6,'Senior',50000);

/*
A company wants to hire new employees. The budget of the company for the salary is $70000.
The company's criteria for hiring are:
	keep hiring the seniors with the smallest salary until you cannot hire more seniors.
    Use the remaining budget to hire the junior with smallest salary.
    Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
write a query to find the seniors and juniors under these category.
*/

-- Solution 1
with all_salary as(
select
    *,
    sum(salary) over(partition by experience order by salary asc rows between unbounded preceding and current row) as running_salary
from candidates
),

seniors_hired as(
select * from all_salary 
where experience = 'Senior' and running_salary <=70000)

select * from all_salary
where experience = 'Junior' and  running_salary <= 70000 - (select sum(salary) from seniors_hired)
union
select * from seniors_hired