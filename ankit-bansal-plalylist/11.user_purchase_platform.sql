-- 11 User purchase platform
-- 🔗 https://youtu.be/4MLVfsQEGl0?si=M3Y3vpaP4cn_xGAc

-- table schema

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending 
values
(1,'2019-07-01','mobile',100),
(1,'2019-07-01','desktop',100),
(2,'2019-07-01','mobile',100),
(2,'2019-07-02','mobile',100),
(3,'2019-07-01','desktop',100),
(3,'2019-07-02','desktop',100);


/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
If a user make purchase using mobile and desktop both on the same date then only it will be included in the both result
*/

-- Solution 1

with purchase_count as(
select spend_date, user_id, count(distinct platform) as total_purchase
from spending
group by spend_date, user_id
order by spend_date
),

aggregated_data as(
select 
    a.spend_date, 
    case when a.spend_date = b.spend_date and a.user_id = b.user_id and b.total_purchase > 1  then 'both' else platform end as platform, 
    sum(a.amount) as total_amount,
    count(distinct a.user_id) as total_users
from spending a 
left join purchase_count b on a.spend_date = b.spend_date and a.user_id = b.user_id
group by 1,2),

date_platform_combination as(
select spend_date, 'mobile' as platform from spending
union
select spend_date, 'desktop' as platform from spending
union
select spend_date, 'both' as platform from spending
)

select a.*, coalesce(b.total_amount, 0), coalesce(b.total_users,0)
from date_platform_combination a
left join aggregated_data b on a.spend_date = b.spend_date and a.platform = b.platform
order by a.spend_date, b.platform;
