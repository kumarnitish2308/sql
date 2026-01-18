-- 47 Unique purchase on each day 
-- 🔗 https://youtu.be/FNUIqQbj_EE?si=yPp05LKyaXQD_Yn0

-- table schema

create table purchase_history (
userid int,
productid int,
purchasedate date
);

insert into 
purchase_history (userid, productid, purchasedate) 
values
(1, 1, '2012-01-23'),
(1, 2, '2012-01-23'),
(1, 3, '2012-01-25'),
(2, 1, '2012-01-23'),
(2, 2, '2012-01-23'),
(2, 2, '2012-01-25'),
(2, 4, '2012-01-25'),
(3, 4, '2012-01-23'),
(3, 1, '2012-01-23'),
(4, 1, '2012-01-23'),
(4, 2, '2012-01-25');

/*
Write a query to  find out the users who purchased different products on different dates.
i.e -- products purchased on any particular day is not repeated on any other day.
*/


select 
    userid,
    count(distinct purchasedate) total_shopping_days,
    count(*) as total_purchase,
    count(distinct productid) as unique_purchase
from purchase_history
group by userid
having total_purchase = unique_purchase and total_shopping_days > 1;