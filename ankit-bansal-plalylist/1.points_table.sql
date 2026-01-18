-- 1 Points table
-- 🔗 https://youtu.be/qyAgWL066Vo?si=pGgQOlc6f88J7Anb

-- table schema
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);

INSERT INTO icc_world_cup (Team_1, Team_2, Winner)
VALUES 
    ('India', 'SL', 'India'),
    ('SL', 'Aus', 'Aus'),
    ('SA', 'Eng', 'Eng'),
    ('Eng', 'NZ', 'NZ'),
    ('Aus', 'India', 'India');

-- Problem statement 
-- Create a points table which contains team_name, matches_played, matches_won, matches_lost

--Solution 1
with matches_played as(
select team, count(*) as matches_played from (
select team_1 as team from icc_world_cup
union all 
select team_2 as team from icc_world_cup) a
group by team),

matches_won as(
select winner, count(*) as matches_won from icc_world_cup
group by winner)

select team, matches_played, coalesce(matches_won,0) as matches_won, coalesce(matches_played - matches_won,0) as matches_lost
from matches_played a
left join matches_won b on b.winner = a.team

--Solution 2
select team, count(*) as matches_played, sum(win_flag) as matches_won, count(*) - sum(win_flag) as matches_lost
from(
select team_1 as team, case when team_1 = winner then 1 else 0 end as win_flag from icc_world_cup
union all 
select team_2 as team, case when team_2 = winner then 1 else 0 end as win_flag from icc_world_cup) a
group by team;

--Solution 3
select team, matches_played, matches_won,  matches_played - matches_won as matches_lost
from(
select 
    team,
    (select count(*) from (
        select team_1 as team from icc_world_cup
        union all
        select team_2 as team from icc_world_cup
    ) as all_teams
    where all_teams.team = t.team) as matches_played,
    (select count(*) from icc_world_cup
    where winner = t.team) as matches_won
from (
    select team_1 as team from icc_world_cup
    union 
    select team_2 as team from icc_world_cup
) as t)t1;
