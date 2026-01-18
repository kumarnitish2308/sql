-- 13 Product pair
-- 🔗 https://youtu.be/9Kh7EnZlhUg?si=pWX1o2m0T340_Onn

-- table schema
create table orders
(
order_id int,
customer_id int,
product_id int
);

insert into orders 
values 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);

insert into products 
values 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

/* 
Find the most ordered product pair
*/

-- Solution 1
select concat(p1.name, " ", p2.name) as pair, count(*) as purchase_freq
from orders a 
join orders b on a.order_id = b.order_id and a.product_id < b.product_id
join products p1 on p1.id = a.product_id
join products p2 on p2.id = b.product_id
group by 1;

-- Solution 2

with product_pairs as(
select 
	a.order_id,
	least(a.product_id, b.product_id) AS product_id1,
	greatest(a.product_id, b.product_id) AS product_id2
from orders a 
join orders b on a.order_id = b.order_id and a.product_id < b.product_id),

pair_names as (
select  
	pp.product_id1, 
	pp.product_id2, 
	concat(p1.name, ' ', p2.name) AS pair
from product_pairs pp
join products p1 on pp.product_id1 = p1.id
join products p2 on pp.product_id2 = p2.id
)
select 
    pn.pair, 
    count(*) AS purchase_freq
from pair_names pn
group by pn.pair
order by purchase_freq desc;