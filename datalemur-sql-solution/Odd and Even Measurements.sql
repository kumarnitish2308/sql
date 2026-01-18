-- Odd and Even Measurements [Google SQL Interview Question]

-- ranking measurement for each measurement day
with ranked_measurement as(
select cast(measurement_time as date) AS measurement_day, 
measurement_value,
row_number() over(partition by cast(measurement_time as date) order by measurement_time) as rnk
from measurements
)

-- sum of measurement values for even and odd ranks on each measurement day
select measurement_day,
sum(case when rnk % 2 = 0 then measurement_value end) as even_sum,
sum(case when rnk % 2 != 0 then measurement_value end) as odd_sum
from ranked_measurement
group by measurement_day
