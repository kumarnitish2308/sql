-- 33 Human traffic of stadium
-- 🔗 https://youtu.be/tDfAo7uw-3w?si=xQizRzr12H0nQQX6

-- table schema

create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10),
(2,'2017-07-02',109),
(3,'2017-07-03',150),
(4,'2017-07-04',99),
(5,'2017-07-05',145),
(6,'2017-07-06',1455),
(7,'2017-07-07',199),
(8,'2017-07-08',188);

/*Write a SQL query to display the records which have 3 or more consecutive rows with the 
with the number of people more than or equal to 100 each day */

-- Solution 1

with grp as(
select 
    *,
    id- row_number() over(order by visit_date) as grp
from stadium
where no_of_people >=100),

result_grp as(
select grp, count(*) as total
from grp
group by grp
having count(*) >=3)

select * from grp
join result_grp -- on result_grp.grp = grp.grp
where result_grp.grp = grp.grp

-- Solution 2 
-- It can be solved using lead_lag also