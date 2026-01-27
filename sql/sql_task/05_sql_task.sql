--------------------------------
-- SQL-TASK-5 ------------------
--------------------------------

USE sql_tasks;

-- 1. Find out top 10 countries which have maximum A and D values.
SELECT A.country,A,D FROM (SELECT country,A FROM country_ab
ORDER BY A DESC LIMIT 10) A
LEFT JOIN 
(SELECT country,D FROM country_cd
ORDER BY D DESC LIMIT 10) B
ON A.country = B.country
UNION
SELECT B.country,A,D FROM (SELECT country,A FROM country_ab
ORDER BY A DESC LIMIT 10) A
RIGHT JOIN 
(SELECT country,D FROM country_cd
ORDER BY D DESC LIMIT 10) B
ON A.country = B.country
ORDER BY country;

-- 2. Find out highest CL value for 2020 for every region. 
--    Also sort the result in descending order. 
SELECT Region,MAX(CL) FROM country_cl t1
JOIN country_ab t2
ON t1.country = t2.country
WHERE t1.Edition = 2020
GROUP BY Region
ORDER BY MAX(CL) DESC;


-- 3. Find top-5 most sold products.
SELECT Name,SUM(Quantity) AS 'total_quantity' FROM sales t1
JOIN product t2
ON t1.ProductID = t2.ProductID
GROUP BY t1.ProductID
ORDER BY total_quantity DESC LIMIT 5;


-- 4. Find sales man who sold most no of products.
SELECT t1.SalesPersonID,FirstName,LastName,SUM(Quantity) AS 'num_sold' FROM sales t1
JOIN employee t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY num_sold DESC LIMIT 5;


-- 5. Sales man name who has most no of unique customer.
SELECT t1.SalesPersonID,FirstName,LastName,COUNT(DISTINCT CustomerID) AS 'unique_customers' FROM sales t1
JOIN employee t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY unique_customers DESC LIMIT 5;

-- 6. Sales man who has generated most revenue. Show top 5.
SELECT t1.SalesPersonID,t3.FirstName,t3.LastName,
ROUND(SUM(t1.Quantity * t2.Price)) AS 'total_revenue'
FROM sales t1
JOIN product t2
ON t1.ProductID = t2.ProductID
JOIN employee t3
ON t1.SalesPersonID = t3.EmployeeID
GROUP BY t1.SalesPersonID
ORDER BY total_revenue DESC LIMIT 5;

-- 7. List all customers who have made more than 10 purchases.
SELECT t1.CustomerID,t2.FirstName,t2.LastName,COUNT(*) FROM sales t1
JOIN customer t2
ON t1.CustomerID = t2.CustomerID
GROUP BY t1.CustomerID
HAVING COUNT(*) > 10;

-- 8. List all salespeople who have made sales to more than 5 customers.
SELECT t1.SalesPersonID,FirstName,LastName,COUNT(DISTINCT CustomerID) AS 'unique_customers' FROM sales t1
JOIN employee t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY t1.SalesPersonID
HAVING unique_customers > 5;

