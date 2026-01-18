-- 16 customer churn Analysis part 1
-- 🔗 https://youtu.be/hGflhxWWxTI?si=GtDlgVuHgDY0lQOW

-- table schema

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);

insert into transactions 
values 
(1,1,'2020-01-15',150),
(2,1,'2020-02-10',150),
(3,2,'2020-01-16',150),
(4,2,'2020-02-25',150),
(5,3,'2020-01-10',150),
(6,3,'2020-02-20',150),
(7,4,'2020-01-20',150),
(8,5,'2020-02-20',150);

/*
Churn -- Customer who came in this month but didn't come in next month
*/

-- Solution 1

select date_format(t1.order_date, '%Y-%m-01') as month,count(distinct t1.cust_id) as retained_customer
from transactions t1
left join transactions t2 on t1.cust_id = t2.cust_id 
and date_format(t2.order_date, '%Y-%m-01') = date_format(date_add(t1.order_date, interval 1 month), '%Y-%m-01')
where t2.order_date is null
group by date_format(t1.order_date, '%Y-%m-01');
