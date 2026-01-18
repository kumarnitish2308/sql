-- 9 Consecutive events
-- 🔗 https://youtu.be/WrToXXN7Jb4?si=goKi50hz6C6f5MC5

-- table schema

create table tasks (
date_value date,
state varchar(10)
);

insert into tasks
values 
('2019-01-01','success'),
('2019-01-02','success'),
('2019-01-03','success'),
('2019-01-04','fail'),
('2019-01-05','fail'),
('2019-01-06','success');

/*
A person performs a task and he fails on some day and get success on someday.
Write a SQL query to get the consecutive date for which he was successful or fail, 
incase of no success or failure for 2 consecutive days start and end date will be same.
*/

-- Solution 1
with state_group as(
select *,
	row_number() over(order by date_value)  - row_number() over(partition by state order by date_value) as grp
from tasks
order by date_value)

select state, min(date_value) as start_date, max(date_value) as end_date
from state_group
group by state, grp

-- Solution 2 
with group_created as(
select  
    *,
    date_sub(date_value, interval row_number() over(partition by state order by date_value) day) as group_date
from tasks)

select state, min(date_value) as start_date, max(date_value) as end_date
from group_created
group by state, group_date;