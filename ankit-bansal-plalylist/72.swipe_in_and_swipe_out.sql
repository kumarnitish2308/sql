-- 72 Swipe in and swipe out
-- 🔗 https://youtu.be/Jo2Ra41QQcU?si=GDkGYSOLzJL3LIR0

-- table schema
CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time datetime
);


INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');

select * from swipe 
order by employee_id;

/*
we have a swipe table which keeps track of employees login and logout time.
Find out the time spent by the employee in office on any particular day(office hours = last logout time - first login time)
Find out how productive he was at office at any particular day(He might have done many swipe-in and swipe-out in a day but what is the actual time spent by him in the office)
*/

-- Solution 1
with calculated_base as(
select 
    employee_id,
    activity_type,
    activity_time as login_time,
    timestampdiff(hour, min(activity_time) over(partition by employee_id, date(activity_time)),max(activity_time) over(partition by employee_id, date(activity_time))) as working_hours,
    case when activity_type = 'login' then lead(activity_time) over (partition by employee_id order by employee_id, activity_time) else null end as logout_time,
    case when activity_type = 'login' then timestampdiff(hour, activity_time, lead(activity_time) over (partition by employee_id order by employee_id, activity_time)) else null end as duration_in_hours
from swipe)
select 
    employee_id,
    date(login_time) as activity_day,
    working_hours as total_hours,
    sum(duration_in_hours) as productive_hours
from calculated_base
where logout_time is not null
group by 1,2,3
order by activity_day

