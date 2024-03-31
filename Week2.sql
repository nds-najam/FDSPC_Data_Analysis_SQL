-- Week2

select count(order_id) from orders
where order_date='2022-08-22' and final_price>40
;

select count(order_id) from orders
where 
(order_date between '2022-09-04' and '2022-09-10')
and
(dayofweek(order_date)=1 or dayofweek(order_date)=7)
;

select count(order_id) from orders
where driver_id=10
and month(order_date)=7
and total_price>50
;

select * from restaurants limit 5;

select cuisine,count(restaurant_id) from restaurants
group by cuisine
;

select order_date,count(order_id) as num_orders from orders
where month(order_date)=9 and dayofweek(order_date)=2
group by order_date
;

SELECT SUM(final_price) AS total_revenue
FROM orders
WHERE DATE(order_date) BETWEEN '2022-09-01' AND '2022-09-15';

select count(order_id) from orders
where date(order_date)='2022-07-01' 
and final_price<35
;
