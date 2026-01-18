-- 46 Uber's driver profit
-- 🔗 https://youtu.be/eayyD51fIVY?si=FF95_Zt4idg1KuGI

-- table schema

create table drivers (
id varchar(10),
start_time time,
end_time time,
start_loc varchar(10),
end_loc varchar(10)
);

insert into drivers 
(id, start_time, end_time, start_loc, end_loc) 
values
('dri_1', '09:00', '09:30', 'a', 'b'),
('dri_1', '09:30', '10:30', 'b', 'c'),
('dri_1', '11:00', '11:30', 'd', 'e'),
('dri_1', '12:00', '12:30', 'f', 'g'),
('dri_1', '13:30', '14:30', 'c', 'h'),
('dri_2', '12:15', '12:30', 'f', 'g'),
('dri_2', '13:30', '14:30', 'c', 'h');

/* Write a query to print the total rides and profit rides for each driver.
Profit ride is when the end location of current ride is same as start location of next ride.
*/

-- Solution 1
with rides as (
select
	id,
	start_loc,
    end_loc,
	lead(start_loc,1) over (partition by id order by end_time asc) as next_start_loc
    from drivers
)
select
    id,
    count(*) as total_rides,
    sum(case when end_loc = next_start_loc then 1 else 0 end) as total_profit_rides
from rides
group by id;

-- Solution 2
with drivers_partition as(
select 
    *,
    row_number() over(partition by id order by start_time asc) as rnk
from drivers
)

select 
    id,
    count(*) as total_ride,
    sum(case when end_loc = start_loc_2 then 1 else 0 end) as total_profit_rides
from
(
select d1.*, d2.start_loc as start_loc_2 
from drivers_partition d1 
left join drivers_partition d2 on d1.id = d2.id and d1.rnk = d2.rnk - 1
) a
group by id;

