-- 13 Amazon prime subscription
-- 🔗 https://youtu.be/i_ljK9gmstY?si=1Mu_6oxnU65SvstG

-- table schema

drop table if exists users;
create table users
(
user_id integer,
name varchar(20),
join_date date
);

truncate table users;
select * from users;
insert into users (user_id, name, join_date) 
values  
(1, 'Jon', '2020-02-14'),  
(2, 'Jane', '2020-02-14'),  
(3, 'Jill', '2020-02-15'),  
(4, 'Josh', '2020-02-15'),  
(5, 'Jean', '2020-02-16'),  
(6, 'Justin', '2020-02-17'), 
(7, 'Jeremy', '2020-02-18');

create table events
(
user_id integer,
type varchar(10),
access_date date
);
insert into events (user_id, type, access_date) 
values 
(1, 'Pay', '2020-03-01'),  
(2, 'Music', '2020-03-02'),  
(2, 'P', '2020-03-12'), 
(3, 'Music', '2020-03-15'),  
(4, 'Music', '2020-03-15'),  
(1, 'P', '2020-03-16'),  
(3, 'P', '2020-03-22');

/* Return the fraction of users rounded to two decimal places, who accessed Amazon music and upgraded to 
prime membership within the first 30 days of signup */

-- Solution 1

with music_base as(
select * from users u
where user_id in (select user_id from events e where lower(e.type) = 'music')
),

prime_base as(
select * from events
where type = 'P'
)

select 
	round(100*(count(distinct case when datediff(p.access_date, m.join_date) <=30 then m.user_id end)/count(distinct(m.user_id))),2) as ratio
from music_base m
left join prime_base p on m.user_id = p.user_id;

-- Solution 2

select round(100*(sum(case when datediff(e1.access_date, u.join_date) <= 30 then 1 else 0 end)/count(*)),2) as ratio
from users u
left join events e on e.user_id = u.user_id
left join events e1 on e1.user_id = u.user_id and e1.type = 'P'
where lower(e.type) = 'music'
