-- 1341. Movie Rating
/*-- calculates the count of movies rated by each user and assigns a dense rank based on 
the descending order of movie counts and ascending order of user names.*/
with total_movie_rated as(
    select u.name, count(created_at) as movies_rated,
    dense_rank() over(order by count(created_at) desc, u.name asc)  as u_rank
    from movierating m 
    join users u on u.user_id = m.user_id
    group by u.name
),

/*-- calculates the average rating for each movie in February 2020 and assigns a dense rank based on the 
descending order of average ratings and ascending order of movie titles.*/
movies_avg_rating as(
    select m1.title, avg(rating) as avg_rating,
    dense_rank() over(order by avg(rating) desc, m1.title asc) as m_rank
    from movierating m
    join movies m1 on m1.movie_id = m.movie_id
    where year(created_at) = 2020 and month(created_at) = 2
    group by m1.title
)
-- retrieves the top-ranked user and movie based on the calculated rankings from the respective CTEs.
select name as results
from total_movie_rated
where u_rank = 1
union all
select title as results
from movies_avg_rating
where m_rank = 1
    
