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
