-- 8 Tournament winners
-- 🔗 https://youtu.be/IQ4n4n-Y9z8?si=5bNuTUefvoWeVn7K

-- table schema

create table players
(player_id int,
group_id int);

insert into players 
values 
(15,1),
(25,1),
(30,1),
(45,1),
(10,2),
(35,2),
(50,2),
(20,3),
(40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int);

insert into matches 
values 
(1,15,45,3,0),
(2,30,25,1,2),
(3,30,15,2,0),
(4,40,20,5,2),
(5,35,50,1,1);

/*
write a query to find the winner in each group.
The winner is who scored maximum total points within the group.
In the case of tie the lowest player_id wins. 
*/

-- Solution 1

with player_score as(
select first_player as player_id, sum(first_score) as score
from(
select first_player, first_score from matches
union all 
select second_player, second_score from matches) a
group by first_player
order by player_id)

select * from 
(
select 
ps.*, 
p.group_id,
row_number() over(partition by group_id order by score desc, player_id asc) as rnk
from player_score ps
left join players p on p.player_id = ps.player_id) b
where rnk = 1