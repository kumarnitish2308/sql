-- 25 Number of products customer can buy in their budget and list of those products
-- 🔗 https://youtu.be/B09xhslOvxw?si=-9mlCfUFMF_9uals

-- table schema

create table products
(
product_id varchar(20),
cost int
);

truncate table products;
insert into products 
values 
('P1',200),
('P2',300),
('P3',500),
('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget 
values 
(100,400),
(200,800),
(300,1500);

-- Solution 1

with running_cost as(
select 
	*,
    sum(cost) over(order by cost asc) as running_cost
from products
)

select customer_id, budget, count(*) as no_of_products, group_concat(product_id order by product_id) as product_list
from customer_budget c
left join running_cost r on r.running_cost < c.budget
group by customer_id, budget;

-- Solution 2

with running_cost as (
select 
	p.product_id,
	p.cost,
	sum(p2.cost) as running_cost
from products p
join products p2 on p2.cost <= p.cost
group by p.product_id, p.cost
)

select 
    c.customer_id, 
    c.budget, 
    count(r.product_id) as no_of_products, 
    group_concat(r.product_id order by r.product_id) as product_list
from customer_budget c
left join running_cost r on r.running_cost < c.budget
group by c.customer_id, c.budget
order by c.customer_id;