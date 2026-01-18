-- Common Table Expression (CTE) to assign aliases for the current, next, and previous seat IDs
with cte as (
    select 
        id,
        student,
        lead(id) over(order by id) as next,
        lag(id) over(order by id) as prev
    from seat
)

swapping seat id
select 
    case 
        when id % 2 != 0 and next is not null then next
        when id % 2 = 0 then prev
        when id % 2 != 0 and next is null then id
        else null
    end as id,
    student 
from cte
order by id;
