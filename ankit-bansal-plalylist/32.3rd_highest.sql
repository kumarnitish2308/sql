-- 32 Third highest salary with a twist 
-- 🔗 https://youtu.be/Cbm6Hz_Yhwg?si=GVe-hEptokvP4gqk

-- table schema

create table emp (
    emp_id int null,
    emp_name varchar(50) null,
    salary int null,
    manager_id int null,
    emp_age int null,
    dep_id int null,
    dep_name varchar(20) null,
    gender varchar(10) null
);


insert into emp 
(emp_id, emp_name, salary, manager_id, emp_age, dep_id, dep_name, gender) 
values
(1, 'Ankit', 14300, 4, 39, 100, 'Analytics', 'Female'),
(2, 'Mohit', 14000, 5, 48, 200, 'IT', 'Male'),
(3, 'Vikas', 12100, 4, 37, 100, 'Analytics', 'Female'),
(4, 'Rohit', 7260, 2, 16, 100, 'Analytics', 'Female'),
(5, 'Mudit', 15000, 6, 55, 200, 'IT', 'Male'),
(6, 'Agam', 15600, 2, 14, 200, 'IT', 'Male'),
(7, 'Sanjay', 12000, 2, 13, 200, 'IT', 'Male'),
(8, 'Ashish', 7200, 2, 12, 200, 'IT', 'Male'),
(9, 'Mukesh', 7000, 6, 51, 300, 'HR', 'Male'),
(10, 'Rakesh', 8000, 6, 50, 300, 'HR', 'Male'),
(11, 'Akhil', 4000, 1, 31, 500, 'Ops', 'Male');

/*Write a SQL query to find the details of the employee with the 3rd highest salary in the department
In case there are less than 3 employee in a department then return the employee with the min salary
*/

-- Solution 1

with salary_ranked as(
select 
    *,
    dense_rank() over(partition by dep_id order by salary desc) as rnk,
    count(*) over(partition by dep_id) as total_emp,
    min(salary) over(partition by dep_id) as min_salary
from emp
),


final as(
select 
    *,
    case 
    when max(rnk) = 3 then salary 
    when max(rnk) < 3 then min_salary else null 
    end as third_highest_salry
from salary_ranked
group by 1,2,3,4,5,6,7,8)

select emp_id, emp_name, salary, manager_id, emp_age, dep_id, dep_name, gender from final
where salary = third_highest_salry;

-- Solution 2

with salary_ranked as(
select 
    *,
    dense_rank() over(partition by dep_id order by salary desc) as rnk,
    count(*) over(partition by dep_id) as total_emp,
    min(salary) over(partition by dep_id) as min_salary
from emp
)

select * from salary_ranked
where rnk = 3 or(total_emp < 3 and rnk = total_emp);