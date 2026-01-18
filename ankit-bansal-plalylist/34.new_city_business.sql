-- 34 New city business
-- 🔗 https://youtu.be/y-CeVtidYJE?si=bfpiKwjoeNHqwjFg

-- table schema

create table business_city (
    business_date date,
    city_id int
);

insert into business_city 
(business_date, city_id) values
(cast('2020-01-02' as date), 3),
(cast('2020-07-01' as date), 7),
(cast('2021-01-01' as date), 3),
(cast('2021-02-03' as date), 19),
(cast('2022-12-01' as date), 3),
(cast('2022-12-15' as date), 3),
(cast('2022-02-28' as date), 12);



-- Write a SQL query to identify yearwise count of new cities where udaan started their operations

-- Solution 1
select yr, count(*) as '# New city'
from(
select city_id, year(min(business_date)) as yr
from business_city
group by city_id) a
group by yr

-- Solution 2
with year_cte as(
select city_id, year(business_date) as yr
from business_city)

select a.yr, count(case when b.city_id is null then a.city_id end) as total
from year_cte a
left join year_cte b on a.city_id = b.city_id and a.yr > b.yr
group by yr
