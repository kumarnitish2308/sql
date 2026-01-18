
-- 22) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.
with cte as(
select a.full_name, a.nationality
,count(1) as no_of_paintings
,rank() over(order by count(1) desc) as rnk
from work w
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
join museum m on m.museum_id=w.museum_id
where s.subject='Portraits'
and m.country != 'USA'
group by a.full_name, a.nationality)

select full_name as artist_name, nationality, no_of_paintings
from cte where rnk = 1

-- 21) Which are the 3 most popular and 3 least popular painting styles?
with cte as(
select style,
dense_rank() over(order by count(*) desc) as most
from work
where style is not null
group by style),

cte2 as(select style,
dense_rank() over(order by count(*) asc) as lowest3
from work
where style is not null
group by style)

select style,
case when most <=3 then 'most_popular'  end as remarks
from cte
where most <= 3
union all
select style,
case when lowest3 <=3 then 'least_popular'  end as remarks
from cte2
where lowest3 <= 3;


-- 20) Which country has the 5th highest no of paintings?
with cte as(
select m.country, 
count(*) as no_of_Paintings,
rank() over(order by count(*) desc) as rnk
from work w
join museum m on m.museum_id=w.museum_id
group by m.country)

select country, no_of_Paintings
from cte where rnk = 5



-- 19) Identify the artist and the museum where the most expensive and least expensive painting is placed. 

-- most expensive
with cte as(
select work_id,sale_price,
dense_rank() over(order by sale_price desc) as rnk
from product_size)

select a.full_name, m.name as museum_name
from work w 
join artist a on a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
where work_id in (select work_id from cte where rnk = 1);



-- least expensive
with cte as(
select work_id,sale_price,
dense_rank() over(order by sale_price asc) as rnk
from product_size)

select a.full_name, m.name as museum_name
from work w 
join artist a on a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
where work_id in (select work_id from cte where rnk = 1);



-- 18) Display the country and the city with most no of museums.
select country, city, count(museum_id) as total_museum
from museum
group by country,city;



-- 17) Identify the artists whose paintings are displayed in multiple countries
with cte as (
select w.artist_id, full_name, count(distinct country) as cnt
from work w 
join museum m on m.museum_id = w.museum_id
join artist a on a.artist_id = w.artist_id
group by w.artist_id, full_name)

select full_name,cnt as countries_displayed
from cte 
where cnt > 1
order by cnt desc;



-- 16) Which museum has the most no of most popular painting style?
with cte as(
select style,count(*)
,rank() over(order by count(*) desc) as rnk
from work
group by style),

cte2 as(
select museum_id, count(*) as total,
dense_rank() over(order by count(*) desc) as rn
from work
where style = (select style from cte where rnk = 1) and museum_id is not null
group by museum_id)

select c.museum_id, name as museum_name, total
from cte2 c
join museum m on m.museum_id = c.museum_id
where rn = 1;



-- 15) Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?
with cte as(
select museum_id,
str_to_date(open, '%h:%i:%p') as open_time,
str_to_date(close, '%h:%i:%p') as close_time,
timediff(str_to_date(close, '%h:%i:%p'), str_to_date(open, '%h:%i:%p')) as open_duration,
dense_rank() over(order by timediff(str_to_date(close, '%h:%i:%p'), str_to_date(open, '%h:%i:%p')) desc) as rnk
from museum_hours)

select  m.name, m.state, open_duration
from cte c
join museum m on m.museum_id = c.museum_id
where rnk = 1;


-- 14) Display the 3 least popular canvas sizes
with cte as(
select size_id, count(*) as cnt,
dense_rank() over(order by count(*)) as rnk
from product_size 
group by size_id)

select c.size_id, c2.label as canvas_name
from cte c
join canvas_size c2 on c2.size_id = c.size_id
where rnk <=3;


-- 13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
with cte as (
select artist_id, count(*) as cnt,
dense_rank() over(order by count(*) desc) as rnk
from work 
group by artist_id)

select c.artist_id, a.full_name, cnt as total_paintings
from cte c
join artist a on a.artist_id = c.artist_id
where rnk <= 5;


-- 12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
with cte as(
select museum_id,count(*) as cnt,
dense_rank() over(order by count(*) desc) as rnk
from work
where museum_id is not null
group by museum_id)

select c.museum_id, m.name
from cte c
join museum m on m.museum_id = c.museum_id
where rnk<=5;



-- 11) How many museums are open every single day?
select count(museum_id) from(
select museum_id,count(distinct day) as cnt
from museum_hours
group by museum_id)a
where cnt = 7;


-- 9) Fetch the top 10 most famous painting subject
with cte as(
select s.subject, count(*) as total,
dense_rank() over(order by count(*) desc) as rnk
from work w
join subject s on s.work_id = w.work_id
group by s.subject)

select subject from cte where rnk < 11;



-- 8) Museum_Hours table has 1 invalid entry. Identify it and remove it.
with cte as(
select museum_id,day,
row_number() over(partition by museum_id, day) as rn
from museum_hours)
delete from cte where rn > 1;

-- 7) Identify the museums with invalid city information in the given dataset
select name as musuem_name, city
from museum
where city regexp '[0-9]' or city is null;


-- 6) Delete duplicate records from work, product_size, subject and image_link tables
with cte as(
select work_id,
row_number() over(partition by work_id) as rn
from work)
delete from cte where rn > 1

-- 5) Which canva size costs the most?
with size_cost as(
select size_id,sale_price,
dense_rank() over(order by sale_price desc) as rnk
from product_size)

select a.size_id,label,a.sale_price
from size_cost a
join canvas_size b on a.size_id = b.size_id
where rnk = 1;

select work_id,count(*)
from work
group by work_id;



-- 4) Identify the paintings whose asking price is less than 50% of its regular price
select * from work;
select p.work_id,name from product_size p
join work w on w.work_id = p.work_id
where sale_price < (regular_price/2);


-- 3) How many paintings have an asking price of more than their regular price? 
select count(size_id) from product_size
where sale_price >regular_price;


-- 2) Are there museuems without any paintings?
select m.museum_id, name
from museum m
where m.museum_id not in(select distinct museum_id from work);


-- 1) Fetch all the paintings which are not displayed on any museums?
select count(*) from work where museum_id is null;



