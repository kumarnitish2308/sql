-- 25 Number of products customer can buy in their budget and list of those products
-- 🔗 https://youtu.be/FZm7NgybHWA?si=us1RJI0p4CMNIJLf

-- table schema

-- Solution 1 
create table subscriber (
    sms_date date,
    sender varchar(20),
    receiver varchar(20),
    sms_no int
);

insert into subscriber (sms_date, sender, receiver, sms_no) 
values 
('2020-04-01', 'Avinash', 'Vibhor', 10),
('2020-04-01', 'Vibhor', 'Avinash', 20),
('2020-04-01', 'Avinash', 'Pawan', 30),
('2020-04-01', 'Pawan', 'Avinash', 20),
('2020-04-01', 'Vibhor', 'Pawan', 5),
('2020-04-01', 'Pawan', 'Vibhor', 8),
('2020-04-01', 'Vibhor', 'Deepak', 50);

with unique_combo as
(
select 
    sms_date, 
    sender, 
    receiver, 
    sms_no,
   case when sender < receiver then sender else receiver end as first_person,
    case when sender > receiver then sender else receiver end as second_person
from subscriber
group by sms_date, sender, receiver, sms_no
)

select sms_date, first_person, second_person, sum(sms_no) as sms_exchanged
from unique_combo
group by sms_date, first_person, second_person;
