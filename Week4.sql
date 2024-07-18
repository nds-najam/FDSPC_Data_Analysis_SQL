-- Inner Join
SELECT customers.name, products.product_name, sales.quantity
FROM customers
INNER JOIN sales ON customers.id = sales.customer_id
INNER JOIN products ON sales.product_id = products.id;

-- Left Outer Join
SELECT customers.name, products.product_name, sales.quantity
FROM customers
LEFT JOIN sales ON customers.id = sales.customer_id
LEFT JOIN products ON sales.product_id = products.id;

-- Right Outer Join
SELECT customers.name, products.product_name, sales.quantity
FROM customers
RIGHT JOIN sales ON customers.id = sales.customer_id
RIGHT JOIN products ON sales.product_id = products.id;

-- Full Outer Join
SELECT customers.name, products.product_name, sales.quantity
FROM customers
FULL JOIN sales ON customers.id = sales.customer_id
FULL JOIN products ON sales.product_id = products.id;

-- Analyze the food preferences of customers
SELECT t2.food_type_new, SUM(t1.quantity) AS item_quantity
FROM orders_items t1
LEFT JOIN (
	SELECT item_id,
		CASE 
			WHEN food_type LIKE 'veg%' THEN 'veg'
			ELSE 'non-veg'
		END AS food_type_new
	FROM food_items
			) t2 ON t1.item_id = t2.item_id
GROUP BY t2.food_type_new;

-- Find the number of items ordered from each of the restaurants
SELECT r.restaurant_name, r.restaurant_id, r.cuisine, t1.item_quantity
from restaurants r
LEFT JOIN (
	select restaurant_id, SUM(quantity) as item_quantity
	FROM food_items fi
	LEFT JOIN orders_items oi ON fi.item_id = oi.item_id
	GROUP BY restaurant_id ) t1
ON r.restaurant_id = t1.restaurant_id
ORDER BY restaurant_id ;

-- Find the restaurants with zero orders
SELECT r.restaurant_name, r.restaurant_id, r.cuisine, t1.item_quantity
from restaurants r
LEFT JOIN (
	select restaurant_id, SUM(quantity) as item_quantity
	FROM food_items fi
	LEFT JOIN orders_items oi ON fi.item_id = oi.item_id
	GROUP BY restaurant_id ) t1
ON r.restaurant_id = t1.restaurant_id
WHERE item_quantity IS NULL
ORDER BY restaurant_id ;

-- Week 4 Graded Assignment
-- Q3 What is the highest number of orders placed by any customer?
SELECT customer_id,count(order_id) as NumOrders from orders GROUP BY customer_id ORDER BY NumOrders DESC;
-- Q4 Use ranking functions to find the top 3 food items (based on the quantity ordered) for restaurant id = 10 
select *, rank() over (order by t1.total_quantity) as item_rank from
(
SELECT restaurant_id,oi.item_id,item_name,sum(quantity) as total_quantity
from orders_items oi INNER JOIN food_items fi
ON oi.item_id = fi.item_id
where fi.restaurant_id = 10
group by oi.item_id
order by total_quantity desc) t1 ;

-- Q5  find the items that have not been ordered by any customer.
-- Q5 find the items that have not been ordered by any customer.
SELECT f.item_id, COUNT(f.item_id) as item_count
FROM orders_items o  RIGHT JOIN food_items f
ON o.item_id = f.item_id
GROUP BY f.item_id
having item_count = 0;
