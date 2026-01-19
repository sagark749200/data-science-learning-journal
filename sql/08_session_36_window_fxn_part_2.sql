----------------------------------------
--session_windwow_function_part_2
----------------------------------------


use campusx;

-- find 5 highest run scorer for each ipl team
SELECT * FROM (SELECT BattingTeam,batter,SUM(batsman_run) AS 'total_runs',
               DENSE_RANK() OVER(PARTITION BY BattingTeam ORDER BY SUM(batsman_run) DESC) AS 'rank_within_team'
               FROM ipl
               GROUP BY BattingTeam,batter) t
WHERE t.rank_within_team < 6
ORDER BY t.BattingTeam,t.rank_within_team;

-- cumulative sum
-- Q2Find virat kohli run after 50th, 100th and 200th match 
SELECT * FROM (SELECT 
               CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID) AS CHAR)) AS 'match_no',
               SUM(batsman_run) AS 'runs_scored',
               SUM(SUM(batsman_run)) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'career_runs'
               FROM ipl
               WHERE batter = 'V Kohli'
               GROUP BY ID) t
WHERE match_no = 'Match-50' OR match_no = 'Match-100' OR match_no = 'Match-200';

-- cumulative avg
-- Q3 find virat kohli avg after every match
SELECT * FROM (SELECT 
               CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID) AS CHAR)) AS 'match_no',
               SUM(batsman_run) AS 'runs_scored',
               SUM(SUM(batsman_run)) OVER w AS 'career_runs',
               AVG(SUM(batsman_run)) OVER w AS 'career_avg'
               FROM ipl
               WHERE batter = 'V Kohli'
               GROUP BY ID
               WINDOW w AS (ORDER BY ID
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) t;
             
             
-- Q4 running avg
-- find virat kohli rolling avg of last 10 matches

SELECT * FROM (SELECT 
               CONCAT("Match-",CAST(ROW_NUMBER() OVER(ORDER BY ID) AS CHAR)) AS 'match_no',
               SUM(batsman_run) AS 'runs_scored',
               SUM(SUM(batsman_run)) OVER w AS 'career_runs',
               AVG(SUM(batsman_run)) OVER w AS 'career_avg',
               AVG(SUM(batsman_run)) OVER(ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS 'rolling_avg'
               FROM ipl
               WHERE batter = 'V Kohli'
               GROUP BY ID
               WINDOW w AS (ORDER BY ID
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) t;
              


-- Q5 percent of total - each food percent of restaurant 1
-- find 
use zomato;      
SELECT f_name,
(total_value/SUM(total_value) OVER())*100 AS 'percent_of_total'
FROM (SELECT f_id,SUM(amount) AS 'total_value' FROM orders t1
      JOIN order_details t2
      ON t1.order_id = t2.order_id
      WHERE r_id = 1
      GROUP BY f_id) t
JOIN food t3
ON t.f_id = t3.f_id
ORDER BY (total_value/SUM(total_value) OVER())*100 DESC
       


