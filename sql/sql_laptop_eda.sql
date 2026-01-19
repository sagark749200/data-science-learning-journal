----------------------------------
-- LAPTOP DATASET EDA-------------
----------------------------------
use sql_cx_live;

-- univarient analysis
-- numerical columns

SELECT * FROM laptops;

-- head, tail and sample
SELECT * FROM laptops
ORDER BY `index` LIMIT 5;

SELECT * FROM laptops
ORDER BY `index` DESC LIMIT 5;

SELECT * FROM laptops
ORDER BY rand() LIMIT 5;


-- 8 point summary statistics (percentile does not work in mysql)
SELECT COUNT(Price) OVER(),
MIN(Price) OVER(),
MAX(Price) OVER(),
AVG(Price) OVER(),
STD(Price) OVER()
-- PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
-- PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY Price) OVER() AS 'Median',
-- PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops
ORDER BY `index` LIMIT 1;



-- missing value
SELECT COUNT(Price)
FROM laptops
WHERE Price IS NULL;


-- outliers  (cant use this method in new versions)
SELECT * FROM (SELECT *
-- PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q1',
-- PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY Price) OVER() AS 'Q3'
FROM laptops) t
WHERE t.Price < t.Q1 - (1.5*(t.Q3 - t.Q1)) OR
t.Price > t.Q3 + (1.5*(t.Q3 - t.Q1));


-- how to plot histogram in sql (interview question)
-- take example of price categorization 
SELECT t.buckets,REPEAT('*',COUNT(*)/5) FROM (SELECT price, 
CASE 
	WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
	ELSE '>100K'
END AS 'buckets'
FROM laptops) t
GROUP BY t.buckets;

-- CATEGORICAL COLUMNS
--
SELECT Company,COUNT(Company) FROM laptops
GROUP BY Company;
-- FOR PLOT COPY PASTE TABLE ON EXCEL AND PLOT CHART 

-- missing value find
select distinct company from laptops;
-- same for a

-- NUMERICAL - NUMERICAL COLUMNS

-- min,max,count,std function
SELECT
    COUNT(Price) AS price_count,
    COUNT(cpu_speed) AS cpu_speed_count,
    MIN(Price) AS min_price,
    MIN(cpu_speed) AS min_cpu_speed,
    MAX(Price) AS max_price,
    MAX(cpu_speed) AS max_cpu_speed,
    AVG(Price) AS avg_price,
    AVG(cpu_speed) AS avg_cpu_speed,
    STDDEV_POP(Price) AS std_price,
    STDDEV_POP(cpu_speed) AS std_cpu_speed
FROM laptops;


-- scatterplot  GPPGLE SHEET PASTE AND PLOT
-- example cpu_speed vs price
SELECT cpu_speed,Price FROM laptops;


-- CAT VS CAT COLUMNS
-- company wise touch or non touch screen laptops (plot)
SELECT Company,
SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no'
FROM laptops
GROUP BY Company;


--find missing values in categorical columns
SELECT DISTINCT cpu_brand FROM laptops;


-- company wise cpu brand laptops (plot)
SELECT Company,
SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'intel',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'samsung'
FROM laptops
GROUP BY Company;










