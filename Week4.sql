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

