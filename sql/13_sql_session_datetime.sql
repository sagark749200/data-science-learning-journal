-----------------------------
-- SQL DATETIME--------------
-----------------------------

use campusx;

create table uber_rides(
            ride_id INTEGER PRIMARY KEY auto_increment,
            user_id INTEGER,
            cab_id 	integer,
            start_time DATETIME,
            end_time DATETIME
);

SELECT * FROM uber_rides;

insert into uber_rides (user_id, cab_id, start_time,end_time) VALUES
(22,33,'2023-03-11 22:00:00',now());


SELECT * FROM uber_rides;

-- curr_date(), curr_time(), now()

select current_date();
select current_time();
select now();

-- extraction functions
-- date()
select *, date(start_time),
time(start_time),
year(start_time),
month(start_time),
monthname(start_time),
day(start_time),
dayofweek(start_time),
quarter(start_time),
hour(start_time),
minute(start_time),
second(start_time),
dayofyear(start_time),
weekofyear(start_time),
last_day(start_time)
from uber_rides;

-- datetime format
-- date_format
select start_time,date_format(start_time, "%d %b %y") from uber_rides;

-- time_format (can be done from date format)
select start_time,date_format(start_time, '%r') from uber_rides;

-- type conversion--------
--  ----------------------
select monthname('2023-03-11');
-- implicit type conversion

select monthname('9 march 2023');
-- implicit type conversion failed

-- explicit type 
select monthname(str_to_date('9 mar 2023', '%e %b %Y'));
select monthname(str_to_date('9-mar hello 2023', '%e-%b hello %Y'));

-- Datetime Arithmatic
-- datediff
select datediff(current_date(), '2022-11-07');
select datediff (start_time, end_time) from uber_rides;

-- timediff
select timediff(current_date(), '2022-11-07');
select timediff (start_time, end_time) from uber_rides;

-- 
select now(), date_add(now(),interval 10 hour);
select now(), date_sub(now(),interval 10 hour);

-- auto update feature of timestamp
create table posts(
         post_id integer primary key auto_increment,
         user_id integer,
         content text,
         created_at timestamp default current_timestamp(),
         updated_at timestamp default current_timestamp on update current_timestamp);


insert into posts (user_id,content) values (1,'hello world');         
   
update posts 
set content = 'no more hello world'
where post_id = 1;

select * from posts;    