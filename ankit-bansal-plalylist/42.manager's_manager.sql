-- 42 Manager's manager
-- 🔗 https://youtu.be/8glk10JlvKE?si=H-siH2BX1H-oc_Ad

-- table schema

create table emp (
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int
);

insert into emp 
(emp_id, emp_name, department_id, salary, manager_id, emp_age) 
values
(1, 'Ankit', 100, 10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 12000, 4, 37),
(4, 'Rohit', 100, 14000, 2, 16),
(5, 'Mudit', 200, 20000, 6, 55),
(6, 'Agam', 200, 12000, 2, 14),
(7, 'Sanjay', 200, 9000, 2, 13),
(8, 'Ashish', 200, 5000, 2, 12),
(9, 'Mukesh', 300, 6000, 6, 51),
(10, 'Rakesh', 500, 7000, 6, 50);

-- Write a query to list emp name along with their manager and senior manager name.
-- Senior manager is manager's manager

select 
    e1.emp_id,
    e1.emp_name,
    e2.emp_name as 'manager_name',
    e3.emp_name as 'senior_manager'
from emp e1
left join emp e2 on e1.manager_id = e2.emp_id
left join emp e3 on e2.manager_id = e3.emp_id
order by e1.emp_id;