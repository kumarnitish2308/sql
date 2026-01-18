-- User's Third Transaction [Uber SQL Interview Question]

-- Solution 1

SELECT user_id,spend,transaction_date
FROM(
SELECT user_id,spend,transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS row_num
FROM transactions
) AS transaction_num

WHERE transaction_num.row_num = 3

-- Solution 2

SELECT user_id,spend,transaction_date
FROM(
SELECT user_id,spend,transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS row_num
FROM transactions
) AS transaction_num

WHERE transaction_num.row_num = 3
