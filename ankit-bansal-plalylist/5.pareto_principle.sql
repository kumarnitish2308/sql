-- 5 Pareto principle
-- 🔗 https://youtu.be/oGgE180oaTs?si=SNpkWjJHQbX616Fr

-- table schema: uploaded csv to mysql(use description of the link above to download the file)
/*
Find out the product which contributes to the 80% of the sales
*/
-- Solution 1
with product_sales as(
select 
    product_id, 
    sum(sales) as total_sales
from orders 
group by product_id
order by total_sales desc),
run_over_sales as
(
select 
    product_id,
    total_sales,
    sum(total_sales) over(order by total_sales desc) as running_sales, 
    -- over(rows between unbounded preceding and current row)
    0.8*sum(total_sales) over() as sales_80
from product_sales
)
select product_id from run_over_sales
where running_sales <= sales_80;
