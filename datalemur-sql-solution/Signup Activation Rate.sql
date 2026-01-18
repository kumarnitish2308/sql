-- Signup Activation Rate [TikTok SQL Interview Question]

select round(1.0*count(t.email_id)/(select count(distinct email_id) from emails),2) as activation_rate
from emails e
left join texts t on t.email_id = e.email_id
where t.signup_action = 'Confirmed'
