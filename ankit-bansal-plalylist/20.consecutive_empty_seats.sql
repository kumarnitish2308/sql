-- 20 Consecutive empty seats
-- 🔗 https://youtu.be/F9Otofceer0?si=ivrD52NLeBAtBAZ0

-- table schema

create table bms 
(seat_no int ,
is_empty varchar(10)
);
insert into bms values
(1,'N'),
(2,'Y'),
(3,'N'),
(4,'Y'),
(5,'Y'),
(6,'Y'),
(7,'N'),
(8,'Y'),
(9,'Y'),
(10,'Y'),
(11,'Y'),
(12,'N'),
(13,'Y'),
(14,'Y');

-- Write a sql query to find the 3 or more consecutive empty seats

-- Solution 1
with grp_base as(
select 
    seat_no,
    seat_no - row_number() over(partition by is_empty order by seat_no asc) as grp
from bms
where lower(is_empty) = 'y')

select seat_no from grp_base where grp in 
(
select grp from grp_base group by grp
having count(*) >= 3
);

select * from bms
where is_empty = 'Y';

-- Solution 2
select seat_no from
(
select 
    *,
    lag(is_empty,1) over(order by seat_no) as prev_1,
    lag(is_empty,2) over(order by seat_no) as prev_2,
    lead(is_empty,1) over(order by seat_no) as next_1,
    lead(is_empty,2) over(order by seat_no) as next_2
from bms) a
where is_empty = 'Y' and prev_1 = 'Y' and prev_2 = 'Y'
	or( is_empty = 'Y' and next_1 = 'Y' and next_2 = 'Y')
    or(next_1 = 'Y' and is_empty = 'Y' and prev_1 = 'Y')
order by seat_no;
