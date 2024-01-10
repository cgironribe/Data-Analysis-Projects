SELECT * FROM videogame_sales

-- Columns normalization. All the data is filled in English but the columns are named in Spanish including special characters and blank spaces
EXEC sp_rename 'videogame_sales.Nombre', 'Game_name', 'COLUMN';
EXEC sp_rename 'videogame_sales.Plataforma', 'Platform', 'COLUMN';
EXEC sp_rename 'videogame_sales.Año', 'Launch_year', 'COLUMN';
EXEC sp_rename 'videogame_sales.Genero', 'Genre', 'COLUMN';
EXEC sp_rename 'videogame_sales.Ventas NA', 'NA_sales', 'COLUMN';
EXEC sp_rename 'videogame_sales.Ventas EU', 'EU_sales', 'COLUMN';
EXEC sp_rename 'videogame_sales.Ventas JP', 'JP_sales', 'COLUMN';
EXEC sp_rename 'videogame_sales.Ventas Otros', 'Other_sales', 'COLUMN';
EXEC sp_rename 'videogame_sales.Ventas Global', 'Global_sales', 'COLUMN';

-- Investigate Platform popularity in 2016

SELECT genre, COUNT(genre) as games_launched
from videogame_sales
where launch_year = 2016
GROUP BY genre
order by games_launched DESC


--BEST SELLING GLOBAL 2016
SELECT TOP(10)* FROM videogame_sales WHERE launch_year = 2016 ORDER BY global_sales DESC
--BEST SELLING GLOBAL 2015
SELECT TOP(10)* FROM videogame_sales WHERE launch_year = 2015 ORDER BY global_sales DESC
--BEST SELLING GLOBAL 2014
SELECT TOP(10)* FROM videogame_sales WHERE launch_year = 2014 ORDER BY global_sales DESC


--sales % per genre
WITH cte_total_launched AS (
    SELECT genre, COUNT(genre) AS total_launched 
    FROM videogame_sales 
    WHERE launch_year = 2016 
    GROUP BY genre
),
cte_total_sales AS (
    SELECT genre, SUM(global_sales) AS total_sales 
    FROM videogame_sales 
    WHERE launch_year = 2016 
    GROUP BY genre
)
SELECT cte_total_launched.genre, 
    cte_total_launched.total_launched, 
    cte_total_sales.total_sales,
    CONCAT(ROUND((cte_total_sales.total_sales * 100.0) / NULLIF(cte_total_launched.total_launched, 0), 2), '%') AS sales_percentage
FROM cte_total_launched
JOIN cte_total_sales ON cte_total_launched.genre = cte_total_sales.genre
ORDER BY sales_percentage DESC;

--platform which generated the most sales
WITH cte_total_sales_platform AS (
    SELECT platform, SUM(global_sales) AS total_sales 
    FROM videogame_sales 
    WHERE launch_year = 2016 
    GROUP BY platform
)
SELECT cte_total_sales_platform.platform, 
    cte_total_sales_platform.total_sales,
    ROUND((cte_total_sales_platform.total_sales * 100.0) / 
        (SELECT SUM(total_sales) FROM cte_total_sales_platform), 2) AS sales_percentage
FROM cte_total_sales_platform
ORDER BY total_sales DESC;

--country with highest sales 2016
SELECT 
    CASE 
        WHEN SUM(NA_SALES) > SUM(EU_SALES) AND SUM(NA_SALES) > SUM(JP_SALES) AND SUM(NA_SALES) > SUM(OTHER_SALES) THEN 'North America'
        WHEN SUM(EU_SALES) > SUM(NA_SALES) AND SUM(EU_SALES) > SUM(JP_SALES) AND SUM(EU_SALES) > SUM(OTHER_SALES) THEN 'Europe'
        WHEN SUM(JP_SALES) > SUM(NA_SALES) AND SUM(JP_SALES) > SUM(EU_SALES) AND SUM(JP_SALES) > SUM(OTHER_SALES) THEN 'Japan'
        ELSE 'Other'
    END AS country_with_most_sales,
    CASE 
        WHEN SUM(NA_SALES) > SUM(EU_SALES) AND SUM(NA_SALES) > SUM(JP_SALES) AND SUM(NA_SALES) > SUM(OTHER_SALES) THEN SUM(NA_SALES)
        WHEN SUM(EU_SALES) > SUM(NA_SALES) AND SUM(EU_SALES) > SUM(JP_SALES) AND SUM(EU_SALES) > SUM(OTHER_SALES) THEN SUM(EU_SALES)
        WHEN SUM(JP_SALES) > SUM(NA_SALES) AND SUM(JP_SALES) > SUM(EU_SALES) AND SUM(JP_SALES) > SUM(OTHER_SALES) THEN SUM(JP_SALES)
        ELSE SUM(OTHER_SALES)
    END AS highest_sales_amount
FROM videogame_sales
WHERE launch_year = 2016;



--platform prefered by genre
SELECT 
    genre,
    platform,
    MAX(GREATEST(NA_SALES, EU_SALES, JP_SALES, OTHER_SALES)) AS Sales
FROM videogame_sales
WHERE launch_year = 2016
GROUP BY PLATFORM, genre
ORDER BY genre, Sales DESC;



-- sales contribution per country 2016
WITH CTE_sales AS (
	SELECT SUM(na_sales) AS na_sales_year,
		SUM(eu_sales) AS eu_sales_year,
		SUM(jp_sales) AS jp_sales_year,
		SUM(other_sales) AS other_sales_year,
		SUM(global_sales) AS global_sales_year
	FROM videogame_sales
	WHERE launch_year = 2016
	)
	SELECT ROUND((na_sales_year * 100.0) / global_sales_year,2) AS na_percentage_contribution,
		ROUND((eu_sales_year * 100.0) / global_sales_year,2) AS eu_percentage_contribution,
		ROUND((jp_sales_year * 100.0) / global_sales_year,2) AS jp_percentage_contribution,
		ROUND((other_sales_year * 100.0) / global_sales_year,2) AS other_percentage_contribution
	FROM CTE_sales

--which company launched more games 2016
SELECT editorial, COUNT(*) AS games_launched, SUM(global_sales) AS sales_generated
FROM videogame_sales
WHERE launch_year = 2016
GROUP BY Editorial
ORDER BY games_launched DESC, sales_generated DESC

--Platform preference by country
SELECT PLATFORM, 
	ROUND(SUM(na_sales), 2) as na_revenue_from_platform, 
	ROUND(SUM(eu_sales), 2) as eu_revenue_from_platform, 
	ROUND(SUM(jp_sales), 2) as jp_revenue_from_platform, 
	ROUND(SUM(other_sales), 2) as other_revenue_from_platform, 
	ROUND(SUM(global_sales), 2) as global_revenue_from_platform
from videogame_sales
where launch_year = 2016
group by PLATFORM
order by global_revenue_from_platform DESC, platform;

--Genre preference by country
SELECT Genre, 
	ROUND(SUM(na_sales), 2) as na_revenue_from_platform, 
	ROUND(SUM(eu_sales), 2) as eu_revenue_from_platform, 
	ROUND(SUM(jp_sales), 2) as jp_revenue_from_platform, 
	ROUND(SUM(other_sales), 2) as other_revenue_from_platform, 
	ROUND(SUM(global_sales), 2) as global_revenue_from_platform
from videogame_sales
where launch_year = 2016
group by Genre
order by global_revenue_from_platform DESC, Genre;

