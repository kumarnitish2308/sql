create table stock_table 
(
product_id int,
product_name varchar(50),
stock_count int,
stock_date date
);

insert into stock_table (product_id, product_name, stock_count, stock_date) 
values
(101, 'Widget A', 5, '2025-03-01'),
(101, 'Widget A', 0, '2025-03-02'),
(101, 'Widget A', 0, '2025-03-03'),
(101, 'Widget A', 0, '2025-03-04'),
(101, 'Widget A', 3, '2025-03-05'),
(101, 'Widget A', 0, '2025-03-06'),
(101, 'Widget A', 0, '2025-03-07'),
(101, 'Widget A', 4, '2025-03-08'),
(102, 'Widget B', 0, '2025-03-01'),
(102, 'Widget B', 0, '2025-03-02'),
(102, 'Widget B', 0, '2025-03-03'),
(102, 'Widget B', 2, '2025-03-04');

-- Write a query to get the product with longest out of stock streak

with out_of_stock as 
(
select
	product_id,
    stock_date,
    row_number() over (partition by product_id order by stock_date) as rn
from stock_table
where stock_count = 0
),

streaks as 
(
select
	product_id,
    stock_date,
     date_sub(stock_date, interval rn day) as grp
from out_of_stock
),

streak_lengths as 
(
select
	product_id,
    min(stock_date) as start_date,
    max(stock_date) as end_date,
    datediff(max(stock_date), min(stock_date)) + 1 as consecutive_days
from streaks
group by product_id, grp
)

select
    product_id,
    consecutive_days,
    start_date,
    end_date
from streak_lengths
order by consecutive_days desc
limit 1;
