-- 39 Quiet student in exam
-- 🔗 https://youtu.be/ZzCS5XW8QOU?si=75M8DsswxCPqR3oZ

-- table schema

create table students
(
student_id int,
student_name varchar(20)
);

insert into students 
values
(1,'Daniel'),
(2,'Jade'),
(3,'Stella'),
(4,'Jonathan'),
(5,'Will');

create table exams
(
exam_id int,
student_id int,
score int
);

insert into exams 
values
(10,1,70),
(10,2,80),
(10,3,90),
(20,1,80),
(30,1,70),
(30,3,80),
(30,4,90),
(40,1,60),
(40,2,70),
(40,4,80);

/*
write a query to report the students(student_id, student_name, =) being quiet in all exams
A quite student is one who took at least one exam and didn't score neither high score nor the low score in any of the exam
Don't return the student who has never taken any exam.
Return the result table ordered by student_id
*/

-- Solution 1
with high_low_score as(
select 
	exam_id as exam_idd,
    min(score) as min_score, 
    max(score) as max_score 
from exams
group by 1
)

select student_id from exams e
join high_low_score h on h.exam_idd = e.exam_id
group by student_id
having max(case when score = min_score or score = max_score then 1 else 0 end) = 0;

