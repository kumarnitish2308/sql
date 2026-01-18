-- Solution 1
with cte as
(select card_name,min(issue_year) as issue_year
from monthly_cards_issued
group by card_name),

cte2 as(
select c.card_name,c.issue_year,min(issue_month) as min_month
from monthly_cards_issued m
join cte c on c.card_name = m.card_name and c.issue_year = m.issue_year
group by c.card_name,c.issue_year
)

select m2.card_name, m2.issued_amount 
from monthly_cards_issued m2
join cte2 c2 on m2.card_name = c2.card_name 
and c2.issue_year = m2.issue_year
and c2.min_month = m2.issue_month
order by m2.issued_amount desc

-- Solution 2
  
with first_month_sale as (
select card_name, issued_amount,
rank() over (partition by card_name order by issue_year,issue_month) rnk
from monthly_cards_issued
)
select card_name,issued_amount
from first_month_sale
where rnk = 1
order by issued_amount desc;
