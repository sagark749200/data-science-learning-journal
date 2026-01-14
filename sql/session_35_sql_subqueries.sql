--------------------------------------
---- SESSION_35_SQL_SUBQUERIES--------
--------------------------------------
---------EXAMPLE----------
--find the movie with highest score
use sql_cx_live;
SELECT * from sql_cx_live.movies
WHERE score = (SELECT MAX(score) FROM sql_cx_live.movies);

----------Independent_Scaler_Subquery-----------

--find the movie with highest profit (gross - budget)
SELECT * From movies
where (gross - budget) = (select max(gross - budget)
						   from movies);
                           
-------------through_order_by-------------                           
					
select * from movies
order by (gross-budget) desc limit 1;


--find the number of movies with score greater than average score of all movies
select count(*) from movies
where score > (select avg(score)
                  from movies);
                  
--find the movie with highest score in year 2000                  
select * from movies 
where year = 2000 AND score = (select max(score) from movies
                                   where year = 2000);
                                   
                                   
--find the movie with highest score among movies having votes greater than average votes                                 
select * from movies
where score = (select max(score) from movies
                 where votes > (select avg(votes)
                                   from movies));
 ----------------------------
 -------Independent_Row_Subquery----------
 --find users who have not placed any orders
 use zomato;

select * from users
where user_id not in (select distinct(user_id) from orders);
  

--find movies directed by top 3 directors having highest gross collection  
  
with top_directors as (select director 
						from movies 
                        group by director
                        order by sum(gross)
                        desc limit 3) 
select * from movies
where director in (select * from top_directors)    


--find stars whose average movie score is greater than 8.5 and have more than 25000 votes
select * from movies
where star in (select star from movies
                 where votes > 25000
                 group by star
                 having avg(score) > 8.5) 
                 

---------------------------------------
----Independent_Table_subquery---------

--find the movie with highest profit for each year
select * from movies
where (year, gross-budget) in (select year, max(gross-budget)
                              from movies
                              group by year);
                              
--find the movie with highest score for each genre having more than 25000 votes
select * from movies
where (genre,score) IN (select genre,max(score)
                        from movies
                        where votes > 25000
                        group by genre)
AND votes > 25000                        
               

--find top 5 star-director duos based on gross collection
with top_duos as (select star,director,max(gross)
                   from movies
				   group by star, director
                   order by sum(gross) desc limit 5)
select * from movies
where (star,director,gross) in (select * from top_duos)               
                  
------------------------------
-----correlation_subquery--------------


--find movies having score greater than average score of their genre
select * from movies m1
where score > (select avg(score) from movies m2
               where m2.genre = m1.genre);
               
  
--find users' favorite food based on frequency of orders
with fav_food as (
                   select t2.user_id,name,f_name,count(*) as 'frequency' from users t1
                   join orders t2 on t1.user_id = t2.user_id
                   join order_details t3 on t2.order_id = t3.order_id
                   join food t4 on t3.f_id = t4.f_id
                   group by t2.user_id,t3.f_id)    
			select * from fav_food f1
where frequency = (select max(frequency)
                   from fav_food f2
                   where f2.user_id = f1.user_id)  
                   
                   
-------------------USE_CASES------
--------WHERE DONE

------SELECT-------
--find the percentage of votes received by each movie out of total votes received by all movies
use sql_cx_live;
select name, (votes/(select sum(votes) from movies))*100 from movies;



--find average score for each genre along with movie details
select name,genre,score,
(select avg(score) from movies m2 where m2.genre = m1.genre)
from movies m1 

--------------------
------from---------
--find average restaurant rating along with restaurant name
use zomato;

select r_name,avg_rating
from (select r_id,avg(restaurant_rating) as 'avg_rating'
      from orders
      group by r_id) t1 join restaurants t2 
      on t1.r_id = t2.r_id
      
      
------------------------
-------HAVING-----------
--find genres having average score greater than average score of all movies
use sql_cx_live;

select genre,avg(score)
from movies
group by genre
having avg(score) > (select avg(score) from movies)      
                   
                   
------------------
-----INSERT-------
--create a table loyal_users having user_id,name and money columns
use zomato;


create table loyal_users(
      user_id VARCHAR(255),
      name VARCHAR(255),
      money INT)
      
use zomato;
insert into loyal_users
(user_id,name)
select t1.user_id,name from orders t1
join users t2 on t1.user_id = t2.user_id
group by user_id,name
having count(*) > 3;

----------UPDATE-------
--update money column in loyal_users table to 10% of total amount spent by each user
update loyal_users
set money = (select sum(amount)*0.1
             from orders
             where orders.user_id = loyal_users.user_id);
      
      
      
-------DELETE------   
--delete users who have not placed any orders          
delete from users
where user_id in (select user_id from users
			      where user_id not in (select distinct(user_id) from orders))      
                           