-- 37 Sachin's milestone
-- 🔗 https://youtu.be/7LufPVm01NQ?si=W5xD3CGuT9loCfu6

-- table schema --> Download and Import CSV file from video description

-- Find the match number when Sachin crossed the 1000, 5000 and 10000 runs milestone

with runs_over_match as(
select 
    `match`,
    innings,
    runs,
    sum(runs) over(order by `match`rows between unbounded preceding and current row) as runs_over_match
from sachin_batting_scores
),

milestones as(
select 1000 as milestone_runs
union
select 5000 as milestone_runs
union
select 10000 as milestone_runs
)

select  
    min(`match`) as match_no,
    min(innings) as min_innings,
    min(runs_over_match) as runs_over_match,
    milestone_runs
from milestones m
left join runs_over_match r on r.runs_over_match >= m.milestone_runs
group by milestone_runs


