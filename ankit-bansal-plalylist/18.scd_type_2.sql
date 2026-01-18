-- 18 SCD type 2
-- 🔗 https://youtu.be/51ryMCf-fvU?si=yOxXW6XeqDV9Ocoo

-- table schema
create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);

insert into billings values
('Sachin','1990-01-01',25),
('Sehwag' ,'1989-01-01', 15),
('Dhoni' ,'1989-01-01', 20),
('Sachin' ,'1991-02-05', 30);

create table hours_worked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);

insert into hours_worked values
('Sachin', '1990-07-01' ,3),
('Sachin', '1990-08-01', 5),
('Sehwag','1990-07-01', 2),
('Sachin','1991-07-01', 4);

/*
Billings table contains bill rate for a player on any particular date.
hours_worked table contains the total hours worked by a player on any particular date.
Calculate the earnings of each player.
*/

-- Solution 1(directly copied from video)

with date_range as(
select 
    *,
    lead(date_add(bill_date, interval - 1 day),1,'9999-12-31') over(partition by emp_name order by bill_date asc) as bill_date_end
from billings)

select 
    hw.emp_name,
    sum(dr.bill_rate*hw.bill_hrs) as earnings
from hours_worked hw
join date_range dr on dr.emp_name = hw.emp_name and hw.work_date between dr.bill_date and dr.bill_date_end
group by hw.emp_name;