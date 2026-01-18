-- 25 Number of products customer can buy in their budget and list of those products
-- 🔗 https://youtu.be/Ck1gQrlS5pQ?si=oqGKl-_MN7-Ya-_u

-- table schema

create table students (
    studentid int null,
    studentname nvarchar(255) null,
    subject nvarchar(255) null,
    marks int null,
    testid int null,
    testdate date null
);

insert into students (studentid, studentname, subject, marks, testid, testdate) 
values 
(2, 'Max Ruin', 'Subject1', 63, 1, '2022-01-02'),
(3, 'Arnold', 'Subject1', 95, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject1', 61, 1, '2022-01-02'),
(5, 'John Mike', 'Subject1', 91, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject2', 71, 1, '2022-01-02'),
(3, 'Arnold', 'Subject2', 32, 1, '2022-01-02'),
(5, 'John Mike', 'Subject2', 61, 2, '2022-11-02'),
(1, 'John Deo', 'Subject2', 60, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject2', 84, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject3', 29, 3, '2022-01-03'),
(5, 'John Mike', 'Subject3', 98, 2, '2022-11-02');

-- 1. Write a SQL query to find the students who scored above average marks in each subject
with average_marks as(
select subject, round(avg(marks),2) as average_marks from students group by subject)

select studentname from students s 
join average_marks a on a.subject = s.subject and s.marks > a.average_marks;

-- 2. Write a SQL query to get the percentage of students who scored more than 90 in any subject amongst the total students
select 100*(count(distinct case when marks > 90 then studentname else null end)/count(distinct studentname)) as percentage from students;

-- 3. Write a SQL query to find the second highest and second lowest marks in each subject
with marks_base as(
select
    subject,
    marks,
    row_number() over(partition by subject order by marks asc) as decreasing,
    row_number() over(partition by subject order by marks desc) as increasing
from students
)

select 
    subject,
    max(case when increasing = 2 then marks end) as second_highest_marks,
    max(case when decreasing = 2 then marks end) as second_lowest_marks
from marks_base
group by 1;

-- 4.For each student and test, identify if their marks increased or decreased from previous test.
select
	*,
    case 
	when marks > lag(marks,1) over(partition by studentid order by testdate,subject) then 'increased'
        when marks < lag(marks,1) over(partition by studentid order by testdate,subject) then 'decreased'
    end as 'increase/decrease_flag'
from students;