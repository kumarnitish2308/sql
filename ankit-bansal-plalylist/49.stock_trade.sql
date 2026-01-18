-- 49 Stock Trade
-- 🔗 https://youtu.be/X6i1WMx0vnY?si=allUUvPHyW3v_vN5

-- table schema

create table trade_tbl 
(
trade_id varchar(20),
trade_timestamp time,
trade_stock varchar(20),
quantity int,
price float
);

insert into trade_tbl 
values
('TRADE1', '10:01:05', 'ITJunction4All', 100, 20),
('TRADE2', '10:01:06', 'ITJunction4All', 20, 15),
('TRADE3', '10:01:08', 'ITJunction4All', 150, 30),
('TRADE4', '10:01:09', 'ITJunction4All', 300, 32),
('TRADE5', '10:10:00', 'ITJunction4All', -100, 19),
('TRADE6', '10:10:01', 'ITJunction4All', -300, 19);

/* Write a query to find all couples of trade for same stock that happened in the range of 10 seconds 
and having the price difference by more than 10%.
Output result should also list the price difference between the 2 trade.
*/

-- Solution 1

select 
    a.trade_id, 
    b.trade_id,
    abs(timestampdiff(second, a.trade_timestamp, b.trade_timestamp)) as time_diff,
    round(abs(100*(a.price - b.price)/a.price),2) as price_diff
from trade_tbl a
cross join trade_tbl b
where a.trade_id <> b.trade_id and a.trade_timestamp < b.trade_timestamp 
	  and abs(timestampdiff(second, a.trade_timestamp, b.trade_timestamp)) < 10
      and round(abs(100*(a.price - b.price)/a.price),2) > 25
order by a.trade_id, b.trade_id;

