-----Lecture 04 SQL_JOINS---------

-------------------------------
-------JOINS-------------------

------cross join--

SELECT * from sql_cx_live.users1 t1
CROSS JOIN sql_cx_live.groups t2

---inner join-----

SELECT * FROM sql_cx_live.membership t1
INNER JOIN sql_cx_live.users1 t2
ON t1.user_id = t2.user_id

---left join----

SELECT * FROM sql_cx_live.membership t1
LEFT JOIN sql_cx_live.users1 t2
ON t1.user_id = t2.user_id


---RIGHT JOIN----

SELECT * FROM sql_cx_live.membership t1
RIGHT JOIN sql_cx_live.users1 t2
ON t1.user_id = t2.user_id

---FULL OUTER JOIN---

SELECT * FROM sql_cx_live.membership t1
FULL OUTER JOIN sql_cx_live.users1 t 2
ON t1.user_id = t2.user_id

-----THIS IS NOT THE RIGHT WAY TO RUN FULL OUTER JOIN FIR YOU HAVE TO UNDERSTAND THE SET OPERATORS----
-----NOW TRY AGAIN  (LEFT UNION RIGHT)---------

SELECT * FROM sql_cx_live.membership t1
LEFT JOIN sql_cx_live.users1 t2
ON t1.user_id = t2.user_id
UNION
SELECT * FROM sql_cx_live.membership t1
RIGHT JOIN sql_cx_live.users1 t2
ON t1.user_id = t2.user_id




----SET OPERATORS----


----UNION-----

SELECT * FROM sql_cx_live.person1
UNION
SELECT * FROM sql_cx_live.person2

----UNION ALL----

SELECT * FROM sql_cx_live.person1
UNION ALL
SELECT * FROM sql_cx_live.person2

----INTERSECT----

SELECT * FROM sql_cx_live.person1
INTERSECT
SELECT * FROM sql_cx_live.person2

----EXCEPT-----

SELECT * FROM sql_cx_live.person1
EXCEPT
SELECT * FROM sql_cx_live.person2





------SELF JOIN-------

SELECT * FROM sql_cx_live.users1 t1
JOIN sql_cx_live.users1 t2
ON t1.emergency_contact = t2.user_id

-------------------------------------
----------QUESTIONS------------------


-----JOINING ON MORE THAN ONE COLUMN------

SELECT * FROM sql_cx_live.students t1
JOIN sql_cx_live.class t2
ON t1.class_id = t2.class_id
AND t1.enrollment_year = t2.class_year 


-----JOINING 3 TABLES -----
-----TO FIND THE NAME OF CUSTOMERS WHO PLACED THE ORDER------

SELECT * FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id = t2.order_id
JOIN flipkart.users t3
ON t2.user_id = t3.user_id


----SIRF KAM KE COLUMNS CHAIYE-----

SELECT t1.order_id,t1.amount,t1.profit,t3.name FROM flipkart.order_details t1
JOIN flipkart.orders t2
ON t1.order_id = t2.order_id
JOIN flipkart.users t3
ON t2.user_id = t3.user_id


----find user name , city on the order is basis----

SELECT t1.order_id,t2.name,t2.city 
FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id = t2.user_id		


----- find category in order id basis----

SELECT order_id,vertical
FROM flipkart.order_details t1
JOIN flipkart.category t2
on t1.category_id = t2.category_id


---- find orders from pune---

SELECT * FROM flipkart.orders t1
JOIN flipkart.users t2
on t1.user_id = t2.user_id
where t2.city = 'Pune'

----------------------------------------------
----------PRACTICE QUESTION-------------------


----find all the profitable orders----

SELECT t1.order_id,SUM(t2.profit) FROM flipkart.orders t1
JOIN flipkart.order_details t2
ON t1.order_id =  t2.order_id
GROUP BY t1.order_id
HAVING SUM(t2.profit) > 0 



---CUSTOMER WHO HAS PLACED THE MAX NUMBER OF ORDER----

SELECT name,count(*) as 'num_orders' FROM flipkart.orders t1
JOIN flipkart.users t2
ON t1.user_id = t2.user_id
GROUP BY t2.name
ORDER BY num_orders DESC LIMIT 1



------ BEST PROFITABLE CATEGORY----

SELECT t2.vertical,SUM(profit) FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id = t2.category_id
GROUP BY t2.vertical
ORDER BY SUM(profit) DESC LIMIT 1



---- MOST PROFITABLE STATE-----

SELECT state,SUM(profit) FROM flipkart.orders t1
JOIN flipkart.order_details t2
ON t1.order_id = t2.order_id
JOIN flipkart.users t3
ON t1.user_id = t3.user_id
GROUP BY state
order by SUM(profit) desc limit 1



------ FING CATEGORIES HAVING PROFIT MORE THAN 3000------


SELECT t2.vertical,SUM(profit) FROM flipkart.order_details t1
JOIN flipkart.category t2
ON t1.category_id = t2.category_id
GROUP BY t2.vertical
HAVING SUM(profit) > 3000