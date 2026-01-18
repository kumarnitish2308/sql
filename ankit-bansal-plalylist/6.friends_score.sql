-- 6 Friends score
-- 🔗 https://youtu.be/SfzbR69LquU?si=_8Sgb5Ih4kFCcRSf

-- table schema

create table friend (
pid int, 
fid int
);
insert into friend (pid , fid ) values 
(1,2),
(1,3),
(2,1),
(2,3),
(3,5),
(4,2),
(4,3),
(4,5);


create table person (
PersonID int,
name varchar(50),	
Score int
);

insert into person values
(1,'Alice',88),
(2,'Bob',11),
(3,'Devis',27),
(4,'Tara',45),
(5,'John',63);

select * from person;
select * from friend;

/*Write a query to find PersonID, name, number of friends,
sum of marks of person who have friends with total score greater than 100
*/

-- Solution 1
with friend_score as(
select 
a.pid as person_id,
p1.name as person_name,
p.personid as friend_id,
p.name as friend_name,
p.score as friend_score
from friend a
left join person p1 on p1.personid = a.pid
left join person p on p.personid = a.fid)

select person_id, person_name, count(*) as total_fiends, sum(friend_score) as friends_total_score
from friend_score
group by 1,2
having friends_total_score > 100
