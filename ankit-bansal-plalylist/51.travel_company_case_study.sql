-- 51 Travel company case study
-- 🔗 https://youtu.be/XsbqEx_3GiM?si=gArMTbqLfF3sXruq

-- table schema


create table booking_table 
(
booking_id       varchar(3) not null,
booking_date     date not null,
user_id          varchar(2) not null,
line_of_business varchar(6) not null
);

insert into booking_table 
(booking_id, booking_date, user_id, line_of_business) 
values
('b1',  '2022-03-23', 'u1', 'Flight'),
('b2',  '2022-03-27', 'u2', 'Flight'),
('b3',  '2022-03-28', 'u1', 'Hotel'),
('b4',  '2022-03-31', 'u4', 'Flight'),
('b5',  '2022-04-02', 'u1', 'Hotel'),
('b6',  '2022-04-02', 'u2', 'Flight'),
('b7',  '2022-04-06', 'u5', 'Flight'),
('b8',  '2022-04-06', 'u6', 'Hotel'),
('b9',  '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-10', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-16', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-20', 'u5', 'Hotel'),
('b15', '2022-04-22', 'u6', 'Flight'),
('b16', '2022-04-26', 'u4', 'Hotel'),
('b17', '2022-04-28', 'u2', 'Hotel'),
('b18', '2022-04-30', 'u1', 'Hotel'),
('b19', '2022-05-04', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

-- Create the user_table
create table user_table 
(
user_id varchar(3) not null,
segment varchar(2) not null
);

-- Insert data into user_table
insert into user_table (user_id, segment) values
('u1',  's1'),
('u2',  's1'),
('u3',  's1'),
('u4',  's2'),
('u5',  's2'),
('u6',  's3'),
('u7',  's3'),
('u8',  's3'),
('u9',  's3'),
('u10', 's3');

/* Problem 1
Write a SQL query to find the total count of user in each segment who booked flight in Apr 2022
*/

select 
    a.segment, 
    count(distinct a.user_id) as total_user_count,
    count(distinct(case when line_of_business = 'Flight' and month(booking_date) = 4 and year(booking_date) = 2022 then a.user_id end )) user_who_booked_in_apr_2022
from user_table a
left join booking_table b on a.user_id = b.user_id
group by 1;

/* Problem 2
Write a SQL query to find users whose first booking was a hotel booking.
*/
with ranked_booking as
(
select
    *,
    rank() over(partition by user_id order by booking_date asc) as rnk
from booking_table
)
select * from ranked_booking
where lower(line_of_business) = 'Hotel' and rnk = 1;

/* Problem 3
Write a SQL query to calculate the days between first and last booking of each user
*/

select 
    user_id, 
    min(booking_date) as first_booking_date,
    max(booking_date) as last_booking_date,
    datediff(max(booking_date),min(booking_date)) as booking_diff
from booking_table
group by user_id;

/* Problem 4
Write a SQL query to count the number of flight and hotel bookings in each of the segments for the year 2022
*/
select 
    segment,
    count(case when lower(line_of_business) = 'flight' then b.user_id end) as total_flight_bookings,
    count(case when lower(line_of_business) = 'hotel' then b.user_id end) as total_hotel_bookings
from booking_table a 
left join user_table b on a.user_id = b.user_id
group by segment;
