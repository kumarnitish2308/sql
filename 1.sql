with new_identifier as (
select *, case when brand1 < brand2 then concat(brand1, brand2, year) else concat(brand2, brand1, year) end as identifier
from brands),

identifier_ranked as(
select *, row_number() over(partition by identifier order by year) as rnk
from new_identifier)

select brand1, brand2, year, custom1, custom2, custom3, custom4
from identifier_ranked 
where rnk = 1 or (custom1 != custom3 and custom2!= custom4)
order by year;
