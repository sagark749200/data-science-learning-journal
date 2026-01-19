-- --------------------------
-- String data types---------
-- --------------------------

-- wildcard
use sql_cx_live;

-- uunderscore
 select name 
 from movies
 where name like 'A____';
 
 -- percent
 select name 
 from movies 
 where name like '%man';
 
 
 -- STRING functions
 -- UPPER LOWER
 select name, UPPER(name), LOWER(name) from movies;
 
 -- concat 
 select CONCAT(name, ' ', director) from movies;
 
 -- concat ws
 select CONCAT_WS(' - ',name,star,director) from movies;
 
 -- substr
 SELECT name, SUBSTR(name,1,5) from movies;
  SELECT name, SUBSTR(name,-5) from movies;
  
  
-- replace
select replace("Hello World","World","india");

-- reverse
SELECT REVERSE("Hello");

-- palindrome
select name from movies
where name = reverse(name);

-- length, char_length
SELECT name, LENGTH(name), CHAR_LENGTH(name) from movies
where  LENGTH(name) != CHAR_LENGTH(name);

-- insert
select INSERT("hello world",7,0,"india");
select INSERT("hello world",7,5,"india");


-- left and right
select name,left(name,3) from movies;
select name,right(name,3) from movies;

-- REPEAT
select repeat(name,3) from movies;

-- TRIM
select TRIM("        sagar      ");
select TRIM(BOTH "." FROM "..........sagar....");
select TRIM(LEADING "." FROM "..........sagar....");
select TRIM(TRAILING "." FROM "..........sagar....");

-- LTRIM, RTRIM
select LTRIM('      sagar     ');
select RTRIM('      sagar     ');

-- substring_index
select substring_index("www.campusx.com",".",1);
select substring_index("www.campusx.com",".",2);
select substring_index("www.campusx.com",".",-1);

-- strcmp (string comparison)
select strcmp("Delhi","Mumbai");
select strcmp("Mumbai","Delhi");
select strcmp("Delhi","delhi");

-- locate

select LOCATE("w", "hello world");
select LOCATE("l", "hello world",6);  -- last l find while searching start from 6th index

-- LPAD , RPAD

select LPAD('4040404015',13,"+91");
select RPAD('4040404015',13,"+91");




