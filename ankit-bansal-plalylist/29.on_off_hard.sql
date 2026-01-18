-- 29 Total number of login between login and logoff time
-- 🔗 https://youtu.be/XQ80MgsTka0?si=4FJ2sFrCa3w-VmeU
-- table schema

create table event_status
(
event_time varchar(10),
status varchar(10)
);

insert into event_status 
values
('10:01','on'),
('10:02','on'),
('10:03','on'),
('10:04','off'),
('10:07','on'),
('10:08','on'),
('10:09','off'),
('10:11','on'),
('10:12','off');

/*
login   logout  total_login
10:01	10:04	3
10:07	10:09	2
10:11	10:12	1
*/

-- Solution 1
with ranked_group as(
select 
    *,
	cast(right(event_time, 2) as unsigned) - row_number() over (order by event_time) as grp
    from event_status
order by event_time
)
select  
    min(event_time) as login, 
    max(event_time) as logout, 
    count(case when status = 'on' then 1 else null end) as total_login  
from ranked_group  
group by grp;

-- Solution 2
with grp_key as(
select
    *,
    sum(case when status = 'on' and prev_status = 'off' then 1 else 0 end) over(order by event_time asc) as group_key
from
(select 
    *,
    lag(status, 1, status) over(order by event_time asc) as prev_status
from event_status) a
)

select 
    min(event_time) as login_time,
    max(event_time) as logout_time,
    count(*) - 1 as total_login
from grp_key
group by group_key;
