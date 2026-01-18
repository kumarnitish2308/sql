-- Sending vs. Opening Snaps [Snapchat SQL Interview Question]

-- Solution 1
with cte as (
select age_bucket,
sum(case when activity_type = 'send' then time_spent end) over (partition by age_bucket) as send_spent,
sum(case when activity_type = 'open' then time_spent end) over (partition by age_bucket) as open_spent
from
activities as a
join age_breakdown as b on a.user_id = b.user_id
)

select distinct age_bucket,
round((100 * send_spent / (send_spent + open_spent)), 2) as send_perc,
round((100 * open_spent / (send_spent + open_spent)), 2) as open_perc
from cte;

-- Solution 2
select age_bucket,
round(100*sum(case when activity_type = 'send' then time_spent end)/sum(time_spent),2) as send_perc,
round(100*sum(case when activity_type = 'open' then time_spent end)/sum(time_spent),2) as open_perc
from activities a
join age_breakdown b on b.user_id = a.user_id
where a.activity_type IN ('send', 'open') 
group by age_bucket
