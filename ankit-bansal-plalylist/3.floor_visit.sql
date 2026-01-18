-- 3 Floor visit
-- 🔗 https://youtu.be/P6kNMyqKD0A?si=54TeuORa-xTRVNsG

-- table schema
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values 
('A','Bangalore','A@gmail.com',1,'CPU'),
('A','Bangalore','A1@gmail.com',1,'CPU'),
('A','Bangalore','A2@gmail.com',2,'DESKTOP'),
('B','Bangalore','B@gmail.com',2,'DESKTOP'),
('B','Bangalore','B1@gmail.com',2,'DESKTOP'),
('B','Bangalore','B2@gmail.com',1,'MONITOR');


-- Solution 1 
 
with floor_visit as(
select 
	name,
    floor,
    count(*) as total_visit,
    resources
from entries
group by name, floor, resources),

max_visit as 
(
select 
	name,
    max(total_visit) as max_visit
from floor_visit
group by name),

unique_resources as 
(
select  
    name, 
    group_concat(distinct resources order by resources separator ', ') AS unique_resources 
  from entries 
group by  name)

select 
	a.name,
    sum(total_visit) as total_visit,
    max(case when a.total_visit = b.max_visit then floor end) as floor,
    c.unique_resources as resources_used
from floor_visit a 
left join max_visit b on a.name = b.name
left join unique_resources c on c.name = b.name
group by a.name, c.unique_resources;

