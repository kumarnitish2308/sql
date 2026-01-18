-- 35 Consecutive empty seats in a row
-- 🔗 https://youtu.be/e4IILSHtKl4?si=OxL5AvJKmj3U1jdA

-- table schema

create table movie
(
seat varchar(50),
occupancy int
);

insert into movie 
values
('a1',1),
('a2',1),
('a3',0),
('a4',0),
('a5',0),
('a6',0),
('a7',1),
('a8',1),
('a9',0),
('a10',0),
('b1',0),
('b2',0),
('b3',0),
('b4',1),
('b5',1),
('b6',1),
('b7',1),
('b8',0),
('b9',0),
('b10',0),
('c1',0),
('c2',1),
('c3',0),
('c4',1),
('c5',1),
('c6',0),
('c7',1),
('c8',0),
('c9',0),
('c10',1);

-- Solution 1

/*There are 3 rows in a movie hall each with 10 seats in each row
Write a SQL query to find 4 consecutive empty seats in any row*/

with grp as(
select seat, occupancy, left(seat,1) as seat_row, cast(substring(seat,2,2) as unsigned) as seat_no,
cast(substring(seat,2,2) as unsigned)- row_number() over(partition by left(seat,1) order by cast(substring(seat,2,2) as unsigned)) as grp
from movie
where occupancy = 0),

final as(
select grp,seat_row  from grp
group by grp,seat_row
having count(*) >= 4)

select * from(
select seat, occupancy,b.grp from grp a
left join final b on b.grp = a.grp and a.seat_row = b.seat_row) a
where grp is not null