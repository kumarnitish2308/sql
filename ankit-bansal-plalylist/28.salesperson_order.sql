-- 28 Number of products customer can buy in their budget and list of those products
-- 🔗 https://youtu.be/e1SVjR-xoto?si=GEmUZ7f7xPk963zx

-- table schema
create table orders (
    order_number int not null,
    order_date date not null,
    cust_id int not null,
    salesperson_id int not null,
    amount float not null,
    primary key (order_number) 
);


insert into orders (order_number, order_date, cust_id, salesperson_id, amount) 
values 
(30, '1995-07-14', 9, 1, 460),
(10, '1996-08-02', 4, 2, 540),
(40, '1998-01-29', 7, 2, 2400),
(50, '1998-02-03', 6, 7, 600),
(60, '1998-03-02', 6, 7, 720);

-- Find the largest order by value for each salesperson(without using cte, window function or temp table) 
select a.*,max(b.amount) from orders a
left join orders b on a.salesperson_id = b.salesperson_id
group by a.order_number, a.order_date, a.cust_id, a.salesperson_id, a.amount
having a.amount >= max(b.amount);
