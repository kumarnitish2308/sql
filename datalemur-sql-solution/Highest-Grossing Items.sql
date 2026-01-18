-- Highest-Grossing Items [Amazon SQL Interview Question]

-- finding total_spend on each product in every category 
with spend_table as (
select category, product,
sum(spend) as total_spend
from product_spend
where extract(year from transaction_date) = 2022
group by category,product
),

-- ranking product within each category
ranked_spend as (
select *,
dense_rank() over(partition by category order by total_spend desc) as rnk
from spend_table)

--getting top 2 product within each category
select category,product,total_spend
from ranked_spend
where rnk <=2
