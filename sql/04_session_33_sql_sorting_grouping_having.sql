-------------------------------------------
-------------SORTING QUERY-----------------
-------------------------------------------

--1. find the top 5 Samsung phones with the biggest screen size--
SELECT model,screen_size from campusx.smartphones
WHERE brand_name = 'samsung'
order by screen_size desc LIMIT 5 

--2. sort all the phones in descending order of the number of total cameras
SELECT model,num_front_cameras + num_rear_cameras AS 'total_cameras' FROM campusx.smartphones
order by total_cameras DESC


--3. find the phones with the highest pixel density (PPI)--
SELECT model,
ROUND(sqrt(resolution_width*resolution_width + resolution_height*resolution_height)/ screen_size,2) as 'PPI'
FROM campusx.smartphones
order by PPI desc

--4. find the phone with the 2nd largest battery capacity--
SELECT model,battery_capacity
FROM campusx.smartphones
order by battery_capacity DESC LIMIT 1,1

--5. find the phone with the lowest rating among Apple phones--
SELECT model, rating
FROM campusx.smartphones
where brand_name = 'apple'
order by rating ASC LIMIT 1

--6. sort all phones by brand name (A-Z) and price (low to high)--
SELECT * FROM campusx.smartphones
order by brand_name ASC, price ASC

--7. sort all phones by brand name (A-Z) and rating (high to low)--
SELECT * FROM campusx.smartphones
order by brand_name ASC, rating DESC


-------------------------------------------
-------------Grouping QUERY-----------------
-------------------------------------------

--1  Group smartphones by brand and get the count, average price, max rating, avg screen size, and avg battery capacity
SELECT brand_name, COUNT(*) AS 'num_phones',
round(AVG(price)) AS 'avg price',
MAX(rating) AS 'max rating',
ROUND(AVG(screen_size),2) AS 'avg screen size',
ROUND(AVG(battery_capacity)) AS 'avg battery capacity' 
FROM campusx.smartphones
GROUP BY brand_name
order by num_phones desc LIMIT 10


--2 Group smartphones by whether they have an NFC and get the average price and rating
 --Avg price of 5g phones vs avg price of non 5g phones
SELECT has_nfc,
ROUND(AVG(price),2) AS 'avg price',
ROUND(AVG(rating),2) AS 'avg rating'
from campusx.smartphones
group by has_nfc

--3 Group smartphones by whether they have 5G and get the average price and rating
SELECT has_5g,
ROUND(AVG(price),2) AS 'avg price',
ROUND(AVG(rating),2) AS 'avg rating'
from campusx.smartphones
group by has_5g

--4 Group smartphones by extended memory availability and get the average price and rating
SELECT extended_memory_available,
ROUND(AVG(price),2) AS 'avg price',
ROUND(AVG(rating),2) AS 'avg rating'
from campusx.smartphones
group by extended_memory_available

--5 Group smartphones by brand and processor brand to get the count of phones and average rear camera resolution
select brand_name,processor_brand,
count(*) AS 'num phones',
ROUND(AVG(primary_camera_rear)) AS 'avg camera resolution'
from campusx.smartphones
GROUP BY brand_name,processor_brand

--6 Find the top 5 most expensive brands based on average price of their phones
SELECT brand_name, ROUND(AVG(price)) AS 'avg_price' 
FROM campusx.smartphones
GROUP BY brand_name
order by avg_price DESC LIMIT 5

--7 Find the brand with the smallest average screen size
SELECT brand_name, ROUND(AVG(screen_size)) AS 'avg_screen_size' 
FROM campusx.smartphones
GROUP BY brand_name
order by avg_screen_size ASC LIMIT 1

--8 Find the brand with the most number of phones having both NFC and IR blaster
SELECT brand_name, COUNT(*) AS 'count'
FROM campusx.smartphones
WHERE has_nfc = 'True' AND has_ir_blaster = 'True'
Group by brand_name
order by count desc limit 1

--9 Find the average price of Samsung phones having 5G, grouped by whether they have NFC or not
SELECT has_nfc, avg(price) as 'avg_price' 
FROM campusx.smartphones
where brand_name = 'samsung' and has_5g = 'True'
GROUP BY has_nfc


-------------------------------------------
-------------HAVING CLAUSE QUERY-----------------
-------------------------------------------

--1 Costliest Brand which has at least 20 phones.
SELECT brand_name,
count(*) as 'count',
AVG(price) as 'avg_price'
FROM campusx.smartphones
group by brand_name
having count > 20 
order by avg_price desc


--2 Brand with the highest average rating having at least 40 phones.
SELECT brand_name,
count(*) as 'count',
AVG(rating) as 'avg_rating'
FROM campusx.smartphones
group by brand_name
having count > 40 
order by avg_rating desc

--3 Top 3 brands with the highest average RAM among phones having refresh rate > 90Hz and fast charging available, having at least 10 such phones.
SELECT brand_name,
AVG(ram_capacity) as 'avg_ram'
FROM campusx.smartphones
where refresh_rate > 90 AND fast_charging_available = 1
group by brand_name
having count(*) > 10
order by 'avg_ram' desc limit 3

--4  Find the avg price of all the phone brands with avg rating of 70 and num_phones more than 10 among all 5g enabled phones
select brand_name, AVG(price) as 'avg_price'
from campusx.smartphones
where has_5g = 'True'
group by brand_name
having avg(rating) >70 and count(*) > 10



-------------------------------------------
-------------IPL DATASET PRACTICE-----------------
-------------------------------------------

--1 Find the top 5 batsmen with the highest total runs scored
SELECT batter, sum(batsman_run) as 'runs'
from campusx.ipl
group by batter
order by runs desc limit 5

--2 find the 2nd highest 6 hitters in IPL
SELECT batter, count(*) as num_sixes
FROM campusx.ipl
where batsman_run = 6
group by batter
order by num_sixes desc limit 1,1

--3  find the top 5 batsmen with the highest strike rate who have played a min of 1000 balls
SELECT batter, SUM(batsman_run), COUNT(batsman_run),
ROUND((SUM(batsman_run)/COUNT(batsman_run)) * 100,2) as 'strike_rate'
from campusx.ipl
group by batter
having COUNT(batsman_run) > 1000
order by strike_rate desc limit 5