-- 50 Section max
-- 🔗 https://youtu.be/ACD6J1opmFs?si=eU_jEvN4pgKAefz4

-- table schema

create table section_data
(
section varchar(5),
number integer
);

insert into section_data
values 
('A',5),
('A',7),
('A',10),
('B',7),
('B',9),
('B',10),
('C',9),
('C',7),
('C',9),
('D',10),
('D',3),
('D',8);

/* 
We have a table which stores data of multiple sections.
Every section has 3 numbers. We have to find the top 4 numbers from any 2 sections(2 numbers each) 
whose addition should be maximum.
So, in this case we will choose section b where we have 19(10+9) then we need to choose either C or D
because both has the sum of 18 but in D we have 10 which is big from 9. So we will give priority to D.
*/

with cte as
(
select 
    *,
    row_number() over(partition by section order by number desc) as rnk
from section_data
),

cte_2 as
(
select 
    section,
    number,
    sum(number) over(partition by section) as total,
    max(number) over(partition by section) as section_max
from cte
where rnk <=2
)

select * from
(
select 
    *,
    dense_rank() over(order by total desc, section_max desc) as rnk
from cte_2) a
where rnk <= 2;


