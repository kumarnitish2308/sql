-- 602. Friend Requests II: Who Has the Most Friends

--🗣️Solution 1

-- Part 1: Getting all unique IDs involved in requests
with all_id as (
    -- Selecting requester IDs and aliasing as 'id'
    select requester_id as id
    from requestaccepted
    -- Combining with accepter IDs to include all unique IDs
    union all
    select accepter_id as id
    from requestaccepted
),

-- Part 2: Counting, grouping, and ranking all the unique IDs
appearnace_count as (
    -- Counting occurrences of each unique ID
    select id, count(id) as total_appearance,
    -- Ranking IDs based on appearance count in descending order
    rank() over(order by count(id) desc) as rnk
    from all_id
    -- Grouping by unique IDs
    group by id
)

-- Part 3: Selecting the ID with the highest appearance count
select id, total_appearance as num from appearnace_count
-- Filtering to include only the top-ranked ID (with the highest appearance count)
where rnk = 1;


--🗣️Solution 2

-- Part 1: Getting all unique IDs involved in requests
with all_id as (
    -- Selecting requester IDs and aliasing as 'id'
    select requester_id as id
    from requestaccepted
    -- Combining with accepter IDs to include all unique IDs
    union all
    select accepter_id as id
    from requestaccepted
)

-- Part 2: Counting occurrences of each unique ID and selecting the top one
select id, count(id) as num
from all_id
-- Grouping by unique IDs
group by id
-- Ordering by appearance count in descending order
order by count(id) desc
-- Limiting the result to only the top-ranked ID (with the highest appearance count)
limit 1;

