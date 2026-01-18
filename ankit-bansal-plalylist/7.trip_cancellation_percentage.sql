-- 7 Trip cancellation
-- 🔗 https://youtu.be/Ydwm7y4y4k8?si=fD9lWHaS_vtgNDqC

-- table schema

create table trips (
id int,
client_id int, 
driver_id int, 
city_id int, 
status varchar(50), 
request_at varchar(50));

Create table users (
users_id int, 
banned varchar(50), 
role varchar(50));


insert into Trips (id, client_id, driver_id, city_id, status, request_at) 
values 
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');

insert into Users (users_id, banned, role) 
values 
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');

/*
Write a sql query to find the cancellation rate of request with unbanned users
(both client and driver must not be banned) each day between "2013-10-01" and "2013-10-03"
Round cancellation rate to 2 decimal points.

The cancellation rate is computed by dividing the number of cancelled (by client or driver)
requests with unbanned users by the total number of requests with unbanned users on that day.
*/

-- Solution 1
with combined_base as(
select 
    client_id, 
    u.banned as client_banned, 
    driver_id, 
    u1.banned as driver_banned, 
    status, 
    request_at 
from trips t
left join users u on u.users_id = t.client_id
left join users u1 on u1.users_id = t.driver_id
where u.banned = 'No' and u1.banned = 'No')

select 
    request_at,
    count(*) as total_trips,
    sum(case when status != 'completed' then 1 else 0 end) as cancelled_trips,
    round(100*sum(case when status != 'completed' then 1 else 0 end)/count(*),2) as cancellation_percentage
from combined_base
group by request_at