-- most rated movies
SELECT TOP 3 title, 
	   rating
FROM movies m
ORDER By rating DESC

-- favorite genres
SELECT TOP 5 genre,
	   COUNT(DISTINCT(rm.renting_id)) AS times_rented
FROM genres g
INNER JOIN movies_genres mg ON g.genre_id = mg.genre_id
INNER JOIN movies m ON mg.movie_id = m.movie_id
INNER JOIN rented_movies rm ON rm.movie_id = m.movie_id
GROUP BY genre 
ORDER BY times_rented DESC

-- rating distribution per genre
SELECT genre,
	   ROUND(AVG(r.rating), 2) AS avg_rating,
	   COUNT(DISTINCT(r.rating)) AS rating_count
FROM genres g
INNER JOIN movies_genres mg ON g.genre_id = mg.genre_id
INNER JOIN movies m ON mg.movie_id = m.movie_id
INNER JOIN ratings r ON r.movie_id = m.movie_id
GROUP BY genre 

-- directors popularity
SELECT CONCAT(first_name, ' ', last_name) AS director,
	   COUNT(DISTINCT(renting_id)) AS movies_rented
FROM directors d
INNER JOIN movies_directors md on md.director_id = d.director_id
INNER JOIN movies m ON m.movie_id = md.movie_id
INNER JOIN rented_movies rm ON rm.movie_id = m.movie_id
GROUP BY CONCAT(first_name, ' ', last_name)
ORDER BY movies_rented DESC
		-- actors popularity
		SELECT CONCAT(first_name, ' ', last_name) AS actr,
				COUNT(DISTINCT(renting_id)) AS movies_rented
		FROM actors a
		INNER JOIN movies_actors ma ON ma.actor_id = a.actor_id
		INNER JOIN movies m ON m.movie_id = ma.movie_id
		INNER JOIN rented_movies rm ON rm.movie_id = m.movie_id
		GROUP BY CONCAT(first_name, ' ', last_name)
		ORDER BY movies_rented DESC

-- relationship between movie duration and ratings
SELECT 
    ((SUM(duration * rating) - SUM(duration) * SUM(rating) / COUNT(*)) / 
    (SQRT((SUM(duration * duration) - SUM(duration) * SUM(duration) / COUNT(*)) * 
    (SUM(rating * rating) - SUM(rating) * SUM(rating) / COUNT(*))))) AS correlation
FROM 
    (SELECT 
         m.movie_id, 
         CAST(REPLACE(duration, ' min', '') AS FLOAT) AS duration, 
         r.rating
     FROM 
         movies m
     JOIN 
         ratings r ON m.movie_id = r.movie_id) AS DurationRatings;



-- analyzing keywords on ratings
SELECT LOWER(REPLACE(commentary, '.', ' ')) AS cleaned_commentary
FROM ratings r
WHERE commentary IS NOT NULL

SELECT word, COUNT(*) AS word_count
FROM (SELECT value AS word
	  FROM ratings r 
	  CROSS APPLY STRING_SPLIT(commentary, ' ')
	  ) as words
GROUP BY word
ORDER BY word_count DESC;

-- rental frecuency per weekday
SELECT CASE WHEN DATEPART(WEEKDAY, date_of_renting) = 7 THEN 'sunday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 1 THEN 'monday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 2 THEN 'tuesday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 3 THEN 'wednesday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 4 THEN 'thursday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 5 THEN 'friday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 6 THEN 'saturday' ELSE 'none' END AS week_day,
		COUNT(DISTINCT(renting_id)) AS movies_rented
FROM rented_movies rm
GROUP BY (CASE WHEN DATEPART(WEEKDAY, date_of_renting) = 7 THEN 'sunday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 1 THEN 'monday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 2 THEN 'tuesday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 3 THEN 'wednesday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 4 THEN 'thursday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 5 THEN 'friday'
			WHEN DATEPART(WEEKDAY, date_of_renting) = 6 THEN 'saturday' ELSE 'none' END)
ORDER BY movies_rented DESC

-- Retrieve top genre rental per weekday
WITH ranked_genres AS (
    SELECT 
        week_day,
        genre,
        movies_rented,
        ROW_NUMBER() OVER (PARTITION BY week_day ORDER BY movies_rented DESC) AS row_num
    FROM (
        SELECT 
            CASE WHEN DATEPART(WEEKDAY, date_of_renting) = 7 THEN 'sunday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 1 THEN 'monday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 2 THEN 'tuesday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 3 THEN 'wednesday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 4 THEN 'thursday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 5 THEN 'friday'
                 WHEN DATEPART(WEEKDAY, date_of_renting) = 6 THEN 'saturday' ELSE 'none' END AS week_day,
            genre,
            COUNT(DISTINCT renting_id) AS movies_rented
        FROM 
            rented_movies rm
            INNER JOIN movies m ON rm.movie_id = m.movie_id
            INNER JOIN movies_genres mg ON mg.movie_id = m.movie_id
            INNER JOIN genres g ON g.genre_id = mg.genre_id
        GROUP BY DATEPART(WEEKDAY, date_of_renting),
            genre
    ) AS subquery
)
SELECT 
    week_day,
    genre,
    movies_rented
FROM 
    ranked_genres
WHERE 
    row_num = 1
ORDER BY 
    week_day;






