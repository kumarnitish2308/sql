-- 2 New and repeat customer
-- 🔗 https://youtu.be/MpAMjtvarrc?si=thQ-HcA1Xgz6UmA3

-- table schema
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders 
values
(1,100,cast('2022-01-01' as date),2000),
(2,200,cast('2022-01-01' as date),2500),
(3,300,cast('2022-01-01' as date),2100),
(4,100,cast('2022-01-02' as date),2000),
(5,400,cast('2022-01-02' as date),2200),
(6,500,cast('2022-01-02' as date),2700),
(7,100,cast('2022-01-03' as date),3000),
(8,400,cast('2022-01-03' as date),1000),
(9,600,cast('2022-01-03' as date),3000);

-- Solution 1 
with new_repeat_check as (
select 
	customer_id,
    order_date,
    min(order_date) over(partition by customer_id order by order_date asc) as first_order_date,
    case when order_date = min(order_date) over(partition by customer_id order by order_date asc) then 1 else 0 end as new_customer_flag,
    case when order_date != min(order_date) over(partition by customer_id order by order_date asc) then 1 else 0 end as old_customer_flag
from customer_orders)

select 
	order_date, 
    sum(new_customer_flag) as new_customers, 
    sum(old_customer_flag) as repeat_customers
from new_repeat_check
group by order_date;

-- Solution 2
select 
    co.order_date, 
    sum(case when co.order_date = (select min(order_date) from customer_orders where customer_id = co.customer_id) then 1 else 0 end) as new_customers,
    sum(case when co.order_date != (select min(order_date) from customer_orders where customer_id = co.customer_id) then 1 else 0 end) as repeat_customers
from 
    customer_orders co
group by 
    co.order_date;

--Solution 3
with ranked_base as(
select  
	customer_id,
	order_date,
	row_number() over(partition by customer_id order by order_date asc) as rnk
from customer_orders)
select 
	order_date,
    sum(case when rnk = 1 then 1 else 0 end) as new_customer,
    sum(case when rnk > 1 then 1 else 0 end) as repeat_customer
from ranked_base
group by order_date;



