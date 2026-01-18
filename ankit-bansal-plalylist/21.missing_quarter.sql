-- 20 Missing quarter for each store
-- 🔗 https://youtu.be/cGP5Tm2gVdQ?si=wt5aZaSXQb6C2NM5

-- table schema

create table stores (
Store varchar(10),
Quarter varchar(10),
amount int);

insert into stores 
values 
('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

-- Find missing quarter for each store

-- Solution 1
select store, concat('Q',(10 - sum(cast(right(quarter,1) as unsigned)))) as missing_quarter
from stores
group by store;

-- Solution 2
with all_quarter as(
select distinct quarter as quarter from stores
),

all_store as(
select distinct store as store from stores
),

/*
This will also work instead of both the above cte and then doing the cross join.

select distinct s1.store, s2.quarter from stores s1, stores s2
order by s1.store
*/

all_combination as(
select * from all_store
cross join all_quarter
order by store, quarter)

select a.store, a.quarter from all_combination a
left join stores s on s.store = a.store and a.quarter = s.quarter
where s.store is null
order by store;

