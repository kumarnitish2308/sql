-- 38 Last non-null value
-- 🔗 https://youtu.be/Xh0EevUOWF0?si=kw8xjEkEEvAixjCO

-- table schema

create table brands 
(
category varchar(20),
brand_name varchar(20)
);


insert into brands values
('chocolates','5-star'),
(null,'dairy milk'),
(null,'perk'),
(null,'eclair'),
('Biscuits','britannia'),
(null,'good day'),
(null,'boost');

/*
Fill the category with last non-null value
*/
-- Solution 1

alter table brands add column id int auto_increment primary key;

with recursive filled_categories as (
select id, category, brand_name
from brands
where id = 1
union all
select 
	b.id,
	case when b.category is not null then b.category else fc.category end as category,
	b.brand_name
    from brands b
join filled_categories fc on b.id = fc.id + 1
)
select 
    category,
    brand_name
from filled_categories
order by id;

-- Solution 2

with rnk as(
select 
    *,
    row_number() over(order by (select null)) as rnk
from brands
),

category_grp as(
select 
    *,
    lead(rnk,1,999999) over(order by rnk) as next_rank
from rnk
where category is not null)

select c.category, r.brand_name
from rnk r
join category_grp c on r.rnk >= c.rnk and (r.rnk <= c.next_rank - 1 or c.next_rank is null)