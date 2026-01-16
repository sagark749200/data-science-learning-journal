SELECT *, AVG(marks) OVER(PARTITION BY branch) from campusx.marks;

select *,
AVG(marks) OVER() AS 'Overall_avg',
MIN(marks) OVER(),
MAX(marks) OVER(),
MIN(marks) OVER(partition by branch),
MAX(marks) OVER(partition by branch)
from campusx.marks
order by student_id;

-- qus

SELECT * FROM (select *,
               AVG(marks) OVER(partition by branch) as 'branch_avg'
               FROM marks) t
WHERE t.marks > t.branch_avg
order by student_id; 

-- RANK FUNCTION
select *,
RANK() OVER(ORDER BY marks DESC)
FROM marks;  

select *,
RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;  

-- DENSE RANK

select *,
RANK() OVER(PARTITION BY branch ORDER BY marks DESC),
DENSE_RANK() OVER(PARTITION BY branch ORDER BY marks DESC)
FROM marks;

-- ROW NUMBER

SELECT *,
ROW_NUMBER () OVER(partition by branch)
from marks;

SELECT *,
concat(branch,'-',ROW_NUMBER () OVER(partition by branch)) as'code_for_student'
from marks;


-- qus of top 2 highly paying cutomer per month

use zomato;
select * from (select monthname(date) as 'month', user_id, sum(amount) as 'total',
		     	RANK() OVER(partition by monthname(date) order by sum(amount) DESC) as 'month_rank'
				from orders
                GROUP BY monthname(date),user_id) t
where t.month_rank < 3
order by month desc, month_rank asc;


-- fist_value & last_value 

use campusx;
-- first_value
select *,
first_value(name) over(order by marks desc)
from marks;

-- last_value
select *,
last_value(name) over(order by marks desc)
from marks;

-- frames understand now try again last_value
-- all
select *,
last_value(marks) over(order by marks desc
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from marks;

-- branch wise 
select *,
last_value(marks) over(PARTITION BY branch
                       order by marks desc
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from marks;    

-- NTH values
select *,
NTH_VALUE(name,2) over(PARTITION BY branch
                       order by marks desc
                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from marks;   



-- find topper of all branch and print only name branch and marks
select name,branch,marks from (select *,
                               first_value(name) over (partition by branch order by marks desc) as 'topper_name',
							   first_value(marks) over (partition by branch order by marks desc) as 'topper_marks'
                               from marks) t
where t.name = t.topper_name AND t.marks = t.topper_marks;        


-- find lowest of all branch and print only name branch and marks
select name,branch,marks from (select *,
                               last_value(name) over (partition by branch order by marks desc
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'topper_name',
							   last_value(marks) over (partition by branch order by marks desc
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as 'topper_marks'
                               from marks) t
where t.name = t.topper_name AND t.marks = t.topper_marks;


-- hecting to write similar lines repeatedly so use this 
select name,branch,marks from (select *,
                               last_value(name) over w as 'topper_name',
							   last_value(marks) over w as 'topper_marks'
                               from marks
                               window w as (partition by branch order by marks desc
                               ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t
where t.name = t.topper_name
AND t.marks = t.topper_marks;


-- LEAD & LAG Func

SELECT *,
LAG(marks) over(order by student_id),
LEAD(marks) over(order by student_id)
from marks;

-- find mom revenue growth for zomato

use zomato;

select monthname(date), sum(amount),
(( sum(amount) - LAG(sum(amount)) OVER (ORDER BY MONTH(date)))/LAG(sum(amount)) OVER (ORDER BY MONTH(date)))*100
from orders
group by monthname(date),month(date)
order by month(date) ASC;