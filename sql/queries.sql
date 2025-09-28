-- parameterized query that gets all products in an order
PREPARE get_order_items(int) AS
SELECT 
	p.name AS product_name,
	c.category_name AS category,
    oi.quantity AS product_quantity,
    p.price AS single_product_price,
    (oi.quantity * p.price) AS product_total
FROM order_item oi
JOIN product p ON p.id = oi.product_id
JOIN category c ON c.id = p.category_id
WHERE oi.order_id = $1;

-- parameterized query that gets total price of order
PREPARE get_order_total_amount(int) AS
SELECT 
    SUM(oi.quantity * p.price) AS total_order_amount
FROM order_item oi
JOIN product p ON p.id = oi.product_id
WHERE oi.order_id = $1;

-- parameterized query that gets order items and total price of order in the same table
PREPARE get_order_invoice(int) AS
(
    SELECT 
        p.name AS product_name,
        c.category_name,
        oi.quantity AS product_quantity,
        p.price AS single_product_price,
        (oi.quantity * p.price) AS line_total
    FROM order_item oi
    JOIN product p ON p.id = oi.product_id
    JOIN category c ON c.id = p.category_id
    WHERE oi.order_id = $1
)
UNION ALL
(
    SELECT 
        'ORDER TOTAL' AS product_name,
        NULL AS category_name,
        NULL AS product_quantity,
        NULL AS single_product_price,
        SUM(oi.quantity * p.price) AS line_total
    FROM order_item oi
    JOIN product p ON p.id = oi.product_id
    WHERE oi.order_id = $1
);

-- parameterized query that gets number of orders and total amount from every (or selected) city
PREPARE order_report(text) AS
SELECT 
    c.details->>'city' AS customer_city,
    COUNT(DISTINCT o.id) AS number_of_orders,
    SUM(p.price * oi.quantity) AS total_amount
FROM customer c
JOIN "order" o ON o.customer_id = c.id 
JOIN order_item oi ON oi.order_id = o.id
JOIN product p ON p.id = oi.product_id
WHERE ($1 IS NULL OR c.details->>'city' = $1)
GROUP BY c.details->>'city'
ORDER BY number_of_orders DESC;

-- queries can be executed like this
EXECUTE get_order_items(10); -- or any order id can be used
EXECUTE get_order_total_amount(10); -- or any order id can be used
EXECUTE get_order_invoice(10); -- or any order id can be used
EXECUTE order_report(NULL); -- to filter by city, pass in city name