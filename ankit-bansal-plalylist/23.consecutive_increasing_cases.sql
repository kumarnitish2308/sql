-- 21 City where covid cases increased on consecutive days
-- 🔗 https://youtu.be/7okRHS6WL0c?si=CgXlIeKq-IFhQ8HN

-- table schema

create table covid
(
    city varchar(50),
    days date,
    cases int
);

insert into covid (city, days, cases) 
values
('delhi', '2022-01-01', 100),
('delhi', '2022-01-02', 200),
('delhi', '2022-01-03', 300),

('mumbai', '2022-01-01', 100),
('mumbai', '2022-01-02', 100),
('mumbai', '2022-01-03', 300),

('chennai', '2022-01-01', 100),
('chennai', '2022-01-02', 200),
('chennai', '2022-01-03', 150),

('bangalore', '2022-01-01', 100),
('bangalore', '2022-01-02', 300),
('bangalore', '2022-01-03', 200),
('bangalore', '2022-01-04', 400);

-- Solution 1

with flagged_city as (
select 
    city,
    cases,
    lead(cases,1) over(partition by city order by days),
    case when cases >= lead(cases,1) over(partition by city order by days) then 0 else 1 end as increase_flag
from covid
order by city)

select city from flagged_city
group by city
having count(distinct increase_flag) = 1 and max(increase_flag) = 1;

-- Solution 2

with flagged_cities as(
select city, cases,
    rank() over(partition by city order by days asc) as days_rank,
    rank() over(partition by city order by cases) as cases_rank,
    cast(rank() over(partition by city order by days asc) as signed) - 
    cast(rank() over(partition by city order by cases) as signed) as rank_difference
from covid)

select city from flagged_cities
group by city 
having count(distinct rank_difference) = 1 and max(rank_difference) = 0;


