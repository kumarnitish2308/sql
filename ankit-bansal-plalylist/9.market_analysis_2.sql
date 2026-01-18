-- 9 Market Analysis 2
-- 🔗 https://youtu.be/1ias-sP_XAY?si=lpR1cbBeVRgRIR6g

-- table schema

drop table if exists users;
create table users (
user_id int     ,
join_date date    ,
favorite_brand  varchar(50)
);

drop table if exists orders;
 create table orders (
 order_id int,
 order_date date,
 item_id int,
 buyer_id int,
 seller_id int 
 );

 create table items(
 item_id int,
 item_brand varchar(50)
 );


 insert into users 
 values 
 (1,'2019-01-01','Lenovo'),
 (2,'2019-02-09','Samsung'),
 (3,'2019-01-19','LG'),
 (4,'2019-05-21','HP');

 insert into items 
 values 
 (1,'Samsung'),
 (2,'Lenovo'),
 (3,'LG'),
 (4,'HP');

 insert into orders 
 values 
 (1,'2019-08-01',4,1,2),
 (2,'2019-08-02',2,1,3),
 (3,'2019-08-03',3,2,3),
 (4,'2019-08-04',1,4,2),
 (5,'2019-08-04',1,3,4),
 (6,'2019-08-05',2,2,4);
 
 /*
write a query to find for each seller whether the brand of second item they sold is their favourite brand or not .
If a seller sold less than 2 items report the answer for that seller as 'No'.
*/

-- Solution 1
with base as(
select u.user_id, favorite_brand, i.item_brand as sold_brand,
row_number() over(partition by seller_id order by order_date) as rnk
from users u
left join orders o on o.seller_id = u.user_id
left join items i on i.item_id = o.item_id)

select 
    user_id,
    case when favorite_brand = sold_brand then 'Yes' else 'No' end as fav_brand
from base
where rnk = 2 or sold_brand is null