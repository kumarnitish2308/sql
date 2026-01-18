-- 24 Company with atleast 2 person who speaks English and German both
-- 🔗 https://youtu.be/35gjU7pChQk?si=ofWhItSs0874FZV3

-- table schema

create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values 
(1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');


-- Find companies who have atleast 2 users who speak English and German both the languages

-- Solution 1

select company_id
from
(
select company_id, user_id, count(*) as total_languages
from company_users 
where language in ('English', 'German')
group by 1,2
having count(*) = 2
) a
group by 1 
having count(*) >= 2;


