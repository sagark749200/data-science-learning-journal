---------------------------------------------------
----- SQL Window Functions - Part 3----------------
---------------------------------------------------


use youtube_views;

-- Q1 find month wise percent change in views
SELECT YEAR(Date),MONTH(Date),SUM(views) AS 'views',
((SUM(views) - LAG(SUM(views)) OVER(ORDER BY YEAR(Date),MONTH(Date)))/LAG(SUM(views)) OVER(ORDER BY YEAR(Date),MONTH(Date)))*100 AS 'Percent_change'
FROM youtube_views
GROUP BY YEAR(Date),MONTH(Date)
ORDER BY YEAR(Date),MONTH(Date);

-- USING LAG weekly base
-- find weekly percent change in views

SELECT *,
((Views - LAG(Views,7) OVER(ORDER BY Date))/LAG(Views,7) OVER(ORDER BY Date))*100 AS 'weekly_percent_change'
FROM youtube_views;

-- percentile and Quantile concept 
-- find the median marks of all the students
use campusx;

SELECT *,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY marks) OVER() AS median_marks
from marks;


-- find the median marks of students branch wise
SELECT *,
PERCENTILE_DISC(0.5) WITHINGROUP(ORDER BY marks) OVER(partition by branch) AS median_marks
from marks;

-- find the median marks of all the students using PERCENTILE_CONT
select *,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY marks) OVER(PARTITION BY branch) AS 'median_marks_cont'
FROM marks;


-- find Q1 and Q3 marks of all the students excluding outliers
SELECT * FROM (SELECT *,
               PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q1',
               PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q3'
                FROM marks) t
WHERE t.marks > t.Q1 - (1.5*(t.Q3 - t.Q1)) AND
      t.marks < t.Q3 + (1.5*(t.Q3 - t.Q1))
order by student_id;


-- check outliers based on Q1 and Q3
SELECT * FROM (SELECT *,
               PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q1',
               PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY marks) OVER() AS 'Q3'
               FROM marks) t
WHERE t.marks <= t.Q1 - (1.5*(t.Q3 - t.Q1));


-- NTILE function
-- divide the students into 3 buckets based on their marks
SELECT *,
NTILE(3) OVER(ORDER BY marks DESC) AS 'buckets'
FROM marks;



-- divide the smartphones into 3 buckets based on their price for each brand
SELECT brand_name,model,price, 
CASE 
	WHEN bucket = 1 THEN 'budget'
    WHEN bucket = 2 THEN 'mid-range'
    WHEN bucket = 3 THEN 'premium'
END AS 'phone_type'
FROM (SELECT brand_name,model,price,
      NTILE(3) OVER(PARTITION BY brand_name ORDER BY price) AS 'bucket' 
      FROM smartphones) t;



-- CUME_DIST function
-- find the students who scored more than 90th percentile
SELECT * FROM (SELECT *,
               CUME_DIST() OVER(ORDER BY marks) AS 'Percentile_Score'
               FROM marks) t
WHERE t.Percentile_Score > 0.90;


-- find the top airline with the lowest average fare for each source-destination pair
USE flight;
SELECT * FROM (SELECT source,destination,airline,AVG(price) AS 'avg_fare',
               DENSE_RANK() OVER(PARTITION BY source,destination ORDER BY AVG(price)) AS 'rank'
               FROM flights
               GROUP BY source,destination,airline) t
WHERE t.rank < 2















