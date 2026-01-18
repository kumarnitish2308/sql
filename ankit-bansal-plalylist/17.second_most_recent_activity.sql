-- 17 Second most recent activity
-- 🔗 https://youtu.be/RljzVfz8vjk?si=48nfVVoHPMW5veIV

-- table schema

create table user_activity
(
user_name varchar(20) ,
activity varchar(20),
start_date Date   ,
end_date Date
);

insert into user_activity 
values 
('Alice','Travel','2020-02-12','2020-02-20'),
('Alice','Dancing','2020-02-21','2020-02-23'),
('Alice','Travel','2020-02-24','2020-02-28'),
('Bob','Travel','2020-02-11','2020-02-18');

/*
Find second most recent activity and if user has only 1 activity 
then return that as it is.
*/

-- Solution 1

select * from 
(
select *,
    count(*) over(partition by user_name) as total_activity,
    rank() over(partition by user_name order by start_date desc) as rnk
from user_activity) a
where total_activity = 1 or rnk = 2;
