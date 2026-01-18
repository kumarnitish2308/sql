/*
Churn analysis is the process of identifying the reasons why customers stop doing business with a company. 
This analysis is crucial for businesses, especially those with subscription models, to understand and reduce customer attrition. 
It involves examining data to find patterns and indicators that predict when and why customers are likely to leave, enabling companies to take proactive steps to retain them.

Key Components of Churn Analysis:
    1.Customer Data Collection: Gathering detailed information on customer behavior, demographics, and interactions with the company.

    2.Segmentation: Dividing customers into different segments based on characteristics like usage patterns, demographics, and purchase history.

    3.Churn Rate Calculation: Measuring the percentage of customers who leave over a specific period.

    4.Identifying Churn Indicators: Finding common traits or actions that precede churn, such as a drop in usage or negative feedback.

    5. Predictive Modeling: Using statistical and machine learning techniques to predict which customers are at risk of churning.

    6. Root Cause Analysis: Investigating the underlying reasons for churn through qualitative and quantitative methods, such as surveys and data analysis.

    7. Intervention Strategies: Developing strategies to prevent churn, such as improving customer service, offering incentives, or enhancing product features.

Benefits of Churn Analysis:
    1. Improved Customer Retention: By understanding why customers leave, businesses can implement strategies to retain them.

    2. Increased Revenue: Retaining customers is often more cost-effective than acquiring new ones, leading to higher overall revenue.

    3. Enhanced Customer Experience: Insights from churn analysis can inform improvements in products, services, and customer interactions.

    4. Targeted Marketing: Identifying at-risk customers allows for personalized marketing efforts to re-engage them.
*/

-- 15 customer churn Analysis part 1 --> Retention
-- 🔗 https://youtu.be/6hfsRqmyvog?si=_SsjHbsg5fiZJzlv

-- table schema

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);

insert into transactions 
values 
(1,1,'2020-01-15',150),
(2,1,'2020-02-10',150),
(3,2,'2020-01-16',150),
(4,2,'2020-02-25',150),
(5,3,'2020-01-10',150),
(6,3,'2020-02-20',150),
(7,4,'2020-01-20',150),
(8,5,'2020-02-20',150);

/*
Find out the number of customer who has come in last month and this month also.
*/

-- Solution 1

select 
    date_format(t1.order_date, '%y-%m-01') as month,
    count(distinct t2.cust_id) as retained_customer
from transactions t1
left join transactions t2 on t1.cust_id = t2.cust_id 
    and date_format(t2.order_date, '%y-%m-01') = date_format(date_sub(t1.order_date, interval 1 month), '%y-%m-01')
group by date_format(t1.order_date, '%y-%m-01');

-- Solution 2

with all_months as (
select distinct date_format(order_date, '%Y-%m-01') as month from transactions
),

prev_month_orders as (
select 
	t1.cust_id,
	t1.order_date,
	lag(t1.order_date) over (partition by t1.cust_id order by t1.order_date) as prev_order_date
from transactions t1
),

retained_customers as (
select 
	date_format(order_date, '%Y-%m-01') as month,
	count(distinct cust_id) as retained_customer
from prev_month_orders
where date_format(prev_order_date, '%Y-%m') = date_format(date_sub(order_date, interval 1 month), '%Y-%m')
group by date_format(order_date, '%Y-%m-01')
)

select 
    a.month,
    coalesce(b.retained_customer, 0) as retained_customer
from all_months a
left join retained_customers b on a.month = b.month
order by a.month;
