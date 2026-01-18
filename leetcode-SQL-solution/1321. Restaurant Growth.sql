-- Common Table Expression (CTE) to calculate the total amount for each date
with cte as(
  select visited_on, sum(amount) as amount
  from customer
  group by visited_on
),

-- Another CTE to calculate the rolling sum and average over a 7-day window
cte2 as (
select visited_on,
sum(amount) over( order by visited_on rows between 6 preceding and current row) as amount,
round(avg(amount) over(order by visited_on rows between 6 preceding and current row),2) as average_amount
from cte
)

-- Final select statement
select * from cte2
-- Filter by dates where visited_on is greater than or equal to 6 days after the minimum visited_on date
where visited_on >= (select date_add(min(visited_on), interval 6 day) from customer);
