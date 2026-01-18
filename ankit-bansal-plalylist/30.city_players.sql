-- 30 Find players in each city
-- 🔗 https://youtu.be/e-I9SxbLky8?si=VbBwImt1_gh8uXhj

-- table schema

create table players_location
(
name varchar(20),
city varchar(20)
);

insert into players_location
values 
('Sachin','Mumbai'),
('Virat','Delhi') , 
('Rahul','Bangalore'),
('Rohit','Mumbai'),
('Mayank','Bangalore');

/*
Find players in each city

output

Bangalore  Mumbai   Delhi
Mayank	   Rohit	Virat
Rahul	   Sachin	
*/
select * from(
select
	case when city = 'Bangalore' then name end as 'Bangalore',
    case when city = 'Mumbai' then name end as 'Mumbai',
    case when city = 'Delhi' then name end as 'Delhi'
from players_location
) a;

with player_group as(
select 
    *,
    row_number() over(partition by city order by name asc) as player_grp
from players_location)

select 
    max(case when city = 'Bangalore' then name end) as 'Bangalore',
    max(case when city = 'Mumbai' then name end) as 'Mumbai',
    max(case when city = 'Delhi' then name end) as 'Delhi'
from player_group
group by player_grp;
