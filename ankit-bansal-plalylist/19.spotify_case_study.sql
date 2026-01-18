-- 19 Spotify case study
-- 🔗 https://youtu.be/-YdAIMjHZrM?si=g4yLLfPXLbIau0tz

-- table schema

create table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);


insert into activity 
values 
(1,'app-installed','2022-01-01','India'),
(1,'app-purchase','2022-01-02','India'),
(2,'app-installed','2022-01-01','USA'),
(3,'app-installed','2022-01-01','USA'),
(3,'app-purchase','2022-01-03','USA'),
(4,'app-installed','2022-01-03','India'),
(4,'app-purchase','2022-01-03','India'),
(5,'app-installed','2022-01-03','SL'),
(5,'app-purchase','2022-01-03','SL'),
(6,'app-installed','2022-01-04','Pakistan'),
(6,'app-purchase','2022-01-04','Pakistan');

-- 1. Find total active user each day
select event_date, count(distinct user_id) as total_active_user from activity
group by 1;

-- 2. Find active users each week
select week(event_date)+1 as week_number, count(distinct user_id) as total_active_user from activity
group by 1;

-- 3. day wise total number of users who installed the app and purchased on the same day
with installation_base as(
select * from activity 
where event_name = 'app-installed'), 

purchase_base as(
select * from activity 
where event_name = 'app-purchase'),

all_dates_base as(
select distinct event_date as event_date from activity)

select c.event_date, sum(case when b.user_id is not null then 1 else 0 end) as total_user
from all_dates_base c
left join installation_base a on a.event_date = c.event_date
left join purchase_base b on a.user_id = b.user_id and a.event_date = b.event_date
group by c.event_date;

/*
4. Out of total paid users percentage of paid users in India, USA and any other country should be tagged as othets 
country users_percentage
India  40
USA    20
Others 40
*/
with country_app_purchase as(
select 
	case when country in ('USA','India') then country else 'Others' end as country_name,
    count(distinct case when event_name = 'app-purchase' then user_id end) as total_users
from activity 
group by case when country in ('USA','India') then country else 'others' end)

select country_name, round(100*total_users/sum(total_users) over(), 2) as paid_user_percentage
from country_app_purchase;

/*
5. Among all the users who installed the app on a given day, how many did in app purchase on the very next day.
2022-01-01 0
2022-01-02 1
2022-01-03 0
2022-01-04 0
*/

select distinct a.event_date, count(distinct b.user_id) as total_user
from activity a
left join activity b on a.user_id = b.user_id and a.event_date = date_add(b.event_date, interval 1 day)
group by a.event_date;

