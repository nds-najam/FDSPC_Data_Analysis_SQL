/* Week3 */
/*
Understand Percentage Change in Weekend & Weekday Sales Over Months
1) Find total revenue for weekdays and weekends over the four months
2) Then compare values from the previous month for weekends and weekdays
3) Find the percentage change in revenue for the months. 
*/


-- step 1 revenue for weekdays and weekends over the four months
SELECT
case 
when dayofweek(order_date) between 2 and 6 then 'Weekday'
when dayofweek(order_date) in (1,7) then 'Weekend'
end as day_of_week,
month(order_date) as month,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, month
order by day_of_week
;

/* Window Functions
Agrregate functions: avg,sum,max,min,count etc.
Analytical functions: lag,lead,rank,denserank etc.
*/

-- step 2 compare the revenue with previous month for weekday and weekend
SELECT
*,
round(((total_revenue-previous_rev)/previous_rev)*100,2) as Percentage_Change
FROM
-- T2 --
(
select 
*,
LAG(total_revenue) OVER (PARTITION BY day_of_week) as previous_rev
from 
-- T1 --
(
SELECT
case 
when dayofweek(order_date) between 2 and 6 then 'Weekday'
when dayofweek(order_date) in (1,7) then 'Weekend'
end as day_of_week,
month(order_date) as month,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, month
order by day_of_week
) 
T1
)
T2
;

select * from
(
select
month, driver_id, avg_time,
rank() over (partition by month order by avg_time desc) as driver_rank
from
(
select 
month(order_date) as month, 
driver_id, 
avg(minute(timediff(delivered_time,order_time))) as avg_time
from orders
group by month,driver_id
) as query_1
) as query_2
where driver_rank between 1 and 5
;


select * from orders limit 100;

/* Exercise */
-- Finding percentage changes with meal segment
select *,
round(((Total_revenue-Previous_rev)/Previous_rev)*100,2) as Percentage_Change
from
(
select 
Month,Meal,Total_revenue,
lag(Total_revenue) over (PARTITION BY Meal order by Month) as Previous_rev
from
(
select 
month(order_date) as Month, 
case
when hour(order_time) >= 3 and hour(order_time) < 6 then 'Suhoor'
when hour(order_time) >= 6 and hour(order_time) < 10 then 'Breakfast'
when hour(order_time) >= 10 and hour(order_time) < 12 then 'Brunch'
when hour(order_time) >= 12 and hour(order_time) < 16 then 'Lunch'
when hour(order_time) >= 16 and hour(order_time) < 18 then 'Snacks'
when hour(order_time) >= 18 then 'Dinner'
when hour(order_time) >= 0 and hour(order_time) < 3 then 'Late Dinner'
end as Meal,
-- count(order_id) as num_orders,
round(sum(final_price),0) as Total_revenue
from orders
group by Meal,Month
) as query_1
order by Month,Meal
) as query_2
;

/*
Customer Preference of Meal
*/
select *
from
(
select Month,Meal,num_orders,
rank() over (partition by Month order by num_orders desc) as Meal_rank
from
(
select 
case
when hour(order_time) >= 3 and hour(order_time) < 6 then 'Suhoor'
when hour(order_time) >= 6 and hour(order_time) < 10 then 'Breakfast'
when hour(order_time) >= 10 and hour(order_time) < 12 then 'Brunch'
when hour(order_time) >= 12 and hour(order_time) < 16 then 'Lunch'
when hour(order_time) >= 16 and hour(order_time) < 18 then 'Snacks'
when hour(order_time) >= 18 then 'Dinner'
when hour(order_time) >= 0 and hour(order_time) < 3 then 'Late Dinner'
end as Meal,
month(order_date) as Month, 
count(order_id) as num_orders

from orders
group by Meal,Month
) as query_1
) as query_2
order by Meal_rank,Month,Meal
;

/* Fractal Solution*/
SELECT
order_month,
time_segment,
total_revenue,
((total_revenue-(lag(total_revenue) over(partition by order_month)))/(lag(total_revenue) over(partition by order_month)))*100 as "percent_change"
from
(
SELECT
MONTH(order_date) AS order_month,
CASE
WHEN HOUR(order_time) BETWEEN 6 AND 11 THEN '6AM-12PM'
WHEN HOUR(order_time) BETWEEN 12 AND 17 THEN '12PM-6PM'
WHEN HOUR(order_time) BETWEEN 18 AND 23 THEN '6PM-12AM'
ELSE '12AM-6AM'
END AS time_segment,
SUM(final_price) AS total_revenue
FROM orders
GROUP BY order_month, time_segment
ORDER BY order_month, total_revenue DESC)
t1;


select count(order_id) from
(
select order_id,order_time,delivered_time,
case
when minute(timediff(delivered_time,order_time)) < 30 then 'Fast'
when minute(timediff(delivered_time,order_time)) between 30 and 60 then 'Medium'
when minute(timediff(delivered_time,order_time)) > 60 then 'Slow'
end as time_taken
from orders
) as query_1
where time_taken='Fast'
;

select * from food_items limit 10;

select restaurant_id,count(item_name) as num_items 
from food_items
group by restaurant_id
order by count(item_name) desc
;

select * from 
(
SELECT
*,
rank() over (partition by avg_rating order by avg_rating desc) as driver_rank
from
(
select driver_id,round(avg(order_rating),2) as avg_rating
from orders
group by driver_id
) as q1
) as q2
order by driver_rank desc
;


select driver_id,round(avg(rating),2) as avg_rating
from drivers
group by driver_id
order by avg_rating desc;

select * from food_items 
where calories = (select max(calories) from food_items);

select * from customers limit 10;

select * from orders limit 10;

select count(*) from
(
select customer_id,count(customer_id) as num_count
from orders
group by customer_id
) q1
where num_count > 1
;
