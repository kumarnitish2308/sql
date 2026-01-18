-- 39 Phone log
-- 🔗 https://youtu.be/3qEfsSC27_4?si=U4pCS-_c8OI-_kZF

-- table schema

create table phone_log(
caller_id int, 
recipient_id int,
date_called datetime
);

insert into phone_log(caller_id, recipient_id, date_called)
values
(1, 2, '2019-01-01 09:00:00.000'),
(1, 3, '2019-01-01 17:00:00.000'),
(1, 4, '2019-01-01 23:00:00.000'),
(2, 5, '2019-07-05 09:00:00.000'),
(2, 3, '2019-07-05 17:00:00.000'),
(2, 3, '2019-07-05 17:20:00.000'),
(2, 5, '2019-07-05 23:00:00.000'),
(2, 3, '2019-08-01 09:00:00.000'),
(2, 3, '2019-08-01 17:00:00.000'),
(2, 5, '2019-08-01 19:30:00.000'),
(2, 4, '2019-08-02 09:00:00.000'),
(2, 5, '2019-08-02 10:00:00.000'),
(2, 5, '2019-08-02 10:45:00.000'),
(2, 4, '2019-08-02 11:00:00.000');

/*There is a phone log table that has information about callers's call history
Write a query to identify the callers whose first and last call was to the same person on a given day.
*/

-- Solution 1

select * from phone_log;
with first_last_call as( 
select caller_id, date(date_called) as call_date, min(date_called) as first_call_date, max(date_called) as last_call_date
from phone_log
group by caller_id, date(date_called)
)

select fl.*, pl.recipient_id, pl2.recipient_id from first_last_call fl
left join phone_log pl on pl.caller_id = fl.caller_id and fl.first_call_date = pl.date_called
left join phone_log pl2 on pl2.caller_id = fl.caller_id and fl.last_call_date = pl2.date_called
where pl.recipient_id = pl2.recipient_id