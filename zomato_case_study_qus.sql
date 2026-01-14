-- 1 how to use a particular database
USE zomato;

-- 2 find number of rows in order_details table
SELECT COUNT(*) FROM order_details;


-- 3 find 5 random users
SELECT * FROM users ORDER BY rand() LIMIT 5;


-- 4 find null values in restaurant_rating column
SELECT * FROM orders WHERE restaurant_rating IS NULL;

-- filling null
UPDATE orders SET restaurant_rating = 0 
WHERE restaurant_rating IS NULL;


-- 5 find number of orders placed by each user
SELECT t2.user_id, t2.name, COUNT(*) AS `#orders`
FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
GROUP BY t2.user_id, t2.name;


-- Q6 find number of menu items for each restaurant
SELECT r_name,COUNT(*) AS 'menu_items' FROM restaurants t1
JOIN menu t2
ON t1.r_id = t2.r_id
GROUP BY t2.r_id, r_name;


-- Q7 find number of votes and average rating for each restaurant
SELECT r_name,COUNT(*) AS 'num_votes',ROUND(AVG(restaurant_rating),2) AS 'rating' 
FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE restaurant_rating IS NOT NULL
GROUP BY t1.r_id, r_name;


-- Q8 find most popular/sold food item
SELECT f_name,COUNT(*) FROM menu t1
JOIN food t2
ON t1.f_id = t2.f_id
GROUP BY t1.f_id,f_name
ORDER BY COUNT(*) DESC LIMIT 1;


-- Q9 -> part 1 find restaurant with highest revenue in july
SELECT r_name,SUM(amount) AS 'revenue' FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE MONTHNAME(DATE(date)) = 'July'
GROUP BY t1.r_id, r_name
ORDER BY revenue DESC LIMIT 1;

-- Q9 part 2 month by month revenue for a particular restautant = kfc
SELECT MONTHNAME(DATE(date)),SUM(amount) AS 'revenue' FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
WHERE r_name = 'dominos'
GROUP BY MONTH(DATE(date)),MONTHNAME(DATE(date))
ORDER BY MONTH(DATE(date));


-- Q10 find restaurants with revenue > 1500
SELECT r_name,SUM(amount) AS 'revenue' FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t1.r_id,r_name
HAVING revenue > 1500;


-- Q11 find users who have not placed any orders
SELECT user_id,name FROM users
EXCEPT
SELECT t1.user_id,name FROM orders t1
join users t2
on t1.user_id = t2.user_id;


-- Q12 find all orders placed by user with user_id = 5 between 15th May 2022 and 15th July 2022
SELECT t1.order_id,f_name,date FROM orders t1
JOIN order_details t2
ON t1.order_id = t2.order_id
JOIN food t3
ON t2.f_id = t3.f_id
WHERE user_id = 5 AND date BETWEEN '2022-05-15' AND '2022-07-15';


-- Q13 find most ordered food item by each user
SELECT t1.user_id,t3.f_id,COUNT(*) FROM users t1
JOIN orders t2
ON t1.user_id = t2.user_id
JOIN order_details t3
ON t2.order_id = t3.order_id
GROUP BY t1.user_id,t3.f_id
ORDER BY COUNT(*) DESC;


-- Q14 find restaurant with highest average price of menu items
SELECT r_name,SUM(price)/COUNT(*) AS 'Avg_price' FROM menu t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t1.r_id,r_name
ORDER BY Avg_price DESC LIMIT 1;


-- Q15 find delivery partner with highest salary(number of deliveries * 100 + average delivery rating * 1000)
SELECT partner_name,COUNT(*) * 100  + AVG(delivery_rating)*1000 AS 'salary'
FROM orders t1
JOIN delivery_partner t2
ON t1.partner_id = t2.partner_id
GROUP BY t1.partner_id,partner_name
ORDER BY salary DESC;


-- Q16 month by month revenue for each restaurant (almost same as q9 part 2)
SELECT t2.r_name,MONTHNAME(DATE(date)),SUM(amount) AS 'revenue' FROM orders t1
JOIN restaurants t2
ON t1.r_id = t2.r_id
GROUP BY t2.r_name,MONTH(DATE(date)),MONTHNAME(DATE(date))
ORDER BY t2.r_name,MONTH(DATE(date));


-- Q17 corr function issue
-- Q18 corr function issue

-- Q19 find restaurants that serve only veg food
SELECT r_name FROM menu t1
JOIN food t2
ON t1.f_id = t2.f_id
JOIN restaurants t3
ON t1.r_id = t3.r_id
GROUP BY t1.r_id,r_name
HAVING MIN(type) = 'Veg' AND MAX(type) = 'Veg';


-- Q20 find min, max and avg order amount for each user
SELECT name,MIN(amount),MAX(amount),AVG(amount) FROM orders t1
JOIN users t2
ON t1.user_id = t2.user_id
GROUP BY t1.user_id,name




